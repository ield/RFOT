%%
% Starting point
xini=[0 0];
      
%%
% Initialize optimization
%
options=optimoptions('fminunc');
options.Display='iter';

%%
% Optimize
% With the annonimous function, it i possible to use the returned value of
% the function in the new function.
[xopt]=fminunc(@(x) Rosenbrock(x),...
               xini,...
               options);

%%
% Show results
%
disp('Optimal vector')
disp(xopt)

% The first order optimality is the "gradient of the function"