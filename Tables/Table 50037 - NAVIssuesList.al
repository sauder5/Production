table 50037 "NAV Issues List"
{

    fields
    {
        field(5; RecordID; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; "Area"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Order Entry","Grain&Forage",Sales,Inventory,Shipping,Finance,Purchasing,Production;
        }
        field(20; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Extended Description"; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Required Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Priority (1=High - 10=Low)"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60; "User ID"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Date Entered"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(80; Resolution; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Date Resolved"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; RecordID)
        {
            Clustered = true;
        }
        key(Key2; "User ID", "Area", "Date Entered", RecordID)
        {
            Enabled = false;
        }
        key(Key3; "User ID", RecordID)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Date Entered" := CurrentDateTime;
        "User ID" := UserId;
    end;

    [Scope('Internal')]
    procedure SetText(Value: Text[1024]; Selection: Integer)
    var
        lText: BigText;
        DataStream: OutStream;
    begin
        if Selection = 1 then begin
            Clear("Extended Description");
            lText.AddText(Value);
            "Extended Description".CreateOutStream(DataStream);
            lText.Write(DataStream);
        end else begin
            Clear(Resolution);
            lText.AddText(Value);
            Resolution.CreateOutStream(DataStream);
            lText.Write(DataStream);
            "Date Resolved" := CurrentDateTime;
            Modify();
        end;
    end;

    [Scope('Internal')]
    procedure GetText(Selection: Integer) Value: Text
    var
        lText: BigText;
        DataStream: InStream;
    begin
        Clear(Value);
        if Selection = 1 then begin
            if "Extended Description".HasValue then begin
                "Extended Description".CreateInStream(DataStream);
                lText.Read(DataStream);
                lText.GetSubText(Value, 1);
            end;
        end else begin
            if Resolution.HasValue then begin
                Resolution.CreateInStream(DataStream);
                lText.Read(DataStream);
                lText.GetSubText(Value, 1);
            end;
        end;
        exit(Value);
    end;
}

