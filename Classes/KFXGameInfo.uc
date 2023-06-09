//-----------------------------------------------------------
//  Class:      KFXGame.KFXGameInfo
//  Creator:    zhangjinpin@kingsoft ÕÅ½ðÆ·
//  Data:       2007-03-26
//  Desc:       FOXÏîÄ¿ÓÎÏ·¹æÔò
//  Update:     ÖØÔØËùÓÐGameInfoµÄEventºÍÖØÒªµÄfunction
//  Special:    **ÕâÀïÃ»ÓÐº¯ÊýºÍÊÂ¼þ×ÓÀà²»ÐíÖØÔØ
//-----------------------------------------------------------

class KFXGameInfo extends DeathMatch
	config(KFXGameRPInfo)
	dependson(KFXFaeryAgent)

	//<< wangkai Dolby voice
	dependson(KFXDVServerAgent);
	//>>



//-----------------------------------------------------------
// ¶¨Òå²»¿ÉÅäÖÃ±äÁ¿
//-----------------------------------------------------------
var int nGameState;     // ÓÎÏ·×´Ì¬

enum EGameState
{
	EGameState_PendingMatch,
	EGameState_MatchInProgress,
	EGameState_MatchTravel,
	EGameState_MatchOver
};
enum EAgentServerType
{
	EE_NORMAL, /*ÆÕÍ¨Èü*/
	EE_FACTION, /*Õ½¶ÓÈü*/
	EE_ELITE, /*µç¾ºÈü*/
};

enum EIDCheckFlag
{
	EID_MajorWeapons,         //Ö÷ÎäÆ÷
	EID_MinorWeaponID,        //¸¨ÖúÎäÆ÷
	EID_MeleeWeapons,         //Àä±øÆ÷
	EID_Grenades,             //À×
	EID_RoleHead,             //½ÇÉ«µÄÍ·
	EID_RoleBody,             //½ÇÉ«µÄÉíÌå
	EID_RoleLeg,              //½ÇÉ«µÄÍÈ
	EID_RoleSuit,              //½ÇÉ«µÄÌ××°
	EID_FlashBomb,  //ÉÁ¹âÀ×
	EID_Bomb,       //¸ß±¬À×
	EID_SmokeBomb,  //ÑÌÎíµ¯
};

var EAgentServerType GameRealmType;//realm´«¹ýÀ´µÃ·þÎñÆ÷ÀàÐÍ£¬»á¸ù¾Ý´ËÀàÐÍ½øÐÐÐ©Âß¼­´¦Àí
var float RealmGameCashFactor;

var KFXFaeryAgent KFXAgent;
var int             fxGameOptParam;         // ÓÎÏ·ÄÚÖ¸¶¨µÄÌØÊâ¿ª¹Ø

var bool bCallGameEnd;
var int EndGameSignal;

var bool  bCallPVEGameEnd;   //PVE
//-------
var float TimeNeedChangeWeapBegin;              //Íæ¼Ò»»Ç¹¿ªÊ¼¼ÆÊ±µÄÊ±¼ä
var int TimeSpawnWait;                          //¶ÔÍæ¼Ò³öÉúµÄµÈ´ýÊ±¼ä×î³¤ÖµÉèÖÃ
//--------
//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø 2009.2.22
var() class<KFXPawn> PawnClass;
var() string PawnClassName;
var   class<KFXSquadAI> SquadClass;
//>>
//=====Ìí¼ÓÄ£Ê½ÏÂµÄpickupËæ»úÉú³É
var array<KFXPickupFactory> pickupfactory;

//<< wangkai Dolby Voice
var KFXDVServerAgent DVServer;

//>>
var  int RestartIndex;//½øÐÐÌØÊâÎäÆ÷µÄÂß¼­

var bool NeedCalcKDValue;            //ÊÇ·ñ¼ÆËãkdÖµ

var bool    KFXMGAllowLostCollision; //»úÇ¹ÀàÎäÆ÷ÊÇ·ñÔÊÐí¼ÜÉèºó¶ªÊ§Åö×²
var bool    NeedRestartByTeam;       //ÖØÉúµãµÄÑ¡ÔñÊÇ·ñÒÀÀµÓÚ¶ÓÎéÐÅÏ¢

var bool    AllowHeadKill;

var int DVCount;// Ugly....TODO

var bool NeedCalcDeathCount;

var float DmgFactorModifier;

var bool bPickupControll;   //PickupµÄÏûÊ§ÓÉÄ£Ê½¿ØÖÆ
var bool bClientSimuFire;   //ÊÇ·ñ¿Í»§¶ËÄ£Äâ¿ª»ð
//var float EndTime;                              // ½áÊøÊ±¼ä
var int RoleGUID;
var bool bPlayedNearWinVoice;           //ÊÇ·ñÒÑ¾­²¥·Å¹ý½Ó½üÊ¤ÀûµÄÓïÒô
var int  PlayerNum;
var int  WantToBeVIPNum;                //ÉêÇëVIPÈËÊý

//FarmÓÎÏ·ÄÚ¹¦ÄÜ sunqiang
var float DropItemBasicRate;
var float DeathsDroppedRate;
var float KillsDroppedRate;
var float MapAddRate;
var float ToDropItemTime;
var float ToDropItemRate;
var int MaxDropPartNum;
struct DropPartInfo
{
	var int ItemID;           //ID higher ID
	var float ItemDropRate;   //µôÂÊ
};
var int MaxDropPaperNum;
struct DropPaperInfo
{
	var int ItemID;           //ID higher ID
	var float ItemDropRate;   //µôÂÊ
};
var DropPartInfo  DroppedPartInfo[8];
var DropPaperInfo  DroppedPaperInfo[8];
enum DroppedItemWay
{
	DroppedByTime ,
	DroppedByKill
};
var string 	GameOptions;

const MaxDropItemNum = 20;    //Õû³¡ÓÎÏ·×î´óµôÂäµÄ¸öÊý

var float  KFXGameStartTime;                    //ÓÎÏ·¿ªÊ¼µÄÊ±¼ä,Ð¡¾Ö¿ªÊ¼»»¶ÓµÄÊ±¼ä

//PVE
var bool bCallOnePVEGuanEnd;
//

var int  nRestartLoop;
function bool GetGameOptFlag(int index)
{
	return( ( (1<<index) & fxGameOptParam )>0 );
}

//-----------------------------------------------------------
// Dolby Voice Game Server Init
// added by WangKai 2008-05-19
//-----------------------------------------------------------
function DVInitServer()
{
	if (Level.NetMode != NM_DedicatedServer)
		return;

	if (DVServer == none)
	{
		DVServer = spawn(class'KFXDVServerAgent');
		if (DVServer == None)
		{
			log("[Dolby Voice] Error! <KFXGameInfo::DVInitServer> Cannot create DV Server Agent Instance");
			return;
		}
	}

	//ÏÈ×öÒ»ÏÂÇåÀí¹¤×÷
	DVCleanUpServer();

	//³õÊ¼»¯
	if (DVServer.DVInit())
	{
		log ("[Dolby Voice] <KFXGameInfo::DVInitServer> DVServer Init Ok");
	}
	else
	{
		DVServer = none;
		log ("[Dolby Voice] <KFXGameInfo::DVInitServer> DVServer Init Failed");
	}
}

//-----------------------------------------------------------
// Dolby Voice Game Server Init
// added by WangKai 2008-05-19
//-----------------------------------------------------------
function DVStartServer()
{
	if (Level.NetMode != NM_DedicatedServer)
		return;

	if (DVServer == none)
	{
		log("[Dolby Voice] Error! <KFXGameInfo::DVStartServer> NULL DVServer Agent Instance");
		return;
	}

	DVServer.DVStart();
}

//-----------------------------------------------------------
// Dolby Voice Game Server Clean Up Before Doing Any Initial Work
// added by WangKai 2008-07-05
//-----------------------------------------------------------
function DVCleanUpServer()
{
	if (Level.NetMode != NM_DedicatedServer)
		return;

	if (DVServer != none)
	{
		DVServer.DVCleanUp();
		log ("[Dolby Voice] <KFXGameInfo::DVCleanUpServer> Server cleaned up");
	}
	else
	{
		log ("[Dolby Voice] Error! <KFXGameInfo::DVCleanUpServer> Null DVServer");
	}
}

//-----------------------------------------------------------
// Dolby Voice Init Client Info,
//  Mainly To Send Server Side Info to Dolby Client
//  Server Side Only!
//  By Using replication
// added by WangKai 2008-07-05
//-----------------------------------------------------------
function DVServerInitClientInfo(KFXPlayer VoicePlayer)
{
	local int nSpatialChnMapping, nTeamChnMapping;
	local int nPlayerID;
	local string PlayerName;

	// ·Ç·þÎñÆ÷£¬·µ»Ø
	if (Level.NetMode != NM_DedicatedServer)
	{
		return;
	}
	// PlayerÎª¿Õ£¬·µ»Ø
	if (VoicePlayer == none)
	{
		log ("[Dolby Voice] Error! <KFXGameInfo::DVServerInitClientInfo> NULL Player When Replicate In InitClientInfo");
		return;
	}
	// DVServerÎª¿Õ£¬·µ»Ø
	if (DVServer == none)
	{
		log ("[Dolby Voice] Error!  <KFXGameInfo::DVServerInitClientInfo> NULL DVServer When Replicate In InitClientInfo");
		return;
	}
	else
	{
		// 3DÁÄÌìÆµµÀID
		nSpatialChnMapping = DVServer.DVSpatialChnMapping;
		// µÃµ½¶ÓÎéÆµµÀID
		nTeamChnMapping = DVServer.DVGetTeamChnMapping(VoicePlayer.DVGetInitTeamID());

		// ¿Õ¼äÆµµÀÓ³ÉäID´íÎó£¬·µ»Ø
		if (nSpatialChnMapping == -1)
		{
			log ("[Dolby Voice] <KFXGameInfo::DVServerInitClientInfo> Error! Result In Invalid Spatial Channel Mapping ID, return");
			return;
		}
		// ¶ÓÎéÆµµÀÓ³ÉäID´íÎó£¬·µ»Ø
		if (nTeamChnMapping == -1)
		{
			log ("[Dolby Voice] <KFXGameInfo::DVServerInitClientInfo> Info, team channel mapping==-1");
		}

		nPlayerID = DVServer.DVGetPlayerID(VoicePlayer);
		PlayerName = VoicePlayer.PlayerReplicationInfo.PlayerName;

		// ¸æËß¿Í»§¶Ë£¬ÁîÆäÁ¬½ÓDolbyµÄÓïÒô·þÎñÆ÷
		VoicePlayer.DVInitClientInfo(PlayerName, nPlayerID, DVServer.DVGameID, DVServer.DVASIP, DVServer.DVASPort, nSpatialChnMapping, nTeamChnMapping);
	}
}

//-----------------------------------------------------------
// Disconnect a player
// added by WangKai 2008-07-05
//-----------------------------------------------------------
function DVDisconnectPlayer(KFXPlayer player)
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		return;
	}

	if (player == none)
	{
		log ("[Dolby Voice] <KFXGameInfo::DVDisconnectPlayer> Error! NULL Player When Disconnect Player");
		return;
	}
	if (DVServer == none)
	{
		log ("[Dolby Voice] <KFXGameInfo::DVDisconnectPlayer> Error! NULL DVServer When Disconnect Player");
		return;
	}

	DVServer.DVDisconnectPlayer(Player);
}

//-----------------------------------------------------------
// Dolby Voice, channel operations after player respawned
// server only
// added by WangKai 2009-06-11
//-----------------------------------------------------------
function DVPlayerEndSpectating(KFXPlayer P)
{
	if (DVServer == none)
		return;

	// Õ½¶Ó·þÎñÆ÷
	if (GameRealmType == EE_FACTION)
	{
		// rejoin player to channels
		DVServer.DVChangeTeam(P, P.DVGetInitTeamID());
	}
	else
	{
		// rejoin player into spatial channel
		DVServer.DVChannelListenJoin(P, DVServer.DVSpatialChnID, PRI_0);
		DVServer.DVChannelTalkJoin(P, DVServer.DVSpatialChnID, DVServer.DVSpatialChnMapping, PRI_0);
	}
}

//-----------------------------------------------------------
// Dolby Voice, channel operations after player died
// server only
// added by WangKai 2009-06-11
//-----------------------------------------------------------
function DVPlayerBeginSpectating(KFXPlayer P)
{
	if (DVServer == none)
		return;
	// Õ½¶Ó·þÎñÆ÷
	if (GameRealmType == EE_FACTION)
	{
		// remove from all the channels
		DVServer.DVChannelListenLeaveAll(P);
		DVServer.DVChannelTalkLeaveAll(P);
	}
	else
	{
		// remove from spatial channel
		DVServer.DVChannelListenLeave(P, DVServer.DVSpatialChnID);
		DVServer.DVChannelTalkLeave(P, DVServer.DVSpatialChnID);
	}
}

