function [] = plot_actuator_limits(tilts,tips,centroid,actuator_lims,badpostilttip,nn)

if nargin<6
    nn = 1;
end

all_tips = min(tips):5:max(tips);
all_tilts = min(tilts):5:max(tilts);

[p,o,q] = meshgrid(all_tips, all_tilts, centroid);
positions = [q(:) o(:) p(:)];

[abs_pos] = tilttip_to_abs(positions);

validgrid = (abs_pos(:,1)>max(actuator_lims) | abs_pos(:,1)<min(actuator_lims)) +...
            (abs_pos(:,2)>max(actuator_lims) | abs_pos(:,2)<min(actuator_lims)) +...
            (abs_pos(:,3)>max(actuator_lims) | abs_pos(:,3)<min(actuator_lims));

hh = figure(nn);

%this part isn't working. the two plots aren't correctly aligned, probably
%due to reshaping etc.
hold on
surf(all_tilts,all_tips,reshape(validgrid,numel(all_tilts),numel(all_tips))');
scatter(badpostilttip(:,3),badpostilttip(:,4),2+20*ones(size(badpostilttip,1),1));
shading flat
xlabel('tips')
ylabel('tilts')
view([0 90])
pubgraph(hh)
end