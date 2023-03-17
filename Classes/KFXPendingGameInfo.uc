//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXPendingGameInfo extends KFXGameInfo;

// ÊÇ·ñ´¦ÓÚPending×´Ì¬
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
