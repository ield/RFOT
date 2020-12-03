% Author: ield (based on code of Jaime Esteban)
% Simulates Van der Pol Oscillator using HB
% Step 1. It sets and initial frequency and a number of harmonics. The fft
%   is initialized at the beginnin ONLY with the purpose of determining the
%   length of the V vector. The main
%   frequency is modified in the optimization process defininf the fft in
%   each loop
% Step 2. It is simulated the harmonic balance. All the modifications donde
%   are explained in vanderpoloscillator function
%
% Solutions: The result reached should not be satisfactory enough because the error in
% the third harmonic is comparable to the value of the current. However, 
% the value of this harmonic is so small that mayba it can be approached to 0.
% The initial
% position is determinant to find the solution because the optimization is
% local. It is chosen a starting point which can be approached to some low noise. 
% To decide the number of
% harmonics, this number was increased until increasing it did not imply a
% strong change in the solution.

%% Initialize time and harmonics
NoHarmonics=50;
f0 = 1;     % GHz
[~,f]=initializeFT(NoHarmonics,f0);
n_frec=length(f);

%% Solve by optimization
% Ste starting point
% It is chosen this starting point because being an oscillator it is
% expected to have only one (the main) tone.
Vini=0.0001*rand(2*n_frec,1);
% Vini(2) = 1;

options=optimoptions('lsqnonlin');
options.Algorithm='trust-region-reflective';
options.Display='iter';
options.MaxFunctionEvaluations = 20e3;
%
[Vopt]=lsqnonlin(@(x) vanderpoloscillator(x,NoHarmonics,false),...
                 Vini,...
                 [],[],options);



%% Display the results
vanderpoloscillator(Vopt,NoHarmonics,true);

