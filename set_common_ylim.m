function set_common_ylim(fig_obj,common_ylimit,r,c)
% set_common_ylim(fig_obj,ylim) - set the ylimit of all the axes objects
% within the figure handle (fig_obj) the given values (ylim). By default,
% the ylimit will be set for all subplots. Optionally either rows or
% columns can be set to the given ylimit; you can't set both rows and
% columns. 
%
% Warning: This function assumes that all the subplots are of the same size.
% If not, unexpected behavior may arise.
% 
% Example1
% set_common_ylim(gcf,[0 10]) - sets all subplots ylimit to [0 10]
% for the current figure.
%
% Example2
% set_common_ylim(gcf,[0 10],[1,3]) - same as example 1 except that now
% only rows 1 and 3 of subplots will have [0,10] as ylimit.
%
% Example3
% set_common_ylim(gcf,[0 10],[],[1,2]) - same as example 1 except that now
% only columns 1 and 2 of subplots will have [0,10] as ylimit.
%
% Not allowed/implemented:
% set_common_ylim(gcf,[0 10],[3,4],[1,2]) - you are trying to set ylimit of
% rows and columns at the same time. This is not implemented.
%
% Mani Subramaniyan 2022-10-21

if nargin == 2
    r = [];
    c = [];
elseif nargin == 3
    c = [];
end

cond = (isempty(r) & isempty(c)) | (~isempty(r) & isempty(c)) | (isempty(r) & ~isempty(c));
assert(cond, 'You can set either the row or the column, not both')

axes_obj = findobj(fig_obj,'Type','Axes');
  % Exclude suptitle which shows up as Axes
st_ax = arrayfun(@(x) strcmp(x.Tag,'suptitle'),axes_obj);
axes_obj = axes_obj(~st_ax);
% Go to each axes object and move text objects to the same relative
% position after altering ylimit
%
% By default, we will set ylimit for all subplots.
axes_obj = select_axes(axes_obj,r,c);

nAx = length(axes_obj);
for iAx = 1:nAx
    ax = axes_obj(iAx);  
    yv = get(ax,'ylim');
    % Any text objects? If yes, get their original y-coordinates to that we
    % can place them back in an equivalent y-position after chaning ylim.
    tob = findobj(ax,'Type','text');
    nTx = length(tob);
    y_rel = nan(nTx,1);
    for iTx = 1:nTx
        p = get(tob(iTx),'Position'); % [x,y,z]
        % original relative position
        d = diff(yv);
        y_rel(iTx) = (p(2)-yv(1))/d;
    end
    % Alter ylimit
    % Clever(!#$) matlab also will alter the xlimit depending on the remaining
    % data points visibile within the new ylimit. So, we need to keep
    % xlimit.
    xv = get(ax,'xlim');
    set(ax,'ylim',common_ylimit)
    set(ax,'xlim',xv);
    % Reset text positions
    for iTx = 1:nTx
        p = get(tob(iTx),'Position');
        new_y = common_ylimit(1)+diff(common_ylimit)*y_rel(iTx);
        new_pos = [p(1) new_y p(3)];
        set(tob(iTx),'Position',new_pos)
    end
end
shg

function sel_axes = select_axes(axes_obj,r,c)
if (isempty(r) && isempty(c))
    sel_axes = axes_obj;
else
    nAx = length(axes_obj);
    pp = nan(nAx,2);
    for i = 1:nAx
        p = get(axes_obj(i),'Position');
        pp(i,:) = p(1:2); % Left, Bottom distances
    end

    % Columns are unique Left distances
    u_left = unique(pp(:,1)); % columns (left-2-right order)
    u_bottom = flipud(unique(pp(:,2))); % rows (top-2-bottom order)

    if ~isempty(r) % Rows selected
        sel_bottom = u_bottom(r);
        sel_ind = ismember(pp(:,2),sel_bottom);
    elseif ~isempty(c) % Columns selected
        sel_left = u_left(c);
        sel_ind = ismember(pp(:,1),sel_left);
    else
        error('You must set rows or columns to non-empty')
    end
    sel_axes = axes_obj(sel_ind);
end

