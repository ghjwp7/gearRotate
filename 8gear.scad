/* [Params:] */
$fn=20;
// Circular pitch of gears
circPitch=10; // [1:100]
// Central Teeth
centralTeeth=13; // [3:300]
// Central sweep angle; 1-360
tAngle=90; // [1:360]
// Edge Teeth
edgeTeeth=11; // [3:300]
// Arm Hub Diameter
armHubDiam=15; // [1:100]
// Arm Toe Diameter
armToeDiam=11; // [1:100]
// Hub to Toe Distance
HubToToe=33; // [1:200]
// Manual setting for center to center Distance
ccManualDist=38.2; // [1:200]

use </home/j-waldby/pcb/3D/gearLegs/test-legs/GFgear.scad>

centerToCenter=circPitch*(centralTeeth+edgeTeeth)/(2*pi);

union() {
  color("Blue",0.5) {
    rotate(a = (abs($t*2 - 1)-1)*tAngle) {
      linear_extrude(center = true, height = 7) {
	gear(circular_pitch = circPitch, num_teeth = centralTeeth);
      }
    }
  }
  //translate([centerToCenter,0,0]) {
  //translate([circPitch*(centralTeeth+edgeTeeth)/(2*pi),0,0]) {
  translate([ccManualDist,0,0]) {
    rotate(a = (1-abs($t*2 - 1))*tAngle*centralTeeth/edgeTeeth) {
      union(){
	linear_extrude(center = true, height = 6) {
	  gear(circular_pitch = circPitch, num_teeth = edgeTeeth);
	}
	hull() {
	  translate([HubToToe,0,0]) circle(armToeDiam);
	  circle(armHubDiam);
	}
      }
    }
  }
}