function [md, mt] = moving_metric_by_time(data,t_data,t_start,t_end,win_t,overlap_t,metric,valid_len_flag)
% md = moving_metric_by_time(data,t_data,t_start,t_end,win_t,overlap_t,metric,valid_len_flag)
% Compute a given metric using data points falling within a moving time
% window. NaN's will be ignored by using 'omitnan' flag in the metric
% calculation.
% 
% Inputs:
%   data - vector of data points
%   t_data - time points(sec) corresponding to the data points
%   t_start - start time(sec) of the moving metric computation
%   t_end - end time(sec) of the moving metric computation
%   win_t - length(sec) of window
%   overlap_t - length(sec) of overlap of adjacent windows. Set this to 0
%   for contigous time windows.
%   metric - metric to be computed such as 'mean','median','std', 'var' etc
%   valid_len_flag - set to true to compute metric values using full length
%   moving time windows. Default value is set to true.
%
% Output: 
%   md - column vector of moving metric values
%   mt - column vector of window center times
%
% Mani Subramaniyan, last modified - 2022-07-01

if nargin < 8
    valid_len_flag = false;
end
% Idea: Compute the edges of the time moving time windows. Then, we will 
% simply pick the data points that are within each segment edges and 
% perform requested metric on these points.

% Single input metrics such as mean, median, std, var etc only
assert(any(strcmp(metric,{'sum','mean','median','std','var'})),'Currently allowed metrics are "sum","mean","median","std","var"')
[tw_start, tw_end] = make_moving_time_window_edges(t_start,t_end,win_t,overlap_t,valid_len_flag);
nWin = length(tw_start);
md = nan(nWin,1);
mt = tw_start+(win_t/2);

for iWin = 1:nWin
    sel_data = data(t_data >= tw_start(iWin) & t_data < tw_end(iWin));
    if ~isempty(sel_data)
        md(iWin) = eval(sprintf('%s(sel_data,"omitnan")',metric));
    end
end







