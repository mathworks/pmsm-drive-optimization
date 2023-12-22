function plotSystemLosses(varargin)
    % Utility function to plot power losses of the drive system, in function of time.
    % Input arguments:
    % 1) simlog (simscape.logging.Node)
    % 2) simlog2 (simscape.logging.Node) [optional] -> creates a second plot tiled 
    % next to the first

    % Copyright 2022 The MathWorks, Inc. 
    
    if nargin == 1
        simlog = varargin{1};
    elseif nargin == 2
        simlog1 = varargin{1};
        simlog2 = varargin{2};
    else
        error('Number of input arguments must be 1 or 2')
    end 
    
    model = 'pmsm_foc_drive';
    inverterfidelity = get_param([model '/Inverter'],'LabelModeActiveChoice');
    
    % Get simulation results
    if nargin == 1
        tout = simlog.PMSM.PMSM.iron_losses_rotor.series.time;
        iron_loss = simlog.PMSM.PMSM.iron_losses_rotor.series.values('W') + ...
            simlog.PMSM.PMSM.iron_losses_stator.series.values('W');
        motor_total_loss = simlog.PMSM.PMSM.power_dissipated.series.values('W');
        copper_loss = motor_total_loss - iron_loss;
    else
        tout1 = simlog1.PMSM.PMSM.iron_losses_rotor.series.time;
        iron_loss1 = simlog1.PMSM.PMSM.iron_losses_rotor.series.values('W') + ...
            simlog1.PMSM.PMSM.iron_losses_stator.series.values('W');
        motor_total_loss1 = simlog1.PMSM.PMSM.power_dissipated.series.values('W');
        copper_loss1 = motor_total_loss1 - iron_loss1;

        tout2 = simlog2.PMSM.PMSM.iron_losses_rotor.series.time;
        iron_loss2 = simlog2.PMSM.PMSM.iron_losses_rotor.series.values('W') + ...
            simlog2.PMSM.PMSM.iron_losses_stator.series.values('W');
        motor_total_loss2 = simlog2.PMSM.PMSM.power_dissipated.series.values('W');
        copper_loss2 = motor_total_loss2 - iron_loss2;
    end
    
    switch inverterfidelity
        case 'Averaged'
            if nargin == 1
                inverter_loss = simlog.Inverter.Averaged...
                    .Average_Value_Voltage_Source_Converter_Three_Phase.power_dissipated.series.values('W');

                % Create filled area plot
                figure()
                area(tout,[inverter_loss, copper_loss, iron_loss]);
                title('Power loss')
                xlabel('Time [s]');
                ylabel('Power [W]');
                legend({'Inverter', 'Motor (copper)', 'Motor (iron)'})
                grid on
            else
                inverter_loss1 = simlog1.Inverter.Averaged...
                    .Average_Value_Voltage_Source_Converter_Three_Phase.power_dissipated.series.values('W');
                inverter_loss2 = simlog2.Inverter.Averaged...
                    .Average_Value_Voltage_Source_Converter_Three_Phase.power_dissipated.series.values('W');

                % Create two filled area plots sharing Y axis
                figure('Position', [0, 500, 1000, 500]);
                tiledlayout(1,2,'TileSpacing','compact')
                ax1 = nexttile; % original controller
                
                area(tout1,[inverter_loss1, copper_loss1, iron_loss1]);
                title('Power Loss (Original Controller)')
                xlabel('Time [s]');
                ylabel('Power [W]');
                legend({'Inverter', 'Motor (copper)', 'Motor (iron)'})
                grid on
                ax2 = nexttile; % optimal controller
                
                area(tout2,[inverter_loss2, copper_loss2, iron_loss2]);
                title('Power Loss (Optimal Controller)')
                xlabel('Time [s]');
                ylabel('Power [W]');
                legend({'Inverter', 'Motor (copper)', 'Motor (iron)'})
                grid on

                % Set the same y axis limits on both plots
                powmax1 = max(inverter_loss1 + copper_loss1 + iron_loss1);
                powmax2 = max(inverter_loss2 + copper_loss2 + iron_loss2);
                powmax = max(powmax1,powmax2);
                ylim(ax1, [0, powmax])
                ylim(ax2, [0, powmax]);
            end
            
    
        case {'Switching (Ideal)', 'Switching (Tabulated)'}
            tStop = str2double(get_param(model, 'StopTime'));
            tAvg = 5e-3;
            if nargin == 1
                
                [powerLossCell, switchingLossCell] = ee_getPowerLossTimeSeries(simlog, 0, tStop, tAvg);
        
                [condLossVec, tvecCondLoss] = extractConductionLoss(powerLossCell);
                [switchLossVec, tvecSwitchLoss] = extractSwitchingLoss(switchingLossCell, tStop, tAvg);
                
                % Unify time vectors
                inverter_conduction_loss = interp1(tvecCondLoss,condLossVec, tout);
                inverter_switching_loss = interp1(tvecSwitchLoss,switchLossVec, tout);
        
                % Create filled area plot
                figure()
                area(tout,[inverter_conduction_loss, inverter_switching_loss, copper_loss, iron_loss]);
                title('Power loss')
                xlabel('Time [s]');
                ylabel('Power [W]');
                legend({'Inverter (conduction)', 'Inverter (switching)','Motor (copper)', 'Motor (iron)'})
                grid on
            else
                [powerLossCell1, switchingLossCell1] = ee_getPowerLossTimeSeries(simlog1, 0, tStop, tAvg);
                [powerLossCell2, switchingLossCell2] = ee_getPowerLossTimeSeries(simlog2, 0, tStop, tAvg);

                [condLossVec1, tvecCondLoss1] = extractConductionLoss(powerLossCell1);
                [condLossVec2, tvecCondLoss2] = extractConductionLoss(powerLossCell2);
                [switchLossVec1, tvecSwitchLoss1] = extractSwitchingLoss(switchingLossCell1, tStop, tAvg);
                [switchLossVec2, tvecSwitchLoss2] = extractSwitchingLoss(switchingLossCell2, tStop, tAvg);

                % Unify time vectors
                inverter_conduction_loss1 = interp1(tvecCondLoss1,condLossVec1, tout1);
                inverter_conduction_loss2 = interp1(tvecCondLoss2,condLossVec2, tout2);
                inverter_switching_loss1 = interp1(tvecSwitchLoss1,switchLossVec1, tout1);
                inverter_switching_loss2 = interp1(tvecSwitchLoss2,switchLossVec2, tout2);
        
                % Create filled area plot
                figure('Position', [0, 500, 1000, 500]);
                tiledlayout(1,2,'TileSpacing','compact')

                ax1 = nexttile; % original controller
                area(tout1,[inverter_conduction_loss1, inverter_switching_loss1, copper_loss1, iron_loss1]);
                title('Power Loss (Original Controller)')
                xlabel('Time [s]');
                ylabel('Power [W]');
                legend({'Inverter (conduction)', 'Inverter (switching)', 'Motor (copper)', 'Motor (iron)'})
                grid on

                ax2 = nexttile; % optimal controller
                area(tout2,[inverter_conduction_loss2, inverter_switching_loss2, copper_loss2, iron_loss2]);
                title('Power Loss (Optimal Controller)')
                xlabel('Time [s]');
                ylabel('Power [W]');
                legend({'Inverter (conduction)', 'Inverter (switching)', 'Motor (copper)', 'Motor (iron)'})
                grid on

                % Set the same y axis limits on both plots
                powmax1 = max(inverter_conduction_loss1 + inverter_switching_loss1 + copper_loss1 + iron_loss1);
                powmax2 = max(inverter_conduction_loss2 + inverter_switching_loss2 + copper_loss2 + iron_loss2);
                powmax = max(powmax1,powmax2);
                ylim(ax1, [0, powmax])
                ylim(ax2, [0, powmax]);
            end
    
    end

