
// Swatch to fit 8 in a 2x1x6 GridFinity bin, based in shape
// around the Extrutim printables design, which is based around
// someone else's anyway.  Defaults here will give you a swatch with two spaces
// to write–in the manufacturer and color name (if useful).  All you need to do
// is customize the material.

// Copyright 2024, Sam Vilain.  All rights reserved.
// You can use this under the terms of the GPL version 3 or later.  For other
// terms, please get in touch.

/* [Swatch Print Settings] */
initial_layer_height = 0.24;
layer_height = 0.2;

// Color printing mode
color_mode = "MMU";  // [MMU:Multiple filament changes, Manual:Single filament change, Mono:Single color swatches]
// check to produce just the body STL.  It will have no label unless "single filament change" is selected.
no_label = false;
// check to produce just the label STL.   If both options are left unchecked, a single monocolor swatch STL will be produced.
no_body = false;


/* [Filament Details] */
// Use underscores to print a line for write–in (or label–on)
manufacturer = "";
//manufacturer = "________________";
// the main material for printing purposes
material = "PLA";  // [PLA, PETG, ABS, ASA, TPU, PC, PCABS, PCTG, PP, PET, PA, PPA, PAHT, ____]
// to add –CF, –GF, etc (or a "+" for unspecified copolymers)
filler = ""; // ["":None, +:Copolymer, CF: Carbon Fiber, GF: Glass Fiber, WF: Wood, X: Other]
// the color may be obvious, but if the vendor has a lot of colors for a material, this can help make sure the swatchholder gets the right one when ordering
color_name = "";

/* [Verbose filament details] */
// These extra details are available for scripts converting information from filament profiles to swatches or can be set manually..  Most importantly, to help give quick cost vs color decisions:
cost_per_kg = -1;

// HTML color code; 3-digit websafe color codes or full 6-digit value.  Printed on the swatch, and used to color the preview in OpenSCAD.
color_code = "";
// Color for the label; if printing single color swatches, using a color with good contrast will make the label easier to read here in OpenSCAD, but otherwise have no effect.  Clear this entry to show the label in the same color as the swatch.
contrast_color = "#000";

// set to add print setings to the swatch
nozzle_temp_range = [-1, -1];
bed_temp_range = [-1, -1];
chamber_temp_range = [-1, -1];
part_fan_speed = [-1, -1];
// If you just want to type what goes in the print settings space, enter it here
print_settings_override = "";

/* [Font for Manufacturer] */
// The font to use for the Manufacturer
label_manufacturer_font = "Gotham";
// If the manufacturer name doesn't fit, try tweaking this, and treat font height as a last resort.  Various fonts have different names for these widths, nothing is standard, X11 font names were the Betamax of this
label_manufacturer_font_width = "";  // ["":Default, Narrow, XNarrow:Extra Narrow, Cond:"Cond(ensed)", Condensed]
// Use the boldest font weight which fits and is still legible for best printability
label_manufacturer_font_weight = "Bold";  // ["":Default, Thin, Light, Book, Medium, Bold, Heavy, Ultra]
label_manufacturer_font_style = "";  // ["":Regular, Italic]
label_manufacturer_font_height = 7; // [5:0.25:8]

/* [Font for Material Code] */
// The font to use for the Material: recommend to use the same as the major font.
label_material_font = "Gotham"; 
// Shrink this before lowering the font height for longer filament types
label_material_font_width = "Narrow";  // ["":Default, Narrow, XNarrow:Extra Narrow, Cond:"Cond(ensed)", Condensed]
label_material_font_weight = "Bold";  // ["":Default, Thin, Light, Book, Medium, Bold, Heavy, Ultra]
label_material_font_style = "";  // ["":Regular, Italic,]
label_material_font_height = 8; // [6:0.5:10]

/* [Font for other details] */
// The font to use for everything else
label_details_font = "Noto Sans";
label_details_font_width = "";  // ["":Default, SemiCondensed, Condensed, ExtraCondensed]
label_details_font_weight = "";  // [Thin, ExtraLight, Light, Medium, "":Default, SemiBold, Bold, ExtraBold, Black]
label_details_font_style = "";  // ["":Regular, Italic]
label_details_font_height = 5; // [4:0.25:7]

