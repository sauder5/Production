tableextension 60081 GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(51000; "Check-off"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Seasonal Disc. Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Check-off Payment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51004; "Name Sort"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51020; "Seasonal Cash Disc Code"; Code[20])
        {
            TableRelation = "Seasonal Cash Discount";
            DataClassification = CustomerContent;
        }
        field(51100; "Fall Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Fall Amount" > "Credit Amount" THEN ERROR('Fall Amount cannot be more than Credit Amount');
                "Spring Amount" := "Credit Amount" - "Fall Amount";
                UpdateSeasonalCashDiscount();
            end;
        }
        field(51101; "Spring Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Spring Amount" > "Credit Amount" THEN ERROR('Spring Amount cannot be more than Credit Amount');
                "Fall Amount" := "Credit Amount" - "Spring Amount";
                UpdateSeasonalCashDiscount();
            end;
        }
        field(51102; "Seasonal Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51103; "Fall Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51104; "Spring Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51105; "Potential Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51106; "Potential Fall Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51107; "Potential Spring Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                UpdateSeasonalCashDiscount();
            end;
        }
        modify("Credit Amount")
        {
            trigger OnBeforeValidate()
            begin
                cuCustPmtLink.CheckSeasDiscForGJLn(Rec);
            end;
        }
    }

    var
        cuCustPmtLink: Codeunit "Cust. Payment Link Mgt.";

    local procedure UpdateSeasonalCashDiscount()
    begin
        cuCustPmtLink.UpdateDepLnSeasCashDisc(Rec);
    end;
}