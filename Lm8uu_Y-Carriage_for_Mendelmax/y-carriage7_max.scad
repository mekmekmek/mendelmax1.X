// MendelMax  
// Y-carriage
// Used for sliding on Y axis
// GNU GPL v2
// Author: Tommy Cheng
// 

include <gregs-lm8uu-holder3.scad>
include <configuration.scad>

layer_height=0.30;                   // Skeinforge/SFACT layer height.

beam_support_thickness=5;
beam_width=20;
beam_thickness=9;

bar_seperation=100;                  // seperation between the Y parallel bars.  

carriage_mount_hole_y_sep=110;       // center to center distance in Y direction. 
carriage_mount_hole_x_sep=bar_seperation;       // center to center distance in X direction. 

carriage_width=carriage_mount_hole_x_sep;
carriage_depth=carriage_mount_hole_y_sep;

hbp_mounting_hole_sep =210;

mount_radius=6;

lm8uu_center_to_platform_surface=11;

three_lm8uu=1;                       // How many lm8uus to use: 0 = 4 lm8uu, 1 = 3 lm8uu.
single_lm8uu_side=-1;                // Single bearing side selection: -1 = left, 1 = right.

three_legged=1;                      // three or four legged: 1 = three, 0 = four. 
                                     // (this trumps "three_lm8uu", so if three_legged 
                                     // is set to 1, it will be 3 lm8uu regardless 
                                     // of the setting of "three_lm8uu".)

belt_width=6.5;
belt_thickness=1.5; 
tooth_height=1.5;
tooth_spacing=2;                  // T5 belt = 5.0, XL belt = 5.08, 2 for GT2;

belt_socket_x_offset=0;
belt_socket_y_offset=carriage_depth/2;

belt_clamp_thickness=2; 
belt_clamp_width=m3_diameter+3*belt_clamp_thickness+2;
belt_clamp_hole_separation=13;
belt_clamp_channel_height=m3_diameter+2*belt_clamp_thickness+1;
belt_clamp_length=belt_clamp_hole_separation+m3_diameter+2*belt_clamp_thickness;

y_idler_bearing_dia = 22;
y_pulley_dia = 9.7;

belt_socket_channel_height = 2;   // idler side

belt_socket_channel_height_motor = belt_socket_channel_height + 
	(y_idler_bearing_dia-y_pulley_dia)/2;  // motor side

belt_socket_height=beam_thickness+2;
belt_socket_support_width=7;
belt_socket_support_thickness=belt_socket_height;

m3_socket_diameter=6;
m3_socket_height=3.5;
m3_nut_height=2.7;

belt_tensioner_guide_length=13;
belt_tensioner_guide=true;

extension_block_thickness=27;

lm8uu_spacer_thickness=lm8uu_center_to_platform_surface-beam_thickness-
						lm8uu_diameter/2;
lm8uu_y_offset = carriage_depth/2-lm8uu_holder_length;
bar_y_offset = (carriage_depth-beam_width)/2;

support_center_y_space=carriage_mount_hole_y_sep-106;
support_center_width=10;
support_center_depth=support_center_y_space+2*beam_width;

frame_angle=atan(carriage_depth/carriage_width);


// carriage + belt clamps
////////////////////////////////////////////

y_carriage();
mirror([0,0,0])
translate([-5,0,0])
belt_clamps();


// 4 spacers
////////////////////////////////////////////
//four_spacers();

// 3 spacers
////////////////////////////////////////////
//three_spacers();


module four_spacers() {
	translate([0,0,0])
	rotate([0,0,0])
	for(i=[0,1,2,3])
	translate([i*14+mount_radius,0,0])
	rotate([0,0,90])
	spacer();
}

module three_spacers() {
	translate([0,0,0])
	rotate([0,0,0])
	for(i=[0,1])
	translate([i*14+mount_radius,0,0])
	rotate([0,0,90])
	spacer();
	
	translate([-20,0,0])
	rotate([0,0,90])
	odd_spacer();
}

//belt_socket();
//carriage_frame();

