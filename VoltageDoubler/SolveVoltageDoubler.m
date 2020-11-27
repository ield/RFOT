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
amplitudes = 1:0.2:10;      % Try to find a strategy to define these steps in order to obtain a good distribution
% avoiding the nonlinearity at 10v, without using too much steps, but
% aoiding non linearities.
% The increase must be given by the curve of the diode.
% Make a foor loop using source stepping

[Vopt]=fminunc(@(x) sum(voltagedoubler(x,f,t,false).^2),...
                         Vini,...
                         options);

toc
%% Display the results
voltagedoubler(Vopt,f,t,true);

