//-----------------------------------------------------------
//set:mat2_button01 image:button_02_focus
//-----------------------------------------------------------
class KFXFaeryAgent extends Info
    native;

// ��������
const KFX_MAJORWEAP_CNT = 30;       //����������
const KFX_BAGPROP_CNT = 30;
const KFX_GAIN_ITEM_COUNT = 20;      //�ֵ���������Ʒ����
const KFX_GAIN_ITEM_NUM = 5;
const KFX_CUR_ITEM_COUNT = 20;
const KFX_PLAYERITEMS_COUNT = 120;
// ������������
const WEAPON_CLS_COUNT = 15;
const WEAPON_PENDANT_CNT = 6;
const BODY_CNT = 2;
const BODY_PENDANT_CNT = 9;
const KFX_GRENADE_CNT = 3;
const MAX_DURABLE_CNT = 10;

const MAX_Netbar_Action = 4;
//��������
const MAX_ActionAdd_Num = 4;
enum  _Action_Class
{
    _EA_EXP ,  ///����
	_EA_GAME_COIN, ///���һ�ȡ
	_EA_POINT , ///���ֻ�ȡ
	_EA_MOVE , ///�ƶ��ٶ�
};
// ��Ϸ���
enum  KFX_GAME_RESULT
{
    KFX_FLEE,      // ���� ����;�˳���
	KFX_VICTORY,   // ʤ
	KFX_DEUCE,     // ƽ
	KFX_DEFEATED,  // ��
	KFX_NONE       // �޽��
};
enum EREALM_GS_COMMAND
{
    EREALM_COMMAND_NONE,       //��
    EREALM_COMMAND_ENDGAME,    //������Ϸ
};

//�����Ϣ
struct native FAgentItemData
{
    var int ItemType;
    var int ItemDurable;
    var int ItemEquiped;
};

struct native PlayerWeaponComponentsBlock
{
    var array<int> EquipedWeaponComponents;                       //�������
    var array<int> UnEquipedWeaponComponents;      //�������
};

struct native FactionEndGameInfo
{
	var int m_uiTeamType; // ���/��������
	var int m_uiGameResult; // �������
	var int m_iCurPointAdd;	// ��ǰ��������
	var int	m_iGameTicketAdd; // 电竞券增�
	var int m_iMmrAdd; //MMR(�羺����)����
};
struct native KFXEndGameInfo
{
    var int   nWinTeamIndex;
    var int   nGameResult;            //ʧ�ܱ�ʤ�����������Ȼ�ɱ��ֵ*100
    var int   nTotalRound;
};

//��ҵ�ǰװ�����ݽṹ
struct native CurEquipItemsListType
{
    var int SessionID;                             //sessionid
    var int MajorWeaponID;                         //��ǰ������
    var int MinorWeaponID;                         //��ǰ������
	var int MeleeWeaponID;                         //��ǰ�����
	var int Grenades[KFX_GRENADE_CNT];             //��
	var int Body[BODY_CNT];                        //��ɫ��װ
	var int BodyPendents[BODY_PENDANT_CNT];        //��ɫ��������ֱ��������Ƚ�
    var PlayerWeaponComponentsBlock PlayerWeaponComponents;
};

var array<CurEquipItemsListType> CurEquipItemsList;

struct native MissionData
{
    var int HighID;
    var int LowID;
    var int MissionID;
};
struct native PlayerMissionData
{
    var int PlayerIndex;
    var array<MissionData> Missions;
};

struct native BasePlayerDataBlock
{
    var int SessionID;                                 //��ɫID
    var int CommRifleKillCount;                     //���ǹ
    var int AssaultKillCount;                        //ͻ����ǹ
    var int SniperKillCount;                         //�ѻ�ǹ
    var int ScatterKillCount;                        //����ǹ
    var int MachinegunKillCount;                      //����ǹ
    var int PistolKillCount;                         //��ǹ
    var int GrenadeKillCount;                        //�׻�ɱ
    var int RemoveBombCount;                             //�����
    var int InstallBombCount;                               //�����
    var int FirstBooldCount;                         //���firstblood�Ĵ���
    var int DoubleKillCount;                         //˫��ɱ����
    var int ThreeKillCount;                          //����ɱ����
    var int FiveKillCount;                           //����ɱ�Ĵ���
    var int HeadKillCount;                           //��ͷ����
    var int KnifeKillCount;                          //��ɱ����
    var int KillCount;                          //��ɱ����
    var int DeathCount;                         //��������
    var int KillGhostCount;                          //ɱ��������
    var int KillBotCount;                            //ɱ��bot��
    var byte KillVipCount;                            //ɱ��Vip��
    var byte ChamPoinCount;                           //��õ�����Ϸ�ھ���
    var int GameResult;                         //��Ϸ���
    var int Experience;                         //��þ���ֵ
    var int GameCash;                           //�������ֵ
    var int SPoint;                             //��û���
    var FAgentItemData DurableItemList[MAX_DURABLE_CNT];    //�;���Ʒ

