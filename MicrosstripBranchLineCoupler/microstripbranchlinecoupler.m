function [s11,s21,s31,s41] = ...
             microstripbranchlinecoupler(wref,wh1,wh2,wr1,wr2,lh1,lh2,lr,f)
%MICROSTRIPBRANCHLINECOUPLER computes the S-parameters of a 4-branch
%           microstrip line coupler
%   [s11,s21,s31,s41] = ...
%            MICROSTRIPBRANCHLINECOUPLER(wref,wh1,wh2,wr1,wr2,lh1,lh2,lr,f)
%
%   wref = microstrip line widths of ports (mm)
%   wh1,wh2 = microstrip line widths of longitudinal lines (mm)
%   wr1,wr2 = microstrip line widths of branches (mm)
%   lh1,lh2 = microstrip line lengths of longitudinal lines (mm)
%   lr = microstrip line length of branches (mm)
%   f = frequency (GHz). Can be a vector.
%
%   s11 = S_11 parameter at frequencies f (size as f)
%   s21 = S_21 parameter at frequencies f (size as f)
%   s31 = S_31 parameter at frequencies f (size as f)
%   s41 = S_41 parameter at frequencies f (size as f)

end
