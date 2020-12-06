function [rho] = matchingnetwork5(params,f,Z_S,Z_L,f0)
%MATCHINGNETWORK computes the reflection coefficient of a 
%                complex-impedance matching network with 5 elements.
%   [rho] = MATCHINGNETWORK5(params,f,Z_S,Z_L)
%
%   params(5) = vector of reactances at f0
%   f = frequency (GHz)     (vector, same size as Z_S and Z_L)
%   Z_S = impedance (ohms)
%   Z_L = impedance (ohms)
%
%   rho = reflection coeffcient at frequencies f

omega0=2*pi*f0;
omega=2*pi*f;

if params(1)>=0
    Zp1=1j*(omega/omega0)*params(1);
else
    Zp1=1j*(omega0./omega)*params(1);
end
Yp1=1./Zp1;
if params(2)>=0
    Zs1=1j*(omega/omega0)*params(2);
else
    Zs1=1j*(omega0./omega)*params(2);
end
if params(3)>=0
    Zp2=1j*(omega/omega0)*params(3);
else
    Zp2=1j*(omega0./omega)*params(3);
end
Yp2=1./Zp2;
if params(4)>=0
    Zs2=1j*(omega/omega0)*params(4);
else
    Zs2=1j*(omega0./omega)*params(4);
end
if params(5)>=0
    Zp3=1j*(omega/omega0)*params(5);
else
    Zp3=1j*(omega0./omega)*params(5);
end
Yp3=1./Zp3;

Zv=1./(Yp1+1./(Zs1+1./(Yp2+1./(Zs2+1./(Yp3+1./Z_L)))));
rho=(Zv-conj(Z_S))./(Zv+conj(Z_S));

end
