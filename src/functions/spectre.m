function spect = spectre(sig,Nfft,Fs)
%spectre(sig, Nfft) is a function which calculate directly the power
%spectrum
%   sig -> signal which used to calculate power spectrum
%   Nfft -> number of points used in fft();

%
spect = abs(fft(sig,Nfft).^2)/length(sig);
%
% f=(-length(spect)/2:length(spect)/2-1)*Fs/length(spect);
% figure; grid on;
% plot(f,fftshift(spect));
% xlabel('Frequency/Hz');ylabel('Powerspectrum/dB');
% title('resultat de spectre de puissance');

end

