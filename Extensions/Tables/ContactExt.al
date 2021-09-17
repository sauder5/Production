tableextension 65050 ContactExt extends Contact
{
    fields
    {
        field(50000; "Last Website Login"; Date)
        {
            DataClassification = CustomerContent;
        }
    }
}