function [Sx, f, t, mean_f] = spectro(x,w,d,N_fft,Fs,display)
% This function computes the spectrogram for m = [0, d, 2d, 3d...]
% This function outputs are:
% -> Sx, which is a matrix of n_fft lines and
%                            M (number of elements of m) columns
%    Sx(i,j) is the value of the spectrogram for time t(i) and frequency
%    f(j)
% -> f, is a column vector of the frequencies (in Hz)
% -> t, is a row vector containing the times of the beginning of the
% windows

if d==0
    error("d MUST be at least 1");
end

display_bool=strcmp(display,'display');

X=stft(x,w,d,N_fft,Fs);
Sx=(abs(X).^2)./length(w);
L=length(x);
M=floor(L/d);
t=(1:M)*d;
t=t*(1/Fs);
f=(0:N_fft-1)*Fs;
f=f';
fchanged=zeros(length(f)/2,1);

for i=1:length(f)
    fchanged(i)=f(length(f)-i+1);
end

mean_f=0;
for i=1:length(Sx(:,1))
    [amp,freq]=max(Sx(i,:));
    mean_f=mean_f+freq;
end
mean_f=mean_f/length(t);

if (display_bool)
    figure();
    faxis=0:Fs/length(f):Fs;
    imagesc(t,faxis,10*log10(Sx))
    title("Spectrogram obtained via spectro.m");
    set(gca, 'YDir','normal')
    ylim([0 100])
    caxis([-20 60])
    xlabel("time in seconds (s)")
    ylabel("Frequency in Hertz (Hz)")
    cb=colorbar;
    ylabel(cb,"Power/Frequency (Db/Hz)");
end

end

