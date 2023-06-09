class KFXPlayer extends KFXPlayerBase
    config(user);

//---------------------------------------------------------
// - µÀ¾ßÈüÏà¹Ø¶¨Òå

var KFXWeapBase KFXMagicWeap[2];        // µÀ¾ß
var int         KFXMagicWeapIndex;      // µ±Ç°Ê¹ÓÃµÀ¾ßµÄË÷Òý

//<<×Ô¶¯ÓïÒô
var int         KFXVoiceCount;              //×Ô¶¯ÓïÒô¼ÆÊý
var Range       KFXSoundRadius;             //×Ô¶¯ÓïÒôÑ°ÕÒ·¢ÉùÕß·¶Î§
var int         KFXMatchStartCount;         //ÓÎÏ·¿ªÊ¼ÓïÒôÊý,Ã¿¸öÄ£Ê½²»Ò»Ñù
var int         KFXVictoryCount;            //ÓÎÏ·½áÊøÊ¤ÀûÓïÒôÊý
var int         KFXDefeateCount;            //ÓÎÏ·½áÊøÊ§°ÜÓïÒôÊý
var int         KFXDeuceCount;              //ÓÎÏ·½áÊøÆ½¾ÖÓïÒôÊý
var int         KFXVoiceCountB;             //ÓÎÏ·¿ªÊ¼À¶¶ÓÓïÒôÊý,·Ö¶ÓÎé
var int         KFXVoiceCountR;             //ÓÎÏ·¿ªÊ¼ºì¶ÓÓïÒôÊý,·Ö¶ÓÎé
//>>


//×Ô¶¯ÓïÒô
var bool        bChinaVoice;             //ÊÇ·ñÖÐÎÄÓïÒô
var bool        bMaleVoice;              //ÊÇ·ñÄÐÉù
var string      MatchStartVoiceB[10];    //ÓÎÏ·¿ªÊ¼ºìÀ¶¶Ó
var string      MatchStartVoiceR[10];
var int         MatchStartVoiceBNum;    //ÓÎÏ·¿ªÊ¼ÓïÒô¸öÊý
var int         MatchStartVoiceRNum;

var string      VictoryVoice[10];       //Ê¤ÀûÊ§°ÜÓïÒô
var int         VictoryVoiceNum;
var string      DefeatedVoice[10];
var int         DefeatedVoiceNum;

var string      NearVictoryVoice[10];       //ÒªÊ¤ÀûÊ±ÁìÏÈ·½ºÍÂäºó·½ÓïÒô
var int         NearVictoryVoiceNum;
var string      LaggerVoice[10];
var int         LaggerVoiceNum;

var string      FemaleSmokeVoice[3];
var int         FemaleSmokeNum;
var string      FemaleFlashVoice[3];
var int         FemaleFlashNum;
var string      FemaleGrenadeVoice[3];
var int         FemaleGrenadeNum;

var string      MaleSmokeVoice[3];
var int         MaleSmokeNum;
var string      MaleFlashVoice[3];
var int         MaleFlashNum;
var string      MaleGrenadeVoice[3];
var int         MaleGrenadeNum;

var bool        bInitedVoice;               //ÊÇ·ñ³õÊ¼»¯ÓïÒô×ÊÔ´

//±³¾°ÒôÀÖÏà¹Ø
var globalconfig float BGMusicAdjustFactor;       //±³¾°ÒôÀÖÒôÁ¿µ÷½ÚÏµÊý 0--1µÄÖµ
var globalConfig bool BGMusicEnable;             //±³¾°ÒôÀÖ¿ª¹Ø

var int         BGmusicHandle;                //PlayMusic·µ»Ø¾ä±ú£¬È«¾ÖÓÃ
var float       BGMusicVolume;                //ÒôÁ¿
var bool        bLoopPlay;                 //ÊÇ·ñÑ­»·²¥·Å
var bool        bInStarting;              //ÔÚ¿ªÊ¼²¥·ÅÊ±¼ä¶Î
//----±³¾°ÒôÀÖµÄ¸ñÊ½ÐÅÏ¢
struct KFXBGMusicFormat
{
    var  array<string>     BGMusicString;         //ÒôÀÖÃû³Æ
};

//---³£¹æ
var KFXBGMusicFormat  BGMusics;
var int CurBGMusicIndex;                //µ±Ç°²¥·ÅµÄÒôÀÖË÷Òý
var int StartBGMusicIndex[3];
var int MidBGMusicIndex[3];
var int WinBGMusicIndex;
var int LoseBGMusicIndex;
var int EndBGMusicIndex;

var bool  FirstRestartPlayer;                   //-------½öÔÚ¿Í»§¶Ë
var bool  bAllowChangeWeapGameStart;

var bool  PlayerFreeViewManager;                //-----Íæ¼Ò×ÔÓÉÊÓ½Ç¿ØÖÆ
//-------¸÷ÖÖÒôÐ§¿ØÖÆ¸ñÊ½ÐÅÏ¢£¨ÒôÁ¿ºÍ¿ª¹Ø£©
//struct KFXSoundFormat
//{
//    var globalconfig float Volume;
//    var globalconfig float Radius;
//    var globalconfig bool  bEnable;
//};
//-----Ò»°ãµÄÒôÐ§¿ØÖÆ²ÎÊý ------
//var globalconfig KFXSoundFormat NormalSoundParam;
//------Õ½¶·Ö¸ÁîÒôÐ§¿ØÖÆ²ÎÊý--------
//var globalconfig KFXSoundFormat InstructionSoundParam;



//-------------------------------------
var string TransWeaponPageName;

var bool    PartitionTeamEnable;//ÊÇ·ñÊ¹ÓÃ½ÇÉ«Çø·Ö¹¦ÄÜ

//< To be Cleaned
//var int KFXMagicItem[2];
//var bool  KFXMagicPending; // Client: ÊÇ·ñ´¦ÓÚµÈ´ý×´Ì¬
//var float KFXMagicTimer;   // Client: µ¹¼ÆÊ±
//var KFXPlayerReplicationInfo KFXMagicPendingObj; // Client: µÀ¾ßÊ¹ÓÃÄ¿±ê
//> To be Cleaned

//---------------------------------------------------------

//< Added by SunZhuoshi(moved from KFXHUD)
//Small map mode: 0, rotate player; 1, rotate map.
enum ESmallMapMode
{
    SMALLMAPMODE_ROTATE_PLAYER,
    SMALLMAPMODE_ROTATE_MAP
};

enum EFindVoicerType
{
    FINDVOICEERTYPE_FIRST
};

//>
//< Added by SunZhuoshi to support F1 help for newbies
var bool bFirstTimeGame;
var string HelpInGameClass;
//>

//< Code for autoaim
// TODO: ÕûÀí´úÂë£¬Ö»ÓÃÓÚµÀ¾ßÈû
var globalconfig bool KFXIsOnAutoAimMode;         // ÊÇ·ñ¿ªÆô×Ô¶¯Ãé×¼¹¦ÄÜ
var int     KFXAutoAimMP;               // ×Ô¶¯Ãé×¼¿ÉÓÃ´ÎÊý(ÐèÒªÂð?)
var float   KFXAutoAimAngle;            // ×Ô¶¯Ãé×¼½Ç¶È
var float   KFXAutoAimColdDownMax;      // CodeDown×î´óÖµ
var float   KFXAutoAimColdDown;         // µ±Ç°CodeDownÖµ
var float   KFXAutoAimValidTime;        // AutoAimÉúÐ§Ê±¼ä
var float   KFXAutoAimValidTimeMax;     // AutoAimÉúÐ§Ê±¼äMax
var float   KFXAutoAimLockTime;         // Ëø¶¨Ä¿±êËùÓÃÊ±¼ä
var float   KFXAutoAimLockTimeDelta;    // Ëø¶¨Ä¿±êËùÐè¼ä¸ôÊ±¼ä
var Actor   KFXAutoAimTarget;           // ×Ô¶¯Ãé×¼Ä¿±ê
var vector  KFXAutoAimSpot;             // ×Ô¶¯Ãé×¼·½Ïò
var vector  KFXAutoAimStart;            // ×Ô¶¯Ãé×¼ÆðÊ¼·½Ïò
//> Code for autoaim end
var globalconfig bool bKFXShowShadow;
var globalconfig bool bKFXShakeView;
var globalconfig bool bKFXLockWirelessSound;    //ÊÇ·ñ¹Ø±ÕÎÞÏßµçÓïÒô
var globalconfig bool bKFXLockSMZKeySound;      //ÊÇ·ñ¹Ø±ÕF2¡¢F3¡¢F4ÓïÒô
var globalconfig bool bKFXKeyOfShowKill;        // ÊÇ·ñÏÔÊ¾ÏûÃðÍ³¼Æ
var globalconfig bool bKFXKeyOfRadar;           //ÊÇ·ñÏÔÊ¾À×´ï
var globalconfig bool bKFXKeyOfChat;            //ÊÇ·ñÏÔÊ¾ÁÄÌì¿ò
var globalconfig bool bKFXKeyOfEncourage;       //ÊÇ·ñÏÔÊ¾¼¤ÀøÐ§¹û
var globalconfig bool bKFXKeyOfAimPoint;        //ÊÇ·ñÏÔÊ¾Ä¿±êÖ¸Ïò
var globalconfig int  KFXCrosshairColorType;    //×¼ÐÇÑÕÉ«
var globalconfig int  KFXCrosshairShapeType;    //×¼ÐÇÀàÐÍ
var globalconfig byte KFXCrosshairSizeIndex;    //×¼ÐÇ´óÐ¡: 0-small, 1-medium, 2-large
var globalconfig int  CrossHairDrawType;        //×¼ÐÇµÄ»æÖÆ·½Ê½1-normal£¬ 2-Fireing Drawn£¬ 3-Drawing with Spread
var globalconfig bool bKFXIsNickName;           //ÊÇ·ñêÇ³Æ»¹ÊÇÔË¶¯Ô±³ÆºÅ
var globalconfig int  DrawWeaponAXIS;           //»æÖÆ×¼ÐÇÄ£Ê½  0--normal  1--new type
var globalconfig bool bShowTeammates;			//ÏÔÊ¾¶ÓÓÑÃû×Ö
var globalconfig byte KFXRadarScale;			//(0-255) À×´ï±ÈÀý
var globalconfig bool bShowBulletPic;			//ÏÔÊ¾×Óµ¯Í¼Æ¬×ÊÔ´
var globalconfig bool bShowWeaponFireTrace;		//ÊÇ·ñÏÔÊ¾µ¯ÏßÌØÐ§
var globalconfig bool bShowKilledPos;			//ËÀÍö±¨µã¹¦ÄÜ¿ª¹Ø
var globalconfig byte bCanHearOthersKill;       //ÄÜ·ñÌý¼ûËûÈË²¥·ÅÁ¬É±ÏûÏ¢ 0±ðÈË²»ÄÜÌý¼û£¬1¶ÓÓÑÄÜÌý¼û£¬2µÐÈËÄÜÌý¼û
var globalconfig bool bIsChinaVoice;

// Garbage Message Filter
var globalconfig bool bIsEnterLeaveGame;        //ÊÇ·ñÏÔÊ¾½øÈëÀë¿ªÓÎÏ·
var globalconfig bool bIsVoiceMessage;          //ÊÇ·ñÏÔÊ¾ÎÞÏßµçÓïÒô
var globalconfig bool bIsChatWithTeam;          //ÊÇ·ñÏÔÊ¾ÓÎÏ·ÄÚ¶ÓÎéÁÄÌì
var globalconfig bool bIsChatWithAll;           //ÊÇ·ñÏÔÊ¾ÓÎÏ·ÄÚÈ«ÌåÁÄÌì
var globalconfig bool bIsChatWithPersonal;            //ÊÇ·ñÏÔÊ¾ÃÜÁÄ
var globalconfig bool bIsChatWithFaction;           //ÊÇ·ñÏÔÊ¾Õ½¶ÓÁÄÌì
var globalconfig bool bIsCanHearSpeaker;        //ÊÇ·ñÏÔÊ¾À®°È
var globalconfig bool bIsSystemMessage;         //ÊÇ·ñÏÔÊ¾ÏµÍ³¹«¸æ

//< Properties from UnrealPlayer
var bool        bLatecomer;     // entered multiplayer game after game started

var() int       MultiKillLevel; // Á¬É±Êý
var() int       MaxMultiKillLevel;//×î´óÁ¬É±Êý
var() float     LastKillTime;
var float       LastHeadShotTime;

var int         ClientMultiKillNum;
var float ClientRestartTime;

//<<ÀîÍþ¹ú ·´Íâ¹ÒÏà¹Ø ±äËÙ³ÝÂÖ
var float DeltaTimeStack[200];
var int DeltaTimeTop;
var bool DeltaTimeIntialize;
///´æ´¢DeltaTimeµÄÆ½¾ùÖµ
var float AverageDeltaTime;
//>>


var bool bReadyToStart; //Ready to start the game - used to prevent player from clicking in until he's had a chance to see the login menu
var string LoginMenuClass;  //Set by replicated function called by DeathMatch to the name of the login menu
var bool bForceLoginMenu;   //Set by replicated function called by DeathMatch to whether it wants to force player to see login menu
var float LastKickWarningTime;

var string NetBotDebugString;
//> Properties from UnrealPlayer end

//< Properties from xPlayer
// attract mode

var int numcams, curcam;
var Pawn attracttarget, attracttarget2;
var float camtime, targettime, gibwatchtime;
var Vector focuspoint;

var float MinAdrenalineCost;


//var xUtil.PlayerRecord PawnSetupRecord;
var float LastRulesRequestTime;
var float LastMapListRequestTime;

var bool autozoom;
var globalconfig bool bClassicTrans;
var bool bHighBeaconTrajectory;
var bool bWaitingForPRI, bWaitingForVRI;
var config bool bDebuggingVoiceChat;

var config bool bAutoDemoRec;

var bool bKFXEnableSwitchWeapon;    //ÊÇ·ñÔÊÐí»»Ç¹.[Ô­KFXSwitchWeaponCard]

//-------------------------------------------
// add by zjpwxh@kingsoft
//-------------------------------------------
var bool bShowWinAndLoss;           // ÏÔÊ¾Ê¤¸ºÌáÊ¾
var bool bShowRoundWinAndLoss;      // Ð¡¾ÖÊ¤¸ºÏÔÊ¾
var bool bShowGameMenu;             // ÊÇ·ñÏÔÊ¾²Ëµ¥

var float KFXIdleTime;              // ·¢´ôÊ±¼ä

var float KFXEndGameTime;           // ½áÊøÊ±¼ä

// Êý¾Ý¿âÊý¾Ý
var KFXFaeryAgent.KFXPlayerInfo fxDBPlayerInfo;
var KFXFaeryAgent.CurEquipItemsListType fxDBPlayerEquipList;
var KFXFaeryAgent.BasePlayerDataBlock   fxDBPlayerBaseData;
var KFXFaeryAgent.PlayerDataBlockExtra  fxPlayerExtraData;
var KFXFaeryAgent.KFXPVEPlayerData      fxPVEPlayerData;
//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.21
var KFXFaeryAgent.KFXPlayerExpInfo fxDBPlayerExpInfo;
//>>
var KFXFaeryAgent.KFXPlayerWeaponsBakInfo  fxDBPlayerWeaponsInfo;
var KFXFaeryAgent.KFXBagPropsInfo fxDBPlayerPropsInfo;
var int   KFXCurSelectWeaponID;    // µ±Ç°Ê¹ÓÃµÄÎäÆ÷ID
var float KFXPlayerLoginTime;           // ¼ÇÂ¼Íæ¼ÒµÇÂ¼Ê±¼ä
///ÅçÆá¹¦ÄÜ
var int   KFXCurSelectDoodleCardID; ///<µ±Ç°Ñ¡ÔñµÄÅçÆáµÀ¾ßµÄid

//Éú»¯
var int		fxMutateRole;	//¾ÈÊÀÖ÷Ä£Ê½£¬¿É±äÉíÄ¾ÄËÒÁµÄ½ÇÉ«:

//------------½ØÖÁµ½2009.10.12    ¸Ã¹¦ÄÜ½öÏÞÓÚÔÚÖÕ½áÕßÄ£Ê½ÏÂÊ¹ÓÃ----------------
struct    RoleAttributeAdjustStruct
{
    var float Param1;            //ÊôÐÔÖµ»Ö¸´µ½»ù´¡ÖµµÄ¶àÉÙ
    var int   MaxUseTimes;                 //×î¶àÊ¹ÓÃµÄ´ÎÊý
    var int   CurUsedTimes;                //µ±Ç°Ê¹ÓÃµÄ´ÎÊý
    var float CDTime;                      //µÀ¾ßµÄÀäÈ´Ê±¼ä
} ;
var RoleAttributeAdjustStruct AmmoCountAdjustBlock;  //½ÇÉ«Ê¹ÓÃµÄ×Óµ¯»Ö¸´µÀ¾ß
var RoleAttributeAdjustStruct HealthCountAdjustBlock;  //½ÇÉ«Ê¹ÓÃµÄÉúÃüÖµ»Ö¸´µÀ¾ß
var RoleAttributeAdjustStruct GodCountAdjustBlock;  //½ÇÉ«Ê¹ÓÃµÄÎÞµÐµÀ¾ß
//------------------------------------------------------------------------------

// Ð¡µØÍ¼Ä£Ê½
var globalconfig ESmallMapMode fxSmallMapMode;

// Channels which player was a member of during last match
var transient globalconfig array<string> RejoinChannels;

var bool KFXFirstLogin;

var bool bServerAllowHide;             //ÉèÖÃÃæ°å¿ØÖÆÊÇ·ñÄÜ¹»½øÐÐÒþÉí¿ØÖÆ
var globalconfig int  nPartitialTeamSet;            //ÉèÖÃÃæ°å¿ØÖÆÊÇ·ñ½øÐÐ¶ÓÎéÇø·Ö

//ÆÁ±Î°ïÖúÏûÏ¢
var globalconfig bool bBlockAssitMsg;
//ÑªµÄÑÕÉ«
var globalconfig byte nBloodColor;

var int PitchUpLimit;
var int PitchDownLimit;
var bool bRequairLogInGame;       //Íæ¼ÒÊÇ·ñ¾ö¶¨Ïò·þÎñÆ÷ÇëÇó´´½¨½ÇÉ«

var KFXSpectateHook 		SpectateHook;						// ¼ÙÎäÆ÷£¬Í¬²½Êý¾Ý×¨ÓÃ

var bool bCheatDead;		// ¹Û²ì¶ÔÏóËÀÍöÊ±£¬ÓÃÀ´±ê¼ÇÈË³Æ×´Ì¬
var float LastCameraLocationZ;
var float LastCameraTimeSecond;
var actor LastCameraViewTarget;

///ucc-bin×´Ì¬²ÎÊý
var bool SetupOutputPing;
var bool HaveInitOutputPing;
var float PingStateTimer;

var globalconfig bool bEnableSpecialView;      //ÊÇ·ñÊ¹ÓÃÌØÊâµÄÊÓÒ°Ä¿Ç°ÔÝÊ±Ö»¶Ô½©Ê¬ÏµÁÐÄ£Ê½ÉúÐ§

//<zhong:·´·ÉÌìÍâ¹ÒÏà¹Ø
var float FallingStartTime;		// ÆðÌøÊ±¼ä
var vector FallingStartVelocity;
var float FallingStartZ;		// ÆðÌø¸ß¶È
var int CheckErrorTimes;		// ²âÊÔ²»Í¨¹ý´ÎÊý
var int CheckFlag;              // ÉÏÒ»¸ö²âÊÔÊ±¼ä¶Îflag
var float LastFallDeltaTime;	// ²âÊÔ¼ä¸ôÏà¹ØÔ¤´æÖµ

var vector LastCheckPawnLocation;	//Ô¤´æÉÏ´ÎpawnµÄÎ»ÖÃ
var bool CheckPawnWithGeometry;			//ÊÇ·ñ¼ì²éºÍ¼¸ºÎÌåµÄÅö×²

//ÊÇ·ñÔÊÐí±¬Í·
var bool bAllowHeadKilled;
//ÊÇ·ñÔÊÐíÌßÈË
var bool bAllowKickIdle;

var bool fireeffectctrl;

var protected KFXCardPack KFXPlayerCardPack; //Íõð© µÀ¾ß¿¨Æ¬°ü¡£

//<< ·þ×°°óÊôÐÔ
var KFXSuitInfo KFXSuitAttr;
var float KFXSuitExpFactor;
var float KFXSuitPointFactor;
//>>

var class<KFXTaskManager> TaskManagerClass; ///<ÈÎÎñÏµÍ³Ïà¹Ø¶¨Òå
var KFXTaskManager TaskManager;				///< ÈÎÎñ¹ÜÀíÆ÷
var array<int> ServerInTaskArray;
var array<int> ServerOutTaskArray;			///< ·þÎñÆ÷Íê³ÉÈÎÎñÁÐ±í£¬°Ñ¸ÃÈÎÎñÔÚ´«ÈëarrayË÷Òý¼ÓÈë¼´¿É
struct ClientTaskInfo    					///<¿Í»§¶ËÈÎÎñ½á¹¹
{
	var int TaskID;
	var int TaskProcess;
};
var array<ClientTaskInfo> ClientTaskArray;	///<¿Í»§¶ËÈÎÎñÁÐ±í

// »»Ç¹Ê±¼äÏÞÖÆ
var config float TransWeaponTimeLimit;
var config float TransWeaponRadius;
var KFXFaeryAgent.CurEquipItemsListType fxTransWeapList;

//ÎäÆ÷ÄÍ¾Ã¶ÈÏûºÄ¼ÆÊý
struct fxWeapDurConsume
{
    var int ConsumeWeapId;
    var float DurConsume;
    var float Durable; //ÓÎÏ·¿ªÊ¼Ê±ÎäÆ÷µÄÄÍ¾Ã¶È
};
var array<fxWeapDurConsume>  WeapDurConsumes;

//ÎäÆ÷ÄÍ¾Ã¶ÈÏûºÄ ¿ªÊ¼¼ÆÊ±
var float RecordStartSecond;
//µ±Ç°ÕýÔÚ¼ÆËãÄÍ¾Ã¶ÈÏûºÄµÄÎäÆ÷ID
var int CurConsumeWeapID;
var int LastConsumeWeapID;

struct fxTransWeaponCompoent
{
    var int WeaponID;
    var int ComponentID[6];
};

var array<fxTransWeaponCompoent> TransComponents;
var array<int>				MyShownTaskTip;

var bool   bRecordOver;
var   int   CanBuyWeaponType;        //Íæ¼ÒÄÜÂòµÄÎäÆ÷ Ê®½øÖÆ1111±íÊ¾Ö÷ÎäÆ÷¸±ÎäÆ÷Àä±øÆ÷ºÍÀ×¶¼¿ÉÒÔÂò£¬ÄÄ¸öÎª0£¬±íÊ¾ÄÄÒ»ÀàÎäÆ÷²»ÄÜÂò
var int  bomb_bag_level;	//À×°üµÈ¼¶

var int MultiHealdShotNum;
struct CombatmessageDataSet
{
    var int MaxMutiKillNum;//×î¶àÁ¬É±£º¡Ý3ÈË
	var int MaxFastKillNum;//×î¿ì»÷É±£º¡Ü5Ãë
	var int Combo2lNum;//2Á¬É±´ÎÊý£º¡Ý3´Î
	var int Combo3lNum;//3Á¬É±´ÎÊý£º¡Ý3´Î
	var int Combo4lNum;//4Á¬É±´ÎÊý£º¡Ý3´Î
	var int Combo5lNum;//5Á¬É±´ÎÊý£º¡Ý3´Î
	var int Combo6lNum;//6Á¬É±¼°ÒÔÉÏ´ÎÊý£º¡Ý3´Î
	var int Combo7lNum;//6Á¬É±¼°ÒÔÉÏ´ÎÊý£º¡Ý3´Î
	var int Combo8lNum;//6Á¬É±¼°ÒÔÉÏ´ÎÊý£º¡Ý3´Î
	var int MaxAliveTime;//×î³¤´æ»îÊ±¼ä£º¡Ý60Ãë£¨Èç¹ûÓÐÐ¡¾Ö£¬Ôò¿çÐ¡¾ÖÍ³¼Æ£©--------->Ð¡¾ÖÎ´×ö
	var int FBNum;//FB´ÎÊý¡Ý3´Î
	var int FKNum;//FK´ÎÊý¡Ý3´Î
	var int MaxSingleLifeKill;//µ¥ÌõÃü×î¶à»÷É±Êý¡Ý5ÈË
	var int MaxMutiHeadKill;//×î¶àÁ¬Ðø±¬Í·¡Ý3ÈË
	var int CrossWallKillNum;//´©Ç½»÷É±¡Ý10ÈË
	var int CrossWallHeadKillNum;//´©Ç½±¬Í·¡Ý5ÈË
	var int MaxSingleBloodKillNum;//1µÎÑª»÷É±¡Ý1ÈË
	var int MaxFullHealthKillNum;//ÂúÑªÁ¬É±Êý¡Ý3ÈË
	var int MaxKillInFalling;//ÌøÔ¾ÖÐ»÷É±¡Ý5ÈË
	var int MaxCrouchKill;//¶×ÏÂ»÷É±¡Ý20ÈË
};
var CombatmessageDataSet PlayerCombatmessageDataSet;
var int LastLifekilledNum;
//Í¨±¨¸øÍ¬¶Ó¶ÓÓÑ¼äµÄÓöµÐÇé¿ö£¬ÔÝÓÉ¿Í»§¶ËÀ´ÊÕ¼¯
struct AreaEnemyMsg
{
	var byte SoundType;	//0±íÊ¾ÎÞ£¬1±íÊ¾×¼ÐÇÖ¸ÏòÄ³¸öµÐÈË£¬2±íÊ¾±»É±ËÀ£¬3±íÊ¾É±ËÀ±ðÈË
	var byte AreaID;	//ÇøÓò±êÊ¶
};
struct GainedAreaEnemyMsg
{
	var byte SoundType;	//0±íÊ¾ÎÞ£¬1±íÊ¾×¼ÐÇÖ¸ÏòÄ³¸öµÐÈË£¬2±íÊ¾±»É±ËÀ£¬3±íÊ¾É±ËÀ±ðÈË
	var byte AreaID;	//ÇøÓò±êÊ¶
	var int  ReadTime;	//¶ÁÁËÕâÌõÏûÏ¢µÄÊ±¼ä
	var string PlayerName;
};
var array<AreaEnemyMsg>  		AreaEnemyMsgs;
var array<GainedAreaEnemyMsg>	GainedAreaEnemyMsgs;
var float				 		LastBroadcastEnemyTime;

var vector      BlendedTargetViewLocation;
var bool bHasJustRestarted;
var bool bFreeRecord;

var vector DownViewLoc;  //¸©ÊÓ½ÇÎ»ÖÃ
var bool    bPressQ;    //ÊÇ·ñ°´ÏÂÁËQ¼ü
var bool bJustLogin;        //ÊÇ·ñ ¸Õ¸ÕµÇÂ½
var bool bShowViewHelp;    //ÊÇ·ñÏÔÊ¾¹Û²ìÕßÄ£Ê½ÏÂµÄÌáÊ¾

var Pawn KillMePawn;          //É±ËÀÎÒÄÇ¸öÈËµÄPawn
var bool bDrawSelectWair;       // ÊÇ·ñÏÔÊ¾ÓéÀÖ±¬ÆÆÖÐµÄÑ¡Ôñ1,2Ïß

var int weapon_limit;
var bool bIsRound;                 //ÊÇ·ñÊÇÐ¡¾ÖÄ£Ê½
var bool tick_signal;
var Mover TestMover;
var float SpecKillerSecs;      //¹Û²ìÕß¿´KillerµÄÊ±¼äÏÞÖÆ£¬Õâ¸öÊÇËÀÍö»Ø·ÅÖÐÓÃµ½µÄ
var int  AllowMaxDistForG;     //¼ÆËãÉËº¦Ê±¿Í»§¶Ë·þÎñÆ÷Î»ÖÃÏà²îµÄ×î´óÖµ
var int  AllowMaxDistForK;     //¼ì²â¿Í»§¶Ë·þÎñÆ÷Î»ÖÃÏà²î²»ÒªÌ«´ó
var bool bLogOutInGame;        //ÊÇ·ñÖÐÍ¾ÍË³ö
var int  LatestMajorWeapon;    //×îÐÂµÄÂòµÄÖ÷ÎäÆ÷
var bool  bInitMVPWeapon;
var int  bWantToBeVIP;
var float time_be_hitted;		//±»»÷É±µÄÊ±¿Ì

//ºÍÐ³²å¼þ
struct HUD_Tile
{
	var float u;
	var float v;
	var float ul;
	var float vl;
	var Material mat;
	var bool valid;
};
struct Level_ReplaceableActor
{
	var string replaced_actor;		//±»Ìæ»»µÄactorµÄÃû×Ö
	var string replace_actor;		//Ìæ»»actorµÄÃû×Ö
};
var int		life_style;			//·´ºÍÐ³²å¼þ¿ª¹Ø£¬ÎªtrueµÄÊ±ºò£¬ÓÃµÚÈý·½²å¼þ
var string 	life_style_type;	//·´ºÍÐ³²å¼þµÄÀàÐÍ£¬µÚÒ»ÆÚµÄ£¬µÚ¶þÆÚµÄ£¬µÚÈýÆÚµÈµÈ
var bool 	life_style_init;
var bool	life_blood_shoot_effect_valid;	//¿ª¹Ø
var bool	life_first_person_blood_valid;	//µÚÒ»ÈË³ÆÅçÑªÌØÐ§¿ª¹Ø
var bool	life_blood_texture_valid;	//¿ª¹Ø
var bool	life_encourage_sound_valid;	//¼¤ÀøÒôÐ§¿ª¹Ø
var bool 	life_horrible_level;		//¿Ö²À·ÕÎ§¿ª¹Ø

var float	life_style_check_time;
var string 	life_blood_texture;	//	ÑªÒºÌùÍ¼
var string	life_blood_shoot_effect;	//ÅçÑªÌØÐ§
var string 	life_blood_head_effect;		//±¬Í·µÄÅçÑªÌØÐ§
var HUD_Tile life_hurt_pic;		//±»ÊÜÉËºóhudÏÔÊ¾µÄÍ¼Æ¬
var array<HUD_Tile> life_encourage_pic;     //¼¤ÀøÍ¼±ê
var array<string>	life_encourage_sound;	//¼¤ÀøÒôÐ§
var int			life_replaceable_size;		//³¡¾°ÖÐ¿ÉÌæ»»µÄÎï¼þµÄÊýÁ¿
var array<Level_ReplaceableActor>	life_replaceable_actors;	//³¡¾°ÖÐ¿ÉÌæ»»µÄÎï¼þÐÅÏ¢

var bool   bTransWeaponOpened;
//ËÀÍöÕðÆÁ sunqiang
var globalconfig bool     bShakeViewAfterDead;
var globalconfig float    fxDeadPitchChange;
var globalconfig float    fxDeadRollChange;
var byte                  DyingDirection;
var int                   PlayerInDeadStateCount;

//Ò»¼üÈÓÀ×Ò»¼ü°´°ü
var  bool   bQuickToss;
var  bool   bQuickInstallC4;

//var bool   bGodLike;//Õâ¸öÄã¶®µÄ

//Í³¼ÆACEÎäÆ÷Âß¼­ÐÞ¸Ä ¸ÄÎªÓÎÏ·ÄÚÊ¹ÓÃÊ±¼ä×î³¤µÄ
struct WeaponUsedInfo
{
    var float BeginUseTime;
    var float UsedTime;
    var int   WeaponID;
};
var array <WeaponUsedInfo>  WeapUsedInfo;

var float TossBeginTime;
var float InstallBeginTime;


var Array<string> PrecacheTableNames;


//ÓÎÏ·ÄÚFarmÏµÍ³Âß¼­  sunqiang

//¼ì²âDllÖÐÊÇ·ñ±»Ìæ»»¹ý¹¦ÄÜ sunqiang
var bool        bIsCheckDLlLatest;
var float       LastCallTime;
var float       ClientLastCheckTime;

//ÊÇ·ñ¸´»î¹ýÁË
var bool  bHasRestarted;

//Îª½â¾öÓÎÏ·ÖÐ²»ÄÜ¸´»îÌí¼Ó´úÂë
var  int   DyingTimes;             //ËÀÍö+1£¬¸´»î-1
var  float DeadStartTime;
var  float CheckIsRestartinterval;


//
var vector curr_accel;

delegate ProcessRule(string NewRule);   // Should be assigned elsewhere
delegate ProcessMapName(string NewMap);


//> Properties from xPlayer end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

replication
{
    //< replication from xPlayer
    // client to server
    reliable if ( Role < ROLE_Authority )
        ServerRequestRules, ServerUpdateDoodle,AdminMenu, ServerRequestPlayerInfo,
        ServerSpecViewGoal, ServerSetClassicTrans, KFXLockRadio, ServerRequairLogInGame,
		ServerDoCollectEnemyMsg/*,NotifyGameMVP*/,BeatFly;
    reliable if ( Role == ROLE_Authority)
        ClientReceiveRule, ClientReceiveBan,ClientGameEndedProcess, ClientBeginGame, ClientChangeTeam,
		ClientGainEnemyMsgs, ClientPVEBaseLevelUp,KFXDamageNoise;
    //>  replication from xPlayer end

    //< replication from UnrealPlayer
    // Things the server should send to the client.
    reliable if ( Role == ROLE_Authority )
        ClientSendStats, ClientSendSprees, ClientSendMultiKills, ClientSendWeapon,
        ClientReceiveLoginMenu, ClientReceiveBotDebugString, KFXGSCommand, UISwitchWeapon;

    reliable if ( Role < ROLE_Authority )
        ServerUpdateStats, ServerUpdateStatArrays, ServerGetNextWeaponStats,
        ServerSetReadyToStart, ServerSendBotDebugString, ServerSetPlayerID;
    //> replication from UnrealPlayer end

    reliable if( Role == ROLE_Authority && bNetDirty )
        fxDBPlayerPropsInfo,//fxDBPlayerWeaponsInfo,
        KFXIsOnAutoAimMode, KFXAutoAimColdDown,
        KFXMagicWeap,bRequairLogInGame,bServerAllowHide,AmmoCountAdjustBlock,HealthCountAdjustBlock,
        GodCountAdjustBlock,KFXPlayerCardPack, TaskManager, SpectateHook, fxMutateRole;

    //reliable if( Role == ROLE_Authority && bNetInitial )
    //    fxDBPlayerInfo;

    reliable if( Role < ROLE_Authority )
        KFXChangeWeapon,KFXChangeDoodleCardID, KFXServerSetAutoAim, KFXServerFireAutoAim,
        ServerSpecMode, ServerSuperState,ServerCrAsh;
    unreliable if(Role < ROLE_Authority)
        ServreSetOwnScale, ServerChangeFreeView,ServerViewPriorPlayer,ServerToFreeView;

    // add by zjpwxh@kingsoft
    reliable if ( Role == ROLE_Authority )
        /*KFXChangeWeaponACK, */KFXReceiveLocalizedMessage;

    //Íõð© Ìí¼Ó¼ÓËÙÂß¼­µÄÍ¬²½£¬Ä¿Ç°Ö»ÊµÏÖÁËÓÄÁéÄ£Ê½¼ÓËÙ 2009-12-01
    //Íõð© ÐÞ¸Ä ÐÂ¿¨Æ¬ÏµÍ³ ´¥·¢°´¼ü
    reliable if( Role < ROLE_Authority)
        KFXUseSpeedUp;
    reliable if ( Role == ROLE_Authority && bNetDirty)
        CanBuyWeaponType;
    reliable if( Role < ROLE_Authority)
         ServerToDie;
    //ËïÇ¿ ¿Í»§¶ËÄ£Äâ¿ª»ðÓÒ¼ü¹¦ÄÜ¸æËß·þÎñÆ÷
    reliable if( Role < ROLE_Authority)
       KFXServerDoRightFire;

    //ËïÇ¿ ¹Û²ìÕßÄ£Ê½×´Ì¬Ö®¼äÇÐ»»
    reliable if( Role < ROLE_Authority)
       ServerDownView,ServerSpectating;
    //½Ó½üÊ¤ÀûµÄÓïÒô
   reliable if ( Role == ROLE_Authority)
       ClientNearWinVoice;
   reliable if(Role < Role_Authority)
       ServerCloseMover,ServerOpenMover;

    // ¹ã¸æÎ»ÂÖ²¥     sunqiang
    reliable if ( Role < ROLE_Authority )
        KFXRequestPoster;
    reliable if ( Role == ROLE_Authority )
        KFXPutPoster;
    reliable if ( Role < ROLE_Authority )
        MakeServerEndGame,ServerQuickFire,ServerStopQuickFire;
    reliable if ( Role == ROLE_Authority )
        ClientGetDropItem;
    //Ôö¼Ó»÷»Ù½¨ÖþÎïº¯Êý
    reliable if ( Role < ROLE_Authority )
        SetDestroyableActorTakeDamage,SetDestroyableObjectiveTakeDamage ;

}

///
///·´Íâ¹ÒÏà¹Ø ±äËÙ³ÝÂÖ
///¼ÆËãDeltaTimeµÄÆ½¾ùÖµ
function UpdateAverageDeltaTime(float DeltaTime)
{
    local int i;
    local float TempValue;
    if( DeltaTimeTop == ArrayCount(DeltaTimeStack) ) //ArrayCount(DeltaTimeStack)
        DeltaTimeTop = 0;

    //LOG("DeltaTime "$DeltaTime*100);
    //LOG("AverageDeltaTime "$AverageDeltaTime*100);

    if(!DeltaTimeIntialize)
    {
        for( i = 0; i < ArrayCount(DeltaTimeStack); i++ )
        {
            DeltaTimeStack[i] = DeltaTime;
        }

        DeltaTimeIntialize = true;
    }

    DeltaTimeStack[DeltaTimeTop] = DeltaTime;

    for( i = 0; i < ArrayCount(DeltaTimeStack); i++ )
    {
        TempValue += DeltaTimeStack[i];
    }

    if( ArrayCount(DeltaTimeStack) != 0 )
        AverageDeltaTime = TempValue/ArrayCount(DeltaTimeStack);
    else
        AverageDeltaTime = DeltaTime;

    DeltaTimeTop++;
}

