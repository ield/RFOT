%% Genetic Algorithms / Evolution Programs
%
%%% Save figures for the result
%
figure(1);figure(2);

%
%%% Bounds
%
lb=[ 20  20 6 6 20 20 6 6 ];
ub=[125 125 60 60 125 125 60 60];

%
%%% Optimization options
%
options = optimoptions('ga');
%
options.Display='iter';
options.PlotFcns={@gaplotbestf,@gaplotdistance};
% The genetic algorith depends on so many parameters that you need some
% feedback to see what is happening and be able to correct something.
%   gaplotbestf shows the value of the function for each individual, 
%   gaplotdistanceshows the average of 20% of individuals randomly selected
%   (whole population)
% This way you know both the best result and a picture of the population

options.Generations=800;
options.FunctionTolerance=1e-6;
options.MaxStallGenerations=options.Generations/10; % Maximum iterations without improvement to stop the program.
%
%%% INITIAL POPULATION CREATION
options.PopulationSize=200; % This value must be as large as possible. So that the variance of the generation is not reduced quickly.
%options.CreationFcn=@gacreationuniform;
options.CreationFcn=@gacreationlinearfeasible;
% gacreationlinearfeasible 
% This function creates the random initial population, but it is important
% to take care of the constraints.
%
%%% SCALING / RANK
options.FitnessScalingFcn=@fitscalingprop;
% options.FitnessScalingFcn={@fitscalingshiftlinear, 2}; % Parameter: No~p% Change the selection preasire at each iteration
% A too low selection pressure means that all the offsprings come from the
% same individual, and too high it means that randomom individuals are
% generated constantly.

% options.FitnessScalingFcn={@fitscalingtop,5}; % Parameter: No. % You only take the best 5, regarless on how good or bad they are

% options.FitnessScalingFcn=@fitscalingrank; % In stead of looking at the values of the fitness, you rank the elements and thake a fitness function that only considers the position of the rank. Matlab uses the second function in slide 13
%
%%% SELECTION
options.SelectionFcn=@selectionroulette;
%options.SelectionFcn=@selectionstochunif;  % Stochastic uniform selection
% options.SelectionFcn={@selectiontournament,2}; % Parameter: No~ps % Choosing k elements and from the k elements select the best. The parameter is k (in this case 2).
%
%%% ELITISM
% Elitism crossover and notation are related because MATLAB 
%   1. Determines the elite, and selects them.
%   2. With the remaining population, there are selected some individuals
%   with the crossover function. The percentage of individuals chosen are
%   determined in the crossover fraction.
%   3. The remaining are chosen in mutation.
options.EliteCount=3; % Parameter: No   % Number of best elements that pass directly to the best generation
%
%%% CROSSOVER
options.CrossoverFraction=0.8; % The percentage of individuals chosen at crossover
%options.CrossoverFcn={@crossoverheuristic, 1.2};  % Parameter: ratio
                                             %Avoid when using constraints
% This is the heuristic way: it is determined the distance to advance, but
% not in \beta such as in the slides, but from the bad value: 1 + beta many
% times. We cannot use it because we have constraints.


options.CrossoverFcn={@crossoverintermediate, 1}; % Parameter: ratio
% There is a parameter alpha that must not be below 0.37 For alpha  = 0.5,
% in matlab the ratio is set to 1. (as seen above)
%
%%% MUTATION
%options.MutationFcn={@mutationuniform, 0.01}; % Parameter: mutation rate.
%Probability of the parameters to change:changed randomly to a value
%between the parameters of the population
                                             % Avoid when using constraints
                                             % 
options.MutationFcn={@mutationgaussian, 1, 1}; % Parameters: initial std. dev
%                                                             shrink
%                                                             factor: how the variance decreases: var = var(1-shrink*k/maxNumberGenerations) where k is the iteration. At the end, k = maxNumberGenerations, so var goes to 0
                                             %Avoid when using constraints
options.MutationFcn=@mutationadaptfeasible; %Useless when not using constraints.
% This is the only possibility with contrained optimization because it ensures the offsprings are in the space.

%
%%% Call the Genetic Agorithm Solver
% Se that you can have linear constraints (such as ub, lb)
% maxperformancedoublestubtuner is the function that must be minimized but
% BEWARE the fitness function should be always positive, so that f =
% (1/(u+a)) where u is the objective function. U is the function to be
% minimized (maxperformancedoublestubtuner), the fitness function is
% determines as explained.
%
[xopt,fopt]=ga(@(x) maxPerformanceDoubleStubTuner(x,false),...
               8,...
               [],[],[],[],lb,ub,[],options);

%
%%% Check result
%
maxPerformanceDoubleStubTuner(xopt,true)
%
disp('Parameters (Z, L)')
disp(xopt)
