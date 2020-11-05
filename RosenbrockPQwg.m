function [f,grad] = RosenbrockPQwg(x,P,Q)
%ROSENBROCK computes the Rosenbrock function with parameters P and Q
%   f = ROSENBROCK(x,P,Q)
%
%   x = vector of size 2
%   P = first scalar parameter
%   Q = second scalar parameter
%
%   f = scalar function value
%   grad = gradient

f = Q*(x(2)-x(1)^2)^2+(P-x(1))^2;

% The gradient is not always required so, depending on the outputs required
% it is returned the gradient or not. The gradient is calculated by hand.

if nargout > 1 % gradient required
    grad = [4*Q*x(1)*(x(1)^2-x(2))+2*(x(1)-P);
                   2*Q*(x(2)-x(1)^2)        ];
end

end

