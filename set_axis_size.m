function set_axis_size(ax,width_height)
% Set the size of the given axis ax to given width and height.
%
% Inputs:
% ax - axis handle
% width_height - 2-element vector specifying width and height in inches.
% Note that the width and height will be for the axis excluding tick and
% x/y labels. The original units (cm, normalized etc) of the axis will be 
% retained though the axis size will be as requested in inches.
% 
% Mani Subramaniyan 2023-03-24

original_units = get(ax,'Units');
set(ax,'Units','Inches')
p = get(gca,'Position');
p(3:4) = width_height;
set(gca,'Position',p)
set(ax,'Units',original_units)