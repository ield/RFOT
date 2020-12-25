% Engineer: ield
% Function to control the cst file of the waveguide filter. Function based
% on the code provided by Oleg Iupikov 
% https://www.mathworks.com/matlabcentral/fileexchange/72228-tcstinterface-cst-studio-suite-to-matlab-interface
%%%%%%%%%%%%%%%%%%%%%%%%%%% Important %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% It is not necessary to run a000_RUN_ME_FIRST.m

function [Freq, S11, S21] = controlCST(dim)
% Dim contais the dimensions to be optimized in the fine adjustment:
% dim(1) = l1
% dim(2) = w1
% dim(3) = l2
% dim(4) = w2

%% Initialize CST
CSTProject = 'WaveguideBandpassFilter/CSTFiles/WaveguideBandpassFilter.cst';
CST = TCSTInterface();
CST.OpenProject(CSTProject);

%% Set the new values
dim_names = ['l1'; 'w1'; 'l2'; 'w2'];   % Names of the dimensions to be updated

for ii = 1:length(dim)
    CST.ChangeParameter(dim_names(ii, :), dim(ii)); % Store all parameters
end

%% Run the solver
% It skips if the solution already exists. Beware that the run id is not
% the last one if the solution already exists.
% CST.Solve('SkipIfSolutionExists',true); 
CST.Solve();

%% Retrieve results
% The last results correspond to runid = 0
RunID = 0;  % Last results

% The interesting results are the s11 and the s21
[S11, Freq, ~, ~] = CST.GetSParams(RunID, 1, 1);
[S21, ~, ~, ~] = CST.GetSParams(RunID, 1, 2);
%% Close the project
% CST.CloseProject();
end

