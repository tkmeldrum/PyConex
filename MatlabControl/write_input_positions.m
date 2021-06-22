function [num_positions] = write_input_positions(tilt_vals, tip_vals, centroid_vals, input_positions_filename)

[o,p,q] = meshgrid(tilt_vals, tip_vals, centroid_vals);
positions = [q(:) p(:) o(:)];
num_positions = numel(positions)/3;
positions(:,2:4) = positions;
positions(:,1) = 1:num_positions;

fileID = fopen(input_positions_filename,'w');
fprintf(fileID,  '%u, %f, %f, %f\n', positions' );
fclose(fileID);