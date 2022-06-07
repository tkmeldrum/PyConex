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

%%%%%%%%%% user defined parameters  %%%%%%%%%%
params.gamma = 42.577;
params.G = 23.87;
params.zf = 4;
params.actuator_lims = [0 11.7];


%write octree data output file?
%octree_out.txt, columns are:
%index, centroid, tilt, tip, max(SI), max(dSI)
write_out = 1;

%generate next level of octree zoom?
next_octree = 0;

%%%%%%%%%% end user defined parameters  %%%%%%%%%%



%choose directory containing output_positions.txt, stamps.txt, and
%input_positions.txt data files
% readdir = [uigetdir(pwd,'Choose directory with output data.'),filesep];
readdir = '/Volumes/ISC1026/Data/LJK/PM5/June2022/TiltTip/OliveOil/OctreeA/';

% read files
[positions_data,tilts,tips,params,input_pos_data,time_data] = read_tilttip_text_files(readdir,params);

% process all CPMGs, perform FT, find SI and d(SI)/dz for optimum peak
% selection
[data,SI,dSI] = read_octreeCPMG_series(readdir,params);

SI.best_data = positions_data(SI.bestPos,:);
dSI.best_data = positions_data(dSI.bestPos,:);
out_data = [positions_data max(data.SI)' max(data.dSI)'];

% write text data out
if write_out == 1
    writedir = uigetdir(readdir,'Choose directory to write new data.');
    
    fileID = fopen([writedir,filesep,'octree_out.txt'],'w');
    fprintf(fileID,  '%u, %f, %f, %f, %f, %f\n', out_data' );
    fclose(fileID);
end

% [meshtilt,meshtip] = meshgrid(tilts,tips);
% SIinterp = interp2(positions_data(:,3),positions_data(:,4),SI.pks,tilts,tips);


% make next octree
if next_octree == 1
    writedir2 = [uigetdir(readdir,'Choose directory to write next level of Octree data.'),filesep];
    
    % choose here whether you use signal intensity (SI.best_data) or the
    % spatial derivative (dSI.best_data) for the next octree level
    [next_positions, next_abs_pos] = make_next_octree(SI.best_data,tilts,tips,params,writedir2);
end

%% fix mesh problems in case acq doesn't finish

SI.hold_matrix = zeros(numel(tilts),numel(tips));
dSI.hold_matrix = zeros(numel(tilts),numel(tips));

for ii = 1:numel(tilts)
    for jj = 1:numel(tips)
        try
            ind_search = find(input_pos_data(:,3) == tilts(ii) & input_pos_data(:,4) == tips(jj));
            SI.hold_matrix(ii,jj) = out_data(ind_search,5);
            dSI.hold_matrix(ii,jj) = out_data(ind_search,6);
        end
    end
end

%%
% [rowsout, colsout] = prep_for_subplot(nPos_in);
% SI.all_pks = reshape(SI.pks,numel(tilts),numel(tips));
% dSI.all_widths = reshape(dSI.widths,numel(tilts),numel(tips));
pp = figure(5);
for ii = 1:size(out_data,1)
subplot(3,3,ii)
hold on
yyaxis left
plot(data.z,data.SI(:,ii));
ylabel('SI [arb]')

yyaxis right
plot(data.dz,data.dSI(:,ii));

xlabel('z [um]')
ylabel('d(SI)/dz [um-1]')
end

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


