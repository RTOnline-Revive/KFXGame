class KFXPlayerReplicationInfo extends TeamPlayerReplicationInfo;

//var xUtil.PlayerRecord Rec;

var bool bForceNoPlayerLights;  // OBSOLETE
var bool bNoTeamSkins; //OBSOLETE

// Edit By lwg
//�Ƶ�������
//var class<Scoreboard> LocalStatsScreenClass;
//var SquadAI Squad;
//var bool bHolding;

// following properties are used for server-side local stats gathering and not replicated (except through replicated functions)

// Edit By lwg
//�Ƶ�������
//var bool bFirstBlood;

struct KFXHangingInfo
{
    var float   fxHangingExp;           // ����ֵ
    var float   fxHangingCash;          // ��Ϸ��
    var float   fxHangingSPoint;        // ����
    var float   fxLastUpdateSec;        // ��һ�θ���ʱ��

    var float   fxHangingExpSpeed;      // �һ�����ֵ����
    var float   fxHangingCashSpeed;     // �һ���Ϸ������
    var float   fxHangingSPointSpeed;   // �һ���������
};

// Edit By lwg
//�Ƶ�������
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
//�Ƶ�������
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
// add by zjpwxh@kingsoft �Ž�Ʒ
//--------------------------------------------------
//var int     fxCurrCredit;       // ��ǰ����   //����û�����ˣ�wangkai
var int  StaticEXPWithNoAdditional;//δ�����εľ���ֵ���ݣ��������߰��㾭��ļӳ�Ӱ�죩
var int     fxCurrExp;          // ��ǰ����
var int		fxExp_netbar;	//���ɵľ���ӳ�
var int     fxKills;            // ɱ����
var int     fxDeaths;           // ������
var int     fxHeadKillNum;      // ��ͷ��
var int     fxSpecKillNum;      // ɱ����
var int     fxDaggerKillNum;    // ��ɱ��
var int     fxProjectileKillNum; //Ͷ���������Ļ�ɱ��
var bool    bSuperState;        // �Ƿ�����޵�״̬
var float   fxDeadTime;         // ����ʱ��
var float   fxClientDeadTime;   // ����ʱ��(�ͻ��˼�¼)
var bool    bHeadKill;          // �Ƿ�ͷ
var bool    bAutoAimKill;       // �Զ���ͷ
var bool    bDeadStatus;        // �Ƿ�����״̬
var int     fxGameResult;       // ��Ϸ���
var bool    bSpecMode;          // �����˺�ģʽ
var vector  fxLocation;         // �ͻ���λ��
var float   fxRestartTime;      // ����ʱ��
var bool    bSpeechState;       // �꺰��״̬
var bool    bLevelup;           // �Ƿ�����
var int     fxLevel;            // ����ȼ�
var float   fxLoginTime;        // ��½ʱ��
var int     fxTransPigNum;      // ������
var int     fxContribution;     // ���׶�
var int     fxShowCredit;       // �ͻ�����ʾ����
var int     fxShowWinExp;       // �ͻ�����ʾӮ����������
var float   fxPropBonusFactor;	// ����Ӱ�������������
var int     fxExtraExp;         // ���⽱��
var float   fxGameCashFinalFactor;//��Ϸ�����յ���ϵ������ҵ��ߣ�
var bool    bVipBonus;
var bool    bNetBarBonus;
var bool    bPropBonus;
var int     PlayerHealth;
var int     PlayerRewardTime;       //�ͽ�ģʽ�µ����ͨ��ʱ��
var int     PlayerRewardCount;      //�ͽ�ģʽ�µ����ɱ������
var bool    bfxHanging;             // �Ƿ�һ�
var KFXHangingInfo fxHangingInfo;   // �һ���Ϣ
var byte	fxPlayerDomain;			//������ڵ�����

var int     PlayerGameType;       //��Ϸ���ͣ���ͨ��ս�ӣ��羺
var int     fxGameCash;         // ��õ���Ϸ��
var int		fxGameCash_Netbar;	//���ɼӳɵ���Ϸ��
var float   fxTeamMatchFactor;  //ս�ӳ�Ա�ӳ� ����
var int     fxPlayerDBID;       //��������ݿ������ΨһID
var byte	ACEOrder;			//��ҵ�ace������1��ʾ��һ����

//--------------------------------------------------
// **TeamInfo�е�ScoreĿǰ������ʾ���������
//--------------------------------------------------

//<<����ϵͳ        ChenJianye
var int     KFXKillMeCount;
var int     KFXKilledByMeCount;
//>>

