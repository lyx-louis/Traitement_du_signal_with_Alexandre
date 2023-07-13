function spect = welch(sig,win_size,Nfft,rate_overlap,win_type)
%Welch is a function which calculate the power spectrun by periodogram
%Welch
%   sig -> signal to calculate power spectrum
%   win_size -> size of window
%   rate_overlap -> rate of overlap, the value is lower than 1
%   win_type -> type of windows, exemple : hamming, rectan,triang...  for
%   more type of window, use commande doc window:
%   Nfft => number of point used in fft();
len = length(sig);
n_overlap = ceil(win_size*rate_overlap*0.01);
if n_overlap == win_size
    error("overlap can't be window size");
end
L = floor((len - n_overlap ) / (win_size - n_overlap));
N_used = (win_size - n_overlap) * (L - 1) + win_size;
signal_used = sig(1,1:N_used);

window_fun = window(win_type, win_size);
P_win      = sum(window_fun.^2)/win_size;
spect = 0;
for n = 1:1:L
    nstart = ( n - 1 )*(win_size - n_overlap);  % 每个窗的起始点
    %ZAt=signal_used(1,nstart + 1: nstart + Nfft);
    
    if n_overlap == win_size
        error("overlap can't be window size");
    end
    
    len = length(sig);
    %n_overlap = ceil(win_size*rate_overlap*0.01);
    L = floor((len - n_overlap ) / (win_size - n_overlap));
    N_used = (win_size - n_overlap) * (L - 1) + win_size;
    signal_used = sig(1,1:N_used);
    window_fun = window(win_type, win_size);
    P_win      = sum(window_fun.^2)/win_size;
    spect = 0;
    
    temp_signal = signal_used(1,nstart + 1: nstart + win_size).*window_fun';
    spect = spect+ abs(fft(temp_signal,Nfft).^2)/(win_size*P_win);
    spect = spect./L;
    %         f = (0:length(spect)-1)*fs/length(spect);
end



end