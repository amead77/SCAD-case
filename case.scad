/*
2024
so... when I first created this (about 2 years prior) I had not long started with openscad and I stopped
creating this because I just ran out of steam before creating the latches.
I posted it to reddit in its current state and people liked it, but no one was offering
to assist, so I removed it, then abandoned the whole thing as others did a better job.
The reason I created it is the same reason I've come back to it. Autodesk Fusion 360....
You can get some really good fusion models including the design files (.f3d), but Autodesk have
gone and locked the configurator behind a paywall, where it used to be free for hobby use. 

2026
I've returned to it because I found a good one, but a) no handles, and b) creating a 80mm 
tall base caused the latches to get clipped in half. Then I found another, but that had no handles 
and other limitations. I found myself with no real option but to take another look at this.
And... oh... I made some design *choices* didn't I.
Literally no one else approached their versions like I have. Probably because they have sense.
I tried getting copilot to create my latches and fix some issues. That branch got abandoned immediately
as AI can't see what it is making. It can help you with syntax errors, some functions and stuff, but not
create a model or part of.
*/

/**
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/06/19r553";
**/

use </home/adam/Documents/Programming/SCAD-lib/mainlib.scad>;
$fn = 32;
//Choose part / Assembly view
run = "assembly"; //[assembly, base, top, latches, handle, seal]
//x,y size
corner_distance = [250, 250]; 
//muliples of nozzle size
wall_thickness = 3.2;  //0.1
//max 2x wall_thickness
base_thickness = 4;  //0.1
//height of base bottom (min 20mm or it weirds out)
base_height = 100; //0.1
top_height = 20; //0.1
//hinge hole size
hinge_hole = 3.2; //0.1
//thickness for outer hinge and 2x is inner hinge
hinge_thickness = 4.0; //0.1
hinge_clearance = 0.2; //0.1
hinge_screw_len = 35; //0.1
hinge_screw_dia = 3; //0.1
hinge_screw_head_dia = 6; //0.1
hinge_screw_head_len = 4; //0.1
//fudged for visualisation only
left_screw_offset = 115;
right_screw_offset = 35;


//changing this affects the angle of the seal outer. use for printing support ease. Min is lip_z = 8
base_lip_z = 8; //0.1
base_lip_z_angler = 3; //0.1
//same for top
top_lip_z = 8; //0.1
top_lip_z_angler = 2; //0.1

//seal depth. This will always be -1 for the top (to allow 1mm seal)
seal_depth = 1.5;
//under or oversize the seal height by this much, for fitment/different materials
seal_undersizing_z = -0.2; //0.01
seal_undersizing_inner = 0.05;//0.01
seal_undersizing_outer = 0.05;//0.01

//the width of the part at the case side
//seal_width_case = 3;
//the width of the part that sticks out
seal_width_open = wall_thickness / 4;

sd = seal_depth;
bh = base_height;
th = top_height;
wt = wall_thickness;
//swc = seal_width_case;
swo = seal_width_open;


