%% s_PNAS_figure6B.m
% 
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure caption:
% (B) Peripheral data. The quadratic models based on Trichromacy (left) and
% Tetrachromacy (middle) are shown for S1, S2 and a third subject (S3).
% Comparing Trichromacy to Tetrachromacy, the RMSE values decrease from
% 0.106 to 0.045 (S1), 0.058 to 0.030 (S2), and 0.061 to 0.044 (S3).
% Otherwise as in (A).              
%
% HH (c) Vista lab Oct 2012. 
%%
pos  = [0 0 500 500];                     % figure position
C    = [0 0 0; 0.6 0.6 0.6; 0.8 0.8 0.8]; % color for each subject

confIntv = 80;                            % confidence interval
tempInd  =  1;                            % which temporal data set 
%% get measurement error in each stimulus
% [widthoferrx MeasurementErrors EachThreshold eachEx] = cmErrorCalcMeasurement(subinds, fovflag, confIntv);
% 
% % Define the position of black bar in the figure
% sx = 0.01; sy = 0.5;
% sxend = 10.^(log10(sx) + widthoferrx);

%% Fig 6B. Trichromacy at Periphery (left)
figname = 'fig6p3';
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);
condname         = 'Noise05pNFromSearchGrid';
[x y er seP3 rawY] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd, condname);

%% draw
f6p3    = figure('Position',pos);
cm_plotPredEstComp(x, y, er, C, bstparams.Fov);

% store data
clear data
data.x = x; data.y = y; data.er = er; data.yers = seP3; data.rawY = rawY;
set(gcf,'UserData',data);

%% Fig 6B. Tetrachromacy at Periphery (center)
figname = 'fig6p4';
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);
[x y er seP4 rawY] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd, condname);

%% draw
f6p4    = figure('Position',pos);
cm_plotPredEstComp(x, y, er, C, bstparams.Fov);

% store data
clear data
data.x = x; data.y = y; data.er = er; data.yers = seP4; data.rawY = rawY;
set(gcf,'UserData',data);

%% save 
cm_figureSavePNAS(f6p3,'6p3')
cm_figureSavePNAS(f6p4,'6p4')

%% figure 6B right
% load dichromacy model bootstrapped results
figname = 'fig6r'; 
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);
[~,~,~,seFovPeriDichro] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd, condname);

%% peripheral data
% sort data
SquareErrorsPeri{1} = seFovPeriDichro{3}; SquareErrorsPeri{2} = seP3{1}; SquareErrorsPeri{3} = seP4{1};
SquareErrorsPeri{4} = seFovPeriDichro{4}; SquareErrorsPeri{5} = seP3{2}; SquareErrorsPeri{6} = seP4{2};
SquareErrorsPeri{7} = seFovPeriDichro{5}; SquareErrorsPeri{8} = seP3{3}; SquareErrorsPeri{9} = seP4{3};
% calc RMSE
RMSEsPeri= cm_calcMeasurementError(SquareErrorsPeri);

%% draw peripheral results
f6Bright = cm_plotRMSEresults(RMSEsPeri);

% store
clear data
data.RMSEsPeri = RMSEsPeri;
set(gcf,'UserData',data);

%% save
cm_figureSavePNAS(f6Bright,'6Bright')
