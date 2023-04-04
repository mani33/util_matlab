function [ct_hour_of_day,hours] = get_cyclic_hour_loc_on_cont_time(ct_start,ct_end,hour_of_day,first_loc_only,varargin)
% function ct_hour_of_day = get_cyclic_hour_loc_on_cont_time(ct_start,ct_end,hour_of_day,first_loc_only)
% Get the cyclic locations corresponding to a given hour of day on a 
% continuous time spanning across several days. Useful for plotting 
% specific time points in sleep studies where continuous time is used for 
% plotting data across multiple days.
%
% Inputs:
% ct_start - continuous time (h) start. eg. 176
% ct_end - continous time (h) end. eg. 256
% hour_of_day - hour of the day in 24h format that you want to find the
% location on the continuous hour range (between ct_start and ct_end)
% first_loc_only - return only the first of the hour locations
%
% Outputs:
%   ct_hour_of_day - continuous times corresponding to the requested
%   cyclic hour_of_day
%   hours - hours corresponding to given hour_of_day
%
% Mani Subramaniyan 2023-03-23
args.day_start_hour = 0; % must be 0 or 24; 0 or 24 for marking day start
args = parse_var_args(args,varargin{:});
if nargin < 4
    first_loc_only = false;
end
% Go a bit before the day corresponding to ct_start
win_start_day = floor(ct_start/24);
% Go a bit beyond the day corresponding to ct_end
win_end_day = ceil(ct_end/24);
nHourOfDay = length(hour_of_day);
d = struct;
for iHod = 1:nHourOfDay
    chour_of_day = hour_of_day(iHod);
    ct_hour_of_day = (win_start_day:win_end_day)*24 + chour_of_day;
    % Trim
    c_locs = ct_hour_of_day(ct_hour_of_day >= ct_start & ct_hour_of_day <= ct_end);
    c_hours = repmat(chour_of_day,1,length(c_locs));
    d.locs{iHod} = c_locs;
    d.hours{iHod} = c_hours;
    if first_loc_only
        d.locs{iHod} = c_locs(1);
        d.hours{iHod} = c_hours(1);
    end
end
% Pool and sort
all_locs = [d.locs{:}];
all_hours = [d.hours{:}];
[ct_hour_of_day,ind] = sort(all_locs);
hours = all_hours(ind);
if args.day_start_hour==0
    hours(hours==24) = 0;
elseif args.day_start_hour==24
    hours(hours==0) = 24;
else
    error('day starting must be 0 or 24')
end

