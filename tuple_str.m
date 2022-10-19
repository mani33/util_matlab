function s = tuple_str(v,n_decimals)
% function s = tuple_str(v,n_decimals). Make a tuple string s (e.g.: '(1,2,3)') 
% from the input vector v(e.g.[1,2,3]) with a given number of decimals. 
% v can have one element.
%
% Mani Subramaniyan 2022-06-13

if nargin < 2
    n_decimals = 5;
end
sp = sprintf('%%0.%uf,',n_decimals);

if ischar(v)
    s = sprintf('"%s",', v);
elseif iscell(v)
    s = cellfun(@(x) sprintf('"%s",',x), v, 'UniformOutput', false);
    s = [s{:}];   
else
    s = sprintf(sp, v);
end
% Trim off the ", " at the end
s = s(1:end-1);
% Add parentheses
s = ['(' s ')'];



