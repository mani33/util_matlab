function bin_avg = get_bin_value_average(x,bin_edges,varargin)
% Compute the average of values falling within each bin
%
% Mani Subramaniyan 2023-02-17
args.omitnan = true;
args = parse_var_args(args,varargin{:});
bin_ind = discretize(x,bin_edges);
nBins = length(bin_edges)-1;
bin_avg = nan(nBins,1);
for iBin = 1:nBins
    if args.omitnan
        bin_avg(iBin,1) = mean(x(bin_ind==iBin),'omitnan');
    else
        bin_avg(iBin,1) = mean(x(bin_ind==iBin),'includenan');
    end
end