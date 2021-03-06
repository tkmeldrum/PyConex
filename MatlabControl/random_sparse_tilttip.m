function [z_final,z_pctstd,max_std,tilt_tip_stats] = random_sparse_tilttip(tilts,tips,all_pks,rand_frac,n_iter)

for ii = 1:n_iter
    sel = randperm(numel(all_pks),round(rand_frac*numel(all_pks)));
    hold_pks = nan(size(all_pks));
    hold_pks(sel) = all_pks(sel);
    hold_pks = fillmissing(hold_pks,'constant',median(hold_pks(:),'omitnan'));
    [z_recon(:,:,ii)] = low_pass_tilt_tip_filter(tilts,tips,hold_pks,0.05);
    z_temp = z_recon(:,:,ii);
    [~,peak_locs(ii)] = findpeaks(z_temp(:),'SortStr','descend','NPeaks',1);
    [row(ii),col(ii)] = ind2sub([numel(tilts),numel(tips)],peak_locs(ii));
    tilt_peak(ii) = tilts(row(ii));
    tip_peak(ii) = tips(col(ii));
end

z_final = squeeze(mean(z_recon,3));
z_pctstd = range(z_recon,3)./z_final; %std(z_recon,0,3)./z_final;
max_std = max(max(z_pctstd));

tilt_tip_stats = [mean(tilt_peak) std(tilt_peak) range(tilt_peak) mean(tip_peak) std(tip_peak) range(tip_peak)];
end