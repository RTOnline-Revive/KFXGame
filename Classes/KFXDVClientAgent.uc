//-----------------------------------------------------------
//  Class:      KFXGame.KFXVoiceClientAgent
//  Creator:    wangkai1@kingsoft Íõ¿­
//  Data:       2008-05-19
//  Desc:       DolbyÓïÒô¿Í»§¶ËÀà£¬nativeÓÃDolbyÓïÒô¿âµÄ¿Í»§¶ËAPIÊµÏÖ
//  Update:
//  Special:
//-----------------------------------------------------------

class KFXDVClientAgent extends Actor
    config(user)
    native;

/*
enum EKFXTalkMode
{
    TKM_LISTEN,
    TKM_SPEAK,
    TKM_LISTEN_SPEAK
};
*/

enum EDVDevice
{
	DEV_UNKNOWN,
	DEV_CAPTURE,
	DEV_HEADPHONES,
	DEV_STEREOSPEAKERS,
	DEV_SURROUNDSPEAKERS
};

enum EDVEngine
{
	ENG_DEFAULT,
	ENG_MONO,
	ENG_DIRECTX,
	ENG_DOLBYHEADPHONE,
	ENG_DOLBYVIRTUALSPEAKER
};

enum EDVMicTest
{
	MICT_LOOPBACK,
	MICT_TO_SERVER
};

enum EDVSpeakTest
{
	SPKT_VOICE_5_1,  //5.1 speaker enum with voice
	SPKT_NOISE_5_1,  //5.1 speaker enum with noise
	SPKT_NOISE_SWEEP //noise sweeping through 360 degrees
};

enum EDVRoomMode
{
	RM_NORMAL,
	RM_CAVERN,
	RM_SMALL
};

enum EDVVoiceFont
{
	VF_NONE,
	VF_PRESET_W2M,
	VF_PRESET_M2W,
	VF_PRESET_ELF,
	VF_PRESET_PIG1,
	VF_PRESET_PIG2,
	VF_PRESET_PIG3,
	VF_PRESET_TORTOISE1,
	VF_PRESET_TORTOISE2,
	VF_PRESET_TORTOISE3,
	VF_EXT_MALE1,
	VF_EXT_MALE2,
	VF_EXT_MALE3,
	VF_EXT_FEMALE1,
	VF_EXT_FEMALE2,
	VF_EXT_FEMALE3
};

struct native init DVDeviceInfo
{
	var int nId;                       				//device id
	var string sName;                  				//device name as reported by DirectX
	var EDVDevice DevType;
	var bool bSysDefault;              				//true if device is system default device
	var bool bDVDefault;               				//true if device is selected as default for new ice clients
	var EDVEngine Engine;              				//audio engine type to use if this is
};                                     				//an output device, ignored for capture devices

struct native init DVClientStatus
{
	var int nPing;                             		// Round trip time in ms of last ping message
	var int nNetIn;                            		// Total payload bytes received
	var int nNetOut;                           		// Total payload bytes sent
	var string sGameServerName;                		// Name of Game server (this is "" if not properly connected)
	var string sAudioServerName;               		// Name of Audio server (this is "" if not properly connected)
	var byte TalkVolume;                       		// non zero value between 1 and 255 indicating talking volume if player is currently talking
	var bool bRunning;                         		// set if the client is running, i.e the library is processing audio
	var bool bPremium;                         		// set if the client is in premium mode
};


enum EDVTalkType
{
    DVTT_SPATIAL,                              		// glabal 3D voice
    DVTT_TEAM,                                 		// walkie-talkie voice, team only
    DVTT_SPATIAL_TEAM                          		// both of spatial and team
};

//-------------------- variables ----------------------------------
var globalconfig bool bDVPremium;                              	// if the client use a surround sound effect

var globalconfig EDVEngine DVEngine;                           	// engine type of client

var globalconfig int DVCodec;                                  	// codec of client

var globalconfig float DVListenVolume;                         	// volume for listening

var globalconfig float DVSpeakVolume;                          	// volume for speak

var globalconfig bool bDVListenEnabled;                        	// if this player can hear from the world

var globalconfig bool bDVSpeakEnabled;                         	// if this player can speak in the world

//var EDVTalkType DVTalkType;                     	// which talk type this player use

var bool bDVUpdateStatus;                         	// if the Dolby client info should be updated every tick, see Timer for reference

var DVClientStatus DVStatus;                      	// the status of Dolby client

