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

tilts = -300:+50:+300; %um
tips =  -200:+50:+250; %um
centroids = 8.25; %mm

filedir = '/Users/tyler/Desktop/TestFikder/';

[nPos_out, positions] = write_input_positions(tilts,tips,centroids,filedir);

[badpostilttip] = check_valid_actuator_moves(positions,actuator_lims);

if ~isempty(badpostilttip)
    sprintf('BAD POSTITIONS FOUND.')
else
    sprintf('No bad positions found.')
end

% plot_actuator_limits(tilts,tips,centroids,actuator_lims)

