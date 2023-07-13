function [spect,perio,p_spect_v,p_perio_v] = part1_func(signal,fmin,fmax,Fs,padding,recotra)
%FREQPOWER estimates the power of the signal given between fmin and fmax
%
%   ARGS:
%       signal              --> signal to process
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
len = length(signal);





if(padding)
    k = ceil(log2(len));
    N = 2^k; 
    Nsec = N/8;
    pad = N - len;
    pad_mat = zeros(1,pad);
    signal = [signal pad_mat];
    len = N;
% spectre de puissance
spect = abs(fft(signal,N).^2)/N;
f = (0:length(spect)-1)*Fs/length(spect);

figure;
plot(f(1:N/2),spect(1:N/2),'r');grid on;



%peridogramme
Pxx1 = abs(fft(signal(1:Nsec),Nsec).^2)/Nsec;
Pxx2 = abs(fft(signal(Nsec:2*Nsec),Nsec).^2)/Nsec;
Pxx3 = abs(fft(signal(2*Nsec:3*Nsec),Nsec).^2)/Nsec;
Pxx4 = abs(fft(signal(3*Nsec:4*Nsec),Nsec).^2)/Nsec;
Pxx5 = abs(fft(signal(4*Nsec:5*Nsec),Nsec).^2)/Nsec;
Pxx6 = abs(fft(signal(5*Nsec:6*Nsec),Nsec).^2)/Nsec;
Pxx7 = abs(fft(signal(6*Nsec:7*Nsec),Nsec).^2)/Nsec;
Pxx8 = abs(fft(signal(7*Nsec:N),Nsec).^2)/Nsec;

perio = (Pxx1+Pxx2+Pxx3+Pxx4+Pxx5+Pxx6+Pxx7+Pxx8)/8;

f2 = (0:length(perio)-1)*Fs/length(perio);

hold on
plot(f2(1:Nsec/2),perio(1:Nsec/2),'b');
xlabel('Frequency/Hz');
title('Comparer reusltat spectre et periodogramme');
legend('spectre de puissance', 'periodogramme');

figure,
plot(f(1:N/2),10*log(spect(1:N/2)),'r');grid on;
hold on
plot(f2(1:Nsec/2),10*log(perio(1:Nsec/2)),'b');
xlabel('Frequency/Hz');ylabel('Powerspectrum/dB');
title('Comparer reusltat spectre et periodogramme en db');
legend('spectre de puissance', 'periodogramme');


else
    spect = abs(fft(signal,len).^2)/len;
    
    
f = (0:length(spect)-1)*Fs/length(spect);
figure;
plot(f(1:len/2),spect(1:len/2),'r');grid on;

Nsec = ceil(len/8);
    
Pxx1 = abs(fft(signal(1:Nsec),Nsec).^2)/Nsec;
Pxx2 = abs(fft(signal(Nsec:2*Nsec),Nsec).^2)/Nsec;
Pxx3 = abs(fft(signal(2*Nsec:3*Nsec),Nsec).^2)/Nsec;
Pxx4 = abs(fft(signal(3*Nsec:4*Nsec),Nsec).^2)/Nsec;
Pxx5 = abs(fft(signal(4*Nsec:5*Nsec),Nsec).^2)/Nsec;
Pxx6 = abs(fft(signal(5*Nsec:6*Nsec),Nsec).^2)/Nsec;
Pxx7 = abs(fft(signal(6*Nsec:7*Nsec),Nsec).^2)/Nsec;
Pxx8 = abs(fft(signal(7*Nsec:len),Nsec).^2)/Nsec;

perio = (Pxx1+Pxx2+Pxx3+Pxx4+Pxx5+Pxx6+Pxx7+Pxx8)/8;


f2 = (0:length(perio)-1)*Fs/length(perio);

hold on
plot(f2(1:Nsec/2),perio(1:Nsec/2),'b');
xlabel('Frequency/Hz');
title('Comparer reusltat spectre et periodogramme');
legend('spectre de puissance', 'periodogramme');
end
%% calculer pour la bande

% pour spect puissance 
i = 1;
while f(i)<fmin
   i = i+1;   
end
min_index_1 = i;

i = 1;
while f(i) < fmax
    i = i+1;
end
max_index_1 = i;

figure;
plot(f(min_index_1:max_index_1),spect(min_index_1:max_index_1),'r');grid on;




% pour periodogramme
i = 1;
while f2(i)<fmin
   i = i+1;   
end
min_index_2 = i;

i = 1;
while f2(i) < fmax
    i = i+1;
end
max_index_2 = i;

hold on;
plot(f2(min_index_2:max_index_2),perio(min_index_2:max_index_2),'b');title('periodogramme et spect dans la bande');
xlabel('Hz');
legend('spectre de puissance', 'periodogramme');
%% methode pour calculer  : rectangle ouo trapeze
 nbr_espace_spect = max_index_1 - min_index_1;
 nbr_espace_perio = max_index_2 - min_index_2;
 msf = zeros(1,nbr_espace_spect);
 msp = zeros(1,nbr_espace_perio); 
if(recotra)
    
    for i=0:nbr_espace_spect-1
        msf(i+1) = 1*spect(min_index_1+i);
    end
  
   
  
    for i=0:nbr_espace_perio-1
        msp(i+1) = 1*perio(min_index_2+i);
    end
   


    % theorie:
%     p_theorie_s = sum(spect(min_index_1:max_index_1))/nbr_espace_spect
%     
%     p_theorie_p = sum(perio(min_index_2:max_index_2))/nbr_espace_perio
else
    for i=0:nbr_espace_spect-1
        msf(i+1) = (spect(min_index_1+i)+spect(min_index_1+i+1))*1/2;
    end
    
    for i=0:nbr_espace_perio-1
        msp(i+1) = (perio(min_index_2+i)+perio(min_index_2+i+1))*1/2;
    end
end
p_spect_v = sum(msf)/nbr_espace_spect;
p_perio_v = sum(msp)/nbr_espace_perio;





end

