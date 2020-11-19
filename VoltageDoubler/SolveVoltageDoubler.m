%% Solves voltage doubler

% Initialize time and harmonics
f_p=1; % GHz
NoHarmonics=8;
[t,f]=initializeFT(NoHarmonics,f_p);
n_time=length(t);
n_freq=length(f);

%% Solve by optimization
tic

% Set an initial voltage vector
Vini=zeros(6*n_freq,1);

options=optimoptions('fminunc');
options.Display='iter';
% options.MaxFunctionEvaluations=20000;
%
[Vopt]=fminunc(@(x) sum(voltagedoubler(x,f,t,false).^2),...
                         Vini,...
                         options);

toc
%% Display the results
voltagedoubler(Vopt,f,t,true);

