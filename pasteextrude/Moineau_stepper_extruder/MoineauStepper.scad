// Moineau Pump evolution version
// Original design by emmett
// Modifications by Tomi T. Salo <ttsalo@iki.fi> 2011

R1=3; // radius of rolling circle
R2=5; // radius of rotor
H=40; // height
wall=2; // wall thickness
top=3; // crank thickness
c1=0.6; // crank clearance
c2=0.0; // stator clearance
c3=0.4; // rotor clearance
phi=480; // degrees of rotation of stator (>360)
$fn=40; // number of facets in circles
flange_thickness = 3;
flange_radius = 20;
bolt_diameter = 3;

stepper_shaft_length = 18;

coupling_longitudinal_clearance = 1;
coupling_rotor_base_height = 5;
shaft_radius = 6;
coupling_angular_clearance = 5;
coupling_tooth_height = 5;
coupling_num_teeth = 3;
coupling_tooth_hole_radius = 2;

inner_radius_clearance = 2;
inner_radius = max(R2, shaft_radius) + R1 + inner_radius_clearance;
inlet_wall_thickness = 1.5;
inlet_height = 56;
//inlet_pool = 40;

shaft_length = inlet_height + flange_thickness - stepper_shaft_length - 
  coupling_rotor_base_height - coupling_longitudinal_clearance; 

v=4*R1*R2*H*360/phi;
echo(str("Pumping speed is ",v/1000," cc per revolution"));
echo(str("Coupler shaft length is ", shaft_length, " mm"));
echo(str("Inlet block inner diameter is ", inner_radius * 2, " mm"));

module coupler_shaft() {
  coupling(radius = shaft_radius, hole_radius = 0,
           base_height = 0, tooth_height = coupling_tooth_height, 
           num_teeth = coupling_num_teeth,
           tooth_hole_radius = coupling_tooth_hole_radius);
  translate([0, 0, coupling_tooth_height])
  cylinder(r = shaft_radius, 
           h = shaft_length - 2 * coupling_tooth_height);
  translate([0, 0, shaft_length - coupling_tooth_height])
  coupling(radius = shaft_radius, hole_radius = 0,
           base_height = 0, tooth_height = coupling_tooth_height, 
           num_teeth = coupling_num_teeth,
           tooth_hole_radius = coupling_tooth_hole_radius);
}

module motor_coupling() {
  coupling(radius = shaft_radius, hole_radius = 2.7,
           base_height = 5, tooth_height = coupling_tooth_height, 
           num_teeth = coupling_num_teeth,
           tooth_hole_radius = coupling_tooth_hole_radius,
           d_depth1 = 0.5, d_depth2 = 0.5);
}

module coupling(radius, hole_radius, base_height, tooth_height, 
                num_teeth, tooth_hole_radius, d_depth1, d_depth2) {
  difference () {
    cylinder(r = radius, h = base_height);
    difference () {
      cylinder(r = hole_radius, h = base_height);
      translate([-radius, hole_radius - d_depth1, 0])
      cube([radius * 2, radius, base_height]);  
      translate([hole_radius - d_depth2, -radius, 0])
      cube([radius, radius * 2, base_height]);  
    }
  }
  translate([0, 0, base_height])
  coupling_teeth(radius = radius, hole_radius = tooth_hole_radius,
                 height = tooth_height, num_teeth = num_teeth);
}

module coupling_tooth(radius, height, degrees) {
  difference () {
    cylinder(r = radius, h = height);
    translate([-radius, 0, 0])cube(radius * 2); 
    rotate(-180-degrees, [0, 0, 1])
      translate([-radius, 0, 0])cube(radius * 2);
  }
}

module coupling_teeth(radius, hole_radius, height, num_teeth) {
  tooth_angle = 360 / num_teeth;
  difference () {
    for (i = [0 : tooth_angle : 360]) {
      rotate(i - coupling_angular_clearance, [0, 0, 1])
      coupling_tooth(radius = radius, height = height,
                 degrees = tooth_angle / 2 - coupling_angular_clearance);
    }
    cylinder(r = hole_radius, h = height);
  }
}


module rotor() {
  union() {
    linear_extrude(height=H, convexity=20, twist=2*phi)
    translate([R1/2,0,0])
    circle(r = R2 - c3);
    translate([cos(2*phi)*R1/2, -sin(2*phi)*R1/2, H])
    coupling(radius = shaft_radius, hole_radius = 0,
             base_height = 5, tooth_height = coupling_tooth_height, 
             num_teeth = coupling_num_teeth,
             tooth_hole_radius = coupling_tooth_hole_radius);
  }
}

module hollow(Rc, Rr, twist) {
  linear_extrude(height=H, convexity=10, twist=twist, slices=100)
  union() {
    translate([-Rc,0,0])
    circle(r=Rr);
    translate([Rc,0,0])
    circle(r=Rr);
    square([2*Rc,2*Rr],center=true);
    // for a smoother mesh:
    square([2/5*Rc,2.003*Rr],center=true);
    square([5/5* Rc,2.002*Rr],center=true);
    square([8/5*Rc,2.001*Rr],center=true);
  }
}