var EDVVoiceFont DVCurVoiceFont;                    // the Voice-font used currently

var bool bDVValid;                                  // if the client is healthy

var bool bDVTeamTalk;                             	// if talk to other team members

var bool bDVSpatialTalk;                          	// if talk in spatial channel

var byte DVSpatialChnMapping;                     	// spatial channel id

var byte DVTeamChnMapping;                        	// team id, walkie-talkie related

var float DVUpdateInterval;                       	// Interval of update, (second)

//ÆÁ±ÎÁÐ±í
var array<int> BannedID;                            // list of banned id

// -----------------------------------------------------------------



// ----------------------------------------
// ¸ù¾Ý²»Í¬µÄVoiceÈ¡µ½ÏÔÊ¾ÓÃÍ¼Æ¬µÄURL
// ----------------------------------------
static function string DVGetSpeakIndicator(byte VoiceFont, bool bMute, bool bLarge)
{
    local KFXCSVTable CfgTable;
    local string QueryStr;
    if (_ValidateVoiceFont(VoiceFont))
    {
        CfgTable = class'KFXTools'.static.GetConfigTable(200);
        if (CfgTable != none && CfgTable.SetCurrentRow(VoiceFont))
        {
            if (bMute)
            {
                if (bLarge)
                    QueryStr = "PicLargeMuted";
                else
                    QueryStr = "PicSmallMuted";
            }
            else
            {
                if (bLarge)
                    QueryStr = "PicLarge";
                else
                    QueryStr = "PicSmall";
            }
            return CfgTable.GetString(QueryStr);
        }
    }
}

// ----------------------------------------
// ·µ»Øµ±Ç°VoiceFont
// ----------------------------------------
function byte DVGetCurVoiceFont()
{
    return DVCurVoiceFont;
}




// ----------------------------------------
// ÆÁ±ÎÁÐ±íÀïÉ¾³ýÒ»Ìõ¼ÇÂ¼
// ----------------------------------------
function DVRemoveBan(int ID)
{
    local int i;
    for (i=0; i<BannedID.length; i++)
    {
        if (BannedID[i] == ID)
        {
            BannedID.Remove(i, 1);
            return;
        }
    }
}
// ----------------------------------------
// ÆÁ±ÎÁÐ±íÀïÌí¼ÓÒ»Ìõ¼ÇÂ¼
// ----------------------------------------
function DVAddBan(int ID)
{
    local int i;
    for (i=0; i<BannedID.length; i++)
    {
        if (BannedID[i] == ID)
            return;
    }
    BannedID[BannedID.length] = ID;
}

// ----------------------------------------
// ÊÇ·ñÔÚÆÁ±ÎÁÐ±íÀï
// ----------------------------------------
function bool DVInBanList(int ID)
{
    local int i;
    for (i=0; i<BannedID.length; i++)
    {
        if (BannedID[i] == ID)
            return true;
    }
    return false;
}

// ----------------------------------------
// Íæ¼ÒÊÇ·ñÕýÔÚËµ»°
// ----------------------------------------
function bool DVIsTalking()
{
    return
        (bDVTeamTalk || bDVSpatialTalk);
}

//=====================> »ªÀöµÄ·Ö¸îÏß£¬ÉÏÃæÊÇÂß¼­Ïà¹Ø½Ó¿Ú£¬ºóÃæÊÇ¹¦ÄÜÏà¹Ø½Ó¿Ú <=====================

// ----------------------------------------
// Æô¶¯¿Í»§¶Ë
// ----------------------------------------
function DVStart()
{
    local array<byte> OnlyTalkMap;
    // ¿ªÊ¼¹¤×÷£¡
    if (DVUpdateInterval > 0)
    {
        SetTimer(DVUpdateInterval, true);
        log ("[Dolby Voice] Client stated. Update interval "$ DVUpdateInterval);

        // ICE¿â¿ªÊ¼¹¤×÷°É£¡£¨Ëä¿ÉÒÔÖØ¸´µ÷ÓÃ´Ë½Ó¿Ú£¬µ«±ðÃ¿Ö¡¶¼µ÷~~£©
        _DVAutoTick();

        //Ò»Ð©ÉèÖÃ
        bDVValid = true;

        //<< HACK!!! Íæ¼ÒÓÐÊ±¿ÉÒÔÔÚÄ³¸öÆµµÀÀïËµ»°£¬ÕâÊÇÒ»¸öBug
        OnlyTalkMap[0] = 0;
        _DVOnlyTalkIntoChannelMapping(OnlyTalkMap);
        _DVTalkIntoChannelMapping(0, false);
        //>>

        _DVTalkIntoChannelMapping(DVSpatialChnMapping, bDVSpatialTalk);
        if (DVTeamChnMapping != -1)
            _DVTalkIntoChannelMapping(DVTeamChnMapping, bDVTeamTalk);
        else
            log ("[Dolby Voice] Mode without init team talk");
    }
    else
    {
        log ("[Dolby Voice] Error! Invalid default update interval: "$ DVUpdateInterval);
    }
}

