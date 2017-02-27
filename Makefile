
STL_FILES=bearing_adapter.stl bearing_holder.stl crank.stl rod_adapter.stl \
		  cap.stl rod.stl servo_holder.stl clamp.stl

all: $(STL_FILES)

bearing_adapter.stl: servo_arm.scad
	openscad -o $@ -Dpart=1 $<

bearing_holder.stl: servo_arm.scad
	openscad -o $@ -Dpart=2 $<

crank.stl: servo_arm.scad
	openscad -o $@ -Dpart=3 $<

rod_adapter.stl: servo_arm.scad
	openscad -o $@ -Dpart=4 $<

cap.stl: telescope_cap.scad
	openscad -o $@ -Dpart=1 $<

rod.stl: telescope_cap.scad
	openscad -o $@ -Dpart=2 $<

servo_holder.stl: servo_holder.scad
	openscad -o $@ $<

clamp.stl: clamp.scad
	openscad -o $@ $<

clean:
	rm -f $(STL_FILES)
