tableextension 60097 CommentLineExt extends "Comment Line"
{
    fields
    {
        field(51000; "Print on Cancellation Notice"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51001; "Copy to Items of Same Product"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}