    var int RewardTime;                          //�ͽ�ģʽ����Ϸʱ��
    var int RewardBossCnt;                       //�ͽ�ģʽɱ������
    var int KillMeMost;						//ɱ�Լ������Ǹ���� Role ID
};
struct native PlayerDataBlockExtra
{
    var int SessionID;                                 //��ɫID
    var int PlayerContribution;
    var byte VIPEscapeTimes;                    //VIP���Ѵ���
    var byte ACEOrder;
    var int  GhostKillCount;                    //����ɱ����
    var int  CorpseKillCount;                   //��ʬɱ����
    var int  KillCorpseCount;                   //ɱ����ʬ��
    var int GainItem[KFX_GAIN_ITEM_COUNT];       //�����Ʒ
};
var Array<BasePlayerDataBlock>  BasePlayersData;
var Array<PlayerDataBlockExtra> PlayersDataExtra;

// �������
// Note: ���������ޣ��ٴ��װ�����ˣ������ü���
struct native KFXPlayerInfo
{
    var int PlayerID;          // PlayerΨһ��ʶ
    var int SessionID;         // Session ID
    var int RealmIP;           // �������Realm��IP
    var int RealmPort;         // �������Realm��Port
    var string PlayerName;     // Player name

    var int RoleID;            // ʹ�ý�ɫ���
    var byte TeamID;           // ������
    var byte nLevel;		   // ����ȼ�

    // װ����Ϣ
    var int nMajorWeaponID;                         //��ǰ������
    var int nMinorWeaponID;                         //��ǰ������
	var int nMeleeWeaponID;                         //��ǰ�����
	var int	nGrenades[KFX_GRENADE_CNT];             //��

    var byte nVipLevel;								// Vip����
    var byte nNetBarMode;							// ����ģʽ

    // ��ɫս����Ϣ
	var int	nKillCount;								// ɱ����
	var int	nDeathCount;							// ������

	var int	nHeadKillCount;							// ��ͷ����
	var int	nKnifeKillCount;						// ��ɱ����
	var int	nSpeicalKillCount;						// �����ɱ

	var byte nGameResult;							// ����,ʤ,��,ƽ,�޽�� (see: enum KFX_GAME_RESULT)

	// ��ɫ�ȼ���Ϣ
	var int	nExperience;							// ����
	var int nGameCash;                              // ��Ϸ��
	var int nDanceCardBit;				            //��λ����ʾ���迨����KFXItem.csv TypeIDLow����ʾ

    // �������
    var float   fSPointGainSpeed;                   // ���ֻ�ȡ����
    var int     nSPoint;                            // ע�⣺��ȡ���� GameServer->Realm����Ϸ��������Ϸ���������õ��Ļ��֣�����������������
    var int     nTotalSPoint;                       // ע�⣺�ܵĻ��� Realm->GameServer ����ת�����˶�Ա�ƺţ��ɴ���������������Ϸ������������ҵ�һ�����ݿ����ԣ�
    var int     nIndividualGrade;                   //��������
    var int     nTeamGrade;                         //�������֣�ս����ʱΪ�������֣���Ӣ��ʱΪС�Ӽ������֣�

    // Avatar��Ϣ
    var int AvatarBody;
    var int AvatarHead;
    var int AvatarLegs;

    var int Suit;              // ��װ

    // ս�����
    var int FactionID;          // ս��ID
    var int FactionIconID;      // ս��ͼ��ID
    var string FactionName;     // ս������
    var float FactionCashFactor;    //ս�Ӿ����Ҽӳ�
    //��Ա���
    var int     nIsMember;                          //�Ƿ��ǻ�Ա
    var int     RewardTime;     //���ͨ��ʱ��
    var int     RewardCount;    //���ɱ������

    //�۲���ģʽ��������Ϸ��ֱ���ǹ۲���
    var byte    nSpectatorView;               //�Ƿ�۲���

    var int     nGainItem[KFX_GAIN_ITEM_NUM];         //�ֵ���������ߵ���Ϣ
    var int     uWinFactionID;                          //ʤ����ս��id
    var int     uWinSpoint;				// ʤ��ս�ӵ÷�
    var int     uLostSpoint;				// ʧ��ս�ӵ÷�
    var PlayerMissionData MissionBlock;

	//���ɻ
	var int 	level_netbar;
	var float 	xp_netbar[MAX_Netbar_Action];

	var int    bWantToBeVIP;             //�Ƿ��뵱VIP
};
struct native KFXPlayerInfoEx
{
	var array<int>		mutate_roles;		//�ɱ���ľ�����Ľ�ɫ
};

struct native KFXPlayerWeaponsBakInfo   //����������Ϣ
{
    var int SessionID;         // Session ID
	var int	nMajorWeapons[KFX_MAJORWEAP_CNT];       //����������
};

struct native KFXBagPropsInfo
{
    var int SessionID;         // Session ID
    var int	nBagProps[KFX_BAGPROP_CNT];		        // ����
};

//<<������ ��װ��� 2009.1.21
struct native KFXPlayerExpInfo
{
    var int SessionID;         // Session ID
    //����ͺͼӳ�ϵ��
    var int     ActionType[MAX_ActionAdd_Num];
    var float   ActionRate[MAX_ActionAdd_Num];

//    // Avatar��Ϣ
//    var int AvatarBody;
//    var int AvatarHead;
//    var int AvatarLegs;
//
//    var int Suit;              // ��װ

