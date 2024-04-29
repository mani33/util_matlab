function set_figure_size(fig_handle,wh)

fh = fig_handle;
original_units = get(fh,'Units');
set(fh,'Units','Inches')
p = get(gca,'Position');
p(3:4) = wh;
set(fh,'Position',p)
set(fh,'Units',original_units)