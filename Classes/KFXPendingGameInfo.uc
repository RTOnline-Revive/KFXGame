//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXPendingGameInfo extends KFXGameInfo;

// �Ƿ���Pending״̬
function bool KFXCheckPending()
{
    return true;
}

event PreLogin
(
    string Options,
    string Address,
    string PlayerID,
    out string Error,
    out string FailCode
)
{
    Error = "illegale login request!";
}

defaultproperties
{
}
