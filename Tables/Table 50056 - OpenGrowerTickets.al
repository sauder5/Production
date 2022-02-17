table 50056 "Open Grower Tickets"
{
    DataClassification = CustomerContent;
    LinkedObject = true;
    fields
    {
        field(10; "Grower Ticket No."; Code[20]) { DataClassification = CustomerContent; }
        field(20; "Receipt Date"; DateTime) { DataClassification = CustomerContent; }
        field(30; "Vendor No."; Code[20]) { DataClassification = CustomerContent; }
        field(40; "Name"; text[100]) { DataClassification = CustomerContent; Caption = 'Vendor Name'; }
        field(50; "Grower Share %"; Decimal) { DataClassification = CustomerContent; }
        field(60; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Posted,Canceled,Closed;
        }
        field(70; "Posting Date"; DateTime) { DataClassification = CustomerContent; }
        field(80; "Location Code"; Code[10]) { DataClassification = CustomerContent; }
        field(90; "Bin Code"; Code[20]) { DataClassification = CustomerContent; }
        field(100; "Item No."; code[20]) { DataClassification = CustomerContent; }
        field(110; "Description"; text[100]) { DataClassification = CustomerContent; }
        field(120; "Gross Wgt (LB)"; Decimal) { DataClassification = CustomerContent; }
        field(130; "Tare Wgt (LB)"; Decimal) { DataClassification = CustomerContent; }
        field(140; "Net Wgt (LB)"; Decimal) { DataClassification = CustomerContent; }
        field(150; "Gross Qty In Purchase UOM"; Decimal) { DataClassification = CustomerContent; }
        field(160; "Purch. Unit of Measure"; code[10]) { DataClassification = CustomerContent; }
        field(170; "Commodity Code"; code[20]) { DataClassification = CustomerContent; }
        field(180; "Commodity Premium per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(190; "Moisture Test Result"; Decimal) { DataClassification = CustomerContent; }
        field(200; "Moisture Discount per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(210; "Shrink %"; Decimal) { DataClassification = CustomerContent; }
        field(220; "Shrink Qty per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(230; "Splits Test Result"; Decimal) { DataClassification = CustomerContent; }
        field(240; "Splits Premium per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(250; "Test Weight Result"; Decimal) { DataClassification = CustomerContent; }
        field(260; "Test Weight Discount per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(270; "Vomitoxin Test Result"; Decimal) { DataClassification = CustomerContent; }
        field(280; "Vomitoxin Discount per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(290; "Cropping Practice Code"; Code[20]) { DataClassification = CustomerContent; }
        field(300; "Cropping Premium per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(310; "Out of Zone Premium per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(320; "Check off %"; Decimal) { DataClassification = CustomerContent; }
        field(330; "Total Premium Disc per UOM"; Decimal) { DataClassification = CustomerContent; }
        field(340; "Net Qty in Purchase UOM"; Decimal) { DataClassification = CustomerContent; }
        field(350; "Settled Quantity"; Decimal) { DataClassification = CustomerContent; }
        field(360; "Remaining Quantity"; Decimal) { DataClassification = CustomerContent; }
    }
}