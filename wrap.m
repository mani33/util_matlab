function wx = wrap(x,n)
% Wrap x around n.
% Example:
% 1 = wrap(1,3)
% 2 = wrap(2,3)
% 3 = wrap(3,3)
% 1 = wrap(4,3)
% 2 = wrap(5,3)

wx = 1 + mod(x-1,n);