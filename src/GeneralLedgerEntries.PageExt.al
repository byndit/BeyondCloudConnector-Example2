pageextension 50002 "LOW General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addfirst(factboxes)
        {
            part(Dropzone; "BYD Dropzone Fact Box")
            {
                ApplicationArea = All;
            }
            part(FilePreview; "BYD File Preview")
            {
                ApplicationArea = All;
                Provider = Dropzone;
                SubPageLink = "File No." = field("File No.");
            }
        }
        addlast(content)
        {
            field("ABC Doc. Process Nos."; Rec."ABC Doc. Process No.")
            {
                ApplicationArea = All;
                ToolTip = 'Link this unique Document Process No. with Beyond Cloud Connector Files.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        InitDropZone;
    end;

    local procedure InitDropZone()
    var
        DocumentProcessNo: Record "ABC Doc. Process No.";
        EmptyRecId: RecordId;
    begin
        if not DocumentProcessNo.Get(Rec."ABC Doc. Process No.") then
            clear(DocumentProcessNo);
        CurrPage.Dropzone.Page.SetRecID(DocumentProcessNo.RecordId());
        CurrPage.FilePreview.Page.SetRecID(DocumentProcessNo.RecordId());
        CurrPage.Dropzone.Page.Activate(true);
        CurrPage.FilePreview.Page.Activate(true);
    end;
}