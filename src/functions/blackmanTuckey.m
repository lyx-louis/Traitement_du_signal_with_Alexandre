function spect = blackmanTuckey(sig,Nfft,Fs)
%blackmanTuckey is a function which calculate the power spectrun by methode
%Blackman-Tuckey
%   sig -> signal to calculate power spectrum
%   Nfft => number of point used in fft();
auto_corr = xcorr(sig, 'unbiased');
spect = abs(fft(auto_corr,Nfft));

end

