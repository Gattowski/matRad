function [saved_metadata] = matRad_writeCube(filepath,cube,datatype,metadata)
% matRad wrapper for Cube export
% 
% call
%   [saved_metadata] = matRad_writeCube(filepath,cube,meta)
%
% input
%   filepath:                   full output path. needs the right extension
%                               to choose the appropriate writer
%   cube:                       cube that is to be written
%   datatype:                   MATLAB numeric datatype
%   metadata:                   meta-information in struct. 
%                               Necessary fieldnames are:
%                               - resolution: [x y z]
%                               Optional:
%                               - axisPermutation (matRad default [2 1 3])
%                               - coordinateSystem (matRad default 'LPS')
%                               - imageOrigin (as used in DICOM)
%                               - dataUnit (i.e. Gy..)
%                               - dataName (i.e. dose, ED, ...)
%                               - compress (true/false)
%                                 (default chosen by writer)
%
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

matRad_cfg = MatRad_Config.instance();

%% Sanity checks
[filedir,filename,ext] = fileparts(filepath);
if ~exist(filedir,'dir')
    matRad_cfg.dispError('Directory %s does not exist!', filedir);
end

%No Special characters in filename (allow only _ and alphanumeric
%characters
robustFileName = filename(isstrprop(filename,'alphanum') | filename == '_');
if ~strcmp(robustFileName,filename)
    matRad_cfg.dispWarning('Changing filename from ''%s'' to ''%s'' to get rid of special characters!',filename,robustFileName);
    filepath = fullfile(filedir,[robustFileName ext]);
end

%% Prepare Metadata
%if the field is not set, we assume standard matRad x-y swap
if ~isfield(metadata,'axisPermutation')
    %cube = permute(cube,[2 1 3]); %This should be done in the writer based
    %on the axis permutation field
    metadata.axisPermutation = [2 1 3]; %Default Matlab axis permutation
end
%use the matrad coordinate system
if ~isfield(metadata,'coordinateSystem')
    metadata.coordinateSystem = 'LPS';  %Matlab coordinate system
end

% Ensure resolution is given
if ~isfield(metadata,'resolution')
    matRad_cfg.dispError('metadata.resolution is required!');
end

if isstruct(metadata.resolution) && all(isfield(metadata.resolution,{'x','y','z'}))
    metadata.resolution = [metadata.resolution.x metadata.resolution.y metadata.resolution.z];
end

%If there is no image origin set, center the image
imageExtent = metadata.resolution .* size(cube);
if ~isfield(metadata,'imageOrigin')
    metadata.imageOrigin = zeros(1,numel(imageExtent)) - (imageExtent/2);
end
%we can also store the center
if ~isfield(metadata,'imageCenter')
    metadata.imageCenter = metadata.imageOrigin + (imageExtent/2);
end


metadata.datatype = datatype;
    
%% Choose writer
%So far we only have an nrrd writer
[~,writers] = matRad_supportedBinaryFormats();

writerIx = find(~cellfun(@isempty,strfind({writers.fileFilter},ext)));

if ~isempty(writerIx) && isscalar(writerIx)
    writerHandle = writers(writerIx).handle; 
    writerHandle(filepath,cube,metadata);
else
    matRad_cfg.dispError('No unique writer found for extension "%s"',ext);
end

matRad_cfg.dispInfo('File written to %s...\n',filepath);
saved_metadata = metadata;


end

