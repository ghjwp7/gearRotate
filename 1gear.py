#!/usr/bin/env python3

# 1gear.py makes a .scad file for animation of a gear (plus an
# indicatoe) rotating through a given angle.  Note, the file
# GFgear.scad is a copy of gear.scad by Greg Frost as seen at
# https://www.thingiverse.com/thing:1919326 .  Place GFgear.scad in
# the same directory as this program.

# When this program runs, it writes a file, tooth.scad.  Open
# tooth.scad in program openscad.  Click View / Animate.  Below the 3D
# viewport, boxes for FPS and Steps should appear; fill in numbers
# like 30 and 100.  In the Customizer panel, click the triangle next
# to `Params:`.  Sliders and spinboxes for toothCount and tAngle will
# drop down, that can be used to set the number of gear teeth and the
# total sweep angle.

# During animation, `Time` will repeatedly advance from 0 to 1 in
# `Steps` steps.  There will be `FPS` steps per real second.  At each
# step, the gear rotation angle will advance by tAngle/Steps degrees.
# After every Steps steps, Time starts over at 0.

# The Customizer panel is available in OpenSCAD development snapshots
# (like openscad-nightly) since January 2017.  If not visible see
# https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/WIP#Customizer
# about using [Edit] [Preferences] [Features] [Customizer] to make
# Customizer available, and about using [View] [Hide customizer] to
# make Customizer visible or not.

# This program accepts two optional command-line parameters: (1) Gear
# thickness, mm, and (2) `Circular pitch` of gear, equal to (pitch
# diameter)*pi/(tooth count), mm.  (Ie, the tooth-to-tooth spacing at
# the pitch diameter, measured at radial centerlines of teeth).  When
# not specified, these default to 6 mm and 10 mm respectively.

from solid import linear_extrude, scad_render_to_file
from solid.utils import color, down, left, Green
from math import sqrt, pi, sin, cos, atan2

#---------------------------------------------
if __name__ == '__main__':
    from solid import include, use, scad_render, rotate, square
    from sys import argv
    from re import sub
    arn = 0
    arn+=1; gThik      = float(argv[arn]) if len(argv)>arn else 6
    arn+=1; circPitch  = float(argv[arn]) if len(argv)>arn else 10
    use('GFgear.scad')
    tRateHold, toothHold, stickHold = 98765, 76543, 54321
    gearAsm = gear(toothHold,circPitch) + square([stickHold,1])
    hs = linear_extrude(gThik, True)(rotate(tRateHold)(gearAsm))
    # Substitute variable names & formulae in place of various holders
    # Note, scad_render returns a string with a `use <...>` statement
    # and CSG .scad code for gear and square outline and its extrusion.
    hs = sub(str(toothHold), 'toothCount', scad_render(hs))
    hs = sub(str(tRateHold), '$t*tAngle', hs)
    hs = sub(str(stickHold), 'toothCount*{:0.4f}'.format(circPitch/4), hs)
    hs = '/* [Params:] */\n// Number of Teeth\ntoothCount=11; // [3:300]\n// Total sweep angle; 1-360\ntAngle=90; // [1:360]\n$fn=20;\n{}'.format(hs)
    fo = open('tooth.scad','w+')
    fo.write(hs)
    fo.close()
    