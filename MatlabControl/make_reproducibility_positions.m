% Make ON/ZERO/ON/ZERO... positions, iterate n times for a full data set of
% reproducibility

clear
clc
close all

actuator_lims = [0 11.9];

n_files = 17;

on_pos = [6.46, -134, 56];
off_pos = [0,0,0];

filedir = 'Z:\Data\TKM\PM5\Sept2021\Sample231\CPMG_Reproducibility\';

positions = repmat([on_pos;off_pos],n_files,1); %%ADJUST FOR FULL ONOFF
positions = [(1:n_files*2)',positions]; %%ADJUST FOR FULL ONOFF

[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
write_input_positions(filedir,positions)
