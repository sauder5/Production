tableextension 60038 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50000; "Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Future PO"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Receiving Address Code"; Code[20])
        {
            TableRelation = "Location Address".Code where("Location Code" = field("Location Code"));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                RuppUpdateShipToAddress();
            end;
        }
        modify("Pay-to Vendor No.")
        {
            trigger OnAfterValidate()
            var
                recUserSetup: Record "User Setup";
            begin
                //SOC-SC 09-12-14
                IF "Purchaser Code" = '' THEN BEGIN
                    IF recUserSetup.GET(USERID) THEN BEGIN
                        IF recUserSetup."Default Salesperson Code" <> '' THEN BEGIN
                            "Purchaser Code" := recUserSetup."Default Salesperson Code";
                        END;
                    END;
                END;
                //SOC-SC 09-12-14

            end;
        }
    }

    trigger OnAfterInsert()
    var
        recUserSetup: Record "User Setup";
    begin
        if recUserSetup.Get(UserId) then
            if recUserSetup."Default Ship-To for Purch. " > '' then
                if ("Receiving Address Code" = '') then begin
                    validate("Location Code", recUserSetup."Default Location Code");
                    Validate("Receiving Address Code", recUserSetup."Default Ship-To for Purch. ");
                End;
    end;


    procedure RuppUpdateShipToAddress()
    var
        LocationAddress: Record "Location Address";
        CompanyInfo: Record "Company Information";
    begin
        if "Location Code" > '' Then
            if LocationAddress.get("Location Code", "Receiving Address Code") then
                with LocationAddress do begin
                    SetShipToAddress(
                        Name, "Name 2", Address, "Address 2",
                        City, "Post Code", County, "Country/Region Code");
                    "Ship-to Contact" := Contact;
                end
            else begin
                CompanyInfo.GET;
                "Ship-to Code" := '';
                SetShipToAddress(
                    CompanyInfo."Ship-to Name", CompanyInfo."Ship-to Name 2", CompanyInfo."Ship-to Address", CompanyInfo."Ship-to Address 2",
                    CompanyInfo."Ship-to City", CompanyInfo."Ship-to Post Code", CompanyInfo."Ship-to County",
                    CompanyInfo."Ship-to Country/Region Code");
                "Ship-to Contact" := CompanyInfo."Ship-to Contact";
            end;
    end;
}