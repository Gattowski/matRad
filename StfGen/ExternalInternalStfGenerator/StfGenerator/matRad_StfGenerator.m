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
        totalNumOfBixels;

    end
    
    % Protected properties with public get access
    properties (SetAccess = protected, GetAccess = public)
        machine;                % base data defined in machine file
    end

end
