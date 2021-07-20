function [num_positions, positions] = write_input_positions(tilt_vals, tip_vals, centroid_vals, filedir)

[p,o,q] = meshgrid(tip_vals, tilt_vals, centroid_vals);
positions = [q(:) o(:) p(:)];
num_positions = numel(positions)/3;
positions(:,2:4) = positions;
positions(:,1) = 1:num_positions;

if ~exist(filedir, 'dir')
    mkdir(filedir)
end

fileID = fopen([filedir,'input_positions.txt'],'w');
fprintf(fileID,  '%u, %f, %f, %f\n', positions' );
fclose(fileID);