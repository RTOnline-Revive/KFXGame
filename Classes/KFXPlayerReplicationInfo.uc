class KFXPlayerReplicationInfo extends TeamPlayerReplicationInfo;

//var xUtil.PlayerRecord Rec;

var bool bForceNoPlayerLights;  // OBSOLETE
var bool bNoTeamSkins; //OBSOLETE

// Edit By lwg
//移到父类中
//var class<Scoreboard> LocalStatsScreenClass;
//var SquadAI Squad;
//var bool bHolding;

// following properties are used for server-side local stats gathering and not replicated (except through replicated functions)

// Edit By lwg
//移到父类中
//var bool bFirstBlood;

struct KFXHangingInfo
{
    var float   fxHangingExp;           // 经验值
    var float   fxHangingCash;          // 游戏币
    var float   fxHangingSPoint;        // 点数
    var float   fxLastUpdateSec;        // 上一次更新时间

    var float   fxHangingExpSpeed;      // 挂机经验值速率
    var float   fxHangingCashSpeed;     // 挂机游戏币速率
    var float   fxHangingSPointSpeed;   // 挂机点数速率
};

// Edit By lwg
//移到父类中
/*
struct WeaponStats
{
	var class<Weapon> WeaponClass;
	var int kills;
	var int deaths;
	var int deathsholding;
};
var array<WeaponStats> WeaponStatsArray;

struct VehicleStats
{
	var class<Vehicle> VehicleClass;
	var int Kills;
	var int Deaths;
	var int DeathsDriving;
};
var array<VehicleStats> VehicleStatsArray;
*/

// Edit By lwg
//移到父类中
/*
var int FlagTouches, FlagReturns;
var byte Spree[6];
var byte MultiKills[7];
var int Suicides;
var int flakcount,combocount,headcount,ranovercount,DaredevilPoints;
var byte Combos[5];
*/
var int fxRoleGUID;
//--------------------------------------------------
// add by zjpwxh@kingsoft 张金品
//--------------------------------------------------
//var int     fxCurrCredit;       // 当前荣誉   //看来没有用了，wangkai
var int  StaticEXPWithNoAdditional;//未经修饰的经验值数据（不受乱七八糟经验的加成影响）
var int     fxCurrExp;          // 当前经验
var int		fxExp_netbar;	//网吧的经验加成
var int     fxKills;            // 杀人数
var int     fxDeaths;           // 死亡数
var int     fxHeadKillNum;      // 爆头数
var int     fxSpecKillNum;      // 杀猪数
var int     fxDaggerKillNum;    // 刀杀数
var int     fxProjectileKillNum; //投掷类武器的击杀数
var bool    bSuperState;        // 是否出于无敌状态
var float   fxDeadTime;         // 死亡时间
var float   fxClientDeadTime;   // 死亡时间(客户端纪录)
var bool    bHeadKill;          // 是否爆头
var bool    bAutoAimKill;       // 自动爆头
var bool    bDeadStatus;        // 是否死亡状态
var int     fxGameResult;       // 游戏结果
var bool    bSpecMode;          // 特殊伤害模式
var vector  fxLocation;         // 客户端位置
var float   fxRestartTime;      // 复活时间
var bool    bSpeechState;       // 宏喊话状态
var bool    bLevelup;           // 是否升级
var int     fxLevel;            // 人物等级
var float   fxLoginTime;        // 登陆时间
var int     fxTransPigNum;      // 变猪数
var int     fxContribution;     // 贡献度
var int     fxShowCredit;       // 客户端显示荣誉
var int     fxShowWinExp;       // 客户端显示赢方额外荣誉
var float   fxPropBonusFactor;	// 道具影响分数计算因子
var int     fxExtraExp;         // 特殊奖励
var float   fxGameCashFinalFactor;//游戏币最终调节系数（玩家道具）
var bool    bVipBonus;
var bool    bNetBarBonus;
var bool    bPropBonus;
var int     PlayerHealth;
var int     PlayerRewardTime;       //赏金模式下的最短通关时间
var int     PlayerRewardCount;      //赏金模式下的最多杀人数量
var bool    bfxHanging;             // 是否挂机
var KFXHangingInfo fxHangingInfo;   // 挂机信息
var byte	fxPlayerDomain;			//玩家所在的区域

var int     PlayerGameType;       //游戏类型，普通，战队，电竞
var int     fxGameCash;         // 获得的游戏币
var int		fxGameCash_Netbar;	//网吧加成的游戏币
var float   fxTeamMatchFactor;  //战队成员加成 比率
var int     fxPlayerDBID;       //玩家在数据库里面的唯一ID
var byte	ACEOrder;			//玩家的ace排名，1表示第一名。

//--------------------------------------------------
// **TeamInfo中的Score目前用来表示队伍击毙数
//--------------------------------------------------

//<<消灭系统        ChenJianye
var int     KFXKillMeCount;
var int     KFXKilledByMeCount;
//>>

//<< Dolby Voice相关变量
// 人物语音音量：0 if not taling, indicative volume 1-255 if player is talking
var byte    KFXTalkVolume;      //由服务器同步到客户端
var bool    bKFXTeamTalk;       //标识是否正在用队伍聊天
var bool    bKFXMute;           //标识是否屏蔽, client only
//道具
var byte    KFXVoiceFont;       //装备哪种VoiceFont
var byte    KFXCurVoiceFont;    //当前是哪种VoiceFont, client only
var bool    bKFXSpatial;        //是否使用3D立体声
var bool    bKFXHeadKill;           // 是否装备爆头卡
var bool    bKFXHeadKillResist;     // 是否装备防爆头卡
var bool    bKFXAnimalResist;       // 变身雷保护卡
//>>

var float   KFXFastOccupyFactor;      // 快速占领卡：占领减少的时间

var int     KFXTotalSPoint;     //总的积分用于转换成运动员称号
var int     KFXIndividualGrade;  //个人评分
var int     KFXVIP;            //是否是会员

