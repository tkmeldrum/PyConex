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

tilt_set = [-150, -5, -200]; %um
tip_set =  [115, 5, 165]; %um
centroid_set = [8.0195, 0, 8.0195]; %mm

filedir = 'Z:\Data\TKM\PM5\June2021\TipTilt\Sample249_auto\CPMG_series7\';

tilt_vals = make_inc_vector(tilt_set);
tip_vals = make_inc_vector(tip_set);
centroid_vals = make_inc_vector(centroid_set);

nPos_out = write_input_positions(tilt_vals,tip_vals,centroid_vals,filedir)

