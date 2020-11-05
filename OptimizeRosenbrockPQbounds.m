%%
% Parameters and starting point
P=2;
Q=100;
xini=[0 0];
lb=[-Inf -Inf];
ub=[Inf 3]; % In this case, the only constraint is x2<=3. However, there is need to fill all the ub and lb vectors, so they are filled with infinities.
      
%%
% Initialize optimization
%
options=optimoptions('fmincon');
options.Display='iter';
%options.OptimalityTolerance=1e-12;

%%
% Optimize
%
clc
[xopt]=fmincon(@(x) RosenbrockPQ(x,P,Q),...
               xini,...
               [],[],[],[],lb,ub,[],...
               options);

%%
% Show results
%
disp('Optimal vector')
disp(xopt)