function EAgentServerType GetRealmType()
{
	return GameRealmType;
}
//-----------------------------------------------------------
// KFFaery Êý¾Ý½Ó¿Ú
// added by Kevin 2007.04.14
//-----------------------------------------------------------
// ³õÊ¼»¯KFXFaery½Ó¿Ú
function KFXInitFaery()
{
	local int RealGuan;
	local int NextMapID;
	log("GameInfo--------KFXInitFaery ");
    if ( class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
	{
		KFXAgent = spawn(class'KFXFaeryAgent');
		log("GameInfo--------KFXCheckPending() "$KFXCheckPending());
        if ( !KFXCheckPending() )
		{
			Log("[KFXFaeryAgent] Notify Game Ready!");
			RealGuan = KFXAgent.PVEStartGuan + KFXAgent.CurGuanIndex ;
			NextMapID = KFXAgent.PVERandGame[0].nMapID;
            log("GameInfo--------KFXAgent.PVEStartGuan "$KFXAgent.PVEStartGuan);
			log("GameInfo--------KFXAgent.CurGuanIndex "$KFXAgent.CurGuanIndex);
			log("GameInfo--------RealGuan "$RealGuan);
			log("GameInfo--------KFXAgent.bPVEGame "$KFXAgent.bPVEGame);
			log("GameInfo--------NextMapID "$NextMapID);

			KFXAgent.KFXNotifyGameReady(int(KFXAgent.bPVEGame),RealGuan,NextMapID);
		}
	}
}

// ÊÇ·ñ´¦ÓÚPending×´Ì¬
function bool KFXCheckPending()
{
	return false;
}

// ½áÊøÓÎÏ·ºó¶ÔKFXFaeryµÄ»Øµ÷
function KFXCallGameEnd()
{
	if ( EndGameSignal == 1 && KFXAgent != none )
		KFXAgent.KFXEndGame();
	log("[LABOR]-------------kfx call game end!");
	bCallGameEnd = true;
}
function bool KFXPVECanRestartGame();
/* ProcessServerTravel()
 Kevin Sun: in KFXServer Mode
 ServerTravelÊ±Ç¿ÖÆDisconnect¿Í»§¶Ë£¬¶ø·ÇPreClientTravel
*/
function ProcessServerTravel( string URL, bool bItems )
{
	local playercontroller P;
	log("KFXGameINfo-------KFXAgent.bPVEGame "$KFXAgent.bPVEGame );
	//if(!KFXAgent.bPVEGame)
	if(!IsA('KFXPVEGame'))
	{
		if ( class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
		{
			log("KFXProcessServerTravel: Force Disconnecting All Clients");

			foreach DynamicActors( class'PlayerController', P )
			{
				if( NetConnection( P.Player )!=None )
				{
					// Notify Client Disconnect
					//KFXPlayer(P).KFXGSCommand(-1);
				}
			}

			return;
		}
	}
	log("KFXGameINfo-------URL "$URL );
	super.ProcessServerTravel(URL, bItems);
}

// Íæ¼ÒÉí·ÝÑéÖ¤
function bool KFXValidatePlayer(
	int nSessionID,
	out KFXFaeryAgent.KFXPlayerInfo PlayerInfo,
	optional bool get_info)
{
	local int nLoop;
	local Controller ctrl;
	local int bfound;

	//¼ì²éµ±Ç°controllerÁÐ±íÖÐ£¬ÓÐÃ»ÓÐÕâ¸ösessionidµÄÍæ¼Ò£¬Èç¹ûÓÐ£¬ÄÇÃ´ÏÔÊ¾ÈÕÖ¾¡£
	//Èç¹ûÕæÓÐÕâÑùµÄ£¬ÄÇÃ´¿ÉÒÔÖ±½Ó·µ»Øfalse
	for(ctrl = Level.ControllerList; ctrl != none; ctrl = ctrl.nextController)
	{
		if(KFXPlayer(Ctrl) != none && KFXPlayer(Ctrl).fxDBPlayerInfo.SessionID == nSessionID)
		{
			bfound++;

			if(bfound >= 1)
			{
				log("#### ERROR #### critical! there are "$bfound$" people use the same session="$nSessionID
						@"he's id is "$KFXPlayer(Ctrl).fxDBPlayerInfo.PlayerID
						@"he's name is "$KFXPlayer(Ctrl).fxDBPlayerInfo.PlayerName);
				return false;
			}
		}
	}
    log("KFXGameInfo------ KFXAgent.Players.Length "$ KFXAgent.Players.Length);
	for ( nLoop = 0; nLoop < KFXAgent.Players.Length; nLoop++ )
	{

        log("KFXGameInfo------ KFXAgent.Players[nLoop].SessionID "$ KFXAgent.Players[nLoop].SessionID);
        log("KFXGameInfo------ nSessionID "$ nSessionID);

        if ( KFXAgent.Players[nLoop].SessionID == nSessionID )
		{
			PlayerInfo = KFXAgent.Players[nLoop];
			if(get_info)
				KFXAgent.Players[nLoop].MissionBlock.Missions.Length = 0;
			KFXAgent.NotifyPlayerLogInGameServer(nSessionID);
			return true;
		}
	}

	Log("[Kevin] Player Login Failed! Invalid Session ID:" $nSessionID
		$"  Invalid Player ID: "$PlayerInfo.RoleID);

	return false;
}

//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.21
//»ñµÃÀ©Õ¹µÄÍæ¼ÒÐÅÏ¢
function bool KFXGetPlayerExpInfo(
	int nSessionID,
	out KFXFaeryAgent.KFXPlayerExpInfo PlayerExpInfo)
{
	local int nLoop;

	for ( nLoop = 0; nLoop < KFXAgent.PlayersExp.Length; nLoop++ )
	{
		if ( KFXAgent.PlayersExp[nLoop].SessionID == nSessionID )
		{
			PlayerExpInfo = KFXAgent.PlayersExp[nLoop];

			return true;
		}
	}

	Log("Get PlayerExpInfo Failed! Invalid Session ID:" $nSessionID);

	return false;
}
//>>
function bool KFXGetPlayerPropsInfo(    int nSessionID,
	out KFXFaeryAgent.KFXBagPropsInfo PlayerBagPropsInfo)
{
	local int nLoop;

	for ( nLoop = 0; nLoop < KFXAgent.PlayerBagProps.Length; nLoop++ )
	{
		if ( KFXAgent.PlayerBagProps[nLoop].SessionID == nSessionID )
		{
			PlayerBagPropsInfo = KFXAgent.PlayerBagProps[nLoop];

			return true;
		}
	}

	Log("Get PlayerBagPropsInfo Failed! Invalid Session ID:" $nSessionID);

	return false;

}

function bool KFXGetPlayerCurEquipList( int nSessionID,
						out KFXFaeryAgent.CurEquipItemsListType PlayerEquipListInfo )
{
	local int nLoop;
	local KFXFaeryAgent.CurEquipItemsListType tempEquipItemsList;

	for ( nLoop = 0; nLoop < KFXAgent.CurEquipItemsList.Length; nLoop++ )
	{
		tempEquipItemsList = KFXAgent.CurEquipItemsList[nLoop];
		if ( tempEquipItemsList.SessionID == nSessionID )
		{
			PlayerEquipListInfo = tempEquipItemsList;

			return true;
		}
	}

	return false;
}

function bool KFXGetPlayerWeapsInfo(    int nSessionID,
	out KFXFaeryAgent.KFXPlayerWeaponsBakInfo PlayerWeapsInfo)
{
	local int nLoop;

	for ( nLoop = 0; nLoop < KFXAgent.PlayerWeapons.Length; nLoop++ )
	{
		if ( KFXAgent.PlayerWeapons[nLoop].SessionID == nSessionID )
		{
			PlayerWeapsInfo = KFXAgent.PlayerWeapons[nLoop];

			return true;
		}
	}

	Log("Get PlayerWeapsInfo Failed! Invalid Session ID:" $nSessionID);

	return false;

}

// Íæ¼ÒÊý¾Ý»ØÐ´
function bool KFXUpdatePlayerInfo(KFXPlayer player)
{
	local int nLoop;
	local int checkID;

	if (KFXAgent == none)
		return false;

	checkID = KFXPlayerReplicationInfo(player.PlayerReplicationInfo).fxPlayerDBID;
	for(nLoop = 0; nLoop < KFXAgent.Players.Length; nLoop++)
	{
		if(KFXAgent.Players[nLoop].PlayerID == checkID)
		{
			checkID = KFXAgent.Players[nLoop].SessionID;
			if(KFXAgent.Players[nLoop].SessionID != player.fxDBPlayerInfo.SessionID)
			{
				log("#### ERROR #### player's session id has been changed, playername="
						$player.PlayerReplicationInfo.PlayerName
						@"playerid="$KFXAgent.Players[nLoop].PlayerID);
			}
			KFXAgent.Players[nLoop] = player.fxDBPlayerInfo;
			KFXAgent.Players[nLoop].SessionID = checkID;
			return true;
		}
	}
	log("#### ERROR #### can't update player info! id="$checkID@player.PlayerReplicationInfo.PlayerName);
	return false;
}
function bool KFXUpatePlayerBaseInfo(KFXPlayer player)
{
	local int nLoop;
	local int checkID;
	if (KFXAgent == none)
		return false;

	checkID = KFXPlayerReplicationInfo(player.PlayerReplicationInfo).fxPlayerDBID;
	for( nLoop = 0; nLoop < KFXAgent.Players.Length; nLoop++)
	{
		if(checkID == KFXAgent.Players[nLoop].PlayerID)
		{
			if(KFXAgent.Players[nLoop].SessionID != player.fxDBPlayerInfo.SessionID)
			{
				log("#### ERROR #### player's session has been changed!, name="
						$player.PlayerReplicationInfo.PlayerName
						@"playerid="$checkID@"sessionid="$player.fxDBPlayerInfo.SessionID);
			}
			KFXAgent.BasePlayersData[nLoop] = player.fxDBPlayerBaseData;
			KFXAgent.PlayersDataExtra[nLoop] = player.fxPlayerExtraData;
			KFXAgent.PVEPlayerData[nLoop] = player.fxPVEPlayerData;

			KFXAgent.BasePlayersData[nLoop].SessionID = KFXAgent.Players[nLoop].SessionID;
			KFXAgent.PlayersDataExtra[nLoop].SessionID = KFXAgent.Players[nLoop].SessionID;
			KFXAgent.PVEPlayerData[nLoop].SessionID    = KFXAgent.Players[nLoop].SessionID;
			return true;
		}
	}
	//Èç¹ûÃ»ÓÐÕÒµ½£¬ÄÇÃ´ÏÔÊ¾´íÎó¡£
	log("#### ERROR #### can't set player's game info, name="
			$player.PlayerReplicationInfo.PlayerName
			@"playerid="$checkID);

	return true;
}
// Íæ¼ÒÊý¾Ý»ØÐ´
function bool KFXUpdatePlayerExpInfo(KFXFaeryAgent.KFXPlayerInfo PlayerInfo, KFXFaeryAgent.KFXPlayerExpInfo PlayerExpInfo)
{
	local int nLoop;

	if (KFXAgent == none)
		return false;

	for ( nLoop = 0; nLoop < KFXAgent.Players.Length; nLoop++ )
	{
		if ( KFXAgent.Players[nLoop].PlayerID == PlayerInfo.PlayerID )
		{
			KFXAgent.PlayersExp[nLoop] = PlayerExpInfo;
			KFXAgent.PlayersExp[nLoop].SessionID = KFXAgent.Players[nLoop].SessionID;
			return true;
		}
	}

	return false;
}


// ³õÊ¼»¯Íæ¼ÒÍæ¼ÒÊý¾Ý
function KFXSetupPlayer(KFXPlayer player, KFXFaeryAgent.KFXPlayerInfo PlayerInfo)
{
	// ¼ÆËãÐÞÕýÖµÁÐ±í
	KFXComputeModifier(player, PlayerInfo);

	// ·¢ËÍÐÞÕýÖµÁÐ±í

	// ÉèÖÃPawn class
	//SetPlayerPawnClass(player, PlayerInfo.RoleID);

	// ÉèÖÃRequired Inventory
}

// ¼ÆËãÐÞÕýÖµÁÐ±í
function KFXComputeModifier(KFXPlayer player, KFXFaeryAgent.KFXPlayerInfo PlayerInfo)
{
	// TODO: ¼ÆËãÐÞÕýÖµÁÐ±í
}

//-----------------------------------------------------------
// Ò»Ð©Á÷³Ì
//-----------------------------------------------------------
/*
1. InitGame--SetGrammar--PreBeginPlay--Beginplay--PostBeginPlay--PostNetBeginPlay--SetInitialstate
2. PreLogin--Login--PostLogin--(StartMatch)--(RestartPlayer)
*/

//-----------------------------------------------------------
// event²¿·Ö
//-----------------------------------------------------------
// ÔÚInitGameÖ®ºó±»µ÷ÓÃ
event PreBeginPlay()
{
	local KFXCSVTable CFG_MapWeapLimit;
	local KFXCSVTable CFG_FactionMatch;
	local int loop;
	local int PVEPart;

	AddToPackageMap("fx_rifle_sounds.uax");
	AddToPackageMap("fx_coldsteel_sounds.uax");
	AddToPackageMap("XXXWeapons.u",true);
	super.PreBeginPlay();
	if(KFXGameReplicationInfo(GameReplicationInfo) == none)
		return;
	// ´óÌüÄ£Ê½
	if ( KFXAgent != none )
	{
		CFG_MapWeapLimit = class'KFXTools'.static.GetConfigTable(104);
		if ( !CFG_MapWeapLimit.SetCurrentRow(KFXAgent.Game.nWeapLimit) )
		{
			log("[KFXGameInfo] PreBeginPlay  CFG_MapWeapLimit set current row error!!!!!!"$KFXAgent.Game.nWeapLimit);
		}

		for ( loop = 1; loop <= 17; loop++ )
		{
			KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit = KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit | (CFG_MapWeapLimit.GetInt("WeaponType"$loop)<<(loop-1));
		}
		log("[KFXGameInfo] fxWeapLimit:"$KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit);
		GameRealmType = EAgentServerType(KFXAgent.Game.nGameType);
		RealmGameCashFactor = KFXAgent.Game.fGameCoinFactor;

		// Í¬²½µØÍ¼ID
		KFXGameReplicationInfo(GameReplicationInfo).fxMapID = KFXAgent.Game.nMapID;
		KFXGameReplicationInfo(GameReplicationInfo).nGameType = KFXAgent.Game.nGameType;

		if(KFXAgent.Game.nGameType != 0)
		{
			CFG_FactionMatch = class'KFXTools'.static.GetConfigTable(708);
			log("GameType"@KFXAgent.Game.nGameType@"GameMode"@KFXAgent.Game.nGameMode);
			if ( !CFG_FactionMatch.SetCurRowWithNewKey("CombinationID",""$((KFXAgent.Game.nGameType << 16) + KFXAgent.Game.nGameMode)) )
			{
				log("CSVError GameType"@KFXAgent.Game.nGameType@"GameMode"@KFXAgent.Game.nGameMode);
			}
			KFXGameReplicationInfo(GameReplicationInfo).bAllowTeamChange = CFG_FactionMatch.GetBool("SwapTeamCfg");
			KFXGameReplicationInfo(GameReplicationInfo).ReWinOnDraw = CFG_FactionMatch.GetInt("MatchDrawCfg");
			log("bAllowTeamChange"@KFXGameReplicationInfo(GameReplicationInfo).bAllowTeamChange@"ReWinOnDraw"@KFXGameReplicationInfo(GameReplicationInfo).ReWinOnDraw);
		}
		else
		{
			KFXGameReplicationInfo(GameReplicationInfo).bAllowTeamChange = true;
			KFXGameReplicationInfo(GameReplicationInfo).ReWinOnDraw = 0;
		}

		fxGameOptParam = KFXAgent.Game.nGameOptParam;
		if(fxGameOptParam>0)
		{
			KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle = GetGameOptFlag(6);
			KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle = GetGameOptFlag(7);
			log("[KFXGameInfo] GameOptParam open"$fxGameOptParam);
		}
		else
		{
			log("[KFXGameInfo] GameOptParam closed"$fxGameOptParam);
		}

		//if(KFXAgent.bPVEGame)
		if(IsA('KFXPVEGame'))
		{
			PVEPart = class'PVEGameManager'.static.GetCurPart();
			KFXGameReplicationInfo(GameReplicationInfo).SetBaseLevelData(PVEPart);
		}

		log("[KFXGameInfo] PreBeginPlay GameRealmType is :"$ GameRealmType$"RealmGameCashFactor"$RealmGameCashFactor);
	}
	else
	{
		KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit = 0;
		KFXGameReplicationInfo(GameReplicationInfo).bAllowTeamChange = true;
		KFXGameReplicationInfo(GameReplicationInfo).ReWinOnDraw = 0;
	}
	InitFarmInfo();
	log("[LABOR]-----------weapon limit:"$KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit);
}
function InitFarmInfo()
{
	local KFXCSVTable DropItemMapInfo,CSVGameInfo;
	local int MapID;
	local int TableMapID;
	local bool bMapDropped;
	local int i;

	if ( KFXAgent != none )
	{
		DropItemMapInfo = class'KFXTools'.static.KFXCreateCSVTable("DropItemRate.csv");
		CSVGameInfo = class'KFXTools'.static.GetConfigTable(102);

		TableMapID = KFXGameReplicationInfo(GameReplicationInfo).fxMapID;

		if (!CSVGameInfo.SetCurRowWithNewKey("ID",""$TableMapID))
		{
			Log(" Can't Resolve KFXGameInfo.csv MapID (Attr Table): "$TableMapID);
			return;
		}
		MapID = CSVGameInfo.GetInt("MapID");
		if ( !DropItemMapInfo.SetCurrentRow(MapID) )
		{
			Log("Can't Resolve DropItemMapInfo.csv MapID (Attr Table): "$MapID);
			return;
		}
	}
	else
	{
		DropItemMapInfo = class'KFXTools'.static.KFXCreateCSVTable("DropItemRate.csv");
		MapID = 101;
		if ( !DropItemMapInfo.SetCurrentRow(MapID) )
		{
			Log("[Kevin] Can't Resolve MapID (Attr Table): "$MapID);
			return;
		}

	}
	bMapDropped = DropItemMapInfo.GetBool("IsDropped") ;
	if(!bMapDropped)
	{
		log("This Map Can't Drop, MapID: "$MapID);
	}
	DropItemBasicRate = DropItemMapInfo.GetFloat("ItemBasicRate") ;
	MapAddRate = DropItemMapInfo.GetFloat("MapAddRate") ;
	DeathsDroppedRate = DropItemMapInfo.GetFloat("DeathsAddRate") ;
	KillsDroppedRate = DropItemMapInfo.GetFloat("KillsAddRate") ;
	ToDropItemTime = DropItemMapInfo.GetFloat("TimeToDropItem") ;
	ToDropItemRate = DropItemMapInfo.GetFloat("TimeToDropRate") ;
	MaxDropPartNum = DropItemMapInfo.GetInt("DropPartNum") ;
	MaxDropPaperNum = DropItemMapInfo.GetInt("DropPaperNum") ;
	log("VIPGame----MapID "$MapID
					$"DropItemBasicRate :"$DropItemBasicRate
					$"MapAddRate :"$MapAddRate
					$"DeathsDroppedRate :"$DeathsDroppedRate
					$"KillsDroppedRate :"$KillsDroppedRate
					$"ToDropItemTime :"$ToDropItemTime
					$"ToDropItemRate :"$ToDropItemRate
					$"MaxDropPartNum: "$MaxDropPartNum
					$"MaxDropPaperNum: "$MaxDropPaperNum);

	for(i=1; i<=MaxDropPartNum; i++)
	{
		DroppedPartInfo[i-1].ItemID = DropItemMapInfo.GetInt("ItemID"$i);
		DroppedPartInfo[i-1].ItemDropRate = DropItemMapInfo.GetFloat("ItemRate"$i);
		log("Part Dropped is ----DroppedPartInfo[i-1].ItemID: "$DroppedPartInfo[i-1].ItemID
						$"DroppedPartInfo[i-1].ItemDropRate: "$DroppedPartInfo[i-1].ItemDropRate);
	}
	for(i=1; i<=MaxDropPaperNum; i++)
	{
		DroppedPaperInfo[i-1].ItemID = DropItemMapInfo.GetInt("PaperID"$i);
		DroppedPaperInfo[i-1].ItemDropRate = DropItemMapInfo.GetFloat("PaperRate"$i);
		log("Paper Dropped is ----DroppedPaperInfo[i-1].ItemID: "$DroppedPaperInfo[i-1].ItemID
						$"DroppedPaperInfo[i-1].ItemDropRate: "$DroppedPaperInfo[i-1].ItemDropRate);
	}

}
//  ActorÏú»ÙÊ±µ÷ÓÃ
event Destroyed()
{
	super.Destroyed();
	log ("[Dolby Voice] TEST GAMEINFO DESTROY");
}

// ÔÚBeginPlayÖ®ºóµ÷ÓÃ£¬Ö®Ç°»¹Íê³ÉÁËÉùÒôÉèÖÃ
event PostBeginPlay()
{
	super.PostBeginPlay();
	log("KFXGameInfo PostBeginPlay");
}

// ¶¨Ê±ºô½Ð£¬Ò»¸öÖØÒªµÄ·½·¨£¬ÔÚUpdateTimersÖÐ±»µ÷ÓÃ
// °éËæ·½·¨SetTimer(sec, flag)£¬ÉèÖÃµ÷ÓÃÊ±¼äºÍÊÇ·ñÑ­»·
// ÐÞ¸ÄÎªÑÓ³Ù1.0Ãë·¢ËÍÏûÏ¢
event Timer()
{
	local NavigationPoint N;
	local int i;

	// ÕâÀïÓÃÀ´·¢ËÍÍæ¼ÒµÇÂ½ÐÅÏ¢
	if( bWelcomePending )
	{
		// ÓÐÈËµÇÂ½µÄÊ±ºòÖÃÎªtrue
		bWelcomePending = false;

		if ( Level.NetMode != NM_Standalone )
		{
			for ( i = 0; i < GameReplicationInfo.PRIArray.Length; i++ )
			{
				// ÕÒÃ»ÓÐÌáÊ¾¹ýµÄÈË
				if ( GameReplicationInfo.PRIArray[i] != none && !GameReplicationInfo.PRIArray[i].bWelcomed )
				{
					// µÇÂ½Ê±¼ä×ã¹»Í¬²½ÓÃ
					if( Level.TimeSeconds - KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).fxLoginTime > 1.5 )
					{
						if( KFXBotReplicationInfo(GameReplicationInfo.PRIArray[i]) == none)
						{
							BroadcastLocalizedMessage(class'KFXGameMessage', 1, GameReplicationInfo.PRIArray[i]);
						}
						GameReplicationInfo.PRIArray[i].bWelcomed = true;
					}
					// ·ñÔò±£ÁôÌáÊ¾µÄ»ú»á
					else
					{
						bWelcomePending = true;
					}
				}
			}
		}
	}

	BroadcastHandler.UpdateSentText();
	for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
		N.FearCost *= FearCostFallOff;
}

// ÓÎÏ·½áÊøÊ±±»ºô½Ð£¬ÔÚTickµÄClient Travell(¸ü»»¹Ø¿¨)
event GameEnding()
{
	super.GameEnding();
}

// Ìßµô³¬¹ý·¢´ôÊ±¼äÏÞÖÆµÄController
event KickIdler(PlayerController PC)
{
	super.KickIdler(PC);
}

event MapLoaded()
{
	super.MapLoaded();
	// ÕâÀï³õÊ¼»¯Dolby VoiceÀà
	// ²»ÔÚInitGameÀïÃæµ÷ÓÃµÄÔ­ÒòÊÇInitGameºóÃæÓÎÏ··þÎñÆ÷»¹ÓÐÒ»´ó¶Î×èÈû²Ù×÷£¨MapLoadingÓÐºÜ¶à²Ù×÷£©
	// ÓïÒô·þÎñÆ÷¶Ë»áÔÝÊ±ÊÕ²»µ½DVServerAgentµÄ°ü£¬µ¼ÖÂPingÖµ·ÖÎö±äµÃºÜ¸ß
	// ¹ÊÒªÌø¹ýMap LoadingµÄ¹ý³Ì

	DVInitServer();//Èç¹ûÏà¹ØC++´úÂë²»±»±àÒë£¬³õÊ¼»¯¾Í»áÊ§°Ü
	DVStartServer();//Dolby Voice¿ªÊ¼¹¤×÷
}

// ³õÊ¼»¯ÓÎÏ·**µ÷ÓÃµÄµÚÒ»¸öevent
// ÕâÀïÃæÊ¹ÓÃ×Ô¼ºµÄÉè¶¨
event InitGame( string Options, out string Error )
{
	GameOptions = Options;
	// added by kevin
	// ³õÊ¼»¯KFXFaery
	KFXInitFaery();

	// ¸¸ÀàÀïÃæÍê³ÉÁËÒ»Ð©½âÎöOptions²¢ÉèÖÃµÄ¹ý³Ì
	// Í¬Ê±ÉèÖÃÁËGameSpeed
	super.InitGame(Options, Error);

	if ( !class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
	{
		// TODO: ½âÎö²ÎÊý£¬ÅÐ¶ÏÊÇ·ñÎªµÀ¾ßÈü
//        KFXAllowMagicItem=true; // Temp Code
	}

	//HOW do U USE THESE??? local string InOpt, LeftOpt;


}
event InitPVEGame()
{
}
// ¸ÄÐ´¹ã²¥´¦Àí¼°Ê±Õ½¶·ÏûÏ¢
event KFXBroadcastLocalized
(
	actor Sender,
	class<LocalMessage> Message,
	optional int Switch1,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject,
	optional int Switch2
)
{
//  local KFXPlayerREplicationInfo p1, p2, p;
//  local int i;
//  //¼ÇÂ¼Ë­É±ËÀÁË×Ô¼º
//  p1 = KFXPlayerReplicationInfo(RelatedPRI_1); //killer
//  p2 = KFXPlayerReplicationInfo(RelatedPRI_2); //killed
//  //Èç¹ûÆäÖÐÓÐÒ»·½²»ÊÇÈË»òÕßÊÇ×Ô¼º£¬ÄÇÃ´¾Í²»ÐèÒªÖ´ÐÐ´ËÂß¼­¡£·ñÔò¼ÇÂ¼¸´³ð
//  if(p1 != none && p2 != none && p1 != p2)
//  {
//      for(i=0; i<GameReplicationInfo.PRIArray.Length; i++)
//      {
//          p = KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
//          if(p.fxPlayerDBID == p1.fxPlayerDBID)
//              p1 = p;
//          else if(p.fxPlayerDBID == p2.fxPlayerDBID)
//              p2 = p;
////            if(GameReplicationInfo.PRIArray[i] == RelatedPRI_1)
////            {
////                p1 = KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
////            }
////            else if(GameReplicationInfo.PRIArray[i] == RelatedPRI_2)
////            {
////                p2 = KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
////            }
////            if(p1 != none && p2 != none)
////                break;
//        }
//      p2.nIDLastKillMe = p1.fxPlayerDBID;
//      p2.nRealIDLastKillMe = p1.fxRoleGUID;
//      if(p1.nIDLastKillMe == p2.fxPlayerDBID)
//      {
//          p1.nIDLastKillMe = 0;
//      }
//  }

	KFXBroadcastHandler(BroadcastHandler).KFXAllowBroadcastLocalized(
		Sender,
		Message,
		Switch1,
		RelatedPRI_1,
		RelatedPRI_2,
		OptionalObject,
		Switch2
	);
}

// ÊÇ·ñÔÊÐíÍæ¼ÒµÇÂ½**Error²»Îª¿ÕÔòÎÞ·¨µÇÂ½
event PreLogin
(
	string Options,
	string Address,
	string PlayerID,
	out string Error,
	out string FailCode
)
{
	local int nSessionID;
	local KFXFaeryAgent.KFXPlayerInfo PlayerInfo;
	local bool bValidatePlayer;

	super.PreLogin(Options, Address, PlayerID, Error, FailCode);

	if ( !class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
	{
		return;
	}

	nSessionID = GetIntOption(Options, "Session", -1);

	bValidatePlayer = KFXValidatePlayer(nSessionID, PlayerInfo);

	if( !bValidatePlayer )
	{
		Error = "LoginError";
		FailCode = "LoginFailCode";
	}
	else
	{
		Log("[KFXFaeryAgent] Player preLogin: PlayerID="$PlayerInfo.PlayerID$" PlayerName="$PlayerInfo.PlayerName
			$" RoleID="$PlayerInfo.RoleID
			$" TeamID="$PlayerInfo.TeamID
			$" Level="$PlayerInfo.nLevel
			$" Experience="$PlayerInfo.nExperience
			);
	}
}

// Íæ¼ÒµÇÂ½**ÖØÒªÊÂ¼þ,ÍêÈ«ÖØÔØ
// ²úÉúÒ»¸öÍæ¼ÒµÄpawnºÍcontroller£¬²¢ÇÒÍê³É³öÉúµãºÍ¶ÓÎéÑ¡Ôñ
event PlayerController Login
(
	string Portal,
	string Options,
	out string Error
)
{
	local NavigationPoint   StartSpot;
	local PlayerController  NewPlayer;
	local string            InName, InAdminName, InPassword, InChecksum, InCharacter,InSex;
	local byte              InTeam;
	local bool              bSpectator, bAdmin;

	// add for server mode
	local int nSessionID;
	local KFXFaeryAgent.KFXPlayerInfo fxPlayerInfo;

	//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.21   ÖÁ 2009.11.12 ±¾½á¹¹ÖÐµÄÊý¾ÝÒÑ¾­´ó²¿·Ö×ªÒÆ
	local KFXFaeryAgent.KFXPlayerExpInfo fxPlayerExpInfo;
	//>>
	local KFXFaeryAgent.KFXPlayerWeaponsBakInfo fxPlayerWeapsInfo;
	local KFXFaeryAgent.KFXBagPropsInfo fxNetPlayerProps;
	local KFXFaeryAgent.CurEquipItemsListType PlayerEquipListInfo;

	local int               InDVID;//wangkai, Dolb Voice, 2008-10-14
	//<< Dolby Demo
	local KFXCSVTable       CSVMapInfo;
	local string            MapName;
	//>>
	local int i,part,WeaponID;
	local KFXCSVTable   CFG_WeapComponent;
	local array<int>    testTasks;
	local int j;
	// ·Ç´óÌüÄ£Ê½
	if ( KFXAgent == none )
	{
		log("KFXgameInfo----1-----Level.TimeSeconds "$Level.TimeSeconds);
		// ¹ýÂË×Ö·û´®ÑÕÉ«
		Options = StripColor(Options);  // Strip out color Codes
		log("KFXgameInfo----2-----Level.TimeSeconds "$Level.TimeSeconds);

		// ½âÊÍOptions
		InName      = Left(ParseOption ( Options, "Name"), 20);
		InTeam      = GetIntOption( Options, "Team", 255 ); // Ä¬ÈÏÎÞ¶ÓÎé
		InAdminName = ParseOption ( Options, "AdminName");
		InPassword  = ParseOption ( Options, "Password" );
		InChecksum  = ParseOption ( Options, "Checksum" );
		InSex       = ParseOption(Options, "Sex");
		InCharacter = ParseOption(Options, "Character");
		InDVID      = GetIntOption(Options, "DVID", 0);// wangkai, id for dolby voice
		log("KFXgameInfo----3-----Level.TimeSeconds "$Level.TimeSeconds);

		// ÅÐ¶ÏÊÇ·ñÊÇ¹Û²ìÕß
		bSpectator = ( ParseOption( Options, "SpectatorOnly" ) ~= "1" );
		log("KFXgameInfo----4-----Level.TimeSeconds "$Level.TimeSeconds);

		// ÅÐ¶ÏÊÇ·ñÊÇadmin
		if (AccessControl != None)
			bAdmin = AccessControl.CheckOptionsAdmin(Options);
		log("KFXgameInfo----5-----Level.TimeSeconds "$Level.TimeSeconds);

		// ÏÞÖÆµÇÂ½ÓÎÏ·
		if ( !bAdmin && AtCapacity(bSpectator) )
		{
			Error = GameMessageClass.Default.MaxedOutMessage;
			return None;
		}

		log("KFXgameInfo----6-----Level.TimeSeconds "$Level.TimeSeconds);
		// adminÔÚÈËÂúÊ±Ç¿ÖÆÊ¹ÓÃSpectatorÄ£Ê½
		if ( bAdmin && AtCapacity(false))
		{
			bSpectator = true;
		}

		// Í¬²½µØÍ¼ID(Ð¡Õò)
		KFXGameReplicationInfo(GameReplicationInfo).fxMapID = 2;
		fxGameOptParam = 1;
		// ×¢Òâ£ºÕâÊ±ºòControllerÊÇ¿ÕµÄ

		// Ñ¡ÔñÒ»¸ö¶ÓÎé
		InTeam = PickTeam(InTeam, None);
		log("KFXgameInfo----7-----Level.TimeSeconds "$Level.TimeSeconds);

		// ²éÕÒ³öÉúµã
		StartSpot = FindPlayerStart( None, InTeam, Portal );
		log("KFXgameInfo----8-----Level.TimeSeconds "$Level.TimeSeconds);

		// ÎÞ·¨³öÉúÔò·µ»Ønone
		if( StartSpot == none )
		{
			Error = GameMessageClass.Default.FailedPlaceMessage;
			return None;
		}
		log("KFXgameInfo----9-----Level.TimeSeconds "$Level.TimeSeconds);

		// ²úÉúÒ»¸öcontroller
		if ( PlayerControllerClass == None )
		{
			PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));
		}
		log("KFXgameInfo----11-----Level.TimeSeconds "$Level.TimeSeconds);

		NewPlayer = spawn(PlayerControllerClass,,,StartSpot.Location,StartSpot.Rotation);
		log("KFXgameInfo----12-----Level.TimeSeconds "$Level.TimeSeconds);

		if( NewPlayer == none )
		{
			log("Couldn't spawn player controller of class "$PlayerControllerClass);
			Error = GameMessageClass.Default.FailedSpawnMessage;
			return None;
		}
		log("KFXgameInfo----13-----Level.TimeSeconds "$Level.TimeSeconds);

		// ÉèÖÃ³öÉúµã
		NewPlayer.StartSpot = StartSpot;

		// ÉèÖÃÓÎÏ·Í¬²½ÐÅÏ¢
		NewPlayer.GameReplicationInfo = GameReplicationInfo;

		// Íæ¼ÒÈ¨ÏÞÈ¥µôÁË

		// Ê×ÏÈ½øÈë¹Û²ìÄ£Ê½
		if ( bAttractCam )
		{
			NewPlayer.GotoState('AttractMode');
		}
		else
		{
			//NewPlayer.GotoState('Spectating');
		}
		// ¹Û²ìÕßÄ£Ê½ ½øÈëÓÎÏ·ºóÖ±½ÓÊÇ¹Û²ìÕß ËïÇ¿ 2010.1.4
//      if(PlayerNum  == 0)
//      {
//            bSpectator = true;//bool(fxPlayerInfo.nSpectatorView);
//          KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bSpectatorView = true;//bool(fxPlayerInfo.nSpectatorView);
//            log("Player Is SpectatorView Is True");
//            PlayerNum++;
//        }

		  log("KFXgameInfo----14-----Level.TimeSeconds "$Level.TimeSeconds);

		// add vip & netbar & prop level
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bVipBonus = true;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bNetBarBonus = true;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bPropBonus = true;

		// ÉèÖÃÊ¹ÓÃµÄÌáÊ¾ÉùÒô°ü
		NewPlayer.PlayerReplicationInfo.VoiceTypeName = ParseOption ( Options, "Voice");

//        // ÉèÖÃ½ÇÉ«
//        NewPlayer.SetPawnClass(NewPlayer.PawnClass.Name, InCharacter); //"KFXGame.KFXPawn"
		NewPlayer.PlayerReplicationInfo.SetCharacterName(inCharacter);
		if ( Left(InSex,3) ~= "F" )
		{
			NewPlayer.SetPawnFemale();  // only effective if character not valid
		}
		log("KFXgameInfo----15-----Level.TimeSeconds "$Level.TimeSeconds);

		// ·ÖÅäÒ»¸öPlayerID
		NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

		// ³õÊ¼»¯Ãû×Ö£¬Ãû×Ö±äÎª£ºÄ¬ÈÏÃû×Ö+playerid
		if( InName=="" )
		{
			InName=DefaultPlayerName;
		}
		if( Level.NetMode!=NM_Standalone || NewPlayer.PlayerReplicationInfo.PlayerName==DefaultPlayerName )
		{
			ChangeName( NewPlayer, InName$NewPlayer.PlayerReplicationInfo.PlayerID, false );
		}
		log("KFXgameInfo----16-----Level.TimeSeconds "$Level.TimeSeconds);

		// login time
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxLoginTime = Level.TimeSeconds;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).TimeNeedChangeWeapBegin = Level.TimeSeconds;
		//<< wangkai, Dolby Voice, 2008-10-07
		KFXPlayer(NewPlayer).fxDBPlayerInfo.SessionID = InDVID;//NewPlayer.PlayerReplicationInfo.PlayerID;
		KFXPlayer(NewPlayer).fxDBPlayerInfo.PlayerName = InName;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxPlayerDBID = InDVID;//KFXPlayer(NewPlayer).fxDBPlayerInfo.PlayerID;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bKFXSpatial = true;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).PreDroppedTime = Level.TimeSeconds;
		log("KFXgameINfo------Level.TimeSeconds :"$Level.TimeSeconds);
		log("KFXgameInfo----17-----Level.TimeSeconds "$Level.TimeSeconds);

		if (DVServer != none)
		{
			DVServer.DVMapSpatialChannel("DF-ShuangShiZhenChengLou");
			//TODO
			DVCount++;
		}

		log("[Dolby Voice] new Player ID: "$ KFXPlayer(NewPlayer).fxDBPlayerInfo.SessionID);
		log("[Dolby Voice] new Player Name: "$ KFXPlayer(NewPlayer).fxDBPlayerInfo.PlayerName);
		//>>

		// ¹Û²ìÕß»òÕßÎÞ·¨·ÖÅä¶ÓÎéµÄÊ±ºò
		if ( bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator || !ChangeTeam(newPlayer, InTeam, false) )
		{
			NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
			NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
			NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
			NumSpectators++;

			return NewPlayer;
		}

		newPlayer.StartSpot = StartSpot;
		log("KFXgameInfo----18-----Level.TimeSeconds "$Level.TimeSeconds);

		// ¹ÜÀíÔ±µÇÂ½
		if (AccessControl != None && AccessControl.AdminLogin(NewPlayer, InAdminName, InPassword))
		{
			AccessControl.AdminEntered(NewPlayer, InAdminName);
		}
		log("KFXgameInfo----19-----Level.TimeSeconds "$Level.TimeSeconds);

		NumPlayers++;
		bWelcomePending = true;

		//15°ÑÖ÷ÎäÆ÷
		KFXPlayer(NewPlayer).fxDBPlayerEquipList.Body[0] = 1105;    //ÒÂ·þ
		KFXPlayer(NewPlayer).fxDBPlayerEquipList.Body[1] = 1105;
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nMajorWeaponID = 65537;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[0] = 65538;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[1] = 65539;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[2] = 65540;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[3] = 65541;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[4] = 65542;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[5] = 65543;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[6] = 65544;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[7] = 65545;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[8] = 65546;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[9] = 65549;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[10] = 0;//65550;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[11] = 0;//65551;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[12] = 0;//65552;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[13] = 0;//65553;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo.nMajorWeapons[14] = 0;//65554;
		log("KFXgameInfo----20-----Level.TimeSeconds "$Level.TimeSeconds);

		//1°Ñ¸±ÎäÆ÷
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nMinorWeaponID = 2031617;
		//1°ÑÀä±øÆ÷
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nMeleeWeaponID = 2686977;
		//5¸öÀ×£¬²»ÓÃÀàÐÍ¼ì²é
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nGrenades[0] = 3342337;
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nGrenades[1] = 3407873;
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nGrenades[2] = 3473409;
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nGrenades[3] = 393217;
		KFXPlayer(NewPlayer).fxDBPlayerInfo.nGrenades[4] = 458754;

		//Ìí¼Ó¹Ò¼þ
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[0] = 16449537;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[1] = 16515073;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[2] = 16580609;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[3] = 16646145;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[4] = 16711681;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[5] = 16777217;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[6] = 16842753;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[7] = 16908289;
		KFXPlayer(NewPlayer).fxTransWeapList.BodyPendents[8] = 1;
		log("KFXgameInfo----21-----Level.TimeSeconds "$Level.TimeSeconds);

		//testTasks[0] = 1;
		//testTasks[1] = 2;
		//testTasks[2] = 3;
		//testTasks[3] = 4;
		KFXPlayer(NewPlayer).TaskManager.InitServerTaskArray(testTasks);
		log("KFXgameInfo----22-----Level.TimeSeconds "$Level.TimeSeconds);

		// test level
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxLevel = 3;

		if( Level.NetMode == NM_Standalone )
		{
			bDelayedStart = false;
		}

		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxPlayerDBID = NewPlayer.PlayerReplicationInfo.PlayerID;

		log("allocate sim fxPlayerDBID is "$KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxPlayerDBID);


		if(IsA('KFXPVEGame'))
		{
			InitPVEPRIdata(NewPlayer,nSessionID);
			KFXPlayer(NewPlayer).PVEBaseLevelUp(class'PVEGameManager'.static.GetCurPart(),class'PVEGameManager'.static.IsFirstGuanInPart());
		}
		// ÑÓ³Ù³öÉú
		if ( bDelayedStart )
		{

			NewPlayer.GotoState('PlayerWaiting');

			return NewPlayer;
		}
		log("KFXgameInfo----23-----Level.TimeSeconds "$Level.TimeSeconds);

		// ×¢Òâ£ºÕâ¸öÊ±ºòpawn»¹Ã»ÓÐ²úÉúÄØ
		log("KFXgameInfo----25-----Level.TimeSeconds "$Level.TimeSeconds);


		return NewPlayer;
	}
	// ´óÌüÄ£Ê½
	else
	{
		nSessionID = GetIntOption(Options, "Session", -1);
		KFXValidatePlayer(nSessionID, fxPlayerInfo, true);          //»ñµÃSeesionID

		log("#### INFO #### player login, player id="$fxPlayerInfo.PlayerID
				  @"name="$fxPlayerInfo.PlayerName
				  @"session="$fxPlayerInfo.SessionID);

		//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.21
		KFXGetPlayerExpInfo(nSessionID, fxPlayerExpInfo);
		//>>
		KFXGetPlayerPropsInfo(nSessionID, fxNetPlayerProps);
		KFXGetPlayerWeapsInfo(nSessionID, fxPlayerWeapsInfo);
		KFXGetPlayerCurEquipList( nSessionID, PlayerEquipListInfo );
		GetPlayerInfoLog(fxNetPlayerProps, fxPlayerWeapsInfo, fxPlayerInfo);

		//<< Dolby Demo
		if (DVServer != none && DVCount == 0)
		{
			CSVMapInfo = class'KFXTools'.static.GetConfigTable(101);//KFXMapInfo.csv
			if (CSVMapInfo != none)
			{
				CSVMapInfo.SetCurrentRow(KFXAgent.Game.nMapID);
				MapName = CSVMapInfo.GetString("MapName");
				DVServer.DVMapSpatialChannel(MapName);
			}
			//TODO
			DVCount++;
		}
		//>>

		// ¹ýÂË×Ö·û´®ÑÕÉ«
		Options = StripColor(Options);

		// ½âÊÍOptions**ÁÙÊ±
		//InName     = Left(ParseOption ( Options, "Name"), 20);
		InName     = fxPlayerInfo.PlayerName;
		InTeam     = fxPlayerInfo.TeamID;

				// Í¬²½µØÍ¼ID
		KFXGameReplicationInfo(GameReplicationInfo).fxMapID = KFXAgent.Game.nMapID;
		fxGameOptParam = KFXAgent.Game.nGameOptParam;
		if(fxGameOptParam>0)
		{
			KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle = GetGameOptFlag(6); //|| KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle
			KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle = GetGameOptFlag(7); //|| KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle
			log("[KFXGameInfo] GameOptParam open"$fxGameOptParam);
		}
		else
		{
			log("[KFXGameInfo] GameOptParam closed"$fxGameOptParam);
		}
		// ×¢Òâ£ºÕâÊ±ºòControllerÊÇ¿ÕµÄ

		// ²éÕÒ³öÉúµã
		StartSpot = FindPlayerStart( None, InTeam, Portal );

		// ÎÞ·¨³öÉúÔò·µ»Ønone
		if( StartSpot == None )
		{
			Error = GameMessageClass.Default.FailedPlaceMessage;
			log("Couldn't FindPlayerStart nSessionID :"$nSessionID);
			KFXAgent.KFXPlayerLeave(nSessionID);
            return None;
		}

		// ²úÉúÒ»¸öcontroller
		if ( PlayerControllerClass == None )
		{
			PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));
		}
		NewPlayer = spawn(PlayerControllerClass,,,StartSpot.Location,StartSpot.Rotation);

		if( NewPlayer == None )
		{
			log("Couldn't spawn player controller of class "$PlayerControllerClass$"  nSessionID :"$nSessionID);
			Error = GameMessageClass.Default.FailedSpawnMessage;
			KFXAgent.KFXPlayerLeave(nSessionID);
            return None;
		}

		// ÉèÖÃ³öÉúµã
		NewPlayer.StartSpot = StartSpot;

		// ÉèÖÃÓÎÏ·Í¬²½ÐÅÏ¢
		NewPlayer.GameReplicationInfo = GameReplicationInfo;

		// ÉèÖÃÊý¾Ý¿âÐÅÏ¢
		KFXPlayer(NewPlayer).fxDBPlayerInfo = fxPlayerInfo;

		// Êý¾Ý¿âIDÉèÖÃ
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxPlayerDBID = fxPlayerInfo.PlayerID;
		//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.21
		KFXPlayer(NewPlayer).fxDBPlayerExpInfo = fxPlayerExpInfo;
		for( i = 0; i<fxPlayerInfo.MissionBlock.Missions.Length; i++ )
		{
			KFXPlayer(NewPlayer).ServerInTaskArray[KFXPlayer(NewPlayer).ServerInTaskArray.Length] = fxPlayerInfo.MissionBlock.Missions[i].MissionID;
		}
		KFXPlayer(NewPlayer).TaskManager.InitServerTaskArray(KFXPlayer(NewPlayer).ServerInTaskArray);

		//>>
		KFXPlayer(NewPlayer).fxDBPlayerPropsInfo = fxNetPlayerProps;
		KFXPlayer(NewPlayer).fxDBPlayerWeaponsInfo = fxPlayerWeapsInfo;
		KFXPlayer(NewPlayer).fxDBPlayerEquipList = PlayerEquipListInfo;
		KFXPlayer(NewPlayer).fxTransWeapList    = PlayerEquipListInfo;
		KFXPlayer(NewPlayer).KFXCurSelectWeaponID = KFXPlayer(NewPlayer).fxDBPlayerInfo.nMajorWeaponID;

		CFG_WeapComponent = class'KFXTools'.static.GetConfigTable(22);

		for(i = 0; i< PlayerEquipListInfo.PlayerWeaponComponents.EquipedWeaponComponents.Length;i++)
		{
			if(CFG_WeapComponent.SetCurrentRow(PlayerEquipListInfo.PlayerWeaponComponents.EquipedWeaponComponents[i]))
			{
				WeaponID = CFG_WeapComponent.GetInt("GunID");
				part = CFG_WeapComponent.GetInt("Part");
				KFXPlayer(NewPlayer).AddComponentInfo(WeaponID,
					PlayerEquipListInfo.PlayerWeaponComponents.EquipedWeaponComponents[i],part);

			}
		}

		// add vip & netbar & prop level
		if( fxPlayerInfo.nVipLevel > 0 )
		{
			KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bVipBonus = true;
		}
		if( fxPlayerInfo.nNetBarMode > 0 )
		{
			KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bNetBarBonus = true;
		}
		// Ê×ÏÈ½øÈë¹Û²ìÄ£Ê½
		if ( bAttractCam )
		{
			NewPlayer.GotoState('AttractMode');
		}
		else
		{
			NewPlayer.GotoState('Spectating');
		}

		// ³õÊ¼»¯Ãû×Ö
		if( InName=="" )
		{
			InName=DefaultPlayerName;
		}
		if( Level.NetMode!=NM_Standalone || NewPlayer.PlayerReplicationInfo.PlayerName==DefaultPlayerName )
		{
			ChangeName( NewPlayer, InName, false );
		}

		// ÉèÖÃÊ¹ÓÃµÄÌáÊ¾ÉùÒô°ü**´ý¶¨
		NewPlayer.PlayerReplicationInfo.VoiceTypeName = ParseOption ( Options, "Voice");

		// ÉèÖÃ½ÇÉ«Ä£ÐÍÃû×Ö**·ÏÆú
		// NewPlayer.SetPawnClass(DefaultPlayerClassName, InCharacter);

		// ·ÖÅäÒ»¸öPlayerID**ÓÎÏ·ÄÚ×¨ÓÃ
		NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

		// login time
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxLoginTime = Level.TimeSeconds;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).TimeNeedChangeWeapBegin = Level.TimeSeconds;

		log("\\\\\\\\\\\\fxPlayerInfo.nSpectatorView:"$fxPlayerInfo.nSpectatorView);
		// ¹Û²ìÕßÄ£Ê½ ½øÈëÓÎÏ·ºóÖ±½ÓÊÇ¹Û²ìÕß ËïÇ¿ 2010.1.4
		if(fxPlayerInfo.nSpectatorView == 1)
		{
			  bSpectator = true;
			  // Õâ¸öÒªÍ¬²½µÄ
			  KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bSpectatorView = true;
//              if(!KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle)
//              {
//                  KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle = true;
//              }
//              if(!KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle)
//              {
//                  KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle = true;
//              }
//              log("KFXGameInfo------KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle "$KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle);
//              log("KFXGameInfo------KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle "$KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle);

		}


		KFXAgent.NotifyPlayerLogInGameServer(KFXPlayer(NewPlayer).fxDBPlayerInfo.SessionID);



		// ¹Û²ìÕß»òÕßÎÞ·¨·ÖÅä¶ÓÎéµÄÊ±ºò
		if ( bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator || !ChangeTeam(newPlayer, InTeam, false) )
		{
			NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
			NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
			NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
			NumSpectators++;
			return NewPlayer;
		}

		NumPlayers++;
		bWelcomePending = true;

		// ÉèÖÃÐÞÕýÖµ¡¢pawnÀà¡¢ÉíÉÏ±³°üµÈµÈ
		KFXSetupPlayer(KFXPlayer(NewPlayer), fxPlayerInfo);

		// Ôö¼ÓÈËÎïµÈ¼¶Í¬²½
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxLevel = fxPlayerInfo.nLevel;

		// Ôö¼ÓÍ¨¹ý×Ü»ý·Ö»»È¡ÔË¶¯Ô±³ÆºÅ
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).KFXTotalSPoint = fxPlayerInfo.nTotalSPoint;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxBattleTeamName = fxPlayerInfo.FactionName;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxBattleTeamID = fxPlayerInfo.FactionID;

		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).KFXIndividualGrade = fxPlayerInfo.nIndividualGrade;
		KFXTeamInfo(NewPlayer.PlayerReplicationInfo.Team).KFXTeamGrade = fxPlayerInfo.nTeamGrade;
		log("KFXIndividualGrade org"@KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).KFXIndividualGrade);
		log("KFXTeamInfo KFXTeamGrade org"@KFXTeamInfo(NewPlayer.PlayerReplicationInfo.Team).KFXTeamGrade);
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).PreDroppedTime = Level.TimeSeconds;
		log("KFXgameINfo------Level.TimeSeconds :"$Level.TimeSeconds);

		// Õ½¶Ó»ÕÕÂ
		if ( fxPlayerInfo.FactionIconID == 1 )
		{
			// 160001ÎªÄ¬ÈÏ¶Ó»ÕÇ°¾°ID
			KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxFactionIcon = 16001;
			KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxFactionBackGround = 1;
		}
		else
		{
			KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxFactionIcon = fxPlayerInfo.FactionIconID & 0x0000FFFF;
			KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxFactionBackGround = (fxPlayerInfo.FactionIconID & 0xFFFF0000) >> 16;
		}
		//-------»áÔ±¹¦ÄÜ
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).KFXVIP = fxPlayerInfo.nIsMember;

		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).PlayerRewardTime =  fxPlayerInfo.RewardTime;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).PlayerRewardCount = fxPlayerInfo.RewardCount;

		//½ÇÉ«µÄÍø°ÉÐÅÏ¢
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).netbar_level = fxPlayerInfo.level_netbar;
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).exp_netbar_ex = fxPlayerInfo.xp_netbar[0];
		KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).silver_netbar_ex = fxPlayerInfo.xp_netbar[1];
		log("KFXGameInfo------KFXAgent.MAX_ActionAdd_Num "$KFXAgent.MAX_ActionAdd_Num);
		for(j=0; j<KFXAgent.MAX_ActionAdd_Num; j++)
		{
			 KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).ActionRate[j] =  fxPlayerExpInfo.ActionRate[j];
			 KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).ActionType[j] =  fxPlayerExpInfo.ActionType[j];
		}
		log(" ActionRate[0] "$fxPlayerExpInfo.ActionRate[0]$
			" ActionRate[1] "$fxPlayerExpInfo.ActionRate[1]$
			" ActionRate[2] "$fxPlayerExpInfo.ActionRate[2]$
			" ActionRate[3] "$fxPlayerExpInfo.ActionRate[3]);
		log(" ActionType[0] "$fxPlayerExpInfo.ActionType[0]$
			" ActionType[1] "$fxPlayerExpInfo.ActionType[1]$
			" ActionType[2] "$fxPlayerExpInfo.ActionType[2]$
			" ActionType[3] "$fxPlayerExpInfo.ActionType[3]);

		KFXPlayer(NewPlayer).bWantToBeVIP  = fxPlayerInfo.bWantToBeVIP;
		if(KFXPlayer(NewPlayer).IsBlueTeam() && KFXPlayer(NewPlayer).bWantToBeVIP == 1)
		{
			WantToBeVIPNum++;
		}
		log(" bWantToBeVIP "$KFXPlayer(NewPlayer).bWantToBeVIP$
			" RewardCount "$fxPlayerInfo.RewardCount$
			" RewardTime "$fxPlayerInfo.RewardTime
			$"KFXPlayer(NewPlayer).IsBlueTeam():"$KFXPlayer(NewPlayer).IsBlueTeam());

		log("[KFXGameInfo]  LogIn fxPlayerInfo.nTotalSPoint:"$fxPlayerInfo.nTotalSPoint);
		log("[KFXGameInfo]  LogIn  KFXVIP:"$fxPlayerInfo.nIsMember);
		log("fxPlayerInfo.SessionID"$fxPlayerInfo.SessionID);
		;
		log("PlayerName"$InName);
		log("[KFXGame] fxBattleTeamID "$KFXPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).fxBattleTeamID);

		//if(KFXAgent.bPVEGame)
		if(IsA('KFXPVEGame'))
		{
			InitPVEPRIdata(NewPlayer,nSessionID);
			KFXPlayer(NewPlayer).PVEBaseLevelUp(class'PVEGameManager'.static.GetCurPart(),class'PVEGameManager'.static.IsFirstGuanInPart());
		}

		// ÑÓ³Ù³öÉú
		if ( bDelayedStart )
		{
			NewPlayer.GotoState('PlayerWaiting');
			return NewPlayer;
		}

		// ×¢Òâ£ºÕâ¸öÊ±ºòpawn»¹Ã»ÓÐ²úÉúÄØ
		return NewPlayer;
	}
}
function InitPVEPRIdata(Controller NewPlayer,int nSessionID);