    // ս�����
//    var int FactionID;          // ս��ID
//    var int FactionIconID;      // ս��ͼ��ID
//    var string FactionName;     // ս������
//    //��Ա���
//    var int     nIsMember;                          //�Ƿ��ǻ�Ա
//
//    var int     nGainItem[KFX_GAIN_ITEM_COUNT];         //�ֵ���������ߵ���Ϣ
//    var int     uWinFactionID;                          //ʤ����ս��id
//    var int     uWinSpoint;				// ʤ��ս�ӵ÷�
//    var int     uLostSpoint;				// ʧ��ս�ӵ÷�
};
//>>

// ��Ϸ����
// [nGameOptParam] ���壺
// 1. ľ����ģʽ��
//      ����һλ - ��ʬ�Ƿ��ж����˺�
struct native KFXGameData
{
    var const int  nMapID;        // ��ͼ���
	var const int  nGameMode;     // ��Ϸģʽ
	var const int  nTimeLimit;    // ʱ������
	var const int  nRounds;       // �غ�����
	var const int  nKillLimit;    // ɱ������
	var const int  nWeapLimit;	  // ������������
	var const int  nRestartTime;  // ����ʱ��
	var const int  nGameOptParam; // ��Ϸѡ�������ÿ��λ��ʶ��ͬ����Ϣ

    var const int   nNotCountKill;  ////��ɱ�Ƿ���� 0�����㡣1���㡣
	var const float fExpFactor;	  //���ض�ʱ�����Ƿ�������ֵ�����Ĺ���
	var const float fSPointFactor;//���ֻ�ȡ��Ӫ�ϵͳ
    var const float fGameCoinFactor;// ��Ϸ�һ�ȡ����
    var const float fHonorPointRate;// ��������ֵ�ڻ�������ռ�ı���
    var const float fGameTimeRate;  // ������Ϸʱ���ڻ�������ռ�ı���
    var const int   nGameType;     // ��������������

    var const int nBotModeConfig;// ��������ģʽ�������
//    var       int nTaskMapID;
	var const int nRealmCommand;     //����realm������
	var int nStartGuanNum;     //PVB ���Ĺؿ�ʼ
    var const int PVEDifficulty;     //PVE �Ѷ�1��ͨ0����
};
//by sunqiang
var bool bPVEGame;
var bool bHasOtherGuan;
struct native PVERandData
{
    var int nRulesID;
    var int nMapID;
};
var array<PVERandData> PVERandGame;
var int PVEStartGuan;
var int CurGuanIndex;
var bool bCanRestartGame;
const                G_MaxGuanNum = 54;
enum PVEGameState
{
    PVEState_Start,
    PVEState_Matching,
    PVEState_MatchOver,
};
//PVE Data
struct native KFXPVEPlayerData
{
    var int SessionID;
    var int InitialNormalRestartCoinsNum;
    var int InitialDeadRestartCoinsNum;
    var int UsedNormalRestartCoinsNum;
    var int UsedDeadRestartCoinsNum;
    var int UsedFreeRestartNum;
//    var int PerGuanExp;
//    var int TotalGuanExp;
//    var int PerGuanCash;
//    var int TotalGuanCash;
    var int PerGuanScore;
    var int TotalGuanScore;
    var int PerGuanTime;
    var int TotalGuanTime;
	var int PVELevel;
	var int PVELevelExp;
	var int PVECurDropItemNum;


};
var array<KFXPVEPlayerData> PVEPlayerData;
//PVE  end



var FactionEndGameInfo KFXFactionEndGameInfo[2];//ս����Ϣ
var KFXEndGameInfo        EndGameInfo;

// ��������б�
// Only RealLevel Valid
var array<KFXPlayerInfo> Players;
var array<KFXPlayerInfoEx> PlayersInfoEx;

//<<������ ��װ��� 2009.1.21
// ��������б���չ
var array<KFXPlayerExpInfo> PlayersExp;
//>>
//<<װ������������Ϣ���ó�����
var array<KFXPlayerWeaponsBakInfo> PlayerWeapons;
//<<װ�������ݰѿ�Ƭ��Ϣȡ��
var array<KFXBagPropsInfo> PlayerBagProps;

// ��Ϸ����
// PendingLevel & RealLevel Valid
var KFXGameData Game;

// ������Setup Game OK�� ���������������
// Only RealLevel Valid
native function KFXNotifyGameReady(int bPVEGame,int NextGuanID,int NextMapID);

// ��Ϸ����
native function KFXNotifyGameEnd();

// �����;�˳�
native function KFXNotifyPlayerLeave(int SessionID);

// ע��Agent
native function KFXRegist();

// ��ע��Agent
native function KFXUnRegist();

// ���KFXFaeryAgent
native static function KFXFaeryAgent KFXGetAgent();

// �Ƿ����Ӵ���������
native static function bool KFXIsKFXServerMode();

native function NotifyPlayerLogInGameServer( int SessionID );

/*
*/

native static function bool IsItemInEquipList(int SessionID, int itemID);
native static function int GetItemDurable(int SessionID, int itemID);

// ��Ϸ���й����н�������realm������
event KFXOnCommand( int Command )
{
    log("[KFXFaeryAgent]  KFXOnCommand"$Command);

    switch( EREALM_GS_COMMAND(Command) )
    {
        case EREALM_COMMAND_NONE:
            break;
        case EREALM_COMMAND_ENDGAME:
            Level.Game.EndGame(none,"ServerCommand");
            log("[KFXFaeryAgent] Game End Because of ServerCommand");
            break;
    }
}

