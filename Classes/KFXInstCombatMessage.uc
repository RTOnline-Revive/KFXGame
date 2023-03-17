//-----------------------------------------------------------
//  Class:      KFXGame.KInstCombatMessage
//  Creator:    zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-03-29
//  Desc:       ��ʱս����Ϣ
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXInstCombatMessage extends LocalMessage;


//��ൽ20�� 20�Ժ�����չ
const CONS_Encourage_Cnt = 30;
enum EEncourageType
{
    ET_Normal,      //��ͨ
    ET_FirstBlood,  //��һ��Ѫ
    ET_Combo2,      //2��ɱ
    ET_Combo3,      //3��ɱ
    ET_Combo4,      //4��ɱ
    ET_Combo5,      //5��ɱ
    ET_Combo6,      //6��ɱ
    ET_Combo7,      //7��ɱ
    ET_ComboN,      //>7��ɱ
    ET_Knife,       //��ɱ
    ET_HeadShot,    //��ͷ
    ET_Bomb,        //��ը
    ET_Special,     //�����ɱ
    ET_Tank,        //ɱ̹��
    ET_Corpse,      //ɱ��ʬ
    ET_CorpseKiller, //��ʬɱ��
    ET_CrossWallKill,     //��ǽɱ
    ET_CrossWallHeadKill //��ǽ��ɱ
};


// ��ɱ�߼�
static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    local int MultiKillNum;
    if (Switch == 1)//C4
        return;

    // �Լ���ɱ����
	if ( RelatedPRI_1 == KFXPlayer(P).PlayerReplicationInfo )
    {
        // �ж���ɱ
        if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//���ǹ۲��ߣ�����
        {
            // ������ɱ
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
                // ��:�ж��ֵ���ģʽ��ɱ
                if(KFXPlayer(P) != none)
                {
                    KFXHUD(KFXPlayer(P).myHUD).AddTotalKill();
                }
                //��һ��Ѫ
                if (false)//!KFXGameReplicationInfo(P.GameReplicationInfo).bNotFirstBlood) ���ٲ��ŵ�һ��Ѫ����
                {
                    PlayEncourageSound(P, ET_FirstBlood);
                    KFXPlayer(P).MultiKillLevel = 1;//��һ�λ�ɱ
                    KFXPlayer(P).PlayerCombatmessageDataSet.FBNum++;
                }
				//3���ڼ�һ����ɱ
                else //if ( P.Level.TimeSeconds - KFXPlayer(P).LastKillTime < KFXGameReplicationInfo(P.GameReplicationInfo).fxSeriateKillTime )//�����ӵ�5��
				{

                    // �ͻ��˲���ͳ����ɱ�����ɷ�������������ֵ����
                    KFXPlayer(P).MultiKillLevel = KFXPlayer(P).ClientMultiKillNum;
					//<< ��߻�ɱ��
                    if (KFXPlayer(P).MultiKillLevel > KFXPlayer(P).MaxMultiKillLevel)
					{
					    //���±�������ɱ��
                        KFXPlayer(P).MaxMultiKillLevel = KFXPlayer(P).MultiKillLevel;
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiKillNum =  KFXPlayer(P).MultiKillLevel;
        	            if ( P.Pawn.Health == int (P.Pawn.HealthMax) && KFXPlayer(P).PlayerCombatmessageDataSet.MaxFullHealthKillNum < KFXPlayer(P).MultiKillLevel)
                            KFXPlayer(P).PlayerCombatmessageDataSet.MaxFullHealthKillNum = KFXPlayer(P).MultiKillLevel;

                        log("SeriateKill update MaxMutiKillNum"$KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiKillNum$
                        "MaxFullHealthKillNum:"$KFXPlayer(P).PlayerCombatmessageDataSet.MaxFullHealthKillNum$
                        "P.Pawn.HealthMax"$int (P.Pawn.HealthMax));
                    }
                    //>>

					// ��������
					if (KFXPlayer(P).MultiKillLevel > 1)
                    {
                        PlayComboKillSound(P, KFXPlayer(P).MultiKillLevel);
				    }
                }

                if ( P.Pawn != none )
                {
     	            if ( P.Pawn.Health == 1 )
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxSingleBloodKillNum++;
                    if ( P.Pawn.Physics == PHYS_Falling )
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxKillInFalling++;
                    if ( P.Pawn.bIsCrouched )
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxCrouchKill++;
                }
            }
			else
			{
				KFXPlayer(P).MultiKillLevel = 0;    //��ɱ����ɱ������
			}

            KFXPlayer(P).LastKillTime = KFXPlayer(P).Level.TimeSeconds;
		    if ( KFXPlayer(P).PlayerCombatmessageDataSet.MaxFastKillNum == 0
            || ( KFXPlayer(P).PlayerCombatmessageDataSet.MaxFastKillNum != 0
            && KFXPlayer(P).PlayerCombatmessageDataSet.MaxFastKillNum > KFXPlayer(P).LastKillTime - KFXPlayer(P).ClientRestartTime)
            )
            {
                KFXPlayer(P).PlayerCombatmessageDataSet.MaxFastKillNum = KFXPlayer(P).LastKillTime - KFXPlayer(P).ClientRestartTime;
            }
            log("[LABOR]---------------max fast kill num:"$KFXPlayer(P).PlayerCombatmessageDataSet.MaxFastKillNum
						@KFXPlayer(P).LastKillTime
						@KFXPlayer(P).ClientRestartTime);

            KFXPlayer(P).LastLifekilledNum++;
		}
    }
	// �Լ��Ǳ�ɱ��
	else if ( RelatedPRI_2 == P.PlayerReplicationInfo )
	{
        KFXPlayer(P).MultiKillLevel = 0;//��ɱ����ɱ������
	}
	else if((KFXPlayer(P).bCanHearOthersKill == 1 && RelatedPRI_1.Team.TeamIndex == KFXPlayer(P).PlayerReplicationInfo.Team.TeamIndex) || KFXPlayer(P).bCanHearOthersKill >= 2)
	{
        // �ж���ɱ
        if ( true)
        {
            // ������ɱ
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
				// ��������
				MultiKillNum = KFXPlayer(P).ClientMultiKillNum;
                if (MultiKillNum > 1)
                {
                    PlayComboKillSound(P, MultiKillNum);
			    }
            }
		}

    }
}

