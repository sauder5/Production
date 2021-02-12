table 50050 "Settlement-Prepayment Ticket"
{
    // version GroProd


    fields
    {
        field(10; "Settlement No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Production Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(40; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item."No.";

            trigger OnValidate();
            begin
                if recItem.GET("Item No.") then
                    "Generic Name Code" := recItem."Generic Name Code";
            end;
        }
        field(50; "Generic Name Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Attribute".Code WHERE("Attribute Type" = FILTER("Generic Name"));
        }
        field(60; "Settlement Quantity"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("Settled Quantity");
            end;
        }
        field(70; "Settlement Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(80; "Base Settlement Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(90; "Prepayment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(100; "Settlement Type"; Option)
        {
            DataClassification = CustomerContent;
            InitValue = Cash;
            OptionCaption = 'Cash,Futures (New Crop)';
            OptionMembers = Cash,"Futures (New Crop)";
        }
        field(110; "Futures Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(120; "Deferred Payment"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(130; "Deferred Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(140; "Settled Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                recApplied: Record "Settlement Applied Amounts";
            begin
                recApplied.RESET;
                recApplied.SETFILTER("Settlement Ticket No.", "Settlement No.");
                recApplied.CALCSUMS("Quantity Applied");
                "Settled Quantity" := recApplied."Quantity Applied";

                VALIDATE("Remaining Quantity", "Settlement Quantity" - "Settled Quantity");
            end;
        }
        field(150; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(160; "Purchase Invoice"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(170; "Purch Inv Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(180; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Posted,Prepay Paid,Prepay Consumed';
            OptionMembers = Open,Posted,"Prepay Paid","Prepay Consumed";
        }
        field(190; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(330; "Transaction ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(340; "Item Journal Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(350; "Value Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(360; "Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(370; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(380; "Prepay Total Consumed"; Decimal)
        {
            CalcFormula = Sum("Settlement Applied Amounts"."Prepay Consumed" WHERE("Prepay No." = FIELD("Settlement No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Settlement No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        recItem: Record Item;
        cduReceiptMgt: Codeunit "Receipt Management";
        recAppliedAmt: Record "Settlement Applied Amounts";

    trigger OnDelete()
    var
        GrowerTkt: Code[20];
        recGrowerTkt: Record "Grower Ticket";
    begin
        If "Settlement No." > '' then begin
            recAppliedAmt.SETFILTER("Settlement Ticket No.", "Settlement No.");
            IF recAppliedAmt.FINDSET THEN
                REPEAT
                    GrowerTkt := recAppliedAmt."Grower Ticket No.";
                    recAppliedAmt.DELETE;
                    IF recGrowerTkt.GET(GrowerTkt) THEN BEGIN
                        recGrowerTkt.VALIDATE("Settled Quantity");
                        recGrowerTkt.MODIFY;
                    END;
                UNTIL recAppliedAmt.NEXT = 0;
        end;
    end;

    procedure Init(ProdLot: Code[20]);
    var
        recProdLot: Record "Production Lot";
        recGrowerTkt: Record "Grower Ticket";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recVendor: Record Vendor;
    begin
        VALIDATE("Production Lot No.", ProdLot);

        CLEAR(recProdLot);

        if recProdLot.GET(ProdLot) then;

        "Settlement No." := NoSeriesMgt.GetNextNo('R_SETTLENO', TODAY(), true);
        "Settlement Date" := TODAY;
        INSERT;
    end;
}

