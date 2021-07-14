% fit original data for mininum
close all

[fitresult, gof] = twoDgaussian_tiptiltfit(tips, tilts, all_pks);
fitvals = coeffvalues(fitresult);
target_tip = fitvals(4);
target_tilt = fitvals(5);

% random selection
for ii = 5:numel(all_pks)
    for ll = 1:50
        pos_choose = randperm(numel(all_pks));
        pos_choose = pos_choose(1:ii);
        pos_selection = positions_data(pos_choose,:);
        tilts_selection = pos_selection(:,3);
        tips_selection = pos_selection(:,4);
        pks_selection = pks(pos_choose);

        [fitresult_selection, ~] = twoDgaussian_tiptiltfit(tips_selection, tilts_selection, pks_selection');
        fitvals_selection{ii-4} = coeffvalues(fitresult_selection);
        target_tip_selection(ii-4,ll) = fitvals_selection{ii-4}(4);
        target_tilt_selection(ii-4,ll) = fitvals_selection{ii-4}(5);
    end
end

% target_tilt_rms = abs(abs(target_tilt-target_tilt_selection)./target_tilt);
% target_tip_rms = abs(abs(target_tip-target_tip_selection)./target_tip);

tip_mean = mean(target_tip_selection,2);
tip_std = std(target_tip_selection,0,2);
tip_min = min(target_tip_selection,[],2);
tip_max = max(target_tip_selection,[],2);

tilt_mean = mean(target_tilt_selection,2);
tilt_std = std(target_tilt_selection,0,2);
tilt_min = min(target_tilt_selection,[],2);
tilt_max = max(target_tilt_selection,[],2);
%%
ind = 5:numel(all_pks);
ind_frac = ind/numel(all_pks);

hh = figure(1);
set(gcf,'Position',[132         191        1435         952])

subplot(1,2,1)
hold on
plot(ind_frac,tilt_mean,'-k')
plot(ind_frac,tilt_mean+tilt_std,'--k')
plot(ind_frac,tilt_mean-tilt_std,'--k')
plot(ind_frac,tilt_min,':k')
plot(ind_frac,tilt_max,':k')
line([0 1],target_tilt*[1, 1],'Color','red')
ylim([min(tilts) max(tilts)])
ylabel('tilt')
xlabel('frac of total space')

subplot(1,2,2)
hold on
plot(ind_frac,tip_mean,'-k')
plot(ind_frac,tip_mean+tilt_std,'--k')
plot(ind_frac,tip_mean-tilt_std,'--k')
plot(ind_frac,tip_min,':k')
plot(ind_frac,tip_max,':k')
line([0 1],target_tip*[1, 1],'Color','red')
ylim([min(tips) max(tips)])
ylabel('tip')
xlabel('frac of total space')

pubgraph(hh)

print([filedir,'2dsamplespace.png'],'-dpng')