function GetPlayerInfoLog(KFXFaeryAgent.KFXBagPropsInfo fxNetPlayerProps,
		 KFXFaeryAgent.KFXPlayerWeaponsBakInfo fxNetPlayerWeaps,
		 KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo)
{
	local int loop;
	 // µÀ¾ß
	for ( loop = 0; loop < 30; loop++ )
	{
		if ( fxNetPlayerProps.nBagProps[loop] != 0 )
		{
			log("[KFXGameInfo][AddAgentInventory] nBagProps id:"$fxNetPlayerProps.nBagProps[loop]);
		}
	}

	// À×
	for ( loop = 0; loop < 3; loop++ )
	{
		if ( fxNetPlayerInfo.nGrenades[loop] != 0 )
		{
			log("[KFXGameInfo][AddAgentInventory] nGrenades id:"$fxNetPlayerInfo.nGrenades[loop]);
		}
	}

	// µ¶
	if (fxNetPlayerInfo.nMeleeWeaponID != 0)
	{
		log("[KFXGameInfo][AddAgentInventory] nMeleeWeaponID id:"$fxNetPlayerInfo.nMeleeWeaponID);
	}

	// ¸¨ÎäÆ÷
	if (fxNetPlayerInfo.nMinorWeaponID != 0)
	{
		log("[KFXGameInfo][AddAgentInventory] nMinorWeaponID id:"$fxNetPlayerInfo.nMinorWeaponID);
	}

	//Íæ¼Ò×°±¸ÁËÖ÷ÎäÆ÷
	if (fxNetPlayerInfo.nMajorWeaponID != 0 )
	{
		log("[KFXGameInfo][AddAgentInventory] nMajorWeaponID id:"$fxNetPlayerInfo.nMajorWeaponID);
	}
}

//Usage: ´´½¨¿¨Æ¬°ü£¬¸ù¾ÝFareAgent´«À´µÄÊý¾Ý£¬¼ÓÔØ¿¨Æ¬¶ÔÏó
//param1: ÓÎÏ·Õß£¬½«¿¨Æ¬°ü°ó¶¨¸ø´«ÈëµÄÓÎÏ·Õß
//Author:Hawk Wang 2009-12-24  wanghao2@kingsoft.com
//Call:ÔÚPostLoginÊÂ¼þÖÐ£¬ÎªÃ¿Ò»¸öÍæ¼Òµ÷ÓÃÒ»´Î¡£
Function KFXCardPackInit(KFXPlayer inPlayer)
{
	local KFXCardPack cardPack;

	if(inPlayer!=none)
	{
		cardPack = inPlayer.KFXGetCardPack();
		//TODO£ºÕýÊ½°æÊ¹ÓÃÕâ¸ö´úÂë£¡£¡£¡£¡£¡£¡£¡£¡
		CardPack.KFXInitCardPack(inPlayer,self);

		//FOR DEBUG ONLY£º ÕýÊ½°æ×¢ÏúµôÕâ¸ö´úÂë
		;
//        cardPack.TestInitCardPack(inPlayer,self);
		//End of FOR DEBUG ONLY
	}
	else
	{
		Log("[KFXGameInfo][KFXCardPack]:Bad Player Controller!");
	}
}

//Useage: ÔÚÃ¿´ÎPawn±»³õÊ¼»¯ÎäÆ÷Ê±£¬£¨ÖØÉúºó£©ÖØÖÃµÀ¾ß
//param£º´«ÈëÖ¸¶¨µÄpawn£¬ÓÃÓÚÕÒµ½¶ÔÓ¦µÄKFXPlayer¶ÔÏó
//Author: Hawk Wang Íõð© wanghao2@kingsoft.com
//Call:ÔÚAddDefaultInventoryµ÷ÓÃ¡££¨ÔÚAddNotAgentInventory( PlayerPawn);Ö®ºó£©
Function KFXCardPackReset(Pawn inPawn)
{    local KFXCardPack cardPack;
	 local KFXPlayer P;

	 P = KFXPlayer(inPawn.Controller);
	 cardPack = P.KFXGetCardPack();

	 cardPack.KFXReadyCard();
	 ;
}


