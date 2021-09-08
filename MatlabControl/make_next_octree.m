function [positions, abs_pos] = make_next_octree(bestPos,tilts,tips,params,writedir)
centroid_pos = bestPos(2);
tilt_center = bestPos(3);
tip_center = bestPos(4);

dtilt = (tilts(2)-tilts(1))/2;
dtip = (tips(2)-tips(1))/2;

% filedir = [filedir(1:end-2),num2str(str2num(filedir(end-1))+1),'\'];

tilt_vals = [tilt_center-dtilt tilt_center tilt_center+dtilt];
tip_vals = [tip_center-dtip tip_center tip_center+dtip];

positions = make_positions_mesh(tilt_vals,tip_vals,centroid_pos);
[positions, abs_pos] = check_valid_actuator_moves(positions,params.actuator_lims);
plot_actuator_limits(positions,params.actuator_lims)
write_input_positions(writedir,positions)