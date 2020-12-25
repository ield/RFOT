% Engineer: ield
% Calculate the error of the fine function
function [U] = maxperformancewaveguidebpffinefunction(f,s11,s21,draw)

f = f/1e9;  

RL=-20*log10(abs(s11));
IL=-20*log10(abs(s21));

%
%%%
%%%%% Objective function definition
%%%
%
f1=11.1;
f2=11.7;
f3=12.3;
f4=12.9;
minRL_PB=20; % (dB)
minIL_SB=20; % (dB)

%
%%% Lower stop-band
indsLSB=find(f<=f1);
weight1=1/length(indsLSB)/minIL_SB;
error1=weight1*(minIL_SB-IL(indsLSB));
%
%%% Pass-band
indsPB=find(f>=f2&f<=f3);
weight2=1/length(indsPB)/minRL_PB;
error2=weight2*(minRL_PB-RL(indsPB));
%
%%% Lower stop-band
indsUSB=find(f>=f4);
weight3=1/length(indsUSB)/minIL_SB;
error3=weight3*(minIL_SB-IL(indsUSB));

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
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    figure(100);
    set(gcf,'Color',[1 1 1]);
    plot(f,-20*log10(abs(s11))); hold on;
    plot(f,-20*log10(abs(s21))); hold on;
    plot([min(f) f1 f1],minIL_SB-[0 0 10],'k-'); hold on;
    plot([f2 f2 f3 f3],minRL_PB-[10 0 0 10],'k-'); hold on;
    plot([f4 f4 max(f)],minIL_SB-[10 0 0],'k-'); hold on;
    ylim([0 40])
    title(['Fine function = ' num2str(U)])
    xlabel('Frequency (GHz)')
    ylabel('(dB)')
    legend('RL',...
           'IL',...
           'Location','best')
    drawnow
    hold off;
end
end

