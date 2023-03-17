//-----------------------------------------------------------
//  Class:      KFXGame.KFXVoicePack
//  Creator:    zhangjinpin@kingsoft 张金品
//  Data:       2007-08-06
//  Desc:       宏喊话
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXVoicePack extends VoicePack;

var localized string SMZKeyText[10];
var localized string SMXKeyText[10];
var localized string SMCKeyText[10];

var music SMZKeySound_Male[10];
var music SMXKeySound_Male[10];
var music SMCKeySound_Male[10];

var music SMZKeySound_Female[10];
var music SMXKeySound_Female[10];
var music SMCKeySound_Female[10];

var string MessageString;
var music MessageSound;

var bool bForceMessageSound;
var bool bInitedVoice;
var PlayerReplicationInfo fxSender;

static function PlayerSpeech( name Type, int Index, string Callsign, Actor PackOwner )
{
	local name SendMode;
	local PlayerReplicationInfo Recipient;
	local int RoleID;

    SendMode = 'TEAM';
    Recipient = none;
    RoleID = KFXPlayer(PackOwner).fxDBPlayerInfo.RoleID;

	Controller(PackOwner).SendVoiceMessage(
        Controller(PackOwner).PlayerReplicationInfo,
        Recipient,
        Type,
        Index,
        SendMode,
        RoleID
        );
}

function ClientInitialize(
    PlayerReplicationInfo Sender,
    PlayerReplicationInfo Recipient,
    name messagetype,
    byte messageIndex,
    optional int RoleID
    )
{
    fxSender = Sender;
    if( PlayerController(Owner).PlayerReplicationInfo != Sender && Recipient != none )
    {
        Destroy();
        return;
    }

    if( PlayerController(Owner).bNoVoiceMessages )
	{
		Destroy();
		return;
	}
	log("KFXVoicePack------KFXPlayer(Owner).bIsVoiceMessage "$KFXPlayer(Owner).bIsVoiceMessage);
    if(PlayerController(Owner).PlayerReplicationInfo != Sender && !KFXPlayer(Owner).bIsVoiceMessage)
	{
		Destroy();
		return;
	}

    if(!bInitedVoice)
    {
       GetMatchVoice(messagetype,messageIndex,RoleID);
       //bInitedVoice = false;
    }
	SetTimer(0.6, false);

	if( messagetype == 'Z_Speech' )
	{
        MessageString = SMZKeyText[messageIndex];
       if( RoleID % 2 == 0 )
            MessageSound = SMZKeySound_Female[messageIndex];
        else
            MessageSound = SMZKeySound_Male[messageIndex];
    }
    else if( messagetype == 'X_Speech' )
    {
        MessageString = SMXKeyText[messageIndex];
       if( RoleID % 2 == 0 )
            MessageSound = SMXKeySound_Female[messageIndex];
        else
            MessageSound = SMXKeySound_Male[messageIndex];
    }
    else if( messagetype == 'C_Speech' )
    {
        MessageString = SMCKeyText[messageIndex];
        if( RoleID % 2 == 0 )
            MessageSound = SMCKeySound_Female[messageIndex];
        else
            MessageSound = SMCKeySound_Male[messageIndex];

    }
    log("KFXVoicePack-----messagetype "$messagetype);
    log("KFXVoicePack-----MessageString "$MessageString);
    log("KFXVoicePack------MessageSound "$MessageSound);
	if ( PlayerController(Owner).PlayerReplicationInfo == Sender )
	{
		bForceMessageSound = true;
	}
	// 宏喊话标记
	else
	{
        KFXPlayerReplicationInfo(Sender).bSpeechState = true;
    }

}

