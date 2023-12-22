close_system('pmsm_foc_drive');
% Clear SystemParams script outputs
clear PmsmParams InverterParams PowSupplyParams SensorParams
clear MechLoadParams SolverParams ControllerParams TestScenarioParams
% Clear ControllerOptimization script outputs
clear betaVec2 Bgrid exitflag exitFlagMat fobj fval hAxs hBattery hController hFig3 hInverter hMotor hTile id idg iDg
clear iDgrid iDrefOpt iDrefOptimal idtrq iDvec idxMatchTrqConstraint idxOpt idxRpm idxTest idxTrq Igrid inverterfidelity
clear iq iqg iQg iQgrid iQrefOpt iQrefOptimal iqtrq iQvec khInterpolant kJInterpolant lenRpmVec lenTrqVec lossTrq magVec2
clear model nPolePairs out output PmotorFcn PmotorThisW PmotorValsw1 PmotorValsw2 prob rotorKhMat_IB rotorKjMat_IB rpmVec
clear Rs sol statorKhMat_IB statorKjMat_IB TmotorFcn TmotorInterpolant TorqueConstraint TorqueMatrix TorqueMatrix_IBX trq
clear trqtest trqVec w w1 w2 wtest x0 xVec2 OptimalControllerParams
% Clear FreqResponseAnalysis script outputs
clear idqrefchoice estStart estStop in InnerLoopParams simInnerLoop simStop OuterLoopParams useParallel
% Display success
disp('Shutdown of PmsmDriveOptimization was successfull')