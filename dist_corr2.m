function dcorr = dist_corr2(X,varargin)
% function dcorr = dist_corr2(X,varargin)
% Compute  Gábor J. Székely's distance correlation as described in Wikipedia
% 
% Inputs:
%   X is a nObservations-by-nVariables matrix
%   Optional (name,value) paris for handling NaN containing rows: ('rows', 
%   one of {'all','complete','pairwise'}). Default is 'all'
% Outputs:
%   dcorr - distance correlation matrix
%
% Example:
%
%   X = [1      2       3       4
%        nan    3       7       9
%        7      nan3    11      8
%        12     76      8       4]
%
%   dist_corr2(X,'rows','complete') - Before staring computation, removes
%   a row if it contain NaN in one or more columns. Therefore, in the end,
%   you will start with a new version of matrix X that contains fewer
%   observations (2 rows in the example) but without any NaN's anywhere 
%   in the matrix and end with a 4-by-4 dist corr matrix.
%   
%   dist_corr2(X,'rows','pairwise') - Here rows are not removed before
%   starting computation. Rather, when a specific combination of two rows
%   are taken, rows with NaN are removed. In the example X, when corr is
%   computed for the columns 1 and 2, rows 2 and 3 are removed, but for
%   columns 3 and 4, no rows are removed.
%
% Mani Subramaniyan 2022-12-09

args.rows = 'all';
args = parse_var_args(args,varargin{:});
omitnan = false;
% Remove nan rows
switch args.rows
    case 'complete'
        [nan_rows,~] = find(isnan(X));
        X = X(~nan_rows,:);
    case 'pairwise'
        omitnan = true;
end
nCols = size(X,2);
dcorr = nan(nCols,nCols);
% Note that this code is not efficient as it computes all elements of the
% correlation matrix which is not necessary (you only need to compute half
% of the elements as the correlation matrix is symmetric)
for iVar = 1:nCols
    for jVar = 1:nCols
        dcorr(iVar,jVar) = dist_corr(X(:,iVar),X(:,jVar),omitnan);
    end
end
