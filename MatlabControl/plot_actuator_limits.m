function [] = plot_actuator_limits(tilts,tips,centroid,actuator_lims,nn)

if nargin<5
    nn = 1;
end

all_tips = min(tips):max(tips);
all_tilts = min(tilts):max(tilts);

[p,o,q] = meshgrid(all_tips, all_tilts, centroid);
positions = [q(:) o(:) p(:)];

[abs_pos] = tilttip_to_abs(positions);

validgrid = (abs_pos(:,1)>max(actuator_lims) | abs_pos(:,1)<min(actuator_lims)) +...
            (abs_pos(:,2)>max(actuator_lims) | abs_pos(:,2)<min(actuator_lims)) +...
            (abs_pos(:,3)>max(actuator_lims) | abs_pos(:,3)<min(actuator_lims));

hh = figure(nn);
surf(all_tips,all_tilts,reshape(validgrid,numel(all_tilts),numel(all_tips)));
shading flat
xlabel('tips')
ylabel('tilts')
view([90 -90])
pubgraph(hh)
end