event KFXKillRoleInGame( int RoleID )
{
    // �������realm�Ͽ����ӵ�ʱ�򣬴�ʱrealm��������Ƿ�����Ϸ��
    // ����������Ϸ�ڣ�������Э�����gs�ߺţ���������
    // ������û��ڵ��������Ϸ������ֱ�Ӳ�ͻ��˻�������Ϸ�����к�realm�Ͽ�����
     // �����ֱ��ֶ������������
     // << add by fangjianbin
	local Controller Player;
    local int PlayerNum;
	for (Player = Level.ControllerList; Player != none; Player = Player.nextController)
	{
		if (KFXPlayer(Player).fxDBPlayerInfo.PlayerID == RoleID)
		{
		    log("Destroy Controller for  Realm Aksed "$"Player Name Is :"$Player.PlayerReplicationInfo.PlayerName$"  Role ID Is: "$KFXPlayer(Player).fxDBPlayerInfo.PlayerID);
            KFXPlayer(Player).Destroy();
			DeleteOnePlayerDefault(RoleID);
            return;
		}
	}
	for (Player = Level.ControllerList; Player != none; Player = Player.nextController)
	{
        if(KFXPlayer(Player) != none)
        {
            PlayerNum++;
        }
    }
    log("Agent-----PlayerNum "$PlayerNum);
    if(PlayerNum == 0)
    {
        bCanRestartGame = false;
        default.bCanRestartGame = false;
        KFXEndGame();
    }
	log("[LABOR]-------------can't find role when kill role. roleID="$RoleiD);

}
event AddPlayerScoreInfo(int RoleID,array<int>ItemID)
{
    local Controller C;
    for(C=Level.ControllerList; C!=none; C=C.nextController)
    {
        if(KFXPlayer(C) != none)
        {
            if (KFXPlayer(C).fxDBPlayerInfo.PlayerID == RoleID)
            {
                KFXPlayer(C).AddPlayerScoreInfo(ItemID);
            }
        }
    }
}
event DeleteOnePlayerDefault(int RoleID)
{
    local int i;
    local int SessionID;
    for(i=0; i<default.Players.Length; i++)
    {
        if(default.Players[i].RoleID == RoleID)
        {
            SessionID = default.Players[i].SessionID;
            default.Players.Remove(i,1);
            break;
        }
    }
    log("Agent------RoleID :"$RoleID$"   SessionID :"$SessionID);
    for(i=0; i<default.PVEPlayerData.Length; i++)
    {
         if(default.PVEPlayerData[i].SessionID == SessionID)
         {
            default.PVEPlayerData.Remove(i,1);
            break;
         }
    }
    for(i=0; i<default.PlayersExp.Length; i++)
    {
         if(default.PlayersExp[i].SessionID == SessionID)
         {
            default.PlayersExp.Remove(i,1);
            break;
         }
    }
    for(i=0; i<default.PlayersDataExtra.Length; i++)
    {
         if(default.PlayersDataExtra[i].SessionID == SessionID)
         {
            default.PlayersDataExtra.Remove(i,1);
            break;
         }
    }
    for(i=0; i<default.BasePlayersData.Length; i++)
    {
         if(default.BasePlayersData[i].SessionID == SessionID)
         {
            default.BasePlayersData.Remove(i,1);
            break;
         }
    }
    for(i=0; i<default.PlayerWeapons.Length; i++)
    {
         if(default.PlayerWeapons[i].SessionID == SessionID)
         {
            default.PlayerWeapons.Remove(i,1);
            break;
         }
    }
    for(i=0; i<default.PlayerBagProps.Length; i++)
    {
         if(default.PlayerBagProps[i].SessionID == SessionID)
         {
            default.PlayerBagProps.Remove(i,1);
            break;
         }
    }
    for(i=0; i<default.CurEquipItemsList.Length; i++)
    {
         if(default.CurEquipItemsList[i].SessionID == SessionID)
         {
            default.CurEquipItemsList.Remove(i,1);
            break;
         }
    }
}
// ��ʼ��Ϸ
// Only PendingLevel Valid
event KFXStartGame()
{
    local string map;
    local string mode;
    local KFXCSVTable CSVMap, CSVMode, CSVGameInfo;
    local int GameModeConfig;
    local int MapID;
    local int nGameMode;
    GameModeConfig = 0;
    log("Agent-------Game.nGameMode "$Game.nGameMode);

    if(Game.nGameMode == 4 || Game.nGameMode == 5)          //4,5ΪPPVEģʽ
    {
       bPVEGame = true;
       default.bPVEGame = true;
    }
    log("Agent-------bPVEGame "$bPVEGame);

    if(default.bPVEGame)
    {
        log("Agent-------Game.nStartGuanNum "$Game.nStartGuanNum);

        KFXStartPVEGame();

        log("Agent-------KFXStartPVEGame ");
        return;
    }
    CSVMap  = class'KFXTools'.static.KFXCreateCSVTable("KFXMapInfo.csv");
    CSVMode = class'KFXTools'.static.KFXCreateCSVTable("KFXGameMode.csv");
    CSVGameInfo = class'KFXTools'.static.KFXCreateCSVTable("KFXGameInfo.csv");

    if ( CSVMap == none )
    {
        log("[KFXFaeryAgent] Error: Can't Open MapInfo Data!");
        Crash();
        return;
    }

    if ( CSVMode == none )
    {
        log("[KFXFaeryAgent] Error: Can't Open GameMode Data!");
        Crash();
        return;
    }
    if ( CSVGameInfo == none )
    {
        log("[KFXFaeryAgent] Error: Can't Open CSVGameInfo Data!");
        Crash();
        return;
    }
    CSVGameInfo.SetCurRowWithNewKey("ID",""$Game.nMapID);

    nGameMode = CSVGameInfo.GetInt("ModeID");
    log("KFXFaery-----org-nGameMode"$Game.nGameMode);
    log("KFXFaery-----org-Game.nMapID"$Game.nMapID);

    MapID = CSVGameInfo.GetInt("MapID");
    CSVGameInfo.ResetCurRowKey();

    if ( !CSVMap.SetCurrentRow(MapID) )
    {
        log("[KFXFaeryAgent] Error: Invalid MapID:"$Game.nMapID);
        Crash();
        return;
    }

    if ( !CSVMode.SetCurrentRow(Game.nGameMode) )
    {
        log("[KFXFaeryAgent] Error: Invalid Game Mode:"$Game.nGameMode);
        Crash();
        return;
    }

    map = CSVMap.GetString("MapName");
    GameModeConfig = CSVMap.GetInt("GameModeConfig");
    log("[KFXFaeryAgent]  GameModeConfig"$GameModeConfig);

    if( GameModeConfig == 1 )
        mode = CSVMode.GetString("GameMode2");
    else
    mode = CSVMode.GetString("GameMode");

    log("[KFXFaeryAgent]  mode"$mode);

    log("[KFXFaeryAgent] Notify Game Setup!");

    log("[KFXFaeryAgent] Mode="$ Game.nGameMode $ " Map="$ Game.nMapID );

    Level.ServerTravel(map$"?Game="$mode, false);
}
event int GetPVENextRules()
{
	return default.PVERandGame[0].nRulesID;
}

