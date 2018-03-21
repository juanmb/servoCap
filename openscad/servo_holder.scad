
width = 9;
thickness = 4;
holeSep = 20;
holeDiam = 3.5;
length = 30;
servoLength = 56;
servoSize = 41;
servoWidth = 21;
servoHoleSep = 10;
servoHoleDist = 49;
baseXPos = servoLength/2 - 18;

$fn = 16;

// cube centered in x axis
module xcube(size) { translate([-size[0]/2, 0, 0]) cube(size); }

// cube centered in x and y axis
module xycube(size) { translate([-size[0]/2, -size[1]/2, 0]) cube(size); }

module countersunkHole(d, l) {
    union() {
        cylinder(l, d=d);
        translate([0, 0, l-d/2]) cylinder(d/2, d/2, d);
    }
}

module base() {
    difference() {
        xycube([width, length, thickness]);
        for (i = [-1, 1]) {
            translate([0, i*holeSep/2, 0]) countersunkHole(holeDiam, thickness);
        }
    }
}

module servoHolder() {
    th = thickness;
    w = servoWidth;

    union() {
        xycube([servoLength, width, th]);
        translate([0, 0, th]) {
            difference() {
                xcube([servoLength, th, w]);
                xcube([servoSize, th, w]);
                for (i = [-1, 1]) for (j = [-1, 1]) {
                    translate([i*servoHoleDist/2, 0, (w + j*servoHoleSep)/2])
                        rotate([-90, 0, 0]) cylinder(th+1, d=holeDiam);
                }
            }
        }
    }
}

union() {
    translate([baseXPos, 0, 0]) base();
    servoHolder();
}
