page 50092 "Farm Field Picture"
{
    // version GroProd

    PageType = CardPart;
    SourceTable = "Farm Field";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(Image; Image)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            /*            action(TakePicture)
                        {
                            ApplicationArea = All;
                            CaptionML = ENU = 'Take',
                                        ESM = 'Hacer',
                                        FRC = 'Prélever',
                                        ENC = 'Take';
                            Image = Camera;
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            ToolTipML = ENU = 'Activate the camera on the device.',
                                        ESM = 'Activa la cámara en el dispositivo.',
                                        FRC = 'Activez la caméra sur l''appareil.',
                                        ENC = 'Activate the camera on the device.';
                            Visible = CameraAvailable;

                            trigger OnAction();
                            begin
                                TakeNewPicture;
                            end;
                        } */
            action(ImportPicture)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Import',
                            ESM = 'Importar',
                            FRC = 'Importer',
                            ENC = 'Import';
                Image = Import;
                ToolTipML = ENU = 'Import a picture file.',
                            ESM = 'Importa un archivo de imagen.',
                            FRC = 'Importez un fichier image.',
                            ENC = 'Import a picture file.';

                trigger OnAction();
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    TESTFIELD("Farm Field No.");
                    TESTFIELD("Farm Field Name");

                    if Image.HASVALUE then
                        if not CONFIRM(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    CLEAR(Image);
                    Image.IMPORTFILE(FileName, ClientFileName);
                    if not MODIFY(true) then
                        INSERT(true);

                    if FileManagement.DeleteServerFile(FileName) then;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Export',
                            ESM = 'Exportar',
                            FRC = 'Exporter',
                            ENC = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTipML = ENU = 'Export the picture to a file.',
                            ESM = 'Exporta la imagen a un archivo.',
                            FRC = 'Exportez l''image vers un fichier.',
                            ENC = 'Export the picture to a file.';
                Visible = NOT CameraAvailable;

                trigger OnAction();
                var
                    NameValueBuffer: Record "Name/Value Buffer";
                    TempNameValueBuffer: Record "Name/Value Buffer" temporary;
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    TESTFIELD("Farm Field No.");
                    TESTFIELD("Farm Field Name");

                    NameValueBuffer.DELETEALL;
                    ExportPath := TEMPORARYPATH + "Farm Field No." + FORMAT(Image.MEDIAID);
                    Image.EXPORTFILE(ExportPath);
                    FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer, TEMPORARYPATH);
                    TempNameValueBuffer.SETFILTER(Name, STRSUBSTNO('%1*', ExportPath));
                    TempNameValueBuffer.FINDFIRST;
                    ToFile := STRSUBSTNO('%1 %2.jpg', "Farm Field No.", "Farm Field Name");
                    DOWNLOAD(TempNameValueBuffer.Name, DownloadImageTxt, '', '', ToFile);
                    if FileManagement.DeleteServerFile(TempNameValueBuffer.Name) then;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Delete',
                            ESM = 'Eliminar',
                            FRC = 'Supprimer',
                            ENC = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTipML = ENU = 'Delete the record.',
                            ESM = 'Elimina el registro.',
                            FRC = 'Supprimez l''enregistrement.',
                            ENC = 'Delete the record.';

                trigger OnAction();
                begin
                    TESTFIELD("Farm Field No.");

                    if not CONFIRM(DeleteImageQst) then
                        exit;

                    CLEAR(Image);
                    MODIFY(true);
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        if "Farm Field No." > '' then
            SetEditable(true)
        else
            SetEditable(false);
    end;

    var
        /*        CameraProvider: DotNet CameraProvider; */
        CameraAvailable: Boolean;
        DeleteExportEnabled: Boolean;
        OverrideImageQst: TextConst ENU = 'The existing picture will be replaced. Do you want to continue?', ESM = 'Se sustituirá la imagen existente. ¿Quiere continuar?', FRC = 'L''image existante sera remplacée. Voulez-vous continuer ?', ENC = 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: TextConst ENU = 'Are you sure you want to delete the picture?', ESM = '¿Está seguro de que desea eliminar la imagen?', FRC = 'Voulez-vous vraiment supprimer l''image ?', ENC = 'Are you sure you want to delete the picture?';
        SelectPictureTxt: TextConst ENU = 'Select a picture to upload', ESM = 'Seleccionar una imagen para cargar', FRC = 'Sélectionner une image à charger', ENC = 'Select a picture to upload';
        DownloadImageTxt: TextConst ENU = 'Download image', ESM = 'Descargar imagen', FRC = 'Télécharger image', ENC = 'Download image';
        IsEditable: Boolean;

    [Scope('Personalization')]
    /*    procedure TakeNewPicture();
        var
            CameraOptions: DotNet CameraOptions;
        begin
            FIND;
            TESTFIELD("Farm Field No.");
            TESTFIELD("Farm Field Name");

            if not CameraAvailable then
                exit;

            CameraOptions := CameraOptions.CameraOptions;
            CameraOptions.Quality := 50;
            CameraProvider.RequestPictureAsync(CameraOptions);
        end; */

    local procedure SetEditableOnPictureActions();
    begin
        DeleteExportEnabled := Image.HASVALUE;
    end;

    [Scope('Personalization')]
    /*    procedure IsCameraAvailable(): Boolean;
        begin
            exit(CameraProvider.IsAvailable);
        end;
    */
    local procedure SetEditable(SetVar: Boolean);
    begin
        IsEditable := SetVar;
    end;

    //event CameraProvider(PictureName : Text;PictureFilePath : Text);
    //begin
    /*
    */
    //end;
}

