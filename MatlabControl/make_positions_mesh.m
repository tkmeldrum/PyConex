function [positions] = make_positions_mesh(tilt_vals, tip_vals, centroid_vals)

[p,o,q] = meshgrid(tip_vals, tilt_vals, centroid_vals);
o(:,2:2:end) = flipud(o(:,2:2:end));
positions = [q(:) o(:) p(:)];
num_positions = numel(positions)/3;
positions(:,2:4) = positions;
positions(:,1) = 1:num_positions;

