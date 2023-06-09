//-----------------------------------------------------------
//  Class:      KFXGame.KFXVoiceServerAgent
//  Creator:    wangkai1@kingsoft Íõ¿­
//  Data:       2008-05-19
//  Desc:       DolbyÓïÒôÓÎÏ··þÎñÆ÷Àà£¬nativeÓÃDolbyÓïÒô¿âÓÎÏ··þÎñÆ÷APIÊµÏÖ
//  Update:
//  Special:
//-----------------------------------------------------------

class KFXDVServerAgent extends Actor
    native
    config(KFXGameRPInfo);


enum EDVChannel
{
    CHN_SPATIAL,        //£¨¾àÀë¸Ð+·½Î»¸Ð£© Á¢Ìå ÓïÒôÆµµÀ
    CHN_NON_SPATIAL,    //£¨¾àÀë¸Ð£© Á¢Ìå ÓïÒôÆµµÀ
    CHN_DIRECT_WK,      //£¨·½Î»¸Ð£© ¶Ô½²»ú ÓïÒôÆµµÀ
    CHN_NORM_WK         //¶Ô½²»ú ÓïÒôÆµµÀ
};

enum EDVChannelProperty
{
	CHP_HEARING_RANGE,                     // hearing range of the channel, read only, spatial only, int
	CHP_EFFECT,                            // channel effect, non spatial only, 0 for none, 1 for noise, int
	CHP_NUM_AVATARS,                       // number of players in this channel, read only, int
	CHP_SPATIAL                            // 0 if nonspatial, 1 if spatial, read only, int
};

enum EDVPriority
{
    PRI_0,  //½«À´¿ÉÒÔ¸Ä³ÉÆäËüµÄÃüÃû
    PRI_1,
    PRI_2,
    PRI_3
};

struct native DVPlayerStatus
{
	var byte   TalkVolume;                // player talking volume: 0 if not taling, indicative volume 1-255 if player is talking
	var int    nLastContactSeconds;		  // Number of seconds since the player last contacted the server
	var bool   bConnected;         		  // true if the player is currently in contact with the server
	var bool   bPremium;          		  // true if the client is premium
	var int    nMorphID;           		  // Voice morphing ID used by the client (if any)
};

struct native DVAudioServerStatus
{
	//control server
	var bool control_server_connected;     // 1 if libICE is properly connected to its control server, 0 otherwise
	var int control_server_uptime;         // seconds the control server has been running
	var float control_server_load;         // 1 if normal, >1 if simplification occurs

	//audio server
	var bool audio_server_connected;       // 1 if the audio server is properly connected to the control server, 0 o/w
	var int audio_server_uptime;           // seconds the audio server has been running
	var float audio_server_load;           // 1 if normal, >1 if simplification occurs
	var int clients_connected;             //number of clients connected in the game in last second
	var int clients_connected2;            //number connected to a client in last second

	//Audio server network stats
	var int packets_out;                   //number of packets sent since startup
	var int packets_out_sec;               //number of packets sent in last second
	var float kbytes_out;                  //number of kilobytes sent
	var int bytes_out_sec;                 //number of bytes sent in last second
	var int packets_in;                    //number of packets recv since startup
	var int packets_in_sec;                //number of packets recv in last second
	var float kbytes_in;                   //number of kilobytes recv
	var int bytes_in_sec;                  //number of bytes recv in last second
};

var int         DVSpatialChnID;             // ¿Õ¼äÆµµÀID
var int         DVTeam1ChnID;               // ¶ÓÎé1¶Ô½²»úÆµµÀ
var int         DVTeam2ChnID;               // ¶ÓÎé2¶Ô½²»úÆµµÀ
var int         DVTeam1DirChnID;            // ¶ÓÎé1´ø·½Ïò¶Ô½²»úÆµµÀ
var int         DVTeam2DirChnID;            // ¶ÓÎé2´ø·½Ïò¶Ô½²»úÆµµÀ

var int         DVSpatialChnMapping;        // ¿Õ¼äÆµµÀIDÓ³Éä
var int         DVTeam1ChnMapping;          // ¶ÓÎé1ÆµµÀIDÓ³Éä
var int         DVTeam2ChnMapping;          // ¶ÓÎé2ÆµµÀIDÓ³Éä

