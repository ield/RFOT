function [rho]=stubtuner(Zl,Ll,Zs,Ls,f,Z0,ZL)
%STUBTUNER computes the S-parameters of an open-circuit 
%          parallel-stub tuner.
%   [rho]=STUBTUNER(Zl,Ll,Zs,Ls,f,ZL)
%
%   Zl = characteristic impedance of the line between stub and load (ohms)
%   Ll = length of line between stub and load (mm)
%   Zs = characteristic impedance of the stub (ohms)
%   Ls = length of the stub (mm)
%   f = frequency (GHz). Can be a vector.
%   Z0 = reference impedance (ohms). Same size as f.
%   ZL = complex load (ohms). Same size as f.
%
%   rho = reflection at frequencies f (size as f)

beta=2*pi*f/300;
tl=1j*tan(beta*Ll);
ts=1j*tan(beta*Ls);

%
Ze=ZL;
Ze=Zl.*(Ze+tl.*Zl)./(Zl+tl.*Ze);
Ze=1./(1./Ze+ts./Zs);
rho=(Ze-Z0)./(Ze+Z0);