//<< Dolby Voice��ر���
// ��������������0 if not taling, indicative volume 1-255 if player is talking
var byte    KFXTalkVolume;      //�ɷ�����ͬ�����ͻ���
var bool    bKFXTeamTalk;       //��ʶ�Ƿ������ö�������
var bool    bKFXMute;           //��ʶ�Ƿ�����, client only
//����
var byte    KFXVoiceFont;       //װ������VoiceFont
var byte    KFXCurVoiceFont;    //��ǰ������VoiceFont, client only
var bool    bKFXSpatial;        //�Ƿ�ʹ��3D������
var bool    bKFXHeadKill;           // �Ƿ�װ����ͷ��
var bool    bKFXHeadKillResist;     // �Ƿ�װ������ͷ��
var bool    bKFXAnimalResist;       // �����ױ�����
//>>

var float   KFXFastOccupyFactor;      // ����ռ�쿨��ռ����ٵ�ʱ��

var int     KFXTotalSPoint;     //�ܵĻ�������ת�����˶�Ա�ƺ�
var int     KFXIndividualGrade;  //��������
var int     KFXVIP;            //�Ƿ��ǻ�Ա

var int TimeNeedChangeWeapBegin;


var string fxBattleTeamName;              //ս������
var int fxBattleTeamID;                   //ս��id
var int fxWinnerTeamID;                   //ʤ����ս��id
var int fxWinSpoint;                      //ʤ��ս�ӵ÷�
var int fxLostSpoint;                     //ʧ��ս�ӵ÷�
var int fxFactionIcon;
var int fxFactionBackGround;

///��Ϸ�ڻ�õ���Ʒ
var array<int> fxItemList;
var int     fxKillBots;            		///< ɱbot��
var int fxKillSpecialTeam;				///< ��ɱ��������� ���飬ľ����
var int fxKillsInGhostState;            ///������״̬��ɱ����
var int fxKillsInCorpseState;           ///�ڽ�ʬ״̬��ɱ��
var int fxKillCorpseCount;              //ɱ����ʬ��

var float fxHeadKillSpecial;			///<��ͷ��þ���ֵ����
var bool fxHeadKillExpCard;				///<�Ƿ�װ����ͷ����ֵ��Ƭ
var float fxRestartCardTime;				///<װ������ʱ����ٿ��Ĳ���
var float fxFastSwitchAmmoRate;         ///<װ�����ٻ��������ٱ���

var bool bKFXHasFactionBadge;


///<ͬ������ṹ���壬ʹ�ý���ͬ��
struct SReplicateArray
{
	var byte bits[3];
	var array<int> arrData;
};

const REP_VALUE			= 0;                ///<��ʶ���е�ͬ��ֵ
const REP_WEAPONKILL 	= 1;                ///<������ɱ
const REP_MULTIKILL		= 2;                ///<��ɱ
const REP_COUNT			= 3;
var array<SReplicateArray> fxRepArray[REP_COUNT]; 	///<��α��ͬ������

var int fxWeaponKillRep;					///<ͬ�����
var int fxLastWeaponKillRep;				///<������
var int fxMultiKillRep;						///<ͬ�����
var int fxLastMultiKillRep;					///<������
var int nIDLastKillMe;				//��һ����ɱ�Լ����ˣ�����Ҫͬ�����ͻ��˼���
var int nRealIDLastKillMe;

struct SChangedRep
{
	var float timeSecond;   // �ı�ʱ��
	var int value1;			// ��ֵ 1��value
	var int value2;			// ��ֵ 2��value
};
var array<SChangedRep> fxChangedRepValues;	///<�洢�ͻ���һ��ʱ���ڸı�fxRepArray��ʶ

//��������ͬ������
const REPVALUE_KILL			= 0;			///<��ɱ���� fxKills
const REPVALUE_DEATH		= 1;			///<��ɱ���� fxDeaths
const REPVALUE_HEADKILL		= 2;			///<��ͷɱ���� fxHeadKillNum
const REPVALUE_KNIFEKILL	= 3;            ///<��ɱ���� fxDaggerKillNum
const REPVALUE_SPEKILL		= 4;			///<�����ɱ�� fxSpecKillNum
const REPVALUE_FIRSTBLOOD	= 5;			///<��һ��Ѫ����λ�٣��Ժ����չ
const REPVALUE_KILLBOT		= 6;			///<ɱbot����
const REPVALUE_KILLSPETEAM	= 7;			///<ɱ����������� ���� ľ����
const REPVALUE_PLAYERHEALTH = 8;            ///���Ѫ��
const REPVALUE_KILLVIP      = 9;            ///ɱVip����
const REPVALUE_MODEVALUE0	= 16;           ///<ģʽ�����ֵ  ����ģʽ �����
const REPVALUE_MODEVALUE1	= 17;           ///<ģʽ�����ֵ  ����ģʽ �����
const REPVALUE_MODEVALUE2	= 18;           ///<ģʽ�����ֵ  ���������
const REPVALUE_MODEVALUE3	= 19;           ///<ģʽ�����ֵ   VIP���ܴ���
const REPVALUE_MODEVALUE4	= 20;           ///<����״̬��ɱ����
const REPVALUE_MODEVALUE5	= 21;           ///<��ʬ״̬�¸�Ⱦ����
const REPVALUE_MODEVALUE6	= 22;           ///<ɱ����ʬ��
const REPVALUE_MODEVALUE7	= 23;           ///<ģʽ�����ֵ
const REPVALUE_COUNT		= 24;

