%
% Nominal dimensions
%
Width_stub=2.58;  %(mm)
Length_stub=10;  %(mm)
Width_connectionline=2.58;  %(mm)
Length_connectionline=10;  %(mm)
Rs=3;     % (ohms)
CT=1e-3;  % (nF)

x=[Width_stub Width_connectionline Length_stub Length_connectionline];
maxperformanceshifter(x,Rs,CT,true);

% With these specifications return and insertions losses are met but phase
% shift is not. Sometimes there are met some specifications and some other
% times not

%%
% Optimization
%
xini=[2.58 2.58 10 10];
lb=[0.2 0.2  5  5];
ub=[ 4   4  15 15];
%
options=optimset('fmincon');
options.Display='iter';
[xopt]=fmincon(@(x) maxperformanceshifter(x,Rs,CT,false),...
               xini,...
               [],[],[],[],lb,ub,[],...
               options);

maxperformanceshifter(xopt,Rs,CT,true);

% The best way to see the efort done to perdom the optimization is to look
% at the number of function evaluations (the second column of the printed
% vlaue). This depends on the algorithm used. If the contraints are relaxed
% sometimes the complexity increases, contrary to the expectatives.
% Sometimes it is better to use some reasonable constraints to increase the
% performance of the optimziation.
