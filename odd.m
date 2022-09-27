function v = odd(x)
% Check if the given input array is odd or even. Output v is a boolean of
% the same size as x.
%
% Mani Subramaniyan 2022-09-26
v = logical(rem(x,2));