module spacer()
{
  difference() 
  {
	union() {
		translate(v=[0, 0, extension_block_thickness/2])
		rounded_end_bar(lm8uu_holder_width*6/4+2*mount_radius, 
					mount_radius*2, 
					extension_block_thickness);
	}
	for (i=[-1,0])
	translate(v=[lm8uu_holder_width*3/4+i*(lm8uu_holder_width*6/4), 0, -1])
	cylinder(r=m3_diameter/2, h=extension_block_thickness+2, $fn=10);

	translate(v=[-lm8uu_holder_width/2, -mount_radius/2, 4])
	cube([lm8uu_holder_width,mount_radius,extension_block_thickness-3]);
  }
}

module odd_spacer()
{
  difference() 
  {
	union() {
		spacer();
		translate(v=[0, 0, extension_block_thickness])
		sphere(r=lm8uu_holder_width/2);

		difference() {
			translate(v=[0, 8, -1])
			rotate([0,30,90])
			rounded_end_bar(lm8uu_holder_width*6/4+2*mount_radius, 
						mount_radius*2, 
						extension_block_thickness);
			translate(v=[-25, 0, -25])
			cube([50,50,50]);
		}

		mirror([0,1,0])
		difference() {
			translate(v=[0, 8, -1])
			rotate([0,30,90])
			rounded_end_bar(lm8uu_holder_width*6/4+2*mount_radius, 
						mount_radius*2, 
						extension_block_thickness);
			translate(v=[-25, 0, -25])
			cube([50,50,50]);
		}
	}

	translate(v=[0, 0, extension_block_thickness])
	sphere(r=lm8uu_holder_width/2-2);
	
	translate(v=[-25, -25, extension_block_thickness])
	cube([50,50,50]);

	translate(v=[-25, -25, -50])
	cube([50,50,50]);

	translate(v=[-lm8uu_holder_width/2, -mount_radius/2, 4])
	cube([lm8uu_holder_width,mount_radius,extension_block_thickness-3]);
//	for (i=[-1,0])
//	translate(v=[lm8uu_holder_width*3/4+i*(lm8uu_holder_width*6/4), 0, -1])
//	cylinder(r=m3_diameter/2, h=extension_block_thickness+2, $fn=10);
//
//	translate(v=[-lm8uu_holder_width/2, -mount_radius/2, 4])
//	cube([lm8uu_holder_width,mount_radius,extension_block_thickness-3]);
  }
}

module y_carriage()
{
	difference()
	{	
		union()
		{
			carriage_frame();
			belt_socket();
			screw_holes(false);
		}
		screw_holes();
		bearing_holder_cutouts();
	}
	difference() {
		bearing_holders();
		translate([0,0,-10])
		cube([200,200,20], center=true);
	}
}

module belt_clamps()
{
	translate([carriage_width/2-belt_clamp_length+20,-belt_clamp_length-3,0])
	rotate([0,0,90])
	{
		for (i=[-1,1])
		translate([belt_clamp_width*2,i*(belt_clamp_width+1),0])
		belt_clamp();
		translate([belt_clamp_width*2,0,0])
		belt_clamp_channel();
	}
}

module bearing_holders()
{
	for (i=[-1,1])
	for(j=[-1,1])
	{
		if (three_lm8uu == 1 && single_lm8uu_side == i)
		{
			translate(v=[i*bar_seperation/2-lm8uu_holder_width/2, 
			-lm8uu_holder_length/2, 
			beam_thickness+lm8uu_spacer_thickness-2])
			{
				lm8uu_bearing_holder(beam_thickness);
				difference()
				{
					translate(v=[0,0,-beam_thickness-lm8uu_spacer_thickness])
					cube(size=[lm8uu_holder_width,
								lm8uu_holder_length,
								beam_thickness+lm8uu_spacer_thickness]);
					lm8uu_zip_tie_holes();
				}
			}
		} else {

			translate(v=[i*bar_seperation/2-lm8uu_holder_width/2, 
				j*(carriage_depth/carriage_width*bar_seperation-lm8uu_holder_length)/2-lm8uu_holder_length/2, 
				beam_thickness+lm8uu_spacer_thickness-2])
			{
				if (j<0)
					mirror([0,1,0])
					translate([0,-lm8uu_holder_length,0])
					lm8uu_bearing_holder(beam_thickness);
				else
					lm8uu_bearing_holder(beam_thickness);
				
				difference()
				{
					translate(v=[0,0,-beam_thickness-lm8uu_spacer_thickness])
					cube(size=[lm8uu_holder_width,
							lm8uu_holder_length,
							beam_thickness+lm8uu_spacer_thickness]);
					lm8uu_zip_tie_holes();
				}
			}
		}
	}
}

