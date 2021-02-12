report 50054 "Items by Bin/Lot"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/ItemsbyBinLot.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(BinContentBuffer; "Bin Content Buffer")
        {
            DataItemTableView = SORTING("Item No.", "Bin Code", "Lot No.");
            UseTemporary = true;
            column(Item; BinContentBuffer."Item No.")
            {
            }
            column(LocCode; BinContentBuffer."Location Code")
            {
            }
            column(BinCode; BinContentBuffer."Bin Code")
            {
            }
            column(LotNumber; BinContentBuffer."Lot No.")
            {
            }
            column(Quantity; BinContentBuffer."Qty. to Handle (Base)")
            {
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

    trigger OnPreReport()
    var
        ItemEntry: Record "Item Ledger Entry";
        BinContent: Record "Bin Content";
        LocationCode: Label 'RUPP';
    begin
        ItemEntry.SetRange("Location Code", LocationCode);
        ItemEntry.SetRange(Open, true);
        if ItemEntry.FindSet then
            repeat
                BinContentBuffer.Reset;
                BinContentBuffer.SetRange("Location Code", LocationCode);
                BinContentBuffer.SetRange("Item No.", ItemEntry."Item No.");
                BinContentBuffer.SetRange("Lot No.", ItemEntry."Lot No.");
                BinContentBuffer.SetRange("Serial No.", ItemEntry."Serial No.");
                if BinContentBuffer.IsEmpty then begin  //combination not processed yet
                    BinContent.Reset;
                    BinContent.SetRange("Location Code", LocationCode);
                    BinContent.SetRange("Item No.", ItemEntry."Item No.");
                    if ItemEntry."Lot No." <> '' then
                        BinContent.SetRange("Lot No. Filter", ItemEntry."Lot No.");
                    if ItemEntry."Serial No." <> '' then
                        BinContent.SetRange("Serial No. Filter", ItemEntry."Serial No.");
                    BinContent.SetFilter(Quantity, '<>%1', 0);
                    if BinContent.FindSet then
                        repeat
                            BinContent.CalcFields("Quantity (Base)");

                            BinContentBuffer.Init;
                            BinContentBuffer."Location Code" := BinContent."Location Code";
                            BinContentBuffer."Bin Code" := BinContent."Bin Code";
                            BinContentBuffer."Item No." := BinContent."Item No.";
                            BinContentBuffer."Variant Code" := BinContent."Variant Code";
                            BinContentBuffer."Unit of Measure Code" := BinContent."Unit of Measure Code";
                            BinContentBuffer."Lot No." := ItemEntry."Lot No.";
                            BinContentBuffer."Serial No." := ItemEntry."Serial No.";
                            BinContentBuffer."Zone Code" := BinContent."Zone Code";
                            BinContentBuffer."Qty. to Handle (Base)" := BinContent."Quantity (Base)";
                            BinContentBuffer."Qty. Outstanding (Base)" := BinContent."Quantity (Base)";
                            BinContentBuffer.Insert;
                        until BinContent.Next = 0;
                end;
            until ItemEntry.Next = 0;
    end;
}

