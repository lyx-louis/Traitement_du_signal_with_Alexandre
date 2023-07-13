function AWGN = generateAWGN(length, mean, variance)
%GENERATEAWGN generates an Additive White Gaussian Noise with the given
%parameters
%
%   GENERATEAWGN(LENGTH) generates a centered AWGN with a variance equal to
%   1 on LENGTH samples
%
%   GENERATEAWGN(LENGTH, MEAN) generates an AWGN with a variance equal to
%   1 on LENGTH samples, centered on MEAN
%
%   GENERATEAWGN(LENGTH, MEAN, VARIANCE) generates an AWGN on LENGTH samples, 
%   centered on MEAN, with a variance of VARIANCE

if ~exist('mean','var')
    mean=0;
end
if ~exist('variance', 'var')
    variance=1;
end

AWGN = variance * randn(1,length) + mean;
end