// ----------------------------------------
// ¿Í»§¶ËÇåÀí
// ----------------------------------------
function DVCleanUp()
{
    //ÇåÀíÆÁ±ÎÁÐ±í
    BannedID.Remove(0, BannedID.Length);
    //ÖØÖÃ±äÁ¿
    bDVListenEnabled = default.bDVListenEnabled;
    bDVSpeakEnabled = default.bDVSpeakEnabled;
    bDVSpatialTalk = default.bDVSpatialTalk;
    bDVTeamTalk = default.bDVTeamTalk;

    //Kill timer
    SetTimer(0, false);
}

// ----------------------------------------
// Set if talk to team
// ----------------------------------------
function DVSetTeamTalkEnable(bool bTeamTalk)
{
    if (bTeamTalk == bDVTeamTalk)
        return;
    //_DVSetTeamTalkEnable(bTeamTalk);
    if (DVTeamChnMapping == -1)
    {
        log ("[Dolby Voice] Invalid team channel mapping id");
        return;
    }
    if (_DVTalkIntoChannelMapping(DVTeamChnMapping, bTeamTalk))
        bDVTeamTalk = bTeamTalk;
}

function DVSetSpatialTalkEnable(bool bSpatialTalk)
{
    if (bSpatialTalk == bDVSpatialTalk)
        return;
    if (DVSpatialChnMapping == -1)
    {
        log ("[Dolby Voice] Invalid spatial channel mapping id");
        return;
    }
    if (_DVTalkIntoChannelMapping(DVSpatialChnMapping, bSpatialTalk))
         bDVSpatialTalk = bSpatialTalk;
}


// ----------------------------------------
// Return if the player can hear from the world
// ----------------------------------------
function bool DVIsListenEnabled()
{
    return bDVListenEnabled;
}

// ----------------------------------------
// Return if the player can speak in the world
// ----------------------------------------
function bool DVIsSpeakEnabled()
{
    return bDVSpeakEnabled;
}

// ----------------------------------------
// Set Player Name, ID and TeamChannel ID
// ----------------------------------------
function bool DVSetClientInfo(int nGameID, string sPlayerName, int nPlayerID, byte nSpatialChnMapping, byte nTeamChnMapping)
{
    if (_DVSetClientInfo(nGameID, sPlayerName, nPlayerID))
    {
        if (/*nTeamChnMapping != -1 && */   // -1±íÊ¾Ã»ÓÐ¶ÓÎé
            nSpatialChnMapping != -1)
        {
            DVSpatialChnMapping = nSpatialChnMapping;
            DVTeamChnMapping = nTeamChnMapping;
            return true;
        }
        else
        {
            log ("[Dolby Voice] DVSetClientInfo Error! Team Id Is 0");
            return false;
        }
    }
    return false;
}

// ----------------------------------------
// ¸ü»»¶ÓÎé
// ----------------------------------------
function DVChangeTeam(byte nNewTeamChnMapping)
{
    DVTeamChnMapping = nNewTeamChnMapping;
}

// ----------------------------------------
// Set if can listen, globally
// ----------------------------------------
function DVSetListenEnable(bool bCanListen)
{
    _DVSetListenEnable(bCanListen);
}

// ----------------------------------------
// Set if can speak, globally
// ----------------------------------------
function DVSetSpeakEnable(bool bCanSpeak)
{
    _DVSetSpeakEnable(bCanSpeak);
}

// ----------------------------------------
// Set the listen volume
// ----------------------------------------
function bool DVSetListenVolume(float Value)
{
    if (_DVSetListenVolume(Value))
    {
        DVListenVolume = Value;
        return true;
    }
    else
        return false;
}

