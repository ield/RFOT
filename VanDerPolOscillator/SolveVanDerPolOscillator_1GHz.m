%% DOES NOT solve Van Der Pol Oscillator

% Initialize time and harmonics
% f0 is fixed to 1 GHz, in this case we modify the value of C, so we can
% provide directly with time and frequency axes
NoHarmonics=10;
f0 = 1;     % GHz
[t,f]=initializeFT(NoHarmonics,f0);
n_frec=length(f);

%% Solve by optimization
Vini=ones(2*n_frec,1);

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

