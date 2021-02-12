table 50005 "Rupp Setup"
{

    fields
    {
        field(1; PK; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Check-off Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(11; "Check-off Bal. Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(12; "Check-off Bal. Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Check-off Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                                         Blocked = CONST(false))
            ELSE
            IF ("Check-off Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Check-off Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Check-off Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Check-off Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Check-off Bal. Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(13; "Check-off Bank Payment Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Payment Type';
            OptionCaption = ' ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT';
            OptionMembers = ,"Computer Check","Manual Check","Electronic Payment","Electronic Payment-IAT";

            trigger OnValidate()
            begin
                TestField("Check-off Bal. Account Type", "Check-off Bal. Account Type"::"Bank Account");
            end;
        }
        field(20; "Purchase Contract Nos"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(21; "Receipt Nos"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(22; "Item Wt for Receiving"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Gross Wt","Net Wt";
        }
        field(23; "Print Purch Inv on Settlement"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Check-off Payment Nos"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(25; "Location Code for Contract"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(30; "Premium/ Discount Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"G/L Account",Item,,,"Charge (Item)";
        }
        field(31; "Premium/ Discount No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            TableRelation = IF ("Premium/ Discount Type" = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                                    "Account Type" = CONST(Posting),
                                                                                                    Blocked = CONST(false))
            ELSE
            IF ("Premium/ Discount Type" = CONST(Item)) Item WHERE(Blocked = CONST(false))
            ELSE
            IF ("Premium/ Discount Type" = CONST("Charge (Item)")) "Item Charge";
        }
        field(32; "Premium/ Discount UOM Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Premium/ Discount Type" = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Premium/ Discount No."))
            ELSE
            "Unit of Measure";
        }
        field(33; "Premium/ Discount Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(40; "License Nos"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(41; "Compliance Group Nos"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50; "Work Order Nos"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(60; "Geographical Restriction Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rupp Reason Code".Code WHERE(Type = CONST("Line Cancelled"));
        }
        field(70; "Seasonal Disc. Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(71; "Seas. Disc. Jnl Template Name"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(72; "Seas. Disc. Jnl Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Seas. Disc. Jnl Template Name"));
        }
        field(80; "Min Amt to Print Sched on Conf"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Min. SO value to enable printing of Seash. Cash Disc. Schedule on Order Conf';
        }
        field(100; "Min.Order Value for Static S/H"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(101; "Static S/H Charge"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(102; "Static S/H Charge Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"G/L Account",Item,Resource,,"Charge (Item)";
        }
        field(103; "Static S/H Charge No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Static S/H Charge Type" = CONST(Item)) Item."No."
            ELSE
            IF ("Static S/H Charge Type" = CONST(Resource)) Resource."No."
            ELSE
            IF ("Static S/H Charge Type" = CONST("G/L Account")) "G/L Account"."No.";
        }
        field(104; "Static S/H Charge UOM Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(110; "Min Wt in g for Large Seed GNP"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Used to determine whether to create GNP Certification for Canadian shipments';
        }
        field(111; "Min Wt in g for Small Seed GNP"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Used to determine whether to create GNP Certification for Canadian shipments';
        }
    }

    keys
    {
        key(Key1; PK)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

