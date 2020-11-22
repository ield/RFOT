function error = errorCoupler(values,wref,f,inds,f1,f2,RLdesired,ISOdesired, method, draw)

% Evaluates the error between the measured data and the constraints. 
%   1. It takes the values and denormalizes the input (or not)
%   2. It calculates all the s-parameters and rl, etc.
%   3. Compares the s-parameters with the constraints to compute the error.
%   4. Draws the error (or not)
%   4. We do not need to take care about the bounds.
% Variables
%   wref = microstrip line widths of ports (mm)
%   wh1,wh2 = microstrip line widths of longitudinal lines (mm)
%   wr1,wr2 = microstrip line widths of branches (mm)
%   lh1,lh2 = microstrip line lengths of longitudinal lines (mm)
%   lr = microstrip line length of branches (mm)
%   f = frequency (GHz). Can be a vector.
%   inds = working frequency band (GHz)
%   f1, f2 = limits (lower and upper) of the frequency band
%   RL, ISO desired = the objective functions
%   draw = if it necessary to draw at the end of each iteration

% Step 1.
% The values are not given normalized because all the units are more or
% less the same.

% Step 1
wh1=values(1);
wh2=values(2);
wr1=values(3);
wr2=values(4);
lh1=values(5);
lh2=values(6);
lr=values(7);

normalized = false;
if normalized
    wref = wref*2.01;
    wh1=2.96*wh1;
    wh2=4.34*wh2;
    wr1=0.003*wr1;
    wr2=1.55*wr2;
    lh1=17.30*lh1;
    lh2=17.40*lh2;
    lr=16.30*lr;
end


% Step 2
[s11,s21,s31,s41] = microstripbranchlinecoupler(wref,wh1,wh2,wr1,wr2,lh1,lh2,lr,f);

RL=-20*log10(abs(s11));     % Return loss
DIR=-20*log10(abs(s21));    % Direct
COU=-20*log10(abs(s31));    % Coupled
ISO=-20*log10(abs(s41));    % Isolation

% Step 3
% The errors are going to be 3:
%   1. The return loss
%   2. The isolation
%   3. The separation between the coupled and direct branch. This error in
%   the future will be ponterated with the average of the coupled and
%   direct branches so that it is also reduced.
%   4. The minimum attenuation
%
% The most impotant goal is to satisfy 1 and 2. Then, it is optimized 3 and
% 4. If they are not satisfied then the solution does not matter.
%
% Depending on the method used to calculate the error it is tried to only
% reduce the separation between branches or both the separation and the
% attenuation.

% 3.1
% The weight is scaled to 2.5 because these criteria are the most important
% ones and need to be satiafied.
weightRL = 2.5/length(inds)/RLdesired;
errorRL = weightRL*(RLdesired-RL(inds));

% 3.2
% The weight is scaled to 2.5 because these criteria are the most important
% ones and need to be satiafied.
weightISO = 2.5/length(inds)/ISOdesired;
errorISO = weightISO*(ISOdesired-ISO(inds));

delta_dir_cou = abs(DIR(inds) - COU(inds)); % Distance between branches, for 3.3


% 3.3 and 3.4
% Depending on the method it is only calculated one or two errors.
% In both cases it is set a goal, determined empiracally after several
% tests, which determines the objective of both the attenuation or
% difference that is targetted.

switch method
    case 1      % It is onl considered the separation between coupled and direct lines
        % 3.3
        diff_goal = 0.43;          % Best result so far = 0.545
        weightDiff = 1/length(inds)/diff_goal;
        errorDiff = weightDiff*(delta_dir_cou-diff_goal).*((delta_dir_cou-diff_goal)>0);
        error = [errorRL errorISO errorDiff];
        
    case 2
        
        % 3.3 
        diff_goal = 0.5;
        weightDiff = 1/length(inds)/diff_goal;
        errorDiff = weightDiff*(delta_dir_cou-diff_goal).*((delta_dir_cou-diff_goal)>0);  % It is reduced the number of evaluation functions
        
        % 3.4
        cou_dir_goal = 4.8;
        weightAtt = 1/length(inds)/cou_dir_goal;
        errorDir = weightAtt*(DIR(inds)-cou_dir_goal).*((DIR(inds)-cou_dir_goal)>0);
        errorCou = weightAtt*(COU(inds)-cou_dir_goal).*((COU(inds)-cou_dir_goal)>0);
        
        error = [errorRL errorISO errorDiff errorDir errorCou];

end

% Step 4
if draw
    maxDELTA=max(abs(DIR(inds)-COU(inds)));
    cenDELTA=(DIR(inds)+COU(inds))/2;           % Average between both values. It is later used to plot the lines that go with the graph

    yield = length(find([errorRL errorISO]>0.00001)) / length([errorRL errorISO]);
    Amax = max([COU(inds) DIR(inds)]);
    
    % difference between maximum and minimum attenuation.
    pass_delta = max([COU(inds) DIR(inds)]) - min([COU(inds) DIR(inds)]);
    
    % Figures
    figure(1)
    %
    subplot(2,1,1)
    plot(f,RL,...
         f,ISO,...
         [f1 f1 f2 f2],RLdesired+[-10 0 0 -10],'k',...
         [f1 f1 f2 f2],ISOdesired+[-10 0 0 -10],'k')
    axis([min(f) max(f) 0 40])
    ylabel('(dB)')
    title(['Satisfied = ' num2str(yield == 0)]);
    legend('RL',...
           'ISO',...
           'Location','Best')
    %
    subplot(2,1,2)
    plot(f,DIR,...
         f,COU,...
         f(inds),cenDELTA+maxDELTA/2,'k',...
         f(inds),cenDELTA-maxDELTA/2,'k',...
         f(inds), Amax*ones(1, length(inds)), 'r--')
    axis([min(f) max(f) 2 9])
    xlabel('Frequency (GHz)')
    ylabel('(dB)')
    title(['\Delta = ' num2str(maxDELTA) ' dB: A_{max} = ' num2str(Amax) 'dB; A_{diff} = ' num2str(pass_delta) ' dB'])
    legend('DIR',...
           'COU',...
           'Location','Best')

    
end

end

