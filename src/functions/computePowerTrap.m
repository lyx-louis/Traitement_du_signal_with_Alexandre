function power = computePowerTrap(sig, fmin, fmax, step,fech,Nfft)
%COMPUTEPOWERTRAP Summary of this function goes here
%   Detailed explanation goes here
freq_axis=(-length(sig)/2:length(sig)/2-1)*fech/length(sig);


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


nbr_espace = max_index - min_index;

theRest = mod(nbr_espace,step);
nbr_step = floor(nbr_espace/step);



msf = zeros(1,floor(nbr_espace/step));

for i=0:step:nbr_espace-step
    msf(i+1) = (sig(min_index+i)+sig(min_index+i+step-1))*1/2*step;
end

if(theRest ==0)
    power = sum(msf);
else
    power = sum(msf) + theRest*(sig(min_index+nbr_step*step) + sig(min_index+nbr_step*step+theRest))*0.5;
end
power = abs(power) * fech/Nfft;
end


