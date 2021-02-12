table 50002 "Location Address"
{
    DataCaptionFields = "Code", Name;
    DrillDownPageID = "Location Address List";
    LookupPageID = "Location Address List";

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Name; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(5700; "Name 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name 2';
        }
        field(5701; Address; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Address';
        }
        field(5702; "Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Address 2';
        }
        field(5703; City; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                //Postcode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(5704; "Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(5705; "Phone No. 2"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No. 2';
            ExtendedDatatype = PhoneNo;
        }
        field(5706; "Telex No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Telex No.';
        }
        field(5707; "Fax No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Fax No.';
        }
        field(5713; Contact; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact';
        }
        field(5714; "Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ZIP Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                //Postcode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(5715; County; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'State';
        }
        field(5720; "Country/Region Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "Location Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name, Address, City, "Post Code")
        {
        }
    }

    trigger OnDelete()
    var
        TransferRoute: Record "Transfer Route";
        WhseEmployee: Record "Warehouse Employee";
        WorkCenter: Record "Work Center";
    begin
    end;

    var
        Bin: Record Bin;
        Postcode: Record "Post Code";
        WhseSetup: Record "Warehouse Setup";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        Text000: Label 'You cannot delete the %1 %2, because they contain items.';
        Text001: Label 'You cannot delete the %1 %2, because one or more Warehouse Activity Lines exist for this %1.';
        Text002: Label '%1 must be Yes, because the bins contain items.';
        Text003: Label 'Canceled.';
        Text004: Label 'The total quantity of items in the warehouse is 0, but the Adjustment Bin contains a negative quantity and other bins contain a positive quantity.\';
        Text005: Label 'Do you still want to delete this %1?';
        Text006: Label 'You cannot change the %1 until the inventory stored in %2 %3 is 0.';
        Text007: Label 'You have to delete all Adjustment Warehouse Journal Lines first before you can change the %1.';
        Text008: Label '%1 must be %2, because one or more %3 exist.';
        Text009: Label 'You cannot change %1 because there are one or more open ledger entries on this location.';
        Text010: Label 'Checking item ledger entries for open entries...';
        Text011: Label 'You cannot change the %1 to %2 until the inventory stored in this bin is 0.';
        Text012: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text013: Label 'You cannot delete %1 because there are one or more ledger entries on this location.';
        Text014: Label 'You cannot change %1 because one or more %2 exist.';
        ShippingAgent: Record "Shipping Agent";
        EShipAgentService: Record "E-Ship Agent Service";
        ShippingAccount: Record "Shipping Account";
        EDIIntegration: Codeunit "EDI Integration";
}

