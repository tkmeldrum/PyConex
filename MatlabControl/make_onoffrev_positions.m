% Make ON, OFF, REV positions, iterate n times for a full data set

clear
clc
close all

actuator_lims = [0 11.9];

n_files = 5;

on_pos = [6.46, -134, 56];
off_pos = [on_pos(1),0,0];
rev_pos = [on_pos(1),-on_pos(2),-on_pos(3)];

filedir = 'Z:\Data\LJK\PM5\September2021\Sample231\CPMG_TiltTipB\';

positions = repmat([on_pos;off_pos;rev_pos],n_files,1); %%ADJUST FOR FULL ONOFF
positions = [(1:n_files*3)',positions]; %%ADJUST FOR FULL ONOFF

[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
write_input_positions(filedir,positions)
