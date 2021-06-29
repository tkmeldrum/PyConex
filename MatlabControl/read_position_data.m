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
params.gamma = 42.577;
params.G = 23.87; 
params.zf = 4;

[output_positions_filename,filedir] = uigetfile('*.txt');

% filedir = '/Volumes/ISC1026/Data/TKM/PM5/June2021/TipTilt/Sample249_auto/CPMG_series2/';
main_title = 'test';
showfigs = 1;

% output_positions_filename = [filedir,'input_positions.txt'];

%% read file made by python with output positions

fileID = fopen([filedir,output_positions_filename],'r');
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
        if ii == bestPos
            plot(z,int_spatial(:,ii)','-r');
        else
            plot(z,int_spatial(:,ii)');
        end
    end
    pubgraph(hh)
    
    gg = figure(2);
    for ii = 1:nPos_in
        subplot(rowsout,colsout,ii)
        if ii == bestPos
            plot(dz,dSA(:,ii),'-r');
        else
            plot(dz,dSA(:,ii));
        end
    end
    pubgraph(gg)
end