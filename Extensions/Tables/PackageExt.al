tableextension 80701 PackageExt extends Package
{
    fields
    {
        field(51000; "Warehouse Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        modify("Ship-to City")
        {
            trigger OnAfterValidate()
            var
                PostCode: Record "Post Code";
            begin
                //RSI-KS
                PostCode.ValidateCity(
                "Ship-to City", "Ship-to ZIP Code", "Ship-to State", "Ship-to Country Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //RSI-KS
            end;
        }
        modify("Ship-to ZIP Code")
        {
            trigger OnAfterValidate()
            var
                PostCode: Record "Post Code";
            begin
                //RSI-KS
                PostCode.ValidateCity(
                "Ship-to City", "Ship-to ZIP Code", "Ship-to State", "Ship-to Country Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //RSI-KS
            end;
        }
        modify("Blind Ship-from City")
        {
            trigger OnAfterValidate()
            var
                PostCode: Record "Post Code";
            Begin
                //RSI-KS
                PostCode.ValidateCity(
                "Blind Ship-from City", "Blind Ship-from ZIP Code", "Blind Ship-from State", "Blind Ship-from Country Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //RSI-KS
            end;
        }
        modify("Blind Ship-from ZIP Code")
        {
            trigger OnAfterValidate()
            var
                PostCode: Record "Post Code";
            Begin
                //RSI-KS
                PostCode.ValidateCity(
                "Blind Ship-from City", "Blind Ship-from ZIP Code", "Blind Ship-from State", "Blind Ship-from Country Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //RSI-KS
            end;
        }
    }
    Procedure UpdateOrderTrackingNo(var Package: Record Package)
    var
        recSH: record "Sales Header";
    begin
        //SOC-SC 09-04-14; called from codeunit 'Shipping'
        IF Package."Source Type" = 36 THEN BEGIN
            recSH.RESET();
            recSH.SETRANGE("Document Type", "Source Subtype");
            recSH.SETFILTER("No.", "Source ID");
            IF recSH.FINDSET() THEN BEGIN
                REPEAT
                    IF recSH."Package Tracking No." <> Package."External Tracking No." THEN BEGIN
                        recSH."Package Tracking No." := Package."External Tracking No.";
                        recSH.MODIFY();
                    END;
                UNTIL recSH.NEXT = 0;
            END;
        END;
    end;
}