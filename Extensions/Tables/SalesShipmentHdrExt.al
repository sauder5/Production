tableextension 60110 SalesShipmentHdr extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Order Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Order Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Ordered By"; Code[35])
        {
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(50003; "Ordered By Name"; Text[50])
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
        field(51003; "Order Method"; Option)
        {
            OptionMembers = ,Phone,Mail,Fax,Email,"In-person",Website,"From Salesperson";
            DataClassification = CustomerContent;
        }
        field(51020; "Seasonal Cash Disc Code"; Code[50])
        {
            TableRelation = "Seasonal Cash Discount";
            DataClassification = CustomerContent;
        }
        field(51021; "Grace Period Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52000; "Region Code"; Code[50])
        {
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
    }
}