table 50051 "Settlement Applied Amounts"
{
    // version GroProd


    fields
    {
        field(10; "Production Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Production Lot" WHERE("Production Lot No." = FIELD("Production Lot No."));

        }
        field(20; "Settlement Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Settlement-Prepayment Ticket" where("Settlement No." = field("Settlement Ticket No."));
        }
        field(30; "Grower Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Grower Ticket" where("Grower Ticket No." = field("Grower Ticket No."));
        }
        field(50; "Quantity Applied"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Prepay No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Prepay Consumed"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(80; "Applied Date"; date)
        {

        }
    }

    keys
    {
        key(Key1; "Production Lot No.", "Settlement Ticket No.", "Grower Ticket No.")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        "Applied Date" := Today();
    end;
}

