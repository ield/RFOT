function error=errorFPD200model(v,vgsdata,vdsdata,idsdata,draw)
% ERRORFPD200MODEL evaluates the error in IDS between measured data
%                  and the nonlinear model
%    error=ERRORFPD200MODEL(v,vgsdata,vdsdata,idsdata,draw)
%
%    v(1) = device width (micron)
%    v(2) = Threshold voltage (volt)
%    v(3) = Knee-voltage (1/volt)
%    v(4) = Transconductance parameter (amp/volt^Q)
%    v(5) = Threshold shifting (dimensionless)
%    v(6) = Nonideal thermal voltage (volt)
%    v(7) = Power-law parameter (dimensionless)
%    v(8) = output feedback scaled by width (micron/watt)
%    draw = if 'true' show comparison between data and model
%
%    error = error in IDS

normalized=false;

if normalized
    www=150*v(1);
    VTO=-0.6471*v(2);
    alpha=3.453*v(3);
    beta=0.000682*v(4);
    gamma=0.0155*v(5);
    Vst=0.05677*v(6);
    Q=0.9*v(7);
    delta=36.23*v(8)/www;
else
    www=v(1);
    VTO=v(2);
    alpha=v(3);
    beta=v(4);
    gamma=v(5);
    Vst=v(6);
    Q=v(7);
    delta=v(8)/www;
end

%
%  Non-linear functions evaluation 
%
[VGS,VDS]=meshgrid(vgsdata,vdsdata);
Vg=Q*Vst*log(exp((VGS-VTO+gamma*VDS)/(Q*Vst))+1);
Ids0=www*beta*Vg.^Q*alpha.*VDS./sqrt(1+(alpha*VDS).^2);
IDS=Ids0./(1+delta*VDS.*Ids0);

%
%  Error evaluation
%
error=(IDS-idsdata);
error=error(:);

%
%  Plot comparison
%
if draw
    vgsdib=vgsdata;
    vdsdib=linspace(0,10,61);
    [VGS,VDS]=meshgrid(vgsdib,vdsdib);
    Vg=Q*Vst*log(exp((VGS-VTO+gamma*VDS)/(Q*Vst))+1);
    Ids0=www*beta*Vg.^Q*alpha.*VDS./sqrt(1+(alpha*VDS).^2);
    IDS=Ids0./(1+delta*VDS.*Ids0);
    %
    figure(1)
    plot(vdsdib,1000*IDS,'k',...
         vdsdata,1000*idsdata,'*')
    xlabel('Vds (V)')
    ylabel('Ids (mA)')
    %
    vgsdib=linspace(-1,0,21);
    vdsdib=vdsdata;
    [VGS,VDS]=meshgrid(vgsdib,vdsdib);
    Vg=Q*Vst*log(exp((VGS-VTO+gamma*VDS)/(Q*Vst))+1);
    Ids0=www*beta*Vg.^Q*alpha.*VDS./sqrt(1+(alpha*VDS).^2);
    IDS=Ids0./(1+delta*VDS.*Ids0);
    %
    figure(2)
    plot(vgsdib,1000*IDS,'k',...
         vgsdata,1000*idsdata,'*')
    xlabel('Vgs (V)')
    ylabel('Ids (mA)')
    drawnow
end

