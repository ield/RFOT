load FPD200measureddata
%
%
vini=[150 -0.6471 3.453 0.000682 0.0155 0.05677 0.9 36.23];
% vini=[1 1 1 1 1 1 1 1];
%
errorFPD200model(vini,vgsdata,vdsdata,idsdata,true);

%%
%vini=vopt;

chosennorm=1;
switch chosennorm
                 
    case 'lsq'
    %
    options=optimoptions('lsqnonlin');
    options.Display='iter';
    [vopt]=lsqnonlin(@(x) errorFPD200model(x,vgsdata,vdsdata,idsdata,...
                                           false),...
                     vini,...
                     [],[],options);
                 
    otherwise
    options=optimoptions('fminunc');
    options.Display='iter';
    [vopt]=fminunc(@(x) U_FPD200model(x,vgsdata,vdsdata,idsdata,...
                                      false,chosennorm),...
                   vini,...
                   options);
               
end

%%                
errorFPD200model(vopt,vgsdata,vdsdata,idsdata,true);