// Just the color name in italics looks good and squeezes a bit more in, it seems
label_color_name_font_style = "Italic"; // ["":Regular, Italic]

/* [Font for print settings] */
// if temperatures are specified, they are printed with this width and height; font and weight come from the "details" setting.
label_settings_font_width = ""; //  ["":Default, SemiCondensed, Condensed, ExtraCondensed, Narrow, XNarrow:Extra Narrow, Cond:"Cond(ensed)", Condensed]
label_settings_font_height = 4; // [3:0.25:6]
// Pick a symbol for each setting prefix, but sadly OpenSCAD doesn't do a good job of finding the appropriate font that contains the glyphs for the unicode characters.
label_settings_nozzle_temp_glyph = "T:";  // ["T:", Ⓣ, 🅃, 🆃, "N:", Ⓝ, 🄽, 🅽, ↓, 🌡, ⚺, ⛉, ⛊]
label_settings_bed_temp_glyph = "B:";  // ["B:", Ⓑ , 🄱, 🅱, ■, ⬜, ⬚, □, 🞐, 🞑, 🞒, 🞓, 🛏]
label_settings_chamber_temp_glyph = "C:";  // ["C:", Ⓒ, 🄲, 🅲, ⛶, ▣, 🌤, ♨, 🌡]
label_settings_fan_speed_glyph = "F:";  // ["F:", Ⓒ, 🄲, 🅲, ⛶, ▣, 🌤, ♨, 🌡]

/* [Swatch Dimensions] */
// Maximum swatch thickness
swatch_thickness = 3;  // [1.5:0.1:4.5]
body_thickness = 2.4; // [1:0.1:3]
// label thickness is the difference between the above two, up to this value
label_max_thickness = 0.6; // [0.2:0.05:1]

// Overall dimensions
swatch_length = 75;  // [50:0.5:83]
swatch_width = 32;   // [20:0.5:37]

handle_size = 9;  // [6:0.5:10]

/* [Extra Dimension Settings] */
// space between lines, in mm
label_line_spacing = 1; // [0.5:0.1:2]

// width of the translucency staircase, in mm
staircase_size = 5; // [3:0.5:12]

// how wide the edge is
edge_width = 3; // [0:0.1:5]
corner_chamfer = 3; // [0:0.1:4]

// convert a thickness to a layer count or number
function layer_n(thickness) = (
  thickness > initial_layer_height?
      (floor((thickness - initial_layer_height)/layer_height)+1)
  :   (thickness <= 0 ? 0 : 1)
);

// calculate various dimensional settings
swatch_layers = layer_n(swatch_thickness);
body_layers =  layer_n(body_thickness);

label_max_layers = floor(label_max_thickness / layer_height);
label_layers =  color_mode == "Manual" ? (swatch_layers - body_layers) : min(swatch_layers - body_layers, label_max_layers);
echo(str("Layers: Swatch: ", swatch_layers, ", body: ", body_layers, " label: ", label_layers));

function layers_thick(n) = layer_height * n;
function layer_top(n) = initial_layer_height + (layer_height * (n-1));

label_thickness = swatch_thickness - body_thickness;

verbose_height = (cost_per_kg > 0 ? label_details_font_height + label_line_spacing : 0) + (
    color_code != "" ? label_details_font_height + label_line_spacing : 0);


body_length = swatch_length - edge_width - handle_size - edge_width * sin(360/16);
body_width = swatch_width - edge_width * 2;

label_margin = corner_chamfer + corner_chamfer*sin(360/16);
label_origin = [label_margin, swatch_width - label_margin, layer_top(body_layers)];
label_inner_margin = label_margin - edge_width;
echo(str("body width: ", body_width, ", label_margin: ", label_margin, ", edge_width: ", edge_width));
label_inner_width = body_width - label_inner_margin*2;
label_inner_length = body_length - label_inner_margin*2;

echo(str("height of verbose text: ", verbose_height, "mm"));

staircase_max_length = label_inner_length - label_material_font_height - label_line_spacing*2 - verbose_height;
staircase_steps = min(body_layers, floor(staircase_max_length / staircase_size));
echo(str("staircase max length: ", staircase_max_length, "mm, steps: ", staircase_steps));

