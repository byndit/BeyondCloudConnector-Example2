codeunit 50004 "ABC Install Custom Table"
{
    trigger OnRun()
    begin
        CreateDropzoneTables();
    end;

    local procedure CreateDropzoneTables()
    begin
        InsertDropzoneTable(Database::"Location");
        InsertCloudStorage(Database::"Location");
        ActivateDropzoneForAllUsers(Database::"Location");
    end;

    local procedure InsertDropzoneTable(Id: Integer)
    var
        DropzoneTable: Record "BYD Dropzone Table";
    begin
        if not DropzoneTable.Get(Id) then begin
            DropzoneTable.Init();
            DropzoneTable.ID := Id;
            DropzoneTable.Insert();
        end;
    end;

    local procedure InsertCloudStorage(Id: Integer)
    var
        CloudStorage: Record "BYD Cloud Storage";
    begin
        if not CloudStorage.Get(Id) then begin
            CloudStorage.Init();
            CloudStorage.Type := CloudStorage.Type::Dropzone;
            CloudStorage."Table ID" := Id;
            CloudStorage.Insert();
        end;
    end;

    local procedure ActivateDropzoneForAllUsers(Id: Integer)
    var
        CloudConnectorUserSetup: Record "BYD Cloud Connector User Setup";
        User: Record User;
    begin
        User.SetRange(State, User.State::Enabled);
        User.SetFilter("License Type", '%1|%2', User."License Type"::"Full User", User."License Type"::"Limited User");
        if User.FindSet() then
            repeat
                if not CloudConnectorUserSetup.Get(User."User Name", Id) then begin
                    CloudConnectorUserSetup.Init();
                    CloudConnectorUserSetup."User ID" := User."User Name";
                    CloudConnectorUserSetup."Dropzone Enabled" := true;
                    CloudConnectorUserSetup."File Preview Enabled" := true;
                    CloudConnectorUserSetup."Table No." := Id;
                    CloudConnectorUserSetup.Insert();
                end;
            until User.Next() = 0;
    end;
}