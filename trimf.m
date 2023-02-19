function f = trimf(x,p)
% Trangular membership function - custom made.
% x - time series for which triangle membership is determined
% p - [a,b,c] where a marks beginning, c marks the end and b marks the 
% vertex, of the triangle in the time series.
%
% Mani Subramaniyan, last modified - 2022-07-15
a = p(1);
b = p(2);
c = p(3);
n = length(x);
f = zeros(n,1);
for i = 1:n
    y = x(i);
    if (y >= a) && (y <= b)
        f(i) = (y-a)/(b-a);
    elseif (y >=b) && (y <= c)
        f(i) = (c-y)/(c-b);
    end
end
