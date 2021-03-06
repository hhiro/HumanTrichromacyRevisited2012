function f = cm_histPigments(pod,mds,lfs, limitPigs)
% f = cm_histPigments(pod,mds,lfs, limitPigs)
%  
% This function draws histgrams for pigment density. The results should be
% calculated cm_pigmentCorrection.m
%
% see also cm_pigmentCorrection.m and s_PNAS_figureS2.m
%
% HH (c) Vista lab Oct 2012. 
%
%% prep

binnum = 20;  % number of binning
YL = [0 400]; % limitaion of Y axix

titlename = {'L-cone POD', 'M-cone POD','S-cone POD'};

% prep color
E{1}{1} = [1 0 0];  F{1}{1} = 'none'; 
E{1}{2} = [0 1 0];  F{1}{2} = 'none';
E{1}{3} = [0 0 1];  F{1}{3} = 'none';
E{1}{4} = [1 1 0];  F{1}{4} = 'none';
E{1}{5} = [0 1 1];  F{1}{5} = 'none';

E{2}{1} =  'none';  F{2}{1} = [1 0 0] ;
E{2}{2} =  'none';  F{2}{2}  =[0 1 0] ;
E{2}{3} =  'none';  F{2}{3} = [0 0 1] ;
E{2}{4} =  'none';  F{2}{4} = [1 1 0] ;
E{2}{5} =  'none';  F{2}{5} = [0 1 1] ;

ind = 1;
nsub = length(pod);
%%
for subinds = 1:nsub
    
    if iscell(pod)
        PODS = pod{subinds};
        MDS  = mds{subinds};
        LFS  = lfs{subinds};
    else
        PODS = pod;
        MDS  = mds;
        LFS  = lfs;
    end
    
    
    %% macular
    f(ind) =figure('Position',[0 0 600 900]);

    subplot(2,1,1)
    
    ranges = [limitPigs(3) limitPigs(4)];
    bins = linspace(ranges(1), ranges(2), binnum);

    hist(MDS,bins)    
    xlim(ranges)
    h = findobj(gca,'Type','patch');
    set(h(1),'FaceColor',F{subinds}{4},'EdgeColor',E{subinds}{4},'LineWidth',3);
    
    title('macular pigment')
    ylim(YL);
    hold on
    
    %% lens
    subplot(2,1,2)
    
    ranges = [1-limitPigs(5) 1+limitPigs(5)];
    bins = linspace(ranges(1), ranges(2), binnum);
    
    hist(LFS,bins)
    xlim(ranges)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',F{subinds}{5},'EdgeColor',E{subinds}{5},'LineWidth',3);
    
    title('lens pigment')
    ylim([0 250]);
    hold on
    ind = ind + 1;
    
    %% photopigment optical density
    
    f(ind) =figure('Position',[600 0 600 1100]);

    
    ranges = [limitPigs(1) limitPigs(2)];
    bins = linspace(ranges(1), ranges(2), binnum);
    
    for ii = 1:3
        subplot(3,1,ii)
        hist(PODS(:,ii),bins); xlim(ranges);
        title(titlename{ii})
        h = findobj(gca,'Type','patch');        
        set(h(1),'FaceColor',F{subinds}{ii},'EdgeColor',E{subinds}{ii},'LineWidth',3);        
        ylim(YL);
        hold on
    end
    
    ind = ind + 1;
end