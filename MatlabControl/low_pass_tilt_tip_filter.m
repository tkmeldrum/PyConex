function [z_recon,best_recon_pos] = low_pass_tilt_tip_filter(tilts,tips,all_pks,FWHMf)
xgrid = tilts;
ygrid = tips';
z = all_pks;

z_filt = exp(-(((1:numel(xgrid))-(numel(xgrid)+1)/2).^2/(FWHMf*round(numel(xgrid))^2/(4*log(2)))+...
               ((1:numel(ygrid))'-(numel(ygrid)+1)/2).^2/(FWHMf*round(numel(ygrid))^2/(4*log(2)))));
           
% if rand_frac < 1
%    sel = randi(numel(all_pks),round(rand_frac*numel(all_pks)),1);
% %    [row,col] = ind2sub(size(all_pks),sel);
%    hold_pks = nan(size(all_pks));
%    hold_pks(sel) = all_pks(sel);
%    hold_pks = interp2(xgrid,ygrid,hold_pks,xgrid,ygrid);
%     
% end
% xspread = max(1,round(numel(xgrid)/10));
% yspread = max(1,round(numel(ygrid)/10));

Fz = fftshift(fft2(z));
% gg = figure(2);
% surf(abs(Fz));
% shading flat

% [~,I] = max(abs(Fz),[],'all','linear');
% [row,col] = ind2sub(size(Fz),I);

% z_filt = zeros(size(Fz));
% z_filt(row-xspread:row+xspread,col-yspread:col+yspread) = ones(2*xspread+1,2*yspread+1);
z_recon = abs(ifft2(Fz.*z_filt'));

[~,I] = max(z_recon,[],'all','linear');
[row,col] = ind2sub(size(Fz),I);
best_recon_pos = [row,col];