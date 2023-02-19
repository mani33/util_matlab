function varargout = msubplot(r,c,matSize,varargin)
% h = msubplot(r,c,matSize,param1,paramVal1,param2,paramVal2,...)
%-----------------------------------------------------------------------------------------
% MSUBPLOT - subplot with indexing done as in matrix (i,j) style
%
% example:  When you want to go to subplot(2,4,3), you can use 
%           h = msubplot(1,3,[2 4])
% This function is called by:
% This function calls:
% MAT-files required:
%
% See also: 

% Author: Mani Subramaniyan
% Date created: 2011-11-08
% Last revision: 2011-11-08
% Created in Matlab version: 7.13.0.564 (R2011b)
%-----------------------------------------------------------------------------------------

for i = 1:length(r)
    for j = 1:length(c)
        temp.ind(i,j) = sub2ind(fliplr(matSize),c(j),r(i));
    end
end
h = subplot(matSize(1),matSize(2),temp.ind(:),varargin{:});

if nargout
    varargout{1} = h;
end