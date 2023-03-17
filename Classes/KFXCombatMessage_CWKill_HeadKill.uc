//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_CWKill_HeadKill extends KFXCombatMessage_CWKill;

// 处理激励声音逻辑
static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
//    local int WeapType;
    Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if (Switch == 1)//C4
        return;
    // 自己是杀人者
	if ( RelatedPRI_1 == P.PlayerReplicationInfo )
	{
        // 判断连杀
        if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//不是观查者？？？
        {
            // 不是自杀
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
                if (KFXGameReplicationInfo(P.GameReplicationInfo).bNotFirstBlood
                    && KFXPlayer(P).MultiKillLevel < 2)//无连杀
                {
                    PlayEncourageSound(P, ET_CrossWallHeadKill);
                }
			}
		}
		// 观察者**目前和本人的逻辑相同
        else
        {
            //不是自杀
			if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
                if (KFXGameReplicationInfo(P.GameReplicationInfo).bNotFirstBlood
                    && KFXPlayer(P).MultiKillLevel < 2)//无连杀
                {
                     PlayEncourageSound(P, ET_CrossWallHeadKill);
                }
			}
		}
	}
}

defaultproperties
{
}
