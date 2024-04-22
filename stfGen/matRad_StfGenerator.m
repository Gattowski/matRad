classdef (Abstract) matRad_StfGenerator    
% Implement these properties in a subclass
    properties (Constant, Abstract)
       shortName;               % short identifier by which matRad recognizes an engine
       name;                    % user readable name for dose engine
       possibleRadiationModes;  % radiation modes the engine is meant to process
       %supportedQuantities;    % supported (influence) quantities. Does not include quantities that can be derived post-calculation.
    end    
    
    % Public properties
    properties
        totalNumOfBixels;

    end
    
    % Protected properties with public get access
    properties (SetAccess = protected, GetAccess = public)
        machine;                % base data defined in machine file
    end


    methods      
        %Constructor  
        function this = matRad_StfGenerator(pln)
            this.setDefaults();
            if nargin == 1 && ~isempty(pln)
                this.assignPropertiesFromPln(pln);
            end
        end

        function assignPropertiesFromPln(this,pln,warnWhenPropertyChanged)
            matRad_cfg = MatRad_Config.instance();


            % find all target voxels from cst cell array
            V = [];
            for i=1:size(cst,1)
                if isequal(cst{i,3},'TARGET') && ~isempty(cst{i,6})
                    V = [V; cst{i,4}{1}];
                end
            end

            % Remove double voxels
            V = unique(V);
            % generate voi cube for targets
            voiTarget    = zeros(ct.cubeDim);
            voiTarget(V) = 1;
    
            % add margin
            addmarginBool = matRad_cfg.propStf.defaultAddMargin;
            if isfield(pln,'propStf') && isfield(pln.propStf,'addMargin')
               addmarginBool = pln.propStf.addMargin; 
            end
            

                 
        end

    end
end