//����������ɱ
const WEAPONKILL_FIST 		= 0;            ///<ʹ��ȭͷ��ɻ�ɱ��
const WEAPONKILL_SMG 		= 1;    		///<ʹ�ó��ǹ��ɻ�ɱ��
const WEAPONKILL_RIFLE 		= 2;    		///<ʹ��ͻ����ǹ��ɻ�ɱ��
const WEAPONKILL_SNIPER 	= 3;   			///<ʹ�þѻ�ǹ��ɻ�ɱ��
const WEAPONKILL_LMG 		= 4;  			///<ʹ�����ǹ��ɻ�ɱ��
const WEAPONKILL_HMG 		= 5;  			///<ʹ���ػ�ǹ��ɻ�ɱ��
const WEAPONKILL_CANNON 	= 6;  			///<ʹ��������ɻ�ɱ��
const WEAPONKILL_ROCKET 	= 7;   			///<ʹ�û��Ͳ��ɻ�ɱ��
const WEAPONKILL_PISTOL 	= 8;			///<ʹ����ǹ��ɻ�ɱ��
const WEAPONKILL_MELEE 		= 9;    		///<ʹ�ý�ս������ɻ�ɱ��
const WEAPONKILL_SHOTGUN 	= 10;  			///<ʹ��ɢ��ǹ��ɻ�ɱ��
const WEAPONKILL_ASSIST 	= 11;   		///<ʹ�ø�����װ����ɻ�ɱ��
const WEAPONKILL_COUNT		= 12;
//������ɱ
const MULTIKILL_TWO			= 0;			///<����ɱ
const MULTIKILL_THREE		= 1;            ///<����ɱ
const MULTIKILL_FIVE		= 2;            ///<����ɱ
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

// ����ͳ�ƣ�ս��ͳ�ƣ������8����¼
// һ������һ����¼
const HitCollect_CNT = 8;
// ����ͳ�ƣ����б��ˣ�
struct HitOtherCollect
{
	var string OtherName[HitCollect_CNT];
	var byte bHeadKill[HitCollect_CNT];
	var byte bShootDown[HitCollect_CNT];
	var byte bOld[HitCollect_CNT];
	var int HitHP[HitCollect_CNT];
	var int OtherLevel[HitCollect_CNT];
};

// �����˻���
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

// server | client HUD��ʾ
var BeHitedCollect BeHitedListHUD;
var HitOtherCollect HitOtherListHUD;

//��¼��ǰ�������ǹе
var int		fxCurrWeaponID;
var array<KFXKilledMe>		killedmes;

struct WeapAndCompntID
{
    var int weaponID;
    var int CompntID[6];
};

var array<WeapAndCompntID> WeapAndCompntIdList;

var bool bSpectatorView;    //ֱ�ӹ۲���ģʽ����
var float nHonorPointEx;	//����Ҷ���ľ�������
var float nSilverEx;		//����Ҷ������Ϸ������

var float DeadBeginTime;
var bool  bDrawRedDeadFlag;
var bool  bInitedDeadTime;

//����pawn״̬����
var bool bKFXTestGod;					//�޵�״̬��
var float fxTestGodBeginTime;			//�޵�״̬����ʱ��
var float fxTestGodLastTime;			//�޵�״̬����ʱ��
var bool bKFXGodError;					//�޵м��

var bool bKFXTestHide;					//����״̬��
var float fxTestHideBeginTime;			//����״̬����ʱ��
var float fxTestHideLastTime;			//����״̬����ʱ��
var bool bKFXHideError;					//����״̬���

var bool bKFXTestScale;					//����С��
var float fxTestScaleBeginTime;			//����С����ʱ��
var float fxTestScaleLastTime;			//����С����ʱ��
var bool bKFXScaleError;				//����С���
var int  ACEWeapon;

