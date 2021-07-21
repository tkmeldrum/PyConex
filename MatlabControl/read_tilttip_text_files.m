function [positions_data,tilts,tips,params,input_pos_data,time_data] = read_tilttip_text_files(filedir,params)

fileout = [filedir,'output_positions.txt'];
filestamps = [filedir,'stamps.txt'];
filein = [filedir,'input_positions.txt'];

if isfile(fileout)
    fileID = fopen(fileout,'r');
    data = fscanf(fileID,'%u, %f, %f, %f');
    fclose(fileID);
else
    sprintf('Output file (output_positions.txt) not found.');
    return
end

if isfile(filestamps)
    fileID = fopen([filedir,'stamps.txt'],'r');
    stampdata = textscan(fileID,'%u, %f, %s');
    fclose(fileID);
    time_data = [stampdata{2}(:)];
else
    sprintf('Timestamps file (stamps.txt) not found.');
end

if isfile(filein)
    fileID = fopen([filedir,'input_positions.txt'],'r');
    input_pos_data = fscanf(fileID,'%u, %f, %f, %f');
    fclose(fileID);
else
    sprintf('Input positions file (input_positions.txt) not found.');
end

positions_data = reshape(data,4,numel(data)/4)';
input_pos_data = reshape(input_pos_data,4,numel(input_pos_data)/4)';
tilts = unique(input_pos_data(:,3));
tips = unique(input_pos_data(:,4));
params.nPos_in = size(positions_data,1);

end