//��õ�ͼ���⿪ʼ
event string GetPVENextMap()
{
    local int MapID;
    local KFXCSVTable CSVMapInfo;
    local string MapString;

	MapID = default.PVERandGame[0].nMapID;
    log("KFXPVEGame---------default.CurGuanIndex "$default.CurGuanIndex);
//    if(default.CurGuanIndex % 2 == 0)
//    {
//         MapID = 101;
//    }
//    else
//    {
//         MapID = 103;
//    }
    log("KFXPVEGame---------MapID "$MapID);
    CSVMapInfo = class'KFXTools'.static.GetConfigTable(101);

    if ( !CSVMapInfo.SetCurrentRow(MapID) )
    {
        Log("Can't Resolve KFXMapInfo.csv MapID (Attr Table): "$MapID);
        return "";
    }
    MapString = CSVMapInfo.GetString("MapName");
    MapString $=".ut2";
    log("KFXPVEGame---------MapString "$MapString);
    return MapString;

}
event int GetPVENextMapID()
{
    local int MapID;

    MapID = default.PVERandGame[0].nMapID;
    log("GetPVENextMapID---------MapID "$MapID);
    return MapID;
}
// Only PendingLevel Valid
event KFXStartPVEGame()
{
	local string map;
	local string mode;
	local KFXCSVTable CSVMap, CSVMode, CSVGameInfo;
	local int GameModeConfig;
	local int MapID;
	local int nGameMode;
	local int temp;
	local int Start;
	Start = game.nStartGuanNum ;

	log("[KFXFaeryAgent]  Start "$Start);
    //ֻ��ʼ��һ��
    log("[KFXFaeryAgent]  default.PVERandGame.Length "$default.PVERandGame.Length);
	DeletePVERandDefault();
    if(default.PVERandGame.Length == 0)
    {
        default.PVEStartGuan = game.nStartGuanNum;
        log("[KFXFaeryAgent]  default.PVEStartGuan "$default.PVEStartGuan);
        class'PVEGameManager'.static.SetStartGuan(Start);
        class'PVEGameManager'.static.SetStartChapter(Start/27 + 1);
        class'PVEGameManager'.static.SetMaxGuanNum(G_MaxGuanNum);
        class'PVEGameManager'.static.InitAll();
	    SetPVEAllGuanInfo();                   //FaeryAgent ���ÿ����Ϣ
    }
	mode = "KFXPVEGame.KFXPVEGame";

    map = GetPVENextMap();
    log("[PVEGame KFXFaeryAgent]  mode "$mode);
    log("[PVEGame KFXFaeryAgent]  map "$map);

    log("[PVEGame KFXFaeryAgent] Notify Game Setup!");

	log("[PVEGame KFXFaeryAgent] Mode="$ Game.nGameMode $ " Map="$ map );

    Level.ServerTravel(map$"?Game="$mode, false);
	Level.ServerTravel(map$"?Game="$mode$"?GuanRoles="$GetPVENextRules(), false);
}
event DeletePVERandDefault()
{
    default.PVERandGame.Remove(0,default.PVERandGame.Length);
    class'PVEGameManager'.static.DeleteAll();
	default.CurGuanIndex = 0;
	default.PVEStartGuan = 0;

	default.bHasOtherGuan = false;
	default.bCanRestartGame = false;
	log("Agent------DeletePVERandDefault ");
}
event DeletePVEPlayerDefault()
{
	default.bPVEGame = false;
    default.PVEPlayerData.Remove(0,default.PVEPlayerData.Length);
	default.Players.Remove(0,default.Players.Length);
	default.PlayersExp.Remove(0,default.PlayersExp.Length);
	default.PlayersDataExtra.Remove(0,default.PlayersDataExtra.Length);
    default.BasePlayersData.Remove(0,default.BasePlayersData.Length);
	default.PlayerWeapons.Remove(0,default.PlayerWeapons.Length);
	default.PlayerBagProps.Remove(0,default.PlayerBagProps.Length);
	default.CurEquipItemsList.Remove(0,default.CurEquipItemsList.Length);
    log("Agent------DeletePVEPlayerDefault ");
}
event SetPlayerEquipedListItem(int PlayerIndex, int itemID)//����װ�����б�
{
    local int TypeID;
    local int loop;
    local KFXCSVTable KFXItemTable;
    TypeID = itemID >> 16;
    log("SetPlayerCurEquipListItem itemid"$itemID$"TypeID"$TypeID);

    KFXItemTable = class'KFXTools'.static.GetConfigTable(30);

    if ( TypeID <= 0 || itemID <= 0 )
        return;

    if ( TypeID <31 )//������
    {
        CurEquipItemsList[PlayerIndex].MajorWeaponID = itemID ;
        log("SetPlayerCurEquipListItem MajorWeapon itemid"$itemID$"TypeID"$TypeID);
    }
    else if (TypeID <41)//������
    {
        CurEquipItemsList[PlayerIndex].MinorWeaponID = itemID ;
    }
    else if ( TypeID < 51 )//�����
    {
        CurEquipItemsList[PlayerIndex].MeleeWeaponID = itemID ;
    }
    else if (TypeID < 61)//Ͷ��������
    {
         for( loop = 0; loop<KFX_GRENADE_CNT; loop++ )
         {
            if ( CurEquipItemsList[PlayerIndex].Grenades[loop] == 0 )
            {
                CurEquipItemsList[PlayerIndex].Grenades[loop] = itemID;
                break;
            }
         }
    }
    else if ( TypeID < 161 )//��Ƭ
    {
        log("ERROR ID: "$itemID);
    }
    else if ( TypeID < 241 )//���
    {
        log("ERROR ID: "$itemID);
    }
    else if ( TypeID < 251 )//��ɫ��װ
    {
        KFXItemTable.SetCurrentRow(itemID);
	log("SuitType:"$itemID$",CurEquipItemsList[PlayerIndex].Body[1]:"$CurEquipItemsList[PlayerIndex].Body[1]);
        if ( TypeID == 241)
        {
            KFXItemTable.SetCurrentRow(itemID);

            CurEquipItemsList[PlayerIndex].Body[1] = itemID & 0xffff;
            CurEquipItemsList[PlayerIndex].Body[0] = (itemID & 0xffff)+1;
            log("Body 1:"$CurEquipItemsList[PlayerIndex].Body[1]);
            return;
        }
    }
    else if ( TypeID < 271 )//��װ�Ҽ�
    {
         for( loop = 0; loop<BODY_PENDANT_CNT; loop++ )
         {
            if ( CurEquipItemsList[PlayerIndex].BodyPendents[loop] == 0 )
            {
                CurEquipItemsList[PlayerIndex].BodyPendents[loop] = itemID ;
                break;
            }
         }
    }
    else if ( TypeID < 311 )//�ͽ������ͼֽ
    {
        log("ERROR ID: "$itemID);
    }
    else if ( TypeID > 1540 && TypeID < 2153 )//�������
    {
        CurEquipItemsList[PlayerIndex].PlayerWeaponComponents.EquipedWeaponComponents[
                CurEquipItemsList[PlayerIndex].PlayerWeaponComponents.EquipedWeaponComponents.Length] = itemID ;
        log("WeaponComponents add id:"$itemID);
    }


    ;
}
// ������Ϸ
// Only RealLevel Valid
function KFXEndGame()
{
    local int i;
    local string NextGame;
    local Controller C;
	if ( !KFXIsKFXServerMode() )
		return;

    Log("[KFXFaeryAgent] Notify Game End!");

    for (i = 0; i < Players.length; i++ )
    {
        ;
    }

    KFXNotifyGameEnd();
    log("Agent-------bPVEGame "$bPVEGame);
    log("Agent-------default.bPVEGame "$default.bPVEGame);
    if(default.bPVEGame)
    {
        NextGame = PrepareNextGame();
        Level.ServerTravel(NextGame, false);
    }
    else
    {
        Level.ServerTravel("logo?Game=KFXGame.KFXPendingGameInfo", false);
    }
}
function string PrepareNextGame()
{
    local string NextGame;
    local string map;
    local int NextGuanID;
    if(PVECanRestartGame())   //�������һ�صĻ��ͼ��������������Ϸ
    {
        //DeletePVELastGuan();
        map = GetPVENextMap();
        log("Agent---------map "$map);
        NextGuanID = default.PVEStartGuan + default.CurGuanIndex;
        log("Agent---------default.CurGuanIndex "$default.CurGuanIndex);
        log("Agent---------default.PVEStartGuan "$default.PVEStartGuan);
        log("Agent---------NextGuanID "$NextGuanID);

        NextGame = map$"?Game=KFXPVEGame.KFXPVEGame"$"@GuanID="$NextGuanID;

    }
    else
    {
//            for(C=Level.ControllerList; C!=none; C=C.nextController)
//            {
//                KFXPlayer(C).KFXGSCommand(-1);
//                log("KFXFaeryAgent------C "$C);
//                C.Destroy();
//            }
        log("KFXFaeryAgent------DeleteAllPVEDefault ");
        //DeleteAllPVEDefault();
        NextGame = "logo?Game=KFXGame.KFXPendingGameInfo" ;

    }
    log("Agent---------NextGame "$NextGame);
    return NextGame;
}
function bool PVECanRestartGame()
{
    local Controller C;
    local int PlayerNum;

    PlayerNum = Players.Length;
    log("Agent------Players.Length "$default.Players.Length);
    log("Agent------PlayerNum "$PlayerNum);
    log("Agent------bCanRestartGame "$bCanRestartGame);
    return bCanRestartGame  ;
}

