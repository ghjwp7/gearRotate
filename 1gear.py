#!/usr/bin/env python3

# 1gear.py makes a .scad file for animation of a gear rotating through
# a given angle.  Note, the file GFgear.scad is a copy of gear.scad
# from https://www.thingiverse.com/thing:1919326 by Greg Frost.
# Locate GFgear.scad in the same directory as this program.

# When this program runs, it writes a file, tooth.scad.  Open
# tooth.scad in program openscad.  Click View / Animate.  Below the 3D
# viewport, boxes for FPS and Steps should appear; fill in numbers
# like 10 and 60.  In the Customizer panel, click the triangle next to
# `Params:`.  Sliders and spinboxes for toothCount and tAngle will
# appear, and can be used to set the number of gear teeth and the
# total sweep angle.

from solid import linear_extrude, cube, cylinder, polygon, scad_render_to_file
from solid.utils import color, down, left, Green
from math import sqrt, pi, sin, cos, atan2

#---------------------------------------------
if __name__ == '__main__':
    from solid import include, use, scad_render, rotate, square
    from sys import argv
    from re import sub
    arn = 0
    arn+=1; nT  = int(argv[arn]) if len(argv)>arn else 20
    arn+=1; gM  = float(argv[arn]) if len(argv)>arn else 3.0
    arn+=1; hD  = float(argv[arn]) if len(argv)>arn else 3.175
    arn+=1; gThik  = float(argv[arn]) if len(argv)>arn else 6
    print ('Including a GF gear sequence')
    use('GFgear.scad')
    tRateHold, toothHold, stickHold = 98765, 76543, 54321
    circPitch = 10.0
    gearAsm = gear(toothHold,circPitch) + square([stickHold,1])
    hs = linear_extrude(gThik, True)(rotate(tRateHold)(gearAsm))
    # Substitute variable names & formulae in place of various holders
    hs = sub(str(toothHold), 'toothCount', scad_render(hs))
    hs = sub(str(tRateHold), '$t*tRate*tAngle', hs)
    hs = sub(str(stickHold), 'toothCount*{:0.4f}'.format(circPitch/pi), hs)
    hs = '/* [Params:] */\n// Number of Teeth\ntoothCount=11; // [3:300]\n// Sweep rate multiplier; 1,2,3...\ntRate=2; // [1:100]\n// Total sweep angle; 1-360\ntAngle=90; // [1:360]\n$fn=20;\n{}'.format(hs)
    fo = open('tooth.scad','w+')
    fo.write(hs)
    fo.close()
    