function varargout = get_fig_position()
% function p = get_fig_position()
%-----------------------------------------------------------------------------------------
% get_fig_position - Gives you the position of the current figure.
%
% example: [171,1139,560,420] = get_fig_position()
%
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also: 

% Author: Mani Subramaniyan
% Date created: 2010-12-23
% Last revision: 2010-12-23
% Created in Matlab version: 7.5.0.342 (R2007b)
%-----------------------------------------------------------------------------------------
p = get(gcf,'Position');
s = mat2str(p);
s = sprintf('set(gcf,"Position",%s)',s);
disp(s);
clipboard('copy',s);
if nargout
    varargout{1} = p;
end