// �����;�˳�
// Only RealLevel Valid
function KFXPlayerLeave(int SessionID)
{
    Log("[KFXFaeryAgent] Player Leave Game: Session="$SessionID);

    KFXNotifyPlayerLeave(SessionID);
	if(bPVEGame)
	{
         KFXPVEPlayerLeave(SessionID);
    }
}
function  KFXPVEPlayerLeave(int SessionID)
{
    local int i;
    log("Agent--------SessionID "$SessionID);
    log("Agent--------Default.Players.Length "$Default.Players.Length);

    for(i=0; i<Default.Players.Length; i++)
    {
        log("Agent--------default.Players "$default.Players[i].SessionID );
        if(default.Players[i].SessionID == SessionID)
        {
            default.Players.Remove(i,1);
        }
    }
    log("Agent----22----Default.Players.Length "$Default.Players.Length);
    for(i=0; i<Default.PVEPlayerData.Length; i++)
    {
        log("Agent--------default.PVEPlayerData "$default.PVEPlayerData[i].SessionID);
        if(default.PVEPlayerData[i].SessionID == SessionID)
        {
            default.PVEPlayerData.Remove(i,1);
        }
    }
    for(i=0; i<Default.PlayersExp.Length; i++)
    {
        log("Agent--------default.PlayersExp "$default.PlayersExp[i].SessionID);
        if(default.PlayersExp[i].SessionID == SessionID)
        {
            default.PlayersExp.Remove(i,1);
        }
    }
    for(i=0; i<Default.PlayersDataExtra.Length; i++)
    {
        log("Agent--------default.PlayersDataExtra "$default.PlayersDataExtra[i].SessionID);
        if(default.PlayersDataExtra[i].SessionID == SessionID)
        {
            default.PlayersDataExtra.Remove(i,1);
        }
    }
    for(i=0; i<Default.BasePlayersData.Length; i++)
    {
        log("Agent--------default.BasePlayersData "$default.BasePlayersData[i].SessionID);
        if(default.BasePlayersData[i].SessionID == SessionID)
        {
            default.BasePlayersData.Remove(i,1);
        }
    }
    for(i=0; i<Default.PlayerWeapons.Length; i++)
    {
        log("Agent--------default.PlayerWeapons "$default.PlayerWeapons[i].SessionID);
        if(default.PlayerWeapons[i].SessionID == SessionID)
        {
            default.PlayerWeapons.Remove(i,1);
        }
    }
    for(i=0; i<Default.PlayerBagProps.Length; i++)
    {
        log("Agent--------default.PlayerBagProps "$default.PlayerBagProps[i].SessionID);
        if(default.PlayerBagProps[i].SessionID == SessionID)
        {
            default.PlayerBagProps.Remove(i,1);
        }
    }
    for(i=0; i<Default.CurEquipItemsList.Length; i++)
    {
        log("Agent--------default.CurEquipItemsList[i].SessionID "$default.CurEquipItemsList[i].SessionID);
        if(default.CurEquipItemsList[i].SessionID == SessionID)
        {
            default.CurEquipItemsList.Remove(i,1);
        }
    }



}