end

% Helper functions
function [lossvec, tvec] = extractConductionLoss(powerLossCell)
    nodeNames = powerLossCell(:,1);     
    inverterValuesCell = powerLossCell(contains(nodeNames, 'Inverter'),2);
    tvec = inverterValuesCell{1}(:,2); % all nodes share same tvec
    % Aggregate losses from all IGBTs for each timestamp
    lossvec = zeros(size(tvec));
    for idxTime = 1:length(tvec)
        sumLoss = 0;
        for idxIgbt = 1:length(inverterValuesCell)
            sumLoss = sumLoss + inverterValuesCell{idxIgbt}(idxTime,3);
        end
        lossvec(idxTime) = sumLoss;
    end
end

function [lossvec, tvec] = extractSwitchingLoss(switchingLossCell, tStop, tAvg)
    % Concatenate timestamps and energy loss
    numericValuesCell = switchingLossCell(:,2);
    numericValuesArray = cat(1, numericValuesCell{:});
    [tstamp, sortIdxs] = sort(numericValuesArray(:,1));
    Evec = numericValuesArray(:,2);
    Evec = Evec(sortIdxs);
    % Average to compute power
    tvec = 0:tAvg:tStop;
    tvec = tvec';
    lossvec = zeros(size(tvec));
    for idxTime = 2:length(tvec)
        lossvec(idxTime) = sum(Evec(tstamp<=tvec(idxTime)&tstamp>tvec(idxTime-1)))/tAvg;
    end
end
