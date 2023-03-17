//-----------------------------------------------------------
//  Class:      KFXGame.KInstCombatMessage
//  Creator:    zhangjinpin@kingsoft 张金品
//  Data:       2007-03-29
//  Desc:       即时战斗消息
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXInstCombatMessage extends LocalMessage;


//最多到20， 20以后是扩展
const CONS_Encourage_Cnt = 30;
enum EEncourageType
{
    ET_Normal,      //普通
    ET_FirstBlood,  //第一滴血
    ET_Combo2,      //2连杀
    ET_Combo3,      //3连杀
    ET_Combo4,      //4连杀
    ET_Combo5,      //5连杀
    ET_Combo6,      //6连杀
    ET_Combo7,      //7连杀
    ET_ComboN,      //>7连杀
    ET_Knife,       //刀杀
    ET_HeadShot,    //爆头
    ET_Bomb,        //爆炸
    ET_Special,     //特殊击杀
    ET_Tank,        //杀坦克
    ET_Corpse,      //杀僵尸
    ET_CorpseKiller, //僵尸杀人
    ET_CrossWallKill,     //穿墙杀
    ET_CrossWallHeadKill //穿墙击杀
};


// 连杀逻辑
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

    // 自己是杀人者
	if ( RelatedPRI_1 == KFXPlayer(P).PlayerReplicationInfo )
    {
        // 判断连杀
        if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//不是观查者？？？
        {
            // 不是自杀
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
                // 钟:判定兄弟连模式击杀
                if(KFXPlayer(P) != none)
                {
                    KFXHUD(KFXPlayer(P).myHUD).AddTotalKill();
                }
                //第一滴血
                if (false)//!KFXGameReplicationInfo(P.GameReplicationInfo).bNotFirstBlood) 不再播放第一滴血语音
                {
                    PlayEncourageSound(P, ET_FirstBlood);
                    KFXPlayer(P).MultiKillLevel = 1;//计一次击杀
                    KFXPlayer(P).PlayerCombatmessageDataSet.FBNum++;
                }
				//3秒内计一次连杀
                else //if ( P.Level.TimeSeconds - KFXPlayer(P).LastKillTime < KFXGameReplicationInfo(P.GameReplicationInfo).fxSeriateKillTime )//体验版加到5秒
				{

                    // 客户端不再统计连杀数，由服务器传过来的值计算
                    KFXPlayer(P).MultiKillLevel = KFXPlayer(P).ClientMultiKillNum;
					//<< 最高击杀数
                    if (KFXPlayer(P).MultiKillLevel > KFXPlayer(P).MaxMultiKillLevel)
					{
					    //更新本地最大击杀数
                        KFXPlayer(P).MaxMultiKillLevel = KFXPlayer(P).MultiKillLevel;
                        KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiKillNum =  KFXPlayer(P).MultiKillLevel;
        	            if ( P.Pawn.Health == int (P.Pawn.HealthMax) && KFXPlayer(P).PlayerCombatmessageDataSet.MaxFullHealthKillNum < KFXPlayer(P).MultiKillLevel)
                            KFXPlayer(P).PlayerCombatmessageDataSet.MaxFullHealthKillNum = KFXPlayer(P).MultiKillLevel;

                        log("SeriateKill update MaxMutiKillNum"$KFXPlayer(P).PlayerCombatmessageDataSet.MaxMutiKillNum$
                        "MaxFullHealthKillNum:"$KFXPlayer(P).PlayerCombatmessageDataSet.MaxFullHealthKillNum$
                        "P.Pawn.HealthMax"$int (P.Pawn.HealthMax));
                    }
                    //>>

					// 播放声音
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
				KFXPlayer(P).MultiKillLevel = 0;    //自杀，连杀数清零
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
	// 自己是被杀者
	else if ( RelatedPRI_2 == P.PlayerReplicationInfo )
	{
        KFXPlayer(P).MultiKillLevel = 0;//被杀，连杀数清零
	}
	else if((KFXPlayer(P).bCanHearOthersKill == 1 && RelatedPRI_1.Team.TeamIndex == KFXPlayer(P).PlayerReplicationInfo.Team.TeamIndex) || KFXPlayer(P).bCanHearOthersKill >= 2)
	{
        // 判断连杀
        if ( true)
        {
            // 不是自杀
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
				// 播放声音
				MultiKillNum = KFXPlayer(P).ClientMultiKillNum;
                if (MultiKillNum > 1)
                {
                    PlayComboKillSound(P, MultiKillNum);
			    }
            }
		}

    }
}

//播放连杀激励音效
static function PlayComboKillSound(PlayerController P, int ComboLevel)
{
    if(KFXPlayer(P).bIsRound)        //小局
    {
       PlayRoundComboKillSound(P,ComboLevel);
    }
    else
    {
       PlayDeathComboKillSound(P,ComboLevel);
    }
}
//播放连杀激励音效
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
//播放连杀激励音效
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
//播放杀人信息激励音效，连杀不再走该逻辑，团队模式下走PlayDeathComboEncourageSOund,小局模式走PlayRoundComboEncourageSOund
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

//播放团队激励音效
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

//播放小局模式激励音效
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