var string      DVASIP;                     // Audio·þÎñÆ÷IP
var int         DVASPort;                   // Audio·þÎñÆ÷¶Ë¿Ú
var string      DVCSIP;                     // Control·þÎñÆ÷IP
var int         DVCSPort;                   // Control·þÎñÆ÷IP
var float       DVUpdateInterval;           // ·þÎñÆ÷¸üÐÂÖÜÆÚ
var int         DVGameID;                   // ÓÎÏ··þÎñÆ÷±àºÅ
var config float DVDefHearRange;            // Ä¬ÈÏÌýÁ¦·¶Î§


//--------------------------------
// ³õÊ¼»¯º¯Êý£¬·µ»ØÊÇ·ñ³É¹¦
//--------------------------------
function bool DVInit()
{
    if(_DVInit())
    {
        log ("[Dolby Voice] <DVInit> Server Initialized");
        log ("[Dolby Voice] HearingRange: "$DVDefHearRange);
        return true;
    }
    else
    {
        log ("[Dolby Voice] <DVInit> Error! Server Init Failed");
        return false;
    }
}

//--------------------------------
// ³õÊ¼»¯º¯Êý£¬·µ»ØÊÇ·ñ³É¹¦
//--------------------------------
function bool DVStart()
{
    // ¿ªÊ¼¹¤×÷£¡
    if (DVUpdateInterval > 0)
    {
        SetTimer(DVUpdateInterval, true);
        log ("[Dolby Voice] Server Started. Update Interval "$ DVUpdateInterval);
        return true;
    }
    else
    {
        log ("[Dolby Voice] Error! Invalid default Update Interval: "$ DVUpdateInterval);
        return false;
    }
}

//--------------------------------
// ÇåÀíDolby
//--------------------------------
function DVCleanUp()
{
    _DVDestroy();
    SetTimer(0, false);

    DVSpatialChnMapping = 0;
    DVTeam1ChnMapping   = 1;
    DVTeam2ChnMapping   = 2;
    DVASIP              = "";
    DVASPort            = 0;
    DVCSIP              = "";
    DVCSPort            = 0;
    //DVGameID            = 0;
}

//--------------------------------
// ÉêÇëÒ»¸öÐÂµÄÆµµÀ
// ·µ»ØChannelMappingID£¬´íÎóÊ±·µ»Ø-1
//--------------------------------
function int DVCreateChannel(EDVChannel Type)
{
    return _DVCreateChannel(Type);
}

//--------------------------------
// Ïú»ÙÖ¸¶¨ÆµµÀ
//--------------------------------
function bool DVDestroyChannel(int nChannelID)
{
    return _DVDestroyChannel(nChannelID);
}

//--------------------------------
// µÃµ½ÆµµÀÌýÁ¦·¶Î§
//--------------------------------
function int DVGetChannelHearingRange(int nChannelID)
{
    return _DVGetChannelProperty(nChannelID, CHP_HEARING_RANGE);
}

//--------------------------------
// µÃµ½ÆµµÀÊÇ·ñÎª´øÔÓÒôµÄ¶Ô½²»ú
//--------------------------------
function bool DVIsChannelNoisy(int nChannelID)
{
    return bool(_DVGetChannelProperty(nChannelID, CHP_EFFECT));
}

//--------------------------------
// µÃµ½ÆµµÀÖÐµÄÍæ¼ÒÈËÊý
//--------------------------------
function int DVGetChannelAvatarNum(int nChannelID)
{
    return _DVGetChannelProperty(nChannelID, CHP_NUM_AVATARS);
}

//--------------------------------
// µÃµ½ÆµµÀÊÇ·ñÊÇSpatial Channel
//--------------------------------
function bool DVIsChannelSpatial(int nChannelID)
{
    return bool(_DVGetChannelProperty(nChannelID, CHP_SPATIAL));
}


//--------------------------------
// ÉèÖÃÆµµÀÊÇ·ñÊÇ´øÔÓÒôµÄ¶Ô½²»ú
//--------------------------------
function bool DVSetChannelNoisy(int nChannelID, bool bNoisy)
{
    local int nNoisy;
    if (bNoisy)
        nNoisy = 1;
    else
        nNoisy = 0;
    return _DVSetChannelProperty(nChannelID, CHP_EFFECT, nNoisy);
    }