function Timer()
{
	local PlayerController PlayerOwner;

	PlayerOwner = PlayerController(Owner);

    if ( MessageSound != None )
	{
		if( PlayerOwner.PlayerReplicationInfo.Team == none )
		{
            log("KFXVoicePack--111---MessageString "$MessageString);
            PlayerOwner.TeamMessage(fxSender, MessageString, 'Say');
        }
        else
        {
            log("KFXVoicePack--222---MessageString "$MessageString);
            PlayerOwner.TeamMessage(fxSender, MessageString, 'TeamShout');
        }
	}

	if ( MessageSound != None
        && ( Level.TimeSeconds - PlayerOwner.LastPlaySpeech > 2 || bForceMessageSound )
        && !KFXPlayer(PlayerOwner).bKFXLockSMZKeySound )
	{
		PlayerOwner.LastPlaySpeech = Level.TimeSeconds;

		if ( (PlayerOwner.ViewTarget != None) )
		{
//			PlayerOwner.ViewTarget.PlaySound(
//                MessageSound, SLOT_None, 1.0, false, 100, 1.0, false
//                );
			PlayerOwner.ViewTarget.KFXPlayMusic(
                MessageSound, SLOT_None, 1.0, false, 100, 1.0, false,false
                );
		}
		else
		{
//			PlayerOwner.PlaySound(
//                MessageSound, SLOT_None, 1.0, false, 100, 1.0, false
//                );
			PlayerOwner.KFXPlayMusic(
                MessageSound, SLOT_None, 1.0, false, 100, 1.0, false, false
                );
		}
	}
	else
	{
		Destroy();
	}

	KFXPlayerReplicationInfo(fxSender).bSpeechState = false;
}
function int GetVoiceTale(int RoleID)
{
    local bool bMaleVoice;
    bMaleVoice =  RoleID % 2 == 1;              //1为male
    if(KFXPlayer(Owner).bChinaVoice)
    {
        if(bMaleVoice)
            return 712;
        else
            return 713;
    }
    else
    {
        if(bMaleVoice)
            return 714;
        else
            return 715;
    }

}
function bool GetMatchVoice(
    name messagetype,
    byte messageIndex,
    optional int RoleID
)
{
    local KFXCSVTable CFG_Voice;
    local int         TableID;
    local int         GameModeID;
    local int         i;
    local string      TempVoice;

    TableID        = GetVoiceTale(RoleID);
    GameModeID     = 1;

    log("KFXVoicePack-------RoleID :"$RoleID);
    log("KFXVoicePack-------messagetype :"$messagetype);
    log("KFXVoicePack-------messageIndex :"$messageIndex);

    log("KFXVoicePack------TableID "$TableID);
    log("KFXVoicePack------GameModeID "$GameModeID);

    CFG_Voice      = class'KFXTools'.static.GetConfigTable(TableID);
    if ( !CFG_Voice.SetCurrentRow(GameModeID) )
    {
        Log("[KFXPlayer] Can't Resolve The RadioVoice "$GameModeID);
        return false;
    }

    i = messageIndex;
    if(RoleID % 2 == 1)    //male
    {
        if(messagetype == 'Z_Speech')
        {
           TempVoice = CFG_Voice.GetString("Voice_Z"$i);
           if(TempVoice != "none")
           {
                SMZKeySound_Male[i]=music(DynamicLoadObject(TempVoice, class'music'));
           }
        }
        else if(messagetype == 'C_Speech')
        {
           TempVoice = CFG_Voice.GetString("Voice_C"$i);
           if(TempVoice != "none")
           {
                SMCKeySound_Male[i]=music(DynamicLoadObject(TempVoice, class'music'));
           }
        }
        else if(messagetype == 'X_Speech')
        {
           TempVoice = CFG_Voice.GetString("Voice_X"$i);
           if(TempVoice != "none")
           {
                SMXKeySound_Male[i]=music(DynamicLoadObject(TempVoice, class'music'));
           }
        }
        log("Male-------TempVoice :"$TempVoice);
    }
    else
    {
        if(messagetype == 'Z_Speech')
        {
           TempVoice = CFG_Voice.GetString("Voice_Z"$i);
           if(TempVoice != "none")
           {
                SMZKeySound_Female[i]=music(DynamicLoadObject(TempVoice, class'music'));
           }
        }
        else if(messagetype == 'C_Speech')
        {
           TempVoice = CFG_Voice.GetString("Voice_C"$i);
           if(TempVoice != "none")
           {
                SMCKeySound_Female[i]=music(DynamicLoadObject(TempVoice, class'music'));
           }
        }
        else if(messagetype == 'X_Speech')
        {
           TempVoice = CFG_Voice.GetString("Voice_X"$i);
           if(TempVoice != "none")
           {
                SMXKeySound_Female[i]=music(DynamicLoadObject(TempVoice, class'music'));
           }
        }
        log("Female-------TempVoice :"$TempVoice);
    }

//    if(KFXPlayer(Owner).bMaleVoice)
//    {
//        log("male-------Voice_ZNum :"$Voice_ZNum);
//        for(i=1; i<= Voice_ZNum; i++)
//        {
//            TempVoice = CFG_Voice.GetString("Voice_Z"$i);
//            log("male-------TempVoice :"$TempVoice);
//            if(TempVoice != "none")
//            {
//                SMZKeySound_Male[i]=music(DynamicLoadObject(TempVoice, class'music'));
//            }
//            log("male-------SMZKeySound_Male[i] :"$SMZKeySound_Male[i]);
//        }
//    }
//    else
//    {
//         log("Female-------Voice_ZNum :"$Voice_ZNum);
//        for(i=1; i<=Voice_ZNum; i++)
//        {
//            TempVoice = CFG_Voice.GetString("Voice_Z"$i);
//            log("Female-------TempVoice :"$TempVoice);
//            if(TempVoice != "none")
//            {
//                SMZKeySound_FeMale[i]=music(DynamicLoadObject(TempVoice, class'music'));
//            }
//            log("Female-------SMZKeySound_FeMale[i] :"$SMZKeySound_FeMale[i]);
//        }
//
//    }
//    if(KFXPlayer(Owner).bMaleVoice)
//    {
//        for(i=1; i<= Voice_CNum; i++)
//        {
//            TempVoice = CFG_Voice.GetString("Voice_C"$i);
//            if(TempVoice != "none")
//            {
//                SMCKeySound_Male[i]=music(DynamicLoadObject(TempVoice, class'music'));
//            }
//        }
//    }
//    else
//    {
//        for(i=1; i<=Voice_CNum; i++)
//        {
//            TempVoice = CFG_Voice.GetString("Voice_C"$i);
//            if(TempVoice != "none")
//            {
//                SMCKeySound_FeMale[i]=music(DynamicLoadObject(TempVoice, class'music'));
//            }
//        }
//
//    }
//
//    if(KFXPlayer(Owner).bMaleVoice)
//    {
//        for(i=1; i<= Voice_XNum; i++)
//        {
//            TempVoice = CFG_Voice.GetString("Voice_X"$i);
//            if(TempVoice != "none")
//            {
//                SMXKeySound_Male[i]=music(DynamicLoadObject(TempVoice, class'music'));
//            }
//        }
//    }
//    else
//    {
//        for(i=1; i<=Voice_XNum; i++)
//        {
//            TempVoice = CFG_Voice.GetString("Voice_X"$i);
//            if(TempVoice != "none")
//            {
//                SMXKeySound_FeMale[i]=music(DynamicLoadObject(TempVoice, class'music'));
//            }
//        }
//
//    }

}

defaultproperties
{
}
