//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_CWKill extends KFXInstCombatMessage;

// ¥¶¿Ìº§¿¯…˘“Ù¬ﬂº≠
static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
}
