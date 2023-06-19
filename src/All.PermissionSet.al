permissionset 50000 "All ABC Admin"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All permissions for ABC App', Locked = true;

    Permissions =
         codeunit "ABC Custom Cloud Events" = X,
         codeunit "ABC Custom Cloud Mgt." = X,
         codeunit "ABC Install Custom Connector" = X,
         codeunit "ABC Install Custom Table" = X,
         codeunit "ABC Mail Extension" = X,
         codeunit "ABC On Install" = X,
         page "ABC General Setup" = X,
         table "ABC Doc. Process No." = X,
         table "ABC General Setup" = X,
         tabledata "ABC Doc. Process No." = RIMD,
         tabledata "ABC General Setup" = RIMD;
}