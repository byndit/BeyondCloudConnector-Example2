pageextension 50000 "ABC Gen. Journal" extends "General Journal"
{
    layout
    {
        addfirst(factboxes)
        {
            part(Dropzone; "BYD Dropzone Fact Box")
            {
                ApplicationArea = All;
                Visible = ShowFilePreview;
            }
            part(FilePreview; "BYD File Preview")
            {
                ApplicationArea = All;
                Provider = Dropzone;
                SubPageLink = "File No." = field("File No.");
                Visible = ShowFilePreview;
            }
        }
        addlast(Control1)
        {
            field("ABC Doc. Process Nos."; Rec."ABC Doc. Process No.")
            {
                ApplicationArea = All;
                ToolTip = 'Link this unique Document Process No. with Beyond Cloud Connector Files.';
            }
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                ShowFilePreview := true;
                InitDropZone();
            end;
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitDropZone();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitDropZone();
    end;

    local procedure InitDropZone()
    var
        DocumentProcessNo: Record "ABC Doc. Process No.";
        IntegerRec: Record Integer;
    begin
        ShowFilePreview := true;
        if Rec."ABC Doc. Process No." = '' then begin
            ShowFilePreview := false;
            IntegerRec.Get(1);
            CurrPage.FilePreview.Page.SetRecID(IntegerRec.RecordId());
            CurrPage.Dropzone.Page.SetRecID(IntegerRec.RecordId());
            CurrPage.FilePreview.Page.Activate(true);
            exit;
        end;
        if not DocumentProcessNo.Get(Rec."ABC Doc. Process No.") then
            exit;
        CurrPage.Dropzone.Page.SetRecID(DocumentProcessNo.RecordId());
        CurrPage.FilePreview.Page.SetRecID(DocumentProcessNo.RecordId());
        CurrPage.Dropzone.Page.Activate(true);
        CurrPage.FilePreview.Page.Activate(true);
    end;

    var
        ShowFilePreview: Boolean;
}