//������ɱ������Ч
static function PlayComboKillSound(PlayerController P, int ComboLevel)
{
    if(KFXPlayer(P).bIsRound)        //С��
    {
       PlayRoundComboKillSound(P,ComboLevel);
    }
    else
    {
       PlayDeathComboKillSound(P,ComboLevel);
    }
}
//������ɱ������Ч
static function PlayDeathComboKillSound(PlayerController P, int ComboLevel)
{
    local int Level;
    local EEncourageType Type;
    local bool LevelisBiggerthan6;

    Level = ComboLevel;
    LevelisBiggerthan6 = false;
    if (Level > 6)
    {
        LevelisBiggerthan6 = true;
        Level = 6;
    }

    switch (Level)
    {
        case 2:
            Type = ET_Combo2;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo2lNum++;
            break;
        case 3:
            Type = ET_Combo3;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo2lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo3lNum++;
            break;
        case 4:
            Type = ET_Combo4;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo3lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo4lNum++;
            break;
        case 5:
            Type = ET_Combo5;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo4lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo5lNum++;
            break;
        case 6:
            if ( !LevelisBiggerthan6 )
            {
                KFXPlayer(P).PlayerCombatmessageDataSet.Combo5lNum--;
                KFXPlayer(P).PlayerCombatmessageDataSet.Combo6lNum++;
            }
            Type = ET_ComboN;
    }

    if (Type != ET_Normal)
        PlayDeathComboEncourageSound(P, Type);
}
//������ɱ������Ч
static function PlayRoundComboKillSound(PlayerController P, int ComboLevel)
{
    local int Level;
    local EEncourageType Type;
    local bool LevelisBiggerthan8;

    Level = ComboLevel;
    LevelisBiggerthan8 = false;
    if (Level > 8)
    {
        LevelisBiggerthan8 = true;
        Level = 8;
    }

    switch (Level)
    {
        case 2:
            Type = ET_Combo2;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo2lNum++;
            break;
        case 3:
            Type = ET_Combo3;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo2lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo3lNum++;
            break;
        case 4:
            Type = ET_Combo4;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo3lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo4lNum++;
            break;
        case 5:
            Type = ET_Combo5;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo4lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo5lNum++;
            break;
        case 6:
            Type = ET_Combo6;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo5lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo6lNum++;
            break;
        case 7:
            Type = ET_Combo7;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo6lNum--;
            KFXPlayer(P).PlayerCombatmessageDataSet.Combo7lNum++;
            break;
        case 8:
            if ( !LevelisBiggerthan8 )
            {
                KFXPlayer(P).PlayerCombatmessageDataSet.Combo7lNum--;
                KFXPlayer(P).PlayerCombatmessageDataSet.Combo8lNum++;
            }
            Type = ET_ComboN;
    }

    if (Type != ET_Normal)
        PlayRoundComboEncourageSound(P, Type);
}
//����ɱ����Ϣ������Ч����ɱ�����߸��߼����Ŷ�ģʽ����PlayDeathComboEncourageSOund,С��ģʽ��PlayRoundComboEncourageSOund
static function PlayEncourageSound(PlayerController P, EEncourageType Type)
{
    local string SoundName;
    local int iTemp;


    if ( !KFXPlayer(P).bKFXKeyOfEncourage )
    {
        return;
    }
    if(KFXPlayer(P).life_style>0 && KFXPlayer(P).life_encourage_sound_valid)
    {
		SoundName = KFXPlayer(P).life_encourage_sound[Type];
	}
	else
	{
	    if (P.PlayerReplicationInfo.bIsFemale)
	        SoundName = "fx_encourage_music.female_";
	    else
	        SoundName = "fx_encourage_music.male_";
	    switch (Type)
	    {
	        case ET_Normal:
	            SoundName $= "1kill";
	            break;
	        case ET_FirstBlood:
	            SoundName $= "first";
	            break;
	        case ET_Knife:
	            SoundName $= "E_cheer1";
	            break;
	        case ET_HeadShot:
	            SoundName $= "E_cheer5";
	            break;
	        case ET_Bomb:
	            SoundName $= "E_cheer2";
	            break;
	        case ET_Special:
	            SoundName $= "animal";
	            break;
	        case ET_Tank:
	            SoundName $= "tank1";
	            break;
	        case ET_Corpse:
	            SoundName = "fx_encourage_music.human.";
	            SoundName $= "human_1kill";
            	if(SoundName != "")
            	    P.Pawn.PlaySound( sound(DynamicLoadObject(SoundName, class'Sound')), SLOT_None,
                		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), true,
                		100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
                return;
	            break;
	        case ET_CorpseKiller:
	        	SoundName = "fx_encourage_music.mutate.";
	            SoundName $= "mutate_killhuman";
            	if(SoundName != "")
            	    P.Pawn.PlaySound( sound(DynamicLoadObject(SoundName, class'Sound')), SLOT_None,
                		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), true,
                		100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
                return;
	            break;
	        case ET_CrossWallKill:
	             SoundName $= "E_cheer3";
	             break;
	        case ET_CrossWallHeadKill:
	            SoundName $= "E_cheer4";
	            break;
	    }
	}
    log("CombatMessage-----SoundName "$SoundName);
    log("CombatMessage-----sound(DynamicLoadObject(SoundName, class'Sound')) "$sound(DynamicLoadObject(SoundName, class'Sound')));
	if(SoundName != "")
	    P.Pawn.PlaySound( sound(DynamicLoadObject(SoundName, class'Sound')), SLOT_None,
    		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), false,
    		100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
}

