%%
% Starting point
wwwini=[0.5 2.0 1.0];
%wwwini=[0.12 1.78 0.70];
%wwwini=[0.20 1.79 0.76];

maxperformanceSBfilter(wwwini,true);
      
%%
% Optimization
%

constraints=true;
draw=false;
switch constraints
    case false
        options=optimoptions('fminunc');
        options.Display='iter';
        [wwwopt]=fminunc(@(x) maxperformanceSBfilter(x,draw),...
                         wwwini,...
                         options);
    case true
        options=optimoptions('fmincon');
        options.Display='iter';
        lb=[0.2 0.2 0.2];       % These constraints are set because when fabrcating a real filter, in the fabrication lab they say you that there are minimum widths.
        ub=[3 3 3];             % If we dont want contraints were we set [Inf Inf Inf]
        [wwwopt]=fmincon(@(x) maxperformanceSBfilter(x,draw),...
                         wwwini,...
                         [],[],[],[],lb,ub,[],...
                         options);
end
maxperformanceSBfilter(wwwopt,true);
disp('Optimal dimensions')
disp(wwwopt)
