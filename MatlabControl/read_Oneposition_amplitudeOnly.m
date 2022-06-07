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
topparams.zf = 2;
topparams.zlim = [-75 75];

filedir = '/Volumes/acstore-groups/ISC1026/Data/LJK/PM5/June2022/TiltTip/OliveOil/CPMG_ONOFFREV/ON/';
main_title = '4.44 mm Olive Oil ON';

nDir = count_directories(filedir);

%% process data with FT
for ii = 1:nDir
    [echoVec,z,spatialdata(:,:,ii),timedata(:,:,ii),params,~] = readKeaForFTT2([filedir,num2str(ii),filesep],topparams.G, topparams.gamma, topparams.zf);

end
%% get just signal intensity vs z, smooth, and get d(S)/dz

int_spatial = abs(squeeze(sum(spatialdata,2)));
int_smoothed = smoothdata(int_spatial,'gaussian',round(size(int_spatial,1)/200));
dSA_smoothed = diff(int_smoothed)./diff(z');
dSA = diff(int_spatial)./diff(z');
dz = z(2:end)'-(z(2)-z(1))/2;

%% fit derivative to gaussian for FWHM

% Set up fittype and options.
ft = fittype( '-a*exp(-(x-c)^2/(2*s^2))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.1 0 10];

for ii = 1:nDir
    [xData, yData] = prepareCurveData( dz, dSA_smoothed(:,ii) );
    
    % Fit model to data.
    [mdl{ii}, gof{ii}] = fit( xData, yData, ft, opts );
    fitvals(:,ii) = coeffvalues(mdl{ii})';
end
FWHM = 2*sqrt(2*log(2)).*fitvals(3,:);

%% plot

kk= figure(6);
subplot(2,1,1)
hold on
plot(z,int_smoothed)
xlim(topparams.zlim)
ylabel('signal intensity')
% xlabel('position [um]')

subplot(2,1,2)
hold on
plot(dz,dSA_smoothed)
xlim(topparams.zlim)
ylabel('d(SI)/dz [um^{-1}]')
xlabel('position [um]')

sgtitle(main_title)
pubgraph(kk)
% print([filedir,main_title,'.png'],'-dpng');