function [output_list] = readMultiTiltTipPositions(dirlist)

outind = 1;
for ii = 1:numel(dirlist)
    %     fileID = fopen([dirlist{ii},'output_positions.txt'],'r');
    %     data = fscanf(fileID,'%u, %f, %f, %f');
    %     fclose(fileID);
    %
    %     fileID = fopen([dirloc,'stamps.txt'],'r');
    %     stampdata = textscan(fileID,'%u, %f, %s');
    %     fclose(fileID);
    %     params.time_data = [stampdata{2}(:)];
    %
    fileID = fopen([dirlist{ii},'input_positions.txt'],'r');
    input_pos_data = fscanf(fileID,'%u, %f, %f, %f');
    fclose(fileID);
    
    %     params.positions_data = reshape(data,4,numel(data)/4)';
    input_pos_data = reshape(input_pos_data,4,numel(input_pos_data)/4)';
    %     params.tilts = unique(params.input_pos_data(:,3));
    %     params.tips = unique(params.input_pos_data(:,4));
    nPos_in = size(input_pos_data,1);
    %     params.graph_order = sortrows(params.input_pos_data,3,'descend');
   
        

    for ll = 1:nPos_in
        output_list(outind).dir = [dirlist{ii},num2str(ll),filesep];
        output_list(outind).tilt = input_pos_data(ll,3);
        output_list(outind).tip = input_pos_data(ll,4);
        output_list(outind).centroid = input_pos_data(ll,2);
        outind = outind+1;
    end
end


% output_list = [output_list(:)];