pageextension 50100 "ABC Pay. Prop. Lines" extends "OPP Payment Proposal Lines"
{
    layout
    {
        addfirst(factboxes)
        {
            part(BYDDropzone; "BYD Dropzone Fact Box")
            {
                ApplicationArea = All;
                Visible = BYDIsDropzoneReady and BYDIsDropzoneVisible;
            }
            part(BYDFilePreview; "BYD File Preview")
            {
                ApplicationArea = All;
                Visible = BYDIsDropzoneReady and BYDIsFilePreviewVisible;
                Provider = BYDDropzone;
                SubPageLink = "File No." = field("File No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        CloudStorageMgt: Codeunit "BYD Cloud Storage Mgt.";
    begin
        BYDIsDropzoneReady := CurrPage.BYDDropzone.Page.IsDropzoneReady(Database::"Purch. Inv. Header");
        BYDIsDropzoneVisible := CloudStorageMgt.DropzoneVisible(Database::"Purch. Inv. Header");
        BYDIsFilePreviewVisible := CloudStorageMgt.FilePreviewVisible(Database::"Purch. Inv. Header");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        EmptyRecId: RecordId;
    begin
        if Rec.RecordId() = EmptyRecId then
            CurrPage.Update();
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchInvHeader.SetLoadFields("No.");
        if rec."Account Type" = rec."Account Type"::Vendor then
            if Rec."Applies-to Doc. Type" = Rec."Applies-to Doc. Type"::Invoice then begin
                PurchInvHeader.Get(Rec."Applies-to Doc. No.");
                CurrPage.BYDDropzone.Page.SetRecID(PurchInvHeader.RecordId());
                CurrPage.BYDFilePreview.Page.SetRecID(PurchInvHeader.RecordId());
            end;
    end;

    var
        BYDIsDropzoneReady: Boolean;
        BYDIsDropzoneVisible: Boolean;
        BYDIsFilePreviewVisible: Boolean;
}