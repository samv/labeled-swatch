
# Tradable, optionally labeled Filament Swatches

This repo contains an OpenSCAD parametric remix of [this filament
swatch](https://www.printables.com/model/952352-another-filament-sample), which has been
shrunk very slightly, so that they can fit sideways in a typical 2xN gridfinity bin.

I'll leave the full story of how and why I think this specific OpenSCAD model is useful and
not already covered by other models that are out there to the end of the README.

But long story short, I was organizing a filament swatch exchange, so that people at a 3D
printing conference can get together with several swatches of each of their favorite
filaments printed out, and leave with samples of a bunch of other peoples' favorites.  This
is the file that has resulted.

## Jump in!

Open the "labeled-swatch.scad" in OpenSCAD and see if you can use it with just the in–built
instructions.  The rest of the details here are just to put in writing what differentiates
this swatch.

## Sample images

To be added!

## Tradable Filament Swatch features

There are swatches out there, even OpenSCAD customizable ones which are quite sophisticated.
Why would you want this model?  Let me enumerate:

* backwards compatible with the Extrutim system in two ways; either;

  (a) use Extrutim cases: they will comfortably hold the swatches in this system, with only
      the minor downside that they will rattle around slightly.

  (b) tweak the model parameters to be the same size as Extrutim swatches.

* **Versatile** - swatches can be made to be labeled in the STL so that they come out of the
  printer pre–labeled, or printed as standard blanks with the most important details added
  on via a marker or a labeler.

* **Multicolor**: it is easy to make two STL files per swatch, and if loaded simultaneously
  and converted to a single obect will make it trivial to print the label in a different
  color to the body of the swatch, if you have an MMU.  Otherwise, you can select single
  color mode to use embossing only.  Finally, for people who don't have an MMU but are still
  enthusiastic about multicolor, there is an option to make the label a single layer thick
  and at the surface of the model, without having to manually paint the model yourself in
  your slicer.

* **Clean** - there are no samples of infill types, no bridging or overhang tests, no
  embedded fragments of filament, etc.  The only two features preserved were:
  
  - the handle, for adding the swatch to a keychain
  
  - the translucency patches, so you can see what the filament looks like if you print only
    a few layers of it

* Includes just the details you care about for a swatch from someone else's printer, and for
  a filament exchange, you would consider all but the first _two_ optional, and the rest a
  nice to have.

  - Most prominently, **material type abbreviation**, because the material type is one of
    the most important decisions you make when choosing a filament.  Embossed, though this
    can be switched to write–in/label–on if desired.

  - The **manufacturer name** of the filament is the first line, for hopefully obvious
    reasons; you need to be able to order it.  "Generic" helps nobody.

  - The **color name**, and while this often may seem superfluous; it is good for in–between
    colors and the color blind; and after all, if you want to get that filament, it can
    always help when searching for a deal to know the exact name used by the manufacturer,
    in case they got creative.

    - The **color code** is also useful for entering the filament in to slicers and making
      it show visually the correct color.  But to be honest, it's one of the least important
      details on the card, as nothing tells you the color space or how the specific code was
      determined.  I recommend sticking to 3–hex digit codes, websafe colors, for codes
      which were not supplied by the manufacturer or obtained via a standardized scanner
      such as from filamentcolors.xyz.

  - The **price per kg** is a good factoid to know about the filament.  This lets you make
    an informed decision on its value for money for projects.

    Manufacturers can obviously change their prices at any time, so this can never be a
    precise value and only enterable using the parameterizer to the nearest dollar, and is
    really just supposed to give somebody a ballpark, to know whether they should regard
    this filament as "thrifty", "average" or "spendy".  We can't use those kind of
    qualitative terms directly, because different people operate on different prevailing
    budgets.  The idea here is to put a value which indicates what kind of price you pay for
    this, without a giant bulk purchase.  Maybe that's a price from Amazon, maybe it's a
    manufacturer price with a discount for a handful of rolls applied.  And let the person
    who ends up with the swatch be the judge.

  - Finally, it is also possible to put the filament print settings on the swatch, although
    it does end up looking a little busy if you do so.
	
* **Easy font variation** - the swatches are not the smallest, but they are still quite
  small when you try to fit certain details on it, like a longer manufacturer's names or a
  creative product color name.  Additionally, the abbreviation for the material needs to be
  big and take up the whole width sideways, but also have the capability of adding a filler
  indicator to it.  To assist with this, the defaults use fonts which are widely available
  in a variety of font ratios/widths, weights and other variations, and the form makes it
  easy to try switching between them to see what fits for the values you are having
  
* **Automatic production of swatches from slicer filament profiles** - the intention was
  always to make a script which takes a filament settings JSON files, and runs the
  command–line OpenSCAD to create STL or even 3MF files which can then be trivially printed.
  This might seem like "burying the lede" to put this at the end, but the script isn't
  written yet so right now this is just an idea.  It also remains to be seen whether the job
  of laying out the writing to fit on the swatch can be automated.  Hopefully it can,
  especially if sticking to Gotham and Helvetica Neue.  

## Motivation and backstory

To be completed...

## License and author

Copyright 2024, Sam Vilain.  All Rights Reserved.
This file may be used under the terms of the GNU General Public License, either
verison 3 or, at your discretion, any later version.  If this is inconvenient
to me, please hit me up on Voron discord as @DaddyBuiltIt and we can discuss.
