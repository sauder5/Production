table 50028 "Research Plot Data"
{
    DrillDownPageID = "Research Plot Data";
    LookupPageID = "Research Plot Data";

    fields
    {
        field(10; Type; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Research Plots".Type;
        }
        field(15; Year; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Key"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = false;
            InitValue = 10;
        }
        field(30; "Variety Hybrid"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Plot#"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50; IDSP; Text[2])
        {
            DataClassification = CustomerContent;
        }
        field(60; "Plot Name"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Plot Size"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(80; "Row Width"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Row Length"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(110; "Rep #"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(120; Status; Option)
        {
            DataClassification = CustomerContent;
            InitValue = Active;
            OptionMembers = Active," Inactive";
        }
        field(130; Population; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(140; "Date Planted"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(150; "Date Harvested"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(160; IDP; Text[1])
        {
            DataClassification = CustomerContent;
        }
        field(170; "Plant Count"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(180; "Wet Lbs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(190; Yield; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(200; Moisture; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(210; Ratio; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(220; Height; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(230; Lodge; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(240; Maturity; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(250; Stalk; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(260; Root; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(270; "Ear Height"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(280; "Plot ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Type, "Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*IF GET(Type, Key) THEN BEGIN
          recPlotData.SETFILTER(Type, '%1', Type);
          recPlotData.FINDLAST;
          Key:=recPlotData.Key + 10;
        END;*/

    end;

    var
        recPlotData: Record "Research Plot Data";
}

