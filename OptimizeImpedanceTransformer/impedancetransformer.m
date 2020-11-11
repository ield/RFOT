function [s11,s21,s12,s22] = impedancetransformer(zzz,ZS,ZL,f0,f)
%IMPEDANCETRANSFORMER computes the S-parameters of an impedance
%             transformer between impedances ZS and ZL
%   [s11,s21,s12,s22] = IMPEDANCETRANSFORMER(zzz,ZS,ZL,f0,f)
%
%   zzz = vector of characteristic impedances of line sections (ohms)
%   ZS = source impedance (ohms)
%   ZL = load impedance (ohms)
%   f0 = central frequency (GHz)
%   f = frequency (GHz). Can be a vector.
%
%   s11 = S_11 parameter at frequencies f (size as f)
%   s21 = S_21 parameter at frequencies f (size as f)
%   s12 = S_12 parameter at frequencies f (size as f)
%   s22 = S_22 parameter at frequencies f (size as f)

Nsec=length(zzz);
Nfrec=length(f);        % if the number of frequency points, there can be problems.

theta=pi*f/(2*f0);
% Frequency sweep
for ifrec=1:Nfrec
    ABCD=[1 0;0 1];
    for isec=1:Nsec
        ABCD=ABCD*...
           [cos(theta(ifrec)) 1j*zzz(isec)*sin(theta(ifrec));
           1j*sin(theta(ifrec))/zzz(isec) cos(theta(ifrec))];
    end
    den=ABCD(1,1)*ZL+ABCD(1,2)+ABCD(2,1)*ZS*ZL+ABCD(2,2)*ZS;
    s11(ifrec)=(ABCD(1,1)*ZL+ABCD(1,2)-ABCD(2,1)*ZS*ZL-ABCD(2,2)*ZS)/den;
    s21(ifrec)=2*sqrt(ZS*ZL)/den;
    s12(ifrec)=2*(ABCD(1,1)*ABCD(2,2)-ABCD(1,2)*ABCD(2,1))*sqrt(ZS*ZL)/den;
    s22(ifrec)=(-ABCD(1,1)*ZL+ABCD(1,2)-ABCD(2,1)*ZS*ZL+ABCD(2,2)*ZS)/den;
end
