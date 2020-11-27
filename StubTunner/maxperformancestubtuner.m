function U = maxperformancestubtuner(xxx,draw)

%
%%%
%%%%% Parameter conversion and fixed parameters
%%%
%
Zl=50;        % (ohms)
Ll=xxx(1);    % (mm)
Zs=50;        % (ohms)
Ls=xxx(2);    % (mm)

Df=0.05;      % (GHz)
f1=2.45-Df;   % (GHz)
f2=2.45+Df;   % (GHz)

%
%%%
%%%%% Frequency sweep and tuner response
%%%
%
f=linspace(f1,f2,11);     % (GHz)
Z0=50*ones(size(f));      % (ohms)
ZL=25+1./(2j*pi*f*1.e-3); % (ohms)
[rho]=stubtuner(Zl,Ll,Zs,Ls,f,Z0,ZL);
RL=-20*log10(abs(rho));

%
%%%
%%%%% Error definition
%%%
%
RLdesired=15; % (dB)
%
weightRL=1/length(f)/RLdesired;
errorRL=weightRL*(RLdesired-RL);
%
error=[errorRL];
MAXe=max(error);

%
%%% Objective function U(x)
%
chosennorm=2;
indsP=find(error>=0);
if ~isempty(indsP)
    error=error(indsP);
    U=MAXe*sum((error/MAXe).^chosennorm)^(1/chosennorm);
else
    U=MAXe./sum((MAXe./error).^chosennorm)^(1/chosennorm);
end

%
%%%
%%%%% Figures
%%%
%
if draw
    fdib=linspace(2.2,2.65,46);
    Z0=50*ones(size(fdib));
    ZL=25+1./(2j*pi*fdib*1.e-3);
    [rhodib]=stubtuner(Zl,Ll,Zs,Ls,fdib,Z0,ZL);
    RLdib=-20*log10(abs(rhodib));
    %
    figure(1)
    plot(fdib,RLdib,'r',...
         [f1 f1 f2 f2],RLdesired+[-5 0 0 -5],'k-')
    ylim([0 25])
    xlabel('Frequency (GHz)')
    ylabel('RL (dB)')
    %
    figure(2)
    plot([f1 f2],[0 0],'k',...
          f,errorRL,'g')
    %
    drawnow
end

end