pageextension 60038 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("Work Order No."; "Work Order No.")
            {
                applicationarea = all;
            }
        }
        addafter("Dimension Set ID")
        {
            field("Product Code"; "Product Code")
            {
                applicationarea = all;
            }
            field("Qty. in Lowest UOM"; "Qty. in Lowest UOM")
            {
                applicationarea = all;
            }
            field("Qty. in Common UOM"; "Qty. in Common UOM")
            {
                applicationarea = all;
            }
            field("Unit Cost"; UnitCost)
            {
                applicationarea = all;
            }
            field("Source No."; "Source No.")
            {
                applicationarea = all;
            }
            field("Vendor Name"; VendRec.Name)
            {
                applicationarea = all;
            }
            field("PO Number"; PurchaseRec."Order No.")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        UnitCost: Decimal;
        VendRec: record Vendor;
        PurchaseRec: Record "Purch. Rcpt. Header";

    trigger OnAfterGetRecord()
    begin
        UnitCost := 0;
        IF Quantity <> 0 THEN
            UnitCost := "Cost Amount (Actual)" / Quantity;

        IF NOT VendRec.GET("Source No.") THEN BEGIN
            CLEAR(VendRec);
            CLEAR(PurchaseRec);
        END
        ELSE
            IF NOT PurchaseRec.GET("Document No.") THEN
                CLEAR(PurchaseRec);
    end;
}