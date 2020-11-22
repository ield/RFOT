function U = U_Coupler(values,wref,f,inds,f1,f2,RLdesired,ISOdesired, method, draw)

% Generates the objective function that must be minimized 
%   1. It gives values to the input parameters
%   2. It calculates the error
%   3. It computes the U function
% Variables
%   wref = microstrip line widths of ports (mm)
%   wh1,wh2 = microstrip line widths of longitudinal lines (mm)
%   wr1,wr2 = microstrip line widths of branches (mm)
%   lh1,lh2 = microstrip line lengths of longitudinal lines (mm)
%   lr = microstrip line length of branches (mm)
%   f = frequency (GHz). Can be a vector.
%   inds = working frequency band (GHz)
%   f1, f2 = limits (lower and upper) of the frequency band
%   RL, ISO desired = the objective functions
%   draw = if it necessary to draw at the end of each iteration

error = errorCoupler(values,wref,f,inds,f1,f2,RLdesired,ISOdesired, method, draw);
MAXe = max(error);

chosennorm = 2;
indsP=find(error>=0);
if ~isempty(indsP)
    error=error(indsP);
    U=MAXe*sum((error/MAXe).^chosennorm)^(1/chosennorm);
else
    U=MAXe./sum((MAXe./error).^chosennorm)^(1/chosennorm);
end

end