var int TimeNeedChangeWeapBegin;


var string fxBattleTeamName;              //战队名字
var int fxBattleTeamID;                   //战队id
var int fxWinnerTeamID;                   //胜利的战队id
var int fxWinSpoint;                      //胜利战队得分
var int fxLostSpoint;                     //失败战队得分
var int fxFactionIcon;
var int fxFactionBackGround;

///游戏内获得的物品
var array<int> fxItemList;
var int     fxKillBots;            		///< 杀bot数
var int fxKillSpecialTeam;				///< 击杀特殊队数量 幽灵，木乃伊
var int fxKillsInGhostState;            ///在幽灵状态下杀人数
var int fxKillsInCorpseState;           ///在僵尸状态下杀人
var int fxKillCorpseCount;              //杀死僵尸数

var float fxHeadKillSpecial;			///<爆头获得经验值比率
var bool fxHeadKillExpCard;				///<是否装备爆头经验值卡片
var float fxRestartCardTime;				///<装备复生时间减少卡的参数
var float fxFastSwitchAmmoRate;         ///<装备快速换弹卡加速比率

var bool bKFXHasFactionBadge;


///<同步数组结构定义，使用解析同步
struct SReplicateArray
{
	var byte bits[3];
	var array<int> arrData;
};

const REP_VALUE			= 0;                ///<标识已有的同步值
const REP_WEAPONKILL 	= 1;                ///<武器击杀
const REP_MULTIKILL		= 2;                ///<连杀
const REP_COUNT			= 3;
var array<SReplicateArray> fxRepArray[REP_COUNT]; 	///<（伪）同步数组

var int fxWeaponKillRep;					///<同步相关
var int fxLastWeaponKillRep;				///<旧数据
var int fxMultiKillRep;						///<同步相关
var int fxLastMultiKillRep;					///<旧数据
var int nIDLastKillMe;				//上一个击杀自己的人，不需要同步，客户端计算
var int nRealIDLastKillMe;

struct SChangedRep
{
	var float timeSecond;   // 改变时间
	var int value1;			// 数值 1级value
	var int value2;			// 数值 2级value
};
var array<SChangedRep> fxChangedRepValues;	///<存储客户端一定时间内改变fxRepArray标识

//定义已有同步数据
const REPVALUE_KILL			= 0;			///<击杀次数 fxKills
const REPVALUE_DEATH		= 1;			///<被杀次数 fxDeaths
const REPVALUE_HEADKILL		= 2;			///<爆头杀次数 fxHeadKillNum
const REPVALUE_KNIFEKILL	= 3;            ///<刀杀次数 fxDaggerKillNum
const REPVALUE_SPEKILL		= 4;			///<特殊击杀数 fxSpecKillNum
const REPVALUE_FIRSTBLOOD	= 5;			///<第一滴血，用位少，以后可扩展
const REPVALUE_KILLBOT		= 6;			///<杀bot数量
const REPVALUE_KILLSPETEAM	= 7;			///<杀特殊队伍生物 幽灵 木乃伊
const REPVALUE_PLAYERHEALTH = 8;            ///玩家血量
const REPVALUE_KILLVIP      = 9;            ///杀Vip数量
const REPVALUE_MODEVALUE0	= 16;           ///<模式相关数值  爆破模式 埋包数
const REPVALUE_MODEVALUE1	= 17;           ///<模式相关数值  爆破模式 拆包数
const REPVALUE_MODEVALUE2	= 18;           ///<模式相关数值  拆埋包总数
const REPVALUE_MODEVALUE3	= 19;           ///<模式相关数值   VIP逃跑次数
const REPVALUE_MODEVALUE4	= 20;           ///<幽灵状态下杀人数
const REPVALUE_MODEVALUE5	= 21;           ///<僵尸状态下感染人数
const REPVALUE_MODEVALUE6	= 22;           ///<杀死僵尸数
const REPVALUE_MODEVALUE7	= 23;           ///<模式相关数值
const REPVALUE_COUNT		= 24;

//定义武器击杀
const WEAPONKILL_FIST 		= 0;            ///<使用拳头完成击杀数
const WEAPONKILL_SMG 		= 1;    		///<使用冲锋枪完成击杀数
const WEAPONKILL_RIFLE 		= 2;    		///<使用突击步枪完成击杀数
const WEAPONKILL_SNIPER 	= 3;   			///<使用狙击枪完成击杀数
const WEAPONKILL_LMG 		= 4;  			///<使用轻机枪完成击杀数
const WEAPONKILL_HMG 		= 5;  			///<使用重机枪完成击杀数
const WEAPONKILL_CANNON 	= 6;  			///<使用榴弹炮完成击杀数
const WEAPONKILL_ROCKET 	= 7;   			///<使用火箭筒完成击杀数
const WEAPONKILL_PISTOL 	= 8;			///<使用手枪完成击杀数
const WEAPONKILL_MELEE 		= 9;    		///<使用近战武器完成击杀数
const WEAPONKILL_SHOTGUN 	= 10;  			///<使用散弹枪完成击杀数
const WEAPONKILL_ASSIST 	= 11;   		///<使用副挂类装备完成击杀数
const WEAPONKILL_COUNT		= 12;
//定义连杀
const MULTIKILL_TWO			= 0;			///<二连杀
const MULTIKILL_THREE		= 1;            ///<三连杀
const MULTIKILL_FIVE		= 2;            ///<五连杀
const MULTIKILL_COUNT		= 3;

var int fxCommRifleKillCount;
var int fxAssaultKillCount;
var int fxSniperKillCount;
var int fxScatterKillCount;
var int fxMachinegunKillCount;
var int fxPistolKillCount;
var int fxGrenadeKillCount;
var int fxFirstBooldCount;
var int fxDoubleKillCount;
var int fxThreeKillCount;
var int fxFiveKillCount;
var int fxChamPoinCount;

