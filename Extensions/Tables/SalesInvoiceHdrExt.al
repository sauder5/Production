tableextension 60112 SalesInvoiceHdrExt extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Order Created By"; Code[30])
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
        field(51001; "Cancelled-SOC"; Boolean)
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
        field(51020; "Seasonal Cash Disc Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51021; "Grace Period Days"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51030; "Freight Charges Option"; Option)
        {
            OptionMembers = "User Decides","One Time Charge","All Actual Charges";
            DataClassification = CustomerContent;
        }
        field(52000; "Region Code"; Code[20])
        {
            TableRelation = Region;
            DataClassification = CustomerContent;
        }
    }
}