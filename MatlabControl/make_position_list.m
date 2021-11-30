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

tilts = linspace(-250,300,17); %linspace(-260,300,15); %um
tips =  linspace(-320,293,17); %linspace(-260,300,15); %um
centroids = 6.70; %6.65; %mm

filedir = 'Z:\Data\LJK\PM5\November2021\Sample174\CPMGSeriesA\';

positions = make_positions_mesh(tilts,tips,centroids);

% positions = [(1:22)',ones(22,1)*centroids, tilts, tips];

[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
%%
write_input_positions(filedir,positions)
plot_actuator_limits(positions,actuator_lims)






