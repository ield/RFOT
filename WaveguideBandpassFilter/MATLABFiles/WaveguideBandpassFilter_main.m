% Engineer: ield
% Main script to optimize a waveguide bandpass filter using surrogate
% models: a coarse function defined in Matlab and a fine function using
% cst. Code based in SM_Adapter by Jaime Esteban
clear;
close all;
%% Initialization
% Diary and log. Esto se hace para guardar en un fichero txt todo lo que
% sale por pantalla
LogFineResults=[];
LogCoarseResults=[];
diary (['diary_SM_bpf_' datestr(now,30) '.txt']);

% Counters of fine and coarse evaluations.
countFineEvals=0;
countCoarseEvals=0;

% Frequencies
f=10e9:100e3:14e9;  % Frequencies, with resolution each 100 KHz

% Upper and lower bounds (mm)
% w limits take care that the width of the iris is not bigger than the
% width of the cavity (19mm). l limits take care that the length is arounf
% the theoretical lengths
lmin = 10;
lmax = 16;
wmin = 1;
wmax = 18;

dimsmin=[wmin wmin lmin lmin]';
dimsmax=[wmax wmax lmax lmax]';

% Constants
Nvars=4;    % Two lengths and 2 heights.
IDN=eye(Nvars);
ZRN=zeros(Nvars,1);

% Space Mapping optimization initialization
stepbystep=false;
goon=true;
nevals=1;
nevalsMAX=10;

% Options for the optimization routines
optionsfmincon=optimoptions('fmincon');
optionsfmincon.Algorithm='sqp'; 
% It will never evaluate the function in a nonfeasible point: this is
% important because there are some constraints like h1 cannot be bigger
% than b1.
optionslsqnonlin=optimoptions('lsqnonlin');
if stepbystep
    optionsfmincon.Display='iter';
    optionslsqnonlin.Display='iter';
end

%% Initial point
xk=[10.8 8 12.2 13.8]'; % Initial values
[xk,~,~,output]=...
   fmincon(@(v) maxperformancewaveguidebandpassfiltercoarsefunction(v,IDN,ZRN,ZRN,f,false),...
           xk,[],[],[],[],dimsmin,dimsmax,[],optionsfmincon);
% In the first case we dont have the matrix. That is why we insert the
% identity matrix and all the values to 0. However, we use the same
% function. This way we do not have to create a new one

countCoarseEvals=countCoarseEvals+output.funcCount;
maxperformancewaveguidebandpassfiltercoarsefunction(xk,IDN,ZRN,ZRN,f,true);
Bk=IDN;
zguess=xk;
if stepbystep,pause,end

