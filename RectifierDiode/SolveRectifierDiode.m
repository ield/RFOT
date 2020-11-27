%% Solves rectifier diode

% Initialize time and harmonics
f_p=1; % GHz
NoHarmonics=8;  % Dont mistake with the number of frequencies, #har+1 = #freq
[t,f]=initializeFT(NoHarmonics,f_p);
n_time=length(t);
n_freq=length(f);

%% Solve by optimization

% Set an initial voltage vector
% The length of the vector is important: it is important to see that there
% must be 4 harmonics, so we want 5 points (0 also counts), and we have two
% port, real and imaginary numbers, so 
vini = zeros(4*(NoHarmonics++1), 1);


% Use any of the available optimization routines ...
%         fminsearch
%         fminunc
%         fmincon
%         lsqnonlin
%         .........
% ... to minimize current vector error

% options = optimoptions('fminunc');
% options.Display= 'iter';
% 
% Vopt = fminunc(@(x) sum(rectifierdiode(x,f,t,false).^2), vini, options);
% 
options = optimoptions('lsqnonlin');
options.Display= 'iter';

% Vopt = lsqnonlin(@(x) rectifierdiode(x,f,t,false), vini, [], [], options);

% options.SpecifyObjectiveGradient = true;
% Vopt = lsqnonlin(@(x) rectifierdiode_Jacob(x,f,t,false), vini, [], [], options);

% It is normally better to use lsqnonlin because it is better for these
% cases.However, this cannot be used if we want to check that imag(V(0)) = 0

% options.SpecifyObjectiveGradient = true;
% Vopt = lsqnonlin(@(x) rectifierdiode_Jacob(x,f,t,false), vini, [], [], options);
% This option is normally better because the number of evaluations is
% decreased. In the other method, the number of evaluations increases
% because it performs all the approximations of the gradient for every
% test. If we calculate these approximations, it is not needed to compute
% the gradient.

% However, this function apparently does not lead to a good result. Why?
% Because we only know from G0 to Gk, and we do not know about Gk+m (see
% slide 20). We are ignoring these values. This leads to some error.
% Solution: Solve in a first step with the Jacobian and use the output as
% the input for the next function: see below

options.SpecifyObjectiveGradient = true;
Vopt_1 = lsqnonlin(@(x) rectifierdiode_Jacob(x,f,t,false), vini, [], [], options);
options.SpecifyObjectiveGradient = false;
Vopt = lsqnonlin(@(x) rectifierdiode(x,f,t,false), Vopt_1, [], [], options);
%% Display the results
draw=true;
rectifierdiode(Vopt,f,t,draw);

% It is important to compare the results of the errors with respect the
% amplitudes of the harmonics, so that the errores are way smaller than the
% harmonics.
