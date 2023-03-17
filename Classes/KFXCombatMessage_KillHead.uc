//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_KillHead extends KFXInstCombatMessage;

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
                    else
                    {
                        PlayEncourageSound(P, ET_HeadShot);
                    }
                }

				if ( P.Level.TimeSeconds - KFXPlayer(P).LastHeadShotTime < KFXGameReplicationInfo(P.GameReplicationInfo).fxSeriateKillTime )//规定时间内计一次连杀
				{
                    KFXPlayer(P).MultiHealdShotNum++;
                    log("KFXPlayer(P).MultiHealdShotNum:"$KFXPlayer(P).MultiHealdShotNum);
                }
                else
                    KFXPlayer(P).MultiHealdShotNum = 0;
                if ( KFXPlayer(P).MultiHealdShotNum != 0 )
                {
                    if ( KFXPlayer(P).MultiHealdShotNum > KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiHeadKill )
                    {
                        log("update KFXPlayer(P).MultiHealdShotNum:"$KFXPlayer(P).MultiHealdShotNum);
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiHeadKill = KFXPlayer(P).MultiHealdShotNum;
                    }
                }
			KFXPlayer(P).LastHeadShotTime = P.Level.TimeSeconds;
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
                    else
                    {
                        PlayEncourageSound(P, ET_HeadShot);
                    }
                }
				if ( P.Level.TimeSeconds - KFXPlayer(P).LastHeadShotTime < KFXGameReplicationInfo(P.GameReplicationInfo).fxSeriateKillTime )//规定时间内计一次连杀
				{
                    KFXPlayer(P).MultiHealdShotNum++;
                    log("KFXPlayer(P).MultiHealdShotNum:"$KFXPlayer(P).MultiHealdShotNum);
                }
                else
                    KFXPlayer(P).MultiHealdShotNum = 0;
                if ( KFXPlayer(P).MultiHealdShotNum != 0 )
                {
                    if ( KFXPlayer(P).MultiHealdShotNum > KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiHeadKill )
                    {
                        log("update KFXPlayer(P).MultiHealdShotNum:"$KFXPlayer(P).MultiHealdShotNum);
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiHeadKill = KFXPlayer(P).MultiHealdShotNum;
                    }
                }
				KFXPlayer(P).LastHeadShotTime = P.Level.TimeSeconds;

			}
		}
	}
}

defaultproperties
{
}
