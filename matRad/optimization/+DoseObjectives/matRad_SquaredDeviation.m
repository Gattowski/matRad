classdef matRad_SquaredDeviation < DoseObjectives.matRad_DoseObjective
% matRad_SquaredDeviation Implements a penalized least squares objective
%   See matRad_DoseObjective for interface description
%
% References 
%     -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    
    properties (Constant)
        name = 'Squared Deviation';
        parameterNames = {'d^{ref}'};
        parameterTypes = {'dose'};
    end
    
    properties
        parameters = {60};
        penalty = 1;
    end

    
    methods
        function obj = matRad_SquaredDeviation(penalty,dRef)
            
            %If we have a struct in first argument
            if nargin == 1 && isstruct(penalty)
                inputStruct = penalty;
                initFromStruct = true;
            else
                initFromStruct = false;
                inputStruct = [];
            end
            
            %Call Superclass Constructor (for struct initialization)
            obj@DoseObjectives.matRad_DoseObjective(inputStruct);
                        
            %now handle initialization from other parameters
            if ~initFromStruct
                if nargin == 2 && isscalar(dRef)
                    obj.parameters{1} = dRef;
                end
                
                if nargin >= 1 && isscalar(penalty)
                    obj.penalty = penalty;
                end
            end
        end
   
        %% Calculates the Objective Function value
        function fDose = computeDoseObjectiveFunction(obj,dose)
            % deviation : dose minus prefered dose
            deviation = dose - obj.parameters{1};
            % claculate objective function
            fDose = 1/numel(dose) * (deviation'*deviation);
        end
        
        %% Calculates the Objective Function gradient
        function fDoseGrad   = computeDoseObjectiveGradient(obj,dose)
            % deviation : Dose minus prefered dose
            deviation = dose - obj.parameters{1};
            
            % calculate delta
            fDoseGrad = 2 * 1/numel(dose) * deviation;
        end
    end
    
    methods (Static)
        function rob = availableRobustness()
            rob = DoseObjectives.matRad_DoseObjective.availableRobustness();
            rob{end+1} = 'PROB'; %By default, no robustness is available
        end
    end
    
end
