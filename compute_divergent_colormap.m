function cmap = compute_divergent_colormap(val_matching_mid_col, data, clipping_quantiles, ncol)
% MS 2020-12-07
% Create a divergent colormap so that the middle color matches the data
% value given by the user.
% example: cmap = compute_divergent_colormap(100,data,[0.025 0.975],257)

% 1. Find number of colors below the mid color matching data
d = data(:);
m = quantile(d,clipping_quantiles);
R = diff(m); % range
F = (val_matching_mid_col-m(1))/R;
ncol_below = round(ncol*F);
ncol_above = ncol - ncol_below;

chigh =  [0.706, 0.016, 0.150];
cmid = [0.8654, 0.8654, 0.8654];
clow = [0.230, 0.299, 0.754]; 

s_low = linspace(0,1,ncol_below+1);
s_high = linspace(0,1,ncol_above);
maplow = diverging_map(s_low,clow,cmid);
maphigh = diverging_map(s_high, cmid, chigh);

cmap = cat(1, maplow, maphigh(2:end,:));