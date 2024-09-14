#!/usr/bin/python3

import argparse
import asyncio
import click
import dataclasses
import enum
import json
import math
import os
from os import path
import pathlib
import re
import shlex
import subprocess
import sys
import time
import traceback
from typing import Any, Callable, Coroutine, Dict, List, Optional
import yaml


# relative to nozzle size
FIRST_LAYER_HEIGHT = 0.6
VERBOSE = False
DEBUG = False

LABEL_SCAD = path.join(path.dirname(__file__), "labeled-swatch.scad")


async def build_stl(
        scad_file: str,
        output_file: str,
        **defines: str,
) -> Optional[BaseException]:
    openscad_args = ["openscad", scad_file, "-o", output_file]
    for key, value in defines.items():
        if isinstance(value, str):
            value = '"' + value.replace('"', '\"') + '"'
        elif isinstance(value, bool):
            value = 'true' if value else 'false'
        openscad_args.extend(("-D", f"{key}={value}"))
    if VERBOSE:
        print(f"executing: {' '.join(shlex.quote(x) for x in openscad_args)}")
    start_time = time.time()
    redir = dict() if DEBUG else dict(
        stdout=asyncio.subprocess.PIPE, 
        stderr=asyncio.subprocess.PIPE,
    )
    proc = await asyncio.create_subprocess_exec(
        *openscad_args,
        **redir)
    stdout, stderr = await proc.communicate()
    completed = time.time() - start_time
    if VERBOSE:
        print(f"output_file={output_file}, rc={proc.returncode}, elapsed={completed:.3f}s")
    if proc.returncode != 0:
        return OpenSCADError(returncode=proc.returncode, stdout=stdout, stderr=stderr, elapsed=completed,
                             cmdline=openscad_args)
    return None


@dataclasses.dataclass
class OpenSCADError(ChildProcessError):
    returncode: int
    stdout: str
    stderr: str
    elapsed: float
    cmdline: List[str]

    def __str__(self):
        how_long = f"{self.elapsed*1000:.0f}ms" if self.elapsed<1200 else f"{self.elapsed:.3f}s"
        stdout_split = self.stdout.split(b"\n")
        stderr_split = self.stderr.split(b"\n")
        return (f"OpenSCAD returned error code {self.returncode} in {how_long};\n"
                f"    arguments: {' '.join(shlex.quote(x) for x in self.cmdline[1:])}\n"
                f"    stderr: {'\n\t'.join(x.decode() for x in stderr_split)}\n"
                f"    stdout: {'\n\t'.join(x.decode() for x in stdout_split)}\n")


class PrintMode(enum.Enum):
    MONO = "Mono"
    MANUAL = "Manual"
    MMU = "MMU"

    @classmethod
    @property
    def modes(cls) -> List[str]:
        return list(str(x) for x in cls)


@dataclasses.dataclass
class SwatchMakeResult:
    input_filename: str
    body_stl: Optional[str] = None
    label_stl: Optional[str] = None
    details: Dict[str, str] = None
    error: Optional[BaseException] = None
    stack: Optional[traceback.StackSummary] = None


