/* [Params:] */
$fn=20;
// Circular pitch of gears
circPitch=15; // [1:100]
// Central (Sun) Teeth
sunTeeth=18; // [3:3:300]
// Central sweep angle; 1-360
sweepAngle=120; // [1:360]
// Edge (Planet) Teeth
edgeTeeth=18; // [3:3:300]
// Arm Hub Diameter
armHubDiam=76; // [1:200]
// Arm Toe Diameter
armToeDiam=61; // [1:200]
// Hub to Toe Distance
HubToToe=107; // [1:200]

use <GFgear.scad>

centerToCenter = circPitch*(sunTeeth+edgeTeeth)/(2*PI);
// Use GFgear's outside_radius() function for sun's tip-diameter
sunDiameter = 2*outside_radius(sunTeeth, circPitch);

// Convert time to a back-and-forth rotation-angle, with dt % dwell
// times at min and max swings, and specified oversweep amount os
function roDwell(dt, os) = (max(dt/400, min(1-dt/400, (1-abs($t*2 - 1))))-0.1)*(sweepAngle+os)/(1-dt/200) - os;
// Compute sun rotation angle for planet half-tooth rotation
function overAngle() = 180*edgeTeeth/(sunTeeth*sunTeeth);
// Convert time to angle, with 40% dwell and half-tooth oversweep
function roAngle() = roDwell(40, overAngle());
// Total sun swing is sweepAngle + oversweep
function totalAngle() = sweepAngle + overAngle();


module makeArm(mainAngle=0) {
  translate([centerToCenter*cos(mainAngle),centerToCenter*sin(mainAngle),0]) {
    initialAngle = mainAngle + (1-edgeTeeth%2) * 180/edgeTeeth;
    rotate(a = initialAngle+roAngle()*sunTeeth/edgeTeeth) {
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
	  translate([centerToCenter*sin(totalAngle()-90),centerToCenter*cos(totalAngle()-90),0]) circle(d=sunDiameter);
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
	gear(circular_pitch = circPitch, num_teeth = sunTeeth);
      }
    }
  }
  // Make 3 planet gears
  makeArm(0);
  makeArm(120);
  makeArm(240);
}