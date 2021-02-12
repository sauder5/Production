table 50027 "Geographical Restriction"
{
    DrillDownPageID = "Geographical Restrictions";
    LookupPageID = "Geographical Restrictions";

    fields
    {
        field(1; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = Product;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = IF ("Product Code" = FILTER('')) Item."No."
            ELSE
            IF ("Product Code" = FILTER(<> '')) Item."No." WHERE("Product Code" = FIELD("Product Code"));
        }
        field(3; "Country Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Country/Region";
        }
        field(4; State; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(5; City; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Post Code".City WHERE("Country/Region Code" = FIELD("Country Code"),
                                                    County = FIELD(State));
            ValidateTableRelation = false;
        }
        field(6; "Zip Code"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Post Code".Code WHERE("Country/Region Code" = FIELD("Country Code"),
                                                    County = FIELD(State));
            ValidateTableRelation = false;
        }
        field(7; "Allowed Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = Customer;

            trigger OnValidate()
            begin

                CheckValues();
            end;
        }
        field(10; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Lot No.';
            TableRelation = "Item Ledger Entry"."Lot No." WHERE("Item No." = FIELD("Item No."));

            trigger OnLookup()
            begin
                //ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",1,"Lot No.");
            end;
        }
        field(20; "Restriction Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Not Allowed to Sell","Allowed to Sell";

            trigger OnValidate()
            begin

                CheckValues();
            end;
        }
    }

    keys
    {
        key(Key1; "Product Code", "Item No.", "Country Code", State, City, "Zip Code", "Allowed Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if ("Product Code" = '') and ("Item No." = '') then
            Error('Product Code or Item No. is required');

        //IF ("Country Code" = '') AND (State = '') AND (City = '') AND ("Zip Code" = '') THEN
        //  ERROR('Country Code or State or City or Zip Code is required');
    end;

    [Scope('Internal')]
    procedure CheckValues()
    begin

        if ("Allowed Customer No." <> '') and ("Restriction Type" = "Restriction Type"::"Not Allowed to Sell") then
            Error('<Restriction Type> cannot be <Not Allowed to Sell> when <Allowed Customer No.> has a value.');
    end;
}

