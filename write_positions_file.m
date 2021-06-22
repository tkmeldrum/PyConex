clear
close all
clc

tilt_vals = -175:30:+5;
tip_vals = -5:30:+175;
centroid = 8.095;
input_positions_filename = 'C:\CommonData\TKM\PM5\TiltTip\input_positions.txt';

output_positions_filename = 'Z:\Data\TKM\PM5\June2021\TipTilt\Sample249_auto\CPMG_series2\output_positions.txt';

[o,p,q] = meshgrid(tilt_vals, tip_vals, centroid);
positions = [q(:) p(:) o(:)];
num_positions = numel(positions)/3;
positions(:,2:4) = positions;
positions(:,1) = 1:num_positions;


%% write to input positions
fileID = fopen(input_positions_filename,'w');

fprintf(fileID,  '%u, %f, %f, %f\n', positions' );

fclose(fileID);

%% read from output positions
fileID = fopen(output_positions_filename,'r');
data = fscanf(fileID,'%u, %f, %f, %f', [4 507]);
fclose(fileID);

positions_data = data';

num_files = size(positions_data,1);