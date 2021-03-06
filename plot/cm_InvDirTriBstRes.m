function [InvDirTrichromacy LMSrespStim] = cm_InvDirTriBstRes(btsparams, tempInd, condname)
% [InvDirTrichromacy LMSrespStim] = cm_InvDirTriBstRes(btsparams, tempInd, condname)
%
% This function finds invisible stimulus direction in 4D space from
% bootstrapped Trichormacy model. 
% 
% 1) Load bootstrapped results, which indicates Visivility matrix by
% Trichromacy model.
% 
% 2) Trichromacy model consists of three hyperplane in 4D space, which
% indicates that hole direction exists. 
%
% 3) The hole direction is undetectable direction - which is 'estimated
% invisible direction' by Trichromacy model.
%
% <Input>
%   btsparams [struct]  ... parameters for bootstarapping analysis 
%       Fov             ... 1 is fovea, 0 is periphery
%       Sub             ... which subject
%       NMech           ... number of mechanisms
%       Cor             ... 1 is Correct the model for pigment density
%       Cone            ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%       nBoot           ... number of bootstrapping process
%       ResampleRatio   ... ratio of resampling (from 0 to 1)
%
%   tempInd             ... which temporal data (fovea;1-2. periphery; 1-3)
%   condname            ... name of condition, default is blank (char)
%
% <Output>
%   InvDirTrichromacy   ... Invisible direction by Trichromacy model
%   LMSrespStim         ... estimated LMS responses to the stimulus
%
%
% see also cm_ConditionPrepforBootstrapipngSGE.m
%
% HH (c) Vista lab Oct 2012. 
%
%%
if ~exist('tempInd','var') || isempty(tempInd)
    tempInd = 1;
end


if ~exist('condname','var') || isempty(condname)
    condname = [];
end

% exponential
p = 2;

%%
subinds  = btsparams.Sub;   % which subject
numMech  = btsparams.NMech; % number of mechanisms
fovflag  = btsparams.Fov;   % fovea or periphery
corflag  = btsparams.Cor;   % correct axis or not with pigment density
coneflag = btsparams.Cone;  % only cone pigmetn or not

ResampleRatio = btsparams.ResampleRatio;

ind = 1;
%% main loop

for sub = subinds
    for nM = numMech
        for fv = fovflag
            if ~(sub == 3 && fv == true) % because S3 foveal data doesn't exist
                for cr = corflag
                    
                    for cn = coneflag
                        
                        % load bootstrapped results
                        btsStruct = cm_loadbootstrapResults(sub, nM, fv, cr, cn, ResampleRatio, condname);
                        
                        % visibility matrix
                        VisMtx = btsStruct.V;
                        
                        %% calc invisible stimulus direction 
                        nTrials = size(VisMtx,4);
                        nullDs  = zeros(4,nTrials);
                        
                        for ij = 1:nTrials
                            nullDs(:,ij) = cm_findHoleEllispoid(VisMtx(:,:,tempInd,ij),p);
                        end
                         
                        %% estimate LMS response to the stimuli
                        LMSrespStim{ind}  = cm_EstLMSresponse(nullDs, sub, fv);                        
                                                
                        %%
                        InvDirTrichromacy{ind} = nullDs;                                                
                        ind = ind+1;
                    end
                end
            end
        end
    end
end


end
