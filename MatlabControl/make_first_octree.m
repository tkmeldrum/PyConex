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

%% user defined parameters
actuator_lims = [0 12];

tilts = [-150, +150]; %um
tips =  [-150, +150]; %um
centroid_pos = 3.95; %mm
cells_per_axis = 3;
filedir = 'Z:\Data\TKM\PM5\June2022\HotGlue\OctreeA\';

dtilt = range(tilts)/cells_per_axis;
tilt_vals = tilts(1)+dtilt/2:dtilt:tilts(2);

dtip = range(tips)/cells_per_axis;
tip_vals = tips(1)+dtip/2:dtip:tips(2);

positions = make_positions_mesh(tilt_vals,tip_vals,centroid_pos);
[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
plot_actuator_limits(positions,actuator_lims)
write_input_positions(filedir,positions)