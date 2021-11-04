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
gamma = 42.577;
G = 23.87; 
zf = 4;

[output_positions_filename,filedir] = uigetfile('*.txt');

% output_positions_filename = 'output_positions.txt';
% filedir = '/Volumes/ISC1026/Data/LJK/PM5/October2021/Sample249/Octree_TestA/';

% filedir = '/Volumes/ISC1026/Data/TKM/PM5/June2021/TipTilt/Sample249_auto/CPMG_series2/';
main_title = 'OctreeK';
showfigs = 0;
calc_next_octree = 0;
write_best_pos_info =0;
% best_pos_file = '/Volumes/ISC1026/Data/LJK/PM5/October2021/Sample249/best_position_datainput_positions.txt';

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

for ii = 1:size(input_pos_data,1)
    input_pos_data(ii,5) = find(input_pos_data(ii,3)==tilts);
    input_pos_data(ii,6) = find(input_pos_data(ii,4)==tips);
end

%% process data with FT
[rowsout, colsout] = prep_for_subplot(nPos_in);

for ii = 1:nPos_in
    filelist{ii} = [filedir,num2str(ii),filesep];
    [echoVec,z,spatialdata(:,:,ii),timedata(:,:,ii),params,~] = readKeaForFTT2(filelist{ii},G, gamma, zf);
    int_spatial(:,ii) = abs(squeeze(sum(spatialdata(:,:,ii),2)));
    dSA(:,ii) = diff(int_spatial(:,ii))./diff(z');
    [pks(ii),locs(ii),widths(ii),proms(ii)] = findpeaks(int_spatial(:,ii),'SortStr','descend','NPeaks',1);
end
dz = z(2:end)'-(z(2)-z(1))/2;

[~,bestINTPos] = max(max(int_spatial,[],1));
[~,bestdSAPos] = max(max(dSA,[],1));

best_INT_data = positions_data(bestINTPos,:)
best_dSA_data = positions_data(bestdSAPos,:)

%account for randomly omitted points
if nPos_in ~= numel(tilts)*numel(tips)
    all_pks = nan(numel(tilts),numel(tips));
    all_widths = nan(numel(tilts),numel(tips));
    for ii = 1:size(input_pos_data,1)
        all_pks(input_pos_data(ii,5),input_pos_data(ii,6)) = pks(ii);
        all_widths(input_pos_data(ii,5),input_pos_data(ii,6)) = widths(ii);
    end
else
    all_pks = reshape(pks,numel(tilts),numel(tips));
    all_widths = reshape(widths,numel(tilts),numel(tips));
end


tilt_centroid = sum(max(int_spatial).*positions_data(:,3)')./sum(max(int_spatial));
tip_centroid = sum(max(int_spatial).*positions_data(:,4)')./sum(max(int_spatial));

sprintf('Centroid = %3.0f µm tilt, %3.0f µm tip',tilt_centroid,tip_centroid)

%%

% rand_frac = 0;
% sel = randperm(numel(all_pks),round(rand_frac*numel(all_pks)));
% hold_pks = nan(size(all_pks));
% hold_pks(sel) = all_pks(sel);
% hold_pks = fillmissing(hold_pks,'constant',median(hold_pks(:),'omitnan'));
if nPos_in ~= numel(tilts)*numel(tips)
    all_pks_filled = fillmissing(all_pks,'constant',median(all_pks(:),'omitnan'));
    [z_recon,best_recon_pos] = low_pass_tilt_tip_filter(tilts,tips,all_pks_filled,0.05);
else
    [z_recon,best_recon_pos] = low_pass_tilt_tip_filter(tilts,tips,all_pks,0.05);
end

[pks_recon,locs_recon] = findpeaks(z_recon(:),'SortStr','descend','NPeaks',1);
% best_recon_data = positions_data(locs_recon,:);

%%
% best_recon_data = positions_data(best_recon_pos,:);
% [~,bestINTPos_recon] = max(max(z_recon,[],1));
close all

pp = figure(5);
subplot(1,2,1)
hold on
mesh(tips,tilts,all_pks); %,'FaceColor','none')
plot(best_INT_data(4),best_INT_data(3),'r*')
plot(best_dSA_data(4),best_dSA_data(3),'b*')
plot(tip_centroid,tilt_centroid,'g*')
shading interp
view([0 -90])
xlabel('tips [um]')
ylabel('tilts [um]')

subplot(1,2,2)
hold on
mesh(tips,tilts,z_recon); %,'FaceColor','none')
plot(best_INT_data(4),best_INT_data(3),'r*')
plot(best_dSA_data(4),best_dSA_data(3),'b*')
plot(tips(best_recon_pos(2)),tilts(best_recon_pos(1)),'k*');
plot(tip_centroid,tilt_centroid,'g*')
shading interp
% for ii = 1:size(best_recon_data,1)
%     plot(best_recon_data(ii,4),best_recon_data(ii,3),'k*');
% end
view([0 -90])
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
if nPos_in == numel(tilts)*numel(tips)
%     close all
    n_steps = 20;
    oo = figure(1);
    for lll = 1:n_steps-1
        
        [z_final,z_std,max_std,tilt_tip_stats(lll,:)] = random_sparse_tilttip(tilts,tips,all_pks,lll/n_steps,100);
        subplot(floor(sqrt(n_steps)),n_steps/floor(sqrt(n_steps)),lll)
        hold on
        surf(tips,tilts,z_std)
        colormap(flipud(gray))
        % caxis reverse
        if lll == 1
            cl = caxis;
        end
        if lll == n_steps
            colorbar
        end
        title(['frac=',num2str(lll/n_steps),', max=',num2str(max_std)])
        caxis([0 max(cl)])
        shading interp
        contour(tips,tilts,z_final,10,'-r')
        
        view([0 -90])
        xlabel('tips [um]')
        ylabel('tilts [um]')
    end
    sgtitle('Sparse, random subset of tilt/tip space; std/mean frac')
    pubgraph(oo)
    
end
%%
if showfigs == 1
    dSAylims = [min(min(dSA,[],1)) max(max(dSA,[],1))];
    dINTylims = [min(min(int_spatial,[],1)) max(max(int_spatial,[],1))];
    hh = figure(1);
    for ii = 1:nPos_in
        subplot(numel(tilts),numel(tips),ii)
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
        text(400,dINTylims(2),[num2str(graph_order(ii,1))],'Color','r');
    end
    pubgraph(hh)
    
    gg = figure(2);
    for ii = 1:nPos_in
        subplot(numel(tilts),numel(tips),ii)
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

%%
if calc_next_octree == 1
    next_Octree_ind = 5;
    params.actuator_lims = [0 11.9];
    writedir2 = [uigetdir(filedir,'Choose directory to write next level of Octree data.'),filesep];
    [next_positions, next_abs_pos] = make_next_octree(input_pos_data(next_Octree_ind,:),...
        tilts,tips,params,writedir2);
end

%%
if write_best_pos_info == 1
    formatSpec = '%s\n Best INT data = Ind %u, Centroid = %6.4f mm, Tilt = %6.4f µm, Tip = %6.4f\n Best dSA data = Ind %u, Centroid = %6.4f mm, Tilt = %6.4f µm, Tip = %6.4f\n\n';
    
    fileID = fopen(best_pos_file,'a');
    fprintf(fileID,  formatSpec, main_title, best_INT_data, best_dSA_data );
    fclose(fileID);
end

%%
tilt_centroid = sum(sum(normalize(int_spatial,'range'),1).*positions_data(:,3)')./sum(sum(normalize(int_spatial,'range')));
tip_centroid = sum(sum(normalize(int_spatial,'range'),1).*positions_data(:,4)')./sum(sum(normalize(int_spatial,'range')));