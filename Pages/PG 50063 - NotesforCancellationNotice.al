page 50063 "Notes for Cancellation Notice"
{
    // //SOC-SC 09-25-14
    //   Added field "Print on Cancellation Notice"
    // 
    // //Orig: page 124
    // 
    // //SOC-MD 01-03-16
    //   Added field "Copy to Product"
    //   Modified OnInsertRecord to make the field checked
    //   Created function CopyCommentLine

    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Comment Line";
    SourceTableTemporary = true;
    SourceTableView = WHERE("Table Name" = CONST(Item),
                            "Print on Cancellation Notice" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
                field("Code"; Code)
                {
                }
                field("Include in E-Mail"; "Include in E-Mail")
                {
                    Visible = false;
                }
                field("Print on Cancellation Notice"; "Print on Cancellation Notice")
                {
                }
                field("Copy to Items of Same Product"; "Copy to Items of Same Product")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Copy Comments")
            {
                Caption = 'Copy Comments';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CopyCommentLine;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        recItem: Record Item;
    begin
        if "Table Name" = "Table Name"::Item then begin
            if gsInventoryStatusCode <> '' then begin
                Code := gsInventoryStatusCode;
            end else begin
                if recItem.Get("No.") then begin
                    Code := recItem."Inventory Status Code";
                end;
            end;
        end;
        "Print on Cancellation Notice" := true;
        "Copy to Items of Same Product" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;

    var
        gsInventoryStatusCode: Code[10];

    [Scope('Internal')]
    procedure SetInventoryStatusCode(InventoryStatusCode: Code[10])
    begin
        gsInventoryStatusCode := InventoryStatusCode;
    end;

    [Scope('Internal')]
    procedure CopyCommentLine()
    var
        recItem: Record Item;
        cProductCode: Code[10];
        recCommentLine: Record "Comment Line";
        recCommentLine2: Record "Comment Line";
        iLineNo: Integer;
        cNo: Code[20];
    begin

        CurrPage.SetSelectionFilter(recCommentLine);
        iLineNo := 0;
        if recItem.Get("No.") then begin
            cProductCode := recItem."Product Code";
            cNo := recItem."No.";
        end;

        if cProductCode <> '' then begin
            recItem.Reset();
            recItem.SetRange("Product Code", cProductCode);
            if recItem.FindSet() then begin

                repeat
                    if recItem."No." <> cNo then begin
                        //recCommentLine.SETRANGE("Table Name","Table Name"::Item);
                        recCommentLine.SetRange("Copy to Items of Same Product", true);
                        recCommentLine.SetRange("Print on Cancellation Notice", true);
                        recCommentLine.FindSet();

                        repeat
                            iLineNo := iLineNo + 10000;
                            recCommentLine2.Init();
                            recCommentLine2."Table Name" := recCommentLine2."Table Name"::Item;
                            recCommentLine2."No." := recItem."No.";
                            recCommentLine2."Line No." := iLineNo;
                            recCommentLine2.Date := recCommentLine.Date;
                            recCommentLine2.Comment := recCommentLine.Comment;
                            recCommentLine2.Code := recCommentLine.Code;
                            recCommentLine2."Print on Cancellation Notice" := recCommentLine."Print on Cancellation Notice";
                            recCommentLine2."Copy to Items of Same Product" := recCommentLine."Copy to Items of Same Product";
                            recCommentLine2.Insert(true);
                        until recCommentLine.Next = 0;
                    end;
                until recItem.Next = 0;
            end;
        end;

        Message('Copy Completed');
    end;
}

