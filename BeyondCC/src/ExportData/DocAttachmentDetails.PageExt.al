pageextension 50003 "ABC Doc. Attachment Details" extends "Document Attachment Details"
{
    actions
    {
        addlast(processing)
        {
            action("ABC DownloadABCAttachment")
            {
                Caption = 'Download All Attachments from System';
                Image = MoveDown;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ExportfromAttachments: Codeunit "ABC Export from Attachments";
                begin
                    ExportfromAttachments.DownloadAllData();
                end;
            }
        }
    }
}