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
as AI can't see what it is making and successfully produced trash. 
It can help you with syntax errors, some functions and stuff, but not create a model or part of.
*/

/**
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/06/20r269";
**/

use </home/adam/Documents/Programming/SCAD-lib/mainlib.scad>;
$fn = 32;

//Choose part / Assembly view
/* [Part Chooser] */
run = "assembly"; //[assembly, base, top, latches, handle, seal, hinge_screw, latch_screw]
/* [Basic Dimensions] */
//x,y size. This is actually to the begining of each corner radius. Design choices my dude... Render and measure edge to edge.
corner_distance = [165, 165]; 
//height of base bottom (min 20mm or it weirds out)
base_height = 40; //0.1
top_height = 20; //0.1
//muliples of nozzle size
wall_thickness = 3.2;  //0.1
//max 2x wall_thickness, chop model to see better what goes on
base_thickness = 4;  //0.1

/* [Hinge] */

//hinge hole size (legacy, replaced by hinge_outer_rib_hole_dia / hinge_inner_rib_hole_dia)
//hinge_hole = 3.2; //0.1
//thickness for outer hinge and 2x is inner hinge
hinge_thickness = 4.0; //0.1
hinge_clearance = 0.2; //0.1
//fudged for visualisation only
right_screw_offset = 35;
left_screw_offset = corner_distance.y - right_screw_offset;


/* [Screw and hole sizing] */
//the top and bottom holes must match, but inner/outer can be different for screwing into the plastic on one side, top case hinge hole will match hinge_outer_rib_hole_dia
hinge_outer_rib_hole_dia = 3.2; //0.1
hinge_inner_rib_hole_dia = 3.0; //0.1

//the top case latch rib hole sizing can be differrent from the base, as adding a handle could change how you want to attach
latch_outer_rib_top_hole_dia = 3.2; //0.1
latch_inner_rib_top_hole_dia = 3.2; //0.1
latch_outer_rib_base_hole_dia = 3.2; //0.1
latch_inner_rib_base_hole_dia = 3.2; //0.1

//handle hole can be different from the latch rib holes
handle_hole_dia = 3.2; //0.1

//actual latch hole sizes, not the support ribs (legacy, replaced by latch_inner_rib_*_hole_dia)
//latch_hole = 3.2;  //0.1
latch_screw_dia = 3.0; //0.1
latch_screw_len = 35; //0.1
latch_screw_head_dia = 6; //0.1
latch_screw_head_len = 4; //0.1
hinge_screw_len = 35; //0.1
hinge_screw_dia = 3.0; //0.1
hinge_screw_head_dia = 7; //0.1
hinge_screw_head_len = 4; //0.1



/* [Seal and Lip] */

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





/* [Latches] */

///////////////////come back to here
//this shouldn't change
latch_dist_between_holes = 20.0;  //0.1
latch_width = 19.5; //0.1
latch_circle_thickness = 6.0; //0.1
//too thick and it won't flex
latch_thickness = 2.2; //0.1
//fudged for visualisation only
latch_right_screw_offset = 40;
latch_left_screw_offset = corner_distance.y - latch_right_screw_offset;
latch_preview_outset = latch_dist_between_holes;
//latch hole size (max 3.5)
latch_screw_clip_clearance = 0.1;
latch_thickness_offset = 1.7;
latch_segment_angle = 240;
latch_segment_rotation = 55;
latch_flat_offset = 9;

/* [Side Supports] */
side_support_rib_thickness = 5; //0.1
//reinforcement count
side_reinforce_count = 3; // [1:1:8]
//offset from edge
side_reinforce_first_offset = 10; // [4:1:60]
// 0 = auto spread between edge offsets
side_reinforce_spacing = 0; 


/* [Handle] */
handle_preview_y = (latch_left_screw_offset + latch_right_screw_offset) / 2;