var int fxCurMultiKillCount;

// 消灭统计（战绩统计）；最多8条纪录
// 一条命是一个纪录
const HitCollect_CNT = 8;
// 击中统计（击中别人）
struct HitOtherCollect
{
	var string OtherName[HitCollect_CNT];
	var byte bHeadKill[HitCollect_CNT];
	var byte bShootDown[HitCollect_CNT];
	var byte bOld[HitCollect_CNT];
	var int HitHP[HitCollect_CNT];
	var int OtherLevel[HitCollect_CNT];
};

// 被别人击中
struct BeHitedCollect
{
	var string HiterName[HitCollect_CNT];
	var byte HiterLevel[HitCollect_CNT];
	var byte bHeadKill[HitCollect_CNT];
	var byte bShootDown[HitCollect_CNT];
	var byte bOld[HitCollect_CNT];
	var int HitHP[HitCollect_CNT];
	var int HitWeapID[HitCollect_CNT];
};

struct KFXKilledMe
{
	var int playerid;
	var int counter;
};
// server only
var BeHitedCollect BeHitedList;
var HitOtherCollect HitOtherList;

// server | client HUD显示
var BeHitedCollect BeHitedListHUD;
var HitOtherCollect HitOtherListHUD;

//记录当前玩家所持枪械
var int		fxCurrWeaponID;
var array<KFXKilledMe>		killedmes;

struct WeapAndCompntID
{
    var int weaponID;
    var int CompntID[6];
};

var array<WeapAndCompntID> WeapAndCompntIdList;

var bool bSpectatorView;    //直接观察者模式进入
var float nHonorPointEx;	//该玩家额外的经验速率
var float nSilverEx;		//该玩家额外的游戏币速率

var float DeadBeginTime;
var bool  bDrawRedDeadFlag;
var bool  bInitedDeadTime;

//测试pawn状态数据
var bool bKFXTestGod;					//无敌状态开
var float fxTestGodBeginTime;			//无敌状态开启时间
var float fxTestGodLastTime;			//无敌状态保持时间
var bool bKFXGodError;					//无敌检查

var bool bKFXTestHide;					//隐身状态开
var float fxTestHideBeginTime;			//隐身状态开启时间
var float fxTestHideLastTime;			//隐身状态保持时间
var bool bKFXHideError;					//隐身状态检查

var bool bKFXTestScale;					//变大变小开
var float fxTestScaleBeginTime;			//变大变小开启时间
var float fxTestScaleLastTime;			//变大变小保持时间
var bool bKFXScaleError;				//变大变小检查
var int  ACEWeapon;

//网吧加成信息
var int	  netbar_level;				//网吧等级
var float exp_netbar_ex;   			//网吧经验加成
var float silver_netbar_ex;			//网吧银币加成

var int   ActionType[4];            //活动种类
var float ActionRate[4];            //活动加成

var int     fxKillBlood;   // 统计幽灵打警察血量
var int     fxOldKills;     //上一次击杀数
var int     fxOldDeaths;
var int     fxAttackBloodOnce;// 一次攻击的伤害血量
var bool    bBloodIsKills;         //伤血值是否算击杀数
var int     fxPlayerContribution;    //玩家在参与战队赛和精英赛时，都可以获得贡献值：

var                 bool         bIsRedTeam;
var                 bool         bFemale;


//游戏内Farm系统逻辑  sunqiang
var float   DeathsDroppedRate;
var float   KillsDroppedRate;
var int     DroppingKills;
var int     DroppingDeaths;
const MaxDropItemNum = 20;                 //整场游戏最大掉落的个数
var int LastDropItem[MaxDropItemNum];     //整场游戏掉落的东西ID
var int CurDropItemNum;                   //当前游戏掉落的东西个数
var float PreDroppedTime;                 //上次掉落时间

//< PVE积分系统，必须通过Set方法设置分数
enum EGUANSCORE_TYPE		//单关中，每个积分获得的方式
{
	EGS_None,
	EGS_FromAIDamaged,		//伤害AI获得
	EGS_FromAIKilled,		//杀死AI获得
	EGS_FromPassGuan,		//通关获得
	EGS_FromSpecial,		//特殊的
	EGS_FromDestroyActor,   //击毁加分物件
};
var int GuanScore;     		//单关积分数
var int TotalGuanScore;		//此关之前的总积分数，这个由Feary设置


//PVE成长体系
var int PVELevel;                        //玩家的等级，与本部分的基础属性等级无关
var int ClientPveLevel;                  //客户端未得到本次同步之前的等级
var int PVEexp;                          //玩家经验，目前的设计是不包含已经升级的经验
var int ClientPVEexp;                    //客户端未得到同步之前的玩家经验
var float LevelHP;                       //玩家当前等级的HP上限
var float LevelDmgFactor;                //玩家当前等级的伤害系数

