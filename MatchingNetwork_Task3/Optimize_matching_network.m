% Script that finds the global minimum of a matching netwrok by 1.
% simulated annheling and 2. local minimization with the obtained result.
% Author: ield

%% Initialize variables
load fimpedances.mat;
f0 = mean(f);

%% Define the limits
xini = rand(1,5)-0.5;

% The capacitances and indictances are expected to be in the range
%   1pf<c<1nf
%   1ph<l<1uh
% Therefore, it is seen that there is a gap between the minimum absolute
% value of l and c when computed the 'parameter p'. Therefore, that values
% are corrected as explained below.
% The limits are initially obtained for the capacitance and inductances values
% available in RS (https://es.rs-online.com/web/) and then corrected seeing
% which values lead to errors: l>2nH and c>10pf, c<0.5 pf

c_max = 10e-12;       % Value in F
c_min = 0.5e-12;      % Value in F
% Minimum abs(P) that can be obtained when C = c_min. Approx = 1.38e-7
min_abs_p_c = 1/(2*pi*f0*1e9*c_max);
% Minimum P that can be obtained when C = c_max. Approx = -6496
min_par = -1/(2*pi*f0*1e9*c_min);

l_min = 100e-12;      % Value in H
l_max = 2e-9;         % Value in H
% Minimum abs(P) that can be obtained when L = l_max. Approx = 1.5394
min_abs_p_l = 2*pi*f0*1e9*l_min;
% Maximum P that can be obtained when L = L_max. Approx = 6e6
max_par = 2*pi*f0*1e9*l_max;

lb = min_par*ones(1, 5);
ub = max_par*ones(1, 5);

%% Simulated annheling
% The temperature is increased to 1000 because the starting values to look
% at are a long space, so it is important to have many jumps at the
% beginning.
% The reduction factor is decreased, because after restrictign the bouds,
% the convergence was very clear, with very few "false minima" (local
% minima), so this way it is resudced the number of evaluation functions
% The other parameters are left as they were.

sa_t=1000;  
sa_rt=0.45;
sa_nt=5;
sa_ns=20;
[xopt,fopt]=simann(@(x) Matching_network_objective(x, f, Z_S, Z_L, f0, ...
                   min_abs_p_c, min_abs_p_l, 1),...
                   xini,lb,ub,sa_t,sa_rt,sa_nt,sa_ns,true);
               
figure;
subplot(2, 1, 1);
rho_opt = matchingnetwork5(xopt, f, Z_S, Z_L, f0);
plot(f, -20*log10(abs(rho_opt)));
xlabel('Frequency (GHz)');
ylabel('|\rho|^2');
title('Local + Global results');
hold on;

fprintf('Simulated annheling results\n');
for ii = 1:length(xopt)
   if(xopt(ii) >= 0)
       par = xopt(ii) + min_abs_p_l;
       L = par / (2*pi*f0*1e9)*1e9;
       fprintf('L%i = %f nH\n', ii, L);
   else
       par = xopt(ii) - min_abs_p_c;
       C = -1 / (2*pi*f0*1e9*par)*1e12;
       fprintf('C%i = %f pF\n', ii, C);
   end
end

%% Local optimization
% The results obtained using global optimization are improved with local
% optimization. It can be observed that the error is reduced a little bit
% from the global input (it is important that the error function reduces
% rho AND reuduces the separation between values).
xini = xopt;
options=optimoptions('lsqnonlin');
options.Algorithm='trust-region-reflective';
options.Display='iter';
[xopt]=lsqnonlin(@(x) Matching_network_objective(x, f, Z_S, Z_L, f0, ...
                   min_abs_p_c, min_abs_p_l, 2),xini,lb,ub,options);

rho_opt = matchingnetwork5(xopt, f, Z_S, Z_L, f0);
plot(f, -20*log10(abs(rho_opt)), 'k--');
legend('Global', 'Local');

fprintf('Local optimization results\n');
for ii = 1:length(xopt)
   if(xopt(ii) >= 0)
       par = xopt(ii) + min_abs_p_l;
       L = par / (2*pi*f0*1e9)*1e9;
       fprintf('L%i = %f nH\n', ii, L);
   else
       par = xopt(ii) - min_abs_p_c;
       C = -1 / (2*pi*f0*1e9*par)*1e12;
       fprintf('C%i = %f pF\n', ii, C);
   end
end

% Finally, it is compared what would have been obtained if using only local
% optimization. Once in a while, the resultant function is the one in the
% local + global optimization, but it depends on the starting point

xini = rand(1,5)-0.5;
[xopt_test]=lsqnonlin(@(x) Matching_network_objective(x, f, Z_S, Z_L, f0, ...
                   min_abs_p_c, min_abs_p_l, 2),xini,lb,ub,options);

rho_opt_test = matchingnetwork5(xopt_test, f, Z_S, Z_L, f0);

subplot(2, 1, 2)
plot(f, -20*log10(abs(rho_opt_test)));
xlabel('Frequency (GHz)');
ylabel('|\rho|^2');
title('Using ONLY local optimization...');