// µÇÂ½³É¹¦ºóÐø´¦Àí**ÕâÀï²ÅÊÇ¿ÉÒÔ°²È«µÄÊ¹ÓÃPlayerReplicationInfo
// ÕâÀï»áµ÷ÓÃ²úÉúPawnºÍHUD\ScoreBoard
event PostLogin( PlayerController NewPlayer )
{
	super.PostLogin(NewPlayer);

	// Ò»´ÎÐÔ³õÊ¼»¯µÀ¾ß
	KFXAddPropOnce(KFXPlayer(NewPlayer));
	// Ò»´ÎÐÔ×°ÔØµÀ¾ß
	KFXCardPackInit(KFXPlayer(NewPlayer));

	//<< wangkai Dolby Voice, 2008-07-08
	if (DVServer != none)
	{
		log ("[Dolby Voice] <KFXGameInfo::PostLogin> InitClientInfo Now...");

		KFXPlayer(NewPlayer).KFXPlayerIP = NewPlayer.GetPlayerNetworkAddress();
		;

		//Í¬²½¸ø¿Í»§¶ËÒ»Ð©ÐÅÏ¢£¬Ê¹ÆäÁ¬½ÓAudioServer
		DVServerInitClientInfo(KFXPlayer(NewPlayer));
		//DVServerÁ¬½Ó´ËÍæ¼Ò
		DVServer.DVConnectPlayer(KFXPlayer(NewPlayer));
	}
	else
	{
		log ("[Dolby Voice] <KFXGameInfo::PostLogin> InitClientInfo Failed Since DVServer Is Null");
	}
	//>>

	KFXPlayer(NewPlayer).KFXPlayerLoginTime = Level.TimeSeconds;
}

// ÊÇ·ñ½ÓÊÜÎï¼þ**²»°üÀ¨ÎäÆ÷
event AcceptInventory(pawn PlayerPawn)
{
	super.AcceptInventory(PlayerPawn);
}
//-----------------------------------------------------------


//-----------------------------------------------------------
// function²¿·Ö
//-----------------------------------------------------------
// ÖØÖÃlevel**Ã»·¢ÏÖÔÚÄÄÀï±»µ÷ÓÃµÄ£¿
function Reset()
{
	Super.Reset();
}

// ÉèÖÃÓÎÏ·ËÙ¶È**Ö÷ÒªÀïÃæÓÐ¸öSetTimer
function SetGameSpeed( float T )
{
	super.SetGameSpeed(T);
}

// ¿ªÊ¼±ÈÈü**ÔÚPostLoginÖÐµ÷ÓÃ
function StartMatch()
{
	// Ä¿Ç°µÚÒ»¸öÈËµÇÂ½µÄÊ±ºò»á±»µ÷ÓÃÒ»´Î
	// ÒÔºóÖ±½Ó²úÉúÈËÎï

	super.StartMatch();

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø

	if ( KFXAgent == none ) //·Ç´óÌüÄ£Ê½
	{
	}

	//>>
}


// Íæ¼ÒÊÇ·ñ¿ÉÒÔÖØÉú£¬¾ßÌåÄ£Ê½ÀïÃæÐèÒªÖØÔØ
function bool PlayerCanRestart( PlayerController aPlayer )
{
	if(aPlayer.PlayerReplicationInfo.bOnlySpectator)
	{
		return false;
	}
	return super.PlayerCanRestart(aPlayer);
}


function int KFXGetPlayerStartTeam(Controller aPlayer)
{
	local int TeamNum;
	// Ã»ÓÐ¶ÓÎéÄ¬ÈÏÎª255
	if( aPlayer.PlayerReplicationInfo == none || aPlayer.PlayerReplicationInfo.Team == none )
	{
		TeamNum = 255;
	}
	else
	{
		if(KFXPlayer(aPlayer)!=none)
		{
			TeamNum = KFXPlayer(aPlayer).GetPlayerRealTeamNum();
		}
		else
			TeamNum = aPlayer.PlayerReplicationInfo.Team.TeamIndex;
	}

	return TeamNum;
}

function KFXSetUpBotAttributes(Controller aPlayer, NavigationPoint startSpot)
{
	if( KFXBot(aPlayer) == none )
		return;
	if( KFXPawn(aPlayer.Pawn) == none )
		return;

	KFXPawn(aPlayer.Pawn).bCanStrafe = true;
}

// Íæ¼ÒÖØÉú**ÖØÒªº¯Êý**ÖØÐ´
function RestartPlayer( Controller aPlayer )
{
	local int i;
	local int TeamNum;
	local NavigationPoint startSpot;
	local int SuitID;
    local int RoleID;
	// ÔÚÊ²Ã´Çé¿öÏÂ»á³öÏÖÕâ¸öÎÊÌâ£¿£¿£¡
	if ( aPlayer == none )
	{
		log("[RestartPlayer] Error! aPlayer == none");
		return;
	}

	if(aPlayer.PlayerReplicationInfo.bOnlySpectator)
	{
		return;
	}

	if( KFXPlayer(aPlayer) != none)
		log("RestartPlayer aPlayer name:" $ aPlayer.PlayerReplicationInfo.PlayerName@Level.TimeSeconds );
	// levelÖØÆðÊ±²»ÔÊÐíÖØÉú
	if( bRestartLevel && Level.NetMode != NM_DedicatedServer && Level.NetMode != NM_ListenServer )
	{
		return;
	}
	TeamNum = KFXGetPlayerStartTeam(aPlayer);

//
	// ÐÞ¸ÄUTµÄµØ·½**±£Ö¤×Ü»á²úÉúPawnÓÚÄ³¸ö³öÉúµã
	while( aPlayer.Pawn == none )
	{
		if( i > nRestartLoop )
		{
			if(KFXPlayer(aPlayer)!= none)
				log("[RestartPlayer]Error! RestartPlayer loop over"@nRestartLoop);
			return;
		}

		// ÕÒ³öÉúµã**Ò»°ã×Ü»áÕÒµ½
		startSpot = FindPlayerStart(aPlayer, TeamNum);

		if( startSpot == none )
		{
			i++;
//            return;
			continue;
		}

		//aPlayer.PawnClass = GetDefaultPlayerClass(aPlayer);

		// ²úÉúpawn
//        if( aPlayer.PawnClass != none )
//        {

		if(KFXPlayer(aPlayer)!=none)
			SuitID = KFXPlayer(aPlayer).KFXGetSuitID();
		if( KFXBot(aPlayer) != none )
			SuitID = KFXBot(aPlayer).KFXGetSuitID();
		if( KFXMonster(aPlayer) != none )
			SuitID = KFXMonster(aPlayer).KFXGetSuitID();

		if(SuitID == 0)
		   SuitID = 1102;
		log("RestartPlayer PawnClass is "$aPlayer.default.PawnClass.Name$SuitID);
		aPlayer.Pawn = Spawn(/*class'KFXPawn'*/class<KFXPawn>(DynamicLoadObject("xxxweapons.XXX_"$aPlayer.default.PawnClass.Name$SuitID, class'class',true)),,,StartSpot.Location,StartSpot.Rotation);
		if( aPlayer.Pawn != none )
		{
			//>> ÉèÖÃbotµÄÊôÐÔ
			KFXSetUpBotAttributes(aPlayer,startSpot);
			if ( class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
			{
				//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
				//KFXPawn(aPlayer.Pawn).KFXInitilizeA(KFXPlayer(aPlayer));
				if( PlayerController(aPlayer) != none )
					KFXPawn(aPlayer.Pawn).KFXInitilizeA(KFXPlayer(aPlayer));
				else if( KFXBot(aPlayer) != none || KFXMonster(aPlayer) != none)
				{
					RoleID = InitBotRoleID(SuitID);
                    KFXPawn(aPlayer.Pawn).KFXInitilizeB(
						RoleID, TeamNum,
						KFXBot(aPlayer).AvatarBody,
						KFXBot(aPlayer).AvatarHead,
						KFXBot(aPlayer).AvatarLegs,
						SuitID);
				}
				//>>
			}
			else
			{
				//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø 2009.2.22
				//KFXPawn(aPlayer.Pawn).KFXInitilizeB(
				//    int(PlayerController(aPlayer).GetDefaultURL("RoleID")), TeamNum);
				if( PlayerController(aPlayer) != none )
				{
					KFXPawn(aPlayer.Pawn).KFXInitilizeA(KFXPlayer(aPlayer));
				}
				//Edit by lwg
				//ÖÕÓÚÕÒµ½ÁË ¡£¡£¡£
				//else if( KFXBotBase(aPlayer) != none )
				else if( KFXBot(aPlayer) != none || KFXMonster(aPlayer) != none)
				{
					RoleID = InitBotRoleID(SuitID);
                    KFXPawn(aPlayer.Pawn).KFXInitilizeB(
						RoleID, TeamNum,
						KFXBot(aPlayer).AvatarBody,
						KFXBot(aPlayer).AvatarHead,
						KFXBot(aPlayer).AvatarLegs,
						//KFXBot(aPlayer).Suit); //·Ç´óÌüÄ£Ê½ µ±´´½¨KFXBotµÄPawnÊ±Ö±½ÓÖ¸¶¨RoleID
						SuitID);
				}
				//>>
			}
			RoleGUID++;
			KFXPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).fxRoleGUID = RoleGUID;
			KFXPawn(aPlayer.Pawn).KFXPlayerId = RoleGUID;
//            return;

			break;
		}
//        }
		i++;
	}

	// ²»ÖªµÀ¸ÉÉ¶µÄ
	if( PlayerController(aPlayer) != none )
	{
		PlayerController(aPlayer).TimeMargin = -0.1;
	}

	// ÉèÖÃÒ»Ð©¶«Î÷
	aPlayer.Pawn.Anchor = startSpot;
	aPlayer.Pawn.LastStartSpot = PlayerStart(startSpot);
	aPlayer.Pawn.LastStartTime = Level.TimeSeconds;
	aPlayer.PreviousPawnClass = aPlayer.Pawn.Class;
	KFXPawnBase(aPlayer.Pawn).AshesKeepingTime = KFXGameReplicationInfo(Level.GRI).fxPlayerRestartDelay+3;

	aPlayer.Possess(aPlayer.Pawn);
	aPlayer.PawnClass = aPlayer.Pawn.Class;

	aPlayer.Pawn.PlayTeleportEffect(true, true);
	aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);

	KFXPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).bFemale = KFXPawn(aPlayer.Pawn).bIsFemale;

	// Ìí¼ÓÉíÉÏ±³°ü£¬¼´£¬ÎäÆ÷¡¢ÒÂ·þ¡¢µÀ¾ßµÈ
	AddDefaultInventory(aPlayer.Pawn);

	// ´¥·¢ÊÂ¼þ£¬Ã»É¶ÓÃ
	TriggerEvent( StartSpot.Event, StartSpot, aPlayer.Pawn);

	//·´·ÉÌìÍâ¹ÒÏà¹Ø±äÁ¿ÖÃÁã
	if(KFXPlayer(aPlayer) != none)
	{
		KFXPlayer(aPlayer).LastCheckPawnLocation = vect(0.0, 0.0, 0.0);
	}
	
	PostVolumeRestartPlayer(KFXPawn(aPlayer.Pawn),PlayerStart(startSpot));

	//Ìí¼Ó¸´»î¹ýµÃÃûµ¥
	AddRestartPlayer(KFXPlayer(aPlayer));
}

simulated function PostVolumeRestartPlayer(KFXPawn varPawn,PlayerStart varPS)
{
}
function int InitBotRoleID(int SuitID)
{
	local KFXCSVTable CFG_AVATAR;
    local int RoleID;
	;

	if ( Role != ROLE_Authority )
		return 0;
	CFG_AVATAR = class'KFXTools'.static.GetConfigTable(44);
	if ( CFG_AVATAR == none )
	{
		log("PawnAvatar.csv No Exist ");
        return 1;
	}

	if ( !CFG_AVATAR.SetCurrentRow(SuitID) )
	{
		log("PawnAvatar.csv No Exist SuitID:"$SuitID);
        if( !CFG_AVATAR.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
            ;

	}
//	if ( (SuitID & 0xffff) > 6000 )     //¶à´ËÒ»¾ÙµÄ´úÂë
//	{

		RoleID = CFG_AVATAR.GetInt("PawnListID"); //3;
//	}
//	else
//	{
//		player.fxDBPlayerInfo.RoleID = CFG_AVATAR.GetInt("PawnListID"); //1;
//	}

	log("KFXPawnBase----SuitID "$SuitID);
	log("KFXPawnBase----RoleID "$RoleID);
    return RoleID;

}
//ÍÅ¶ÓÄ£Ê½ÅÅÐò·½·¨
function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
	local KFXPlayerReplicationInfo tp1, tp2;
	tp1 = KFXPlayerReplicationInfo(p1);
	tp2 = KFXPlayerReplicationInfo(p2);
	//½µÐòÅÅÐò£¬¼´´óµÄÔÚÇ°
	//ÐèÒª½»»»Êý¾ÝµÄ·µ»Øfalse

	//±ÜÃâ¹Û²ì³É³ÉÎªACE
	if( tp1.bOnlySpectator )
	{
		if( tp2.bOnlySpectator )
			return true;
		else
			return false;
	}
	else if ( tp2.bOnlySpectator )
		return true;

	if(tp1.fxKills < tp2.fxKills)
		return false;
	else if(tp1.fxKills > tp2.fxKills)
		return true;
	if(tp1.fxDeaths > tp2.fxDeaths)
		return false;
	else if(tp1.Deaths < tp2.fxDeaths)
		return true;
//  if(p1.PlayerID > p2.PlayerID)
//      return false;
//  else
		return true;    //killsºÍdeathsÏàÍ¬µÄ£¬²»½»»»

}

// Íæ¼ÒÍË³ö
function Logout( Controller Exiting )
{
	local int i;
	local int j;
	local Controller P;
	local KFXPlayerReplicationInfo PRI;
	local KFXGameReplicationInfo GRI;
    local int SpectatorNum;
	GRI = KFXGameReplicationInfo(Level.GRI);
	PRI = KFXPlayerReplicationInfo(Exiting.PlayerReplicationInfo);
	if ( PlayerController(Exiting) != None )
	{
		if ( PlayerController(Exiting).PlayerReplicationInfo.bOnlySpectator )
		{
			NumSpectators--;
		}
		else
		{
			NumPlayers--;
		}
	}

	for ( i= 0;i < GRI.PRIArray.length; i++ )
	{
		if ( !InOrder(GRI.PRIArray[i],Exiting.PlayerReplicationInfo) )
		{
			break;
		}
	}
//    if ( i == GRI.PRIArray.length && GRI.GameMVPUsedWeaponID == 0)
//    {
//        GRI.GameMVPUsedWeaponID = KFXPlayer(Exiting).KFXCurSelectWeaponID;
//        log("[Logout] Exiting setup GameMVPUsedWeaponID ");
//    }
	//<< wangkai, Dolby Voice, 2008-07-09
	if (DVServer != none)
	{
		DVDisconnectPlayer(KFXPlayer(Exiting));
	}
	else
	{
		log ("[Dolby Voice] <KFXGameInfo::Logout> Null DVServer When Player Log Out");
	}
	//>>
    log("GameInfo------Exiting.PlayerReplicationInfo.PlayerName "$Exiting.PlayerReplicationInfo.PlayerName);
	NotifyLogout(Exiting);
	KFXPlayer(Exiting).bLogOutInGame = true;
	log("[zjpwxh]Player Logout : "$Exiting.PlayerReplicationInfo.PlayerName);

	// ½áÊøÌõ¼þ**ÅÐ¶ÏÊÇ·ñ»¹ÓÐ¶ÓÓÑÔÚÏß£¬·ñÔò¶ÓÎéÊ§°ÜÓÎÏ·½áÊø

	// ÍË³öÌáÊ¾
	BroadcastLocalizedMessage(class'KFXGameMessage', 2, Exiting.PlayerReplicationInfo);

	if( !bCallGameEnd && KFXPlayerReplicationInfo(Exiting.PlayerReplicationInfo).bSpectatorView)
	{
		RefalshData(Exiting, true);//¹Û²ìÕßÀë¿ª²»»áµ¼ÖÂÓÎÏ·½áÊø¡£
		AfterRefreshData(KFXPlayer(Exiting));
		return;
	}
	i =0;               //¶ÔÉÏÃæÊ¹ÓÃi½øÐÐ¹é0
	if( !bCallGameEnd && Exiting.PlayerReplicationInfo.Team != none )
	{
		// Kevin Sun: ÖÐÍ¾ÍË³ö
		RefalshData(Exiting, true);
		AfterRefreshData(KFXPlayer(Exiting));

		for ( P = Level.ControllerList; KFXPlayer(P) != None; P = P.nextController )
		{
			if( P.PlayerReplicationInfo.Team != none && Exiting.PlayerReplicationInfo.Team != none
				&& P.PlayerReplicationInfo.Team.TeamIndex == Exiting.PlayerReplicationInfo.Team.TeamIndex
				&& !KFXPlayerReplicationInfo(P.PlayerReplicationInfo).bSpectatorView)
			{
				log("GameInfo------P.PlayerReplicationInfo.PlayerName "$P.PlayerReplicationInfo.PlayerName);
                i++;
			}
		}
		log("GameInfo------i "$i);
		if( i == 0 )
		{
			for ( P = Level.ControllerList; KFXPlayer(P) != None; P = P.nextController )
			{
				if( P.PlayerReplicationInfo.Team != none && Exiting.PlayerReplicationInfo.Team != none
					&& P.PlayerReplicationInfo.Team.TeamIndex != Exiting.PlayerReplicationInfo.Team.TeamIndex )
				{
					EndGame(P.PlayerReplicationInfo, "NoEnemy");
				}
				j++;
				if( P.PlayerReplicationInfo != none && KFXPlayerReplicationInfo(P.PlayerReplicationInfo).bSpectatorView)
				{
				    SpectatorNum++ ;
                }
			}
			log("GameInfo------j "$j$"   SpectatorNum"$SpectatorNum);
			if( j == 0  || j == SpectatorNum)
			{
				KFXCallGameEnd();
			}
		}
	}

	if (!bCallGameEnd && GameReplicationInfo != none)
	{
		for (i = 0; i < GameReplicationInfo.PRIArray.Length; i++)
		{
			PRI = KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
			PRI.UpdatePlayerLeaveCombatInfo(GameReplicationInfo.PRIArray);
		}
	}
}

// PostLoginÊ±ºô½Ð£¬Í¨ÖªÆäËûÍæ¼Ò
function NotifyLogin(int NewPlayerID)
{
	super.NotifyLogin(NewPlayerID);
}

function NotifyLogout(Controller Exiting)
{
	super.NotifyLogout(Exiting);
}

function SetPlayerDefaults(Pawn PlayerPawn);
//ÎªÄ£Ê½Ìí¼ÓÄ£Ê½ÎäÆ÷ Player Ìí¼ÓÎäÆ÷µÄplayer,  Index ÔÚÄ£Ê½ÎäÆ÷ËùÔÚ¶ÓÎéÖÐµÄ±àºÅ,
//  Mode Ëæ»úµÄ·½Ê½£¬ all ÊÇ·ñÊÇËùÓÐÈË¶¼¿ÉÒÔÓµÓÐ
function SetModeWeapToPlayer( KFXPlayer Player, int Mode );
function bool CheckAddModeWeap()
{
	return false;
}

//Ìí¼ÓÒ»¸ö±³°ü**ÁÙÊ±ÊµÏÖ
function AddDefaultInventory( pawn PlayerPawn)
{
//    local KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo;
//    local int CurSelectWeapID;
	local KFXPlayer P;

	SetPlayerDefaults(PlayerPawn);  // do nothing
	P = KFXPlayer(PlayerPawn.Controller);

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø Ö»ÒªÊÇbot¾Íµ¥¶À´¦Àí»ñµÃÎäÆ÷µÄÁ÷³Ì
	if( KFXBot(PlayerPawn.Controller) != none )
	{
		KFXBot(PlayerPawn.Controller).AddBotInventory();
		//AddNotAgentInventory( PlayerPawn );
	}
	else if( KFXAgent == none)//²âÊÔÊ¹ÓÃµÄº¯Êý
		{
		AddNotAgentInventory( PlayerPawn );
	}
	else
	{
		AddAgentInventory( PlayerPawn);
		KFXCardPackReset(PlayerPawn);     //Íõð©£¬ÖØÖÃµÀ¾ß¡£
		PlayerPawn.Controller.ClientSwitchToBestWeapon();
	}

	//Í¬²½ÓïÒôµÀ¾ßÐÅÏ¢£¬¿Í»§¶Ë×ö¡£¡£¡£Ëä²»°²È«£¬µ«Ã»ÓÐÆäËü°ì·¨
	// rep to client
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot Èç¹ûÊÇ»úÆ÷ÈËÔòP¾­¹ýÇ¿×ªÎªnone
	if( P != none )
	//>>
	P.KFXGetVoiceItems(
		KFXPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).bKFXSpatial,
		KFXPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).KFXVoiceFont
		);

}

// Ìí¼ÓµÀ¾ß£¬È«³¡ÓÎÏ·Ö»¼ÓÒ»´Î
function KFXAddPropOnce(KFXPlayer P)
{
	local KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo;
	local KFXFaeryAgent.KFXBagPropsInfo fxNetPlayerProps;
	local int loop;
	fxNetPlayerInfo = P.fxDBPlayerInfo;
	fxNetPlayerProps = P.fxDBPlayerPropsInfo;
	// µÀ¾ß
	for ( loop = 0; loop < 20; loop++ )
	{
		if ( fxNetPlayerProps.nBagProps[loop] != 0 )
		{
			class'KFXPropSystem'.static.KFXApplyPropOnce(P, fxNetPlayerProps.nBagProps[loop]);
		}
	}
}
function AddNotAgentInventory( pawn PlayerPawn)
{
	local KFXPlayer P;

	P = KFXPlayer(PlayerPawn.Controller);

	KFXPawn(PlayerPawn).AddDefaultInventory();

	if( p!=none && P.PlayerReplicationInfo.Team!=none
	&& P.IsRedTeam() )//´øÓÐÄ£Ê½ÎäÆ÷µÄ¶ÓÎé
	{
		SetModeWeapToPlayer( P, 0 );
	}
	else
		log("[KFXGameInfo] No need to Allocate Mode Weapon");

	KFXPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).bKFXSpatial = true;
	KFXPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).KFXVoiceFont = 2;
}

//Íõð©2009-12-22£ºÐÂµÀ¾ßÏµÍ³²âÊÔ£¬×¢ÊÍµôÁË¾ÉµÄµÀ¾ßÏµÍ³µÄ´úÂë
function AddAgentInventory( pawn PlayerPawn )
{
	local KFXPlayer P;

	P = KFXPlayer(PlayerPawn.Controller);

	//Ìí¼ÓÄ£Ê½ÎäÆ÷
	KFXAddModeWeaps( PlayerPawn, p );
	//Ìí¼ÓÀ×
	KFXAddGrenades( PlayerPawn, p );
	//Ìí¼ÓÀä±ùÆ÷
	KFXAddMeleeWeapons( PlayerPawn, p );
	//Ìí¼Ó¸±ÎäÆ÷
	KFXAddAgentMinorWeapons( PlayerPawn, P );
	//Ìí¼ÓÖ÷ÎäÆ÷
	KFXAddAgentMajorWeapons( PlayerPawn, P );
}

function KFXAddModeWeaps( pawn PlayerPawn, KFXPlayer p )
{
	if( p!=none && P.PlayerReplicationInfo.Team!=none
	&& P.IsRedTeam() )//´øÓÐÄ£Ê½ÎäÆ÷µÄ¶ÓÎé
	{
		log("[gameinfo] SetModeWeapToPlayer");
		SetModeWeapToPlayer( P, 0 );
	}
}