///
///¸ù¾ÝDeltaTimeµÄÆ½¾ùÖµÀ´ÐÞÕý¸üÐÂÊ±¼ä
///
function float DeltaTimeFilter(float DeltaTime)
{
    local float AdjustDeltaTime;

    if( DeltaTime < AverageDeltaTime )
        AdjustDeltaTime = DeltaTime;
    else
        AdjustDeltaTime = AverageDeltaTime;


    //LOG("AdjustDeltaTime "$AdjustDeltaTime*100);
    return AdjustDeltaTime;
}

///
///¼ÓÈëÁËÍæ¼Ò»ñµÃÓÎÏ·ÄÚµôÂäÎïÆ·µÄ½Ó¿Ú
///
function PlayerGetItem(int ItemID)
{

}

function KFXLockRadio(bool bLockRadio)
{
    bKFXLockWirelessSound = bLockRadio;
}

function float GetPlayerSkillCdTime()
{
    return 0;
}
function ServerSendMessage(string HintString, int id)
{
}

function KFXSetMulKill(int killCount)
{
}

exec function SetCHMode( int Mode )
{
    CrossHairDrawType = Mode;
}

exec function SetDrawWeaponAXIS( int Type )
{
    DrawWeaponAXIS = Type;
    SaveConfig();
    if ( Pawn != none && Pawn.Weapon != none )
    {
        KFXWeapBase(Pawn.Weapon).ExchangeWeaponAxisType( Type );
    }
}
exec function PrintDoodle()
{
    local vector mHitNormal;
    local actor mHitActor;
    local material mHitMaterial;
    local vector HitLocation;
	local vector StartTrace, EndTrace;

    if( KFXPawn(self.Pawn).CurPrintTimes >= KFXGameReplicationInfo(GameReplicationInfo).fxMaxTimesToUsePrint )
    {
        return;
    }

    StartTrace = Pawn.Location + Pawn.EyePosition();
    EndTrace = StartTrace + vector(Rotation) * 8192.0;

    mHitActor = Trace(HitLocation,mHitNormal,EndTrace,StartTrace, true, ,mHitMaterial);

    if( VSize( HitLocation - StartTrace )>500 )
    return;
//
//    class'ProjectorDesc'.default.HitLoction = HitLocation;
//    class'ProjectorDesc'.default.HitNormal = mHitNormal;
//
//    LOG("[KFXWeaponAttatchment]  HitLoction:"$class'ProjectorDesc'.default.HitLoction$"HitNormal:"$class'ProjectorDesc'.default.HitNormal);
//    Spawn(class'DoodleProjector',,,HitLocation - FMax( VSize( Pawn.Location + Pawn.EyePosition() -  HitLocation), 2 ) * vector(Rotation), Rotation );//Rotator(-vector(
//    LOG("[KFXWeaponAttatchment] ScorchActor back dist"$VSize( Pawn.Location + Pawn.EyePosition() -  HitLocation) );
    ServerUpdateDoodle();
}

function ServerUpdateDoodle()
{
    local vector mHitNormal;
    local actor mHitActor;
    local material mHitMaterial;
    local vector HitLocation;
	local vector StartTrace, EndTrace;

    if(KFXCurSelectDoodleCardID == 0)
        return;

    if( KFXPawn(self.Pawn).CurPrintTimes >= KFXGameReplicationInfo(GameReplicationInfo).fxMaxTimesToUsePrint )
    {
        return;
    }

    StartTrace = Pawn.Location + Pawn.EyePosition();
    EndTrace = StartTrace + vector(Rotation) * 8192.0;

    mHitActor = Trace(HitLocation,mHitNormal,EndTrace,StartTrace, true, ,mHitMaterial);

    KFXPawn(self.Pawn).PendingPrintDoodleData.Revasion++;
    KFXPawn(self.Pawn).PendingPrintDoodleData.PrintLocation = HitLocation;
    KFXPawn(self.Pawn).PendingPrintDoodleData.PrintNormal = mHitNormal;

    KFXPawn(self.Pawn).CurPrintDoodleData.Revasion = KFXPawn(self.Pawn).PendingPrintDoodleData.Revasion;
    KFXPawn(self.Pawn).CurPrintDoodleData.PrintLocation = KFXPawn(self.Pawn).PendingPrintDoodleData.PrintLocation;
    KFXPawn(self.Pawn).CurPrintDoodleData.PrintNormal = KFXPawn(self.Pawn).PendingPrintDoodleData.PrintNormal;
    if( KFXCurSelectDoodleCardID != 0 )
    {
        KFXPawn(self.Pawn).PendingPrintDoodleData.ItemID = KFXCurSelectDoodleCardID;
        KFXPawn(self.Pawn).CurPrintDoodleData.ItemID = KFXPawn(self.Pawn).PendingPrintDoodleData.ItemID;
    }
    KFXPawn(self.Pawn).CurPrintTimes++;
    ;
}

exec function GetBattleTeamName()
{
    if( fireeffectctrl )
        fireeffectctrl = false;
    else
        fireeffectctrl = true;
    ;
}


//²»·µ»ØÕæÕýµÄÒôÁ¿Öµ£¬Ö»ÊÇ·µ»ØÏÞ¶¨Öµ
exec function float GetSoundVolumeFactor( int SwitchNum )
{
    local bool Enable;

    Enable = GetSoundEnable(SwitchNum);

    if(!Enable)
        return 0;

    Switch( SwitchNum )
    {
        case 0:
            return(NormalSoundParam.Volume);
        break;
        case 1:
            return(InstructionSoundParam.Volume);
        break;
    }
}

exec function float GetSoundRadiusFactor( int SwitchNum)
{
    local bool Enable;

    Enable = GetSoundEnable(SwitchNum);

    if(!Enable)
        return 0;

    Switch( SwitchNum )
    {
        case 0:
            return(NormalSoundParam.Radius);
        break;
        case 1:
            return(InstructionSoundParam.Radius);
        break;
    }
}
exec function bool GetSoundEnable( int SwitchNum )
{
    Switch( SwitchNum )
    {
        case 0:
            return(NormalSoundParam.bEnable);
        break;
        case 1:
            return(InstructionSoundParam.bEnable);
        break;
    }
}

exec function SetSoundVolume( int Index, float VolumeFactor)
{
    Switch( Index )
    {
        case 0:
            NormalSoundParam.Volume = VolumeFactor;
        break;
        case 1:
            InstructionSoundParam.Volume = VolumeFactor;
        break;
    }

}
exec function SetSoundEnable( int Index, bool Enable)
{
    Switch( Index )
    {
        case 0:
            NormalSoundParam.bEnable = Enable;
        break;
        case 1:
            InstructionSoundParam.bEnable = Enable;
        break;
    }
}
exec function SetSoundRadius( int Index, float Radius)
{
    Switch( Index )
    {
        case 0:
            NormalSoundParam.Radius = Radius;
        break;
        case 1:
            InstructionSoundParam.Radius = Radius;
        break;
    }

}

//------------------------------------------------------

exec function KFXSetEnableSPView( bool bEnable )
{
    bEnableSpecialView = bEnable;
    if( !IsInState('RoundEnded') && !IsInState('GameEnded') )
        ChangeAMBLight( false, true );
}

exec function ChangeAMBLight( bool Enable, optional bool bForce )
{

}
//----¿ÉÒÔ¸ü¸Ä³¡¾°µÄäÖÈ¾·½Ê½
exec function ChangeRendMap( int mapInt )
{
    RendMap = mapInt;
}

exec function KFXShowPlayerShadows(bool bShow)
{
    local KFXPawn P;

    bKFXShowShadow = bShow;
    default.bKFXShowShadow = bKFXShowShadow;

    foreach DynamicActors(class'KFXPawn',P)
    {
        P.KFXSetShadowEnable(bShow);
    }

    ;
    StaticSaveConfig();
}
// added by duodonglai to support mpeg2 record & replay
exec function RecordMovieStart()
{
    ConsoleCommand("recordmovie start filename=test.avi",true);
}
exec function RecordMovieStop()
{
    ConsoleCommand("recordmovie stop",true);
}
exec function ReplayMovieStart()
{
    ConsoleCommand("replaymovie start filename=test.avi",true);
}
exec function ReplayMovieStop()
{
    ConsoleCommand("replaymovie stop",true);
}
// added by duodonglai for test role's height

 function SetOwnScale(float cal)
{
    ServreSetOwnScale(cal);
}
function ServreSetOwnScale(float cal)
{
    if(KFXPawn(Pawn) != none)
    {
        KFXPawn(Pawn).SetDrawScale(cal);

        KFXPawn(Pawn).SetCollisionSize(KFXPawn(Pawn).DefCollisionRadius * cal,
                                       KFXPawn(Pawn).DefCollisionHeight * cal);
    }
}
// Show stat data in combat
exec function KFXStat()
{
    ConsoleCommand("stat net");
    ConsoleCommand("stat fps");
}

// Show help menu in game
exec function KFXShowHelpInGame()
{
    if(Player.GUIController.IsInState('Tutorial'))
        return;

    //ClientCloseMenu(true, true);
    //ClientOpenMenu(HelpInGameClass);
}

exec function ChangeRole(byte F){}


//< Functions from xPlayer
exec function CheckPriority()
{
    local Inventory Inv;
    local int Count;

    if ( Pawn == None )
    {
        DebugMessage("Pawn is none - returning");
        return;
    }

    for( Inv = Pawn.Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )
    {
        if ( Weapon(Inv) != None )
            DebugMessage("Weapon:"$Inv.Name@"Priority:"$Weapon(Inv).Priority,'PriorityDebug');

        Count++;
    }
}

exec function showAttach()
{
    KFXPawn(Pawn).CreateAttachEffect();
}

exec function hidAttach()
{
    KFXPawn(Pawn).DestroyAttachEffect();
}
//--·µ»Øµ±Ç°playerÊÇ·ñÐèÒªÏò·þÎñÆ÷ÇëÇó´´½¨½ÇÉ«
exec function bool GetPlayerNeedRequair()
{
    return !bRequairLogInGame;
}

exec function RequairLogInGame( bool B )
{
    bRequairLogInGame = B;

    ServerRequairLogInGame(B);
}
//===»ñµÃµØÍ¼id
exec function int KFXGetMapID()
{
    return KFXGameReplicationInfo(self.GameReplicationInfo).fxMapID;
}
//====»ñµÃ»÷É±ÏÞÖÆ
exec function int KFXGetKillLimit()
{
    return KFXGameReplicationInfo(self.GameReplicationInfo).fxKilledLimit;
}
//====»ñµÃ¸´ÉúÊ±¼ä
exec function int KFXGetRestartLimit()
{
    return FMax(GetGRI().fxPlayerRestartDelay-GetPRI().fxRestartCardTime, 0);
}
//====»ñµÃÓÎÏ·Ê±¼äÏÞÖÆ
exec function int KFXGetTimeLimit()
{
    return KFXGameReplicationInfo(self.GameReplicationInfo).fxTimeLimit;
}

exec function KFXPartitialTeamSet(int Seting)
{
}

function ServerRequairLogInGame( bool B )
{
    bRequairLogInGame = B;
    log("[KFXPlayer]self is in state:"$GetStateName());
    if(bRequairLogInGame)//---Í¨Öª¿Í»§¶ËÉú³É½áÊø
    {
        if( !IsInState('RoundEnded') && !IsInState('GameEnded'))
        {
        	log("KFXPlayer--------------RestartPlayer");
            Level.Game.RestartPlayer(self);
            ClientBeginGame();
        }
    }
}
function NotifyManagerPlayEnd()
{
    log("NotifyManagerPlayEnd");
    bRecordOver = true;
    GetPRI().nRealIDLastKillMe = -1;
    KFXPawn(ViewTarget).LastKillMe = none;
}

// wangkai, Ç¹Ö§ÊÇ·ñÉÏ±£ÏÕ£¬ÓÃÓÚÆÁ±ÎKFXWeaponBase::ClientStartFire
simulated function bool KFXGunSafeOn()
{
    return false;
}

simulated function DebugMessage(string DebugString, optional name Type)
{
    ClientMessage(DebugString);
    log(DebugString,Type);
}

simulated function String GetRoleString()
{
    local String T;

    T = "Role: ";
    Switch(Role)
    {
        case ROLE_None: T=T$"None"; break;
        case ROLE_DumbProxy: T=T$"DumbProxy"; break;
        case ROLE_SimulatedProxy: T=T$"SimulatedProxy"; break;
        case ROLE_AutonomousProxy: T=T$"AutonomousProxy"; break;
        case ROLE_Authority: T=T$"Authority"; break;
    }

    return T;
}
simulated function TakeHit(int Direction)
{
    if( KFXPawn(self.Pawn) == none )
    {
        return;
    }
    KFXPawn(self.Pawn).ShowByHit(Direction);
}

simulated function String GetPhysicsString()
{
    local String T;

    T = "Physics: ";
    Switch( Pawn.Physics )
    {
        case PHYS_None: T=T$"None"; break;
        case PHYS_Walking: T=T$"Walking"; break;
        case PHYS_Falling: T=T$"Falling"; break;
        case PHYS_Swimming: T=T$"Swimming"; break;
        case PHYS_Flying: T=T$"Flying"; break;
        case PHYS_Rotating: T=T$"Rotating"; break;
        case PHYS_Projectile: T=T$"Projectile"; break;
        case PHYS_Interpolating: T=T$"Interpolating"; break;
        case PHYS_MovingBrush: T=T$"MovingBrush"; break;
        case PHYS_Spider: T=T$"Spider"; break;
        case PHYS_Trailer: T=T$"Trailer"; break;
        case PHYS_Ladder: T=T$"Ladder"; break;
        case PHYS_Karma: T=T$"Karma"; break;
    }
    return T;
}


function ServerRequestRules()
{
    local GameInfo.ServerResponseLine Response;
    local int i;


    if ( Level.Pauser == None && Level.TimeSeconds - LastRulesRequestTime < 3.0)
    {
        log("ServerRequestRules Level.TimeSeconds:"$Level.TimeSeconds@"LastRequestTime:"$LastRulesRequestTime);
        return;
    }

    LastRulesRequestTime = Level.TimeSeconds;
    Level.Game.GetServerDetails(Response);
    ClientReceiveRule("");
    for (i=0;i<Response.ServerInfo.Length;i++)
        ClientReceiveRule(Response.ServerInfo[i].Key$"="$Response.ServerInfo[i].Value);
}

function ClientReceiveRule(string NewRule)
{
    ProcessRule(NewRule);
}

function StopFiring()
{
}

simulated function bool KFXSetWeaponMaterialEX(KFXWeapBase Weap)
{
    return false;
}
simulated function UpdatePrecacheMaterials()
{
    PrecacheMaterials();
}
simulated function PrecacheMaterials()
{
    local KFXCSVTable PrecacheRes;
    local int i,TempType, CacheType;
    local string TempString;
    local Object Precache;
    local int loop;
    super.PrecacheMaterials();
    for ( loop = 0; loop < PrecacheTableNames.Length; loop++ )
    {
        PrecacheRes  = class'KFXTools'.static.KFXCreateCSVTable(PrecacheTableNames[loop]);
	i=1;

	while(PrecacheRes.SetCurrentRow( i ))
	{
//		TempString = PrecacheRes.GetString("ResName");
//            TempType = PrecacheRes.GetInt("ResType");
//            CacheType = PrecacheRes.GetInt("CacheType");
//            LOG("[KFXPlayer] PrecacheMaterials"@TempString@TempType@CacheType);

		//<<ÀîÍþ¹ú ¿Í»§¶ËÓÅ»¯ 2009.3.11
		switch(TempType)
		{
			case 0:
			//LOG("[KFXPlayer] UpdatePrecacheMaterials"@TempString);
                Precache = DynamicLoadObject(TempString, class'texture');
                Precache.CacheDiskFile("",0,CacheType);
                //Level.AddPrecacheMaterial( Precache );
			break;
			case 1:
                ;
                Precache = DynamicLoadObject(TempString, class'StaticMesh');
                Precache.CacheDiskFile("",1,CacheType);
			break;
			case 3:
			//LOG("[KFXPlayer] DynamicLoadObject"@TempString);
                Precache = DynamicLoadObject(TempString, class'Mesh');
                Precache.CacheDiskFile("",3,CacheType);
			break;
			case 4:
			//LOG("[KFXPlayer] DynamicLoadObject"@TempString);
                Precache = DynamicLoadObject(TempString, class'Sound');
                Precache.CacheDiskFile("",4,CacheType);
			break;
			case 5:
			//LOG("[KFXPlayer] DynamicLoadObject"@TempString);
                Precache = DynamicLoadObject(TempString, class'class');
                Precache.CacheDiskFile("",5,CacheType);
			break;
		}
		i++;
		//>>
	}
    }
    PrecacheCsvData();
}

