function pmsmParams = getFemPmsmParams(matFile)
    %GETFEMPMSMPARAMS get parameters for a FEM-Parameterized PMSM. 
    % To learn more about generating parameters from a FEM tool, 
    % >> edit ee_import_fem_motorcad_sat_loss_map.m
    %
    %   Input arguments: matFile [string] file name of a
    %   SaturationLossMap.mat export containing motor parameters
    %   Output arguments: pmsmParams [struct] contains parameters for a
    %   FEM-Parameterized PMSM block

    % Copyright 2022 The MathWorks, Inc. 

    % Parse input arguments
    arguments
        matFile {mustBeText}
    end

    %% Load the exported data
    data = load(matFile,...
        'Frequency','Speed',...
        'Stator_Current_Phase_Peak','Phase_Advance','Angular_Rotor_Position',...
        'Angular_Flux_Linkage_D','Angular_Flux_Linkage_Q','Angular_Electromagnetic_Torque',...
        'Iron_Loss_Rotor_Back_Iron_Hysteresis_Coefficient',...
        'Iron_Loss_Rotor_Back_Iron_Eddy_Coefficient',...
        'Iron_Loss_Rotor_Pole_Hysteresis_Coefficient',...
        'Iron_Loss_Rotor_Pole_Eddy_Coefficient',...
        'Iron_Loss_Stator_Back_Iron_Hysteresis_Coefficient',...
        'Iron_Loss_Stator_Back_Iron_Eddy_Coefficient',...
        'Iron_Loss_Stator_Tooth_Hysteresis_Coefficient',...
        'Iron_Loss_Stator_Tooth_Eddy_Coefficient',...
        'Id_Peak','Iq_Peak','Phase_Resistance_DC_at_20C');
    
    % Derived parameters. Note that this data was calculated as a function of
    % peak current and current advance angle. Modifications to the code below
    % will be required if data was calculated as a function of d-axis and
    % q-axis currents, making use of matrices Id_Peak and Iq_Peak instead of
    % Stator_Current_Phase_Peak and Phase_Advance.
    fLosses = data.Frequency;  % Frequency at which iron losses determined
    N = fLosses/data.Speed*60; % Number of pole pairs
    magVec   = data.Stator_Current_Phase_Peak(:,1)'; % Peak current magnitude vector
    gammaVec  = data.Phase_Advance(1,:); % Current advance angle vector
    angleVec = squeeze(data.Angular_Rotor_Position(1,1,:))'/N; % Rotor angle vector
    fluxDmat = data.Angular_Flux_Linkage_D; % D-axis flux linkage
    fluxQmat = data.Angular_Flux_Linkage_Q; % Q-axis flux linkage
    torqueMat = data.Angular_Electromagnetic_Torque; % Torque matrix
    rotorKhMat = data.Iron_Loss_Rotor_Back_Iron_Hysteresis_Coefficient + ...
                 data.Iron_Loss_Rotor_Pole_Hysteresis_Coefficient; % Steinmetz hysteresis loss coefficient matrix
    rotorKjMat = data.Iron_Loss_Rotor_Back_Iron_Eddy_Coefficient + ...
                 data.Iron_Loss_Rotor_Pole_Eddy_Coefficient; % Steinmetz eddy current loss coefficient matrix
    rotorKexMat = zeros(length(magVec), length(gammaVec)); % Steinmetz excess current loss coefficient matrix
    statorKhMat = data.Iron_Loss_Stator_Back_Iron_Hysteresis_Coefficient + ...
                 data.Iron_Loss_Stator_Tooth_Hysteresis_Coefficient; % Steinmetz hysteresis loss coefficient matrix
    statorKjMat = data.Iron_Loss_Stator_Back_Iron_Eddy_Coefficient + ...
                 data.Iron_Loss_Stator_Tooth_Eddy_Coefficient; % Steinmetz eddy current loss coefficient matrix
    statorKexMat = zeros(length(magVec), length(gammaVec)); % Steinmetz excess current loss coefficient matrix
    Rs = data.Phase_Resistance_DC_at_20C; % Stator resistance


    %% Store parameters in a struct format
    pmsmParams = struct();
    pmsmParams.NumPolePairs = N;
    pmsmParams.CurrMagVec = magVec;
    pmsmParams.CurrAdvAngleVec = gammaVec;
    pmsmParams.RotorAngleVec = angleVec;
    pmsmParams.FluxDMat = fluxDmat;
    pmsmParams.FluxQMat = fluxQmat;
    pmsmParams.TorqueMat = torqueMat;
    pmsmParams.RotorKhMat = rotorKhMat;
    pmsmParams.RotorKjMat = rotorKjMat;
    pmsmParams.RotorKexMat = rotorKexMat;
    pmsmParams.StatorKhMat = statorKhMat;
    pmsmParams.StatorKjMat = statorKjMat;
    pmsmParams.StatorKexMat = statorKexMat;
    pmsmParams.StatorResistance = Rs;


end

