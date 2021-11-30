% Make ON, OFF, REV positions, iterate n times for a full data set

clear
clc
close all

actuator_lims = [0 12];

n_files = 3;

on_pos = [6.65, 226, 253];
off_pos = [on_pos(1), -69, -79];
rev_pos = [on_pos(1), 263 ,-263];
%bad_pos1 = [6.61, -37.5, -37.5];
%bad_pos2 = [6.61, -225, 150];



filedir = 'Z:\Data\TKM\PM5\Nov2021\Sample217B\CPMG_ON2BAD\';

%positions = repmat([on_pos;on_pos2;bad_pos1;bad_pos2],n_files,1);
positions = repmat([on_pos;off_pos;rev_pos],n_files,1); %%ADJUST FOR FULL ONOFF
% positions = repmat([on_pos;bad_pos1;bad_pos2],n_files,1); %%ADJUST FOR FULL ONOFF
positions = [(1:n_files*3)',positions]; %%ADJUST FOR FULL ONOFF
%%
[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
write_input_positions(filedir,positions)
