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
actuator_lims = [0 11.6];

tilts = [-250,+250]; %um
tips =  [-190,+170]; %um
centroid_pos = 8.25; %mm
cells_per_axis = 8;
filedir = '/Users/tyler/Desktop/TestFikder/';

dtilt = range(tilts)/cells_per_axis;
tilt_vals = tilts(1)+dtilt/2:dtilt:tilts(2);

dtip = range(tips)/cells_per_axis;
tip_vals = tips(1)+dtip/2:dtip:tips(2);

[nPos_out, positions] = write_input_positions(tilt_vals,tip_vals,centroid_pos,filedir);

[badpostilttip] = check_valid_actuator_moves(positions,actuator_lims);

if ~isempty(badpostilttip)
    sprintf('BAD POSTITIONS FOUND.')
else
    sprintf('No bad positions found.')
end

plot_actuator_limits(tilts,tips,centroid_pos,actuator_lims,badpostilttip)
