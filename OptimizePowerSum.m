%%
% Starting point
xini=[1 1 1 1];
b = [10 30 100 354];
      
%%
% Initialize optimization
%
% options=optimoptions('fminunc');
options=optimoptions('lsqnonlin');

options.Display='iter';

%%
% Optimize
% With the annonimous function, it i possible to use the returned value of
% the function in the new function.
% [xopt]=fminunc(@(x) sum(powerSum(x, b).^2), xini, options);
[xopt]=lsqnonlin(@(x) powerSum(x, b), xini, [], [], options);

%%
% Show results
%
disp('Optimal vector')
disp(xopt)

% The first order optimality is the "gradient of the function"