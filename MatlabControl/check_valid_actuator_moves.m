function [badpostilttip,badposabs] = check_valid_actuator_moves(positions,actuator_lims)

abs_pos = tilttip_to_abs(positions(:,2:4));


%% check validity of actuator moves

A_low = find(abs_pos<min(actuator_lims));
A_high = find(abs_pos>max(actuator_lims));

[badhigh,~] = ind2sub(size(abs_pos),A_high);
[badlow,~] = ind2sub(size(abs_pos),A_low);
badrows = sort([badlow;badhigh]);

badposabs = abs_pos(badrows,:);
badpostilttip = positions(badrows,:);

end
