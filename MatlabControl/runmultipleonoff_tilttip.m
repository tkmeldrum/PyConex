function [data] = runmultipleonoff_tilttip(dirname,params,T2kernel)

data.nDir = count_directories(dirname);

for ii = 1:data.nDir
    fulldir = [dirname num2str(ii) filesep];
    [data.echoVec,data.z,data.spatialdata(:,:,ii),data.timedata(:,:,ii),data.params] = readKeaForFTT2(fulldir,params.G, params.gamma, params.zf);
end

data.params.T2_minmax = [1e-4 1e1];
data.params.T2_steps = 120;
data.params.alpha = 1e8;
data.params.zlims = [-50 50];

data.params.z_ind = [find(data.z<data.params.zlims(1),1,'last') find(data.z>data.params.zlims(2),1,'first')];
data.z_vec = data.z(data.params.z_ind(1):data.params.z_ind(2))';

% remove y-offset

offset_frac = 0.15;
ft = fittype( 'A*(exp(-x/T2))+y0', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf 0 -Inf];
opts.StartPoint = [0.6 0.03 0.15];

%%
for jj = 1:data.nDir
    for ii = 1:range(data.params.z_ind)+1
        offset_range = [numel(data.echoVec)-round(offset_frac*numel(data.echoVec)) numel(data.echoVec)];
        offset = mean(abs(data.spatialdata(ii+data.params.z_ind(1)-1,offset_range,jj)));
        [data.spectrum(:,ii,jj),data.tauh]=upnnlsmooth1D(abs(data.spatialdata(ii+data.params.z_ind(1)-1,:,jj)')-offset,data.echoVec',...
            data.params.T2_minmax(1),data.params.T2_minmax(2),data.params.alpha,-1,min(data.params.T2_steps,data.params.nrEchoes),T2kernel);
        
        [xData, yData] = prepareCurveData( data.echoVec, abs(data.spatialdata(ii+data.params.z_ind(1)-1,:,jj)) );
        [fitresult, gof] = fit( xData, yData, ft, opts );
        aa = coeffvalues(fitresult);
        ci = range(confint(fitresult))/2;
        data.monoexp.A(ii,jj) = aa(1);
        data.monoexp.Aci(ii,jj) = ci(1);
        data.monoexp.T2(ii,jj) = aa(2);
        data.monoexp.T2ci(ii,jj) = ci(2);
        data.monoexp.y0(ii,jj) = aa(3);
        data.monoexp.y0ci(ii,jj) = ci(3);
        data.monoexp.rmse(ii,jj) = gof.rmse;
        
    end
    data.MLT2(:,jj) = mean_log(data.tauh',data.spectrum(:,:,jj));
end



data.meanMLT2 = 10.^mean(log10(data.MLT2),2,'omitnan');

end
