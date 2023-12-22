%% Plot System Losses Compared
% Utility script to plot power losses of the original drive system and the 
% optimized drive system, in function of time, sharing Y axis.

% Copyright 2022 The MathWorks, Inc. 

model = 'pmsm_foc_drive';
% Run model with original controller parameters
SystemParams;
set_param([bdroot, '/PMSM Controller'], 'ControllerParameters', 'ControllerParams');
disp('Original system parameters loaded')
out1 = sim(model);

% Run model with optimal controller parameters
if exist('OptimalControllerParams','var')
set_param([bdroot, '/PMSM Controller'], 'ControllerParameters', 'OptimalControllerParams');
else
ControllerOptimization;
set_param([bdroot, '/PMSM Controller'], 'ControllerParameters', 'OptimalControllerParams');
end
disp('Optimal controller parameters loaded')
out2 = sim(model);


plotSystemLosses(out1.simlog_pmsm_foc_drive, out2.simlog_pmsm_foc_drive);