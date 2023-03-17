//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_Normal extends KFXInstCombatMessage;


static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    local int WeapType;
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
                    WeapType = (switch >> 16);
                    if (class'KFXTools'.static.IsKnife(switch))//是刀杀/拳头
                    {
                        PlayEncourageSound(P, ET_Knife);
                    }
                    else if ( (OptionalObject != none) && (OptionalObject.Name == 'KFXDmgTypeDelayed') )//爆炸杀
                    {
                        ;
                        PlayEncourageSound(P, ET_Bomb);
                    }
                    else
                    {
                        PlayEncourageSound(P, ET_Normal);
                    }
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
                    WeapType = (switch >> 16);
                    if (class'KFXTools'.static.IsKnife(switch))//是刀杀/拳头
                    {
                        PlayEncourageSound(P, ET_Knife);
                    }
                    else if ((OptionalObject != none) && (OptionalObject.Name == 'KFXDmgTypeDelayed'))//爆炸杀
                    {
                        PlayEncourageSound(P, ET_Bomb);
                    }
                    else
                    {
                        PlayEncourageSound(P, ET_Normal);
                    }
                }
			}
		}
	}
}

defaultproperties
{
}
