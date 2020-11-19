% Initial values for a microstrip branch-line coupler using the formulas
% that you can find in the books. Many of these values are not feasible.
% Running this: rl meets spec, il almost meets spec

% Dimensions
wref=2.01;
wh1=2.96;
wh2=4.34;
wr1=0.003;
wr2=1.55;
lh1=17.30;
lh2=17.40;
lr=16.30;

% Frequency band
f1=2.05;
f2=2.85;

% Specs
RLdesired=20; %(dB)
ISOdesired=25; %(dB)

% Response
f=linspace(1,4,121);
[s11,s21,s31,s41] = ...
            microstripbranchlinecoupler(wref,wh1,wh2,wr1,wr2,lh1,lh2,lr,f);
RL=-20*log10(abs(s11));
DIR=-20*log10(abs(s21));
COU=-20*log10(abs(s31));
ISO=-20*log10(abs(s41));
%
inds=find(f>=f1&f<=f2);
maxDELTA=max(abs(DIR(inds)-COU(inds)));     % Maximum separation in the inds zone: the workinf frequency band
cenDELTA=(DIR(inds)+COU(inds))/2;           % A verga ebetween both values. It is later used to plot the lines that go with the graph

% Figures
figure(1)
%
subplot(2,1,1)
plot(f,RL,...
     f,ISO,...
     [f1 f1 f2 f2],RLdesired+[-10 0 0 -10],'k',...
     [f1 f1 f2 f2],ISOdesired+[-10 0 0 -10],'k')
axis([min(f) max(f) 0 40])
ylabel('(dB)')
legend('RL',...
       'ISO',...
       'Location','Best')
%
subplot(2,1,2)
plot(f,DIR,...
     f,COU,...
     f(inds),cenDELTA+maxDELTA/2,'k',...
     f(inds),cenDELTA-maxDELTA/2,'k')
axis([min(f) max(f) 2 9])
xlabel('Frequency (GHz)')
ylabel('(dB)')
title(['\Delta = ' num2str(maxDELTA) ' dB'])
legend('DIR',...
       'COU',...
       'Location','Best')

