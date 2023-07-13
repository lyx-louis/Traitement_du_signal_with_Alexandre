function area = trapArea(sig,start,stop,step)
%TRAPAREA computes the area under a signal using the rectangles method

if ~exist('start','var')
    start=1;
end

if ~exist('stop','var')
    stop=length(sig);
end

if ~exist('step','var')
    step=16;
end

area=sum( (sig(start:step:stop)+sig(start+step-1:step:stop) )/2 .*step);

end