replication
{

	// Edit By lwg
    //移到父类中
    //reliable if ( bNetInitial && (Role == ROLE_Authority) )
	//	LocalStatsScreenClass;
	//reliable if ( Role == ROLE_Authority )
	//	/*Squad, */bHolding; //, DareDevilPoints;

	// 只同步一次
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        fxDeadTime,fxBattleTeamName,fxBattleTeamID, bKFXHeadKill, fxFactionIcon,fxFactionBackGround;

    // 数值变化就同步
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
       PVELevel, PVEexp,
       fxCurrExp, fxKills, fxDeaths,PlayerHealth,bFemale,
       bHeadKill, bAutoAimKill, fxExp_netbar, netbar_level, fxGameCash_Netbar,
       bDeadStatus, fxLevel, fxTransPigNum, fxContribution, fxShowCredit, fxShowWinExp,
       fxPropBonusFactor, fxExtraExp,
       bVipBonus, bNetBarBonus, bPropBonus,
       fxHeadKillNum, fxSpecKillNum, fxDaggerKillNum,
       fxPlayerDBID, KFXTotalSPoint,
       KFXIndividualGrade,
       KFXVoiceFont,
       bKFXSpatial,
       bfxHanging,KFXVIP, KFXFastOccupyFactor, fxHeadKillExpCard,
	   fxWinSpoint,fxLostSpoint, fxRestartCardTime, fxFastSwitchAmmoRate,
	   bKFXHasFactionBadge, fxWeaponKillRep, fxMultiKillRep, fxKillBots,
	   fxKillSpecialTeam,fxKillsInGhostState,fxKillsInCorpseState,fxKillCorpseCount, nRealIDLastKillMe, fxProjectileKillNum, PlayerRewardTime,
	   PlayerRewardCount, fxCurrWeaponID,bSuperState,bSpectatorView, fxPlayerDomain,fxRoleGUID,ACEWeapon,fxKillBlood,fxAttackBloodOnce,PlayerGameType,bIsRedTeam;
	reliable if(Role < ROLE_Authority)
		SetPlayerDomain;
    unreliable if( bNetDirty && (Role == ROLE_Authority) )
        bKFXTeamTalk, KFXTalkVolume, fxCurMultiKillCount;

//    // 只同步给自己
     reliable if ( bNetDirty && (Role == ROLE_Authority) && bNetOwner )
       fxGameCash, BeHitedListHUD, HitOtherListHUD,fxTeamMatchFactor;

		reliable if(Role == ROLE_Authority)
			ClientSetGuanScore;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// 初始化相关数组
	InitRepArray(REP_VALUE, 0, 0, 0, REPVALUE_COUNT);
	//低十二位存fxWeaponKill击杀总数，高20位作为武器位,每个信息5位，共4个预存
	InitRepArray(REP_WEAPONKILL, 12, 5, 4, WEAPONKILL_COUNT);
	//低八位存fxMultiKill总数，高24位作为连杀位，每个信息4位，共6个预存
	InitRepArray(REP_MULTIKILL, 8, 4, 6, MULTIKILL_COUNT);

    /*
	if ( UnrealMPGameInfo(Level.Game) != None )
		LocalStatsScreenClass = UnrealMPGameInfo(Level.Game).LocalStatsScreenClass;
	*/
}

//
// 初始化相关同步数组
//
simulated function InitRepArray(int id, byte bits1, byte bits2, byte bits3, byte len)
{
	local int i;
	fxRepArray[id].bits[0] = bits1;
    fxRepArray[id].bits[1] = bits2;
    fxRepArray[id].bits[2] = bits3;
    for(i=0; i<len; i++)
    {
    	fxRepArray[id].arrData[i] = 0;
	}
}

///
///解析同步信息
///
simulated event PostNetReceive()
{
	UpdateRepValue(); // 刷新同步值对应REP_VALUE数组信息
	UpdateRepArray(); //刷新（伪）同步数组
}

simulated function UpdateRepValue()
{
	local int i;

    ;
    ;
    // 保留2秒内同步改变信息
	for(i = fxChangedRepValues.Length-1; i >= 0; i--)
	{
		//LOG("fxChangedRepValues[i].timeSecond:"$fxChangedRepValues[i].timeSecond);
		if(Level.TimeSeconds - fxChangedRepValues[i].timeSecond >= 2)
		{
			;
			fxChangedRepValues.Remove(0, i+1);
			break;
		}
	}
	CheckRepValue(PlayerHealth, 	REP_VALUE, REPVALUE_PLAYERHEALTH);  ///<玩家血量
	CheckRepValue(fxKills, 			REP_VALUE, REPVALUE_KILL);  	///<击杀次数 fxKills
	CheckRepValue(fxDeaths, 		REP_VALUE, REPVALUE_DEATH);    	///<被杀次数 fxDeaths
	CheckRepValue(fxHeadKillNum, 	REP_VALUE, REPVALUE_HEADKILL);  ///<爆头杀次数 fxHeadKillNum
	CheckRepValue(fxDaggerKillNum, 	REP_VALUE, REPVALUE_KNIFEKILL); ///<刀杀次数 fxDaggerKillNum
	CheckRepValue(fxSpecKillNum, 	REP_VALUE, REPVALUE_SPEKILL);   ///<特殊击杀数 fxSpecKillNum
	CheckRepValue(fxKillBots, 		REP_VALUE, REPVALUE_KILLBOT);   ///<杀bot数量 fxKillBots
	CheckRepValue(fxKillSpecialTeam, REP_VALUE, REPVALUE_KILLSPETEAM); ///<杀特殊队伍数量 fxKillSpecialTeam
	CheckRepValue(fxKillsInGhostState, 	REP_VALUE, REPVALUE_MODEVALUE4);   ///<
	CheckRepValue(fxKillsInCorpseState, 	REP_VALUE, REPVALUE_MODEVALUE5);   ///<
	CheckRepValue(fxKillCorpseCount, 	REP_VALUE, REPVALUE_MODEVALUE6);   ///<
}

///
/// 处理同步数据相关客户端刷新
///
simulated function CheckRepValue(int repValue, int value1, int value2)
{
	local SChangedRep tempChange;
	local int i, tempLen;
	tempChange.value1 = value1;
	tempChange.timeSecond = Level.TimeSeconds;
	tempLen = fxChangedRepValues.Length;

	if(repValue != fxRepArray[value1].arrData[value2])
	{
		;
		fxRepArray[value1].arrData[value2] = repValue;
		tempChange.value2 = value2;

		for(i = tempLen-1; i >= 0; i--)        // 去除之前相关项
		{
			if(fxChangedRepValues[i].value1 == tempChange.value1 &&
				fxChangedRepValues[i].value2 == tempChange.value2)
			{
				fxChangedRepValues.Remove(i, 1);
			}
		}
		fxChangedRepValues[fxChangedRepValues.Length] = tempChange;
	}
}