// ----------------------------------------
// Set IP and port of Dolby Control Server
// ----------------------------------------
function bool DVSetAudioServerInfo(string sCSIp,  coerce int sCSPort)
{
    return _DVSetAudioServerInfo(sCSIP, sCSPort);
}

// ----------------------------------------
// return the status of the Dolby client
// ----------------------------------------
function bool DVGetStatus(out DVClientStatus Status)
{
    return _DVGetStatus(Status);
}

// ----------------------------------------
// Check If Dolby Client Library Available
// & and do some variable init job
// ----------------------------------------
function bool DVInit()
{
    return _DVInit();
}

// ----------------------------------------
// Check If Dolby Client Library Available
// ----------------------------------------
function bool DVIsActive()
{
    return _DVIsActive();
}

// ----------------------------------------
// Set Room Mode for rending current Sound
// ----------------------------------------
function bool DVSetRoomMode(EDVRoomMode RoomMode)
{
    return _DVSetRoomMode(RoomMode);
}

// ----------------------------------------
// Set Voice Font for current voice input
// ----------------------------------------
// *** ÍâÎ§Ê¹ÓÃ·½±ã£¬ÁÙÊ±¸ÄÎªbyte²ÎÊý ***
//function bool DVSetVoiceFont(EDVVoiceFont VoiceFont)
function bool DVSetVoiceFont(byte VoiceFont)
{
    if (_ValidateVoiceFont(VoiceFont) && _DVSetVoiceFont(EDVVoiceFont(VoiceFont)))
    {
        DVCurVoiceFont = EDVVoiceFont(VoiceFont);
        return true;
    }
    return false;
}

// ----------------------------------------
// Set if talk into specified channelmapping
// ----------------------------------------
function bool DVTalkIntoChannelMapping(byte nChannelMapping, bool bTalk)
{
    return _DVTalkIntoChannelMapping(nChannelMapping, bTalk);
}

// ----------------------------------------
// Set to talk ONLY into specified channelmappings,
// any other channelmappings which are not in this list will NOT be
// talk into
// ----------------------------------------
function bool DVOnlyTalkIntoChannelMapping(array<byte> aChannelMappings)
{
    return _DVOnlyTalkIntoChannelMapping(aChannelMappings);
}

// ----------------------------------------
// Get info. of all input devices on this computer
// READONLY!!!
// ----------------------------------------
function bool DVGetCurrentInputDevice(out DVDeviceInfo Device)
{
    return _DVGetCurrentInputDevice(Device);
}

// ----------------------------------------
// Get info. of all output devices on this computer
// READONLY!!!
// ----------------------------------------
function bool DVGetCurrentOutputDevice(out DVDeviceInfo Device)
{
    return _DVGetCurrentOutputDevice(Device);
}

function bool DVGetAllDevice(out array<DVDeviceInfo> Devices)
{
    return _DVGetAllDevice(Devices);
}

// ----------------------------------------
// Set input device for dolby voice
// ----------------------------------------
function bool DVSetCurrentInputDevice(DVDeviceInfo Device, optional bool bSetAsDefault)
{
    return _DVSetCurrentInputDevice(Device, bSetAsDefault);
}

// ----------------------------------------
// Set output device for dolby voice
// ----------------------------------------
function bool DVSetCurrentOutputDevice(DVDeviceInfo Device, optional bool bSetAsDefault)
{
    return _DVSetCurrentOutputDevice(Device, bSetAsDefault);
}

// ----------------------------------------
// ²âÊÔÊä³ö¿ªÊ¼
// ----------------------------------------
function bool DVStartSpeakTest(EDVSpeakTest SpeakTestMode)
{
    return _DVStartSpeakTest(SpeakTestMode);
}

// ----------------------------------------
// ²âÊÔÊä³öÍ£Ö¹
// ----------------------------------------
function bool DVStopSpeakTest()
{
    return _DVStopSpeakTest();
}

// ----------------------------------------
// ²âÊÔÊäÈë£º¿ªÊ¼Â¼Òô
// ----------------------------------------
function bool DVStartMicTest_Record()
{
    return _DVStartMicTest_Record();
}

// ----------------------------------------
// ²âÊÔÊäÈë£º²¥·ÅÂ¼Òô
// ----------------------------------------
function bool DVStartMicTest_Play(EDVMicTest MicTestMode)
{
    return _DVStartMicTest_Play(MicTestMode);
}

