%% PMSM Drive Using Field-Oriented Control
% 
% This example models an electric drive with supporting design scripts that:
% 1. Determine open-loop frequency response and check stability margins. This requires Simulink® Control Design, using the Frequency Response Estimator block.
% 2. Determine the optimum d-axis and q-axis currents that minimize overall motor losses when delivering a commanded torque and speed.
% The Electric Drive is implemented using:
% 1. A detailed nonlinear motor model in the form of tabulated flux linkages and Steinmetz coefficients.
% 2. A Field-Oriented Controller (FOC) that has been optimized to minimize motor losses.
% 
% Copyright 2022 The MathWorks, Inc.

%% System Model

%% Model
model = 'pmsm_foc_drive';
open_system(model)

set_param(find_system(bdroot,'FindAll','on','type','annotation','Tag','ModelFeatures'),'Interpreter','off');

%% Inverter Model

open_system('SwitchingInverterTabulated');

%% Field-Oriented Controller

open_system([model, '/PMSM Controller/PMSM Field-Oriented Controller'], 'force');

%% Plot Losses With Original Controller

out = sim(model);
plotSystemLosses(out.simlog_pmsm_foc_drive);

%% Optimize Controller to Minimize Losses

ControllerOptimization;
set_param([model, '/PMSM Controller'], 'ControllerParameters', 'OptimalControllerParams');


%% %% Plot Losses With Optimal Controller

plotSystemLossesOriginalAndOptimal;

%%
% 
clear all
close all
bdclose all