//���ɼӳ���Ϣ
var int	  netbar_level;				//���ɵȼ�
var float exp_netbar_ex;   			//���ɾ���ӳ�
var float silver_netbar_ex;			//�������Ҽӳ�

var int   ActionType[4];            //�����
var float ActionRate[4];            //��ӳ�

var int     fxKillBlood;   // ͳ������򾯲�Ѫ��
var int     fxOldKills;     //��һ�λ�ɱ��
var int     fxOldDeaths;
var int     fxAttackBloodOnce;// һ�ι������˺�Ѫ��
var bool    bBloodIsKills;         //��Ѫֵ�Ƿ����ɱ��
var int     fxPlayerContribution;    //����ڲ���ս�����;�Ӣ��ʱ�������Ի�ù���ֵ��

var                 bool         bIsRedTeam;
var                 bool         bFemale;


//��Ϸ��Farmϵͳ�߼�  sunqiang
var float   DeathsDroppedRate;
var float   KillsDroppedRate;
var int     DroppingKills;
var int     DroppingDeaths;
const MaxDropItemNum = 20;                 //������Ϸ������ĸ���
var int LastDropItem[MaxDropItemNum];     //������Ϸ����Ķ���ID
var int CurDropItemNum;                   //��ǰ��Ϸ����Ķ�������
var float PreDroppedTime;                 //�ϴε���ʱ��

//< PVE����ϵͳ������ͨ��Set�������÷���
enum EGUANSCORE_TYPE		//�����У�ÿ�����ֻ�õķ�ʽ
{
	EGS_None,
	EGS_FromAIDamaged,		//�˺�AI���
	EGS_FromAIKilled,		//ɱ��AI���
	EGS_FromPassGuan,		//ͨ�ػ��
	EGS_FromSpecial,		//�����
	EGS_FromDestroyActor,   //���ټӷ����
};
var int GuanScore;     		//���ػ�����
var int TotalGuanScore;		//�˹�֮ǰ���ܻ������������Feary����


//PVE�ɳ���ϵ
var int PVELevel;                        //��ҵĵȼ����뱾���ֵĻ������Եȼ��޹�
var int ClientPveLevel;                  //�ͻ���δ�õ�����ͬ��֮ǰ�ĵȼ�
var int PVEexp;                          //��Ҿ��飬Ŀǰ������ǲ������Ѿ������ľ���
var int ClientPVEexp;                    //�ͻ���δ�õ�ͬ��֮ǰ����Ҿ���
var float LevelHP;                       //��ҵ�ǰ�ȼ���HP����
var float LevelDmgFactor;                //��ҵ�ǰ�ȼ����˺�ϵ��

replication
{

	// Edit By lwg
    //�Ƶ�������
    //reliable if ( bNetInitial && (Role == ROLE_Authority) )
	//	LocalStatsScreenClass;
	//reliable if ( Role == ROLE_Authority )
	//	/*Squad, */bHolding; //, DareDevilPoints;

	// ֻͬ��һ��
    reliable if ( bNetInitial && (Role == ROLE_Authority) )
        fxDeadTime,fxBattleTeamName,fxBattleTeamID, bKFXHeadKill, fxFactionIcon,fxFactionBackGround;

    // ��ֵ�仯��ͬ��
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

//    // ֻͬ�����Լ�
     reliable if ( bNetDirty && (Role == ROLE_Authority) && bNetOwner )
       fxGameCash, BeHitedListHUD, HitOtherListHUD,fxTeamMatchFactor;

		reliable if(Role == ROLE_Authority)
			ClientSetGuanScore;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// ��ʼ���������
	InitRepArray(REP_VALUE, 0, 0, 0, REPVALUE_COUNT);
	//��ʮ��λ��fxWeaponKill��ɱ��������20λ��Ϊ����λ,ÿ����Ϣ5λ����4��Ԥ��
	InitRepArray(REP_WEAPONKILL, 12, 5, 4, WEAPONKILL_COUNT);
	//�Ͱ�λ��fxMultiKill��������24λ��Ϊ��ɱλ��ÿ����Ϣ4λ����6��Ԥ��
	InitRepArray(REP_MULTIKILL, 8, 4, 6, MULTIKILL_COUNT);

    /*
	if ( UnrealMPGameInfo(Level.Game) != None )
		LocalStatsScreenClass = UnrealMPGameInfo(Level.Game).LocalStatsScreenClass;
	*/
}

//
// ��ʼ�����ͬ������
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
///����ͬ����Ϣ
///
simulated event PostNetReceive()
{
	UpdateRepValue(); // ˢ��ͬ��ֵ��ӦREP_VALUE������Ϣ
	UpdateRepArray(); //ˢ�£�α��ͬ������
}

