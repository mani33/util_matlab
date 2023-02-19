function varargout = cxlabel(label_str,cond,varargin)
% Add xlabel to the current axes when cond is true.
% Mani Subramaniyan, last modified - 2022-07-21

if (nargin < 2) || cond
    h = xlabel(label_str,varargin{:});
    if nargout
        varargout{1} = h;
    end
end