module flange(radius, thickness, supported) {
  difference() {
    union () {
      if (supported == 0) {
        cylinder(r = radius, h = thickness);
      } else {
        cylinder(r = radius, h = thickness);
        translate([0, 0, -radius])cylinder(r1 = 0, r2 = radius, h = radius);
      }
    }
    for (i = [0 : 60 : 360]) {
      rotate(i, [0, 0, 1])
      translate([0, radius - bolt_diameter * 1.5, 0])
      cylinder(r = bolt_diameter / 2, h = thickness);
      if (supported == 1) {
        rotate(i, [0, 0, 1])
        translate([0, radius - bolt_diameter * 1.5, -bolt_diameter * 3])
        cylinder(r = bolt_diameter, h = bolt_diameter * 3);         
      }
    }
    if (circular_hole == 0) {
      if (supported == 0) {
        hollow(R1, R2, 0);
      }  
    } else {
      translate([0, 0, -radius * 3 + thickness])
      cylinder(r = circular_hole, h = radius * 3);
    }
  }
}

module pump_chassis() {
  difference() {
    union() {
      translate([0, 0, flange_thickness])hollow(R1, R2+wall+c2, phi);
      flange(radius = flange_radius, thickness = flange_thickness, supported = 0,
             circular_hole = 0);
      translate([0, 0, H])flange(radius = flange_radius, thickness = flange_thickness, 
           supported = 1, circular_hole = 0);
     }
    translate([0, 0, flange_thickness])hollow(R1, R2+c2, phi);
  }
}

module pump_nozzle(aperture) {
  flange(radius = flange_radius, thickness = flange_thickness, supported = 0, circular_hole = 0);
  difference() {
    translate([0, 0, flange_thickness]) cylinder(r1 = R2 * 2, r2 = 0, h = R2 * 2);
    cylinder(r = aperture, h = R2 * 3);
    intersection () {
      cylinder(r1 = R2 * 2, r2 = 0, h = R2 * 2);
      hollow(R1, R2, 0);
    }
  }
}

module pump_rotor() {
  rotor();
}

module pump_inlet_block() {
  inlet_pipe_angle = 32;
  inlet_pipe_radius = 7.5;
  inlet_pipe_wall_thickness = 1.5;
  inlet_pipe_support = 0;
  difference () { // motor mount
    translate([0, 0, 1.5])cube([1.7 * 25.4, 1.7 * 25.4, 3], center = true);
    for (i = [45 : 90 : 315]) {
      rotate(i, [0, 0, 1])
      translate([0, 21.8, 0])
      cylinder(r = 1.5, h = 3);
    }
    cylinder(r = 3, h = 3); // axle hole
  }
  translate([0, 0, 3 + 3])
  difference () { // seal retention ring
    cylinder(r = inner_radius, h = 2);
    cylinder(r1 = inner_radius, r2 = inner_radius - 2, h = 2);
  }
  difference() { // inlet hull
    union () {
      translate([0, 0, inlet_height])
      flange(radius = flange_radius, thickness = flange_thickness, supported = 1, 
         circular_hole = inner_radius); // connection flange to chassis
      cylinder(r = inlet_wall_thickness + inner_radius, h = inlet_height); // outer hull
      if (inlet_pipe_support != 0) {
      translate([-(1 / tan(90 - inlet_pipe_angle)) * inlet_height 
                 - inlet_pipe_radius * 2, 
                 - inlet_pipe_radius * 2, 0])
      cube([inlet_pipe_radius * 4, inlet_pipe_radius * 4, 1]); }
      difference () { // inlet pipe
        translate([0, 0, inlet_height])
        rotate(180 + inlet_pipe_angle, [0, 1, 0])
        cylinder(r = inlet_pipe_radius + inlet_pipe_wall_thickness, 
                 h = inlet_height * 2);
        translate([-inlet_height * 6, -inlet_height * 2, - inlet_height * 4])
        cube([inlet_height * 6, inlet_height * 4, inlet_height * 4]); // inlet pipe cut
      }
    }
    cylinder(r = inner_radius, h = inlet_height * 2); // inner void
    translate([0, 0, inlet_height])
    rotate(180 + inlet_pipe_angle, [0, 1, 0])
    cylinder(r = inlet_pipe_radius, h = inlet_height * 2); // inlet pipe void
  }
}

module pump() {
  rotate(180, [1, 0, 0])pump_nozzle(aperture = 1);
  pump_chassis();
  translate([0, 0, H + inlet_height + flange_thickness * 2])rotate(180, [1, 0, 0])pump_inlet_block();
}

pump_chassis();
//pump_nozzle(aperture = 1);
//pump_rotor();
//pump_inlet_block();
//pump();
//coupler_shaft();
//motor_coupling();