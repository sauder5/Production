page 50021 Receipt
{
    // //SOC-SC 08-06-15
    //   Added field "Vomitoxin Test Result"

    Caption = 'Contract Receipt';
    PageType = Document;
    SourceTable = "Receipt Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Primary Vendor No."; "Primary Vendor No.")
                {
                }
                field("Primary Vendor Name"; "Primary Vendor Name")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Contract No."; "Contract No.")
                {
                }
                field("Scale Ticket No."; "Scale Ticket No.")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
            }
            group("Receiving Data")
            {
                field("Gross Wt (LB)"; "Gross Wt (LB)")
                {
                }
                field("Tare Wt (LB)"; "Tare Wt (LB)")
                {
                }
                field("Net Wt (LB)"; "Net Wt (LB)")
                {
                }
                field("Moisture Test Result"; "Moisture Test Result")
                {
                }
                field("Splits Test Result"; "Splits Test Result")
                {
                }
                field("Test Weight Result"; "Test Weight Result")
                {
                }
                field("Vomitoxin Test Result"; "Vomitoxin Test Result")
                {
                }
                field(Farm; Farm)
                {
                }
                field("Farm Field"; "Farm Field")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field(PurchUOM; "Purch. Unit of Measure Code")
                {
                    Caption = 'Purch. Unit of Measure';
                    Editable = false;
                }
                field("Net Quantity in Purchase UOM"; "Net Quantity in Purchase UOM")
                {
                    Editable = false;
                }
            }
            group(Detail)
            {
                Visible = false;
                field("Quality Premium Code"; "Quality Premium Code")
                {
                    Editable = false;
                }
                field("Check-off %"; "Check-off %")
                {
                    Editable = false;
                }
                field("Purch. Unit of Measure Code"; "Purch. Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Lbs per Purch. Unit of Measure"; "Lbs per Purch. Unit of Measure")
                {
                    Editable = false;
                }
                field("Gross Quantity in Purchase UOM"; "Gross Quantity in Purchase UOM")
                {
                    Editable = false;
                }
                field("Shrink %"; "Shrink %")
                {
                }
                field("Shrink Qty."; "Shrink Qty.")
                {
                }
                field(netQtyInPUOM; "Net Quantity in Purchase UOM")
                {
                    Caption = 'Net Quantity in Purchase UOM';
                    Editable = false;
                }
                field("Unit Premium/Discount"; "Unit Premium/Discount")
                {
                }
            }
            part(Lines; "Receipt Subform")
            {
                SubPageLink = "Receipt No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Split")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UpdateLines();
                    Commit;
                    Message('Calculated Splits');
                end;
            }
            action(Post)
            {
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RcptMgt: Codeunit "Receipt Management";
                begin
                    RcptMgt.ProcessReceipt(Rec);
                end;
            }
        }
    }
}

