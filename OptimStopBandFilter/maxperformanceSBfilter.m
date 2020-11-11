function U = maxperformanceSBfilter(www,draw)

%
%%%
%%%%% Constant parameters
%%%
%
lll=[9.14 9.55 9.16]; % (mm)
wref=2.58; % (mm)
h=0.762; % (mm)
er=2.17;
% If these parameters are fixed, the only parameters that can be optiized
% are the widths of the stubs.

%
%%%
%%%%% Frequency sweep and filter response
%%%
%
%f=linspace(0,11,111);
f=linspace(1.5,10,86);
[s11,s21] = stopbandfilter(www,lll,wref,h,er,f);
RL=-20*log10(abs(s11));
IL=-20*log10(abs(s21));

%
%%%
%%%%% Objective function definition
%%%
%
f1=1.5;
f2=4.8;
f3=5.5;
f4=6.5;
f5=7.5;
f6=10;
minIL_SB=20; % (dB)
maxIL_PB=0.5; % (dB)

%
%%% Lower pass-band
indsLPB=find(f>=f1&f<=f2);              % Indezes of the lower passband.
weight1=1/length(indsLPB)/maxIL_PB;     % The value of the specification (maxIL_PB) is important because it is not the same an error of 0.5 in 1 dB than in 40 dB.In the latter, is less significant.
error1=weight1*(IL(indsLPB)-maxIL_PB);  % All the errors are calculated by subtraction.

% Now the weights are not irrelevant, because there are different errors,
% so the weights are to be considered. If all the errors are given the same
% weight without looking at the number of frequency points, there can be
% some strange results.

%
%%% Stop-band
indsSB=find(f>=f3&f<=f4);
weight2=1/length(indsSB)/minIL_SB;
error2=weight2*(minIL_SB-IL(indsSB));
%
%%% Upper pass-band
indsUPB=find(f>=f5&f<=f6);
weight3=1/length(indsUPB)/maxIL_PB;
error3=weight3*(IL(indsUPB)-maxIL_PB);

%
%%% Join all errors
%
error=[error1 error2 error3];
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
    fdib=linspace(0,11,221);
    [s11dib,s21dib] = stopbandfilter(www,lll,wref,h,er,fdib);
    %
    figure(1)
    plot(fdib,-20*log10(abs(s11dib)),...
         fdib,-20*log10(abs(s21dib)),...
         [f1 f1 f2 f2],maxIL_PB+[2 0 0 2],'k-',...
         [f3 f3 f4 f4],minIL_SB-[10 0 0 10],'k-',...
         [f5 f5 f6 f6],maxIL_PB+[2 0 0 2],'k-')
    ylim([0 25])
    xlabel('Frequency (GHz)')
    ylabel('(dB)')
    legend('RL',...
           'IL',...
           'Location','best')
    %
    figure(2)
    plot(f(indsLPB),error1,...
         f(indsSB),error2,...
         f(indsUPB),error3,...
         [min(f) max(f)],[0 0],'k--')
    ylim(0.05*[-1 1])
    drawnow
end

end

