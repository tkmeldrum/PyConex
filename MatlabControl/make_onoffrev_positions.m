% Make ON, OFF, REV positions, iterate n times for a full data set

clear
clc
close all

actuator_lims = [0 12];

n_files = 2;

on_pos = [3.95, 62.5, 37.5];

off_pos = [on_pos(1),0,0];
%rev_pos = [on_pos(1), -147, 216];
% bad_pos1 = [on_pos(1), -on_pos(2),on_pos(3)];
% bad_pos2 = [on_pos(1), on_pos(2),-on_pos(3)];

%For TiltTipCheck
% tilt_1 = [on_pos(1),47.5,on_pos(3)]
% tilt_2 = [on_pos(1),57.5,on_pos(3)]
% tilt_3 = [on_pos(1),67.5,on_pos(3)]
% tilt_4 = [on_pos(1),77.5,on_pos(3)]
% tilt_5 = [on_pos(1),87.5,on_pos(3)]
% tilt_6 = [on_pos(1),97.5,on_pos(3)]
% tilt_7 = [on_pos(1),107.5,on_pos(3)]
% tilt_8 = [on_pos(1),117.5,on_pos(3)]
% tilt_9 = [on_pos(1),127.5,on_pos(3)]
% tilt_10 = [on_pos(1),137.5,on_pos(3)]
% tilt_11 = [on_pos(1),147.5,on_pos(3)]
% 
% tip_1 = [on_pos(1),on_pos(2),112.5]
% tip_2 = [on_pos(1),on_pos(2),122.5]
% tip_3 = [on_pos(1),on_pos(2),132.5]
% tip_4 = [on_pos(1),on_pos(2),142.5]
% tip_5 = [on_pos(1),on_pos(2),152.5]
% tip_6 = [on_pos(1),on_pos(2),162.5]
% tip_7 = [on_pos(1),on_pos(2),172.5]
% tip_8 = [on_pos(1),on_pos(2),182.5]
% tip_9 = [on_pos(1),on_pos(2),192.5]
% tip_10 = [on_pos(1),on_pos(2),202.5]
% tip_11 = [on_pos(1),on_pos(2),212.5]

filedir = 'Z:\Data\TKM\PM5\June2022\HotGlue\CPMG_ONOFF\';

%positions = repmat([tilt_1;tilt_2;tilt_3;tilt_4;tilt_5;tilt_6;tilt_7;tilt_8;tilt_9;tilt_10;tilt_11],n_files,1); %%TILTCHECK
%positions = repmat([tip_1;tip_2;tip_3;tip_4;tip_5;tip_6;tip_7;tip_8;tip_9;tip_10;tip_11],n_files,1); %%TIPCHECK
positions = repmat([on_pos;off_pos],n_files,1); %%ADJUST FOR FULL ONOFF
% positions = repmat([on_pos;bad_pos1;bad_pos2],n_files,1); %%ADJUST FOR FULL ONOFF
positions = [(1:n_files*2)',positions]; %%ADJUST FOR FULL ONOFF
%%
[positions, abs_pos] = check_valid_actuator_moves(positions,actuator_lims);
write_input_positions(filedir,positions)
