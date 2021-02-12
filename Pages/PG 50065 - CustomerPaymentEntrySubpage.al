page 50065 "Customer Payment Entry Subpage"
{
    Caption = 'Customer Payment Entries';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = giEntryNo = "Entry No.";
                }
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = giEntryNo = "Entry No.";
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = giEntryNo = "Entry No.";
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = giEntryNo = "Entry No.";
                }
                field("Original Amt. (LCY)"; "Original Amt. (LCY)")
                {
                }
                field(Amount; Amount)
                {
                    Visible = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                }
                field("User ID"; "User ID")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Open; Open)
                {
                    Editable = false;
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                    Editable = false;
                }
                field("Requested Fall Amount"; "Requested Fall Amount")
                {

                    trigger OnValidate()
                    begin
                        //UpdatePotentialAmt();
                    end;
                }
                field("Requested Spring Amount"; "Requested Spring Amount")
                {

                    trigger OnValidate()
                    begin
                        //UpdatePotentialAmt();
                    end;
                }
                field("Requested Seasonal Amount"; "Requested Seasonal Amount")
                {
                    Visible = false;
                }
                field("Requested Seasonal Discount"; "Requested Seasonal Discount")
                {
                }
                field("Linked Seasonal Amount"; "Linked Seasonal Amount")
                {
                    Visible = false;
                }
                field("Linked Seasonal Discount"; "Linked Seasonal Discount")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select Entry")
            {
                ShortCutKey = 'F2';
                Visible = false;

                trigger OnAction()
                begin
                    SelectEntry();
                end;
            }
            separator(Action1000000020)
            {
            }
            action("Requested Seasonal Discounts")
            {
                RunObject = Page "Requested Seasonal Discounts";
                RunPageLink = "Payment CLE No." = FIELD("Entry No.");
                RunPageView = SORTING("Payment CLE No.", Request, Cancelled, "Season Code")
                              WHERE(Request = FILTER(true),
                                    Cancelled = FILTER(false));
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        gbDocSelected := false;
        giCurrEntryNo := "Entry No.";
        gsCurrDocNo := "Document No.";
    end;

    var
        giEntryNo: Integer;
        gsDocNo: Code[30];
        gbDocSelected: Boolean;
        giCurrEntryNo: Integer;
        gsCurrDocNo: Code[30];

    [Scope('Internal')]
    procedure GetEntryNo(var retDocNo: Code[20]) retEntryNo: Integer
    begin

        retEntryNo := giCurrEntryNo;
        retDocNo := gsCurrDocNo;
        CurrPage.Update();
    end;

    [Scope('Internal')]
    procedure SelectEntry()
    begin

        //SOC-MA --> remove after deleteing the calling function
        /*
        giEntryNo :="Entry No.";
        gsDocNo   := "Document No.";
        gbDocSelected := TRUE;
        CurrPage.UPDATE();
        */

    end;

    [Scope('Internal')]
    procedure SetEntryNo(EntryNo: Integer; DocumentNo: Code[30])
    begin

        giEntryNo := EntryNo;
        gsDocNo := DocumentNo;
        gbDocSelected := true;
        CurrPage.Update();
    end;
}