// À×
function KFXAddGrenades( Pawn PlayerPawn, KFXPlayer p )
{
	local KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo;
	local KFXFaeryAgent.CurEquipItemsListType fxNetPlayerEquipList;
	local int loop;
	local int ItemID;
	local int flashbomb, bomb, smokebomb;


	fxNetPlayerInfo = KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo;
	fxNetPlayerEquipList = KFXPlayer(PlayerPawn.Controller).fxTransWeapList;

	for ( loop = 0; loop < 3; loop++ )
	{
		ItemID = fxNetPlayerEquipList.Grenades[loop];
		if ( ItemID > 0 )
		{
			if ( CheckItemID(ItemID,EID_FlashBomb) )
			{
				if(flashbomb == 0)
				{
					flashbomb = ItemID;
					class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn),ItemID);
				}
			}
			else if(CheckItemID(ItemID,EID_Bomb) )
			{
				if(bomb == 0)
				{
					bomb = ItemID;
					class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn),ItemID);
				}
			}
			else if(CheckItemID(ItemID,EID_SmokeBomb))
			{
				if(smokebomb == 0)
				{
					smokebomb = ItemID;
					class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), ItemID);
				}
			}
			else
			{
				log("Error: Check Grenade id error so player is destroy"$PlayerPawn.PlayerReplicationInfo.PlayerName$"nGrenadesID:"$ItemID);
				log("Destroy Controller for Error Grenades"$"Player Name Is :"$PlayerPawn.Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo.PlayerID);
                PlayerPawn.Controller.Destroy();
				return;
			}
		}
	}

}

//Àä±øÆ÷
function KFXAddMeleeWeapons( pawn PlayerPawn, KFXPlayer p )
{
	local KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo;
	local KFXFaeryAgent.CurEquipItemsListType fxNetPlayerEquipList;

	fxNetPlayerInfo = KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo;
	fxNetPlayerEquipList = KFXPlayer(PlayerPawn.Controller).fxTransWeapList;
	// µ¶
	if (fxNetPlayerEquipList.MeleeWeaponID != 0)
	{
		if ( CheckItemID(fxNetPlayerEquipList.MeleeWeaponID,EID_MeleeWeapons))
		{
			KFXPlayer(PlayerPawn.Controller).KFXCurSelectWeaponID = fxNetPlayerEquipList.MeleeWeaponID;
			class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), fxNetPlayerEquipList.MeleeWeaponID);
		}
		else
		{
			log("Error: Check MeleeWeapon id error so player is destroy"$PlayerPawn.PlayerReplicationInfo.PlayerName$"nMeleeWeaponID:"$fxNetPlayerEquipList.MeleeWeaponID);
			log("Destroy Controller for Error MeleeWeapon "$"Player Name Is :"$PlayerPawn.Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo.PlayerID);
            PlayerPawn.Controller.Destroy();
			return;
		}
	}
	else
	{
		//Ä¬ÈÏÐ¡µ¶
		class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), 2686977);
	}
}

// ¸¨ÎäÆ÷
function bool KFXAddAgentMinorWeapons( pawn PlayerPawn, KFXPlayer p ,optional out KFXWeapBase RetWeap)
{
	local KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo;
	local KFXFaeryAgent.CurEquipItemsListType fxNetPlayerEquipList;
	local KFXWeapBase MinorWeap;
	local int i,WeapDurable;

	fxNetPlayerInfo = KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo;
	fxNetPlayerEquipList = KFXPlayer(PlayerPawn.Controller).fxTransWeapList;
	if (fxNetPlayerEquipList.MinorWeaponID != 0)
	{
		if ( CheckItemID(fxNetPlayerEquipList.MinorWeaponID,EID_MinorWeaponID) )
		{
			for(i = 0; i< KFXPlayer(PlayerPawn.Controller).TransComponents.Length; i++)
			{
				if(KFXPlayer(PlayerPawn.Controller).TransComponents[i].WeaponID ==fxNetPlayerEquipList.MinorWeaponID )
				{
					KFXPlayer(PlayerPawn.Controller).KFXCurSelectWeaponID = fxNetPlayerEquipList.MinorWeaponID;
					MinorWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), fxNetPlayerEquipList.MinorWeaponID,
						0,0,KFXPlayer(PlayerPawn.Controller).TransComponents[i].ComponentID);
					break;
				}
			}
			if(i == KFXPlayer(PlayerPawn.Controller).TransComponents.Length)
			{
				KFXPlayer(PlayerPawn.Controller).KFXCurSelectWeaponID = fxNetPlayerEquipList.MinorWeaponID;
				MinorWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), fxNetPlayerEquipList.MinorWeaponID);
			}
			WeapDurable = KFXAgent.GetItemDurable(KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo.SessionID,fxNetPlayerEquipList.MinorWeaponID);
			if(MinorWeap != none && WeapDurable != -1)
				MinorWeap.KFXServerDurableFact(WeapDurable);
			if(MinorWeap != none)
			{
				RetWeap = MinorWeap;
				return true;
			}
			else
				 return false;
		}
		else
		{
			log("Error: Check MinorWeapon id error so player is destroy"$PlayerPawn.PlayerReplicationInfo.PlayerName$"nMinorWeaponID"$fxNetPlayerEquipList.MinorWeaponID);
			log("Destroy Controller for Error MinorWeapon "$"Player Name Is :"$PlayerPawn.Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo.PlayerID);

            PlayerPawn.Controller.Destroy();
			return false;
		}
	}
	return false;
}

//Ö÷ÎäÆ÷
function KFXAddAgentMajorWeapons( pawn PlayerPawn, KFXPlayer p ,optional out KFXWeapBase RetWeap)
{
	local KFXFaeryAgent.KFXPlayerInfo fxNetPlayerInfo;
	local KFXFaeryAgent.CurEquipItemsListType fxNetPlayerEquipList;
	local int SessionID;
	local int CurSelectWeapID;
	local int NewMajorWeapID;
	local int i,WeapDurable;
	local KFXWeapBase MajorWeap;

	fxNetPlayerInfo = KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo;
	fxNetPlayerEquipList = KFXPlayer(PlayerPawn.Controller).fxTransWeapList;
	SessionID = fxNetPlayerInfo.SessionID;
	CurSelectWeapID = KFXPlayer(PlayerPawn.Controller).KFXCurSelectWeaponID;
	//¸´»îºóÃ»ÓÐÎäÆ÷£¬Ìí¼ÓÈÕÖ¾
	log("KFXGameInfo-------- KFXPlayer(PlayerPawn.Controller).PlayerName "
		$KFXPlayerReplicationInfo(PlayerPawn.Controller.PlayerReplicationInfo).PlayerName);
	log("KFXGameInfo-------- fxNetPlayerEquipList.MajorWeaponID "
		$fxNetPlayerEquipList.MajorWeaponID);


	//µ±´æÔÚÎäÆ÷ÏÞÖÆµÄÊ±ºò£¬ÐèÒªÉú³ÉÎ´ÏÞÖÆµÄÆäËüÄ¬ÈÏÖ÷ÎäÆ÷
	NewMajorWeapID = MajorWeapLimitCheck(fxNetPlayerEquipList.MajorWeaponID);

	if (NewMajorWeapID != 0 )
	{
		if ( CheckItemID(NewMajorWeapID,EID_MajorWeapons) )
		{
			for(i = 0; i< KFXPlayer(PlayerPawn.Controller).TransComponents.Length; i++)
			{
				if(KFXPlayer(PlayerPawn.Controller).TransComponents[i].WeaponID ==NewMajorWeapID )
				{
					KFXPlayer(PlayerPawn.Controller).KFXCurSelectWeaponID = NewMajorWeapID;
					MajorWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), NewMajorWeapID,
						0,0,KFXPlayer(PlayerPawn.Controller).TransComponents[i].ComponentID);
					log("KFXGameInfo-------- MajorWeap "$MajorWeap);
					break;
				}
			}
			if(i == KFXPlayer(PlayerPawn.Controller).TransComponents.Length)
			{
				KFXPlayer(PlayerPawn.Controller).KFXCurSelectWeaponID = NewMajorWeapID;
				MajorWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(PlayerPawn), NewMajorWeapID);
			}
			RetWeap = MajorWeap;
			WeapDurable = KFXAgent.GetItemDurable(KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo.SessionID,NewMajorWeapID);
			if(MajorWeap != none && WeapDurable != -1)
				MajorWeap.KFXServerDurableFact(WeapDurable);
		}
		else
		{
			log("Error: Check MajorWeapon id error so player is destroy"$PlayerPawn.PlayerReplicationInfo.PlayerName$"nMajorWeaponID:"$fxNetPlayerEquipList.MajorWeaponID);
			log("Destroy Controller for Error MajorWeapon "$"Player Name Is :"$PlayerPawn.Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(PlayerPawn.Controller).fxDBPlayerInfo.PlayerID);

            PlayerPawn.Controller.Destroy();
			return;
		}
	}
}

function int MajorWeapLimitCheck(int MajorWeapID)
{
	local int Limitparam;
	local KFXCSVTable CFG_Weapon;
	local int NewMajorWeapID;
	local int WeapGroup1;

	NewMajorWeapID = MajorWeapID;

	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
	Limitparam = KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit;

	if( NewMajorWeapID != 0 )
	{
		CFG_Weapon.SetCurrentRow(NewMajorWeapID);
		WeapGroup1 = CFG_Weapon.GetInt("WeaponGroup1");
		if(!class'KFXPropSystem'.static.KFXWeapLimitCheck( WeapGroup1, Limitparam ))
			return NewMajorWeapID;
	}

	NewMajorWeapID = 65545;
	CFG_Weapon.SetCurrentRow(NewMajorWeapID);
	WeapGroup1 = CFG_Weapon.GetInt("WeaponGroup1");
	if(!class'KFXPropSystem'.static.KFXWeapLimitCheck( WeapGroup1, Limitparam ))
		return NewMajorWeapID;

	NewMajorWeapID = 196609;
	CFG_Weapon.SetCurrentRow(NewMajorWeapID);
	WeapGroup1 = CFG_Weapon.GetInt("WeaponGroup1");
	if(!class'KFXPropSystem'.static.KFXWeapLimitCheck( WeapGroup1, Limitparam ))
		return NewMajorWeapID;

	return MajorWeapID;
}

function bool CheckItemID( int ID, EIDCheckFlag Flag )
{
	local int TypeID;

	local KFXCSVTable CFG_Item;

	//!!!
//    return true;
	if ( ID < 1 )
		return false;

	TypeID = ID>>16;

	switch ( Flag )
	{
		case EID_MajorWeapons:
		return(TypeID >= 1 && TypeID <= 30 );

		case EID_MinorWeaponID:
		return (TypeID >= 30 && TypeID <= 40);

		case EID_MeleeWeapons:
		return (TypeID >= 41 && TypeID <= 50);

		case EID_Grenades:
		return ( TypeID >= 51 && TypeID <= 60 );

		case EID_FlashBomb:
			return TypeID == 51;
		case EID_Bomb:
			return TypeID == 52;
		case EID_SmokeBomb:
			return TypeID == 53;

		case EID_RoleHead:
		case EID_RoleBody:
		case EID_RoleLeg:
			return true;

		case EID_RoleSuit:
		if ( !(TypeID>=241 && TypeID<=250) )
		{
			log("[KFXGameInfo] CheckItemID EID_RoleSuit TypeID:"$TypeID);
			return false;
		}
		break;
	}

	CFG_Item = class'KFXTools'.Static.GetConfigTable(30);
	if ( CFG_Item == none )
	{
		log("Error: CheckItemID Can't find CFG_Item");
		return false;
		//log("ERROR: CheckItemID Role has Wrong ID"$ID);
	}
	if ( !CFG_Item.SetCurrentRow(ID) )
	{
		log("ERROR: CheckItemID CFG_Item Can't find right ID"$ID);
		return false;
	}
	return true;
}


function bool CheckUpdateKills( Controller Killer, Controller Killed )
{
	return ( Killer != none && Killer != Killed );
}
//ÒªÇóÇ°Ò»Ö¡Ö´ÐÐ£¬·ñÔòPawn¾ÍÏú»ÙÁË
function CalcKillInfoPreTick(Controller Killer,Pawn KilledPawn);

