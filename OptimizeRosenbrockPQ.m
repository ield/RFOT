%%
% Parameters and starting point
P=2;
Q=100;
xini=[0 0];
      
%%
% Initialize optimization
%
options=optimoptions('fminunc');
options.Display='iter';

%%
% Optimize
%
% Since we want to minimize with respect to x we use @x, so Matlab will
% minimize fminunc only with x, it will not minimize  and Q
clc
[xopt]=fminunc(@(x) RosenbrockPQ(x,P,Q),...
               xini,...
               options);

%%
% Show results
%
disp('Optimal vector')
disp(xopt)
