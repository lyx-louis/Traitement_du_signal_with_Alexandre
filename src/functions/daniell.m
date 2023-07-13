function P = daniell(sig,Nfft,winsize, zeroPadding,Fs)
%DANIELL computes the Daniell periodogram of the signal
%
%   DANIELL(SIG) returns the periodogram of the signal
%
%   DANIELL(SIG,WINSIZE) returns the periodogram of the signal, where the
%   mean was computed using WINSIZE+1 values
%
%   DANIELL(SIG,WINSIZE,NFFT) returns the periodogram of the signal, where
%   the mean was computed using WINSIZE+1 values, and the fft of SIG was
%   computed on NFFT points
%
%   DANIELL(SIG,WINSIZE,NFFT, ZEROPADDING) returns the periodogram of the signal, where
%   the mean was computed using WINSIZE+1 values, and the fft of SIG was
%   computed on NFFT points. The signal is zero-padded to have a length
%   equal to a power of 2, if ZEROPADDING is set as 'on'
%% =============== ARGS

if ~exist('winsize','var')
    winsize=16;
end

if ~exist('Nfft','var')
    Nfft=256;
end

if ~exist('zeroPadding','var')
    zeroPadding='off';
end


%% =============== POWER SPECTRUM

SigFft        = fft(sig,Nfft);
PowerSpectrum = abs(SigFft.^2)/length(sig);

%% =============== SMOOTHING

for loop=1:length(PowerSpectrum)
    Interval = loop-winsize/2:loop+winsize/2;
    Interval = mod(Interval-1, length(PowerSpectrum))+1;
    PowerSpectrum(loop) = mean(PowerSpectrum(Interval));
end


P = PowerSpectrum;
 
end
