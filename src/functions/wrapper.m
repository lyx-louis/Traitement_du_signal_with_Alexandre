function [outputArg1,outputArg2] = wrapper(type, varargin)
%WRAPPER is a function called by the graphical user interface to handle the
%request, and call the right functions afterwards
%   Detailed explanation goes here

if ~exist('type','var')
    type="PowerSpectrum";
end

%% ================= Extracting args

%{
    In any case, sig is the  first argument to be given in varargin.
    If we want a Daniell periodogram, we will then have winsize, Nfft,
    fmin, fmax and method
    If we want a Welch periodogram, we will then have window, noverlap,
    Nfft, fmin, fmax and method
    If we want a Bartlett periodogram, we'll see
    If we want a Caponn periodogram, TBA
%}

sig = varargin(1);



end

