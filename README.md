This directory contains two programs:

1gear.py writes a .scad file, tooth.scad, which animates a gear
rotation back and forth in a given angle range.  See comments in 1gear
for details of program usage.  A few extracts appear below.

8gear.scad animates the meshed rotation of some sun-and-planet gears
back and forth in an angle range.  Planets have arms of specified size
and shape.  Red ring denotes a 5" diameter.


Brief Extracts from 1gear.py comments:

  When this program runs, it writes a file, tooth.scad.  Open
  tooth.scad in program openscad.  Click View / Animate.  Below the 3D
  viewport, boxes for FPS and Steps should appear; fill in numbers
  like 30 and 100.  In the Customizer panel, click the triangle next
  to `Params:`.  Sliders and spinboxes for toothCount and tAngle will
  drop down, that can be used to set the number of gear teeth and the
  total sweep angle of the indicator arm on the gear.

  The Customizer panel is available in OpenSCAD development snapshots
  (like openscad-nightly) since January 2017. [...]

  This program accepts two optional command-line parameters: (1) Gear
  thickness, mm, and (2) `Circular pitch` of gear [...]

