codeunit 50012 Setup
{
    // Serenic Human Capital Management - (c)Copyright Serenic Software, Inc. 1999-2016.
    // By opening this object you acknowledge that this object includes confidential information
    // and intellectual property of Serenic Software, Inc., and that this work is protected by US
    // and international copyright laws and agreements.
    // ------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
        if Confirm('Run HCM 8.00.00.04 Setup') then begin
            if Company.FindSet(false, false) then
                repeat
                    if CAPayrollCompany then begin
                        InitROESeparationCodes;
                        UpdateGroundsForTermination;
                        UpdateROEPayControls;
                        UpdateROEDetailLines;
                    end;
                until Company.Next = 0;

            Message('HCM 8.00.00.04 Setup Complete');
        end;
    end;

    var
        Company: Record Company;
        ROESepCode: array[30] of Code[3];
        ROESepDesc: array[30] of Text[50];
        TextQuote: Label '''';

    [Scope('Internal')]
    procedure UpdateGroundsForTermination()
    var
        SourceRec: Record "Grounds for Termination";
        i: Integer;
    begin
        SourceRec.ChangeCompany(Company.Name);
        if SourceRec.FindSet(false, false) then begin
            UpdateExistingROECodes('A', 1);
            UpdateExistingROECodes('B', 3);
            UpdateExistingROECodes('C', 7);
            UpdateExistingROECodes('D', 4);
            UpdateExistingROECodes('E', 5);
            UpdateExistingROECodes('F', 14);
            UpdateExistingROECodes('G', 15);
            UpdateExistingROECodes('H', 17);
            UpdateExistingROECodes('J', 18);
            UpdateExistingROECodes('K', 19);
            UpdateExistingROECodes('M', 26);
            UpdateExistingROECodes('N', 28);
            UpdateExistingROECodes('P', 29);
            UpdateExistingROECodes('Z', 30);

            for i := 1 to 30 do begin
                if not SourceRec.Get(ROESepCode[i]) then begin
                    SourceRec.Code := ROESepCode[i];
                    SourceRec.Description := ROESepDesc[i];
                    SourceRec.Insert;
                end;
            end;
        end;
    end;

    [Scope('Internal')]
    procedure UpdateExistingROECodes(pOldCode: Code[1]; pNewCodeRef: Integer)
    var
        SourceRec: Record "Grounds for Termination";
    begin
        SourceRec.ChangeCompany(Company.Name);
        if SourceRec.Get(pOldCode) then begin
            SourceRec.Rename(ROESepCode[pNewCodeRef]);
            SourceRec.Description := ROESepDesc[pNewCodeRef];
            SourceRec.Modify;
        end;
    end;

    [Scope('Internal')]
    procedure NewOtherMonieValue(pOldValue: Integer): Integer
    var
        NewValue: Integer;
    begin
        case pOldValue of
            0:
                NewValue := 0;
            1:
                NewValue := 97;
            2:
                NewValue := 7;
            3:
                NewValue := 8;
            4:
                NewValue := 9;
            5:
                NewValue := 10;
            6:
                NewValue := 11;
            7:
                NewValue := 98;
            8:
                NewValue := 13;
            9:
                NewValue := 15;
            10:
                NewValue := 16;
            11:
                NewValue := 19;
            12:
                NewValue := 99;
            13:
                NewValue := 22;
        end;
        exit(NewValue);
    end;

    [Scope('Internal')]
    procedure UpdateROEPayControls()
    var
        SourceRec: Record "Payroll Control";
    begin
        SourceRec.ChangeCompany(Company.Name);

        if SourceRec.FindSet(false, true) then
            repeat
                if SourceRec."ROE Box 17a Reporting" then begin
                    SourceRec."Vacation Pay Type" := SourceRec."Vacation Pay Type"::"2-Paid because no longer working";
                    SourceRec.Modify;
                end;
                if SourceRec."ROE Box 17c Reporting" then begin
                    SourceRec."Other Money Type" := NewOtherMonieValue(SourceRec."Other Money Type");
                    SourceRec.Modify;
                end;

            until SourceRec.Next = 0;
    end;

    [Scope('Internal')]
    procedure UpdateROEDetailLines()
    var
        SourceRec: Record "ROE Detail Line";
    begin
        SourceRec.ChangeCompany(Company.Name);

        if SourceRec.FindSet(false, true) then
            repeat
                if SourceRec.Type = SourceRec.Type::"Other Monies" then begin
                    SourceRec."Other Money Type" := NewOtherMonieValue(SourceRec."Other Money Type");
                    SourceRec.Modify;
                end;
            until SourceRec.Next = 0;
    end;

    [Scope('Internal')]
    procedure InitROESeparationCodes()
    begin
        ROESepCode[1] := 'A00';
        ROESepCode[2] := 'A01';
        ROESepCode[3] := 'B00';
        ROESepCode[4] := 'D00';
        ROESepCode[5] := 'E00';
        ROESepCode[6] := 'E02';
        ROESepCode[7] := 'E03';
        ROESepCode[8] := 'E04';
        ROESepCode[9] := 'E05';
        ROESepCode[10] := 'E06';
        ROESepCode[11] := 'E09';
        ROESepCode[12] := 'E10';
        ROESepCode[13] := 'E11';
        ROESepCode[14] := 'F00';
        ROESepCode[15] := 'G00';
        ROESepCode[16] := 'G07';
        ROESepCode[17] := 'H00';
        ROESepCode[18] := 'J00';
        ROESepCode[19] := 'K00';
        ROESepCode[20] := 'K12';
        ROESepCode[21] := 'K13';
        ROESepCode[22] := 'K14';
        ROESepCode[23] := 'K15';
        ROESepCode[24] := 'K16';
        ROESepCode[25] := 'K17';
        ROESepCode[26] := 'M00';
        ROESepCode[27] := 'M08';
        ROESepCode[28] := 'N00';
        ROESepCode[29] := 'P00';
        ROESepCode[30] := 'Z00';

        ROESepDesc[1] := 'Shortage of work / End of contract or season';
        ROESepDesc[2] := 'Employer bankruptcy or receivership';
        ROESepDesc[3] := 'Strike or lockout';
        ROESepDesc[4] := 'Illness or injury';
        ROESepDesc[5] := 'Quit';
        ROESepDesc[6] := 'Quit / Follow spouse';
        ROESepDesc[7] := 'Quit / Return to school';
        ROESepDesc[8] := 'Quit / Health reasons';
        ROESepDesc[9] := 'Quit / Voluntary retirement';
        ROESepDesc[10] := 'Quit / Take another job';
        ROESepDesc[11] := 'Quit / Employer relocation';
        ROESepDesc[12] := 'Quit / Care for a dependant';
        ROESepDesc[13] := 'Quit / To become self-employed';
        ROESepDesc[14] := 'Maternity';
        ROESepDesc[15] := 'Mandatory retirement';
        ROESepDesc[16] := 'Retirement / Approved workforce reduction';
        ROESepDesc[17] := 'Work-Sharing';
        ROESepDesc[18] := 'Apprentice training';
        ROESepDesc[19] := 'Other';
        ROESepDesc[20] := 'Other / Change of payroll frequency';
        ROESepDesc[21] := 'Other / Change of ownership';
        ROESepDesc[22] := 'Other / Requested by Employment Insurance';
        ROESepDesc[23] := 'Other / Canadian Forces - Queen' + TextQuote + 's Regs/Orders';
        ROESepDesc[24] := 'Other / At the employee' + TextQuote + 's request';
        ROESepDesc[25] := 'Other / Change of Service Provider';
        ROESepDesc[26] := 'Dismissal';
        ROESepDesc[27] := 'Dismissal / Terminated within probationary period';
        ROESepDesc[28] := 'Leave of absence';
        ROESepDesc[29] := 'Parental';
        ROESepDesc[30] := 'Compassionate Care';
    end;

    [Scope('Internal')]
    procedure CAPayrollCompany(): Boolean
    var
        PayrollSetup: Record "NVP Payroll Setup";
        CACompany: Boolean;
    begin
        PayrollSetup.ChangeCompany(Company.Name);
        if PayrollSetup.Get then begin
            if PayrollSetup."Payroll Country" = PayrollSetup."Payroll Country"::Canada then
                CACompany := true;
        end;

        exit(CACompany);
    end;
}