%% Fine function evalution f(xk)
disp(' ')
disp('Fine function (w1, w2, l1, l2)')
disp(xk')

[s11,s21]=controlCST(xk); % The values returned must be transpossed

% This way we dont have to evaluate the fine function constantly
countFineEvals=countFineEvals+1;
funfinek=maxperformancewaveguidebpffinefunction(f,s11.',s21.',true);
%
LogFineResults=[LogFineResults; funfinek xk'];
disp(' ')
disp('Log of fine results:')
disp('Function value    xk')
disp(num2str(LogFineResults,'%9.3g '))
if stepbystep,pause,end

%% Obtain zk
disp(' ')
disp('Mapping ...')
disp(xk')
[zk,~,~,~,output]=...
   lsqnonlin(@(v) mappingerror_bpf(v,f,s11.',s21.',false),...
             zguess,dimsmin,dimsmax,optionslsqnonlin);
countCoarseEvals=countCoarseEvals+output.funcCount;
mappingerror_bpf(zk,f,s11.',s21.',true);
%
disp(' ')
disp('Evaluation of the coarse function ...')
funcoarsek=maxperformancewaveguidebandpassfiltercoarsefunction(zk,IDN,ZRN,ZRN,f,true);
countCoarseEvals=countCoarseEvals+1;
%
LogCoarseResults=[LogCoarseResults;
                  funcoarsek zk'];
disp(' ')
disp('Log of coarse results:')
disp('Function value    zk')
disp(num2str(LogCoarseResults,'%9.3g '))
if stepbystep,pause,end

%% Loop

deltak=norm(xk)/1000; % It is better to start with a very small trust region.
deltaMAX=norm(xk)/10;

while goon
    %
    disp(' ')
    disp('Determine next point ...')
    [xkm1,~,~,output]=...
         fmincon(@(v) maxperformancewaveguidebandpassfiltercoarsefunction(v,Bk,xk,zk,f,false),...
                 xk,[],[],[],[],...
                 dimsmin,dimsmax,@(v) trustregion(v,xk,deltak),optionsfmincon);
    countCoarseEvals=countCoarseEvals+output.funcCount;
    funcoarsekm1EXPECTED=maxperformancewaveguidebandpassfiltercoarsefunction(xkm1,Bk,xk,zk,f,true);
    if stepbystep,pause,end
    %
    %
    disp(' ')
    disp('Evaluation of the fine function ...')
    [s11,s21]=controlCST(xkm1);
    countFineEvals=countFineEvals+1;
    funfinekm1=maxperformancewaveguidebpffinefunction(f,s11.',s21.',true);
    %
    LogFineResults=[LogFineResults;
                    funfinekm1 xkm1'];
    disp(' ')
    disp('Log of fine results:')
    disp('Function value    xkm1')
    disp(num2str(LogFineResults,'%9.3g '))
    if stepbystep,pause,end
    %
    %
    disp(' ')
    disp('Mapping ...')
    disp(xkm1')
    zini=Bk*(xkm1-xk)+zk;
    [zkm1,~,~,~,output]=...
         lsqnonlin(@(v) mappingerror_bpf(v,f,s11.',s21.',false),...
                   zini,dimsmin,dimsmax,optionslsqnonlin);
    countCoarseEvals=countCoarseEvals+output.funcCount;
    mappingerror_bpf(zkm1,f,s11.',s21.',true);
    funcoarsekm1=maxperformancewaveguidebandpassfiltercoarsefunction(zkm1,IDN,ZRN,ZRN,f,true);
    countCoarseEvals=countCoarseEvals+1;
    %
    LogCoarseResults=[LogCoarseResults;
                      funcoarsekm1 zkm1'];
    disp(' ')
    disp('Log of coarse results:')
    disp('Function value    zk')
    disp(num2str(LogCoarseResults,'%9.3g '))
    if stepbystep,pause,end
    %
    % New Jacobian estimation
    hk=xkm1-xk;
    Bkm1=Bk+(1/(hk'*hk))*(zkm1-zk-Bk*hk)*hk';
    %
    % Decision on the confidence radius
    rhoimprov=(funcoarsek-funcoarsekm1)/(funcoarsek-funcoarsekm1EXPECTED);
    disp(' ')
    disp(['Expected change from ' num2str(funcoarsek) ' to ' num2str(funcoarsekm1EXPECTED)])
    disp(['  Actual change from ' num2str(funcoarsek) ' to ' num2str(funcoarsekm1) ])
    disp(['  With a step of the ' num2str(100*norm(hk)/deltak) '% of trust-region size'])
    disp(['Improvement ratio = ' num2str(rhoimprov)])
    disp(['Step size = ' num2str(norm(hk))])
    disp(['Stop criterion = ' num2str(norm(hk)/(1+norm(xk)))])
    if rhoimprov<1/4
        deltak=deltak/2;
        disp(['Delta reduction to ' num2str(deltak)])
    elseif (rhoimprov>3/4)&&(norm(hk)/deltak>0.9)
        deltak=min(2*deltak,deltaMAX);
        disp(['Delta increase to ' num2str(deltak)])
    else
        disp(['Keep Delta as ' num2str(deltak)])
    end
    %
    % Update if improvement
    if funfinekm1<funfinek
        disp(['New objective function = ' num2str(funfinekm1)])
        xk=xkm1;
        zk=zkm1;
        funfinek=funfinekm1;
        funcoarsek=funcoarsekm1;
    end
    %
    % Update in any case
    Bk=Bkm1;
    %
    % Check stop criteria
    if norm(hk)/(1+norm(xk))<1e-4
        goon=false;
        disp(['Stop because change in parameters is ' num2str(norm(hk))])
    end
    nevals=nevals+1;
    if nevals>nevalsMAX
        goon=false;
        disp(['Stop after ' num2str(nevalsMAX) ' iterations'])
    end
    %
    if stepbystep,pause,end
end

disp(' ')
disp('Number of function evaluations')
disp(['No. of fine function evaluations = ' num2str(countFineEvals)])
disp(['No. of coarse function evaluations = ' num2str(countCoarseEvals)])

diary off