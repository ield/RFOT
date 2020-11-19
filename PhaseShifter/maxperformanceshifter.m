function U = maxperformanceshifter(xxx,Rs,CT,draw)
% This is the objective function obtained from the response function
%
%%%
%%%%% Constant parameters
%%%
%
wref=2.58;
h=0.762; % (mm)
er=2.17;

%
%%%
%%%%% Frequency sweep and shifter response
%%%
%
f1=5.7;
f2=6.3;
f=linspace(f1,f2,16);
[s11F,s21F,s11R,s21R] = phaseshifter(xxx(1:2),xxx(3:4),wref,h,er,Rs,CT,f);
RLF=-20*log10(abs(s11F));
ILF=-20*log10(abs(s21F));
RLR=-20*log10(abs(s11R));
ILR=-20*log10(abs(s21R));
DeltaPhi=(180/pi)*(angle(s21R./s21F));  % This is the phase difference between the phases in the forward and in reverse input

%
%%%
%%%%% Objective function definition
%%%
%
RLdesired=12;
ILdesired=1.5;
Deltaphidesired=40;
DeltaDeltaphidesired=5;

% There are 6 specifications: 2 for the il r and f (the two modes), 2 for
% the rl (r and f) and 2 for the phase: up and low bound.

%
%%% Insertion loss forward state
weightILF=1/length(f)/ILdesired;
errorILF=weightILF*(ILF-ILdesired);
%
%%% Insertion loss reverse state
weightILR=1/length(f)/ILdesired;
errorILR=weightILR*(ILR-ILdesired);
%
%%% Return loss forward state
weightRLF=1/length(f)/RLdesired;
errorRLF=weightRLF*(RLdesired-RLF);
%
%%% Return loss reverse state
weightRLR=1/length(f)/RLdesired;
errorRLR=weightRLR*(RLdesired-RLR);
%
%%% Phase difference upper bound
weightPHI1=1/length(f)/DeltaDeltaphidesired;
errorPHI1=weightPHI1*(DeltaPhi-(Deltaphidesired+DeltaDeltaphidesired));
%
%%% Phase difference lower bound
weightPHI2=1/length(f)/DeltaDeltaphidesired;
errorPHI2=weightPHI2*((Deltaphidesired-DeltaDeltaphidesired)-DeltaPhi);

%
%%% Join all errors
error=[errorILF errorILR errorRLF errorRLR errorPHI1 errorPHI2];
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
    fdib=linspace(4,8,101);
    [s11Fdib,s21Fdib,s11Rdib,s21Rdib] = ...
                      phaseshifter(xxx(1:2),xxx(3:4),wref,h,er,Rs,CT,fdib);
    RLFdib=-20*log10(abs(s11Fdib));
    ILFdib=-20*log10(abs(s21Fdib));
    RLRdib=-20*log10(abs(s11Rdib));
    ILRdib=-20*log10(abs(s21Rdib));
    DeltaPhidib=(180/pi)*(angle(s21Rdib./s21Fdib));
    %
    figure(1)
    plot(fdib,RLFdib,'r',...
         fdib,ILFdib,'b',...
         fdib,RLRdib,'r--',...
         fdib,ILRdib,'b--',...
         [f1 f1 f2 f2],RLdesired+[-5 0 0 -5],'k-',...
         [f1 f1 f2 f2],ILdesired+[1.5 0 0 1.5],'k-')
    axis([4 8 0 25])
    xlabel('Frequency (GHz)')
    ylabel('(dB)')
    legend('RL F',...
           'IL F',...
           'RL R',...
           'IL R',...
           'Location','best')
    %   
    figure(2)
    plot(fdib,DeltaPhidib,...
         [f1 f1 f2 f2],Deltaphidesired+DeltaDeltaphidesired*[2 1 1 2],'k-',...
         [f1 f1 f2 f2],Deltaphidesired-DeltaDeltaphidesired*[2 1 1 2],'k-')
    axis([4 8 30 50])
    xlabel('Frequency (GHz)')
    ylabel('(degrees)')
    legend('\Delta\phi',...
           'Location','best')
    %
    figure(3)
    plot([f1 f2],[0 0],'k',...)
          f,errorILF,'b',...
          f,errorILR,'b--',...
          f,errorRLF,'r',...
          f,errorRLR,'r--',...
          f,errorPHI1,'g',...
          f,errorPHI2,'g')
    %
    drawnow
end

end

