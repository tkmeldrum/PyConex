function [setOut] = make_inc_vector(set_in)

if mod((set_in(3)-set_in(1)),set_in(2)) ~= 0
    errordlg('Increments don''t match range','Increment error')
end

setOut = linspace(set_in(1), set_in(3), max((set_in(3)-set_in(1))/set_in(2)+1,1));
end