simulated function PrecacheCsvData()
{
    local KFXCSVTable CSVTable;

    ;
    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponMedia.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponMedia.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponAttribute.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponAttribute.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponFireMode.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponFireMode.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponAccessory.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponAccessory.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponSound.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponSound.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponTrack.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponTrack.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponAttachment.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponAttachment.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponEffect.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponEffect.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponClass.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponClass.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponProjectile.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponProjectile.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponDamageType.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponDamageType.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("Props.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"Props.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("MagicItem.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"MagicItem.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnList.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnList.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnAttribute.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnAttribute.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnMedia.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnMedia.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnStateAnim.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnStateAnim.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnAvatar.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnAvatar.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnSkeleton.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnSkeleton.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("PawnSound.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"PawnSound.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("LevelUpgradeTable.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"LevelUpgradeTable.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("KFXMapInfo.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"KFXMapInfo.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("NormalManWeaponLocation.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"NormalManWeaponLocation.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("NormalWomanWeaponLocation.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"NormalWomanWeaponLocation.csv");

    CSVTable  = class'KFXTools'.static.KFXCreateCSVTable("WeaponFitting.csv");
    if(CSVTable == none)
    log("[gameinfo] PrecacheCsvData ERROR !!!!! table name is:"$"WeaponFitting.csv");

}

exec function SetPlayerID( int ID )
{
    KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRoleGUID = ID;
    KFXPawn(Pawn).KFXPlayerId = ID;
    ServerSetPlayerID(ID);
}
exec function SetSelfAsTargetPawn()
{
    self.SetTargetPawn(Pawn,Pawn);
}
function ServerSetPlayerID( int ID )
{
    if ( KFXGameInfo(Level.Game).RoleGUID < ID )
    {
        KFXGameInfo(Level.Game).RoleGUID = ID;
    }
    KFXPlayerReplicationInfo(PlayerReplicationInfo).fxPlayerDBID = ID;
    KFXPawn(Pawn).KFXPlayerId = ID;
}
function Pawn FindLastKillMePawn()
{
    local int nKillerRoleID;
    local Pawn P;

    nKillerRoleID = GetPRI().nRealIDLastKillMe;
    if ( nKillerRoleID == -1 || nKillerRoleID == KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRoleGUID )
    {
        log("step1-failed Killer ID:"$GetPRI().nRealIDLastKillMe $"test ID:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRoleGUID
        $"selfID:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRoleGUID);
        log("self name:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).PlayerName$"Killer name:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).PlayerName);
       return none;
    }
    foreach AllActors(class'Pawn', P )
    {
        if ( KFXPawn(P) != none && KFXPawn(P).KFXPlayerId == nKillerRoleID )
        {
            log("succ Killer ID:"$GetPRI().nRealIDLastKillMe $"test ID:"$KFXPawn(P).KFXPlayerId
            $"selfID:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRoleGUID);
            log("self name:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).PlayerName$"Killer name:"$KFXPlayerReplicationInfo(P.PlayerReplicationInfo).PlayerName);
            return P;
        }
        else
        {
            log("failed Killer ID:"$GetPRI().nRealIDLastKillMe $"test ID:"$KFXPawn(P).KFXPlayerId
            $"selfID:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRoleGUID);
            log("self name:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).PlayerName$"Killer name:"$KFXPlayerReplicationInfo(P.PlayerReplicationInfo).PlayerName);
        }
    }
    log("FindLastKillMePawn error!!!!"$nKillerRoleID);
    return none;

}
simulated function PlayBeepSound()
{
    if ( ViewTarget != None )
        ;//ViewTarget.PlaySound(sound'MenuSounds.selectJ', SLOT_None,,,,,false);
}

simulated function float RateWeapon(Weapon w)
{
    return w.Default.Priority;
}

simulated function GotReplaceableActorInfo(out Level_ReplaceableActor info, string str)
{
	local string old_str;
	old_str = str;
	//replaced:xxxx replace:xxxx
	info.replace_actor = Mid(str, Instr(str, "replace:")+8);
	str = Left(str, Instr(str, "replace:")-1);
	info.replaced_actor = Mid(str, Instr(str, "replaced:")+9);
//	log("[LABOR]------------GotReplaceableActorInfo, oldstr="$old_str
//				@"replace="$info.replace_actor
//				@"replaced="$info.replaced_actor);
}
simulated function GotHudTileFromString(out HUD_Tile htile, string str)
{
	local string mat;
	//str=(u=30, v=30, ul=300, vl=300, material=ex.ex)
	str = Mid(str, InStr(str, "(")+1);
	str = Mid(str, 0, InStr(str, ")"));
 	htile.u = int(Mid(str, InStr(str, "u=")+2));
	htile.v = int(Mid(str, InStr(str, "v=")+2));
	htile.ul = int(Mid(str, InStr(str, "ul=")+3));
	htile.vl = int(Mid(str, InStr(str, "vl=")+3));
	mat = Mid(str, InStr(str, "material=")+9);
	htile.mat = Material(DynamicLoadObject(mat, class'Material'));
//	log("[LABOR]------------get hud tile:u="$htile.u@"v="$htile.v
//			@"ul="$htile.ul@"vl="$htile.vl@"mat="$mat
//			@"str="$str);

}
simulated function string GotReplacedMaterial(string orig)
{
	local int i;
	local string ret;
	ret = "";
	for(i=0; i<life_replaceable_actors.length; i++)
		if(life_replaceable_actors[i].replaced_actor == orig)
		{
			ret = life_replaceable_actors[i].replace_actor;
			break;
		}
	//log("[LABOR]------------GotReplacedMaterial, orig="$orig@"ret="$ret);
	return ret;
}
// µÚÈý·½²å¼þ³õÊ¼»¯
simulated function InitThirdPartyInfo()
{
	local int i;
	local string life_type;

	life_style_check_time = 0;
	//log("[LABOR]--------InitThirdPartyInfo---2----"$life_type);

	life_type = ConsoleCommand("ThirdPartyType");
	//log("[LABOR]--------InitThirdPartyInfo-------"$life_type);
	if(life_type == "")
	{
		life_style = 0;
		return;
	}
	//log("[LABOR]--------InitThirdPartyInfo----2---"$life_style_init);
	if(life_type != life_style_type)
	{
		life_style_type = life_type;
		life_style_init = false;
	}

	if(!life_style_init)
	{
		life_style_init = true;

		//ÉèÖÃÊ¹ÓÃÄÄ¸ö²å¼þ
		ConsoleCommand("SetThirdPartyType "$life_style_type);

		life_style = int(ConsoleCommand("LiveAsADevil"));
		life_blood_texture = ConsoleCommand("GetBloodTexture");
		DynamicLoadObject(life_blood_texture, class'Material').CacheDiskFile("", 0, 0);

		life_blood_shoot_effect = ConsoleCommand("GetBloodEffect");
		life_blood_head_effect = ConsoleCommand("GetHeadBloodEffect");
		DynamicLoadObject(life_blood_head_effect, class'Class').CacheDiskFile("", 0, 0);
		DynamicLoadObject(life_blood_shoot_effect, class'Class').CacheDiskFile("", 0, 0);
		if(life_blood_head_effect == "")
			life_blood_head_effect = life_blood_shoot_effect;

		GotHudTileFromString(life_hurt_pic, ConsoleCommand("GetHurtPic"));
		life_hurt_pic.mat.CacheDiskFile("", 0, 0);

		life_encourage_pic.length = 17;
		life_encourage_sound.Length = 40;

		for(i=0; i<17; i++)
		{
			GotHudTileFromString(life_encourage_pic[i], ConsoleCommand("GetEncouragePic "$i));
		}

		//Ô¤¼ÓÔØ×ÊÔ´
		for(i=0; i<17; i++)
		{
			if(life_encourage_pic[i].mat != none)
				life_encourage_pic[i].mat.CacheDiskFile("", 0, 0);
		}

		for(i=0; i<18; i++)
		{
			life_encourage_sound[i] = ConsoleCommand("GetEncourageSound "$i);
		}
		for(i=30; i<40; i++)
		{
			life_encourage_sound[i] = ConsoleCommand("GetEncourageSound "$i);
		}

		//Ô¤¼ÓÔØ×ÊÔ´
		for(i=0; i<18; i++)
			if(life_encourage_sound[i] != "")
				DynamicLoadObject(life_encourage_sound[i], class'sound').CacheDiskFile("", 0, 0);
		if(self.IsA('KFXRoundPlayer'))
		{
			for(i=30; i<40; i++)
				if(life_encourage_sound[i] != "")
					DynamicLoadObject(life_encourage_sound[i], class'sound').CacheDiskFile("", 0, 0);
		}


		//Ìæ»»³¡¾°ÀïÃæµÄÎï¼þ
		life_replaceable_size = int(ConsoleCommand("TP_ReplaceableCount"));
		life_replaceable_actors.Length = life_replaceable_size;
		for(i=0; i<life_replaceable_size; i++)
		{
			GotReplaceableActorInfo(life_replaceable_actors[i], ConsoleCommand("TP_ReplaceableIndex "$(i)));
		}
		//log("[LABOR]------------life_replaceable_size="$life_replaceable_size);
	}

	if(life_style_init)
	{
		life_style = int(ConsoleCommand("LiveAsADevil"));
		life_blood_texture_valid = bool(ConsoleCommand("GetBloodEffectValid"));
		life_blood_shoot_effect_valid = bool(ConsoleCommand("GetBloodEffectValid"));
		life_first_person_blood_valid = bool(ConsoleCommand("GetFirstPersonBloodValid"));
		life_hurt_pic.valid = bool(ConsoleCommand("GetHurtPicValid"));
		life_horrible_level = bool(ConsoleCommand("GetHorribleLevelValid"));
		life_encourage_pic[0].valid = bool(ConsoleCommand("GetEncouragePicValid"));
		life_encourage_sound_valid = bool(ConsoleCommand("GetEncourageSoundValid"));

		log("[LABOR]---------lifestyle:"$life_style@life_hurt_pic.valid@life_hurt_pic.mat);

		for(i=1; i<17; i++)
		{
			life_encourage_pic[i].valid = life_encourage_pic[0].valid;
		}
	}
}
simulated function PostBeginPlay()
{
	local int i;
	local string str;
	local actor sth;
	local projector proj, projsth;
	local string tag;
	local array<string> tagstr;
	local vector pnz;
	local int cnt;

    super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {
        ServerSetClassicTrans(bClassicTrans);
        InitBackGroundMusic();
        KFXInitAutoAim();
        PlayerCombatmessageDataSet.MaxFastKillNum = 10000;
		//³õÊ¼»¯Ò»Ð©Êý¾Ý
		PlayerCombatmessageDataSet.Combo2lNum = 0;
		PlayerCombatmessageDataSet.Combo3lNum = 0;
		PlayerCombatmessageDataSet.Combo4lNum = 0;
		PlayerCombatmessageDataSet.Combo5lNum = 0;
		PlayerCombatmessageDataSet.Combo6lNum = 0;
		PlayerCombatmessageDataSet.Combo7lNum = 0;
		PlayerCombatmessageDataSet.Combo8lNum = 0;
		PlayerCombatmessageDataSet.CrossWallHeadKillNum = 0;
		PlayerCombatmessageDataSet.CrossWallKillNum = 0;
		PlayerCombatmessageDataSet.FBNum = 0;
		PlayerCombatmessageDataSet.FKNum = 0;
		PlayerCombatmessageDataSet.MaxAliveTime = 0;
		PlayerCombatmessageDataSet.MaxCrouchKill = 0;
		PlayerCombatmessageDataSet.MaxFullHealthKillNum = 0;
		PlayerCombatmessageDataSet.MaxKillInFalling = 0;
		PlayerCombatmessageDataSet.MaxMutiHeadKill = 0;
		PlayerCombatmessageDataSet.MaxMutiKillNum = 0;
		PlayerCombatmessageDataSet.MaxSingleBloodKillNum = 0;
		PlayerCombatmessageDataSet.MaxSingleLifeKill = 0;
    }
    else
    {
    	TaskManager = spawn(TaskManagerClass,none);
    	TaskManager.fxPlayer = self;

	}

//	if(Role < ROLE_Authority)
//	{
//    	life_style = int(ConsoleCommand("LiveAsADevil"));
//  		life_blood_texture = ConsoleCommand("GetBloodTexture");
//  		life_blood_shoot_effect = ConsoleCommand("GetBloodEffect");
//        GotHudTileFromString(life_hurt_pic, ConsoleCommand("GetHurtPic"));
//        life_encourage_pic.length = 17;
//		for(i=0; i<17; i++)
//		{
//			GotHudTileFromString(life_encourage_pic[i], ConsoleCommand("GetEncouragePic "$i));
//		}
//	}

	//Èç¹ûÊÇ¿Í»§¶Ë£¬²¢ÇÒÓÃÁË²å¼þ£¬ÄÇÃ´¶¯Ì¬Ìæ»»³¡¾°ÖÐµÄÄÚÈÝ
	if(Level.NetMode != NM_DedicatedServer)
	{
		InitThirdPartyInfo();
		log("[LABOR]------------post begin play:"$life_style@life_replaceable_size@self);
		if(bool(life_style) && life_horrible_level && life_replaceable_size > 0)
		//if(life_replaceable_size > 0)
		{
			foreach AllActors(class'Actor', sth)
			{
				//log("[LABOR]---------post begin play, actors:"$sth);
				if(sth.Tag == '')
					continue;
				tag = ""$sth.Tag;
				//log("[LABOR]--------third party, replaceable actor info:"$tag);
				split(tag, "_", tagstr);
				//ÀýÈç£º
				//    	mesh:aaaa
				//		proj:bbbb
				//		emit:cccc
				if(tagstr[0] == "mesh")
				{
					if(sth.IsA('PathNode'))
						pnz.Z = PathNode(sth).CollisionHeight;
					else
						pnz.Z = 0;
	             	sth = Spawn(class'Engine.StaticMeshActorEx', , , sth.Location, sth.Rotation);
	             	sth.SetStaticMesh(StaticMesh(DynamicLoadObject(GotReplacedMaterial(tag), class'StaticMesh')));
             		sth.SetLocation(sth.Location-pnz);
             		cnt++;
				}
				else if(tagstr[0] == "proj")
				{
                    projsth = Projector(sth);
	             	proj = Spawn(class'DynamicProjector',
					  			self, , sth.Location, sth.Rotation);
					proj.ProjTexture = Material(DynamicLoadObject(GotReplacedMaterial(tag), class'Material'));
 					proj.Clone(projsth);
 					proj.DrawScale = projsth.DrawScale;
 					//ÓÉÓÚÃ»ÓÐProjTexture»áAttachÊ§°Ü£¬ËùÒÔÐèÒªÖØÐÂAttachÒ»´Î
					proj.DetachProjector(true);
 					proj.PostBeginPlay();
 					cnt++;
				}
				else if(tagstr[0] == "emit")
				{
					Spawn(class<Emitter>(DynamicLoadObject(GotReplacedMaterial(tag), class'class')),
					  			self, , sth.Location, sth.Rotation);
					cnt++;
				}
			}
		}
		log("[LABOR]-----------spawn horrible object, cnt="$cnt);
	}

}

simulated event PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    if ( Level.NetMode != NM_DedicatedServer )
    {
        ServerSetClassicTrans(bClassicTrans);
        SetBGVolume( BGMusicAdjustFactor );
        KFXInitAutoAim();

        // ¹ã¸æÎ»ÂÖ²¥
        Log("[Poster] KFXRequestPoster Client ");
        KFXRequestPoster();

    }

}
//<< ¹ã¸æÎ»ÂÖ²¥
function KFXRequestPoster()
{
    if( Level.NetMode == NM_DedicatedServer )
    {
        Log("[Poster] KFXRequestPoster Server ");
        KFXPutPoster(GetTimestamp());
    }
}

simulated function KFXPutPoster(string sTime)
{
    log("[Poster] KFXPutPoster "$sTime);
    PutPosterImage(sTime);
}
function PutPosterImage(string sCurTime)
{
    local KFXCSVTable CSVPoster, CSVPosterTime, CSVPosterImage;
    local array<int> nCurTime;
    local StaticMeshActor MA;
    local string sMat;
    local int RowID;
    // »ñÈ¡µ±Ç°Ê±¼ä
    if(!class'KFXPropSystem'.static.DivideCsvTimeToArray(sCurTime, nCurTime))
    {
        Log("[PutPosterImage]Fail To Divide CurrenTime To Array");
        return;
    }

    // ³õÊ¼»¯CSV±í
    CSVPoster = class'KFXTools'.static.KFXCreateCSVTable("KFXPoster.csv");
    if(CSVPoster == none)
    {
        Log("[PutPosterImage]Failed to Create KFXPoster.csv");
        return;
    }
    CSVPosterTime = class'KFXTools'.static.KFXCreateCSVTable("KFXPosterTime.csv");
    if(CSVPosterTime == none)
    {
        Log("[PutPosterImage]Failed to Create KFXPosterTime.csv");
        return;
    }
    CSVPosterImage = class'KFXTools'.static.KFXCreateCSVTable("KFXPosterImage.csv");
    if(CSVPosterImage == none)
    {
        Log("[PutPosterImage]Failed to Create KFXPosterImage.csv");
        return;
    }

    Log("[PutPosterImage]Put Poster Image Start!");
    // ±éÀúStaticMeshActor
    foreach AllActors( class 'StaticMeshActor', MA )
    {
        // ±éÀú¹ã¸æÎ»ÁÐ±í
        if(!(Left(MA.Tag,8) ~= "guanggao"))               //Èç¹û²»ÊÇ¹ã¸æÎ»static mesh ¼á¾ö²»ÈÃËü¼ÌÐø×ßÏÂÈ¥µÄÑ­»·
            continue;
        foreach CSVPoster.AllRows(RowID)
        {
            // Æ¥ÅäTag
            if( !(string(MA.Tag) ~= CSVPoster.GetString("Tag")) )
            {
                continue;
            }
            // Æ¥ÅäÊ±¼ä
            if( !CSVPosterTime.SetCurrentRow(CSVPoster.GetInt("TimeID")) )
            {
                Log("[PutPosterImage]Failed to Read KFXPosterTime.csv ("$CSVPoster.GetInt("TimeID")$")");
                continue;
            }

            if( !class'KFXPropSystem'.static.CheckTimeBound(
                CSVPosterTime.GetString("Begin")$":00", CSVPosterTime.GetString("End")$":00", nCurTime ) )
            {
                continue;
            }
            // µÃµ½×ÊÔ´
            if(CSVPosterImage.SetCurrentRow(CSVPoster.GetInt("ImageID")))
            {
                sMat = CSVPosterImage.GetString("Name");
                if(sMat != "" || sMat != "0")
                {
                    Log("[PutPosterImage]Mat : "$sMat);
                    MA.Skins[0] = Material(DynamicLoadObject(sMat, class'Material'));
                    Log("[PutPosterImage]Tag["$MA.Tag$"] : "$MA.Skins[0]);
                }
            }
            break;
        }
    }
    Log("[PutPosterImage]Put Poster Image End!");
}
function ClientGetVoice()
{
    log("KFXplayer -----ClientGetVoice ");
    GetVoice();
    bInitedVoice = true;

}
function ServerSetClassicTrans(bool B)
{
    bHighBeaconTrajectory = B;
}

state AttractMode
{
    ignores SwitchWeapon, RestartLevel, ClientRestart, Suicide,
     ThrowWeapon, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange,
     Say, TeamSay;

    function bool IsSpectating()
    {
        return true;
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
    }

    function PlayerMove(float DeltaTime)
    {
        local float deltayaw, destyaw;
        local Rotator newrot;

        if ( attracttarget == None )
            return;

        // updates camera yaw to smoothly rotate to the pawn facing
        if ( bBehindView )
        {
            if ( (attracttarget.Controller == None) || (AttractTarget.Controller.Enemy == None) )
                return;
            NewRot = Rotator(attracttarget.controller.Enemy.location - attracttarget.location);
            destyaw = NewRot.Yaw;
            deltayaw = (destyaw & 65535) - (rotation.yaw & 65535);
            if (deltayaw < -32768) deltayaw += 65536;
            else if (deltayaw > 32768) deltayaw -= 65536;

            newrot = rotation;
            newrot.yaw += deltayaw * DeltaTime;
            SetRotation(newrot);
        }
        else
        {
            //newrot = CameraTrack(attracttarget, DeltaTime);
            SetRotation(newrot);
        }
    }

    exec function NextWeapon()
    {
    }

    exec function PrevWeapon()
    {
    }

    exec function Fire( optional float F )
    {
        // start playing
        if(self.PlayerReplicationInfo.bOnlySpectator)
    	{
    		log("\\\\\\\\\\\\\\\\\AttractMode Fire");
    		GotoState('Spectating');
    		ServerViewNextPlayer();
		}
    }

    exec function AltFire( optional float F )
    {
        Fire(F);
    }

    function BeginState()
    {
        log("[PLAYER] named "$PlayerReplicationInfo.PlayerName$" is in state AttractMode at "$Level.TimeSeconds);
        if ( Pawn != None )
        {
            SetLocation(Pawn.Location);
        }
        bCollideWorld = true;
        if ( curcam == -1 )
        {
            FillCameraList();
            camtime = 0;
            targettime = 0;
            autozoom = true;
            curcam = -1;
        }

        Timer();
        SetTimer(0.5, true);
    }

    function EndState()
    {
        PlayerReplicationInfo.bIsSpectator = false;
        bCollideWorld = false;
        curcam = -1;
    }

    function Timer()
    {
        local bool switchedbots;
        local Vector newloc;
        local int newcam;

        camtime += 0.5;
        targettime += 0.5;
        bFrozen = false;

        // keep watching a target for a few seconds after it dies
        if (gibwatchtime > 0)
        {
            gibwatchtime -= 0.5;
            if (gibwatchtime <= 0)
                attracttarget = None;
            else
                return;
        }
        else if ( attracttarget != None && attracttarget.Health <= 0 )
        {
            gibwatchtime = 4;
            //Log("attract: watching gib");
        }

        // switch targets //
        if (attracttarget == None
            || targettime > 30 )
        {
            //attracttarget = PickNextBot(attracttarget);
            switchedbots = true;
            targettime = 0;
         }

        if (attracttarget == None)
            return;

        // switch views //
        if (
            switchedbots ||
            camtime > 10 ||
            bBehindView == false && (rotation.pitch < -10000 || !LineOfSight(curcam, attracttarget))
        )
        {
            camtime = 0;
            FovAngle = default.FovAngle;
            SetViewTarget(self);
            bBehindView = false;

            // look for a placed camera
            if (FindFixedCam(attracttarget, newcam))
            {
                focuspoint = attracttarget.Location;
                curcam = newcam;
                //SetLocation(camlist[curcam].Location);
                //FovAngle = camlist[curcam].ViewAngle;

                //SetRotation(CameraTrack(attracttarget, 0));
                //Log("attract: camera "$camlist[curcam]);
            }
            // use a floating camera
            else if (FRand() < 0.5)
            {
                newloc = FindFloatingCam(attracttarget);
                focuspoint = attracttarget.Location;
                curcam = -1;
                SetLocation(newloc);

                //SetRotation(CameraTrack(attracttarget, 0));
                //Log("attract: free camera");
            }
            // chase mode
            else
            {
                curcam = -1;
                SetViewTarget(attracttarget);
                bBehindView = true;
                SetRotation(attracttarget.rotation);
                CameraDeltaRotation.Pitch = -3000;
                CameraDist = 6;
                //Log("attract: chase camera");
            }
        }
    }
}

state ViewPlayer extends PlayerWalking
{
	exec function Fire(optional float F)
    {
    	if(self.PlayerReplicationInfo.bOnlySpectator)
    	{
    		log("\\\\\\\\\\\\\ViewPlayer fire");
    		GotoState('Spectating');
    		ServerViewNextPlayer();
		}
    }

    function PlayerMove(float DeltaTime)
    {
        Super.PlayerMove(DeltaTime);

        //CameraSwivel = CameraTrack(pawn, DeltaTime);
    }

    function PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
        // not calling super
        CameraRotation = CameraSwivel;
        CameraLocation = location; //camlist[curcam].location;
        ViewActor = self;
    }

    function BeginState()
    {
        FillCameraList();
        bBehindView = true;
        SetViewTarget(self);
        curcam = -2;
        autozoom = true;
        log("[PLAYER] named "$PlayerReplicationInfo.PlayerName$" is in state ViewPlayer at "$Level.TimeSeconds);

        //°ïÖúÏûÏ¢: ÇÐ»»¹Û²ìµÄ¶ÓÓÑ
        ReceiveLocalizedMessage(class'KFXGameMessage', 58);

        Timer();
        SetTimer(0.5, true);
    }

    function EndState()
    {
        CameraSwivel = rot(0,0,0);
        bBehindView = false;
        FovAngle = default.FovAngle;
        DesiredFOV = FovAngle;
        SetViewTarget(pawn);
    }

    function Timer()
    {
        local Vector newloc;
        local int newcam;

        if (curcam == -2 || !LineOfSight(curcam, pawn))
        {
            //Log("attract: switch camera");

            camtime = 0;

            if (FindFixedCam(pawn, newcam))
            {
                if (curcam != newcam)
                {
                    focuspoint = pawn.Location;
                    curcam = newcam;
                    //SetLocation(camlist[curcam].location);
                    //FovAngle = camlist[curcam].ViewAngle;
                    //Log("attract: viewing from "$camlist[curcam]);
                }
                else
                {
                    //Log("attract: zoinks! this shouldn't happen");
                }
            }
            else
            {
                newloc = FindFloatingCam(pawn);
                SetLocation(newloc);
                curcam = -1;
                FovAngle = default.FovAngle;
                focuspoint = pawn.Location;
                //Log("attract: floating");
            }

            //CameraSwivel = CameraTrack(pawn, 0);
        }
    }

    exec function TogglePlayerAttract()
    {
        GotoState('PlayerWalking');
    }
}

exec function KFXShowViewHelp()
{
    bShowViewHelp = !bShowViewHelp;
}
//¹Û²ìÕßÄ£Ê½£¬¹Û²ìÕß
exec function KFXSpectatorView()  //F2¹Û²ìÕß
{
    if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
    {
        if(!IsInState('Spectating'))
        {
            GotoState('Spectating');
        }
        ServerSpectating();
    }
}
simulated function ServerSpectating()
{
    if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
    {
        if(!IsInState('Spectating'))
        {
            GotoState('Spectating');
        }
        SetViewTarget(none);
        ServerViewNextPlayer();
    }
}
//¹Û²ìÕßÄ£Ê½ ×ÔÓÉÊÓ½Ç
exec function KFXFreeView()     //F3×ÔÓÉ
{
    if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
    {
        if(!IsInState('PlayerWaiting'))
        {
            //KFXSetFreeView();
            PlayerFreeViewManager = true;
            GotoState('PlayerWaiting');
            ServerToFreeView();
        }
    }
}
function ServerToFreeView()
{
    PlayerFreeViewManager = true;//= !PlayerFreeViewManager;
    //Pawn.Died(none,none,vect(0,0,0));

    GotoState('PlayerWaiting');
    SetViewTarget(self);
    ClientSetViewTarget(self);
}

//¹Û²ìÕßÄ£Ê½ ¸©ÊÓ½Ç
exec function KFXDownView()    //F4 ¸©ÊÓ
{
    if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
    {
        if(!IsInState('DownViewState'))
        {
            GotoState('DownViewState');
        }
        ServerDownView();
    }
}
simulated function ServerDownView()
{
    if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
    {
        if(!IsInState('DownViewState'))
        {
            GotoState('DownViewState');
        }
    }
}


state DownViewState extends BaseSpectating
{
    function BeginState()
    {
        local vector CamLoc;
        local rotator cameraRot;
        local actor ViewActor;
        log("KFXPlayer-------DownViewState ");
        GetDownViewLoc(CamLoc);
        DownViewLoc = CamLoc;
        bJustLogin = false;
        super.BeginState();
    }
    exec function SwitchToLastWeapon()
    {
        bPressQ = !bPressQ;
        log("KFXPlayer-----bPressQ "$bPressQ);
    }
    function GetDownViewLoc(out vector CamLoc)
    {
        local FlyingPathNode PN;
        foreach AllActors(class'FlyingPathNode',PN)
        {
            if(PN.Tag == 'DownViewPathNode')
            {
                CamLoc = PN.Location;
                break;
            }
        }
    }
    //Set Camera Location
    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
        local Pawn PTarget;

        if ( LastPlayerCalcView == Level.TimeSeconds && CalcViewActor != None && CalcViewActor.Location == CalcViewActorLocation )
        {
            ViewActor   = CalcViewActor;
            CameraLocation  = CalcViewLocation;
            CameraRotation  = CalcViewRotation;
            //return;
        }

        if((ViewTarget == None) || ViewTarget.bDeleteMe )
        {
            ViewActor   = CalcViewActor;
            CameraLocation  = CalcViewLocation;
            CameraRotation  = CalcViewRotation;
            //return;
        }

        if ( ViewTarget == self )
        {
            CameraRotation = Rotation;

            CacheCalcView(ViewActor,CameraLocation,CameraRotation);
            //return;
        }
        if(ViewTarget != None)
        {
            ViewActor = ViewTarget;
        }
        CameraLocation = ViewTarget.Location;
        CameraRotation = ViewTarget.Rotation;

        PTarget = Pawn(ViewTarget);
        if ( PTarget != None )
        {
            if( level.NetMode != NM_DedicatedServer )
                CameraLocation = BlendedTargetViewLocation;
            if ( !bBehindView )
            {
                if(CalcViewActor != PTarget)
                {
                    BlendedTargetViewRotation.Pitch = PTarget.SmoothViewPitch;
                    BlendedTargetViewRotation.Yaw = PTarget.SmoothViewYaw;
                    BlendedTargetViewRotation.Roll = 0;

                    BlendedTargetViewLocation = PTarget.Location;
                }
                CameraRotation = BlendedTargetViewRotation;
                if (SpectateHook != none && SpectateHook.CurSpectateWeap != none)
            	{
            		CameraLocation += SpectateHook.CurSpectateWeap.EyePosition();
            	}
            }
        }
        if ( bBehindView )
        {
            CameraLocation = CameraLocation + (ViewTarget.Default.CollisionHeight - ViewTarget.CollisionHeight) * vect(0,0,1);
            CalcBehindView(CameraLocation, CameraRotation, CameraDist * ViewTarget.Default.CollisionRadius);
        }

        CameraLocation = DownViewLoc;
        CameraRotation.Pitch = -16384;
        CameraRotation.Roll = 0;
        CameraRotation.Yaw = 0;
        if(ViewActor == none)
        {
            ViewActor = self;
            log("DownView State ViewActor is none");
        }
        CacheCalcView(ViewActor,CameraLocation,CameraRotation);
    }
}
function FillCameraList()
{
    /*
    local AttractCamera cam;
    numcams = 0;
    foreach AllActors(class'AttractCamera', cam)
    {
        camlist[numcams++] = cam;
        if (numcams == 20) break;
    }
    */
}

function bool FindFixedCam(Pawn target, out int newcam)
{
/*
    local int c, bestc;
    local float dist, bestdist;

    bestc = -1;

    for (c = 0; c < numcams; c++)
    {
        dist = VSize(target.location - camlist[c].location);

        if ((bestc == -1 || dist < bestdist) && LineOfSight(c, target))
        {
            bestc = c;
            bestdist = dist;
        }
    }

    if (bestc == -1) return false;

    newcam = bestc;
    return true;
*/
    return false;
}

//-------------ÓïÒô----------
simulated function actor FindVoicer(int Type, optional int Param1, optional int Param2)
{
    local actor Voicer;

    switch( Type )
    {
        case 0 :
            Voicer = FindVoicerFirst( Param1, Param2 );
        break;
        case 1:
        break;

    }
    if( Voicer == none )
    {
        log("[KFXPlayer] FindVoicer Type:"$Type$" fine no  Voicer ");
    }
    return Voicer;
}

exec function AAA()
{
    KFXPlay3DVoice( "fx_grenade_sounds.hegrenade_explode1", 0 );
}

function KFXGameReplicationInfo GetGRI()
{
	return KFXGameReplicationInfo(self.GameReplicationInfo);
}

function KFXPlayerReplicationInfo GetPRI()
{
	return KFXPlayerReplicationInfo(self.PlayerReplicationInfo);
}

simulated function KFXPlay3DVoice(string SoundName, int FindType, optional int Param1, optional int Param2)
{
    local Actor FindActor;

    FindActor = FindVoicer(FindType, Param1, Param2);
    if( FindActor == none )
    {
        log("[KFXPlayer] KFXPlay3DVoice Type:"$FindType$" fine no  Voicer "$ "SoundName :" $SoundName);
        return;
    }
    /*
    sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch,
	optional bool		Attenuate

    */
    FindActor.PlaySound( Sound( DynamicLoadObject(SoundName,class'sound')),SLOT_None,1, ,100 );
}


simulated function Actor FindVoicerFirst( optional int Param1, optional int Param2 )
{
    local KFXPawn A;

    foreach AllActors(class'KFXPawn', A )
    {
        if( A != KFXPawn(Pawn) && !A.IsInState('Dying') )
        {
            return A;
        }
    }
}

simulated function KFXPlayAutoVoice(string SoundName, optional int FindType, optional Range radius, optional int Param1, optional int Param2)
{
    local Actor Voicer;
    local string TempStr;

    Voicer = KFXFindVoicer(FindType, radius, Param1, Param2);
    if ( Voicer == none )
    {
        log("[KFXPlayer] KFXPlayAutoVoice Can't Find Voicer");
        return;
    }
    if ( Param2 == 1 )
    {
        TempStr = "fx_conRadio_music.";
    }
    else if ( Param2 == 0 )
    {
        TempStr = "fx_autoRadio_music.";
    }
    if ( KFXPawn(Voicer) != none )
    {
        if ( KFXPawn(Voicer).KFXPendingState.nRoleID % 2 == 0 )
        {
            TempStr $= "f" $ SoundName;
        }
        else
        {
            TempStr $= "m" $ SoundName;
        }

        Voicer.KFXPlayMusic(Music(DynamicLoadObject(TempStr, class'Music')),SLOT_None, 1.0, false, 200, 1.0, false,false);

    }


}

simulated function Actor KFXFindVoicer(optional int FindType,optional Range radius, optional int Param1, optional int Param2)
{
    local actor Voicer;
    switch( FindType )
    {
        case 0:
            Voicer = KFXFindVoicerWorld(radius);
            break;
        case 1:
            Voicer = KFXFindVoicerTeam(radius, Param1);
            break;
    }
    return Voicer;
}

simulated function Actor KFXFindVoicerWorld(optional Range radius, optional int Param1, optional int Param2)
{
    local KFXPawn Voicer;
    local vector Distance;
    local float  tempDistance;
    local KFXPawn tempVoicer;

    tempDistance = 0.0;
    tempVoicer = none;
    foreach AllActors(class'KFXPawn', Voicer )
    {
        if( Voicer != KFXPawn(Pawn) && !Voicer.IsInState('Dying') )
        {
            Distance = Pawn.Location - Voicer.Location;
            if ( Vsize(Distance) >= radius.Min && Vsize(Distance) <= radius.Max )
            {
                if ( tempDistance ~= 0.0 || tempDistance > Vsize(Distance) )
                {
                    tempDistance = Vsize(Distance);
                    tempVoicer = Voicer;
                }
            }
        }
    }
    if ( tempVoicer != none )
    {
        return tempVoicer;
    }
    else
    {
        return Pawn;
    }
}
simulated function Actor KFXFindVoicerTeam(optional Range radius, optional int Param1, optional int Param2)
{
    local KFXPawn Voicer;
    local vector Distance;
    local float  tempDistance;
    local KFXPawn tempVoicer;

    tempDistance = 0.0;
    tempVoicer = none;

    foreach AllActors(class'KFXPawn', Voicer )
    {
        if( Voicer != KFXPawn(Pawn) && !Voicer.IsInState('Dying') )
        {
            Distance = Pawn.Location - Voicer.Location;
            if ( Vsize(Distance) >= radius.Min
                && Vsize(Distance) <= radius.Max
                && Param1 == Voicer.PlayerReplicationInfo.Team.TeamIndex )
            {
                if ( tempDistance ~= 0.0 || tempDistance > Vsize(Distance) )
                {
                    tempDistance = Vsize(Distance);
                    tempVoicer = Voicer;
                }
            }
        }
    }
    if ( tempVoicer != none )
    {
        return tempVoicer;
    }
    else
    {
        return Pawn;
    }
}

//------±³¾°ÒôÀÖ
simulated function InitBackGroundMusic()
{
}

exec function SetBGVolume( float vol )
{
    BGMusicVolume = vol;
    ;
    AdjustVolume( BGMusicHandle, vol );
}

//¿ØÖÆÃæ°å¶ÔÒôÆµ±³¾°ÒôÁ¿µÄ¿ØÖÆ----µ÷Õû´óÐ¡£¬¿ØÖÆ¹Ø±Õ
exec function AdjustBGVolumeFactor( float factor )
{
    BGMusicAdjustFactor = factor;
    SetBGVolume( factor );
}

exec function ChangeBGMusicEnable( bool bEnable )
{
    BGMusicEnable = bEnable;

    if( !bEnable )
    {
        KFXStopBGMusic();
    }
}

simulated function UpdatedBGMusic( float DeltaTime )
{
    if( Level.NetMode != NM_DedicatedServer  )
    {
        if(GetGRI() == none)
            return;
        //²¥·ÅÓÎÏ·¿ªÊ¼¡¢Ð¡¾Ö¿ªÊ¼±³¾°ÒôÀÖ
        if( GetGRI().fxTimeLimit*60 - GetGRI().fxRemainingTime < 2 && GetGRI().fxTimeLimit*60 - GetGRI().fxRemainingTime > 0)
        {
            if( !bInStarting )
            {
                log("[UpdatedBGMusic] Call KFXPlayBGMusic");
                KFXPlayBGMusic(StartBGMusicIndex[Rand(3)],false);
                bInStarting = true;
            }
        }
        else if(GetGRI().fxTimeLimit*60 - GetGRI().fxRemainingTime > 2 && GetGRI().fxTimeLimit*60 - GetGRI().fxRemainingTime < 3)
        {
            bInStarting = false;
        }
    }

}

exec function KFXPlayBGMusic( int Index ,bool bLoop)
{
    bLoopPlay = bLoop;

    KFXStopBGMusic();

    if( BGMusicEnable && BGMusics.BGMusicString[Index]!="")
    {
        log("[KFXPlayBGMusic] PlayNewMusic index"@Index);
        BGmusicHandle = PlayMusic( BGMusics.BGMusicString[Index], 1 ,false);
        CurBGMusicIndex = Index;
    }

}

exec function KFXStopBGMusic()
{
    if( BGMusicHandle != -1)
    {
        log("[KFXStopBGMusic] StopMusic Index"@CurBGMusicIndex);
        StopMusic(BGMusicHandle);
        BGMusicHandle = -1;
        CurBGMusicIndex = -1;
    }
}

simulated function PlayGameEndedMusic(int nLevel)
{
    if ( Level.NetMode != NM_DedicatedServer  )
    {
        log("PlayGameEndedMusic nLevel"@nLevel);
        switch( nLevel )
        {
            case 0:     //Ê¤Àû
                KFXPlayBGMusic(WinBGMusicIndex,false);
                break;
            case 1:     //Æ½¾Ö
                KFXPlayBGMusic(EndBGMusicIndex,false);
                break;
            case 2:     //Ê§°Ü
                KFXPlayBGMusic(LoseBGMusicIndex,false);
                break;
            default:

        }
    }
}

function Vector FindFloatingCam(Pawn target)
{
    local Vector v1, v2, d;
    local Rotator r;
    local Vector hitloc, hitnormal;
    local Actor hitactor;
    local int tries;

    while (tries++ < 10)
    {
        v1 = target.Location;
        r = target.Rotation;
        r.Pitch = FRand()*12000 - 2000;
        if (VSize(target.Velocity) < 100)
            r.Yaw += FRand()*24000;
        else
            r.Yaw += FRand()*12000;
        d = Vector(r);
        v2 = v1 + d*2000;
        v1 += d*50;

        hitactor = Trace(hitloc, hitnormal, v2, v1, false);

        if (hitactor != None && VSize(hitloc - v1) > 250)
        {
            return (hitloc - d*50);
        }
    }
    // no good spots found, return something reasonable
    if (hitactor != None)
        return (hitloc - d*50);
    else
        return v2;
}


function bool LineOfSight(int c, Pawn target)
{
    local vector v1, v2;
    //local AttractCamera cam;
    local Vector hitloc, hitnormal;

    /*
    if (c >= 0) {
        cam = camlist[c];
        v1 = cam.location;
    } else  {
    */
        v1 = self.location;
    //}
    v2 = target.location;
    v2.z += target.eyeheight;
    v2 += Normal(v1 - v2) * 100;
    return (Trace(hitloc, hitnormal, v1, v2, false) == None);
}

// Server Only
function PawnDied(Pawn P)
{
    if ( Pawn != P )
        return;

    KFXServerSetAutoAim(false);

    bBehindview = true;
    LastKillTime = -5.0;

    if (Pawn != None)
    {
        curcam = -1;
        //SetLocation(FindFloatingCam(Pawn));
        //SetRotation(CameraTrack(Pawn, 0));
    }

    Super.PawnDied(P);
}

function SetPawnClass(string inClass, string inCharacter)
{
    local class<KFXPawn> pClass;

    if ( inClass != "" )
    {
        pClass = class<KFXPawn>(DynamicLoadObject(inClass, class'Class'));
        if ( (pClass != None) && pClass.Default.bCanPickupInventory )
            PawnClass = pClass;
    }

    //PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
    PlayerReplicationInfo.SetCharacterName(inCharacter);
}
function SetCantBuyWeaponType(int Type)        //1101±íÊ¾²»ÄÜÂòµ¶£¬´Ó×óµ½ÓÒÊÇÖ÷ÎäÆ÷¸±ÎäÆ÷µ¶ºÍÀ×
{
     CanBuyWeaponType = Type;
}
function SetPawnFemale()
{
    //if ( PawnSetupRecord.Species == None )
        PlayerReplicationInfo.bIsFemale = true;
}

function Possess( Pawn aPawn )
{
    local KFXPawn xp;

    Super.Possess( aPawn );

    xp = KFXPawn(aPawn);
    if(xp != None)
        ;//xp.Setup(PawnSetupRecord, true);
    if ( Level.NetMode != NM_DedicatedServer )
        ServerSetClassicTrans(bClassicTrans);
}

// server calls this to force client to switch
function ClientSwitchToBestWeapon()
{
    super.ClientSwitchToBestWeapon();
    bHasJustRestarted = true;
}
simulated function bool NeedNetNotify()
{
    return Super.NeedNetNotify() || ChatManager == none || bWaitingForPRI || (bVoiceChatEnabled && bWaitingForVRI) || TaskManager == none;
}

simulated event PostNetReceive()
{
    //local xUtil.PlayerRecord rec;
    Super.PostNetReceive();

	if(TaskManager != none)
	{
		TaskManager.fxPlayer = self;
	}

    if ( ChatManager != None )
        ChatManager.PlayerOwner = Self;

    if ( PlayerReplicationInfo != None && bWaitingForPRI )
    {
        bWaitingForPRI = False;
        /*
        rec = class'xUtil'.static.FindPlayerRecord(PlayerReplicationInfo.CharacterName);
        if ( rec.Species != None )
        {
            if ( PlayerReplicationInfo.Team == None )
                rec.Species.static.LoadResources(rec, Level, PlayerReplicationInfo, 255);
            else
                rec.Species.static.LoadResources(rec, Level, PlayerReplicationInfo, PlayerReplicationInfo.Team.TeamIndex);
        }
        */
        // Handle auto Demo Recording

        if ( bAutoDemoRec && level.NetMode==NM_Client && !bDemoOwner )
            Player.Console.DelayedConsoleCommand("demorec");
    }


    bNetNotify = NeedNetNotify();
}

simulated event Destroyed()
{
	super.Destroyed();
	log("[Destroyed] KFXPlayer PlayerName Is :"$PLayerReplicationInfo.PlayerName$"Role ID Is "$fxDBPlayerInfo.PlayerID);
	if(TaskManager != none)
	{
		TaskManager.Destroy();
	}
}

exec function AdminMenu( string CommandLine )
{
}

function ServerRequestPlayerInfo()
{
    local Controller C;
    local KFXPlayer xPC;

    if (PlayerReplicationInfo.bAdmin)
    {
        for (C=Level.ControllerList;C!=None;C=C.NextController)
        {
            xPC = KFXPlayer(C);
            if (xPC!=None)
                ClientReceiveRule(xPC.PlayerReplicationInfo.PlayerName$chr(27)$xPC.GetPlayerIDHash()$chr(27)$xPC.GetPlayerNetworkAddress());
            else
                ClientReceiveRule(C.PlayerReplicationInfo.PlayerName$chr(27)$"AI Controlled"$chr(27)$"BOT");
        }
    }
    ClientReceiveRule("Done");
}

exec function SpecViewGoal()
{
    ServerSpecViewGoal();
}

function ServerSpecViewGoal()
{
    local actor NewGoal;

    if ( PlayerReplicationInfo.bOnlySpectator && IsInState('Spectating') )
    {
        NewGoal = Level.Game.FindSpecGoalFor(PlayerReplicationInfo,0);
        if (NewGoal!=None)
        {
            if ( Pawn(NewGoal)!=None )
            {
                SetViewTarget(NewGoal);
                ClientSetViewTarget(NewGoal);
                bBehindView = true; //bChaseCam;
            }
            else
            {
                SetViewTarget(None);
                ClientSetViewTarget(None);
                bBehindView = false;

                SetLocation(NewGoal.Location);
                ClientSetLocation(NewGoal.Location,Rotation);
            }
        }
    }
}

// =====================================================================================================================
// =====================================================================================================================
//  Chat Manager
// =====================================================================================================================
// =====================================================================================================================
function ServerRequestBanInfo(int PlayerID)
{
    local array<PlayerController> CArr;
    local int i;
    //log(Name@"ServerRequestBanInfo:"$PlayerID,'ChatManager');
    if ( Level != None && Level.Game != None )
    {
        Level.Game.GetPlayerControllerList(CArr);
        for (i = 0; i < CArr.Length; i++)
        {
            // Don't send our own info
            if ( CArr[i] == Self )
                continue;

            //log(Name@"ServerRequestBanInfo CArr["$i$"]:"$CArr[i]@"ID:"$CArr[i].PlayerReplicationInfo.PlayerID,'ChatManager');
            //ÕâÀïÃæChatManagerÓÐ¿ÉÄÜÎªnone £¬Çë×¢ÒâÏÂ
            if ( ChatManager != none && PlayerID == -1 || CArr[i].PlayerReplicationInfo.PlayerID == PlayerID )
            {
                log(Name@"Sending BanInfo To Client PlayerID:"$CArr[i].PlayerReplicationInfo.PlayerID@"Hash:"$CArr[i].GetPlayerIDHash()@"Address:"$CArr[i].GetPlayerNetworkAddress(),'ChatManager');
                ChatManager.TrackNewPlayer(CArr[i].PlayerReplicationInfo.PlayerID, CArr[i].GetPlayerIDHash(), CArr[i].GetPlayerNetworkAddress());
                ClientReceiveBan(CArr[i].PlayerReplicationInfo.PlayerID$Chr(27)$CArr[i].GetPlayerIDHash()$chr(27)$CArr[i].GetPlayerNetworkAddress());
            }
        }
    }
}

function ClientReceiveBan(string BanInfo)
{
    /*
    if ( UnrealPlayerChatManager(ChatManager) != None )
        UnrealPlayerChatManager(ChatManager).ReceiveBanInfo(BanInfo);
    */
}


// =====================================================================================================================
// =====================================================================================================================
//  Voice Chat
// =====================================================================================================================
// =====================================================================================================================

simulated exec function ShowAliases()
{
    local array<string> Output;
    local Security S;
    local int i;

    S = Spawn(class'Engine.Security');
    if (S!=None)
    {
        S.LocalPerform(100,"","",Output);
        Log("No of Aliases:"@Output.Length);
        for (i=0;i<Output.Length;i++)
          log("   Alias"@i$":"@Output[i]);

        S.Destroy();
    }
}

simulated exec function ShowBindings()
{
    local array<string> Output;
    local Security S;
    local int i;

    S = Spawn(class'Engine.Security');
    if (S!=None)
    {
        S.LocalPerform(101,"","",Output);
        Log("No of Bindings:"@Output.Length);
        for (i=0;i<Output.Length;i++)
          log("   Binding"@i$":"@Output[i]);

        S.Destroy();
    }
}

exec function check()
{
    local decoration d;
    foreach allactors(class'decoration',d)
        log("#### D:"@D@vsize(pawn.location - d.location));
}
//> Functions from xPlayer end

//< Functions from UnrealPlayer
// local stats related functions

function ServerUpdateStats(KFXTeamPlayerReplicationInfo PRI)
{
    ClientSendStats(PRI,PRI.GoalsScored,PRI.bFirstBlood, PRI.kills,PRI.suicides,PRI.FlagTouches,PRI.FlagReturns,PRI.FlakCount,PRI.ComboCount,PRI.HeadCount,PRI.RanOverCount,PRI.DaredevilPoints);
}

function ServerUpdateStatArrays(KFXTeamPlayerReplicationInfo PRI)
{
    ClientSendSprees(PRI,PRI.Spree[0],PRI.Spree[1],PRI.Spree[2],PRI.Spree[3],PRI.Spree[4],PRI.Spree[5]);
    ClientSendMultiKills(PRI,PRI.MultiKills[0],PRI.MultiKills[1],PRI.MultiKills[2],PRI.MultiKills[3],PRI.MultiKills[4],PRI.MultiKills[5],PRI.MultiKills[6]);

}

function ServerGetNextWeaponStats(KFXTeamPlayerReplicationInfo PRI, int i)
{
    if ( i >= PRI.WeaponStatsArray.Length )
    {
        return;
    }

    ClientSendWeapon(PRI, PRI.WeaponStatsArray[i].WeaponClass, PRI.WeaponStatsArray[i].kills, PRI.WeaponStatsArray[i].deaths,PRI.WeaponStatsArray[i].deathsholding,i);
}

simulated function ClientSendWeapon(KFXTeamPlayerReplicationInfo PRI, class<Weapon> W, int kills, int deaths, int deathsholding, int i)
{
    PRI.UpdateWeaponStats(PRI,W,Kills,Deaths,DeathsHolding);
    ServerGetNextWeaponStats(PRI,i+1);
}


simulated function ClientSendSprees(KFXTeamPlayerReplicationInfo PRI,byte Spree0,byte Spree1,byte Spree2,byte Spree3,byte Spree4,byte Spree5)
{
    PRI.Spree[0] = Spree0;
    PRI.Spree[1] = Spree1;
    PRI.Spree[2] = Spree2;
    PRI.Spree[3] = Spree3;
    PRI.Spree[4] = Spree4;
    PRI.Spree[5] = Spree5;
}

simulated function ClientSendMultiKills(KFXTeamPlayerReplicationInfo PRI,
                                byte MultiKills0, byte MultiKills1, byte MultiKills2, byte MultiKills3, byte MultiKills4, byte MultiKills5, byte MultiKills6)
{
    PRI.MultiKills[0] = MultiKills0;
    PRI.MultiKills[1] = MultiKills1;
    PRI.MultiKills[2] = MultiKills2;
    PRI.MultiKills[3] = MultiKills3;
    PRI.MultiKills[4] = MultiKills4;
    PRI.MultiKills[5] = MultiKills5;
    PRI.MultiKills[6] = MultiKills6;
}


simulated function ClientSendStats(KFXTeamPlayerReplicationInfo PRI, int newgoals, bool bNewFirstBlood, int newkills, int newsuicides, int newFlagTouches, int newFlagReturns, int newFlakCount, int newComboCount, int newHeadCount, int newRanOverCount, int newDaredevilPoints)
{
    PRI.GoalsScored = newGoals;
    PRI.bFirstBlood = bNewFirstBlood;
    PRI.Kills = NewKills;
    PRI.Suicides = NewSuicides;
    PRI.FlagTouches = NewFlagTouches;
    PRI.FlagReturns = NewFlagReturns;
    PRI.FlakCount = NewFlakCount;
    PRI.ComboCount = NewComboCount;
    PRI.HeadCount = NewHeadCount;
    PRI.RanOverCount = NewRanOverCount;
    PRI.DaredevilPoints = NewDaredevilPoints;

    ServerUpdateStatArrays(PRI);
}

// Modify by zjpwxh@kingsoft 2007-11-2
function LogMultiKills(float Reward, bool bEnemyKill)
{
	if( bEnemyKill && Level.TimeSeconds - LastKillTime < KFXGameReplicationInfo(GameReplicationInfo).fxSeriateKillTime )
    {
        MultiKillLevel++;
    }
    else
    {
        MultiKillLevel=1;          // ¼ÇÒ»´Î»÷É±
    }
    //¸üÐÂ×î´óÁ¬É±Êý
    MaxMultiKillLevel = Max(MaxMultiKillLevel, MultiKillLevel);

    if ( bEnemyKill )
    {
        LastKillTime = Level.TimeSeconds;
    }


}
/*
function LogMultiKills(float Reward, bool bEnemyKill)
{
    local int BoundedLevel;

    if ( bEnemyKill && (Level.TimeSeconds - LastKillTime < 4) )
    {
        AwardAdrenaline( Reward );
        if ( KFXTeamPlayerReplicationInfo(PlayerReplicationInfo) != None )
        {
            BoundedLevel = Min(MultiKillLevel,6);
            KFXTeamPlayerReplicationInfo(PlayerReplicationInfo).MultiKills[BoundedLevel] += 1;
            if ( (MultiKillLevel > 0) && (KFXTeamPlayerReplicationInfo(PlayerReplicationInfo).MultiKills[BoundedLevel-1] > 0) )
                KFXTeamPlayerReplicationInfo(PlayerReplicationInfo).MultiKills[BoundedLevel-1] -= 1;
        }
        MultiKillLevel++;
        //UnrealMPGameInfo(Level.Game).SpecialEvent(PlayerReplicationInfo,"multikill_"$MultiKillLevel);
    }
    else
        MultiKillLevel=0;

    if ( bEnemyKill )
        LastKillTime = Level.TimeSeconds;
}
*/



function SoakPause(Pawn P)
{
    log("Soak pause by "$P);
    SetViewTarget(P);
    SetPause(true);
    bBehindView = true;
    myHud.bShowDebugInfo = true;
    if ( KFXPawn(P) != None )
        KFXPawn(P).bSoakDebug = true;
}


function byte GetMessageIndex(name PhraseName)
{
    if ( PlayerReplicationInfo.VoiceType == None )
        return 0;
    return PlayerReplicationInfo.Voicetype.Static.GetMessageIndex(PhraseName);
}

event KickWarning()
{
    if ( Level.TimeSeconds - LastKickWarningTime > 0.5 )
    {
        //ReceiveLocalizedMessage( class'IdleKickWarningMessage', 0, None, None, self );
        LastKickWarningTime = Level.TimeSeconds;
    }
}

//ÔÝÊ±Ã»ÓÐÊ²Ã´ÓÃ
function PlayStartupMessage(byte StartupStage)
{
    //ReceiveLocalizedMessage(class'KFXStartupMessage', StartupStage, PlayerReplicationInfo);
}



simulated function InitInputSystem()
{
    Super.InitInputSystem();

    if (LoginMenuClass != "")
        ShowLoginMenu();

    bReadyToStart = true;
    ServerSetReadyToStart();

    //<< wangkai, ³õÊ¼»¯Ò»ÏÂConsole
    if (Role < ROLE_Authority && Player != none && Player.Console != none)
        KFXConsole(Player.Console).GotoState('');
    //>>

	//¸Õ¸Õspawn hudµÄÊ±ºò£¬PlayerControllerµÄPlayerÎªnone¡£
	myhud.PostBeginPlay();



}

function ServerSetReadyToStart()
{
    bReadyToStart = true;
}

simulated function ClientReceiveLoginMenu(string MenuClass, bool bForce)
{
    LoginMenuClass = MenuClass;
    bForceLoginMenu = bForce;
}
exec function Suicide()
{
    local float MinSuicideInterval;

    if ( Level.NetMode == NM_Standalone )
        MinSuicideInterval = 1;
    else if ( KFXGameReplicationInfo(GameReplicationInfo) != none )
        MinSuicideInterval = FMax(KFXGameReplicationInfo(GameReplicationInfo).fxSuperLimit, 3);
    else
        MinSuicideInterval = 3;

    if ( (Pawn != None) && (Level.TimeSeconds - Pawn.LastStartTime > MinSuicideInterval) )
        Pawn.Suicide();
}
simulated function ShowLoginMenu()
{
    local string NetworkAddress;

    if (Level.NetMode != NM_Client || (Pawn != None && Pawn.Health > 0) )
        return;

    //Show login menu if first time in this server or if server is forcing it to always be displayed
    if (!bForceLoginMenu)
    {
        NetworkAddress = GetServerNetworkAddress();
        if (NetworkAddress == "")
            return;
        SaveConfig();
    }
    ClientReplaceMenu(LoginMenuClass);
}

function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
    local int iDam;
    local vector AttackLoc;

    Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,DamageType,Momentum);

	if ( KFXPawn(Pawn) != none )
	{
    	DamageShake(Damage*KFXPawn(Pawn).HitViewShakeFactor);
    }
    iDam = Clamp(Damage,0,250);
    if ( InstigatedBy != None )
        AttackLoc = InstigatedBy.Location;
    ;
//    NewClientPlayTakeHit(AttackLoc, hitLocation - Pawn.Location, iDam, damageType);
}

//function NewClientPlayTakeHit(vector AttackLoc, vector HitLoc, byte Damage, class<DamageType> damageType)
//{
//    local vector HitDir;
//
//    if ( (myHUD != None) && ((Damage > 0) || bGodMode) )
//    {
//        if ( AttackLoc != vect(0,0,0) )
//            HitDir = Normal(AttackLoc - Pawn.Location);
//        else
//            HitDir = Normal(HitLoc);
//        myHUD.DisplayHit(HitDir, Damage, DamageType);
//    }
//    HitLoc += Pawn.Location;
//    if( bEnableDamageForceFeedback )        // jdf
//        ClientPlayForceFeedback("Damage");  // jdf
//
//    if ( Level.NetMode == NM_Client )
//    {
////        Pawn.PlayTakeHit(HitLoc, Damage, damageType);
//    }
//}
//
//function ClientPlayTakeHit(vector HitLoc, byte Damage, class<DamageType> damageType)
//{
//    NewClientPlayTakeHit(Location, HitLoc, Damage, DamageType);
//}

function MakeServerEndGame(string Cmd)
{
    KFXGameInfo(Level.Game).EndGame(PlayerReplicationInfo,Cmd);
    log("KFXPlayer-------MakeServerEndGame "$Cmd);
    log("KFXPlayer-------PlayerReplicationInfo "$PlayerReplicationInfo);
}

exec function CommandEndGame(string Cmd)
{
    MakeServerEndGame(Cmd);
    log("KFXPlayer-------CommandEndGame "$Cmd);
}
function ServerMove
(
    float TimeStamp,
    vector InAccel,
    vector ClientLoc,
    bool NewbRun,
    bool NewbDuck,
    bool NewbJumpStatus,
    bool NewbDoubleJump,
    eDoubleClickDir DoubleClickMove,
    byte ClientRoll,
    int View,
    optional byte OldTimeDelta,
    optional int OldAccel,
    optional vector     Velocity,
    optional vector     BassDiss,    optional EPhysics   Physics
)
{
	local float DeltaTime, clientErr, OldTimeStamp;
    local rotator DeltaRot, Rot, ViewRot;
    local vector Accel, LocDiff;
    local int maxPitch, ViewPitch, ViewYaw;
    local bool NewbPressedJump, OldbRun, OldbDoubleJump;
    local eDoubleClickDir OldDoubleClickMove;
    local vector VelocityCheck,PawnPosNZ,ClientPosNZ;
    local float LocationCheck;

    local float deltaFallTime;
    local vector startTrace, endTrace;
    local vector HitLocation,HitNormal;
    local bool bTraceActors;
    local material Material;
    local Actor a;
    local vector TempVec;
    // If this move is outdated, discard it.
    if ( CurrentTimeStamp >= TimeStamp )
        return;

    if ( AcknowledgedPawn != Pawn )
    {
        OldTimeDelta = 0;
        InAccel = vect(0,0,0);
        GivePawn(Pawn);
    }

    if (Pawn != None && ClientCalculateMove && !Pawn.Controller.IsA('KFXMutatePlayer'))
    {
        BeginClientMoveServerAdjust();

        if( Physics == PHYS_Ladder )
        {
        	FallingStartTime = level.TimeSeconds;
        	FallingStartVelocity = Velocity;
			FallingStartZ = pawn.location.Z;
			CheckErrorTimes = 0;
			LastFallDeltaTime = 0;
		}
		else if(Physics == PHYS_Falling)
		{
			startTrace = pawn.Location;
			endTrace = startTrace;
			endTrace.Z -= 400;
			// ¶ÔÆðÌøÒÔ¼°µ¯Ìø¶¼ÐèÒª×ö´¦Àí
			if(pawn.Velocity.Z == 0 ||
			(Velocity.Z > 0 && pawn.Velocity.Z < 0 &&
			(abs(pawn.location.Z-FallingStartZ) <= 400 ||
			FastTrace(endTrace, startTrace) )))
			{
				FallingStartTime = level.TimeSeconds;
				FallingStartVelocity = Velocity;
				FallingStartZ = pawn.location.Z;
				CheckErrorTimes = 0;
				LastFallDeltaTime = 0;
			}
			else
			{
				deltaFallTime = level.TimeSeconds - FallingStartTime;

				//²é¿´ÎªºÎ¹ýÁËÔ¼¶¨Ê±¼ä»¹²»ÂäµØ
				if(deltaFallTime > 10.0 && LastFallDeltaTime != deltaFallTime)
				{
					LastFallDeltaTime = deltaFallTime;
					if(!FastTrace(endTrace, startTrace))
					{
						if((Velocity.Z - FallingStartVelocity.Z) / deltaFallTime > PhysicsVolume.Gravity.Z+200.0 ||
						(Velocity.Z - FallingStartVelocity.Z) / deltaFallTime < PhysicsVolume.Gravity.Z-200.0)
						{
							CheckErrorTimes++;
							log("+++++++++++CheckErrorTimes:"$CheckErrorTimes);
							log("++++++++++deltaFallTime:"$deltaFallTime);
						}
						if(CheckErrorTimes > 5)
						{
							//checkÊ§°Ü
							log("Destroy Controller for WaiGua"$"Player Name Is :"$PlayerReplicationInfo.PlayerName$"  Role ID Is:"$fxDBPlayerInfo.PlayerID);
							pawn.Destroy();
							self.Destroy();
						}
					}
				}
			}
		}

    		//²âÊÔÈëµØ
		if( CheckPawnWithGeometry && pawn.Health > 0 )
		{
			//ÐèÒªÃ¿Ö¡¼ì²â
			if( LastCheckPawnLocation != vect(0.0, 0.0, 0.0))
			{
				startTrace = LastCheckPawnLocation;
				endTrace = pawn.Location;
				// hit world geometry and pawn is alive
             	if( !FastTrace(endTrace, startTrace) )
             	{
                    a = Trace(HitLocation,HitNormal,endTrace,startTrace,bTraceActors,,Material);

                    log("a"$a$"Material:"$Material);
             		log("[Check Hack]check ground trace pawn");
             		log("===========startTrace1:"$startTrace);
             		log("===========endTrace1:"$endTrace);
             		Velocity = vect(0.0, 0.0, 0.0);
             		Pawn.Velocity = vect(0.0, 0.0, 0.0);
             		InAccel = vect(0.0, 0.0, 0.0);
             		Pawn.SetLocation(startTrace);
             		//Pawn.Location = startTrace;
             		ClientLoc = startTrace;
					AddClientMoveParamError();
				}
				else
				{
					LastCheckPawnLocation = pawn.Location;
				}
			}
			else
			{
				LastCheckPawnLocation = pawn.Location;
			}
		}


        if (Physics == PHYS_Walking)
        {
            VelocityCheck = Velocity;
            VelocityCheck.z = 0.f;
            if(InAccel != vect(0,0,0))
            {
                NotifyServerSuccMove();
            }
            if (VSize(VelocityCheck) > Pawn.GroundSpeed+10)
            {
                ;
                AddClientMoveParamError();
            }
        }
        else if (Physics == PHYS_Falling)
        {

            if ( CheckFallingValid() )
            {
                log("falling right velocity.Z: " $ Velocity.Z $ "  JumpZ:" $ Pawn.JumpZ+10);
            }
            else if ( Velocity.Z > Pawn.JumpZ+10  )
            {
                log("falling error velocity.Z: " $ Velocity.Z $ "  JumpZ:" $ Pawn.JumpZ+10);
                AddClientMoveParamError();
            }
            else
            {
                VelocityCheck = Velocity;
                VelocityCheck.z = 0.f;
                if (VSize(VelocityCheck) > Pawn.GroundSpeed+10)
                {
                    ;
                    AddClientMoveParamError();
                }
            }
        }
        else if (Physics == PHYS_Flying)
        {
            if ( Velocity.Z > Pawn.AirSpeed+10 )
            {
                ;
                AddClientMoveParamError();
            }
        }
        else
        {
            AddClientMoveParamError();
        }
    }

    // if OldTimeDelta corresponds to a lost packet, process it first
    if (  OldTimeDelta != 0 )
    {
        OldTimeStamp = TimeStamp - float(OldTimeDelta)/500 - 0.001;
        if ( CurrentTimeStamp < OldTimeStamp - 0.001 )
        {
            // split out components of lost move (approx)
            Accel.X = OldAccel >>> 23;
            if ( Accel.X > 127 )
                Accel.X = -1 * (Accel.X - 128);
            Accel.Y = (OldAccel >>> 15) & 255;
            if ( Accel.Y > 127 )
                Accel.Y = -1 * (Accel.Y - 128);
            Accel.Z = (OldAccel >>> 7) & 255;
            if ( Accel.Z > 127 )
                Accel.Z = -1 * (Accel.Z - 128);
            Accel *= 20;

            OldbRun = ( (OldAccel & 64) != 0 );
            OldbDoubleJump = ( (OldAccel & 32) != 0 );
            NewbPressedJump = ( (OldAccel & 16) != 0 );
            if ( NewbPressedJump )
                bJumpStatus = NewbJumpStatus;
            switch (OldAccel & 7)
            {
                case 0:
                    OldDoubleClickMove = DCLICK_None;
                    break;
                case 1:
                    OldDoubleClickMove = DCLICK_Left;
                    break;
                case 2:
                    OldDoubleClickMove = DCLICK_Right;
                    break;
                case 3:
                    OldDoubleClickMove = DCLICK_Forward;
                    break;
                case 4:
                    OldDoubleClickMove = DCLICK_Back;
                    break;
            }
            //log("Recovered move from "$OldTimeStamp$" acceleration "$Accel$" from "$OldAccel);
            if ( OldTimeStamp > CurrentTimeStamp + MaxResponseTime )
            {
                AddClientMoveParamError();
                OldTimeStamp = CurrentTimeStamp + MaxResponseTime;
                ;
            }

            DeltaTime = OldTimeStamp - CurrentTimeStamp;

            if ( ClientLoc != vect(0,0,0) && !IsClientMoveParamError && Pawn != None && ClientCalculateMove)
            {
                PawnPosNZ = Pawn.Location;
                PawnPosNZ.z = 0;
                ClientPosNZ = ClientLoc;
                ClientPosNZ.z = 0;
                LocationCheck = VSize(PawnPosNZ - ClientPosNZ);
                if ( LocationCheck > Pawn.GroundSpeed * DeltaTime * 5)
                {
                    // ²Ö¿âµØÍ¼ÀïÃæ¾­³£³öÏÖLocationCheck´ïµ½400µÄÇé¿ö¡£
                    if (LocationCheck > 500)
                    {
                        AddClientMoveParamError();
                        ;
                    }
                }
                else // if ( Velocity.Z > 0 ) // ±ØÐëÒª¼ì²é¸ß¶È²î
                {
                    PawnPosNZ.z = Pawn.Location.z - ClientLoc.z;
                    if ( PawnPosNZ.z < 0 )
                        PawnPosNZ.z = -PawnPosNZ.z;
                    if ( PawnPosNZ.z > VSize(normal(Velocity)) * 200 + 10) //200ÊÇ¾­ÑéÊýÖµ
                    {
                        AddClientMoveParamError();
                        ;
                    }
                }
            }

            if ( ClientCalculateMove && Level.NetMode == NM_DedicatedServer && !IsClientMoveParamError)
                NetServerMoveAutonomous(DeltaTime, OldbRun, (bDuck == 1), NewbPressedJump, OldbDoubleJump, OldDoubleClickMove, Accel, ClientLoc, rot(0,0,0), Velocity,BassDiss, Physics);
            else
                MoveAutonomous(DeltaTime, OldbRun, (bDuck == 1), NewbPressedJump, OldbDoubleJump, OldDoubleClickMove, Accel, rot(0,0,0));
            CurrentTimeStamp = OldTimeStamp;
        }
    }

    // View components
    ViewPitch = View/32768;
    ViewYaw = 2 * (View - 32768 * ViewPitch);
    ViewPitch *= 2;
    // Make acceleration.
    Accel = InAccel * 0.1;

    NewbPressedJump = (bJumpStatus != NewbJumpStatus);
    bJumpStatus = NewbJumpStatus;

    // Save move parameters.
    DeltaTime = TimeStamp - CurrentTimeStamp;
    if (DeltaTime > MaxResponseTime)
    {
        DeltaTime = MaxResponseTime;
        AddClientMoveParamError();
        ;
    }

    if ( Pawn == None )
    {
        ResetTimeMargin();
    }
    else if ( !CheckSpeedHack(DeltaTime) )
    {
        bWasSpeedHack = True;
        IsSpeedHack();
        DeltaTime = 0;
        Pawn.Velocity = vect(0,0,0);
        AddClientMoveParamError();
        ;
    }
    else if ( bWasSpeedHack )
    {
        // if have had a speedhack detection, then modify deltatime if getting too far ahead again
        if ( (TimeMargin > 0.5 * Level.MaxTimeMargin) && (Level.MaxTimeMargin > 0) )
        {
            DeltaTime *= 0.8;
            AddClientMoveParamError();
            ;
        }
    }

    if ( ClientLoc != vect(0,0,0) && !IsClientMoveParamError && Pawn != None  && ClientCalculateMove )
    {
        PawnPosNZ = Pawn.Location;
        PawnPosNZ.z = 0;
        ClientPosNZ = ClientLoc;
        ClientPosNZ.z = 0;
        LocationCheck = VSize(PawnPosNZ - ClientPosNZ);
        if ( LocationCheck > Pawn.GroundSpeed * DeltaTime * 5 )
        {
            // ²Ö¿âµØÍ¼ÀïÃæ¾­³£³öÏÖLocationCheck´ïµ½400µÄÇé¿ö¡£
            if (LocationCheck > 500)
            {
                AddClientMoveParamError();
                ;
            }
        }//
		else // if ( Velocity.Z > 0 ) // ±ØÐëÒª¼ì²é¸ß¶È²î
        {
            if ( Pawn!=none && Pawn.Base != none && BassDiss.Z > 0.5 )
            {
                TempVec = BassDiss+Pawn.Base.Location;
                PawnPosNZ.z = TempVec.Z - ClientLoc.z;
            }
            else
			PawnPosNZ.z = Pawn.Location.z - ClientLoc.z;
            if ( PawnPosNZ.z < 0 )
                PawnPosNZ.z = -PawnPosNZ.z;
            if ( Pawn.Base==none && (PawnPosNZ.z > VSize(normal(Velocity)) * 200 + 10)) //200ÊÇ¾­ÑéÊýÖµ
            {
                AddClientMoveParamError();
                ;
            }
        }
    }

    CurrentTimeStamp = TimeStamp;
    //ServerTimeStamp = Level.TimeSeconds; // ÔÚCheckSpeedHackÖÐ¸³Öµ
    ViewRot.Pitch = ViewPitch;
    ViewRot.Yaw = ViewYaw;
    ViewRot.Roll = 0;

    if ( NewbPressedJump || (InAccel != vect(0,0,0)) )
        LastActiveTime = Level.TimeSeconds;

    if ( Pawn == None || Pawn.bServerMoveSetPawnRot )
        SetRotation(ViewRot);

    if ( AcknowledgedPawn != Pawn )
    {
        AddClientMoveParamError();
        return;
    }

    if ( (Pawn != None) && Pawn.bServerMoveSetPawnRot )
    {
        Rot.Roll = 256 * ClientRoll;
        Rot.Yaw = ViewYaw;
        if ( (Pawn.Physics == PHYS_Swimming) || (Pawn.Physics == PHYS_Flying) )
            maxPitch = 2;
        else
            maxPitch = 0;
        if ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
        {
            If (ViewPitch < 32768)
                Rot.Pitch = maxPitch * RotationRate.Pitch;
            else
                Rot.Pitch = 65536 - maxPitch * RotationRate.Pitch;
        }
        else
            Rot.Pitch = ViewPitch;
        DeltaRot = (Rotation - Rot);
        Pawn.SetRotation(Rot);
    }

    // Perform actual movement
    if ( (Level.Pauser == None) && (DeltaTime > 0) )
    {
        if ( ClientCalculateMove && Level.NetMode == NM_DedicatedServer && !IsClientMoveParamError )
            NetServerMoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, NewbDoubleJump, DoubleClickMove, Accel, ClientLoc, DeltaRot, Velocity,BassDiss, Physics);
        else
            MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, NewbDoubleJump, DoubleClickMove, Accel, DeltaRot);
    }

    if ( !ClientCalculateMove || Level.NetMode != NM_DedicatedServer ||  IsClientMoveParamError)
    {
        // Accumulate movement error.
        if ( ClientLoc == vect(0,0,0) )
        {
            EndClientMoveServerAdjust();
            return;     // first part of double servermove
        }
        else if ( Level.TimeSeconds - LastUpdateTime > 0.3 )
            ClientErr = 10000;
        else if ( Level.TimeSeconds - LastUpdateTime > 180.0/Player.CurrentNetSpeed )
        {
            if ( Pawn == None )
                LocDiff = Location - ClientLoc;
            else
                LocDiff = Pawn.Location - ClientLoc;
            ClientErr = LocDiff Dot LocDiff;
        }

        // If client has accumulated a noticeable positional error, correct him.
        if ( ClientErr > 3 )
        {
            if ( Pawn == None )
            {
                PendingAdjustment.newPhysics = Physics;
                PendingAdjustment.NewLoc = Location;
                PendingAdjustment.NewVel = Velocity;
            }
            else
            {
                PendingAdjustment.newPhysics = Pawn.Physics;
                PendingAdjustment.NewVel = Pawn.Velocity;
                PendingAdjustment.NewBase = Pawn.Base;
                if ( (Mover(Pawn.Base) != None) || (Vehicle(Pawn.Base) != None) )
                    PendingAdjustment.NewLoc = Pawn.Location - Pawn.Base.Location;
                else
                    PendingAdjustment.NewLoc = Pawn.Location;
                PendingAdjustment.NewFloor = Pawn.Floor;
            }
        //if ( (ClientErr != 10000) && (Pawn != None) )
    //      log(" Client Error at "$TimeStamp$" is "$ClientErr$" with acceleration "$Accel$" LocDiff "$LocDiff$" Physics "$Pawn.Physics);
            LastUpdateTime = Level.TimeSeconds;

            PendingAdjustment.TimeStamp = TimeStamp;
            PendingAdjustment.newState = GetStateName();
        }
    }
    else
    {
        ClientUpdatePing(TimeStamp);
    }
    //log("Server moved stamp "$TimeStamp$" location "$Pawn.Location$" Acceleration "$Pawn.Acceleration$" Velocity "$Pawn.Velocity);
    if (IsClientMoveParamError)
        ;
    EndClientMoveServerAdjust();

    //±£ÁôÍæ¼ÒÉÏÒ»Ê±¿ÌËùÔÚµÄÎ»ÖÃ
    if(Pawn != none)
		KFXPlayerReplicationInfo(PlayerReplicationInfo).fxLocation = Pawn.Location;

}

auto state PlayerWaiting
{
    exec function Fire(optional float F)
    {
        if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
        {
            if(GUIController(Player.GUIController).GRI == none)
            {
                GUIController(Player.GUIController).GRI = GameReplicationInfo;
            }
            log("GUIController(Player.GUIController).GRI :"$GUIController(Player.GUIController).GRI);
            if( bJustLogin)
            {
                bJustLogin = false;
                GotoState('DownViewState');

                return;
            }
            else
            {
                return;
            }
        }

        if(self.PlayerReplicationInfo.bOnlySpectator)
    	{
    		GotoState('Spectating');
    		ServerViewNextPlayer();
		}
    }

    exec function SwitchToLastWeapon()
    {
        bPressQ = !bPressQ;
    }

    function bool CanRestartPlayer()
    {
        /*
        return (
               (bReadyToStart || (DeathMatch(Level.Game) != none && DeathMatch(Level.Game).bForceRespawn))
               && Super.CanRestartPlayer()
               );
        */
        return super.CanRestartPlayer();
    }

    simulated function BeginState()
    {
        if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
        {
            if( bJustLogin)
            {
                bJustLogin = false;
                GotoState('DownViewState');
                return;
            }
            else
            {
                return;
            }
        }
        super.BeginState();
        if ( pawn == none)
        {
            SetTimer( 1, true);
        }
        if(self.PlayerReplicationInfo.bOnlySpectator)
    	{
    		GotoState('Spectating');
    		//ServerViewNextPlayer();
		}

    }


    simulated function Timer()
    {
        if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
        {
            if( bJustLogin)
            {
                bJustLogin = false;
                GotoState('DownViewState');
                return;
            }
            else
            {
                return;
            }
        }

        if (Level.NetMode == NM_DedicatedServer)
        {
            super.Fire();
        }
        else
        {
        	Fire();
        }
    }

    function ServerMove
    (
        float TimeStamp,
        vector Accel,
        vector ClientLoc,
        bool NewbRun,
        bool NewbDuck,
        bool NewbJumpStatus,
        bool NewbDoubleJump,
        eDoubleClickDir DoubleClickMove,
        byte ClientRoll,
        int View,
        optional byte OldTimeDelta,
        optional int OldAccel,
        optional vector     Velocity,
        optional vector     BassDiss,        optional EPhysics   Physics
    )
    {
    }

    function ServerRestartPlayer()
    {
        if(!PlayerFreeViewManager)
            super.ServerRestartPlayer();
    }

    function PlayerMove(float DeltaTime)
    {
        local vector X,Y,Z;
        local rotator ViewRotation;

        if( PlayerFreeViewManager )
        {
            super.PlayerMove( DeltaTime );
            return;
        }

        if ( !bFrozen )
        {
            if ( bPressedJump )
            {
                Fire(0);
                bPressedJump = false;
            }
            GetAxes(Rotation,X,Y,Z);
            // Update view rotation.
            ViewRotation = Rotation;
            ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
            ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
            if (Pawn != None)
                ViewRotation.Pitch = Pawn.LimitPitch(ViewRotation.Pitch);
            else
                ViewRotation.Pitch = LimitPitch(ViewRotation.Pitch);
            SetRotation(ViewRotation);
            if ( Role < ROLE_Authority && RealViewTarget != none) // then save this move and replicate it
                ReplicateMove(DeltaTime, vect(0,0,0), DCLICK_None, rot(0,0,0) );
        }
        else if ( (TimerRate <= 0.0) || (TimerRate > 1.0) )
            bFrozen = false;

        ViewShake(DeltaTime);
        ViewFlash(DeltaTime);
    }

}
state WaitingForPawn
{
    function BeginState()
    {
        if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)
        {
            if( bJustLogin)
            {
                bJustLogin = false;
                GotoState('DownViewState');
                return;
            }
            else
            {
                return;
            }
        }
        super.BeginState();
    }
}
function ServerViewPriorPlayer(optional int id);

function ServerViewKiller(KFXPlayer pc)
{
    local bool bRealSpec;
    // ¼ÇÂ¼±¾Éí×´Ì¬
    bRealSpec = PlayerReplicationInfo.bOnlySpectator;

    // ÉèÖÃÁÙÊ±¹Û²ìÕß
    PlayerReplicationInfo.bOnlySpectator = true;

    // ÉèÖÃ±»¹Û²ìÄ¿±ê

    SetViewTarget(pc);
    ClientSetViewTarget(pc);
    SpectateHook.ServerChangeViewTarget(KFXPawn(pc.Pawn));


    // »¹Ô­µ½ÕæÊµ×´Ì¬
    PlayerReplicationInfo.bOnlySpectator = bRealSpec;
}

function ServerSpectate(optional bool bSpecKiller)
{
    // Proper fix for phantom pawns

    if (Pawn != none && !Pawn.bDeleteMe)
    {
        Pawn.Died(self, class'DamageType', Pawn.Location);
    }

    GotoState('Spectating');
    bBehindView = true;

    if( bSpecKiller  && killmepawn != none && !killmepawn.IsInState('Dying') )
    {
        ServerViewKiller(KFXPlayer(killmepawn.Controller));
        SpecKillerSecs = 0.0;
    }
    else
    {
        ServerViewNextPlayer();
    }
}

state Spectating
{
ignores SwitchWeapon, RestartLevel, ClientRestart, Suicide,
     ThrowWeapon, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange;

	exec function Fire( optional float F )
    {
        ServerViewNextPlayer();
    }
    exec function SwitchToLastWeapon()
    {
        bPressQ = !bPressQ;
    }
	exec function AltFire( optional float F )
    {
        ServerViewPriorPlayer();
    }

    //¹Û²ìÕßÄ£Ê½£¬¿Õ¸ñ¼üÇÐ»»Ò»ÈýÈË³Æ¹Û²ìÊÓ½Ç
    exec function Jump( optional float F )
    {
        if( Role < ROLE_Authority )
        {
            if (KFXPawn(ViewTarget) == none || (KFXPawn(ViewTarget) != none
    			&& KFXPawn(ViewTarget).PlayerReplicationInfo == none))
    		{
    			return;
    		}
            if (GetGRI() != none && GetGRI().bEnableThirdAngle)
            {
                bBehindView = !bBehindView;
                SpectateHook.AngleChanged( !bBehindView);
            }

            if(bBehindView)
            {
                //KFXPawn(ViewTarget).bHidden = false;
                //KFXPawn(ViewTarget).AvatarLegs.bHidden=false;
            }
            else
            {
                //KFXPawn(ViewTarget).bHidden = true;
                //KFXPawn(ViewTarget).AvatarLegs.bHidden=true;
            }
        }
    }

	function BeginState()
    {
    	// Ìí¼Óserver only
    	if(KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView)  //¹Û²ìÕßÄ£Ê½³õÈë¹Û²ìÕß£¬ÏÈËø¶¨Ò»¸öÍæ¼Ò
    	{
    	    Fire();
        }
        if( Role == ROLE_Authority )  // ÈÎºÎÈË¾ùÓÐ×Ê¸ñhook
        {
            if( SpectateHook == none )
            {
            	;
            	SpectateHook = Spawn(class<KFXSpectateHook>(
                    DynamicLoadObject("KFXGame.KFXSpectateHook",
    				class'Class')),self
    				);
			}
			if(SpectateHook != none)
    		{
    			SpectateHook.Viewer = self;
    		}
		}
        else
        {
            if(GetGRI().bEnableThirdAngle)
			{
			    bBehindView = true;
			    log("bBehindView is spectating true");
            }
			else
			{
			    log("bBehindView is spectating false ");
                bBehindView = false;
			    //KFXPawn(ViewTarget).bHidden = true;
                //KFXPawn(ViewTarget).AvatarLegs.bHidden=true;
            }
        }
        if(Player.GUIController != none)
	        Player.GUIController.SetHUDData_CheckSpectatingState(true,
					KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView);
    }

    function EndState()
    {
        super.EndState();
        if(Role == ROLE_Authority )  // ÈÎºÎÈË¾ùÓÐ×Ê¸ñhook
        {
            if( SpectateHook != none )
            {
                ;
			    SpectateHook.Destroy();
			    SpectateHook = none;
            }
//            bRealSpec = PlayerReplicationInfo.bOnlySpectator;
//            PlayerReplicationInfo.bOnlySpectator = true;
//            SetViewTarget( Self );
//            ClientSetViewTarget( self );
//            PlayerReplicationInfo.bOnlySpectator = bRealSpec;
		}
        Player.GUIController.SetHUDData_CheckSpectatingState(false,
					KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpectatorView);
    }


    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        if(Level.NetMode==NM_DedicatedServer /*&& !self.CanRestartPlayer()*/)
        {
//            log("SpecKillerSecs 2 is"@SpecKillerSecs);
            if( SpecKillerSecs < 3.0 )
            {
                SpecKillerSecs+=DeltaTime;
//                log("SpecKillerSecs is"@SpecKillerSecs);
                if(SpecKillerSecs >=3.0)
                {
                    log("SpecKillerSecs ServerViewNextPlayer");
                    ServerViewNextPlayer();
                    return;
                }
                if( ViewTarget == none || KFXPawn(ViewTarget) == none )
                {
                    log("SpecKillerSecs pawn none ServerViewNextPlayer");
                    SpecKillerSecs = 4.0;
                    ServerViewNextPlayer();
                    return;
                }
            }
            else if(ViewTarget==none || KFXPawn(ViewTarget) == none)
            {
                ServerViewNextPlayer();
            }
        }

    }

    function ServerMove
    (
        float TimeStamp,
        vector Accel,
        vector ClientLoc,
        bool NewbRun,
        bool NewbDuck,
        bool NewbJumpStatus,
        bool NewbDoubleJump,
        eDoubleClickDir DoubleClickMove,
        byte ClientRoll,
        int View,
        optional byte OldTimeDelta,
        optional int OldAccel,
        optional vector     Velocity,
        optional vector     BassDiss,        optional EPhysics   Physics
    )
    {
        Global.ServerMove(
                    TimeStamp,
                    Accel,
                    ClientLoc,
                    false,
                    false,
                    false,
                    false,
                    DoubleClickMove,
                    ClientRoll,
                    View);
    }

    //¹Û²ì×´Ì¬»ù´¡¹¦ÄÜÍ³Ò»ÐÞ¸Ä£¬Ôö¼ÓÄæÐò±éÀúÍæ¼Ò½øÐÐ¹Û²ì
    function ServerViewPriorPlayer(optional int id)
    {
        local Controller C, Pick;
        local bool bRealSpec;
        local KFXPawn lastView;

        if( SpecKillerSecs < 3.0 && KFXPawn(ViewTarget) != none)
        {
            return;
        }

    	if (ViewTarget != none)
    	{
    		lastView = KFXPawn(ViewTarget);
    	}

        // ¼ÇÂ¼±¾Éí×´Ì¬
        bRealSpec = PlayerReplicationInfo.bOnlySpectator;

        // ÉèÖÃÁÙÊ±¹Û²ìÕß
        PlayerReplicationInfo.bOnlySpectator = true;


        // ÕÒÉÏÒ»¸ö¿É¹Û²ì¶ÔÏó
        for( C = Level.ControllerList; C != None; C = C.NextController )
        {
            // Âß¼­²¿·ÖµÄÅÐ¶¨
            if( Level.Game.CanSpectate(self, bRealSpec, C) )
            {
            	if(id == 0)
            	{
            		//ÕÒÉÏÒ»¸ö¿É¹Û²ìµÄ¶ÔÏó
	                if( RealViewTarget == C ||ViewTarget == C  )
	                {
	                    break;
	                }
	                else
	                {
	                    Pick = C;
	                }
				}
				else
				{
                	//ÕÒÖ¸¶¨idµÄ¶ÔÏó
                	if(KFXPlayerReplicationInfo(C.PlayerReplicationInfo).fxPlayerDBID == id)
                	{
						Pick = C;
						break;
					}
				}
            }
        }
        if(id != 0 && Pick == none)
        {
		 	//Èç¹ûÃ»ÕÒµ½£¬ÄÇÃ´»Ö¸´ÏÖ³¡·µ»Ø
            PlayerReplicationInfo.bOnlySpectator = bRealSpec;
			return;
		}
        //Èç¹ûControllerList¾ÍÊÇself£¬ÄÇÃ´È¡×îºóÒ»¸ö¿É¹Û²ì¶ÔÏóÎªÉÏÒ»¸ö¿É¹Û²ì¶ÔÏó
        if( Pick == none )
        {
            for( C = Level.ControllerList; C != None; C = C.NextController )
            {
                if( Level.Game.CanSpectate(self, bRealSpec, C) )
                {
                    Pick = C;
                }
            }
        }

        // ÉèÖÃ¹Û²ìÕß
        //´Ë´¦µÄPick²»¿ÉÄÜÊÇÎÞPawnµÄController£¬ÉÏÃæµÄCanSpectate²ÅÊÇ×öÕâ¸ö¼ì²é¹¤×÷µÄ
        if(PlayerController(Pick)==none)
        {
            // ¹Û²ì×Ô¼ºµÄcontroller£¬²¢½øÈëµÚÈýÈË³Æ×´Ì¬
            SetViewTarget(self);
            ClientSetViewTarget(self);
            PlayerReplicationInfo.bOnlySpectator = bRealSpec;
            bBehindView = true;
            ClientSetBehindView(bBehindView);
            SpectateHook.ServerChangeViewTarget(none);
            return;
        }

        // ÉèÖÃ±»¹Û²ìÄ¿±ê
        SetViewTarget(Pick);
        ClientSetViewTarget(Pick);
        SpectateHook.ServerChangeViewTarget(KFXPawn(Pick.Pawn));

        // »¹Ô­µ½ÕæÊµ×´Ì¬
        PlayerReplicationInfo.bOnlySpectator = bRealSpec;
    }

    //¹Û²ì×´Ì¬»ù´¡¹¦ÄÜÍ³Ò»ÐÞ¸Ä£¬Ôö¼ÓµÚÒ»ÈË³Æ¹Û²ì¹¦ÄÜ
    function ServerViewNextPlayer(optional Controller targ)
    {
        local Controller C, Pick;
        local bool bRealSpec, bFound ,bTeamMate;
        local KFXPawn lastView;

        if( SpecKillerSecs < 3.0 && KFXPawn(ViewTarget) != none)
        {
            return;
        }

		Pick = targ;	//Ç¿ÖÆÖ¸¶¨Ò»¸ö¹Û²ì¶ÔÏó£¬Ç°ÌáÊÇÕâ¸ö¹Û²ì¶ÔÏóÒ»¶¨ÊÇºÏ·¨µÄ

    	if (ViewTarget != none)
    	{
    		lastView = KFXPawn(ViewTarget);
    	}

        // ¼ÇÂ¼±¾Éí×´Ì¬
        bRealSpec = PlayerReplicationInfo.bOnlySpectator;

        // ÉèÖÃÁÙÊ±¹Û²ìÕß
        PlayerReplicationInfo.bOnlySpectator = true;

		if(Pick == none)
		{
	        for( C = Level.ControllerList; C != None; C = C.NextController )
	        {
	            // Âß¼­²¿·ÖµÄÅÐ¶¨
	            if( Level.Game.CanSpectate(self, bRealSpec, C) )
	            {
	                if( Pick == none )
	                {
	                    Pick = C;
	                }
	                if( bFound )
	                {
	                    if( KFXPlayer(C).GetTeamNum() == GetTeamNum() )
	                    {
	                        bTeamMate = true;
	                    }
	                    if( bTeamMate || ( lastView != none && bFound ) )
	                    {
	                        Pick = C;
	                        break;
	                    }

	                }
	                else
	                {
	                    bFound = ( (RealViewTarget == C) || (ViewTarget == C));
	                }
	            }
	        }
		}

        // ÉèÖÃ¹Û²ìÕß
        //´Ë´¦µÄPick²»¿ÉÄÜÊÇÎÞPawnµÄController£¬ÉÏÃæµÄCanSpectate²ÅÊÇ×öÕâ¸ö¼ì²é¹¤×÷µÄ
        if(PlayerController(Pick)==none)
        {
            // ¹Û²ì×Ô¼ºµÄcontroller£¬²¢½øÈëµÚÈýÈË³Æ×´Ì¬
            SetViewTarget(self);
            ClientSetViewTarget(self);
            PlayerReplicationInfo.bOnlySpectator = bRealSpec;
            bBehindView = true;
            ClientSetBehindView(bBehindView);
            SpectateHook.ServerChangeViewTarget(none);
            return;
        }

        // ÉèÖÃ±»¹Û²ìÄ¿±ê
        SetViewTarget(Pick);
        ClientSetViewTarget(Pick);
        SpectateHook.ServerChangeViewTarget(KFXPawn(Pick.Pawn));

        // »¹Ô­µ½ÕæÊµ×´Ì¬
        PlayerReplicationInfo.bOnlySpectator = bRealSpec;
    }

    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
        local Pawn PTarget;

        if ( LastPlayerCalcView == Level.TimeSeconds && CalcViewActor != None && CalcViewActor.Location == CalcViewActorLocation )
        {
            ViewActor   = CalcViewActor;
            CameraLocation  = CalcViewLocation;
            CameraRotation  = CalcViewRotation;
            if(ViewActor == none)
            {
                ViewActor = self;
                log("1-----Specatating state ViewActor is none");
            }

            return;
        }

        if((ViewTarget == None) || ViewTarget.bDeleteMe )
        {
            ViewActor   = CalcViewActor;
            CameraLocation  = CalcViewLocation;
            CameraRotation  = CalcViewRotation;
            if(ViewActor == none)
            {
                ViewActor = self;
                log("2------Specatating state ViewActor is none");
            }
            return;
        }

        if ( ViewTarget == self )
        {
            CameraRotation = Rotation;

            CacheCalcView(ViewActor,CameraLocation,CameraRotation);
            if(ViewActor == none)
            {
                ViewActor = self;
                log("3-------Specatating state ViewActor is none");
            }
            return;
        }

        ViewActor = ViewTarget;
        CameraLocation = ViewTarget.Location;
        CameraRotation = ViewTarget.Rotation;

        PTarget = Pawn(ViewTarget);
        if ( PTarget != None )
        {
            if( level.NetMode != NM_DedicatedServer )
                CameraLocation = BlendedTargetViewLocation;
            if ( !bBehindView )
            {
                if(CalcViewActor != PTarget)
                {
                    BlendedTargetViewRotation.Pitch = PTarget.SmoothViewPitch;
                    BlendedTargetViewRotation.Yaw = PTarget.SmoothViewYaw;
                    BlendedTargetViewRotation.Roll = 0;

                    BlendedTargetViewLocation = PTarget.Location;
                }
                CameraRotation = BlendedTargetViewRotation;
                if (SpectateHook != none && SpectateHook.CurSpectateWeap != none)
            	{
            		CameraLocation += SpectateHook.CurSpectateWeap.EyePosition();
            	}
            }
        }
        if ( bBehindView )
        {
            CameraLocation = CameraLocation + (ViewTarget.Default.CollisionHeight - ViewTarget.CollisionHeight) * vect(0,0,1);
            CalcBehindView(CameraLocation, CameraRotation, CameraDist * ViewTarget.Default.CollisionRadius * 1.5);
        }

        if(ViewActor == none)
        {
            ViewActor = self;
            log("Specatating state ViewActor is none");
        }

        CacheCalcView(ViewActor,CameraLocation,CameraRotation);
    }

    function PlayerMove(float DeltaTime)
    {
        local rotator ViewRotation;
        local vector X,Y,Z;

        BlendedTargetViewLocation.X = BlendLoc(DeltaTime,BlendedTargetViewLocation.X,ViewTarget.Location.X);
        BlendedTargetViewLocation.Y = BlendLoc(DeltaTime,BlendedTargetViewLocation.Y,ViewTarget.Location.Y);
        BlendedTargetViewLocation.Z = BlendLoc(DeltaTime,BlendedTargetViewLocation.Z,ViewTarget.Location.Z);
        SetLocation(BlendedTargetViewLocation);
        if ( bBehindView )
        {
            ViewRotation = Rotation;
            ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
            ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
            ViewRotation.Pitch = LimitPitch(ViewRotation.Pitch);

            SetRotation(ViewRotation);
        }
        else
        {
            BlendedTargetViewRotation.Pitch = BlendRot(DeltaTime, BlendedTargetViewRotation.Pitch, TargetViewRotation.Pitch & 65535);
            BlendedTargetViewRotation.Yaw = BlendRot(DeltaTime, BlendedTargetViewRotation.Yaw, TargetViewRotation.Yaw & 65535);
            BlendedTargetViewRotation.Roll = BlendRot(DeltaTime, BlendedTargetViewRotation.Roll, TargetViewRotation.Roll & 65535);

            GetAxes(BlendedTargetViewRotation,X,Y,Z);
            if( SpectateHook.CurSpectateWeap != none )
            {
                SpectateHook.CurSpectateWeap.CheckBob(DeltaTime,X);
            }
        }
    }

    function int BlendRot(float DeltaTime, int BlendC, int NewC)
    {
        if ( Abs(BlendC - NewC) > 32767 )
        {
            if ( BlendC > NewC )
                NewC += 65536;
            else
                BlendC += 65536;
        }
        if ( Abs(BlendC - NewC) > 16384 )
            BlendC = NewC;
        else
            BlendC = BlendC + (NewC - BlendC) * FMin(1,10 * DeltaTime);

        return (BlendC & 65535);
    }

    function int BlendLoc(float DeltaTime, int BlendC, int NewC)
    {
        if( Abs(BlendC - NewC) > 200 )
        {
            BlendC = NewC;
        }
        else
        {
            BlendC = BlendC + (NewC - BlendC)*FMin(1,10*DeltaTime);
        }
        return BlendC;
    }

    exec function MoveForward(){}
    exec function MoveBackward(){}
    exec function StrafeLeft(){}
    exec function StrafeRight(){}

}

//
// ÎªÁËÄ£Äâ¿Í»§¶ËÓÐ±È½ÏÆ½»¬µÄÐ§¹û
//
//function int BlendRot(float DeltaTime, int BlendC, int NewC)
//{
//    if ( Abs(BlendC - NewC) > 32767 )
//    {
//        if ( BlendC > NewC )
//            NewC += 65536;
//        else
//            BlendC += 65536;
//    }
//    if ( Abs(BlendC - NewC) > 16383 )
//        BlendC = NewC;
//    else
//        BlendC = BlendC + (NewC - BlendC) * FMin(1,24 * DeltaTime);
//
//    return (BlendC & 65535);
//}


function int LimitPitch(int pitch)
{
    pitch = pitch & 65535;

    if (pitch > PitchUpLimit && pitch < PitchDownLimit)
    {
        if (pitch - PitchUpLimit < PitchDownLimit - pitch)
            pitch = PitchUpLimit;
        else
            pitch = PitchDownLimit;
    }

    return pitch;
}
simulated function bool PlayerCanMoveHack()
{
    return true;
}
// Player movement.
// Player Standing, walking, running, falling.
state PlayerWalking
{
ignores SeePlayer, HearNoise;

	function BeginState()
	{
	    super.BeginState();
	    if(Role < Role_Authority)
        {
    	    if(Pawn != none)
    	    {
                DyingTimes = 0;
                DeadStartTime = 0;
    	    }
    	    log("Restart------DyingTimes "$DyingTimes$"   Pawn: "$Pawn);
	    }
    }
    exec function Fire(optional float F)
    {
    	if(self.PlayerReplicationInfo.bOnlySpectator)
    	{
    		log("\\\\\\\\\\\\\\\\\PlayerWalking Fire");
    		GotoState('Spectating');
    		ServerViewNextPlayer();
		}
    }


    function bool NotifyLanded(vector HitNormal)
    {
        if (DoubleClickDir == DCLICK_Active)
        {
            DoubleClickDir = DCLICK_Done;
            ClearDoubleClick();
            Pawn.Velocity *= Vect(0.1,0.1,1.0);
        }
        else
            DoubleClickDir = DCLICK_None;

        if ( Global.NotifyLanded(HitNormal) )
            return true;

        return false;
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        if ( (DoubleClickMove == DCLICK_Active) && (Pawn.Physics == PHYS_Falling) )
            DoubleClickDir = DCLICK_Active;
        else if ( (DoubleClickMove != DCLICK_None) && (DoubleClickMove < DCLICK_Active) )
        {
            if ( KFXPawn(Pawn).Dodge(DoubleClickMove) )
                DoubleClickDir = DCLICK_Active;
        }

        Super.ProcessMove(DeltaTime,NewAccel,DoubleClickMove,DeltaRot);
    }

    function PlayerMove( float DeltaTime )
    {
        local vector X,Y,Z, NewAccel;
        local eDoubleClickDir DoubleClickMove;
        local rotator OldRotation, ViewRotation, HackRot;
        local bool  bSaveJump;

        if ( KFXPawn(Pawn) == none )
        {
            GotoState('Dead');
            return;
        }
        if ( KFXPawn(Pawn).CanMoveCount>0 || !PlayerCanMoveHack())// ||KFXPawn(Pawn).bPushBlock
        {
            bDuck = 0;
            aUp = 0;
            aBaseX = 0;
            aBaseY = 0;
            aBaseZ = 0;
            aForward = 0;
            aStrafe = 0;

            bPressedJump = false;
        }

        GetAxes(Pawn.Rotation,X,Y,Z);

        // Update acceleration.
        NewAccel = aForward*X + aStrafe*Y;
        NewAccel.Z = 0;
        if ( VSize(NewAccel) < 1.0 )
            NewAccel = vect(0,0,0);
        DoubleClickMove = PlayerInput.CheckForDoubleClickMove(1.1*DeltaTime/Level.TimeDilation);

        GroundPitch = 0;
        ViewRotation = Rotation;
        if ( Pawn.Physics == PHYS_Walking )
        {
            // tell pawn about any direction changes to give it a chance to play appropriate animation
            //if walking, look up/down stairs - unless player is rotating view
             if ( (bLook == 0)
                && (((Pawn.Acceleration != Vect(0,0,0)) && bSnapToLevel) || !bKeyboardLook) )
            {
                if ( bLookUpStairs || bSnapToLevel )
                {
                    GroundPitch = FindStairRotation(deltaTime);
                    ViewRotation.Pitch = GroundPitch;
                }
                else if ( bCenterView )
                {
                    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
                    if (ViewRotation.Pitch > 32768)
                        ViewRotation.Pitch -= 65536;
                    ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
                    if ( (Abs(ViewRotation.Pitch) < 250) && (ViewRotation.Pitch < 100) )
                        ViewRotation.Pitch = -249;
                }
            }
        }
        else
        {
            if ( !bKeyboardLook && (bLook == 0) && bCenterView )
            {
                ViewRotation.Pitch = ViewRotation.Pitch & 65535;
                if (ViewRotation.Pitch > 32768)
                    ViewRotation.Pitch -= 65536;
                ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
                if ( (Abs(ViewRotation.Pitch) < 250) && (ViewRotation.Pitch < 100) )
                    ViewRotation.Pitch = -249;
            }
        }

        /*
        Pawn.CheckBob(DeltaTime, Y);
        */
        Pawn.CheckBob(DeltaTime, vector(rotation));

        // Update rotation.
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime, 1);
        bDoubleJump = false;

        // Hack The Rotation
        if ( KFXPawn(Pawn).KFXHackRotation(OldRotation, Rotation, HackRot) )
        {
            SetRotation(HackRot);
        }

        if ( bPressedJump && Pawn.CannotJumpNow() )
        {
            bSaveJump = true;
            bPressedJump = false;
        }
        else
            bSaveJump = false;

        if ( Role < ROLE_Authority ) // then save this move and replicate it
            ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        else
            ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
        bPressedJump = bSaveJump;
    }
}

