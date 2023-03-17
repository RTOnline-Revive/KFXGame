//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_CWKill_HeadKill extends KFXCombatMessage_CWKill;

// �����������߼�
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
                    PlayEncourageSound(P, ET_CrossWallHeadKill);
                }
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
                     PlayEncourageSound(P, ET_CrossWallHeadKill);
                }
			}
		}
	}
}

defaultproperties
{
}
