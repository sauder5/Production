tableextension 65107 SalesHeaderArcExt extends "Sales Header Archive"
{
    fields
    {
        field(50000; "Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Ordered By"; Code[35])
        {
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(50003; "Ordered By Name"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "Ordered By Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Requested Ship Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(51001; "Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Cancelled Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Order Cancelled"));
            DataClassification = CustomerContent;
        }
        field(51003; "Order Method"; Option)
        {
            OptionMembers = ,Phone,Mail,Fax,Email,"In-person",Website,"From Salesperson";
            DataClassification = CustomerContent;
        }
        field(51004; "On-Hold Reason Code"; Code[10])
        {
            TableRelation = "Rupp Reason Code".Code where(Type = const("Order On Hold"));
            DataClassification = CustomerContent;
        }
        field(51020; "Seasonal Cash Disc Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51021; "Grace Period Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52000; "Region Code"; Code[20])
        {
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
        // Added by TAE 2021-08-04 to support the online customer center and ordering
        field(52010; "Customer Comment"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        // End
    }
}