// ´¦ÀíËÀÍö**ÖØÒªº¯Êý£¬ÍêÈ«ÖØÐ´       Client simulated Fire     Ç°Ò»Ö¡ Ö´ÐÐ
function ServerKilledPreTick( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	 local KFXPlayerReplicationInfo KillerPRI;

	 KillerPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);

	 if ( Killed != None && Killed.bIsPlayer )
	 {
		KFXPlayerReplicationInfo(Killed.PlayerReplicationInfo).bDeadStatus = true;
		log("KFXGameInfo-----ServerKilledPreTick");
		// ¹ã²¥ËÀÍöÏûÏ¢**Õâ¸öµØ·½Òª·¢¸ø¿Í»§¶ËÏÔÊ¾
		if( CheckUpdateKills(Killer,Killed) )
		{
			if( KFXPlayer(Killer) != none )
			{
				KFXPlayer(Killer).LogMultiKills(10.0, true);
				KillerPRI.fxCurMultiKillCount = KFXPlayer(Killer).MultiKillLevel;
			}
		}

		//ÐèÒª¼ì²éÊÇ²»ÊÇµÚÒ»µÎÑª£¬ÊÇ²»ÊÇ×îÖÕÉ±
		ClientSimuFireBroadcastDeathMessage(Killer, Killed, damageType);
		//KFXPlayer(Killer).ServerKilledPostTick = 0;
		KFXPlayer(Killer).KillInfo[KFXPlayer(Killer).KillInfo.Length - 1].TempKilled = Killed;
		KFXPlayer(Killer).KillInfo[KFXPlayer(Killer).KillInfo.Length - 1].TempdamageType = damageType;
		KFXPlayer(Killer).KillInfo[KFXPlayer(Killer).KillInfo.Length - 1].KillerWeaponID = Killed.pawn.KFXDmgInfo.WeaponID;
		CalcKillInfoPreTick(Killer,KilledPawn);
	 }
}
// ´¦ÀíËÀÍö**ÖØÒªº¯Êý£¬ÍêÈ«ÖØÐ´     Client simulated Fire     ºóÒ»Ö¡ Ö´ÐÐ
function ServerKilledPostTick( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	if ( Killed != None && Killed.bIsPlayer )
	{
		// Í¬²½Ïà¹Ø
		Killed.PlayerReplicationInfo.NetUpdateTime = FMin(Killed.PlayerReplicationInfo.NetUpdateTime, Level.TimeSeconds + 0.3 * FRand());
		// ËÀÍö×´Ì¬
		//KFXPlayerReplicationInfo(Killed.PlayerReplicationInfo).bDeadStatus = true;
		//UpdateKillReplicationInfo(Killer,Killed, damageType);

		// ¹ã²¥ËÀÍöÏûÏ¢**Õâ¸öµØ·½Òª·¢¸ø¿Í»§¶ËÏÔÊ¾
		//BroadcastDeathMessage(Killer, Killed, damageType);

		// ¼ÆËã·ÖÊý
		ScoreKill(Killer, Killed);

		// ¸üÐÂÈÎÎñÐÅÏ¢
		if(KFXPlayer(Killer) != none)
		{
			KFXPlayer(Killer).TaskManager.Killed(Killer, Killed);
		}
		if(KFXPlayer(Killed) != none)
		{
			KFXPlayer(Killed).TaskManager.Killed(Killer, Killed);
		}
	}

	// Ïú»ÙÍæ¼ÒPawn
	if( KilledPawn != none )
	{
		DiscardInventory(KilledPawn);
	}

	// ±¨ËÀÍö**ÓÐ¿ÉÄÜÓ¦¸ÃÖØÔØ
	NotifyKilled(Killer,Killed,KilledPawn);
}
// ´¦ÀíËÀÍö**ÖØÒªº¯Êý£¬ÍêÈ«ÖØÐ´
function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	if ( Killed != None && Killed.bIsPlayer )
	{
		// Í¬²½Ïà¹Ø
		Killed.PlayerReplicationInfo.NetUpdateTime = FMin(Killed.PlayerReplicationInfo.NetUpdateTime, Level.TimeSeconds + 0.3 * FRand());
		// ËÀÍö×´Ì¬
		KFXPlayerReplicationInfo(Killed.PlayerReplicationInfo).bDeadStatus = true;

		UpdateKillReplicationInfo(Killer,Killed, damageType);

		// ¹ã²¥ËÀÍöÏûÏ¢**Õâ¸öµØ·½Òª·¢¸ø¿Í»§¶ËÏÔÊ¾
		BroadcastDeathMessage(Killer, Killed, damageType);

		// ¼ÆËã·ÖÊý
		ScoreKill(Killer, Killed);

		// ¸üÐÂÈÎÎñÐÅÏ¢
		if(KFXPlayer(Killer) != none)
		{
			KFXPlayer(Killer).TaskManager.Killed(Killer, Killed);
		}
		if(KFXPlayer(Killed) != none)
		{
			KFXPlayer(Killed).TaskManager.Killed(Killer, Killed);
		}
	}

	// Ïú»ÙÍæ¼ÒPawn
	if( KilledPawn != none )
	{
		DiscardInventory(KilledPawn);
	}

	// Í¨±¨ËÀÍö**ÓÐ¿ÉÄÜÓ¦¸ÃÖØÔØ
	NotifyKilled(Killer,Killed,KilledPawn);
}
///
/// ÖÓ£º¸üÐÂ»÷É±º¯ÊýÏà¹ØµÄÍ¬²½ÐÅÏ¢ÖµClient Simulated Fire ½â¾öËÀÍöÑÓ³ÙÎÊÌâ
///
function UpdateKillReplicationInfoWithWeaponID( Controller Killer, Controller Killed, class<DamageType> damageType ,optional int KillWeaponID)
{
	local KFXCSVTable CFG_Weapon;
	local int ArrID;
	local KFXPlayerReplicationInfo KillerPRI, KilledPRI;
	local KFXGameReplicationInfo GRI;
	KillerPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	KilledPRI = KFXPlayerReplicationInfo(Killed.PlayerReplicationInfo);
	GRI = KFXGameReplicationInfo(GameReplicationInfo);
	// ËÀÍöÊý+1

	if( NeedCalcDeathCount )
	{
		if(KFXAgent != none)
		{
			if(KFXAgent.Game.nNotCountKill == 1)      //ÔËÓªÒªÇó£¬Èç¹û²Î¼ÓÄ³»î¶¯£¬ËÀÍöÊý²»¼Æ
			{
				KilledPRI.fxDeaths += 1;
			}
			else
			{
				KilledPRI.fxDeaths = 0;
			}
		}
		else
		{
			KilledPRI.fxDeaths += 1;
		}
	}
	log("KFXgameINfo------NeedCalcDeathCount "$NeedCalcDeathCount$" nNotCountKill: "$KFXAgent.Game.nNotCountKill$" fxDeaths: "$KilledPRI.fxDeaths);
	//FarmÓÎÏ·ÄÚ
	CheckDrop(Killer,Killed);

    if( CheckUpdateKills(Killer,Killed) )
	{
		if(!GRI.bNotFirstBlood)   // µÚÒ»µÎÑª
		{
			GRI.bNotFirstBlood = true;
			KillerPRI.fxFirstBooldCount++;
		}
		CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
		if ( !CFG_Weapon.SetCurrentRow(KillWeaponID) )
		{
			Log("[KFXGameInfo UpdateKillReplicationInfo] Can't Resolve The Weapon ID (Attribute Table): "$Killed.pawn.KFXDmgInfo.WeaponID);
			return;
		}
		// É±ÈËÊý+1
		KillerPRI.fxKills += 1;
//        log("KFXgameInfo-------KillerPRI.fxKills "$KillerPRI.fxKills);
		//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
		// Á¬É±ÅÐ¶¨**·Åµ½¿Í»§¶Ë
		if( KFXPlayer(Killer) != none )
		{
			if(KFXBot(Killed) != none)
			{
				KillerPRI.fxKillBots++;
			}
			ArrID = CFG_Weapon.GetInt( "WeaponGroup1" );
//          log("UpdateKillReplicationInfo Killer:"$KillerPRI.Playername);
//            log("OrgArrID"$ArrID);
			ArrID = Clamp(ArrID-1, 0, KillerPRI.fxRepArray[KillerPRI.REP_WEAPONKILL].arrData.Length-1);
//            log("ArrID"$ArrID);
			UpdatePRIRepArray(KillerPRI, KillerPRI.REP_WEAPONKILL, ArrID, KillerPRI.fxWeaponKillRep);


//          KFXPlayer(Killer).LogMultiKills(10.0, true);
			ArrID = -1;
//          KillerPRI.fxCurMultiKillCount = KFXPlayer(Killer).MultiKillLevel;

			switch(KFXPlayer(Killer).MultiKillLevel)
			{
			case 2:
				ArrID = KillerPRI.MULTIKILL_TWO;
				KillerPRI.fxDoubleKillCount++;
				break;
			case 3:
				ArrID = KillerPRI.MULTIKILL_THREE;
				KillerPRI.fxThreeKillCount++;
				break;
			case 5:
				ArrID = KillerPRI.MULTIKILL_FIVE;
				KillerPRI.fxFiveKillCount++;
				break;
			}

			if(ArrID != -1)
			{
				UpdatePRIRepArray(KillerPRI, KillerPRI.REP_MULTIKILL, ArrID, KillerPRI.fxMultiKillRep);
			}
			//KillerPRI.fxReplicateArray[REP_MULTIKILL].arrData[ArrID]++;

			;
		}
	}
}
function CheckDrop(Controller Killer, Controller Killed)
{
    if(KFXPlayer(Killer) != none /*&& KFXPlayer(Killed) != none*/ && Killer != Killed)
	{
		CalcDroppedRate(Killer,Killed);
		if(!CheckCanDroppedByKill(Killer,Killed))      //Èç¹û³¤Ê±¼ä²»ÄÜµôÂä£¬ÄÇÍ¨¹ýÊ±¼äÔÙ¸øËûÒ»´Î»ú»á
		{
			CheckCanDroppedByTime(Killer,Killed);
		}
	}
}
///
/// ÖÓ£º¸üÐÂ»÷É±º¯ÊýÏà¹ØµÄÍ¬²½ÐÅÏ¢Öµ  Òò×ö¿Í»§¶ËÄ£Äâ£¬·þÎñÆ÷·ÖÖ¡£»Õâ¸öº¯Êý²»»áÔÙ±»µ÷ÓÃ£¬±» UpdateKillReplicationInfoWithWeaponIDº¯ÊýËùÌæ´ú
///
function UpdateKillReplicationInfo( Controller Killer, Controller Killed, class<DamageType> damageType )
{
	local KFXCSVTable CFG_Weapon;
	local int ArrID;
	local KFXPlayerReplicationInfo KillerPRI, KilledPRI;
	local KFXGameReplicationInfo GRI;
	KillerPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	KilledPRI = KFXPlayerReplicationInfo(Killed.PlayerReplicationInfo);
	GRI = KFXGameReplicationInfo(GameReplicationInfo);
	// ËÀÍöÊý+1
	if( NeedCalcDeathCount )
	{
		if(KFXAgent != none)
		{
			if(KFXAgent.Game.nNotCountKill == 1)      //ÔËÓªÒªÇó£¬Èç¹û²Î¼ÓÄ³»î¶¯£¬ËÀÍöÊý²»¼Æ
			{
				KilledPRI.fxDeaths += 1;
			}
			else
			{
				KilledPRI.fxDeaths = 0;
			}
		}
		else
		{
			KilledPRI.fxDeaths += 1;
		}
	}
	//FarmÓÎÏ·ÄÚ
	if(KFXPlayer(Killer) != none /*&& KFXPlayer(Killed) != none*/ && Killer != Killed)
	{
		CalcDroppedRate(Killer,Killed);
		if(!CheckCanDroppedByKill(Killer,Killed))      //Èç¹û³¤Ê±¼ä²»ÄÜµôÂä£¬ÄÇÍ¨¹ýÊ±¼äÔÙ¸øËûÒ»´Î»ú»á
		{
			CheckCanDroppedByTime(Killer,Killed);
		}
	}

	if( CheckUpdateKills(Killer,Killed) )
	{
		if(!GRI.bNotFirstBlood)   // µÚÒ»µÎÑª
		{
			GRI.bNotFirstBlood = true;
			KillerPRI.fxFirstBooldCount++;
		}
		CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
		if ( !CFG_Weapon.SetCurrentRow(Killed.pawn.KFXDmgInfo.WeaponID) )
		{
			Log("[KFXGameInfo UpdateKillReplicationInfo] Can't Resolve The Weapon ID (Attribute Table): "$Killed.pawn.KFXDmgInfo.WeaponID);
			return;
		}
		// É±ÈËÊý+1
		KillerPRI.fxKills += 1;
		log("KFXgameInfo-------KillerPRI.fxKills "$KillerPRI.fxKills);
		//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
		// Á¬É±ÅÐ¶¨**·Åµ½¿Í»§¶Ë
		if( KFXPlayer(Killer) != none )
		{
			if(KFXBot(Killed) != none)
			{
				KillerPRI.fxKillBots++;
			}
			ArrID = CFG_Weapon.GetInt( "WeaponGroup1" );
			log("UpdateKillReplicationInfo Killer:"$KillerPRI.Playername);
			log("OrgArrID"$ArrID);
			ArrID = Clamp(ArrID-1, 0, KillerPRI.fxRepArray[KillerPRI.REP_WEAPONKILL].arrData.Length-1);
			log("ArrID"$ArrID);
			UpdatePRIRepArray(KillerPRI, KillerPRI.REP_WEAPONKILL, ArrID, KillerPRI.fxWeaponKillRep);


			KFXPlayer(Killer).LogMultiKills(10.0, true);
			ArrID = -1;
			KillerPRI.fxCurMultiKillCount = KFXPlayer(Killer).MultiKillLevel;

			switch(KFXPlayer(Killer).MultiKillLevel)
			{
			case 2:
				ArrID = KillerPRI.MULTIKILL_TWO;
				KillerPRI.fxDoubleKillCount++;
				break;
			case 3:
				ArrID = KillerPRI.MULTIKILL_THREE;
				KillerPRI.fxThreeKillCount++;
				break;
			case 5:
				ArrID = KillerPRI.MULTIKILL_FIVE;
				KillerPRI.fxFiveKillCount++;
				break;
			}

			if(ArrID != -1)
			{
				UpdatePRIRepArray(KillerPRI, KillerPRI.REP_MULTIKILL, ArrID, KillerPRI.fxMultiKillRep);
			}
			//KillerPRI.fxReplicateArray[REP_MULTIKILL].arrData[ArrID]++;

			;
		}
	}
}
//»÷É±µôÂÊÂß¼­
function CalcDroppedRate(Controller Killer, Controller Killed)
{
	local KFXPlayerReplicationInfo KillerPRI, KilledPRI;

	KillerPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	KilledPRI = KFXPlayerReplicationInfo(Killed.PlayerReplicationInfo);
	KillerPRI.DroppingKills ++;
	KilledPRI.DroppingDeaths ++;
	KillerPRI.KillsDroppedRate  =  DeathsDroppedRate * KillerPRI.DroppingDeaths - KillsDroppedRate * KillerPRI.DroppingKills;
	if(KillerPRI.KillsDroppedRate < 0)
		KillerPRI.KillsDroppedRate = 0;
	log("Killer Dropping Info"
			$"DeathsDroppedRate :"$DeathsDroppedRate
			$"KillerPRI.DroppingDeaths :"$KillerPRI.DroppingDeaths
			$"KillsDroppedRate :"$KillsDroppedRate
			$"KillerPRI.DroppingKills :"$KillerPRI.DroppingKills
			$"KillerPRI.KillsDroppedRate  "$KillerPRI.KillsDroppedRate);
   log("KilledPRI.DroppingDeaths "$KilledPRI.DroppingDeaths);
}
function float CalcTotalDroppedRate(Controller Killer)
{
	local float LastDroppedRate;
	local KFXPlayerReplicationInfo KillerPRI;

	KillerPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);

	LastDroppedRate = (DropItemBasicRate + KillerPRI.KillsDroppedRate) * MapAddRate;
	if(LastDroppedRate > 1)
	{
		LastDroppedRate = 1;
	}
	log("KFXgameInfo------LastDroppedRate "$LastDroppedRate);
	return LastDroppedRate;
}
function bool CheckCanDroppedByTime(Controller Killer,Controller Killed)
{
	local float fxTime;
	local float TimeRate;
	local float RandNum;
	local float  PreDroppedTime;
	local bool bCanDrop;
	local int DropItemID;
	local KFXPLayerReplicationInfo PRI;

	PRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	PreDroppedTime = PRI.PreDroppedTime;
	fxTime = int(Level.TimeSeconds - PreDroppedTime)/60;
	log("KFXGameInfo------fxTime "$fxTime);
	log("KFXGameInfo------ToDropItemTime "$ToDropItemTime);
	if(PRI.CurDropItemNum >= MaxDropItemNum)
	{
		log("CheckCanDroppedByTime ----PRI.PlayerName"$PRI.PlayerName$"Have Max Item");
		return false;
	}

	if(fxTime < ToDropItemTime)
	{
		log("It's not time to drop");
		return false;
	}
	TimeRate = fxTime * ToDropItemRate;
	log("KFXGameInfo------TimeRate "$TimeRate);
	log("KFXGameInfo------TimeRate "$TimeRate);

	if(RandNum < TimeRate)
	{
		log("I Will Drop because time");
		bCanDrop = FindDropItemClass(Killer, DropItemID);
		if(bCanDrop)
		{
		  if(DropItemID > 0)
		  {
			 FindDropItemLevel(Killer,bCanDrop,DropItemID);
			 DoAfterDropped(Killer,DroppedByTime);
			 return true;
		  }
		}
}
	return false;
}
function bool CheckCanDroppedByKill(Controller Killer,Controller Killed)
{
   local float RandNum;
   local bool bCanDrop;
   local int DropItemID;
   local KFXPLayerReplicationInfo PRI;
   RandNum = frand();
   PRI = KFXplayerReplicationInfo(Killer.PlayerReplicationInfo);
   log("KFXgameInfo------RandNum "$RandNum);
   log("KFXgameInfo------CalcTotalDroppedRate(Killer) "$CalcTotalDroppedRate(Killer));
   bCanDrop = false;
   if(PRI.CurDropItemNum >= MaxDropItemNum)
   {
		log("CheckCanDroppedByKill ----PRI.PlayerName"$PRI.PlayerName$"Have Max Item");
		return false;
   }
   if(RandNum <= CalcTotalDroppedRate(Killer))   //ÅÐ¶ÏÄÜ·ñµôÂä¶«Î÷
   {
	  log("I Will Drop");
	  bCanDrop = FindDropItemClass(Killer, DropItemID);
	  if(bCanDrop)
	  {
		  if(DropItemID > 0)
		  {
			 FindDropItemLevel(Killer,bCanDrop,DropItemID);
			 DoAfterDropped(Killer,DroppedByKill);
			 return true;
		  }
	  }
   }
   return false;
}
//µôÂäÄÄ¸öÄÄÖÖÁã¼þÍ¼Ö½
function  bool FindDropItemClass(Controller Player,out int DropItemID)
{
	local float RandItem;
	local int i;
	local float Rate;
	local bool bCanDrop;

	RandItem = frand();
	for(i=0; i< MaxDropPartNum; i++)
	{
	  Rate += DroppedPartInfo[i].ItemDropRate;
	  log("KFXGameInfo-----Rate "$Rate);
	  log("KFXGameInfo-----RandItem "$RandItem);
	  log("KFXGameInfo-----DroppedPartInfo[i].ItemDropRate "$DroppedPartInfo[i].ItemDropRate);

	  if(RandItem <= Rate)
	  {
		  bCanDrop = true;
		  DropItemID = DroppedPartInfo[i].ItemID;
		  log("I Will Drop this Part,ID is "$DroppedPartInfo[i].ItemID);
		  break;
	  }
	}
	log("I Try To Drop Paper bCanDrop "$bCanDrop);
	if(!bCanDrop)
	{
		for(i=0; i< MaxDropPaperNum; i++)
		{
			Rate += DroppedPaperInfo[i].ItemDropRate;
			log("DropPaper-----Rate "$Rate);
			log("DropPaper-----RandItem "$RandItem);
			log("DropPaper-----DroppedPaperInfo[i].ItemDropRate "$DroppedPaperInfo[i].ItemDropRate);

			if(RandItem < Rate)
			{
			   bCanDrop = true;
			   DropItemID = DroppedPaperInfo[i].ItemID;
			   log("I Will Drop this Paper,ID is "$DroppedPaperInfo[i].ItemID);
			   break;
			}
		}
	}
	return  bCanDrop;

}
//µôÂäÄÄ¸öµÈ¼¶µÄÁã¼þ»òÕßÍ¼Ö½
function FindDropItemLevel(Controller Player,bool bCanDrop, int DropID)
{
	local KFXCSVTable DropItemLevel;
	local float RandLevel;
	local float DropTotalLevel;
	local float DropLevel;
	local int DropLevelID;
	local int MaxLevelNum;
	local int i;
	local bool bCanDropLevel;
	if(!bCanDrop || DropID <=0)
	{
		log("Game Can't Drop bCanDrop:"$bCanDrop$"  DropID:"$DropID);
	}
	DropItemLevel = class'KFXTools'.static.KFXCreateCSVTable("DropItemID.csv");
	if( DropItemLevel == none )
	{
		log("KFXGameInfo DropItemID Table error");
		return;
	}
	if( !DropItemLevel.SetCurrentRow(DropID))
	{
		log("KFXGameInfo DropItemID Table DropID is error "$DropID);
		return ;
	}
	bCanDropLevel = false;
	MaxLevelNum = DropItemLevel.GetInt("LevelNum");
	RandLevel = frand();
	log("KFXGameInfo------MaxLevelNum "$MaxLevelNum);
	log("KFXGameInfo------RandLevel "$RandLevel);

	for(i=1; i<=MaxLevelNum; i++)
	{
		DropLevel = DropItemLevel.GetFloat("LevelRate"$i);
		DropTotalLevel += DropLevel;
		log("KFXGameInfo------DropLevel "$DropLevel);
		log("KFXGameInfo------RandLevel "$RandLevel);
		log("KFXGameInfo------DropTotalLevel "$DropTotalLevel);
		if(RandLevel <= DropTotalLevel)
		{
		   DropLevelID = DropItemLevel.GetInt("LevelID"$i);
		   bCanDropLevel = true;
		   log("I Will DropItem Level ID Is "$DropLevelID);
		   break;
		}
	}
	log("KFXGameInfo------DropLevelID "$DropLevelID);
	log("KFXGameInfo------DropID "$DropID);
	log("KFXGameInfo------bCanDropLevel "$bCanDropLevel);

	if(DropLevelID > 0 && DropID > 0 && bCanDropLevel)
	{
		SaveLastDropItem(Player,DropID,DropLevelID);
	}
}
//±£´æµôÂäÁã¼þÍ¼Ö½
function SaveLastDropItem(Controller Player ,int HigherID, int LowerID)
{
	local int LastTotalID;
	local int HigherItemID;
	local KFXPlayerReplicationInfo PRI;
	PRI = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo);

	HigherItemID = HigherID<<16;
	LastTotalID = HigherItemID  + LowerID;
	log("KFXGameInfo-----HigherID "$HigherID);
	log("KFXGameInfo-----HigherItemID "$HigherItemID);
	log("KFXGameInfo-----LowerID "$LowerID);
	log("KFXGameInfo-----LastTotalID "$LastTotalID);
	PRI.LastDropItem[PRI.CurDropItemNum++] = LastTotalID;
	PRI.PreDroppedTime  = Level.TimeSeconds;
	log("KFXGameInfo-----PRI.CurDropItemNum "$PRI.CurDropItemNum);

	KFXPlayer(Player).ClientGetDropItem(LastTotalID);     //¿Í»§¶Ë»ñµÃµôÂä
}
//µôÂäºó¹éÁã
function DoAfterDropped(Controller Player, DroppedItemWay DropWay)
{
	local KFXPlayerReplicationInfo PRI;
	PRI = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo);
	log("KFXGameInfo------DropWay "$DropWay);
	if(DropWay == DroppedByKill)
	{
		PRI.DroppingKills = 0;
		PRI.DroppingDeaths = 0;
	}
	else if(DropWay == DroppedByTime)
	{
		PRI.PreDroppedTime = Level.TimeSeconds;
	}
	log("KFXGameInfo------PRI.DroppingKills "$PRI.DroppingKills);
	log("KFXGameInfo------PRI.DroppingDeaths "$PRI.DroppingDeaths);
	log("KFXGameInfo------PRI.PreDroppedTime "$PRI.PreDroppedTime);

}
//
// ¸üÐÂÍ¬²½Êý¾ÝÊý×é
//
function UpdatePRIRepArray(KFXPlayerReplicationInfo PRI, int id1, int id2, out int repValue)
{
	local int highBits, lowBits, bits1, bits2;
	PRI.fxRepArray[id1].arrData[id2]++;
	bits1 = PRI.fxRepArray[id1].bits[0];
	bits2 = PRI.fxRepArray[id1].bits[1];
	repValue++;
	lowBits = repValue & ((1 << bits1) - 1);
	highBits = GetBits(repValue, bits1, 32 - bits1);
	highBits = ((highBits<<bits2) + id2) & ((1<<31) - 1);
	repValue = (highBits<<bits1) + lowBits;
}

function int GetPRIDataByID(KFXPlayerReplicationInfo PRI, int id1, int id2)
{
	return PRI.fxRepArray[id1].arrData[id2];
}
/* Discard a player's inventory after he dies.
*/
//ÒÆ³öºÍÏú»ÙÍæ¼ÒµÄInventory
function DiscardInventory( Pawn Other )
{
	Other.SetWeapon(None);
	Other.SelectedItem = None;
	while ( Other.Inventory != None )
		Other.Inventory.Destroy();
}

// ¹ã²¥¼°Ê±Õ½¶·ÐÅÏ¢**¸ÄÐ´ Ö»ÓÐÀ×É±²Å»á×ßÕâ¸öº¯Êý
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
	local int counter;
	if( (Killer == Other) || (Killer == None) )
	{
		KFXBroadcastLocalized(
			self,
			class'KFXCombatMessage_Suicide',
			KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
			None,
			Other.PlayerReplicationInfo,
			damageType
			);

		;
	}
	else
	{
		//¸ß16Î»ÎªÁ¬É±£¬µÍ16Î»Îª»÷É±ÊýÁ¿
		counter = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxKills & 0xffff;
		counter = counter | (KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxCurMultiKillCount << 16);

		if( KFXPawn(Other.Pawn).KFXDmgInfo.bAutoAim != 0 )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_AutoAim',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
		else if ( damageType == class'KFXDmgTypeCrossWall' )
		{
			if ( KFXPawn(Other.Pawn).KFXDmgInfo.HitBoxID == 2 )
			{
				KFXBroadcastLocalized(
					self,
					class'KFXCombatMessage_CWKill_HeadKill',
					KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
					Killer.PlayerReplicationInfo,
					Other.PlayerReplicationInfo,
					damageType,
					counter
					);

			}
			else
			{
				KFXBroadcastLocalized(
					self,
					class'KFXCombatMessage_CWKill',
					KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
					Killer.PlayerReplicationInfo,
					Other.PlayerReplicationInfo,
					damageType,
					counter
					);

			}
		}
		else if( KFXPawn(Other.Pawn).KFXDmgInfo.HitBoxID == 2 )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_KillHead',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
		//<< wangkai, É±¶¯ÎïÏûÏ¢
		else if ( KFXPawn(Other.Pawn).bSpecialRoleState )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_KillAnimal',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
		}
		else
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_Normal',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
	}
}

//¼ì²éÊÇ²»ÊÇ×îÖÕÉ±»òÕßµÚÒ»µÎÑª
//·µ»Ø1±íÊ¾µÚÒ»µÎÑª£¬·µ»Ø2±íÊ¾×îÖÕÉ±
function CheckFinalKill(out int finalKill)
{
	if(KFXGameReplicationInfo(Level.GRI).fxKilledLimit-1 == Level.GRI.Teams[0].Score
		|| KFXGameReplicationInfo(Level.GRI).fxKilledLimit-1 == Level.GRI.Teams[1].Score)
	{
		//ÓÉÓÚ´Ëº¯ÊýÊÇÔÚServerKilledPreTickÖÐ¼ÆËã£¬¶øÅÐ¶Ï×îÖÕÊ¤ÀûÊÇÔÚServerKilledPostTickÖÐ£¬
		//ËùÒÔÊÇÓÐ¿ÉÄÜ³öÏÖ¶à¸ö×îÖÕÉ±µÄ¡£
		//Èç¹û²»´æÔÚ×îÖÕÉ±
		if(!KFXGameReplicationInfo(Level.GRI).bFinalKill)
			finalKill = 2;
		KFXGameReplicationInfo(Level.GRI).bFinalKill = true;
	}
	else if(Level.GRI.Teams[0].Score == 0 && Level.GRI.Teams[1].Score == 0)
	{
		KFXGameReplicationInfo(Level.GRI).bNotFirstBlood = true;
		finalKill = 1;
	}
	log("[LABOR]----------final kill?="$FinalKill);
}
// ¹ã²¥¼°Ê±Õ½¶·ÐÅÏ¢**¸ÄÐ´
function ClientSimuFireBroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
	local int counter;
	local int ex_value;
	if( (Killer == Other) || (Killer == None) )
	{
		KFXBroadcastLocalized(
			self,
			class'KFXCombatMessage_Suicide',
			KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
			None,
			Other.PlayerReplicationInfo,
			damageType
			);

		;
	}
	else
	{
		//¸ß16Î»ÎªÁ¬É±£¬µÍ16Î»Îª»÷É±ÊýÁ¿
		counter = (KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxKills + 1) & 0xffff;
		counter = counter | (KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxCurMultiKillCount << 16);
		CheckFinalKill(ex_value);
		counter = counter | ex_value<<24;
		if( KFXPawn(Other.Pawn).KFXDmgInfo.bAutoAim != 0 )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_AutoAim',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
		else if ( damageType == class'KFXDmgTypeCrossWall' )
		{
			if ( KFXPawn(Other.Pawn).KFXDmgInfo.HitBoxID == 2 )
			{
				KFXBroadcastLocalized(
					self,
					class'KFXCombatMessage_CWKill_HeadKill',
					KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
					Killer.PlayerReplicationInfo,
					Other.PlayerReplicationInfo,
					damageType,
					counter
					);

			}
			else
			{
				KFXBroadcastLocalized(
					self,
					class'KFXCombatMessage_CWKill',
					KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
					Killer.PlayerReplicationInfo,
					Other.PlayerReplicationInfo,
					damageType,
					counter
					);

			}
		}
		else if( KFXPawn(Other.Pawn).KFXDmgInfo.HitBoxID == 2 )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_KillHead',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
		//<< wangkai, É±¶¯ÎïÏûÏ¢
		else if ( KFXPawn(Other.Pawn).bSpecialRoleState )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_KillAnimal',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
		}
		else
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_Normal',
				KFXPawn(Other.Pawn).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
	}
}

// ÒÔºó×öÍ³¼ÆÓÃ
function GameEvent(string GEvent, string Desc, PlayerReplicationInfo Who)
{
	local KFXPlayerReplicationInfo TPRI;

	if ( GameStats != None )
	{
		GameStats.GameEvent(GEvent, Desc, Who);
	}

	TPRI = KFXPlayerReplicationInfo(Who);

	if ( TPRI == None )
	{
		return;
	}
	// ÏÂÃæÀûÓÃKFXPlayerReplicationInfo×öÒ»Ð©Í³¼Æ
	// **ÔÝÊ±Ã»ÓÐ
}

// ÉËº¦µÄºóÐø´¦Àí**ÖØÒªº¯Êý£ºÊµÏÖÎÞµÐÄ£Ê½µÈµÈ
function float ReduceDamage( float Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	return super.ReduceDamage(Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

// ÅÐ¶¨Ä³¸öitemÊÇ·ñ¿ÉÒÔ±»ÄÃÆð
function bool PickupQuery(Pawn Other, Pickup item)
{
	return super.PickupQuery(Other, item);
}

function AdjustWeapAttribute( KFXWeapBase weap );

// ¸Ä±ä¶ÓÎé
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	if ( !super.ChangeTeam(Other, N, bNewTeam) )
	{
		return false;
	}
	if (DVServer != none)
	{
		DVServer.DVChangeTeam(KFXPlayer(Other), N);
		KFXPlayer(Other).DVChangeTeam(DVServer.DVGetTeamChnMapping(N));
	}
	return true;
}

//·ÖÅä¶ÓÎé
function byte PickTeam(byte Current, Controller C)
{
	return super.PickTeam(Current, C);
}

// ÖØÆðÓÎÏ·
function RestartGame()
{
	// Ö÷Òªµ÷ÓÃÁËlevelµÄServerTravel

	super.RestartGame();
}

// ¼ì²âÓÎÏ·ÊÇ·ñ¿ÉÒÔ½áÊø
function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	return super.CheckEndGame(Winner, Reason);
}

// ½áÊøÓÎÏ·
function EndGame( PlayerReplicationInfo Winner, string Reason )
{
	// ÖÃÒ»¸ö±ê¼Ç£¬Ïú»ÙËùÓÐlogging
	KFXUpdateEndGameInfo();
	super.EndGame(Winner, Reason);
}
function UpdateGameResult(PlayerReplicationInfo Winner);

//²éÕÒÍæ¼Ò×îÓÅµÄ³öÉúµã
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
	return super.FindPlayerStart(Player, InTeam, incomingName);
}

// ³öÉúµãµÄ·ÖÊý¼ÓÈ¨
function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
	local PlayerStart P;
	local int Rate;

	P = PlayerStart(N);

	if ( P != None )
	{
		if ( P.bSinglePlayerStart )
		{
			if ( P.bEnabled )
			{
				Rate = 1000;
			}
			else
			{
				Rate = 20;
			}
		}
		else
		{
			Rate = 10;
		}
	}
	else
	{
		Rate = 0;
	}

	return Rate * FRand();
}

// ¼ì²âÓÎÏ·»ý·Ö**ÕâÀï»á´¥·¢EndGame
function CheckScore(PlayerReplicationInfo Scorer,optional  PlayerReplicationInfo Loser)
{
	super.CheckScore(Scorer,Loser);
}

// É±ÈË½±Àø**ÔÚÕâÀï»á´¥·¢Ò»´ÎCheckScore
function ScoreKill(Controller Killer, Controller Other)
{
	super.ScoreKill(Killer, Other);
}
function bool IsNearWin(KFXPlayerReplicationInfo PRI );
function ScoreDamage( float damage, Controller Killer, Controller Other ){}
function DestroyableActorKilled( Pawn EventInstigator, DestroyableActor Killed, class<DamageType> DamageType );

// ±È½ÏÁ½¸öÍæ¼ÒµÄÅÅÃû
// Èç¹ûlhsÅÅÃû±Èrhs¿¿Ç°£¬·µ»Øtrue£¬·ñÔò·µ»Øfalse
function bool RankCompareOp(PlayerReplicationInfo lhs, PlayerReplicationInfo rhs)
{
	local KFXPlayerReplicationInfo KP1;
	local KFXPlayerReplicationInfo KP2;

	if ( lhs == rhs )
		return false;

	KP1 = KFXPlayerReplicationInfo(lhs);
	KP2 = KFXPlayerReplicationInfo(rhs);

	if( KP1.fxContribution < KP2.fxContribution )
	{
		return false;
	}
	else if( KP1.fxContribution == KP2.fxContribution )
	{
		if( KP1.fxKills < KP2.fxKills )
		{
			return false;
		}
		if( KP1.fxKills == KP2.fxKills )
		{
			if ( KP1.fxDeaths > KP2.fxDeaths )
			{
				return false;
			}
		}
	}
	return true;
}

// »ñµÃÍæ¼ÒÅÅÃû
function int GetPlayerRank(KFXPlayer player)
{
	local int i, Rank;

	Rank = 1;

	for ( i = 0; i < GameReplicationInfo.PRIArray.Length; i++ )
	{
		if ( RankCompareOp(
			GameReplicationInfo.PRIArray[i], player.PlayerReplicationInfo) )
			Rank++;
	}

	return Rank;
}

