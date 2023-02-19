function en = entropy(X,varargin)
% Compute entropy of given vector or matrix using the following formula:
% 
% en = -sum(p*log2(p)) where p is the histogram count of X.

args.n_bins = 20; % number of hist bins.
args = parse_var_args(args,varargin{:});

c = histcounts(X(:),args.n_bins);
en = -sum(c.*log2(c),'omitnan');