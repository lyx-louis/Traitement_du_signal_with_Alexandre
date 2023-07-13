function sig = generateAR(length, mean, variance)
%GENERATEAR generates an AutoRegressive noise with the given
%parameters
%
%   GENERATEAR(LENGTH) generates a centered AWGN with a variance equal to
%   1 on LENGTH samples
%
%   GENERATEAR(LENGTH, MEAN) generates an AWGN with a variance equal to
%   1 on LENGTH samples, centered on MEAN
%
%   GENERATEAR(LENGTH, MEAN, VARIANCE) generates an AWGN on LENGTH samples, 
%   centered on MEAN, with a variance of VARIANCE
%
%   The first value taken by this autoregressive noise is always 0

if ~exist('mean','var')
    mean=0;
end
if ~exist('variance', 'var')
    variance=1;
end

sig=zeros(1,length);

for loop=2:length
    sig(loop)=sig(loop-1)+ ( variance * randn(1) + mean);
end

end
