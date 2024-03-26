function [node_data, element_data] = read_nastran_mesh(filename)
% 
% Open the Nastran file for reading
% filename = 'filename.nas';
% fid = fopen(filename, 'rt');

fid = fopen(filename, 'r');

% Initialize variables
node_data = [];
element_data = [];

% Read the file line by line
while ~feof(fid)
    Line = fgetl(fid);
    
    % Parse node data
    if startsWith(Line, 'GRID')
        node_id = str2double(Line(15:24));
        coord = sscanf(Line(25:end), '%f');
        node_data(end+1,:) = [node_id, coord'];
        
    % Parse element data
    elseif startsWith(Line, 'CQUAD4')
        element_id = str2double(Line(9:16));
        node_ids = sscanf(Line(17:end), '%f');
        element_data(end+1,:) = [element_id, node_ids'];
    
    elseif startsWith(Line, 'CTRIA3')
        element_id = str2double(Line(9:16));
        node_ids = sscanf(Line(17:end), '%f');
        element_data(end+1,:) = [element_id, node_ids'];
    end
end

% Close the file
fclose(fid);
node_data = node_data(:,2:3);
element_data = element_data(:,3:end);

% Extract the node IDs and coordinates from the node


