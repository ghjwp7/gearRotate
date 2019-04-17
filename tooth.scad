/* [Params:] */
// Number of Teeth
toothCount=11; // [3:300]
// Total sweep angle; 1-360
tAngle=90; // [1:360]
$fn=20;
use </home/j-waldby/pcb/3D/gearLegs/test-assembly/GFgear.scad>


linear_extrude(center = true, height = 6) {
	rotate(a = (0.5-abs($t-0.5))*tAngle*2) {
		union() {
			gear(circular_pitch = 10, num_teeth = toothCount);
			square(size = [toothCount*2.5000, 1]);
		}
	}
}