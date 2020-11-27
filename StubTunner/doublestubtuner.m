function [rho]=doublestubtuner(Zl,Ll,Zs,Ls,Zl2,Ll2,Zs2,Ls2,f,Z0,ZL)
%DOUBLESTUBTUNER computes the S-parameters of an open-circuit 
%                parallel-stub tuner with two stubs.
%   [rho]=DOUBLESTUBTUNER(Zl,Ll,Zs,Ls,f,ZL)
%
%   Zl = characteristic impedance of the line between 1st stub and load (ohms)
%   Ll = length of line between 1st stub and load (mm)
%   Zs = characteristic impedance of the 1st stub (ohms)
%   Ls = length of the 1st stub (mm)
%   Zl2 = characteristic impedance of the line between 1st and 2nd stubs (ohms)
%   Ll2 = length of line between 1st and 2nd stubs (mm)
%   Zs2 = characteristic impedance of the 2nd stub (ohms)
%   Ls2 = length of the 2nd stub (mm)
%   f = frequency (GHz). Can be a vector.
%   Z0 = reference impedance (ohms). Same size as f.
%   ZL = complex load (ohms). Same size as f.
%
%   rho = reflection at frequencies f (size as f)

beta=2*pi*f/300;
tl=1j*tan(beta*Ll);
ts=1j*tan(beta*Ls);
tl2=1j*tan(beta*Ll2);
ts2=1j*tan(beta*Ls2);

%
Ze=ZL;
Ze=Zl.*(Ze+tl.*Zl)./(Zl+tl.*Ze);
Ze=1./(1./Ze+ts./Zs);
Ze=Zl2.*(Ze+tl2.*Zl2)./(Zl2+tl2.*Ze);
Ze=1./(1./Ze+ts2./Zs2);
rho=(Ze-Z0)./(Ze+Z0);
