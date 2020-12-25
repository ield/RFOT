function [s11,s21] = waveguidebandpassfiltercoarsefunction(xxx,f)
%WAVEGUIDEBANDPASSFILTERCOARSEFUNCTION computes the S-parameters of a band-pass filter 
%                        model in WR75 waveguide.
%   [s11,s21] = WAVEGUIDEBANDPASSFILTERCOARSEFUNCTION(xxx,f)
%
%   xxx(1:2) = widths of the first and second irises (mm)
%   xxx(3:4) = lengths of the first and second cavities (mm)
%   f = frequency (GHz). Can be a vector.
%
%   s11 = S_11 parameter of the filter at frequencies f (size as f)
%   s21 = S_21 parameter of the filter at frequencies f (size as f)

%   J. Esteban 2017

% Dimensional parameters
www(1)=xxx(1);
www(2)=xxx(2);
lll(1)=xxx(3);
lll(2)=xxx(4);

% From geometry to electrical parameters
a=19.05; %mm
fc=150/a; %GHz
beta0=2*pi*f/300;
betawg=beta0.*sqrt(1-(fc./f).^2);
%
FM=[10    14
    10    14];
WM=[  a/3    a/3;
    2*a/3  2*a/3];
KM=[0.05 0.1
    0.5  0.7];
PM=[0.1 0.2
    0.6 0.8];
[FF,WW]=meshgrid(f,www);
Ki=interp2(FM,WM,KM,FF,WW);
phii=interp2(FM,WM,PM,FF,WW);
%
K1=Ki(1,:);
K2=Ki(2,:);
%
theta1=betawg*lll(1)+phii(1,:)+phii(2,:);
theta2=betawg*lll(2)+2*phii(2,:);
%
CT1=cos(theta1);
jST1=1j*sin(theta1);
CT2=cos(theta2);
jST2=1j*sin(theta2);

% ABCD 1st inverter
A=zeros(size(f));
B=1j*K1;
C=1j./K1;
D=zeros(size(f));
% Add 1st cavity
AP=A.*CT1+B.*jST1;
BP=A.*jST1+B.*CT1;
CP=C.*CT1+D.*jST1;
DP=C.*jST1+D.*CT1;
% Add 2nd inverter
A=1j*BP./K2;
B=1j*AP.*K2;
C=1j*DP./K2;
D=1j*CP.*K2;
% Add 2nd cavity
AP=A.*CT2+B.*jST2;
BP=A.*jST2+B.*CT2;
CP=C.*CT2+D.*jST2;
DP=C.*jST2+D.*CT2;
% Add 3rd inverter
A=1j*BP./K2;
B=1j*AP.*K2;
C=1j*DP./K2;
D=1j*CP.*K2;
% Add 3rd cavity
AP=A.*CT1+B.*jST1;
BP=A.*jST1+B.*CT1;
CP=C.*CT1+D.*jST1;
DP=C.*jST1+D.*CT1;
% Add 4th inverter
A=1j*BP./K1;
B=1j*AP.*K1;
C=1j*DP./K1;
D=1j*CP.*K1;

% ABCD to S parameters
DenS=A+B+C+D;
s21=2./DenS;
s11=(B-C)./DenS;

% Change reference planes
s11=s11.*exp(-2j*phii(1,:));
s21=s21.*exp(-2j*phii(1,:));

end