///
///钟：根据同步值刷新同步数组
///
simulated function UpdateRepArray()
{
	local bool check;

	// 刷新fxWeaponKill信息
	if(fxWeaponKillRep != fxLastWeaponKillRep)
	{
		check = true;
		//低十二位存fxWeaponKill击杀总数，高20位作为武器位,每个信息5位，共4个预存
        OperateReplicatedValue(fxLastWeaponKillRep, fxWeaponKillRep, REP_WEAPONKILL);
	}
	// 刷新fxMultiKill信息
	if(fxMultiKillRep != fxLastMultiKillRep)
	{
		check = true;
		//低八位存fxMultiKill总数，高24位作为连杀位，每个信息4位，共6个预存
		OperateReplicatedValue(fxLastMultiKillRep, fxMultiKillRep, REP_MULTIKILL);
	}

	if(check)
	{
		LogRepInfo();
	}
}

///
/// 钟：根据同步信息的位对相关数组进行刷新
///
simulated function OperateReplicatedValue(out int lastValue, int curValue, int repArrID)
{
	local int delta, oldCount, newCount, i, info, tempInfo, lastLen;
	local SChangedRep tempChange;
	local SReplicateArray repArr;

	repArr = fxRepArray[repArrID];

	oldCount = GetBits(lastValue, 0, repArr.bits[0]);
	newCount = GetBits(curValue, 0, repArr.bits[0]);
	delta = newCount - oldCount;
    lastLen = fxChangedRepValues.Length;
    tempChange.value1 = repArrID;
	tempChange.timeSecond = Level.TimeSeconds;
	if(delta > 0)
	{
		info = GetBits(curValue, repArr.bits[0], 32-repArr.bits[0]);
		if(delta <= repArr.bits[2])
		{
			for(i=0; i<delta; i++)
			{
				tempInfo = GetBits(info, repArr.bits[1]*i, repArr.bits[1]);
				CheckRepValue(repArr.arrData[tempInfo]+1, repArrID, tempInfo);
			}
		}
		else
		{
			tempInfo = GetBits(info, 0, repArr.bits[1]);
			// 数字相差太多则增加最近类的数量
			CheckRepValue(repArr.arrData[tempInfo]+delta, repArrID, tempInfo);
		}
		lastValue = curValue;
	}
}


///
/// 打印（伪）同步数组信息
///
simulated function LogRepInfo()
{
	local int i, j;
	for(i=0; i<REP_COUNT; i++)
	{
		for(j=0; j<fxRepArray[i].arrData.Length; j++)
		{
			//LOG("+++++i:"$i$" j"$j$" data:"$fxRepArray[i].arrData[j]);
		}
	}

	for(i=0; i<fxChangedRepValues.length; i++)
	{
		;
		;
		;
	}
}


simulated function UpdateWeaponStats(KFXTeamPlayerReplicationInfo PRI, class<Weapon> W, int newKills, int newDeaths, int newDeathsHolding)
{
	local int i;
	local WeaponStats NewWeaponStats;

	for ( i=0; i<WeaponStatsArray.Length; i++ )
	{
		if ( WeaponStatsArray[i].WeaponClass == W )
		{
			WeaponStatsArray[i].Kills = newKills;
			WeaponStatsArray[i].Deaths = newDeaths;
			WeaponStatsArray[i].DeathsHolding = newDeathsHolding;
			return;
		}
	}

	NewWeaponStats.WeaponClass = W;
	NewWeaponStats.Kills = newKills;
	NewWeaponStats.Deaths = newDeaths;
	NewWeaponStats.DeathsHolding = newDeathsHolding;
	WeaponStatsArray[WeaponStatsArray.Length] = NewWeaponStats;
}

function AddWeaponDeathHolding(class<Weapon> W)
{
	local int i;
	local WeaponStats NewWeaponStats;

	for ( i=0; i<WeaponStatsArray.Length; i++ )
	{
		if ( WeaponStatsArray[i].WeaponClass == W )
		{
			WeaponStatsArray[i].DeathsHolding++;
			return;
		}
	}

	NewWeaponStats.WeaponClass = W;
	NewWeaponStats.DeathsHolding = 1;
	WeaponStatsArray[WeaponStatsArray.Length] = NewWeaponStats;
}

simulated function UpdateVehicleStats(KFXTeamPlayerReplicationInfo PRI, class<Vehicle> V, int newKills, int newDeaths, int newDeathsDriving)
{
	local int i;
	local VehicleStats NewVehicleStats;

	for (i = 0; i < VehicleStatsArray.Length; i++)
		if (VehicleStatsArray[i].VehicleClass == V)
		{
			VehicleStatsArray[i].Kills = newKills;
			VehicleStatsArray[i].Deaths = newDeaths;
			VehicleStatsArray[i].DeathsDriving = newDeathsDriving;
			return;
		}

	NewVehicleStats.VehicleClass = V;
	NewVehicleStats.Kills = newKills;
	NewVehicleStats.Deaths = newDeaths;
	NewVehicleStats.DeathsDriving = newDeathsDriving;
	VehicleStatsArray[VehicleStatsArray.Length] = NewVehicleStats;
}

