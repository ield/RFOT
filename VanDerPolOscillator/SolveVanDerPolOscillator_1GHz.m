% Author: ield (based on code of Jaime Esteban)
% Simulates Van der Pol Oscillator using HB
% Step 1. It sets and initial frequency (1GHz) and a number of harmonics.
% Step 2. It is simulated the harmonic balance. All the modifications donde
%   are explained in vanderpoloscillator function
%
% Solutions: The result reached is not satisfactory enough because the error in
% the third harmonic is comparable to the value of the current. The initial
% position is determinant to find the solution because the optimization is
% local. It is chosen this starting point because being an oscillator it is
% expected to have only one (the main) tone. To decide the number of
% harmonics, this number was increased until increasing it did not imply a
% strong change in the solution.
NoHarmonics=50;
f0 = 1;     % GHz
[t,f]=initializeFT(NoHarmonics,f0);
n_frec=length(f);

%% Solve by optimization
Vini=0.0001*rand(2*n_frec,1);

options=optimoptions('lsqnonlin');
options.Algorithm='trust-region-reflective';
options.Display='iter';
options.MaxFunctionEvaluations = 20e3;
%
[Vopt]=lsqnonlin(@(x) vanderpoloscillator_1GHz(x,t,f,false),...
                 Vini,...
                 [],[],options);



%% Display the results
vanderpoloscillator_1GHz(Vopt,t,f,true);

