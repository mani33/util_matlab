function Y = make_segments(x,n,p,valid_last_seg)
% Segment the given vector into segments with or without overlap.
% Y = make_segments(X,N,P) partitions the signal vector X into
% N-element segments overlapping by P elements (set P=0 for contiguous partition).
% The last segment may not have N elements from the segmentation. Set the
% valid_last_seg to true to exclude the last segment that is not full
% length. Otherwise, by default, short last segment will be made to full
% length (N) using NaN's making up for missing data points. Output Y is a
% N-by-Num_Segments matrix.
%
% Mani Subramaniyan 2022-06-09

if nargin < 4
    valid_last_seg = false;
end
assert(n > 0, 'N must be > 0')
assert(p >= 0, 'P must be >= 0')
assert(p < n, 'Overlap length(p) must be less than segment length(n)')

nx = length(x);
% Set x as a column vector so we know how to catenate segment elements later on
x = x(:);

done = false;
Y = nan(n,1);
i = 0;
while ~done
    i = i + 1;
    overlap_offset = (i-1)*p;
    % Idea: For contiguous segmenting, you will use (i-1)*n+1 as the
    % segment starting index. Because of overlap, pull this index to the
    % left by (i-1)*p.
    seg_begin = ((i-1)*n+1)-overlap_offset;
    seg_end = seg_begin+n-1;

    % Are we are in the last segment?
    in_last_seg = seg_begin >= (nx-n+1);

    if ~in_last_seg  % Simpler life when NOT in last segment
        Y(:,i) = x(seg_begin:seg_end);
    else % In last segment!
        done = true;
        % Segment end can't go beyond available data
        seg_end = min([nx, seg_end]);
        seg_data = x(seg_begin:seg_end);
        curr_seg_len = length(seg_data);
        if valid_last_seg
            if curr_seg_len==n % Take only full length last segments
                Y(:,i) = seg_data;
            end
        else % Fill in with nan if necessary
            n_fill = n-curr_seg_len;
            Y(:,i) = [seg_data; nan(n_fill,1)];
        end
    end
end