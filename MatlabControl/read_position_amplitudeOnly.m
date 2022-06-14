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
topparams.gamma = 42.577;
topparams.G = 23.87; 
topparams.zf = 4;
% topparams.ILTminmax = [1e-5 1e-1];
% topparams.nrILTSteps = 200;
% topparams.alpha = 1e7;
topparams.zlim = [-150 150];
topparams.actuator_lims = [0 12];
% topparams.kernel = 'exp(-h/T)';

% [output_positions_filename,filedir] = uigetfile('*.txt');

output_positions_filename = 'output_positions.txt';
filedir = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy168\OctreeA\';
writedir2 = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy168\OctreeB\';

% filedir = '/Volumes/ISC1026/Data/TKM/PM5/June2021/TipTilt/Sample249_auto/CPMG_series2/';
main_title = '4.62 mm Epoxy 168 A';
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

% include this only if you need to truncate data for incomplete
% acquisitions

% input_pos_data = input_pos_data(1:192,:);



tilts = unique(input_pos_data(:,3));
tips = unique(input_pos_data(:,4));
nPos_in = size(input_pos_data,1)
graph_order = sortrows(input_pos_data,3,'descend');

for ii = 1:size(input_pos_data,1)
    input_pos_data(ii,5) = find(input_pos_data(ii,3)==tilts);
    input_pos_data(ii,6) = find(input_pos_data(ii,4)==tips);
end


%% process data with FT
[rowsout, colsout] = prep_for_subplot(nPos_in);

for ii = 1:nPos_in
    filelist{ii} = [filedir,num2str(ii),filesep];
    [echoVec,z,spatialdata(:,:,ii),timedata(:,:,ii),params,~] = readKeaForFTT2(filelist{ii},topparams.G, topparams.gamma, topparams.zf);

%     [pks(ii),locs(ii),widths(ii),proms(ii)] = findpeaks(int_spatial(:,ii),'SortStr','descend','NPeaks',1);
%     for jj = 1:numel(z)
%         [spectrum(:,ii,jj),tau] = run_1DILT(abs(spatialdata(jj,:,ii)'),echoVec',topparams);
%         MLT2(ii,jj) = mean_log(tau',spectrum(:,ii,jj));
%     end
end

params.actuator_lims = topparams.actuator_lims;

%% get just signal intensity vs z, smooth, and get d(S)/dz

int_spatial = abs(squeeze(sum(spatialdata,2)));
int_smoothed = smoothdata(int_spatial,'gaussian',round(size(int_spatial,1)/100));
dSA_smoothed = diff(int_smoothed)./diff(z');
dSA = diff(int_spatial)./diff(z');
dz = z(2:end)'-(z(2)-z(1))/2;

%% fit derivative to gaussian for FWHM

% Set up fittype and options.
ft = fittype( '-a*exp(-(x-c)^2/(2*s^2))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.1 0 10];
opts.Lower = [0 -Inf 0];
    
    
for ii = 1:nPos_in
    
    [xData, yData] = prepareCurveData( dz, dSA_smoothed(:,ii) );
    
    [C,I] = min(dSA_smoothed(:,ii));
    opts.StartPoint = [-C dz(I) 10];
    % Fit model to data.
    [mdl{ii}, gof{ii}] = fit( xData, yData, ft, opts );
    fitvals(:,ii) = coeffvalues(mdl{ii})';
    fit_pred(:,ii) = feval(mdl{ii},dz);
%     FWHM(ii) = 2*sqrt(2*log(2))*aa(3);
end

[~,best_dSA_pos] = min(abs(fitvals(3,:))); 
best_dSA_data = positions_data(best_dSA_pos,:);

%% plot

kk= figure(6);
subplot(2,1,1)
hold on
plot(z,int_smoothed)
% plot(z,int_spatial,'--r')
xlim(topparams.zlim)

subplot(2,1,2)
hold on
plot(dz,dSA_smoothed)
xlim(topparams.zlim)
% plot(dz,dSA,'--r')

pubgraph(kk)


% close all

all_FWHM = reshape(fitvals(3,:),numel(tilts),numel(tips));

pp = figure(5);
hold on
plot(best_dSA_data(4),best_dSA_data(3),'r*')

surf(tips,tilts,all_FWHM);
shading interp
% set(gca,'YDir','reverse')
% view([0 90])

colormap(flipud(parula))
xlabel('tips [um]')
ylabel('tilts [um]')
title('based on FWHM')
pubgraph(pp)

%%
oo = figure(7);
for ii = 1:nPos_in
    subplot(rowsout, colsout,ii)
    hold on
    plot(dz,dSA_smoothed(:,ii))
    plot(dz,fit_pred(:,ii),'-r')
    ylim([min(min(dSA_smoothed)) max(max(dSA_smoothed))])
    title(num2str(ii))
end

qq = figure(8);
for ii = 1:nPos_in
    subplot(rowsout, colsout,ii)
    hold on
    plot(z,int_smoothed(:,ii))
%     plot(dz,fit_pred(:,ii),'-r')
    ylim([min(min(int_smoothed)) max(max(int_smoothed))])
    title(num2str(ii))
end



save([filedir,'processed_position_data_',datestr(now,'ddmmmyyyy'),'.mat']);

%%
best_dSA_pos = 6;
[next_positions, next_abs_pos] = make_next_octree(positions_data(best_dSA_pos,:),tilts,tips,params,writedir2);