function [] = plot_actuator_limits(positions,actuator_lims,badpostilttip,nn)

tilts = positions(:,3);
tips = positions(:,4);
centroid = positions(1,2);

if nargin<6
    nn = 1;
end

U = [positions(2:end,3)-positions(1:end-1,3); 0];
V = [positions(2:end,4)-positions(1:end-1,4); 0];

all_tips = min(tips):5:max(tips);
all_tilts = min(tilts):5:max(tilts);

[p,o,q] = meshgrid(all_tips, all_tilts, centroid);
positions = [q(:) o(:) p(:)];

[abs_pos] = tilttip_to_abs(positions);

validgrid = (abs_pos(:,1)>max(actuator_lims) | abs_pos(:,1)<min(actuator_lims)) +...
            (abs_pos(:,2)>max(actuator_lims) | abs_pos(:,2)<min(actuator_lims)) +...
            (abs_pos(:,3)>max(actuator_lims) | abs_pos(:,3)<min(actuator_lims));

hh = figure(nn);
hold on
surf(all_tilts,all_tips,reshape(-validgrid,numel(all_tilts),numel(all_tips))');
scatter(badpostilttip(:,3),badpostilttip(:,4),2+20*ones(size(badpostilttip,1),1),'red','filled');
quiver(tilts,tips,U,V)
shading flat
xlabel('tips')
ylabel('tilts')
view([0 90])
pubgraph(hh)


end