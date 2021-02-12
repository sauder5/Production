tableextension 60025 VenLedgerEntryExt extends "Vendor Ledger Entry"
{
    fields
    {
        field(51001; "Check-off Payment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Check-off"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

}