// ע��Agent
event PreBeginPlay()
{
    KFXRegist();
	if(default.bPVEGame)
	{
//	   Log("[KFXFaeryAgent] PrepareNextGuan ");
//    	class'PVEGameManager'.static.PrepareNextGuan();

		InitPVEPlayerLevelInfo();
	}
    Log("[KFXFaeryAgent] Regist KFXFaeryAgent");
}

// ��ע��Agent
event Destroyed()
{
	KFXUnRegist();
	log("Destroyed-------default.bPVEGame "$default.bPVEGame);
	if(default.bPVEGame)
	{
    	//default.CurGuanIndex++;
    	log("Agent-------default.PVERandGame.Length "$default.PVERandGame.Length);
    	log("Agent-------PVECanRestartGame() "$PVECanRestartGame());
    	if(!PVECanRestartGame())
    	{
    	    DeleteAllPVEDefault();
        }
    	else if(default.PVERandGame.Length == 0)
    	{
    	    DeleteAllPVEDefault();
        }
    }
	Log("[KFXFaeryAgent] UnRegist KFXFaeryAgent");
}

event PlayerBuyItemResponse(int PlayerID, int ItemID)
{
	local Controller Player;

	for (Player = Level.ControllerList; Player != none; Player = Player.nextController)
	{
		if (KFXPlayer(Player).fxDBPlayerInfo.PlayerID == PlayerID)
		{
			KFXPlayer(Player).ServerTransWeapon(ItemID);
		}
	}
}
function SetPVEAllGuanInfo()
{
	local int nStart;
	local int Len;
	local int i;
	nStart = game.nStartGuanNum;
	default.PVERandGame.Insert(0,G_MaxGuanNum - nStart + 1);
	Len = G_MaxGuanNum - nStart;
	log("FaeryAgent--------Len "$Len);
	for(i=0; i<=Len; i++)
	{
		default.PVERandGame[i].nRulesID = class'PVEGameManager'.static.GetRulesByIndex(i);
		default.PVERandGame[i].nMapID   = class'PVEGameManager'.static.GetMapByIndex(i);
		log("Agent--------PVERandGame[i].nRulesID "$default.PVERandGame[i].nRulesID$"  PVERandGame[i].nMapID "$default.PVERandGame[i].nMapID);
	}

}
function DeletePVELastGuan()
{
   log("Agent---111----default.PVERandGame.Length "$default.PVERandGame.Length);
   default.PVERandGame.Remove(0,1);
   log("Agent---222----default.PVERandGame.Length "$default.PVERandGame.Length);
}
event DeleteAllPVEDefault()
{
	log("Agent-------DeleteAllPVEDefault");
    DeletePVEPlayerDefault();
    DeletePVERandDefault();
}
function PVEGameState CheckPVERandArray()
{
	log("Agent--------default.PVERandGame.Length "$default.PVERandGame.Length);
	log("Agent--------default.CurGuanIndex "$default.CurGuanIndex);
	if(default.PVERandGame.Length == 0)
	{
		if(default.CurGuanIndex > 0)
		{
			return PVEState_MatchOver;
		}
		else
		{
			return PVEState_Start;
		}
	}
	else
	{
		return PVEState_Matching;
	}
}

