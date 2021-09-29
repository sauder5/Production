pageextension 80908 EmailListEntryExt extends "E-Mail List Entries"
{
    layout
    {
        addafter("E-Mail")
        {
            field("UPS Delivery Notification"; "UPS Delivery Notification")
            {
                ApplicationArea = all;
            }
            field("UPS Shipment Notification"; "UPS Shipment Notification")
            {
                ApplicationArea = all;
            }
            field("UPS Exception Notification"; "UPS Exception Notification")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
    trigger OnModifyRecord(): Boolean
    begin
        CheckNotification();
    end;

    local procedure CheckNotification()
    var
        bDelivery: Boolean;
        bShipment: Boolean;
        bException: Boolean;

        sDeliveryAddress: text;
        sShipmentAddress: Text;
        sExceptionAddress: text;
        recEmailList: Record "E-Mail List Entry";
        recUPSOptions: Record "UPS Option Page";
    begin
        bDelivery := FALSE;
        bShipment := FALSE;
        bException := FALSE;
        CLEAR(sDeliveryAddress);
        CLEAR(sShipmentAddress);
        CLEAR(sExceptionAddress);

        IF ("UPS Delivery Notification") THEN BEGIN
            bDelivery := "UPS Delivery Notification";
            sDeliveryAddress := "E-Mail";
        END;
        IF ("UPS Shipment Notification") THEN BEGIN
            bShipment := "UPS Shipment Notification";
            sShipmentAddress := "E-Mail";
        END;
        IF ("UPS Exception Notification") THEN BEGIN
            bException := "UPS Exception Notification";
            sExceptionAddress := "E-Mail";
        END;

        recUPSOptions.SETFILTER(Type, '%1', recUPSOptions.Type::"Master Data");
        recUPSOptions.SETFILTER("Source ID", Code);
        recUPSOptions.SETFILTER("Source Type", '%1', DATABASE::Customer);
        recUPSOptions.SETFILTER("Source Subtype", '%1', 0);
        recUPSOptions.SETFILTER("Second Source ID", '');
        recUPSOptions.SETFILTER("Shipping Agent Code", 'UPS');
        IF recUPSOptions.FINDSET THEN
            WITH recUPSOptions DO BEGIN
                "Delivery Notification Email" := sDeliveryAddress;
                IF bDelivery THEN
                    "Delivery Info. Level" := "Delivery Info. Level"::Shipment
                ELSE
                    "Delivery Info. Level" := "Delivery Info. Level"::" ";
                "Exception Notification" := bException;
                "Exception Notification Email" := sExceptionAddress;
                IF bException THEN
                    "Exception Info. Level" := "Exception Info. Level"::Package
                ELSE
                    "Exception Info. Level" := "Exception Info. Level"::" ";
                "Ship Notification" := bShipment;
                "Ship Notification Email" := sShipmentAddress;
                IF bShipment THEN
                    "Ship Notification Type" := "Ship Notification Type"::Email
                ELSE
                    "Ship Notification Type" := "Ship Notification Type"::None;
                "Shipping Agent Service" := 'STANDARD';
                recUPSOptions.MODIFY
            END ELSE BEGIN
            WITH recUPSOptions DO BEGIN
                Type := Type::"Master Data";
                "Source ID" := Code;
                "Source Type" := DATABASE::Customer;
                "Second Source ID" := '';
                "Shipping Agent Code" := 'UPS';
                "Ship Notification" := bShipment;
                IF bShipment THEN
                    "Ship Notification Type" := "Ship Notification Type"::Email
                ELSE
                    "Ship Notification Type" := "Ship Notification Type"::None;
                "Ship Notification Email" := sShipmentAddress;
                "Delivery Notification" := bDelivery;
                IF bDelivery THEN
                    "Delivery Info. Level" := "Delivery Info. Level"::Shipment
                ELSE
                    "Delivery Info. Level" := "Delivery Info. Level"::" ";
                "Delivery Notification Email" := sDeliveryAddress;
                "Exception Notification" := bException;
                IF bException THEN
                    "Exception Info. Level" := "Exception Info. Level"::Package
                ELSE
                    "Exception Info. Level" := "Exception Info. Level"::" ";
                "Exception Notification Email" := sExceptionAddress;
                "Shipping Agent Service" := 'STANDARD';
                recUPSOptions.INSERT;
            END;
        END;
    end;
}