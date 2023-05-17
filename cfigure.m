function cfigure(create_figure,fig_num)
% Create either a new figure or make given figure number (fig_num) as
% current figure conditionally. Useful in a loop when you need a new figure
% conditionally. Saves you an if statement.
%
% Usage:
% cfigure(true) - creates a new figure
% cfigure(true,12) - creates or makes active figure number 12
% cfigure(false,12) - does nothing
% cfigure(false) - does nothing
%
% Mani Subramaniyan 2023-04-07

if create_figure
    if nargin < 2
        figure
    else
        figure(fig_num)
    end
end