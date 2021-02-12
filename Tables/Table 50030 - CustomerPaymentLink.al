table 50030 "Customer Payment Link"
{
    // //SOC-SC 08-24-15
    //   Fixing Remaining Discount
    // 
    // //SOC-SC 12-17-15
    //   Added field
    //     150;Manual Discount Amount;Decimal
    //   Changed DecimalPlaces peoperty of "Discount %" from Undefined to '0:7'
    // 
    // //SOC-SC 12-23-15
    //   Added boolean parameter to UpdateRequestedDiscount()
    //   Calculate Discount Percent based on request on Payment CLE
    // 
    // //SOC-SC 12-29-15
    //   If "Manual Discount Amount" is entered, the calculation is based on this instead of "Discount Percent"
    // 
    // //SOC-SC 01-07-16
    //   Fix for the penny differnce when the user hits F7 key on the Customer Payment Links screen
    // 
    // //SOC-SC 01-11-16
    // //SOC-SC 01-14-16
    //   Fix for penny diff
    // 
    // //SOC-SC 03-18-16
    //   Adding key to speed up opening the screen
    // 
    // //SOC-SC 03-31-16
    //   Added key: Customer No.,Request,Invoice No.
    // 
    // //SOC-SC 04-13-16
    //   Calculate Discount Percent only if Payment CLE has "Requested Spring Amount" or "Requested Fall Amount" filled in, as applicable

    DrillDownPageID = "Customer Payment Links";
    LookupPageID = "Customer Payment Links";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                TestField(Request, false);
            end;
        }
        field(11; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Cust. Ledger Entry"."Document No." WHERE("Document Type" = CONST(Invoice),
                                                                       "Customer No." = FIELD("Customer No."));

            trigger OnValidate()
            begin
                TestField(Request, false);
            end;
        }
        field(12; Request; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Requested Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Request, true);
                //UpdateRequestedDiscount(); //SOC-SC 12-23-15 COMMENTED

                //SOC-SC 12-23-15
                TestAndUpdateCLEReqAmount(CurrFieldNo);
                UpdateRequestedDiscount(false); //added parameter
                //SOC-SC 12-23-15
            end;
        }
        field(14; "Linked Amount"; Decimal)
        {
            CalcFormula = Sum("Customer Payment Link"."Amount to Link" WHERE("Payment CLE No." = FIELD("Payment CLE No."),
                                                                              Request = FILTER(false),
                                                                              "Season Code" = FIELD("Season Code"),
                                                                              Cancelled = FILTER(false)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Order Exists"; Boolean)
        {
            CalcFormula = Exist("Sales Header" WHERE("Document Type" = CONST(Order),
                                                      "No." = FIELD("Order No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Invoiced Qty. on Order"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Quantity Invoiced" WHERE("Document Type" = FILTER(Order),
                                                                      "Document No." = FIELD("Order No."),
                                                                      Type = CONST(Item),
                                                                      Quantity = FILTER(> 0)));
            Description = 'FF';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(17; "Remaining Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'for Requests';

            trigger OnValidate()
            begin
                TestField(Request, true);
                UpdateRemainingDiscount();
            end;
        }
        field(18; "Remaining Discount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'for Requests';
        }
        field(19; "Potential Remaining Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'for Requests; Calculated';
            Editable = false;
        }
        field(20; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Outstanding Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                CalculateNeededPmtAmt();
            end;
        }
        field(30; "Payment Date"; Date)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalculateDiscountPc();
            end;
        }
        field(31; "Season Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Season Code";

            trigger OnValidate()
            begin
                CalculateDiscountPc();
            end;
        }
        field(32; "Grace Period Days"; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalculateDiscountPc();
            end;
        }
        field(33; "Discount %"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 7;

            trigger OnValidate()
            begin
                if not Request then begin
                    CheckBeforeChange();
                    TestField("Amount to Link", 0);
                    CalculateNeededPmtAmt();
                end else begin
                    UpdateRequestedDiscount(false); //SOC-SC 12-23-15
                    UpdateRemainingDiscount();
                end;
            end;
        }
        field(34; "Max Possible Amount to Apply"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(35; "Amount to Link"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                recCustPmtLink: Record "Customer Payment Link";
            begin
                CheckBeforeChange();

                if "Payment CLE No." = 0 then
                    Error('Please select Payment Entry and try again');

                if "Amount to Link" > "Max Possible Amount to Apply" then
                    Error('Amount to Link cannot be greater than %1', "Max Possible Amount to Apply");

                if "Amount to Link" <> 0 then begin
                    recCustPmtLink.Reset();
                    recCustPmtLink.SetRange("Customer No.", "Customer No.");
                    recCustPmtLink.SetRange("Parent Line No.", "Line No.");
                    if recCustPmtLink.Count > 0 then begin
                        Error('Cannot change Amount to Link, as there are entries for this order/ invoice');// already linked');
                    end;
                end;

                //If same payment is already linked (not applied) to another line for this order/invoice, then error out
                if "Amount to Link" <> 0 then begin
                    recCustPmtLink.Reset();
                    recCustPmtLink.SetRange(Request, false);
                    recCustPmtLink.SetRange("Customer No.", "Customer No.");
                    recCustPmtLink.SetRange("Order No.", "Order No.");
                    recCustPmtLink.SetRange("Invoice No.", "Invoice No.");
                    recCustPmtLink.SetFilter("Line No.", '<>%1', "Line No.");
                    recCustPmtLink.SetRange("Payment CLE No.", "Payment CLE No.");
                    recCustPmtLink.SetFilter("Amount to Link", '>%1', 0);
                    recCustPmtLink.SetRange("Amount Applied", 0);
                    if recCustPmtLink.FindFirst() then begin
                        Error('Same payment has already been linked to this Order/ Invoice');
                    end;
                end;

                UpdateEffectiveAmtToLink();

                UpdateSeasonalRemainingAmt_AtLinking(Rec, xRec);
            end;
        }
        field(36; "Discount Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = '100 divided by (100-Discount percent)';
            Editable = false;
        }
        field(37; "Effective Amount to Link"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'More than Amount to Link';
            Editable = false;

            trigger OnValidate()
            begin
                "Effective Discount Amt to Link" := "Effective Amount to Link" - "Amount to Link";
                Validate("Remaining Ord-Inv Amt to Link", "Outstanding Amount" - "Effective Amount to Link");
            end;
        }
        field(38; "Remaining Ord-Inv Amt to Link"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'Outstanding Amount - Effective Amount to Link';
            Editable = false;

            trigger OnValidate()
            var
                recCustPmtLink: Record "Customer Payment Link";
                CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
            begin
                recCustPmtLink.Reset();
                recCustPmtLink.SetRange(Request, false);
                recCustPmtLink.SetRange("Customer No.", "Customer No.");
                recCustPmtLink.SetRange("Order No.", "Order No.");
                recCustPmtLink.SetRange("Invoice No.", "Invoice No.");
                recCustPmtLink.SetFilter("Line No.", '>%1', "Line No.");
                recCustPmtLink.SetFilter("Amount to Link", '>%1', 0);
                recCustPmtLink.SetRange("Amount Applied", 0);
                if "Parent Line No." > 0 then begin
                    recCustPmtLink.SetRange("Parent Line No.", "Parent Line No.");
                end else begin
                    recCustPmtLink.SetRange("Parent Line No.", "Line No.");
                end;
                recCustPmtLink.SetRange(Processed, false);
                recCustPmtLink.SetRange(Cancelled, false);
                if recCustPmtLink.Count > 0 then
                    Error('There are more links for this Order/Invoice after this link. Please un-link them and try again');

                if "Amount to Link" = 0 then begin
                    recCustPmtLink.SetRange("Amount to Link", 0);
                    recCustPmtLink.SetFilter("Line No.", '>%1', "Line No.");
                    if "Parent Line No." = 0 then begin
                        recCustPmtLink.SetRange("Parent Line No.", "Line No.");
                    end else begin
                        recCustPmtLink.SetRange("Parent Line No.", "Parent Line No.");
                    end;
                    if recCustPmtLink.FindSet() then begin
                        recCustPmtLink.DeleteAll();
                    end;
                    //VALIDATE("Payment CLE No.", 0);
                end else begin
                    if ("Remaining Ord-Inv Amt to Link" > 0) then begin
                        SplitLine();
                    end;
                end;
            end;
        }
        field(39; "Effective Discount Amt to Link"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Invoice CLE No."; Integer)
        {

            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField(Request, false);
            end;
        }
        field(41; "Invoice Payment Terms Code"; Code[10])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalculateDiscountPc();
            end;
        }
        field(42; "Invoice CLE Open"; Boolean)
        {
            CalcFormula = Exist("Cust. Ledger Entry" WHERE("Entry No." = FIELD("Invoice CLE No."),
                                                            Open = FILTER(true)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Payment CLE No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                if "Payment CLE No." = 0 then begin
                    "Payment Date" := 0D;
                    "Pmt Entry No. In Process" := 0;
                    "Pmt. Remaining Amount" := 0;
                end;
            end;
        }
        field(51; Processed; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(52; "Amount Applied"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(55; Cancelled; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Pmt Entry No. In Process"; Integer)
        {
        }
        field(61; "Pmt. Remaining Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                CalculateNeededPmtAmt();
            end;
        }
        field(62; "Pmt Amount Linked"; Decimal)
        {
            CalcFormula = Sum("Customer Payment Link"."Amount to Link" WHERE("Payment CLE No." = FIELD("Payment CLE No."),
                                                                              "Invoice CLE No." = FILTER(0),
                                                                              Cancelled = FILTER(false),
                                                                              Processed = FILTER(false)));
            Description = 'SOC FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Parent Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(66; "Inv CLE Applied Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Invoice CLE No."),
                                                                         "Entry Type" = CONST(Application)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Requested Discount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                /*//SOC-SC 12-29-15 commenting
                UpdateRequestedDiscount(TRUE); //SOC-SC 12-23-15
                */

                "Remaining Discount" := "Requested Discount"; //SOC-SC 12-29-15

            end;
        }
        field(150; "Manual Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                dDiscPercent: Decimal;
            begin
                //SOC-SC 12-16-15
                if "Outstanding Amount" <> 0 then
                    dDiscPercent := ("Manual Discount Amount" / "Outstanding Amount") * 100;

                Validate("Discount %", dDiscPercent);
            end;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount to Link";
        }
        key(Key2; "Customer No.", "Order No.", "Invoice No.")
        {
        }
        key(Key3; "Invoice CLE No.", Processed)
        {
            SumIndexFields = "Amount to Link";
        }
        key(Key4; "Payment CLE No.", Request, Cancelled, "Season Code")
        {
            SumIndexFields = "Amount to Link";
        }
        key(Key5; "Customer No.", Request, "Invoice No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Processed, false);
        TestField(Cancelled, false);
    end;

    [Scope('Internal')]
    procedure CalculateNeededPmtAmt()
    var
        dNeededAmt: Decimal;
    begin
        //dNeededAmt := ROUND("Outstanding Amount" * (1-"Discount %"/100), 0.01); //SOC-SC 12-29-15 commenting

        //SOC-SC 12-29-15
        if "Manual Discount Amount" = 0 then begin
            dNeededAmt := Round("Outstanding Amount" * (1 - "Discount %" / 100), 0.01);
        end else begin
            dNeededAmt := "Outstanding Amount" - "Manual Discount Amount";
        end;
        //SOC-SC 12-29-15

        if dNeededAmt < "Pmt. Remaining Amount" then begin
            "Max Possible Amount to Apply" := dNeededAmt;
        end else begin
            "Max Possible Amount to Apply" := "Pmt. Remaining Amount";
        end;

        if "Discount %" = 100 then begin
            "Discount Factor" := 0;
        end else begin
            "Discount Factor" := Round(100 / (100 - "Discount %"), 0.0000000001); //0.00001); //SOC-SC 01-14-16
        end;
    end;

    [Scope('Internal')]
    procedure CalculateDiscountPc()
    var
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        dDiscountPc: Decimal;
    begin
        dDiscountPc := 0;
        if ("Payment Date" <> 0D) and ("Season Code" <> '') then begin
            //dDiscountPc := CustPmtLinkMgt.GetDiscountPc("Season Code", "Grace Period Days", "Payment Date", "Invoice Payment Terms Code"); //SOC-SC 12-23-15 commenting

            //SOC-SC 12-23-15
            GetReqDiscPc("Payment CLE No.", "Season Code", "Invoice Payment Terms Code", dDiscountPc);
            if dDiscountPc = 0 then begin
                if OKToCalculateDiscPc("Payment CLE No.", "Season Code") then //SOC-SC 04-13-16 Added IF statement
                    dDiscountPc := CustPmtLinkMgt.GetDiscountPc("Season Code", "Grace Period Days", "Payment Date", "Invoice Payment Terms Code");
            end;
            //SOC-SC 12-23-15

        end;
        Validate("Discount %", dDiscountPc);
    end;

    [Scope('Internal')]
    procedure UpdateEffectiveAmtToLink()
    var
        dAmt: Decimal;
        dExtra: Decimal;
        dDifference: Decimal;
    begin
        //dAmt := "Amount to Link" * ROUND(100/(100 - "Discount %"), 0.00001); //SOC-SC 01-07-16 commenting

        /*
        //SOC-SC 01-07-16
        IF "Amount to Link" = "Outstanding Amount" THEN BEGIN
          dAmt := "Amount to Link";
        END ELSE BEGIN
          //dAmt := "Amount to Link" * ROUND(100/(100 - "Discount %"), 0.00001);
          dAmt := "Amount to Link" * ROUND(100/(100 - "Discount %"), 0.0000000001); //SOC-SC 01-11-16
        END;
        //SOC-SC 01-07-16
        IF dAmt > "Outstanding Amount" THEN
          dAmt := "Outstanding Amount";
        */

        //SOC-SC 01-14-16
        dAmt := "Amount to Link" * Round(100 / (100 - "Discount %"), 0.0000000001);
        if dAmt > "Outstanding Amount" then begin
            dAmt := "Outstanding Amount";
        end;
        //SOC-SC 01-14-16

        Validate("Effective Amount to Link", Round(dAmt, 0.01));

    end;

    [Scope('Internal')]
    procedure SplitLine()
    var
        recCustPmtLink: Record "Customer Payment Link";
        iLineNo: Integer;
    begin
        recCustPmtLink.Reset();
        recCustPmtLink.SetRange(Request, false);
        recCustPmtLink.SetRange("Customer No.", "Customer No.");
        recCustPmtLink.SetFilter("Line No.", '>%1', "Line No.");
        if "Parent Line No." = 0 then begin
            recCustPmtLink.SetRange("Parent Line No.", "Line No.");
        end else begin
            recCustPmtLink.SetRange("Parent Line No.", "Parent Line No.");
        end;
        recCustPmtLink.SetRange("Amount to Link", 0);
        recCustPmtLink.SetRange(Processed, false);
        recCustPmtLink.SetRange(Cancelled, false);
        if recCustPmtLink.FindSet() then begin
            recCustPmtLink.DeleteAll();
        end;

        recCustPmtLink.Reset();
        recCustPmtLink.SetRange("Customer No.", "Customer No.");
        recCustPmtLink.FindLast();
        iLineNo := recCustPmtLink."Line No.";

        recCustPmtLink.Init();
        recCustPmtLink."Customer No." := "Customer No.";
        recCustPmtLink."Line No." := iLineNo + 1;
        recCustPmtLink."Order No." := "Order No.";
        recCustPmtLink."Invoice No." := "Invoice No.";
        recCustPmtLink.Amount := Amount;
        recCustPmtLink."Outstanding Amount" := "Remaining Ord-Inv Amt to Link";
        recCustPmtLink."Season Code" := "Season Code";
        recCustPmtLink."Grace Period Days" := "Grace Period Days";
        recCustPmtLink."Invoice CLE No." := "Invoice CLE No.";
        if "Parent Line No." <> 0 then begin
            recCustPmtLink."Parent Line No." := "Parent Line No.";
        end else begin
            recCustPmtLink."Parent Line No." := "Line No.";
        end;
        recCustPmtLink."Invoice Payment Terms Code" := "Invoice Payment Terms Code";
        recCustPmtLink.Insert();
    end;

    procedure CheckBeforeChange()
    begin
        //TESTFIELD("Amount Applied", 0);
        TestField(Processed, false);
        TestField(Cancelled, false);
    end;

    procedure UpdateSeasonalRemainingAmt_AtLinking(var CustPmtLink: Record "Customer Payment Link"; var xCustPmtLink: Record "Customer Payment Link")
    var
        recPmtCLE: Record "Cust. Ledger Entry";
        dLinkedAmt: Decimal;
        recReqPmtCustLink: Record "Customer Payment Link";
        dMaxRem: Decimal;
        dRemAmt: Decimal;
    begin
        recPmtCLE.Get(CustPmtLink."Payment CLE No.");
        recPmtCLE.CalcFields("Linked Seasonal Amount", "Remaining Amount");

        dMaxRem := -recPmtCLE."Remaining Amount";
        dLinkedAmt := recPmtCLE."Linked Seasonal Amount" + CustPmtLink."Amount to Link" - xCustPmtLink."Amount to Link";
        //MESSAGE('Total linked seasonal amount is %1', dAmt); //recPmtCLE."Linked Seasonal Amount");

        UpdateSeasonalRemainingAmt(recPmtCLE."Entry No.", dMaxRem);
        /*
        recReqPmtCustLink.RESET();
        recReqPmtCustLink.SETRANGE("Payment CLE No.", recPmtCLE."Entry No.");
        recReqPmtCustLink.SETRANGE(Request, TRUE);
        IF recReqPmtCustLink.FINDSET THEN BEGIN
        
          REPEAT
            IF (dMaxRem <= 0) THEN BEGIN
              dMaxRem   := 0;
              dRemAmt   := 0;
            END ELSE BEGIN
              recReqPmtCustLink.CALCFIELDS("Linked Amount");
              dRemAmt := (recReqPmtCustLink."Requested Amount" - recReqPmtCustLink."Linked Amount");
              IF dRemAmt > dMaxRem THEN BEGIN
                dRemAmt := dMaxRem;
              END;
        
              IF dRemAmt <= 0 THEN
                dRemAmt := 0;
            END;
        
            recReqPmtCustLink.VALIDATE("Remaining Amount", dRemAmt);
            recReqPmtCustLink.MODIFY();
            dMaxRem -= dRemAmt;
          UNTIL recReqPmtCustLink.NEXT = 0;
        END;
        */

    end;

    [Scope('Internal')]
    procedure UpdateSeasonalRemainingAmt(PmtCLEEntryNo: Integer; MaxRem: Decimal)
    var
        dLinkedAmt: Decimal;
        recReqPmtCustLink: Record "Customer Payment Link";
        dRemAmt: Decimal;
    begin
        recReqPmtCustLink.Reset();
        recReqPmtCustLink.SetCurrentKey("Payment CLE No.", Request, Cancelled, "Season Code"); //SOC-SC 03-18-16
        recReqPmtCustLink.SetRange("Payment CLE No.", PmtCLEEntryNo);
        recReqPmtCustLink.SetRange(Request, true);
        if recReqPmtCustLink.FindSet then begin

            repeat
                if (MaxRem <= 0) then begin
                    MaxRem := 0;
                    dRemAmt := 0;
                end else begin
                    recReqPmtCustLink.CalcFields("Linked Amount");
                    dRemAmt := (recReqPmtCustLink."Requested Amount" - recReqPmtCustLink."Linked Amount");
                    if dRemAmt > MaxRem then begin
                        dRemAmt := MaxRem;
                    end;

                    if dRemAmt <= 0 then
                        dRemAmt := 0;
                end;

                recReqPmtCustLink.Validate("Remaining Amount", dRemAmt);
                recReqPmtCustLink.Modify();
                MaxRem -= dRemAmt;
            until recReqPmtCustLink.Next = 0;
        end;
    end;

    procedure UpdateRemainingDiscount()
    var
        dDiscountAmt: Decimal;
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        dPotentialValueOfAmt: Decimal;
    begin
        TestField(Request, true);
        /* //SOC-SC 08-24-15 commenting
        IF "Discount %" <> 0 THEN BEGIN
          dDiscountAmt     := ROUND("Discount %" * "Remaining Amount"/100, 0.01);
        END ELSE BEGIN
          dDiscountAmt     := 0;
        END;
        "Remaining Discount"         := dDiscountAmt;
        "Potential Remaining Amount" := "Remaining Amount" + "Remaining Discount";
        */ //SOC-SC 08-24-15

        //SOC-SC 08-24-15
        dPotentialValueOfAmt := CustPmtLinkMgt.GetPotentialAmt("Discount %", "Remaining Amount", dDiscountAmt);
        "Remaining Discount" := dDiscountAmt;
        "Potential Remaining Amount" := "Remaining Amount" + "Remaining Discount";
        //SOC-SC 08-24-15

    end;

    procedure UpdateRequestedDiscount(CalculatePercent: Boolean)
    var
        dDiscountAmt: Decimal;
        dRatio: Decimal;
        dValue: Decimal;
        CustPmtLinkMgt: Codeunit "Cust. Payment Link Mgt.";
        dPotentialValueOfAmt: Decimal;
        dDiscountPc: Decimal;
    begin
        TestField(Request, true);
        /*dPotentialValueOfAmt := CustPmtLinkMgt.GetPotentialAmt("Discount %", "Requested Amount", dDiscountAmt);
        "Requested Discount" := dDiscountAmt;
        */ //SOC-SC 12-23-15 commenting

        //SOC-SC 12-23-15 new code
        if CalculatePercent then begin
            dDiscountPc := GetDiscPercent("Requested Amount", "Requested Discount");
            "Discount %" := dDiscountPc;
        end else begin
            dPotentialValueOfAmt := CustPmtLinkMgt.GetPotentialAmt("Discount %", "Requested Amount", dDiscountAmt);
            "Requested Discount" := dDiscountAmt;
        end;

    end;

    procedure GetDiscPercent(Amount: Decimal; DiscountAmt: Decimal) DiscountPc: Decimal
    begin
        //SOC-SC 12-23-15
        if Amount = 0 then begin
            DiscountPc := 0;
        end else begin
            //(1-((Amt-DisAmt)/Amt))*100
            DiscountPc := Round((1 - ((Amount - DiscountAmt) / Amount)) * 100, 0.0001);
        end;
    end;

    procedure TestAndUpdateCLEReqAmount(iFieldNo: Integer)
    var
        recCLE: Record "Cust. Ledger Entry";
        dPrevReqAmt: Decimal;
    begin
        //SOC-SC 12-23-15
        if iFieldNo = FieldNo("Requested Amount") then begin
            recCLE.Get("Payment CLE No.");
            recCLE.CalcFields("Original Amount");
            case "Season Code" of
                'SPRING':
                    dPrevReqAmt := recCLE."Requested Fall Amount";
                'FALL':
                    dPrevReqAmt := recCLE."Requested Spring Amount";
            end;

            if (dPrevReqAmt + "Requested Amount") > -recCLE."Original Amount" then
                Error('Requested Amount cannot be more than %1', (-recCLE."Original Amount" - dPrevReqAmt));

            case "Season Code" of
                'SPRING':
                    recCLE."Requested Spring Amount" := "Requested Amount";
                'FALL':
                    recCLE."Requested Fall Amount" := "Requested Amount";
            end;
            recCLE.Modify();
        end;
    end;

    procedure GetReqDiscPc(PmtCLENo: Integer; SeasonCode: Code[20]; PmtTermsCode: Code[10]; var retDiscPc: Decimal)
    var
        recCustPmtLink: Record "Customer Payment Link";
        recPmtTerms: Record "Payment Terms";
    begin
        //SOC-SC 12-23-15
        retDiscPc := 0;
        if recPmtTerms.Get(PmtTermsCode) then begin
            if recPmtTerms."Allow Seasonal Cash Discount" then begin

                recCustPmtLink.Reset();
                recCustPmtLink.SetRange(Request, true);
                recCustPmtLink.SetRange("Payment CLE No.", PmtCLENo);
                recCustPmtLink.SetRange("Season Code", SeasonCode);
                if recCustPmtLink.FindFirst() then begin
                    retDiscPc := recCustPmtLink."Discount %";
                end;

            end;
        end;
    end;

    procedure OKToCalculateDiscPc(PmtCLENo: Integer; SeasonCode: Code[20]) retOKToCaculateDiscountPc: Boolean
    var
        recPmtCLE: Record "Cust. Ledger Entry";
        bCaculateDiscountPc: Boolean;
    begin
        //SOC-SC 04-13-16
        retOKToCaculateDiscountPc := false;
        if recPmtCLE.Get(PmtCLENo) then begin
            case SeasonCode of
                'SPRING':
                    begin
                        if recPmtCLE."Requested Spring Amount" > 0 then
                            retOKToCaculateDiscountPc := true;
                    end;
                'FALL':
                    begin
                        if recPmtCLE."Requested Fall Amount" > 0 then
                            retOKToCaculateDiscountPc := true;
                    end;
            end;
        end;
    end;
}

