pageextension 80730 FastPackOrderExt extends "Fast Pack Order"
{
    layout
    {

    }

    actions
    {

    }

    var
        recWHShipLine: Record "Warehouse Shipment Line";


    local procedure GetWarehouseShipment(SourceID: Code[20]) WarehouseID: Code[20]
    begin
        clear(WarehouseID);
        recWHShipLine.SETFILTER("Source No.", SourceID);
        IF recWHShipLine.FINDSET THEN
            WarehouseID := recWHShipLine."No.";
    end;
}