function ClientRestart(Pawn NewPawn)
{
    //¶Á±í»ñµÃÓïÒô×ÊÔ´
    super.ClientRestart(NewPawn);
    KFXConsole(Player.Console).bKFXCorpseLimit = false;
//    if(self.myHUD!=none)
//        KFXHUD(myHUD).bShowWhoKilledMe = false;

    bFreeCam = false;

    // ¼ÇÂ¼Ê±¼ä
    KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRestartTime = Level.TimeSeconds;
    //<< Dolby Voice
    if (DVClient != none && NewPawn != none)
    {
        // ±ê¼Ç¿ÉÒÔ¿ªÊ¼Ê¼ÓÃ¶Å±ÈÓïÒô
        bDVAllowTalk = true;
        // reset voice font
        DVClient.DVSetVoiceFont(KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXVoiceFont);
        KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXCurVoiceFont
            = KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXVoiceFont;
        // ÔÝÓÉ¿Í»§¶Ë×ö
        if (KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXSpatial && DVClient.DVEngine != ENG_DOLBYHEADPHONE)
        {
            DVClient.DVSetEngine(ENG_DOLBYHEADPHONE);
        }
    }

    if ( DVClient != none && !bDVTipShown )// TODO: temp, Ö»·¢Ò»´Î
    {
        // ´òÓ¡¶Å±ÈÓïÒô°ïÖúÏûÏ¢
        if (DVClient.bDVSpeakEnabled)//¶Å±ÈÓïÒô¿ª
        {
            ToggleDVSpeak(true);
        }
        else//¶Å±ÈÓïÒô¹Ø
        {
            ToggleDVSpeak(false);
        }
        bDVTipShown = true;
    }
    //>>

    if( Pawn!=none )
    {

        KFXPartitialTeamSet(nPartitialTeamSet);
        GUIController(Player.GUIController).PlayerEnterGameNotify();
        GUIController(Player.GUIController).GRI = GameReplicationInfo;
        ClientRestartTime = Level.TimeSeconds;

    }
    if(!bInitedVoice && Pawn != none)
    {
        ClientGetVoice();
    }

}

