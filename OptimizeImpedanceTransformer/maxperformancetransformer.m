function U = maxperformancetransformer(zzz,draw)

%
%%%
%%%%% Constant parameters
%%%
%
ZS=20;
ZL=100;
f1=3;
f2=7;
f0=(f1+f2)/2;
%

%
%%%
%%%%% Frequency sweep and transformer response
%%%
%
f=linspace(f1,f2,21);
[s11,s21,~,~] = impedancetransformer(zzz,ZS,ZL,f0,f);
IL=-20*log10(abs(s21));
RL=-20*log10(abs(s11));

%
%%%
%%%%% Objective function definition
%%%
%
RLdesired=40; %(dB)
%
weight=1/length(f)/RLdesired;
errorRL=weight*(RLdesired-RL);  % There is only one source of error, so the error is determined with only one difference.
%
error=errorRL;
MAXe=max(error);

%
%%% Objective function U(x)
%
chosennorm=2;                   % p exponential in the u function
indsP=find(error>=0);
if ~isempty(indsP)              % Is empty if there are no errors (all the errors are negative), but still we have to improve the response
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
    %
    fdib=linspace(2,8,401);
    [s11dib,s21dib,~,~] = impedancetransformer(zzz,ZS,ZL,f0,fdib);
    ILdib=-20*log10(abs(s21dib));
    RLdib=-20*log10(abs(s11dib));
    %
    figure(1)
    plot(fdib,RLdib,...
         fdib,ILdib,...
         f,RL,'o',...
         f,IL,'o',...
         [f1 f1 f2 f2],RLdesired+[-10 0 0 -10],'k-')
    ylim([0 50])
    xlabel('Frequency (GHz)')
    ylabel('(dB)')
    legend('RL',...
           'IL',...
           'Location','best')
    %
    figure(2)
    plot(f,errorRL)
    drawnow
end

end
