%%
% Parameters and starting point
clear;
P=2;
Q=100;
xini=[0 0];
      
%%
% Initialize optimization
%
options=optimoptions('fminunc');
options.Display='iter';
options.SpecifyObjectiveGradient=true;  % This is the way to specify we want the gradient in the optimization algorithm
%options.Algorithm='trust-region';

%%
% Optimize
%
clc;tic
[xopt]=fminunc(@(x) RosenbrockPQwg(x,P,Q),...
               xini,...
               options);
toc

%%
% Show results
%
disp('Optimal vector')
disp(xopt)
