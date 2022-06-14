clear
clc
close all

params.zf = 4;
params.gamma = 42.577; %MHz/T
params.G = 23.87; %T/m
T2kernel = 'exp(-h/T)';
figdir = '/Volumes/acstore-groups/ISC1026/Data/TKM/PM5/June2022/TiltTip/HotGlue/CPMG_ONOFF3/';

dirname = '/Volumes/acstore-groups/ISC1026/Data/TKM/PM5/June2022/TiltTip/HotGlue/CPMG_ONOFF3/ON/';
ON = runmultipleonoff_tilttip(dirname,params,T2kernel);

dirname = '/Volumes/acstore-groups/ISC1026/Data/TKM/PM5/June2022/TiltTip/HotGlue/CPMG_ONOFF3/OFF/';
OFF = runmultipleonoff_tilttip(dirname,params,T2kernel);

%%
hh = figure(1);
set(gcf,'Position',[1 1 560  800])
subplot(2,1,2)
hold on
for ii = 1:ON.nDir
    contour(ON.z_vec,ON.tauh,squeeze(ON.spectrum(:,:,ii)),'red','LineWidth',0.5)
end
plot(ON.z_vec,ON.MLT2,'--r','LineWidth',1)
plot(ON.z_vec,ON.meanMLT2,'-r','LineWidth',2)
for ii = 1:OFF.nDir
    contour(OFF.z_vec,OFF.tauh,squeeze(OFF.spectrum(:,:,ii)),'black')
end
plot(OFF.z_vec,OFF.MLT2,'--k','LineWidth',1)
plot(OFF.z_vec,OFF.meanMLT2,'-k','LineWidth',2)
set(gca,'YScale','log')
xlabel('position [µm]')
xlim([0 75])
% xlim(ON.params.zlims)
ylabel('T2 [s]')

% pubgraph(hh)
% print([figdir,'ONOFFcomp.png'],'-dpng');

% gg = figure(2);
subplot(2,1,1)
hold on
plot(ON.z,sum(abs(ON.spatialdata(:,:,2)),2),'-r')
plot(OFF.z,sum(abs(OFF.spatialdata(:,:,2)),2),'-k')
% plot(ON.z_vec,log10(ON.meanMLT2)-log10(OFF.meanMLT2),'-k','LineWidth',2)
% line(ON.params.zlims,[0 0],'Color','blue')
% xlabel('position [µm]')
% xlim(ON.params.zlims)
xlim([0 75])
% ylabel('log10 excess T2 (ON-OFF) [s]')
pubgraph(hh)

% print([figdir,'ONOFFcomp.png'],'-dpng');