codeunit 50014 "Rupp Misc Functions"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure GetQtyLUOMandQtyCUOM(ItemNo: Code[20]; "UOM Code": Code[20]; Quantity: Decimal; var RetQtyInLUOM: Decimal; var RetQtyInCUOM: Decimal)
    var
        recItemUOM: Record "Item Unit of Measure";
    begin

        RetQtyInLUOM := 0;
        RetQtyInLUOM := 0;
        if recItemUOM.Get(ItemNo, "UOM Code") then begin
            RetQtyInLUOM := Quantity * recItemUOM."Qty. per Lowest UOM";
            RetQtyInCUOM := Quantity * recItemUOM."Qty. per Common UOM";
        end;
    end;
}

