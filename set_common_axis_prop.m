function set_common_axis_prop(fig_obj,varargin)
%
% Mani Subramaniyan 2022-10-21

args = struct;
% change all fields to lowercase in case user supplies lower, upper, camelcase
% or mixed case
char_uargs = cellfun(@(x) ischar(x), varargin);
lower_char_uargs = lower(varargin(char_uargs));
varargin(char_uargs) = lower_char_uargs;
args = parse_var_args(args,varargin{:});

axes_obj = findobj(fig_obj,'Type','Axes');
  % Exclude suptitle which shows up as Axes
st_ax = arrayfun(@(x) any(strcmp(x.Tag,{'suptitle','suplabel'})),axes_obj);
axes_obj = axes_obj(~st_ax);

fields = fieldnames(args);
nProp = length(fields);
for iProp = 1:nProp
    cfield = fields{iProp};
    set(axes_obj,cfield,args.(cfield))
end
shg