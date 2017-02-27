
diameter = 100;
thickness = 3;
holeDiam = 3.5;
holeHeight = 5;

cornerRadius = 4;
rodWidth = 6.5;
rodLength = 93;
rodHolePos = 10;

$fn = 24;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])
    difference() {
        cube([r + 0.01, r + 0.01, h], center = true);
        translate([r/2, r/2, 0]) cylinder(r = r, h = h + 1, center = true);
    }
}

module roundCornerCube(size, r) {
    difference() {
        cube(size, center=true);
        translate([0, size[1]/2, size[2]/2]) rotate([0, 90, 180])
            fillet(cornerRadius, size[0]+0.01);
    }
}

module cap() {
    cubeSide = 2*cornerRadius + sqrt(2)*holeHeight;
    sep = 2*thickness + rodWidth + 0.5;

    union() {
        cylinder(thickness, d=diameter, $fn=80);
        difference() {
            intersection() {
                translate([0, 0, thickness]) rotate([45, 0, 0])
                    roundCornerCube([sep, cubeSide, cubeSide], cornerRadius);
                cylinder(cubeSide, d=diameter);
            }
            cube([rodWidth + 0.5, 2*cubeSide, 2*cubeSide], center=true);
            translate([0, 0, thickness+holeHeight])
                rotate([0, 90, 0]) cylinder(sep, d=holeDiam, center=true);
        }
    }
}

module rod() {
    difference() {
        cube([rodWidth, rodLength, rodWidth], center=true);
        translate([0, -rodLength/2 + rodHolePos, 0]) rotate([0, 90, 0])
            cylinder(rodWidth+0.01, d=holeDiam, center=true);
        translate([0, -rodLength/2, rodWidth/2]) rotate([0, 90, 0])
            fillet(rodWidth, rodWidth+0.01);
    }
}

part = 0;

if (part == 1) {
    cap();
} else if (part == 2) {
    rod();
} else {
    // assembly
    cap();
    translate([0, rodLength/2 - rodHolePos, thickness + holeHeight]) rod();
}
