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
topparams.zf = 0;

basedir = '/Volumes/acstore-groups/ISC1026/Data/TKM/PM5/June2022/TiltTip/HotGlue/Octree';
printdir = '/Volumes/acstore-groups/ISC1026/Data/TKM/PM5/June2022/TiltTip/HotGlue/';
figtitle = 'Hot Glue, OctreeA2-D';
append = {'A';'A2';'B';'C';'D'};
for ii = 1:numel(append)
    dirlist{ii} = [basedir append{ii} filesep];
end

output_list = readMultiTiltTipPositions(dirlist);

% %% make octree grid image
%
nOctreeLevels = numel(output_list)/9;
tilts = [output_list.tilt];
tips = [output_list.tip];
tilts = reshape(tilts,9,nOctreeLevels);
tips = reshape(tips,9,nOctreeLevels);
%
%
tilt_vals = unique(tilts,'rows');
tilt_step = tilt_vals(2,:)-tilt_vals(1,:);
tip_vals = unique(tips,'rows');
tip_step = tip_vals(2,:)-tip_vals(1,:);
tilt_min = min(tilts)-tilt_step/2;
tip_min = min(tips)-tip_step/2;
tilt_max = max(tilts)+tilt_step/2;
tip_max = max(tips)+tip_step/2;
%
% for ii = 1:nOctreeLevels
%     [X,Y] = meshgrid(tilt_min(ii):tilt_step(ii):tilt_max(ii),...
%         tip_min(ii) :tip_step(ii) : tip_max(ii));
%     for jj = 1:9
%
%         tilt_boxes{ii}(jj,:) = X
%     end
% end


%%

ft = fittype( '-a*exp(-(x-c)^2/(2*s^2))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.1 0 10];
opts.Lower = [0 -Inf 0];


% for ii = 1:nPos_in
%
%
% %     FWHM(ii) = 2*sqrt(2*log(2))*aa(3);
% end

for ii = 1:numel(output_list)
    [echoVec{ii},z{ii},spatialdata{ii},timedata{ii},params(ii),~] = readKeaForFTT2(output_list(ii).dir,topparams.G,topparams.gamma,topparams.zf);
    int_spatial{ii} = abs(squeeze(sum(spatialdata{ii},2)));
    dSA{ii} = diff(int_spatial{ii})./diff(z{ii}');
    
    int_smoothed{ii} = smoothdata(int_spatial{ii},'gaussian',round(size(int_spatial{ii},1)/10));
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
% tiltlin = linspace(min(tilt),max(tilt),100);
% tiplin = linspace(min(tip),max(tip),100);

tiltlin = linspace(tilt_min(1),tilt_max(1),100);
tiplin = linspace(tip_min(1),tip_max(1),100);

% FWHMlin = linspace(min(FWHM),max(FWHM),100);
% Now use these points to generate a uniformly spaced grid:

[TILT,TIP] = meshgrid(tiltlin,tiplin);
% The key to this process is to use scatteredInterpolant to interpolate the values of the function at the uniformly spaced points, based on the values of the function at the original data points (which are random in this example). This statement uses the default linear interpolation to generate the new data:

f = scatteredInterpolant(tilt,tip,FWHM);

f.Method = 'natural';


FWHM_interp = f(TILT,TIP);



%%

[C,I] = min(FWHM);

contour_levels = round(min(FWHM),-1):10:round(max(FWHM),-1);

hh = figure(2);
hold on
contour3(TILT,TIP,FWHM_interp,contour_levels,'k','ShowText','on')
scatter3(tilt,tip,FWHM,'r')
scatter3(tilt(I),tip(I),FWHM(I),'filled','blue')
% quiver(TILT,TIP,FX,FY)
xlim([tilt_min(1) tilt_max(1)]);
ylim([tip_min(1) tip_max(1)]);
xlabel('TILT')
ylabel('TIP')
% view([90 -90])
title({figtitle; ['Best FWHM = ',num2str(round(FWHM(I),2)),' µm [',num2str(round(tilt(I),1)),'/',num2str(round(tip(I),1)),']']})
pubgraph(hh)

print([printdir,'multiContourGrid.png'],'-dpng')
%%
% close all

gg = figure(1);
hold on
surf(TILT,TIP,FWHM_interp)
scatter3(tilt,tip,FWHM+10,'r')
xlim([min(tilt) max(tilt)]);
ylim([min(tip) max(tip)]);
xlabel('TILT')
ylabel('TIP')
colormap(flipud(parula))
shading interp
% view([90 -90])
title(figtitle)
pubgraph(gg)

print([printdir,'multiSurfGrid.png'],'-dpng')