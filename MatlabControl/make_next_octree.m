function [] = make_next_octree(bestPos,tilts,tips,writedir)
centroid_pos = positions_data(bestPos,2);
tilt_center = positions_data(bestPos,3);
tip_center = positions_data(bestPos,4);

dtilt = (tilts(2)-tilts(1))/2;
dtip = (tips(2)-tips(1))/2;

% filedir = [filedir(1:end-2),num2str(str2num(filedir(end-1))+1),'\'];

tilt_vals = [tilt_center-dtilt tilt_center tilt_center+dtilt];
tip_vals = [tip_center-dtip tip_center tip_center+dtip];

write_input_positions(tilt_vals,tip_vals,centroid_pos,writedir);