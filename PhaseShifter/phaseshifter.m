function [s11F,s21F,s11R,s21R] = phaseshifter(www,lll,wref,h,er,Rs,CT,f)
%PHASESHIFTER computes the S-parameters of a phase shifter with two pin
%             diodes in their two states
%   [s11F,s21F,s11R,s21R] = PHASESHIFTER(www,lll,wref,h,er,f)
%
%   www(1) = widths of the two stubs (mm)
%   www(2) = width of the connecting line (mm)
%   lll(1) = length of the two stubs (mm)
%   lll(2) = length of the connecting line (mm)
%   wref = width of the input/output microstrip line
%   h = substrate thickness in mm
%   er = relative substrate permittivity (dimensionless)
%   Rs = Diode forward resistance (ohms)
%   CT = Diode inverse capacitance (nF)
%   f = frequency (GHz). Can be a vector.
%
%   For forward bias of diodes:
%   s11F = S_11 parameter at frequencies f (size as f)
%   s21F = S_21 parameter at frequencies f (size as f)
%   For reverse bias of diodes:
%   s11R = S_11 parameter at frequencies f (size as f)
%   s21R = S_21 parameter at frequencies f (size as f)

% From geometry to electrical parameters
omega=2*pi*f;
beta0=omega/300;
[eeffref,Zref]= microstripparameters(f,wref,h,er);
[eeff1,Zs1]= microstripparameters(f,www(1),h,er);
Ys1=1./Zs1;
[eeffcon,Zcon]= microstripparameters(f,www(2),h,er);
theta_s1=beta0.*sqrt(eeff1)*lll(1);
theta_con=beta0.*sqrt(eeffcon)*lll(2);

% Diodes
YF=1/Rs; % (Siemens) Admitance forward bias
jBR=1j*omega*CT; % (Siemens) Susceptance reverse bias

% ABCD parameters of sutbs and connecting lines
t=1j*tan(theta_s1);
Ystub_F=Ys1.*(YF+t.*Ys1)./(Ys1+t.*YF);
Ystub_R=Ys1.*(jBR+t.*Ys1)./(Ys1+t.*jBR);
CT=cos(theta_con);
jZST=1j*Zcon.*sin(theta_con);
jSTZ=1j*sin(theta_con)./Zcon;

% ABCD parameters of shifter (forward biased diodes) (D=A)
A=CT+Ystub_F.*jZST;
B=jZST;
C=jZST.*Ystub_F.^2+2*CT.*Ystub_F+jSTZ;
% ABCD to S parameters
DenS=A+B./Zref+C.*Zref+A;
s21F=2./DenS;
s11F=(B./Zref-C.*Zref)./DenS;

% ABCD parameters of shifter (reverse biased diodes) (D=A)
A=CT+Ystub_R.*jZST;
B=jZST;
C=jZST.*Ystub_R.^2+2*CT.*Ystub_R+jSTZ;
% ABCD to S parameters
DenS=A+B./Zref+C.*Zref+A;
s21R=2./DenS;
s11R=(B./Zref-C.*Zref)./DenS;

end

