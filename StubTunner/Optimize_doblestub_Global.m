%% GLOBAL optimization of a single-stub tuner
%
%%%
%%%%% Bounds
%%%
%
lb=[20 20 6 6 20 20 6 6];
ub=[125 125 60 60 125 125 60 60];
%
%%%
%%%%% No guess, because the result does not depend on the starting point.
%%%
%
xini=NaN;
%
%%%
%%%%% Optimization
%%%
%
sa_t=100;
sa_rt=0.85;
sa_nt=5;
sa_ns=20;
[xopt,fopt]=simann(@(x) maxPerformanceDoubleStubTuner(x,false),...
                   xini,...
                   lb,ub,...
                   sa_t,sa_rt,sa_nt,sa_ns,true);
%
%%%
%%%%% Result
%%%
%
disp('Lline Lstub')
disp(xopt)
maxperformancestubtuner(xopt,true);