//how thick the handle is, as in, how deep if laid down flat
handle_thickness = 6; //0.1
//the width of the handle is the thickness of the extrusion, not the width of the handle overall
handle_width = 8; //0.1
//how tall it is, as in the top to bottom of the U shape
handle_height = 40; //0.1
//how wide the handle is overall, as in the outer sides of the U shape. this should be set to match the outside edges of the inner latch ribs
handle_length = 80; //0.1
//add this much to the outside edges of the screw holes on the handle, so the handle doesn't interfere with other parts.
handle_screw_mount_offset_length = 7.0; //0.1
//rounding of the edges of the handle
handle_edge_radius = 1; //0.1
//the bend radius of the U shape
handle_radius = 15;
//assembly visualise only, rotate the handle by this much degrees
handle_rotation = 180; //[0:180]


/* [Visualiaston] */
//visualisation of innards
chopmodel = false; //[true, false];
chopmodel_showblock = false; //[true, false];
chopx = -0; //[-400:400]
chopy = -0; //[-400:400]
chopz = -1; //[-400:400]
chop_width = 150; //[0:400]
chop_height = 200; //[0:400]
chop_depth = 200; //[0:400]

// The below was not the smartest move I could have made. But I did it anyway.

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



/*
Create a rounded square (or rect)
*/
module rSquare(x,y,rd,fn = 32){
    $fn=fn;
    hull(){
        translate([rd,rd,0]) circle(r= rd);
        translate([x-rd,rd,0]) circle(r= rd);
        translate([x-rd,y-rd,0]) circle(r= rd);
        translate([rd,y-rd,0]) circle(r =rd);
    }
    
}

// Helper module to center the profile cleanly for extrusions
module profile_centered(w, t, r_edge) {
    translate([-w / 2, -t / 2, 0]) rSquare(w, t, r_edge);
}

module handle_half(
    handle_hole_dia = 3.2,
    handle_thickness = 14,   // Depth of handle profile (Y axis)
    handle_width = 16,       // Width of handle profile (X axis)
    handle_height = 40,      // Total height from pivot center to top edge
    handle_length = 80,      // Total length from outside edge to outside edge
    handle_edge_radius = 1,  // Fillet radius for the profile edges
    handle_radius = 15,       // Inside bend radius of the U-turn
    handle_screw_mount_offset_length = 4
) {
    w = handle_width;
    t = handle_thickness;
    r_edge = handle_edge_radius;
    
    // Calculate precise bend radiuses
    r_inner = handle_radius;
    r_center = r_inner + w / 2;
    r_outer = r_inner + w;
    
    // Straight leg height extends from pivot center (Z=0) up to the bend start
    leg_straight_height = handle_height - r_outer;
    top_straight_half_length = (handle_length / 2) - r_outer;
    
    // Center point of this leg's pivot axis
    leg_x_center = (handle_length / 2) - w / 2;
    
    difference() {
        union() {
            // 1. Straight Vertical Leg
            translate([leg_x_center, 0, 0]) {
                linear_extrude(height = leg_straight_height) {
                    profile_centered(w, t, r_edge);
                }
            }
            
            // 2. 90-Degree Curved Bend
            translate([(handle_length / 2) - r_outer, 0, leg_straight_height]) {
                rotate([90, 0, 0]) {
                    rotate_extrude(angle = 90, $fn = 64) {
                        translate([r_center, 0, 0]) {
                            profile_centered(w, t, r_edge);
                        }
                    }
                }
            }
            
            // 3. Straight Horizontal Top Bar (Half)
            translate([0, 0, handle_height - w / 2]) {
                rotate([0, 90, 0]) {
                    linear_extrude(height = top_straight_half_length) {
                        profile_centered(w, t, r_edge);
                    }
                }
            }
            
            // 4. Solid Pivot Rounding (Using your tube module with ID=0)
            translate([leg_x_center+handle_screw_mount_offset_length/2, 0, 0]) {
                rotate([0, 90, 0]) {
                    tube(
                        od_base = t,
                        od_top = t,
                        id_base = 0,
                        id_top = 0,
                        length = w + handle_screw_mount_offset_length,
                        center = true,
                        $fn = 64
                    );
                }
            }
        }
        
        // 5. Side Mounting Pivot Hole (Drilled clear through the leg along X axis)
        translate([leg_x_center+handle_screw_mount_offset_length/2, 0, 0]) {
            rotate([0, 90, 0]) {
                tube(
                    od_base = handle_hole_dia,
                    od_top = handle_hole_dia,
                    id_base = 0,
                    id_top = 0,
                    length = w + 2+handle_screw_mount_offset_length, // slightly longer for a clean render cut
                    center = true,
                    $fn = 32
                );
            }
        }
    }
}

