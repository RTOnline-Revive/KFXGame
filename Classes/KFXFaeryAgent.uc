//-----------------------------------------------------------
//set:mat2_button01 image:button_02_focus
//-----------------------------------------------------------
class KFXFaeryAgent extends Info
    native;

// 道具数量
const KFX_MAJORWEAP_CNT = 30;       //主武器数量
const KFX_BAGPROP_CNT = 30;
const KFX_GAIN_ITEM_COUNT = 20;      //兄弟连掉落物品数量
const KFX_GAIN_ITEM_NUM = 5;
const KFX_CUR_ITEM_COUNT = 20;
const KFX_PLAYERITEMS_COUNT = 120;
// 武器种类数量
const WEAPON_CLS_COUNT = 15;
const WEAPON_PENDANT_CNT = 6;
const BODY_CNT = 2;
const BODY_PENDANT_CNT = 9;
const KFX_GRENADE_CNT = 3;
const MAX_DURABLE_CNT = 10;

const MAX_Netbar_Action = 4;
//活动最大数量
const MAX_ActionAdd_Num = 4;
enum  _Action_Class
{
    _EA_EXP ,  ///经验
	_EA_GAME_COIN, ///银币获取
	_EA_POINT , ///积分获取
	_EA_MOVE , ///移动速度
};
// 游戏结果
enum  KFX_GAME_RESULT
{
    KFX_FLEE,      // 逃跑 （中途退出）
	KFX_VICTORY,   // 胜
	KFX_DEUCE,     // 平
	KFX_DEFEATED,  // 负
	KFX_NONE       // 无结果
};
enum EREALM_GS_COMMAND
{
    EREALM_COMMAND_NONE,       //无
    EREALM_COMMAND_ENDGAME,    //结束游戏
};

//物件信息
struct native FAgentItemData
{
    var int ItemType;
    var int ItemDurable;
    var int ItemEquiped;
};

struct native PlayerWeaponComponentsBlock
{
    var array<int> EquipedWeaponComponents;                       //武器组件
    var array<int> UnEquipedWeaponComponents;      //武器组件
};

struct native FactionEndGameInfo
{
	var int m_uiTeamType; // 红队/蓝队类型
	var int m_uiGameResult; // 比赛结果
	var int m_iCurPointAdd;	// 当前积分增量
	var int	m_iGameTicketAdd; // 鐢电珵鍒稿閲
	var int m_iMmrAdd; //MMR(电竞积分)增量
};
struct native KFXEndGameInfo
{
    var int   nWinTeamIndex;
    var int   nGameResult;            //失败比胜利或者死亡比击杀比值*100
    var int   nTotalRound;
};

//玩家当前装备数据结构
struct native CurEquipItemsListType
{
    var int SessionID;                             //sessionid
    var int MajorWeaponID;                         //当前主武器
    var int MinorWeaponID;                         //当前副武器
	var int MeleeWeaponID;                         //当前冷冰器
	var int Grenades[KFX_GRENADE_CNT];             //雷
	var int Body[BODY_CNT];                        //角色服装
	var int BodyPendents[BODY_PENDANT_CNT];        //角色配件：脸手背腰左右腿脚
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
    var int SessionID;                                 //角色ID
    var int CommRifleKillCount;                     //冲锋枪
    var int AssaultKillCount;                        //突击步枪
    var int SniperKillCount;                         //狙击枪
    var int ScatterKillCount;                        //霰弹枪
    var int MachinegunKillCount;                      //机关枪
    var int PistolKillCount;                         //手枪
    var int GrenadeKillCount;                        //雷击杀
    var int RemoveBombCount;                             //拆包数
    var int InstallBombCount;                               //埋包数
    var int FirstBooldCount;                         //获得firstblood的次数
    var int DoubleKillCount;                         //双连杀次数
    var int ThreeKillCount;                          //三连杀次数
    var int FiveKillCount;                           //无连杀的次数
    var int HeadKillCount;                           //爆头次数
    var int KnifeKillCount;                          //刀杀次数
    var int KillCount;                          //击杀次数
    var int DeathCount;                         //死亡次数
    var int KillGhostCount;                          //杀死幽灵数
    var int KillBotCount;                            //杀死bot数
    var byte KillVipCount;                            //杀死Vip数
    var byte ChamPoinCount;                           //获得单场游戏冠军数
    var int GameResult;                         //游戏结果
    var int Experience;                         //获得经验值
    var int GameCash;                           //获得银币值
    var int SPoint;                             //获得积分
    var FAgentItemData DurableItemList[MAX_DURABLE_CNT];    //耐久物品