module bearing_holder_cutouts()
{
	for (i=[-1,1])
	for (j=[-1,1])
	{
		if (three_lm8uu == 1 && single_lm8uu_side == i)
		{
			translate(v=[i*bar_seperation/2-lm8uu_holder_width/2,
				-lm8uu_holder_length/2, 
				beam_thickness+lm8uu_spacer_thickness-2])
			{
				lm8uu_holder_cutout(beam_thickness);
				lm8uu_mounting_cutout();
			}
		} else {
			translate(v=[i*bar_seperation/2-lm8uu_holder_width/2,
				j*(carriage_depth/carriage_width*bar_seperation-lm8uu_holder_length)/2-lm8uu_holder_length/2, 
				beam_thickness+lm8uu_spacer_thickness-2])
			{
				lm8uu_holder_cutout(beam_thickness);
				lm8uu_mounting_cutout();
				translate([-1,-10,-2])
				cube([lm8uu_holder_width+2,10,lm8uu_holder_height+2]);
				translate([-1,lm8uu_length+lm8uu_support_thickness*2,-2])
				cube([lm8uu_holder_width+2,10,lm8uu_holder_height+2]);
			}
		}
	}
}

module carriage_frame()
{
	difference()
	{
		union()
		{
			if (three_legged==1)
			{
				for(j=[-1,1])
				{
					leg(1, j, 13, mount_radius, 400, beam_thickness);
					translate(v=[	(carriage_width/2-lm8uu_holder_width*3/4+(lm8uu_holder_width*3/4)),
							j*(carriage_depth/2-mount_radius),
							beam_thickness/2]) {
					difference() { 
						rounded_end_bar(lm8uu_holder_width*6/4+2*mount_radius, 
							mount_radius*2, beam_thickness);
						if (three_legged==0 && i==single_lm8uu_side)
							translate([0, j*(2*mount_radius-1),-1])
							cube([lm8uu_holder_width+2,10,lm8uu_holder_height+2], center=true);
					}
				}
			}
				leg(-1, 0, 13, mount_radius, 400, beam_thickness);
				translate(v=[	-1*(carriage_width/2-lm8uu_holder_width*3/4+(lm8uu_holder_width*3/4)),
							0,
							beam_thickness/2])
				rounded_end_bar(lm8uu_holder_width*6/4+2*mount_radius, 
							mount_radius*2, beam_thickness);
			} else if (three_lm8uu==1) {
				translate([single_lm8uu_side*bar_seperation/2,
					0,
					beam_thickness/2])
				cube(size=[lm8uu_holder_width,
					bar_seperation*tan(frame_angle),
					beam_thickness], 
					center=true);
				carriage_legs();
			} else {
				carriage_legs();
			}
		}
		platform_cutout();
	}
}

module carriage_legs() {
	for (i=[-1,1])
	for(j=[-1,1])
	{
		difference () {
			linear_extrude(height=beam_thickness)
			barbell (
				[0,0],
				[i*carriage_width/2, j*carriage_depth/2],
				13,mount_radius,400,400);
			if (three_legged == 0 || i!=single_lm8uu_side)
			translate(v=[	i*(carriage_width/2-lm8uu_holder_width*3/4+(lm8uu_holder_width*3/4)),
							j*(carriage_depth/2-mount_radius)+j*(2*mount_radius-1),
							beam_thickness/2-1])
			cube([lm8uu_holder_width+2,10,lm8uu_holder_height+2], center=true);
		}
		translate(v=[	i*(carriage_width/2-lm8uu_holder_width*3/4+(lm8uu_holder_width*3/4)),
							j*(carriage_depth/2-mount_radius),
							beam_thickness/2]) {
			difference() { 
				rounded_end_bar(lm8uu_holder_width*6/4+2*mount_radius, mount_radius*2, beam_thickness);
				if (three_legged==0 && i==single_lm8uu_side)
					translate([0, j*(2*mount_radius-1),-1])
					cube([lm8uu_holder_width+2,10,lm8uu_holder_height+2], center=true);
			}
		}
	}
}

