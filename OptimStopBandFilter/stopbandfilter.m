function [s11,s21] = stopbandfilter(www,lll,wref,h,er,f)
%STOPBANDFILTER computes the S-parameters of a stop-band filter in
%               microstrip line.
%   [s11,s21] = STOPBANDFILTER(www,lll,wref,h,er,f)
%
%   www(1) = widths of the first and third stubs (mm)
%   www(2) = widths of the two connecting lines (mm)
%   www(3) = width of the second stub (mm)
%   lll(1) = length of the first and third stubs (mm)
%   lll(2) = length of the two connecting lines (mm)
%   lll(3) = length of the second stub (mm)
%   wref = width of the input/output microstrip line
%   h = substrate thickness in mm
%   er = relative substrate permittivity (dimensionless)
%   f = frequency (GHz). Can be a vector.
%
%   s11 = S_11 parameter of the filter at frequencies f (size as f)
%   s21 = S_21 parameter of the filter at frequencies f (size as f)

% From geometry to electrical parameters
beta0=2*pi*f/300;
[eeffref,Zref]= microstripparameters(f,wref,h,er);
[eeff1,Zs1]= microstripparameters(f,www(1),h,er);
[eeffcon,Zcon]= microstripparameters(f,www(2),h,er);
[eeff2,Zs2]= microstripparameters(f,www(3),h,er);
theta_s1=beta0.*sqrt(eeff1)*lll(1);
theta_con=beta0.*sqrt(eeffcon)*lll(2);
theta_s2=beta0.*sqrt(eeff2)*lll(3);

% ABCD parameters of sutbs and connecting lines
Y1=1j*tan(theta_s1)./Zs1;
Y2=1j*tan(theta_s2)./Zs2;
CT=cos(theta_con);
jZST=1j*Zcon.*sin(theta_con);
jSTZ=1j*sin(theta_con)./Zcon;

% ABCD parameters of whole filter (D=A)
A=jSTZ.*jZST+CT.*(CT+Y2.*jZST)+Y1.*(CT.*jZST+jZST.*(CT+Y2.*jZST));
B=jZST.*(2*CT+Y2.*jZST);
C=(CT+Y1.*jZST).*(2*jSTZ+2*CT.*Y1+CT.*Y2+Y1.*Y2.*jZST);

% ABCD to S parameters
DenS=A+B./Zref+C.*Zref+A;
s21=2./DenS;
s11=(B./Zref-C.*Zref)./DenS;

end

