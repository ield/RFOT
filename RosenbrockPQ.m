function f = RosenbrockPQ(x,P,Q)
%ROSENBROCK computes the Rosenbrock function with parameters P and Q
%   f = ROSENBROCK(x,P,Q)
%
%   x = vector of size 2
%   P = first scalar parameter
%   Q = second scalar parameter
%
%   f = scalar function value

f = Q*(x(2)-x(1)^2)^2+(P-x(1))^2;

end

