codeunit 50003 "ABC Mail Extension"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Mail Management", 'OnSendViaEmailModuleOnAfterEmailSend', '', false, false)]
    local procedure MailManagementOnSendViaEmailModuleOnAfterEmailSend(var Cancelled: Boolean; var HideEmailSendingError: Boolean; var MailSent: Boolean; var Message: Codeunit "Email Message"; var TempEmailItem: Record "Email Item")
    var
        CloudStorageSalesHeader: Record "BYD Cloud Storage";
        SalesHeader: Record "Sales Header";
        Attachment: Codeunit "Temp Blob";
        Attachments: Codeunit "Temp Blob List";
        AttachmentStream: InStream;
        Index: Integer;
        SourceIDs: List of [Guid];
        SourceRelationTypes, SourceTableIDs : List of [Integer];
        AttachmentNames: List of [Text];
        BodyInStream: InStream;
        OutStr: OutStream;
    begin
        if not MailSent then
            exit;
        TempEmailItem.GetSourceDocuments(SourceTableIDs, SourceIDs, SourceRelationTypes);

        if SourceTableIDs.Get(1) <> Database::"Sales Header" then
            exit;

        if SourceRelationTypes.Get(1) <> Enum::"Sales Document Type"::Quote.AsInteger() then
            exit;

        TempEmailItem.GetAttachments(Attachments, AttachmentNames);
        if Attachments.Count() = 0 then
            exit;

        if not CloudStorageSalesHeader.Get(CloudStorageSalesHeader.Type::Dropzone, Database::"Sales Header") then
            exit;

        SalesHeader.SetLoadFields("Document Type", "No.");
        if not SalesHeader.GetBySystemId(SourceIDs.Get(1)) then
            exit;

        /*
        //only initial attachments
        for Index := 1 to Attachments.Count() do begin
            Attachments.Get(Index, Attachment);
            Attachment.CreateInStream(AttachmentStream);
            UploadToBeyondCloudConnector(AttachmentStream, AttachmentNames.Get(Index), CloudStorageSalesHeader, SalesHeader);
        end;
        */

        if Message.GetBody() <> '' then begin
            Attachment.CreateOutStream(OutStr, TextEncoding::UTF8);
            OutStr.Write(Message.GetBody());
            Attachment.CreateInStream(BodyInStream, TextEncoding::UTF8);
            UploadToBeyondCloudConnectorOrDownload(BodyInStream, 'Mail.html', CloudStorageSalesHeader, SalesHeader);
        end;

        if Message.Attachments_First() then
            repeat
                Message.Attachments_GetContent(AttachmentStream);
                UploadToBeyondCloudConnectorOrDownload(AttachmentStream, Message.Attachments_GetName(), CloudStorageSalesHeader, SalesHeader);
            until Message.Attachments_Next() = 0;
    end;

    local procedure UploadToBeyondCloudConnectorOrDownload(var AttachmentInStream: InStream; Filename: Text; CloudStorageSalesHeader: Record "BYD Cloud Storage"; SalesHeader: Record "Sales Header")
    var
        CloudStorageMgt: Codeunit "BYD Cloud Storage Mgt.";
        FileManagement: Codeunit "File Management";
        TypeHelper: Codeunit "Type Helper";
        NewFileName: Text;
        TodayFormatted: Text;
        OK: Boolean;
    begin
        TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone(DateTimeFormatLbl);
        NewFileName := StrSubstNo(FileNameLbl, FileManagement.GetFileNameWithoutExtension(FileName), TodayFormatted, FileManagement.GetExtension(FileName));
        Selected := Dialog.StrMenu(DownloadQst, 1, StrSubstNo('Upload or Download your E-Mail Attachment %1?', NewFileName));
        case selected of
            1:
                OK := DownloadFromStream(AttachmentInStream, 'Download', '', '', NewFileName);
            2:
                begin
                    Clear(CloudStorageMgt);
                    CloudStorageMgt.PerformChunkedFileUpload(AttachmentInStream, CloudStorageSalesHeader, SalesHeader.RecordId(), SalesHeader.TableCaption(), CloudStorageMgt.GetPrimaryKeyText(SalesHeader.RecordId()), NewFileName, FileManagement.GetFileNameMimeType(NewFileName));
                end;
        end;
    end;

    var
        Selected: Integer;
        DateTimeFormatLbl: Label 'dd-MM-yyyy-HH-mm-ss', Locked = true;
        FileNameLbl: Label '%1 %2.%3', Locked = true;
        DownloadQst: Label 'Download,Upload to Beyond Cloud Connector';
}