    var int RewardTime;                          //赏金模式的游戏时间
    var int RewardBossCnt;                       //赏金模式杀敌数量
    var int KillMeMost;						//杀自己最多的那个玩家 Role ID
};
struct native PlayerDataBlockExtra
{
    var int SessionID;                                 //角色ID
    var int PlayerContribution;
    var byte VIPEscapeTimes;                    //VIP逃脱次数
    var byte ACEOrder;
    var int  GhostKillCount;                    //幽灵杀人数
    var int  CorpseKillCount;                   //僵尸杀人数
    var int  KillCorpseCount;                   //杀死僵尸数
    var int GainItem[KFX_GAIN_ITEM_COUNT];       //获得物品
};
var Array<BasePlayerDataBlock>  BasePlayersData;
var Array<PlayerDataBlockExtra> PlayersDataExtra;

// 玩家数据
// Note: 容量有上限，再大就装不下了，尝试用级联
struct native KFXPlayerInfo
{
    var int PlayerID;          // Player唯一标识
    var int SessionID;         // Session ID
    var int RealmIP;           // 玩家所在Realm的IP
    var int RealmPort;         // 玩家所在Realm的Port
    var string PlayerName;     // Player name

    var int RoleID;            // 使用角色编号
    var byte TeamID;           // 队伍编号
    var byte nLevel;		   // 人物等级

    // 装备信息
    var int nMajorWeaponID;                         //当前主武器
    var int nMinorWeaponID;                         //当前副武器
	var int nMeleeWeaponID;                         //当前冷冰器
	var int	nGrenades[KFX_GRENADE_CNT];             //雷

    var byte nVipLevel;								// Vip级别
    var byte nNetBarMode;							// 网吧模式

    // 角色战绩信息
	var int	nKillCount;								// 杀人数
	var int	nDeathCount;							// 死亡数

	var int	nHeadKillCount;							// 爆头次数
	var int	nKnifeKillCount;						// 刀杀次数
	var int	nSpeicalKillCount;						// 特殊击杀

	var byte nGameResult;							// 逃跑,胜,负,平,无结果 (see: enum KFX_GAME_RESULT)

	// 角色等级信息
	var int	nExperience;							// 经验
	var int nGameCash;                              // 游戏币
	var int nDanceCardBit;				            //用位来表示跳舞卡，由KFXItem.csv TypeIDLow来表示

    // 积分相关
    var float   fSPointGainSpeed;                   // 积分获取速率
    var int     nSPoint;                            // 注意：获取积分 GameServer->Realm（游戏结束从游戏服以务器得到的积分，发给大厅服务器）
    var int     nTotalSPoint;                       // 注意：总的积分 Realm->GameServer 用于转换成运动员称号（由大厅服务器发给游戏服务器，是玩家的一个数据库属性）
    var int     nIndividualGrade;                   //个人评分
    var int     nTeamGrade;                         //队伍评分（战队赛时为房间评分，精英赛时为小队技术评分）

    // Avatar信息
    var int AvatarBody;
    var int AvatarHead;
    var int AvatarLegs;

    var int Suit;              // 套装

    // 战队相关
    var int FactionID;          // 战队ID
    var int FactionIconID;      // 战队图标ID
    var string FactionName;     // 战队名称
    var float FactionCashFactor;    //战队经验金币加成
    //会员相关
    var int     nIsMember;                          //是否是会员
    var int     RewardTime;     //最短通关时间
    var int     RewardCount;    //最多杀敌数量

