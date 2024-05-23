classdef matRad_internalStfGenerator < StfGenerator.matRad_StfGenerator
% Implement these properties in a subclass
    properties (Constant)
        possibleRadiationModes = {'brachy'};
        name = 'intStfGen';
        shortName = 'intStfGen';
    end


        % Public properties
    properties
        targetVolume;
        numOfSeedsPerNeedle;
        numOfNeedles;
        template;
        templateNormal;
        seedPoints;
    end

    methods
        
        function this = matRad_internalStfGenerator(pln)   
            if nargin < 1
                pln = [];
            end

            % call superclass constructor
            this = this@StfGenerator.matRad_StfGenerator(pln); 


        end
        function setDefaults(this)
            setDefaults@StfGenerator.matRad_StfGenerator(this);

            % create config instance
            matRad_cfg = MatRad_Config.instance(); 
            

            
           
            

        end
    end    
end