function spaced(maybe_word, new_word) = str(maybe_word, ((maybe_word == "" || maybe_word[len(maybe_word)-1] == " ") && new_word != "") ? "" : " ", new_word);

function font_id(font_name, font_width="", font_weight="", font_style="") = str(font_name, (font_width != "" || font_weight != "" || font_style != "") ? str(":style=", spaced(font_width, spaced(font_weight, font_style))) : "");

label_material_code = str(material, (filler == "" ? "" : str(filler == "+" ? "" : "-", filler)));
label_material_font_id = font_id(label_material_font, font_width=label_material_font_width, font_weight=label_material_font_weight, font_style=label_material_font_style);
label_manufacturer_font_id = font_id(label_manufacturer_font, font_width=label_manufacturer_font_width, font_weight=label_manufacturer_font_weight, font_style=label_manufacturer_font_style);
label_color_name_font_id = font_id(label_details_font, font_width=label_details_font_width, font_weight=label_details_font_weight, font_style=label_color_name_font_style);
label_details_font_id = font_id(label_details_font, font_width=label_details_font_width, font_weight=label_details_font_weight, font_style=label_details_font_style);
label_settings_font_id = font_id(label_details_font, font_width=label_settings_font_width, font_weight=label_details_font_weight, font_style=label_details_font_style);

// some kind of input guarding for people poking stuff in via CLI arguments
function value_not_N(value) = (value == undef || value < 0);
function range_is_nil(value_range) = value_range == undef || len(value_range) == 0 || value_not_N(value_range[0]);

function show_value_range(value_label, value_range) = (
    range_is_nil(value_range) ? "" : str(
        value_label,
        (value_not_N(value_range[1]) || value_range[0] == value_range[1])
            ? value_range[0]
            : str(value_range[0], "-", value_range[1])
    ));
    
function show_value_approx(value_label, value_range) = (
    range_is_nil(value_range) ? "" : str(
        value_label,
        (value_not_N(value_range[1]) || value_range[0] == value_range[1])
            ? value_range[0]
            : str((value_range[0]+value_range[1])/2, "±", (value_range[1] - value_range[0])/2)
    ));

function show_range(value_label, value_range) = range_is_nil(value_range) ? "" : (len(show_value_range(value_label, value_range)) < len(show_value_approx(value_label, value_range)) ? show_value_range(value_label, value_range) : show_value_approx(value_label, value_range));

nozzle_temp_range_text = show_range(label_settings_nozzle_temp_glyph, nozzle_temp_range);
bed_temp_range_text = show_range(label_settings_bed_temp_glyph, bed_temp_range);
chamber_temp_range_text = show_range(label_settings_chamber_temp_glyph, chamber_temp_range);
fan_speed_range_text = show_range(label_settings_fan_speed_glyph, part_fan_speed);

print_settings_text = print_settings_override != "" ? print_settings_override : str(
    nozzle_temp_range_text,
    (nozzle_temp_range_text != "" && bed_temp_range_text != "") ? " " : "",
    bed_temp_range_text,
    (chamber_temp_range_text != "" && (nozzle_temp_range_text != "" || bed_temp_range_text != "")) ? " " : "",
    chamber_temp_range_text,
    (fan_speed_range_text != "" && (nozzle_temp_range_text != "" || bed_temp_range_text != "" || chamber_temp_range_text != "")) ? " " : ""
);

function staircase_layer(step_num) = layer_n(initial_layer_height + (body_thickness - layer_top(1)) / (staircase_steps - 1) * (step_num-1));

function color_or_default(color_entry) = color_entry == "" ? "yellow" : color_entry;

