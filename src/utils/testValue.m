function out = testValue(value, errormsg, min, max)
%TESTVALUE returns a boolean depending on if the value given as an argument
%is within the given boundaries. It also creates a popup window with the
%given errormsg if the value does not fit
%
%   TESTVALUE(VALUE, ERRORMSG) tests if the value if a positive value
%   (between 0 and infinity)
%
%   TESTVALUE(VALUE, ERRORMSG, MIN) tests if the value is greater or equal
%   than the MIN argument
%
%   TESTVALUE(VALUE, ERRORMSG, MIN, MAX) tests if the value is between MIN
%   and MAX included
%

if ~exist('min','var')
    min=0;
end

if ~exist('max','var')
    max=Inf;
end

if ~(value>=min) || ~(value<=max)
    out = false;
    msgbox(errormsg);
else
    out = true;
end

end