module screw_holes(negative=true)
{
	for (i=[-1,1])
	for(j=[-1,1])
	{
		if (three_legged==1) {
			if (single_lm8uu_side == i) {
				if (j==1)
					screw_holes_helper(i,0,negative);
			} else {
			screw_holes_helper(i,j,negative);
			}
		} else  {
			screw_holes_helper(i,j,negative);
		}
	} 
}

module screw_holes_helper(x, y, negative=true)
{
	nut_trap_depth=2;
	for(i=[0,1]) {
		if (negative) {
			color([1,0,1])
			translate(v=[	x*(carriage_width/2-lm8uu_holder_width*3/4+i*(lm8uu_holder_width*6/4)),
							//y*(carriage_depth/2-lm8uu_holder_width*3/4*tan(frame_angle)), 
							y*(carriage_depth/2-mount_radius), 
							-1])
			cylinder(r=m3_diameter/2, h=beam_thickness+10, $fn=10);
	
			translate(v=[	x*(carriage_width/2-lm8uu_holder_width*3/4+i*(lm8uu_holder_width*6/4)), 
							//y*(carriage_depth/2-lm8uu_holder_width*3/4*tan(frame_angle)), 
							y*(carriage_depth/2-mount_radius), 
							beam_thickness-nut_trap_depth])
				rotate([0,0,360/12])
				//cylinder(r=m3_nut_diameter/2, h=nut_trap_depth+1, $fn=6);
			cylinder(r=m3_nut_diameter_bigger/2-0.3, h=nut_trap_depth+1, $fn=6);
		} else {
//			translate(v=[	x*(carriage_width/2-lm8uu_holder_width*3/4+i*(lm8uu_holder_width*6/4)), 
//							y*(carriage_depth/2-lm8uu_holder_width*3/4*tan(frame_angle)), 
//							beam_thickness-nut_trap_depth+1])
//			rotate([0,0,360/12])
//			cylinder(r=m3_nut_diameter_bigger/2+2, h=nut_trap_depth+2, $fn=6);
		}
	}
}

module belt_socket()
{
	translate(v=[-belt_socket_x_offset, 0, 0])
	{
		for (j=[-belt_socket_y_offset, belt_socket_y_offset])
		belt_socket_helper(j);
	}
}