function InitPVEPlayerLevelInfo()
{
	local int loop;
	if(default.bPVEGame)
	{
		if( class'PVEGameManager'.static.IsFirstGuanInPart() )
		{
			for(loop=0; loop < default.PVEPlayerData.Length; loop++)
			{
				default.PVEPlayerData[loop].PVELevel = 1;
				default.PVEPlayerData[loop].PVELevelExp = 0;
			}

			for(loop=0; loop < PVEPlayerData.Length; loop++)
			{
				PVEPlayerData[loop].PVELevel = 1;
				PVEPlayerData[loop].PVELevelExp = 0;
			}
		}
	}
}
event SetAgentDefaultData()
{
	local int i;
	log("FaeryAgent----------default.bPVEGame "$default.bPVEGame);
	log("FaeryAgent----------bPVEGame "$bPVEGame);
    if(!default.bPVEGame)
	{
        log("Agent---Only PVE Can Do");
        return ;
    }
    log("FaeryAgent----------Players.Length "$Players.Length);
	for(i=0; i<Players.Length; i++)
	{
		default.Players[i] = Players[i];
	}
	log("FaeryAgent----------PlayersExp.Length "$PlayersExp.Length);
	for(i=0; i<PlayersExp.Length; i++)
	{
		default.PlayersExp[i] = PlayersExp[i];
	}
	log("FaeryAgent----------PlayerWeapons.Length "$PlayerWeapons.Length);
	for(i=0; i<PlayerWeapons.Length; i++)
	{
		default.PlayerWeapons[i] = PlayerWeapons[i];
	}
	log("FaeryAgent----------PlayerBagProps.Length "$PlayerBagProps.Length);
	for(i=0; i<PlayerBagProps.Length; i++)
	{
		default.PlayerBagProps[i] = PlayerBagProps[i];
	}
	log("FaeryAgent----------CurEquipItemsList.Length "$CurEquipItemsList.Length);
	for(i=0; i<CurEquipItemsList.Length; i++)
	{
		default.CurEquipItemsList[i] = CurEquipItemsList[i];
	}
	log("FaeryAgent----------BasePlayersData.Length "$BasePlayersData.Length);
	for(i=0; i<BasePlayersData.Length; i++)
	{
		default.BasePlayersData[i] = BasePlayersData[i];
	}
	log("FaeryAgent----------PlayersDataExtra.Length "$PlayersDataExtra.Length);
	for(i=0; i<PlayersDataExtra.Length; i++)
	{
		default.PlayersDataExtra[i] = PlayersDataExtra[i];
	}
	log("FaeryAgent----------PVEPlayerData.Length "$PVEPlayerData.Length);
	for(i=0; i<PVEPlayerData.Length; i++)
	{
		default.PVEPlayerData[i] = PVEPlayerData[i];
	}

	default.CurGuanIndex = CurGuanIndex + 1;

	//default.PVEStartGuan = PVEStartGuan;
	log("Agent-------CurGuanIndex "$CurGuanIndex);

}

defaultproperties
{
     PVEStartGuan=1
}
