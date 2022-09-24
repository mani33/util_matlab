function band_psd = get_wavelet_band_psd(wps,fc,band_freq_start,band_freq_end)
% Compute power spectral density for the given frequency band using the
% wavelet power spectrum given.
% Inputs:
% wps - nFreq-by-nTime wavelet power spectrum (uV^2)
% fc - center frequencies of the wavelets
% [band_freq_start, band_freq_end] - frequency band in which psd is computed
% 
% Output: band_psd - scalar, power/Hz
% 
% Mani Subramaniyan 2022-09-23

bw = diff(fc); % bin width
hbw = bw/2; % half bin width
f1 = band_freq_start;
f2 = band_freq_end;
nFreq = length(fc);
% Get scaling factors for the frequency bins as the bin widths may be
% different for each frequency.
sf = nan(nFreq,1);
% For beginning and end, we will only have half bins. We will simply double
% the half bins to get full bins for these two frequencies.
% The rest will have full bins.
% Deal with edges first:
sf(1) = hbw(1)*2;
sf(end) = hbw(end)*2;
for iFreq = 2:nFreq-1
    sf(iFreq) = hbw(iFreq-1) + hbw(iFreq);
end
% Multiply each column of wps by scaling factor. Can be achieved for all
% time points at once using bsxfun
psd = bsxfun(@times,wps,sf);

% % Get total power (not mean!) in the band of interest
% pr_sel = sum(psd(fc >= f1 & fc < f2,:),1); % psd is nFreq-by-nTime
% pr_tot = sum(psd,1);
% % pp = 100*pr_sel./(pr_tot-pr_sel);
% pp = 100*pr_sel./pr_tot;
freq_len = f2-f1;
band_psd = sum(psd(fc >= f1 & fc < f2,:),1)/freq_len; %  power/hz
