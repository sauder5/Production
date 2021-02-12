tableextension 60044 SalesCommentLineExt extends "Sales Comment Line"
{
    fields
    {
        field(51000; "Print On Bill of Lading"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}