    //观察者模式，进入游戏后直接是观察者
    var byte    nSpectatorView;               //是否观察者

    var int     nGainItem[KFX_GAIN_ITEM_NUM];         //兄弟连掉落道具的信息
    var int     uWinFactionID;                          //胜利的战队id
    var int     uWinSpoint;				// 胜利战队得分
    var int     uLostSpoint;				// 失败战队得分
    var PlayerMissionData MissionBlock;

	//网吧活动
	var int 	level_netbar;
	var float 	xp_netbar[MAX_Netbar_Action];

	var int    bWantToBeVIP;             //是否想当VIP
};
struct native KFXPlayerInfoEx
{
	var array<int>		mutate_roles;		//可变身木乃伊的角色
};

struct native KFXPlayerWeaponsBakInfo   //备用武器信息
{
    var int SessionID;         // Session ID
	var int	nMajorWeapons[KFX_MAJORWEAP_CNT];       //备用主武器
};

struct native KFXBagPropsInfo
{
    var int SessionID;         // Session ID
    var int	nBagProps[KFX_BAGPROP_CNT];		        // 道具
};

//<<李威国 套装相关 2009.1.21
struct native KFXPlayerExpInfo
{
    var int SessionID;         // Session ID
    //活动类型和加成系数
    var int     ActionType[MAX_ActionAdd_Num];
    var float   ActionRate[MAX_ActionAdd_Num];

//    // Avatar信息
//    var int AvatarBody;
//    var int AvatarHead;
//    var int AvatarLegs;
//
//    var int Suit;              // 套装

    // 战队相关
//    var int FactionID;          // 战队ID
//    var int FactionIconID;      // 战队图标ID
//    var string FactionName;     // 战队名称
//    //会员相关
//    var int     nIsMember;                          //是否是会员
//
//    var int     nGainItem[KFX_GAIN_ITEM_COUNT];         //兄弟连掉落道具的信息
//    var int     uWinFactionID;                          //胜利的战队id
//    var int     uWinSpoint;				// 胜利战队得分
//    var int     uLostSpoint;				// 失败战队得分
};
//>>

// 游戏数据
// [nGameOptParam] 含义：
// 1. 木乃尹模式：
//      最右一位 - 僵尸是否有队伍伤害
struct native KFXGameData
{
    var const int  nMapID;        // 地图编号
	var const int  nGameMode;     // 游戏模式
	var const int  nTimeLimit;    // 时间上限
	var const int  nRounds;       // 回合上限
	var const int  nKillLimit;    // 杀人上限
	var const int  nWeapLimit;	  // 武器类型限制
	var const int  nRestartTime;  // 复生时间
	var const int  nGameOptParam; // 游戏选项参数，每个位标识不同的信息

    var const int   nNotCountKill;  ////被杀是否计算 0：不算。1：算。
	var const float fExpFactor;	  //在特定时间内是否获得荣誉值翻倍的功能
	var const float fSPointFactor;//积分获取运营活动系统
    var const float fGameCoinFactor;// 游戏币获取速率
    var const float fHonorPointRate;// 控制荣誉值在积分中所占的比例
    var const float fGameTimeRate;  // 控制游戏时间在积分中所占的比重
    var const int   nGameType;     // 大厅服务器类型

