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
graph_order = sortrows(input_pos_data,3,'descend');

%% process data with FT
[rowsout, colsout] = prep_for_subplot(nPos_in);

for ii = 1:nPos_in
    filelist{ii} = [filedir,num2str(ii),filesep];
    [echoVec,z,spatialdata(:,:,ii),timedata(:,:,ii),params,~] = readKeaForFTT2(filelist{ii},params);
    int_spatial(:,ii) = abs(squeeze(sum(spatialdata(:,:,ii),2)));
    dSA(:,ii) = diff(int_spatial(:,ii))./diff(z');
    [pks(ii),locs(ii),widths(ii),proms(ii)] = findpeaks(int_spatial(:,ii),'SortStr','descend','NPeaks',1);
end
dz = z(2:end)'-(z(2)-z(1))/2;

[~,bestINTPos] = max(max(int_spatial,[],1));
[~,bestdSAPos] = max(max(dSA,[],1));

best_INT_data = positions_data(bestINTPos,:)
best_dSA_data = positions_data(bestdSAPos,:)
all_pks = reshape(pks,numel(tilts),numel(tips));
all_widths = reshape(widths,numel(tilts),numel(tips));

%%


pp = figure(5);
% subplot(1,2,1)
surf(tips,flipud(tilts),all_pks); %,'FaceColor','none')
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
    dSAylims = [min(min(dSA,[],1)) max(max(dSA,[],1))];
    dINTylims = [min(min(int_spatial,[],1)) max(max(int_spatial,[],1))];
    hh = figure(1);
    for ii = 1:nPos_in
        subplot(rowsout,colsout,ii)
        if graph_order(ii) == bestINTPos
            plot(z,int_spatial(:,graph_order(ii,1))','-r');
            ylim(dINTylims*1.1);
        elseif graph_order(ii) == bestdSAPos
            plot(z,int_spatial(:,graph_order(ii,1))','-g');
            ylim(dINTylims*1.1);
        else
            plot(z,int_spatial(:,graph_order(ii,1))');
            ylim(dINTylims*1.1);
        end
        text(-500,dINTylims(2),[num2str(graph_order(ii,3)),',',num2str(graph_order(ii,4))]);
    end
    pubgraph(hh)
    
    gg = figure(2);
    for ii = 1:nPos_in
        subplot(rowsout,colsout,ii)
        if graph_order(ii) == bestINTPos
            plot(dz,dSA(:,graph_order(ii,1)),'-r');
            ylim(dSAylims*1.1);
        elseif graph_order(ii) == bestdSAPos
            plot(dz,dSA(:,graph_order(ii,1))','-g');
            ylim(dSAylims*1.1);
        else
            plot(dz,dSA(:,graph_order(ii,1))');
            ylim(dSAylims*1.1);
        end
        text(-500,dSAylims(2),[num2str(graph_order(ii,3)),',',num2str(graph_order(ii,4))]);
    end
    pubgraph(gg)
end
%%
if showfigs == 1
    mm = figure(3);
    subplot(1,2,1)
    hold on
    plot(z,int_spatial(:,bestINTPos),'-r');
    plot(z,int_spatial(:,bestdSAPos),'-g');
    ylim(dINTylims*1.1);
    subplot(1,2,2)
    hold
    plot(dz,dSA(:,bestINTPos),'-r');
    plot(dz,dSA(:,bestdSAPos),'-g');
    ylim(dSAylims*1.1);
    pubgraph(mm)
    
    ll = figure(4);
    plot(diff(time_data))
    ylabel('time between position [s]')
    pubgraph(ll)
end