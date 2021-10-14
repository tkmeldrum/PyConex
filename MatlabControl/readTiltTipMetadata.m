function [params] = readTiltTipMetadata(dirloc,gamma,G,zf)

    params.G = G;
    params.zf = zf;
    params.gamma = gamma;
    
    fileID = fopen([dirloc,'output_positions.txt'],'r');
    data = fscanf(fileID,'%u, %f, %f, %f');
    fclose(fileID);
    
    fileID = fopen([dirloc,'stamps.txt'],'r');
    stampdata = textscan(fileID,'%u, %f, %s');
    fclose(fileID);
    params.time_data = [stampdata{2}(:)];
    
    fileID = fopen([dirloc,'input_positions.txt'],'r');
    input_pos_data = fscanf(fileID,'%u, %f, %f, %f');
    fclose(fileID);
    
    params.positions_data = reshape(data,4,numel(data)/4)';
    params.input_pos_data = reshape(input_pos_data,4,numel(input_pos_data)/4)';
    params.tilts = unique(params.input_pos_data(:,3));
    params.tips = unique(params.input_pos_data(:,4));
    params.nPos_in = size(params.positions_data,1);
    params.graph_order = sortrows(params.input_pos_data,3,'descend');

    for ii = 1:params.nPos_in
        filelist = [dirloc,num2str(ii),filesep];
        [~,~,~,~,params,~] = readKeaForFTT2(filelist,params);
%         master_tilttip_list.dir(ii) = filelist;
%         master_tilttip_list.tilt(ii) = params.input_pos_data(ii,3);
%         master_tilttip_list.tip(ii) = params.input_pos_data(ii,4);
%         master_tilttip_list.centroid(ii) = params.input_pos_data(ii,2);
    end