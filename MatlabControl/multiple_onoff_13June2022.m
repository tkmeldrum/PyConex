clear
clc
close all

params.zf = 1;
params.gamma = 42.577; %MHz/T
params.G = 23.87; %T/m
T2kernel = 'exp(-h/T)';

maindir = 'Z:\Data\TKM\PM5\June2022\TiltTip\Epoxy31\CPMG_ONOFFBAD2\';

dirname = [maindir,'ON/'];
ON = runmultipleonoff_tilttip(dirname,params,T2kernel);

dirname = [maindir,'OFF/'];
OFF = runmultipleonoff_tilttip(dirname,params,T2kernel);

dirname = [maindir,'REV/'];
REV = runmultipleonoff_tilttip(dirname,params,T2kernel);

% dirname = [maindir,'BAD/'];
% BAD = runmultipleonoff_tilttip(dirname,params,T2kernel);
save([maindir,'multipleonoff_proc.mat']);

%%
hh = figure(1);
set(gcf,'Position',[1 1 560  800])
subplot(2,1,2)
hold on
% for ii = 1:ON.nDir
%     contour(ON.z_vec,ON.tauh,squeeze(ON.spectrum(:,:,ii)),10,'red','LineWidth',0.5)
% end
% plot(ON.z_vec,ON.MLT2,':r','LineWidth',1)
contour(ON.z_vec,ON.tauh,ON.meanspectrum,20,'red','LineWidth',0.5)
% plot(ON.z_vec,ON.meanMLT2,'-r','LineWidth',2)


% for ii = 1:OFF.nDir
%     contour(OFF.z_vec,OFF.tauh,squeeze(OFF.spectrum(:,:,ii)),10,'black','LineWidth',0.5)
% end
% plot(OFF.z_vec,OFF.MLT2,':k','LineWidth',1)
contour(OFF.z_vec,OFF.tauh,OFF.meanspectrum,20,'black','LineWidth',0.5)
% plot(OFF.z_vec,OFF.meanMLT2,'-k','LineWidth',2)

% for ii = 1:REV.nDir
%     contour(REV.z_vec,REV.tauh,squeeze(REV.spectrum(:,:,ii)),5,'blue','LineWidth',0.5)
% end
% plot(REV.z_vec,REV.MLT2,':b','LineWidth',1)
% plot(REV.z_vec,REV.meanMLT2,'-b','LineWidth',2)

% for ii = 1:BAD.nDir
%     contour(BAD.z_vec,BAD.tauh,squeeze(BAD.spectrum(:,:,ii)),5,'green','LineWidth',0.5)
% end
% plot(BAD.z_vec,BAD.MLT2,':g','LineWidth',1)
% plot(BAD.z_vec,BAD.meanMLT2,'-g','LineWidth',2)

set(gca,'YScale','log')
xlabel('position [µm]')
% xlim([0 75])
xlim(ON.params.zlims)
ylabel('T2 [s]')

% pubgraph(hh)
% print([figdir,'ONOFFcomp.png'],'-dpng');

% gg = figure(2);
subplot(2,1,1)
hold on
plot(ON.z,mean(squeeze(abs(sum(ON.spatialdata,2))),2,'omitnan'),'-r')
plot(OFF.z,mean(squeeze(abs(sum(OFF.spatialdata,2))),2,'omitnan'),'-k')
plot(REV.z,mean(squeeze(abs(sum(REV.spatialdata,2))),2,'omitnan'),'-b')
plot(BAD.z,mean(squeeze(abs(sum(BAD.spatialdata,2))),2,'omitnan'),'-g')
% plot(ON.z_vec,log10(ON.meanMLT2)-log10(OFF.meanMLT2),'-k','LineWidth',2)
% line(ON.params.zlims,[0 0],'Color','blue')
% xlabel('position [µm]')
legend('ON','OFF','REV','BAD')
xlim(ON.params.zlims)
ylabel('signal intensity [arb]')
pubgraph(hh)

% print([maindir,'ONOFFILTcomp.png'],'-dpng');

%%
close all
xlimits = [-50 25];
ll= figure(3);
set(gcf,'Position',[27          77        1165         720]);
subplot(2,3,1)
% yyaxis left
hold on
plot(ON.z_vec,ON.meanmonoexp.A,'-r')
plot(ON.z_vec,ON.meanmonoexp.A+ON.meanmonoexp.Aci,':r')
plot(ON.z_vec,ON.meanmonoexp.A-ON.meanmonoexp.Aci,':r')

plot(OFF.z_vec,OFF.meanmonoexp.A,'-k')
plot(OFF.z_vec,OFF.meanmonoexp.A+OFF.meanmonoexp.Aci,':k')
plot(OFF.z_vec,OFF.meanmonoexp.A-OFF.meanmonoexp.Aci,':k')

