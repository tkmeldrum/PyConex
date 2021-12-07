clear
clc
close all

load('/Volumes/acstore-groups/ISC1026/Data/LJK/PM5/December2021/Sample231/TiltTipCheck/processed_position_data_07Dec2021.mat');
dMLT2 = diff(MLT2');

topparams.zlim = [-100 50];
%%
close all

loopinds = 1:11; %for changing tilt

hh = figure(1);
pubgraph(hh)
subplot(2,2,1)
hold on
for ii = 1:numel(loopinds)
    plot(z,int_spatial(:,loopinds(ii))','LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(z,int_spatial(:,loopinds(ii)),'-k','LineWidth',2)
    end
end
% set(gca,'YScale','log')
xlim(topparams.zlim)
xlabel('position [µm]')
ylabel('sig intensity')
% ylim(topparams.ILTminmax)

subplot(2,2,3)
hold on
for ii = 1:numel(loopinds)
    plot(dz,dSA(:,loopinds(ii)),'LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(dz,dSA(:,loopinds(ii)),'-k','LineWidth',1.5)
    end
end
% set(gca,'YScale','log')
xlim(topparams.zlim)
ylabel('d(SI)/dz')
xlabel('position [µm]')
% ylim(topparams.ILTminmax)


subplot(2,2,2)
hold on
for ii = 1:numel(loopinds)
    plot(z,MLT2(loopinds(ii),:)','LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(z,MLT2(loopinds(ii),:)','-k','LineWidth',2)
    end
end
set(gca,'YScale','log')
xlim(topparams.zlim)
xlabel('position [µm]')
ylabel('MLT2 [s]')
ylim(topparams.ILTminmax)

subplot(2,2,4)
hold on
for ii = 1:numel(loopinds)
    plot(dz,dMLT2(:,loopinds(ii)),'LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(dz,dMLT2(:,loopinds(ii)),'-k','LineWidth',2)
    end
end
% set(gca,'YScale','log')
xlim(topparams.zlim)
ylabel('d(MLT2)/dz')
xlabel('position [µm]')
ylim([-2e-4 2e-4])

sgtitle('changing tilt')

%%

% close all

loopinds = 12:22; %for changing tip

gg = figure(2);
pubgraph(gg)
subplot(2,2,1)
hold on
for ii = 1:numel(loopinds)
    plot(z,int_spatial(:,loopinds(ii))','LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(z,int_spatial(:,loopinds(ii)),'-k','LineWidth',2)
    end
end
% set(gca,'YScale','log')
xlim(topparams.zlim)
xlabel('position [µm]')
ylabel('sig intensity')
% ylim(topparams.ILTminmax)

subplot(2,2,3)
hold on
for ii = 1:numel(loopinds)
    plot(dz,dSA(:,loopinds(ii)),'LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(dz,dSA(:,loopinds(ii)),'-k','LineWidth',1.5)
    end
end
% set(gca,'YScale','log')
xlim(topparams.zlim)
ylabel('d(SI)/dz')
xlabel('position [µm]')
% ylim(topparams.ILTminmax)


subplot(2,2,2)
hold on
for ii = 1:numel(loopinds)
    plot(z,MLT2(loopinds(ii),:)','LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(z,MLT2(loopinds(ii),:)','-k','LineWidth',2)
    end
end
set(gca,'YScale','log')
xlim(topparams.zlim)
xlabel('position [µm]')
ylabel('MLT2 [s]')
ylim(topparams.ILTminmax)

subplot(2,2,4)
hold on
for ii = 1:numel(loopinds)
    plot(dz,dMLT2(:,loopinds(ii)),'LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(dz,dMLT2(:,loopinds(ii)),'-k','LineWidth',2)
    end
end
% set(gca,'YScale','log')
xlim(topparams.zlim)
ylabel('d(MLT2)/dz')
xlabel('position [µm]')
ylim([-2e-4 2e-4])

sgtitle('changing tip')

%%
close(mm)
mm = figure(3);
set(gcf,'Position',[100 960 2000 200])
pubgraph(mm)
% subplot(2,1,1)
loopinds = 1:11;
% zshift = -50:10:50;

tiledlayout(1,numel(loopinds), 'Padding', 'none', 'TileSpacing', 'compact');
for ii = 1:numel(loopinds)
    %     subplot(1,numel(loopinds),ii)
    nexttile
    yyaxis left
    plot(z,MLT2(loopinds(ii),:)','LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(z,MLT2(loopinds(ii),:)','LineWidth',1.5)
    end
    if ii == 1
        ylabel('MLT2 [s]')
    end
    ylim([1e-5 1e-2])
    set(gca,'YScale','log')
    
    hold on
    yyaxis right
    plot(dz,dMLT2(:,loopinds(ii)),'LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(dz,dMLT2(:,loopinds(ii)),'LineWidth',1.5)
    end
    if ii == numel(loopinds)
        ylabel('d(MLT2)/dz')
    end
    ylim([-8e-4 20e-4])
    % set(gca,'YScale','log')
    xlim(topparams.zlim)
    
    xlabel('position [µm]')
    title([num2str(input_pos_data(loopinds(ii),3)),' µm']);
end
sgtitle('tilts')

print([filedir,'tilt_comp.png'],'-dpng');
print([filedir,'tilt_comp.eps'],'-depsc2');

close(nn)
nn = figure(4);
set(gcf,'Position',[100 860 2000 200])
pubgraph(nn)
% subplot(2,1,1)
loopinds = 12:22;
% zshift = -50:10:50;

tiledlayout(1,numel(loopinds), 'Padding', 'none', 'TileSpacing', 'compact');
for ii = 1:numel(loopinds)
    %     subplot(1,numel(loopinds),ii)
    nexttile
    yyaxis left
    plot(z,MLT2(loopinds(ii),:)','LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(z,MLT2(loopinds(ii),:)','LineWidth',1.5)
    end
    if ii == 1
        ylabel('MLT2 [s]')
    end
    ylim([1e-5 1e-2])
    set(gca,'YScale','log')
    
    hold on
    yyaxis right
    plot(dz,dMLT2(:,loopinds(ii)),'LineWidth',1)
    if ii == (numel(loopinds)-1)/2+1
        plot(dz,dMLT2(:,loopinds(ii)),'LineWidth',1.5)
    end
    if ii == numel(loopinds)
        ylabel('d(MLT2)/dz')
    end
    ylim([-8e-4 20e-4])
    % set(gca,'YScale','log')
    xlim(topparams.zlim)
    
    xlabel('position [µm]')
    title([num2str(input_pos_data(loopinds(ii),4)),' µm']);
end
sgtitle('tips')
print([filedir,'tip_comp.png'],'-dpng');
print([filedir,'tip_comp.eps'],'-depsc2');
