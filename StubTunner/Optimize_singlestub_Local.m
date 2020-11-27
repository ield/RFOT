%% LOCAL optimization of a single-stub tuner
%
%%%
%%%%% Bounds
%%%
%
lb=[ 6  6];
ub=[60 60];
%
%%%
%%%%% Select guess
% as we saw, depending on the starting point, the minimum found is a
% different one.
%%%
%
guess=1;
switch guess
    case 1
        xini=[10 10];
    case 2
        xini=[33 33];
end
%
%%%
%%%%% Optimization
%%%
%
options=optimoptions('fmincon');
options.Display='iter';
[xopt,fopt]=fmincon(@(x) maxperformancestubtuner(x,false),...
                 xini,...
                 [],[],[],[],lb,ub,[],...
                 options);
%
%%%
%%%%% Result
%%%
%
disp('Lline Lstub')
disp(xopt)
maxperformancestubtuner(xopt,true);

