classdef matRad_photonStfGen < ExternalInternalStfGenerator.matRad_externalStfGenerator

    properties (Constant)
        possibleRadiationModes = {'photons'};
        name = 'photonExtStfGen';
        shortName = 'photonExtStfGen';
    end     

    methods
        
        function this = matRad_photonStfGen(pln)   
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