function [z_final,z_pctstd,max_std] = random_sparse_tilttip(tilts,tips,all_pks,rand_frac,n_iter)

for ii = 1:n_iter
    sel = randperm(numel(all_pks),round(rand_frac*numel(all_pks)));
    hold_pks = nan(size(all_pks));
    hold_pks(sel) = all_pks(sel);
    hold_pks = fillmissing(hold_pks,'constant',median(hold_pks(:),'omitnan'));
    [z_recon(:,:,ii)] = low_pass_tilt_tip_filter(tilts,tips,hold_pks,0.05);
end

z_final = squeeze(mean(z_recon,3));
z_pctstd = range(z_recon,3)./z_final; %std(z_recon,0,3)./z_final;
max_std = max(max(z_pctstd));
end