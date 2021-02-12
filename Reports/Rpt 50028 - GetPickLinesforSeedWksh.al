report 50028 "Get Pick Lines for Seed Wksh"
{
    // //RSI-KS 12-07-15
    //   Don't fill unit weight from item card

    ProcessingOnly = true;

    dataset
    {
        dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
        {
            DataItemTableView = WHERE ("Action Type" = FILTER (<> Place));
            RequestFilterFields = "Ship-to Country Code", "Starting Date", "Destination Type", "Destination No.", "Source Document", "Source No.", "Item No.";

            trigger OnAfterGetRecord()
            var
                recItem: Record Item;
                recProduct: Record Product;
            begin
                giLineNo += 1;
                recOrderLnSeedWkshLn.Init();
                recOrderLnSeedWkshLn."Batch No." := giBatchNo;
                recOrderLnSeedWkshLn."Line No." := giLineNo;
                recOrderLnSeedWkshLn."Pick No." := "No.";
                recOrderLnSeedWkshLn."Pick Line No." := "Line No.";
                recOrderLnSeedWkshLn."Source Type" := "Source Type";
                recOrderLnSeedWkshLn."Source Subtype" := "Source Subtype";
                recOrderLnSeedWkshLn."Source No." := "Source No.";
                recOrderLnSeedWkshLn."Source Line No." := "Source Line No.";
                recOrderLnSeedWkshLn."Source Subline No." := "Source Subline No.";
                recOrderLnSeedWkshLn."Source Document" := "Source Document";
                recOrderLnSeedWkshLn."Item No." := "Item No.";
                recOrderLnSeedWkshLn."Variant Code" := "Variant Code";
                recOrderLnSeedWkshLn."Unit of Measure Code" := "Unit of Measure Code";
                recOrderLnSeedWkshLn."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                recOrderLnSeedWkshLn.Description := Description;
                recOrderLnSeedWkshLn.Quantity := Quantity;
                recOrderLnSeedWkshLn."Unit Seed Weight in g" := "Unit Seed Weight in g";
                recOrderLnSeedWkshLn."Line Seed Weight in g" := "Line Seed Weight in g";
                recOrderLnSeedWkshLn."Internal Lot No." := "Internal Lot No.";
                recOrderLnSeedWkshLn."Country of Origin Code" := "Country of Origin Code";
                if recItem.Get("Item No.") then begin
                    recOrderLnSeedWkshLn."Product Code" := recItem."Product Code";
                    if recOrderLnSeedWkshLn."Unit Seed Weight in g" = 0 then begin
                        //    recOrderLnSeedWkshLn."Unit Seed Weight in g" := ROUND(recItem."Net Weight" * 1000/2.2, 0.01);
                        //    recOrderLnSeedWkshLn."Line Seed Weight in g" := recOrderLnSeedWkshLn."Unit Seed Weight in g" * Quantity;
                    end;
                end;
                recOrderLnSeedWkshLn."Created By" := UserId;
                recOrderLnSeedWkshLn."Created DateTime" := dtCreatedDateTime;
                recOrderLnSeedWkshLn.Insert();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if giLineNo > 0 then begin
            recOrderLnSeedWkshLn.Reset();
            recOrderLnSeedWkshLn.FindSet();
            PAGE.RunModal(50074, recOrderLnSeedWkshLn);
        end;
    end;

    trigger OnPreReport()
    begin
        giBatchNo := 1;
        giLineNo := 0;
        dtCreatedDateTime := CurrentDateTime;
    end;

    var
        giBatchNo: Integer;
        giLineNo: Integer;
        dtCreatedDateTime: DateTime;
        recOrderLnSeedWkshLn: Record "Order Line Seed Worksheet Line" temporary;
}

