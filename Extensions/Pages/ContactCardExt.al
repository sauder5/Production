pageextension 65050 ContactCardExt extends "Contact Card"
{
    layout
    {
        addafter("Language Code")
        {
            field("UPS Delivery Notification"; "UPS Delivery Notification")
            {
                ApplicationArea = all;
            }
            field("UPS Exception Notification"; "UPS Exception Notification")
            {
                ApplicationArea = all;
            }
            field("UPS Shipment Notification"; "UPS Shipment Notification")
            {
                ApplicationArea = all;
            }
        }
        addlast(General)
        {
            field(Last_Website_Login; "Last Website Login")
            {
                applicationarea = all;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
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
        recUPSOptions: Record "UPS Option Page";

    begin
        bDelivery := FALSE;
        bShipment := FALSE;
        bException := FALSE;
        CLEAR(sDeliveryAddress);
        CLEAR(sShipmentAddress);
        CLEAR(sExceptionAddress);

        IF ("UPS Delivery Notification") and ("E-Mail" > '') THEN BEGIN
            bDelivery := "UPS Delivery Notification";
            sDeliveryAddress := "E-Mail";
        END;
        IF ("UPS Shipment Notification") and ("E-Mail" > '') THEN BEGIN
            bShipment := "UPS Shipment Notification";
            sShipmentAddress := "E-Mail";
        END;
        IF ("UPS Exception Notification") and ("E-Mail" > '') THEN BEGIN
            bException := "UPS Exception Notification";
            sExceptionAddress := "E-Mail";
        END;

        recUPSOptions.SETFILTER(Type, '%1', recUPSOptions.Type::"Master Data");
        recUPSOptions.SETFILTER("Source ID", "No.");
        recUPSOptions.SETFILTER("Source Type", '%1', DATABASE::Customer);
        recUPSOptions.SETFILTER("Source Subtype", '%1', 0);
        recUPSOptions.SETFILTER("Second Source ID", '');
        recUPSOptions.SETFILTER("Shipping Agent Code", 'UPS');

        IF not recUPSOptions.FINDSET THEN
            with recUPSOptions do begin
                Type := Type::"Master Data";
                "Source ID" := "No.";
                "Source Type" := DATABASE::Customer;
                "Second Source ID" := '';
                "Shipping Agent Code" := 'UPS';
                "Ship Notification" := bShipment;
                recUPSOptions.insert;
            end;

        with recUPSOptions do begin
            "UPS Delivery Notification" := bDelivery;
            "Delivery Notification" := bDelivery;
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
        END;
    end;
}