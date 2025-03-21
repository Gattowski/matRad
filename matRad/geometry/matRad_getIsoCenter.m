function isoCenter = matRad_getIsoCenter(cst,ct,visBool)
% computes the isocenter [mm] as the joint center of gravity 
% of all volumes of interest that are labeled as target within the cst 
% struct
% 
% call
%   isoCenter = matRad_getIsoCenter(cst,ct,visBool)
%
% input
%   cst:        matRad cst struct
%   ct:         ct cube
%   visBool:    toggle on/off visualization (optional)
%
% output
%   isoCenter:  isocenter in [mm]   
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSE.md. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if visBool not set toogle off visualization
if nargin < 3
    visBool = 0;
end

% Initializes V variable.
V = [];

%Check if any constraints/Objectives have been defined yet
if size(cst,2) >= 6
    noObjOrConst = all(cellfun(@isempty,cst(:,6)));
else
    noObjOrConst = true;
end

% Save target indices in V variable.
for i = 1:size(cst,1)
    % We only let a target contribute if it has an objective/constraint or
    % if we do not have specified objectives/constraints at all so far
    if isequal(cst{i,3},'TARGET') && (noObjOrConst || ~isempty(cst{i,6}))
        V = [V; cst{i,4}{1}];
    end
end

% Delete repeated indices, one voxel can belong to two VOIs, because
% VOIs can be overlapping.
V = unique(V);

% throw error message if no target is found
if isempty(V)
    matRad_cfg = MatRad_Config.instance();
    matRad_cfg.dispError('Could not find target!');
end

% Transform to [mm]
coord = matRad_cubeIndex2worldCoords(V, ct); %idx2worldcoord


% Calculated isocenter.
isoCenter = mean(coord);


% Visualization
if visBool

    clf
    hold on
    
    % Plot target
    plot3(coord(:,2), coord(:,1), coord(:,3),'kx')
    
    % Show isocenter: red point
    plot3(isoCenter(2),isoCenter(1),isoCenter(3),'r.','MarkerSize',30)
    
    xlabel('y [mm]')
    ylabel('x [mm]')
    zlabel('z [mm]')
    
end
