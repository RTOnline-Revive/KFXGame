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
    // �Լ���ɱ����
	if ( RelatedPRI_1 == P.PlayerReplicationInfo )
	{
        // �ж���ɱ
        if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//���ǹ۲��ߣ�����
        {

            // ������ɱ
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
                if (KFXGameReplicationInfo(P.GameReplicationInfo).bNotFirstBlood
                 && KFXPlayer(P).MultiKillLevel < 2)//����ɱ
                {
                    WeapType = (switch >> 16);
                    if (class'KFXTools'.static.IsKnife(switch))//�ǵ�ɱ/ȭͷ
                    {
                        PlayEncourageSound(P, ET_Knife);
                    }
                    else
                    {
                        PlayEncourageSound(P, ET_HeadShot);
                    }
                }

				if ( P.Level.TimeSeconds - KFXPlayer(P).LastHeadShotTime < KFXGameReplicationInfo(P.GameReplicationInfo).fxSeriateKillTime )//�涨ʱ���ڼ�һ����ɱ
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
		// �۲���**Ŀǰ�ͱ��˵��߼���ͬ
        else
        {
            //������ɱ
			if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
                if (KFXGameReplicationInfo(P.GameReplicationInfo).bNotFirstBlood
                    && KFXPlayer(P).MultiKillLevel < 2)//����ɱ
                {
                    WeapType = (switch >> 16);
                    if (class'KFXTools'.static.IsKnife(switch))//�ǵ�ɱ/ȭͷ
                    {
                        PlayEncourageSound(P, ET_Knife);
                    }
                    else
                    {
                        PlayEncourageSound(P, ET_HeadShot);
                    }
                }
				if ( P.Level.TimeSeconds - KFXPlayer(P).LastHeadShotTime < KFXGameReplicationInfo(P.GameReplicationInfo).fxSeriateKillTime )//�涨ʱ���ڼ�һ����ɱ
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
