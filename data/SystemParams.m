%% Parameters for models/pmsm_foc_drive
% Script to generate model parameters for pmsm_foc_drive

% Copyright 2022 The MathWorks, Inc.

%% Parameters
% PMSM parameters
PmsmParams = getFemPmsmParams('SaturationLossMap'); 
PmsmParams.RotorInertia = 5*0.03^2; % [kg*m^2]

% Power Supply parameters
PowSupplyParams = struct();
PowSupplyParams.DCVoltage_V = 500; % [V]

% Sensor parameters
SensorParams = struct();
SensorParams.CurrentSensor.TimeConstant = 1e-6; % [s]
SensorParams.SpeedSensor.TimeConstant = 1e-6; % [s]
SensorParams.PositionSensor.TimeConstant = 1e-6; % [s]

% Mechanical Load parameters
MechLoadParams = struct();
MechLoadParams.Inertia = 50*0.05^2; % [kg*m^2]

% Solver Configuration parameters
SolverParams.LocalSolverSampleTime = 2e-6; % [s]

% Controller parameters
ControllerParams = struct();
% Main parameters
ControllerParams.InverterSwitchingFrequency = 2e3; %[Hz]
ControllerParams.SampleTime = 1/(10*ControllerParams.InverterSwitchingFrequency); % [s] 20 kHz
% General tab
ControllerParams.VdcNominal = PowSupplyParams.DCVoltage_V;
ControllerParams.PowMax = max(PmsmParams.CurrMagVec(:))*PowSupplyParams.DCVoltage_V;
ControllerParams.TrqMax = max(abs(PmsmParams.TorqueMat(:)));
ControllerParams.NumPolePairs = PmsmParams.NumPolePairs;
ControllerParams.InverterVdcThreshold = PowSupplyParams.DCVoltage_V/50;
ControllerParams.FundamentalSampleTime = SolverParams.LocalSolverSampleTime;
% Outer loop tab
ControllerParams.OuterLoop.PropGain = 150;
ControllerParams.OuterLoop.IntegGain = 1500;
ControllerParams.OuterLoop.AntiWindupIntegGain = 1;
ControllerParams.OuterLoop.RpmVec = [1000, 8000];
ControllerParams.OuterLoop.TrqRefVec = [1, 50, 100];
ControllerParams.OuterLoop.VdcVec = [300, 500];
ControllerParams.OuterLoop.iDrefMat = zeros(2,3,2); % Not optimized
ControllerParams.OuterLoop.iQrefMat = repmat([1.5,80,160], 2,1,2); % Not optimized
% Inner loop tab
ControllerParams.InnerLoop.PropGain_iD = 0.373;
ControllerParams.InnerLoop.IntegGain_iD = 47.7;
ControllerParams.InnerLoop.AntiWindupIntegGain_iD = 0;
ControllerParams.InnerLoop.PropGain_iQ = 1.5;
ControllerParams.InnerLoop.IntegGain_iQ = 100;
ControllerParams.InnerLoop.AntiWindupIntegGain_iQ = 465;

% Inverter parameters
InverterParams = getInverterParams('igbt_Infineon_FS200R07A1E3_params.mat', ControllerParams.InverterSwitchingFrequency);

%% Input Signals
TestScenarioParams.RotorSpeedRef_rpm = 3000; % [rpm] % Reference to track
TestScenarioParams.StepTorqueAfter_Nm = 50; % [N*m] % Load torque after step


%% Initial conditions
PmsmParams.InitialRotorSpeed_rpm = TestScenarioParams.RotorSpeedRef_rpm ; % [rpm]
PmsmParams.InitialRotorAngle_rad = -pi/2/PmsmParams.NumPolePairs;
InverterParams.igbt.TjInitial = 25; % [degC] priority=None


%% Reporting
disp('SystemParams.m successful run')
