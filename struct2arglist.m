function argList = struct2arglist(params)
% function argList = struct2arglist(params)
% MS 2009-02-24
% This function takes a structure and converts it into
% {param1,val1,param2,val2,...} convenient for passing the list to
% functions.

if isempty(params)
    argList = {};
    return
end
fieldNames = fields(params);
vals = struct2cell(params);
paramValArray = [fieldNames'; vals'];
argList = paramValArray(:)';