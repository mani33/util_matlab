function [start_ind, end_ind] = find_repeats(x, b, splice_gap)
% [start_ind, end_ind] = find_repeats(x, b, splice_gap)
% Find the starting and ending indices of subarrays where a given value (b)
% is repeated in the vector x. 
% 
% Note that single occurrence of b with non-b values before and after will 
% also be included in finding. See Example1 below. Such occurrences will 
% have start_ind=end_ind, allowing for their easy post-hoc elimination 
% if desired.
% 
% Optionally, two adjacent subarrays will be spliced if the gap is 
% <= splice_gap (integer value). Note the gap is the difference between the 
% indices of the end of one segment and the beginning of the next segment; 
% therefore, the number of elements in between the apposing edges will be 
% splice_gap-1.
%
% Example 1: find_repeats([1 0 0 1 1 1 0 1 0 0], 1) will return 
% start_ind = [1,4,8] and end_ind = [1,6,8] as indices of repetitions of 1.
%
% Example 2: find_repeats([11,52,30,4,4,4,5,8,9], 4) - will return 
% start_ind = 4 and end_ind = 6 as indices of repetitions of the value 4.
%
% Example 3: find_repeats([11,52,30,4,4,5,4,4,4,17,29], 4, 2) - will return 
% start_ind = 4 and end_ind = 9 as indices of repetitions of the value 4
% because the gap of 2 between the two subarrays of 4 will now be ignored.
%
% Example 4: find_repeats([11,52,30,4,4,5,9,4,4,4,17,29], 4, 3) will return 
% start_ind = 4 and end_ind = 10 as indices of repetitions of the value 4
% because the gap of 3 between the two subarrays of 4 will now be ignored.
%
% Mani Subramaniyan 2022-06-23

if nargin < 3
    splice_gap = 0;
end

% Cast input as row vector
x = x(:)';

xb_ind = find(x==b);

if ~isempty(xb_ind)
    di_spliced = diff(xb_ind);    
    di_spliced(di_spliced <= splice_gap) = 1; % Replacing "small gaps" with 1 essentially joins the adjacent segments
    df_ind = find(di_spliced> 1); % locations where break of continuity occurs
    end_ind = [xb_ind(df_ind), xb_ind(end)]; % for the last subarray, need to manually add end location
    start_ind = xb_ind([1, df_ind+1]); % for the first subarray, need to manually add beginning location
else
    start_ind = [];
    end_ind = [];
end


