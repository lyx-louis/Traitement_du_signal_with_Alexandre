function area = rectArea(sig,start,stop,step)
%RECTAREA computes the area under a signal using the rectangles method

if ~exist('start','var')
    start=1;
end

if ~exist('stop','var')
    stop=length(sig);
end

if ~exist('step','var')
    step=16;
end

area=sum(sig(start:step:stop).*step);

end

