function [] = write_input_positions(filedir,positions)

if ~exist(filedir, 'dir')
    mkdir(filedir)
end

fileID = fopen([filedir,'input_positions.txt'],'w');
fprintf(fileID,  '%u, %f, %f, %f\n', positions' );
fclose(fileID);