// ¼ÆËã¾­ÑéÖµºÍ·ÖÊý
// ¼ÆËã¾­ÑéÖµºÍ·ÖÊý
// Hawk.Wang 2010-05-11 ÈÙÓþÖµ¼ÆËãÐÂ½á¹¹²âÊÔ,"Updata"Ç°ÃæµÄÄ³Ð¡ÅóÓÑ£¬Æ´Ð´´íÎó0.0¡¢
function UpdataExp( Controller Killer )
{
	local KFXPlayerReplicationInfo fxPRI;

	if( Killer == none || !Killer.bIsPlayer )
	{
		return;
	}

	fxPRI = KFXPlayerReplicationInfo( Killer.PlayerReplicationInfo );

	//¶à°æ±¾£º¡¾Ä£¿éÃèÊö¡¿ÒÀÀµÓÚÄ£Ê½µÄ²îÒìÐÔ»ù´¡ÈÙÓþÖµ¡£ÎÞÌõ¼þMerge
	KFXCalculatedBaseExp( Killer, fxPRI ); //HawkWang [2010-05-11]

//    //¶à°æ±¾£º¡¾Ä£¿éÃèÊö¡¿·òÆÞ¾­ÑéÖµ¼Ó³É
//    KFXCalculatedCoupleExp( fxPRI );
//
//    //¶à°æ±¾£º¡¾Ç°ÖÃÌõ¼þ¡¿£¨1£©KFXPropSystem £¨2£©Props.CSV £¨3£©PRI¼°Í¬²½×Ö¶Î
//    //¶à°æ±¾£º¡¾Ä£¿éÃèÊö¡¿Èç¹ûÐèÒªÈÙÓþ¿¨¹¦ÄÜ£¬ÔòMerge´ËÐÐ´úÂë
	KFXCalculatedPropBonusExp( fxPRI );    //Hawk.Wang [2010-05-10]

//    //¶à°æ±¾£º¡¾Ç°ÖÃÌõ¼þ¡¿£¨1£©PawnAvatar.csv £¨1£©PRI¶ÔÓ¦×Ö¶Î
//    //¶à°æ±¾£º¡¾Ä£¿éÃèÊö¡¿Èç¹ûÐèÒª·þ×°°ó¶¨¾­ÑéÖµ¹¦ÄÜ£¬ÔòmergeÕâÌõ´úÂë
//    KFXCalculatedSuitExp( Killer, fxPRI ); //Hawk.Wang [2010-05-05]·þ×°°ó¶¨¾­ÑéÖµÖØ¹¹
//
//    //¶à°æ±¾£º¡¾Ç°ÖÃÌõ¼þ¡¿£¨1£©KFXNetCafeFactor.csv£¨2£©PRI¶ÔÓ¦×Ö¶Î
//    //¶à°æ±¾£º¡¾Ä£¿éÃèÊö¡¿Èç¹ûÐèÒªÍø°ÉÈÙÓþÖµ¼Ó³É£¬ÔòMergeÕâÌõ´úÂë
//    KFXCalculatedNetBarExp( fxPRI );       //Hawk.Wang [2010-04-15]¼ÆËãÍø°ÉÈÙÓþÖµ¼Ó³É¡£
//
//    //¶à°æ±¾£º¡¾Ä£¿éÃèÊö¡¿¶à±¶¾­Ñé½±Àø»î¶¯×¨ÓÃ£¬ÎÞÌõ¼þMerge
	KFXCalculatedMultipleExp( fxPRI );     //Hawk.Wang [2010-05-10]& WangKai

	log("Playing Time is "$( level.TimeSeconds - fxPRI.fxLoginTime ));
}

//Hawk.Wang 2010-05-11
//¶à°æ±¾£º¡¾Merge¡¿£ºÐÂ½á¹¹²âÊÔ£¬½«¶ÀÁ¢¼ÆËã²¿·Öµ¥¶À×÷ÎªÒ»¸öÐéº¯Êý½øÐÐ¶àÌ¬¡£
function KFXCalculatedBaseExp( controller Killer, KFXPlayerReplicationInfo PRI );


//Hawk.Wang 2010-07-23
//¶à°æ±¾£º¡¾Merge¡¿£ºÅäÅ¼¾­ÑéÖµ½±Àø£¬¶þÆÚ»áÀ©Õ¹£¬ÕâÀïÒò¸Ï¹¤ÁÙÊ±Ð´ËÀ¡£
//Í¬Ê±¼ÆËãÇ×ÃÜ¶ÈµÈ¼¶£¬Ð´µ½ÕâÀïºÜºÏÊÊ¡£
//final function KFXCalculatedCoupleExp( KFXPlayerReplicationInfo PRI )

//HawkWang 2010-05-10
//¶à°æ±¾£º¡¾Merge¡¿ÈÙÓþ¿¨¹¦ÄÜµÄÊµÏÖ£¬È¥µô¾É°æµÄÍø°É½±ÀøºÍVIP¹¦ÄÜ¡£ÔÙ´ÎÍ³Ò»ÊµÏÖ
final function KFXCalculatedPropBonusExp(KFXPlayerReplicationInfo PRI)
{
	//¹Ò¼þÓ°ÏìµÄ¾­Ñé
	PRI.fxCurrExp = (1+PRI.nHonorPointEx) * PRI.fxCurrExp;
	log("fxCurrExp "$PRI.fxCurrExp$"nHonorPointEx"$PRI.nHonorPointEx);
}
//2010-05-05 Hawk.Wang Wanghao2@kingSoft.com
//¶à°æ±¾£º¡¾Merge¡¿·þ×°°ó¶¨¾­ÑéÖµµÄÊµÏÖ²¿·Ö£¬ÓÉÓÚ×ÓÀà¼ÆËã¹«Ê½Ò»ÖÂ£¬ÔÚ»ùÀàÊµÏÖ¡£
//final function KFXCalculatedSuitExp( controller Killer, KFXPlayerReplicationInfo PRI)

//HawkWang 2010-04-14
//¶à°æ±¾£º¡¾Merge¡¿Íø°É½±Àø¾­ÑéÖµµÄÊµÏÖ£¬»ùÀàÊµÏÖ¹²ÓÐ¹¦ÄÜ¡£
//final function KFXCalculatedNetBarExp(KFXPlayerReplicationInfo PRI)


//HawkWang 2010-05-10
//¶à°æ±¾£º¡¾Merge¡¿¶à±¶¾­ÑéÖµ½±Àøº¯ÊýÊµÏÖ.Õâ¸öº¯ÊýÒ»°ãÖ±½Ómerge£¬ÎÞÌØË×´ýÓö
final function KFXCalculatedMultipleExp(KFXPlayerReplicationInfo PRI)
{
	local float ActionExpRate;
	local int i;
	for(i=0; i< KFXAgent.MAX_ActionAdd_Num; i++)
	{
		if((PRI.ActionType[i] -1) == KFXAgent._Action_Class._EA_EXP)
		{
			ActionExpRate = PRI.ActionRate[i];
			break;
		}
	}

	if(KFXAgent != none)
	{
		PRI.fxExp_netbar = PRI.fxCurrExp * (PRI.exp_netbar_ex) * (1 + ActionExpRate);
		PRI.fxCurrExp = PRI.fxCurrExp * (1 + KFXAgent.Game.fExpFactor+PRI.exp_netbar_ex) * (1 + ActionExpRate);
	}
	log("KFXGameInfo------PlayerName "$PRI.PlayerName$" fxCurrExp "$PRI.fxCurrExp
						  $"fExpFactor:"$KFXAgent.Game.fExpFactor$" ActionExpRate: "$ActionExpRate);

}

//»ù´¡ÈÙÓþÖµ*ÓÎÏ·Ê±¼ä*ÓÎÏ·ÈËÊýÓ°ÏìÏµÊý
function float UpdateBasicExp(Controller aPlayer, int ModeID)
{
	local KFXCSVTable  CFG_PlayerExp;
	local float        fxBasicExpFactor;
	local float        fxGameTime;
	local float        fxGamePlayerNunFactor;
	local float        fxBasicExp;
	CFG_PlayerExp = class'KFXTools'.static.GetConfigTable(83);
	if ( !CFG_PlayerExp.SetCurrentRow(ModeID) )
	{
		log("KFXGameInfo------ModeID"$ModeID);
		return 0;
	}
	fxBasicExpFactor = CFG_PlayerExp.GetFloat("fxBasicExpFactor");
	fxGameTime = (Level.TimeSeconds - KFXPlayer(aPlayer).KFXPlayerLoginTime) / 60.0;
	fxGamePlayerNunFactor = KFXGetPlayerNumLimitCoeffi();
	fxBasicExp = fxBasicExpFactor * fxGameTime * fxGamePlayerNunFactor;

    log("fxBasicExpFactor-------fxBasicExpFactor :"$fxBasicExpFactor$"   fxGameTime: "$fxGameTime$"  fxGamePlayerNunFactor: "$fxGamePlayerNunFactor$"   fxBasicExp: "$fxBasicExp);

	return fxBasicExp;
}

//ÓÎÏ·ÈËÊýÓ°ÏìÏµÊý *£¨»÷É±Êý+£¨»÷É±Êý-ËÀÍöÊý£©/4£©* »÷É±ËÀÍöÏµÊý
function float UpdateKillExp(Controller aPlayer, int ModeID)
{
	 local KFXCSVTable  CFG_PlayerExp;
	 local float    DeadLimit;
	 local float    fxKillExp;
	 local float    fxModeExpFactor;
	 local float    fxGamePlayerNunFactor;
	 local float    fxKills,fxDeaths;
	 local float    fxKillsSubDeaths;

	 CFG_PlayerExp = class'KFXTools'.static.GetConfigTable(83);
	 if ( !CFG_PlayerExp.SetCurrentRow(ModeID) )
	 {
		 log("KFXGameInfo------ModeID"$ModeID);
		 return 0;
	 }
	 fxModeExpFactor            =       CFG_PlayerExp.GetFloat("fxModeExpFactor");
	 DeadLimit                  =       CFG_PlayerExp.GetFloat("DeadLimit");
	 fxGamePlayerNunFactor      =       KFXGetPlayerNumLimitCoeffi();
	 fxKills                    =       GetPLayerKills(aPlayer);
	 fxDeaths                   =       GetPLayerDeaths(aPlayer);
	 fxKillsSubDeaths           =       GetKillsSubDeaths(aPlayer);

	 fxKillsSubDeaths = Min(DeadLimit,Max(fxKillsSubDeaths,0));
	 fxKillExp = fxModeExpFactor * fxKillsSubDeaths * fxGamePlayerNunFactor;

	 log("fxKills: "$fxKills
		 $"fxDeaths: "$fxDeaths
		 $"fxModeExpFactor: "$fxModeExpFactor
		 $"fxKillsSubDeaths: "$fxKillsSubDeaths
		 $"fxGamePlayerNunFactor: "$fxGamePlayerNunFactor
		 $"fxKillExp: "$fxKillExp);

	 return fxKillExp;
}


//ÈÙÓþÌØÊâ½±Àø²¿·Ö
function float UpdateSpecialExp(Controller aPlayer, int ModeID)
{
	local KFXCSVTable  CFG_PlayerExp;
	local float fxHeadKillFactor,fxKnifeKillFactor,fxMultiKillFactor;
	local float HeadKillLimit,KnifeKillLimit,MultiKillLimit;
	local float HeadKillExp,KnifeKillExp,MultiKillExp;
	local float fxSpecialExp;
	local int   KnifeKillNum;
	local KFXPlayerReplicationInfo  fxPRI;

	CFG_PlayerExp = class'KFXTools'.static.GetConfigTable(83);
	if ( !CFG_PlayerExp.SetCurrentRow(ModeID) )
	{
		 log("KFXGameInfo------ModeID"$ModeID);
		 return 0;
	}

	fxPRI = KFXPlayerReplicationInfo(KFXPlayer(aPlayer).PlayerReplicationInfo);

	fxHeadKillFactor = CFG_PlayerExp.GetFloat("fxHeadKillFactor");
	fxKnifeKillFactor = CFG_PlayerExp.GetFloat("fxKnifeKillFactor");
	fxMultiKillFactor = CFG_PlayerExp.GetFloat("fxMultiKillFactor");

	HeadKillLimit = CFG_PlayerExp.GetFloat("HeadKillLimit");
	KnifeKillLimit = CFG_PlayerExp.GetFloat("KnifeKillLimit");
	MultiKillLimit = CFG_PlayerExp.GetFloat("MultiKillLimit");

	if(fxPRI.fxHeadKillNum * fxHeadKillFactor > HeadKillLimit)
	{
		 HeadKillExp =  HeadKillLimit;
	}
	else
	{
		 HeadKillExp = fxPRI.fxHeadKillNum * fxHeadKillFactor;
	}

	//if(fxPRI.fxDaggerKillNum * fxKnifeKillFactor > KnifeKillLimit)
	KnifeKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);//fxPRI.fxDaggerKillNum;
	if(KnifeKillNum * fxKnifeKillFactor > KnifeKillLimit)
	{
		 KnifeKillExp =  KnifeKillLimit;
	}
	else
	{
		 KnifeKillExp = KnifeKillNum * fxKnifeKillFactor;
	}

	if(KFXPlayer(aPlayer).MaxMultiKillLevel * fxMultiKillFactor > MultiKillLimit)
	{
		 MultiKillExp =  MultiKillLimit;
	}
	else
	{
		 MultiKillExp = KFXPlayer(aPlayer).MaxMultiKillLevel * fxMultiKillFactor;
	}

	fxSpecialExp = HeadKillExp + KnifeKillExp +  MultiKillExp;

	log("fxPRI.fxHeadKillNum: "$fxPRI.fxHeadKillNum
		$"KnifeKillNum:  "$KnifeKillNum
		$"MaxMultiKillLevel: "$KFXPlayer(aPlayer).MaxMultiKillLevel
		$"fxSpecialExp: "$fxSpecialExp);
//
//    log("fxHeadKillFactor"$fxHeadKillFactor);
//    log("fxKnifeKillFactor"$fxKnifeKillFactor);
//    log("fxMultiKillFactor"$fxMultiKillFactor);
//
//    log("HeadKillLimit"$HeadKillLimit);
//    log("KnifeKillLimit"$KnifeKillLimit);
//    log("MultiKillLimit"$MultiKillLimit);

	return fxSpecialExp;
}

///ÓÎÏ·ÈËÊýÓ°ÏìÏµÊý*ÓÎÏ·Ê±¼ä*Ê¤ÀûÈÙÓþÖµÐÞÕýÏµÊý
function float UpdateResultExp(Controller aPlayer, int ModeID)
{
	local KFXCSVTable  CFG_PlayerExp;
	local float     fxGameTime,fxGamePlayerNunFactor;
	local float     fxResultExpFactor;
	local float     fxResultExp;
	local KFXPlayerReplicationInfo fxPRI;

	if( aPlayer == none || !aPlayer.bIsPlayer )
	{
		return 0;
	}
	CFG_PlayerExp = class'KFXTools'.static.GetConfigTable(83);
	if ( !CFG_PlayerExp.SetCurrentRow(ModeID) )
	{
		 log("KFXGameInfo------ModeID"$ModeID);
		 return 0;
	}

	fxPRI = KFXPlayerReplicationInfo(KFXPlayer(aPlayer).PlayerReplicationInfo);
	fxGameTime = (Level.TimeSeconds - KFXPlayer(aPlayer).KFXPlayerLoginTime) / 60.0;
	fxGamePlayerNunFactor = KFXGetPlayerNumLimitCoeffi();

	if( KFXGameReplicationInfo(GameReplicationInfo).Winner != none && KFXTeamInfo(KFXGameReplicationInfo(GameReplicationInfo).Winner).TeamIndex == fxPRI.Team.TeamIndex )
	{
		fxResultExpFactor =  CFG_PlayerExp.GetFloat("fxWinExpFactor");
	}
	else
	{
		fxResultExpFactor =  CFG_PlayerExp.GetFloat("fxLoseExpFactor");
	}

	fxResultExp = fxGameTime * fxGamePlayerNunFactor * fxResultExpFactor;
    log("----fxResultExpFactor "$fxResultExpFactor$"  -fxGamePlayerNunFactor: "$fxGamePlayerNunFactor$" fxGameTime :"$fxGameTime$" fxResultExp: "$fxResultExp);


	return fxResultExp;
}
function int GetPLayerKills(Controller aPlayer)
{
	return KFXPlayerReplicationInfo(KFXPlayer(aPlayer).PlayerReplicationInfo).fxKills;
}
function int GetPLayerDeaths(Controller aPlayer)
{
	return KFXPlayerReplicationInfo(KFXPlayer(aPlayer).PlayerReplicationInfo).fxDeaths;
}
function int GetKillsSubDeaths(Controller aPlayer)
{
	local int fxKills,fxDeaths;
	fxKills  = GetPLayerKills(aPlayer);
	fxDeaths = GetPLayerDeaths(aPlayer);
	return fxKills + (fxKills - fxDeaths) / 4;
}
//µ±Íæ¼ÒµÄ»÷É±ÊýÎª0Ê±£¬ÎÞÂÛÍæ¼ÒÆäËûÊý¾ÝÎª¶àÉÙ£¬Íæ¼Ò»ñµÃµÄ×îÖÕÈÙÓþÖµÎª0¡££¨·ÀÖ¹Íæ¼Ò¹Ò»úË¢ÈÙÓþ£©
function CheckPlayerKills(Controller aPlayer)
{
	local KFXPlayerReplicationInfo PRI;
	PRI = KFXPlayerReplicationInfo(KFXPlayer(aPlayer).PlayerReplicationInfo);
    if(KFXPlayer(aPlayer).PlayerReplicationInfo != none)
	{
		if(PRI.fxKills <= 0 && PRI.fxKillBlood <= 0)
		{
			PRI.fxCurrExp = 0;
		}
	}
}


//¼ÆËãÕ½¶ÓÈüÊ¤ÀûºÍÊ§°ÜµÄµÃ·Ö
function UpdateBattleTeamWinAndLostPoint( Controller Player,PlayerReplicationInfo Winner );
//pickup¹¤³§Ëæ»úÉú²ú
function PickupFactoryRandSpawn();
//Ìî³äpickup¹¤³§Êý×é
function FindPickupFactory()
{
	local KFXPickupFactory A;
	foreach AllActors(class'KFXPickupFactory',A)
	{
		pickupfactory[A.PickupNum]=A;
	}
	;
}


