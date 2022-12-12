function se = serror(x,dim)
% se = serror(x,dim) - Compute standard error for the array in x in the given
% dimension.
% 
% Examples:
% serror([1,2,3,4])
% serror([1,4,5;3,4,2],1) - computes serror along rows
% serror([1,4,5;3,4,2]) - computes serror along rows
% serror([1,4,5;3,4,2],2) - computes serror along columns
%
% Mani Subramaniyan 2022-11-16
if isvector(x)
    x = x(:);
end
if nargin < 2
    dim = 1;
end
sd = std(x,0,dim,'omitnan');
n = size(x,dim); % need to
se = sd/sqrt(n);