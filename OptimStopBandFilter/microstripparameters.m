function [eeff,Z0] = microstripparameters(f,w,h,er)
%MICROSTRIPPARAMETERS computes microstrip parameters following the basic
%                     formulae given in Pozar 'Microwave Engineering', 4th
%                     Ed. Sec. 3.8
%   [eeff,Z0] = MICROSTRIPPARAMETERS(f,w,h,er)
%
%   f = frequency in GHz, can be a vector.
%   w = microstrip width in mm
%   h = substrate thickness in mm
%   er = relative substrate permittivity (dimensionless)
%
%   eeff = effective relative permittivity  (dimensionless)
%   Z0 = impedance in ohms

%   J. Esteban 2016

eeff0=0.5*(er+1)+0.5*(er-1)/sqrt(1+12*w/h);
if w<h
    Z00=60*log((8*h/w)+(w/4/h))/sqrt(eeff0);
else
    Z00=120*pi/(w/h+1.393+0.667*log(w/h+1.444))/sqrt(eeff0);
end

g=0.6+0.009*Z00;
fp=Z00/(0.8*pi*h);

eeff=er-(er-eeff0)./(1+g*(f/fp).^2);
Z0=Z00*sqrt(eeff0./eeff);

end

