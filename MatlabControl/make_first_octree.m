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
abs_pos = tilttip_to_abs(positions(:,2:4));


%% check validity of actuator moves
lower_lim = 0;
upper_lim = 11.6;

A_low = find(abs_pos<lower_lim);
A_high = find(abs_pos>upper_lim);

[badrows,~] = ind2sub(size(abs_pos),A_high);
badposabs = abs_pos(badrows,:);
badpostilttip = sort(positions(badrows,:),1);

%% plot valid tilt/tip ranges
all_tips = min(tips):max(tips);
all_tilts = min(tilts):max(tilts);

AC_length = 9.4019*25.4; %mm
rfcoil_width = 25000; %um

all_tilts_mm = AC_length/rfcoil_width*all_tilts;
all_tips_mm  = (sqrt(3)*AC_length/2)/rfcoil_width*all_tips;

[TILTGRID,TIPGRID] = meshgrid(all_tilts_mm,all_tips_mm);

A = centroid_pos + TILTGRID + TIPGRID;
B = centroid_pos           -2*TIPGRID;
C = centroid_pos - TILTGRID + TIPGRID;

validgrid = (A>12) + (B>12) + (C>12);

hh = figure(1);
surf(all_tilts,all_tips,validgrid);
shading flat
% colormap(gray(2))
xlabel('tilts')
ylabel('tips')
pubgraph(hh)