plot(REV.z_vec,REV.meanmonoexp.A,'-b')
plot(REV.z_vec,REV.meanmonoexp.A+REV.meanmonoexp.Aci,':b')
plot(REV.z_vec,REV.meanmonoexp.A-REV.meanmonoexp.Aci,':b')
xlim(xlimits)
ylim([-0.1 1.1])
ylabel('fitted signal intensity [arb]')
xlabel('position [µm]')

subplot(2,3,4)
hold on
plot(ON.z_vec(2:end),diff(ON.meanmonoexp.A)./diff(ON.z_vec)','-r')
% plot(ON.z_vec,ON.meanmonoexp.T2+ON.meanmonoexp.T2ci,':r')
% plot(ON.z_vec,ON.meanmonoexp.T2-ON.meanmonoexp.T2ci,':r')

plot(OFF.z_vec(2:end),diff(OFF.meanmonoexp.A)./diff(OFF.z_vec)','-k')
% plot(OFF.z_vec,OFF.meanmonoexp.T2+OFF.meanmonoexp.T2ci,':k')
% plot(OFF.z_vec,OFF.meanmonoexp.T2-OFF.meanmonoexp.T2ci,':k')

plot(REV.z_vec(2:end),diff(REV.meanmonoexp.A)./diff(REV.z_vec)','-b')
% plot(REV.z_vec,REV.meanmonoexp.T2+REV.meanmonoexp.T2ci,':b')
% plot(REV.z_vec,REV.meanmonoexp.T2-REV.meanmonoexp.T2ci,':b')
xlim(xlimits)
xlabel('position [µm]')
ylabel('dA/dz [1/µm]')
ylim([-0.1 0.05])


subplot(2,3,2)
hold on
plot(ON.z_vec,ON.meanmonoexp.T2,'-r')
plot(ON.z_vec,ON.meanmonoexp.T2+ON.meanmonoexp.T2ci,':r')
plot(ON.z_vec,ON.meanmonoexp.T2-ON.meanmonoexp.T2ci,':r')

plot(OFF.z_vec,OFF.meanmonoexp.T2,'-k')
plot(OFF.z_vec,OFF.meanmonoexp.T2+OFF.meanmonoexp.T2ci,':k')
plot(OFF.z_vec,OFF.meanmonoexp.T2-OFF.meanmonoexp.T2ci,':k')

plot(REV.z_vec,REV.meanmonoexp.T2,'-b')
plot(REV.z_vec,REV.meanmonoexp.T2+REV.meanmonoexp.T2ci,':b')
plot(REV.z_vec,REV.meanmonoexp.T2-REV.meanmonoexp.T2ci,':b')
xlim(xlimits)
xlabel('position [µm]')
ylabel('T2 [s]')
ylim([1e-2 0.05])
set(gca,'YScale','log')

subplot(2,3,3)
hold on

plot(ON.z_vec,ON.meanbiexp.T22,'-r')
plot(ON.z_vec,ON.meanbiexp.T22+ON.meanbiexp.T22ci,':r')
plot(ON.z_vec,ON.meanbiexp.T22-ON.meanbiexp.T22ci,':r')

plot(OFF.z_vec,OFF.meanbiexp.T21,'-k')
plot(OFF.z_vec,OFF.meanbiexp.T21+OFF.meanbiexp.T21ci,':k')
plot(OFF.z_vec,OFF.meanbiexp.T21-OFF.meanbiexp.T21ci,':k')

plot(REV.z_vec,REV.meanbiexp.T21,'-b')
plot(REV.z_vec,REV.meanbiexp.T21+REV.meanbiexp.T21ci,':b')
plot(REV.z_vec,REV.meanbiexp.T21-REV.meanbiexp.T21ci,':b')
xlim(xlimits)
xlabel('position [µm]')
ylabel('T2[1] [s]')
ylim([1e-4 0.1])
set(gca,'YScale','log')

subplot(2,3,6)
hold on
plot(ON.z_vec,ON.meanbiexp.T21,'-r')
plot(ON.z_vec,ON.meanbiexp.T21+ON.meanbiexp.T21ci,':r')
plot(ON.z_vec,ON.meanbiexp.T21-ON.meanbiexp.T21ci,':r')

plot(OFF.z_vec,OFF.meanbiexp.T22,'-k')
plot(OFF.z_vec,OFF.meanbiexp.T22+OFF.meanbiexp.T22ci,':k')
plot(OFF.z_vec,OFF.meanbiexp.T22-OFF.meanbiexp.T22ci,':k')

plot(REV.z_vec,REV.meanbiexp.T22,'-b')
plot(REV.z_vec,REV.meanbiexp.T22+REV.meanbiexp.T22ci,':b')
plot(REV.z_vec,REV.meanbiexp.T22-REV.meanbiexp.T22ci,':b')
xlim(xlimits)
xlabel('position [µm]')
ylabel('T2[2] [s]')
ylim([1e-2 1e-1])
set(gca,'YScale','log')



subplot(2,3,5)
hold on
plot(ON.z_vec(2:end),diff(ON.meanmonoexp.T2)./diff(ON.z_vec)','-r')
% plot(ON.z_vec,ON.meanmonoexp.T2+ON.meanmonoexp.T2ci,':r')
% plot(ON.z_vec,ON.meanmonoexp.T2-ON.meanmonoexp.T2ci,':r')

plot(OFF.z_vec(2:end),diff(OFF.meanmonoexp.T2)./diff(OFF.z_vec)','-k')
% plot(OFF.z_vec,OFF.meanmonoexp.T2+OFF.meanmonoexp.T2ci,':k')
% plot(OFF.z_vec,OFF.meanmonoexp.T2-OFF.meanmonoexp.T2ci,':k')

plot(REV.z_vec(2:end),diff(REV.meanmonoexp.T2)./diff(REV.z_vec)','-b')
% plot(REV.z_vec,REV.meanmonoexp.T2+REV.meanmonoexp.T2ci,':b')
% plot(REV.z_vec,REV.meanmonoexp.T2-REV.meanmonoexp.T2ci,':b')
xlim(xlimits)
xlabel('position [µm]')
ylabel('dT2/dz [s/µm]')
ylim([-0.01 0.01])
% set(gca,'YScale','log')
pubgraph(ll)

exportgraphics(ll,[maindir,'ONOFF_expFit.eps'],'ContentType','vector');

%%
close all
gg = figure(2);
subplot(2,1,1)
hold on
% plot(ON.z_vec,ON.monoexp.T2,'-r')
% plot(ON.z_vec,mean(ON.monoexp.T2,2),'-r','LineWidth',2)
for ii = 1:3
    plot(ON.z_vec,ON.monoexp.T2(:,ii),'.-r')
    plot(ON.z_vec,ON.monoexp.T2(:,ii)-ON.monoexp.T2ci(:,ii),':r')
    plot(ON.z_vec,ON.monoexp.T2(:,ii)+ON.monoexp.T2ci(:,ii),':r')
    
    plot(OFF.z_vec,OFF.monoexp.T2(:,ii),'.-k')
    plot(OFF.z_vec,OFF.monoexp.T2(:,ii)-OFF.monoexp.T2ci(:,ii),':k')
    plot(OFF.z_vec,OFF.monoexp.T2(:,ii)+OFF.monoexp.T2ci(:,ii),':k')
    
    plot(REV.z_vec,REV.monoexp.T2(:,ii),'.-b')
    plot(REV.z_vec,REV.monoexp.T2(:,ii)-REV.monoexp.T2ci(:,ii),':b')
    plot(REV.z_vec,REV.monoexp.T2(:,ii)+REV.monoexp.T2ci(:,ii),':b')
end
% plot(OFF.z_vec,OFF.monoexp.T2,'-k')
% plot(OFF.z_vec,mean(OFF.monoexp.T2,2),'-k','LineWidth',2)
% plot(OFF.z_vec,mean(OFF.monoexp.T2,2)-min(OFF.monoexp.T2ci,[],2),':k')
% plot(OFF.z_vec,mean(OFF.monoexp.T2,2)+max(OFF.monoexp.T2ci,[],2),':k')

% plot(REV.z_vec,REV.monoexp.T2,'-b')
% plot(REV.z_vec,mean(REV.monoexp.T2,2),'-b','LineWidth',2)
% plot(REV.z_vec,mean(REV.monoexp.T2,2)-min(REV.monoexp.T2ci,[],2),':b')
% plot(REV.z_vec,mean(REV.monoexp.T2,2)+max(REV.monoexp.T2ci,[],2),':b')

% plot(BAD.z_vec,BAD.monoexp.T2,'-g')

xlim([-10 10])
ylim([0.01 0.05])
xlabel('position [µm]')
ylabel('monexponential fit T2 [s]')
% set(gca,'YScale','log')


subplot(2,1,2)
hold on
for ii = 1:3
    plot(ON.z_vec,ON.monoexp.A(:,ii),'.-r')
    plot(ON.z_vec,ON.monoexp.A(:,ii)-ON.monoexp.Aci(:,ii),':r')
    plot(ON.z_vec,ON.monoexp.A(:,ii)+ON.monoexp.Aci(:,ii),':r')
    
    plot(OFF.z_vec,OFF.monoexp.A(:,ii),'.-k')
    plot(OFF.z_vec,OFF.monoexp.A(:,ii)-OFF.monoexp.Aci(:,ii),':k')
    plot(OFF.z_vec,OFF.monoexp.A(:,ii)+OFF.monoexp.Aci(:,ii),':k')
    
    plot(REV.z_vec,REV.monoexp.A(:,ii),'.-b')
    plot(REV.z_vec,REV.monoexp.A(:,ii)-REV.monoexp.Aci(:,ii),':b')
    plot(REV.z_vec,REV.monoexp.A(:,ii)+REV.monoexp.Aci(:,ii),':b')
end
ylim([-0.5 1])

xlim([-50 10])
pubgraph(gg)