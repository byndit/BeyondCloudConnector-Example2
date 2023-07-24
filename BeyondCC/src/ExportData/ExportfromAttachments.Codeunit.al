codeunit 50006 "ABC Export from Attachments"
{
    procedure DownloadAllData()
    var
        TempBlob: Codeunit "Temp Blob";
        DocumentAttachment: Record "Document Attachment";
        DataCompression: Codeunit "Data Compression";
        ZipOutStream: OutStream;
        ZipInStream: InStream;
        ZipFileName: Text[50];
        DocumentStream: OutStream;
        ServerFileInStream: InStream;
        JObject: JsonObject;
        RecRef: RecordRef;
    begin
        if DocumentAttachment.IsEmpty() then
            exit;

        ZipFileName := 'Attachments_' + Format(CurrentDateTime) + '.zip';
        DataCompression.CreateZipArchive();

        DocumentAttachment.FindSet();
        repeat
            if DocumentAttachment."Document Reference ID".HasValue() then begin
                clear(TempBlob);
                Clear(DocumentStream);
                Clear(ServerFileInStream);
                TempBlob.CreateOutStream(DocumentStream);
                DocumentAttachment."Document Reference ID".ExportStream(DocumentStream);
                TempBlob.CreateInStream(ServerFileInStream);
                DataCompression.AddEntry(ServerFileInStream, DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension");
            end;

            if not TempDocumentAttachment.Get(DocumentAttachment.RecordId()) then begin
                RecRef.Open(DocumentAttachment."Table ID");
                SetDocumentAttachmentFiltersForRecRef(DocumentAttachment, RecRef, JObject);
                RecRef.Close();
            end;
        until DocumentAttachment.Next() = 0;

        clear(TempBlob);
        Clear(DocumentStream);
        Clear(ServerFileInStream);
        TempBlob.CreateOutStream(DocumentStream);
        JObject.WriteTo(DocumentStream);
        TempBlob.CreateInStream(ServerFileInStream);
        DataCompression.AddEntry(ServerFileInStream, BCCFileNameTok);

        TempBlob.CreateOutStream(ZipOutStream);
        DataCompression.SaveZipArchive(ZipOutStream);
        DataCompression.CloseZipArchive();
        TempBlob.CreateInStream(ZipInStream);
        DownloadFromStream(ZipInStream, '', '', '', ZipFileName);
    end;

    local procedure SetDocumentAttachmentFiltersForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var JObject: JsonObject)
    var
        DocumentAttachment2: Record "Document Attachment";
        JObjectKey: Text;
        JFiles: JsonArray;
    begin
        DocumentAttachment2.Reset();
        DocumentAttachment2.SetRange("Table ID", RecRef.Number());
        case RecRef.Number() of
            DATABASE::Customer,
            DATABASE::Vendor,
            DATABASE::Item,
            DATABASE::Employee,
            DATABASE::"Fixed Asset",
            DATABASE::Resource,
            DATABASE::Job:
                begin
                    DocumentAttachment2.SetRange("No.", DocumentAttachment."No.");
                    JObjectKey := StrSubstNo('%1: %2', RecRef.Name, DocumentAttachment."No.");
                end;
        end;
        case RecRef.Number() of
            DATABASE::"Sales Header",
            DATABASE::"Purchase Header",
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    DocumentAttachment2.SetRange("Document Type", DocumentAttachment."Document Type");
                    DocumentAttachment2.SetRange("No.", DocumentAttachment."No.");
                    if DocumentAttachment."Line No." = 0 then
                        JObjectKey := StrSubstNo('%1: %2,%3', RecRef.Name, format(DocumentAttachment."Document Type", 0, 2), DocumentAttachment."No.");
                end;
        end;
        case RecRef.Number() of
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    DocumentAttachment2.SetRange("Line No.", DocumentAttachment."Line No.");
                    JObjectKey := StrSubstNo('%1: %2,%3,%4', RecRef.Name, format(DocumentAttachment."Document Type", 0, 2), DocumentAttachment."No.", DocumentAttachment."Line No.");
                end;
        end;
        case RecRef.Number() of
            DATABASE::"Sales Invoice Header",
            DATABASE::"Sales Invoice Line",
            DATABASE::"Sales Cr.Memo Header",
            DATABASE::"Sales Cr.Memo Line",
            DATABASE::"Purch. Inv. Header",
            DATABASE::"Purch. Inv. Line",
            DATABASE::"Purch. Cr. Memo Hdr.",
            DATABASE::"Purch. Cr. Memo Line":
                begin
                    DocumentAttachment2.SetRange("No.", DocumentAttachment."No.");
                    if DocumentAttachment."Line No." <> 0 then
                        JObjectKey := StrSubstNo('%1: %2,%3', RecRef.Name, DocumentAttachment."No.", DocumentAttachment."Line No.")
                    else
                        JObjectKey := StrSubstNo('%1: %2', RecRef.Name, DocumentAttachment."No.");
                end;
        end;
        if DocumentAttachment2.FindSet() then begin
            Clear(JFiles);
            repeat
                TempDocumentAttachment := DocumentAttachment2;
                TempDocumentAttachment.Insert();
                JFiles.Add(DocumentAttachment2."File Name" + '.' + DocumentAttachment2."File Extension");
            until DocumentAttachment2.Next() = 0;
            JObject.Add(JObjectKey, JFiles);
        end;
    end;

    var
        TempDocumentAttachment: Record "Document Attachment" temporary;
        bccFileNameTok: Label 'beyondcloudconnector.json', Locked = true;
}