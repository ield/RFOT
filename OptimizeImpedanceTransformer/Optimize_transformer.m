%%
%
% Chebyshev design
xini=[21.79 28.65 44.71 69.78 91.76];
% Linear design
xini=[33 47 60 73 87];

%%
draw=true;
options=optimoptions('fminunc');
options.Display='iter';
[xopt]=fminunc(@(x) maxperformancetransformer(x,draw),...
                 xini,...
                 options);
maxperformancetransformer(xopt,true);
disp(xopt)

% In the final result all the errors are negative and close to 0 (the
% desired objective) and the function is above the limit.

