pageextension 65601 FixedAssetListExt extends "Fixed Asset List"
{
    layout
    {
        addafter("Serial No.")
        {
            field("Acquisition Cost"; recFADepbook."Acquisition Cost")
            {
                applicationarea = all;
            }
            field("Acquisition Date"; recFADepbook."Acquisition Date")
            {
                applicationarea = all;
            }
            field("Disposed Flag"; bDisposed)
            {
                applicationarea = all;
            }
            field("Disposal Date"; recFADepbook."Disposal Date")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }

    var
        bDisposed: Boolean;
        recFADepbook: Record "FA Depreciation Book";

    trigger OnAfterGetRecord()
    begin
        //RSI-KS
        recFADepBook.RESET;
        recFADepBook.SETFILTER("FA No.", "No.");
        recFADepBook.FINDFIRST;
        recFADepBook.CALCFIELDS("Acquisition Cost");
        bDisposed := recFADepBook."Disposal Date" > 0D;
        //RSI-KS        
    end;
}