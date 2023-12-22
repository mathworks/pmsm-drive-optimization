function outLastAc = getMotorCurrentsLastCycle(simlog_pmsm_foc_drive, PmsmParams, TestScenarioParams)
    %GETMOTORCURRENTSLASTCYCLE Outputs a structure with the currents in the
    %last AC cycle of the simulation, and additional parameters

    % Copyright 2022 The MathWorks, Inc. 
    
    % Get simlog signals
    i_a = simlog_pmsm_foc_drive.PMSM.PMSM.i_a.series.values('A');
    i_b = simlog_pmsm_foc_drive.PMSM.PMSM.i_b.series.values('A');
    i_c = simlog_pmsm_foc_drive.PMSM.PMSM.i_c.series.values('A');   
    angular_position_rad = simlog_pmsm_foc_drive.PMSM.PMSM.angular_position.series.values('rad');
    angular_position_mod2pi_rad = mod(angular_position_rad, 2*pi);
    rpmRotor = simlog_pmsm_foc_drive.PMSM.PMSM.angular_velocity.series.values('rpm');
    trq_total_Nm = -1*simlog_pmsm_foc_drive.PMSM.PMSM.torque.series.values('N*m');
    i_d = simlog_pmsm_foc_drive.PMSM.PMSM.i_d.series.values('A');
    i_q = simlog_pmsm_foc_drive.PMSM.PMSM.i_q.series.values('A');
    t_out =  simlog_pmsm_foc_drive.PMSM.PMSM.i_a.series.time;

    % Get relevant motor parameters
    N = PmsmParams.NumPolePairs;
    rpmRef = TestScenarioParams.RotorSpeedRef_rpm;
    trqRefNm = TestScenarioParams.StepTorqueAfter_Nm;

    AcCyclePeriod = 1/(rpmRef/60*N);

    idxLastAcPeriod = t_out >= (t_out(end) - AcCyclePeriod) ;

    % Set output values
    outLastAc.i_a = i_a(idxLastAcPeriod);
    outLastAc.i_b = i_b(idxLastAcPeriod);
    outLastAc.i_c = i_c(idxLastAcPeriod);
    outLastAc.angular_position_rad = angular_position_rad(idxLastAcPeriod);
    outLastAc.angular_position_mod2pi_rad = angular_position_mod2pi_rad(idxLastAcPeriod);
    outLastAc.rpmRotor = rpmRotor(idxLastAcPeriod);
    outLastAc.trq_total_Nm = trq_total_Nm(idxLastAcPeriod);
    outLastAc.i_d = i_d(idxLastAcPeriod);
    outLastAc.i_q = i_q(idxLastAcPeriod);
    outLastAc.t_out = t_out(idxLastAcPeriod);
    % Metadata
    outLastAc.rpmRef = rpmRef;
    outLastAc.trqNmRefNm = trqRefNm;

end