simulated function UpdateRepValue()
{
	local int i;

    ;
    ;
    // ����2����ͬ���ı���Ϣ
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
	CheckRepValue(PlayerHealth, 	REP_VALUE, REPVALUE_PLAYERHEALTH);  ///<���Ѫ��
	CheckRepValue(fxKills, 			REP_VALUE, REPVALUE_KILL);  	///<��ɱ���� fxKills
	CheckRepValue(fxDeaths, 		REP_VALUE, REPVALUE_DEATH);    	///<��ɱ���� fxDeaths
	CheckRepValue(fxHeadKillNum, 	REP_VALUE, REPVALUE_HEADKILL);  ///<��ͷɱ���� fxHeadKillNum
	CheckRepValue(fxDaggerKillNum, 	REP_VALUE, REPVALUE_KNIFEKILL); ///<��ɱ���� fxDaggerKillNum
	CheckRepValue(fxSpecKillNum, 	REP_VALUE, REPVALUE_SPEKILL);   ///<�����ɱ�� fxSpecKillNum
	CheckRepValue(fxKillBots, 		REP_VALUE, REPVALUE_KILLBOT);   ///<ɱbot���� fxKillBots
	CheckRepValue(fxKillSpecialTeam, REP_VALUE, REPVALUE_KILLSPETEAM); ///<ɱ����������� fxKillSpecialTeam
	CheckRepValue(fxKillsInGhostState, 	REP_VALUE, REPVALUE_MODEVALUE4);   ///<
	CheckRepValue(fxKillsInCorpseState, 	REP_VALUE, REPVALUE_MODEVALUE5);   ///<
	CheckRepValue(fxKillCorpseCount, 	REP_VALUE, REPVALUE_MODEVALUE6);   ///<
}

///
/// ����ͬ��������ؿͻ���ˢ��
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

		for(i = tempLen-1; i >= 0; i--)        // ȥ��֮ǰ�����
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
///�ӣ�����ͬ��ֵˢ��ͬ������
///
simulated function UpdateRepArray()
{
	local bool check;

	// ˢ��fxWeaponKill��Ϣ
	if(fxWeaponKillRep != fxLastWeaponKillRep)
	{
		check = true;
		//��ʮ��λ��fxWeaponKill��ɱ��������20λ��Ϊ����λ,ÿ����Ϣ5λ����4��Ԥ��
        OperateReplicatedValue(fxLastWeaponKillRep, fxWeaponKillRep, REP_WEAPONKILL);
	}
	// ˢ��fxMultiKill��Ϣ
	if(fxMultiKillRep != fxLastMultiKillRep)
	{
		check = true;
		//�Ͱ�λ��fxMultiKill��������24λ��Ϊ��ɱλ��ÿ����Ϣ4λ����6��Ԥ��
		OperateReplicatedValue(fxLastMultiKillRep, fxMultiKillRep, REP_MULTIKILL);
	}

	if(check)
	{
		LogRepInfo();
	}
}

///
/// �ӣ�����ͬ����Ϣ��λ������������ˢ��
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
			// �������̫������������������
			CheckRepValue(repArr.arrData[tempInfo]+delta, repArrID, tempInfo);
		}
		lastValue = curValue;
	}
}


///
/// ��ӡ��α��ͬ��������Ϣ
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
//-----------�ж϶�����Ϣ---�Ի��ӹ��ܵ�ʵ��------�ӿ�Ҫͳһ----

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
	//�������������ô��ʾ�����Ѿ�������
	return (KFXGameReplicationInfo(Level.GRI).fxChangeTeamCount % 2 == 1);
}

simulated function int GetMyTeamIndex()
{
	//�����Ƿ���Team.TeamIndex��
	//����ǻ��ӵģ���ô�͵��෴��
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

// ���»�ɱ���˵���Ϣ������ɱ������Ǻ�ӵģ���ô����
function int CheckHitHP(int hithp, bool behited_isred)
{
	//vipģʽ�£���Ӷ�����100��Ѫ
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
	local int find;		//�Ƿ��ҵ��Ǹ��ˣ��ҵ���
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
		//���û�ҵ�����ô�����һ����
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

	//���ҵ��������Ϣ��ǰ��������˳��
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
	local int find;		//�Ƿ��ҵ��Ǹ��ˣ��ҵ���
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
	//���ҵ��������Ϣ��ǰ��������˳��
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

	//��¼һ��˭ɱ������
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
//û�õ�һ�֣���ִ���������
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