//--------------------------------
// Á¬½ÓÒ»¸öÍæ¼Ò
//--------------------------------
function bool DVConnectPlayer(KFXPlayer Player)
{
    local string sName, sIP;
    local int nID, nTeam;
    local bool bSpatial;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVConnectPlayer> Error! Null Player");
        return false;
    }

    sName = Player.PlayerReplicationInfo.PlayerName;  //Player.fxDBPlayerInfo.PlayerName;
    sIP = Player.KFXPlayerIP;
    nID = DVGetPlayerID(Player);
    nTeam = Player.DVGetInitTeamID(); //Player.fxDBPlayerInfo.TeamID;
    bSpatial = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).bKFXSpatial;

    if (sName == "" || sIP == "" || nID == -1 )
    {
        log ("[Dolby Voice] <DVConnectPlayer>  Error! Result In Invalid Params");
        log ("Name: "$ sName);
        log ("IP: "$ sIP);
        log ("ID: "$ nID);

        return false;
    }

    log ("[Dolby Voice] <DVConnectPlayer> To Connect Player: "$sName);

    if ( !_DVConnectPlayer(sName, nID, sIP) )
    {
        return false;
    }

    return _DVChangeTeam(nID, nTeam, bSpatial);
}

//--------------------------------
// ¶Ï¿ªÒ»¸öÍæ¼Ò
//--------------------------------
function bool DVDisconnectPlayer(KFXPlayer Player)
{
    local int nID;
    if (Player == none)
    {
        log ("[Dolby Voice] <DVDisconnectPlayer> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVDisconnectPlayer> To Disconnect Player(ID): "$ nID);

    return _DVDisconnectPlayer(nID);
}

//--------------------------------
// Í¨Öª¸ü»»¶ÓÎé
//--------------------------------
function bool DVChangeTeam(KFXPlayer Player, int nTeamID)
{
    local int nID;
    local bool bSpatial;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChangeTeam> Null Player");
        return false;
    }

    if (nTeamID != 0 && nTeamID != 1 && nTeamID != 255)
    {
        Warn ("[Dolby Voice] Invalid team id when DVChangeTeam");
    }

    nID = DVGetPlayerID(Player);
    bSpatial = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).bKFXSpatial;
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChangeTeam> To Change Team. Player(ID): "$ nID $", TeamID: "$nTeamID $", DirWalkie-Talkie: "$bSpatial);

    return _DVChangeTeam(nID, nTeamID, bSpatial);
}

function DVGetMappedChannels(out array<int> nChannelIDs, int nChannelMapping)
{
    nChannelIDs.remove(0, nChannelIDs.length);
    switch (nChannelMapping)
    {
    case DVSpatialChnMapping:
        nChannelIDs.insert(0, 1);
        nChannelIDs[0] = DVSpatialChnID;
        break;
    case DVTeam1ChnMapping:
        nChannelIDs.insert(0, 2);
        nChannelIDs[0] = DVTeam1ChnID;
        nChannelIDs[1] = DVTeam1DirChnID;
        break;
    case DVTeam2ChnMapping:
        nChannelIDs.insert(0, 2);
        nChannelIDs[0] = DVTeam2ChnID;
        nChannelIDs[1] = DVTeam2DirChnID;
        break;
    }
}

//--------------------------------
// µÃµ½TeamChannel Mapping
//--------------------------------
function int DVGetTeamChnMapping(int nTeamID)
{
    if (nTeamID == 0)
        return DVTeam1ChnMapping;
    else if (nTeamID == 1)
        return DVTeam2ChnMapping;
    else
        return -1;// -1 indicates no team channels
}

//--------------------------------
// ¸ù¾ÝTeamIDµÃµ½ team channel id
//--------------------------------
function int DVGetTeamChannel(int nTeamID)
{
    if (nTeamID == 0)
        return DVTeam1ChnID;
    else if (nTeamID == 1)
        return DVTeam2ChnID;
    else
        return -1;
}

//--------------------------------
// ¸ù¾ÝTeamIDµÃµ½ team dir channel id
//--------------------------------
function int DVGetTeamDirChannel(int nTeamID)
{
    if (nTeamID == 0)
        return DVTeam1DirChnID;
    else if (nTeamID == 1)
        return DVTeam2DirChnID;
    else
        return -1;
}

