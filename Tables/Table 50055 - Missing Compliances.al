table 50055 "Missing Compliances"
{
    DataClassification = CustomerContent;
    LinkedObject = true;
    fields
    {
        field(10; "Document No."; code[20]) { DataClassification = CustomerContent; }
        field(20; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(30; "Line No."; integer) { DataClassification = CustomerContent; }
        field(40; "Sell-to Customer No."; code[20]) { DataClassification = CustomerContent; }
        field(50; "Ship-to Code"; code[10]) { DataClassification = CustomerContent; }
        field(60; "Outstanding Quantity"; Decimal) { DataClassification = CustomerContent; }
        field(70; "No."; code[20]) { DataClassification = CustomerContent; }
        field(80; "Waiver Code"; code[20]) { DataClassification = CustomerContent; }
        field(90; "Liability Waiver Required"; Boolean) { DataClassification = CustomerContent; }
        field(100; "Liability Waiver Start Date"; DateTime) { DataClassification = CustomerContent; }
        field(110; "Liability Waiver End Date"; DateTime) { DataClassification = CustomerContent; }
        field(120; "Liability Waiver Signed"; Boolean) { DataClassification = CustomerContent; }
        field(130; "Missing Liability Waiver"; Boolean) { DataClassification = CustomerContent; }
        field(140; "License Required"; Boolean) { DataClassification = CustomerContent; }
        field(150; "License No."; code[20]) { DataClassification = CustomerContent; }
        field(160; "License Issued Date"; DateTime) { DataClassification = CustomerContent; }
        field(170; "License Expiration Date"; DateTime) { DataClassification = CustomerContent; }
        field(180; "Missing License"; Boolean) { DataClassification = CustomerContent; }
        field(190; "Quality Release Required"; Boolean) { DataClassification = CustomerContent; }
        field(200; "Quality Release Start Date"; DateTime) { DataClassification = CustomerContent; }
        field(210; "Quality Release End Date"; DateTime) { DataClassification = CustomerContent; }
        field(220; "Quality Release Signed"; Boolean) { DataClassification = CustomerContent; }
        field(230; "Missing Quality Release"; Boolean) { DataClassification = CustomerContent; }
    }
}