tableextension 66505 LotNoInformationExt extends "Lot No. Information"
{
    fields
    {
        field(51000; "Seed Size"; Option)
        {
            OptionMembers = " ",Small,Large;
            DataClassification = CustomerContent;
        }
        field(51001; "Seed Shape"; Option)
        {
            OptionMembers = Flat,Round;
            DataClassification = CustomerContent;
        }
        field(51002; "Seed Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Seeds/LB"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51004; "Germ %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51005; "Purity %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51006; "Inert %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51007; "Tested Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(51008; "Batch No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51009; "Country of Origin"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(51010; "JD Plate"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(51011; "IH Plate"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(51012; "Caution Notes"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(51013; "Seed Notes"; text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}