report 50008 "Work Order Report"
{
    // RSI-KS 08-06-15 Print bag items with consumed
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/WorkOrderReport.rdlc';
    UsageCategory = ReportsAndAnalysis;

    ProcessingOnly = false;

    dataset
    {
        dataitem("Work Order"; "Work Order")
        {
            column(WorkOrderNo; "Work Order"."No.")
            {
            }
            column(WOCreatedDateTime; "Work Order"."Created Date Time")
            {
            }
            column(WOCreatedDate; DT2Date("Work Order"."Created Date Time"))
            {
            }
            column(WODueDate; "Work Order"."Due Date")
            {
            }
            column(WOLocationCode; "Work Order"."Location Code")
            {
            }
            column(WOBinCode; "Work Order"."Bin Code")
            {
            }
            column(WOCreatedfromTemplate; "Work Order"."Created from Template")
            {
            }
            column(WODescription; "Work Order".Description)
            {
            }
            dataitem("Produced Item"; "Produced Item")
            {
                DataItemLink = "Work Order No." = FIELD("No.");
                DataItemTableView = SORTING("Work Order No.", "Line No.");
                column(PIWorkOrderNo; "Produced Item"."Work Order No.")
                {
                }
                column(PILineNo; "Produced Item"."Line No.")
                {
                }
                column(PIItemNo; "Produced Item"."Item No.")
                {
                }
                column(PIItemDesc; "Produced Item".Description)
                {
                }
                column(PIUOM; "Produced Item"."Unit of Measure Code")
                {
                }
                column(PILocation; "Produced Item"."Location Code")
                {
                }
                column(PIBin; "Produced Item"."Bin Code")
                {
                }
                column(PIQuantity; "Produced Item".Quantity)
                {
                }
                column(PIQtytoAssemble; "Produced Item"."Quantity to Assemble")
                {
                }
                column(PIQtyAssembled; "Produced Item"."Assembled Quantity")
                {
                }
                column(PIScreen; "Produced Item".Screen)
                {
                }
                column(PIBagItemNo; "Produced Item"."Bag Item No.")
                {
                }
                column(BIWorkOrderNo; gsBIWONo)
                {
                }
                column(BILineNo; giBILineNo)
                {
                }
                column(BINo; gsBIItemNo)
                {
                }
                column(BIDescription; gsBIItemDescription)
                {
                }
                column(BIUOMCode; gsBIItemUOMCode)
                {
                }
                column(BILocation; gsBILoc)
                {
                }
                column(BIBin; gsBIBin)
                {
                }
                column(BIQty; gdBIQty)
                {
                }
                column(ProducedLot; "Produced Item"."Lot No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    recBI: Record "Consumed Item";
                    recItem: Record Item;
                begin
                    gsBIItemNo := '';
                    gsBIItemDescription := '';
                    gsBIItemUOMCode := '';
                    gsBILoc := '';
                    gsBIBin := '';
                    gdBIQty := 0;

                    /*IF "Produced Item"."Bag Item No." <> '' THEN BEGIN
                      recBI.RESET();
                      recBI.SETRANGE("Work Order No.", "Produced Item"."Work Order No.");
                      recBI.SETRANGE("No.", "Produced Item"."Bag Item No.");
                      IF recBI.FINDFIRST() THEN BEGIN
                        //gsBIWONo
                        //giBILineNo
                        gsBIItemNo            := recBI."No.";
                        gsBIItemDescription   := recBI.Description;
                        gsBIItemUOMCode       := recBI."Unit of Measure Code";
                        gsBILoc               := recBI."Location Code";
                        gsBIBin               := recBI."Bin Code";
                        //gdBIQty               := recBI.Quantity;
                        gdBIQty               := Quantity;
                      END;
                    END; */

                end;
            }
            dataitem("Consumed Item"; "Consumed Item")
            {
                DataItemLink = "Work Order No." = FIELD("No.");
                DataItemTableView = SORTING("Work Order No.", "Line No.");
                column(CIWorkOrderNo; "Consumed Item"."Work Order No.")
                {
                }
                column(CILineNo; "Consumed Item"."Line No.")
                {
                }
                column(CIItemNo; "Consumed Item"."No.")
                {
                }
                column(CIItemDesc; "Consumed Item".Description)
                {
                }
                column(CIUOM; "Consumed Item"."Unit of Measure Code")
                {
                }
                column(CILocation; "Consumed Item"."Location Code")
                {
                }
                column(CIBin; "Consumed Item"."Bin Code")
                {
                }
                column(CIQuantity; "Consumed Item".Quantity)
                {
                }
                column(CIQtytoConsume; "Consumed Item"."Quantity to Consume")
                {
                }
                column(CIQtyConsumed; "Consumed Item"."Consumed Quantity")
                {
                }
                column(ConsumedLot; "Consumed Item"."Lot No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    /*IF "Consumed Item".Type = "Consumed Item".Type::Item THEN BEGIN
                      IF BagExists("Consumed Item"."No.")  THEN
                        CurrReport.SKIP;
                    END;*/

                end;
            }
            dataitem("Rupp Comment Line"; "Rupp Comment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Table ID", "Document No.", "Document Line No.", "Line No.") WHERE("Table ID" = CONST(50020), "Document Line No." = CONST(0));
                column(HdrComment; "Rupp Comment Line".Comment)
                {
                }
            }
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

    var
        gsItemDesc: Text[50];
        gsBIWONo: Code[20];
        giBILineNo: Integer;
        gsBIItemNo: Code[20];
        gsBIItemDescription: Text[50];
        gsBIItemUOMCode: Code[10];
        gsBILoc: Code[10];
        gsBIBin: Code[20];
        gdBIQty: Decimal;

    [Scope('Internal')]
    procedure BagExists(ItemNo: Code[20]) retBagExists: Boolean
    var
        recPI: Record "Produced Item";
    begin

        retBagExists := false;

        recPI.Reset();
        recPI.SetFilter("Work Order No.", "Work Order"."No.");
        recPI.SetFilter("Bag Item No.", ItemNo);

        if recPI.FindFirst() then
            retBagExists := true;
    end;
}

