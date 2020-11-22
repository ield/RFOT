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

% The starting point is determinant. Other starting points lead to other
% optimal dimensions, which are not that optimal... These initial values
% are satisfactory because they do not imply a very high attenuation, which
% is not good either.
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

% Method
% Depending on the method used to calculate the error it is tried to only
% reduce the separation between branches or both the separation and the
% attenuation, depending on the application case
%   1: to only reduce the separation between branches: fewer functions
%   needed but the attenuation differs with the frequency. Used for
%   narrowband applications.
%   2: to reduce the separation between branches and the attenuation of the
%   coupled and direct outputs. More functions needed but the attenuation
%   is more constant in both paths. Used for wideband applications
method = 1;

errorCoupler(xini,wref,f,inds,f1,f2,RLdesired,ISOdesired, method, true);

%%
% Optimization
%
% Setting the vector of initial values and optimization values
lb_width = 0.15;
lb_length = 5;

ub_width = 5;
ub_length = 16;     % Modified based on seen results set to 16

lb=[lb_width lb_width lb_width lb_width lb_length  lb_length  lb_length];
ub=[ub_width ub_width ub_width ub_width ub_length ub_length ub_length];
%
options=optimset('fmincon');
options.Display='iter';
[xopt]=fmincon(@(x) U_Coupler(x, wref, f,inds,f1,f2,RLdesired,ISOdesired, method, false),...
               xini,...
               [],[],[],[],lb,ub,[],...
               options);

errorCoupler(xopt,wref,f,inds,f1,f2,RLdesired,ISOdesired, method, true);
xopt