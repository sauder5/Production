page 50054 "Payment Links"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Customer Payment Link";
    SourceTableView = SORTING("Payment CLE No.", Request, Cancelled, "Season Code")
                      WHERE(Request = CONST(false),
                            "Payment CLE No." = FILTER(> 0),
                            Cancelled = CONST(false),
                            "Amount to Link" = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; "Customer No.")
                {
                }
                field("Payment CLE No."; "Payment CLE No.")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Invoice CLE No."; "Invoice CLE No.")
                {
                }
                field("Invoice Payment Terms Code"; "Invoice Payment Terms Code")
                {
                }
                field(Processed; Processed)
                {
                }
                field("Order Exists"; "Order Exists")
                {
                }
                field("Linked Amount"; "Linked Amount")
                {
                }
                field("Season Code"; "Season Code")
                {
                }
                field("Grace Period Days"; "Grace Period Days")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field("Amount to Link"; "Amount to Link")
                {
                }
                field("Effective Amount to Link"; "Effective Amount to Link")
                {
                }
                field("Amount Applied"; "Amount Applied")
                {
                }
            }
        }
    }

    actions
    {
    }
}

