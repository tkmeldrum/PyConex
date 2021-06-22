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

tilt_set = [-150, 50, 150]; %um
tip_set =  [-150, 10, 150]; %um
centroid_set = [8.0195, 0, 8.0195]; %mm

params.gamma = 42.577;
params.G = 23.87; 
params.zf = 0;

filedir = '/Volumes/ISC1026/Data/TKM/PM5/June2021/TipTilt/Sample249_auto/CPMG/';
main_title = 'test';
showfigs = 0;

input_positions_filename = [filedir,'input_positions.txt'];
output_positions_filename = [filedir,'output_positions.txt'];

%% make file with positions to be read by python

tilt_vals = make_inc_vector(tilt_set);
tip_vals = make_inc_vector(tip_set);
centroid_vals = make_inc_vector(centroid_set);

nPos_out = write_input_positions(tilt_vals,tip_vals,centroid_vals,input_positions_filename)

%% read file made by python with output positions

fileID = fopen(output_positions_filename,'r');
data = fscanf(fileID,'%u, %f, %f, %f');
fclose(fileID);

positions_data = reshape(data,4,numel(data)/4)';
nPos_in = size(positions_data,1)

%% process data with FT
[rowsout, colsout] = prep_for_subplot(nPos_in);



for ii = 1:nPos_in
    filelist{ii} = [filedir,num2str(ii),filesep];
    [echoVec,z,spatialdata(:,:,ii),timedata(:,:,ii),params,~] = readKeaForFTT2(filelist{ii},params);
    int_spatial(:,ii) = abs(squeeze(sum(spatialdata(:,:,ii),2)));
    dSA(:,ii) = diff(int_spatial(:,ii))./diff(z');  
end
dz = z(2:end)'-(z(2)-z(1))/2;

[~,bestPos] = max(max(dSA,[],1));

best_data = positions_data(bestPos,:)

if showfigs == 1
    hh = figure(1);
    for ii = 1:nPos_in
        subplot(rowsout,colsout,ii)
        plot(z,int_spatial(:,ii)');
    end
    pubgraph(hh)
    
    gg = figure(2);
    for ii = 1:nPos_in
        subplot(rowsout,colsout,ii)
        plot(dz,dSA(:,ii));
    end
    pubgraph(gg)
end