//the corners are rotate extruded, so are also the sides
shBaseCorner = [
    [0,0], 
    [wt * 2,0], 
    [wt * 3,wt], 
    [wt * 3,bh-base_lip_z-base_lip_z_angler], 
    [(wt * 3)+2, bh-base_lip_z], 
    [(wt * 3)+2, bh], 
    [(wt * 3)+1, bh], 
    [(wt * 3)+1, (bh-sd)], 
    [(wt * 2)+1, (bh-sd)], 
    [(wt * 2)+1, bh], 
    [wt * 2, bh], 
    [wt * 2, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];

shTopCorner = [
    [0,0], 
    [wt * 2,0], 
    [wt * 3,wt], 
    [wt * 3,th-top_lip_z], 
    [(wt * 3)+2, th-top_lip_z+top_lip_z_angler], 
    [(wt * 3)+2, th], 
    [(wt * 3)+1, th], 
    [(wt * 3)+1, (th-sd)], 
    [(wt * 2)+1, (th-sd)], 
    [(wt * 2)+1, th], 
    [wt * 2, th], 
    [wt * 2, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];

/*
shTopCorner = [
    [0,0], 
    [wt * 2,0], 
    [wt * 3,wt], 
    [wt * 3,th-10], 
    [(wt * 3)+2, th-top_lip_z], 
    [(wt * 3)+2, th], 
    [(wt * 3)+ swc / 2, th], //[(wt * 3)+0.9, th], 
    [(wt * 3)- swo, (th+(sd-1))], //[(wt * 3)+0.3, (th+(sd-1))], 
    [(wt * 2)+swo, (th+(sd-1))], //[(wt * 2)+1.7, (th+(sd-1))], 
    [(wt * 2)+swo-wt / 2, th], //[(wt * 2)+1.1, th], 
    [wt * 2, th], 
    [wt * 2, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];
*/

shBaseSupport = [
    [wt * 2,0], 
    [wt * 3,0], 
    [wt * 4,wt], 
    [wt * 4,bh], 
    [(wt * 3)+2, bh], 
    [(wt * 3), bh-base_lip_z], 
    [(wt * 3), bh-base_lip_z], 
    [wt * 3, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];

shTopSupport = [
    [wt * 2,0], 
    [wt * 3,0], 
    [wt * 4,wt], 
    [wt * 4,th], 
    [(wt * 3)+2, th], 
    [(wt * 3)+2, th-top_lip_z+top_lip_z_angler], 
    [(wt * 3), th-top_lip_z+top_lip_z_angler], 
    [wt * 3, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];
//shBaseSupport = [[wt * 2,0], [wt * 3,0], [wt * 4,wt], [wt * 4,bh], [(wt * 3)+2, bh], [(wt * 3)+2, bh-8], [(wt * 3), bh-8], [wt * 3, wt * 2], [wt, base_thickness], [0, base_thickness], [0,0]];

//these are actually the latch external parts.
shBaseLatches = [
    [wt * 2,0], 
    [wt * 3,0], 
    [wt * 4,wt], 
    [(wt * 4)+5, bh-15], 
    [(wt * 4)+5, bh], 
    [wt * 4,bh], 
    [(wt * 3)+2, bh],
    [(wt * 3)+2, bh-8], 
    [(wt * 3), bh-8], 
    [wt * 3, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];

shTopLatches = [
    [wt * 2,0], 
    [wt * 3,0], 
    [wt * 4,wt], 
    [(wt * 4)+5, th-15], 
    [(wt * 4)+5, th], 
    [wt * 4,th], 
    [(wt * 3)+2, th],
    [(wt * 3), th-8], 
    [(wt * 3), th-8], 
    [wt * 3, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];

//shBaseHinge is the main part of the hinge, minus the actual hingey round bits :|
shBaseHinge = [
    [(wt * 4), bh], 
    [((wt * 4)+10), bh], 
    [((wt * 4)+10), (bh-2)], 
    [(wt * 3), (wt * 2)], 
    [(wt * 4), bh]
];

shTopHinge = [
    [(wt * 4), th], 
    [((wt * 4)+10), th], 
    [((wt * 4)+10), (th-2)], 
    [(wt * 3), (wt * 2)], 
    [(wt * 4), th]
];


///////////////////come back to here
//lets do a massive cludge :)
cLatchBetweenHoles = 20.0;  //0.1
cLatchWidth = 19.5; //0.1
cLatchCircle = 6.0; //0.1
//too thick and it won't flex
cLatchThickness = 3; //0.1
latch_screw_len = 25; //0.1
latch_screw_dia = 3; //0.1
latch_screw_head_dia = 6; //0.1
latch_screw_head_len = 4; //0.1
//fudged for visualisation only
latch_left_screw_offset = 110;
latch_right_screw_offset = 40;
//latch hole size (max 3.5)
latch_hole = 3.2;  //0.1
latch_screw_clip_clearance = 0.1;
latch_thickness = 1.6;


side_support_rib_thickness = 5; //0.1

// --------------------------
// Side reinforcement customizer
// --------------------------
//reinforcement count
side_reinforce_count = 3; // [1:1:8]
//offset from edge
side_reinforce_first_offset = 10; // [4:1:60]
// 0 = auto spread between edge offsets
side_reinforce_spacing = 0; 

//visualisation of innards
chopmodel = true; //[true, false];
chopx = -0;
chopy = -0;
chopz = -1;
chop_width = 150;
chop_height = 200;
chop_depth = 200;

/*
Create a seal that fits in the top rim of the case base section. The top of the seal is chamfered to allow 
the case top to revolve on it's hinge and drop onto it.
*/
module generate_seal() {
    // Groove in base is between x=(wt*2)+1 and x=(wt*3)+1, z=(bh-sd)..bh.
    slot_inner = (wt * 2) + 1;
    slot_outer = slot_inner + wt;
    z_bottom = bh - sd;
    z_top = bh;

    seal_top_w = min(wt, max(0.2, swo));
    top_inset = (wt - seal_top_w) / 2;

    //profile of the seal. square base with chamfered top
    shSeal = [
        [slot_inner+seal_undersizing_inner, z_bottom],
        [slot_outer-seal_undersizing_outer, z_bottom],
        [slot_outer-seal_undersizing_outer, z_top],
        [slot_outer - top_inset, z_top+seal_depth+seal_undersizing_z],
        [slot_inner + top_inset, z_top+seal_depth+seal_undersizing_z],
        [slot_inner+seal_undersizing_inner, z_top],
        [slot_inner+seal_undersizing_inner, z_bottom]
    ];

    module seal_corner() {
        rotate_extrude(angle = 90)
            polygon(shSeal);
    }

    module seal_corners() {
        translate([0, 0, 0])
            rotate([0,0,180])
                seal_corner();
        translate([corner_distance.x, 0, 0])
            rotate([0,0,270])
                seal_corner();
        translate([corner_distance.x, corner_distance.y, 0])
            rotate([0,0,0])
                seal_corner();
        translate([0, corner_distance.y, 0])
            rotate([0,0,90])
                seal_corner();
    }

    module seal_sides() {
        translate([corner_distance.x, corner_distance.y, 0])
            rotate([90,0,0])
                linear_extrude(height = corner_distance.y)
                    polygon(shSeal);
        translate([0, corner_distance.y, 0])
            rotate([90,0,90])
                linear_extrude(height = corner_distance.x)
                    polygon(shSeal);
        translate([0, 0, 0])
            rotate([90,0,180])
                linear_extrude(height = corner_distance.y)
                    polygon(shSeal);
        translate([corner_distance.x, 0, 0])
            rotate([90,0,270])
                linear_extrude(height = corner_distance.x)
                    polygon(shSeal);
    }

    union() {
        seal_corners();
        seal_sides();
    }
}

function reinforce_spacing_auto() =
    (side_reinforce_count > 1)
        ? (corner_distance.x - (2 * side_reinforce_first_offset)) / (side_reinforce_count - 1)
        : 0;

function reinforce_x(i) =
    (side_reinforce_count == 1)
        ? (corner_distance.x / 2)
        : (side_reinforce_first_offset + i * ((side_reinforce_spacing > 0) ? side_reinforce_spacing : reinforce_spacing_auto()));


module reinforce_pair_at(xpos, which = 0) {
    half_t = side_support_rib_thickness / 2;

    // Rear side extrudes in +X, so start half thickness before the target center.
    translate([xpos - half_t, corner_distance.y, 0])
        rotate([90,0,90])
            linear_extrude(height = side_support_rib_thickness)
                //polygon(shBaseSupport);
                polygon(which ? shTopSupport : shBaseSupport);

    // Front side extrudes in -X, so start half thickness after the target center.
    translate([xpos + half_t, 0, 0])
        rotate([90,0,270])
            linear_extrude(height = side_support_rib_thickness)
                polygon(which ? shTopSupport : shBaseSupport);
}


///////////////////////////////////////////

module bcorners(which = 0) {
    if (which == 0) {
        rotate_extrude(angle = 90) {
            polygon(shBaseCorner);
        }
    } else {
        rotate_extrude(angle = 90) {
            polygon(shTopCorner);        
        }
    }
}

module base_corners(which = 0 ) {
    translate([0, 0, 0])
        rotate([0,0,180])
            bcorners(which);
    translate([corner_distance.x, 0, 0])
        rotate([0,0,270])
            bcorners(which);
    translate([corner_distance.x, corner_distance.y, 0])
        rotate([0,0,0])
            bcorners(which);
    translate([0, corner_distance.y, 0])
        rotate([0,0,90])
            bcorners(which);
}


module base_sides(which = 0) {

    if (which == 0) {
        translate([corner_distance.x,corner_distance.y,0])
            rotate([90,0,0])
                linear_extrude(height = corner_distance.y)
                    polygon(shBaseCorner);     
        translate([0,corner_distance.y,0])
            rotate([90,0,90])
                linear_extrude(height = corner_distance.x)
                    polygon(shBaseCorner);     
        translate([0,0,0])
            rotate([90,0,180])
                linear_extrude(height = corner_distance.y)
                    polygon(shBaseCorner);     
        translate([corner_distance.x,0,0])
            rotate([90,0,270])
                linear_extrude(height = corner_distance.x)
                    polygon(shBaseCorner);    
    }
    if (which == 1) {
        translate([corner_distance.x,corner_distance.y,0])
            rotate([90,0,0])
                linear_extrude(height = corner_distance.y)
                    polygon(shTopCorner);     
        translate([0,corner_distance.y,0])
            rotate([90,0,90])
                linear_extrude(height = corner_distance.x)
                    polygon(shTopCorner);     
        translate([0,0,0])
            rotate([90,0,180])
                linear_extrude(height = corner_distance.y)
                    polygon(shTopCorner);     
        translate([corner_distance.x,0,0])
            rotate([90,0,270])
                linear_extrude(height = corner_distance.x)
                    polygon(shTopCorner);    
    }
}

module base_hinge_profile(which = 0) {
    //creates rear support, then adds the hinge part minus the centre hole, finally differences out the hole. IFs probably unnecessary here as in base_hinge
    module bmain(which = 0) {
        //if ((run == 0) || (run == 2) || (run == 3) || (run == 5)) {
        if (which == 0) {
            polygon(shBaseSupport);
            polygon(shBaseHinge);      
            translate([(wt * 4)+5, bh, 0]) {
                circle(d=10, $fn=100);
            }
        } else {
            polygon(shTopSupport);
            polygon(shTopHinge);      
            translate([(wt * 4)+5, th, 0]) {
                circle(d=10, $fn=100);
            }
        }
        //}
    }
    //if ((run == 0) || (run == 2) || (run == 3) || (run == 5)) {
        difference() {
        bmain(which);
        translate([(wt * 4)+5, which ? th : bh, 0])
            circle(d=hinge_hole, $fn=100);
        }
    //}
}

//builds the hinges, then case side supports
module base_hinge(which = 0, addscrews = false) {
    //hinges base
    if (which == 0) {
        translate([corner_distance.x,corner_distance.y,0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness)
                    base_hinge_profile(which);
        translate([corner_distance.x,corner_distance.y-hinge_thickness * 5,0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness)
                    base_hinge_profile(which);
        translate([corner_distance.x, hinge_thickness,0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness)
                    base_hinge_profile(which);
        translate([corner_distance.x, hinge_thickness * 6, 0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness)
                    base_hinge_profile(which);
    } else if (which == 1) {
//////// hinges top
        translate([corner_distance.x,corner_distance.y - hinge_thickness - hinge_clearance, 0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness * 4 - (hinge_clearance * 2))
                    base_hinge_profile(which);

        translate([corner_distance.x, hinge_thickness * 5 - hinge_clearance, 0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness * 4 - (hinge_clearance * 2))
                    base_hinge_profile(which);
    }
/*
    simple screw module for differencing/subtracting from models
    this isn't intended to create a thread, just a suitable 
    screw hole in whatever is being designed.

module screw(
    thread_dia = 3,  //the diameter of the screw thread
    thread_len = 30, //the length of the screw thread
    head_dia = 6,    //the diameter of the screw head
    head_len = 2,    //the length of the screw head
    head_cs = false  //whether the screw head is countersunk

*/
    if (addscrews) {
        translate([
            corner_distance.x + 17.5, 
            left_screw_offset, //hinge_screw_head_len + hinge_screw_len + (hinge_thickness * 4), 
            top_height
        ]) {
            rotate([90,0,0]) {
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
        }
        translate([
            corner_distance.x + 17.5, 
            right_screw_offset, //corner_distance.y,//-(hinge_thickness * 3) - 10 - hinge_screw_head_len-hinge_screw_len, 
            top_height
        ]) {
            rotate([90,0,180]) {
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
        }
        //latch screws
        translate([
            -15, 
            latch_left_screw_offset, //hinge_screw_head_len + hinge_screw_len + (hinge_thickness * 4), 
            top_height - 10
        ]) {
            rotate([90,0,0]) {
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
        }
        translate([
            -15, 
            latch_right_screw_offset, //corner_distance.y,//-(hinge_thickness * 3) - 10 - hinge_screw_head_len-hinge_screw_len, 
            top_height - 10
        ]) {
            rotate([90,0,180]) {
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
        }
        translate([
            -15, 
            latch_left_screw_offset, //hinge_screw_head_len + hinge_screw_len + (hinge_thickness * 4), 
            top_height + 10
        ]) {
            rotate([90,0,0]) {
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
        }
        translate([
            -15, 
            latch_right_screw_offset, //corner_distance.y,//-(hinge_thickness * 3) - 10 - hinge_screw_head_len-hinge_screw_len, 
            top_height + 10
        ]) {
            rotate([90,0,180]) {
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
        }

    }
////////


        //side supports
/*
        translate([10, corner_distance.y, 0])
            rotate([90,0,90])
                linear_extrude(height = 5)
                    polygon(shBaseSupport);
        translate([corner_distance.x-10, corner_distance.y, 0])
            rotate([90,0,90])
                linear_extrude(height = 5)
                    polygon(shBaseSupport);
        translate([10, 0, 0])
            rotate([90,0,270])
                linear_extrude(height = 5)
                    polygon(shBaseSupport);
        translate([corner_distance.x-10, 0, 0])
            rotate([90,0,270])
                linear_extrude(height = 5)
                    polygon(shBaseSupport);
*/    

}

module side_supports(which) {
    // side supports, configurable count and spacing
    for (i = [0:side_reinforce_count-1]) {
        reinforce_pair_at(reinforce_x(i), which = which);
    }        
}


module base_plate() {
    translate([0,0,0])
        cube([corner_distance.x, corner_distance.y, base_thickness], center = false);
}

module base_latches_profile(which = 0) {

    //module blatch() {
    //    polygon(shBaseLatches);
    //}
    //if ((run == 0) || (run == 4) || (run == 5)) {
            if (which == 0) {
                difference() {
                    polygon(shBaseLatches);
                    translate([(wt * 4)+2, bh-10, 0]) {
                        circle(d=latch_hole, $fn=100);
                    }
                }
            } else {
                difference() {
                    polygon(shTopLatches);
                    translate([(wt * 4)+2, th-10, 0]) {
                        circle(d=latch_hole, $fn=100);
                    }
            }
            }
            //blatch();
    //}
}

module base_latches(which = 0) {
        translate([0, 5, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which);
        translate([0, corner_distance.y-10, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which);
        translate([0, corner_distance.y-35, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which);
        translate([0, 30, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which);
}

module finger_latch() {
    union() {
        tube(
            od_base = cLatchCircle-0.5,
            od_top = cLatchCircle-0.5,
            id_base = latch_screw_dia+latch_screw_clip_clearance,
            id_top = latch_screw_dia+latch_screw_clip_clearance,
            length = cLatchWidth - hinge_clearance,
            segment_angle = 240,
            rotation = 55
        );
        translate([0, cLatchBetweenHoles, 0]) {
            tube(
                od_base = cLatchCircle,
                od_top = cLatchCircle,
                id_base = latch_screw_dia+latch_screw_clip_clearance,
                id_top = latch_screw_dia+latch_screw_clip_clearance,
                length = cLatchWidth - hinge_clearance,
                segment_angle = 0,
                rotation = 0
            );
        }
        translate([-latch_thickness, -9, -9.65]) {
            rotate([0, 270, 0])
                cube([cLatchWidth- hinge_clearance, 10+cLatchWidth- hinge_clearance, latch_thickness]);
        }
    }
}

/*
Main
*/
render() {
    difference() {
        union() {
            if (run == "base") {
                union() {
                    base_corners(which = 0);
                    base_sides(which = 0);
                    base_plate();
                    base_hinge(which = 0);
                    base_latches(which = 0);
                }
            }
            if (run == "top") {
                union() {
                    base_corners(which = 1);
                    base_sides(which = 1);
                    base_plate();
                    base_hinge(which = 1);
                    base_latches(which = 1);
                }
            }
/*
            if ((run == 1) || (run == 3)) {
                polygon(shBaseCorner);
            }
            if (run == 2) {
                base_hinge_profile();
            }
            if (run == 3) {
                #base_hinge_profile();
            }
            if (run == 4) {
                base_latches();
            }
            if (run == 6) {
                base_corners(which = 1);
            }
*/            
            if (run == "assembly") {
                union() {
                    base_corners(which = 0);
                    base_sides(which = 0);
                    base_plate();
                    base_hinge(which = 0);
                    base_latches(which = 0);
                    side_supports(which = 0);
                }

                translate([0, corner_distance.y, (top_height + base_height) + 0]) {
                    rotate([180, 0, 0]) {
                        union() {
                            base_corners(which = 1);
                            base_sides(which = 1);
                            base_plate();
                            base_hinge(which = 1, addscrews = true);
                            base_latches(which = 1);
                            side_supports(which = 1);
                        }
                    }
                }
                translate([0, 0, 0.0]) {
                    generate_seal();
                }
                translate([-15, 130, base_height-10]) {
                    rotate([90, 0, 0]) {
                        finger_latch();
                    }
                }
                translate([-15, 20, base_height-10]) {
                    rotate([90, 0, 0]) {
                        finger_latch();
                    }
                }
            } //assembly

            if (run == "latches") {
                finger_latch();
            }

            if (run == "handle") {

            }

            if (run == "seal") {
                generate_seal();
            }
        } //union, for separating for differencing

        if (chopmodel == true) {
            translate([chopx, chopy, chopz])
                cube([chop_width, chop_height, chop_depth], center = false);
        }

    }
}