function [data] = runmultipleonoff_tilttip(dirname,params,T2kernel)

data.nDir = count_directories(dirname);

for ii = 1:data.nDir
    fulldir = [dirname num2str(ii) filesep];
    [data.echoVec,data.z,data.spatialdata(:,:,ii),data.timedata(:,:,ii),data.params] = readKeaForFTT2(fulldir,params.G, params.gamma, params.zf);
end


data.params.T2_minmax = [1e-4 1e0];
data.params.T2_steps = 120;
data.params.alpha = 1e8;
data.params.zlims = [-50 50];

data.params.z_ind = [find(data.z<data.params.zlims(1),1,'last') find(data.z>data.params.zlims(2),1,'first')];
data.z_vec = data.z(data.params.z_ind(1):data.params.z_ind(2))';

% remove y-offset

offset_frac = 0.15;
ft_mono = fittype( 'A*(exp(-x/T2))+y0', 'independent', 'x', 'dependent', 'y' );
ft_bi = fittype( 'A*(a*exp(-x/T21) + (1-a)*exp(-x/T22))+y0', 'independent', 'x', 'dependent', 'y' );
monoopts = fitoptions( 'Method', 'NonlinearLeastSquares' );
monoopts.Display = 'Off';
monoopts.Lower = [-Inf 0 -Inf];
monoopts.StartPoint = [0.6 0.03 0.15];

biopts = fitoptions( 'Method', 'NonlinearLeastSquares' );
biopts.Display = 'Off';
biopts.Lower = [-Inf -Inf -Inf 0 0];
biopts.StartPoint = [0.85 0.01 0.1 1 0];
biopts.Upper = [Inf Inf Inf 1 Inf];

%%
for jj = 1:data.nDir
    for ii = 1:range(data.params.z_ind)+1
        offset_range = [numel(data.echoVec)-round(offset_frac*numel(data.echoVec)) numel(data.echoVec)];
        offset = mean(abs(data.spatialdata(ii+data.params.z_ind(1)-1,offset_range,jj)));
        [data.spectrum(:,ii,jj),data.tauh]=upnnlsmooth1D(abs(data.spatialdata(ii+data.params.z_ind(1)-1,:,jj)')-offset,data.echoVec',...
            data.params.T2_minmax(1),data.params.T2_minmax(2),data.params.alpha,-1,min(data.params.T2_steps,data.params.nrEchoes),T2kernel);
        
        [xData, yData] = prepareCurveData( data.echoVec, abs(data.spatialdata(ii+data.params.z_ind(1)-1,:,jj)) );
        try
            [monofitresult, monogof] = fit( xData, yData, ft_mono, monoopts );
            [bifitresult, bigof] = fit( xData, yData, ft_bi, biopts );
            
            aa = coeffvalues(monofitresult);
            ci = range(confint(monofitresult))/2;
            data.monoexp.A(ii,jj) = aa(1);
            data.monoexp.Aci(ii,jj) = ci(1);
            data.monoexp.T2(ii,jj) = aa(2);
            data.monoexp.T2ci(ii,jj) = ci(2);
            data.monoexp.y0(ii,jj) = aa(3);
            data.monoexp.y0ci(ii,jj) = ci(3);
            data.monoexp.rmse(ii,jj) = monogof.rmse;
            
            bb = coeffvalues(bifitresult);
            ci = range(confint(bifitresult))/2;
            data.biexp.A(ii,jj) = bb(1);
            data.biexp.Aci(ii,jj) = ci(1);
            data.biexp.T21(ii,jj) = bb(2);
            data.biexp.T21ci(ii,jj) = ci(2);
            data.biexp.T22(ii,jj) = bb(3);
            data.biexp.T22ci(ii,jj) = ci(3);
            data.biexp.a(ii,jj) = bb(4);
            data.biexp.aci(ii,jj) = ci(4);
            data.biexp.y0(ii,jj) = bb(5);
            data.biexp.y0ci(ii,jj) = ci(5);
            data.biexp.rmse(ii,jj) = bigof.rmse;
        end
        
    end
    data.MLT2(:,jj) = mean_log(data.tauh',data.spectrum(:,:,jj));
end



data.meanMLT2 = 10.^mean(log10(data.MLT2),2,'omitnan');

if data.nDir > 1
    data.meantimedata = mean(data.timedata,3);
    [~,data.meanspatialdata] = echoFT(data.params,data.meantimedata);
    for ii = 1:range(data.params.z_ind)+1
        [data.meanspectrum(:,ii)]=upnnlsmooth1D(abs(data.meanspatialdata(ii+data.params.z_ind(1)-1,:)'),data.echoVec',...
            data.params.T2_minmax(1),data.params.T2_minmax(2),data.params.alpha,-1,min(data.params.T2_steps,data.params.nrEchoes),T2kernel);
    end
end

end
