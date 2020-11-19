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
xini=[wh1 wh2 wr1 wr2 lh1 lh2 lr];

% Frequency band
f1=2.05;
f2=2.85;

% Specs
RLdesired=20; %(dB)
ISOdesired=25; %(dB)

% Response
f=linspace(1,4,121);
inds=find(f>=f1&f<=f2);

errorCoupler(wref, xini, f,inds,f1,f2,RLdesired,ISOdesired, true);

%%
% Optimization
%
% Setting the vector of initial values and optimization values

lb=[0.15 0.15 0.15 0.15 5  5  5];
ub=[5 5 5 5 inf inf inf];
%
options=optimset('fmincon');
options.Display='iter';
[xopt]=fmincon(@(x) U_Coupler(wref, x, f,inds,f1,f2,RLdesired,ISOdesired, false),...
               xini,...
               [],[],[],[],lb,ub,[],...
               options);

errorCoupler(wref, xopt, f,inds,f1,f2,RLdesired,ISOdesired, true);