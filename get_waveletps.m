function [wps,Fc_vec,Fb_vec,sf] = get_waveletps(data_vec,freq_begin,freq_end,fs,varargin)
% Get wavelet transform of the given data vector (data_vec).
% [wps,Fc_vec,Fb_vec,sf] = get_waveletps(data_vec,...)
%
% Mani Subramaniyan
% 2021-11-08
% 2022-09-16
% Inputs: data_vec - input signal.
%
% Outputs:  wps - wavelet power spectrum (size: num of center freq x length of input sig)
%           Fc_vec - vector of center frequencies
%           Fb_vec - vector of time decay parameters
%           sf - vector of std of freq domain Gaussian of the wavelets

args.freq_std_scaling_meth = 'log'; % log, linear, custom
args.freq_std_begin = 0.1250;
args.freq_std_end = 2.5000;
args.freq_scaling_meth = 'log'; % log, linear, custom
args.custom_freq_vec = []; % if the freq_scaling_meth is 'custom' then, this field must be supplied
args.custom_freq_std_vec = []; % if the freq_std_scaling_meth is 'custom' then, this field must be supplied
args.nfreq = 30;
args.wave_halfwidth = 2.5000;
args = parse_var_args(args,varargin{:});

N = length(data_vec(:));
% Get Fc - center frequencies for the wavelets
Fc_vec = get_Fc(freq_begin,freq_end,args.freq_scaling_meth,args.nfreq,args);

% Get the time decay parameter Fb
[Fb_vec,sf] = get_Fb(args.freq_std_begin,args.freq_std_end,args.freq_std_scaling_meth,args.nfreq,args);

% Compute number of samples for the wavelet
wave_nsamples = 2*round(args.wave_halfwidth*fs)+1; % make sure it is odd number

wps = zeros(args.nfreq,N);

% Main idea: To compute the spectrogram, you convolve the data (time
% domain) with the time domain version of the wavelet. However, instead of 
% convolving the data with the wavelet in the time domain, we are going to 
% do the equivalent, that is, multiplication of the data and wavelet
% in the frequency domain. 

n_fft = N + wave_nsamples -1;
half_wavelet = (wave_nsamples-1)/2;

% Do the data FFT outside the loop because the data remains the same for
% all the loops below. You only need to compute fresh FFT for the wavelets 
% because their parameters change in every loop.
fft_data = fft(data_vec, n_fft);
debug = false;

for i = 1:args.nfreq
    % Create complex morelet wavelet
    psi = get_wavelet(-args.wave_halfwidth,args.wave_halfwidth, ...
        wave_nsamples,Fb_vec(i),Fc_vec(i));
    % Make sure that the norm is 1
    psi = psi/norm(psi);
    if debug
        plot(real(psi)); hold all; plot(imag(psi));%#ok
        hold off
    end
    % Computer FFT of the wavelet. Make sure that the FFT length (nConv) is matched
    % with that of the data. This is important because we are going to multiply
    % element-by-element in the frequency domain outputs of the FFT of the data
    % and the wavelet.
    fft_psi = fft(psi,n_fft);
    % Get time domain signal back after ifft
    conv_out = abs(ifft(fft_data.*fft_psi,n_fft));
    % Trim off the edges as they have the convolution warm up artifact
    conv_out = conv_out(half_wavelet+1:end-half_wavelet);
    wps(i,:) = conv_out;
end

function [wt,t] = get_wavelet(LB,UB,N,Fb,Fc)
% [wt,t] = get_wavelet(LB,UB,N,Fb,Fc)
% Compute complex Morlet wavelet with given parameters.
% Mani Subramaniyan
% 2021-11-08
t = linspace(LB,UB,N)';
wt = (1/sqrt(pi*Fb))*exp((1i*2*pi*Fc*t)-((t.^2)/Fb));

function Fc_vec = get_Fc(freq_begin,freq_end,freq_scaling_meth,nfreq,args)
% Fc_vec = get_Fc(freq_begin,freq_end,freq_scaling_meth)
% Get the center frequencies for the wavelets
fbound = [freq_begin,freq_end];
switch freq_scaling_meth
    case 'log'
        Fc_vec = logspace(log10(fbound(1)),log10(fbound(2)),nfreq);
    case 'linear'
        Fc_vec = linspace(fbound(1),fbound(2),nfreq);
    case 'custom'
        Fc_vec = args.custom_freq_vec;
    otherwise
        error('Unknown method')
end

function [Fb_vec,sf] = get_Fb(freq_std_begin,freq_std_end,freq_std_scaling_meth,nfreq,args)
% [Fb_vec,sf] = get_Fb()
% Get the time decay parameter (Fb) set for the wavelets. Also return wavelets'
% frequency domain Gaussian's standard deviation that depends on Fb.
% Mani Subramaniyan
% 2021-11-08

fbound = [freq_std_begin,freq_std_end];
% Relationship between wavelet's time domain std (std_t) and frequency domain std (std_f) is:
% std_f = 1/(2*pi*std_t)
% Matlab's Fb = 2*std_t^2

switch freq_std_scaling_meth
    case 'log'
        sf = logspace(log10(fbound(1)),log10(fbound(2)),nfreq);
    case 'linear'
        sf = linspace(fbound(1),fbound(2),nfreq);
    case  'custom'
        sf = args.custom_freq_std_vec;        
    otherwise
        error('Unknown method')
end
Fb_vec = 1./(2*(pi*sf).^2);