function gw = get_gausswin(stdev,sampling_interval,odd_flag)
% gw = get_gausswin(stdev,bin_width_msec,odd_flag)
%-----------------------------------------------------------------------------------------
% GET_GAUSSWIN - Gives a normalized gaussian window with a defined standard deviation
% and sampling interval. stdev and sampling_interval must have the same
% unit.
%
% example: gw = get_gausswin(10,2) - creates a normalized gaussian window
% with a standard deviation of 10 units and sampling interval of 2 units.
% The unit can be msec, sec, minutes, or any other metric such as meters.
%
% This function calls: gausswin
%
% See also: gausswin

% Author: Mani Subramaniyan
% Date created: 2012-07-05
% Last revision: 2022-07-01
% Created in Matlab version: 9.12.0.1884302 (R2022a)
%-----------------------------------------------------------------------------------------

% Basic formula for computing L and alpha required by MATLAB's gausswin
% function is: 
% 
% sigma = (L-1)/(2*alpha) as found in the MATLAB's help. 
%
% In this formula, the unit of the variables is in terms of samples. That is,
% a sigma value of 0.3 means that the standard deviation of the gaussian is
% 0.3 sampling intervals. L is the number of samples in the gaussian window.
% 
% As an example, we will use sec as the unit.By default, the sampling 
% interval is unitless and has a value of 1. To assign sec as unit to 
% sigma, we multiply it by the sampling interval: 
%
% std_sec = sampling_interval*(L-1)/(2*alpha). 
% 
% To get alpha, the last variable we need is L. Given that we know the 
% sampling interval, we can compute L once we fix the percentage of the 
% gaussian that will be covered by our window. We know that 3 standard 
% deviations on either side of the window center will cover 99.9% of the 
% gaussian window area. Given this, the length of the window in the units 
% of sec will be 6*sampling_interval. Then, the number of samples in the 
% window (L) can be obtained by dividing the length of the window by the 
% sampling interval.

if nargin < 3
    odd_flag = false;
end
n_std = 6;
win_len = n_std*stdev;
L = round(win_len/sampling_interval);
if rem(L,2)==0 && odd_flag % L is even number but user wants it to be odd
   L = L + 1;
end
alpha = sampling_interval*(L-1)/(2*stdev);
gw = gausswin(L,alpha);
% Normalize to have an area of 1
gw = gw/sum(gw);
