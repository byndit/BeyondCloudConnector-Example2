page 50000 "ABC General Setup"
{
    ApplicationArea = All;
    Caption = 'General Setup';
    PageType = Card;
    SourceTable = "ABC General Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                caption = 'General';

                field("Doc. Process Nos."; Rec."Doc. Process Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Process Nos. field';
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
