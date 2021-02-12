tableextension 60289 PaymentMethodExt extends "Payment Method"
{
    fields
    {
        field(51010; "Print Disc Sched on Ord Conf."; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51020; "Payment Terms Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
    }
}