module belt_socket_helper(y)
{
	difference() 
	{
		union()
		{
			translate(v=[0, y, belt_socket_height/2])
			if (y>0)
				rounded_end_bar(belt_clamp_hole_separation+belt_clamp_width, 
								belt_clamp_width, 
								belt_socket_height);	
			else
				translate(v=[0, 0, 
					(m3_nut_diameter+tooth_height+belt_socket_channel_height_motor - 
						belt_socket_height)/2])
				rounded_end_bar(belt_clamp_hole_separation+belt_clamp_width, 
								belt_clamp_width, 
								m3_nut_diameter+tooth_height+belt_socket_channel_height_motor);	

			for(i=[-1,1])
			translate([0,y/2,0])
			difference()
			{
				union() {
					translate([	i*(belt_socket_support_width+belt_width+2)/2,
						0, belt_socket_support_thickness/2])
					cube(	size=[belt_socket_support_width,abs(y),belt_socket_support_thickness], 
						center=true);
					if (y<0)
						translate([	i*(belt_socket_support_width+belt_width+2)/2,
							0, belt_socket_support_thickness*2/3])
						rotate([-6,0,0])
						cube(size=[belt_socket_support_width,abs(y),belt_socket_support_thickness], 
							center=true);
				}

				translate([-100,-100,-10])
				cube([200,200,10]);
				translate([-100,-100,m3_nut_diameter+tooth_height+belt_socket_channel_height_motor])
				cube([200,200,10]);


				if(belt_tensioner_guide && y>0)
				translate([	i*(belt_socket_support_width+belt_width+2)/2,
					(y/2+(y/abs(y))*(-belt_tensioner_guide_length/2-belt_clamp_width/2-3.5)),
					(belt_socket_height-tooth_height-belt_socket_channel_height)/2+
						belt_socket_channel_height])
				rotate([90,0,90])
				rounded_end_bar(belt_tensioner_guide_length+m3_diameter, 
						m3_diameter, 
						belt_socket_support_width+2);

				// socket beam cutout
//				translate([	i*(belt_socket_support_width+belt_width+2)/2,
//					-y/2,
//					(belt_socket_height-tooth_height-belt_socket_channel_height)/2+
//						belt_socket_channel_height])
//				rotate([90,0,90])
//				rounded_end_bar(20+m3_diameter, 
//						m3_diameter, 
//						belt_socket_support_width+2);

				// socket beam cutout
//				translate([	i*(belt_socket_support_width+belt_width+2)/2,
//					(y/2+(y/abs(y))*(-belt_tensioner_guide_length/2-belt_clamp_width/2-1)),
//					(belt_socket_channel_height)/2+1])
//				rotate([90,0,90])
//				rounded_end_bar(14, 
//						m3_diameter, 
//						belt_socket_support_width+2);
			}
		}
		translate(v=[0, y, 0])
					if (y<0)
					{
						mirror([0,1,0])
						belt_socket_holes(
							m3_nut_diameter+tooth_height+belt_socket_channel_height_motor,
							belt_socket_channel_height_motor, false);
					} else {
						belt_socket_holes();
					}
		
	}
}

module belt_socket_holes(
	socket_height=belt_socket_height, 
	channel_height=belt_socket_channel_height,
	tighener=true)
{

	m3_socket_diameter=6;
	m3_socket_height=3.5;

	for(k=[-1,1])
	{
		translate([k*belt_clamp_hole_separation/2,0,socket_height/2])
		cylinder(r=m3_diameter/2,h=socket_height+2,center=true,$fn=8);
//		translate([k*belt_clamp_hole_separation/2,0,m3_socket_height/2-0.5])
//		cylinder(r=m3_socket_diameter/2-0.1,h=m3_socket_height+1,center=true,$fn=10);
	}

	translate([0,0,channel_height/2])
	cube([belt_width,20,channel_height], center=true);

	if(tighener)
	translate([0,belt_clamp_width/2,
				(socket_height-tooth_height-channel_height)/2+
					channel_height])
	{
		rotate([90,180/8,0])
		cylinder(r=m3_diameter/2-0.3 /*tight*/ ,h=beam_width+10,center=true,$fn=8);
		translate([0,-belt_clamp_width,0])
		rotate([90,0,0]) 
		cylinder(r=m3_nut_diameter/2, h=3.4,center=true,$fn=6);
	}
	translate([0,0,socket_height/2])
	for(i=[-3:3])
	translate([-belt_width/2,
				-tooth_spacing/4+i*tooth_spacing,
				socket_height/2-tooth_height])
	cube([belt_width,tooth_spacing/2,tooth_height+1]);
}

module leg(x_dir, y_dir, r1, r2, r3, thickness=beam_support_thickness)
{
	linear_extrude(height=thickness)
	barbell (
		[0,0],
		[x_dir*carriage_width/2, y_dir*carriage_depth/2],
		r1,r2,r3,r3);
}

module platform_cutout()
{
	cutout_end_spacing=2;
	cutout_radius2=mount_radius-3;
	
	platform_cutout_helper(

		(bar_seperation-lm8uu_holder_width)/2-cutout_end_spacing-cutout_radius2-10,
		0,
		cutout_end_spacing, cutout_radius2, frame_angle);
}

