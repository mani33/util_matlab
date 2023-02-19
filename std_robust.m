function s = std_robust(x,omitnan)
% s = std_robuest(x,omitnan) Robust form of standard deviation based on 
% R. Quian Quiroga, Z. Nadasdy, Y. Ben-Shaul
% Unsupervised spike detection and sorting with wavelets and superparamagnetic clustering
% Neural Comput., 16 (2004), pp. 1661-1687
if nargin < 2
    omitnan = "none";
end
if strcmp(omitnan,'omitnan')
    s = median(abs((x-median(x,"omitnan")))/0.6745,"omitnan");
else
    s = median(abs((x-median(x)))/0.6745);
end