/*
function AddVehicleKill(class<VehicleDamageType> D)
{
	local class<Vehicle> V;
	local int i;
	local VehicleStats NewVehicleStats;

	V = D.default.VehicleClass;
	if (V == None)
		return;

	for (i = 0; i < VehicleStatsArray.Length; i++)
		if (VehicleStatsArray[i].VehicleClass == V)
		{
			VehicleStatsArray[i].Kills++;
			return;
		}

	NewVehicleStats.VehicleClass = V;
	NewVehicleStats.Kills = 1;
	VehicleStatsArray[VehicleStatsArray.Length] = NewVehicleStats;
}
*/
/*
function AddVehicleDeath(class<DamageType> D)
{
	local class<Vehicle> V;
	local int i;
	local VehicleStats NewVehicleStats;

	if (class<VehicleDamageType>(D) == None)
		return;

	V = class<VehicleDamageType>(D).default.VehicleClass;
	if (V == None)
		return;

	for (i = 0; i < VehicleStatsArray.Length; i++)
		if (VehicleStatsArray[i].VehicleClass == V)
		{
			VehicleStatsArray[i].Deaths++;
			return;
		}

	NewVehicleStats.VehicleClass = V;
	NewVehicleStats.Deaths = 1;
	VehicleStatsArray[VehicleStatsArray.Length] = NewVehicleStats;
}

function AddVehicleDeathDriving(class<Vehicle> V)
{
	local int i;
	local VehicleStats NewVehicleStats;

	for (i = 0; i < VehicleStatsArray.Length; i++)
		if (VehicleStatsArray[i].VehicleClass == V)
		{
			VehicleStatsArray[i].DeathsDriving++;
			return;
		}

	NewVehicleStats.VehicleClass = V;
	NewVehicleStats.DeathsDriving = 1;
	VehicleStatsArray[VehicleStatsArray.Length] = NewVehicleStats;
}
*/

simulated function UpdatePrecacheMaterials()
{
	if ( CharacterName == "" )
		return;
	/*
    rec = class'xUtil'.static.FindPlayerRecord(CharacterName);
	if ( rec.Species != None )
	{
		if ( Team == None )
			rec.Species.static.LoadResources(rec, Level,self,255);
		else
			rec.Species.static.LoadResources(rec, Level,self,Team.TeamIndex);
	}
	*/
}

simulated function SetCharacterName(string S)
{
	Super.SetCharacterName(S);
	UpdateCharacter();
}


simulated event UpdateCharacter()
{
    //Rec = class'xUtil'.static.FindPlayerRecord(CharacterName);
}

simulated function material GetPortrait()
{
    /*
	if ( Rec.Portrait == None )
		return Material(DynamicLoadObject("PlayerPictures.cDefault", class'Material'));
	return Rec.Portrait;
	*/
	return none;
}
//-----------判断队伍信息---对换队功能的实现------接口要统一----

simulated function bool IsRedTeam()
{
    local int ChangeTeamCont;
	if(KFXGameReplicationInfo(Level.GRI) == none)
		return false;
    if (Team == none)
    {
    	return false;
    }


    ChangeTeamCont = KFXGameReplicationInfo(Level.GRI).fxChangeTeamCount;
    if( ChangeTeamCont%2 == 0 )
    {
        return ( Team.TeamIndex == 1 );
    }
    else
    {
        return ( Team.TeamIndex == 0 );
    }
}

simulated function bool IsBlueTeam()
{
    local int ChangeTeamCont;
	if(KFXGameReplicationInfo(Level.GRI) == none)
		return false;
    if (Team == none)
    {
    	return false;
    }


    ChangeTeamCont = KFXGameReplicationInfo(Level.GRI).fxChangeTeamCount;
    if( ChangeTeamCont%2 == 0 )
    {
        return ( Team.TeamIndex == 0 );
    }
    else
    {
        return ( Team.TeamIndex == 1 );
    }
}

simulated function bool IsTeamChanging()
{
	//如果是奇数，那么表示队伍已经换队了
	return (KFXGameReplicationInfo(Level.GRI).fxChangeTeamCount % 2 == 1);
}

simulated function int GetMyTeamIndex()
{
	//正常是返回Team.TeamIndex，
	//如果是换队的，那么就得相反的
	return (Team.TeamIndex + KFXGameReplicationInfo(Level.GRI).fxChangeTeamCount)%2;
}
simulated function int GetOtherTeamIndex()
{
	return (Team.TeamIndex + 1 + KFXGameReplicationInfo(Level.GRI).fxChangeTeamCount)%2;
}

simulated function bool IsGrayTeam()
{
    return ( Team == none || Team.TeamIndex == 255 );
}

//---------------------------------------------------------------

// 更新击杀别人的信息，被击杀者如果是红队的，那么特殊
function int CheckHitHP(int hithp, bool behited_isred)
{
	//vip模式下，红队队友是100滴血
	if(behited_isred && hithp > 100)
		return 100;
	else if(!behited_isred && hithp > 100)
		return 100;
	else
		return hithp;
}
function UpdateHitOtherList(bool bHeadKill, int HitHP, PlayerReplicationInfo PRI, bool bDead)
{
	local int index;
	local int find;		//是否找到那个人，找到了
	local int tmpHeadKill, tmpHitHP, tmpOtherLevel;
	local byte tmpbOld, tmpbShootdown;
	local string tmpOtherName;

	if (PRI.PlayerName == "")
	{
		return;
	}
	find = -1;
	for (index = 0; index < HitCollect_CNT; index++)
	{
		if(HitOtherList.OtherName[index] == "")
			break;
		if (HitOtherList.bOld[index] == 0 && HitOtherList.OtherName[index] == PRI.PlayerName)
		{
       		HitOtherList.HitHP[index] += HitHP;
			HitOtherList.bOld[index] = 0;
			HitOtherList.HitHP[index] = CheckHitHP(HitOtherList.HitHP[index], KFXPlayerReplicationInfo(PRI).IsRedTeam());
			HitOtherList.bShootDown[index] = byte(bDead);
			if(bDead && bHeadKill)
			{
				HitOtherList.bHeadKill[index] = 1;
			}
			else
			{
				HitOtherList.bHeadKill[index] = 0;
			}
			HitOtherList.OtherLevel[index] = KFXPlayerReplicationInfo(PRI).fxLevel;
			find = index;
			break;
		}
	}
	if(find == -1)
	{
		//如果没找到，那么就添加一个。
		if(index > HitCollect_CNT-1)
			index = HitCollect_CNT-1;
		HitOtherList.OtherName[index] = PRI.PlayerName;
		HitOtherList.HitHP[index] = HitHP;
		HitOtherList.bOld[index] = 0;
		HitOtherList.HitHP[index] =
				CheckHitHP(HitOtherList.HitHP[index], KFXPlayerReplicationInfo(PRI).IsRedTeam());
		HitOtherList.bShootDown[index] = byte(bDead);
		if(bDead && bHeadKill)
		{
			HitOtherList.bHeadKill[index] = 1;
		}
		else
		{
			HitOtherList.bHeadKill[index] = 0;
		}
		HitOtherList.OtherLevel[index] = KFXPlayerReplicationInfo(PRI).fxLevel;
		find = index;
	}

	//将找到的这个信息提前，其他的顺延
	tmpHeadKill = HitOtherList.bHeadKill[find];
	tmpbOld = HitOtherList.bOld[find];
	tmpHitHP = HitOtherList.HitHP[find];
	tmpOtherName = HitOtherList.OtherName[find];
	tmpOtherLevel = HitOtherList.OtherLevel[find];
	tmpbShootdown = HitOtherList.bShootDown[find];
	for (index = find; index > 0; index--)
	{
		HitOtherList.bHeadKill[index] = HitOtherList.bHeadKill[index-1];
		HitOtherList.bOld[index] = HitOtherList.bOld[index-1];
		HitOtherList.HitHP[index] = HitOtherList.HitHP[index-1];
		HitOtherList.OtherName[index] = HitOtherList.OtherName[index-1];
		HitOtherList.OtherLevel[index] = HitOtherList.OtherLevel[index-1];
		HitOtherList.bShootDown[index] = HitOtherList.bShootDown[index-1];
	}
	HitOtherList.bHeadKill[0] = tmpHeadKill;
	HitOtherList.bOld[0] = tmpbOld;
	HitOtherList.HitHP[0] = tmpHitHP;
	HitOtherList.OtherName[0] = tmpOtherName;
	HitOtherList.OtherLevel[0] = tmpOtherLevel;
	HitOtherList.bShootDown[0] = tmpbShootdown;

	for (index = 0; index < HitCollect_CNT; index++)
	{
		if(HitOtherList.OtherName[index] != "")
		{

		}
	}


}

