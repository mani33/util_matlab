function dcorr = dist_corr(X,Y,omitnan)
% function dcorr = dist_corr(X,Y,omitnan)
% Compute  Gábor J. Székely's distance correlation as described in Wikipedia
%
% Inputs:
%   X and Y are vectors (row or column)
%   omitnan - boolean (false by default); if true, nan's from X and
%   corresponding elements in Y (even if y's element is not nan) will be
%   removed. Same is done for Y. This step is done before any computation
%   begins.
%
% Outputs:
%   dcorr - distance correlation, scalar
%
% Mani Subramaniyan 2022-12-06
if nargin < 3
    omitnan = false;
end
% Remove NaN's if asked for
if omitnan
    nan_ind = isnan(X) | isnan(Y);
    good_ind = ~nan_ind;
    X = X(good_ind);
    Y = Y(good_ind);
    assert(any(good_ind),['All elements of X or Y are NaN. Set "omitnan" ' ...
        'argument to false to accept NaN as dist_corr'])   
end
dvar_x = dist_cov(X,X);
dvar_y = dist_cov(Y,Y);
deno = sqrt(dvar_x*dvar_y);
dcorr = dist_cov(X,Y)/deno;

function dcov = dist_cov(X,Y)
% function dcov = dist_cov(X,Y)
% Compute  Gábor J. Székely's distance covariance as described in Wikipedia
% Mani Subramaniyan 2022-12-06
% Inputs:
%   X and Y are vectors (row or column). Set X and Y equal to obtain
%   distance variance, which is handy for computing distance correlation as
%   shown below:
%   distance correlation(X,Y)^2 = (dist_cov(X,Y)^2)/sqrt(dist_cov(X,X)*dist_cov(Y,Y))
% Outputs:
%   dcov - distance correlation, scalar
dcov2 = (1/(length(X)^2)) * sum(doubly_centered(X).*doubly_centered(Y),'all');
dcov = sqrt(dcov2);

function A_jk = doubly_centered(X)
% Compute pairwise distances between each element within X
X = X(:);
xr = repmat(X,1,length(X)); % replicate V column vector
% Pairwise distances
dxx = abs(xr-xr');
% Center each element by the row mean and column mean and add grand mean
marginal = mean(dxx,1); % row and column mean are the same by symmetry of dxx
row_centered = bsxfun(@minus, dxx, marginal); % subtract row means
row_col_centered = bsxfun(@minus, row_centered, marginal'); % subtract column mean
A_jk = row_col_centered + mean(dxx(:)); % add grand mean

