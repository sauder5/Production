report 50080 wWashTableObjectFile
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/wWashTableObjectFile.rdlc';
    Caption = 'Wash table object file';

    dataset
    {
        dataitem(Item; Item)
        {
            column(SourceFile; wgSrcFileName)
            {
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(wgSrcFileName; wgSrcFileName)
                    {
                        ShowCaption = false;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message('Washed table object file created.');
    end;

    trigger OnPreReport()
    begin
        if UpperCase(CopyStr(wgSrcFileName, StrLen(wgSrcFileName) - 3)) <> '.TXT' then
            Error('File name extension must be .txt');
        wgTrgFileName := CopyStr(wgSrcFileName, 1, StrLen(wgSrcFileName) - 4) + '_WASHED' + CopyStr(wgSrcFileName, StrLen(wgSrcFileName) - 3);
        wgSrcFile.TextMode := true;
        wgSrcFile.WriteMode := false;
        wgSrcFile.Open(wgSrcFileName);
        wgTrgFile.TextMode := true;
        wgTrgFile.Create(wgTrgFileName);


        wgDialog.Open('Creating washed table object file\@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\', wgProgressInt);
        wgProgressTime := Time;

        while wgSrcFile.Pos < wgSrcFile.Len do begin

            if wgProgressTime < Time - 1000 then begin // every second
                wgProgressTime := Time;
                wgProgressInt := Round(wgSrcFile.Pos / wgSrcFile.Len * 10000, 1);
                wgDialog.Update;
            end;

            wgWrite := false;
            wgSrcFile.Read(S);

            wlFncSetWrite;
            if wgWrite then
                wgTrgFile.Write(S);
        end;

        wgSrcFile.Close;
        wgTrgFile.Close;
        wgDialog.Close;
    end;

    var
        wgSrcFileName: Text[60];
        wgTrgFileName: Text[1024];
        wgSrcFile: File;
        wgTrgFile: File;
        S: Text[1024];
        wgCodeBeginPos: Integer;
        wgInCodeSection: Boolean;
        wgInRelation: Boolean;
        wgWrite: Boolean;
        wgDialog: Dialog;
        wgProgressInt: Integer;
        wgProgressTime: Time;

    local procedure wlFncSetWrite()
    var
        wlDelProperty: array[4] of Text[30];
        i: Integer;
    begin
        if wgInCodeSection then begin
            if StrPos(S, '  {') = 1 then begin
                wgWrite := true;
                exit;
            end;
            if StrPos(S, '  }') = 1 then begin
                wgWrite := true;
                wgInCodeSection := false;
                exit;
            end;
            wgWrite := false;
            exit;
        end;

        if StrPos(S, '  CODE') = 1 then begin
            wgWrite := true;
            wgInCodeSection := true;
            exit;
        end;

        if not wgInRelation then
            if StrPos(S, 'CalcFormula=') <> 0 then
                wgInRelation := true;
        if not wgInRelation then
            if StrPos(S, 'TableRelation=') <> 0 then
                if CopyStr(S, StrPos(S, 'TableRelation=') - 1, 1) in [' ', ';'] then //Avoid false positives
                    wgInRelation := true;

        //Determine wether to close Calcformula or TableRelation with ';'
        if wgInRelation then begin
            wgWrite := false;
            if StrLen(S) > 0 then begin
                if CopyStr(S, StrLen(S)) = ';' then begin
                    wgInRelation := false;
                    if StrPos(S, '{') <> 0 then begin
                        S := CopyStr(S, 1, StrPos(S, '=')) + ';';
                        wgWrite := true;
                    end;
                    exit;
                end;
            end;
        end;

        //Determine wether to close Calcformula or TableRelation with '}'
        if wgInRelation then begin
            wgWrite := false;
            if StrLen(S) > 0 then begin
                if CopyStr(S, StrLen(S)) = '}' then
                    wgInRelation := false;
                if StrPos(S, '{') <> 0 then begin
                    if StrPos(S, '}') <> 0 then
                        S := CopyStr(S, 1, StrPos(S, '=')) + '}'
                    else
                        S := CopyStr(S, 1, StrPos(S, '=')) + ';';
                    wgWrite := true;
                end;
                if not wgWrite and not wgInRelation then begin
                    S := PadStr('', StrLen(S) - 1) + '}';
                    wgWrite := true;
                end;
            end;
            exit;
        end;

        wgWrite := wgCodeBeginPos = 0;
        if wgCodeBeginPos = 0 then begin
            if StrPos(S, '=BEGIN') <> 0 then begin
                wgCodeBeginPos := StrPos(S, '=BEGIN') + 1;
                if StrLen(S) > wgCodeBeginPos + StrLen('=BEGIN') then
                    wgCodeBeginPos := 0; //text found after =BEGIN
            end;
            if wgCodeBeginPos = 0 then
                if StrPos(S, '=VAR') <> 0 then begin
                    wgCodeBeginPos := StrPos(S, '=VAR') + 1;
                    if StrLen(S) > wgCodeBeginPos + StrLen('=VAR') then
                        wgCodeBeginPos := 0; //text found after =VAR
                    if wgCodeBeginPos > 0 then
                        S := CopyStr(S, 1, wgCodeBeginPos - 2) + '=BEGIN';
                end;
        end
        else begin
            if CopyStr(S, wgCodeBeginPos, 4) = 'END;' then begin
                wgCodeBeginPos := 0;
                wgWrite := true;
                exit;
            end;
        end;

        wlDelProperty[1] := 'LookupFormID=';
        wlDelProperty[2] := 'DrillDownFormID=';
        wlDelProperty[3] := 'AutoFormatExpr=';
        wlDelProperty[4] := 'CaptionClass=';

        for i := 1 to 4 do begin
            if StrPos(S, wlDelProperty[i]) <> 0 then begin
                if StrPos(S, ' }') = 0 then
                    wgWrite := false
                else
                    S := CopyStr(S, 1, StrPos(S, wlDelProperty[i]) - 1) + ' }';
                exit;
            end;
        end;
    end;
}