function UpdateDeadHitInfo(PlayerReplicationInfo PRI)
{
	local int index;
	for (index = 0; index < HitCollect_CNT; index++)
	{
		if (HitOtherList.OtherName[index] == PRI.PlayerName)
		{
			HitOtherList.bOld[index] = 1;
			break;
		}
	}

	for (index = 0; index < HitCollect_CNT; index++)
	{
		if (BeHitedList.HiterName[index] == PRI.PlayerName)
		{
			BeHitedList.bOld[index] = 1;
			break;
		}
	}
}

function UpdatePlayerLeaveCombatInfo(array<PlayerReplicationInfo> PRIArray)
{
	local int i, j;
	local bool bLeave;

	for (i = 0; i < HitCollect_CNT; i++)
	{
		bLeave = false;
		if (HitOtherList.OtherName[i] != "")
		{
			bLeave = true;
			for (j = 0; j < PRIArray.length; j++)
			{
            	if (PRIArray[j].PlayerName == HitOtherList.OtherName[i])
            	{
            		bLeave = false;
            		break;
            	}
			}
		}

		if (bLeave)
		{
			HitOtherList.OtherName[i] = "";
			HitOtherList.bOld[i] = byte(false);
			break;
		}
	}


	for (i = 0; i < HitCollect_CNT; i++)
	{
		bLeave = false;
		if (BeHitedList.HiterName[i] != "")
		{
			bLeave = true;
			for (j = 0; j < PRIArray.length; j++)
			{
            	if (PRIArray[j].PlayerName == BeHitedList.HiterName[i])
            	{
            		bLeave = false;
            		break;
            	}
			}
		}

		if (bLeave)
		{
			BeHitedList.HiterName[i] = "";
			BeHitedList.bOld[i] = byte(false);
			break;
		}
	}

}

