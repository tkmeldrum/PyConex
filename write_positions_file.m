clear
close all
clc

tilt_vals = -150:25:150;
tip_vals = -150:25:150;
centroid = 5:1:7;
input_positions_filename = '/Users/tyler/Desktop/input_positions.txt';

[o,p,q] = meshgrid(tilt_vals, tip_vals, centroid);
positions = [q(:) p(:) o(:)];
num_positions = numel(positions)/3;
positions(:,2:4) = positions;
positions(:,1) = 1:num_positions;


%%
fileID = fopen(input_positions_filename,'w');

fprintf(fileID,  '%u, %f, %f, %f\n', positions' );

fclose(fileID);
