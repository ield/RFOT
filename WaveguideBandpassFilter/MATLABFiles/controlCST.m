% Engineer: ield
% Function to control the cst file of the waveguide filter. Function based
% on the code provided by Oleg Iupikov 
% https://www.mathworks.com/matlabcentral/fileexchange/72228-tcstinterface-cst-studio-suite-to-matlab-interface
%%%%%%%%%%%%%%%%%%%%%%%%%%% Important %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% It is not necessary to run a000_RUN_ME_FIRST.m

function [S11, S21] = controlCST(dim)
% Dim contais the dimensions to be optimized in the fine adjustment:
% dim(1) = w1
% dim(2) = w2
% dim(3) = l1
% dim(4) = l2

%% Initialize CST
CSTProject = 'WaveguideBandpassFilter/CSTFiles/WaveguideBandpassFilter.cst';
CST = TCSTInterface();
CST.OpenProject(CSTProject);

%% Set the new values
dim_names = ['w1'; 'w2'; 'l1'; 'l2'];   % Names of the dimensions to be updated

for ii = 1:length(dim)
    CST.ChangeParameter(dim_names(ii, :), dim(ii)); % Store all parameters
end

%% Run the solver
% It skips if the solution already exists. The run id is set to the
% existant solution or to 0 if the solution does not exist
[SolutionExists, ~, RunID] = CST.SolutionExistsForCurrentParameterCombination();
if ~SolutionExists
    CST.Solve
    RunID = 0; % The last results correspond to runid = 0,
end

CST.Solve();

%% Retrieve results

  % Last results

% The interesting results are the s11 and the s21
[S, ~, ~, ~] = CST.GetSParams(RunID);

S11 = squeeze(S(1, 1, :));
S21 = squeeze(S(2, 1, :));
% It is checked that the frequencies of the S-parameters is the one of the
% coarse evaluation

%% Close the project
% CST.CloseProject();
end

