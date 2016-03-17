function [CSI,usedNodes] = mapFindCSI(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin==4
    Set1=varargin{1};
    Set2=varargin{2};
    shiftsize=varargin{3};
    colshifts=varargin{4};
    option=1;
elseif nargin>=5
    Set1=varargin{1};
    Set2=varargin{2};
    shiftsize=varargin{3};
    colshifts=varargin{4};
    option=2;
    meanCSI=varargin{5};
else
    error('Incorrect Number of inputs to function FindCSI.  Check requirements')
end

    
[k,l]=size(Set1);
%% Graph Search
if option==1
    [PathPts, usedNodes] = mapGraphSearchFirstPass(Set1,Set2,2,20000,40,25,10,5,1,1,0,1);
%     [PathPts, usedNodes] = GraphSearchFirstPass(Set1,Set2,2,20000,40,25,100,100,1,1,0,1);
else
    [PathPts, usedNodes] = GraphSearchSecondPass(Set1,Set2,meanCSI,2,20000,40,25,10,5,1,1,0,1);
end

%% Inverse Shift
CSI = [];
if ~isempty(PathPts)
    for k = 1:numel(PathPts)
        
        if mean(full(PathPts(k).weight)) < 0.5, continue, end
        
        kCSI.weight = PathPts(k).weight;
        
        kCSI.x = PathPts(k).x;
        kCSI.y = PathPts(k).y;
        kCSI.keep = PathPts(k).keep;
        
        kCSI.y = kCSI.y - colshifts(kCSI.x) - shiftsize;
        
        CSI = [CSI kCSI];

    end
end

% HERE KEEP ONLY THE STRETCHES THAT ARE VALID, BASED LENTH, HEIGHT, WEIGHT, AND MUTUAL SUPERIMPOSITION.

end
