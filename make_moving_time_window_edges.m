function [mw_begin, mw_end] = make_moving_time_window_edges(t_begin,t_end,win_t,overlap_t,valid_last_seg)
% Create moving time window edges. 
% 
% Inputs:
%   t_begin - start time of the moving window computation
%   t_end - end time of the moving window computation
%   win_t - length of window
%   overlap_t - length of overlap of adjacent windows. Must be positive. 
%   Set this to 0 if contiguous time segments are needed. Note that when 
%   set to 0, the end time of a segment will be equal to the beginning of 
%   the next segment. You will have to use the appropriate set of 
%   inequalities such as (>,<=) or (>=,<).
%   valid_len_flag - Set the valid_last_seg to true to exclude the last 
%   segment that is not full length. Otherwise, by default, short last 
%   segment edges will be returned.
%
% Outputs:
%   mw_begin - column vector of moving window beginnings
%   mw_end - column vector of moving window ends
%
% Mani Subramaniyan 2022-07-01

if nargin < 5
    valid_last_seg = false;
end

t_len = t_end-t_begin;
done = false;
mw = struct;
i = 0;
% We will work with relative time first, that is, t_start is taken as 0.
% Then we will add t_start to all time edges at the end of the computation.
while ~done
    i = i + 1;
    overlap_offset = (i-1)*overlap_t;
    % Idea: For contiguous segmenting, you will use (i-1)*wt as the
    % segment starting time. Because of overlap, pull this time to the
    % left by (i-1)*overlap_t.
    seg_begin = ((i-1)*win_t)-overlap_offset;
    seg_end = seg_begin+win_t;

    % Are we are in the last segment?
    in_last_seg = seg_begin >= (t_len-win_t);

    if ~in_last_seg  % Simpler life when NOT in last segment
        mw.begin(i,1) = seg_begin;
        mw.end(i,1) = seg_end;
    else % In last segment!
        done = true;
        % Segment end can't go beyond available data
        seg_end = min([t_len, seg_end]);
        curr_seg_len = seg_end-seg_begin;
        % Take only full length last segment when mandatory. When
        % valid_last_seg is not required, return edges of last segment
        % irrespective of its length.
        if (valid_last_seg && curr_seg_len==win_t) || (~valid_last_seg)
            mw.begin(i,1) = seg_begin;
            mw.end(i,1) = seg_end;
        end
    end
end
% Convert relative times to absolute time of the user.
mw_begin = mw.begin+t_begin;
mw_end = mw.end+t_begin;