function U=U_FPD200model(v,vgsdata,vdsdata,idsdata,draw,chosennorm)
% U_FPD200MODEL evaluates the objective function 
%               from error in ERRORFPD200MODEL


error=abs(errorFPD200model(v,vgsdata,vdsdata,idsdata,draw));
MAXe=max(error);
%
%%% Objective function U(x)
%
U=MAXe*sum((error/MAXe).^chosennorm)^(1/chosennorm);
% We only define the u+ function. There is no u- because in this case we
% want the function to approach the desired function. Therefore, every
% deviation from the desired function is considered an error.
