function [data] = runmultipleonoff_tilttip(dirname,params,T2kernel)

data.nDir = count_directories(dirname);

for ii = 1:data.nDir
    fulldir = [dirname num2str(ii) filesep];
    [data.echoVec,data.z,data.spatialdata(:,:,ii),data.timedata(:,:,ii),data.params] = readKeaForFTT2(fulldir,params.G, params.gamma, params.zf);
end

data.params.T2_minmax = [1e-3 1e0];
data.params.T2_steps = 100;
data.params.alpha = 1e8;
data.params.zlims = [-100 100];

data.params.z_ind = [find(data.z<data.params.zlims(1),1,'last') find(data.z>data.params.zlims(2),1,'first')];
data.z_vec = data.z(data.params.z_ind(1):data.params.z_ind(2))';

%%
for jj = 1:data.nDir
    for ii = 1:range(data.params.z_ind)+1
        [data.spectrum(:,ii,jj),data.tauh]=upnnlsmooth1D(abs(data.spatialdata(ii+data.params.z_ind(1)-1,:,jj)'),data.echoVec',...
            data.params.T2_minmax(1),data.params.T2_minmax(2),data.params.alpha,-1,min(data.params.T2_steps,data.params.nrEchoes),T2kernel);
    end
    data.MLT2(:,jj) = mean_log(data.tauh',data.spectrum(:,:,jj));
end



data.meanMLT2 = 10.^mean(log10(data.MLT2),2);

end
