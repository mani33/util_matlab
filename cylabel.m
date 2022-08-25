function varargout = cylabel(label_str,cond,varargin)
% Add ylabel to the current axes when cond is true.
% Mani Subramaniyan, last modified - 2022-07-21
if (nargin < 2) || cond
    h = ylabel(label_str,varargin{:});
    if nargout
        varargout{1} = h;
    end
end