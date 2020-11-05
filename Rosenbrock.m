function f = Rosenbrock(x)
%ROSENBROCK computes the Rosenbrock function with parameters P=1 and Q=100.
% This function is very nteresting to optimize because the minimum is in
% the shape of a banana and the gradient tends to go sometimes outside of
% the minimum. Therefore, many optf functions are tested with this
% function.
%   f = ROSENBROCK(x)
%
%   x = vector of size 2
%
%   f = scalar function value

f = 100*(x(2)-x(1)^2)^2+(1-x(1))^2;

end

