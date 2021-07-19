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

tilts = [-300,+300]; %um
tips =  [-200,+250]; %um
centroid_pos = 8.25; %mm
cells_per_axis = 3;
filedir = 'Z:\Data\TKM\PM5\July2021\TipTilt\GlassDuctTape\OctreeCPMG_series1\';

dtilt = range(tilts)/cells_per_axis;
tilt_vals = tilts(1)+dtilt/2:dtilt:tilts(2);

dtip = range(tips)/cells_per_axis;
tip_vals = tips(1)+dtip/2:dtip:tilts(2);

nPos_out = write_input_positions(tilt_vals,tip_vals,centroid_pos,filedir);

