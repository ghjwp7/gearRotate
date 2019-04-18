/* [Params:] */
$fn=20;
// Circular pitch of gears
circPitch=15; // [1:100]
// Central Teeth
centralTeeth=18; // [3:3:300]
// Central sweep angle; 1-360
tAngle=120; // [1:360]
// Edge Teeth
edgeTeeth=18; // [3:3:300]
// Arm Hub Diameter
armHubDiam=76; // [1:200]
// Arm Toe Diameter
armToeDiam=61; // [1:200]
// Hub to Toe Distance
HubToToe=107; // [1:200]

use <GFgear.scad>

centerToCenter = circPitch*(centralTeeth+edgeTeeth)/(2*PI);
centerPitchDiam = circPitch*centralTeeth/PI;
modul = centerPitchDiam/centralTeeth;
centerTipDiam = centerPitchDiam + 2*modul;

function roAngle() = (max(0.1, min(0.9, (1-abs($t*2 - 1))))-0.1)*tAngle/0.8 - 180/min(centralTeeth,edgeTeeth);

module makeArm(mainAngle=0) {
  translate([centerToCenter*cos(mainAngle),centerToCenter*sin(mainAngle),0]) {
    initialAngle = mainAngle + (1-edgeTeeth%2) * 180/edgeTeeth;
    rotate(a = initialAngle+roAngle()*centralTeeth/edgeTeeth) {
      union(){
	linear_extrude(center = true, height = 6) {
	  gear(circular_pitch = circPitch, num_teeth = edgeTeeth, teeth_skip=edgeTeeth/2-2);
	}
	difference() {
	  hull() {
	    translate([HubToToe,0,0]) circle(d=armToeDiam);
	    circle(d=armHubDiam);
	  }
	  // At present, works ok when sun & planet tooth counts
	  // match and are even; else goes too far or not far enough
	  translate([centerToCenter*sin(tAngle-90),centerToCenter*cos(tAngle-90),0]) circle(d=centerTipDiam);
	}
      }
    }
  }
}  

union() {
  color("Red") {
    difference() {
      circle(131); circle(127);
    }
  }  
  color("Blue",0.5) {
    rotate(a = -roAngle()) {
      linear_extrude(center = true, height = 7) {
	gear(circular_pitch = circPitch, num_teeth = centralTeeth);
      }
    }
  }
  // Make 3 planet gears
  makeArm(0);
  makeArm(120);
  makeArm(240);
}