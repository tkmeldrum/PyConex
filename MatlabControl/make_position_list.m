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

tilt_vals = -300:+50:+300; %um
tip_vals =  -200:+50:+250; %um
centroid_vals = 8.25; %mm

filedir = '/Users/tyler/Desktop/TestFikder/';

[nPos_out, positions] = write_input_positions(tilt_vals,tip_vals,centroid_vals,filedir);
[A,B,C] = tilttip_to_abs(positions(:,2:4));


