tableextension 60003 PaymentTermsExt extends "Payment Terms"
{
    fields
    {
        field(51000; "Allow Seasonal Cash Discount"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51010; "Print Disc Sched on Ord Conf."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(52000; "Due Date MM-DD"; Text[5])
        {
            DataClassification = CustomerContent;
        }
    }
}