/*
Creates the actual handle by joining two perfectly mirrored halves at X = 0
*/
module handle(
    handle_hole_dia = 3.2,
    handle_thickness = 14,
    handle_width = 16,
    handle_height = 40,
    handle_length = 80,
    handle_edge_radius = 1,
    handle_radius = 15,
    handle_screw_mount_offset_length = 4
) {
    union() {
        handle_half(
            handle_hole_dia, handle_thickness, handle_width, 
            handle_height, handle_length, handle_edge_radius, handle_radius, handle_screw_mount_offset_length
        );
        mirror([1, 0, 0]) {
            handle_half(
                handle_hole_dia, handle_thickness, handle_width, 
                handle_height, handle_length, handle_edge_radius, handle_radius, handle_screw_mount_offset_length
            );
        }
    }
}


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

function hinge_rib_hole_dia(which, inner) =
    which == 0 ? 
        inner ? hinge_inner_rib_hole_dia : hinge_outer_rib_hole_dia : 
        hinge_outer_rib_hole_dia;

function latch_rib_hole_dia(which, inner) =
    which == 0 ? 
        inner ? 
            latch_inner_rib_base_hole_dia :
            latch_outer_rib_base_hole_dia 
        : 
        inner ? 
            latch_inner_rib_top_hole_dia :
            latch_outer_rib_top_hole_dia;


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

