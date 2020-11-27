%% DOES NOT solve Van Der Pol Oscillator

% Initialize time and harmonics
NoHarmonics=10;
f0 = 1;     % GHz
[~,f]=initializeFT(NoHarmonics,f0);
n_frec=length(f);

%% Solve by optimization
Vini=ones(2*n_frec,1);
% Vini=rand(2*n_frec,1);
% Vini(length(Vini)/2+1) = 1; % Initial frequency set to 1 GHz

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

