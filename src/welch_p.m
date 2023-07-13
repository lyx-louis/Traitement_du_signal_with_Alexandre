function DSP = welch_p(x, w, offset, Nfft)
%WELCH_P processes the Welch's periodogram of a signal x
%   x is the signal of interest
%   w is the window used
%   offset is the offset between two segments
%   Nfft is the number of points used for the fft
% It returns the SPD of x as the variable DSP

L=length(w); % segments length
if offset>0 && L-offset>=0 % positive overlap, no more overlap than length
    D=offset; % starting point of segments (L MUST be higher than overlap)
else
    if offset==0
        error("offset MUST be a strictly positive integer")
    else
        error("offset MUST NOT be higher than L")
    end
end

K=ceil(length(x)/offset); % number of segments
                                % 1 is added to overlap, so no division by
                                % 0 is done

%% FRAMING                
                                
framed_signal=zeros(L,K); % each segment is a column. L lines, of K columns
    % means K segments of length L
offset_count=0;
for l=1:K %foreach segment
    for j=1:L %foreach elem in segment
        if offset_count*D+j<=length(x)
            framed_signal(j,l)=x(offset_count*D+j);
        end
    end
    offset_count=offset_count+1;
end

%% FINITE FOURIER TRANSFORMS

% Applying our window

framed_signal_windowed=zeros(L,K);
framed_signal_windowed_fft=zeros(Nfft,K);
I=zeros(Nfft,K);
for i=1:K
    framed_signal_windowed(:,i)=conv(framed_signal(:,i),w,'same');
    framed_signal_windowed_fft(:,i)=fft(framed_signal_windowed(:,i),Nfft);
    U=sum(w(1:L).^2)/L;
    I(:,i)=(L/U)*abs(framed_signal_windowed_fft(:,i)).^2;
end

DSP=zeros(1,Nfft);
for f=1:Nfft
    DSP(f)=(1/K)*sum(I(f,:));
end

   
        

end

