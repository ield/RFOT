function [error] = Matching_network_objective(x, f, Z_S, Z_L, f0, ...
                    min_abs_p_c, min_abs_p_l, type)
% Author: ield
% Transforms the rho given by matchingnetwrok5 to the error of the problem.
% The error is calculated as in a lsq nonlin problem.
% The error considers two aspects: reducing rho, and reducing the distance
% between values: it is assumed that rho should be small and similar in all
% the frequency band.
% Type: 1 if the optimization, 2 if the optimization is local (lsqnonlin)
%% Transforms the values of x:
% The capacitances and indictances are expected to be in the range
%   1pf<c<1nf
%   1ph<l<1uh
% Therefore, it is seen that there is a gap between the minimum absolute
% value of l and c when computed the 'parameter p'. Therefore, that values
% are corrected as explained below
% 
% min_abs_p_c = Minimum abs(P) that can be obtained when C = c_max. Approx = -0.0065
% min_abs_p_l = Minimum abs(P) that can be obtained when L = l_max. Approx = 0.01539
%
% The values that are positive are increased min_abs_p_l and the values
% that are negative are decreased min_abs_p_c

x(x>=0) = x(x>=0) + min_abs_p_l;
x(x<0) = x(x<0) - min_abs_p_c;
%% Calculating the error
% There are two errors: the first one is due to have pho > 0. The second
% one is due to have different values.
rho = matchingnetwork5(x, f, Z_S, Z_L, f0);

if(type == 1)
    % Error 1
    error1 = sum(abs(rho));

    % Error 2
    rho_deviation = abs(rho - mean(rho));
    error2 = sum(abs(rho_deviation).^2);

%     error = sqrt(error1^2 + error2^2);
    error = error1;
    
else 
    % Error 1
    error1 = abs(rho);

    % Error 2
    rho_deviation = abs(rho - mean(rho));
    error2 = rho_deviation;

    error = [error1; error2]';
end


end

