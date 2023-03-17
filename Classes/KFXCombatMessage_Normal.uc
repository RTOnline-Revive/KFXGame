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
                    else if ( (OptionalObject != none) && (OptionalObject.Name == 'KFXDmgTypeDelayed') )//��ըɱ
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
                    else if ((OptionalObject != none) && (OptionalObject.Name == 'KFXDmgTypeDelayed'))//��ըɱ
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
