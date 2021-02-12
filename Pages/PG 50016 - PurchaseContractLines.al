page 50016 "Purchase Contract Lines"
{
    // //SOC-SC 08-06-15
    //   Added "Vomitoxin Test Result"

    Editable = true;
    PageType = List;
    SourceTable = "Purchase Contract Line";
    SourceTableView = SORTING ("Sequence No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract No."; "Contract No.")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Transaction Date"; "Transaction Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Settlement Unit Cost"; "Settlement Unit Cost")
                {
                }
                field("Settlement Line Amount"; "Settlement Line Amount")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Invoice %"; "Invoice %")
                {
                }
                field("Settlement Invoiced"; "Settlement Invoiced")
                {
                }
                field("Settled Line No."; "Settled Line No.")
                {
                }
                field("Invoiced Line Received Qty"; "Invoiced Line Received Qty")
                {
                }
                field("Invoiced Line Qty Yet To Rcv"; "Invoiced Line Qty Yet To Rcv")
                {
                }
                field("Premium/ Discount Unit Cost"; "Premium/ Discount Unit Cost")
                {
                }
                field("Premium/ Discount Amount"; "Premium/ Discount Amount")
                {
                }
                field("Check-off Amount"; "Check-off Amount")
                {
                }
                field("Invoice Unit Cost"; "Invoice Unit Cost")
                {
                }
                field("Invoice Line Amount"; "Invoice Line Amount")
                {
                }
                field("Purchase Order No."; "Purchase Order No.")
                {
                }
                field("Purchase Order Line No."; "Purchase Order Line No.")
                {
                }
                field("Purch. Invoice No."; "Purch. Invoice No.")
                {
                }
                field("Purch. Invoice Line No."; "Purch. Invoice Line No.")
                {
                }
                field("Scale Ticket No."; "Scale Ticket No.")
                {
                }
                field("Receipt No."; "Receipt No.")
                {
                }
                field("Receipt Line No."; "Receipt Line No.")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field(Moisture; Moisture)
                {
                }
                field(Splits; Splits)
                {
                }
                field("Test Weight"; "Test Weight")
                {
                }
                field("Vomitoxin Test Result"; "Vomitoxin Test Result")
                {
                }
                field("Shrink %"; "Shrink %")
                {
                }
                field("Recd. Gross Qty."; "Recd. Gross Qty.")
                {
                }
                field("Recd. Shrink Qty."; "Recd. Shrink Qty.")
                {
                }
                field("Recd. Net Qty."; "Recd. Net Qty.")
                {
                }
                field("Recd. Lot No."; "Recd. Lot No.")
                {
                }
                field("Recd. Location Code"; "Recd. Location Code")
                {
                }
                field("Recd. Bin Code"; "Recd. Bin Code")
                {
                }
                field("Recd. Splits Unit Premium"; "Recd. Splits Unit Premium")
                {
                }
                field("Recd. Test Weight Unit Disc"; "Recd. Test Weight Unit Disc")
                {
                }
                field("Recd. Vomitoxin Unit Discount"; "Recd. Vomitoxin Unit Discount")
                {
                }
                field("Recd. Seed Unit Premium"; "Recd. Seed Unit Premium")
                {
                }
                field("Recd. Splits Premium Amount"; "Recd. Splits Premium Amount")
                {
                }
                field("Recd. Test Weight Disc Amount"; "Recd. Test Weight Disc Amount")
                {
                }
                field("Recd. Vomitoxin Disc Amount"; "Recd. Vomitoxin Disc Amount")
                {
                }
                field("Recd. Seed Premium Amount"; "Recd. Seed Premium Amount")
                {
                }
                field("Recd. Unit Premium/Discount"; "Recd. Unit Premium/Discount")
                {
                }
                field("Quality Premium Code"; "Quality Premium Code")
                {
                }
                field("Check-off %"; "Check-off %")
                {
                }
                field("Recd/Settled Qty. Invoiced"; "Recd/Settled Qty. Invoiced")
                {
                }
                field("Recd/Settled Qty. Not Invoiced"; "Recd/Settled Qty. Not Invoiced")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ShowDocument)
            {
                Caption = 'Show &Document';
                Image = ViewOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction()
                var
                    PurchContract: Record "Purchase Contract Header";
                begin
                    PurchContract.Get("Contract No.");
                    PAGE.Run(PAGE::"Purchase Contract", PurchContract);
                end;
            }
            action("Posted Purchase Invoice Lines")
            {

                trigger OnAction()
                var
                    recPurchInvLn: Record "Purch. Inv. Line";
                begin
                    if "Transaction Type" = "Transaction Type"::Invoice then begin
                        recPurchInvLn.Reset();
                        recPurchInvLn.SetRange("Purchase Contract No.", "Contract No.");
                        recPurchInvLn.SetRange("Purchase Contract Inv Line No.", "Line No.");
                        if recPurchInvLn.FindSet() then begin
                            PAGE.RunModal(529, recPurchInvLn);
                        end;
                    end;
                end;
            }
            action("Posted Purchase Receipt Lines")
            {

                trigger OnAction()
                var
                    recPurchRcptLn: Record "Purch. Rcpt. Line";
                begin
                    if "Transaction Type" = "Transaction Type"::Receipt then begin
                        recPurchRcptLn.Reset();
                        recPurchRcptLn.SetRange("Purchase Contract No.", "Contract No.");
                        recPurchRcptLn.SetRange("Purchase Contract Rct Line No.", "Line No.");
                        if recPurchRcptLn.FindSet() then begin
                            PAGE.RunModal(528, recPurchRcptLn);
                        end;
                    end;
                end;
            }
            action("Settlement Links")
            {

                trigger OnAction()
                var
                    recContractRcptInvLink: Record "Contract Rcpt-Invoice Link";
                begin
                    if "Transaction Type" = "Transaction Type"::Settlement then begin
                        recContractRcptInvLink.Reset();
                        recContractRcptInvLink.SetRange("Contract No.", "Contract No.");
                        recContractRcptInvLink.SetRange("Settlement Line No.", "Line No.");
                        if recContractRcptInvLink.FindSet() then begin
                            PAGE.RunModal(0, recContractRcptInvLink);
                        end;
                    end;
                end;
            }
        }
    }
}