async def make_swatch(
        settings_filename: str,
        print_mode: PrintMode,
        output_dir: Optional[str] = "",
        show_cost: bool = True,
        show_nozzle_temp: bool = True,
        show_bed_temp: bool = True,
        show_chamber_temp: bool = False,
        show_fan_speed: bool = False,
        read_preset: bool = False,
        write_preset: bool = False,
        **defines: any,
) -> SwatchMakeResult:

    infile = LABEL_SCAD

    details = dict(defines)
    with open(settings_filename) as settings_json:
        info = json.load(settings_json)
        vendor = info["filament_vendor"][0]
        details["manufacturer"] = vendor
        material = info["filament_type"][0]
        details["material"] = material

        # some very Gotham-specific shrinking rules; TODO: use PIL, locate and open the font,
        # and determine based on metrics whether the specific letters fit in the space.
        if len(material) == 3:
            details["label_material_font_width"] = ""
        elif len(material) == 4:
            details["label_material_font_width"] = "Narrow"
        elif len(material) == 5:
            details["label_material_font_width"] = "XNarrow"
        else:
            details["label_material_font_width"] = "Cond"
            if len(material) > 7:
                details["label_material_font_height"] = 7.5 - (len(material) - 7)*0.5

        # some very Gotham-specific shrinking rules...
        if len(vendor) <= 7:
            details["label_manufacturer_font_width"] = ""
        elif len(vendor) <= 9:
            details["label_manufacturer_font_width"] = "Narrow"
        elif len(vendor) <= 11:
            details["label_manufacturer_font_width"] = "XNarrow"
        else:
            details["label_manufacturer_font_width"] = "Cond"
            if len(vendor) > 13:
                details["label_manufacturer_font_height"] = 7 - (len(vendor) - 13)*0.3
  
        filament_name = info["name"]
        pattern = f"{vendor} {material}\\s*([^@\\s][^@]*)@"
        m = re.match(pattern, filament_name)
        if m:
            details["color_name"] = m.group(1)
            color_name = m.group(1)
            
        else:
            color_name = ""
        rgb = canonical_rgb_hex(info["default_filament_colour"][0])

        # some very Noto Sans-specific shrinking values...
        if len(color_name) <= 11 and len(rgb) < 7:
            details["label_details_font_width"] = ""
        elif len(color_name) <= 13 and len(rgb) < 8:
            details["label_details_font_width"] = "SemiCondensed"
        elif len(color_name) <= 15:
            details["label_details_font_width"] = "Condensed"
        else:
            details["label_details_font_width"] = "ExtraCondensed"
            if len(vendor) > 16:
                details["label_details_font_height"] = 5.0 - (len(color_name) - 16)*0.25

        details["color_code"] = rgb
        details["cost_per_kg"] = math.ceil(float(info["filament_cost"][0]))

        details["nozzle_temp_range"] = [int(info["nozzle_temperature_range_low"][0]), int(info["nozzle_temperature_range_high"][0])]
        (bed_min, bed_max) = -1, -1
        for plate_type in "hot", "eng", "textured":
            for which in "temperature", "temperature_initial_layer":
                bed_temp_text = info.get(f"{plate_type}_plate_{which}")
                if bed_temp_text is None:
                    continue
                bed_temp = int(bed_temp_text)
                if bed_min < 0 or bed_min > bed_temp:
                    bed_min = bed_temp
                if bed_max < 0 or bed_max < bed_temp:
                    bed_max = bed_temp
        details["bed_temp_range"] = [bed_min, bed_max]

        # some more semi-automatic font auto-picking
        if bed_min > 0:
            details["label_settings_font_width"] = "ExtraCondensed"
        chamber_temp = int(info["chamber_temperatures"][0])
        if chamber_temp != 0:
            details["chamber_temp_range"] = [chamber_temp, chamber_temp]
            if bed_min > 0:
                details["label_details_font_height"] = 3.0
            else:
                details["label_settings_font_width"] = "ExtraCondensed"

    filename_tag = tagify(vendor, material, color_name or rgb)
    details = readwrite_preset(filename_tag, details, read=read_preset, write=write_preset)

    details["print_mode"] = print_mode.value
    result = SwatchMakeResult(
        input_filename=settings_filename,
        details=details,
    )
    if print_mode == PrintMode.MONO:
        result.body_stl = path.join(output_dir, f"swatch-mono-{filename_tag}.stl")
        result.error = await build_stl(infile, result.body_stl, **details)
    else:
        #if print_mode == PrintMode.MANUAL:
        result.body_stl = path.join(output_dir, f"swatch-{filename_tag}-body.stl")
        result.error = await build_stl(infile, result.body_stl, no_label=True, **details)
        result.label_stl = path.join(output_dir, f"swatch-{filename_tag}-label.stl")
        label_error = await build_stl(infile, result.label_stl, no_body=True, **details)
        if result.error is None:
            result.error = label_error
        elif label_error is not None:
            print(f"E: multiple errors processing {input_filename}; this error generating will not be shown in the summary:\n{label_error}\n")
    return result


PRESETS_TO_WRITE = {}


def readwrite_preset(preset_name: str, details: Dict[str, Any], read: bool, write: bool):
    """Uses the OpenSCAD preset system to allow per-filament customization of things"""
    if not (read or write):
        return details

    preset_filename = LABEL_SCAD.replace(".scad", ".json")

    if read and os.exists(preset_filename):
        with open(preset_filename) as preset_file:
            preset_json = json.load(preset_file).get("parameterSets", {}).get(preset_name, {})
            # if this field this script never sets is there, it means it was configured in
            # OpenSCAD, so use it
            if "edge_width" in preset_json:
                details = preset_json
                # don't ever re-write out one we just read, at this level anyway
                write = False

    if write:
        PRESETS_TO_WRITE[preset_name] = details

    return details


def commit_presets():
    preset_filename = LABEL_SCAD.replace(".scad", ".json")

    existing_presets = {}
    if os.exists(preset_filename):
        with open(preset_filename) as preset_file:
            existing_presets = json.load(preset_file)
    else:
        existing_presets = {
            "parameterSets": {},
            "fileFormatVersion": "1"
        }

    if write:
        PRESETS_TO_WRITE[preset_name] = details

    return details


non_token_letters = re.compile(r'\W', re.UNICODE)


def tagify(*values: str) -> str:
    return '-'.join(non_token_letters.sub('', value) for value in values)


async def catch_error(async_func: Callable[[str, ...], Coroutine], filename: str, *args: Any,
                      **kwargs: Any) -> SwatchMakeResult:
    try:
        return await async_func(filename, *args, **kwargs)
    except Exception as exc:
        stack_trace = traceback.TracebackException.from_exception(exc)
        return SwatchMakeResult(filename, error=exc, stack=stack_trace)