function ToggleDVSpeak( bool Enable )
{
    if ( Enable )
    {
//        myHud.Message(none, CONF_3DTalkHelp, 'System');
//        myHud.Message(none, CONF_TeamTalkHelp, 'System');
    }
    else
    {
//        myHud.Message(none, CONF_OpenDVTalk, 'System');
    }
}

//function NotifyGameMVP()
//{
//    log("[KFXPlayer] Find GameMVP Name:"$self.PlayerReplicationInfo.PlayerName$"KFXCurSelectWeaponID:"$KFXCurSelectWeaponID);
//    if ( Level.Game == none )
//        return;
//    //GetGRI().GameMVPUsedWeaponID = KFXCurSelectWeaponID;
//
//    //mvpÎª×°±¸¿âÖÐµÄÖ÷ÎäÆ÷
//    if(fxDBPlayerEquipList.MajorWeaponID > 0)
//	    GetGRI().GameMVPUsedWeaponID = fxDBPlayerEquipList.MajorWeaponID;
//	else if(fxDBPlayerEquipList.MinorWeaponID > 0)
//		GetGRI().GameMVPUsedWeaponID = fxDBPlayerEquipList.MinorWeaponID;
//	else if(fxDBPlayerEquipList.MeleeWeaponID > 0)
//    	GetGRI().GameMVPUsedWeaponID = fxDBPlayerEquipList.MeleeWeaponID;
//}

function bool InOrder( PlayerReplicationInfo P1, PlayerReplicationInfo P2 )
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
//	if(p1.PlayerID > p2.PlayerID)
//		return false;
//	else
		return true;	//killsºÍdeathsÏàÍ¬µÄ£¬²»½»»»

}
function CheckPawnCanSee()
{
    local int i,j;
    local KFXPlayerReplicationInfo tmp;
    local Pawn A;

    foreach self.AllActors(class'Pawn', A)
    {
        tmp = KFXPlayerReplicationInfo(A.PlayerReplicationInfo);
        if( Pawn != none && tmp!=none && tmp.Team.TeamIndex != GetPRI().Team.TeamIndex && !tmp.bDeadStatus && !GetPRI().bDeadStatus )
        {
            if ( !LineOfSightTo(A))
            {
                A.IsRenderEnable = false;
            }
            else
                A.IsRenderEnable = true;
        }
        else
            A.IsRenderEnable = true;
    }
}
//¶ÔPRIs½øÐÐÅÅÐò£¬¶ÔÓÚÍ¬Ò»Ö¡£¬±£Ö¤¸Ãº¯ÊýÖ»Ö´ÐÐÒ»´Î£¬·ñÔòÀË·Ñ
function SortPRIArray()
{
    local int i,j;
    local PlayerReplicationInfo tmp;

    for (i=0; i<GameReplicationInfo.PRIArray.Length-1; i++)
    {
        for (j=i+1; j<GameReplicationInfo.PRIArray.Length; j++)
        {
            if( !InOrder( GameReplicationInfo.PRIArray[i], GameReplicationInfo.PRIArray[j] ) )
            {
                tmp = GameReplicationInfo.PRIArray[i];
                GameReplicationInfo.PRIArray[i] = GameReplicationInfo.PRIArray[j];
                GameReplicationInfo.PRIArray[j] = tmp;
            }
        }
    }
}
//function DoCheckMVP()
//{
//	SortPRIArray();
//
//    if ( self.GetGRI().PRIArray[0] == self.PlayerReplicationInfo )
//    {
//        NotifyGameMVP();
//    }
//}
function ModifyCheckMVP()
{
//    log("[KFXPlayer] Find GameMVP Name:"$self.PlayerReplicationInfo.PlayerName$"KFXCurSelectWeaponID:"$KFXCurSelectWeaponID);
//    log("KFXPlayer-------bInitMVPWeapon "$bInitMVPWeapon);
//    if(!bInitMVPWeapon)
//    {
//        if ( Level.Game == none )
//            return;
//        //mvpÎª×°±¸¿âÖÐµÄÖ÷ÎäÆ÷
//        if(fxDBPlayerEquipList.MajorWeaponID > 0)
//    	    KFXPlayerReplicationInfo(PlayerReplicationInfo).ACEWeapon = fxDBPlayerEquipList.MajorWeaponID;
//    	else if(fxDBPlayerEquipList.MinorWeaponID > 0)
//    		KFXPlayerReplicationInfo(PlayerReplicationInfo).ACEWeapon = fxDBPlayerEquipList.MinorWeaponID;
//    	else if(fxDBPlayerEquipList.MeleeWeaponID > 0)
//        	KFXPlayerReplicationInfo(PlayerReplicationInfo).ACEWeapon = fxDBPlayerEquipList.MeleeWeaponID;
//    	bInitMVPWeapon = true;
//	}
}

function int GetLatestMajorWeapon()
{
    return LatestMajorWeapon;
}
state GameEnded
{
    function BeginState()
    {
        super.BeginState();

//        if(Level.NetMode == NM_Client)
//        {
//            ConsoleCommand("OBJ LIST");
//            log("KFXPlayer------ OBJ LIST");
//        }

        if( myHUD != none )
        {
            if(GetPlayerNeedRequair())
                RemoveActivePageByName("KFXGUI.KFXGameTransWeapon");
        }

        if ( LastLifekilledNum>PlayerCombatmessageDataSet.MaxSingleLifeKill )
        {
            PlayerCombatmessageDataSet.MaxSingleLifeKill = LastLifekilledNum;
        }
        LastLifekilledNum = 0;
//
//        if ( self.GetGRI().PRIArray[0] == self.PlayerReplicationInfo )
//        {
//            NotifyGameMVP();
//        }
        if ( PlayerCombatmessageDataSet.MaxAliveTime < Level.TimeSeconds - ClientRestartTime )
            PlayerCombatmessageDataSet.MaxAliveTime = Level.TimeSeconds - ClientRestartTime;

        CloseTransWeaponPage();
    }
}
state Dead
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon;

    exec function Fire( optional float F )
    {
        if ( bFrozen )
        {
            if ( (TimerRate <= 0.0) || (TimerRate > 1.0) )
                bFrozen = false;
            return;
        }
        if ( PlayerReplicationInfo.bOutOfLives )
            ServerSpectate();
        else
        {
            Super.Fire(F);
            //<< chenjianye
            //restart player message
            //if(self.myHUD!=none)
            	//KFXHUD(myHUD).bShowWhoKilledMe = false;
            //>>
        }
    }

    function BeginState()
    {
        super.BeginState();
        if(Role < Role_Authority)
        {
            DyingTimes++;
            DeadStartTime = Level.TimeSeconds;
            log("Dead------DyingTimes "$DyingTimes);
        }
        if ( PlayerCombatmessageDataSet.MaxAliveTime < Level.TimeSeconds - ClientRestartTime )
            PlayerCombatmessageDataSet.MaxAliveTime = Level.TimeSeconds - ClientRestartTime;

        if ( LastLifekilledNum>PlayerCombatmessageDataSet.MaxSingleLifeKill )
        {
            PlayerCombatmessageDataSet.MaxSingleLifeKill = LastLifekilledNum;
        }
        LastLifekilledNum = 0;

        if( Level.NetMode != NM_DedicatedServer )
            SetBGVolume( BGMusicAdjustFactor );

        if (Level.NetMode != NM_DedicatedServer)
        {
        	KFXPlayerReplicationInfo(PlayerReplicationInfo).fxClientDeadTime = level.TimeSeconds;
        }
        bRecordOver = false;
        KFXVoiceCount = 0;                //ÓïÒô±íÖØÐÂ¶ÁÈ¡
        bInitedVoice = false;
        PlayerInDeadStateCount++;
        log("KFXPlayer-------PlayerInDeadStateCount "$PlayerInDeadStateCount);
        if(Role == Role_Authority)
        {
            StopOtherWeaponUsedInfo();
        }
    }
    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
        super.PlayerCalcView(ViewActor,CameraLocation,CameraRotation);
        if (bShakeViewAfterDead)// Level.NetMode != NM_DedicatedServer)
        {
             ModifyDeadManCameraRotation(CameraRotation);
        }
    }


Begin:
    Sleep(3.0);
    if ( (ViewTarget == None) || (ViewTarget == self) || (VSize(ViewTarget.Velocity) < 1.0) )
    {
        Sleep(1.0);
        if ( myHUD != None )
            myHUD.bShowScoreBoard = true;
    }
    else
        Goto('Begin');
}

function ShowMidGameMenu(bool bPause)
{
    //<< Added By Carl WangÊ¹ÓÎÏ·ÄÚ²Ëµ¥·ÖÑµÁ·¹ØºÍÕý³£Ä£Ê½
    if(Player.GUIController.IsInState('Tutorial'))
    {
        MidGameMenuClass = "KFXGUI.KFXGUITutorialGameMenu";
    }
    //>>

    // Pause if not already
    if(Level.Pauser == None)
        SetPause(true);

    if ( Level.NetMode != NM_DedicatedServer )
        StopForceFeedback();  // jdf - no way to pause feedback

    // Open menu

    if (bDemoOwner)
        ClientopenMenu(DemoMenuClass);

    else if ( LoginMenuClass != "" )
        ClientOpenMenu(LoginMenuClass);

    else ClientOpenMenu(MidGameMenuClass);
}


//exec function ToggleMesh()
//{
//    if(KFXPawn(Pawn) != none)
//    {
//        KFXPawn(Pawn).ToggerMaterial();
//    }
//}

//debug bot when a net client
exec function NetDebugBot()
{
    if (Level.NetMode == NM_Client && ViewTarget != Pawn)
        ServerSendBotDebugString();
}
exec function KFXSetAllChatInfoEnable()
{
    bIsEnterLeaveGame=true;
    bIsVoiceMessage=true;
    bIsChatWithTeam=true;
    bIsChatWithAll=true;
    bIsCanHearSpeaker=true;
    bIsSystemMessage=true;
    bIsChatWithPersonal=true;
    bIsChatWithFaction=true;
    log("KFXPlayer-----KFXSetAllChatInfoEnable ");
}
exec function KFXSetAllChatInfoDisable()
{
    bIsEnterLeaveGame=false;
    bIsVoiceMessage=false;
    bIsChatWithTeam=false;
    bIsChatWithAll=false;
    bIsCanHearSpeaker=false;
    bIsSystemMessage=false;
    bIsChatWithPersonal=false;
    bIsChatWithFaction=false;
    log("KFXPlayer-----KFXSetAllChatInfoDisable ");
}
exec function KFXSetEnterLeaveGameEnable(byte bEnable)
{
    bIsEnterLeaveGame = bool(bEnable);
    log("KFXSetEnterLeaveGameEnable-----bEnable "$bEnable);
}

exec function KFXSetVoiceMessageEnable(byte bEnable)
{
    bIsVoiceMessage = bool(bEnable);
    log("KFXSetVoiceMessageEnable-----bEnable "$bEnable);
}

exec function KFXSetChatWithTeamEnable(byte bEnable)
{
    bIsChatWithTeam = bool(bEnable);
    log("KFXSetChatWithTeamEnable-----bEnable "$bEnable);
}
exec function KFXSetChatWithAllEnable(byte bEnable)
{
    bIsChatWithAll = bool(bEnable);
    log("KFXSetChatWithAllEnable-----bEnable "$bEnable);
}
exec function KFXSetChatWithPersonalEnable(byte bEnable)
{
    bIsChatWithPersonal = bool(bEnable);
    log("KFXSetChatWithPersonalEnable-----bEnable "$bEnable);
}
exec function KFXSetChatWithFactionEnable(byte bEnable)
{
    bIsChatWithFaction = bool(bEnable);
    log("KFXSetChatWithFactionEnable-----bEnable "$bEnable);
}
exec function KFXSetCanHearSpeakerEnable(byte bEnable)
{
    bIsCanHearSpeaker = bool(bEnable);
    log("KFXSetCanHearSpeakerEnable-----bEnable "$bEnable);
}
exec function KFXSetSystemMessageEnable(byte bEnable)
{
    bIsSystemMessage = bool(bEnable);
    log("KFXSetSystemMessageEnable-----bEnable "$bEnable);
}


function ServerSendBotDebugString()
{
    /*
    if (Bot(RealViewTarget) != None)
        ClientReceiveBotDebugString("(ORDERS: "$Bot(RealViewTarget).Squad.GetOrders()$") "$Bot(RealViewTarget).GoalString);
    else
        ClientReceiveBotDebugString("");
    */
}

simulated function ClientReceiveBotDebugString(string DebugString)
{
    NetBotDebugString = DebugString;
    if (NetBotDebugString != "")
        ServerSendBotDebugString();
}
simulated function ClientChangeTeam()
{
    KFXHUD(myHUD).KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(37), true,, 3, 1);
    //=====»»¶ÓÊ±ÔÊÐí»»Ç¹
    KFXGameReplicationInfo(GameReplicationInfo).ClientStart = false;
}
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    Super.DisplayDebug(Canvas, YL, YPos);

    if (NetBotDebugString != "")
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawText("Bot ViewTarget's Goal: "$NetBotDebugString);
        YPos += YL;
        Canvas.SetPos(4, YPos);
    }
}
//> Functions from UnrealPlayer end

exec function ForceReload()
{

    if ( (Pawn != None) && (Pawn.Weapon != None)
         && (KFXWeapBase(Pawn.Weapon) != none) )
    {
        KFXWeapBase(Pawn.Weapon).KFXForceReload();
    }
}
// added by duodonglai to art test
exec function ToggleCamera()
{
    bFreeCamera = !bFreeCamera;
}

simulated function ServerCloseMover(Mover TestMover)
{
   log("KFXPlayer-----ServerCloseMover----TestMover "$TestMover);
   TestMover.DoClose();
}
simulated function ServerOpenMover(Mover TestMover)
{
   log("KFXPlayer-----ServerOpenMover----TestMover "$TestMover);
   TestMover.DoOpen();
}

//< functions for AutoAim
// functions below only valid at owner Client!
simulated event Tick( float DeltaTime )
{
    // Tick AutoAim
//    if(Level.NetMode==NM_DedicatedServer)
//    {
    ///>>²éÕÒPingÖµ½Ï´óµÄ¿Í»§¶Ë
    local int i;
	local KFXPlayerReplicationInfo KFXPRI;
	local KFXGameReplicationInfo KFXGRI;

	KFXGRI = GetGRI();
	KFXPRI = GetPRI();

	if(level.NetMode == NM_Client && KFXPRI.PVELevel != -1)
	{
		if(KFXPRI.ClientPveLevel == -1)
		{
			KFXPRI.ClientPveLevel = KFXPRI.PVELevel;
   			KFXGRI.SetBaseLevelData(KFXPRI.ClientPveLevel);
   			Player.GUIController.SetHUDData_PvePlayerLevel(KFXPRI,false);
			KFXPRI.LevelDmgFactor = KFXGRI.BaseDmgFactor + (KFXPRI.PVELevel -1)*KFXGRI.LevelupDmgFactor;
		    KFXPRI.LevelHP = KFXGRI.BaseHP + (KFXPRI.PVELevel -1)*KFXGRI.LevelupHP;
		}
		else if(KFXPRI.ClientPveLevel != KFXPRI.PVELevel )
		{
			KFXPRI.ClientPveLevel = KFXPRI.PVELevel;
   			KFXGRI.SetBaseLevelData(KFXPRI.ClientPveLevel);
			Player.GUIController.SetHUDData_PvePlayerLevel(KFXPRI,true);
			KFXPRI.LevelDmgFactor = KFXGRI.BaseDmgFactor + (KFXPRI.PVELevel -1)*KFXGRI.LevelupDmgFactor;
		    KFXPRI.LevelHP = KFXGRI.BaseHP + (KFXPRI.PVELevel -1)*KFXGRI.LevelupHP;
		}

		if(KFXPRI.ClientPVEexp != KFXPRI.PVEexp)
		{
			KFXPRI.ClientPVEexp = KFXPRI.PVEexp;
			Player.GUIController.SetHUDData_PveExp(KFXPRI.PVEexp,
					KFXGRI.GetPveLevelUpExp(KFXPRI.PVELevel));
		}
	}

    if( Role == ROLE_Authority )
    {
        for(i = KillInfo.Length-1; i >= 0; i-- )
        {
            if(KFXPlayerReplicationInfo(KillInfo[i].TempKilled.PlayerReplicationInfo).bDeadStatus)
            {
                if(KillInfo[i].ServerKilledPostTick < 0)
                {
                    KillInfo[i].ServerKilledPostTick = 0;
                }
                else if(KillInfo[i].ServerKilledPostTick == 0)
                {

                    self.Pawn.KFXDmgInfo.WeaponID = KillInfo[i].KillerWeaponID;
                    Level.Game.UpdateKillReplicationInfoWithWeaponID(self,KillInfo[i].TempKilled, KillInfo[i].TempDamageType,KillInfo[i].KillerWeaponID);
                    Level.Game.ServerKilledPostTick(self,KillInfo[i].TempKilled,KillInfo[i].TempKilled.Pawn,KillInfo[i].TempDamageType);
					KillInfo[i].TempKilled.Pawn.KFXDmgInfo.WeaponID = 0;
                    KillInfo[i].ServerKilledPostTick++;
                    KillInfo.Remove(i,1);

                }
            }
        }
        if( !SetupOutputPing )
        {
            PingStateTimer = level.TimeSeconds;
            SetupOutputPing = true;
        }

        if( !HaveInitOutputPing )
        {
            if( (level.TimeSeconds - PingStateTimer) > 120 )
            {
                if( PlayerReplicationInfo != none )
                {
                    log("UccBin state Begin IP:"$GetPlayerNetworkAddress()$" Ping:"$PlayerReplicationInfo.Ping*4$"DeltaTime:"$DeltaTime);
                }

                PingStateTimer = level.TimeSeconds;
                HaveInitOutputPing = true;
            }
        }
        else if( (level.TimeSeconds - PingStateTimer) > 200 )
        {
            if( PlayerReplicationInfo != none )
            {
                if( PlayerReplicationInfo.Ping > 100 )
                    log("UccBin state IP:"$GetPlayerNetworkAddress()$" Ping:"$PlayerReplicationInfo.Ping*4$"DeltaTime:"$DeltaTime);
            }

            PingStateTimer = level.TimeSeconds;
        }
    }
    else
    {
    	if (Pawn != none && KFXPawn(Pawn).bTransWeaponMenuOpened
    		&& !KFXCanShowWeapChangePage() )
			//&& Level.TimeSeconds - GetPRI().fxRestartTime > TransWeaponTimeLimit)
    	{
    		CloseTransWeaponPage();
    	}

	    //¿Í»§¶ËÃ¿¸ôÒ»¶ÎÊ±¼ä£¬ÊÕ¼¯Ò»ÏÂÐÅÏ¢£¬²¢¹ã²¥¸øÆäËû¶ÓÓÑ
		if(Level.TimeSeconds - LastBroadcastEnemyTime > GetGRI().UpdateEnemyMsgTime)
	    {
			LastBroadcastEnemyTime = level.TimeSeconds;
			SendEnemyMsgs();
		}
    }

    ///<<
//    log("player location"@Location);
//    log("player Rotation"@Rotation);
//    log("player CachedLocation"@CachedLocation);
//    log("player CachedRotation"@CachedRotation);
//    log("player CalcViewLocation"@CalcViewLocation);
//    log("player CalcViewRotation"@CalcViewRotation);
//    log("player CalcViewActor"@CalcViewActor);
//    log("player ViewTarget"@ViewTarget);
//    log("player CalcViewActorLocation"@CalcViewActorLocation);



//    KFXAutoAimTick(DeltaTime);

//    }


}
function DoSomeIfDllIsNotLatest()
{
    if(Level.TimeSeconds - LastCallTime > 10)
    {
        Destroy();
        log("Controller Destroyed Becault Dll Is Not Latest");
    }
}
event  CheckLatestDllForAntiPlugin()
{
    LastCallTime = Level.TimeSeconds;
}
// ÓÉÓÎÏ··þÎñÆ÷Í¨Öª¿Í»§¶ËÖ´ÐÐµÄÖ¸Áî
simulated function KFXGSCommand(int nCmd)
{
    if ( nCmd == -1 )
    {
        Log("[KFXGSCmd] Disconnect!");
        ConsoleCommand("disconnect");
    }
    else if ( nCmd == -2 )
    {
        Log("[KFXGSCmd] Exit!");
        ConsoleCommand("exit");
    }
}

// Init auto Aim System
// Owner Clietn Only
simulated function KFXInitAutoAim()
{
    //NOTE: MUST default value, self.value is replicated from server(fix value when init)
    KFXServerSetAutoAim(default.KFXIsOnAutoAimMode);

    //ÆÕÍ¨Ä£Ê½ÆÁ±Î×Ô¶¯Ãé×¼¹¦ÄÜ
    //KFXServerSetAutoAim(false);
}

// function for fire AutoAim logical
function bool KFXFireAutoAim()
{
    // Is auto Aim Mode On
    if ( !KFXIsOnAutoAimMode ||
         KFXAutoAimColdDown > 0 /*||*/
         /*KFXAutoAimMP <= 0*/ )
        return false;

    if ( KFXAutoAimChooseTarget() )
    {
        // Choose a valid target

        KFXServerFireAutoAim();

        KFXAutoAimLockTime = 0;
        KFXRasieAutoAim(0.01);    // for instant auto aim case

        return true;
    }

    return false;
}

// function for choose target
function bool KFXAutoAimChooseTarget()
{
    local KFXPawn p, Obj;
    local float DotV, LastDotV, Angle;
    local vector FireDir, t;
    local vector AimSpot, StartProj, EndProj;

    StartProj = Pawn.Location;
    FireDir = vector(Rotation);

    // Choose Best Target
    ForEach DynamicActors( class 'KFXPawn', p )
    {
        /*ÅÐ¶ÏËÀÍö×´Ì¬¼°ÆäËûÎÞ·¨Éä»÷×´Ì¬*/
        if ( P == Pawn || P.bTearOff
            || (p.PlayerReplicationInfo.Team!=none&&
               p.PlayerReplicationInfo.Team.TeamIndex
               == Pawn.PlayerReplicationInfo.Team.TeamIndex
                && p.PlayerReplicationInfo.Team.TeamIndex < 2 )
            || !LineOfSightTo(p) )
            continue;

        EndProj = p.Location;
        t = Normal(EndProj - StartProj);
        DotV = FireDir dot t;
        Angle  = acos( DotV / (VSize(FireDir) * VSize(t)) );

        if ( Abs(Angle) > KFXAutoAimAngle )
            continue;

        if ( DotV > LastDotV )
        {
            Obj = p;
            AimSpot = t;
            LastDotV = DotV;
        }
    }

    if ( Obj != none )
    {
        KFXAutoAimTarget = Obj;
        KFXAutoAimStart = FireDir;
        KFXAutoAimSpot = AimSpot;

        return true;
    }

    return false;
}

function KFXAutoAimTick(float DeltaTime)
{
    if ( Pawn == none )
        return;

    if ( Role == ROLE_Authority )
    {
        // auto Aim Valid Tick
        KFXAutoAimValidTick(DeltaTime);

        // Calc auto Aim Cold Down
        KFXAutoAimColdDownTick(DeltaTime);

        // ¼æÈÝµ¥»úÄ£Ê½,²¢ÓÅ»¯·þÎñÆ÷µÄÅÐ¶ÏÐ§ÂÊ
        if ( Level.NetMode == NM_DedicatedServer )
            return;
    }

    if ( Pawn.IsLocallyControlled() )
    {
        // Calc auto Aim Raise
        KFXRasieAutoAim(DeltaTime);
    }
}

// function for calc valid autoaim
function KFXAutoAimValidTick(float DeltaTime)
{
    // Is auto Aim Mode On
    if ( !KFXIsOnAutoAimMode )
        return;

    // tick valid autoaim
    if ( KFXAutoAimValidTime > 0 )
    {
        KFXAutoAimValidTime -= DeltaTime;
        KFXAutoAimValidTime = FMax(KFXAutoAimValidTime, 0);

        // calc colddown
        if ( KFXAutoAimValidTime == 0 )
        {
            KFXAutoAimColdDown = KFXAutoAimColdDownMax;
            KFXAutoAimColdDown = FMax(KFXAutoAimColdDown, KFXAutoAimColdDownMax);
        }
    }
}

// function for calc colddown
function KFXAutoAimColdDownTick(float DeltaTime)
{
    // Is auto Aim Mode On
    if ( !KFXIsOnAutoAimMode )
        return;

    KFXAutoAimColdDown = KFXAutoAimColdDown - DeltaTime;
    KFXAutoAimColdDown = FMax(KFXAutoAimColdDown, 0);
}

// function for rasie AutoAim
function KFXRasieAutoAim(float DeltaTime)
{
    local rotator StartRot, EndRot, TravelRot;
    // Is auto Aim Mode On
    if ( !KFXIsOnAutoAimMode || KFXAutoAimColdDown > 0
        || KFXAutoAimTarget == none )
        return;

    // Calc Auto Aim Raise
    KFXAutoAimLockTime = KFXAutoAimLockTime + DeltaTime;
    KFXAutoAimLockTime = FMin(KFXAutoAimLockTime, KFXAutoAimLockTimeDelta);

    if ( KFXAutoAimLockTime >= KFXAutoAimLockTimeDelta )
    {
        SetRotation(rotator(KFXAutoAimSpot));

        KFXAutoAimTarget = none;
        KFXAutoAimLockTime = 0;
    }
    else
    {
        StartRot = rotator(KFXAutoAimStart);
        EndRot = rotator(KFXAutoAimSpot);

        TravelRot = StartRot +
            (EndRot - StartRot) * (KFXAutoAimLockTime / KFXAutoAimLockTimeDelta);

        SetRotation(TravelRot);
    }

}

// function for Render AutoAim first person effect
function KFXRenderAutoAimEffect(Canvas c);

// toggle AutoAim Mode on
exec function KFXToggleAutoAim()
{
    KFXIsOnAutoAimMode = !KFXIsOnAutoAimMode;
    SaveConfig();

    KFXServerSetAutoAim(KFXIsOnAutoAimMode);
}

// Notify Server We Fire the AutoAim
simulated function KFXServerFireAutoAim()
{
    //KFXAutoAimMP--;

    if (KFXAutoAimValidTime <= 0)
        KFXAutoAimValidTime = KFXAutoAimValidTimeMax;
}

// Set The Auto AimKill Flag
// Server Only
function KFXServerSetAutoAim(bool bAutoAim)
{
    KFXIsOnAutoAimMode = bAutoAim;

    //KFXAutoAimColdDown = KFXAutoAimColdDownMax;
    //KFXAutoAimColdDown = FMax(KFXAutoAimColdDown, KFXAutoAimColdDownMax);
}

//=============================================================================
// KFXPlayer Control

// Player view.
// Compute the rendering viewpoint for the player.
//