module platform_cutout_helper(x1,x2,end_spacing,radius, frame_angle)
{
	if(abs(x2-x1)>=2*radius)
	translate([0,0,-1])	
	for (i=[-1,1])
	for(j=[-1,1])
	{
		if (three_legged==1) {
			if (single_lm8uu_side == i) {
				if (j==1)
					linear_extrude(height=beam_thickness+beam_support_thickness+2)
					barbell (
						[i*x1, 0],
						[i*x2, 0],
						radius,radius+2,300,300);
			} else {
				linear_extrude(height=beam_thickness+beam_support_thickness+2)
				barbell (
					[i*x1, j*x1*tan(frame_angle)],
					[i*x2, j*x2*tan(frame_angle)],
					radius,radius+2,300,300);
			}
		} else  {
			linear_extrude(height=beam_thickness+beam_support_thickness+2)
			barbell (
				[i*x1, j*x1*tan(frame_angle)],
				[i*x2, j*x2*tan(frame_angle)],
				radius,radius+2,300,300);
		}
	}	
}

module rounded_end_bar(x, y, z)
{
		cube([x-y,y,z],center=true);

		for(i=[-1,1])
		translate([i*(x-y)/2,0,0])
		rotate(360/16)
		cylinder(r=y/2,h=z,$fn=40, center=true);
}

// The following are borrowed form Greg Frost's X-carriage
module barbell (x1,x2,r1,r2,r3,r4) 
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference ()
	{
		union()
		{
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}
		translate(x3)
		circle(r=r3,$fa=5);
		translate(x4)
		circle(r=r4,$fa=5);
	}
}

function triangulate (point1, point2, length1, length2) = 
point1 + 
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b)); 

function rotated(a)=[cos(a),sin(a),0];

module belt_clamp_channel()
{
	difference()
	{
		translate([0,0,belt_clamp_clamp_height/2])
		union()
		{
			rounded_end_bar(belt_clamp_width*2+1, belt_clamp_width,belt_clamp_clamp_height);

			translate([-belt_width/2,-belt_clamp_width/2,
				belt_clamp_clamp_height/2-1])
				cube([	belt_width,
						belt_clamp_width,
						belt_socket_channel_height_motor-belt_thickness+2]);
		}

		for(i=[-1,1])
		translate([i*belt_clamp_hole_separation/2,0,-1])
		rotate(360/16)
		cylinder(r=m3_diameter/2,h=belt_clamp_channel_height+2,$fn=8);
	}
}

module belt_clamp_holes()
{
	translate([0,0,belt_socket_height/2])
	{
		for(i=[-1,1])
		translate([i*belt_clamp_hole_separation/2,0,0])
		cylinder(r=m3_diameter/2,h=belt_socket_height+2,center=true,$fn=8);
	
		rotate([90,0,0])
		//rotate(360/16)
		cylinder(r=m3_diameter/2-0.3 /*tight*/ ,h=belt_clamp_width+2,center=true,$fn=8);

		rotate([90,0,0]) 
		translate([0,0,belt_clamp_width/2])
		cylinder(r=m3_nut_diameter/2 ,h=3.4,center=true,$fn=6);
	}
}

belt_clamp_clamp_height=tooth_height+belt_clamp_thickness*2;


module belt_clamp(teeth=false)
{
	difference()
	{
		translate([0,0,belt_clamp_clamp_height/2])
		union()
		{
			cube([belt_clamp_hole_separation,belt_clamp_width,
				belt_clamp_clamp_height],center=true);
			for(i=[-1,1])
			translate([i*belt_clamp_hole_separation/2,0,0])
			cylinder(r=belt_clamp_width/2,h=belt_clamp_clamp_height,center=true,$fn=40);
		}

		for(i=[-1,1])
		translate([i*belt_clamp_hole_separation/2,0,-1])
		cylinder(r=m3_diameter/2,h=belt_clamp_clamp_height+2,$fn=8);

		for(i=[-1,1])
		translate([i*belt_clamp_hole_separation/2,0,
			belt_clamp_clamp_height-m3_socket_height+1])
		cylinder(r=m3_nut_diameter_bigger/2-0.3,h=m3_socket_height,$fn=6);

		if (teeth)
		for(i=[-1:1])
		translate([-belt_width/2,-tooth_spacing/4+i*tooth_spacing,
			belt_clamp_clamp_height-tooth_height])
		cube([belt_width,tooth_spacing/2,tooth_height+1]);
	}
}
