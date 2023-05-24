function xj = jitter(x,amp,method,varargin)
% xj = jitter(x,amp,varargin) - Jitter given x-coordinate points by
% amplitude AMP horizontally left and right alernatingly. Helpful in
% separating overlapping plotted points in a regular fashion.
%
% Usage example: plot(jitter(x),y) - this will 
% Mani Subramaniyan 2023-05-23
if nargin < 3
    method = 'fixed_hdist';
end
switch method
    case 'fixed_hdist'
        za = ones(1,length(x))*amp;
        za(1:2:end) = -1*amp;
        xj = x+za;
    case 'random'
        xj = x+normrnd(0,amp,size(x));
end

