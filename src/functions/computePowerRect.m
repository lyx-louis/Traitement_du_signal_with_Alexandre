function power = computePowerRect(sig, fmin, fmax, step, fech,Nfft)
%COMPUTEPOWER Summary of this function goes here
%   Detailed explanation goes here
freq_axis=(-length(sig)/2:length(sig)/2-1)*fech/length(sig);

freq_min = -length(sig)/2;

delta_freq = fmin-freq_min;
delta_ech=delta_freq/Nfft;
if delta_ech < 0 || delta_ech > Nfft
    fprintf("Sample out of the figure.\n");
end
% pour periodogramme
i = 1;
while freq_axis(i)<fmin
    i = i+1;
end
min_index = i;

i = 1;
while i <= length(freq_axis) && freq_axis(i) < fmax
    i = i+1;
end
max_index = i;


nbr_espace = max_index - min_index; %50
theRest = mod(nbr_espace,step);
nbr_step = floor(nbr_espace/step);

msf = zeros(1,nbr_step);

for i=0:step:nbr_espace-step
    msf(i/step+1) = sig(min_index+i)*step;
end

if(theRest ==0)
    power = sum(msf);
else
    power = sum(msf) + theRest*sig(min_index+nbr_step*step);
end
power = abs(power) * fech/Nfft;

end