function float KFXGetPlayerNumLimitCoeffi()
{
	local float PlayerNum;

	PlayerNum = GetNumPlayers();

	if( PlayerNum > 16 )
	{
		log("[KFXGameInfo] KFXGetPlayerNumLimitCoeffi PlayerNum is "$PlayerNum);
	}
	return sqrt(PlayerNum);
}
// ¼ÆËã¹±Ï×¶È
function UpdateContribution(PlayerReplicationInfo PlayerRP);
// ¼ÆËã»ñÈ¡µÄÓÎÏ·±Ò
// @Param: player -- »ñÈ¡ÓÎÏ·±ÒµÄÍæ¼Ò£» Flee --- ÊÇ·ñÊÇÖÐÍ¾ÍË³ö
function UpdateGameCash( KFXPlayer player, optional bool flee )
{
	// ÁÙÊ±±äÁ¿
	local int    FinalGameCash;           // ×îÖÕ½á¹û
	local KFXPlayerReplicationInfo PRI;

	PRI = KFXPlayerReplicationInfo(player.PlayerReplicationInfo);

	FinalGameCash = GetModeGameCash(Player);
	PRI.fxGameCash = FinalGameCash;

	PRI.fxGameCash_Netbar = PRI.fxGameCash * (PRI.silver_netbar_ex) ;
	PRI.fxGameCash = PRI.fxGameCash * (1 + RealmGameCashFactor+PRI.silver_netbar_ex) ;
	UpdateActionGameCash(PRI);

//    log("PRI.fxGameCash "$PRI.fxGameCash);
//    log("KFXGameInfo-----IsInState('MatchOver') "$IsInState('MatchOver'));
//    log("KFXGameInfo-----EndTime "$EndTime);
//    log("KFXGameInfo-----player.bLogOutInGame "$player.bLogOutInGame);

	//Èç¹ûÖÐÍ¾ÍË³öÈÙÓþÖµ¾­ÑéÖµÈ«²¿¹é0
	if((EndTime <= 0 && player.bLogOutInGame) && player.PlayerReplicationInfo.Team != none )
	{
		// Kevin Sun: ÖÐÍ¾ÍË³ö
		KFXPlayerReplicationInfo(player.PlayerReplicationInfo).fxCurrExp = 0;
		KFXPlayerReplicationInfo(player.PlayerReplicationInfo).fxGameCash = 0;
	}

	log("KFXGameInfo------PRI.fxGameCash: "$PRI.fxGameCash$" RealmGameCashFactor: "$RealmGameCashFactor);
}
//Ìí¼Ó»î¶¯Ó°ÏìÒø±ÒÖµ
function UpdateActionGameCash(KFXPlayerReplicationInfo PRI)
{
	local float ActionCashRate;
	local int i;
	for(i=0; i< KFXAgent.MAX_ActionAdd_Num; i++)
	{
		if((PRI.ActionType[i] -1) == KFXAgent._Action_Class._EA_GAME_COIN)
		{
			ActionCashRate = PRI.ActionRate[i];
			log("KFXGameInfo------ActionCashRate "$ActionCashRate);
			break;
		}
	}
	log("UpdateActionGameCash------ActionCashRate "$ActionCashRate);
	PRI.fxGameCash = PRI.fxGameCash * (1 + ActionCashRate);
}
function int GetModeGameCash(Controller player)
{
	local float  TotalPlayTime;       // ÓÎÏ·Ê±¼ä
	local float   fxGameCashRate;
	local int  FinalCash;
	local float  TeamMatchFactor;       //Õ½¶Ó±ÈÈüÒø±Ò¼Ó³É
	local KFXGameReplicationInfo GRI;
	local KFXPlayerReplicationInfo PRI;
	// »ñÈ¡ÅäÖÃÐÅÏ¢
	GRI = KFXGameReplicationInfo(GameReplicationInfo);
	PRI = KFXPlayerReplicationInfo(player.PlayerReplicationInfo);

	fxGameCashRate = GetGameCashRate(GRI.GameModeID);
	TeamMatchFactor = KFXPlayer(Player).fxDBPlayerInfo.FactionCashFactor;

	//É±ÈËÎª0£¬Ê²Ã´¶¼²»µÃ
//    if (PRI.fxKills == 0)
//    {
//        PRI.fxGameCash = 0;
//        FinalCash = 0;
//        return 0;
//    }
	TotalPlayTime = EndTime - KFXPlayer(player).KFXPlayerLoginTime;
	FinalCash = TotalPlayTime * fxGameCashRate;

	//¹Ò¼þÓ°ÏìµÄÓÎÏ·±Ò
	FinalCash = FinalCash * (1+KFXPlayerReplicationInfo(player.PlayerReplicationInfo).nSilverEx);
	log("[LABOR]------------silver ex:"$KFXPlayerReplicationInfo(player.PlayerReplicationInfo).nSilverEx
		@FinalCash);

	FinalCash += FinalCash * TeamMatchFactor;
	PRI.fxTeamMatchFactor = TeamMatchFactor;
	//---¼ÓÇ¿ÓÎÏ·±ÒÏÞÖÆ
	if ( FinalCash < 0 || FinalCash > 200000 )
		FinalCash = 0;

	log("GameCash------PRI.fxTeamMatchFactor "$PRI.fxTeamMatchFactor$
		" TeamMatchFactor: "$TeamMatchFactor$
		" TotalPlayTime: "$TotalPlayTime$
		" FinalCash: "$FinalCash$
		" fxGameCashRate: "$fxGameCashRate);

	return FinalCash;
}
function float GetGameCashRate(int ModeID)
{
   local KFXCSVTable  CFG_PlayerExp;
   local float fxGameCashRate;
   local float MapWeaponLimit;//¶ÓÎéÎäÆ÷ÏÞÖÆÓ°ÏìÒø±Ò,±ÈÈçµ¶Õ½£¬¾Ñ»÷Õ½»ñµÃÒø±ÒÏµÊýÊÇ²»Ò»ÑùµÄ
   CFG_PlayerExp = class'KFXTools'.static.GetConfigTable(83);

   if ( !CFG_PlayerExp.SetCurrentRow(ModeID) )
   {
		log("KFXGameInfo------ModeID"$ModeID);
		return 0;
   }
   fxGameCashRate = CFG_PlayerExp.GetFloat("fxGameCashRate");
   MapWeaponLimit = CFG_PlayerExp.GetFloat("MapWeaponLimit"$KFXAgent.Game.nWeapLimit);
   fxGameCashRate *= MapWeaponLimit;
   log("KFXGameInfo-------ModeID: "$ModeID
				   $" nWeapLimit: "$KFXAgent.Game.nWeapLimit
			   $" MapWeaponLimit: "$MapWeaponLimit
			   $" fxGameCashRate: "$fxGameCashRate);

   return fxGameCashRate;

}
function float UpdateGamePoint( KFXPlayer player, optional bool flee )
{
	local float HonorPointRate;// ¿ØÖÆÈÙÓþÖµÔÚ»ý·ÖÖÐËùÕ¼µÄ±ÈÀý
	local float GameTimeRate;  // ¿ØÖÆÓÎÏ·Ê±¼äÔÚ»ý·ÖÖÐËùÕ¼µÄ±ÈÖØ
	local int   TotleExperience;//¾­ÑéÖµ
	local float TotalPlayTime;  //×ÜÓÎÏ·Ê±¼ä
	local float PointGainSpeed; //»ý·Ö»ñÈ¡ËÙÂÊ
	local float sPoint;
	local float ActionSpointRate;
	local int   i;
	local KFXPlayerReplicationInfo PRI;
	if ( KFXAgent != none )
	{
		HonorPointRate = KFXAgent.Game.fHonorPointRate;
		GameTimeRate = KFXAgent.Game.fGameTimeRate;
		PointGainSpeed = FMax( player.fxDBPlayerInfo.fSPointGainSpeed, KFXAgent.Game.fSPointFactor );
		TotleExperience = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).StaticEXPWithNoAdditional;
		TotalPlayTime = (Level.TimeSeconds - player.KFXPlayerLoginTime) / 60.0;
		PRI = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo);
		for(i=0; i< KFXAgent.MAX_ActionAdd_Num; i++)
		{
			if((PRI.ActionType[i] -1) == KFXAgent._Action_Class._EA_POINT)
			{
				ActionSpointRate = PRI.ActionRate[i];
				log("KFXGameInfo------ActionSpointRate "$ActionSpointRate);
				break;
			}
		}
		log("UpdateGamePoint------ActionSpointRate "$ActionSpointRate);
		sPoint = (TotleExperience*HonorPointRate +
					KFXGetPlayerNumLimitCoeffi()*TotalPlayTime*GameTimeRate)*PointGainSpeed * (1 + ActionSpointRate);

		// ¼ÆËã·þ×°ÊôÐÔÓ°Ïì
		sPoint *= player.KFXGetSuitPointRate();

		log("[KFXGameInfo] TotleExperience:"$TotleExperience
				$"TotalPlayTime:"$TotalPlayTime
				$"PointGainSpeed"$PointGainSpeed
				$"HonorPointRate"$HonorPointRate
				$"GameTimeRate:"$GameTimeRate);

		return sPoint;
	}
}
function float UpdatePawnSpeed(KFXPlayerReplicationInfo PRI)
{
	local float ActionSpeedRate;
	local int   i;

	for(i=0; i< KFXAgent.MAX_ActionAdd_Num; i++)
	{
		if((PRI.ActionType[i] -1) == KFXAgent._Action_Class._EA_MOVE)
		{
			ActionSpeedRate = PRI.ActionRate[i];
			log("KFXGameInfo------ActionSpeedRate "$ActionSpeedRate);
			break;
		}
	}
	log("KFXGameInfo------ActionSpeedRate "$ActionSpeedRate);
	return ActionSpeedRate;

}
// »ØÐ´Êý¾Ý
function RefalshData(Controller P, optional bool bflee)
{
	local KFXPlayer fxPlayer;
	local KFXPlayerReplicationInfo fxPRI;
	local int i,j;
	local bool Found;

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø »úÆ÷ÈË²»ÐèÒª»ØÐ´Êý¾Ý
	if( KFXBot(P) != none || KFXMonster(P) != none)
		return;
	//>>
	fxPlayer = KFXPlayer(P);
	fxPRI = KFXPlayerReplicationInfo(fxPlayer.PlayerReplicationInfo);
	log("[LABOR]---------refresh date, playerid="$fxPRI.fxPlayerDBID@fxPRI.PlayerName);
	// TODO: ÔÚÕâÀï¼ÆËãÊ±»úÊÇ·ñÌ«Íí£¬ÔÚÓÎÏ·½áÊø×Ô¼ºÊÇ·ñ»¹ÄÜ¹»¿´µ½»ñµÃµÄÓÎÏ·±Ò?
	UpdateGameCash(fxPlayer,bflee);

	if( fxPlayer != none && fxPRI != none )
	{
		// Kevin Sun: ²»Ê¹ÓÃ+=,ÖÐÍ¾ÍË³ö²»¸øÈÙÓþ
		if( NeedCalcKDValue )
		{
			fxPlayer.fxDBPlayerInfo.nKillCount = fxPRI.fxKills;
			fxPlayer.fxDBPlayerInfo.nDeathCount = fxPRI.fxDeaths;
		}
		else
		{
			fxPlayer.fxDBPlayerInfo.nKillCount = 0;
			fxPlayer.fxDBPlayerInfo.nDeathCount = 0;
		}

		for( i = 0; i< fxPlayer.fxDBPlayerInfo.MissionBlock.Missions.Length; i++ )
		{
			Found = false;
			for( j = 0; j<fxPlayer.ServerOutTaskArray.Length; j++ )
			{
				if ( fxPlayer.fxDBPlayerInfo.MissionBlock.Missions[i].MissionID == fxPlayer.ServerOutTaskArray[j] )
				{
					Found = true;
					break;
				}
			}
			if ( !Found )
			{
				fxPlayer.fxDBPlayerInfo.MissionBlock.Missions.Remove(i,1);
				i--;
			}
		}

		fxPlayer.fxDBPlayerInfo.nHeadKillCount = fxPRI.fxHeadKillNum;
		fxPlayer.fxDBPlayerInfo.nKnifeKillCount = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);
		fxPlayer.fxDBPlayerInfo.nSpeicalKillCount = fxPRI.fxSpecKillNum;
		fxPlayer.fxDBPlayerInfo.nExperience = fxPRI.fxCurrExp + fxPRI.fxExtraExp;

		//¼ÓÇ¿ÓÎÏ·±ÒµÄÏÞÖÆ
		if(fxPRI.fxGameCash<0||fxPRI.fxGameCash>200000)
			fxPRI.fxGameCash = 0;

		fxPlayer.fxDBPlayerInfo.nGameCash = fxPRI.fxGameCash;
		fxPlayer.fxDBPlayerInfo.nSPoint = UpdateGamePoint( fxPlayer,bflee );   //¸üÐÂ»ý·Ö

		if ( bflee )
			fxPlayer.fxDBPlayerInfo.nGameResult = 0; // KFX_FLEE
		else
			fxPlayer.fxDBPlayerInfo.nGameResult = fxPRI.fxGameResult;

		fxPlayer.fxDBPlayerInfo.uWinFactionID = fxPRI.fxWinnerTeamID;
		fxPlayer.fxDBPlayerInfo.uWinSpoint = fxPRI.fxWinSpoint;
		fxPlayer.fxDBPlayerInfo.uLostSpoint = fxPri.fxLostSpoint;
		log("[KFXGameinfo] uWinFactionID "$fxPlayer.fxDBPlayerInfo.uWinFactionID$
						   "uWinSpoint:"$fxPlayer.fxDBPlayerInfo.uWinSpoint$
						   "uLostSpoint:"$fxPlayer.fxDBPlayerInfo.uLostSpoint$
							"nKnifeKillCount:"$fxPlayer.fxDBPlayerInfo.nKnifeKillCount);

		SetupPlayerBaseData( fxPlayer, fxPRI, bflee );
		log("fxPlayer.fxDBPlayerBaseData.DeathCount "$fxPlayer.fxDBPlayerBaseData.DeathCount);
		KFXUpatePlayerBaseInfo(fxPlayer);
		// Êý¾Ý×îºó¿½±´µ½Êý¾Ý³Ø
		KFXUpdatePlayerInfo(fxPlayer);

		KFXUpdatePlayerExpInfo(fxPlayer.fxDBPlayerInfo, fxPlayer.fxDBPlayerExpInfo);
		// ½«Êý¾Ý»ØË¢µ½Realm
		if ( bflee )
			KFXPlayerFlee( fxPlayer.fxDBPlayerInfo.SessionID );
	}
	//fxPlayer.ClientTravel("Entry", TRAVEL_Absolute, false
}
function AfterRefreshData(KFXPlayer fxPlayer)
{
	fxPlayer.ClientTravel("Entry", TRAVEL_Absolute, false);
}

function SetupPlayerBaseData(KFXPlayer P,KFXPlayerReplicationInfo fxPRI , optional bool bflee)
{
	local array<int> WeapDurIndex;
	local int i,j;
	P.fxDBPlayerBaseData.SessionID                  = P.fxDBPlayerInfo.SessionID;
	P.fxDBPlayerBaseData.CommRifleKillCount         = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,1);//fxPRI.fxCommRifleKillCount;
	P.fxDBPlayerBaseData.AssaultKillCount           = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,2);//fxPRI.fxAssaultKillCount;
	P.fxDBPlayerBaseData.SniperKillCount            = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,3);//fxPRI.fxSniperKillCount;
	P.fxDBPlayerBaseData.ScatterKillCount           = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,10);//fxPRI.fxScatterKillCount;
	P.fxDBPlayerBaseData.MachinegunKillCount        = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,4);//fxPRI.fxMachinegunKillCount;
	P.fxDBPlayerBaseData.PistolKillCount            = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,8);//fxPRI.fxPistolKillCount;
	P.fxDBPlayerBaseData.GrenadeKillCount           = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);//fxPRI.fxGrenadeKillCount;
	P.fxDBPlayerBaseData.FirstBooldCount            = fxPRI.fxFirstBooldCount;
	P.fxDBPlayerBaseData.DoubleKillCount            = fxPRI.fxDoubleKillCount;
	P.fxDBPlayerBaseData.ThreeKillCount             = fxPRI.fxThreeKillCount;
	P.fxDBPlayerBaseData.FiveKillCount              = fxPRI.fxFiveKillCount;
	P.fxDBPlayerBaseData.HeadKillCount              = fxPRI.fxHeadKillNum;;
	P.fxDBPlayerBaseData.KnifeKillCount             = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);//fxPRI.fxDaggerKillNum;
	P.fxDBPlayerBaseData.KillCount                  = fxPRI.fxKills;
	P.fxDBPlayerBaseData.DeathCount                 = fxPRI.fxDeaths;
	P.fxDBPlayerBaseData.KillGhostCount             = fxPRI.fxKillSpecialTeam;
	P.fxDBPlayerBaseData.KillBotCount               = fxPRI.fxKillBots;
	P.fxDBPlayerBaseData.ChamPoinCount              = fxPRI.fxChamPoinCount;
	P.fxDBPlayerBaseData.GameResult                 = fxPRI.fxGameResult;
	P.fxDBPlayerBaseData.Experience                 = fxPRI.fxCurrExp + fxPRI.fxExtraExp;;
	P.fxDBPlayerBaseData.GameCash                   = fxPRI.fxGameCash;;
	P.fxDBPlayerBaseData.SPoint                     = UpdateGamePoint( P,bflee );   //¸üÐÂ»ý·Ö;
	P.fxDBPlayerBaseData.RewardTime                 = KFXGameReplicationInfo(Level.GRI).TotalGameTime;
	P.fxDBPlayerBaseData.RewardBossCnt              = fxPRI.fxKills;
	P.fxDBPlayerBaseData.KillMeMost                 = fxPRI.GetWhoKilledMeMost();
	for(i=0; i<MAXDropItemNum; i++)
	{
		P.fxPlayerExtraData.GainItem[i]            = fxPRI.LastDropItem[i];
		log("KFXGameInfo------P.fxPlayerExtraData.GainItem[i] :"$P.fxPlayerExtraData.GainItem[i]);
	}
	P.fxPlayerExtraData.SessionID                   = P.fxDBPlayerInfo.SessionID;
	P.fxPlayerExtraData.PlayerContribution          = fxPRI.fxPlayerContribution;
	P.fxPlayerExtraData.GhostKillCount              = fxPRI.fxKillsInGhostState;
	P.fxPlayerExtraData.CorpseKillCount             = fxPRI.fxKillsInCorpseState;

	P.fxPVEPlayerData.SessionID                         = P.fxDBPlayerInfo.SessionID;
	P.fxPVEPlayerData.PerGuanScore                      = fxPRI.GuanScore;
	P.fxPVEPlayerData.TotalGuanScore                    = P.fxPVEPlayerData.TotalGuanScore + P.fxPVEPlayerData.PerGuanScore ;
	P.fxPVEPlayerData.PerGuanTime                       = EndTime - KFXGameStartTime ;;
	P.fxPVEPlayerData.TotalGuanTime                     = P.fxPVEPlayerData.TotalGuanTime + P.fxPVEPlayerData.PerGuanTime ;
	P.fxPVEPlayerData.PVELevel                          = fxPRI.PVELevel;
	P.fxPVEPlayerData.PVELevelExp                       = fxPRI.PVEexp;
    P.fxPVEPlayerData.PVECurDropItemNum                 = fxPRI.CurDropItemNum;

	log("[LABOR]------------kill me most:name="$fxPRI.PlayerName@fxPRI.fxPlayerDBID@P.fxDBPlayerBaseData.KillMeMost);
	log("KnifeKillCount:"$P.fxDBPlayerBaseData.KnifeKillCount);
	log("GrenadeKillCount:"$P.fxDBPlayerBaseData.GrenadeKillCount
		$"fxPlayerContribution: "$fxPRI.fxPlayerContribution
		$"fxKillsInGhostState :"$fxPRI.fxKillsInGhostState
		$"fxKillsInCorpseState :"$fxPRI.fxKillsInCorpseState
		$"MachinegunKillCount  :"$P.fxDBPlayerBaseData.MachinegunKillCount
		$"PerGuanScore  :"$P.fxPVEPlayerData.PerGuanScore
		$"TotalGuanScore  :"$P.fxPVEPlayerData.TotalGuanScore
		$"PerGuanTime  :"$P.fxPVEPlayerData.PerGuanTime
		$"TotalGuanTime  :"$P.fxPVEPlayerData.TotalGuanTime
		$"PVELevel  :"$P.fxPVEPlayerData.PVELevel
		$"PVELevelExp  :"$P.fxPVEPlayerData.PVELevelExp
		$"EndTime  :"$EndTime
        $"CurDropItemNum  :"$fxPRI.CurDropItemNum);//
		//$"KFXGameStartTime  :"$KFXGameStartTime);
	//½áËãÍË³öÇ°Ê¹ÓÃµÄÎäÆ÷µÄÄÍ¾ÃÏûºÄ
	P.WeapDurConsumeEnd();
	//°ÑËùÓÐ¼ÇÂ¼µÄÎäÆ÷ÄÍ¾ÃÏûºÄÖÐÇ°10Ãû¿½±´µ½fxDBPlayerBaseData£¬ÒÔ±ãºóÐø¿½±´¸øFaery
	for(i=0; i < P.WeapDurConsumes.Length; i++ )
	{
		for(j=0; j < 10 && j < WeapDurIndex.Length; j++)
		{
			if( P.WeapDurConsumes[i].DurConsume > P.WeapDurConsumes[WeapDurIndex[j]].DurConsume )
			{
				WeapDurIndex.Insert(j,1);
				log("Insert WeapDurIndex "$WeapDurIndex[j]);
				WeapDurIndex[j]=i;
				break;
			}
		}
		if(j == WeapDurIndex.Length)
		{
			WeapDurIndex[j]=i;
			log("Push back WeapDurIndex "$WeapDurIndex[j]);
		}

	}
	for(i=0; i< 10 && i< WeapDurIndex.Length ; i++)
	{
		//ÖÐÍ¾ÍË³ö£¬ÄÍ¾Ã¶ÈÏûºÄ³ËÒÔÒ»¸öÏµÊý
		if(bflee)
		{
			P.fxDBPlayerBaseData.DurableItemList[i].ItemType =
				P.WeapDurConsumes[i].ConsumeWeapId;
			P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable =
				P.WeapDurConsumes[i].Durable - P.WeapDurConsumes[i].DurConsume*KFXGameReplicationInfo(GameReplicationInfo).fxDurableFactor;
			log("bFlee Remove durable "$P.WeapDurConsumes[i].Durable$" - "$P.WeapDurConsumes[i].DurConsume);
			if( P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable < 0 )
			{
				P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable = 0;
			}
			//P.fxDBPlayerBaseData.DurableItemList[i].ItemEquiped =
		}
		else
		{
			P.fxDBPlayerBaseData.DurableItemList[i].ItemType = P.WeapDurConsumes[i].ConsumeWeapId;
			P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable = P.WeapDurConsumes[i].Durable - P.WeapDurConsumes[i].DurConsume;
			log("Remove durable "$P.WeapDurConsumes[i].Durable$" - "$P.WeapDurConsumes[i].DurConsume);
			if( P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable < 0 )
			{
				P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable = 0;
			}
			//P.fxDBPlayerBaseData.DurableItemList[i].ItemEquiped =
		}
		log("DurableConsume ItemType "$P.WeapDurConsumes[i].ConsumeWeapId$" DurableConsume Durable "$P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable);
	}
	//°ÑÃ»ÓÐÄÍ¾Ã¶ÈÏûºÄµÄ£¬itemtypeÎª0
	for( i=i;i < 10; i++)
	{
		P.fxDBPlayerBaseData.DurableItemList[i].ItemType = 0;
		P.fxDBPlayerBaseData.DurableItemList[i].ItemDurable = 0;
	}

}

function KFXUpdateEndGameInfo()
{
	  KFXAgent.KFXFactionEndGameInfo[0].m_uiTeamType = 0;
	  KFXAgent.KFXFactionEndGameInfo[0].m_uiGameResult = 1;
	  KFXAgent.KFXFactionEndGameInfo[0].m_iCurPointAdd = 0;
	  KFXAgent.KFXFactionEndGameInfo[0].m_iGameTicketAdd = 0;
	  KFXAgent.KFXFactionEndGameInfo[0].m_iMmrAdd = 0;

	  KFXAgent.KFXFactionEndGameInfo[1].m_uiTeamType = 1;
	  KFXAgent.KFXFactionEndGameInfo[1].m_uiGameResult = 1;
	  KFXAgent.KFXFactionEndGameInfo[1].m_iCurPointAdd = 0;
	  KFXAgent.KFXFactionEndGameInfo[1].m_iGameTicketAdd = 0;
	  KFXAgent.KFXFactionEndGameInfo[1].m_iMmrAdd = 0;
}
// Íæ¼ÒÖÐÍ¾ÍË³ö
function KFXPlayerFlee(int Session)
{
	if ( KFXAgent != none )
		KFXAgent.KFXPlayerLeave(Session);
}

// ÊÇ·ñ¿ÉÒÔ¹Û²ì
function bool CanSpectate( PlayerController Viewer, bool bOnlySpectator, actor ViewTarget )
{
	local PlayerController P;

	P = PlayerController(ViewTarget);

	if(KFXBot(ViewTarget) != none && KFXBot(ViewTarget).pawn != none)
	{
		return true;
	}

	if( Viewer == none || P == none )
	{
		return false;
	}

	if ( Viewer == P )
		return false;

	if ( Viewer.PlayerReplicationInfo.Team == none && !KFXPlayerReplicationInfo(Viewer.PlayerReplicationInfo).bSpectatorView)
	{
		log("[CanSpectate] ViewerTeam==none! PlayerName:"$Viewer.PlayerReplicationInfo.PlayerName);
		return false;
	}

	if ( P.PlayerReplicationInfo.Team == none )
	{
		log("[CanSpectate] TargetTeam==none! PlayerName:"$P.PlayerReplicationInfo.PlayerName);
		return false;
	}

	//ÎÞPawnµÄController²»ÄÜ¹Û²ì
	if(P.Pawn==none)
	{
		return false;
	}

	//Èç¹û¹Û²ìcontrollerµÄ¹Û²ì¶ÔÏóÎªnoneÔò·µ»Øfalse
	if(Pawn(P.ViewTarget)==none)
	{
		return false;
	}

	//¹Û²ìÕßÄ£Ê½
	if(KFXPlayerReplicationInfo(Viewer.PlayerReplicationInfo).bSpectatorView)
	{
		log("\\\\\\\\KFXGameInfo CanSpectate  can see");
		return true;
	}

	return true;
}

//-----------------------------------------------------------


function KFXBot SpawnKFXBot(optional string botName, optional bool Leader)
{
	local KFXBot NewBot;

	if (PawnClass == None)
	{
		if( PawnClassName != "" )
		{
			PawnClass = class<KFXPawn>(DynamicLoadObject(PawnClassName, class'class'));
		}
	}

	NewBot = KFXBot(Spawn(PawnClass.default.ControllerClass));

	if ( NewBot != None )
		InitializeKFXBot(NewBot, botName, Leader);
	return NewBot;
}

/* Initialize bot
*/
function InitializeKFXBot(KFXBot NewBot, optional string botName, optional bool Leader)
{

	NewBot.PlayerReplicationInfo.Team = none;
	ChangeBotName(NewBot, botName, Leader);
	ChangeTeam(NewBot, 1, false);
}

//
//ÐÞ¸ÄbotÃû³Æ
//
function ChangeBotName(KFXBot NewBot, optional string botName, optional bool Leader)
{
}

function Pawn GetBotPawn()
{
	local Controller c, nextC;

	c = Level.ControllerList;
	;
	while (c != None)
	{
		nextC = c.NextController;
		if ( KFXBot(c) != none )
		{
			;
			return c.Pawn;
		}
		else
		{
			;
		}
		c = nextC;
	}

	return none;
}

function KFXBot GetBot()
{
	local Controller c, nextC;

	c = Level.ControllerList;
	;
	while (c != None)
	{
		nextC = c.NextController;
		if ( KFXBot(c) != none )
		{
			;
			return KFXBot(c);
		}
		else
		{
			;
		}
		c = nextC;
	}

	return none;
}
//>>

function bool KFXCanConsumeWeapDurable()
{
	return true;
}

function SendEnemyMsgs(int PlayerID, byte TeamID, byte SoundType, byte AreaID)
{
	local KFXPlayer pc;
	for(pc = KFXPlayer(Level.ControllerList); pc != none; pc = KFXPlayer(pc.nextController))
	{
		if(pc.PlayerReplicationInfo.Team.TeamIndex == TeamID
			&& KFXPlayerReplicationInfo(pc.PlayerReplicationInfo).fxPlayerDBID != PlayerID)
		{
			pc.ClientGainEnemyMsgs(PlayerID, SoundType, AreaID);
		}
	}
}
function NotifyObjectiveDestroy(Pawn Instigator, Actor Killed)
{
   log("KFXGameInfo-------GameRulesModifiers "$GameRulesModifiers);
   if ((GameRulesModifiers != None))
   {
	   GameRulesModifiers.NotifyObjectiveDestroy(Instigator,Killed);
   }
}
function  AddRestartPlayer(KFXPlayer P);
//-----------------------------------------------------------
// Ä¬ÈÏÊôÐÔ
//-----------------------------------------------------------
//-----------------------------------------------------------

defaultproperties
{
     nGameState=-1
     RealmGameCashFactor=1.000000
     PawnClassName="KFXGame.KFXPawn"
     SquadClass=Class'KFXGame.KFXSquadAI'
     NeedCalcKDValue=是
     KFXMGAllowLostCollision=是
     NeedRestartByTeam=是
     NeedCalcDeathCount=是
     DmgFactorModifier=1.000000
     RoleGUID=-1
     nRestartLoop=10
     bAllowBehindView=是
     bAllowVehicles=是
     ScoreBoardType="KFXGame.KFXScoreBoard"
     HUDType="KFXGame.KFXHUD"
     MaxPlayers=16
     DefaultPlayerName="KFXPlayer"
     BroadcastHandlerClass="KFXGame.KFXBroadcastHandler"
     PlayerControllerClassName="KFXGame.KFXPlayer"
     GameName="Fox Game"
}
