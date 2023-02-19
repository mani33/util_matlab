function bin_avg = bin_and_avg_data_by_time(x,x_time,time_bin_edges,varargin)
% bin_and_avg_data_by_time(x,x_time,time_bin_edges) - average time series
% data points falling within each bin of time bin edges.
%
% Mani Subramaniyan 2023-02-17
args.omitnan = true;
args = parse_var_args(args,varargin{:});
time_bin_ind = discretize(x_time,time_bin_edges);
nBins = length(time_bin_edges)-1;
bin_avg = nan(nBins,1);
for iBin = 1:nBins
    if args.omitnan
        bin_avg(iBin,1) = mean(x(time_bin_ind==iBin),'omitnan');
    else
        bin_avg(iBin,1) = mean(x(time_bin_ind==iBin),'includenan');
    end
end