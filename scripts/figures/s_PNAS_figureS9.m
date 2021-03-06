% s_PNAS_figureS9.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure Caption:
% Estimated rod sensitivity. To estimate rod detection threshold, we
% extrapolated the data from Naarendorp et al(8) to the intensity levels
% used in our experiments. The green symbols show threshold versus
% increment experiments with albino Gnat2cpfl3 mice (lacking cone
% function). An albino ALR/LtJ control threshold is shown as blue circles.
% The yellow circles replot the data of a human rod monochromat (9). Under
% our experimental conditions, we estimate 7.74 x 10^5 isomerizations per
% rod per second (assuming a 3mm pupil, mean background luminance 2060
% cd/m2, inner rod diameter 2.22 µm (at 15 degrees eccentricity(10)) and
% rod peak absorbtance 0.66(11). See also ISET-4.0 for the estimation in
% detail(12)). We extrapolated the rod monochromat data points linearly in
% log-log space (dashed line) to reach the intensity levels in our
% experimental rig. In this case, rod threshold is predicted to be higher
% than 1.0 x 10^6  isomerizations per rod per second, which indicates that
% over 100% of rod modulation is required for a subject to detect rhodopsin
% photon absorptions at these levels (Figure modified from Naarendorp et
% al. (8)).         
%
%
%% Calculate the number of rod absorptions to a uniform scene 
%
% We simulate the rod absorptions to the LED device at its mean light
% level. 
%
% We believe that there are about 750,000 absorptions per second per rod
% for this spectral power distribution at this level.  Rod thresholds under
% these conditions are probably far above 10% modulation.  So, we suspect
% that the visibility of the 4th photopigment signal is not the rods.
%
% Hiroshi Horiguchi, 2012.

% This script requires full set of vset 
% https://github.com/wandell/vset

addpath(genpath('vset'))
%%
s_initISET
%% Set variables

% Photopigment optical density
rodpod = 0.05;

RodinnerSegmentDiameter = 2.22; % 15 deg ecc. Curio 1993
meanluminance = 2060; % cd/m2

% measured pupil size in experiment 
pupilsize = 3; % mm 

rodPeakAbsorbtance = 0.66; % from Rodieck

%% create uniform scene
scene = sceneCreate('uniformee');

% bin of wavelength for analysis here 
wave  = sceneGet(scene,'wave');

% load primaries
primaries = vcReadSpectra('ledSPD_pr715.mat', wave);

% multiply your primaries by illEnergy
illEnergy = primaries * ones(6,1);

% apply illuminant energy to scene
scene = sceneAdjustIlluminant(scene,illEnergy);
% sceneGet(scene,'mean luminance') % you'll probably get 2060 Cd/m2.

% set luminance you desire
scene = sceneSet(scene,'mean luminance', meanluminance);   % Cd/m2
vcAddAndSelectObject(scene);sceneWindow(scene);

%% create an optical image of human eye

% optical image of human
oi = oiCreate('human');

% set pupil size
pRad_meter = pupilsize / 2 / 1000; % pupil radius (m)
optics = opticsCreate('human', pRad_meter);
oi = oiSet(oi,'optics',optics);

%% open an optical image window
% compute optical image
oi = oiCompute(scene,oi);

% add optical image to optical image struct
vcAddAndSelectObject(oi);

% show the optical image
oiWindow;

%%  Now set up the rod sensor parameters

% define rod size as sensor
RodArea   = (RodinnerSegmentDiameter./2)^2 * pi();
Rodpixels = sqrt(RodArea);
pixSize   = Rodpixels*1e-6;

% set sensor tile just as monochrome   
sensor    = sensorCreateIdeal('monochrome',pixSize);

% set various paramter especially for visualization
pixel = sensorGet(sensor,'pixel');
pixel = pixelSet(pixel,'voltageSwing', 300);
sensor = sensorSet(sensor,'pixel',pixel);
sensor = sensorSet(sensor,'autoexposure',0);
sensor = sensorSet(sensor,'exposureTime',1);

% rod response function as color-filter
rodabsorbance = vcReadSpectra('rodabsorbance.mat',wave);
rods = cm_variableLMSI_PODandLambda(rodabsorbance, rodpod, [], LensTransmittance(wave));
rods = rods * rodPeakAbsorbtance;
sensor = sensorSet(sensor,'filter spectra',rods);
sensor = sensorSet(sensor,'filter names',{'wrod'});

% compute sensor response to optical image
sensor = sensorCompute(sensor,oi);

% add and show the image
vcAddAndSelectObject(sensor); sensorImageWindow
%% Calculate number of absorptions (electrons) per rod

% get sensor information
sensor = vcGetObject('sensor');

% define ROI at the center on the sensor
roi    = sensorROI(sensor,'center');

% Put ROI on the sensor
sensor = sensorSet(sensor,'roi',roi);

% Pick up number of electrons in the ROI
elROI  = sensorGet(sensor,'roi electrons');

% mean of electron:
% this is estimated rhodopsin isomarization per rod per second
mean(elROI)

