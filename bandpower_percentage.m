function per_power = bandpower_percentage(x,fs,fstart,fend)
% Get percentage of given band's power
% Mani Subramaniyan 2022-09-20

% This is essentially copy-pasted from MATLAB's help. No idea here is mine.
[Pxx,F] = periodogram(x(:)',rectwin(length(x)),length(x),fs);
pBand = bandpower(Pxx,F,[fstart fend],'psd');
pTot = bandpower(Pxx,F,'psd');
per_power = 100*(pBand/pTot);