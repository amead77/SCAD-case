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

*/

/**
//next 2 lines used only by my 'on save' script. can be ignored otherwise.
//AUTO-V
version = "v0.1-2026/06/19r109";
**/

//0 for base, 1 for corner poly, 2 for hinge poly, 3 for both (debug), 4 for latches, 5 for top, 7 for assembly
run = "assembly"; //[assembly, base, top, latches, handle]
//x,y size
corner_distance = [100, 150]; 
//muliples of nozzle size
wall_thickness = 3.2; 
//max 2x wall_thickness
base_thickness = 4; 
//height of base bottom (min 20mm or it weirds out)
base_height = 30;
top_height = 20;
//hinge hole size
hinge_hole = 2.6;
//latch hole size
latch_hole = 2.6; //max 3.5
//seal depth. This will always be -1 for the top (to allow 1mm seal)
seal_depth = 2.2;

sd = seal_depth;
bh = base_height;
th = top_height;
wt = wall_thickness;

//changing this affects the angle of the seal outer. use for printing support ease.
base_lip_z = 10; 
//same for top
top_lip_z = 6;

shBaseCorner = [
    [0,0], 
    [wt * 2,0], 
    [wt * 3,wt], 
    [wt * 3,bh-base_lip_z], 
    [(wt * 3)+2, bh-8], 
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
    [wt * 3,th-10], 
    [(wt * 3)+2, th-top_lip_z], 
    [(wt * 3)+2, th], 
    [(wt * 3)+0.9, th], 
    [(wt * 3)+0.3, (th+(sd-1))], 
    [(wt * 2)+1.5, (th+(sd-1))], 
    [(wt * 2)+1, th], 
    [wt * 2, th], 
    [wt * 2, wt * 2], 
    [wt, base_thickness], 
    [0, base_thickness], 
    [0,0]
];


shBaseSupport = [
    [wt * 2,0], 
    [wt * 3,0], 
    [wt * 4,wt], 
    [wt * 4,bh], 
    [(wt * 3)+2, bh], 
    [(wt * 3)+2, bh-base_lip_z], 
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
    [(wt * 3)+2, th-top_lip_z], 
    [(wt * 3), th-top_lip_z], 
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
    [(wt * 3)+2, th-8], 
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
//tried setting a variable 'shcorner' to either shTopCorner or shBaseCorner depending on 'run'. kept doing the corners but not the sides no matter what I tried. so module base_sides() got doubled up on the ifs instead

///////////////////come back to here
//lets do a massive cludge :)
cLatchBetweenHoles = 20.0;
cLatchWidth = 19.5;

side_support_rib_thickness = 5;

// --------------------------
// Side reinforcement customizer
// --------------------------
side_reinforce_count = 3; // [1:1:8]
side_reinforce_first_offset = 10; // [4:1:60]
side_reinforce_spacing = 0; // 0 = auto spread between edge offsets


chopmodel = true; //[true, false];
chopx = 50;
chopy = 75;
chopz = -1;
chop_width = 200;
chop_height = 200;
chop_depth = 200;

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
module base_hinge(which = 0) {
    //hinges base
    if (which == 0) {
        translate([corner_distance.x,corner_distance.y,0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile(which);
        translate([corner_distance.x,corner_distance.y-25,0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile(which);
        translate([corner_distance.x, 5,0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile(which);
        translate([corner_distance.x, 30, 0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile(which);
    } else if (which == 1) {
//////// hinges top
        translate([corner_distance.x,corner_distance.y-5.1,0])
            rotate([90,0,0])
                linear_extrude(height = 19.8)
                    base_hinge_profile(which);

        translate([corner_distance.x, 24.9,0])
            rotate([90,0,0])
                linear_extrude(height = 19.8)
                    base_hinge_profile(which);
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
                }

                translate([0, corner_distance.y, (top_height + base_height) + 10]) {
                    rotate([180, 0, 0]) {
                        union() {
                            base_corners(which = 1);
                            base_sides(which = 1);
                            base_plate();
                            base_hinge(which = 1);
                            base_latches(which = 1);
                        }
                    }
                }
            } //assembly

            if (run == "latches") {

            }

            if (run == "handle") {

            }
        }

        if (chopmodel == true) {
            translate([chopx, chopy, chopz])
                cube([chop_width, chop_height, chop_depth], center = false);
        }

    }
}