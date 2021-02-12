pageextension 88323 CustContCreditCard extends "Cust./Cont. Credit Cards -CL-"
{
    layout
    {
    }

    actions
    {
        addafter("&Credit Card")
        {
            action(New)
            {
                Caption = 'New Card';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreditCard;
                trigger OnAction()
                var
                    CreditCardPage: Page "Credit Card Lookup -CL-";
                begin
                    CreditCardPage.SetCustomerNo := GETFILTER("Customer No. Filter");
                    CreditCardPage.SetContactNo := GETFILTER("Contact No. Filter");
                    CreditCardPage.RUNMODAL;
                    Populate;
                end;
            }
        }
    }
}