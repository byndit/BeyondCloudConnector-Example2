pageextension 50018 "ABC Location List" extends "Location List"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ABCDropzone; "BYD Dropzone Fact Box")
            {
                ApplicationArea = All;
                Visible = ABCIsDropzoneReady and ABCIsDropzoneVisible;
            }
            part(ABCFilePreview; "BYD File Preview")
            {
                ApplicationArea = All;
                Visible = ABCIsDropzoneReady and ABCIsFilePreviewVisible;
                Provider = ABCDropzone;
                SubPageLink = "File No." = field("File No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        CloudStorageMgt: Codeunit "BYD Cloud Storage Mgt.";
    begin
        ABCIsDropzoneReady := CurrPage.ABCDropzone.Page.IsDropzoneReady(Rec.RecordId().TableNo());
        ABCIsDropzoneVisible := CloudStorageMgt.DropzoneVisible(Rec.RecordId().TableNo());
        ABCIsFilePreviewVisible := CloudStorageMgt.FilePreviewVisible(Rec.RecordId().TableNo());
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        EmptyRecId: RecordId;
    begin
        if Rec.RecordId() <> EmptyRecId then
            CurrPage.Update();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ABCDropzone.Page.SetRecID(Rec.RecordId());
        CurrPage.ABCFilePreview.Page.SetRecID(Rec.RecordId());
    end;

    var
        ABCIsDropzoneReady: Boolean;
        ABCIsDropzoneVisible: Boolean;
        ABCIsFilePreviewVisible: Boolean;
}