module swatch_outline(border_height = swatch_thickness, border_width = swatch_thickness) {
        difference() {
    polygon([
        [0, corner_chamfer],
        [corner_chamfer, 0],
        [swatch_length - handle_size, 0],
        [swatch_length, handle_size],
        [swatch_length, swatch_width - handle_size],
        [swatch_length - handle_size, swatch_width],
        [corner_chamfer, swatch_width],
        [0, swatch_width - corner_chamfer],        
    ]);
    corner_chamfer_16th = corner_chamfer*sin(360/16);
    polygon([
        [border_width, corner_chamfer + corner_chamfer_16th],
        [corner_chamfer + corner_chamfer_16th, border_width],
        [swatch_length - handle_size - corner_chamfer_16th, border_width],
        [swatch_length - border_width, handle_size + corner_chamfer_16th],
        [swatch_length - border_width, swatch_width - (handle_size + corner_chamfer_16th)],
        [swatch_length - handle_size - corner_chamfer_16th, swatch_width - border_width],
        [corner_chamfer + corner_chamfer_16th, swatch_width - border_width],
                [border_width, swatch_width - (corner_chamfer + corner_chamfer_16th)],

    ]);
    }
}

module swatch_basic() {

    if (!no_body) {
        color(color_or_default(color_code))
        difference() {
            union() {
                border_width = swatch_thickness;
                linear_extrude(layer_top(swatch_layers))
                    swatch_outline(border_width);
                translate([border_width, border_width, 0])
                    cube([body_length, body_width, body_thickness]);
            }

            for(step = [0:staircase_steps-1]) {
                step_layer = staircase_layer(step);
                stair_size = [staircase_size, staircase_size,
                    layer_top(body_layers+1) - layer_top(step_layer)];
                stair_offset = [(step) * staircase_size, 0, body_thickness-(layer_top(body_layers+1) - layer_top(step_layer))];
                position = [label_margin, label_margin, layer_top(1)] + stair_offset;
            
                echo (str("Step ", step+1, ": layer is ", step_layer, " (top at ", layer_top(step_layer), "), offset ", stair_offset));
                echo (str("Step ", step+1, ": drawing a cube at ", position, " size ", stair_size));                                                            
                translate(position)
                    cube(stair_size + [0.001, 0, 0]);    
            }
        }
    }
    translate(label_origin)
        children();
}

module label_text_flat() {
    translate([0, -label_manufacturer_font_height, 0]) {
        if (manufacturer != "") {
            text(manufacturer, size=label_manufacturer_font_height, font=label_manufacturer_font_id);
        } else {
            square([staircase_max_length - label_line_spacing, label_line_spacing/2]);
        }
        translate([0, -label_details_font_height-label_line_spacing, 0]) {
            if (color_name != "") {
                text(color_name, size=label_details_font_height, font=label_color_name_font_id);
            } else {
                square([staircase_max_length - label_line_spacing, label_line_spacing/2]);
            }
            if (print_settings_text) {
                translate([0, -label_settings_font_height-label_line_spacing, 0]) {
                    text(print_settings_text, size=label_settings_font_height, font=label_settings_font_id);
                }
            }
        }
    }
    echo(str("Drawing material label: ", label_material_code, "; font=", label_material_font_id, " - label inner length: ", label_inner_length));

    translate([label_inner_length - label_line_spacing, -label_inner_width/2, 0]) {
        rotate([0,0,90])
            text(label_material_code, size=label_material_font_height, font=label_material_font_id, halign="center");
        translate([-label_material_font_height-label_line_spacing, 0, 0]) {
        rotate([0,0,90])
            if (color_code != "") {
            text(color_code, size=label_details_font_height, font=label_details_font_id, halign="center");
            }
            if (cost_per_kg > 0) {
                translate([color_code != ""?-label_details_font_height-label_line_spacing:0, 0, 0]) {
                    rotate([0,0,90])
                        text(str("$", cost_per_kg, "/kg"), size=label_details_font_height, font=label_details_font_id, halign="center");
                }
            }
        }
    }
/*
    translate([0, -label_inner_width, 0])
    square([label_inner_length, 1]);
   */ 
}

swatch_basic() {
    if (color_mode == "Manual" && label_layers > 1 && !no_body) {
        color(color_or_default(color_code))
            linear_extrude(layers_thick(label_layers - 1))
                label_text_flat();
    }
    if (!no_label) {
        color(color_or_default(contrast_color != "" ? contrast_color : color_code)) {
            translate([0,0,color_mode == "Manual" ? layers_thick(label_layers - 1) : 0])
                linear_extrude(layers_thick(color_mode == "Manual" ? 1 : label_layers)) {
                    label_text_flat();
                }
        }
    }
}