% s_PNAS_figure2.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% We described how we fit a model to threshold data in an m-file;
% cmMechamismfitResultsOutput.m
%
% Figure caption:
% Figure 2. Quadratic model fitting to foveal measurements.  (A) Threshold
% measurements and ellipses estimated by a quadratic model in subject 1
% (S1). We fit the sampled measurements using a quadratic model with three
% mechanisms as defined by the row size of the opponent-mechanism matrix,
% V3x4. The model (black solid line) fits the measurements well (black
% filled circles). Measurement points are shown only if they lie near the
% displayed plane (cosine of the angle between the point and the plane is
% more than 0.95). Upper panels show planes including the cone-silent axis
% (Z: zero-cone) and one of the L-, M-, or S cone pigment axes. The
% photopigment densities are assumed to match the standard color observer
% (see main body). Note that a subject could detect a cone-silent stimulus
% at 2% stimulus modulation. Lower panels show planes consisting of L-, M-,
% and S- cone pigments axes. The ellipses on the cone-pigment planes are in
% good agreement with the color-science literature. The threshold to detect
% L+M light is much higher than L-M and the threshold in the S- direction
% is lower than the L+M threshold. (B) Threshold ellipses and measurements
% estimated in subject 2 (S2). Thresholds are generally lower than those of
% S1. However, the shapes of the ellipses are similar to S1.               
%
%
% HH (c) Vista lab Oct 2012. 
%

%%

% Run everything in the local directory that is ignored by git
chdir(fullfile(cmPublicRootPath,'local'));

%% figure 2A
%  This takes a few minutes to compute.
%
%  Returns the visibility matrix for the mechanisms estimated in Figure 2A
%  using the threshold data set.

subinds  = 1;   % Which subject
numMech  = 3;   % How many mechanisms (3 or 4)
fovflag  = 1;   % In the fovea or not
corflag  = 0;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.
nSeeds = 1000;  % Number of seeds for 1st fitting
[Vis2A, params2A] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

%% Draw Fig 2A analysis from the parameters and data
%  We don't color the background, but the curves are the same.
%  We attach the data set to the matlab figure.

f2a = figure('Position',[0 0 1000 630]);
params2A.subtag = 's1f2a';
cm_mechanismfit_draw2D(Vis2A, params2A,[0 0 0],1);

% store data
clear data;
params2A.subtag = 's1f';
data.params = params2A; data.vismtx = Vis2A;
set(gcf,'UserData',data);

%% The analysis for figure 2B
subinds  = 2; 
[Vis2B, params2B] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% Draw Fig 2B analysis from the parameters and data
f2b = figure('Position',[0 0 1000 630]);
params2B.subtag = 's2f2b';
cm_mechanismfit_draw2D(Vis2B,params2B,[0 0 0],1);

% store data
clear data;
params2B.subtag = 's2f';
data.params = params2B; data.vismtx = Vis2B;
set(gcf,'UserData',data);

%% Save the figures.
% Figures will be saved in a folder defined by
% cm_defaultPathforSavefigure.m 
%
cm_figureSavePNAS(f2a,'2A')
cm_figureSavePNAS(f2b,'2B')
