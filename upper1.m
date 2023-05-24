function ustr = upper1(str)
% Change any string into lowercase with the first letter upper case.
% Example:
%       upper1('resilient') - returns 'Resilient'
%       upper1('RESILIENT') - returns 'Resilient'
%
% Mani Subramaniyan 2023-05-24

ss = lower(str);
ustr = [upper(ss(1)) ss(2:end)];