function Y = yieldshifter(xxx,draw)

Yexp=0.96;   % Expected yield
Csigma=3;   % Confidence. Times std.dev.
EpsF=0.005; % Accepted fractional error
Number=ceil(Yexp*(1-Yexp)*(Csigma/EpsF)^2);

% Nominal lumped elements
Rs=3;     % (ohms)
CT=1e-3;  % (nF)

% Evaluate objective function for 'Number' pahse shifters
for iNumber=1:Number
    xxxcal=xxx+0.2*truncatednormal(size(xxx),2);        %Adding an error of +-0.2mm
    Rscal=Rs+0.1*Rs*truncatednormal([1 1],2);           % In this case we are considering a 10% viablitity because we are multiplying by 0.1
    CTcal=CT+0.1*CT*truncatednormal([1 1],2);
    U(iNumber) = maxperformanceshifter(xxxcal,Rscal,CTcal,false);
end

% Evaluate Yield estimation
Y=sum(U<=0)/Number;

%
%%%
%%%%% Figures
%%%
%
if draw
    figure(2)
    hist(U,[-1 1])
    title([num2str(Number) ' samples'])
    set(gca,'XtickLabel',[{'Acceptable'} {'Non acceptable'}])
    drawnow
end

end

