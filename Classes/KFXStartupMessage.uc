//-----------------------------------------------------------
//  Class:      KFXGame.KFXStartupMessage
//  Creator:    zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-07-29
//  Desc:       ����ʱ��Ϣ
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXStartupMessage extends LocalMessage;


static simulated function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    return "";
}

defaultproperties
{
}