module base_hinge_profile(which = 0, inner = false) {
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
            circle(d=hinge_rib_hole_dia(which, inner), $fn=100);
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
                    base_hinge_profile(which, inner = true);
        translate([corner_distance.x, hinge_thickness,0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness)
                    base_hinge_profile(which);
        translate([corner_distance.x, hinge_thickness * 6, 0])
            rotate([90,0,0])
                linear_extrude(height = hinge_thickness)
                    base_hinge_profile(which, inner = true);
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
    if (addscrews) { //hinge screws
        translate([
            corner_distance.x + 17.5, 
            left_screw_offset, //hinge_screw_head_len + hinge_screw_len + (hinge_thickness * 4), 
            top_height
        ]) {
            rotate([90,0,0]) {
                translate([0, 0, hinge_screw_len])
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
                translate([0, 0, hinge_screw_len])
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
                translate([0, 0, latch_screw_len])
                screw(
                    thread_dia = latch_screw_dia,
                    thread_len = latch_screw_len,
                    head_dia = latch_screw_head_dia,
                    head_len = latch_screw_head_len,
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
                translate([0, 0, latch_screw_len])
                screw(
                    thread_dia = latch_screw_dia,
                    thread_len = latch_screw_len,
                    head_dia = latch_screw_head_dia,
                    head_len = latch_screw_head_len,
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
                translate([0, 0, latch_screw_len])
                screw(
                    thread_dia = latch_screw_dia,
                    thread_len = latch_screw_len,
                    head_dia = latch_screw_head_dia,
                    head_len = latch_screw_head_len,
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
                translate([0, 0, latch_screw_len])
                screw(
                    thread_dia = latch_screw_dia,
                    thread_len = latch_screw_len,
                    head_dia = latch_screw_head_dia,
                    head_len = latch_screw_head_len,
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

module base_latches_profile(which = 0, inner = false) {

    //module blatch() {
    //    polygon(shBaseLatches);
    //}
    //if ((run == 0) || (run == 4) || (run == 5)) {
            if (which == 0) {
                difference() {
                    polygon(shBaseLatches);
                    translate([(wt * 4)+2, bh-10, 0]) {
                        circle(d=latch_rib_hole_dia(which, inner), $fn=100);
                    }
                }
            } else {
                difference() {
                    polygon(shTopLatches);
                    translate([(wt * 4)+2, th-10, 0]) {
                        circle(d=latch_rib_hole_dia(which, inner), $fn=100);
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
                    base_latches_profile(which, inner = false);
        translate([0, corner_distance.y-10, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which, inner = false);
        translate([0, corner_distance.y-35, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which, inner = true); //top inner
        translate([0, 30, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile(which, inner = true); //base inner
}

module finger_latch(
    hole_dia_a = latch_outer_rib_base_hole_dia,
    hole_dia_b = latch_outer_rib_top_hole_dia
) {
    union() {
        tube(
            od_base = latch_circle_thickness-0.5,
            od_top = latch_circle_thickness-0.5,
            id_base = hole_dia_a+latch_screw_clip_clearance,
            id_top = hole_dia_a+latch_screw_clip_clearance,
            length = latch_width - hinge_clearance,
            segment_angle = latch_segment_angle,
            rotation = latch_segment_rotation
        );
        translate([0, latch_dist_between_holes, 0]) {
            tube(
                od_base = latch_circle_thickness,
                od_top = latch_circle_thickness,
                id_base = hole_dia_b+latch_screw_clip_clearance,
                id_top = hole_dia_b+latch_screw_clip_clearance,
                length = latch_width - hinge_clearance,
                segment_angle = 0,
                rotation = 0
            );
        }
        translate([-latch_thickness_offset, -latch_flat_offset, -9.65]) {
            rotate([0, 270, 0])
                cube([latch_width- hinge_clearance, 10+latch_width- hinge_clearance, latch_thickness]);
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
                translate([-15, latch_left_screw_offset + latch_preview_outset, base_height-10]) {
                    rotate([90, 0, 0]) {
                        finger_latch();
                    }
                }
                translate([-15, latch_right_screw_offset - latch_preview_outset, base_height-10]) {
                    rotate([90, 0, 0]) {
                        finger_latch();
                    }
                }
                translate([-15, handle_preview_y, base_height-10]) {
                    rotate([-handle_rotation, 0, 90]) {
                        handle(
                            handle_hole_dia = handle_hole_dia,
                            handle_thickness = handle_thickness,
                            handle_width = handle_width,
                            handle_height = handle_height,
                            handle_length = handle_length,
                            handle_edge_radius = handle_edge_radius,
                            handle_radius = handle_radius,
                            handle_screw_mount_offset_length = handle_screw_mount_offset_length
                        ); 
                    }
                }


            } //assembly

            if (run == "latches") {
                finger_latch(
                    hole_dia_a = latch_outer_rib_base_hole_dia,
                    hole_dia_b = latch_outer_rib_top_hole_dia
                );
            }

            if (run == "handle") {
                handle(
                    handle_hole_dia = handle_hole_dia,
                    handle_thickness = handle_thickness,
                    handle_width = handle_width,
                    handle_height = handle_height,
                    handle_length = handle_length,
                    handle_edge_radius = handle_edge_radius,
                    handle_radius = handle_radius,
                    handle_screw_mount_offset_length = handle_screw_mount_offset_length
                ); 
            }

            if (run == "seal") {
                generate_seal();
            }
            if (run == "hinge_screw") {
                translate([0, 0, hinge_screw_len])
                screw(
                    thread_dia = hinge_screw_dia,
                    thread_len = hinge_screw_len,
                    head_dia = hinge_screw_head_dia,
                    head_len = hinge_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }
            if (run == "latch_screw") {
                translate([0, 0, latch_screw_len])
                screw(
                    thread_dia = latch_screw_dia,
                    thread_len = latch_screw_len,
                    head_dia = latch_screw_head_dia,
                    head_len = latch_screw_head_len,
                    head_cs = false,
                    translate_head = true
                );
            }            
        } //union, for separating for differencing

        if (chopmodel == true) {
            translate([chopx, chopy, chopz])
                if (chopmodel_showblock) {
                    //color("")
                    %cube([chop_width, chop_height, chop_depth], center = false);
                } else {
                    cube([chop_width, chop_height, chop_depth], center = false);
                }
        }

    }
}