// ----------------------------------------
// ²âÊÔÊäÈë£ºÖÐÖ¹Â¼Òô»òÖÐÖ¹²¥·Å
// ----------------------------------------
function bool DVStopMicTest()
{
    return _DVStopMicTest();
}

// ----------------------------------------
// ÉèÖÃ¿Í»§¶ËÓïÒôÒýÇæ
// ----------------------------------------
function bool DVSetEngine(EDVEngine Engine)
{
    if(_DVSetEngine(Engine))
    {
        DVEngine = Engine;
        return true;
    }
    return false;
}

function DVPause()
{
    _DVPause();
}

// ----------------------------------------
// Called when speak test finishes,
// called after _DVStartSpeakTest has finished its work
// ----------------------------------------
delegate function OnSpeakTestDone()
{
    log ("[Dolby Voice] Speak test done");
}

// ----------------------------------------
// Called when mic test finishes,
// called after _DVStartMicTest_Play has finished its work
// ----------------------------------------
delegate function OnMicTestDone()
{
    log ("[Dolby Voice] Mic test done");
}

static function bool _ValidateVoiceFont(byte VoiceFont)
{
    if (VoiceFont > EDVVoiceFont.VF_EXT_FEMALE3)//EnumCount(EDVVoiceFont)) -- obsoleted???
    {
        log ("[Dolby Voice] Invalide VoiceFont");
        return false;
    }
    return true;
}

//<< private & native methods, using INSIDE of this class is strongly recommended
native function _DVSetListenEnable(bool bCanListen);
native function _DVSetSpeakEnable(bool bCanSpeak);
native function bool _DVSetListenVolume(float Value);
native function bool _DVSetAudioServerInfo(string sCSIp, int sCSPort);
native function bool _DVSetClientInfo(int nGameID, string sPlayerName, int nPlayerID);
native function bool _DVInit();
native function bool _DVIsActive();
native function _DVSetRotation(rotator rotation);
native function bool _DVGetStatus(DVClientStatus status);
native function _DVTick();
native function bool _DVSetRoomMode(EDVRoomMode RoomMode);
native function bool _DVSetVoiceFont(EDVVoiceFont VoiceFont);
native function bool _DVTalkIntoChannelMapping(byte nChannelMapping, bool bTalk);
native function bool _DVOnlyTalkIntoChannelMapping(array<byte> aChannelMappings);
native function bool _DVGetAllDevice(out array<DVDeviceInfo> Devices);
native function bool _DVGetCurrentInputDevice(out DVDeviceInfo Device);
native function bool _DVGetCurrentOutputDevice(out DVDeviceInfo Device);
native function bool _DVSetCurrentInputDevice(DVDeviceInfo Device, bool bSetAsDefault);
native function bool _DVSetCurrentOutputDevice(DVDeviceInfo Device, bool bSetAsDefault);
native function bool _DVStartSpeakTest(EDVSpeakTest SpeakTestMode);
native function bool _DVStopSpeakTest();
native function bool _DVStartMicTest_Record();
native function bool _DVStartMicTest_Play(EDVMicTest MicTestMode);
native function bool _DVStopMicTest();
native function bool _DVSetEngine(EDVEngine Engine);
native function _DVAutoTick();//ÈÃICEClientlib×Ô¶¯Tick
native function _DVPause();     // ÔÝÍ£¿Í»§¶Ë
//>>




event Timer()
{
    local KFXPlayer VoicePlayer;
    VoicePlayer = KFXPlayer(Level.GetLocalPlayerController());
    if (none == VoicePlayer)
    {
        log("[KFXDVClientAgent] Error! none Voice Player In Timer");
        return;
    }
    _DVSetRotation(VoicePlayer.Rotation);

    // we use _DVAutoTick in DVStart() instead
    //_DVTick();

    //ÌîÔÊStatusÊý¾Ý
    if (bDVUpdateStatus)
    {
        _DVGetStatus(DVStatus);
        //log("PlayerVolume: "$DVStatus.TalkVolume);
    }
}

defaultproperties
{
     bDVPremium=是
     DVEngine=ENG_MONO
     DVCodec=20
     DVListenVolume=1.000000
     DVSpeakVolume=1.000000
     bDVListenEnabled=是
     bDVSpeakEnabled=是
     bDVUpdateStatus=是
     DVUpdateInterval=0.020000
     bHidden=是
     bSkipActorPropertyReplication=是
     bOnlyDirtyReplication=是
     RemoteRole=ROLE_None
}
