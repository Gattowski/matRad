classdef matRad_StfGenerator 

    properties (Constant, Abstract)
       shortName;               % short identifier by which matRad recognizes an engine
       name;                    % user readable name for dose engine
       possibleRadiationModes;  % radiation modes the engine is meant to process
    end    
    
 
    properties
        ct
        cst
        pln
        visMode
        matRad_cfg
        stf
    end
    
    methods
        function this = matRad_StfGenerator(ct, cst, pln, visMode)
              
            
            this.matRad_cfg = MatRad_Config.instance();
            addpath(fullfile(this.matRad_cfg.matRadRoot));
            this.matRad_cfg.dispInfo('matRad: Generating stf struct...');
            this.pln = pln;
            this.cst = cst;
            this.ct = ct;
            this.visMode = visMode;
            
            if ~isfield(pln, 'propStf')
                this.matRad_cfg.dispError('no applicator information in pln struct');
            end
            
            this.matRad_cfg.dispInfo('Processing completed: %d%%\n', 100);

            
        end
        
        function this = generateImageCoordinates(this)
            V = [];
            for i = 1:size(this.cst, 1)
                if isequal(this.cst{i, 3}, 'TARGET') && ~isempty(this.cst{i, 6})
                    V = [V; vertcat(this.cst{i, 4}{:})];
                end
            end
            
            V = unique(V);
            voiTarget = zeros(this.ct.cubeDim);
            voiTarget(V) = 1;
            
            addmarginBool = this.matRad_cfg.propStf.defaultAddMargin;
            if isfield(this.pln, 'propStf') && isfield(this.pln.propStf, 'addMargin')
                addmarginBool = this.pln.propStf.addMargin;
            end
            
            if addmarginBool
                voiTarget = matRad_addMargin(voiTarget, this.cst, this.ct.resolution, this.ct.resolution, true);
                V = find(voiTarget > 0);
            end
            
            if isempty(V)
                this.matRad_cfg.dispError('Could not find target.');
            end
            
            [coordsY_vox, coordsX_vox, coordsZ_vox] = ind2sub(this.ct.cubeDim, V);
            
            this.stf.targetVolume.Xvox = coordsX_vox;
            this.stf.targetVolume.Yvox = coordsY_vox;
            this.stf.targetVolume.Zvox = coordsZ_vox;
            
            V = [this.cst{:, 4}];
            V = unique(vertcat(V{:}));
            
            eraseCtDensMask = ones(prod(this.ct.cubeDim), 1);
            eraseCtDensMask(V) = 0;
            for i = 1:this.ct.numOfCtScen
                this.ct.cube{i}(eraseCtDensMask == 1) = 0;
            end
        end
        
        function this = saveVoiCoordinates(this)
            % Ensure the voxel coordinates are within valid range
            if all(this.stf.targetVolume.Xvox > 0 & this.stf.targetVolume.Xvox <= length(this.ct.x)) && ...
               all(this.stf.targetVolume.Yvox > 0 & this.stf.targetVolume.Yvox <= length(this.ct.y)) && ...
               all(this.stf.targetVolume.Zvox > 0 & this.stf.targetVolume.Zvox <= length(this.ct.z))
                
                % Ensure voxel coordinates are integers
                this.stf.targetVolume.Xvox = round(this.stf.targetVolume.Xvox);
                this.stf.targetVolume.Yvox = round(this.stf.targetVolume.Yvox);
                this.stf.targetVolume.Zvox = round(this.stf.targetVolume.Zvox);
                
                this.stf.targetVolume.Xvox = this.ct.x(this.stf.targetVolume.Xvox);
                this.stf.targetVolume.Yvox = this.ct.y(this.stf.targetVolume.Yvox);
                this.stf.targetVolume.Zvox = this.ct.z(this.stf.targetVolume.Zvox);
            else
                error('Indices must be positive integers and within valid range');
            end
        end

    end
end