//--------------------------------
// µÃµ½Íæ¼Ò×´Ì¬
//--------------------------------
function bool DVGetPlayerStatus(KFXPlayer Player, out DVPlayerStatus status)
{
    local int nID;
    if (Player == none)
    {
        log ("[Dolby Voice] <DVGetPlayerStatus> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    return _DVGetPlayerStatus(nID, status);
}

//--------------------------------
// ÉèÖÃÍæ¼ÒÔÚÄ³Ò»ÆµµÀÄÚµÄÎ»ÖÃ
//--------------------------------
function bool DVSetPlayerChannelPos(KFXPlayer Player, int nChannelID, vector vLocation, rotator rRotation)
{
    local int nID;
    if (Player == none)
    {
        log ("[Dolby Voice] <DVSetPlayerChannelPos> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;
    return _DVSetPlayerChannelPos(nID, nChannelID, vLocation, rRotation);
}

//--------------------------------
// ÉèÖÃÊÇ·ñÊ¹Ä³ÈËÆÁ±ÎÄ³ÈË;
// nID--ÒªÆÁ±Î±ðÈËµÄÍæ¼ÒID, nMuteID--±»ÆÁ±ÎµÄÍæ¼ÒID
//--------------------------------
function bool DVMuteOneToOne(KFXPlayer Player, KFXPlayer MutePlayer, bool bMute)
{
    local int nID, nMuteID;
    if (Player == none)
    {
        log ("[Dolby Voice] <DVMuteOneToOne> Null Player");
        return false;
    }

    if (MutePlayer == none)
    {
        log ("[Dolby Voice] <DVMuteOneToOne> Null MutePlayer");
        return false;
    }

    if (Player == MutePlayer)
    {
        log ("[Dolby Voice] <DVMuteOneToOne> Player cannot mute self");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    nMuteID = DVGetPlayerID(MutePlayer);
    if (nMuteID == -1)
        return false;

    log ("[Dolby Voice] <DVMuteOneToOne> To MuteOneToOne(ID): "$ nID $" Mutes "$ nMuteID);

    return _DVMuteOneToOne(nID, nMuteID, bMute);
}

//--------------------------------
// ÉèÖÃÊÇ·ñÊ¹Ä³ÈËÆÁ±Î¶àÈË;
// nID--ÒªÆÁ±Î±ðÈËµÄÍæ¼Ò, nMuteIDs--±»ÆÁ±ÎµÄÍæ¼ÒIDÁÐ±í
// ¼ì²é TODO
//--------------------------------
function bool DVMuteOneToMany(KFXPlayer Player, array<KFXPlayer> MutePlayers, bool bMute)
{
    local int i;
    local int nID;
    local array<int> MuteIDs;
    MuteIDs.Insert(0, MutePlayers.length);

    if (Player == none)
    {
        log ("[Dolby Voice] <DVMuteOneToMany> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    for (i=0; i<MutePlayers.length; i++)
    {
        MuteIDs[i] = DVGetPlayerID(MutePlayers[i]);
        if (MuteIDs[i] == -1)
            return false;
    }

    log ("[Dolby Voice] <DVMuteOneToMany> To MuteOneToMany(ID): "$ nID $" Mutes Many");

    return _DVMuteOneToMany(nID, MuteIDs, bMute);
}

//--------------------------------
// ÉèÖÃÊÇ·ñÊ¹¶àÈËÆÁ±ÎÄ³ÈË;
// nIDs--ÒªÆÁ±Î±ðÈËµÄ¶à¸öÍæ¼ÒIDÁÐ±í, nMuteID--±»ÆÁ±ÎµÄÍæ¼ÒID
// ¼ì²é TODO
//--------------------------------
function bool DVMuteManyToOne(array<KFXPlayer> Players, KFXPlayer MutePlayer, bool bMute)
{
    local int i;
    local int nMuteID;
    local array<int> IDs;
    IDs.Insert(0, Players.length);

    if (MutePlayer == none)
    {
        log ("[Dolby Voice] <DVMuteManyToOne> Null Player");
        return false;
    }

    nMuteID = DVGetPlayerID(MutePlayer);
    for (i=0; i<Players.length; i++)
    {
        IDs[i] = DVGetPlayerID(Players[i]);
    }

    log ("[Dolby Voice] <DVMuteManyToOne> To MuteManyToOne(ID): Many Mute "$ nMuteID);

    return _DVMuteManyToOne(IDs, nMuteID, bMute);
}

//--------------------------------
// µÃµ½·þÎñÆ÷µ±Ç°×´Ì¬
//--------------------------------
function bool DVGetAudioServerStatus(out DVAudioServerStatus status)
{
    return _DVGetServerStatus(status);
}


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//--------------------------------
// Ê¹Ò»¸öÍæ¼ÒÔÚÄ³¸öÆµµÀÀïÄÜËµ
//--------------------------------
function bool DVChannelTalkJoin(KFXPlayer Player, int nChannelID, int nChannelMapping, EDVPriority Priority)
{
    local int nID;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChannelTalkJoin> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChannelTalkJoin> Player(ID) "$ nID $" To Talk Join "$ nChannelID $ "With Priority "$ Priority);

    return _DVChannelTalkJoin(nID, nChannelID, nChannelMapping, Priority);
}

//--------------------------------
// Ê¹Ò»¸öÍæ¼ÒÔÚÄ³¸öÆµµÀÀï²»ÄÜËµ
//--------------------------------
function bool DVChannelTalkLeave(KFXPlayer Player, int nChannelID)
{
    local int nID;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChannelTalkLeave> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChannelTalkLeave> Player(ID) "$ nID $" To Talk Leave "$ nChannelID);

    return _DVChannelTalkLeave(nID, nChannelID);
}

//--------------------------------
// Ê¹Ò»¸öÍæ¼ÒÔÚËùÓÐÆµµÀÀï²»ÄÜËµ
//--------------------------------
function bool DVChannelTalkLeaveAll(KFXPlayer Player)
{
    local int nID;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChannelTalkLeaveAll> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChannelTalkLeaveAll> Player(ID) "$ nID $"Leaves all channels");

    return _DVChannelTalkLeaveAll(nID);
}

//--------------------------------
// Ê¹Ò»¸öÍæ¼ÒÔÚÄ³¸öÆµµÀÀïÄÜÌý
//--------------------------------
function bool DVChannelListenJoin(KFXPlayer Player, int nChannelID, EDVPriority Priority)
{
    local int nID;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChannelListenJoin> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChannelListenJoin> Player(ID) "$ nID $" To Listen Joins "$ nChannelID $ "With Priority "$ Priority);

    return _DVChannelListenJoin(nID, nChannelID, Priority);
}

//--------------------------------
// Ê¹Ò»¸öÍæ¼ÒÔÚÄ³¸öÆµµÀÀï²»ÄÜÌý
//--------------------------------
function bool DVChannelListenLeave(KFXPlayer Player, int nChannelID)
{
    local int nID;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChannelListenLeave> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChannelListenLeave> Player(ID) "$ nID $" To Listen Leaves "$ nChannelID);

    return _DVChannelListenLeave(nID, nChannelID);
}

//--------------------------------
// Ê¹Ò»¸öÍæ¼ÒÔÚËùÓÐÆµµÀÀï²»ÄÜÌý
//--------------------------------
function bool DVChannelListenLeaveAll(KFXPlayer Player)
{
    local int nID;

    if (Player == none)
    {
        log ("[Dolby Voice] <DVChannelListenLeaveAll> Null Player");
        return false;
    }

    nID = DVGetPlayerID(Player);
    if (nID == -1)
        return false;

    log ("[Dolby Voice] <DVChannelListenLeaveAll> Player(ID) "$ nID $"Leaves all channels");

    return _DVChannelListenLeaveAll(nID);
}

//--------------------------------
// µÃµ½Íæ¼ÒµÄID£ºÊ¹ÓÃµÄÊÇSessionID
//--------------------------------
function int DVGetPlayerID(KFXPlayer Player)
{
    //local int id, session;
    if (Player == none)
    {
        log ("[Dolby Voice] Error! NULL Player In DVGetPlayerID");
        return -1;
    }
    if (DVGameID == 0)
    {
        log ("[Dolby Voice] Error! Error When GetGameID is 0");
        return -1;
    }

    return (Player.fxDBPlayerInfo.SessionID & 0xFFFF);
}

function DVMapSpatialChannel(string MapName)
{
    if (MapName == "")
    {
        log ("[Dolby Voice] Null Map Name");
        return;
    }
    _DVMapSpatialChannel(MapName);
}





//<< private & native methods, using INSIDE of this class is strongly recommended
native function bool _DVInit();

native function _DVDestroy();

native function int _DVCreateChannel(EDVChannel ChannelType);

native function bool _DVDestroyChannel(int nChannelID);

native function int _DVGetChannelProperty(int nChannelID, EDVChannelProperty Property);

native function bool _DVSetChannelProperty(int nChannelID, EDVChannelProperty Property, int nValue);

native function bool _DVConnectPlayer(string sName, int nID, string ip);

native function bool _DVDisconnectPlayer(int nID);

native function bool _DVChangeTeam(int nID, int nTeamID, bool SpatialWalkieTalkie);

native function bool _DVSetPlayerPos(int nID, vector vLocation, rotator rRotation);

native function bool _DVSetPlayerChannelPos(int nID, int nChannelID, vector vLocation, rotator rRotation);

native function bool _DVChannelTalkJoin(int nID, int nChannelID, int nChannelMapping, EDVPriority Priority);

native function bool _DVChannelTalkLeave(int nID, int nChannelID);

native function bool _DVChannelTalkLeaveAll(int nID);

native function bool _DVChannelListenJoin(int nID, int nChannelID, EDVPriority Priority);

native function bool _DVChannelListenLeave(int nID, int nChannelID);

native function bool _DVChannelListenLeaveAll(int nID);

native function bool _DVMuteOneToOne(int nID, int nMuteID, bool bMute);

native function bool _DVMuteOneToMany(int nID, array<int> nMuteIDs, bool bMute);

native function bool _DVMuteManyToOne(array<int> nIDs, int nMuteID, bool bMute);

native function bool _DVGetPlayerStatus(int nID, out DVPlayerStatus status);

native function bool _DVGetServerStatus(out DVAudioServerStatus status);

// map related
native function bool _DVMapSpatialChannel(string MapName);

//>>


// start the server!
event Timer()
{
    local KFXPlayer VoicePlayer;
    local Controller C;
    local int nPlayerID;
    local DVPlayerStatus status;
    local bool bRet;

    C = Level.ControllerList;
    VoicePlayer = KFXPlayer(C);

    while (C != none)
    {
        // Ìø¹ý»úÆ÷ÈË
        if (KFXBot(C) != none)
        {
            C = C.NextController;
            continue;
        }
        VoicePlayer = KFXPlayer(C);

        if (VoicePlayer == none)
        {
            log("[Dolby Voice] <Timer> Error! Null Player");
            return;
        }

        nPlayerID = DVGetPlayerID(VoicePlayer);
        if (nPlayerID != -1)
        {
            if (VoicePlayer.Pawn != none)
            {
                // ¸üÐÂÎ»ÖÃ£¬ÑÛ¾¦µÄ¸ß¶ÈÎª×¼
                _DVSetPlayerPos(nPlayerID, VoicePlayer.Pawn.Location + VoicePlayer.Pawn.EyePosition(), VoicePlayer.Rotation);
            }
            //<< ¸üÐÂ×´Ì¬
            bRet = _DVGetPlayerStatus(nPlayerID, status);
            if (bRet)
            {
                if (KFXPlayerReplicationInfo(VoicePlayer.PlayerReplicationInfo).KFXTalkVolume != status.TalkVolume)
                {
                    KFXPlayerReplicationInfo(VoicePlayer.PlayerReplicationInfo).KFXTalkVolume = status.TalkVolume;
                }
            }
            else
            {
                log ("[Dolby Voice] <Timer> Error! when update player status");
            }
            //>>
        }

        C = C.NextController;
    }
}

defaultproperties
{
     DVSpatialChnMapping=-1
     DVTeam1ChnMapping=-1
     DVTeam2ChnMapping=-1
     DVUpdateInterval=0.100000
     DVDefHearRange=5000.000000
     bHidden=是
     bSkipActorPropertyReplication=是
     bOnlyDirtyReplication=是
     RemoteRole=ROLE_None
}
