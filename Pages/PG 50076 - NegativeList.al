page 50076 "Negative List"
{
    // //POPN6.2  Add menu items to Item Button
    //         Add global variables
    // 
    // //PM1.0
    //   Added button <Product Availability>
    //   Added columns "Product Code" and "Product Qty."
    // //SOC-SC 08-09-14
    //   Added <Quality Premium List>
    //   Added column "Quality Premium Code"
    //   Added 'Compliance Groups'
    //   Added 'Inventory' column
    //   Added "Sale Item" and "Purchase Item"
    // //SOC-SC 08-23-14
    //   Added 'Create New Items'
    //   Added 'Attributes'
    //   "Generic Name"
    // //SOC-MA
    // 
    // //SOC-SC 09-25-14
    //   Added report 'Items to Produce'
    // 
    // //SOC-SC 05-26-15
    //   Added Actions -> Cancel-Substitute

    Caption = 'Negative List';
    CardPageID = "BC O365 Item Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    PromotedActionCategories = 'Process';
    SourceTable = RuppLiveNegatives;
    SourceTableView = WHERE(Available = FILTER(< 0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("On Hand"; "On Hand")
                {
                    Caption = 'On Hand';
                }
                field("Sales Order"; "Sales Order")
                {
                    Caption = 'On Sales Order';
                }
                field("Purchase Order"; "Purchase Order")
                {
                    Caption = 'On Purchase Order';
                }
                field("WO Quantity"; "WO Quantity")
                {
                    Caption = 'On Work Order';
                }
                field(Available; Available)
                {
                    Caption = 'Available';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }

    trigger OnOpenPage()
    begin
        /*RESET();
        recCount:=COUNT();
        recNumber:=0;
        intProgress:=0;
        ProgressWindow.OPEN('Processing @1@@@@@@@@@@@@@@@@@@@@', intProgress);
        ProgressWindow.UPDATE();
        timProgress:=TIME;
        SETRANGE("No.", 'V', 'VZ');
        IF Rec.FINDSET() THEN BEGIN
          REPEAT
            recNumber+= 1;
            UpdateCalculatedQuantities;
            IF "Qty. Available to Sell" < 0 THEN
              MARK(TRUE);
            IF timProgress < TIME - 1000 THEN BEGIN
              timProgress := TIME;
              intProgress:= ROUND(recNumber / recCount * 10000, 1);
              ProgressWindow.UPDATE();
            END;
          UNTIL Rec.NEXT = 0;
        ProgressWindow.CLOSE();
        END;
        MARKEDONLY(TRUE);*/

    end;

    var
        SkilledResourceList: Page "Skilled Resource List";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        cduProdMgt: Codeunit "Product Management";
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        "--POPN--": Integer;
        greNote: Record Note;
        EntryNo: Integer;
        NotesT: Record Note;
        ProgressWindow: Dialog;
        timProgress: Time;
        intProgress: Integer;
        recCount: Integer;
        recNumber: Integer;

    [Scope('Internal')]
    procedure GetSelectionFilter(): Text
    var
        Item: Record Item;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
    end;

    [Scope('Internal')]
    procedure SetSelection(var Item: Record Item)
    begin
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
        SocialListeningMgt: Codeunit "Social Listening Management";
    begin
    end;
}

