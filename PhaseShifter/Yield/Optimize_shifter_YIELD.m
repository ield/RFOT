%
% Starting point (max. performance)
%
Width_stub=3.40;  %(mm)
Length_stub=11.18;  %(mm)
Width_connectionline=2.83;  %(mm)
Length_connectionline=9.74;  %(mm)
Rs=3;     % (ohms)
CT=1e-3;  % (nF)

x=[Width_stub Width_connectionline Length_stub Length_connectionline];
maxperformanceshifter(x,Rs,CT,true);
yieldshifter(x,true)

%%
% Optimization
%
xini=x;
lb=[0.2 0.2  5  5];
ub=[ 4   4  15 15];
%
options=optimoptions('fmincon');
options.Display='iter';
options.OutputFcn=@outfun;
[xopt]=fmincon(@(x) 1-yieldshifter(x,true),...
                 xini,...
                 [],[],[],[],lb,ub,[],...
                 options);
maxperformanceshifter(xopt,Rs,CT,true);
% The computer finishing this yield does not mean that it has fiished
% optimizing. This is because the results vary between different runs. If
% you want a good approach put
% a loop of different optimizations where xini = xopt. Another approach is
% to increase the number of samples.
% It is complicated to optimize the yield with a Montecarlo method.

