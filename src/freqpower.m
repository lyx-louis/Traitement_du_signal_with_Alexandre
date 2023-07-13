function ret = freqpower(sig, fmin, fmax, fs, padding, periodogram, method)
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
    
    if periodogram~="None" % periodogram requested
        switch periodogram
            case "Welch"
                f=[fmin fmax];
                pxx=pwelch(sig);
                figure;plot(10*log10(pxx));
                title("Welch PSD estimates for signal");
                xlabel("Frequency (Hz)");
                xlim(f);
            case "Bartlett"
                N = length(sig);
                K=8;
                M = ceil(N/K);
                sigP=zeros(1,N);
                sigtmp=zeros(1,M);
                for i=0:K-1
                    sigtmp(:) = sig(i*M+1:min((i+1)*M,N));
                    sigPtmp = abs(fft(sigtmp)).^2;
                    sigP(i*M+1:min((i+1)*M,N)) = sigPtmp(:);
                end
                
                figure;plot(10*log10(fftshift(sigP)));
                title("Bartlett PSD estimate");
                xlim([fmin, fmax]);
                
            case "Blackman-Tuckey"
                disp(TODO)
            case "Capon"
                disp(TODO)
               
        end
    else                   % power spectrum
        n = length(sig);
        fftSig = fft(sig,n);
        powSig = abs(fftSig).^2/length(sig);
        f = length(powSig);
        figure; plot(-f/2:f/2-f/n, fftshift(powSig));
        xlim([fmin, fmax]);
    end
end

