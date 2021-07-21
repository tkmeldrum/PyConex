function [data,SI,dSI] = read_octreeCPMG_series(filedir,params)

for ii = 1:params.nPos_in
    [data.echoVec,data.z,data.spatialdata(:,:,ii),data.timedata(:,:,ii),params,~] =...
        readKeaForFTT2([filedir,num2str(ii),filesep],params);
end

data.z = data.z';

data.SI = abs(squeeze(sum(data.spatialdata,2)));
[~,SI.bestPos] = max(max(data.SI,[],1));

data.dSI = diff(data.SI)./diff(data.z);
data.dz = data.z(2:end)-(data.z(2)-data.z(1))/2;

[~,dSI.bestPos] = max(max(data.dSI,[],1));

for ii = 1:params.nPos_in
    [SI.pks(ii),SI.locs(ii),SI.widths(ii),SI.proms(ii)] = findpeaks(data.SI(:,ii),'SortStr','descend','NPeaks',1);
    [dSI.pks(ii),dSI.locs(ii),dSI.widths(ii),dSI.proms(ii)] = findpeaks(data.dSI(:,ii),'SortStr','descend','NPeaks',1);
end