def get_print_mode(ctx, param, value):
    try:
        return getattr(PrintMode, value.upper())
    except AttributeError:
        raise click.BadParameter(f"Valid Print Modes: {' '.join(PrintMode.modes)}")


def canonical_rgb_hex(hex_code: str) -> str:
    """Shortens a hex code from 6 (or even 8) hex digits to half the size, if it is a
    "websafe color" and this does not lose any accuracy.
    """
    m = re.match(r'^#?([0-9a-fA-F]{3,8})$', hex_code)
    if not m:
        return hex_code
    hex_digits = m.group(1)
    if len(hex_digits) < 6:
        return f"#{hex_digits.upper()}"
    short_hex_digits = []
    for ix in range(len(hex_digits)//2):
        value = hex_digits[ix*2:(ix+1)*2].upper()
        if value[0] == value[1]:
            short_hex_digits.append(value[0])
        else:
            return f"#{hex_digits.upper()}"
    return f"#{''.join(short_hex_digits)}"


@click.command()
@click.option(
    "--print-mode",
    help=f"Whether you have an MMU, want to manually change filaments part way, or want monochrome (labeled) swatches: ({', '.join(PrintMode.modes)})",

    type=click.UNPROCESSED,
    default="MMU",
    metavar="MODE",
    callback=get_print_mode,
)
@click.option("--parallel", "-l", type=int, default=-1, help="how many OpenSCAD instances to run in parallel")
@click.option("--output_dir", "-O", type=click.Path(file_okay=False, path_type=pathlib.Path), default=None, help="directory to write generated swatch STL files to")
@click.option("--verbose", "-v", is_flag=True, default=False, help="show openscad arguments")
@click.option("--debug", "-d", is_flag=True, default=False, help="show openscad output")
@click.option("--write-presets", "-w", is_flag=True, default=False, help="write generated customizer inputs to labeled-swatch.json")
@click.option("--read-presets", "-r", is_flag=True, default=False, help="use customizer inputs from labeled-swatch.json")
@click.argument("setting_files", type=click.Path(exists=True), nargs=-1)
def make(setting_files: List[str], print_mode: PrintMode, parallel: int,
         verbose: bool, debug: bool, read_presets: bool, write_presets: bool,
         output_dir: Optional[str]) -> None:
    """Swatch maker."""

    if parallel <= 0:
        parallel = os.cpu_count()

    loopy = asyncio.new_event_loop()
    asyncio.set_event_loop(loopy)
    global VERBOSE, DEBUG
    VERBOSE, DEBUG = verbose, debug

    todo_tasks = []
    results = []
    make_swatch_args = dict()
    if read_presets:
        make_swatch_args.update(read_preset=True)
    if write_presets:
        make_swatch_args.update(write_preset=True)
    while todo_tasks or setting_files:
        if len(todo_tasks) < parallel and len(setting_files) > 0:
            new_task = asyncio.ensure_future(
                catch_error(make_swatch, setting_files[0], print_mode, **make_swatch_args),
            )
            todo_tasks.append(new_task)
            new_task.filename, setting_files = setting_files[0], setting_files[1:]
            timeout_task = asyncio.ensure_future(asyncio.sleep(0.1))
        done, pending = loopy.run_until_complete(
            asyncio.wait(todo_tasks + [timeout_task], return_when=asyncio.FIRST_COMPLETED)
        )
        if timeout_task in pending:
            timeout_task.cancel()
        tasks_finished = False
        for task in done:
            if task is timeout_task:
                continue
            tasks_finished = True
            exc = task.exception()
            if exc is not None:
                print(f"Error in {task.filename} did not get caught :-(")
                results.append(
                    SwatchMakeResult(
                        input_filename=task.filename,
                        error=exc,
                    )
                )
            else:
                results.append(task.result())
        if tasks_finished:
            todo_tasks = list(task for task in todo_tasks if task not in done)

    print("Generated swatch files:")
    row_fmt = "%40s %15s %6s %7s %-12s %7s %7s"
    print(row_fmt % ("filename", "vendor", "type", "rgb", "color", "price", "print settings"))
    error_row_fmt = "%40s  %s %s: %s"

    for result in results:
        input_basename = path.basename(result.input_filename)
        if len(input_basename) > 40:
            input_basename = input_basename[:39] + "…"
        if result.error is not None:
            error_name = type(result.error).__name__
            err_noun = "Exception" if error_name.endswith("Error") else "Error"
            print(error_row_fmt % (input_basename, error_name, err_noun, str(result.error)))
            if result.stack is not None:
                for line in result.stack.format():
                    print(line)
            continue
        print(row_fmt % (
            input_basename,
            result.details["manufacturer"], result.details["material"],
            result.details["color_code"], result.details["color_name"],
            f'${result.details["cost_per_kg"]}/kg',
            result.details["nozzle_temp_range"]
        ))

    if len(PRESETS_TO_WRITE) > 0:
        write_presets()


if __name__ == "__main__":
    make()
