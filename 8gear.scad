/* [Gear Params:] */
// Circular pitch of gears
circPitch=15; // [1:100]
// Central (Sun) Teeth
sunTeeth=18; // [3:3:300]
// Edge (Planet) Teeth
edgeTeeth=18; // [3:3:300]
// Sun Gear Thickness
gearThick=8; // [1:40]
/* [Arm Params:] */
// Central sweep angle; 1-360
sweepAngle=120; // [1:360]
// Arm Hub Diameter
armHubDiam=76; // [1:200]
// Arm Toe Diameter
armToeDiam=61; // [1:200]
// Hub to Toe Distance
HubToToe=107; // [1:200]
// Arm and Planet Gear Thickness
armThick=8; // [1:40]
// Segments per circle
$fn=20;

use <GFgear.scad>

centerToCenter = circPitch*(sunTeeth+edgeTeeth)/(2*PI);
// Use GFgear's outside_radius() function for sun's tip-diameter
sunDiameter = 2*outside_radius(sunTeeth, circPitch);

// Convert time to a back-and-forth rotation-angle, with dt % dwell
// times at min and max swings
function roDwell(dt) = (max(dt/400, min(1-dt/400, (1-abs($t*2 - 1))))-0.1)*sweepAngle/(1-dt/200);
// Convert time to angle, with 40% dwell
function roAngle() = roDwell(40);
// Anti-collision-cutout angle is sweepAngle * gear ratio
function antiAngle() = sweepAngle*sunTeeth/edgeTeeth;

module makeArm(mainAngle=0) {
  translate([centerToCenter*cos(mainAngle),centerToCenter*sin(mainAngle),-armThick/2]) {
    rotate(a = mainAngle+roAngle()*sunTeeth/edgeTeeth) {
      union(){
	rotate(a = (1-edgeTeeth%2) * 180/edgeTeeth) { // Make teeth mesh
	  linear_extrude(center=false, height=armThick) {
	    gear(circular_pitch = circPitch, num_teeth = edgeTeeth, teeth_skip=edgeTeeth/2-2);
	  }
	}
	linear_extrude(center=false, height=armThick) {
	  difference() {
	    hull() {
	      translate([HubToToe,0,0]) circle(d=armToeDiam);
	      circle(d=armHubDiam);
	    }
	    translate([centerToCenter*sin(antiAngle()-90),centerToCenter*cos(antiAngle()-90),0]) circle(d=sunDiameter);
	  }
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
      linear_extrude(center=true, height=gearThick) {
	gear(circular_pitch = circPitch, num_teeth = sunTeeth);
      }
    }
  }
  // Make 3 planet gears
  makeArm(0);
  makeArm(120);
  makeArm(240);
}