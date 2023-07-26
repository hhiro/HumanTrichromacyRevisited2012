function  btsStruct = cm_loadbootstrapResults(subinds, numMech, fovflag, corflag, coneflag, ResampleRatio, condname)
% btsStruct = cm_loadbootstrapResults(subinds, numMech, fovflag, corflag, coneflag, ResampleRatio)
%
% This function reads bootstrapped results.
% 
%   <Input>
%     subinds         ... which subject
%     numMech         ... number of mechanisms
%     fovflag         ... 1 is fovea, 0 is periphery
%     corflag         ... 1 is Correct the model for pigment density
%     coneflag        ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%     ResampleRatio   ... ratio of resampling (from 0 to 1)
%     condname        ... name of condition 
%
%
%   <Output>
%     btsStruct (strucnt) bootstrapping result struct by cm_mechfitBS.m
%       Thresholds ... Predicted threshold by model
%       PredPoints ... Predicted coodinate in 4D space
%       V          ... Visivility Matrix
%       paramSets  ... parameters for analysis
%       sSumL      ... sum of negative log-likilihood
%       eTh        ... Predicted threshold at each temporal frequency
%       ePp        ... Predicted coodinate at each temporal frequency 
%       rsInds     ... randsample index
%
%
% See Also 
%    cm_mechfitBS.m
% 
% HH (c) Vista lab Oct 2012. 
%

% Examples: 
%{
 subinds  = 1; % which subject
 numMech  = 3; % number of mechanisms
 fovflag  = 1; % fovea or periphery
 corflag  = 0; % correct axis or not with pigment density
 coneflag = 0; % only cone pigmetn or not

 ResampleRatio = 0.9; 
 
 btsStruct = cm_loadbootstrapResults(subinds, numMech, fovflag, corflag, coneflag, ResampleRatio)
%}


%%

if ~exist('condname','var') || isempty(condname)
    condname = [];
end

if ~exist('subinds','var') || isempty(subinds)
    help cm_loadbootstrapResults
    btsStruct = [];
    return
end

homedir  = pwd; % store home directory

% get method tag
[methodTag tempFreqs] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag);

% get folder name which bootstrapped results exist
foldername = cm_definefolderforSaveSGEresults(subinds, methodTag, fovflag, corflag, ResampleRatio, condname);

% number of different freq dataset 
nFreq = length(tempFreqs);

%%  load bootstrapped results

cd(foldername) % change directory
d = dir;       % get file information in the directory

ind = 1; ntTag = 1;
% main loop
for ii = 1:length(d)
    
    % only mat file should be loaded here
    
    n = d(ii).name;
    if ~strcmp(n,'.') && ~strcmp(n,'..') && ~strcmp(n,'.DS_Store')
        
        % load mat file
        tmp = load(n);
        
        % how many data set in the result loaded
        nTry = size(tmp.Thresh,1);        
        % index for the end of the matrix 
        ntTagEnd = ntTag+nTry-1;
        
        Thresholds(ntTag:ntTagEnd,:)   = tmp.Thresh;
        PredPoints(:,:,ntTag:ntTagEnd) = tmp.PredP;
        
        % if the case the model was solved at one frequency data
        if ind == 1 && size(tmp.VisMtrcies,3) == 1
            V = tmp.VisMtrcies;
            
        else % data usually are solved for all freq data set simultaneously
            V(:,:,:,ntTag:ntTagEnd,:) = tmp.VisMtrcies;
        end
        
        % put each freq data 
        
        for ik = 1:nFreq
            
            clear EachP EachT EachR
            
            for ij = 1:nTry
                EachP(:,:,ij) = tmp.eachP{ij}{ik};
                EachT(ij,:)   = tmp.eachT{ij}{ik};
                EachR(ij,:)   = tmp.RSs{ij}{ik};
            end
        
            ePp{ik}(:,:,ntTag:ntTagEnd)  = EachP;
            eTh{ik}(ntTag:ntTagEnd,:)    = EachT;
            rsInds{ik}(ntTag:ntTagEnd,:) = EachR;
            
        end        
        sSumL(ind)  = tmp.params;
        
        ntTag       = ntTagEnd + 1;
        ind         = ind + 1;

    end    
end

% put data into the struct
paramSets = tmp.params;

btsStruct = struct('Thresholds', Thresholds, 'PredPoints', PredPoints,...
                    'V', V, 'paramSets', paramSets, 'sSumL', sSumL);

btsStruct.eTh = eTh; btsStruct.ePp = ePp; btsStruct.rsInds = rsInds;

cd(homedir)

end
