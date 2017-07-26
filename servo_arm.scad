// Bearing dimensions
bearingDiam = 22.4;
bearingInnerDiam = 7.7;
bearingHeight = 7;

thickness = 1.6;
rimHeight = 1;
rimThickness = 0.5;
stopHeight = 3;
armLength = 30;

// Spring fasteners
fastener1Distance = 20; // distance from the axis
fastener2Distance = 22; // distance from the axis
fastenerDiam = 3.5;
fastenerHeigh = 3.5;

// support holes
holeSep = 16;
holeDiam = 3.4;

armWidth = 2*fastenerDiam;
outerDiam = bearingDiam + 2*thickness;
height = bearingHeight + rimHeight + stopHeight;
// Distance from the axis to the support wall
wallDist = fastener2Distance + fastenerDiam/2;
fastenerDistance = sqrt(pow(fastener1Distance, 2) + pow(fastener2Distance, 2));
echo("Distance between the spring fasteners:", fastenerDistance);
echo("Distance from the axis to the wall:", wallDist);

//$fn = 80;

module limitCutout() {
    h = bearingHeight + rimHeight;
    union() {
        for (angle = [0, 30, 45]) {
            rotate(angle) translate([0, bearingDiam/2, h + stopHeight/2])
                cube([armWidth, bearingDiam, stopHeight+1], center=true);
        }
    }
}

module springFastener() {
    union() {
        cylinder(fastenerHeigh, d=fastenerDiam, $fn=12);
        translate([0, 0, fastenerHeigh-1]) cylinder(1, d=fastenerDiam+1, $fn=12);
    }
}

module crank() {
    difference() {
        union() {
            cylinder(stopHeight, d=17);
            translate([-armWidth/2, 0, 0])
                cube([armWidth, fastener1Distance, stopHeight]);
            translate([0, fastener1Distance, 0]) {
                cylinder(stopHeight, d=armWidth);
                translate([0, 0, stopHeight]) springFastener();
            }
        }
        cylinder(stopHeight, d=3, $fn=8);
    }
}

// bearing holder
module bearingHolder() {
    difference() {
        union() {
            cylinder(height, d=outerDiam);
            translate([0, -outerDiam/2, 0]) cube([wallDist, outerDiam, height]);
            translate([fastener2Distance, 0, height]) springFastener();
        }

        // rim at the bottom of the bearing
        cylinder(rimHeight, d=bearingDiam - 2*rimThickness);
        translate([0, 0, rimHeight]) cylinder(height, d=bearingDiam);

        // limit cutouts
        limitCutout();
        mirror([0, 1, 0]) limitCutout();

        // hollow bottom rectangle
        hollowL = outerDiam - 2*thickness;
        hollowW = wallDist - bearingDiam/2 - 2*thickness;
        translate([bearingDiam/2 + thickness, -hollowL/2, 0])
            cube([hollowW, hollowL, height-thickness]);

        // support holes
        for (y = [-holeSep/2, holeSep/2]) {
            translate([wallDist - thickness, y, height/2]) rotate([0, 90, 0])
                cylinder(thickness, d=holeDiam, $fn=8);
        }
    };
}

module elongatedHole(d, l, h) {
    union() {
        translate([-l/2, -d/2, 0]) cube([l, d, h]);
        for (pos = [-1, 1]) {
            translate([pos*l/2, 0, 0]) cylinder(h, d=d, $fn=12);
        }
    }
}

flangeLen = 21;

module rodAdapter() {
    rodSize = 7.0;
    thickerSide = 4;
    width = outerDiam;
    holeLen = 6;
    d = 3.1;
    th = 2;

    holeSize = [rodSize, width+.2, rodSize];
    holePos = flangeLen - holeLen/2 - d;
    clampSize = [rodSize + 2*th, width, rodSize + th + thickerSide];
    dist = flangeLen - d - holeLen/2 + thickerSide + rodSize/2;
    echo("Distance from elongated hole's center to rod's center", dist);

    difference() {
        union() {
            // flange
            difference() {
                translate([0, -width/2, 0]) cube([th, width, flangeLen]);
                // elongated holes
                for (i = [-1, 1]) {
                    translate([-.1, i*holeSep/2, holePos]) rotate([0, 90, 0])
                        elongatedHole(d, holeLen, th+.2);
                }
            }
            // rod clamp
            translate([0, 0, th - clampSize[2]])
                difference() {
                    translate([0, -width/2, 0]) cube(clampSize);
                    translate([th, -width/2-.1, th]) cube(holeSize);
                    // clamp holes
                    for (i = [-1, 1]) {
                        translate([th+rodSize/2, i*holeSep/2, th+rodSize])
                            cylinder(thickerSide+.1, d=d, $fn=13);
                    }
                }
            // rib
            difference() {
                translate([th, -th/2, 0]) cube([clampSize[0]-th, th, flangeLen]);
                translate([th, -flangeLen/2, flangeLen]) rotate([0, 45, 0]) cube(flangeLen);
            }
        }
    }
}

module bearingAdapter() {
    h = bearingHeight - 1;
    $fn = 16;
    difference() {
        cylinder(h, d=bearingInnerDiam);
        cylinder(h, d=holeDiam);
    }
}


part = 0;

if (part == 1) {
    bearingAdapter();
} else if (part == 2) {
    bearingHolder();
} else if (part == 3) {
    crank();
} else if (part == 4) {
    rodAdapter();
} else {
    // assembly
    bearingHolder();
    translate([0, 0, rimHeight]) bearingAdapter();
    translate([0, 0, bearingHeight + rimHeight]) crank();
    translate([wallDist, 0, height-flangeLen]) rodAdapter();
}
