// outer dimensions
width = 32 + 4.8;
length = 45.0 + 4.8;
height = 16;
thickness = 2.4;
//ensure that the edge roundness is greater than the wall thickness
corner_radius = 4;
tolerance = 0.3;

connSize = [2.7, 2.7, 7.8];
connSep = 2.54*2;
usbSize = [8.5, 8.5, 4.5];
holeSep = [40.7, 15.3];
holeDiam = 1.6;
spacerDiam = 4.0;
spacerLength = 5.0;
pcbThickness = 1.6;
nanoPos = 24;

connZPos = 4;
powerConnDiam = 8.5;
powerConnYPos = 9;
powerConnZPos = 10;

// lid slope
slope1 = 1.5;
slope2 = 0.5;

t = 0.1;

$fn = 20;

// aliases
size = [length, width, height];
th = thickness;
r = corner_radius;
d = 2*r;

innerSize = [size[0] - 2*th + t, size[1] - 2*th + t, size[2] - th];
echo("Inner size:", innerSize);

module outerCorner(x, y) {
    translate([(size[0] - d + t)*x, (size[1] - d + t)*y, 0])
        cylinder(size[2] + th, r=r);
}

module innerCorner(x, y) {
    translate([(size[0] - d + t)*x, (size[1] - d + t)*y, 0])
        cylinder(size[2], r=r-th);
}

module lidGrooveCorner(x, y) {
    translate([(size[0] - d + th - t)*x, (size[1] - d + t)*y, 0])
        cylinder(th, r - th + slope1, r - th + slope2);
}

module lidCorner(x, y) {
    translate([(size[0] - d + t)*x, (size[1] - d + t)*y, 0])
        cylinder(th, r - th + slope1 - tolerance, r - th + slope2 - tolerance);
}

module box() {
    translate([r, r, 0])
        difference () {
            hull() { for (i=[0, 1], j=[0, 1]) outerCorner(i, j); }

            translate([0, 0, th])
                hull() { for (i=[0, 1], j=[0, 1]) innerCorner(i, j); }

            translate([0, 0, size[2] + t])
                hull() { for (i=[0, 1], j=[0, 1]) lidGrooveCorner(i, j); }

            translate([size[0] - d, -r, size[2] + t])
                cube([r, size[1] + t, th]);
        }
}

module lid() {
    translate([r, r, 0])
        hull() { for (i=[0, 1], j=[0, 1]) lidCorner(i, j); }
}

module spacer() {
    difference() {
        cylinder(spacerLength, d=spacerDiam);
        cylinder(spacerLength + t, d=holeDiam);
    }
}

module pcbBox() {
    difference() {
        union() {
            translate([-length/2, 0, 0]) box();
            // spacers
            for (i=[-1, 1], j=[-1, 1])
                translate([i*holeSep[0]/2, j*holeSep[1]/2 + nanoPos, th]) spacer();
        }

        // connector holes
        h = th + spacerLength + pcbThickness;
        translate([-length/2 - t, nanoPos + - usbSize[0]/2, h]) cube(usbSize);
        for (i=[0, -1])
            translate([i*connSep, -t, th + connZPos]) cube(connSize);
        translate([-length/2 - t, powerConnYPos, powerConnZPos])
            rotate([0, 90, 0]) cylinder(th + 2*t, d=powerConnDiam);

        // mounting holes
        for (i=[-1, 1])
            translate([10, width/2 + i*10, -t]) cylinder(th + 2*t, d=3.4);
    }
}

pcbBox();
translate([-length/2, size[1] + 2, 0]) lid();
