function d = mdir(varargin)
d = dir(varargin{:});
% File "." and ".." folders and remove them
names = {d.name};
ex = ismember(names,{'.','..'});
d = d(~ex);
