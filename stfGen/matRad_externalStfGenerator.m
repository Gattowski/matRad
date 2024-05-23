classdef matRad_externalStfGenerator.m < StfGenerator.matRad_StfGenerator
% Implement these properties in a subclass
    properties (Constant)
        possibleRadiationModes = {'protons','photons','carbon','helium'};
        name = 'extStfGen';
        shortName = 'extStfGen';
    end 
    
    % Public properties
    properties
        gantryAngle;
        couchAngle;
        bixelWidth;
        SAD;
        isoCenter;
        numOfRays;
        ray;
        sourcePoint_bev
        sourcePoint;
        numOfBixelPerRay;

    end
    
    methods
        
        function this = matRad_externalStfGenerator(pln)   
            if nargin < 1
                pln = [];
            end

            % call superclass constructor
            this = this@StfGenerators.matRad_StfGenerator(pln); 


        end
        function setDefaults(this)
            setDefaults@StfGenerator.matRad_StfGenerator(this);

            % create config instance
            matRad_cfg = MatRad_Config.instance(); 
            

            
           
            

        end
    end

end