//�����ŶӼ�����Ч
static function PlayDeathComboEncourageSound(PlayerController P, EEncourageType Type)
{
    local string SoundName;
    local int iTemp;

    if ( !KFXPlayer(P).bKFXKeyOfEncourage )
    {
        return;
    }
    if(KFXPlayer(P).life_style>0 && KFXPlayer(P).life_encourage_sound_valid)
    {
		SoundName = KFXPlayer(P).life_encourage_sound[Type];
	}
	else
	{
	    if (P.PlayerReplicationInfo.bIsFemale)
	        SoundName = "fx_encourage_music.female_";
	    else
	        SoundName = "fx_encourage_music.male_";

	    switch (Type)
	    {
	        case ET_Normal:
	            SoundName $= "1kill";
	            break;
	        case ET_FirstBlood:
	            SoundName $= "first";
	            break;
	        case ET_Combo2:
	            SoundName $= "E_cheer7";
	            break;
	        case ET_Combo3:
	            SoundName $= "E_cheer8";
	            break;
	        case ET_Combo4:
	            SoundName $= "E_cheer9";
	            break;
	        case ET_Combo5:
	            SoundName $= "E_cheer10";
	            break;
	        case ET_ComboN:
	            SoundName $= "E_cheer11";
	            break;
	    }
	}
	if(SoundName != "")
	    P.Pawn.PlaySound( sound(DynamicLoadObject(SoundName, class'Sound')), SLOT_None,
    		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), false,
		    100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
}

