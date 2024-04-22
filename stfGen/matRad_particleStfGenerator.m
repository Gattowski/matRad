classdef matRad_particleStfGen < ExternalInternalStfGenerator.matRad_externalStfGenerator
    properties (Constant)
        possibleRadiationModes = {'protons','carbon','helium'};
        name = 'ParticleExtStfGen';
        shortName = 'ParticleExtStfGen';
    end     
    
    % Public properties
    properties
        longitudinalSpotSpacing
    end

    methods
        
        function this = matRad_particleStfGen(pln)   
            if nargin < 1
                pln = [];
            end

            % call superclass constructor
            this = this@ExternalInternalStfGenerator.matRad_externalStfGenerator(pln); 


        end
        function setDefaults(this)
            setDefaults@ExternalInternalStfGenerator.matRad_externalStfGenerator(this);

            % create config instance
            matRad_cfg = MatRad_Config.instance(); 
            

            
           
            

        end
    end
end