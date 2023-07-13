function spect = bartlett(sig,winsize,Nfft,Fs)
%BARTLETT is a function which calculate the power spectrun by periodogram
%bartlett
%   sig -> signal to calculate power spectrum
%   Nsec -> number of point to divide signal in diffrent groups
%   Nfft => number of point used in fft();
nbr_fenetre = floor(length(sig)/winsize);
spect = 0;
for i=1:nbr_fenetre
    pxx = sig((i-1)*winsize+1:i*winsize);
    spect = spect + abs(fft(pxx,Nfft)).^2/winsize;
end

spect = spect./nbr_fenetre; % moyennage des fenetres


end

