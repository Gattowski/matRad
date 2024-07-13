classdef matRad_photonStfGenerator < matRad_externalStfGenerator

    properties (Constant)
        possibleRadiationModes = {'photons'};
        name = 'photonStfGen';
        shortName = 'photonStfGen';
    end 


    methods
        function this = matRad_photonStfGenerator(ct, cst, pln, visMode)
            this@matRad_externalStfGenerator(ct, cst, pln, visMode);
        end
        
        function generateStf(this) % photon stf 
            generateStf@matRad_externalStfGenerator(this);
            
            % Save ray and target position in lps system. 260-275
            for j = 1:stf(i).numOfRays
                         stf(i).ray(j).beamletCornersAtIso = [rayPos(j,:) + [+stf(i).bixelWidth/2,0,+stf(i).bixelWidth/2];...
                                                              rayPos(j,:) + [-stf(i).bixelWidth/2,0,+stf(i).bixelWidth/2];...
                                                              rayPos(j,:) + [-stf(i).bixelWidth/2,0,-stf(i).bixelWidth/2];...
                                                              rayPos(j,:) + [+stf(i).bixelWidth/2,0,-stf(i).bixelWidth/2]]*rotMat_vectors_T;
                         stf(i).ray(j).rayCorners_SCD = (repmat([0, machine.meta.SCD - SAD, 0],4,1)+ (machine.meta.SCD/SAD) * ...
                                                                          [rayPos(j,:) + [+stf(i).bixelWidth/2,0,+stf(i).bixelWidth/2];...
                                                                           rayPos(j,:) + [-stf(i).bixelWidth/2,0,+stf(i).bixelWidth/2];...
                                                                           rayPos(j,:) + [-stf(i).bixelWidth/2,0,-stf(i).bixelWidth/2];...
                                                                           rayPos(j,:) + [+stf(i).bixelWidth/2,0,-stf(i).bixelWidth/2]])*rotMat_vectors_T;
            end



            for j = stf(i).numOfRays:-1:1 % -463
                 % book keeping for photons
                 stf(i).ray(j).energy = machine.data.energy;
            end

            
        end

        
    end
end
