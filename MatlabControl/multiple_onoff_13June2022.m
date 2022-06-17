clear
clc
close all

params.zf = 2;
params.gamma = 42.577; %MHz/T
params.G = 23.87; %T/m
T2kernel = 'exp(-h/T)';
figdir = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy31\CPMG_ONOFFBAD1\';

dirname = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy31\CPMG_ONOFFBAD1\ON\';
ON = runmultipleonoff_tilttip(dirname,params,T2kernel);

dirname = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy31\CPMG_ONOFFBAD1\OFF\';
OFF = runmultipleonoff_tilttip(dirname,params,T2kernel);

dirname = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy31\CPMG_ONOFFBAD1\REV\';
REV = runmultipleonoff_tilttip(dirname,params,T2kernel);

dirname = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy31\CPMG_ONOFFBAD1\BAD\';
BAD = runmultipleonoff_tilttip(dirname,params,T2kernel);

%%
hh = figure(1);
set(gcf,'Position',[1 1 560  800])
subplot(2,1,2)
hold on
for ii = 1:ON.nDir
    contour(ON.z_vec,ON.tauh,squeeze(ON.spectrum(:,:,ii)),'red','LineWidth',0.5)
end
plot(ON.z_vec,ON.MLT2,':r','LineWidth',1)
plot(ON.z_vec,ON.meanMLT2,'-r','LineWidth',2)

for ii = 1:OFF.nDir
    contour(OFF.z_vec,OFF.tauh,squeeze(OFF.spectrum(:,:,ii)),'black')
end
plot(OFF.z_vec,OFF.MLT2,':k','LineWidth',1)
plot(OFF.z_vec,OFF.meanMLT2,'-k','LineWidth',2)

for ii = 1:REV.nDir
    contour(REV.z_vec,REV.tauh,squeeze(REV.spectrum(:,:,ii)),'blue','LineWidth',0.5)
end
plot(REV.z_vec,REV.MLT2,':b','LineWidth',1)
plot(REV.z_vec,REV.meanMLT2,'-b','LineWidth',2)

for ii = 1:BAD.nDir
    contour(BAD.z_vec,BAD.tauh,squeeze(BAD.spectrum(:,:,ii)),'green','LineWidth',0.5)
end
plot(BAD.z_vec,BAD.MLT2,':g','LineWidth',1)
plot(BAD.z_vec,BAD.meanMLT2,'-g','LineWidth',2)

set(gca,'YScale','log')
xlabel('position [µm]')
xlim(ON.params.zlims)
ylabel('T2 [s]')

% pubgraph(hh)
% print([figdir,'ONOFFcomp.png'],'-dpng');

% gg = figure(2);
subplot(2,1,1)
hold on
plot(ON.z,mean(squeeze(abs(sum(ON.spatialdata,2))),2),'-r')
plot(OFF.z,mean(squeeze(abs(sum(OFF.spatialdata,2))),2),'-k')
plot(REV.z,mean(squeeze(abs(sum(REV.spatialdata,2))),2),'-b')
plot(BAD.z,mean(squeeze(abs(sum(BAD.spatialdata,2))),2),'-g')
% plot(ON.z_vec,log10(ON.meanMLT2)-log10(OFF.meanMLT2),'-k','LineWidth',2)
% line(ON.params.zlims,[0 0],'Color','blue')
% xlabel('position [µm]')
legend('ON','OFF','REV','BAD')
xlim(ON.params.zlims)
ylabel('signal intensity [arb]')
pubgraph(hh)
print([figdir,'ONOFFcomp.png'],'-dpng');