%% DOES NOT solve Van Der Pol Oscillator

% Initialize time and harmonics
f0=1; % GHz
NoHarmonics=8;
[t,f]=initializeFT(NoHarmonics,f0);
n_time=length(t);
n_frec=length(f);

%% Solve by optimization
Vini=rand(2*n_frec,1);

options=optimoptions('lsqnonlin');
options.Algorithm='trust-region-reflective';
options.Display='iter';
%
[Vopt]=lsqnonlin(@(x) vanderpoloscillator(x,f,t,false),...
                 Vini,...
                 [],[],options);



%% Display the results
vanderpoloscillator(Vopt,f,t,true);

