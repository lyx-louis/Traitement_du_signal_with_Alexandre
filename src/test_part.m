function [ret,puissance] = test_part(sig, fmin, fmax, fs, padding, periodogram, method)
%FREQPOWER estimates the power of the signal given between fmin and fmax
%
%   ARGS:
%       sig              --> signal to process
%       fmin             --> lower boundary for estimation
%       fmax             --> higher boundary for estimation
%       fs               --> sampling frequency of our signal
%       padding          --> boolean to choose if we do zero-padding
%                            (default: false)
%       periodogram      --> string to choose if we simply return the
%                            estimated power, or the desired periodogram
%                            (default: "None")
%       method           --> the method used to compute the power (default:
%                            "rectangle")
%
%   PERIODOGRAM VALUES:
%       "None"           --> Computes the power spectrum
%       "Welch"          --> Computes the periodogram via Welch's method
%       "Capon"          --> Computes the periodogram via Capon's method
%       "Bartlett"       --> Computes the periodogram via Bartlett's
%           method
%       "Blackman-Tukey" --> Computes the periodogram via Blacman-Tukey's
%           method
%
%   METHOD VALUES:
%       "rectangle"      --> rectangles method
%       "trapezium"      --> trapezium method
%

ret=0; % debug value
TODO = "Sorry, this is yet to be implemented.";

%% === Checking args

if ~exist('padding','var')
    padding=0;
end

if ~exist('periodogram','var')
    periodogram="None";
end

if ~exist('method','var')
    method="rectangle";
end

%% === If sig is a column, transforms it as a row
[a,b] = size(sig);
if a~=1 && b~=1 % matrix
    error("Expected sig to be a vector, got a matrix.");
end

if a==1 && b==1
    error("Expected sig to be a vector, got a scalar");
end


if a~=1 % if column vector
    sig=sig.';
end
%% === Zero-padding if needed

if padding
    l = length(sig);
    p = ceil(log2(l)); % nearest power of 2
    
    sig = [sig zeros(1,pow2(p)-l)];
end

%% === POWER Processing
len = length(sig);
if periodogram~="None" % periodogram requested
    switch periodogram
        case "Welch"
            %  1.指定窗大小 即 做fft的点数（Nfft）3.重叠率 4.窗函数类型
            Nfft = ceil(len/8);
            rate = 10;
            n_overlap   = ceil(Nfft * rate * 0.01);
            L = floor((len - n_overlap ) / (Nfft - n_overlap));
            N_used = (Nfft - n_overlap) * (L - 1) + Nfft;
            signal_used = sig(1,1:N_used);
            window_fun = window(@rectwin, Nfft);
            P_win      = sum(window_fun.^2)/Nfft;
            spect = 0;
            for n = 1:1:L
                nstart = ( n - 1 )*(Nfft - n_overlap);  % 每个窗的起始点
                %ZAt=signal_used(1,nstart + 1: nstart + Nfft);
                
                temp_signal = signal_used(1,nstart + 1: nstart + Nfft).*window_fun';
                spect = spect+ abs(fft(temp_signal,Nfft).^2)/(Nfft*P_win);
                
            end
            spect = spect./L;
            f = (0:length(spect)-1)*fs/length(spect);
            figure,
            plot(f(1:Nfft/2),spect(1:Nfft/2),'r');
            xlabel('Frequency/Hz');ylabel('Powerspectrum/dB');
            xlim([fmin fmax]);
            title('reusltat de periodogramme Welch');
        case "Bartlett"
            Nsec = ceil(len/8);
            Pxx1 = abs(fft(sig(1:Nsec),Nsec).^2)/Nsec;
            Pxx2 = abs(fft(sig(Nsec:2*Nsec),Nsec).^2)/Nsec;
            Pxx3 = abs(fft(sig(2*Nsec:3*Nsec),Nsec).^2)/Nsec;
            Pxx4 = abs(fft(sig(3*Nsec:4*Nsec),Nsec).^2)/Nsec;
            Pxx5 = abs(fft(sig(4*Nsec:5*Nsec),Nsec).^2)/Nsec;
            Pxx6 = abs(fft(sig(5*Nsec:6*Nsec),Nsec).^2)/Nsec;
            Pxx7 = abs(fft(sig(6*Nsec:7*Nsec),Nsec).^2)/Nsec;
            Pxx8 = abs(fft(sig(7*Nsec:len),Nsec).^2)/Nsec;
            
            spect = (Pxx1+Pxx2+Pxx3+Pxx4+Pxx5+Pxx6+Pxx7+Pxx8)./8;
            
            f = (0:length(spect)-1)*fs/length(spect);
            
            figure,
            plot(f(1:Nsec/2),spect(1:Nsec/2),'b');
            xlabel('Frequency/Hz');ylabel('Powerspectrum/dB');
            title('reusltat de periodogramme Bartlett');
            %                 N = length(sig);
            %                 K=8;
            %                 M = ceil(N/K);
            %                 sigP=zeros(1,N);
            %                 sigtmp=zeros(1,M);
            %                 for i=0:K-1
            %                     sigtmp(:) = sig(i*M+1:min((i+1)*M,N));
            %                     sigPtmp = abs(fft(sigtmp)).^2;
            %                     sigP(i*M+1:min((i+1)*M,N)) = sigPtmp(:);
            %                 end
            %
            %                 figure;plot(10*log10(fftshift(sigP)));
            %                 title("Bartlett PSD estimate");
            %                 xlim([fmin, fmax]);
            
        case "Blackman-Tuckey" % auto -correlation
            auto_corr = xcorr(sig, 'unbiased');
            spect = abs(fft(auto_corr,len));
            f = (0:length(spect)-1)*fs/length(spect);
            
            figure;
            plot(f(1:len/2),spect(1:len/2),'r');title('自相关函数法实现功率谱估计');
        case "Capon"
            disp(TODO)
            
    end
else                   % power spectrum
    spect = abs(fft(sig,len).^2)/len;
    f = (0:length(spect)-1)*fs/length(spect);
    figure;
    plot(f(1:len/2),spect(1:len/2),'r');
    xlabel('Frequency/Hz');ylabel('Powerspectrum/dB');
    title('resultat de spectre de puissance');
    %         spect = abs(fft(signal,len).^2)/len;
end

%% === estimer la puissance
i = 1;
while f(i)<fmin
    i = i+1;
end
min_index = i;

i = 1;
while f(i) < fmax
    i = i+1;
end
max_index = i;


nbr_espace_spect = max_index - min_index;
msf = zeros(1,nbr_espace_spect);

if method == "rectangle"
    for i=0:nbr_espace_spect-1
        msf(i+1) = 1*spect(min_index+i);
        
    end
else
    for i=0:nbr_espace_spect-1
        msf(i+1) = (spect(min_index+i)+spect(min_index+i+1))*1/2;
    end
end
for i=0:nbr_espace_spect-1
    if msf(i+1) == max(msf)
        k = i+1;
    end
    
end

puissance = sum(msf)/nbr_espace_spect;




end

