function [v] = powerSum(x, b)
v = zeros(1, length(b));
for ii = 1:length(b)
%     v(ii) = 0;
%     for jj = 1:length(b)
%         v(ii) = v(ii) + x(jj)^ii;
%     end
%     v(ii) = v(ii) - b(ii);
    v(ii) = sum(x.^ii) - b(ii);
end
end

