page 50081 "Vegetable Label List"
{
    CardPageID = "Vegetable Label";
    DataCaptionFields = "Item Number";
    Editable = true;
    PageType = Card;
    UsageCategory = Lists;
    SourceTable = "Vegetable Label";
    SourceTableView = WHERE("Item Number" = FILTER(<> 'PRINTER'));

    layout
    {
        area(content)
        {
            group(Control1000000021)
            {
                ShowCaption = false;
                field(gLabel; gLabel)
                {
                    Caption = 'Label Name';
                }
                field(gPrinter; gPrinter)
                {
                    AssistEdit = false;
                    Caption = 'Printer';
                    DrillDown = false;
                    Lookup = true;
                    LookupPageID = Printers;
                    TableRelation = Printer;

                    trigger OnAssistEdit()
                    var
                        PrinterSelect: Record "Printer Selection";
                    begin
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(gQuantity; gQuantity)
                {
                    Caption = 'Number of Labels';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
            }
            group(Control1000000026)
            {
                ShowCaption = false;
                field(gItem; gItem)
                {
                    Caption = 'Item Lookup:';

                    trigger OnValidate()
                    begin
                        Setfilter("Item Number", '>=%1', gItem);
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Control1000000024)
            {
                ShowCaption = false;
                repeater(Group)
                {
                    field("Item Number"; "Item Number")
                    {

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            vegPage: Page "Vegetable Label";
                            vegRec: Record "Vegetable Label";
                        begin
                            Modify;
                            vegRec.Get("Item Number");
                            vegPage.SetRecord(vegRec);
                            vegPage.Run;
                        end;
                    }
                    field("Lot Number"; "Lot Number")
                    {
                    }
                    field("Batch Number"; "Batch Number")
                    {
                    }
                    field("Product Category"; "Product Category")
                    {
                        Width = 20;
                    }
                    field("Product Name"; "Product Name")
                    {
                        Width = 30;
                    }
                    field("Product Info"; "Product Info")
                    {
                    }
                    field("Test Date"; "Test Date")
                    {
                    }
                    field(Germ; Germ)
                    {
                        Width = 6;
                    }
                    field(Purity; Purity)
                    {
                        Width = 6;
                    }
                    field("Inert Material"; "Inert Material")
                    {
                        Width = 6;
                    }
                    field(Origin; Origin)
                    {
                        Width = 6;
                    }
                    field("Net Weight Seed"; "Net Weight Seed")
                    {
                    }
                    field("Seed Size"; "Seed Size")
                    {
                        Width = 6;
                    }
                    field("Seeds Per Lb"; "Seeds Per Lb")
                    {
                        DecimalPlaces = 0 : 0;
                        Width = 6;
                    }
                    field("JD Plate"; "JD Plate")
                    {
                        Width = 8;
                    }
                    field("IH Plate"; "IH Plate")
                    {
                        Width = 8;
                    }
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Printing)
            {
                Caption = 'Printing';
                action(Print)
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PrintFill;
                        btFormatDoc.Print;
                    end;
                }
            }
        }
    }

    trigger OnClosePage()
    var
        recVegLabel: Record "Vegetable Label";
    begin
        if PrintEnabled then
            btEngine.Stop;

        if gPrinter > '' then begin
            recVegLabel.SetFilter("Item Number", 'PRINTER');
            recVegLabel.SetFilter("Lot Number", UserId);
            if recVegLabel.FindSet then begin
                recVegLabel.Caution := gPrinter;
                recVegLabel."Product Info" := Format(gLabel);
                recVegLabel.Modify;
            end else begin
                Clear(recVegLabel);
                recVegLabel."Item Number" := 'PRINTER';
                recVegLabel."Lot Number" := UserId;
                recVegLabel."Product Info" := Format(gLabel);
                recVegLabel.Caution := gPrinter;
                recVegLabel.Insert;
            end;
        end;
    end;

    trigger OnOpenPage()
    var
        recVegLabel: Record "Vegetable Label";
        OK: Boolean;
    begin
        gQuantity := 1;
        recVegLabel.SetFilter("Item Number", 'PRINTER');
        recVegLabel.SetFilter("Lot Number", UserId);
        if recVegLabel.FindSet then begin
            gPrinter := recVegLabel.Caution;
            if recVegLabel."Product Info" > '' then
                Evaluate(gLabel, recVegLabel."Product Info");
        end;

        if IsNull(btEngine) then begin
            PrintEnabled := StartEngine();
        end;
    end;

    var
        gLabel: Option Corn,"Indian Art","Seed Size",Seed,Weight;
        gPrinter: Text[80];
        gQuantity: Integer;
        gItem: Code[20];
        [RunOnClient]
        btEngine: DotNet Engine;
        [RunOnClient]
        btFormatDoc: DotNet LabelFormatDocument;
        sText: Text;
        result: Integer;
        sName: Text;
        SQL: Text;
        PrintEnabled: Boolean;

    local procedure PrintFill()
    var
        lLabel: Text;
    begin

        if not PrintEnabled then
            Exit;

        lLabel := Format(gLabel);
        if (lLabel = '') or (gPrinter = '') or (gQuantity = 0) then begin
            Error('Please be sure to select a label format, printer and quantity');
            exit;
        end;

        //

        sText := 'L:\VegLabels\' + lLabel + '.btw';
        btFormatDoc := btEngine.Documents.Open(sText, gPrinter);
        btFormatDoc.PrintSetup.IdenticalCopiesOfLabel := gQuantity;

        btFormatDoc.SubStrings.SetSubString('ProductCategory', "Product Category");
        btFormatDoc.SubStrings.SetSubString('ProductName', "Product Name");
        btFormatDoc.SubStrings.SetSubString('ProductInfo', "Product Info");
        btFormatDoc.SubStrings.SetSubString('NetWeightSeed', "Net Weight Seed");
        btFormatDoc.SubStrings.SetSubString('BatchNumber', "Batch Number");
        btFormatDoc.SubStrings.SetSubString('LotNumber', "Lot Number");
        btFormatDoc.SubStrings.SetSubString('TestDate', "Test Date");
        btFormatDoc.SubStrings.SetSubString('Germ', Germ);
        btFormatDoc.SubStrings.SetSubString('Purity', Purity);
        btFormatDoc.SubStrings.SetSubString('InertMaterial', "Inert Material");
        btFormatDoc.SubStrings.SetSubString('Caution', Caution);
        btFormatDoc.SubStrings.SetSubString('Origin', Origin);
        btFormatDoc.SubStrings.SetSubString('SeedSize', "Seed Size");
        btFormatDoc.SubStrings.SetSubString('SeedsPerLb', Format("Seeds Per Lb"));
        btFormatDoc.SubStrings.SetSubString('JDPlate', "JD Plate");
        btFormatDoc.SubStrings.SetSubString('IHPlate', "IH Plate");
    end;

    [TryFunction]
    local procedure StartEngine()
    begin
        btEngine := btEngine.Engine(true);
    end;

}

