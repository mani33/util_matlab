function set_common_prop(fig_handles,child_obj_name,varargin)
%
% Mani Subramaniyan 2022-10-21

args = struct;
% change all fields to lowercase in case user supplies lower, upper, camelcase
% or mixed case
char_uargs = cellfun(@(x) ischar(x), varargin);
lower_char_uargs = lower(varargin(char_uargs));
varargin(char_uargs) = lower_char_uargs;
args = parse_var_args(args,varargin{:});

nFig = length(fig_handles);
for iFig = 1:nFig
    figure(fig_handles(iFig))
    sel_obj = findobj(gcf,'Type',child_obj_name);
    % Exclude suptitle which shows up as Axes
    % st_ax = arrayfun(@(x) any(strcmp(x.Tag,{'suptitle','suplabel'})),sel_obj);
    % sel_obj = sel_obj(~st_ax);

    fields = fieldnames(args);
    nProp = length(fields);
    for iProp = 1:nProp
        cfield = fields{iProp};
        set(sel_obj,cfield,args.(cfield))
    end
    shg
end