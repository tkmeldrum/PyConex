% Matlab code for tilt/tip table, W&M
% TKM, June 2021
%
% This code (1) generates the txt file with the positions for the
% tilt/table input, (2) reads the txt file that contains the actual
% positions used during acquisition, and (3) processes the Kea data to
% interpret the tilt/tip files.

clear
clc
close all

% user defined parameters
actuator_lims = [0 11.9];

tilts = -100:50:150; %um
tips =  -100:50:150; %um
centroids = 6.47; %mm

filedir = 'Z:\Data\LJK\PM5\September2021\Sample1\CPMGSeriesA\';

positions = make_positions_mesh(tilts,tips,centroids);
[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
write_input_positions(filedir,positions)
plot_actuator_limits(positions,actuator_lims)






