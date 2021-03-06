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
actuator_lims = [0 12];
random_frac = 0.8;

tilts = -260:35:300; %um
tips =  -260:35:300; %um
centroids = 6.65; %mm

filedir = 'Z:\Data\LJK\PM5\November2021\Sample215\RandomCPMGSeriesB\';

positions = make_positions_mesh(tilts,tips,centroids);
[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);

sel = sortrows(randperm(size(positions,1),round(size(positions,1)*random_frac))');
positions = [(1:numel(sel))',positions(sel,2:4)];
abs_pos = abs_pos(sel,:);
write_input_positions(filedir,positions)
plot_actuator_limits(positions,actuator_lims)