//����С��ģʽ������Ч
static function PlayRoundComboEncourageSound(PlayerController P, EEncourageType Type)
{
    local string SoundName;
    local int iTemp;

    if ( !KFXPlayer(P).bKFXKeyOfEncourage )
    {
        return;
    }
    if(KFXPlayer(P).life_style>0 && KFXPlayer(P).life_encourage_sound_valid)
    {
		if(Type>=ET_Combo2 && Type<=ET_ComboN)
			SoundName = KFXPlayer(P).life_encourage_sound[CONS_Encourage_Cnt+Type];
		else
			SoundName = KFXPlayer(P).life_encourage_sound[Type];
	}
	else
	{
	    if (P.PlayerReplicationInfo.bIsFemale)
	        SoundName = "fx_encourage_music.female_";
	    else
	        SoundName = "fx_encourage_music.male_";

	    switch (Type)
	    {
	        case ET_Normal:
	            SoundName $= "1kill";
	            break;
	        case ET_FirstBlood:
	            SoundName $= "first";
	            break;
	        case ET_Combo2:
	            SoundName $= "E_cheer14";
	            break;
	        case ET_Combo3:
	            SoundName $= "E_cheer12";
	            break;
	        case ET_Combo4:
	            SoundName $= "E_cheer13";
	            break;
	        case ET_Combo5:
	            SoundName $= "E_cheer15";
	            break;
	        case ET_Combo6:
	            SoundName $= "E_cheer16";
	            break;
	        case ET_Combo7:
	            SoundName $= "E_cheer17";
	            break;
	        case ET_ComboN:
	            SoundName $= "E_cheer18";
	            break;
	    }
	}

	if(SoundName != "")
	    P.Pawn.PlaySound( sound(DynamicLoadObject(SoundName, class'Sound')), SLOT_None,
    		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), false,
		    100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
}

static function string GetWeaponSrc(int nWeaponID)
{
    local string sWeaponSrc;
    local KFXCSVTable fxCsvWeapon;

    sWeaponSrc = "";

    fxCsvWeapon = class'KFXTools'.static.GetConfigTable(10);

    if( fxCsvWeapon == none )
    {
        return sWeaponSrc;
    }

    if( nWeaponID == 0 || !fxCsvWeapon.SetCurrentRow(nWeaponID) )
    {
        return sWeaponSrc;
    }

    sWeaponSrc = fxCsvWeapon.GetString("HUDRes_Kill");

    return sWeaponSrc;
}

static function GetWeapCompntSrc(int nWeaponID,KFXPlayerReplicationInfo KillerPRI,out array<string> CompntSrc)
{
    local KFXCSVTable fxCsvCompnt;
    local int loop1,loop2;

    fxCsvCompnt = class'KFXTools'.static.GetConfigTable(22);

    CompntSrc.remove(0,CompntSrc.Length);

    if( fxCsvCompnt == none || nWeaponID == 0)
    {
        return;
    }

    for(loop1=0; loop1 < KillerPRI.WeapAndCompntIdList.Length; loop1++)
    {
        if(KillerPRI.WeapAndCompntIdList[loop1].weaponID == nWeaponID)
        {
            for(loop2=0; loop2 < 6; loop2++)
            {
                if(KillerPRI.WeapAndCompntIdList[loop1].CompntID[loop2] != 0)
                {
                    fxCsvCompnt.SetCurrentRow(KillerPRI.WeapAndCompntIdList[loop1].CompntID[loop2]);
                    CompntSrc[CompntSrc.Length]= fxCsvCompnt.GetString("HUDCompnt_Kill");
                }
            }
            break;
        }
    }
}

defaultproperties
{
}
