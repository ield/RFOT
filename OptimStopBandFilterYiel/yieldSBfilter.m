function Y = yieldSBfilter(www,draw)

Yexp=0.9;   % Expected yield
Csigma=3;   % Confidence. Times std.dev. You are going to reach a reliability of 99.7%
EpsF=0.005; % Accepted fractional error
Number=ceil(Yexp*(1-Yexp)*(Csigma/EpsF)^2);

% Evaluate objective function for 'Number' filters
for iNumber=1:Number
    wwwcal=www+0.2*truncatednormal(size(www),2);    % It is thinking that there can be an error of +- 0.2 in the fabrication process
    U(iNumber) = maxperformanceSBfilter(wwwcal,false);
end

% Evaluate Yield estimation
Y=sum(U<=0)/Number;
% In this case we are optimizing the yield. The biggest will be the best

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