function AdjustView(float DeltaTime )
{
    // teleporters affect your FOV, so adjust it back down
    if ( FOVAngle != DesiredFOV )
    {
        if ( FOVAngle > DesiredFOV )
            FOVAngle = FOVAngle - FMax(7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
        else
            FOVAngle = FOVAngle - FMin(-7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
        if ( Abs(FOVAngle - DesiredFOV) <= 10 )
            FOVAngle = DesiredFOV;
    }

    // adjust FOV for weapon zooming
    if ( bZooming )
    {
        ZoomLevel = FMin(ZoomLevel + DeltaTime, DesiredZoomLevel);
        DesiredFOV = FClamp(85.0 - (ZoomLevel * 80.0), 1, 170);
    }
}

function CalcFirstPersonView( out vector CameraLocation, out rotator CameraRotation )
{
    super.CalcFirstPersonView(CameraLocation, CameraRotation);

    if ( Level.NetMode != NM_DedicatedServer && Pawn != none && Pawn.Weapon != none )
    {
        CameraRotation = Normalize(CameraRotation + KFXWeapBase(Pawn.Weapon).KFXWeaponShakeView());
    }
}

function ModifyDeadManCameraRotation( out rotator CameraRotation)
{
    local float DeadBeginTime,RestartNeedTime;
    local float PassedTime;
    local float ChangeViewPerTick;
    DeadBeginTime = GetPRI().fxDeadTime;
    RestartNeedTime = 1;//FMax(GetGRI().fxPlayerRestartDelay-GetPRI().fxRestartCardTime, 0);

    if(PlayerInDeadStateCount > 0)
    {
        if(level.TimeSeconds - DeadBeginTime >0 && level.TimeSeconds - DeadBeginTime <=  RestartNeedTime)
        {
           PassedTime = level.TimeSeconds - DeadBeginTime;
           ChangeViewPerTick = 0.05;
           if(PassedTime < RestartNeedTime/3 )
           {
               CameraRotation.Pitch += fxDeadPitchChange * PassedTime;
           }
           else if(PassedTime < RestartNeedTime/3 + RestartNeedTime/10)
           {
               CameraRotation.Pitch += fxDeadPitchChange * PassedTime;
               CameraRotation.Roll  += fxDeadRollChange * (PassedTime - RestartNeedTime/3);
           }
           else
           {
               CameraRotation.Pitch += fxDeadPitchChange * PassedTime;
               CameraRotation.Roll  += fxDeadRollChange * (PassedTime - (RestartNeedTime/3 + RestartNeedTime/10));
           }
        }
    }
}
simulated function float GetMouseSensFactor()
{
    if ( KFXPawn(Pawn) != none && KFXPawn(Pawn).Weapon != none
        && KFXWeapBase(KFXPawn(Pawn).Weapon) != none )
        return KFXWeapBase(KFXPawn(Pawn).Weapon).KFXHackMouseSens();
    return 0.0f;
}

//=============================================================================

// Server Only
// »»±»Ñ¡ÎäÆ÷£¬ÖØÉúºóÉúÐ§
// @param: id --- 0ÎªÄ¬ÈÏÎäÆ÷£¬ 1-15Îª±³°üÎäÆ÷
//Ò»¶¨Òª °ÑÎäÆ÷µÄid¼ÆËã³öÀ´
function KFXChangeWeapon(int ID)
{
	//Èç¹ûÃ»ÓÐ×°±¸À×°ü£¬ÇÒ´ËidÊÇÒ»¿ÅÀ×£¬ÄÇÃ´Ö±½Ó·µ»Ø

	local int bomb_type;

	if(KFXGameInfo(Level.Game).CheckItemID(ID, EID_Grenades))
	{
		if(KFXGameInfo(Level.Game).CheckItemID(ID, EID_FlashBomb))
		{
			bomb_type = 1;
		}
		else if(KFXGameInfo(Level.Game).CheckItemID(ID, EID_SmokeBomb))
		{
			bomb_type = 2;
		}
	}

	if(bomb_type > 0 && (bomb_bag_level&(1<<bomb_type))==0)
	{
		log("[LABOR]-----------bomb bag limit! limit="$bomb_bag_level@bomb_type);
		return;
	}

	if (KFXGameInfo(Level.Game).KFXAgent.IsItemInEquipList(fxDBPlayerInfo.SessionID, ID))
	{
		ServerTransWeapon(ID);
	}
}

// ÓÎÏ·ÄÚ¹ºÂò server only
function ServerTransWeapon(int ID)
{
	local int InventoryGroup;
	local int WeapType;
	local int GrenadesIndex, GrenadesCnt;
	local bool bNewGrenade;
	local int OldWeapID;
	local int i,WeapDurable;
	local KFXWeapBase NewWeap;
	local int bomb_type;

    //¼ì²éÊÇ²»ÊÇÀ×£¬Èç¹ûÊÇÀ×£¬ÄÇÃ´ÊÇ·ñÓÐÀ×°ü
	if(KFXGameInfo(Level.Game).CheckItemID(ID, EID_Grenades))
	{
		if(KFXGameInfo(Level.Game).CheckItemID(ID, EID_FlashBomb))
		{
			bomb_type = 1;
		}
		else if(KFXGameInfo(Level.Game).CheckItemID(ID, EID_SmokeBomb))
		{
			bomb_type = 2;
		}
	}

	if(bomb_type > 0 && (bomb_bag_level&(1<<bomb_type))==0)
	{
		log("[LABOR]-----------bomb bag limit! limit="$bomb_bag_level@bomb_type);
		return;
	}


    //ÖØÑ¡Ö÷ÎäÆ÷Ö®ºó£¬½áËãÉÏÒ»¸öÎäÆ÷µÄÄÍ¾Ã¶ÈÏûºÄ£¬²¢¿ªÊ¼ÏÂÒ»¸öÎäÆ÷ÄÍ¾Ã¶ÈÏûºÄ¼ÆÊ±
    WeapDurConsumeEnd();
    WeapDurConsumeStart(ID);

    KFXCurSelectWeaponID = ID;

    log("KFXChangeWeapon KFXCurSelectWeaponID:" @ KFXCurSelectWeaponID);
    log("fxTransWeapList.MajorWeaponID:" @ fxTransWeapList.MajorWeaponID);
    log("fxTransWeapList.MinorWeaponID:" @ fxTransWeapList.MinorWeaponID);
    log("fxTransWeapList.MeleeWeaponID:" @ fxTransWeapList.MeleeWeaponID);
    log("fxTransWeapList.Grenades[0]:" @ fxTransWeapList.Grenades[0]);
    log("fxTransWeapList.Grenades[1]:" @ fxTransWeapList.Grenades[1]);
    log("fxTransWeapList.Grenades[2]:" @ fxTransWeapList.Grenades[2]);
    if (Level.NetMode != NM_DedicatedServer)
    {
    	return;
    }

    if (ID <= 0)
	{
		return;
	}

    WeapType = ID >> 16;;

	if (WeapType <= 0)
	{
		return;
	}

	if (WeapType < 31)
	{
        InventoryGroup = 1;
        OldWeapID = fxTransWeapList.MajorWeaponID;
		fxTransWeapList.MajorWeaponID = KFXCurSelectWeaponID;
        SavePlayerBuyWeapon(KFXCurSelectWeaponID);
	}
	else if (WeapType < 41)
	{
        InventoryGroup = 2;
        OldWeapID = fxTransWeapList.MinorWeaponID;
		fxTransWeapList.MinorWeaponID = KFXCurSelectWeaponID;

	}
	else if (WeapType < 51)
	{
		InventoryGroup = 3;
		OldWeapID = fxTransWeapList.MeleeWeaponID;
		fxTransWeapList.MeleeWeaponID = KFXCurSelectWeaponID;

	}
	else if (WeapType < 61)
	{
		InventoryGroup = 4;
		GrenadesCnt = 3;
		bNewGrenade = true;

        for (GrenadesIndex = 0; GrenadesIndex < GrenadesCnt; GrenadesIndex++)
		{
			if (fxTransWeapList.Grenades[GrenadesIndex] >> 16 == WeapType)
			{
				OldWeapID = fxTransWeapList.Grenades[GrenadesIndex];
				fxTransWeapList.Grenades[GrenadesIndex] = KFXCurSelectWeaponID;
				bNewGrenade = false;
				break;
			}
		}

		if (bNewGrenade)
		{
			for (GrenadesIndex = 0; GrenadesIndex < GrenadesCnt; GrenadesIndex++)
			{
				if (fxTransWeapList.Grenades[GrenadesIndex] == 0)
				{
					fxTransWeapList.Grenades[GrenadesIndex] = KFXCurSelectWeaponID;
					break;
				}
			}
		}

		if (!bNewGrenade)
		{
			DeleteWeapon(InventoryGroup, OldWeapID);
		}

        //ÔÚÉú³ÉÎäÆ÷Ê±°²×°ÒÑÓÐµÄÎäÆ÷Åä¼þ
		for(i = 0; i< TransComponents.Length; i++)
        {
            if(TransComponents[i].WeaponID ==ID )
            {
                class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn), ID,
                    0,0,TransComponents[i].ComponentID,true);
                break;
            }
        }
        if(i == TransComponents.Length)
        {
            class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn), ID,,,,true);
        }
		UISwitchWeapon(InventoryGroup, KFXCurSelectWeaponID);
		return;
	}

	DeleteWeapon(InventoryGroup);
	for(i = 0; i< TransComponents.Length; i++)
    {
        if(TransComponents[i].WeaponID ==ID )
        {
            NewWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn), ID,
                0,0,TransComponents[i].ComponentID,true);
            break;
        }
    }
    if(i == TransComponents.Length)
    {
        NewWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn), ID,,,,true);
    }

    WeapDurable = KFXGameInfo(level.Game).KFXAgent.GetItemDurable( fxDBPlayerInfo.SessionID,ID);
    if(NewWeap != none && WeapDurable != -1 && WeapType > 0 && WeapType < 41)
       NewWeap.KFXServerDurableFact( WeapDurable );
	UISwitchWeapon(InventoryGroup);
}
function SavePlayerBuyWeapon(int MajorWeaponID)
{
    log("KFXPlayer----MajorWeaponID "$MajorWeaponID);

    if ( Level.Game == none )
        return;
    if(MajorWeaponID > 0)
    {
	    LatestMajorWeapon = MajorWeaponID;
	    //KFXPlayerReplicationInfo(PlayerReplicationInfo).ACEWeapon = LatestMajorWeapon;
    }
}
function DeleteWeapon(int WeaponGroup, optional int WeaponID)
{
	local Inventory Invi,Invj;

	if (Pawn == none)
	{
		return;
	}

	for (Invi = Pawn.Inventory; Invi!=none; Invi = Invj)
    {
        Invj = Invi.Inventory;

        if ( Weapon(Invi).InventoryGroup == WeaponGroup)
        {
        	if (WeaponID != 0)
        	{
        		if (KFXWeapBase(Invi).KFXGetWeaponID() != WeaponID)
        		{
        			continue;
        		}
        	}

	        Invi.DetachFromPawn(Pawn);
	        Pawn.DeleteInventory(Invi);
	        Invi.Destroy();
	        Invi = none;
	        break;
        }
    }
}

// NoSwitchÎªtrueÊ±£¬Ö»¹Ø»»Ç¹½çÃæ£¬²»ÇÐ»»ÎäÆ÷
function UISwitchWeapon(int WeapType, optional int WeapID)
{

	if (WeapType <= 0)
	{
		return;
	}

	if (Pawn != none)
	{
		if (WeapID == 0)
		{
			//Pawn.SwitchWeapon(WeapType);
		}
		else
		{
			//KFXPawn(Pawn).SwitchGrenade(WeapID);
		}
	}

}

//ÔÚ»»³Éµ±Ç°ÎäÆ÷Ê±£¬¿ªÊ¼ÎäÆ÷ÄÍ¾Ã¶ÈÏûºÄ¼ÆÊ±
function WeapDurConsumeStart(int WeapID)
{
    local KFXCSVTable CSVItems;
    local int WeapType;
    local int durable;

    if( !KFXGameInfo(level.Game).KFXCanConsumeWeapDurable())
	{
	    return;
	}

    //Èç¹ûÔÚ»»ÓÃ¸ÃÎäÆ÷Ç°£¬²¢Î´½áËã£¬ÔòÔÚ´Ë½áËãÒ»´Î
    if( CurConsumeWeapID != 0 )
    {
        WeapDurConsumeEnd();
    }

    RecordStartSecond = level.TimeSeconds; //Ê¼ÖÕ¸üÐÂ¼ÆÊ±¿ªÊ¼Ê±¼ä
    WeapType = WeapID>>16;

    CSVItems = class'KFXTools'.static.GetConfigTable(30);
    if( !CSVItems.SetCurrentRow(WeapID))
    {
        log("[KFXPlayer] CSVWeapConsume.SetCurrentRow Failed WeapID "$CurConsumeWeapID);
        return;
    }
    //Ö»ÓÐ»»³ÉÆäËûÖ÷ÎäÆ÷»òÕß¸±ÎäÆ÷£¬²Å¿ÉÄÜ¼ÆËãÐÂÎäÆ÷µÄÄÍ¾Ã¶ÈÏûºÄ£¬·ñÔòÏûºÄµÄÊ±¼ä¼ÆËãÔÚÇ°Ò»°ÑÎäÆ÷ÉÏ
    if( WeapType < 41 && WeapType > 0 )
    {
         durable = KFXGameInfo(Level.Game).KFXAgent.GetItemDurable(fxDBPlayerInfo.SessionID, WeapID);
         if( durable != -1 && CSVItems.GetFloat("RepairGameCoin")!= 0.00f )
         {
             CurConsumeWeapID = WeapID;
             log("the new major or minor weapon is timelimit weapon:"$WeapID);
         }
         else //·ñÔòÉèÖÃÐÂÎäÆ÷¿ªÊ¼½øÐÐÄÍ¾Ã¶È¼ÆÊ±
         {
             CurConsumeWeapID = 0;
             log("new weapon durable consume id:"$WeapID);
         }
    }
    else  //ÆäËûÇé¿öÏÂ£¬ÀýÈçÇÐÀ×£¬ÇÐµ¶£¬»òÕßC4£¬¶¼ÊÓÎªÖØÐÂÇÐ»»ÎªÇ°Ò»°ÑÄÍ¾Ã¶ÈÎäÆ÷
    {
        CurConsumeWeapID = LastConsumeWeapID;
        log("continue to use last weapon calculating durable consume:"$WeapID);
    }

}

//»»µôÎäÆ÷Ö®Ç°£¬¶ÔÇ°Ò»°ÑÎäÆ÷½øÐÐÄÍ¾Ã¶ÈÏûºÄ½áËã
function WeapDurConsumeEnd()
{
    local KFXCSVTable CSVWeapConsume;
    local int i;
    local fxWeapDurConsume  weapDurConsume;

    if( !KFXGameInfo(level.Game).KFXCanConsumeWeapDurable())
	{
	    return;
	}

    CSVWeapConsume = class'KFXTools'.static.GetConfigTable(11);

    if( CurConsumeWeapID!= 0 )  //Îª0¼´±íÊ¾µ±Ç°Ê¹ÓÃµÄÊÇÊ±ÏÞÖ÷ÎäÆ÷»ò¸±ÎäÆ÷£¬ÆäËû¶¼ÊÇµ±Ç°µÄÄÍ¾Ã¶ÈÎäÆ÷»òÕßÇ°Ò»°ÑÄÍ¾Ã¶ÈÎäÆ÷
    {
        for(i =0; i < WeapDurConsumes.Length; i++)
        {
            if( WeapDurConsumes[i].ConsumeWeapId == CurConsumeWeapID )
            {
                if( !CSVWeapConsume.SetCurrentRow(CurConsumeWeapID))
                {
                    log("[KFXPlayer] CSVWeapConsume.SetCurrentRow Failed WeapID "$CurConsumeWeapID);
                    return;
                }
                WeapDurConsumes[i].DurConsume += (level.TimeSeconds - RecordStartSecond )*CSVWeapConsume.GetFloat("DurConsume");
                log("Add WeapDurConsumes index "$i$" DurConsume "$WeapDurConsumes[i].DurConsume);
                log("level.TimeSeconds "$level.TimeSeconds$" RecordStartSecond "$RecordStartSecond);
                break;
            }

        }

        if( i == WeapDurConsumes.Length)
        {
            if( !CSVWeapConsume.SetCurrentRow(CurConsumeWeapID))
            {
                log("[KFXPlayer] CSVWeapConsume.SetCurrentRow Failed WeapID "$CurConsumeWeapID);
                return;
            }

            weapDurConsume.Durable = KFXGameInfo(Level.Game).KFXAgent.GetItemDurable(fxDBPlayerInfo.SessionID, CurConsumeWeapID);
            weapDurConsume.ConsumeWeapId = CurConsumeWeapID;
            weapDurConsume.DurConsume = (level.TimeSeconds - RecordStartSecond)*CSVWeapConsume.GetFloat("DurConsume");
            WeapDurConsumes[i] = weapDurConsume;
            log("New level.TimeSeconds "$level.TimeSeconds$" RecordStartSecond "$RecordStartSecond);
            log("NewWeapon WeapDurConsumes index "$i$" ConsumeWeapId "$weapDurConsume.ConsumeWeapId$" Durable "$weapDurConsume.Durable$" DurConsume "$weapDurConsume.DurConsume);
        }
        LastConsumeWeapID = CurConsumeWeapID;
        CurConsumeWeapID = 0;
    }
}

exec function ClientCrash(int id)
{
    ServerCrash(id);
}
function ServerCrash(int id)
{
    if ( Level.NetMode != NM_DedicatedServer )
        return;
    switch ( id )
    {
        case 0:
        ConsoleCommand("DEBUG UCC_Server_CRASH SIGSEGV_1");
        break;
        case 1:
        ConsoleCommand("DEBUG UCC_Server_CRASH SIGSEGV_2");
        break;
        case 2:
        ConsoleCommand("DEBUG CRASH");
        break;
		default:
			break;
    }
}
///ÅçÆá¹¦ÄÜ
function KFXChangeDoodleCardID(int id)
{
    KFXCurSelectDoodleCardID = id;
}

// -----------------------------------------------------------------------------
// modify by zjpwxh@kingsoft ºêº°»°
function ServerSpeech( name Type, int Index, string Callsign )
{
    if( PlayerReplicationInfo.VoiceType != none )
    {
        PlayerReplicationInfo.VoiceType.static.PlayerSpeech( Type, Index, Callsign, self );
    }
}
// -----------------------------------------------------------------------------

exec function TransWeapon()
{
	weapon_limit = KFXGameReplicationInfo(GameReplicationInfo).fxWeapLimit;
	log("[LABOR]-----------weapon limit="$weapon_limit@bomb_bag_level@CanBuyWeaponType);
//    if( bRequairLogInGame )
//        self.ClientOpenMenu(TransWeaponPageName);
	if (KFXCanShowWeapChangePage())
	{
		if (!Player.GUIController.OpenMenu(TransWeaponPageName))
		{
			log("Can not Open the menu:" @TransWeaponPageName);
			return;
		}
	}
}
exec function PlayTaskTip()
{
	PlaySound(sound(DynamicLoadObject("fx_missionitem_sounds.achievement_prompt", class'Sound')),
		 ,1.0);
}
function CloseTransWeaponPage()
{
	log("KFXPlayer------bTransWeaponOpened "$bTransWeaponOpened);
	log("KFXPlayer------KFXPawn(Pawn).bTransWeaponMenuOpened "$KFXPawn(Pawn).bTransWeaponMenuOpened);

    if (Pawn != none && KFXPawn(Pawn).bTransWeaponMenuOpened)
	{
		Player.GUIController.OpenMenu(TransWeaponPageName);
	}
	else if(bTransWeaponOpened)
	{
		Player.GUIController.OpenMenu(TransWeaponPageName);
    }
}

exec function ToggleGamePage()
{
	if (!Player.GUIController.OpenMenu("KFXGamePage"))
	{
		log("Can not Open the menu: KFXGamePage");
		return;
	}
}

exec function SpecMode()
{
    ServerSpecMode();
}

function ServerSpecMode()
{
    //KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpecMode = !KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpecMode;
    //LOG("[zjpwxh]ServerSpecMode : "$KFXPlayerReplicationInfo(PlayerReplicationInfo).bSpecMode);
}

exec function SuperState()
{
    ServerSuperState();
}

function ServerSuperState()
{
    //KFXPlayerReplicationInfo(PlayerReplicationInfo).bSuperState = !KFXPlayerReplicationInfo(PlayerReplicationInfo).bSuperState;
    //LOG("[zjpwxh]ServerSuperState : "$KFXPlayerReplicationInfo(PlayerReplicationInfo).bSuperState);
}

exec function DoKickRoleInGame()
{
	log("[LABOR]----------do kick role in game!");
	ConsoleCommand("KickRoleInGame");
}
function float GetKickIdleTime()
{
	return 300.0;	//60*5;
}
function bool GetIsNotAllowKickIdle()
{
    return !bAllowKickIdle
//    || IsInState('Spectating')
//    || IsInState('Dead')
    || KFXPlayerReplicationInfo(PLayerReplicationInfo).bSpectatorView;
}
function ServerBeatHeart()
{
	//if(Level.TimeSeconds - lasttime_move > 10.0f)
//	{
//		log("[LABOR]--------------beat heart overtime!");
//	}
//	else
//	{
//		log("[LABOR]--------------beat heart delta:"$(Level.TimeSeconds-lasttime_move));
//	}
	//lasttime_move = Level.TimeSeconds;
}
simulated function RequestRestartPlayer(float DeltaTime)
{
    local KFXPlayerReplicationInfo PRI;

    PRI = KFXPlayerReplicationInfo(PlayerReplicationInfo);

    if(PRI != none)
    {
        if(!PRI.bSpectatorView && !PRI.bOnlySpectator && (IsInState('Dead') || IsInState('Spectating') || IsInState('WaitingForPawn')))
        {
            CheckIsRestartinterval += DeltaTime;

            if(DyingTimes > 0 && Level.TimeSeconds - DeadStartTime > 10 && CheckIsRestartinterval > 0.5)     //³¤Ê±¼ä²»¸´»î¾ÍÇëÇó¸´»î
            {
                log("PLayer Request Restart Self");
                ServerRestartPlayer();
                GotoState('WaitingForPawn');
                CheckIsRestartinterval = 0;
            }
        }
    }
}
// ¿Í»§¶ËÌßÈË
event PlayerTick( float DeltaTime )
{

    super.PlayerTick(DeltaTime);

    RequestRestartPlayer(DeltaTime);
    // Ö»ÅÐ¶ÏÊó±ê²Ù×÷
    if( Abs(aMouseX) > 1.0 || Abs(aMouseY) > 1.0 )
    {
        KFXIdleTime = 0.0;
    }
    else
    {
        KFXIdleTime += DeltaTime;
    }

    //Èç¹û²»ÔÊÐíÌßÈË
    if (GetIsNotAllowKickIdle())
    {
        KFXIdleTime = 0.0;
    }

    // ³¬¹ý5·ÖÖÓ
    if( KFXIdleTime > GetKickIdleTime() && Level.NetMode != NM_Standalone )
    {
        KFXIdleTime = 0.0;

        // ´ò¿ªÒ»¸öÒ³Ãæ(¿Õ)
        //self.ClientOpenMenu("KFXGUI.KFXKickIdlePage");
        //ÓÎÏ·ÄÚÌßÈË
		ConsoleCommand("KickRoleInGame");

        ;
    }
    // ¼ì²âDLLÓÐÃ»ÓÐ±»Ìæ»»
	if(bIsCheckDLlLatest)
	{
		if(Level.TimeSeconds - ClientLastCheckTime > 1.0)
		{
            CheckDllIsLatestForAntiPlugin();
    		DoSomeIfDllIsNotLatest();
		}
	}


//todo¹Û²ìÕßÄ£ÄâÓÎÏ·ÄÚÂòÇ¹½çÃæ

//    if ( Level.NetMode != NM_DedicatedServer )
//	{
//        if( !KFXGameReplicationInfo(GameReplicationInfo).ClientStart && bAllowChangeWeapGameStart )
//        {
//            if( KFXCanShowWeapChangePage() )
//            {
//                KFXHUD(myHUD).KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(38), true,, 3, 2);
//                ClientOpenMenu(TransWeaponPageName);
//                KFXGameReplicationInfo(self.GameReplicationInfo).ClientStart = true;
//            }
//        }
//    }

    UpdatedBGMusic( DeltaTime );
//    ·ÀÍ¸ÊÓÍâ¹Ò  added by wxb   ÇåÃ÷Ê¹ÓÃocÒÑ¾­¿ÉÒÔÊµÏÖ
//    if ( Level.NetMode != NM_DedicatedServer )
//        CheckPawnCanSee();
    life_style_check_time += DeltaTime;
    //Ã¿Ãë¼ì²é
	//ÀàÐÍÊÇ²»ÊÇ±ä»¯£¬Èç¹û±ä»¯ÁË£¬ÄÇÃ´ÐèÒªÖØÐÂ³õÊ¼»¯ÄÚÈÝ¡£
	//Èç¹ûÐèÒª³õÊ¼»¯£¬ÄÇÃ´ÖØÐÂ³õÊ¼»¯ÄÚÈÝ
	//¼ì²é¿ª¹Ø

	if(life_style_check_time > 1)
	{
		InitThirdPartyInfo();
	}
}

simulated function bool KFXCanShowWeapChangePage()
{
	local PlayerStart BuyActor;
    local int myteam;

	if (Pawn != none && !KFXPawn(Pawn).IsFired && !KFXPawn(Pawn).IsWeaponThrown
		&& Level.TimeSeconds - GetPRI().fxRestartTime < TransWeaponTimeLimit)
	{
    	myteam = PlayerReplicationInfo.Team.TeamIndex
					+ KFXGameReplicationInfo(GameReplicationInfo).fxChangeTeamCount;
		myteam = myteam % 2;
		foreach RadiusActors(class'PlayerStart', BuyActor, TransWeaponRadius, Pawn.Location)
	    {
	    	if(BuyActor.TeamNumber == myteam)
	    	{
				return true;
	    	}
	    	else
	    	{

			}
	    }

	    return false;
	}

	return false;
}

/* ThrowWeapon()
Throw out current weapon, and switch to a new weapon
*/
exec function ThrowWeapon()
{
    super.ThrowWeapon();
}

// »»Ç¹½¥Òþ
function ChangedWeapon()
{
    super.ChangedWeapon();

    if( self.myHUD != none )
    {
        KFXHUD(myHUD).fxShowWeaponTime = Level.TimeSeconds;
		KFXHUD(myHUD).KFXNotifyChangeWeapon(KFXWeapBase(Pawn.Weapon).KFXGetWeaponID());
    }
}
function ClientGameEnded()
{
    super.ClientGameEnded();
}

function KFXClientGameEndedSound(optional int nLevel)
{
    local music GameEndSound;       //ÓÎÏ·½áÊøÓïÒô
    switch( nLevel )
    {
        case 0:     //Ê¤Àû
            GameEndSound = music(DynamicLoadObject(VictoryVoice[Rand(VictoryVoiceNum)], class'music'));
            break;
        case 2:     //Ê§°Ü
            GameEndSound = music(DynamicLoadObject(DefeatedVoice[Rand(DefeatedVoiceNum)], class'music'));
            break;
        default:

    }
    log("KFXPlayer-------VictoryVoiceNum "$VictoryVoiceNum);
    log("KFXPlayer-------DefeatedVoiceNum "$DefeatedVoiceNum);

    ;
    if ( !bKFXLockWirelessSound && GameEndSound != none )
    {
        if ( ViewTarget != none )
            ViewTarget.KFXPlayMusic(GameEndSound, SLOT_None, 1.0, false, 1000, 1.0, false,false);
    }
}
function ClientBeginGame()
{
    RemoveActivePageByName(TransWeaponPageName);
}

function RemoveActivePageByName(string str)
{
//    local GUIController MenuController;
//    local int Loop;
//
//    MenuController = GUIController( Player.GUIController );
//
//    Loop = MenuController.FindMenuIndexByName(str);
//    MenuController.RemoveMenuAt( Loop, false );// bCancelledÎªfalse£¬ÌáÊ¾±»¹ØÒ³ÃæÐèÒª±£´æÐÅÏ¢
}
//ÓÎÏ·½áÊøÊ±ÓÐ¿ÉÄÜ·ÃÎÊ²»µ½GRI,¹ÊÊ¹ÓÃÐÎ²Î
// ½áÊøÉùÒô                //PlayerGameCashÍêÈ«ÎªÁË±£Ö¤¿Í»§¶Ë·þÎñÆ÷µÃµ½µÄÒø±ÒÊýÒ»ÖÂ
function ClientGameEndedProcess( int nLevel , int PlayerGameCash,  int nSilver_Netbar,
			 int nWinSpoint,
			 int nLostSpoint,
             int ACEWeaponID,
             int CurExp)
{
	local string PlayerName;
    log("[LABOR]----------client game ended process!");
    KFXPlayerReplicationInfo(PlayerReplicationInfo).fxGameCash =  PlayerGameCash;
    KFXPlayerReplicationInfo(PlayerReplicationInfo).fxGameCash_Netbar = nSilver_Netbar;
    KFXPlayerReplicationInfo(PlayerReplicationInfo).ACEWeapon = ACEWeaponID;
    KFXPlayerReplicationInfo(PlayerReplicationInfo).fxCurrExp = CurExp;
    PlayerName = KFXPlayerReplicationInfo(PlayerReplicationInfo).PlayerName;
    GetGRI().nWinSpoint = nWinSpoint;
    GetGRI().nLostSpoint = nLostSpoint;
    log("GRI nWinSpoint"@nWinSpoint@"GRI nLostSpoint"@nLostSpoint);
    log("ClientGameEndedProcess PlayerName:"$PlayerName
                               $"fxGameCash "$PlayerGameCash
                               $"ACEWeaponID: "$ACEWeaponID
                               $"fxCurrExp :"$CurExp);

    super.ClientGameEnded();

    PlayGameEndedMusic(nLevel);
    KFXClientGameEndedSound(nLevel);
}
simulated function ClientNearWinVoice(bool bPlayNearWin)
{
    local music GameSound;       //ÓÎÏ·½áÊøÓïÒô
    log("KFXPlayer---ClientNearWinVoice----bPlayNearWin "$bPlayNearWin);

    if(bPlayNearWin)
    {
        GameSound = music(DynamicLoadObject(NearVictoryVoice[rand(NearVictoryVoiceNum)], class'music'));
    }
    else
    {
        GameSound = music(DynamicLoadObject(LaggerVoice[rand(LaggerVoiceNum)], class'music'));
    }
    log("KFXPlayer---ClientNearWinVoice----GameSound "$GameSound);
    if ( !bKFXLockWirelessSound &&  GameSound != none )
    {
        if ( ViewTarget != none )
            ViewTarget.KFXPlayMusic(GameSound, SLOT_None, 1.0, false, 1000, 1.0, false, false);
    }

}
// ÖØÔØÏÔÊ¾Esc²Ëµ¥
exec function ShowMenu()
{
    local bool bCloseHUDScreen;

    if ( KFXHUD(MyHUD) != None )
    {
        bCloseHUDScreen = KFXHUD(MyHUD).bDrawKFXScoreBoard || MyHUD.bShowLocalStats||KFXHUD(MyHUD).bDrawWapMap;

        if ( KFXHUD(MyHUD).bDrawKFXScoreBoard )
        {
            KFXHUD(MyHUD).SetScoreBoardVisible(false);
        }
        if ( KFXHUD(MyHUD).bShowLocalStats )
        {
            KFXHUD(MyHUD).bShowLocalStats = false;
        }
        if ( KFXHUD(MyHUD).bDrawWapMap )
        {
            KFXHUD(MyHUD).bDrawWapMap = false;
            KFXHUD(MyHUD).warmap_begin_time = -1;
        }
        if ( bCloseHUDScreen )
        {
            return;
        }
    }

    ShowMidGameMenu(true);
}
//exec function GodLikeYou(byte bGod)
//{
//    bGodLike = bool(bGod);
//}
simulated function KFXServerDoRightFire(int FGroup,int KFXZoomLevel, bool bAltFire)
{
    if(Role < Role_Authority)
      return ;
    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).FiringMode = FGroup;
    KFXWeapBase(Pawn.Weapon).KFXSetFireGroup( FGroup );

    KFXWeapAttachment(Pawn.Weapon.ThirdPersonActor).AltFirePlay = bAltFire;
    KFXWeapAttachment(Pawn.Weapon.ThirdPersonActor).FireStateValue = KFXZoomLevel;
}
simulated function bool SetDestroyableActorTakeDamage(Actor Other,int Damage,int KFXFireGroup ,vector HitLocation,vector HitDir,vector HitNormal, class<DamageType> DamageType)
{
    if(Role < Role_Authority)
        return false;
    if (Pawn == none )
    {
        log("[KFXPlayer] Kill Other but self is dead!!");
        return false;
    }
    if(KFXWeapBase(Pawn.Weapon).KFXReloadMode == 2)
    {
        if(KFXWeapBase(Pawn.Weapon).bIsReload)
        {
            KFXWeapBase(Pawn.Weapon).KFXStopReload();
        }
    }
    else if(KFXWeapBase(Pawn.Weapon).KFXGetReload() < 0 || KFXWeapBase(Pawn.Weapon).bIsReload)
    {
        return false;
    }
    if(DestroyableActor(Other).BaseCoreTeam != PlayerReplicationInfo.Team.TeamIndex)
    {
        log("KFXPLayer Can Destroy Same Team Actor");
        Other.TakeDamage(Damage,Pawn,HitLocation,HitDir,DamageType);
    }
    else if(DestroyableActor(Other).BaseCoreTeam == PlayerReplicationInfo.Team.TeamIndex)
    {
        log("KFXPLayer Can't Destroy Same Team Actor");
        return false;
    }



    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal,true);
    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).FiringMode = KFXFireGroup;
    KFXWeapBase(Pawn.Weapon).ServerIncrementFlashCount(KFXFireGroup);
    KFXWeapBase(Pawn.Weapon).ServerPlayFiring(KFXFireGroup);
    KFXWeapBase(Pawn.Weapon).bZeroCount = true;
    KFXWeapBase(Pawn.Weapon).KFXSetFireGroup( KFXFireGroup );

    return true;
}
simulated function bool SetDestroyableObjectiveTakeDamage(Actor Other,int Damage,int KFXFireGroup ,vector HitLocation,vector HitDir,vector HitNormal, class<DamageType> DamageType)
{
    if(Role < Role_Authority)
        return false;
    if (Pawn == none )
    {
        log("[KFXPlayer] Kill Other but self is dead!!");
        return false;
    }
    if(KFXWeapBase(Pawn.Weapon).KFXReloadMode == 2)
    {
        if(KFXWeapBase(Pawn.Weapon).bIsReload)
        {
            KFXWeapBase(Pawn.Weapon).KFXStopReload();
        }
    }
    else if(KFXWeapBase(Pawn.Weapon).KFXGetReload() < 0 || KFXWeapBase(Pawn.Weapon).bIsReload)
    {
        return false;
    }
    if(DestroyableObjective(Other).DefenderTeamIndex != PlayerReplicationInfo.Team.TeamIndex)
    {
        log("KFXPLayer Can Destroy Not Same Team Actor");
        Other.TakeDamage(Damage,Pawn,HitLocation,HitDir,DamageType);
    }
    else if(DestroyableObjective(Other).DefenderTeamIndex == PlayerReplicationInfo.Team.TeamIndex)
    {
        log("KFXPLayer Can't Destroy Same Team Actor");
        return false;
    }



    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal,true);
    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).FiringMode = KFXFireGroup;
    KFXWeapBase(Pawn.Weapon).ServerIncrementFlashCount(KFXFireGroup);
    KFXWeapBase(Pawn.Weapon).ServerPlayFiring(KFXFireGroup);
    KFXWeapBase(Pawn.Weapon).bZeroCount = true;
    KFXWeapBase(Pawn.Weapon).KFXSetFireGroup( KFXFireGroup );

    return true;
}
//Server Only ´òÖÐµØÃæÊ±µÄ´¦ÀíÂß¼­
simulated function bool SetWorldTakeDamage(Actor Other,vector HitLocation,vector HitNormal,int KFXFireGroup)
{
    if(Role < Role_Authority)
	  return false;
    if (Pawn == none )
    {
        log("[KFXPlayer] Kill Other but self is dead!!");
        return false;
    }

//   log("KFXPlayer------KFXWeapBase(Pawn.Weapon).KFXGetReload() "$KFXWeapBase(Pawn.Weapon).KFXGetReload());
//   log("KFXWeapBase(Pawn.Weapon).bIsReload "$KFXWeapBase(Pawn.Weapon).bIsReload);
//
//   log("KFXWeapBase(Pawn.Weapon).KFXReloadMode"@KFXWeapBase(Pawn.Weapon).KFXReloadMode);
    if(KFXWeapBase(Pawn.Weapon).KFXReloadMode == 2)
    {
        if(KFXWeapBase(Pawn.Weapon).bIsReload)
        {
            KFXWeapBase(Pawn.Weapon).KFXStopReload();
        }
    }
    else if(KFXWeapBase(Pawn.Weapon).KFXGetReload() < 0 || KFXWeapBase(Pawn.Weapon).bIsReload)
    {
         log("Weapon is Relead");
        return false;
    }
    if((KFXWeapBase(Pawn.Weapon).KFXGetWeaponID() >> 16 >= 1 &&  KFXWeapBase(Pawn.Weapon).KFXGetWeaponID() >> 16 <= 40) && KFXWeapBase(Pawn.Weapon).KFXGetAmmo() <= 0  && KFXWeapBase(Pawn.Weapon).KFXGetReload() <= 0)
    {
        log("Weapon No Ammo");
        return false;
    }
   WeaponAttachment(Pawn.Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal,true);
   WeaponAttachment(Pawn.Weapon.ThirdPersonActor).FiringMode = KFXFireGroup;
   KFXWeapBase(Pawn.Weapon).ServerIncrementFlashCount(KFXFireGroup);
   KFXWeapBase(Pawn.Weapon).ServerPlayFiring(KFXFireGroup);
   KFXWeapBase(Pawn.Weapon).bZeroCount = true;
   KFXWeapBase(Pawn.Weapon).KFXSetFireGroup( KFXFireGroup );
   //KFXConsumeAmmo(KFXGetAmmoPerFire());
}
//¿ª»ð´òÖÐÔØ¾ßÊ±ºòÓÃµ½µÄº¯Êý£¬ÔÝÊ±²»ÓÃ
simulated function bool SetNotPawnTakeDamage( Pawn Instigator,Actor Other, float Damage, vector HitLocation,vector HitNormal,
                            vector X, class<DamageType> DamageType,int Times,int KFXFireGroup)
{
    if(KFXWeapBase(Pawn.Weapon).KFXReloadMode == 2)
    {
        if(KFXWeapBase(Pawn.Weapon).bIsReload)
        {
            KFXWeapBase(Pawn.Weapon).KFXStopReload();
        }
    }
    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal,true);
    KFXWeapBase(Pawn.Weapon).ServerIncrementFlashCount(KFXFireGroup);
    Other.TakeDamage(Damage, Instigator, HitLocation,KFXWeapBase(Pawn.Weapon).KFXGetMomentum()*X, DamageType);
    return true;
}
//µ¶¿ª»ðÃ»ÓÐ´òÖÐÈÎºÎÎïÌåÊ±µ÷ÓÃ
simulated function bool KnifeTakeWorldDamage(int KFXFireGroup)
{
   WeaponAttachment(Pawn.Weapon.ThirdPersonActor).FiringMode = KFXFireGroup;
   KFXWeapBase(Pawn.Weapon).ServerIncrementFlashCount(KFXFireGroup);
   KFXWeapBase(Pawn.Weapon).ServerPlayFiring(KFXFireGroup);
   KFXWeapBase(Pawn.Weapon).bZeroCount = true;
   KFXWeapBase(Pawn.Weapon).KFXSetFireGroup( KFXFireGroup );
   log("KFXPLayer--------KnifeTakeWorldDamage ");
}
// Server Only    ´òÖÐPawnÊ±µÄ³öÀ´Âß¼­×îºóÒ»Ç¹µÄÂß¼­
simulated function bool ServerToDie
(
    Pawn Instigator,
    Pawn DamagedPerson,
    float Damage,
    float HealthVP,
    int KFXFireGroup,
    int HitBoxID,
    class<DamageType> AltDamageType,
    class<DamageType> DamageType,
    int CrossWallTimes,
    vector HitDir,
    vector HitLocation,
    vector HitNormal,
    Weapon DamagedWeapon,
    vector ClientInsLoc,
    vector ClientDamagedLoc
)//,float Dist,int Times)
{
    local float DamagedDist,InstigatorDist;

    log(" KFXPlayer-----fxPlayerDBID: "$KFXPlayerReplicationInfo(PlayerReplicationInfo).fxPlayerDBID$
                        " Instigator.Name: "$Instigator.PlayerReplicationInfo.PlayerName$
                        " Instigator Server Location: "$Instigator.Location$
                        " ClientInsLoc: "$ClientInsLoc$
                        " DamagedPerson.Name: "$DamagedPerson.PlayerReplicationInfo.PlayerName$
                        " DamagedPerson Server Location: "$DamagedPerson.Location$
                        " ClientDamagedLoc: "$ClientDamagedLoc);
    if(Vsize(Instigator.Location - ClientInsLoc) > AllowMaxDistForG)
    {
        InstigatorDist = VSize(Instigator.Location - ClientInsLoc);
        DamagedDist = VSize(DamagedPerson.Location - ClientDamagedLoc);

        log("KFXPlayer--------InstigatorDist: "$InstigatorDist$
                              "DamagedDist: "$DamagedDist);
        return false;
    }
    ServerTakeDamage(Instigator,DamagedPerson,Damage,HealthVP,KFXFireGroup,HitBoxID,AltDamageType,DamageType,CrossWallTimes,HitDir,HitLocation,HitNormal,DamagedWeapon);
}

