/* A parametric clamp with support holes for attaching stuff to a cylinder */

use <MCAD/boxes.scad>

diameter = 100;     // inner diameter of the clamp
thickness = 2.4;    // radial thickness
width = 8;          // axial length of the clamp
nutSize = 5.7;      // side-to-side dimension of the hexagonal nut
nutThickness = 4;
screwDiam = 3.0;    // diameter of the closing screw
doubleOpening = false;
gap = 1;            // opening gap

// Support platforms
supportLength = 30;
supportThickness = 2;
supportAngles = [0, 90, -90];  // number and position of support platforms
holeDiam = 3.0;     // diameter of support holes
holeSep = 20;       // separation between support holes

extRadius = diameter/2 + thickness;


difference() {
    union() {
        // external contour
        cylinder(width, extRadius, extRadius, center=true, $fn=80);

        // support platforms
        for (i = supportAngles) {
            rotate(i) translate([0, -extRadius, 0]) support();
        }
        // opening
        opening();
        if (doubleOpening) {
            mirror([0, 1, 0]) opening();
        }
    }
    // inner contour
    cylinder(width+1, diameter/2, diameter/2, center=true, $fn=80);
    // gap
    gap();
    if (doubleOpening) {
        mirror([0, 1, 0]) gap();
    }
    // support holes
    for (i = supportAngles) {
        rotate(i) translate([0, -extRadius, 0]) supportHoles();
    }
}

module opening() {
    difference() {
        holeXPos = thickness*2 + gap/2;
        holeYPos = thickness + (diameter + width)/2;
        w = 2*holeXPos + nutThickness;

        // screw support
        translate([-holeXPos, diameter/2, -width/2]) {
            chamferCube([w, thickness + width, width], 2);
        }
        // screw hole
        translate([-holeXPos, holeYPos, 0]) {
            rotate([0, 90, 0]) cylinder(w, d=screwDiam, $fn=8);
        }
        // nut trap
        translate([holeXPos, holeYPos, 0]) {
            rotate([0, 90, 0]) cylinder(nutThickness, r=nutSize/2/cos(30), $fn=6);
        }
    }
}

module gap() {
    translate([0, extRadius, 0]) cube([gap, extRadius, width+1], center=true);
}

module support() {
    l = supportLength;
    translate([-l/2, -supportThickness, -width/2]) cube([l, l, width], 1);
}

module supportHoles() {
    l = supportLength;
    for (i = [-holeSep/2, holeSep/2]) {
        translate([i, l-supportThickness-1, 0])
            rotate([90, 0, 0]) cylinder(l, d=holeDiam, $fn=8);
    }
}

module chamferCube(size, x) {
    translate(size/2) {
        intersection() {
            cube(size, center=true);
            a = (size[1]+size[2]-2*x)/sqrt(2);
            rotate([45, 0, 0]) cube([size[0], a, a], center=true);
        }
    }
}
