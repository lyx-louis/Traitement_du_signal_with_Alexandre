clear;
clc;
close;
%%
Fs = 1000;
f1=50;
f2=125;
f3=135;
N = 10000;
n=0:N-1;
t=n/Fs;
xn=cos(2*pi*f1*t);
recotra = 1; % 1 => rectange  0 = > trapeze
zero_paddinng = 1; % 0 => pour n'ajoute pas  1 => pour ajouter 
[spect, perio,fs,fp] = part1_func(xn,10,990,Fs,zero_paddinng,recotra);