    var const int nBotModeConfig;// 带机器人模式相关配置
//    var       int nTaskMapID;
	var const int nRealmCommand;     //发自realm的命令
	var int nStartGuanNum;     //PVB 从哪关开始
    var const int PVEDifficulty;     //PVE 难度1普通0死亡
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



var FactionEndGameInfo KFXFactionEndGameInfo[2];//战队信息
var KFXEndGameInfo        EndGameInfo;

// 玩家数据列表
// Only RealLevel Valid
var array<KFXPlayerInfo> Players;
var array<KFXPlayerInfoEx> PlayersInfoEx;

//<<李威国 套装相关 2009.1.21
// 玩家数据列表扩展
var array<KFXPlayerExpInfo> PlayersExp;
//>>
//<<装备扩容武器信息单拿出来了
var array<KFXPlayerWeaponsBakInfo> PlayerWeapons;
//<<装备库扩容把卡片信息取出
var array<KFXBagPropsInfo> PlayerBagProps;

// 游戏数据
// PendingLevel & RealLevel Valid
var KFXGameData Game;

// 服务器Setup Game OK！ 可以设置玩家数据
// Only RealLevel Valid
native function KFXNotifyGameReady(int bPVEGame,int NextGuanID,int NextMapID);

// 游戏结束
native function KFXNotifyGameEnd();

// 玩家中途退出
native function KFXNotifyPlayerLeave(int SessionID);

// 注册Agent
native function KFXRegist();

// 反注册Agent
native function KFXUnRegist();

// 获得KFXFaeryAgent
native static function KFXFaeryAgent KFXGetAgent();

// 是否连接大厅服务器
native static function bool KFXIsKFXServerMode();

native function NotifyPlayerLogInGameServer( int SessionID );

/*
*/

native static function bool IsItemInEquipList(int SessionID, int itemID);
native static function int GetItemDurable(int SessionID, int itemID);

// 游戏运行过程中接收来自realm的命令
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
    // 当玩家与realm断开连接的时候，此时realm会检测玩家是否在游戏内
    // 如果玩家在游戏内，将发送协议告诉gs踢号，将其下线
    // 这个运用会在当玩家在游戏过程中直接叉客户端或者在游戏过程中和realm断开连接
     // 此两种表现都不会出现问题
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
// 开始游戏
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

    if(Game.nGameMode == 4 || Game.nGameMode == 5)          //4,5为PPVE模式
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

//获得地图从这开始
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
    //只初始化一次
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
	    SetPVEAllGuanInfo();                   //FaeryAgent 获得每关信息
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
event SetPlayerEquipedListItem(int PlayerIndex, int itemID)//设置装备的列表
{
    local int TypeID;
    local int loop;
    local KFXCSVTable KFXItemTable;
    TypeID = itemID >> 16;
    log("SetPlayerCurEquipListItem itemid"$itemID$"TypeID"$TypeID);

    KFXItemTable = class'KFXTools'.static.GetConfigTable(30);

    if ( TypeID <= 0 || itemID <= 0 )
        return;

    if ( TypeID <31 )//主武器
    {
        CurEquipItemsList[PlayerIndex].MajorWeaponID = itemID ;
        log("SetPlayerCurEquipListItem MajorWeapon itemid"$itemID$"TypeID"$TypeID);
    }
    else if (TypeID <41)//副武器
    {
        CurEquipItemsList[PlayerIndex].MinorWeaponID = itemID ;
    }
    else if ( TypeID < 51 )//冷兵器
    {
        CurEquipItemsList[PlayerIndex].MeleeWeaponID = itemID ;
    }
    else if (TypeID < 61)//投掷类武器
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
    else if ( TypeID < 161 )//卡片
    {
        log("ERROR ID: "$itemID);
    }
    else if ( TypeID < 241 )//礼包
    {
        log("ERROR ID: "$itemID);
    }
    else if ( TypeID < 251 )//角色服装
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
    else if ( TypeID < 271 )//服装挂件
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
    else if ( TypeID < 311 )//赏金零件及图纸
    {
        log("ERROR ID: "$itemID);
    }
    else if ( TypeID > 1540 && TypeID < 2153 )//武器配件
    {
        CurEquipItemsList[PlayerIndex].PlayerWeaponComponents.EquipedWeaponComponents[
                CurEquipItemsList[PlayerIndex].PlayerWeaponComponents.EquipedWeaponComponents.Length] = itemID ;
        log("WeaponComponents add id:"$itemID);
    }


    ;
}
// 结束游戏
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
    if(PVECanRestartGame())   //如果有下一关的话就继续，否则结束游戏
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

// 玩家中途退出
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

// 注册Agent
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

// 反注册Agent
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
