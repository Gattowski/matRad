classdef matRad_importWidget < matRad_Widget
    % matRad_importWidget class to generate GUI widget to import various
    % formats : dicom, nrrd, etc.
    % 
    %
    % References
    %   -
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Copyright 2020 the matRad development team. 
    % 
    % This file is part of the matRad project. It is subject to the license 
    % terms in the LICENSE file found in the top-level directory of this 
    % distribution and at https://github.com/e0404/matRad/LICENSE.md. No part 
    % of the matRad project, including this file, may be copied, modified, 
    % propagated, or distributed except according to the terms contained in the 
    % LICENSE file.
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

   
    methods
        function this = matRad_importWidget(handleParent)
            matRad_cfg = MatRad_Config.instance();
            if nargin < 1
                handleParent = figure(...
                    'MenuBar','none',...
                    'Units','characters',...
                    'Position',[25 10 89.2 18.3846153846154],...
                    'Color',matRad_cfg.gui.backgroundColor,...
                    'Name','Import Patient',...
                    'HandleVisibility','callback',...
                    'Tag','figure_importDialog',...
                    'IntegerHandle','off',...
                    'WindowStyle','normal');
            end
            this = this@matRad_Widget(handleParent);
        end
        
        %OPENING/INITIALIZE FUNKTION
        function this = initialize(this)
            %             handles = this.handles;
            %              this.handles = handles;
            %
            %handles = guidata(this.widgetHandle);
            %handles.output = this.widgetHandle;
            %guidata(this.widgetHandle, handles);
            
        end
    end
    
    methods (Access = protected)
        function this = createLayout(this)
            matRad_cfg = MatRad_Config.instance();
            
            h1 = this.widgetHandle;
            
            
            h2 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Patient CT file [HU]:',...
                'TooltipString','Choose a patient CT',...
                'HorizontalAlignment','left',...
                'Style','text',...
                'BackgroundColor',matRad_cfg.gui.backgroundColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.03 0.85 0.4 0.1],...
                'Tag','text2');
            
            
            h3 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'Style','edit',...
                'Position',[0.03 0.78 0.73 0.1],...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Callback',@(hObject,event) edit_ctPath_Callback(this,hObject, event),...
                'Tag','edit_ctPath',...
                'TooltipString','Choose the input directory');
            
            
            h4 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Browse...',...
                'TooltipString','Choose the input directory',...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.78 0.78 0.2 0.1],...
                'Callback',@this.pushbutton_ctPath_Callback,...
                'Tag','pushbutton_ctPath');
            
            
            h5 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Binary Masks/Segmentations',...
                'TooltipString','Select binary masks/segmentations',...
                'HorizontalAlignment','left',...
                'Style','text',...
                'BackgroundColor',matRad_cfg.gui.backgroundColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.03 0.435 0.5 0.1],...
                'Tag','text_masks');
            
            
            h6 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'Max',2,...
                'Style','listbox',...
                'TooltipString','Select binary masks/segmentations',...
                'Position',[0.03 0.15 0.73 0.32],... [1.8 3.38461538461539 66.2 4.69230769230769],...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Callback',@this.listbox_maskPaths_Callback,...
                'Tag','listbox_maskPaths',...
                'KeyPressFcn',@(hObject,eventdata)matRad_importGUI('listbox_maskPaths_KeyPressFcn',hObject,eventdata,guidata(hObject)));
            
            
            h7 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Add File(s)...',...
                'TooltipString','Choose the binary mask files',...
                'Style','pushbutton',...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.78 0.37 0.2 0.1],...
                'Callback',@this.pushbutton_addMaskPaths_Callback,...
                'Tag','pushbutton_addMaskPaths');
            
            
            h8 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Import',...
                'TooltipString','Import the selected CT and binary masks',...
                'Position',[0.78 0.02 0.2 0.1],...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Callback',@this.pushbutton_import_Callback,...
                'Tag','pushbutton_import');            
            
            h10 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Add Folder...',...
                'TooltipString','Choose the folder containing binary mask files',...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.78 0.22 0.2 0.1],...
                'Callback',@this.pushbutton_addMaskFolders_Callback,...
                'Tag','pushbutton_addMaskFolders');
            
            
            h11 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','Convert from HU?',...
                'Style','checkbox',...
                'BackgroundColor',matRad_cfg.gui.backgroundColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.03 0.68 0.4 0.1],...
                'Callback',@this.checkbox_huConvert_Callback,...
                'TooltipString','If this is checked, the import assumes that this is a CT given in HU and will convert with the given (or the default) HLUT',...
                'Tag','checkbox_huConvert');
            
            
            h12 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','matRad_default.hlut',...
                'HorizontalAlignment','left',...
                'Style','edit',...
                'Enable','off',...
                'Position',[0.03 0.57 0.73 0.1],...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Callback',@this.edit_hlut_Callback,...
                'Tag','edit_hlut');
            
            
            h13 = uicontrol(...
                'Parent',h1,...
                'Units','normalized',...
                'String','HLUT file...',...
                'TooltipString','Choose the HLUT file',...
                'BackgroundColor',matRad_cfg.gui.elementColor,...
                'ForegroundColor',matRad_cfg.gui.textColor,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight,...
                'FontName',matRad_cfg.gui.fontName,...
                'Position',[0.78 0.57 0.2 0.1],... [69.8 10.6923076923077 18.2 1.76923076923077],...
                'Callback',@this.pushbutton_hlutFile_Callback,...
                'Tag','pushbutton_hlutFile');
            
            this.createHandles();
        end
        
    end
    
    methods
        
        %         %OUTPUT FUNKTION
        %         function varargout = OutputFcn(hObject, eventdata, handles)
        %             varargout{1} = handles.output;
        %         end
        
        %CALLBACK FOR  H3 EDIT CREATE PATH
        function this = edit_ctPath_Callback(this, hObject, event)
        end
        
        %CALLBACK FOR H4 PUSHBUTTON CREATE PATH
        function this = pushbutton_ctPath_Callback(this, hObject, event)
            readers = matRad_supportedBinaryFormats();
            importFilter = horzcat({readers.fileFilter}',{readers.name}');

            handles = this.handles;
            [importCTFile,importCTPath,~] = uigetfile(importFilter, 'Choose the CT file...');
            
            if importCTFile ~= 0
                set(handles.edit_ctPath,'String',fullfile(importCTPath,importCTFile)); % NON EXISTING FIELD 'edit_ctPath'
                % Update handles structure
                this.handles = handles;
            end
        end
        
        %CALLBACK FOR H6 LISTBOX MASK PATHS LEER
        function this = listbox_maskPaths_Callback(this, hObject, event)
            
        end
        
        %CALLBACK FOR PUSHBUTTON ADD MASKPATHS
        function this = pushbutton_addMaskPaths_Callback(this, hObject, event)
            handles = this.handles;
            
            readers = matRad_supportedBinaryFormats();
            importFilter = horzcat({readers.fileFilter}',{readers.name}');

            [importMaskFile,importMaskPath,~] = uigetfile(importFilter, 'Choose the binary mask files...','MultiSelect','on');
            if ~isempty(importMaskFile)
                if ~iscell(importMaskFile)
                    tmpName = importMaskFile;
                    importMaskFile = cell(1);
                    importMaskFile{1} = tmpName;
                end
                importMaskFile = cellfun(@(filename) fullfile(importMaskPath,filename),importMaskFile,'UniformOutput',false);
                entries = get(handles.listbox_maskPaths,'String');
                newEntries = [entries importMaskFile];
                set(handles.listbox_maskPaths,'String',newEntries);
                % Update handles structure
                this.handles = handles;
            end
        end
        
        function cst = showCheckDialog(this,cst)
            handles = this.handles;
            handle = dialog('Position', [100 100 400 250],'WindowStyle','modal','Name','Confirm Segmentations');
            
            %Create Table
            hTable = uitable('Parent',handle,'Units','normal','Position',[0.1 0.2 0.8 0.8]);
            set(hTable,'Data',cst(:,2:3));
            set(hTable,'ColumnName',{'Name','Type'});
            set(hTable,'ColumnWidth',{150,'auto'});
            set(hTable,'RowName',char([]));
            set(hTable,'ColumnEditable',[true true]);
            set(hTable,'ColumnFormat',{'char',{'TARGET', 'OAR', 'IGNORED'}});
            
            %Create Button
            hButton = uicontrol(handle,'Style','pushbutton','String','Confirm','Units','normal','Position',[0.7 0.05 0.2 0.1],'Callback','uiresume(gcbf)');%{@pushbutton_confirm_vois_callback});
            try
                uiwait(handle);
                tmp = get(hTable,'Data');
                cst(:,2:3) = tmp(:,:);
            catch
                this.showWarning('Closed checkdialog without confirmation! Using default cst information!');
            end
            delete(handle);
            this.handles = handles();
            
        end
        
        %CALLBACK FOR H8 PUSHBUTTON IMPORT
        function this = pushbutton_import_Callback(this, hObject, event)
            handles = this.handles;
            
            ctFile = get(handles.edit_ctPath,'String');
            maskFiles = get(handles.listbox_maskPaths,'String');
            
            if isempty(ctFile) || isempty(maskFiles)
                this.showError('Please sepecify a CT and at least one mask!');
            end
            
            convertHU = get(handles.checkbox_huConvert,'Value');
            
            if convertHU
                [ct,cst] = matRad_importPatient(ctFile,maskFiles,get(handles.edit_hlut,'String'));
            else
                [ct,cst] = matRad_importPatient(ctFile,maskFiles);
            end
            
            cst = this.showCheckDialog(cst);
            
            % delete existing workspace - parse variables from base workspace
            %set(handles.popupDisplayOption,'String','no option available');
            AllVarNames = evalin('base','who');
            RefVarNames = {'ct','cst','pln','stf','dij','resultGUI'};
            ChangedVarNames = {};
            for i = 1:length(RefVarNames)
                if sum(ismember(AllVarNames,RefVarNames{i}))>0
                    evalin('base',['clear ', RefVarNames{i}]);
                end
            end
            
            assignin('base', 'ct', ct);
            assignin('base', 'cst', cst);
            
            %delete(handles.figure_importDialog);
            
            this.handles = handles;
            this.changedWorkspace('ct','cst');
            %delete(this.widgetHandle);
            
        end
        
        %         %CALLBACK FOR H9 PUSHBUTTON CANCEL
        %         function this = pushbutton_cancel_Callback(this, hObject, event)
        %            handles = this.handles;
        %             delete(handles.figure_importDialog);
        %             this.handles = handles;
        %         end
        
        %CALLBACK FOR H10 PUSHBUTTON ADD MASK FOLDERS
        function this = pushbutton_addMaskFolders_Callback(this, hObject, event)
            handles = this.handles;
            importMaskPath = uigetdir('./', 'Choose the folder containing binary mask files...');
            importMaskPath = [importMaskPath filesep];
            if ~isempty(importMaskPath)
                entries = get(handles.listbox_maskPaths,'String');
                newEntries = [entries cellstr(importMaskPath)];
                set(handles.listbox_maskPaths,'String',newEntries);
                % Update handles structure
                this.handles = handles;
            end
        end
        
        %CALLBACK FOR H11 CHECKBOX HU CONVERT
        function this = checkbox_huConvert_Callback(this, hObject, event)
            handles = this.handles;
            checked = get(hObject,'Value');
            if checked
                fieldState = 'on';
            else
                fieldState = 'off';
            end
            
            set(handles.edit_hlut,'Enable',fieldState);
            set(handles.pushbutton_hlutFile,'Enable',fieldState);
            this.handles = handles;
        end
        
        %CALLBACK FOR H12 EDIT HLUT
        function this = edit_hlut_Callback(this, hObject, event)
            %bleibt leer
        end
        
        %CALLBACK FOR H13 PUSHBUTTON HLUT FILE
        function this = pushbutton_hlutFile_Callback(this, hObject, event)
            [importHLUTFile,importHLUTPath,~] = uigetfile({'*.hlut', 'matRad HLUT-Files'}, 'Choose the HLUT file...');
            if importHLUTFile ~= 0
                set(handles.edit_hlut,'String',fullfile(importHLUTPath,importHLUTFile));
                % Update handles structure
                this.handles = handles;
            end
        end
        
        
    end
end