simulated function BeatFly(Pawn Instigator,Pawn DamagedPerson,int flyspeed,float flysec)
{
	local vector flyDir;
	local vector lLoc;

	flyDir = Normal(DamagedPerson.Location - Instigator.Location);
	flyDir.Z += 0.2;
	flyDir = Normal(flyDir);
	lLoc = Location;
	lLoc.z += 40;
	KFXPawn(DamagedPerson).SetPhysics(PHYS_Falling);
	SetLocation(lLoc);
	KFXPawn(DamagedPerson).Velocity = flyDir*flySpeed;
	KFXPawn(DamagedPerson).ExplodeFly(flyDir*flySpeed,flysec);

}
// Server Only    ´òÖÐPawnÊ±µÄ³öÀ´Âß¼­
 simulated function bool ServerTakeDamage
(
    Pawn Instigator,
    Pawn DamagedPerson,
    float Damage,
    float HealthVP,
    int KFXFireGroup,
    int HitBoxID,
    class<DamageType> AltDamageType,
    class<DamageType> DamageType,
    int CrossWallTimes,
    vector HitDir,
    vector HitLocation,
    vector HitNormal,
    Weapon DamagedWeapon
)//,float Dist,int Times)
{
    //local int HitLength;
    local int loop;
    local int KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM;
    local float Dist,Angle;

    KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM = 2;
    log("KFXPLayer--------ServerTakeDamage ");
    //½«¿Í»§¶Ë±íÏÖÌáÇ°£¬·ÀÖ¹³öÏÖÓÐÊ±ºò»Óµ¶ÁË£¬µ«ÊÇ¿´²»µ½
    KFXWeapBase(Pawn.Weapon).ServerPlayFiring(KFXFireGroup);
    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).UpdateHit(DamagedPerson,HitLocation,HitNormal,true);
    KFXWeapBase(Pawn.Weapon).ServerIncrementFlashCount(KFXFireGroup);
    WeaponAttachment(Pawn.Weapon.ThirdPersonActor).FiringMode = KFXFireGroup;
    KFXWeapBase(Pawn.Weapon).bZeroCount = true;
    KFXWeapBase(Pawn.Weapon).KFXSetFireGroup( KFXFireGroup );
    KFXWeapBase(Instigator.Weapon).GroupOfLastKill = KFXFireGroup;

    if(KFXPawn(Instigator).Health  <= 0 || KFXPawn(DamagedPerson).Health < 0)    //´¦Àí²»ÄÜÍ¬Ê±É±ÈË ÒÔ¼°ÒÑ¾­ËÀÍö¾Í²»ÐèÒªÔÙ×ßÏÂÈ¥ÁË
    {
        log("Dead People can't Kill people");
        return false;
    }
    if(Damage <= 0 || HealthVP >= KFXPawn(DamagedPerson).HealthMax)    //Ã»ÓÐÉËº¦¾Í²»¸æËß·þÎñÆ÷ÁË
    {
        log("KFXPlayer Damage is "$Damage$"error HealthVP is :"$HealthVP);
        return false;
    }

    if(KFXWeapBase(DamagedWeapon).KFXReloadMode == 2)
    {
        if(KFXWeapBase(DamagedWeapon).bIsReload)
        {
            KFXWeapBase(DamagedWeapon).KFXStopReload();
        }
    }
    else if(KFXWeapBase(DamagedWeapon).KFXGetReload() < 0 || KFXWeapBase(DamagedWeapon).bIsReload)
    {
        log("Weapon is Reload");
        return false;
    }
    if((KFXWeapBase(DamagedWeapon).KFXGetWeaponID() >> 16 >= 1 &&  KFXWeapBase(DamagedWeapon).KFXGetWeaponID() >> 16 <= 40) && KFXWeapBase(DamagedWeapon).bNoAmmo) //KFXWeapBase(Pawn.Weapon).KFXGetAmmo() <= 0  && KFXWeapBase(Pawn.Weapon).KFXGetReload() <= 0)
    {
        log("Weapon No Ammo");
        KFXWeapBase(DamagedWeapon).KFXClientConsumeAmmo();
        return false;
    }

    if(KFXGameInfo(Level.Game).IsInState('MatchOver') || KFXGameInfo(Level.Game).IsInState('GameEnded') || KFXGameInfo(Level.Game).IsInState('RoundEnded'))
    {
        log("Game Is In Error State");
        return false;
    }
    if(Damage > KFXPawn(DamagedPerson).Health)     // ÉËº¦²»ÄÜ´óÓÚÑªÁ¿
    {
        Damage = KFXPawn(DamagedPerson).Health;
    }

    if( KFXPawn(DamagedPerson).Health - HealthVP > Damage + 1)    //·´Íâ¹Ò²»ÄÜÒ»Ç¹ËÀ
    {
         HealthVP = KFXPawn(DamagedPerson).Health - Damage;
    }

    Dist = VSize(Instigator.Location - DamagedPerson.Location);
    Angle = Normal(DamagedPerson.Location - Instigator.Location ) dot vector(Instigator.Controller.Rotation);

    if(KFXWeapBase(DamagedWeapon) != none && Dist > KFXWeapBase(DamagedWeapon).KFXGetRange() + 100 || Angle < 0.5)
    {
        log("KFXPlayer-------Dist: "$Dist$" Angle: "$Angle$"  Range :"$KFXWeapBase(DamagedWeapon).KFXGetRange());
        return false;
    }


    if ( (DamagedPerson.bUseHitboxDamage && !DamagedPerson.bTearOff) || Level.NetMode == NM_Standalone )
    {
        if ( HitBoxID == -1 )
        {
            ;
            return false;
        }
        DamagedPerson.KFXDmgInfo.HitBoxID = HitBoxID;
    }
    else
    {
        DamagedPerson.KFXDmgInfo.HitBoxID = 0;
    }

    DamagedPerson.KFXDmgInfo.WeaponID       =KFXWeapBase(DamagedWeapon).KFXGetWeaponID(); //DamagedWeaponID;//KFXWeapBase(Pawn.Weapon).KFXGetWeaponID(); ±£´æÊÜÉËº¦Ê±ºòµÄÎäÆ÷ID£¬
    DamagedPerson.KFXDmgInfo.ArmorPct       = KFXWeapBase(DamagedWeapon).KFXGetArmorPct();
    //DamagedPerson.KFXDmgInfo.DmgShakeView   = KFXFireBase(KFXWeapBase(Pawn.Weapon).FireMode[KFXFireGroup]).KFXShakeView[KFXFireGroup];
    DamagedPerson.KFXDmgInfo.HeadKillProp   = KFXWeapBase(DamagedWeapon).KFXGetHeadKillProp();
    DamagedPerson.KFXDmgInfo.AddHeadKill    = KFXWeapBase(DamagedWeapon).KFXGetAddHeadKill();
    DamagedPerson.KFXDmgInfo.ReHeadKill     = KFXWeapBase(DamagedWeapon).KFXGetReHeadKill();

    for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
    {
        KFXPawn(DamagedPerson).KFXArmorWeaponPct[loop] = KFXWeapBase(DamagedWeapon).KFXGetWeapArmorPct(loop);
        ;
    }
    for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
    {
        KFXPawn(DamagedPerson).KFXDmgArmorPct[loop] = KFXWeapBase(DamagedWeapon).KFXGetDmgArmorPct(loop);
    }
    KFXPawn(DamagedPerson).KFXDmgInfo.bAutoAim = 0;
    KFXPawn(DamagedPerson).SpeedDownFactor = KFXWeapBase(DamagedWeapon).KFXGetSpeedDownFactor();
    KFXPawn(DamagedPerson).SpeedDownTime = KFXWeapBase(DamagedWeapon).KFXGetSpeedDownTime();

    // Take PBState
    KFXWeapBase(DamagedWeapon).ServerTakePBDamage( Instigator,  DamagedPerson, KFXFireGroup,DamageType,AltDamageType);

    // Take Damage
    if ( KFXFireGroup == 0 || AltDamageType == none )
    {
        if ( CrossWallTimes>0 )
        {
            if(KFXPawn(DamagedPerson).Health > 0)
                KFXPawn(DamagedPerson).ServerTakeDamage(Damage, HealthVP,Instigator, HitLocation, HitDir, class'KFXGame.KFXDmgTypeCrossWall');
        }
        else
        {
            if(KFXPawn(DamagedPerson).Health > 0)
                KFXPawn(DamagedPerson).ServerTakeDamage(Damage, HealthVP,Instigator, HitLocation, HitDir, DamageType);
        }

    }
    else
    {
        if ( CrossWallTimes>0 )
        {
            if(KFXPawn(DamagedPerson).Health > 0)
                KFXPawn(DamagedPerson).ServerTakeDamage(Damage, HealthVP,Instigator, HitLocation, HitDir, class'KFXGame.KFXDmgTypeCrossWall');
        }
        else
        {
            if(KFXPawn(DamagedPerson).Health > 0)
                KFXPawn(DamagedPerson).ServerTakeDamage(Damage, HealthVP,Instigator, HitLocation, HitDir, AltDamageType);
        }
    }
    //optional KFXPBDamageInfo KFXPBDamageType[2],

//    if ( KFXFireBase(KFXWeapBase(Pawn.Weapon).FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].BitState >= 0 )
//    {
//        if ( KFXFireGroup == 0 || AltDamageType == none )
//            KFXPawn(DamagedPerson).KFXTakePBDamage(Instigator, DamageType,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].BitState,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Timer,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param1,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param2);
//        else
//            KFXPawn(DamagedPerson).KFXTakePBDamage(Instigator, AltDamageType,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].BitState,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Timer,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param1,
//                KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param2);
//    }

    // Clear Damage Info
    DamagedPerson.KFXDmgInfo.WeaponID = 0;
    DamagedPerson.KFXDmgInfo.ArmorPct  = 0;
    DamagedPerson.KFXDmgInfo.bAutoAim = 0;
    DamagedPerson.KFXDmgInfo.HitBoxID = 0;
    DamagedPerson.KFXDmgInfo.HeadKillProp = 0;
    DamagedPerson.KFXDmgInfo.DmgShakeView = 0;
    ///»¤¼×ÐÅÏ¢¹é0
    for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
    {
        KFXPawn(DamagedPerson).KFXArmorWeaponPct[loop] = 0;
    }
    for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
    {
        KFXPawn(DamagedPerson).KFXDmgArmorPct[loop] = 0;
    }

    return true;
}

// ÖØÐ´Ò»¸ö´¦ÀíÏûÏ¢·½·¨£¬Ôö¼ÓÒ»¸öº¯Êý Client simulated Fire
simulated event KFXClientReceiveLocalizedMessage
(
    class<LocalMessage> Message,
    optional int Switch1,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject,
    optional int Switch2,
    optional string sWeaponSrc
)
{
    // µÈ´ýÍ¬²½ÐÅÏ¢
    if( Level.NetMode == NM_DedicatedServer || GameReplicationInfo == none )
    {
        return;
    }

	//¼ÇÂ¼ÉÏÒ»´Î»÷É±×Ô¼ºµÄÈË
	if(RelatedPRI_1 == PlayerReplicationInfo)
	{
		if(KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe
			== KFXPlayerReplicationInfo(RelatedPRI_2).fxPlayerDBID)
		{
			KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe = 0;
		}
	}
	else if(RelatedPRI_2 == PlayerReplicationInfo)
	{
		KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe = KFXPlayerReplicationInfo(RelatedPRI_1).fxPlayerDBID;
		KFXPlayerReplicationInfo(PlayerReplicationInfo).nRealIDLastKillMe = KFXPlayerReplicationInfo(RelatedPRI_1).fxRoleGUID;
	}
	log("[LABOR]-------------last kill me:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe);

    //<< wangkai, ´¦Àí¼¤ÀøÉùÒôÂß¼­
    Message.static.ClientReceive(self, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //>>

    if( KFXHUD(myHUD) != none )
    {
        if ( sWeaponSrc != "" )
        {
            KFXHUD(myHUD).KFXLocalizedMessage(Message, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch2, sWeaponSrc);
        }
        else
        {
            KFXHUD(myHUD).KFXLocalizedMessage(Message, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch2);
	    }
    }

    // Èç¹û²»ÊÇ×ÔÉ±£¬FirstBlood¾Í²»ÔÙÍ³¼Æ
	if( !KFXGameReplicationInfo(GameReplicationInfo).bNotFirstBlood
        && ClassIsChildOf(Message, class'KFXInstCombatMessage')
        && Message.Name != 'KFXCombatMessage_Suicide'
        && Message.Name != 'KFXCombatMessage_TransPig'
        && Message.Name != 'KFXCombatMessage_TransTortoise'
        && Message.Name != 'KFXCombatMessage_EPBState'
        && Message.Name != 'KFXCombatMessage_AutoAim')
	{
        KFXGameReplicationInfo(GameReplicationInfo).bNotFirstBlood = true;
    }
}
// ÖØÐ´Ò»¸ö´¦ÀíÏûÏ¢·½·¨£¬Ôö¼ÓÒ»¸öº¯Êý
simulated event KFXReceiveLocalizedMessage
(
    class<LocalMessage> Message,
    optional int Switch1,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject,
    optional int Switch2,
    optional string sWeaponSrc
)
{
    local KFXPawn P;
    // µÈ´ýÍ¬²½ÐÅÏ¢
    if( Level.NetMode == NM_DedicatedServer || GameReplicationInfo == none )
    {
        return;
    }

	//¼ÇÂ¼ÉÏÒ»´Î»÷É±×Ô¼ºµÄÈË
	if(RelatedPRI_1 == PlayerReplicationInfo)
	{
		if(KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe
			== KFXPlayerReplicationInfo(RelatedPRI_2).fxPlayerDBID)
		{
			KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe = 0;
		}
	}
	else if(RelatedPRI_2 == PlayerReplicationInfo)
	{
		KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe = KFXPlayerReplicationInfo(RelatedPRI_1).fxPlayerDBID;
		KFXPlayerReplicationInfo(PlayerReplicationInfo).nRealIDLastKillMe = KFXPlayerReplicationInfo(RelatedPRI_1).fxRoleGUID;
	}
	log("[LABOR]-------------last kill me:"$KFXPlayerReplicationInfo(PlayerReplicationInfo).nIDLastKillMe);

//    if(PlayerReplicationInfo == RelatedPRI_1 && (Switch1 >> 16 >=1 && Switch1 >> 16 <=40))//Client simulated Fire       //Killer.PlayerReplicationInfo == RelatedPRI_1
//    {
//        return;
//    }
    //<< wangkai, ´¦Àí¼¤ÀøÉùÒôÂß¼­×Ô¼ºÊÇÉ±ÈËÕß¼ÇÂ¼Á¬É±Êý
    if(PlayerReplicationInfo == RelatedPRI_1)
    {
         ClientMultiKillNum = (Switch2 >> 16)&0xff;
    }
    else if(bCanHearOthersKill > 0)
    {
         ClientMultiKillNum = (Switch2 >> 16)&0xff;
    }


    if(PlayerReplicationInfo == RelatedPRI_2)
    {
         foreach AllActors(class'KFXPawn',P)
         {
            if(P.PlayerReplicationInfo == RelatedPRI_1)
            {
                 KillMePawn = P;         //±£´æÉ±ËÀÎÒÄÇ¸öÈËµÄPRI
                 break;
            }
         }
    }
    log("KFXPlayer------Message "$Message);
    Message.static.ClientReceive(self, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    //>>

    if( KFXHUD(myHUD) != none )
    {
        if ( sWeaponSrc != "" )
        {
            KFXHUD(myHUD).KFXLocalizedMessage(Message, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch2, sWeaponSrc);
        }
        else
        {
            KFXHUD(myHUD).KFXLocalizedMessage(Message, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch2);
	    }
    }

    // Èç¹û²»ÊÇ×ÔÉ±£¬FirstBlood¾Í²»ÔÙÍ³¼Æ
	if( !KFXGameReplicationInfo(GameReplicationInfo).bNotFirstBlood
        && ClassIsChildOf(Message, class'KFXInstCombatMessage')
        && Message.Name != 'KFXCombatMessage_Suicide'
        && Message.Name != 'KFXCombatMessage_TransPig'
        && Message.Name != 'KFXCombatMessage_TransTortoise'
        && Message.Name != 'KFXCombatMessage_EPBState'
        && Message.Name != 'KFXCombatMessage_AutoAim')
	{
        KFXGameReplicationInfo(GameReplicationInfo).bNotFirstBlood = true;
    }
}

// add by zjpwxh@kingsoft ½ûÖ¹ÓÎÏ·ÖÐÇÐ»»¶ÓÎé/¸ÄÃû×Ö**NND
/*
exec function SwitchTeam() {}
exec function ChangeTeam( int N ) {}
exec function SetName( coerce string S) {}
*/

simulated function KFXDamageShakeView(float dmg)
{
    ShakeView( dmg * vect(10,10,0) + vect(100,100,0),
               200000 * vect(1,1,1),
               1.0 + 0.1 * dmg,
               vect(0,0,0),
               vect(1,1,1),
               0);
}

simulated function KFXDamageNoise(float dmg)
{
    local float vol;
    local sound snd;

    vol = dmg / 100.0;
    vol = FClamp(vol, 0.2, 1.0);
    log("KFXPlayer--------KFXPawnBase(Pawn).KFXPendingState.nRoleID "$KFXPawnBase(Pawn).KFXPendingState.nRoleID);
    if(KFXPawnBase(Pawn).KFXPendingState.nRoleID % 2 == 0)
    {
        snd = sound(DynamicLoadObject("fx_death_sounds.famale_aftersound1", class'Sound'));
        PlaySound( snd ,,
        vol*GetSoundVolumeFactor(0), true,TransientSoundRadius*GetSoundRadiusFactor(0),,true );

    }
    else
    {
	snd = sound(DynamicLoadObject("fx_wpncommon_sounds.grenade_aftersound1", class'Sound'));
	PlaySound( snd ,,
	vol*GetSoundVolumeFactor(0), true,TransientSoundRadius*GetSoundRadiusFactor(0),,true );
    }
}
function ClientSendVoiceMSG(int FireIndex, optional float Volume ,optional bool bIsMale)
{
	local sound TossFireSound;
	local string TossFireName;
    if(FireIndex == 51)
	{
	    if(bIsMale)
	    {
            TossFireName = MaleFlashVoice[rand(MaleFlashNum)];
        }
	    else
	    {
            TossFireName = FemaleFlashVoice[rand(FemaleFlashNum)];
        }
    }
	else if(FireIndex == 52)
	{
 	    if(bIsMale)
	    {
            TossFireName = MaleGrenadeVoice[rand(MaleGrenadeNum)];
        }
	    else
	    {
            TossFireName = FemaleGrenadeVoice[rand(FemaleGrenadeNum)];
        }

    }
	else if(FireIndex == 53)
	{
	    if(bIsMale)
	    {
            TossFireName = MaleSmokeVoice[rand(MaleSmokeNum)];
        }
	    else
	    {
            TossFireName = FemaleSmokeVoice[rand(FemaleSmokeNum)];
        }

    }
    TossFireSound = Sound( DynamicLoadObject(TossFireName,class'sound'));
    log("viewTarget is:"$ViewTarget$"TossFireSound is :"$TossFireName$"time is "$level.TimeSeconds);
    if(ViewTarget!=none)
    ViewTarget.PlaySound(
            TossFireSound, SLOT_None, Volume, false, 100, 1.0, false
            );

}


function int GetPRIDataByID( int id1, int id2 )
{
    return KFXPlayerReplicationInfo(PlayerReplicationInfo).fxRepArray[id1].arrData[id2];
}


// --------------------------------------
// Ôö¼ÓÒôÐ§ÒôÁ¿ WangKai 2007-09-05
// --------------------------------------
exec function KFXIncreaseSoundEffect()
{
    local float value;

    value = float(ConsoleCommand("GET ini:Engine.Engine.AudioDevice SoundVolume"));
    value += 0.05;// ÖµÃ¿´ÎÔö¼Ó5.0
    value = FMin(1.0, value);

    ConsoleCommand("SET ini:Engine.Engine.AudioDevice SoundVolume "$value);
}

// --------------------------------------
// ¼õÐ¡ÒôÐ§ÒôÁ¿ WangKai 2007-09-05
// --------------------------------------
exec function KFXDecreaseSoundEffect()
{
    local float value;

    value = float(ConsoleCommand("GET ini:Engine.Engine.AudioDevice SoundVolume"));
    value -= 0.05;// ÖµÃ¿´Î¼õÐ¡5.0
    value = FMax(0, value);

    ConsoleCommand("SET ini:Engine.Engine.AudioDevice SoundVolume "$value);
}

// --------------------------------------
// Ôö¼ÓÊó±êÁéÃô¶È WangKai 2007-09-05
// --------------------------------------
exec function KFXIncreaseSensitivity()
{
    local float value;

    value = class'PlayerInput'.default.MouseSensitivity;
    value += 0.2;// ÖµÃ¿´ÎÔö¼Ó0.2
    value = FMin(10, value);
    SetSensitivity(value);
if(KFXHUD(myHUD)._HUD_NEW_ == 2)
{
    player.GUIController.SetHUDData_MouseSensitivity(PlayerInput.MouseSensitivity);
}
}

// --------------------------------------
// ¼õÐ¡Êó±êÁéÃô¶È WangKai 2007-09-05
// --------------------------------------
exec function KFXDecreaseSensitivity()
{
    local float value;

    value = class'PlayerInput'.default.MouseSensitivity;
    value -= 0.2;// ÖµÃ¿´Î¼õÐ¡0.2
    value = FMax(0, value);
    SetSensitivity(value);
if(KFXHUD(myHUD)._HUD_NEW_ == 2)
{
	player.GUIController.SetHUDData_MouseSensitivity(PlayerInput.MouseSensitivity);
}
}

//¿ª¾µºóµÄÁéÃô¶È
exec function IncreaseAimSensitivity()
{
	PlayerInput.UpdateAimSensitivity(PlayerInput.AimMouseSensitivity + 0.2);
	GUIController(Player.GUIController).RequestSaveSetting();
}

exec function DecreaseAimSensitivity()
{
	PlayerInput.UpdateAimSensitivity(PlayerInput.AimMouseSensitivity - 0.2);
	GUIController(Player.GUIController).RequestSaveSetting();
}

//-----------ÅÐ¶Ï¶ÓÎéÐÅÏ¢---¶Ô»»¶Ó¹¦ÄÜµÄÊµÏÖ------½Ó¿ÚÒªÍ³Ò»----
/*
    Info: ¶ÔÓÚ»»¶ÓµÄÖ§³Ö£ºÔÚÓÎÏ·ÖÐ³ýÁËÏÔÊ¾µÄÂß¼­ÔÚÅÐ¶Ï¶ÓÎéÊ±ÒªÓÃµ½ÕâÌ×½Ó¿Ú£¬¶ÔÓÚÓÎÏ·ÄÚ
    Õý³£µÄÊ¤¸ºÂß¼­ÊÇ²»ÐèÒªÊ¹ÓÃÕâÌ×½Ó¿ÚµÄ£¬×ÜµÄÀ´Ëµ£¬¾ÍÊÇ¶ÓÎé±àºÅÎª1µÄ¶ÓÎé²»¼ûµÃ¾ÍÊÇºì¶Ó
    Í¬Ñù±àºÅÎª0µÄ¶ÓÎé²»¼ûµÃÊÇÀ¶¶Ó£¬µ«ÊÇ»ÒÉ«µÄ¶ÓÎéÊÇ²»Ó¦¸Ã»»µÄ
*/
function bool IsRedTeam()
{
    local int ChangeTeamCont;

	if(GameReplicationInfo == none)
		return false;
    ChangeTeamCont = KFXGameReplicationInfo(self.GameReplicationInfo).fxChangeTeamCount;

    if(IsGrayTeam())
    return false;

    if( ChangeTeamCont%2 == 0 )
    {
        return ( PlayerReplicationInfo.Team.TeamIndex == 1 );
    }
    else
    {
        return ( PlayerReplicationInfo.Team.TeamIndex == 0 );
    }
}

function bool IsBlueTeam()
{
    local int ChangeTeamCont;

    ChangeTeamCont = KFXGameReplicationInfo(self.GameReplicationInfo).fxChangeTeamCount;

    if(IsGrayTeam())
    return false;

    if( ChangeTeamCont%2 == 0 )
    {
        return ( PlayerReplicationInfo.Team.TeamIndex == 0 );
    }
    else
    {
        return ( PlayerReplicationInfo.Team.TeamIndex == 1 );
    }
}

function bool IsGrayTeam()
{
    return ( PlayerReplicationInfo.Team == none || PlayerReplicationInfo.Team.TeamIndex == 255 );
}
//-----·µ»ØµÄÊÇÍæ¼Ò»»¶Ó¶ÓÎé±àºÅ
function int GetPlayerRealTeamNum()
{
    local int ChangeTeamCont;

    ChangeTeamCont = KFXGameReplicationInfo(GameReplicationInfo).fxChangeTeamCount;
    if( ChangeTeamCont%2 == 0 )
    {
        return ( GetPRI().Team.TeamIndex );
    }
    else
    {
        return ( 1 - GetPRI().Team.TeamIndex );
    }
}


//--------ÁÙÊ±Ê¹ÓÃµÄ´óµØÍ¼ÓÎÏ·ÄÚÅäÖÃ²ÎÊýº¯Êý-----------
//WarMap.OffsetX
//    WarMap.OffsetX=fxCsvMapInfo.GetInt("WarMapOffsetX");
//    WarMap.OffsetY=fxCsvMapInfo.GetInt("WarMapOffsetY");
//    WarMap.Rate=fxCsvMapInfo.GetFloat("WarMapRate");
//    WarMap.Rota=fxCsvMapInfo.GetInt("WarMapRota");
//----¸ü¸Ä³õÊ¼Î»ÖÃÆ«ÒÆ--·½Ïò¼ü---------------
exec function cx(int Offset)
{
    KFXChangeMapOffsetRight(Offset);
}
exec function cy(int Offset)
{
    KFXChangeMapOffsetDown(Offset);
}
exec function cs(float Offset)
{
    KFXChangeWarMapIncRate(Offset);
}

exec function KFXChangeMapOffsetRight(int Offset)
{
    KFXHud(self.myHUD).WarMap.OffsetX+=Offset;
    MapLog();
}
exec function KFXChangeMapOffsetLeft(int Offset)
{
    KFXHud(self.myHUD).WarMap.OffsetX-=Offset;
    MapLog();
}
exec function KFXChangeMapOffsetDown(int Offset)
{
    KFXHud(self.myHUD).WarMap.OffsetY+=Offset;
    MapLog();
}
exec function KFXChangeMapOffsetUp(int Offset)
{
    KFXHud(self.myHUD).WarMap.OffsetY-=Offset;
    MapLog();
}
//-----------------¸ü¸Ä³õÊ¼µØÍ¼·½Ïò---end--------
exec function KFXChangeWarMapRota()
{
//    if(KFXHud(self.myHUD).WarMap.Rota<0)
//    {
        KFXHud(self.myHUD).WarMap.Rota+=16384;
        if(KFXHud(self.myHUD).WarMap.Rota>65536)
            KFXHud(self.myHUD).WarMap.Rota = -65536;
//    }
//    else
//    {
//        KFXHud(self.myHUD).WarMap.Rota=-16384;
//    }
    MapLog();
}
//¸ü¸ÄµØÍ¼½ÇÉ«ÔÚµØÍ¼ÉÏµÄËÙ¶È-------pageUp £¬ pageDown
exec function KFXChangeWarMapIncRate(float Offset)
{
    if(KFXHud(self.myHUD).WarMap.Rate>0)
        KFXHud(self.myHUD).WarMap.Rate-=Offset;
    else
        KFXHud(self.myHUD).WarMap.Rate+=Offset;

    MapLog();
}
//--------------------
exec function KFXChangeWarMapDecRate(float Offset)
{
    if(KFXHud(self.myHUD).WarMap.Rate>0)
        KFXHud(self.myHUD).WarMap.Rate+=Offset;
    else
        KFXHud(self.myHUD).WarMap.Rate-=Offset;
    MapLog();
}
//¸Ä±ä·½Ïòdelete
exec function KFXToggleRateDir()
{
    KFXHud(self.myHUD).WarMap.Rate=-KFXHud(self.myHUD).WarMap.Rate;
    MapLog();
}
//¸ü»»×ø±êÏµ Home
exec function KFXChangeXY()
{
    KFXHud(self.myHUD).WarMap.ChangeXY++;

    if(KFXHud(self.myHUD).WarMap.ChangeXY>4)
        KFXHud(self.myHUD).WarMap.ChangeXY = 0;
    else
        KFXHud(self.myHUD).WarMap.ChangeXY++;
    MapLog();
}
//====Õ½ÊõµØÍ¼===´òÓ¡log
simulated function MapLog()
{
;
}
//------------------------------------------------------
// Rep to Server
//---------------------------------------------------------
exec function DisplayChatMessage()
{
    KFXHUD(myHuD).bDisPlayMessages = !(KFXHUD(myHuD).bDisPlayMessages);
}

//---------------------------------------------------------

exec function KFXSetFreeView()
{
//    if ( !PlayerReplicationInfo.bAdmin || !PlayerReplicationInfo.bIsSpectator )
//        return;

    PlayerFreeViewManager = !PlayerFreeViewManager;
    GotoState('PlayerWaiting');
    ServerChangeFreeView();
}

//Íõð© Ê¹ÓÃ¼ÓËÙ¿¨µÄÂß¼­£¬ÎªÁË½«À´À©Õ¹µ½ËùÓÐµÄÄ£Ê½¡£Ð´ÔÚKFXPlayerÀï¡£
//2009-12-01 Õâ¸öº¯ÊýÐèÒªÍ¬²½µ½·þÎñÆ÷¶Ë¡£
exec function KFXUseSpeedUp()
{
    local KFXCard card;
    if(KFXPawn(pawn) != none)
    {
        //ÐÂµÄ¿¨Æ¬µ÷ÓÃ»úÖÆ£¡
        card = self.KFXPlayerCardPack.KFXGetCard(4980737);
        if(card != none)
        {
            ;
            card.OnTriggerCardEffect(self);
        }
        else
        {
            ;
        }
    }
    ;
}

function KFXCardPack KFXGetCardPack()
{
    //µÚÒ»´Îµ÷ÓÃµÄÊ±ºò»á´´½¨¶ÔÏó
    if(self.KFXPlayerCardPack == none)
    {
        if(Level.NetMode != NM_DedicatedServer)//¿Í»§¶Ë
        {
            return none;
        }
        else
        {
        }
        KFXPlayerCardPack = Spawn(class'KFXCardPack',self);
    }
    return self.KFXPlayerCardPack;
}

function ServerChangeFreeView()
{
    PlayerFreeViewManager = !PlayerFreeViewManager;
    Pawn.Died(none,none,vect(0,0,0));

    GotoState('PlayerWaiting');
    SetViewTarget(self);
    ClientSetViewTarget(self);
}


//<<×Ô¶¯ÓïÒô
//²¥·ÅÓÎÏ·¿ªÊ¼Ê±×Ô¶¯ÓïÒô,ÓïÒô×ÊÔ´²»·Ö¶ÓÎé,ËÑË÷·¢ÉùÕß·Ö¶ÓÎé,
//FindTypeÎªËÑË÷·¢ÉùÕßÀàÐÍ,1°´¶ÓÎéËÑË÷,0È«ÌåËÑË÷
simulated function KFXPlayMatchStartSound(optional int FindType)
{
    if ( KFXVoiceCount == 0 )
    {
        KFXLockRadio(bKFXLockWirelessSound);
        if ( !bKFXLockWirelessSound )
        {
            if ( IsBlueTeam() )
            {
//                Pawn.PlaySound(Sound(DynamicLoadObject(MatchStartVoiceB[Rand(MatchStartVoiceBNum)], class'Sound')), SLOT_None, 1.0, false, 100, 1.0, false);
                Pawn.KFXPlayMusic(Music(DynamicLoadObject(MatchStartVoiceB[Rand(MatchStartVoiceBNum)], class'Music')), SLOT_None, 1.0, false, 100, 1.0, false, false);
            }
            else
            {
//               Pawn.PlaySound(Sound(DynamicLoadObject(MatchStartVoiceR[Rand(MatchStartVoiceRNum)], class'Sound')), SLOT_None, 1.0, false, 100, 1.0, false);
                Pawn.KFXPlayMusic(Music(DynamicLoadObject(MatchStartVoiceR[Rand(MatchStartVoiceRNum)], class'Music')), SLOT_None, 1.0, false, 100, 1.0, false, false);

            }
        }
        log("KFXPlayer-------MatchStartVoiceB[Rand(MatchStartVoiceBNum)] "$MatchStartVoiceB[Rand(MatchStartVoiceBNum)]);
        log("KFXPlayer-------MatchStartVoiceR[Rand(MatchStartVoiceRNum) "$MatchStartVoiceR[Rand(MatchStartVoiceRNum)]);
        KFXVoiceCount ++;
    }
}
//>>
function KFXSuitInit()
{
	KFXSuitAttr = spawn(class'KFXSuitInfo',self);
	if ( Pawn != none )
	{
		KFXSuitAttr.KFXInit(KFXPawn(Pawn).KFXPendingState.nSuitID);
	}
}

simulated function int  KFXGetSuitID()
{
//    if ( class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
//    {
        if ( IsRedTeam() )
        {
            return fxDBPlayerEquipList.Body[1];
        }
        else
		//if ( IsBlueTeam() )
        {
            return fxDBPlayerEquipList.Body[0];

        }
//    }
//    else
//    {
//        return 6102;
//    }
	}

//<<·þ×°°óÊôÐÔ
// ÒÆ¶¯ËÙ¶ÈÊôÐÔ
function KFXUpdateSuitAttr()
{
	local int HPRecoverCount;
	local float HPRecoverTime;
	if ( Pawn != none )
	{
		KFXPawn(Pawn).KFXSpeedScale *= KFXGetSuitSpeed();
		KFXPawn(Pawn).SpeedDownTime *= KFXGetSuitHitSpeedDown();

		HPRecoverCount = KFXGetSuitHPRecoverCount();
		HPRecoverTime = KFXGetSuitHPRecoverTime();
		KFXPawn(Pawn).KFXSetSuitHPRecover(HPRecoverCount, HPRecoverTime);
		KFXSetSuitExpFactor(KFXGetSuitExpRate());
		KFXSetSuitPointFactor(KFXGetSuitPointRate());

		KFXSetSuitBodyArmor();
		KFXSetSuitHeadArmor();
	}
}

// ·þ×°°óÊôÐÔ£¨ÒÆ¶¯ËÙ¶È£©
function float KFXGetSuitSpeed()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("GroundSpeed");

		if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					(KFXSuitAttr.AttrInfo[Index].StarLevel **
					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª1
	return 1.0;
}

// ·þ×°°óÊôÐÔ£¨±äÐÎÊ±¼ä£©
function float KFXGetSuitMagicChangedTime()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("MagicChangedTime");

		if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					(KFXSuitAttr.AttrInfo[Index].StarLevel **
					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª0
	return 0;
}

// ·þ×°°óÊôÐÔ£¨ÉÁ¶ã£©
function float KFXGetSuitHitSpeedDown()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("HitSpeedDown");

        if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					(KFXSuitAttr.AttrInfo[Index].StarLevel **
					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª0
	return 0;
}

// ·þ×°°óÊôÐÔ£¨×Ô¶¯»ØÑª£©
function int KFXGetSuitHPRecoverCount()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("HealthRecover");

        if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					KFXSuitAttr.AttrInfo[Index].StarLevel;
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª0
	return 0;
}

function int KFXGetSuitHPRecoverTime()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("HealthRecover");

        if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param2;
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª0
	return 0;
}

// ·þ×°°óÊôÐÔ£¨·Àµ¯Í·¿ø£©
function float KFXGetSuitHeadArmor()
{
//	local int Index;
	local float ArmorValue;
	ArmorValue = 0;
//	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
//	{
//		Index = KFXSuitAttr.KFXGetAttrIndex("HeadArmor");
//
//		if ( Index != -1 )
//		{
//			ArmorValue = KFXSuitAttr.AttrInfo[Index].Param1 *
//					(KFXSuitAttr.AttrInfo[Index].StarLevel **
//					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
//		}
//	}
	if(Pawn != none)
		ArmorValue += KFXPawn(Pawn).TotalArmorExHead;
	if(ArmorValue == 0)
		ArmorValue = 1.0;
	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª1
	return ArmorValue;
}

// ·þ×°°óÊôÐÔ£¨»¤¼×£©
function float KFXGetSuitBodyArmor()
{
//	local int Index;
	local float ArmorValue;

	ArmorValue = 0;
//	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
//	{
//		Index = KFXSuitAttr.KFXGetAttrIndex("BodyArmor");
//
//		if ( Index != -1 )
//		{
//			ArmorValue = KFXSuitAttr.AttrInfo[Index].Param1 *
//					(KFXSuitAttr.AttrInfo[Index].StarLevel **
//					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
//		}
//	}

	if(Pawn != none)
		ArmorValue += KFXPawn(Pawn).TotalArmorExBody;
	if(ArmorValue == 0)
		ArmorValue = 1.0;
	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª1
	return ArmorValue;
}

function KFXSetSuitBodyArmor()
{
	if ( KFXSuitAttr.KFXGetAttrIndex("BodyArmor") != -1 )
	{
		KFXPawn(Pawn).BodyArmor.ArmorValue = 100;
      	KFXPawn(Pawn).BodyArmor.Level = 1;
      	KFXPawn(Pawn).BodyArmor.ArmorReducePct = 2;
      	KFXPawn(Pawn).KFXArmorPoints = KFXPawn(Pawn).BodyArmor.ArmorValue;
      	KFXPawn(Pawn).BodyArmor.ValidPart = 0x7b;
	}
}

function KFXSetSuitHeadArmor()
{
	if ( KFXSuitAttr.KFXGetAttrIndex("HeadArmor") != -1 )
	{
		KFXPawn(Pawn).HeadArmor.ArmorValue = 100;
        KFXPawn(Pawn).HeadArmor.Level = 1;
        KFXPawn(Pawn).HeadArmor.ArmorReducePct = 2;
        KFXPawn(Pawn).KFXArmorPoints = KFXPawn(Pawn).HeadArmor.ArmorValue;
        KFXPawn(Pawn).HeadArmor.ValidPart = 0x4;
	}
}

function float KFXGetSuitSuperTime()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("SuperTime");

        if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					KFXSuitAttr.AttrInfo[Index].StarLevel;
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª0
	return 0;
}

function float KFXGetSuitSillerRate()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("SillerRate");

		if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					(KFXSuitAttr.AttrInfo[Index].StarLevel **
					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª1
	return 1.0;
}

