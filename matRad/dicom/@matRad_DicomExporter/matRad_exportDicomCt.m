function obj = matRad_exportDicomCt(obj)
% matRad function to export ct to dicom. 
% Class method of matRad_DicomExporter
% 
% call
%   matRad_DicomExporter.matRad_exportDicomCt()
%
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2019 the matRad development team.
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

matRad_cfg.dispInfo('Exporting DICOM CT for scenario %s into %s...\n',obj.exportScenario,obj.dicomDir);

%default meta
meta.PatientName         = obj.PatientName;
meta.PatientID           = obj.PatientID;
meta.PatientBirthDate    = obj.PatientBirthDate;
meta.PatientSex          = obj.PatientSex;
meta.PatientPosition     = obj.PatientPosition;
meta.StudyID             = obj.StudyID;
meta.StudyDate           = obj.StudyDate;
meta.StudyTime           = obj.StudyTime;
meta.StudyInstanceUID    = obj.StudyInstanceUID;
meta.FrameOfReferenceUID = obj.FrameOfReferenceUID;

ClassUID = obj.ctClassUID; %CT Image
meta.MediaStorageSOPClassUID = ClassUID;
meta.SOPClassUID = ClassUID;
%TransferSyntaxUID = '1.2.840.10008.1.2';
%meta.TransferSyntaxUID = TransferSyntaxUID;

%Identifiers
meta.SOPInstanceUID             = dicomuid;
meta.MediaStorageSOPInstanceUID = meta.SOPInstanceUID;
meta.SeriesInstanceUID          = dicomuid;
meta.SeriesNumber               = 1;
meta.InstanceNumber             = 1;


obj.ctMeta.SeriesInstanceUID = dicomuid;
meta.SeriesInstanceUID       = obj.ctMeta.SeriesInstanceUID;

meta.SeriesNumber      = 1;
meta.AcquisitionNumber = 1;
meta.InstanceNumber    = 1;

meta.Modality               = 'CT';
meta.ReferringPhysicianName = obj.dicomName();
meta.PatientPosition        = obj.PatientPosition;


ct = obj.ct;

nSlices = ct.cubeDim(3);
%Create X Y Z vectors if not present
if ~any(isfield(ct,{'x','y','z'}))
    ct = matRad_getWorldAxes(ct);
end

obj.ct = ct;

%Since we are exporting HU directly --> no rescaling in any case
meta.SliceThickness = ct.resolution.z;
meta.PixelSpacing   = [ct.resolution.y; ct.resolution.x];
meta.ImageOrientationPatient = [1;0;0;0;1;0]; %lps
meta.RescaleType = 'HU';

if isfield(ct,'z')
    z = ct.z;
end

ctCube = ct.cubeHU{obj.exportScenario};
ctMin  = min(ctCube(:));
ctCube = ctCube - ctMin;
ctMax  = max(ctCube(:));
ctCube = ctCube ./ ctMax;
ctCube = uint16(ctCube*double(uint16(Inf)));

meta.RescaleIntercept = ctMin;
meta.RescaleSlope     = ctMax / double(uint16(Inf) + 1);

meta.ImageType = 'DERIVED\PRIMARY\AXIAL';

fileName = 'ct_slice_';

obj.ctSliceMetas   = struct([]);
obj.ctExportStatus = struct([]);


for i = 1:nSlices
    ctSlice = ctCube(:,:,i);
    %ctSlice = permute(ctSlice,[1 2]);
    
    obj.ctSliceMetas = obj.addStruct2StructArray(obj.ctSliceMetas,meta);
    
    obj.ctSliceMetas(i).ImagePositionPatient = [ct.x(1); ct.y(1); ct.z(i)];
    
    obj.ctSliceMetas(i).SlicePositions = z(i);
    
    %Create and store unique ID
    obj.ctSliceMetas(i).SOPClassUID    = ClassUID;
    
    fullFileName = fullfile(obj.dicomDir,[fileName num2str(i) '.dcm']);
    if matRad_cfg.isOctave
        obj.ctSliceMetas(i).SOPInstanceUID = dicomuid;
        obj.ctSliceMetas(i).MediaStorageSOPInstanceUID = obj.ctSliceMetas(i).SOPInstanceUID;
    
        dicomwrite(ctSlice,fullFileName,obj.ctSliceMetas(i));
    else
        status = dicomwrite(ctSlice,fullFileName,obj.ctSliceMetas(i),'ObjectType','CT Image Storage');
        obj.ctExportStatus = obj.addStruct2StructArray(obj.ctExportStatus,status);
		
		matRad_cfg.dispDebug('\tWritten Slice %d to %s\n',i,fullFileName);
		
		%We need to get the info of the file just written because of Matlab's
        %hardcoded way of generating InstanceUIDs during writing
        tmpInfo = dicominfo(fullFileName);
        obj.ctSliceMetas(i).SOPInstanceUID              = tmpInfo.SOPInstanceUID;
        obj.ctSliceMetas(i).MediaStorageSOPInstanceUID  = tmpInfo.MediaStorageSOPInstanceUID;        
        
    end
    
    if matRad_cfg.logLevel > 2
        matRad_progress(i,nSlices);
    end

end

end