function UpdateBeHitedList(bool bHeadKill,
	int HitHP,
	PlayerReplicationInfo PRI,
	bool bShootDown,
	int WeapID
)
{
	local int index;
	local int find;		//是否找到那个人，找到了
	local int tmpHeadKill, tmpHitHP, tmpOtherLevel, tmpWeapID;
	local byte tmpbOld, tmpbShootdown;
	local string tmpOtherName;

    if (PRI.PlayerName == "")
	{
		return;
	}
    find = -1;
	for (index = 0; index < HitCollect_CNT; index++)
	{
		if(BeHitedList.HiterName[index] == "")
			break;
		if (BeHitedList.HiterName[index] == PRI.PlayerName)
		{
			BeHitedList.HitHP[index] += HitHP;
			BeHitedList.HitHP[index] =
					CheckHitHP(BeHitedList.HitHP[index], IsRedTeam());
			if(bShootDown)
				BeHitedList.bShootDown[index] = 1;
			else
				BeHitedList.bShootDown[index] = 0;
			if (bShootDown && bHeadKill)
			{
				BeHitedList.bHeadKill[index] = 1;
			}
			else
			{
				BeHitedList.bHeadKill[index] = 0;
			}
			find = index;
			break;
		}
	}

	if (find == -1)
	{
		if(index>HitCollect_CNT-1)
		{
			index = HitCollect_CNT-1;
		}
		BeHitedList.HiterName[index] = PRI.PlayerName;
		BeHitedList.HitHP[index] = HitHP;
		BeHitedList.HitHP[index] =
				CheckHitHP(BeHitedList.HitHP[index], IsRedTeam());
		BeHitedList.bOld[index] = 0;
		if(bShootDown)
			BeHitedList.bShootDown[index] = 1;
		else
			BeHitedList.bShootDown[index] = 0;
		if (bShootDown && bHeadKill)
		{
			BeHitedList.bHeadKill[index] = 1;
		}
		else
		{
			BeHitedList.bHeadKill[index] = 0;
		}
		BeHitedList.HiterLevel[index] = KFXPlayerReplicationInfo(PRI).fxLevel;
		BeHitedList.HitWeapID[index] = WeapID;

		find = index;
	}
	//将找到的这个信息提前，其他的顺延
	tmpHeadKill = BeHitedList.bHeadKill[find];
	tmpbOld = BeHitedList.bOld[find];
	tmpHitHP = BeHitedList.HitHP[find];
	tmpOtherName = BeHitedList.HiterName[find];
	tmpOtherLevel = BeHitedList.HiterLevel[find];
	tmpWeapID = BeHitedList.HitWeapID[find];
	tmpbShootdown = BeHitedList.bShootDown[find];
	for (index = find; index > 0; index--)
	{
		BeHitedList.bHeadKill[index] = BeHitedList.bHeadKill[index-1];
		BeHitedList.bOld[index] = BeHitedList.bOld[index-1];
		BeHitedList.HitHP[index] = BeHitedList.HitHP[index-1];
		BeHitedList.HiterName[index] = BeHitedList.HiterName[index-1];
		BeHitedList.HiterLevel[index] = BeHitedList.HiterLevel[index-1];
		BeHitedList.HitWeapID[index] = BeHitedList.HitWeapID[index-1];
		BeHitedList.bShootDown[index] = BeHitedList.bShootDown[index-1];
	}
	BeHitedList.bHeadKill[0] = tmpHeadKill;
	BeHitedList.bOld[0] = tmpbOld;
	BeHitedList.HitHP[0] = tmpHitHP;
	BeHitedList.HiterName[0] = tmpOtherName;
	BeHitedList.HiterLevel[0] = tmpOtherLevel;
	BeHitedList.HitWeapID[0] = tmpWeapID;
	BeHitedList.bShootDown[0] = tmpbShootdown;


	for (index = 0; index < HitCollect_CNT; index++)
	{
		if(BeHitedList.HiterName[index] != "")
		{

		}
	}

	//记录一下谁杀死了我
	if(bShootDown)
	{
	 	for(index = 0; index < killedmes.length; index++)
	 	{
			if(killedmes[index].playerid == KFXPlayerReplicationInfo(PRI).fxPlayerDBID)
			{
				killedmes[index].counter++;
				break;
			}
		}
		if(index == KilledMes.Length)
		{
			KilledMes.Insert(index, 1);
			killedMes[index].playerid = KFXPlayerReplicationInfo(PRI).fxPlayerDBID;
			killedMes[index].counter++;
		}
	}
}
function int GetWhoKilledMeMost()
{
	local int index, maxIndex;
	local int miniCount;

	maxIndex = 0;
	if(maxIndex >= KilledMes.length)
		return 0;
 	for(index = maxIndex+1; index < killedmes.length; index++)
 	{
 		if(killedmes[index].counter > killedmes[maxIndex].counter)
 		{
			maxIndex = index;
		}
	}
	miniCount = KFXGameReplicationInfo(Level.GRI).MiniKilledMeCount;
	if(miniCount == 0)
		miniCount = 1;
	if(KilledMes[maxIndex].counter < miniCount)
	    return 0;
	return KilledMes[maxIndex].playerid;
}

function TransCombatInfo()
{
	local int index;

	ResetCombatInfo(BeHitedListHUD, HitOtherListHUD);
	BeHitedListHUD = BeHitedList;
	HitOtherListHUD = HitOtherList;
	for (index = 0; index < HitCollect_CNT; index++)
	{
		if(BeHitedListHUD.HiterName[index] != "")
		{

		}
	}

	for (index = 0; index < HitCollect_CNT; index++)
	{
		if(HitOtherListHUD.OtherName[index] != "")
		{

		}
	}

	ResetCombatInfo(BeHitedList, HitOtherList);
}


function ResetCombatInfo(
	out BeHitedCollect BeHited,
	out HitOtherCollect HitOther
)
{
	local int index;
	for (index = 0; index < HitCollect_CNT; index++)
	{
		BeHited.HiterName[index] = "";
		BeHited.HiterLevel[index] = 0;
		BeHited.bHeadKill[index] = 0;
		BeHited.HitHP[index] = 0;
		BeHited.HitWeapID[index] = 0;
		BeHited.bOld[index] = 0;
		BeHited.bShootDown[index] = 0;

		HitOther.bHeadKill[index] = byte(false);
		HitOther.bOld[index] = 0;
		HitOther.HitHP[index] = 0;
		HitOther.OtherName[index] = "";
		HitOther.OtherLevel[index] = 0;
		HitOther.bShootDown[index] = byte(false);
	}
}
function SetPlayerDomain(byte PlayerDomain)
{
	fxPlayerDomain = PlayerDomain;
}

simulated function ClientSetGuanScore(int score, int TotalScore)
{
	GuanScore = score;
	TotalGuanScore = TotalScore;
	log("[LABOR]-----------ClientSetGuanScore:"$Score@TotalScore);
	Level.GetLocalPlayerController().Player.GUIController.SetHUDData_SetPlayerScore(
				fxPlayerDBID, GuanScore, TotalGuanScore);
}
//client&server
simulated function SetGuanScore(int score, int TotalScore)
{
	GuanScore = score;
	TotalGuanScore = TotalScore;
	ClientSetGuanScore(score, TotalScore);
}
//没得到一分，就执行这个函数
simulated function AddGuanScore(int score, int type)
{
	log("[LABOR] -----------add guan score="$score
				@" type="$type);
    SetGuanScore(GuanScore+score, TotalGuanScore);
}

defaultproperties
{
     fxHeadKillSpecial=1.000000
     fxFastSwitchAmmoRate=1.000000
     nRealIDLastKillMe=-1
     fxTestGodLastTime=10.000000
     fxTestHideLastTime=10.000000
     fxTestScaleLastTime=10.000000
     PVELevel=-1
     ClientPveLevel=-1
     LevelDmgFactor=1.000000
     VoiceType=Class'KFXGame.KFXVoicePack'
}