function float KFXGetSuitExpRate()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("ExpRate");

		if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					(KFXSuitAttr.AttrInfo[Index].StarLevel **
					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª1
	return 1.0;
}

function float KFXGetSuitPointRate()
{
	local int Index;

	if ( KFXSuitAttr != none && KFXSuitAttr.AttrInfo.Length != 0 )
	{
		Index = KFXSuitAttr.KFXGetAttrIndex("PointRate");

		if ( Index != -1 )
		{
			return KFXSuitAttr.AttrInfo[Index].Param1 *
					(KFXSuitAttr.AttrInfo[Index].StarLevel **
					(1 / KFXSuitAttr.AttrInfo[Index].Param2));
		}
	}

	// Èô·þ×°Ã»ÓÐµ±Ç°ÊôÐÔ£¬ÊôÐÔÖµÎª1
	return 1.0;
}

function KFXSetSuitExpFactor(float Factor)
{
	KFXSuitExpFactor = Factor;
}

function KFXSetSuitPointFactor(float Factor)
{
	KFXSuitPointFactor = Factor;
}
//·þ×°°óÊôÐÔ>>


event MouseTransWeapon(int WeaponID)
{
	if (WeaponID != 0)
	{
		if (KFXPawn(Pawn).UIChangeWeapon(WeaponID))
		{
			// Òþ²Ø½çÃæ
			//TransWeapon();
		}
	}
}

event SetWeaponClassSelected(bool bSelected)
{
	if (Pawn != none)
	{
		KFXPawn(Pawn).bSelectWeaponClass = bSelected;
	}
}

event UITransWeapon(int WeaponID)
{
	if (Pawn != none)
	{
		KFXPawn(Pawn).TransWeaponID = WeaponID;
		if (WeaponID != 0)
		{
		    KFXChangeWeapon(WeaponID);

//			if (KFXPawn(Pawn).UIChangeWeapon(WeaponID))
//			{
//				log("UITransWeapon hide page");
//				// Òþ²Ø½çÃæ
//				TransWeapon();
//			}
		}
	}
}
event UITransRestartCoinResult(int Result)
{}
event int GetTutorialSniper();
event SetTransWeaponMenuOpened(bool bOpened)
{
	if (Pawn != none)
	{
		KFXPawn(Pawn).bTransWeaponMenuOpened = bOpened;
	}
	bTransWeaponOpened = bOpened;
}
event bool GetWeaponClassSelected()
{
	if (Pawn != none)
	{
		return KFXPawn(Pawn).bSelectWeaponClass;
	}
}
exec function DChangeScale(int did, float s)
{

	local KFXDecoration de;
	local int bfind;
	local vector vscale;
	if(s <= 0)
		s = 1.0;

	for(de = KFXPawn(Pawn).MyDecorations; de != none; de = de.NextDecoration)
	{
		if(de.did == did)
		{
			vscale.X = s;
			vscale.y = s;
			vscale.z = s;
			de.SetDrawScale3D(vscale);
			break;
		}
	}
	if(bfind == 0)
	{
		log("#### WARNING #### can't find decoration to change! did="$did);
	}
}
exec function DChangePos(int did, float x, float y, float z, int roll, int yaw, int pitch)
{

	local KFXDecoration de;
	local int bfind;
	log("[LABOR]-----------DChangePos:"$did@x@y@z@roll@yaw@pitch);
	for(de = KFXPawn(Pawn).MyDecorations; de != none; de = de.NextDecoration)
	{
		if(de.did == did)
		{
			de.DoChangeCoordinate(x, y, z, roll, yaw, pitch);
			bfind = 1;
			break;
		}
	}
	if(bfind == 0)
	{
		log("#### WARNING #### can't find decoration to change! did="$did);
	}
}

//°´¿Õ¸ñ³öÏÖ»÷É±Í³¼Æ
exec function DoCountKill()
{
	bKFXKeyOfShowKill = !bKFXKeyOfShowKill;
}

event DoSelectWair(int id);
function AddComponentInfo(int WeaponID,int ComponentID,int part)
{
    local fxTransWeaponCompoent  WeapComponent;
    local int loop;

    for(loop =0; loop < TransComponents.Length; loop++)
    {
        if(TransComponents[loop].WeaponID == WeaponID)
        {
            TransComponents[loop].ComponentID[part-1] = ComponentID;
            break;
        }
    }

    if( loop == TransComponents.Length )
    {
        WeapComponent.WeaponID = WeaponID;
        WeapComponent.ComponentID[part-1]= ComponentID;
        TransComponents[loop] = WeapComponent;
    }
}

function ClientSetBehindView(bool b)
{
	Super.ClientSetBehindView(b);
	if(self.Pawn != none && KFXPawn(Pawn).AvatarLegs != none)
	{
		KFXPawn(Pawn).AvatarLegs.bHidden = KFXPawn(Pawn).IsFirstPerson();
	}
}
event SetWeaponAXIS(int Type)
{
	SetDrawWeaponAXIS(Type);
}
exec function ChangeMapRoleSpeedFactor(float sp)
{
	KFXHud(self.myHUD).MapRoleSpeedFactor = sp;
}
function bool pushTaskInfo(int taskid)
{
	//½«ÈÎÎñÇëÇó×ª½»¸øGUI£¬ÈÃGUI¾ö¶¨£ºÊÇ·ñÏÔÊ¾¡¢ÈçºÎÏÔÊ¾
	local int i;
	for(i=0; i<MyShownTaskTip.length; i++)
	{
		if(MyShownTaskTip[i] == taskid)
			return false;
	}
	MyShownTaskTip.Insert(i, 1);
	MyShownTaskTip[i] = taskid;
	return true;
}

//ÉèÖÃÊôÐÔ
event SetAttributeWithInt(int idx, int value)
{
	switch(idx)
	{
		case 1:		//×¼ÐÇÑÕÉ«
			KFXCrosshairColorType = value;
			break;
		case 2:		//×¼ÐÇÀàÐÍ
			KFXCrosshairShapeType = value;
			break;
		case 3:     //×¼ÐÇ´óÐ¡
			KFXCrosshairSizeIndex = value;
			break;
		case 4:		//ÊÇ·ñÏÔÊ¾¶ÓÓÑÃû×Ö
			bShowTeammates = bool(value);
			break;
		case 5:   	//¸ü¸ÄÀ×´ï
			ChangeRadarScale(value);
			break;
		default:
			return;
	}
	saveconfig();
}

exec function SetCrosshairColor(int value)
{
	SetAttributeWithInt(1, value);
}
exec function SetCrosshairType(int value)
{
	SetAttributeWithInt(2, value);
}
exec function SetCrosshairSize(int value)
{
	SetAttributeWithInt(3, value);
}
exec function ShowCrosshairColor()
{
	log("[LABOR]---------cross hair color idx="$self.KFXCrosshairColorType);
}
exec function ShowCrosshairType()
{
	log("[LABOR]---------cross hair type idx="$KFXCrosshairShapeType);
}
exec function ShowCrosshairSize()
{
	log("[LABOR]---------cross hair size idx="$KFXCrosshairSizeIndex);
}
exec function DecreaseRadarScale()
{
	ChangeRadarScale(KFXRadarScale-5);
}
exec function IncreaseRadarScale()
{
	ChangeRadarScale(KFXRadarScale+5);
}
exec function ChangeRadarScale(int value)
{
	if(value > 154)
		value = 154;
	if(value < 46)
        value = 46;

	KFXRadarScale = value;
	KFXHUD(myHUD).SetRadarScale(KFXRadarScale, KFXRadarScale);
}

exec function KFXFreeRecord()
{
    bFreeRecord = true;
    KFXSetFreeView();
}

simulated function PlayerCalcViewTarget(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
	local Pawn PTarget;
	local float deltaZ, deltaTime, smooth;//, smoothValue;

	// zhong:¶ÔÓÚÍ¬Ò»¸ö¹Û²ì¶ÔÏóÐèÒª×öÆ½»¬´¦ÀíµÄËµ
	if(LastCameraViewTarget == ViewActor)
	{
    deltaZ = CameraLocation.Z - LastCameraLocationZ;
    deltaTime = level.TimeSeconds - LastCameraTimeSecond;
    smooth = FMin(0.9, 10.0 * deltaTime/level.TimeDilation);
		if(abs(deltaZ) > 1)
	{
		deltaZ = smooth * deltaZ;
		CameraLocation.Z = LastCameraLocationZ + deltaZ;
	}
	}
	else
	{
		LastCameraViewTarget = ViewActor;
	}

	LastCameraLocationZ = CameraLocation.Z;
	LastCameraTimeSecond = level.TimeSeconds;

    CameraRotation = ViewTarget.Rotation;
    PTarget = Pawn(ViewTarget);
    if ( PTarget != None )
    {
        if ( (Level.NetMode == NM_Client) || (bDemoOwner && (Level.NetMode != NM_Standalone)) )
        {
            PTarget.SetViewRotation(TargetViewRotation);
            CameraRotation = BlendedTargetViewRotation;

            PTarget.EyeHeight = TargetEyeHeight;
        }
        else if ( PTarget.IsPlayerPawn() )
            CameraRotation = PTarget.GetViewRotation();

        if (PTarget.bSpecialCalcView && PTarget.SpectatorSpecialCalcView(self, ViewActor, CameraLocation, CameraRotation))
        {
            CacheCalcView(ViewActor, CameraLocation, CameraRotation);
            return;
        }

        if ( !bBehindView )
        {
        	CameraLocation += PTarget.EyePosition();
        	if (SpectateHook != none && SpectateHook.CurSpectateWeap != none)
        	{
        		CameraLocation += SpectateHook.CurSpectateWeap.EyePosition();
        	}
        }
    }
}

//Êý¾ÝÊÕ¼¯ÔÝÊ±¶¼À´×ÔÓÚ¿Í»§¶Ë£¬Èç¹û·þÎñÆ÷ÄÜ×ö£¬¾ÍÈÃ·þÎñÆ÷À´×ö°É¡£
//ÊÕ¼¯µÐÈËµÄÐÅÏ¢£¬ÒªÇóÖ»±£ÁôÖØÒªµÄ
//¿´²ß»®ÒªÇóÁË£¬ÏÖÔÚÊÇ±£´æÖØÒªÐÅÏ¢£¬Èç¹ûÒª±£Áôµ±Ç°ÐÅÏ¢£¬ÄÇÃ´ÔÙ¸Ä
function DoCollectEnemyMsg(byte AreaID, byte SoundType)
{
//	local int i;
//    local bool find;
//
//	//É¾³ýµôÍ¬Ò»ÇøÓòÄÚ¾ÉµÄÐÅÏ¢
//	for(i=0; i<AreaEnemyMsgs.length; i++)
// 	{
//    	if(AreaEnemyMsgs[i].AreaID == AreaID && AreaEnemyMsgs[i].SoundType > SoundType)
//    	{
//			SoundType = AreaEnemyMsgs[i].SoundType;
//		}
//	}
// 	for(i=AreaEnemyMsgs.length-1; i>=0; i--)
// 	{
//    	if(AreaEnemyMsgs[i].AreaID == AreaID)
//    	{
//    		AreaEnemyMsgs.Remove(i, 1);
//		}
//	}
//	//ÔÚ×îºó²åÈë´ËÐÅÏ¢
//	find = false;
//	//Èç¹û·¢ÏÖÕâ¸öÒÑ¾­ÔÚÌáÊ¾ÐÅÏ¢ÖÐÓÐ£¬ÄÇÃ´¾Í²»ÊÕ¼¯
//	for(i=0; i<GainedAreaEnemyMsgs.length; i++)
//	{
//		if(GainedAreaEnemyMsgs[i].AreaID == AreaID
//			&& GainedAreaEnemyMsgs[i].SoundType == SoundType)
//		{
//			find = true;
//			break;
//		}
//	}
//	if(!find)
//	{
//		i = AreaEnemyMsgs.length;
//		AreaEnemyMsgs.Insert(i, 1);
//		AreaEnemyMsgs[i].SoundType = SoundType;
//		AreaEnemyMsgs[i].AreaID = AreaID;
//	}
}
function SendEnemyMsgs()
{
	local int idx;
	if(AreaEnemyMsgs.length == 0)
		return;
 	//Ò»´ÎÖ»´«µÝÒ»¸ö£¬ÇÒÖ»´«µÝ×î½üÒ»´Î×îÖØÒªÄÇ¸öÏûÏ¢
	idx = AreaEnemyMsgs.length - 1;
	ServerDoCollectEnemyMsg(KFXPlayerReplicationInfo(PlayerReplicationInfo).fxPlayerDBID,
				playerReplicationInfo.Team.TeamIndex,
				AreaEnemyMsgs[idx].SoundType,
				AreaEnemyMsgs[idx].AreaID);

	AreaEnemyMsgs.Remove(idx, 1);
}
function ServerDoCollectEnemyMsg(int PlayerID, byte TeamID, byte SoundType, byte AreaID)
{
	if(Level.Game != none)
		KFXGameInfo(Level.Game).SendEnemyMsgs(PlayerID, TeamID, SoundType, AreaID);
}
function ClientGainEnemyMsgs(int PlayerID, byte SoundType, byte AreaID)
{
	local int i, j;

	for(j=0; j < GameReplicationInfo.PRIArray.length; j++)
	{
		if(KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[j]).fxPlayerDBID == PlayerID)
		{
			i = GainedAreaEnemyMsgs.length;
			GainedAreaEnemyMsgs.Insert(i, 1);
			GainedAreaEnemyMsgs[i].SoundType = SoundType;
			GainedAreaEnemyMsgs[i].AreaID = AreaID;
			GainedAreaEnemyMsgs[i].ReadTime = 0;
			GainedAreaEnemyMsgs[i].PlayerName = GameReplicationInfo.PRIArray[j].PlayerName;
		}
	}
}
function bool GetVoice()
{
    GetMatchVoice();
    if(bMaleVoice)
    {
         GetMaleTossFireVoice();
    }
    else
    {
         GetFemaleTossFireVoice();
    }
}

function bool GetMatchVoice()
{
    local KFXCSVTable CFG_Voice;
    local int         TableID;
    local int         GameModeID;
    local int         i;
    local string      TempVoice;
    TableID        = GetVoiceTale();
    GameModeID     = GetGameModeID();

    log("KFXPlayer------TableID "$TableID);
    log("KFXPlayer------GameModeID "$GameModeID);

    CFG_Voice      = class'KFXTools'.static.GetConfigTable(TableID);
    if ( !CFG_Voice.SetCurrentRow(GameModeID) )
    {
        Log("[KFXPlayer] Can't Resolve The GameModeID: "$GameModeID);
        return false;
    }
    //ÓÎÏ·¿ªÊ¼ÓïÒô
    MatchStartVoiceBNum = CFG_Voice.GetInt("B_StartNum");
    for(i=1; i<=MatchStartVoiceBNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("B_Start_"$i);
        if(TempVoice != "none")
        {
            MatchStartVoiceB[i-1] = TempVoice;
        }
    }
    MatchStartVoiceRNum = CFG_Voice.GetInt("R_StartNum");
    for(i=1; i<=MatchStartVoiceRNum; i++ )
    {
        TempVoice =  CFG_Voice.GetString("R_Start_"$i);
        if(TempVoice != "none")
        {
            MatchStartVoiceR[i-1] = TempVoice;
        }
    }

    //Ê¤ÀûÊ§°Ü
    VictoryVoiceNum = CFG_Voice.GetInt("VictoryNum");
    for(i=1; i<=VictoryVoiceNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("Victory_"$i);
        if(TempVoice != "none")
        {
            VictoryVoice[i-1] = TempVoice;
        }
    }

    DefeatedVoiceNum = CFG_Voice.GetInt("DefeatedNum");
    for(i=1; i<=DefeatedVoiceNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("Defeated_"$i);
        if( TempVoice != "none")
        {
            DefeatedVoice[i-1] = TempVoice;
        }
    }
    //ÁìÏÈ·½Âäºó·½
    NearVictoryVoiceNum = CFG_Voice.GetInt("NearVictoryNum");
    for(i=1; i<=NearVictoryVoiceNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("NearVictory_"$i);
        if( TempVoice != "none")
        {
            NearVictoryVoice[i-1] = TempVoice;
        }
    }

    LaggerVoiceNum = CFG_Voice.GetInt("LaggerNum");
    for(i=1; i<=LaggerVoiceNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("Lagger_"$i);
        if( TempVoice != "none")
        {
            LaggerVoice[i-1] =  TempVoice;
        }
    }
}
exec function SetChinaVoice()
{
    bChinaVoice = bIsChinaVoice;
    log("KFXPlayer------bChinaVoice "$bChinaVoice);
}

exec function TUTPressE()
{
    local Mover door;
    if(Pawn != none)
    {
        foreach Pawn.CollidingActors(Class'Mover',door,300)
        {
            if(Left(door.Tag,15) == "VIPGhost_Mover_")
            {
                ServerOpenMover(door);
                break;
            }
        }
    }
}
///ÆäÊµÊÇ¹Ø±ÕMoverµÄ¹¦ÄÜ
exec function DoDance()
{
    local Mover door;
    if(Pawn != none)
    {
        foreach Pawn.CollidingActors(Class'Mover',door,300)
        {
            if(Left(door.Tag,15) == "VIPGhost_Mover_")
            {
                ServerCloseMover(door);
                break;
            }
        }
    }
}
exec function QuickTossGrenade()
{
    local int WeapType;
    if(bFastToss)
    {
        log("You Have Quick Toss Grenade");
        return;
    }
    if(!CheckHaveTossWeapon())
    {
        log("I Start Toss, I Don't Have Toss Weapon; ");
        Pawn.SwitchToLastWeapon();
        return;
    }
    if(Level.TimeSeconds - TossBeginTime < 0.3)
    {
        log("Toss ,Please Give me More Time");
        return;
    }
    bQuickToss = true;
    bFastToss = true;

    WeapType = KFXWeapBase(Pawn.Weapon).KFXGetWeaponID()>>16;
    log("KFXPlayer----111----WeapType "$WeapType);
    SwitchWeapon(4);
    WeapType = KFXWeapBase(Pawn.Weapon).KFXGetWeaponID()>>16;
    log("KFXPlayer----222----WeapType "$WeapType);
    if(WeapType >= 51 && WeapType <= 60)
    {
	ServerQuickFire(false,true);
    }
    log("QuickTossGrenade-222-----bQuickToss "$bQuickToss);
}

function ServerQuickFire(bool bInstallC4,bool bToss)
{
    bQuickToss = bToss;
    bQuickInstallC4 = bInstallC4;
    log("KFXPlayer------"
    $"bQuickInstallC4 :"$bQuickInstallC4
    $"bQuickToss :"$bQuickToss);

}
function ServerStopQuickFire()
{
    if(Level.NetMode == NM_DedicatedServer)
    {
        ClientSwitchToBestWeapon();
    }
}
exec function MiddleMouseUp()
{
    local int WeapType;
    if(!CheckHaveTossWeapon())
    {
        log("I Want Toss, But I Don't Have Toss Weapon; ");
        bFastToss = false;
        return;
    }
    if(!bFastToss)
    {
        log("I Toss,Condition Is I Pressed");
        return;
    }

    WeapType = KFXWeapBase(Pawn.Weapon).KFXGetWeaponID()>>16;

    if(WeapType >= 51 && WeapType <= 60)
    {
    	KFXFireBase(Pawn.Weapon.GetFireMode(0)).MaxHoldTime = 0.01;
    	Pawn.Weapon.ClientStopFire(0);
    	bFastToss = false;
        ServerStopQuickFire();
        log("QuickTossGrenade-333-----Pawn.Weapon "$Pawn.Weapon);
        log("QuickTossGrenade-333-----bQuickToss "$bQuickToss);
        log("QuickTossGrenade-333-----KFXFireBase(Pawn.Weapon.FireMode[0]).MaxHoldTime "$KFXFireBase(Pawn.Weapon.GetFireMode(0)).MaxHoldTime);

    }
    bFastToss = false;
    TossBeginTime = Level.TimeSeconds;
    if(bQuickToss)
    {
    bQuickToss = false;
    }
    if(bQuickInstallC4)
    {
        bQuickInstallC4 = false;
    }
}
function  bool CheckHaveTossWeapon()
{
    local Inventory Inv;
    local int WeapType;
    for(Inv=Pawn.Inventory; Inv!=none; Inv=Inv.Inventory)
    {
        if(KFXWeapBase(Inv) != none)
        {
            WeapType = KFXWeapBase(Inv).KFXGetWeaponID() >> 16;
            log("KFXPlayer------WeapType "$WeapType);
            if(WeapType >= 51 && WeapType <= 60)
            {
                return true;
            }
        }
    }
    return false;
}
function  bool CheckHaveC4()
{
    local Inventory Inv;
    local int WeapID;
    for(Inv=Pawn.Inventory; Inv!=none; Inv=Inv.Inventory)
    {
        if(KFXWeapBase(Inv) != none)
        {
            WeapID = KFXWeapBase(Inv).KFXGetWeaponID() ;
            log("KFXPlayer------WeapID "$WeapID);
            if(WeapID == 1)
            {
                return true;
            }
        }
    }
    return false;
}
function bool GetFemaleTossFireVoice()
{
    local KFXCSVTable CFG_Voice;
    local int         TableID;
    local int         GameModeID;
    local int         i;
    local string      TempVoice;
    if(bChinaVoice)
    {
         TableID   = 713;
    }
    else
    {
        TableID   = 715;
    }
    GameModeID     = 1;

    log("KFXPlayer------TableID "$TableID);

    CFG_Voice      = class'KFXTools'.static.GetConfigTable(TableID);
    if ( !CFG_Voice.SetCurrentRow(GameModeID) )
    {
        Log("[KFXPlayer] Can't Resolve The GameModeID: "$GameModeID);
        return false;
    }
    //¸ß±¬À×
    FemaleGrenadeNum = CFG_Voice.GetInt("GrenadeNum");
    for(i=1; i<=FemaleGrenadeNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("GrenadeVoice_"$i);
        if( TempVoice != "none")
        {
           FemaleGrenadeVoice[i-1] =  TempVoice;
        }
    }
    //ÉÁ¹âÀ×
    FemaleFlashNum = CFG_Voice.GetInt("FlashNum");
    for(i=1; i<=FemaleFlashNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("FlashVoice_"$i);
        if( TempVoice != "none")
        {
           FemaleFlashVoice[i-1] =  TempVoice;
        }
    }
    //ÑÌÎíµ¯
    FemaleSmokeNum = CFG_Voice.GetInt("SmokeNum");
    for(i=1; i<=FemaleSmokeNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("SmokeVoice_"$i);
        if( TempVoice != "none")
        {
           FemaleSmokeVoice[i-1] =  TempVoice;
        }
    }
}
function bool GetMaleTossFireVoice()
{
    local KFXCSVTable CFG_Voice;
    local int         TableID;
    local int         GameModeID;
    local int         i;
    local string      TempVoice;
    if(bChinaVoice)
    {
         TableID   = 712;
    }
    else
    {
        TableID   = 714;
    }
    GameModeID     = 1;

    log("KFXPlayer------TableID "$TableID);

    CFG_Voice      = class'KFXTools'.static.GetConfigTable(TableID);
    if ( !CFG_Voice.SetCurrentRow(GameModeID) )
    {
        Log("[KFXPlayer] Can't Resolve The GameModeID: "$GameModeID);
        return false;
    }
    //¸ß±¬À×
    MaleGrenadeNum = CFG_Voice.GetInt("GrenadeNum");
    for(i=1; i<=MaleGrenadeNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("GrenadeVoice_"$i);
        if( TempVoice != "none")
        {
           MaleGrenadeVoice[i-1] =  TempVoice;
           log("MaleGrenadeVoice[i-1] "$MaleGrenadeVoice[i-1]);
        }
    }
    //ÉÁ¹âÀ×
    MaleFlashNum = CFG_Voice.GetInt("FlashNum");
    for(i=1; i<=MaleFlashNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("FlashVoice_"$i);
        if( TempVoice != "none")
        {
           MaleFlashVoice[i-1] =  TempVoice;
           log("MaleFlashVoice[i-1] "$MaleFlashVoice[i-1]);
        }
    }
    //ÑÌÎíµ¯
    MaleSmokeNum = CFG_Voice.GetInt("SmokeNum");
    for(i=1; i<=MaleSmokeNum; i++ )
    {
        TempVoice = CFG_Voice.GetString("SmokeVoice_"$i);
        if( TempVoice != "none")
        {
           MaleSmokeVoice[i-1] =  TempVoice;
           log("MaleSmokeVoice[i-1] "$MaleSmokeVoice[i-1]);
        }
    }
}
function int GetGameModeID()
{
    return GetGRI().GameMode;
}
function int GetVoiceTale()
{
    SetChinaVoice();                  //ÖÐÓ¢ÎÄÓïÒô¿ÉÅå
    bMaleVoice =  !Pawn.bIsFemale || KFXPawnBase(Pawn).KFXPendingState.nRoleID % 2 == 1;              //1Îªmale
    log("KFXPlayer -----bMaleVoice- "$bMaleVoice);
    if(bChinaVoice)
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
function int GetWinTeamIdx()
{
    if( GameReplicationInfo.Winner == level )
    {
        return 0;//Æ½
    }
    else if( (KFXTeamInfo(GameReplicationInfo.Winner).TeamIndex == 0 && self.GetGRI().fxChangeTeamCount%2 == 0)
        || (KFXTeamInfo(GameReplicationInfo.Winner).TeamIndex == 1 && self.GetGRI().fxChangeTeamCount%2 == 1) )
    {
        return 1;//À¶¶Ó
    }
    else if( (KFXTeamInfo(GameReplicationInfo.Winner).TeamIndex == 1 && self.GetGRI().fxChangeTeamCount%2 == 0)
        || (KFXTeamInfo(GameReplicationInfo.Winner).TeamIndex == 0 && self.GetGRI().fxChangeTeamCount%2 == 1) )
    {
        return 2;//ºì¶Ó
    }
    else
    {
        log ("[GetWinTeamIdx] Bad team id of winner");
        return 255;
    }
}
function CallServerMove
(
    float TimeStamp,
    vector InAccel,
    vector ClientLoc,
    bool NewbRun,
    bool NewbDuck,
    bool NewbPendingJumpStatus,
    bool NewbJumpStatus,
    bool NewbDoubleJump,
    eDoubleClickDir DoubleClickMove,
    byte ClientRoll,
    int View,
    optional byte OldTimeDelta,
    optional int OldAccel
)
{
	curr_accel = InAccel;
	super.CallServerMove(TimeStamp, InAccel, ClientLoc, NewbRun, NewbDuck, NewbPendingJumpStatus, NewbJumpStatus,
			NewbDoubleJump, DoubleClickMove, ClientRoll, View, OldTimeDelta, OldAccel);
}
function int GetLastACEWeapon()
{
    local int i;
    local int ACEWeaponID;
    local float MaxUseTime;
    for(i=0; i<WeapUsedInfo.Length; i++)
    {
        if(WeapUsedInfo[i].BeginUseTime > 0.01)
        {
            if(Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime > 0)
            {
                WeapUsedInfo[i].UsedTime += Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime;
            }
        }
    }
    for(i=0; i<WeapUsedInfo.Length; i++)
    {
        if(WeapUsedInfo[i].UsedTime >= MaxUseTime)
        {
            ACEWeaponID = WeapUsedInfo[i].WeaponID;
            MaxUseTime = WeapUsedInfo[i].UsedTime;
        }
    }
    log("KFXPlayer------ACEWeaponID "$ACEWeaponID);
    KFXPlayerReplicationInfo(PlayerReplicationInfo).ACEWeapon  = ACEWeaponID;
    return ACEWeaponID;
}
//ÎäÆ÷±»»»µÄÊ±ºòÍ³¼ÆÏÂÊ¹ÓÃµÄÊ±¼ä
function StatsWeaponUsedInfo(int WeaponID)
{
    local int i;
    for(i=0; i<WeapUsedInfo.Length; i++)
    {
        if(WeapUsedInfo[i].WeaponID == WeaponID )
        {
            WeapUsedInfo[i].UsedTime += Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime;
            WeapUsedInfo[i].BeginUseTime = 0;
            break;
        }
    }

}
function AddWeaponUsedInfo(int WeaponID)
{
    local bool bFound;
    local int i;
    local int Temp;
    bFound = false;
    for(i=0; i<WeapUsedInfo.Length; i++)
    {
        if(WeapUsedInfo[i].WeaponID == WeaponID)
        {
            bFound = true;
            Temp =i ;
            //break;
        }
        if(WeapUsedInfo[i].BeginUseTime > 0)
        {
            WeapUsedInfo[i].UsedTime += Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime;
            WeapUsedInfo[i].BeginUseTime = 0;
        }

    }
    log("KFXPlayer-----bFound "$int(bFound));
    log("KFXPlayer-----Temp "$Temp);
    if(bFound)
    {
        if(WeapUsedInfo[Temp].BeginUseTime < 0.01)
        {
            WeapUsedInfo[Temp].BeginUseTime = Level.TimeSeconds;
        }
        else
        {
            WeapUsedInfo[Temp].UsedTime += Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime;
            WeapUsedInfo[Temp].BeginUseTime = Level.TimeSeconds;
        }
    }
    else
    {
        WeapUsedInfo.Insert(WeapUsedInfo.Length,1);
        WeapUsedInfo[WeapUsedInfo.Length-1].WeaponID = WeaponID;
        WeapUsedInfo[WeapUsedInfo.Length-1].BeginUseTime = Level.TimeSeconds;
    }
}

//Ã¿´ÎÉ±ÈËºóÍ³¼Æ¸÷×ÔÊ¹ÓÃÊ±¼ä×î³¤µÄÎäÆ÷£¬±ãÓÚ×îÖÕµÄACEÎäÆ÷Í³¼Æ
function StatACEWeaponAfterKill()
{
    local int i;
    for(i=0; i<WeapUsedInfo.Length; i++)
    {
        if(WeapUsedInfo[i].BeginUseTime > 0.01)
        {
            WeapUsedInfo[i].UsedTime += Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime;
        }
        WeapUsedInfo[i].BeginUseTime = Level.TimeSeconds;
    }

}

function StopOtherWeaponUsedInfo()
{
    local int i;
    for(i=0; i<WeapUsedInfo.Length; i++)
    {
        if(WeapUsedInfo[i].BeginUseTime > 0.01)
        {
            WeapUsedInfo[i].UsedTime += Level.TimeSeconds - WeapUsedInfo[i].BeginUseTime;
        }
        WeapUsedInfo[i].BeginUseTime = 0;
    }
}

simulated function bool CanSpeech()
{
    return true;
}
simulated function ClientGetDropItem(int ItemID)
{
    KFXHUD(myHUD).GetDropItemID(ItemID);
}
simulated function ClientKnowPickUpSpawn()
{
}
event ClientSetViewTarget( Actor a )
{
	local KFXPlayerReplicationInfo pri;
	if(a.IsA('pawn'))
	{
		pri = KFXPlayerReplicationInfo(KFXPawn(a).PlayerReplicationInfo);
if(KFXHUD(myHUD)._HUD_NEW_ == 2)
{
   		player.GUIController.SetHUDData_ShowViewtargetInfo(IsInState('Spectating'),
				pri.fxPlayerDBID,
			   	pri.PlayerName);
}
	}
	super.ClientSetViewTarget(a);
}
function SetVisible_ShowAndLost(bool visible)
{
	local int ret;
	//¼ÆËãÊ¤ÀûÊ§°ÜÇé¿ö£¬È»ºóÏÔÊ¾
	bShowWinAndLoss = visible;
	if(visible)
		ret = KFXTeamScoreBoard(myHUD.ScoreBoard).CalcFinalWinNLose();
	else
		ret = -1;
if(KFXHUD(myHUD)._HUD_NEW_ == 2)
{
	Player.GUIController.SetHUDData_MatchVictoryState(visible, ret);
}
}
//ÉèÖÃÉú»¯Ä£Ê½µÄÄÚÈÝ
function SetMutateRole(array<int>  typeids)
{
	local int i;

	fxMutateRole = 0;
	for(i=0; i<typeids.length; i++)
	{
		if(typeids[i]>>16 != 250)
			continue;
		switch(typeids[i]&0xffff)
		{
			case 1619:
				fxMutateRole = fxMutateRole | 0x01;
				break;
			case 1617:
				fxMutateRole = fxMutateRole | 0x02;
				break;
			case 1618:
				fxMutateRole = fxMutateRole | 0x04;
				break;
			case 1620:
				fxMutateRole = fxMutateRole | 0x08;
				break;
			case 1621:
				fxMutateRole = fxMutateRole | 0x10;
				break;
		}
	}
	log("#### INFO #### mutate role:"$fxMutateRole@"id="$fxDBPlayerInfo.PlayerID);
}
 exec function SetWeaponPlayerViewPivot(int pitch,int yaw, int roll)
{
    KFXWeapBase(Pawn.Weapon).KFXInitPlayerViewPivot.Pitch = pitch;
    KFXWeapBase(Pawn.Weapon).KFXInitPlayerViewPivot.yaw = yaw;
    KFXWeapBase(Pawn.Weapon).KFXInitPlayerViewPivot.roll = roll;
    log("KFXPlayer------Pawn.Weapon"$Pawn.Weapon);
    log("KFXPlayer------Pawn.Weapon.PlayerViewPivot"$KFXWeapBase(Pawn.Weapon).KFXInitPlayerViewPivot);

}
simulated function PVEBaseLevelUp(int newLevel,bool bUp)
{

	log("[LABOR]------------PVEBaseLevelUp:"$newLevel@bUp);

	if(newLevel == 0)
		return;

 	//¸üÐÂGRIÖÐµÄBaseLevelÏà¹ØÊý¾Ý
 	GetGRI().SetBaseLevelData(newLevel);

 	ClientPVEBaseLevelUp(NewLevel, bUp);
}
simulated function ClientPVEBaseLevelUp(int newLevel,bool bUp)
{
  	Player.GUIController.SetHUDData_PveBaseLevel(GetGRI(),bUp);
}

function CheckPVELevelUp(float Dmg,float Dmged)
{
	local int levelup;
	local KFXPlayerReplicationInfo KFXPRI;
	local KFXGameReplicationInfo KFXGRI;
	KFXPRI= GetPRI();
	KFXGRI= GetGRI();

	if(Dmg != 0.0)
	{
		KFXPRI.PVEexp += Dmg*KFXGRI.DmgExpRate;
	}

	if(Dmged != 0.0)
	{
		KFXPRI.PVEexp += Dmged*KFXGRI.DmgedExpRate;
	}

	//Ä¿Ç°¼ÙÉè50¾­ÑéÉýÒ»¼¶£¬µÈ´ý¾­ÑéÉý¼¶¹«Ê½µÄµ½À´
	while( KFXPRI.PVEexp > KFXGRI.GetPveLevelUpExp(KFXPRI.PVELevel))
	{
        KFXPRI.PVEexp -= KFXGRI.GetPveLevelUpExp(KFXPRI.PVELevel);
        KFXPRI.PVELevel++;
        levelup++;
	}
	if(levelup>0 )
	{
  		//Éý¼¶ºóÐèÒª¶ÔµÈ¼¶Ó°ÏìµÄÊôÐÔ½øÐÐ¸üÐÂ
		KFXPRI.LevelHP += levelup*KFXGRI.LevelupHP;
		pawn.HealthMax = KFXPRI.LevelHP;
		pawn.Health += levelup*KFXGRI.LevelupHP;
		KFXPRI.LevelDmgFactor += levelup*KFXGRI.LevelupDmgFactor;
	}
	log("[LABOR]--------Check PVE level up:"$levelup
				@KFXGRI.LevelupHP
				@KFXGRI.DmgedExpRate
				@KFXGRI.DmgExpRate
				@Dmged
				@Dmg);

}

function InitPVELevel(int playerLevel,int Exp)
{
    GetPRI().PVELevel = playerLevel;
    GetPRI().PVEexp = Exp;
}

function DoGetScore(int Score)
{

}
function AddPlayerScoreInfo(array<int> ItemID)
{
}

defaultproperties
{
     KFXSoundRadius=(Max=1000.000000)
     BGmusicHandle=-1
     CurBGMusicIndex=-1
     bAllowChangeWeapGameStart=是
     TransWeaponPageName="KFXTransWeaponPage"
     PartitionTeamEnable=是
     HelpInGameClass="KFXGUI.KFXGUIHelpInGame"
     KFXIsOnAutoAimMode=是
     KFXAutoAimAngle=0.700000
     KFXAutoAimValidTimeMax=10.000000
     KFXAutoAimLockTimeDelta=0.050000
     bKFXShakeView=是
     CrossHairDrawType=1
     KFXRadarScale=100
     bShowBulletPic=是
     bShowWeaponFireTrace=是
     bShowKilledPos=是
     bIsChinaVoice=是
     bIsChatWithTeam=是
     bIsChatWithAll=是
     bIsChatWithPersonal=是
     bIsChatWithFaction=是
     bIsCanHearSpeaker=是
     bIsSystemMessage=是
     LastKickWarningTime=-1000.000000
     curcam=-1
     MinAdrenalineCost=100.000000
     bWaitingForPRI=是
     bWaitingForVRI=是
     KFXFirstLogin=是
     PitchUpLimit=18000
     PitchDownLimit=49153
     bEnableSpecialView=是
     CheckPawnWithGeometry=是
     bAllowHeadKilled=是
     bAllowKickIdle=是
     TaskManagerClass=Class'KFXGame.KFXTaskManager'
     TransWeaponTimeLimit=1000.000000
     TransWeaponRadius=500.000000
     bRecordOver=是
     CanBuyWeaponType=1111
     bJustLogin=是
     bShowViewHelp=是
     SpecKillerSecs=4.000000
     AllowMaxDistForG=700
     AllowMaxDistForK=2000
     time_be_hitted=-10.000000
     bShakeViewAfterDead=是
     fxDeadPitchChange=6000.000000
     fxDeadRollChange=10500.000000
     PrecacheTableNames(0)="basicprecacheres.csv"
     bIsCheckDLlLatest=是
     bBehindView=是
     bSmallWeapons=否
     bAimingHelp=是
     MidGameMenuClass="KFXGUI.KFXGameMenu"
     PlayerReplicationInfoClass=Class'KFXGame.KFXPlayerReplicationInfo'
     PawnClass=Class'KFXGame.KFXPawn'
     bNetNotify=是
}
