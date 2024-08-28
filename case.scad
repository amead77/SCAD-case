//0 for base, 1 for corner poly, 2 for hinge poly, 3 for both (debug), 4 for latches, 5 for top
run = 0; 
//x,y size
corner_distance = [100, 150]; 
//muliples of nozzle size
wall_thickness = 3.2; 
//max 2x wall_thickness
base_thickness = 4; 
//height of base bottom (min 20mm or it weirds out)
base_height = 20;
//hinge hole size
hinge_hole = 2.6;
//latch hole size
latch_hole = 2.6; //max 3.5
//seal depth. This will always be -1 for the top (to allow 1mm seal)
seal_depth = 2.2;

sd = seal_depth;
bh = base_height;
wt = wall_thickness;

shBaseCorner = [[0,0], [wt * 2,0], [wt * 3,wt], [wt * 3,bh-10], [(wt * 3)+2, bh-8], [(wt * 3)+2, bh], [(wt * 3)+1, bh], [(wt * 3)+1, (bh-sd)], [(wt * 2)+1, (bh-sd)], [(wt * 2)+1, bh], [wt * 2, bh], [wt * 2, wt * 2], [wt, base_thickness], [0, base_thickness], [0,0]];

shTopCorner = [[0,0], [wt * 2,0], [wt * 3,wt], [wt * 3,bh-10], [(wt * 3)+2, bh-8], [(wt * 3)+2, bh], [(wt * 3)+0.9, bh], [(wt * 3)+0.3, (bh+(sd-1))], [(wt * 2)+1.5, (bh+(sd-1))], [(wt * 2)+1, bh], [wt * 2, bh], [wt * 2, wt * 2], [wt, base_thickness], [0, base_thickness], [0,0]];

shBaseSupport = [[wt * 2,0], [wt * 3,0], [wt * 4,wt], [wt * 4,bh], [(wt * 3)+2, bh], [(wt * 3)+2, bh-8], [(wt * 3), bh-8], [wt * 3, wt * 2], [wt, base_thickness], [0, base_thickness], [0,0]];

shBaseLatches = [[wt * 2,0], [wt * 3,0], [wt * 4,wt], [(wt * 4)+5, bh-15], [(wt * 4)+5, bh], [wt * 4,bh], [(wt * 3)+2, bh], [(wt * 3)+2, bh-8], [(wt * 3), bh-8], [wt * 3, wt * 2], [wt, base_thickness], [0, base_thickness], [0,0]];

//shBaseHinge is the main part of the hinge, minus the actual hingey round bits :|
shBaseHinge = [[(wt * 4), bh], [((wt * 4)+10), bh], [((wt * 4)+10), (bh-2)], [(wt * 3), (wt * 2)], [(wt * 4), bh]];

//tried setting a variable 'shcorner' to either shTopCorner or shBaseCorner depending on 'run'. kept doing the corners but not the sides no matter what I tried. so module base_sides() got doubled up on the ifs instead

module bcorners() {
    if ((run == 0) || (run == 2) || (run == 3)) {
        rotate_extrude(angle = 90) {
            polygon(shBaseCorner);
        }
    } else if ((run == 5) ||(run == 6)) {
        rotate_extrude(angle = 90) {
            polygon(shTopCorner);        
        }
    }
}

module base_corners() {
    translate([0, 0, 0])
        rotate([0,0,180])
            bcorners();
    translate([corner_distance.x, 0, 0])
        rotate([0,0,270])
            bcorners();
    translate([corner_distance.x, corner_distance.y, 0])
        rotate([0,0,0])
            bcorners();
    translate([0, corner_distance.y, 0])
        rotate([0,0,90])
            bcorners();
}


module base_sides() {

    if (run == 0) {
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
    if (run == 5) {
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

module base_hinge_profile() {
    //creates rear support, then adds the hinge part minus the centre hole, finally differences out the hole. IFs probably unnecessary here as in base_hinge
    module bmain() {
        if ((run == 0) || (run == 2) || (run == 3) || (run == 5)) {
            polygon(shBaseSupport);
            polygon(shBaseHinge);      
            translate([(wt * 4)+5, bh, 0])
                circle(d=10, $fn=100);
        }
    }
    if ((run == 0) || (run == 2) || (run == 3) || (run == 5)) {
        difference() {
        bmain();
        translate([(wt * 4)+5, bh, 0])
            circle(d=hinge_hole, $fn=100);
        }
    }
}

//builds the hinges, then case side supports
module base_hinge() {
    //hinges base
    if (run == 0) {
        translate([corner_distance.x,corner_distance.y,0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile();
        translate([corner_distance.x,corner_distance.y-25,0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile();
        translate([corner_distance.x, 5,0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile();
        translate([corner_distance.x, 30, 0])
            rotate([90,0,0])
                linear_extrude(height = 5)
                    base_hinge_profile();
    } else if (run == 5) {
//////// hinges top
        translate([corner_distance.x,corner_distance.y-5.1,0])
            rotate([90,0,0])
                linear_extrude(height = 19.8)
                    base_hinge_profile();

        translate([corner_distance.x, 24.9,0])
            rotate([90,0,0])
                linear_extrude(height = 19.8)
                    base_hinge_profile();
    }
////////


        //side supports
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
    
}

module base_plate() {
    translate([0,0,0])
        cube([corner_distance.x, corner_distance.y, base_thickness], center = false);
}

module base_latches_profile() {

    module blatch() {
        polygon(shBaseLatches);
    }
    if ((run == 0) || (run == 4) || (run == 5)) {
        difference() {
            blatch();
            translate([(wt * 4)+2, bh-10, 0])
                circle(d=latch_hole, $fn=100);
        }
    }
}

module base_latches() {
        translate([0, 5, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile();
        translate([0, corner_distance.y-10, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile();
        translate([0, corner_distance.y-35, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile();
        translate([0, 30, 0])
            rotate([90,0,180])
                linear_extrude(height = 5)
                    base_latches_profile();
}


if ((run == 0) || (run == 5)) {
    union() {
        base_corners();
        base_sides();
        base_plate();
        base_hinge();
        base_latches();
    }
}
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
    base_corners();
}