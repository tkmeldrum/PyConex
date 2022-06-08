% Process and combine multiple tilt/tip positions
% best position identified by FHWM as determined from Gaussian fit to
% spatial derivative of signal
% TKM, Oct 2021

clear
clc
close all

%% user defined parameters
topparams.gamma = 42.577;
topparams.G = 23.87;
topparams.zf = 4;

basedir = 'Z:\Data\LJK\PM5\June2022\TiltTip\OliveOil2Paper\Octree';
printdir = 'Z:\Data\LJK\PM5\June2022\TiltTip\OliveOil2Paper\';
append = ['A','B','C','D','E','F'];
for ii = 1:numel(append)
dirlist{ii} = [basedir append(ii) '\'];
end

output_list = readMultiTiltTipPositions(dirlist);
% ttc_array = [output_list(:).tilt; output_list(:).tip; output_list(:).centroid]';

% [B, ~, ib] = unique(ttc_array, 'rows');
% numoccurences = accumarray(ib, 1);
% indices = accumarray(ib, find(ib), [], @(rows){rows});

%%

ft = fittype( '-a*exp(-(x-c)^2/(2*s^2))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.1 0 10];
    
    
% for ii = 1:nPos_in
%     
%     
% %     FWHM(ii) = 2*sqrt(2*log(2))*aa(3);
% end

for ii = 1:numel(output_list)
    [echoVec{ii},z{ii},spatialdata{ii},timedata{ii},params(ii),~] = readKeaForFTT2(output_list(ii).dir,topparams.G,topparams.gamma,topparams.zf);
    int_spatial{ii} = abs(squeeze(sum(spatialdata{ii},2)));
    dSA{ii} = diff(int_spatial{ii})./diff(z{ii}');
    
    int_smoothed{ii} = smoothdata(int_spatial{ii},'gaussian',round(size(int_spatial{ii},1)/100));
    dSA_smoothed{ii} = diff(int_smoothed{ii})./diff(z{ii}');
    
    dz{ii} = z{ii}(2:end)'-(z{ii}(2)-z{ii}(1))/2;
    for jj = 1:size(dSA_smoothed{ii},2)
        [xData, yData] = prepareCurveData( dz{ii}, dSA_smoothed{ii}(:,jj) );
    
        % Fit model to data.
        [mdl, gof] = fit( xData, yData, ft, opts );
        fitvals = coeffvalues(mdl)';
        FWHM(ii,jj) = 2*sqrt(2*log(2))*fitvals(3);
    end
    
%     [pks(ii),locs(ii),widths(ii),proms(ii)] = findpeaks(int_spatial{ii},'SortStr','descend','NPeaks',1);
%     pks_norm(ii) = pks(ii)/sqrt(params(ii).nrScans);
end


%%
tilt = [output_list.tilt]';
tip = [output_list.tip]';
tiltlin = linspace(min(tilt),max(tilt),80);
tiplin = linspace(min(tip),max(tip),100);
% Now use these points to generate a uniformly spaced grid:

[TILT,TIP] = meshgrid(tiltlin,tiplin);
% The key to this process is to use scatteredInterpolant to interpolate the values of the function at the uniformly spaced points, based on the values of the function at the original data points (which are random in this example). This statement uses the default linear interpolation to generate the new data:

f = scatteredInterpolant(tilt,tip,FWHM);
FWHM_interp = f(TILT,TIP);


%%
close all

hh = figure(1);
hold on
surf(TILT,TIP,FWHM_interp)
scatter3(tilt,tip,FWHM-20,'r')
xlim([min(tilt) max(tilt)]);
ylim([min(tip) max(tip)]);
xlabel('TILT')
ylabel('TIP')
colormap(flipud(parula))
shading interp
view([90 -90])
title('Olive Oil, Paper2, Octree A-F')
pubgraph(hh)

print([printdir,'multiGrid.png'],'-dpng')