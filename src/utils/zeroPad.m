function [sig] = zeroPad(sig)
%ZEROPAD Summary of this function goes here
%   Detailed explanation goes here
[h,w]=size(sig)
if h~=1
    sig=sig';
end
newLength = 2^(ceil(log2(length(sig))));
if newLength~=length(sig)
    sig = [sig zeros(1,newLength-length(sig))];
end
end

