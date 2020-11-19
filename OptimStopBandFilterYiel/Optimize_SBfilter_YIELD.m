%
% Starting point (max. performance)
%
wwwini=[0.201 1.79 0.76];
maxperformanceSBfilter(wwwini,true);
tic;yieldSBfilter(wwwini,true),toc

%%
% Optimization
%
lb=[0.2 0.2 0.2];
ub=[3   3   3  ];
%
options=optimoptions('fmincon');
options.Display='iter';
[wwwopt]=fmincon(@(x) 1-yieldSBfilter(x,true),...
                 wwwini,...
                 [],[],[],[],lb,ub,[],...
                 options);
maxperformanceSBfilter(wwwopt,true);
disp('Maximum yield dimensions')
disp(wwwopt)

% This will give some problems because the error is noisy so that the
% gradient is going to be strange so the function might not converge. To fi
% x this we have to try with a large value of k so that the error is
% smoother, but then it takes a really long time to execute.