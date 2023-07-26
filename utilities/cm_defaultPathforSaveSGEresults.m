function path = cm_defaultPathforSaveSGEresults(condname)
% path = cm_defaultPathforSaveSGEresults(condname)
%
% This function defines a home path to store the bootstrapped results. If
% the path folder doesn't exist, the function will make it. 
% 
% <Input>
%       condname ... condition name (char)
% 
% <Output>
%       path     ... path name (char)
%
% see also cm_defaultPathforSaveSGEresults.m
%
% HH (c) Vista lab Oct 2012. 
%

%%
if ~exist('condname','var') || isempty(condname)
    condname = '';
end

% This was set up to run on Linux biac and hard coded.  Changing.
%
% path = fullfile('~','PNASsgeRsults',condname);
% path = fullfile('/','biac4','wandell','biac3','wandell7','hhiro', condname,'PNASsgeRsults'); % currently search seeds

path = fullfile(cmPublicRootPath,'local',condname,'PNASsgeResults');

if ~exist(path,'dir')
   mkdir(path) 
end

end