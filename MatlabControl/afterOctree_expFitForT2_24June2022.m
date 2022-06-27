z_ind = [find(z<topparams.zlim(1),1,'last') find(z>topparams.zlim(2),1,'first')];
z_vec = z(z_ind(1):z_ind(2))';


ft_bi = fittype( 'A*(a*exp(-x/T21) + (1-a)*exp(-x/T22))+y0', 'independent', 'x', 'dependent', 'y' );
ft_mono = fittype( 'A*(exp(-x/T2))+y0', 'independent', 'x', 'dependent', 'y' );

monoopts = fitoptions( 'Method', 'NonlinearLeastSquares' );
monoopts.Display = 'Off';
monoopts.Robust = 'Bisquare';
monoopts.Lower = [-Inf 0 -Inf];
monoopts.StartPoint = [0.6 0.03 0.15];

opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.Lower = [0 0 0 0 -Inf];
opts.StartPoint = [0.75 0.001 0.1 0.5 0];
opts.Upper = [Inf 0.05 1 1 Inf];

for jj = 1:9
    for ii = 1:1:range(z_ind)+1
        [xData, yData] = prepareCurveData( echoVec, abs(spatialdata(ii+z_ind(1)-1,:,jj)) );
        
        [monofitresult, monogof] = fit( xData, yData, ft_mono, monoopts );
           
            
            aa = coeffvalues(monofitresult);
            ci = range(confint(monofitresult))/2;
            monoexp.A(ii,jj) = aa(1);
            monoexp.Aci(ii,jj) = ci(1);
            monoexp.T2(ii,jj) = aa(2);
            monoexp.T2ci(ii,jj) = ci(2);
            monoexp.y0(ii,jj) = aa(3);
            monoexp.y0ci(ii,jj) = ci(3);
            monoexp.rmse(ii,jj) = monogof.rmse;
%         [bifitresult, bigof] = fit( xData, yData, ft_bi, opts );
        
%         bb = coeffvalues(bifitresult);
%         ci = range(confint(bifitresult))/2;
%         biexp.A(ii,jj) = bb(1);
%         biexp.Aci(ii,jj) = ci(1);
%         biexp.T21(ii,jj) = bb(2);
%         biexp.T21ci(ii,jj) = ci(2);
%         biexp.T22(ii,jj) = bb(3);
%         biexp.T22ci(ii,jj) = ci(3);
%         biexp.a(ii,jj) = bb(4);
%         biexp.aci(ii,jj) = ci(4);
%         biexp.y0(ii,jj) = bb(5);
%         biexp.y0ci(ii,jj) = ci(5);
%         biexp.rmse(ii,jj) = bigof.rmse;
    end
end


%%
T2_spatial = log10(monoexp.T2);
T2_smoothed = smoothdata(T2_spatial,'gaussian',round(size(T2_spatial,1)/10));
dT2_smoothed = diff(T2_smoothed)./diff(z_vec);
dT2 = diff(T2_spatial)./diff(z_vec);
dz_vec = z_vec(2:end)-(z_vec(2)-z_vec(1))/2;    
optsGaussian.Lower = [0 min(z_vec) 0];
optsGaussian.Upper = [Inf max(z_vec) range(z_vec)];
    
for ii = 1:nPos_in
    
    [xData, yData] = prepareCurveData( dz_vec, dT2_smoothed(:,ii) );
    
    [C,I] = max(dT2_smoothed(:,ii));
    optsGaussian.StartPoint = [C 0 10];
    % Fit model to data.
    [T2mdl{ii}, T2gof{ii}] = fit( xData, yData, ft_gaussian, optsGaussian );
    T2fitvals(:,ii) = coeffvalues(T2mdl{ii})';
    T2fit_pred(:,ii) = feval(T2mdl{ii},dz_vec);
%     FWHM(ii) = 2*sqrt(2*log(2))*aa(3);
end


oo = figure(7);
for ii = 1:nPos_in
    subplot(rowsout, colsout,ii)
    hold on
%     plot(z_vec,T2_smoothed(:,ii))
    plot(dz_vec,dT2_smoothed(:,ii))
    plot(dz_vec,T2fit_pred(:,ii),'-r')
%     ylim([min(min(dT2_smoothed)) 1e-1])
%     set(gca,'YScale','log')
    title(num2str(ii))
end

qq = figure(8);
for ii = 1:nPos_in
    subplot(rowsout, colsout,ii)
    hold on
    plot(z_vec,T2_smoothed(:,ii))
%     plot(dz,fit_pred(:,ii),'-r')
    ylim([min(min(T2_smoothed)) max(max(T2_smoothed))])
    title(num2str(ii))
end


%%
save([filedir,'processed_position_data_',datestr(now,'ddmmmyyyy'),'.mat']);
%%

load('Z:\Data\TKM\PM5\June2022\ABS\TiltTipHotGlue\OctreeA2\processed_position_data_25Jun2022.mat');
%%
close all

% ppp = figure(4);
% for ii = 1:9
%     subplot(3,3,ii)
%     hold on
%     plot(z_vec,biexp.T21(:,ii),'-k')
%     plot(z_vec,biexp.T22(:,ii),'-r')
%     set(gca,'YScale','log')
%     xlim(topparams.zlim)
% end

qqq = figure(5);
for ii = 1:9
    subplot(3,3,ii)
    hold on
    plot(z_vec,monoexp.T2(:,ii),'-k')
%     plot(z_vec,biexp.T22(:,ii),'-r')
    set(gca,'YScale','log')
    ylim([1e-4 1e-2])
    xlim(topparams.zlim)
end
