function [abs_pos] = tilttip_to_abs(positions)

AC_length = 9.4019*25.4; %mm
rfcoil_width = 25000; %um

centroid = positions(:,1);
tilt = positions(:,2);
tip = positions(:,3);

tilt_mm = AC_length/rfcoil_width*tilt;
tip_mm  = (sqrt(3)*AC_length/2)/rfcoil_width*tip;

A = centroid + tilt_mm + tip_mm;
B = centroid           -2*tip_mm;
C = centroid - tilt_mm + tip_mm;

abs_pos = [A B C];

end