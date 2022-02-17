tableextension 65050 ContactExt extends Contact
{
    fields
    {
        field(50500; "UPS Delivery Notification"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                recContact: Record Contact;
                recBusContRel: Record "Contact Business Relation";
            begin
                UpdateNotification(NotifyType::Delivery);
            end;

        }
        field(50501; "UPS Shipment Notification"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
            begin
                UpdateNotification(NotifyType::Shipment);
            end;
        }
        field(50502; "UPS Exception Notification"; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateNotification(NotifyType::Exception);
            end;
        }
        field(50550; "Last Website Login"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
    var
        NotifyType: option Delivery,Shipment,Exception;

    local procedure UpdateNotification(nType: Option Delivery,Shipment,Exception)
    var
        recContact: Record Contact;
        recUPSOptions: Record "UPS Option Page";
    begin
        recContact.SetCurrentKey("Company No.");
        recContact.SetFilter("Company No.", "Company No.");
        if "Company No." > '' then
            case nType of
                nType::Delivery:
                    begin
                        if "UPS Delivery Notification" then begin
                            recContact.ModifyAll("UPS Delivery Notification", false);
                            UpdateUPSOption(nType, true);
                        end else
                            UpdateUPSOption(nType, false);
                    end;
                nType::Exception:
                    begin
                        if "UPS Exception Notification" then begin
                            recContact.ModifyAll("UPS Exception Notification", false);
                            UpdateUPSOption(nType, true);
                        end else
                            UpdateUPSOption(nType, false)
                    end;
                nType::Shipment:
                    begin
                        if "UPS Shipment Notification" then begin
                            recContact.ModifyAll("UPS Shipment Notification", false);
                            UpdateUPSOption(nType, true);
                        end else
                            UpdateUPSOption(nType, false);
                    end;
            end;
    end;

    local procedure UpdateUPSOption(nType: Option Delivery,Shipment,Exception; FillFields: boolean)
    var
        recUPSOptions: Record "UPS Option Page";
        recContBusRel: Record "Contact Business Relation";
    begin

        if recContBusRel.get("Company No.", 'CUST') then begin
            recUPSOptions.SETFILTER(Type, '%1', recUPSOptions.Type::"Master Data");
            recUPSOptions.SETFILTER("Source ID", recContBusRel."No.");
            recUPSOptions.SETFILTER("Source Type", '%1', DATABASE::Customer);
            recUPSOptions.SETFILTER("Source Subtype", '%1', 0);
            recUPSOptions.SETFILTER("Second Source ID", '');
            //            recUPSOptions.SETFILTER("Shipping Agent Code", 'UPS');

            IF not recUPSOptions.FINDSET THEN
                with recUPSOptions do begin
                    Type := Type::"Master Data";
                    "Source ID" := recContBusRel."No.";
                    "Source Type" := DATABASE::Customer;
                    "Second Source ID" := '';
                    "Shipping Agent Code" := 'UPS';
                    recUPSOptions.insert;
                end;

            case nType of
                nType::Delivery:
                    begin
                        if ("E-Mail" > '') and FillFields then begin
                            recUPSOptions."Delivery Notification" := true;
                            recUPSOptions."Delivery Info. Level" := recUPSOptions."Delivery Info. Level"::Shipment;
                            recUPSOptions."Delivery Notification Email" := "E-Mail";
                            recUPSOptions.Modify();
                        end else begin
                            recUPSOptions."Delivery Notification" := false;
                            recUPSOptions."Delivery Info. Level" := recUPSOptions."Delivery Info. Level"::" ";
                            clear(recUPSOptions."Delivery Notification Email");
                            recUPSOptions.Modify();
                        end;
                    end;
                nType::Exception:
                    begin
                        if ("E-Mail" > '') and FillFields then begin
                            recUPSOptions."Exception Notification" := true;
                            recUPSOptions."Exception Info. Level" := recUPSOptions."Exception Info. Level"::Package;
                            recUPSOptions."Exception Notification Email" := "E-Mail";
                            recUPSOptions.Modify();
                        end else begin
                            recUPSOptions."Exception Notification" := false;
                            recUPSOptions."Exception Info. Level" := recUPSOptions."Exception Info. Level"::" ";
                            clear(recUPSOptions."Exception Notification Email");
                            recUPSOptions.Modify();
                        end;
                    end;
                nType::Shipment:
                    begin
                        if ("E-Mail" > '') and FillFields then begin
                            recUPSOptions."Ship Notification" := true;
                            recUPSOptions."Ship Notification Type" := recUPSOptions."Ship Notification Type"::Email;
                            recUPSOptions."Ship Notification Email" := "E-Mail";
                            recUPSOptions.Modify();
                        end else begin
                            recUPSOptions."Ship Notification" := false;
                            recUPSOptions."Ship Notification Type" := recUPSOptions."Ship Notification Type"::None;
                            clear(recUPSOptions."Ship Notification Email");
                            recUPSOptions.Modify();
                        end;
                    end;
            end;
        end;
    end;
}