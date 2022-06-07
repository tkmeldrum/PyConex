function [] = plot_actuator_limits(positions,actuator_lims,nn)

tilts = positions(:,3);
tips = positions(:,4);
centroid = positions(1,2);

if nargin<3
    nn = 1;
end

U = [positions(2:end,4)-positions(1:end-1,4); 0];
V = [positions(2:end,3)-positions(1:end-1,3); 0];

all_tips = min(tips):5:max(tips);
all_tilts = min(tilts):5:max(tilts);

[p,o,q] = meshgrid(all_tips, all_tilts, centroid);
meshpositions = [q(:) o(:) p(:)];

[abs_pos] = tilttip_to_abs(meshpositions);

validgrid = (abs_pos(:,1)>max(actuator_lims) | abs_pos(:,1)<min(actuator_lims)) +...
            (abs_pos(:,2)>max(actuator_lims) | abs_pos(:,2)<min(actuator_lims)) +...
            (abs_pos(:,3)>max(actuator_lims) | abs_pos(:,3)<min(actuator_lims));

% hh = figure(nn);
% hold on
% surf(all_tips,all_tilts,reshape(-validgrid,numel(all_tilts),numel(all_tips)));
% scatter(positions(:,4),positions(:,3),20*ones(size(positions,1),1),'red','filled');
% quiver(tips,tilts,U,V)
% shading flat
% xlabel('tips')
% ylabel('tilts')
% view([0 90])
% pubgraph(hh)


end