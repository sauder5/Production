tableextension 65722 ItemCategoryExt extends "Item Category"
{
    fields
    {
        field(50100; "Def. Gen. Prod. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group".Code;
            DataClassification = CustomerContent;
        }
        field(50101; "Def. Inventory Posting Group"; Code[10])
        {
            TableRelation = "Inventory Posting Group".Code;
            DataClassification = CustomerContent;
        }
        field(50102; "Def. Tax Group Code"; Code[10])
        {
            TableRelation = "Tax Group".Code;
            DataClassification = CustomerContent;
        }
        field(50103; "Def. Costing Method"; Option)
        {
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
            DataClassification = CustomerContent;
        }
        field(50104; "Def. VAT Prod. Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group".Code;
            DataClassification = CustomerContent;
        }
    }
}