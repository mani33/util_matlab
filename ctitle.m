function varargout = ctitle(title_str,cond,varargin)
% Add title to the current axes when cond is true.
% Mani Subramaniyan, last modified - 2022-12-07
if (nargin < 2) || cond
    h = title(title_str,varargin{:});
    if nargout
        varargout{1} = h;
    end
end