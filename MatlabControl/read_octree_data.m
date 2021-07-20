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
showfigs = 0;
make_next_octree = 0;


% output_positions_filename = [filedir,'input_positions.txt'];

%% read file made by python with output positions

fileID = fopen([filedir,output_positions_filename],'r');
data = fscanf(fileID,'%u, %f, %f, %f');
fclose(fileID);

fileID = fopen([filedir,'stamps.txt'],'r');
stampdata = textscan(fileID,'%u, %f, %s');
fclose(fileID);
time_data = [stampdata{2}(:)];

fileID = fopen([filedir,'input_positions.txt'],'r');
input_pos_data = fscanf(fileID,'%u, %f, %f, %f');
fclose(fileID);

positions_data = reshape(data,4,numel(data)/4)';
input_pos_data = reshape(input_pos_data,4,numel(input_pos_data)/4)';
tilts = unique(input_pos_data(:,3));
tips = unique(input_pos_data(:,4));
nPos_in = size(positions_data,1)

%% process data with FT
[rowsout, colsout] = prep_for_subplot(nPos_in);



for ii = 1:nPos_in
    filelist{ii} = [filedir,num2str(ii),filesep];
    [echoVec,z,spatialdata(:,:,ii),timedata(:,:,ii),params,~] = readKeaForFTT2(filelist{ii},params);
    int_spatial(:,ii) = abs(squeeze(sum(spatialdata(:,:,ii),2)));
    dSA(:,ii) = diff(int_spatial(:,ii))./diff(z');
    [pks(ii),locs(ii),widths(ii),proms(ii)] = findpeaks(dSA(:,ii),'SortStr','descend','NPeaks',1);
end
dz = z(2:end)'-(z(2)-z(1))/2;

[~,bestPos] = max(max(dSA,[],1));

best_data = positions_data(bestPos,:)
all_pks = reshape(pks,numel(tilts),numel(tips));
all_widths = reshape(widths,numel(tilts),numel(tips));

octree_out_data = [positions_data max(int_spatial)' max(dSA)'];

fileID = fopen([filedir,'octree_out.txt'],'w');
fprintf(fileID,  '%u, %f, %f, %f, %f, %f\n', octree_out_data' );
fclose(fileID);
%%


pp = figure(5);
% subplot(1,2,1)
surf(tips,tilts,all_pks); %,'FaceColor','none')
shading interp
view([0 90])
xlabel('tips [um]')
ylabel('tilts [um]')

% subplot(1,2,2)
% surf(tips,tilts,all_pks./all_widths)
% shading flat
% view([0 90])
% xlabel('tips [um]')
% ylabel('tilts [um]')

pubgraph(pp)

%%
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

    mm = figure(3);
    subplot(1,2,1)
    plot(z,int_spatial(:,bestPos),'-r');
    subplot(1,2,2)
    plot(dz,dSA(:,bestPos),'-r');
    pubgraph(mm)

    ll = figure(4);
    plot(diff(time_data))
    ylabel('time between position [s]')
    pubgraph(ll)
end

%% make next octree

if make_next_octree == 1
    centroid_pos = positions_data(bestPos,2);
    tilt_center = positions_data(bestPos,3);
    tip_center = positions_data(bestPos,4);

    dtilt = (tilts(2)-tilts(1))/2;
    dtip = (tips(2)-tips(1))/2;

    filedir = [filedir(1:end-2),num2str(str2num(filedir(end-1))+1),'\'];

    tilt_vals = [tilt_center-dtilt tilt_center tilt_center+dtilt];
    tip_vals = [tip_center-dtip tip_center tip_center+dtip];

    nPos_out = write_input_positions(tilt_vals,tip_vals,centroid_pos,filedir);
end
