clc;clear;close all;

%% === Begin

% testSig1 = [1,2,3];
% testSig2 = [1,2,3,4,5,6,7];
% testSig3 = [1;2;3];
% testSig4=[1 2;3 4];
% testSig5=12;
% 
% fprintf("===============================\n");
% fprintf("========== SIGNAL 1 ===========\n");
% ret=freqpower(testSig1, 1, 1, 1, 1, 'None');
% disp(ret);
% 
% fprintf("\n");
% fprintf("========== SIGNAL 2 ===========\n");
% ret=freqpower(testSig2, 1, 1, 1, 1, 'None');
% disp(ret);
% 
% fprintf("\n");
% fprintf("========== SIGNAL 3 ===========\n");
% ret=freqpower(testSig3, 1, 1, 1, 1, 'None');
% disp(ret);

% fprintf("\n");
% fprintf("========== SIGNAL 4 ===========\n");
% ret=freqpower(testSig4, 1, 1, 1, 1, 'None');
% disp(ret);

% fprintf("\n");
% fprintf("========== SIGNAL 5 ===========\n");
% ret=freqpower(testSig5, 1, 1, 1, 1, 'None');
% disp(ret);

f = 12;  %Hz
fmin = 50;   %Hz
fmax = 300;  %Hz
t = 0:1/200:1; %1s
padding = 1;

sig = randn(1,200);
ret = freqpower(sig, fmin, fmax, 200, padding,'None');
ret = freqpower(sig, fmin, fmax, 200, padding,'Welch');
ret = freqpower(sig, fmin, fmax, 200, padding,'Bartlett');
figure; plot(sig);title("BBGC");