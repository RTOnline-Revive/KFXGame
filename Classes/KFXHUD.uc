//-----------------------------------------------------------
//  Class:      KFXGame.KFXHUD
//  Creator:    zhangjinpin@kingsoft ÕÅ½ðÆ·
//  Data:       2007-03-29
//  Desc:       FOXÏîÄ¿HUD
//  Update:     ´úÂëÖØ¹¹ 2007-07-02
//  Special:    ·Å»Øµ½KFXGame°ü£¬·½±ãÉèÖÃÒÀÀµ¹ØÏµ
//-----------------------------------------------------------

//PawnOwner²»Ò»¶¨ÊÇµ±Ç°Íæ¼ÒµÄPawn£¬Èç¹û´ËÊ±ÊÇ¹Û²ìÕß£¬ÄÇÃ´¾ÍÊÇ¹Û²ì¶ÔÏóµÄPawn (LinkActorsº¯Êý)£¬Õâ¸öµÃ½÷É÷


// ÈÃÎÒÃÇµÄHUDÔËÐÐÃ¿Ò»Ì¨µçÄÔÉÏ
class KFXHUD extends HUD
    dependson(KFXPlayer)
	config(KFXPlayer);


struct KillEncourageSound
{
	var bool active;
	var int Scope;		//×Ô¼º0¡¢¶ÓÓÑ1¡¢È«Ìå2
	var string strSound[3];	//3ÖÖ½ÇÉ«µÄÒôÐ§×ÊÔ´
	var int vol[3];         //3ÖÖ½ÇÉ«µÄÒôÁ¿
};

var config int 	_HUD_NEW_;

var localized string confWeaponSwitch2;     // »»Ç¹×ÊÔ´ÅäÖÃ

var string KFXMatSrc;

var bool changedangerinfo;
var bool dangerneedchange;
var float dangerchangetime;
var float dangertime;

var localized string KFXBaseFontAlias;
var localized string KFXChatFontAlias;
var localized string KFXSpecFontAlias;

// ¹«ÁÄ¶ÓÁÄÎÄ×Ö
var localized string lTeamChat;
var localized string lPublicChat;
var localized string lSystem;
var localized string SMT_ItemBroadcast;
var localized string lGroupChat;
var localized string SmallBugleChat;
var localized string BigBugleChat;
var localized string SMT_PradoBig, SMT_PradoSmall;
var localized string lPersonnalChat;
var localized string lYouPersonal;
var localized string lSay;
var localized string lUseItem;
var localized string SMT_Semicolon;

var localized string SMT_NotExplode, SMT_RemoveBombFailed;

//ÏûÃðÍ³¼Æ      ChenJianye
var localized string SMT_RivalName,         // ¶ÔÊÖêÇ³Æ
                     SMT_KillInfoTitle,     // ÏûÃðÍ³¼Æ
                     SMT_KillInfo;          // ÏûÃð/±»ÏûÃð
// Added by Linsen for fox version 3
// 2008-3-5
var localized string lClewMsgHead;
var localized string lClewReborn;

var localized string	SMT_TaskComplete, SMT_Sivler;
var localized float		SMT_TipXPos, SMT_TipYPos;
var bool bDisPlayMessages;    //ÁÄÌìÐÅÏ¢ÏÔÊ¾¿ª¹Ø


var Canvas   TempCanvas;      //ÓÃÓÚÁÄÌìÐÅÏ¢¼ÆËã³¤¶È

// ÏÔÊ¾¶ÓÓÑÃû×ÖÈýÖÖ¾àÀë
var config int fxShowNameDist1;
var config int fxShowNameDist2;
var config int fxShowNameDist3;

// ÃÀÊõ×ÖÌå
var Font fxFontArray[10];
var string fxFontNames[10];


// Trace View Actor (Per Frame)
var Actor KFXLastTraceViewActor;
var Actor KFXCurrTracePawn;	//µ±Ç°Êó±êÖ¸ÏòµÄÄÇ¸öÈË

// Ð¡µØÍ¼Ðý×ª·½Ê½£º0--ÈË×ª£¬1--Í¼×ª
enum ESmallMapMode
{
    SMALLMAPMODE_ROTATE_PLAYER,
    SMALLMAPMODE_ROTATE_MAP
};

// ÓÎÏ·ÏûÏ¢£¬±£´æ20Ìõ
struct native fxLocalizedMessage
{
	var class<LocalMessage> Message;
	var string StringMessage;
	var int Switch;
	var PlayerReplicationInfo RelatedPRI, RelatedPRI2;
	var Object OptionalObject;
};
var transient fxLocalizedMessage fxLocalMessages[20];

// ¼´Ê±Õ½¶·ÐÅÏ¢¡£±£´æ5Ìõ
struct fxInstantCombat
{
    var PlayerReplicationInfo  Killed;
    var PlayerReplicationInfo  Killer;
    var float Time;
    var int nTag;   // 0-ÆÕÍ¨ 1-×ÔÉ± 2-×Ô¶¯Ãé×¼ 3-±¬Í· 4-±äÖí 5-±ä¹ê 6-É±Öí/É±¹ê/É±Ã¨ 13-´©Ç½
    var int nKills; // É±ÈËÊý
    var int nSpecialRole; //Öí 1£¬ ¹ê2
    var string sWeaponSrc;
    var array<string> sWeapCompntSrc;
    var bool bPlaySound;          //ÊÇ·ñ²¥·Å¹ý±»É±ÒôÐ§
    var int  KillerInfo;          //Ð×ÊÖÐÅÏ¢ÓÃÓÚ±£´æÀúÊ·Êý¾Ý
    var int  KilledInfo;          //ÊÜº¦ÈËÐÅÏ¢ÓÃÓÚ±£´æÀúÊ·Êý¾Ý
    var byte  MultiKillTime;		//Á¬É±´ÎÊý
    var byte  SpecialKill;			//µÚÒ»µÎÑª£¬×îÖÕÉ±
};
var fxInstantCombat fxCombatMessages[5];

//Ê¹ÓÃµÀ¾ßÐÅÏ¢
struct fxUseItemMessage
{
    var PlayerReplicationInfo User;
    var PlayerReplicationInfo Used;
    var float Time;
    var int   ItemType;
};
var fxUseItemMessage sUseItemMessage[5];

//<< wangkai, ¼¤ÀøÏµÍ³
var string EncourageIconsBig[21];   //¼¤Àø´óÍ¼±êÂ·¾¶
var string EncourageIconsSmall[21]; //¼¤ÀøÐ¡Í¼±êÂ·¾¶


var bool bFemale;                   //ÊÇ·ñÊÇÅ®µÄ
var bool bSexUpdate;

enum EEncourageType
{
    ET_Normal,      //ÆÕÍ¨
    ET_FirstBlood,  //µÚÒ»µÎÑª
    ET_Combo2,      //2Á¬É±
    ET_Combo3,      //3Á¬É±
    ET_Combo4,      //4Á¬É±
    ET_Combo5,      //5Á¬É±
    ET_ComboN,      //>6Á¬É±
    ET_Knife,       //µ¶É±
    ET_HeadShot,    //±¬Í·
    ET_Bomb,        //±¬Õ¨
    ET_Special,     //ÌØÊâ»÷É±
    ET_Tank,        //É±Ì¹¿Ë
    ET_Corpse,      //É±½©Ê¬
    ET_CorpseKiller, //½©Ê¬É±ÈË
    ET_TeamKill,     //ÍÅ¶Ó»÷É±
    ET_Wall,		//´©Ç½»÷É±
    ET_WallHeadShot,	//´©Ç½±¬Í·»÷É±
    ET_KillMotherCorpse,      //É±Ä¸Ìå½©Ê¬
    ET_KillChildCorpse,      //É±×ÓÌå½©Ê¬
    ET_KillFatCorpse,      //É±ÅÖ×Ó½©Ê¬
    ET_KillGirlCorpse,      //É±Ð¡Å®º¢½©Ê¬
};

struct fxEncourageMessage
{
    var EEncourageType Type;
    var byte	bMultiKill;
    var float Time;
    var byte 	bInventory;	//ÊÇ·ñÊÇ
    var bool    bIsBloodKill;
};
var fxEncourageMessage fxEncourageMsgs[10];
var fxInstantCombat fxWhoKilledMeMsgs[6];

var bool bShowWhoKilledMe;//ÏÔÊ¾Ë­É±ÁË×Ô¼º
//>>

struct MaterialInfo
{
    var string MaterialName;
    var int  MatPosx;
    var int  U;
    var int  v;
    var int  UL;
    var int  VL;
};

struct  ChatMessageLine
{
	var string        text;
	var color         TextColor;
	var float         MessageLife;
    var float         sizey;
    var Array<MaterialInfo> Material;
    var int           index;
};
var Array<ChatMessageLine> ChatTextMessages;

struct ChangeWeaponInfo
{
	var int 	nWeaponID;	//¸ü»»µÄÇ¹µÄid
	var float   nUpdateTime;
};
var ChangeWeaponInfo	ChangeWeaponMessage;	//»»Ç¹µÄÏûÏ¢

// Clew message queue.
// Added by Linsen for fox version 3
// 2008-3-3
struct _fxClewMessage
{
    var string sMsgTitle;
    var string sMsgContent;
    var array<string> aMsgContent;
    var float fShowClewmsgTime;
    var float fFirstlyShowTime;
    var int iFirstlyShow;  // 0 - haven't shown
    var int nPriority;     //ÏûÏ¢ÓÅÏÈ¼¶
};
struct _fxClewmsgQueue
{
    var _fxClewMessage fxClewMessage[5]; // Store 5 at most.
    var int front;      // Queue head
    var int tear;       // Queue end
};
var _fxClewmsgQueue  fxClewmsgQueue;




// ÓÎÏ·ÏûÏ¢¡£±£´æ3Ìõ
struct fxGameMessage
{
	var float Time;
    var string sMsgContent;
	var PlayerReplicationInfo PlayerRP_1;
    var PlayerReplicationInfo PlayerRP_2;
};
var fxGameMessage fxGameMessages[3];

struct KFXSmallMap
{
    var Shader          MapShader;
    var TexRotator      MapRotator;
    var TexScaler		MapOffsetLeft;
    var TexScaler       MapScaler;
    var TexScaler		MapOffset;
    var Material        MapMaterial;
};
struct KFXRadar_Teammate
{
	var float xpos;
	var float ypos;
	var bool longdist;
	var Pawn p;
	var KFXPlayerReplicationInfo pri;
};
var KFXRadar_Teammate radar_teams[16];	//16¸ö¶ÓÓÑµÄÐÅÏ¢
var float MapRoleSpeedFactor;
var float RadarMapScale;
var Material fxRadarFrame;
var KFXSmallMap fxSmallMap;
var KFXSmallMap fxMyRotPic;  //×Ô¼ºµÄ·½Î»Í¼
var array<KFXSmallMap> fxTeamRotPic;	//¶ÓÓÑµÄ·½Î»Í¼
var KFXSmallMap	TeammateSpeech;
var bool bInitSmallMap;

// ÊÇ·ñ»­Ö÷HUD
var bool bDrawKFXHUD;

// ÊÇ·ñ»­ScoreBoard
var bool bDrawKFXScoreBoard;

//-----------------------------------------------------------
//Õ½ÊõµØÍ¼È«¾Ö±äÁ¿
//-----------------------------------------------------------
struct KFXWarMap                      //Õ½ÊõµØÍ¼½á¹¹Ìå
{
	var TexRotator	RotMaterial;      //Ê¹Õ½ÊõµØÍ¼ÄÜ¹»Ðý×ª
    var Material Material;            //Õ½ÊõµØÍ¼²ÄÖÊ
    var Material Material2F;          //Õ½ÊõµØÍ¼2Â¥²ÄÖÊ£¬ÔÝÊ±Õâ¸ö²»»æÖÆ
    var int      Map2FHigh;           //2Â¥µÄ¸ß¶È
    var int      OffsetX;             //Õ½ÊõµØÍ¼XÏòÆ«ÒÆ
    var int      OffsetY;             //Õ½ÊõµØÍ¼YÏòÆ«ÒÆ
    var float    Rate;                //Õ½ÊõµØÍ¼ÒÆ¶¯±ÈÀý
    var int      Rota;                //Õ½ÊõµØÍ¼IconÐý×ªÆ«ÒÆ
    var int      ChangeXY;           //ÊÇ·ñ¸Ä±äxy×ø±êÏµ
    var int		 TopTeam;			  //Î»ÓÚÉÏ·½µÄ¶ÓÎé±êÊ¶£¬ÊÇºì¶Ó»¹ÊÇÀ¶¶Ó£¿
    var float 	 BlueTeamPos[2];	//À¶¶ÓµÄ±êÊ¶Î»ÖÃ(x,y)
    var float 	 RedTeamPos[2];      //ºì¶ÓµÄ±êÊ¶Î»ÖÃ(x,y)
};

struct KFXPlayerPos                   //Íæ¼Ò±êÊ¶
{
    var TexRotator Normal;              //Õý³£×´Ì¬
    var TexRotator Dead;                //ËÀÍö×´Ì¬
    var TexRotator CarryC4;				//ÄÃC4
    var Material Pig;                 //±äÖí×´Ì¬
    var Material Tortoise;            //±ä¹ê×´Ì¬
    var TexRotator Firing;              //¿ª»ð×´Ì¬
    var Material Cat;                 //±äÃ¨×´Ì¬
};

var bool bDrawTeamMembers;	//ÊÇ·ñ»æÖÆËÀÍö¹Û²ìÕßÁ½²àµÄ¶ÓÎéÐÅÏ¢
var bool bDrawWapMap;	//ÊÇ·ñ»­WapMap
var float warmap_begin_time;	//-1±íÊ¾Ã»ÓÐ»æÖÆ
var float warmap_cartoon_time;
var bool bInitWarMap;
var KFXWarMap WarMap;
var KFXWarMap WarMap2F;
var KFXPlayerPos MyPlayer,OtherPlayer;
var vector maplocPlayer;
var rotator maprotPlayer;

var array<TexRotator> OtherP;
var TexRotator		OtherPlayerSpeech;
var int OtherNum,OldOtherNum;
//------------------------------------------------------------

// »»Ç¹ÏÔÊ¾Ê±¼ä
var float fxShowWeaponTime;

var color BotChatcolor; // jinxin add 2011-12-20
var color PublicChatColor;
var color PersonnalChatColor;
var color GroupChatColor;
var color TeamChatColor;
var color TeamShoutColor;
var color SystemColor;
var color SmallBugleColor;
var color BigBugleColor;
var color NormalColor;
var color ShadeColor;
var color PlayerInOutColor;
var color ClewMsgColor[4];
var color colorVipBugle;
var color colorPrado[2];
var color colorPradoShade[2];
var color COLOR_ItemBroadcast;
// ·À³ÁÃÔÌáÊ¾
struct ImmerseNotifyInfo
{
    var string  sContent;
};

struct HitDmgInfo
{
    var float Damage;
    var int CurHealth;
    var int HitboxIndex;
    var float Dist;
    var vector HitLoction;
    var vector PawnLocation;
};

var array<HitDmgInfo> HitDmgInfoList;
//< Added to support system announce by SunZhuoshi
struct SysAncInfoInGame
{
   var  int     nType;                   // ¹«¸æÀàÐÍ        ChenJianye
   var  int     nDisplayTimes;           // ¹«¸æÐèÒªÏÔÊ¾µÄ´ÎÊý
   var  int     nDisplayInterval;        // ¸÷´ÎÏÔÊ¾µÄ¼ä¸ôÊ±¼ä
   var  string  sText;                   // ¹«¸æÄÚÈÝ
   var  int     nSystemTime;             // ¸Ã¹«¸æµ½´ï¿Í»§¶ËµÄµ±Ç°ÏµÍ³Ê±¼ä
};

var Array<SysAncInfoInGame> SysAncInfo;
var int SysAncLeftTimes;

//<<Ìí¼ÓÏûÃðÍ³¼ÆÐÅÏ¢         ChenJianye
//struct KillInfo
//{
//    var int     nKillme;                  //É±ÎÒ´ÎÊý
//    var int     nKilledByMe;              //±»É±´ÎÊý
//    var string  sPlayerName;              //Íæ¼ÒÃû³Æ
//};
var array<KFXPlayerReplicationInfo> PlayerKillInfo;

var int nKillInfoCount;
//>>

var bool bNotShowChatClew;

var string                  sRealmName;         //RealmÃû³Æ
var int                     nRealmType;         // ·þÎñÆ÷ÀàÐÍ
var string                  sChannelName;       //ÆµµÀÃû³Æ
var string                  sRoomName;          //·¿¼äÃû³Æ
var int                     nRoomID;            //·¿¼äID

//<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 1.16
var string fx_HUD_Dolby_piece1;
var string fx_HUD_Dolby_piece2;
var string fx_HUD_Dolby_bighorn;
var string fx_HUD_Dolby_smallhorn;
var string fx_HUD_Dolby_background1;
var string fx_HUD_Dolby_background2;
var string fx_HUD_Dolby_bighorn_x;
var string fx_HUD_Dolby_smallhorn_x;

struct DolbyTalkerNameContainer
{
    var string TalkerName;
    var float BeginTime;
    // 0 Í£Ö¹Ëµ»° 1 ÕýÔÚËµ»° 2 ÐÂµÄËµ»°
    var int TalkState;
    var bool needshow;
    var bool mask; //ÊÇ·ñ±»µ±Ç°Íæ¼ÒÆÁ±ÎÁË
    var byte VoiceFont;
};

var int testdeltavalue;
var float testtime;
var float testdeltatime;
var array<string> TestNames;

//ÓÃÀ´´æ´¢ËùÓÐµÄËµ»°ÕßÐÅÏ¢
var array<DolbyTalkerNameContainer> Dolby_TalkerArray;
//ÓÃÀ´´æ´¢ÔÚ½çÃæÉÏÏÔÊ¾µÄËµ»°ÕßÐÅÏ¢
var DolbyTalkerNameContainer Dolby_TalkerNames[4];
//>>

// ÖÓ:ÓÃÀ´ÅäÖÃÓëÊ±¼äÏà¹ØhudµÄÏÔÊ¾½á¹¹
struct HUDEffectTime
{
    var bool  bDraw;        // ÊÇ·ñ»æÖÆÐ§¹û
    var float beginTime;    // Ð§¹û¿ªÊ¼Ê±¼ä
    var float totalTime;    // Ð§¹û³ÖÐøÊ±¼ä
};

// ¹Ò»ú£¨¿¨£©¼¶±ð£¬0±íÊ¾Ã»ÓÐ¹Ò»ú£¨¿¨£©
var byte fxHangingLevel;

//°ÔÆÁ
//PlayerOwner.Level.TimeSeconds;
struct pradoType
{
	var int nType;
	var string content;
};
var array<pradoType>			prados;
var automated KFXMarqueeOnHUD 		marquee;

var float						pradoNeedTime;
var float 						pradoPic1, pradoPic2, pradoWait;
var float UpdateRedCrossHairTime;

var bool NeedDrawEncourageMsgs;


//<< HUDÅäÖÃ
struct KFXTileInfo
{
	var Material MatSrc;
	var bool Active;
	var EDrawPivot Pivot;
 	var float ForcedAlpha;
	var int PosX;
	var int PosY;
	var int LengthX;
	var int LengthY;
	var int OrigX;
	var int OrigY;
	var int ClipX;
	var int ClipY;
};
struct KFXXMLTileInfo
{
	var string szImageSet;
	var String szImage;
	var bool Active;
	var EDrawPivot Pivot;
 	var float ForcedAlpha;
	var int PosX;
	var int PosY;
	var int LengthX;
	var int LengthY;
	var int OrigX;
	var int OrigY;
	var int ClipX;
	var int ClipY;
};

struct KFXTextInfo
{
	var string Text;
	var bool Active;
	var EDrawPivot Pivot;
	var int Shader;
	var int Justfied;
	var int LeftX;
	var int LeftY;
	var int RightX;
	var int RightY;
};
struct KFXTaskTipInfo
{
  	var int taskid;
  	var byte tasktype;		//0ÊÇÈÎÎñ£¬1ÊÇ³É¾Í
  	var byte taskstatus;	//1±íÊ¾Íê³É
  	var float passtime;
};

var KFXTileInfo KFXRadarBox;		// À×´ï¿ò
var KFXTileInfo KFXRadarFinger;		// ÊÓÒ°
var KFXTileInfo KFXRadarDolbyIcon;	// ¶Å±ÈÍ¼±ê
var KFXTileInfo KFXRadarFire;		// ¿ª»ð×´Ì¬
var KFXTileInfo KFXRadarDead;		// ËÀÍö×´Ì¬
var KFXTileInfo KFXRadarSpeech;		// ÁÄÌì×´Ì¬
var KFXTileInfo KFXRadarTeamMate;	// ¶ÓÓÑ
var KFXTileInfo KFXTimeTableBlue;	// µ¹¼ÆÊ±°æ£¨µÃ·Ö°æ£©À¶¶Ó
var KFXTileInfo KFXTimeTableRed;	// µ¹¼ÆÊ±°æ£¨µÃ·Ö°æ£©ºì¶Ó
var KFXTileInfo KFXTimeTableGray;	// µ¹¼ÆÊ±°æ£¨µÃ·Ö°æ£©¸öÈËÈü
var KFXTileInfo KFXOurPartBlue;
var KFXTileInfo KFXOurPartRed;
var KFXTileInfo KFXEnemyBlue;
var KFXTileInfo KFXEnemyRed;
var KFXTileInfo KFXHPDownBox;      //µ×²ãHP
var KFXTileInfo KFXHPBar;
var KFXTileInfo KFXAPBar;
var KFXTileInfo KFXWeaponDownInfo;   //ÓÒÏÂ½ÇÎäÆ÷µ×²ãÐÅÏ¢
var KFXTileInfo KFXWeaponUpInfo;    //ÓÒÏÂ½ÇÎäÆ÷ÉÏ²ãÐÅÏ¢

var KFXTextInfo KFXHPValue;
var KFXTextInfo KFXArmorValue;
var KFXTextInfo KFXCurBulletInfo;   //µ±Ç°Ê£Óà×Óµ¯ÐÅÏ¢
var KFXTextInfo KFXMaxBulletInfo;   //×î´ó×Óµ¯Êý
var KFXTextInfo KFXHitOtherName;   //±»»÷ÖÐÈËµÄÃû×Ö
var KFXTextInfo KFXHitOtherHP;   //±»»÷ÖÐµÄÑªÁ¿
var KFXTextInfo KFXBeHitedName;   //±»»÷ÖÐÈËµÄÃû×Ö
var KFXTextInfo KFXBeHitedHP;   //±»»÷ÖÐµÄÑªÁ¿
var KFXTextInfo KFXBeHitedShotCutKey;   //±»»÷ÖÐµÄÎäÆ÷¿ì½Ý¼ü
//>>

var KFXXMLTileInfo 	KFXTeamPicRed;		//ºì¶Ó±êÊ¶
var KFXXMLTileInfo 	KFXTeamPicBlue;     //À¶¶Ó±êÊ¶
var KFXXMLTileInfo	KFXHPPic;	//hpÍ¼Æ¬
var KFXXMLTileInfo	KFXAPPic;	//apÍ¼Æ¬
var KFXTextInfo		KFXWeaponName;
var KFXTextInfo		KFXBulletLine;		//µ±Ç°×Óµ¯ÊýÁ¿ºÍ×î´ó×Óµ¯ÊýÁ¿Ö®¼äµÄÐ±Ïß
var KFXXMLTileInfo	KFXAmmoCountLine;	//×Óµ¯ÊýÁ¿ÏÂÃæµÄÒ»Ìõ·Ö¸îÏß
var KFXXMLTileInfo	KFXFlashPic;		//ÉÁ¹âÀ×
var KFXXMLTileInfo	KFXFlashPicHighlight;	//ÉÁ¹âÀ×£¬ÁÁÍ¼
var KFXXMLTileInfo	KFXGrenadePic;		//¸ß±¬À×
var KFXXMLTileInfo	KFXGrenadePicHighlight;
var KFXXMLTileInfo	KFXSmokePic;		//ÑÌÎíµ¯
var KFXXMLTileInfo	KFXSmokePicHighlight;
var KFXXMLTileInfo	KFXTimeFrameRed;    	//ºì¶ÓµÄÊ±¼äÀ¸
var KFXXMLTileInfo	KFXTimeFrameBlue;       //À¶¶ÓµÄÊ±¼äÀ¸
var KFXXMLTileInfo	KFXTimeFrameNormal;	    //ÆäËûÇé¿öÏÂµÄÊ±¼äÀ¸
var KFXXMLTileInfo	KFXMainWeaponPic;		//ÎäÆ÷ÌáÊ¾Ö®Ö÷ÎäÆ÷
var KFXXMLTileInfo	KFXSecondWeaponPic;		//ÎäÆ÷ÌáÊ¾Ö®¸±ÎäÆ÷
var KFXXMLTileInfo	KFXKnifePic;			//ÎäÆ÷ÌáÊ¾Ö®µ¶
var KFXXMLTileInfo	KFXACEInfo;				//aceÐÅÏ¢
var KFXXMLTileINfo	KFXRadraFrameInfo;		//À×´ï±ß¿ò
var KFXXMLTileInfo	KFXHitInfoBackground;	//»÷É±Í³¼Æ±³¾°
var KFXXMLTileInfo	KFXHitInfoHint;			//ÏÔÊ¾»÷É±Í³¼ÆÌáÊ¾
var KFXXMLTileInfo	KFXHitOtherLevel;		//±»»÷ÖÐÈËµÄµÈ¼¶
var KFXXMLTileInfo	KFXHitOtherHeadIcon;	//±¬Í·»÷ÖÐ
var KFXXMLTileInfo	KFXHitOtherNormalIcon;	//ÆÕÍ¨»÷ÖÐ
var KFXXMLTileInfo	KFXBeHitedLevel;		//±»»÷ÖÐÈËµÄµÈ¼¶
var KFXXMLTileInfo	KFXBeHitedHeadIcon;		//±¬Í·»÷ÖÐ
var KFXXMLTileInfo	KFXBeHitedNormalIcon;	//ÆÕÍ¨»÷ÖÐ
var KFXXMLTileInfo	KFXBeHitedWeapIcon;		//ÆÕÍ¨»÷ÖÐ
var KFXXMLTileInfo	KFXHundredCent;		//100·Ö£¬»÷É±Í³¼Æ
var KFXXMLTileInfo	KFXTenCent;			//10·Ö
var KFXXMLTileInfo	KFXOneCent;			//1·Ö
var KFXXMLTileInfo	KFXKnifeBulletPic;		//µ¶µÄÊ£Óà×Óµ¯Êý

//¹Û²ìÕßÄ£Ê½ÏÂ£¬ÓÎÏ·µÄlogo
var KFXXMLTileINfo	KFXGameLogo;

//»÷É±Í³¼Æ£º
var KFXXMLTileInfo	KFXLastKillerHeadIcon;		//É±ËÀ×Ô¼ºÄÇ¸öÈËµÄ±¬Í·Í¼±êÎ»ÖÃ
var KFXXMLTileInfo  KFXLastKillerWeaponIcon;	//É±ËÀ×Ô¼ºÄÇ¸öÈËµÄÎäÆ÷Í¼±êÎ»ÖÃ
var KFXTextInfo	KFXLastKillerName;	//¸Õ¸ÕÉ±ËÀ×Ô¼ºµÄÄÇ¸öÈËµÄÃû×Ö
var KFXTextInfo	KFXLastKillerHP;	//¸Õ¸ÕÉ±ËÀ×Ô¼ºµÄÄÇ¸öÈËµÄÑªÁ¿
var KFXTextInfo KFXLastKillerWeaponName;	//¸Õ¸ÕÉ±ËÀ×Ô¼ºµÄÄÇ¸öÈËµÄÎäÆ÷Ãû³Æ
var KFXXMLTileInfo	KFXHitterHeadIcon[2];	//ÆäËû×î½ü2¸ö»÷É±×Ô¼ºµÄÄÇ¸öÈËµÄÃû×ÖºÍ±¬Í·Í¼±ê
var KFXTextInfo KFXHitterName[2];
var KFXTextInfo KFXHitterHP[2];
var KFXXMLTileInfo KFXHittedHeadIcon[6];	//±»×Ô¼º¼¯ÖÐµÄÈËµÄ±¬Í·Í¼±ê¡¢Ãû×Ö¡¢ÑªÁ¿
var KFXTextInfo KFXHittedName[6];
var KFXTextInfo KFXHittedHP[6];

var KFXXMLTileInfo 	CurrRoleIdentifyPic;
var int				CurrRoleIdentifyID;

var int				nACEPos;				//ÉÏ´Î»÷É±ÅÅÃûÎ»ÖÃ
var int				tmpTestCount;
var KFXTextInfo		KFXFlashCnt;			//ÉÁ¹âÀ×¸öÊý
var KFXTextInfo		KFXGrenadeCnt;			//¸ß±¬À×¸öÊý
var KFXTextInfo		KFXSmokeCnt;			//ÑÌÎíµ¯¸öÊý
var KFXXMLTileInfo	KFXRevengeInfo;				//¸´³ðÐÅÏ¢
var KFXXMLTileInfo	KFXEncourageInfo;			//¼¤ÀøÐÅÏ¢
var string			RevengeIcon;			//¸´³ðÍ¼±ê
var bool bShowDebug;
var int				nInventoryID;			//¸´³ðµÄid
//var TexRotator		KFXMapFrame;
var string			sMultiKillImage[6];		//Á¬É±Í¼±ê
var array<KFXTaskTipInfo>	MyTaskTips;		//ÈÎÎñÌáÊ¾
var config float ShowHitCollectTime;
var bool bShowHitCollectInfo;
var int  HitInfoVisible;

//»÷É±ºóµÄ¼¤ÀøÒôÐ§
var KillEncourageSound EncourageSoundOther[7];
var KillEncourageSound EncourageSoundMe[7];
var bool bInitEncourage;
var float radarUScale;
var float radarVScale;
var float radarUOffset;
var float radarVOffset;
var byte radarAlpha;	//À×´ïÍ¸Ã÷¶È
var float ShowBulletTime, BulletPicTime;
var int	  oldBulletNum, oldBulletSpeed;
var bool  bHasShot, bRechangeWeapon;
var int		TargetNameXPos, TargetNameYPos, TargetNameXL, TargetNameYL;	//×¼ÐÇ¶Ô×¼Ä³ÈËºóÏÔÊ¾µÄÃû×ÖµÄÇøÓò
var int	 ProbeDistance;	//ÐÄÌø¸ÐÓ¦µÄ×î´ó¾àÀë
var bool IsInspectating;
var float kdcount;
var Pawn	kdpawn;
var float 	ShowEnemyTime;

//µØÍ¼ÇøÓò
struct DomainCell
{
	var string tag;
	var vector Min;
	var vector Max;
};
var array<DomainCell>	MapDomains;	//µØÍ¼µÄÇøÓò
var byte		currDomain;	//µ±Ç°ËùÔÚÇøÓò£¬¶ÔÓ¦±íÀïÃæµÄidÁÐ
var float		LastShowEnemyMsgTime;

var bool        bHasInitedViewHelp;

var float	timecounter;
var bool    bDrawCombatMsg;//ÊÇ·ñÏÔÊ¾ÓÒÉÏ½Ç»÷É±ÐÅÏ¢
var KFXXMLTileInfo	KFXShopSignal;			//¿ÉÒÔ¹ºÂòÎïÆ·ÌáÊ¾

var float DeadBeginTime;             //ËÀÍöÊ±¼ä
var bool  bInitDeadTime;
var float DeadStatusOnRadar;            //ËÀÍö±êÖ¾ÔÚÀ×´ïÉÏµÄÊ±¼ä

var bool bNoManDeadInFive;          //5ÃëÄÚÃ»ÓÐÈËËÀ
var bool bRound;                    //ÊÇ·ñÊÇÐ¡¾ÖÄ£Ê½
var bool bDrawWeaponInfo;           //ÊÇ·ñ»­ÎäÆ÷ÐÅÏ¢

var KFXTextInfo		KFXHelpInSpectating[14];			//¹Û²ìÕßÏÔÊ¾µÄ°ïÖúÐÅÏ¢
//ÓÄÁéÉËÑª
struct fxKillBloodMessage
{
    var byte KillFiftyBloodNum;
    var byte KillTenBloodNum;
};
var fxKillBloodMessage fxBloodMessage;
struct fxFlyingBloodMessage
{
   var vector Pos;
   var bool bFlying;
   var float fxBeginTime;
   var byte BloodFlag;     //10,50
};
var fxFlyingBloodMessage FlyingBloodMessage[30];

struct fxOneKillMessage
{
    var bool bFlying;
    var float fxBeginTime;
    var vector FlyingPos;
    var vector FinalPos;
    var vector OriginPos;
    var bool bOneKill;
};


//ÉËÑª¼¤ÀøÍ¼±ê
var fxOneKillMessage FlyingOneKillMessage[10];
var int FlyingOneKillNum;
var int FlyingFiftyBloodNum;
var int FlyingTenBloodNum;
var int OneKillsCount;
var bool bFiftyBloodPic;
var bool bTenBloodPic;
var float  FiftyBloodBeginTime;
var float  TenBloodBeginTime;
var KFXXMLTileInfo FiftyBloodTile;
var KFXXMLTileInfo TenBloodTile;
var KFXXMLTileInfo FlyFiftyBloodTile;
var KFXXMLTileInfo FlyTenBloodTile;
var KFXXMLTileInfo FlyOneKillTile;
var bool bDrawBloodMessage;
var vector FlyFiftyBloodTilePos;
var vector FlyTenBloodTilePos;

//µ¶¹¥»÷¾àÀëÄÚµÃµ½ÌáÊ¾
var bool bDrawKnifeAttack;
var KFXXMLTileInfo	KFXKnifeLeftCanAttack;
var KFXXMLTileInfo	KFXKnifeRightCanAttack;
var KFXXMLTileInfo	KFXKnifeBothCanAttack;
var KFXXMLTileInfo	KFXKnifeCannotAttack;

var bool bNeedRevenge;
//FarmÓÎÏ·ÄÚÏÔÊ¾ sunqiang
struct DropItemInfo
{
    var bool bFlying;
    var float DropItemBeginTime;
    var int   ItemID;
    var sound ItemSound;
    var string ItemName;
    var string ItemPicPackage;
    var string ItemPicFile;
};
var DropItemInfo DroppedItemInfo;
var int  DroppedItemNum;
var KFXXMLTileInfo DropItemTile;
var float time_last_set_hud;



var string MyMessage;
var float  ShowTimes;
function CanvasDrawActors( Canvas C, bool bClearedZBuffer )
{
	super.CanvasDrawActors(C, bClearedZBuffer);

	if (  KFXPawn(PlayerOwner.ViewTarget)!= none
	      && !KFXPlayer(PlayerOwner).bBehindView
		  && KFXPlayer(PlayerOwner).SpectateHook != none
		  && KFXPlayer(PlayerOwner).SpectateHook.CurSpectateWeap != none)
	{
		if ( !bClearedZBuffer)
			C.DrawActor(None, false, true); // Clear the z-buffer here
		KFXPlayer(PlayerOwner).SpectateHook.CurSpectateWeap.RenderOverlays( C );
	}
}

simulated function UpdatePrecacheMaterials()
{
    Super.UpdatePrecacheMaterials();
}


function KFXGetNetInfo(string RealmName, int RealmType, string ChannelName,string RoomName,int RoomID)
{
    nRealmType = RealmType;
    sRealmName=RealmName;
    sChannelName=ChannelName;
    sRoomName=RoomName;
    nRoomID=RoomID;
}

// set system announce params & start to run    | System anncounce modified by ChenJianye
simulated function SysAncSet( Array<SysAncInfoInGame> InSysAncInfo )
{
    local int i;
    SysAncInfo = InSysAncInfo;
    SysAncLeftTimes = 0;
    log("--------------- SysAncInfo"@SysAncInfo.Length@"InSysAncInfo"@InSysAncInfo.Length);

    for (i=0;i<SysAncInfo.Length;++i)
    {
        ;
        ;
        ;
        ;
        Message( none, SysAncInfo[i].sText, 'System' ); //ÓÎÏ·ÄÚÖ»·¢Ò»±éÐÅÏ¢    ChenJianye
//        SysAncLeftTimes =InSysAncInfo[i].nDisplayTimes ;
//        LOG("[SZS]SysAncLeftTimes="$SysAncLeftTimes);
//        SetTimer( SysAncInfo[i].nDisplayInterval, true );
//        Timer();
    }
    SysAncInfo.Remove(0,SysAncInfo.Length);
}

// Add lew message into the clew queue.
// Added by Linsen for fox version 3
// 2008-3-3
simulated function KFXClearClewMessage()
{
    // Clear the queue
    while(fxClewmsgQueue.tear != fxClewmsgQueue.front)
    {
        fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].iFirstlyShow = 0;
        fxClewmsgQueue.front =  (fxClewmsgQueue.front + 1) % 5;
    }
}

//<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 2.6 Õâ¸ö½Ó¿ÚÎªÁÄÌìÊÒÄ£Ê½µÄDolbyÖÇÄÜÌáÊ¾ÓÃ È¥µôÁË2ÓÅÏÈ¼¶µÄÁÄÌìÊÒÆÁ±Î
simulated function KFXSendClewMessageForChatGameDolbyInfo(string ClewMsg, optional bool bEmergent, optional string ClewMsgTitle, optional float LastingTime, optional int Priority)
{
    ;
if(_HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_PromptInfo(ClewMsg);
}
    if (fxClewmsgQueue.tear != fxClewmsgQueue.front
        && Priority > fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].nPriority)
    {
        return;
    }
    //ÆÁ±Î°ïÖúÏûÏ¢
    //if (Priority == 2 && KFXPlayer(PlayerOwner).bBlockAssitMsg)
    //{
    //    return;
    //}

    // if bEmergent equals true, abandon all the messages in the queue
    if(bEmergent)
    {
        KFXClearClewMessage();
    }

    // if the queue is full, just abandon the oldest message in the queue
    if((fxClewmsgQueue.tear + 1)%5 == fxClewmsgQueue.front)
    {
        fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].iFirstlyShow = 0;
        fxClewmsgQueue.front =  (fxClewmsgQueue.front + 1) % 5;

    }

    if(LastingTime == 0)
        LastingTime = 3;     // default lasting time
    if(ClewMsgTitle == "")
        ClewMsgTitle = lClewMsgHead;   // default message head
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].sMsgTitle = ClewMsgTitle;
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].fShowClewmsgTime = LastingTime;
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].sMsgContent = ClewMsg;
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].nPriority = Priority;
    fxClewmsgQueue.tear = (fxClewmsgQueue.tear + 1) % 5;
}
//>>

simulated function KFXSendClewMessage(string ClewMsg, optional bool bEmergent, optional string ClewMsgTitle, optional float LastingTime, optional int Priority)
{
    //LOG("Message:"@Priority@ClewMsg);


    if (fxClewmsgQueue.tear != fxClewmsgQueue.front
        && Priority > fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].nPriority)
    {
        return;
    }
    //ÆÁ±Î°ïÖúÏûÏ¢
    if (Priority == 2 && KFXPlayer(PlayerOwner).bBlockAssitMsg)
    {
        return;
    }

    // if bEmergent equals true, abandon all the messages in the queue
    if(bEmergent)
    {
        KFXClearClewMessage();
    }

    // if the queue is full, just abandon the oldest message in the queue
    if((fxClewmsgQueue.tear + 1)%5 == fxClewmsgQueue.front)
    {
        fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].iFirstlyShow = 0;
        fxClewmsgQueue.front =  (fxClewmsgQueue.front + 1) % 5;

    }

    if(LastingTime == 0)
        LastingTime = 3;     // default lasting time
    if(ClewMsgTitle == "")
        ClewMsgTitle = lClewMsgHead;   // default message head
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].sMsgTitle = ClewMsgTitle;
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].fShowClewmsgTime = LastingTime;
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].sMsgContent = ClewMsg;
    fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.tear].nPriority = Priority;
    fxClewmsgQueue.tear = (fxClewmsgQueue.tear + 1) % 5;
if(_HUD_NEW_ == 2)
{
    PlayerOwner.Player.GUIController.SetHUDData_PromptInfo(ClewMsg);
}

}


// Show messages in the clew queue.
// Added by Linsen for fox version 3
// 2008-3-3
function DrawClewMessage(Canvas Canvas)
{
    local  string ClewMsgTitle;
    local  float LastingTime;
    local  float FirstlyShowTime;
    local  float DeltaTime;
    local  int temp;
    local  array<string> WrappedString;

    // The queue is empty
    if(fxClewmsgQueue.tear == fxClewmsgQueue.front)
    {
        return;
    }

    // Game is over
//    if( (PlayerOwner.IsDead())
//        ||(PlayerOwner.IsInState('GameEnded'))
//        ||(PlayerOwner.IsInState('RoundEnded')) )
//    {
//        KFXClearClewMessage();
//        return;
//    }

    // Current Message is shown first time
    if(fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].iFirstlyShow == 0)
    {
        fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].fFirstlyShowTime
                                                          =  Level.TimeSeconds;
        fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].iFirstlyShow = 1;
    }

    ClewMsgTitle = fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].sMsgTitle;
    LastingTime = fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].fShowClewmsgTime;
    FirstlyShowTime = fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].fFirstlyShowTime;

    DeltaTime = Level.TimeSeconds - FirstlyShowTime;

    // Gradually disappear
    if( DeltaTime < LastingTime )
    {
        if(DeltaTime > LastingTime - 1.0)//1Ãë½¥Òþ
        {
            Canvas.bForceAlpha = true;
            Canvas.ForcedAlpha = LastingTime - DeltaTime;
        }

        temp = fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].nPriority;

        // white style
        Canvas.Style = ERenderStyle.STY_Normal;
        Canvas.SetDrawColor(ClewMsgColor[temp].R, ClewMsgColor[temp].G, ClewMsgColor[temp].B, ClewMsgColor[temp].A);

        //ÖÐÖÐ¶ÔÆë·½Ê½
        Canvas.KFXSetPivot(DP_MiddleMiddle);
        Canvas.KFXFontAlias = "heavylarge16";

        Canvas.KFXWrapStrToArray(fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].sMsgContent,
                            WrappedString, 512, "|");

        for (temp=0; temp<WrappedString.length; temp++)
        {
            Canvas.KFXDrawStrJustifiedWithBorder(WrappedString[temp],
                                    1, 256, 127+22*temp, 768, 150+22*temp, ShadeColor, -1);
        }

        /*
        //Canvas.SetPos( 787 * Canvas.ClipX / 1024, 600 * Canvas.ClipY / 768 );
        Canvas.SetPos( Canvas.SizeX - 237, Canvas.SizeY - 168);

        Canvas.DrawTile(
            Material(DynamicLoadObject("fx_ui3_texs.hud_clew_bg_orig", class'Material')),
                228, 86,
                0, 0, 228, 86);



        Canvas.Style = ERenderStyle.STY_Normal;

        temp = 255 * Canvas.ForcedAlpha;
        if(temp == 0)
            temp = 1;
        Canvas.SetDrawColor(255, 255, 255, temp);
        Canvas.KFXFontAlias = "heavysmall12";

        // Bug, text drawn firstly will not gradually disappear
//        Canvas.KFXDrawStrJustified(" ", 1,
//            795 * Canvas.SizeX / 1024, 603 * Canvas.SizeY / 768,
//            1011 * Canvas.SizeX / 1024, 627 * Canvas.SizeY / 768
//            );
        Canvas.KFXDrawStrJustified(" ", 1,
            Canvas.SizeX - 229, Canvas.SizeY - 165,
            Canvas.SizeX - 13, Canvas.SizeY - 141
            );
        // Draw message title
        Canvas.KFXDrawStrJustified(ClewMsgTitle, 1,
            Canvas.SizeX - 229, Canvas.SizeY - 163,
            Canvas.SizeX - 13, Canvas.SizeY - 138
            );


        // Draw message text
        Canvas.KFXFontAlias = "heavysmall12";
        Canvas.KFXWrapStrToArray(
                fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].sMsgContent,
                WrappedString, 220);

        for( temp = 0; temp < WrappedString.Length; temp++)
        {
//            Canvas.KFXDrawStrJustified(WrappedString[temp], 1,
//                791 * Canvas.SizeX / 1024, (617 + temp*21)* Canvas.SizeY / 768,
//                1011 * Canvas.SizeX / 1024, (670 + temp*21)* Canvas.SizeY / 768
//                );
            Canvas.KFXDrawStrJustified(WrappedString[temp], 1,
                Canvas.SizeX - 233, (Canvas.SizeY - 151 + temp*21),
                Canvas.SizeX - 13, (Canvas.SizeY - 98 + temp*21)
                );
        }
        */
        // CanvasÊôÐÔ»Ö¸´
        Canvas.KFXSetPivot(DP_UpperLeft);
        Canvas.ForcedAlpha = 1.0;
        Canvas.bForceAlpha = false;
    }
    else
    {
        // delete the message
        fxClewmsgQueue.fxClewMessage[fxClewmsgQueue.front].iFirstlyShow = 0;
        fxClewmsgQueue.front = (fxClewmsgQueue.front + 1) % 5;
    }
}

// ³õÊ¼Õ½ÊõµØÍ¼
simulated function InitWarMap()
{
    local string sMapSrc;
    local KFXCSVTable fxCsvMapInfo;
	local KFXCSVTable csvGameInfo;
	local int mapid;
    //³õÊ¼»¯Õ½ÊõµØÍ¼
    OldOtherNum=0;
    fxCsvMapInfo = class'KFXTools'.static.GetConfigTable(101);
    csvGameInfo = class'KFXTools'.static.GetConfigTable(102);
	if ( fxCsvMapInfo == none || csvGameInfo == none)
    {
        return;
    }
    csvGameInfo.SwitchCurFileKey("id");

    if ( GetGRI().fxMapID == 0 || !csvGameInfo.SetCurrentRow(GetGRI().fxMapID) )
    {
    	mapid = 1;
        //return;
    }
    else
    {
		mapid = csvGameInfo.GetInt("MapID");
	}
	csvGameInfo.SwitchCurFileKey("No.");
	if(!fxCsvMapInfo.SetCurrentRow(mapid))
	{
		log("##### WARNING ##### can't find this map:"$GetGRI().fxMapID@mapid);
		return;
	}
    sMapSrc = fxCsvMapInfo.GetString("WarMapPic");
    WarMap.Material = Material(DynamicLoadObject(sMapSrc, class'Material'));
    WarMap.RotMaterial = new class'TexRotator';
    WarMap.RotMaterial.Material = WarMap.Material;
	WarMap.RotMaterial.UOffset = 512;
	WarMap.RotMaterial.VOffset = 512;
	WarMap.TopTeam = fxCsvMapInfo.GetInt("TopTeam");
	WarMap.BlueTeamPos[0]=fxCsvMapInfo.GetFloat("BlueTeamX");
	WarMap.BlueTeamPos[1] = fxCsvMapInfo.GetFloat("BlueTeamY");
	WarMap.RedTeamPos[0] = fxCsvMapInfo.GetFloat("RedTeamX");
	WarMap.RedTeamPos[1] = fxCsvMapInfo.GetFloat("RedTeamY");

    sMapSrc = fxCsvMapInfo.GetString("WarMapPic2F");
    WarMap.Material2F = Material(DynamicLoadObject(sMapSrc, class'Material'));
    WarMap.Map2FHigh=fxCsvMapInfo.GetInt("Map2FHigh");
    WarMap.OffsetX=fxCsvMapInfo.GetInt("WarMapOffsetX");
    WarMap.OffsetY=fxCsvMapInfo.GetInt("WarMapOffsetY");
    WarMap.Rate=fxCsvMapInfo.GetFloat("WarMapRate");
    WarMap.Rota=fxCsvMapInfo.GetInt("WarMapRota");
    WarMap.ChangeXY=fxCsvMapInfo.GetInt("WarMapVelXYChange");

//


    //³õÊ¼»¯Íæ¼Ò±êÖ¾
    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_me";
    MyPlayer.Normal = new class'TexRotator';
	MyPlayer.Normal.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	MyPlayer.Normal.VOffset = 21;
	MyPlayer.Normal.UOffset = 22;

    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_death";
    MyPlayer.Dead = new class'TexRotator';
	MyPlayer.Dead.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	MyPlayer.Dead.VOffset = 21;
	MyPlayer.Dead.UOffset = 22;

    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_me";
    MyPlayer.Pig = Material(DynamicLoadObject(KFXMatSrc, class'Material'));

    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_me";
    MyPlayer.Tortoise = Material(DynamicLoadObject(KFXMatSrc, class'Material'));

    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_me";
    MyPlayer.Cat = Material(DynamicLoadObject(KFXMatSrc, class'Material'));

    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_fire";
    MyPlayer.Firing = new class'TexRotator';
    MyPlayer.Firing.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	MyPlayer.Firing.VOffset = 21;
	MyPlayer.Firing.UOffset = 22;

     //³õÊ¼»¯Í¬²ã¶ÓÓÑ±êÖ¾
    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_death";
    OtherPlayer.Dead = new class'TexRotator';
	OtherPlayer.Dead.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	OtherPlayer.Dead.VOffset = 21;
	OtherPlayer.Dead.UOffset = 22;

    KFXMatSrc = "fx_ui_map_texs.warmap_pig";
    OtherPlayer.Pig = Material(DynamicLoadObject(KFXMatSrc, class'Material'));

    KFXMatSrc = "fx_ui_map_texs.warmap_tor";
    OtherPlayer.Tortoise = Material(DynamicLoadObject(KFXMatSrc, class'Material'));

    KFXMatSrc = "mat2_hud_texs.HUD_tacticsmap_death";
    MyPlayer.Cat = Material(DynamicLoadObject(KFXMatSrc, class'Material'));

    bInitWarMap = true;
    return;
}


//> Added...
// ³õÊ¼»¯Ð¡µØÍ¼??ÊÇ·ñÊÍ·Å
function InitSmallMap_MapInfo(out string mapsrc)
{
    local KFXCSVTable fxCsvMapInfo;
	local KFXCSVTable csvGameInfo;
	local int nMapID;

    fxCsvMapInfo = class'KFXTools'.static.GetConfigTable(101);
    csvGameInfo = class'KFXTools'.static.GetConfigTable(102);

    if ( fxCsvMapInfo == none || csvGameInfo == none)
    {
    	log("#### ERROR #### no map info csv!");
        return;
    }
	csvGameInfo.SwitchCurFileKey("id");
    if ( GetGRI().fxMapID == 0 || !csvGameInfo.SetCurrentRow(GetGRI().fxMapID) )
    {
    	log("#### ERROR #### fxMapID == "$GetGRI().fxMapID);
        //return;
        nMapID = 1;	//Ä¬ÈÏÖµ
    }
    else
    {
		nMapID = csvGameInfo.GetInt("MapID");
	}
	csvGameInfo.SwitchCurFileKey("No.");
    if ( !fxCsvMapInfo.SetCurrentRow(nMapID) )
    {
    	log("#### ERROR #### fxMapID == "$nMapID);
        //return;
    }
    MapRoleSpeedFactor = fxCsvMapInfo.GetFloat("MapRoleSpeedFac");
    RadarMapScale = fxCsvMapInfo.GetFloat("RadarMapScale");
	if(RadarMapScale == 0)
		RadarMapScale = 1.0;

    mapsrc = fxCsvMapInfo.GetString("RadarPicName");
}
simulated function InitSmallMap(Canvas canvas)
{
    local string sMapSrc;

	//»ñµÃµØÍ¼ÐÅÏ¢
    InitSmallMap_MapInfo(sMapSrc);

//²»ÆÚÍûÊ§°Ü
//    if(sMapSrc == "")
//    	return;

    fxSmallMap.MapShader = new class'Shader';//Shader(DynamicLoadObject(KFXMatSrc, class'Shader'));
    fxSmallMap.MapShader.Opacity = Material(DynamicLoadObject("mat2_hud_texs.HUD_rader_frameblack", class'Material'));
	fxSmallMap.MapMaterial = Material(DynamicLoadObject(sMapSrc, class'Material'));

	//Ëõ·Åx£¬ Î§ÈÆx*centerÐý×ª£¬Æ½ÒÆx*center-80

    fxSmallMap.MapScaler = new class'TexScaler';
    fxSmallMap.MapScaler.Material = fxSmallMap.MapMaterial;

    fxSmallMap.MapRotator = new class'TexRotator';
    fxSmallMap.MapRotator.Material = fxSmallMap.MapScaler;

	fxSmallMap.MapOffset = new class'TexScaler';
	fxSmallMap.MapOffset.Material =  fxSmallMap.MapRotator;

    fxSmallMap.MapShader.Diffuse = fxSmallMap.MapOffset;
    fxRadarFrame = Material(DynamicLoadObject("mat2_hud_texs.HUD_rader_frame", class'Material'));
    bInitSmallMap = true;

//    fxTeammatePic.MapMaterial = Canvas.KFXLoadXMLMaterial("mat2_HUD_radar", "NewImage7",
//			tu, tv, tul, tvl);
	fxMyRotPic.MapMaterial = Material(DynamicLoadObject("mat2_hud_texs.HUD_rader_me", class'Material'));
	fxMyRotPic.MapScaler = new class'TexScaler';
	fxMyRotPic.MapRotator = new class'TexRotator';
	fxMyRotPic.MapScaler.Material = fxMyRotPic.MapMaterial;
	fxMyRotPic.MapScaler.UOffset = 0;
	fxMyRotPic.MapScaler.VOffset = 0;
	fxMyRotPic.MapRotator.Material = fxMyRotPic.MapScaler;
	fxMyRotPic.MapRotator.UOffset = 12;
	fxMyRotPic.MapRotator.VOffset = 12;

//	KFXMapFrame = new class'TexRotator';
//	KFXMapFrame.Material = Material(DynamicLoadObject("mat2_hud_texs.HUD_rader_frameblack", class'Material'));
//	KFXMapFrame.VOffset =  84;
//	KFXMapFrame.UOffset = 84;

    return;
}
function InitTeamMateRots(int nsize)
{
	local int oldlen;
	local int i;
	if(fxTeamRotPic.length >= nsize)
	{
		return;
	}
	oldlen = fxTeamRotPic.length;
	fxTeamRotPic.Insert(oldlen, nsize-oldlen);
	for(i=oldlen; i<nsize; i++)
	{
		fxTeamRotPic[i].MapMaterial = Material(DynamicLoadObject("mat2_hud_texs.HUD_rader_team", class'Material'));
//		fxTeamRotPic[i].MapScaler = new class'TexScaler';
		fxTeamRotPic[i].MapRotator = new class'TexRotator';
//		fxTeamRotPic[i].MapScaler.Material = fxTeamRotPic[i].MapMaterial;
//		fxTeamRotPic[i].MapScaler.UOffset = 0;
//		fxTeamRotPic[i].MapScaler.VOffset = 0;
		//fxTeamRotPic[i].MapRotator.Material = fxTeamRotPic[i].MapScaler;
		fxTeamRotPic[i].MapRotator.Material = fxTeamRotPic[i].MapMaterial;
		fxTeamRotPic[i].MapRotator.UOffset = 12;	//ÈÆÖÐÐÄÐý×ª
		fxTeamRotPic[i].MapRotator.VOffset = 12;
	}
	if(TeammateSpeech.MapRotator == none)
	{
		TeammateSpeech.MapRotator = new class'TexRotator';
	}

}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    KFXInit();

	if(!bInitEncourage)
		InitEncourageSound();
    // ´ËÊ±PlayerOwner==none? F1°ïÖú²Ëµ¥
    if (KFXPlayer(PlayerOwner).bFirstTimeGame)
    {
        KFXPlayer(PlayerOwner).KFXShowHelpInGame();
    }

    //<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 2.2
    //testtime = 0;
    //testdeltatime = 0;
    //>>

    if(PlayerOwner != none)
    {
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_ModeReset(PlayerOwner);
}
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
    log("[LABOR]-----------kfx hud post begin play");
    PlayerOwner.Player.GUIController.SetHUDData_Init();
}
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
    PlayerOwner.Player.GUIController.ResetHUDData();
}

	//Ã¿0.3ÃëÊÕ¼¯Ò»ÏÂÊý¾Ý
	SetTimer(0.3, true);

	}

}
event Timer()
{

if(_HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_showlogo(
				KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bSpectatorView
				|| (PlayerOwner.ViewTarget != none && PlayerOwner.IsInState('Spectating')));
}

if(_HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_showhelp(KFXPlayer(PlayerOwner).bShowViewHelp);
}

if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	//ÊÕ¼¯hudµÄÖµ£¬Ã¿0.3ÃëÊÕ¼¯Ò»´Î
    GUIController(PlayerOwner.Player.GUIController).SetHUDData(0);
}

if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	//Èç¹ûÕýÔÚ²¥·ÅËÀÍö»Ø·Å£¬ÄÇÃ´Òþ²ØµôUIHUD
    GUIController(PlayerOwner.Player.GUIController).SetHUDData_HudVisible(!(PlayerOwner.IsGameRecorderPlaying()||KFXPlayer(PlayerOwner).bFreeRecord));
}


}

event Destroyed()
{
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_Destroyed();
}
}
/*
// ¹Øµô¿ØÖÆÌ¨
event Destroyed()
{
    PlayerConsole.TypingClose();

    super.Destroyed();
}
*/

// µÃµ½GRIºÍPRI
simulated function KFXGameReplicationInfo GetGRI()
{
    return KFXGameReplicationInfo(PlayerOwner.GameReplicationInfo);
}

simulated function KFXPlayerReplicationInfo GetPRI()
{
    return KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);
}
simulated function SortPRIArray()
{
    local int i,j;
    local PlayerReplicationInfo tmp;
    local GameReplicationInfo gri;

    gri = PlayerOwner.GameReplicationInfo;
    for (i=0; i<GRI.PRIArray.Length-1; i++)
    {
        for (j=i+1; j<GRI.PRIArray.Length; j++)
        {
            if( !InOrder2( GRI.PRIArray[i], GRI.PRIArray[j] ) )
            {
                tmp = GRI.PRIArray[i];
                GRI.PRIArray[i] = GRI.PRIArray[j];
                GRI.PRIArray[j] = tmp;
            }
        }
    }
}
//ÍÅ¶ÓÄ£Ê½ÅÅÐò·½·¨
function bool InOrder2(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
	local KFXPlayerReplicationInfo tp1, tp2;
	tp1 = KFXPlayerReplicationInfo(p1);
	tp2 = KFXPlayerReplicationInfo(p2);
	//½µÐòÅÅÐò£¬¼´´óµÄÔÚÇ°
	//ÐèÒª½»»»Êý¾ÝµÄ·µ»Øfalse
	if(tp1.fxKills < tp2.fxKills)
		return false;
	else if(tp1.fxKills > tp2.fxKills)
		return true;
	if(tp1.fxDeaths > tp2.fxDeaths)
		return false;
	else if(tp1.fxDeaths < tp2.fxDeaths)
		return true;
	return true;	//killsºÍdeathsÏàÍ¬µÄ£¬²»½»»»

}

//¸üÐÂÒ»ÏÂËùÓÐPRIµÄÐÅÏ¢£¬ÈçlocationÐÅÏ¢
function UpdatePRIInfos()
{
	local Pawn p;
	//»­¶ÓÓÑ

	foreach DynamicActors(class'pawn', P)
	{
    	if(p.PlayerReplicationInfo != none)
    	{
    		//¸üÐÂLocationÐÅÏ¢
			KFXPlayerReplicationInfo(p.PlayerReplicationInfo).fxLocation = p.Location;
		}
	}

}

//¹Û²ìÕßÄ£Ê½½øÈëºóÌáÊ¾
function KFXDrawViewHelp(Canvas Canvas)
{
    local int i;
    if(!bHasInitedViewHelp)
    {
        bHasInitedViewHelp = true;
    }
    Canvas.SetDrawColor(255,255,255);
    Canvas.KFXFontAlias = "heavylarge16";
    for(i=0; i<5; i++)
    {
        KFXDrawTextExtra(Canvas, KFXHelpInSpectating[i], KFXHelpInSpectating[i].Text);
    }
    Canvas.SetDrawColor(255,255,0);
    Canvas.KFXFontAlias = "heavylarge16";
    for(i=5; i<14; i++)
    {
        KFXDrawTextExtra(Canvas, KFXHelpInSpectating[i], KFXHelpInSpectating[i].Text);
    }
}
//ÊÇ¿ÉÒÔ»­ÖÐÎÄµÄÁË
simulated function KFXDrawTextExtra(Canvas Canvas, KFXTextInfo TextInfo, coerce string TextSrc)
{

	if ( !TextInfo.Active )
	{
		return;
	}

    Canvas.KFXSetPivot(TextInfo.Pivot);
    Canvas.KFXDrawStrJustifiedWithBorder(TextSrc,TextInfo.Justfied,TextInfo.LeftX, TextInfo.LeftY,
        TextInfo.RightX, TextInfo.RightY,Canvas.DrawColor,-1
	        );
    Canvas.KFXSetPivot(DP_UpperLeft);
}
simulated function DrawHUDInSpectating(Canvas Canvas)
{
    if(KFXPlayer(PlayerOwner).bShowViewHelp)
    {
        KFXDrawViewHelp(Canvas);
    }

    bDrawKFXHUD = true;

    //»­¹Û²ìÕßÄ£Ê½ÏÂµÄ¶ÓÎéÐÅÏ¢   Q¼üÇÐ»»
    DrawTeamMembersInfo(Canvas,KFXPlayer(PlayerOwner).bPressQ);
    DrawTimeInSpectating(Canvas);

    if(KFXPlayer(PlayerOwner).IsInState('DownViewState'))      //¸©ÊÓ½Ç
    {
        if(bDrawKFXHUD)
        {
            bDrawKFXHUD = false;
        }
        KFXDrawPlayerNameInDownViewState(Canvas);       //»­Ãû×Ö
    }
    return;
    if(KFXPlayer(PlayerOwner).IsInState('Spectating'))   //¹Û²ìÕßÊÓ½Ç
    {
        if(!bDrawKFXHUD)
        {
            bDrawKFXHUD = true;
        }
        bDrawCombatMsg =false;
    }

    if(KFXPlayer(PlayerOwner).IsInState('PlayerWaiting'))     //×ÔÓÉÊÓ½Ç
    {
        // »­Õ½¶·ÐÅÏ¢
        DrawCombatMessage(Canvas);
        KFXDrawPlayerNameInSpectating(Canvas);       //»­Ãû×Össs
        if(bDrawKFXHUD)
        {
            bDrawKFXHUD = false;
        }
    }
}
// ÖØÒªº¯Êý£¬ÕâÀïÍê³ÉÁËËùÓÐµÄ»æÖÆ
// ¾ö¶¨ÒÔÖØÔØµÄ·½Ê½Íê³ÉÐÞ¸Ä**×ß×Ô¼ºµÄÒ»Ì×Á÷³Ì
simulated event PostRender( canvas Canvas )
{
    local Font fxFont;

    if ( PlayerOwner.IsGameRecorderPlaying()||KFXPlayer(PlayerOwner).bFreeRecord )
    {
       GUIController(PlayerOwner.Player.GUIController).SetTeamMemberState(-1);
//       GUIController(PlayerOwner.Player.GUIController).SetHUDData_HudVisible(false);
       return;
    }
//    GUIController(PlayerOwner.Player.GUIController).SetHUDData_HudVisible(true);

	super.PostRender(Canvas);

	//ÉèÖÃ»æÖÆÓÎÏ·logo
//if(_HUD_NEW_ == 2)
//{
//	PlayerOwner.Player.GUIController.SetHUDData_showlogo(
//				KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bSpectatorView
//				|| (PlayerOwner.ViewTarget != none && PlayerOwner.IsInState('Spectating')));
//}
//
//if(_HUD_NEW_ == 2)
//{
//	PlayerOwner.Player.GUIController.SetHUDData_showhelp(KFXPlayer(PlayerOwner).bShowViewHelp);
//}
//
//if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
//{
//	//ÊÕ¼¯hudµÄÖµ£¬Ã¿0.3ÃëÊÕ¼¯Ò»´Î
//    GUIController(PlayerOwner.Player.GUIController).SetHUDData(0);
//}

    //¹Û²ìÕßÄ£Ê½ÏÂHUDÒªÏÔÊ¾µÄ¶«Î÷
    if(KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bSpectatorView)
    {
if(_HUD_NEW_ == 1)
{
		//»æÖÆÓÎÏ·logo
		KFXDrawXMLTileInfo(Canvas, KFXGameLogo);
}

		DrawHUDInSpectating(Canvas);
        if(!bDrawKFXHUD)
        {
            return;
        }
    }

    fxFont = Canvas.Font;

    tmpTestCount++;

    // »­ÈËÎïÏà¹ØÌØÐ§
    if( PlayerOwner != none && KFXPawn(PlayerOwner.Pawn) != none )
    {
        KFXPawn(PlayerOwner.Pawn).KFXRenderGameEffects(Canvas);
    }

	// »­½çÃæÍâ¹Û
    if( !bHideHud )
    {
    	if(ScoreBoard != none)
			ScoreBoard.UpdateGRI();
        UpdatePRIInfos();
		if( PlayerOwner != none && bDrawKFXHUD )
        {
            DrawGameHud(Canvas);
        }
    	//½øÐÐÅÅÃû
        if( bDrawKFXScoreBoard && ScoreBoard != none && !PlayerOwner.IsGameRecorderPlaying() )
        {
            ScoreBoard.DrawScoreboard(Canvas);
        }
    }
    //»­ÈÎÎñÌáÊ¾
	DrawTaskTip(Canvas);

    KFXDrawMGInfo( Canvas );
    if ( bShowDebug )
    {
        Canvas.KFXSetPivot(DP_MiddleMiddle);
        Canvas.SetDrawColor(0,255,0,255);
        Canvas.KFXFontAlias = KFXBaseFontAlias;

        Canvas.SetPos( 200, 150 );
        Canvas.SetDrawColor(0,255,0,255);

        Canvas.KFXDrawStr("CurSpeed:"$VSize(PawnOwner.Velocity));

        Canvas.SetPos( 200, 170 );
        Canvas.KFXDrawStr("Jump horizontal distance:"$VSize( (KFXPawn(PawnOwner).JumpLocation - KFXPawn(PawnOwner).LandLocation)*vect(1,1,0) ));

        Canvas.SetPos( 200, 190 );
        Canvas.KFXDrawStr("Comman jump max height:"$((PawnOwner.DefJumpZ*PawnOwner.DefJumpZ)/4308));

        Canvas.SetPos( 200, 210 );
        Canvas.KFXDrawStr("jump max height(jump with croch):"$((PawnOwner.DefJumpZ*PawnOwner.DefJumpZ)/4308));

        Canvas.SetPos( 200, 230 );
        Canvas.KFXDrawStr("Series Location Distance:"$(KFXPawn(PawnOwner).SeriesDistance));

        Canvas.KFXSetPivot(DP_UpperLeft);
    }
    Canvas.Font = fxFont;
    Canvas.bForceAlpha = false;
}
exec function ToggleShowDebug()
{
    bShowDebug = !bShowDebug;
}
// ÔÚPostRenderÖÐµ÷ÓÃ£¬Ò²¾ÍÊÇTriggerÀ©Õ¹
// **×¢Òâ£ºÕâÀïÃæÒª×öÉíÉÏµÄÎäÆ÷ÅÐ¶Ï
simulated function DrawGameHud(Canvas Canvas)
{    //todo:jinxin
   //test
 //  BroadcastHandler.Broadcast(Sender,Msg,Type);
    if ( PlayerOwner.IsGameRecorderPlaying() )
       return;
//      if( !class'KFXBotChatMessage'.static.IsDialogInuse() )
 //   class'KFXBotChatMessage'.static.InitADialog(6);
 //  DrawBotMessage(Canvas,MyMessage);
if(_HUD_NEW_ == 2)
{
	if(Level.TimeSeconds - time_last_set_hud > 0.3)
	{
		time_last_set_hud = Level.TimeSeconds;
	}
	else
	{
		//return;
	}
}
 if(_HUD_NEW_ == 2)
{
	//ÊÕ¼¯hudµÄÖµ
    GUIController(PlayerOwner.Player.GUIController).SetHUDData(0);
}

    // Trace data
    KFXTraceView(Canvas);

    // ÕâÀïÎªÁË±ÜÃâËÀÍöÃ»ÓÐPawnµÄÇé¿ö
    if( PawnOwner != none && PlayerOwner.Pawn != none )
    {
        // »­weaponÐÅÏ¢
        if(bDrawWeaponInfo)
        {
            DrawWeaponInfo(Canvas);
        }

    }
    else
    {
        //½Ø¶ÏÎ£»úÉùÒô
        KFXStopSound(self,none);
    }

//if(_HUD_NEW_ == 2)
//{
//	//»æÖÆÎäÆ÷µÄÊ±ºò£¬¼ì²éÎäÆ÷µÄÐÅÏ¢
//    PlayerOwner.Player.GUIController.SetHUDData_CheckWeaponsNumber();
//}

if(_HUD_NEW_ == 1)
{
    	// »­Í¨ÓÃÐÅÏ¢
	if(PlayerOwner.Pawn != none)
	{
		DrawCommon(Canvas, PlayerOwner.Pawn);
	}
	else if(PlayerOwner.ViewTarget != none && PlayerOwner.IsInState('Spectating'))
	{
		//DrawCommon(Canvas, Pawn(PlayerOwner.ViewTarget));
		//Èç¹ûÊÇ¹Û²ìÕß£¬ÄÇÃ´
		DrawTargetRoleBaseInfo(Canvas, KFXPawn(PawnOwner));
	}
}

    if (  KFXPawn(PlayerOwner.ViewTarget)!= none
      && !KFXPlayer(PlayerOwner).bBehindView
	  && KFXPlayer(PlayerOwner).SpectateHook != none
	  && KFXPlayer(PlayerOwner).SpectateHook.CurSpectateWeap != none
      && !KFXPlayer(PlayerOwner).IsGameRecorderPlaying())
    {
        KFXPlayer(PlayerOwner).SpectateHook.CurSpectateWeap.DrawWeaponInfo(Canvas);
    }
if(_HUD_NEW_ == 1)
{
	//»­À×´ï
	if ( KFXPlayer(PlayerOwner).bKFXKeyOfRadar )
	{
		if(PlayerOwner.Pawn != none)
		{
			DrawSomeoneRadar(Canvas, KFXPawn(PlayerOwner.Pawn));
			DrawSomeoneDomain(Canvas, KFXPawn(PlayerOwner.Pawn));
		}
		else if(PlayerOwner.ViewTarget != none && PlayerOwner.IsInState('Spectating'))
		{
  // Èç¹ûviewTargetÊÇµÐÈË£¬Ôò²»ÏÔÊ¾À×´ï
 //add by jinxin 2011-12-27  ÏÈÐ£Ñé
          if(KFXPawn(PlayerOwner.ViewTarget).GetPRI().Team.TeamIndex == PlayerOwner.PlayerReplicationInfo.Team.TeamIndex)
          {
			DrawSomeoneRadar(Canvas, KFXPawn(PlayerOwner.ViewTarget));
			DrawSomeoneDomain(Canvas, KFXPawn(PlayerOwner.ViewTarget));
          }

		}
		//»æÖÆµØÀíÎ»ÖÃ
	}
}
	//»æÖÆÐÄÌø¸ÐÓ¦Æ÷
	DrawProbe(Canvas, KFXPawn(PawnOwner));

    // »­¹Ò»úÐÅÏ¢
    //DrawHanging(Canvas);

    // »­Íæ¼ÒÍ·ÉÏÃû×Ö
    //DrawName(Canvas);

    //»­Ö¸ÏòµÄÄ¿±êµÄÃû×Ö
    DrawTargetName(Canvas);


if(_HUD_NEW_ == 2 || _HUD_NEW_ == 1)
{
	PlayerOwner.Player.GUIController.SetHUDData_ScoreNTime();
}

if(_HUD_NEW_ == 1)
{
    // »­¶¥¶Ëµ¹¼ÆÊ±ºÍÕ½¼¨
    DrawTime(Canvas);

	//»­¼Ç·ÖÅÆÏÂÃæ¸÷¶ÓÈËÊý
    DrawTeamPlayerCount(Canvas);
}
    // »­½ø¶ÈÌõ
    DrawProgress(Canvas);

if(_HUD_NEW_ == 1)
{
    // »­ÌáÊ¾ÐÅÏ¢
    //DrawMessage(Canvas);//¶¼¶¨Ïòµ½ClewMessageÁË

    // »­Õ½¶·ÐÅÏ¢
    if(bDrawCombatMsg)    //ÊÇ·ñÏÔÊ¾ÓÒÉÏ½Ç»÷É±ÐÅÏ¢
    {
        DrawCombatMessage(Canvas);
    }

	//»­ÎäÆ÷ÌáÊ¾ÐÅÏ¢
	if(PlayerOwner.Pawn != none)
	{
	 	DrawMyWeaponTip(Canvas, PlayerOwner.Pawn);
	}
	else if(PlayerOwner.ViewTarget != none && PlayerOwner.IsInState('Spectating'))
	{
		//DrawMyWeaponTip(Canvas, Pawn(PlayerOwner.ViewTarget));
	}

    //»­Ê¹ÓÃµÀ¾ßÐÅÏ¢
    //DrawUseItemMessage(Canvas);

    // »­¼¤ÀøÐÅÏ¢, wangkai
    DrawEncourageInfo(Canvas);

	DrawHitInfo(Canvas);	//»­ÏûÃðÍ³¼Æ
//
    DrawBuyWeaponTip(Canvas);
}
    // »­ÁÄÌìÏà¹Ø
    DrawInGameChat(Canvas);

	//»æÖÆ¹Û²ìÕßÄ£Ê½ÏÂ£¬¸÷¶ÓÎéµÄÐÅÏ¢
	if(bDrawTeamMembers)
		DrawTeamMembersInfo(Canvas, PlayerOwner.ViewTarget != none && PlayerOwner.IsInState('Spectating') && !KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bSpectatorView);

    // Draw clew messages
    // Added by Linsen
    // 2008-3-1
if(_HUD_NEW_ == 1)
{
    DrawClewMessage(Canvas);
}

if(_HUD_NEW_ == 1)
{
    if(bDrawWapMap && PawnOwner != none)
    {
    	Do_DrawWarMap(Canvas, PawnOwner);
    }
}
    //<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 1.16
    //DrawDolbyHUD(Canvas, 0);
    //>>

	//liubo »­×ßÂíµÆ
    //DrawMarquee(Canvas, PlayerOwner.Level.TimeSeconds);

    DrawCollectedEnemyMsgs(Canvas);


	//»æÖÆÉËÑªÐ§¹û
	DrawHurtEffects(Canvas);
	if(bDrawBloodMessage)
	{
        if(FlyingFiftyBloodNum > 0)
        {
            DrawFlyFiftyBloodPic(Canvas);
        }
        if(FlyingTenBloodNum > 0)
        {
            DrawFlyTenBloodPic(Canvas);
        }

        DrawRankedFiftyBlood(Canvas);
        DrawRankedTenBlood(Canvas);
        GatherBloodMessage();
        DrawFlyingOneKillMessage(Canvas);
    }

    DrawFlyingItem(Canvas);
    return;
}

function DrawHurtEffects(Canvas canvas)
{
	local KFXPlayer LocalPC;
	local bool use_evil;
	LocalPC = KFXPlayer(PlayerOwner);
	use_evil = LocalPC.life_style>0 && LocalPC.life_hurt_pic.mat!=none
				&& LocalPC.life_hurt_pic.valid;
	if(use_evil && Level.TimeSeconds-LocalPC.time_be_hitted < 3)
	{
  		Canvas.Reset();
  		Canvas.bForceAlpha = true;
  		Canvas.ForcedAlpha = 1.0-(Level.TimeSeconds-LocalPC.time_be_hitted)/3;
  		Canvas.SetPos(0, 0);
  		Canvas.DrawTile(LocalPC.life_hurt_pic.mat,
		  	Canvas.SizeX, Canvas.SizeY,
		  	LocalPC.life_hurt_pic.u,
			LocalPC.life_hurt_pic.v,
			LocalPC.life_hurt_pic.ul,
			LocalPC.life_hurt_pic.vl);
  		Canvas.bForceAlpha = false;
	}
}
//»æÖÆÈËÎïÊÇ·ñ¿ÉÒÔ¹ºÂò
function DrawBuyWeaponTip(Canvas canvas)
{
	if(KFXPlayer(PlayerOwner).KFXCanShowWeapChangePage())
	{
    	KFXDrawXMLTileInfo(Canvas, KFXShopSignal);
	}
}

//»æÖÆÊÕ¼¯µ½µÄµÐÈËÐÅÏ¢
function DrawCollectedEnemyMsgs(Canvas canvas)
{

}
function DrawTeamMembersInfo(Canvas canvas, bool IsSp)
{
	//»ñµÃËùÓÐÈËµÄÐÅÏ¢
	//·Ö¼ì³ö×Ô¼º¶ÓÎéºÍÆäËû¶ÓÎé

	//ui:ÉèÖÃÄÚÈÝ£¬°´ÕÕ¹æÔò½øÐÐÅÅÐò£¬ÏÔÊ¾£¬ÉèÖÃÊÇ·ñÄÜ¹»½ÓÊÜÊÂ¼þ£¬
	local Pawn p;
	local KFXGameReplicationInfo GRI;
	local int i;
	local int TeamIdx;

	if(IsInspectating != IsSp)
	{
		IsInspectating = IsSp;
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
		//×öÒ»´ÎÇÐ»»
//		if(IsInspectating)
//			PlayerOwner.Player.GUIController.OpenGamePage("KFXHUDTeamMembersInfo");
//		else
//			PlayerOwner.Player.GUIController.CloseGamePage("KFXHUDTeamMembersInfo");
}
	}
	if(IsInspectating)
	{
		//»æÖÆÓÎÏ·logo
		KFXDrawXMLTileInfo(Canvas, KFXGameLogo);
	}
	if(!IsInspectating)
	{
     	GUIController(PlayerOwner.Player.GUIController).SetTeamMemberState(-1);
	}
	else if(Level.TimeSeconds - timecounter > 1.0f)	//Ã¿Ãë¸üÐÂÒ»´Î£¬²»Ã¿Ö¡¶¼¸üÐÂ°É

	{
		timecounter = Level.TimeSeconds;
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
		//PlayerOwner.Player.GUIController.SetHUDData_DeathView(KFXGameReplicationInfo(PlayerOwner.GameReplicationInfo).bEnableEnemyAngle);
}
else
{
		//Ã»ÃëÉèÖÃÒ»ÏÂÐÅÏ¢
		GUIController(PlayerOwner.Player.GUIController).BeginSetTeamMemberInfo();
		if(KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).IsRedTeam())
			TeamIdx = 1;
		else
			TeamIdx = 0;
		GUIController(PlayerOwner.Player.GUIController).SetTeamMemberParams(
					KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).fxPlayerDBID,
					PlayerOwner.PlayerReplicationInfo.Team.TeamIndex,
					KFXGameReplicationInfo(PlayerOwner.GameReplicationInfo).bEnableEnemyAngle);
		foreach AllActors(class'Pawn', P)
		{
			if(!p.IsInState('Dying'))
			{
				if(KFXPlayerReplicationInfo(p.PlayerReplicationInfo).IsRedTeam())
					TeamIdx = 1;
				else
					TeamIdx = 0;

		 		GUIController(PlayerOwner.Player.GUIController).AddTeamMemberInfo(
				 		p.PlayerReplicationInfo.Team.TeamIndex,
						KFXPlayerREplicationInfo(p.PlayerReplicationInfo).fxPlayerDBID,
						p.PlayerReplicationInfo.PlayerName,
						KFXPlayerReplicationInfo(p.PlayerReplicationInfo).fxKills,
						KFXPlayerReplicationInfo(p.PlayerReplicationInfo).fxDeaths,
						KFXPlayerReplicationInfo(p.PlayerReplicationInfo).fxCurrWeaponID,
						p.Health,
						false,     //KFXBombPawn(p).bHadCFour,ÆÕÍ¨Ä£Ê½ÏÂÃ»ÓÐC4
						true);
			}
		}
		GRI = GetGRI();
		for(i=0; i<GRI.PRIArray.length; i++)
		{
			if(KFXPlayerReplicationInfo(GRI.PRIArray[i]).bDeadStatus)
			{
				if(KFXPlayerReplicationInfo(GRI.PRIArray[i]).IsRedTeam())
					TeamIdx = 1;
				else
					TeamIdx = 0;

				GUIController(PlayerOwner.Player.GUIController).AddTeamMemberInfo(
	            	GRI.PRIArray[i].Team.TeamIndex,
	            	KFXPlayerReplicationInfo(GRI.PRIArray[i]).fxPlayerDBID,
	            	GRI.PRIArray[i].PlayerName,
	            	KFXPlayerReplicationInfo(GRI.PRIArray[i]).fxKills,
	            	KFXPlayerReplicationInfo(GRI.PRIArray[i]).fxDeaths,
	            	0,
	            	0,
					false,
					true);
			}
		}
		GUIController(PlayerOwner.Player.GUIController).EndSetTeamMemberInfo();
}
	}
}


function GotSetAndImage(string imageset, out string set, out string oimage)
{
 	local int conon;
 	conon = InStr(imageset, ":");
 	imageset = Right(imageset, Len(imageset)-conon-1);
  	set = Left(imageset, InStr(imageset, " "));
 	conon = InStr(imageset, ":");
 	if(conon >= 0)
 	{
		oimage = Right(imageset, Len(imageset)-conon-1);
	}
	else
	{
		set = "";
		oimage = "";
	}
}
//»æÖÆÎäÆ÷ÌáÊ¾¹¦ÄÜ
simulated function DrawMyWeaponTip(Canvas Canvas, Pawn CurViewer)
{
	local int nTmpID;
	local int nMainWeaponID, nSecondWeaponID, nKnifeID;
	local KFXXMLTileInfo	tmptile;
    local float delta;
    local Inventory inv;
    local float tOrigX, tOrigY, tOrigXL, tOrigYL;
	local KFXCSVTable csvWeaponMedia;
	local string tMatName;
	local string tMatSet, tMatImage;

    csvWeaponMedia = class'KFXTools'.static.GetConfigTable(10);

    if(csvWeaponMedia == none)
    	return;
   	if(CurViewer == none)
   		return;

	delta = Level.TimeSeconds - ChangeWeaponMessage.nUpdateTime;
	if(delta > 3)
		return;
	for(inv = CurViewer.Inventory; inv != none; inv = inv.Inventory)
	{
			if(KFXWeapBase(inv) != none)
			{
				nTmpID = KFXWeapBase(inv).KFXGetWeaponID() >> 16;
				if(nTmpID >= 1 && nTmpID <= 30 && nMainWeaponID == 0)
					nMainWeaponID = KFXWeapBase(inv).KFXGetWeaponID();
				else if(nTmpID >= 31 && nTmpID <= 40 && nSecondWeaponID == 0)
					nSecondWeaponID = KFXWeapBase(inv).KFXGetWeaponID();
				else if(nTmpID >= 41 && nTmpID <= 50 && nKnifeID == 0)
					nKnifeID = KFXWeapBase(inv).KFXGetWeaponID();
			}
	}

	if(csvWeaponMedia.SetCurrentRow(nMainWeaponID))
	{
		tMatName = csvWeaponMedia.GetString("HUDRes_Main");
		GotSetAndImage(tMatName, tMatSet, tMatImage);
		if(tMatSet != "" && tMatSet != "")
			Canvas.KFXLoadXMLMaterial(tMatSet, tMatImage, tOrigX, tOrigY, tOrigXL, tOrigYL);
		KFXMainWeaponPic.szImageSet = tMatSet;
		KFXMainWeaponPic.szImage = tMatImage;
		KFXMainWeaponPic.OrigX = tOrigX;
		KFXMainWeaponPic.OrigY = tOrigY;
		KFXMainWeaponPic.ClipX = tOrigXL;
		KFXMainWeaponPic.ClipY = tOrigYL;
		KFXMainWeaponPic.ForcedAlpha = 1;
		KFXMainWeaponPic.Active = true;
	}
	else
	{
		KFXMainWeaponPic.Active = false;
	}
	if(csvWeaponMedia.SetCurrentRow(nSecondWeaponID))
	{
		tMatName = csvWeaponMedia.GetString("HUDRes_Main");
		GotSetAndImage(tMatName, tMatSet, tMatImage);
		if(tMatSet != "" && tMatSet != "")
			Canvas.KFXLoadXMLMaterial(tMatSet, tMatImage, tOrigX, tOrigY, tOrigXL, tOrigYL);
		KFXSecondWeaponPic.szImageSet = tMatSet;
		KFXSecondWeaponPic.szImage = tMatImage;
		KFXSecondWeaponPic.OrigX = tOrigX;
		KFXSecondWeaponPic.OrigY = tOrigY;
		KFXSecondWeaponPic.ClipX = tOrigXL;
		KFXSecondWeaponPic.ClipY = tOrigYL;
		KFXSecondWeaponPic.ForcedAlpha = 1;
		KFXSecondWeaponPic.Active = true;
	}
	else
	{
		KFXSecondWeaponPic.Active = false;

	}
	if(csvWeaponMedia.SetCurrentRow(nKnifeID))
	{
		tMatName = csvWeaponMedia.GetString("HUDRes_Main");
		GotSetAndImage(tMatName, tMatSet, tMatImage);
		if(tMatSet != "" && tMatSet != "")
			Canvas.KFXLoadXMLMaterial(tMatSet, tMatImage, tOrigX, tOrigY, tOrigXL, tOrigYL);
		KFXKnifePic.szImageSet = tMatSet;
		KFXKnifePic.szImage = tMatImage;
		KFXKnifePic.OrigX = tOrigX;
		KFXKnifePic.OrigY = tOrigY;
		KFXKnifePic.ClipX = tOrigXL;
		KFXKnifePic.ClipY = tOrigYL;
		KFXKnifePic.ForcedAlpha = 1;
		KFXKnifePic.Active = true;
	}
	else
	{
		KFXKnifePic.Active = false;
	}

	if(delta < 1)
	{
		if(csvWeaponMedia.SetCurrentRow(ChangeWeaponMessage.nWeaponID))
		{
			//¶¯×÷Ð§¹ûµÄÊ±ºò£¬¸Ä³É¸ßÁÁ
			tMatName = csvWeaponMedia.GetString("HUDRes_HeightLight");
			GotSetAndImage(tMatName, tMatSet, tMatImage);
			if(tMatSet != "" && tMatSet != "")
				Canvas.KFXLoadXMLMaterial(tMatSet, tMatImage, tOrigX, tOrigY, tOrigXL, tOrigYL);
			tmptile.szImageSet = tMatSet;
			tmptile.szImage = tMatImage;
			tmptile.OrigX = tOrigX;
			tmptile.OrigY = tOrigY;
			tmptile.ClipX = tOrigXL;
			tmptile.ClipY = tOrigYL;
		}
		else
		{
			log("#### WARNING #### can't find changed weapon! weaponid="$ChangeWeaponMessage.nWeaponID);
			return;
		}
		if(ChangeWeaponMessage.nWeaponID == nMainWeaponID)
		{
			tmptile.PosX = KFXMainWeaponPic.PosX;
			tmptile.PosY = KFXMainWeaponPic.PosY;
			tmptile.LengthX = KFXMainWeaponPic.LengthX;
			tmptile.LengthY = KFXMainWeaponPic.LengthY;
			tmpTile.ForcedAlpha = KFXMainWeaponPic.ForcedAlpha;
			tmpTile.Active = KFXMainWeaponPic.Active;
			tmpTile.Pivot = KFXMainWeaponPic.Pivot;
			if(delta < 1)
			{
				tmpTile.PosX -= -4.0*delta*(delta-1)*20;
				//tmpTile.PosX -= (-(delta-0.5)*(delta-0.5)+1) * 50;	//Ò»ÌõÇúÏß£¬·ÇÏßÐÔ
			}
			else
			{
				tmpTile.ForcedAlpha = (-0.5*delta+1.5);
			}
			KFXDrawXMLTileInfo(Canvas, tmpTile);
			if(delta <1)
			{
				tmpTile = KFXSecondWeaponPic;
				tmpTile.PosX += -4.0*delta*(delta-1)*20;
				KFXDrawXMLTileInfo(Canvas, tmpTile);
				tmpTile = KFXKnifePic;
				tmpTile.PosX += -4.0*delta*(delta-1)*20;
				KFXDrawXMLTileInfo(Canvas, tmpTile);
			}
			else
			{
            	KFXSecondWeaponPic.ForcedAlpha = (-0.5*delta+1.5);
            	KFXDrawXMLTileInfo(Canvas, KFXSecondWeaponPic);
            	KFXKnifePic.ForcedAlpha = (-0.5*delta+1.5);
            	KFXDrawXMLTileInfo(Canvas, KFXKnifePic);
			}
		}
		else if(ChangeWeaponMessage.nWeaponID == nSecondWeaponID)
		{
			tmptile.PosX = KFXSecondWeaponPic.PosX;
			tmptile.PosY = KFXSecondWeaponPic.PosY;
			tmptile.LengthX = KFXSecondWeaponPic.LengthX;
			tmptile.LengthY = KFXSecondWeaponPic.LengthY;
			tmpTile.ForcedAlpha = KFXSecondWeaponPic.ForcedAlpha;
			tmpTile.Active = KFXSecondWeaponPic.Active;
			tmpTile.Pivot = KFXSecondWeaponPic.Pivot;

			if(delta < 1)
			{
				tmpTile.PosX -= -4.0*delta*(delta-1)*20;
				//tmpTile.PosX -= (-(delta-0.5)*(delta-0.5)+1) * 50;	//Ò»ÌõÇúÏß£¬·ÇÏßÐÔ
			}
			else
			{
				tmpTile.ForcedAlpha = (-0.5*delta+1.5);
			}
			KFXDrawXMLTileInfo(Canvas, tmpTile);
			if(delta <1)
			{
				tmpTile = KFXMainWeaponPic;
				tmpTile.PosX += -4.0*delta*(delta-1)*20;
				//tmpTile.PosX += (-(delta-0.5)*(delta-0.5)+1) * 20;	//Ò»ÌõÇúÏß£¬·ÇÏßÐÔ
				KFXDrawXMLTileInfo(Canvas, tmpTile);
				tmpTile = KFXKnifePic;
				tmpTile.PosX += -4.0*delta*(delta-1)*20;
				//tmpTile.PosX += (-(delta-0.5)*(delta-0.5)+1) * 20;	//Ò»ÌõÇúÏß£¬·ÇÏßÐÔ
				KFXDrawXMLTileInfo(Canvas, tmpTile);
			}
			else
			{
            	KFXMainWeaponPic.ForcedAlpha = (-0.5*delta+1.5);
            	KFXDrawXMLTileInfo(Canvas, KFXMainWeaponPic);
            	KFXKnifePic.ForcedAlpha = (-0.5*delta+1.5);
            	KFXDrawXMLTileInfo(Canvas, KFXKnifePic);
			}
		}
		else if(ChangeWeaponMessage.nWeaponID == nKnifeID)
		{
			tmptile.PosX = KFXKnifePic.PosX;
			tmptile.PosY = KFXKnifePic.PosY;
			tmptile.LengthX = KFXKnifePic.LengthX;
			tmptile.LengthY = KFXKnifePic.LengthY;
			tmpTile.ForcedAlpha = KFXKnifePic.ForcedAlpha;
			tmpTile.Active = KFXKnifePic.Active;
			tmpTile.Pivot = KFXKnifePic.Pivot;
			if(delta < 1)
			{
				tmpTile.PosX -= -4.0*delta*(delta-1)*20;
				//tmpTile.PosX -= (-(delta-0.5)*(delta-0.5)+1) * 50;	//Ò»ÌõÇúÏß£¬·ÇÏßÐÔ
			}
			else
			{
				tmpTile.ForcedAlpha = (-0.5*delta+1.5);
			}
			KFXDrawXMLTileInfo(Canvas, tmpTile);
			if(delta <1)
			{
				tmpTile = KFXMainWeaponPic;
				tmpTile.PosX += -4.0*delta*(delta-1)*20;
				KFXDrawXMLTileInfo(Canvas, tmpTile);
				tmpTile = KFXSecondWeaponPic;
				tmpTile.PosX += -4.0*delta*(delta-1)*20;
				KFXDrawXMLTileInfo(Canvas, tmpTile);
			}
			else
			{
            	KFXMainWeaponPic.ForcedAlpha = (-0.5*delta+1.5);
            	KFXDrawXMLTileInfo(Canvas, KFXMainWeaponPic);
            	KFXSecondWeaponPic.ForcedAlpha = (-0.5*delta+1.5);
            	KFXDrawXMLTileInfo(Canvas, KFXSecondWeaponPic);
			}
		}
		else
		{
			KFXDrawXMLTileInfo(Canvas, KFXMainWeaponPic);
			KFXDrawXMLTileInfo(Canvas, KFXSecondWeaponPic);
			KFXDrawXMLTileInfo(Canvas, KFXKnifePic);
			log("#### ERROR #### can't find this weapon type"@ChangeWeaponMessage.nWeaponID);
			return;
		}

	}
	else if(delta < 3)	//´óÓÚ3ÃëÖÓºó²»ÏÔÊ¾
	{
		//½¥±äÏÔÊ¾
		KFXMainWeaponPic.ForcedAlpha = (-0.5*delta+1.5);
		KFXDrawXMLTileInfo(Canvas, KFXMainWeaponPic);

		KFXSecondWeaponPic.ForcedAlpha = (-0.5*delta+1.5);
		KFXDrawXMLTileInfo(Canvas, KFXSecondWeaponPic);

		KFXKnifePic.ForcedAlpha = (-0.5*delta+1.5);
		KFXDrawXMLTileInfo(Canvas, KFXKnifePic);
	}
	//Èç¹ûÓÎÏ·ÎäÆ÷Ã»ÓÐ£¬ÄÇÃ´»­Ò»²ãÃÉ°æ»òÕß»òÕß²æÖ®Àà¡£
}

simulated function DrawMarquee(Canvas canvas, float currTime)
{
	if(prados.length > 0){
		if(marquee!=none && marquee.isRunning()){
    		//»­marquee£¬µ±marquee½áÊøÊ±£¬½øÐÐÒ»Ð©²Ù×÷
	    	if(!marquee.draw(canvas, currTime))
				prados.Remove(0, 1);
		}else{
			marquee.reInit();
			marquee.setDy(pradoPic1, pradoPic2, pradoWait);
			marquee.setPos(208, 67, 760, 75);
			marquee.setColor(prados[0].nType-9);
			marquee.set(canvas, prados[0].content, PlayerOwner.Level.TimeSeconds, pradoNeedTime);

		}
	}
}

exec function myPradoTime(float i, float j, float k, float m)
{
	pradoNeedTime = i;
	pradoPic1 = j;
	pradoPic2 = k;
	pradoWait = m;

	if(i == 0)
		pradoNeedTime = 9;
	if(j == 0)
		pradoPic1 = 0;
	if(k == 0)
		pradoPic2 = 2;
	if(m == 0)
		pradoWait = 1;
}

exec function myPrado2(string sName, int nCityCode, string words, int nCode)
{
	if(words == "")
		words = lClewReborn$lClewReborn;
	addPrado(sName, nCityCode, words, nCode);
	ChatMessageOutGame(sName,words, nCode, 10101, 1);
}
exec function myPrado()
{
	prados.Insert(prados.length, 1);
	prados[prados.length - 1].content = "abcdefghijklmnopqrstuvwxyzabcdefghijklmno";
}
exec function stopMarquee()
{
	marquee.doStop();
}


simulated function KFXDrawMap2F(Canvas Canvas, Pawn CurViewer)
{
	if(CurViewer == none)
		return;
    //»­Õ½ÊõµØÍ¼ÐÅÏ¢
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.SetPos(112*Canvas.SizeX/1024.0 , 84*Canvas.SizeY/768.0 );
//    if(CurViewer.Location.z<WarMap.Map2FHigh)
//    {
		//Èç¹û×Ô¼ºµÄ¶ÓÎéÔÚµØÍ¼µÄÉÏ·½£¬ÄÇÃ´Ðý×ªµØÍ¼£¬Ê¹µÃ×Ô¼ºÔÚÏÂ·½ÏÔÊ¾
		if(CurViewer.PlayerReplicationInfo.Team.TeamIndex == WarMap.TopTeam)
			WarMap.RotMaterial.Rotation.Yaw = 65536 / 2;
		else
			WarMap.RotMaterial.Rotation.Yaw = 0;

        Canvas.DrawTile( WarMap.RotMaterial, 800*Canvas.SizeX/1024.0,
            600*Canvas.SizeY/768.0, 112, 212,800, 600 );
        if(KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).IsBlueTeam())
        {
	        Canvas.SetPos(WarMap.BlueTeamPos[0], WarMap.BlueTeamPos[1]);
		}
		else if(KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).IsRedTeam())
		{
		    Canvas.SetPos(WarMap.RedTeamPos[0], WarMap.RedTeamPos[1]);
		}
//    }
//    else
//    {
//        Canvas.DrawTile( WarMap.Material2F, 800*Canvas.SizeX/1024.0,
//            600*Canvas.SizeY/768.0, 112, 212,800, 600 );
//    }
}

function GetGameChatPos(Canvas Canvas, out float posY, out EDrawPivot pv)
{
	posY = Canvas.SizeY - 160 - 16;
	pv = DP_UpperLeft;
}
function GetTypeGameChatPos(Canvas Canvas, out float posY, out EDrawPivot pv)
{
	posY = Canvas.SizeY - 160 - 16;
	pv = DP_UpperLeft;
}
// »­ÁÄÌìÏà¹Ø
simulated function DrawInGameChat(Canvas Canvas)
{
    // »­ÁÄÌìÐÅÏ¢
    DisplayMessages(Canvas);

    // »­ÊäÈë×Ö·û
    if( PlayerConsole != none && PlayerConsole.bTyping )
    {
        DrawTypingPrompt(Canvas, PlayerConsole.TypedStr, PlayerConsole.TypedStrPos);

        //°ïÖúÏûÏ¢
        if (!bNotShowChatClew)
        {
            KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(54), true,, 3, 2);
            bNotShowChatClew = true;
        }
    }
}

// »­WeaponÐÅÏ¢
simulated function DrawWeaponInfo(Canvas Canvas)
{
    if (PawnOwner.Weapon != none)
    {
    	//»æÖÆ×¼ÐÇºÍ×Óµ¯Ê£ÓàÇé¿ö
        PawnOwner.Weapon.DrawWeaponInfo(Canvas);
    }
}
simulated function KFXDrawKnifeCanAttack(Canvas Canvas,int index)
{

     if(bDrawKnifeAttack)
     {
         if(index == 0)
         {
              KFXDrawXMlTileInfo(Canvas,KFXKnifeCannotAttack);
         }
         else if(index == 1)
         {
             KFXDrawXMlTileInfo(Canvas,KFXKnifeLeftCanAttack);
         }
         else if(index == 2)
         {
             KFXDrawXMlTileInfo(Canvas,KFXKnifeRightCanAttack);
         }
         else if(index == 3)
         {
             KFXDrawXMlTileInfo(Canvas,KFXKnifeBothCanAttack);
         }
     }
}
simulated function KFXDrawBulletPic(Canvas canvas)
{
	local int nscale;	//[0, 15](step=1)
	//local int alpha;
	//local float alphaTime;
	local KFXWeapBase weap;


	if(!KFXPlayer(PlayerOwner).bShowBulletPic)
	{
		return;
	}

	weap = KFXWeapBase(PawnOwner.Weapon);

	if(weap.KFXGetReloadMax() == 0)
	{
	    nscale = 150;
	    if(weap.KFXGetReload() == 0)
	    	nscale = 0;
	}
	else
	{
		nscale = int(weap.KFXGetReload()*150.0 / weap.KFXGetReloadMax() + 0.5);
		if(nscale == 0 && weap.KFXGetReload() != 0)	//1%~10%¾ùËã10%
			nScale = 10;
		if(nscale > 150)
			nscale = 150;
	}

	//Ð¡¾ÖÄ£Ê½¿ÉÄÜÓÐÎÊÌâ
	if(weap.bIsReload)
	{
		oldBulletNum++;
		Canvas.SetPos(467, 410);
		Canvas.KFXSetPivot(DP_MiddleMiddle);
		Canvas.SetDrawColor(255, 255, 255, 255);
		//if(oldBulletNum % 40 < 20)
		//{
	  		Canvas.KFXDrawXMLTile("mat2_HUD_bullet", "NewImage"$(nscale/10), true, 91, 30);
		//}
		//else
		//{
	  		//Canvas.KFXDrawXMLTile("mat2_HUD_bullet", "NewImage"$(100/10), true, 91, 30);
		//}
		if(weap.IsFiring())
			bHasShot = true;
	}
	else
	{
		oldBulletNum = 0;
		bHasShot = false;
		Canvas.SetPos(467, 410);
		Canvas.KFXSetPivot(DP_MiddleMiddle);
		Canvas.SetDrawColor(255, 255, 255, 255);
  		Canvas.KFXDrawXMLTile("mat2_HUD_bullet", "NewImage"$(nscale/10), true, 91, 30);
	}
}
// »­¶¥²¿µ¹¼ÆÊ±ºÍÕ½¼¨
simulated function DrawTime(Canvas Canvas)
{
    if(KFXPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bSpectatorView)
    {
        return;
    }

    // Ò»°ãÓÃ°×É«·ç¸ñ
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, 255);

    KFXDrawXMLTileInfo(Canvas, KFXTimeFrameNormal);

    DrawWeAndEnemy( Canvas );
}
simulated function DrawTimeInSpectating(Canvas Canvas)
{
    // Ò»°ãÓÃ°×É«·ç¸ñ
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, 255);

    KFXDrawXMLTileInfo(Canvas, KFXTimeFrameNormal);

    DrawWeAndEnemy( Canvas );
}
function DrawTeamPlayerCount(Canvas canvas)
{

}

// µÐÎÒ±êÊ¶
simulated function DrawWeAndEnemy( Canvas Canvas )
{
//    if( KFXPlayer(PlayerOwner).IsBlueTeam() )
//    {
//        Canvas.SetPos(KFXOurPartBlue.PosX , KFXOurPartBlue.PosY);
//        KFXDrawTile(Canvas, KFXOurPartBlue);
//
//        Canvas.SetPos(KFXEnemyRed.PosX , KFXEnemyRed.PosY);
//        KFXDrawTile(Canvas, KFXEnemyRed);
//    }
//    else if( KFXPlayer(PlayerOwner).IsRedTeam() )
//    {
//
//        Canvas.SetPos(KFXEnemyBlue.PosX , KFXEnemyBlue.PosY);
//        KFXDrawTile(Canvas, KFXEnemyBlue);
//
//        Canvas.SetPos(KFXOurPartRed.PosX , KFXOurPartRed.PosY);
//        KFXDrawTile(Canvas, KFXOurPartRed);
//    }

}
//»­¹Û²ì¶ÔÏóµÄ»ù±¾ÐÅÏ¢£¬»­Ãû×Ö¡¢kd¡¢ph¡¢ÎäÆ÷
function DrawTargetRoleBaseInfo(Canvas Canvas, KFXPawn CurViewer)
{
	local int weaponID;
	local string str;
	local float xpos, ypos;
	local float xl, yl;
	local KFXCSVTable csvWeaponMedia;
	local string strSet, strImg;


	if(CurViewer == none)
		return;

	//CurViewer.PlayerReplicationInfo.PlayerName;
	weaponID = KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxCurrWeaponID;
	//CurViewer.Health
	//KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxKills;
	//KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxDeaths;

	Canvas.Reset();
	Canvas.KFXSetPivot(DP_LowerMiddle);

	//»­±³¾°Í¼
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(309, 694);
	Canvas.KFXDrawXMLTile("mat2_deathviewpage", "NewImage4", true, 440, 65);

	if(kdpawn != CurViewer)
	{
		kdpawn = CurViewer;
		kdcount = level.TimeSeconds;
	}
	//»­ KDÖµ
	if(level.TimeSeconds - kdcount < 3.0)
	{
		xpos = 446;
		ypos = 679;
		Canvas.SetPos(xpos, ypos);
		Canvas.KFXFontAlias = "heavytiny14";
		Canvas.SetDrawColor(0, 0, 0, 255);
		str = "KILL/";
		Canvas.KFXDrawStr("KILL/");
		Canvas.KFXStrLen(str, xl, yl);
		xpos += xl;
		Canvas.SetPos(xpos, ypos);
		Canvas.SetDrawColor(255, 255, 255, 255);
		str = ""$KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxKills;
		Canvas.KFXDrawStr(str);

		xpos = 513;
		ypos = 679;
		Canvas.SetDrawColor(0, 0, 0, 255);
		str = "DEATH/";
		Canvas.SetPos(xpos, ypos);
		Canvas.KFXDrawStr(str);
		Canvas.KFXStrLen(str, xl, yl);
		xPos += xl;
		Canvas.SetPos(xpos, ypos);
		Canvas.SetDrawColor(255, 255, 255, 255);
		str = ""$KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxDeaths;
		Canvas.KFXDrawStr(str);
	}


    //»­½ÇÉ«Ãû
	xpos = 462;
	ypos = 697;
	xl = 96;
	yl = 16;
	Canvas.KFXFontAlias = "heavytiny16";
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.KFXDrawStrJustified(CurViewer.PlayerReplicationInfo.PlayerName,
				1,
				xPos, ypos, xPos+xl, yPos+yl);

    //»­ÑªÁ¿
	xpos = 405;
	ypos = 732;
	Canvas.SetPos(xpos, ypos);
	Canvas.KFXFontAlias = "heavytiny16";
	Canvas.SetDrawColor(0, 0, 0, 255);
	str = "HP:";
	Canvas.KFXDrawStr(str);
	xpos = 431;
	ypos = 726;
	Canvas.SetPos(xpos, ypos);
	Canvas.KFXFontAlias = "heavytiny24";
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.KFXDrawStr(""$CurViewer.Health);

    //»­ÎäÆ÷
	Canvas.SetPos(490, 716);
	Canvas.KFXDrawXMLTile("mat2_deathviewpage", "NewImage8", true, 137, 34);

	csvWeaponMedia = class'KFXTools'.static.GetConfigTable(10);
	if(csvWeaponMedia != none && csvWeaponMedia.SetCurrentRow(weaponID))
	{
		str = csvWeaponMedia.GetString("HUDRes_Kill");
		GotSetAndImage(str, strSet, strImg);
		if(strSet != "" && strImg != "")
		{
			Canvas.KFXLoadXMLMaterial(strSet, strImg, xpos, ypos, xl, yl);
			if(yl > 24)
			{
				xl *= 24 / yl;
				yl = 24;
			}
			if(xl > 79)
			{
				yl *= 79 / xl;
				xl = 79;
			}
			Canvas.SetPos(518+(79-xl)/2, 721+(24-yl)/2);
			Canvas.KFXDrawXMLTile(strSet, strImg, true, xl, yl);
		}
		str = csvWeaponMedia.GetString("Name");
		Canvas.KFXFontAlias = "heavytiny12";
		Canvas.KFXDrawStrJustified(str, 1, 509, 744, 588, 757);
	}
}
// »­³£¹æÐÅÏ¢
// DrawTileÓÃ·¨(²ÄÖÊ£¬ÏÔÊ¾¿í£¬ÏÔÊ¾¸ß£¬ÇÐÍ¼X£¬ÇÐÍ¼Y£¬ÇÐÍ¼¿í£¬ÇÐÍ¼¸ß)
simulated function DrawCommon(Canvas Canvas, Pawn CurViewer)
{
    //KFXDrawDangerInfo(Canvas);	//ÑªÁ¿Ð¡ÓÚ20µÄÊ±ºò£¬ÌáÐÑÍæ¼Ò
    DrawViewerName(Canvas, CurViewer);
    DrawPlayerTeam(Canvas, CurViewer);
    DrawACEInfo(Canvas, CurViewer);
    KFXDrawPlayerHP(Canvas, CurViewer);
    KFXDrawWeapon(Canvas, PlayerOwner.Pawn);	//»­×Óµ¯£¬ÒÔ¼°ÆØ¹âµ±Ç°ÎäÆ÷
    KFXDrawCardHUD(Canvas);
}
//»­¹Û²ì¶ÔÏóµÄÃû×Ö
function DrawViewerName(Canvas Canvas, Pawn CurViewer)
{
	if(CurViewer == none)
		return;
	if(CurViewer != PlayerOwner.Pawn)
	{
		Canvas.KFXSetPivot(DP_LowerLeft);

  		Canvas.SetPos(93, 691);
    	Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.KFXFontAlias = KFXBaseFontAlias;
   	 	Canvas.Style = ERenderStyle.STY_Normal;
  		Canvas.KFXDrawStr(CurViewer.PlayerReplicationInfo.PlayerName);

		Canvas.SetPos(93, 713);
		Canvas.KFXDrawXMLTile("mat2_HUD_interface", "NewImage16", true, 229, 3);

		Canvas.KFXSetPivot(DP_UpperLeft);
	}
}
//»­aceÐÅÏ¢
simulated function DrawACEInfo(Canvas Canvas, Pawn CurViewer)
{
	local int nPos;
	if(CurViewer == none)
		return;

	if(GetGRI().PRIArray[0] == CurViewer.PlayerReplicationInfo)
		nPos = 1;
	else if(GetGRI().PRIArray.length > 1 && GetGRI().PRIArray[1] == CurViewer.PlayerReplicationInfo)
		nPos = 2;
	else
		nPos = 0;


	if(nPos == 1 && GetGRI() != none
		&& KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxKills > 0)
	{
		//Èç¹ûÊÇµÚÒ»Ãû£¬¸ü»»Í¼Æ¬
		KFXACEInfo.szImageSet="mat2_HUD_interface";
		KFXACEInfo.szImage = "NewImage11";
		KFXTeamPicBlue.szImage = "NewImage18";
		KFXTeamPicRed.szImage = "NewImage92";
		KFXDrawXMLTileInfo(Canvas, KFXACEInfo);
		if(nACEPos != 1)
		{
			//ÉÏÒ»´Î²»ÊÇµÚÒ»Ãû£¬ÄÇÃ´²¥·ÅÒôÀÖ
		}
	}
	else if(nPos == 2 && GetGRI() != none
		&& KFXPlayerReplicationInfo(CurViewer.PlayerReplicationInfo).fxKills > 0)
	{
		//Èç¹ûÊÇµÚ¶þÃû£¬¸ü»»Í¼Æ¬
		KFXACEInfo.szImageSet="mat2_HUD_interface";
		KFXACEInfo.szImage = "NewImage88";
		KFXTeamPicBlue.szImage = "NewImage19";
		KFXTeamPicRed.szImage = "NewImage93";
		KFXDrawXMLTileInfo(Canvas, KFXACEInfo);
		if(nACEPos == 1)
		{
			//Èç¹ûÊÇÓÉµÚÒ»Ãûµôµ½µÚ¶þÃû
		}
		else if(nACEPos == 2)
		{
			//Èç¹ûÔ­À´¾ÍÊÇµÚ¶þÃû
		}
		else
		{
			//²¥·ÅÒôÀÖ
		}

	}
	else
	{
		KFXTeamPicBlue.szImage = "NewImage19";
		KFXTeamPicRed.szImage = "NewImage93";
	}
	nACEPos = nPos;
}
//»­Íæ¼ÒµÄ¶ÓÎé±êÊ¶ÐÅÏ¢»òÕßÕ½¶Ó±êÊ¶ÐÅÏ¢
simulated function DrawPlayerTeam(Canvas Canvas, Pawn CurViewer)
{
	local int suitID;
	local KFXCSVTable csvRoleClothes;

	if(CurViewer == none)
		return;
	//×¼±¸ÒÂ·þ
//	if(KFXPlayer(PlayerOwner).IsRedTeam())
//	{
		suitID = KFXPawn(CurViewer).KFXPendingState.nSuitID;
//	}
//	else
//	{
//		suitID = KFXPlayer(PlayerOwner).fxDBPlayerEquipList.Body[0];
//	}

	//Èç¹ûÃ»ÓÐ»ñÈ¡¹ýÕâÐ©×ÊÔ´£¬ÄÇÃ´»ñÈ¡¡£Èç¹û»ñÈ¡ÁË£¬ÄÇÃ´¾Í±£´æÆðÀ´¡£
	//ÒòÎªºÜ³¤Ê±¼ä¶¼ÊÇ»­Í¬Ò»¸ö×ÊÔ´£¬ËùÒÔ±£´æÊý¾ÝÒª±ÈÃ¿´Î¶¼¶¯Ì¬¶Á¸üºÃ
	if(CurrRoleIdentifyID != suitID)
	{
		csvRoleClothes = class'KFXTools'.static.KFXCreateCSVTable("KFXRoleClothesEx.csv");
		if(csvRoleClothes != none && csvRoleClothes.setCurrentRow(suitID))
		{
			KFXInitXMLTile(suitID, csvRoleClothes, CurrRoleIdentifyPic);
		}
		CurrRoleIdentifyID = suitID;
	}
	KFXDrawXMLTileInfo(Canvas, CurrRoleIdentifyPic);
//
//	if(CurViewer.PlayerReplicationInfo.Team != none && CurViewer.PlayerReplicationInfo.Team.TeamIndex == 0)
//	{
//		self.KFXDrawXMLTileInfo(Canvas, KFXTeamPicBlue);
//	}
//	else if(CurViewer.PlayerReplicationInfo.Team != none && CurViewer.PlayerReplicationInfo.Team.TeamIndex == 1)
//	{
//		KFXDrawXMLTileInfo(Canvas, KFXTeamPicRed);
//	}
//	else
//	{
//		KFXDrawXMLTileInfo(Canvas, KFXTeamPicBlue);	//¸öÈËÈüÖ®ÀàµÄ£¬ÔÝÊ±ÓÃÕâ¸ö¶¥Ìæ
//	}
}
simulated function KFXDrawCardHUD(Canvas Canvas)
{
    local KFXCardPack cardPack;
    cardPack = KFXPlayer(PlayerOwner).KFXGetCardPack();
    if( cardPack == none )
        return;
    if(PlayerOwner != none)
    {
        if(cardPack == none)
        {
            //LOG("[KFXCard] CardPack == NONE!!");
            return;
        }
        //LOG("[KFXCard] Draw in KFXHUD");
        CardPack.KFXDrawGameHUD(canvas,KFXPlayer(PlayerOwner));
    }
}

function KFXDrawDangerInfo(Canvas Canvas)
{
    local float timepast;

    // Ò»°ãÓÃ°×É«·ç¸ñ
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, 255);

    //»­Î£ÏÕÐÅÏ¢
    if((changedangerinfo==true&&PawnOwner!=none&&PawnOwner.Health < 20)||
        (changedangerinfo==false&&PawnOwner.Health > 19))
    {
        changedangerinfo=!changedangerinfo;
        dangerchangetime=level.TimeSeconds;
    }
    timepast=level.TimeSeconds-dangerchangetime;
    if(timepast<dangertime&&PawnOwner!=none&&PawnOwner.Health > 19&&PawnOwner.Health <80)
    {
        Canvas.bForceAlpha = true;
        KFXMatSrc = "fx_ui3_texs.hud_danger";
        Canvas.ForcedAlpha = ((dangertime-timepast)/dangertime);
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
            Canvas.SizeX,
            Canvas.SizeY,
            0, 0, 1024, 768 );
        Canvas.bForceAlpha = false;
        KFXStopSound(self,none);
    }
    else if(PawnOwner!=none&&PawnOwner.Health < 20&&PawnOwner.Health > 0)
    {
        Canvas.bForceAlpha = true;
        KFXMatSrc = "fx_ui3_texs.hud_danger";
        if(int(timepast)%2==1)
        {
            Canvas.ForcedAlpha = ((timepast-int(timepast)));
        }
        else
        {
            Canvas.ForcedAlpha = (1-(timepast-int(timepast)));
        }
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
            Canvas.SizeX,
            Canvas.SizeY,
            0, 0, 1024, 768 );
        Canvas.bForceAlpha = false;
        if(int(timepast*10)%35==0)
        {
            if(bSexUpdate)
            {
                if(KFXPawnBase(playerowner.Pawn).KFXPendingState.nRoleID % 2 == 0)
                    bFemale=true;
                else
                    bFemale=false;
                bSexUpdate=false;
            }
            if(bFemale)
            {
                PlaySound(Sound(DynamicLoadObject("fx_death_sounds.female_heart", class'Sound'))
                    ,,
                    0.7*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
                    700*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
            }
            else
            {
                PlaySound(Sound(DynamicLoadObject("fx_death_sounds.male_heart", class'Sound'))
                    ,,
                    1.0*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
                    900*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
            }
        }
    }

}


function KFXDrawPlayerHP(Canvas Canvas, Pawn CurViewer)
{
	local Inventory inv;
	local String weaponids;
	local int idx;
	if(CurViewer == none)
		return;

	//ÏÔÊ¾Õâ¸öÈËµÄÎäÆ÷
	for(inv = CurViewer.Inventory; inv != none; inv = inv.Inventory)
	{
		idx++;
		if(KFXWeapBase(Inv) != none)
		{
            weaponids $= ""$KFXWeapBase(Inv).KFXGetWeaponID()$"-"$idx$"  ";
		}
	}

	//»­hpÍ¼Æ¬
	KFXDrawXMLTileInfo(Canvas, KFXHPPic);

	//»­hpÖµ
	if(CurViewer.Health <= 25)
		Canvas.SetDrawColor(255, 0, 0, 255);
	else
		Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.Font = LoadFoxFont(3);
    KFXDrawNarrowText(Canvas, KFXHPValue, string(CurViewer.Health), 1);

	//apÖµ²»»­¹Û²ìÕßµÄ
	CurViewer = PlayerOwner.Pawn;
	if(CurViewer == none)
		return;

	//»­apÍ¼Æ¬
	KFXDrawXMLTileInfo(Canvas, KFXAPPic);
	//»­apÖµ
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.Font = LoadFoxFont(3);
	KFXDrawNarrowText(Canvas, KFXArmorValue, ""$KFXPawnBase(CurViewer).KFXArmorPoints, 1);
}
function bool IsKnife(int weapon_typeid)
{
	weapon_typeid = weapon_typeid>>16;
	return (weapon_typeid>=41 && weapon_typeid<=50);
}
function KFXDrawWeapon(Canvas Canvas, Pawn CurViewer)
{
    local int fxCurrAmmo;   // ×Óµ¯ÊýÁ¿
    local int fxMaxAmmo;    // ×î´óÊýÁ¿
    local string strCurAmmo;
    local string strMaxAmmo;
	local Inventory inv;
	local int count;
    local int nGrenade;
    local int nTmpGrenade;
    local int nTmpGrenadeCnt[3];	//ÈýÖÖÀ×¶ÔÓ¦µÄid
	local KFXCSVTable csvWeaponMedia;
	local string weaponname;
	local string weaponset, weaponimage;
	local float worigx, worigy, wlenx, wleny;

	if(CurViewer == none)
		return;

    Canvas.SetDrawColor(255, 255, 255, 255);

    if( CurViewer!=none&& CurViewer.Weapon != none )
    {
        // ÏÔÊ¾×Óµ¯Êý
        fxMaxAmmo = KFXWeapBase(CurViewer.Weapon).KFXGetAllAmmo();
        fxCurrAmmo = KFXWeapBase(CurViewer.Weapon).KFXGetReload();
        if( fxCurrAmmo >= 10000 )
        {
            strCurAmmo = "-";
        }
        else
        {
            strCurAmmo = ""$fxCurrAmmo;
        }
        if( fxMaxAmmo >= 10000 )
        {
            strMaxAmmo = "-";
        }
        else
        {
            strMaxAmmo = ""$fxMaxAmmo;
        }

		if(IsKnife(KFXWeapBase(CurViewer.Weapon).KFXGetWeaponID()))
		{
        	KFXDrawXMLTileInfo(Canvas, KFXKnifeBulletPic);
		}
		else
		{
	       	Canvas.Font = LoadFoxFont(4);
	       	KFXDrawNarrowText(Canvas,KFXCurBulletInfo,strCurAmmo, 1);
	       	Canvas.Font = LoadFoxFont(2);
	       	KFXDrawNarrowText(Canvas, KFXBulletLine, "/", 1);
	       	KFXDrawNarrowText(Canvas,KFXMaxBulletInfo,strMaxAmmo, 2);
		}
    }

	//»æÖÆµ±Ç°ÎäÆ÷µÄÃû³Æ
	csvWeaponMedia = class'KFXTools'.static.GetConfigTable(10);
	if(csvWeaponMedia != none
			&& CurViewer.Weapon != none
			&& csvWeaponMedia.SetCurrentRow(KFXWeapBase(CurViewer.Weapon).KFXGetWeaponID()))
	{
		weaponname = csvWeaponMedia.GetString("HUDRes_WeaponName");
		GotSetAndImage(weaponname, weaponset, weaponimage);
		if(weaponset != "" && weaponimage != "")
		{
			//ÐèÒª×ø±ê¿ÉÅä
		    Canvas.KFXLoadXMLMaterial(weaponset, weaponimage, worigx, worigy, wlenx, wleny);
			Canvas.KFXSetPivot(DP_LowerRight);
			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.SetPos(KFXWeaponName.RightX-wlenx, 699);
			Canvas.KFXDrawXMLTile(weaponset, weaponimage, true, wlenx,
					wleny, worigx, worigy, wlenx, wleny);
		}
	}


	//»æÖÆ×Óµ¯ÊýÓëÊÖÀ×Ö®¼äµÄ·Ö¸îÏß
	KFXDrawXMLTileInfo(Canvas, KFXAmmoCountLine);

	//»ñµÃÊÖÀ×
	for(inv = CurViewer.Inventory; inv != none; inv = inv.Inventory)
	{
		if(KFXWeapBase(inv) != none)
		{
			nTmpGrenade = KFXWeapBase(inv).KFXGetWeaponID();
			if(KFXWeapBase(inv).KFXGetReload() <= 0)
				continue;

			if(nTmpGrenade >> 16 == 51)	//ÉÁ¹âÀ×
			{
            	nTmpGrenadeCnt[0]++;
			}
			else if(nTmpGrenade >> 16 == 52)	//¸ß±¬À×
			{
            	nTmpGrenadeCnt[1]++;
			}
			else if(nTmpGrenade >> 16 == 53)	//ÑÌÎíµ¯
			{
            	nTmpGrenadeCnt[2]++;
			}
			nGrenade++;
		}
		count++;
	}
	//»æÖÆÊÖÀ×Í¼±ê
	if(nTmpGrenadeCnt[0] > 0)
	{
		KFXDrawXMLTileInfo(Canvas, KFXFlashPicHighlight);
		Canvas.Font = LoadFoxFont(8);
		KFXDrawText(Canvas, KFXFlashCnt, ""$nTmpGrenadeCnt[0]);
	}
	else
	{
		KFXDrawXMLTileInfo(Canvas, KFXFlashPic);
	}
	if(nTmpGrenadeCnt[1] > 0)
	{
		KFXDrawXMLTileInfo(Canvas, KFXGrenadePicHighlight);
		Canvas.Font = LoadFoxFont(8);
		KFXDrawText(Canvas, KFXGrenadeCnt, ""$nTmpGrenadeCnt[1]);
	}
	else
	{
		KFXDrawXMLTileInfo(Canvas, KFXGrenadePic);
	}
	if(nTmpGrenadeCnt[2] > 0)
	{
		KFXDrawXMLTileInfo(Canvas, KFXSmokePicHighlight);
		Canvas.Font = LoadFoxFont(8);
		KFXDrawText(Canvas, KFXSmokeCnt, ""$nTmpGrenadeCnt[2]);
	}
	else
	{
		KFXDrawXMLTileInfo(Canvas, KFXSmokePic);
	}

	//»­ÊÖÀ×¸öÊý

}



// Draw the Weapon from highlighted to normal style
// modifed by linsen
// for fox 3rd version
// 2008-2-29
simulated function DrawWeaponSelect(Canvas Canvas)
{
    local KFXCSVTable fxCsvWeapon;
    local int nWeaponID;
    local string sWeaponSrc;
    local Material fxWeaponMat;

    fxCsvWeapon = class'KFXTools'.static.GetConfigTable(10);

    if( fxCsvWeapon == none )
    {
        return;
    }

    // Ò»°ãÓÃ°×É«·ç¸ñ
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, 255);

    if( PawnOwner.Weapon != none )
    {
        nWeaponID = KFXWeapBase(PlayerOwner.Pawn.Weapon).KFXGetWeaponID();
        if( nWeaponID == 0 || !fxCsvWeapon.SetCurrentRow(nWeaponID) )
        {
            return;
        }
    }
    else if(KFXPawn(PawnOwner).LastWeap!=none)
    {
        nWeaponID = KFXPawn(PawnOwner).LastWeap.KFXGetWeaponID();
        if( nWeaponID == 0 || !fxCsvWeapon.SetCurrentRow(nWeaponID) )
        {
            return;
        }
    }
    else
    {
        return;
    }
    sWeaponSrc = fxCsvWeapon.GetString("HUDRes_Main");
    fxWeaponMat = Material(DynamicLoadObject(sWeaponSrc, class'Material'));
    KFXWeaponDownInfo.MatSrc = fxWeaponMat;
    KFXWeaponUpInfo.MatSrc = fxWeaponMat;
    // Fading the highlighted and make the normal picture appear gradually
    if( Level.TimeSeconds - fxShowWeaponTime < 1 )
    {
        Canvas.bForceAlpha = true;
        Canvas.ForcedAlpha = 1.0 - (Level.TimeSeconds - fxShowWeaponTime);
        Canvas.SetPos( KFXWeaponDownInfo.PosX, KFXWeaponDownInfo.PosY);
        KFXDrawTile(Canvas, KFXWeaponDownInfo);
        Canvas.ForcedAlpha = (Level.TimeSeconds - fxShowWeaponTime);
        Canvas.SetPos( KFXWeaponUpInfo.PosX, KFXWeaponUpInfo.PosY);
        KFXDrawTile(Canvas, KFXWeaponUpInfo);
        Canvas.ForcedAlpha = 1.0;
        Canvas.bForceAlpha = false;
    }
    else   // draw normally
    {
        Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.SetPos( KFXWeaponDownInfo.PosX, KFXWeaponDownInfo.PosY);
        KFXDrawTile(Canvas, KFXWeaponUpInfo);
    }

}

// »­¹Û²ì×´Ì¬HUD
simulated function DrawSpectating(Canvas Canvas) {}

function PreSetPlayerMat(TexRotator ma, PlayerReplicationInfo pri, bool revert)
{

}
function Do_DrawWarMap(Canvas Canvas, Pawn CurViewer)
{
	if(warmap_begin_time == -1)
		warmap_begin_time = Level.TimeSeconds;

    KFXDrawMap2F(Canvas, PawnOwner);
    DrawWarMap(Canvas, PawnOwner);
}
//»­Õ½ÊõµØÍ¼
simulated function DrawWarMap(Canvas Canvas, Pawn CurViewer)
{
    local Material PlayerMat;
    local int i;
    local Pawn P;
    local KFXPlayerReplicationInfo fxPRI;
    local KFXPlayerReplicationInfo DeadPRI;
    local float xpos, ypos, xl, yl;
    local int yaw;
    local Vector PlayerLocation;
    local float xoffset, yoffset;
    local int j;
    local float delta;
    local float a, b, c;

	if(CurViewer == none)
		return;

    if(!bInitWarMap)
    {
        InitWarMap();
        if(!bInitWarMap)
        {
			log("#### ERROR ####can't find war map!");
		}
    }


//
//    //×ø±êÏµ×ª»»£¬²»ÖªµÀÊÇ·ñÓÐ±ØÒª£¿£¿£¿£¿
//    if(WarMap.ChangeXY>0&&PlayerOwner.Pawn!=none)
//    {
//        if(WarMap.ChangeXY == 1)
//        {
//        maplocPlayer.X = PlayerOwner.Pawn.Location.Y;
//        maplocPlayer.y = PlayerOwner.Pawn.Location.X;
//        }
//        else if(WarMap.ChangeXY == 2)
//        {
//        maplocPlayer.X = PlayerOwner.Pawn.Location.Y;
//        maplocPlayer.y = -PlayerOwner.Pawn.Location.X;
//
//        }
//        if(WarMap.ChangeXY == 3)
//        {
//        maplocPlayer.X = PlayerOwner.Pawn.Location.Y;
//        maplocPlayer.y = PlayerOwner.Pawn.Location.X;
//        }
//        if(WarMap.ChangeXY == 4)
//        {
//        maplocPlayer.X = -PlayerOwner.Pawn.Location.Y;
//        maplocPlayer.y = PlayerOwner.Pawn.Location.X;
//        }
//    }


//    if(KFXConsole(PlayerConsole).bChating||(KFXPlayerBase(PlayerOwner).DVClient!=none&&KFXPlayerBase(PlayerOwner).DVClient.bDVTeamTalk))
//    {
//        Canvas.SetPos(
//            (512-maplocPlayer.X/WarMap.Rate+WarMap.OffsetX+8)*Canvas.SizeX/1024.0,
//            (384-maplocPlayer.Y/WarMap.Rate+WarMap.OffsetY-8)*Canvas.SizeY/768.0
//            );
//        Canvas.DrawTile(Material(DynamicLoadObject("fx_ui_map_texs.warmap_tx", class'Material'))
//            ,16,16,0, 0, 16, 16);
//    }

    // Ö±½Ó±éÀúPRIÁÐ±í  GetPRI().Team.Size*2
    if(bRound)
    {
        bNoManDeadInFive=true;              //5ÃëÄÚÃ»ÓÐÆäËûÈËËÀÍö
        for( i = 0; i < GetGRI().PRIArray.length; i++ )
        {
            fxPRI = KFXPlayerReplicationInfo(GetGRI().PRIArray[i]);

            if( fxPRI == none || fxPRI.Team == none || fxPRI.bSpectatorView)
            {
                continue;
            }
            if(fxPRI.Team.TeamIndex == CurViewer.PlayerReplicationInfo.Team.TeamIndex  )
            {
                if(fxPRI.bDeadStatus)
                {
                    if(!fxPRI.bInitedDeadTime)
                    {
                        fxPRI.DeadBeginTime = Level.TimeSeconds;
                        fxPRI.bInitedDeadTime = true;
                    }
                }
                else
                {
                    fxPRI.bInitedDeadTime = false;
                }
            }
        }
    }
    OtherNum=0;
    for( i = 0; i < GetGRI().PRIArray.length; i++ )
    {
        fxPRI = KFXPlayerReplicationInfo(GetGRI().PRIArray[i]);

        if( fxPRI == none || fxPRI.Team == none || fxPRI.bSpectatorView)
        {
            continue;
        }

        // ÅÐ¶ÏÊÇ·ñÍ¬¶Ó ----ÔÚÕâÀï¼´±ãÊÇ»»¶ÓÒ²ÊÇÕýÈ·µÄ£¬ÈËÎïËÀÍöÊ±£¬pawn½«´æÔÚÒ»Ð¡»á¶ù£¬µ«Õâ¸öÊ±ºò£¬pawnÉÏÊÇÃ»ÓÐpriµÄ
        if(fxPRI.Team.TeamIndex == CurViewer.PlayerReplicationInfo.Team.TeamIndex  )
        {

			//ÕÒµ½¶ÔÓ¦µÄpawn£¬ÐèÒªpawnµÄyawÖµ
	        foreach DynamicActors(class'Pawn', P)
	        {
	            if( KFXPlayerReplicationInfo(P.PlayerReplicationInfo) == fxPRI )
	            {
  	                break;
	            }
	        }

			//×ø±ê×ª»¯, PlayerLocationÎª»æÖÆµÄ×ø±ê
            PlayerLocation.Z = fxPRI.fxLocation.Z;
            if(WarMap.ChangeXY==0)
            {
                PlayerLocation.X = fxPRI.fxLocation.X;
                PlayerLocation.Y = fxPRI.fxLocation.Y;
            }
            else if(WarMap.ChangeXY == 2)
            {
                PlayerLocation.X = fxPRI.fxLocation.Y;
                PlayerLocation.Y = -fxPRI.fxLocation.X;
            }


			Canvas.SetDrawColor(255,255,255,255);
            if(fxPRI == CurViewer.PlayerReplicationInfo)
			{
            	//Èç¹ûÊÇ×Ô¼º
			    if ( !KFXSetPlayerMat(PlayerMat,Canvas) )
			    {
			        PlayerMat=MyPlayer.Normal;
			    }
			}
			else
			{
				OtherNum++;
            	KFXSetOtherPlayerMat( PlayerMat, Canvas, fxPRI, P );
			}

			xoffset = 0;
			yoffset = 0;

//            if(OtherPlayerMat.MaterialUSize()==32)
//            {
				if(fxPRI.bDeadStatus)
				{
				    TexRotator(PlayerMat).Rotation.Yaw = 0;
//				    xoffset = 9;
//				    yoffset = 9;
				}
				else if(P != none)
                {
                    TexRotator(PlayerMat).Rotation.Yaw = 65536 - P.Rotation.Yaw+WarMap.Rota;
                    if(fxPRI.Team.TeamIndex == WarMap.TopTeam)
     				{
						//Èç¹û×Ô¼ºµÄ¶ÓÎéÔÚÉÏÃæ£¬ÄÇÃ´ÔÙ´ÎÐý×ª180¶È£¬±£Ö¤·½ÏòÕýÈ·
						TexRotator(PlayerMat).Rotation.Yaw += 65536 / 2;
						//Ðý×ª¶¯×÷Ö´ÐÐµÄÊÇÍ¼Æ¬×óÉÏ½ÇµÄÐý×ª£¬ÓÉÓÚÐý×ªºó£¬ÈÔÈ»ÒªËø¶¨×óÉÏ½Ç£¬ËùÒÔÒªÒ»¶¨µÄÆ«ÒÆ
						//Æ«ÒÆÇ¡ºÃÊÇÍ¼Æ¬µÄ³ß´ç
	  					xoffset = -12;
	  					yoffset = -12;
					}
					else
					{
//						xoffset = 12;
//						yoffset = 12;
					}
                }
                PreSetPlayerMat(TexRotator(PlayerMat), fxPRI, fxPRI.Team.TeamIndex == WarMap.TopTeam);

                	xpos = (496-PlayerLocation.X/WarMap.Rate+WarMap.OffsetX) + 7;
                	ypos = (368-PlayerLocation.Y/WarMap.Rate+WarMap.OffsetY) + 12;


                	//Èç¹ûÊÇºì¶Ó£¬ÄÇÃ´Ïà¶ÔÓÚÖÐÐÄ×öÐý×ª£º
     				if(fxPRI.Team.TeamIndex == WarMap.TopTeam)
     				{
						xpos = 1024 - xpos;
						ypos = 768 - ypos;
						xpos += xoffset;
						ypos += yoffset;
					}

				   Canvas.SetPos(
                        xpos*Canvas.SizeX/1024.0,
						ypos*Canvas.SizeY/768.0
                        );
                    Canvas.SetDrawColor(255, 255, 255);
                    if(fxPRI.bDeadStatus)
                    {
                        if(bRound)         //ÊÇÐ¡¾ÖÄ£Ê½
                        {
                            if( Level.TimeSeconds - fxPRI.DeadBeginTime < DeadStatusOnRadar)
                            {
                                Canvas.SetDrawColor(255, 255, 255);
                            }
                            else
                            {
                                Canvas.SetDrawColor(255, 255, 255);
                                for( j = 0; j < GetGRI().PRIArray.length; j++ )
                                {
                                    DeadPRI = KFXPlayerReplicationInfo(GetGRI().PRIArray[j]);

                                    if( DeadPRI == none || DeadPRI.Team == none || fxPRI == DeadPRI)
                                    {
                                        continue;
                                    }
                                    if(DeadPRI.DeadBeginTime > fxPRI.DeadBeginTime)
                                    {
                                        Canvas.SetDrawColor(255, 255, 255);
                                    }
                                }
                            }
                        }

                        //ÏÔÊ¾5Ãëºó¾Í²»ÔÙÏÔÊ¾
                        if(bRound && Level.TimeSeconds - fxPRI.DeadBeginTime > DeadStatusOnRadar)
                        {

						}
                        else
                        {
					    	Canvas.DrawTile(PlayerMat,17, 17, 14, 13, 30, 29);
						}
                    }
					else
					{
						Canvas.DrawTile(PlayerMat,24, 24, 10, 10, 33, 33);

						//»æÖÆÓïÒô±êÊ¶
						if(fxPRI.bSpeechState)
						{
							Canvas.SetPos((xpos-18)*Canvas.SizeX/1024.0, (ypos-16)*Canvas.SizeY/768.0);
							if(OtherPlayerSpeech == none)
							{
								OtherPlayerSpeech = new class'TexRotator';
							}

							OtherPlayerSpeech.material = Material(DynamicLoadObject("mat2_hud_texs.HUD_tacticsmap_radio", class'Material'));
							OtherPlayerSpeech.Rotation = TexRotator(PlayerMat).Rotation;
							OtherPlayerSpeech.UOffset = 24;
							OtherPlayerSpeech.VOffset = 24;
							Canvas.DrawTile(OtherPlayerSpeech, 49, 49, 0, 0, 49, 49);
						}

					}
            		//»æÖÆ´ËÈËµÄÃû×Ö
					Canvas.SetDrawColor(255, 255, 255, 255);
					Canvas.KFXFontAlias = "heavytiny13";
					Canvas.KFXStrLen(fxPRI.PlayerName, xl, yl);
					//ÈËÃûÖ»ÓÐÉÏÏÂ×óÓÒËÄ¸ö·½ÏòµÄÎ»ÖÃ
					yaw = 0;	//Ä¬ÈÏ·½ÏòÉÏ
//					if(P != none)
//					{
//						yaw = P.Rotation.Yaw+WarMap.Rota;
//                    	while(yaw >= 65536)
//                    		Yaw -= 65536;
//                    	while(yaw <= 0)
//                    		Yaw += 65536;
//					}
//					if(yaw > 0
//							&& yaw <= 8192)
//					{
//						xpos = xpos - xl/2;
//						ypos -= 15;
//						//ÉÏ
//					}
//					else if(yaw > 8192
//							&& yaw <= 24576)
//					{
//						xpos += 30;
//						ypos = ypos;
//						//ÓÒ
//					}
//					else if(yaw > 24576
//							&& yaw <= 40960)
//					{
//						xpos = xpos - xl/2;
//						ypos += 22;
//						//ÏÂ
//					}
//					else if(yaw > 40960
//							&& yaw <= 57344)
//					{
//						xpos -= xl-3;
//						ypos = ypos;
//						//×ó
//					}
//					else if(yaw > 57344
//							&& yaw <= 65536)
//					{
//						//ÉÏ
//                        xpos = xpos - xl/2;
//						ypos -= 15;
//					}
					if(fxPRI == CurViewer.PlayerReplicationInfo)
					{
						//»æÖÆËø¶¨Ð§¹û
						delta = Level.TimeSeconds-warmap_begin_time;
						if(warmap_cartoon_time-delta >= 0)
						{

							//Ë®Æ½×ø±ê×ßÏßÐÔ
							Canvas.SetPos((Canvas.SizeX*xpos/1024.0-20)*delta/warmap_cartoon_time,
									Canvas.SizeY/768.0*delta*(ypos-25)/warmap_cartoon_time);
							//Í¼Æ¬Ëõ·Å×ßÇúÏß
							//y=a(x+b)*(x+b)+c
							a = (1024-63)/(warmap_cartoon_time*warmap_cartoon_time*1024.0);
//							b = -warmap_cartoon_time;
//							c = 63/1024.0;
							b = 0;
							c = 0;
							delta = a*(delta+b)*(delta+b)+c;
							Canvas.KFXDrawXMLTile("mat2_HUD_heartbeat", "NewImage5", true,
										Canvas.SizeX/1024.0*(1-delta)*1024.0,
										Canvas.SizeY/768.0*(1-delta)*768.0);
						}
						else if(warmap_cartoon_time-delta >= -0.5)
						{
							Canvas.SetPos((xpos)*Canvas.SizeX/1024.0-20,
								(ypos-25)*Canvas.SizeY/768.0);
							Canvas.bForceAlpha = true;
							Canvas.ForcedAlpha = (delta-warmap_cartoon_time)*2;
							Canvas.KFXDrawXMLTile("mat2_HUD_heartbeat", "NewImage5", true,
										61,
										49);
							Canvas.bForceAlpha = false;
						}
						else if(warmap_cartoon_time-delta >= -1)
						{
							Canvas.SetPos((xpos)*Canvas.SizeX/1024.0-20,
								(ypos-25)*Canvas.SizeY/768.0);
							Canvas.bForceAlpha = true;
							Canvas.ForcedAlpha = 2-2*(delta-warmap_cartoon_time);
							Canvas.KFXDrawXMLTile("mat2_HUD_heartbeat", "NewImage5", true,
										61,
										49);
							Canvas.bForceAlpha = false;
						}
					}

					if(fxPRI.bDeadStatus && bRound && Level.TimeSeconds - fxPRI.DeadBeginTime > DeadStatusOnRadar)
					{

					}
					else
					{
						xpos = xpos - (xl-24)/2;
						ypos -= 14;
   						Canvas.SetPos(xpos*Canvas.SizeX/1024.0,
							ypos*Canvas.SizeY/768.0);
						Canvas.KFXDrawStr(fxPRI.PlayerName);
//      			}
		      }
//            else
//            {
//                Canvas.SetPos(
//                    (504-fxPRI.fxLocation.X/WarMap.Rate+WarMap.OffsetX)*Canvas.SizeX/1024.0,
//                    (376-fxPRI.fxLocation.Y/WarMap.Rate+WarMap.OffsetY)*Canvas.SizeY/768.0
//                );
//                Canvas.DrawTile(OtherPlayerMat,16,16,0, 0, 16, 16);
//            }

            //ÅÐ¶Ï¶ÓÓÑËù´¦µÄ²ãµÄÎ»ÖÃ
//            if(P != none &&P.Location.Z-maplocPlayer.Z>WarMap.Map2FHigh)
//            {
//                Canvas.SetPos(
//                    (512-fxPRI.fxLocation.X/WarMap.Rate+WarMap.OffsetX-24)*Canvas.SizeX/1024.0,
//                    (384-fxPRI.fxLocation.Y/WarMap.Rate+WarMap.OffsetY-8)*Canvas.SizeY/768.0
//                );
//                Canvas.DrawTile(Material(DynamicLoadObject("fx_ui_map_texs.warmap_up", class'Material'))
//                    ,16,16,0, 0, 16, 16);
//            }
//            else if(P != none &&P.Location.Z-maplocPlayer.Z<-WarMap.Map2FHigh)
//            {
//                Canvas.SetPos(
//                    (512-fxPRI.fxLocation.X/WarMap.Rate+WarMap.OffsetX-24)*Canvas.SizeX/1024.0,
//                    (384-fxPRI.fxLocation.Y/WarMap.Rate+WarMap.OffsetY-8)*Canvas.SizeY/768.0
//                );
//                Canvas.DrawTile(Material(DynamicLoadObject("fx_ui_map_texs.warmap_down", class'Material'))
//                    ,16,16,0, 0, 16, 16);
//            }

//            if(fxPRI.bSpeechState)//ÅÐ¶ÏÍ¨Ñ¶×´Ì¬
//            {
//               Canvas.SetPos(
//                    (512-PlayerLocation.X/WarMap.Rate+WarMap.OffsetX+8)*Canvas.SizeX/1024.0,
//                    (384-PlayerLocation.Y/WarMap.Rate+WarMap.OffsetY-8)*Canvas.SizeY/768.0
//               );
//                Canvas.SetDrawColor(255, 255, 255);
//            	Canvas.DrawTile(Material(DynamicLoadObject("fx_ui_map_texs.warmap_tx", class'Material'))
//                    ,16,16,0, 0, 16, 16);
//            }
        }
    }
}

simulated function bool KFXSetPlayerMat( out Material PlayerMat, Canvas Canvas )
{
    if( PlayerOwner.bFire > 0 )
    {
        Canvas.SetDrawColor(255,255,255,255);
        //PlayerMat=MyPlayer.Firing;
        //Íæ¼ÒÃ»ÓÐ¿ª»ð×´Ì¬
        return false;
    }

    if(PlayerOwner.IsDead())
    {
        Canvas.SetDrawColor(255,255,255,255);
        PlayerMat=MyPlayer.Dead;
        return true;
    }

    if(KFXPawnBase(PlayerOwner.Pawn).KFXPendingState.nRoleID==1001)
    {
        PlayerMat=MyPlayer.Pig;
        return true;
    }

    if(KFXPawnBase(PlayerOwner.Pawn).KFXPendingState.nRoleID==1003)
    {
        PlayerMat=MyPlayer.Tortoise;
        return true;
    }

    if( KFXPawnBase(PlayerOwner.Pawn).KFXPendingState.nRoleID==1002 )
    {
        PlayerMat=MyPlayer.Cat;
        return true;
    }

    return false;

}
exec function sl()
{
    ;
    ;
    ;
    ;
}
simulated function bool KFXSetOtherPlayerMat(out Material OtherPlayerMat, Canvas Canvas, KFXPlayerReplicationInfo fxPRI, Pawn P )
{
	local int i, origlen;
	origlen = OtherP.length;
	if(origlen < OtherNum)
	{
		otherP.Insert(origlen, othernum - origlen);
	}
	for(i=origlen; i<OtherNum; i++)
	{
		OtherP[i] = new class'TexRotator';
	}
    // ËÀÍö×´Ì¬
    if( fxPRI.bDeadStatus )
    {
        Canvas.SetDrawColor(255,255,255,255);
		OtherP[OtherNum-1].Material = Material(DynamicLoadObject("mat2_hud_texs.HUD_tacticsmap_death", class'Material'));
	}
	else if( P != none && KFXPawn(P).WeaponAttachment.FlashCount > 0 && KFXPawn(P).WeaponAttachment.FlashCount < 200 )
    {   // ¿ª»ð×´Ì¬
        Canvas.SetDrawColor(255,255,255,255);
    	OtherP[OtherNum-1].Material = Material(DynamicLoadObject("mat2_hud_texs.HUD_tacticsmap_fire", class'Material'));
		OtherP[OtherNum-1].UOffset = 21;
		OtherP[OtherNum-1].VOffset = 22;
	}
    else
    {
    	Canvas.SetDrawColor(255, 255, 255, 255);
    	OtherP[OtherNum-1].Material = Material(DynamicLoadObject("mat2_hud_texs.HUD_tacticsmap_team", class'Material'));
		OtherP[OtherNum-1].UOffset = 21;
		OtherP[OtherNum-1].VOffset = 22;
	}
    OtherPlayerMat = OtherP[OtherNum-1];
	return true;
//    // ±äÖí×´Ì¬
//    if(P != none &&KFXPawnBase(P).KFXPendingState.nRoleID==1001)
//    {
//        OtherPlayerMat=OtherPlayer.Pig;
//        return true;
//    }
//    //±ä¹ê×´Ì¬
//    if(P != none &&KFXPawnBase(P).KFXPendingState.nRoleID==1003)
//    {
//        OtherPlayerMat=OtherPlayer.Tortoise;
//        return true;
//    }
//    if( P != none &&KFXPawnBase(P).KFXPendingState.nRoleID==1002 )
//    {
//        OtherPlayerMat=OtherPlayer.Cat;
//        return true;
//    }
}

function KFXDrawMGInfo( Canvas Canvas )
{
    local int i;
    local int Start;
    return;
    Canvas.KFXSetPivot(DP_MiddleMiddle);
    Canvas.SetDrawColor(0,255,0,255);
    Canvas.KFXFontAlias = KFXBaseFontAlias;

    Start = Clamp( HitDmgInfoList.length-15, 0, HitDmgInfoList.length);
    for ( i = Start; i<HitDmgInfoList.length; i++ )
    {
        Canvas.SetPos( 200, 150+30*(i-start) );
        if ( HitDmgInfoList[i].HitboxIndex < 7 )
            Canvas.SetDrawColor(0,255,0,255);
        else if ( HitDmgInfoList[i].HitboxIndex > 6 )
            Canvas.SetDrawColor(255,255,0,255);
        if ( HitDmgInfoList[i].HitboxIndex == 2 )
            Canvas.SetDrawColor(255,0,0,255);
        if ( HitDmgInfoList[i].HitboxIndex == 1 )
            Canvas.SetDrawColor(0,255,255,255);

        Canvas.KFXDrawStr("dmg:"$HitDmgInfoList[i].Damage $
        " dist:"$HitDmgInfoList[i].Dist$
        " Hitbox:"$HitDmgInfoList[i].HitboxIndex);

    }
    Canvas.KFXSetPivot(DP_UpperLeft);
}

function KFXAddDMGInfo(float Damage,vector HitLocation,int Health,float dist, int HitboxID)
{
    return;
    HitDmgInfoList.Insert(HitDmgInfoList.Length,1);
    HitDmgInfoList[HitDmgInfoList.Length-1].Damage = Damage;
    HitDmgInfoList[HitDmgInfoList.Length-1].HitLoction = HitLocation;
    HitDmgInfoList[HitDmgInfoList.Length-1].CurHealth = Health;
    HitDmgInfoList[HitDmgInfoList.Length-1].PawnLocation = KFXPlayer(Level.GetLocalPlayerController()).Pawn.Location;
    HitDmgInfoList[HitDmgInfoList.Length-1].Dist = dist;
    HitDmgInfoList[HitDmgInfoList.Length-1].HitboxIndex = HitboxID;
    ;
}

//function KFXSetDMGHitbox(int HitboxID)
//{
//    HitDmgInfoList[HitDmgInfoList.Length-1].Damage = Damage;
//    HitDmgInfoList[HitDmgInfoList.Length-1].HitLoction = HitLocation;
//    HitDmgInfoList[HitDmgInfoList.Length-1].CurHealth = Health;
//    HitDmgInfoList[HitDmgInfoList.Length-1].PawnLocation = KFXPlayer(Level.GetLocalPlayerController()).Pawn.Location;
//    HitDmgInfoList[HitDmgInfoList.Length-1].HitboxIndex = HitboxID;
//}

exec function ClearDmgInfo()
{
    HitDmgInfoList.Remove(0,HitDmgInfoList.Length);
}

//»­ÐÄÌø¸ÐÓ¦ÒÇ
function DrawProbe(Canvas canvas, KFXPawn CurViewer)
{

}
//»­PVE¹Ø¿¨ÐÅÏ¢
exec function ShowPVERound(int guan,int chapter,int part,int RuleID)
{
	  log("showpveround --guan  chapter part ruleID"@guan@chapter@part@RuleID);
      playerOwner.Player.GUIController.SetHUDData_SetGuanInfo( guan, chapter, part, RuleID);
}
//»­·ÖÖµ£¬±¾¹ØµÄºÍÈ«²¿µÄ
exec function ShowPVEGuanScore(int guanscore , int totalScore)
{
    //local int playerid;
	//playerid = GUIController(playerOwner.Player.GUIController).getPVEGameHUDPlayerid();
	//playerOwner.Player.GUIController.SetHUDData_SetPlayerScore(playerid,guanscore,totalScore);
	//log("showPVEGuanScore --playerid guanscore totalScore"@playerid@guanscore@totalScore);
}
//»­Ä³ÈËËùÔÚµÄµØÀíÎ»ÖÃ
function DrawSomeoneDomain(Canvas canvas, KFXPawn curViewer)
{

}
simulated function bool IsBombInstaled(int BombPos)
{
	return false;
}
//¹ØÓÚÐ¡µØÍ¼µÄ¼¼Êõ°´
simulated function GetMapPos(vector pos,Canvas Canvas,int zl, KFXPawn CurViewer)
{
    local float Radius;
    local float dx,dy;
    local float fAngle;
    local rotator rotPlayer;
    local vector locPlayer;
    local float x;
    local float y;
    local float a;
    local float b;
    local bool longdist;
    local float XInEyes, YInEyes, RInEyes;
//	local float angle;
	local float xx, yy;
	local int CONS_Radius;
	local float iconUScale, iconVScale;
	local int direct;	//0, 1, 2, 3£¬ÉÏ×óÏÂÓÒ

	if(CurViewer == none)
		return;

    iconUScale = FMin(radarUScale, 1.0);
    iconVScale = FMin(radarVScale, 1.0);

	locPlayer = CurViewer.Location;
    rotPlayer = CurViewer.Rotation;

    x = locPlayer.X - pos.X;
    y = locPlayer.Y - pos.Y;
    Radius = sqrt(x*x+y*y);


    RotPlayer.yaw = rotPlayer.Yaw & 65535;

    // µÚÒ»ÏóÏÞ
    if( x > 0 && y >= 0 )
    {
        fAngle = ACos(x/Radius);
    }
    // µÚ¶þÏóÏÞ
    else if( x < 0 && y >= 0 )
    {
        fAngle = Pi - ASin(y/Radius);
    }
    // µÚÈýÏóÏÞ
    else if( x < 0 && y < 0 )
    {
        fAngle = Pi - ASin(y/Radius);
    }
    // µÚËÄÏóÏÞ
    else if( x >= 0 && y < 0 )
    {
        fAngle = Pi*2+ASin(y/Radius);
    }

	if(x == 0 && y == 0)
	{
    	dx = 0;
    	dy = 0;
	}
	else
	{
		dx = Radius * Cos(fAngle - float(rotPlayer.Yaw)/32768.0f * Pi);
    	dy = Radius * Sin(fAngle - float(rotPlayer.Yaw)/32768.0f * Pi);
    }

    //ÏÖÔÚÊÇÒ»¸ö¾ØÐÎ¿ò£¬ËùÒÔÅÐ¶Ïx£¬yÊÇ·ñÔÚ¾ØÐÎ·¶Î§ÄÚ
	CONS_Radius = 1925/fxSmallMap.MapScaler.UScale;
	x = dx;
	y = dy;
	//Èç¹ûÊÇÔÚÊÓ¾à·¶Î§Ö®Íâ£¬ÄÇÃ´¸øÕâÈËÓ³Éäµ½ÏàÓ¦±ß¿òÉÏ

	//if(x>-xRadius && x<xRadius && y>-yRadius && y<yRadius)
	if(Radius < CONS_Radius)
	{
    	longdist = false;
	}
	else
	{
		x = x/Radius * CONS_Radius;
		y = y/Radius * CONS_Radius;
		longdist = false;   //ÔÚ±ßÔµÏÔÊ¾Ñù×ÓÒ»Ñù
	}

	dx = x*fxSmallMap.MapScaler.UScale;
	dy = y*fxSmallMap.MapScaler.VScale;

	x = -dy / 25 * MapRoleSpeedFactor + 80 - 32*iconUScale/2;
	y = dx / 25 * MapRoleSpeedFactor + 80 - 32*iconVScale/2;

//	//¼ÆËã×ø±ê
//	x = x / 25 + 76;
//	y = y / 25 + 80;

    Canvas.SetPos(x, y);

    switch(zl)
    {
        case 0:
            if(IsBombInstaled(zl))
            {
            	//Canvas.KFXDrawXMLTile("mat2_HUD_radar", "NewImage7", true, 22, 22);
            	//Canvas.KFXDrawXMLTile("mat2_HUD_radar", "NewImage5", true, 27, 30);
                //±¬Õ¨×´Ì¬
//	                if(longdist)
//						KFXMatSrc = "mat2_hud_texs.HUD_rader_boomA_n";
//					else
					longdist = false;
					KFXMatSrc = "mat2_hud_texs.HUD_rader_boomA_s";

            }
            else
            {
            	//Canvas.KFXDrawXMLTile("mat2_HUD_radar", "NewImage4", true, 28, 29);
				KFXMatSrc = "mat2_hud_texs.HUD_rader_boomA_n";
				longdist = true;
			}
			if(!longdist)
			{
				if(  (self.Level.TimeSeconds -  int(Level.TimeSeconds)) > 0.5)
					Canvas.SetDrawColor(255, 255, 255, 255);
				else
					Canvas.SetDrawColor(255, 255, 255, 128);
				Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')), 32*iconUScale, 32*iconVScale,
							0, 0, 32, 32);
				Canvas.SetDrawColor(255, 255, 255, 255);
			}
        	else
				Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')), 32*iconUScale, 32*iconVScale,
							0, 0, 32, 32);
            break;
        case 1:
            if(IsBombInstaled(zl))
            {
//	            	if(longdist)
//		                KFXMatSrc = "mat2_hud_texs.HUD_rader_boomB_n";
//					else
					longdist = false;
	                KFXMatSrc = "mat2_hud_texs.HUD_rader_boomB_s";
                //Canvas.KFXDrawXMLTile("mat2_HUD_radar", "NewImage4", true, 28 ,29);
            }
            else
            {
            	//Canvas.KFXDrawXMLTile("mat2_HUD_radar", "NewImage5", true ,28, 29);
				longdist = true;
                KFXMatSrc = "mat2_hud_texs.HUD_rader_boomB_n";
            }
			if(!longdist)
			{
				if( (self.Level.TimeSeconds -  int(Level.TimeSeconds)) > 0.5)
					Canvas.SetDrawColor(255, 255, 255, 255);
				else
					Canvas.SetDrawColor(255, 255, 255, 128);
				Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')), 32*iconUScale, 32*iconVScale,
							0, 0, 32, 32);
				Canvas.SetDrawColor(255, 255, 255, 255);
			}
			else
				Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')), 32*iconUScale, 32*iconVScale,
							0, 0, 32, 32);
            break;
        case 2:
            KFXMatSrc = "mat2_hud_texs.HUD_rader_C4";
    		Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                		32*iconUScale,32*iconVScale,0, 0, 32, 32 );
        	break;
        case 4:
        	KFXMatSrc = "mat2_hud_texs.HUD_rader_box";
			Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
					19*iconUScale,
					19*iconVScale,
					2, 2, 19, 19 );
    }
}
//»­Ä³ÈËµÄÀ×´ï
//»æÖÆÀ×´ïµ×Í¼£¬»æÖÆÀ×´ï¿ò£¬»æÖÆÍæ¼Ò×Ô¼º£¬£¨¼ÆËã¶ÓÓÑÎ»ÖÃ£©£¬»æÖÆ¸÷¸ö¶ÓÓÑ
function DrawSomeoneRadar_Teaminfo(KFXPlayerReplicationInfo ViewerPRI, vector locplayer, rotator rotPlayer, out int teammates)
{
	local KFXPlayerReplicationInfo pri;
	local bool bfoundpawn;
	local Pawn p;
	local float radius, fangle;
	local float x, y, dx, dy;
	local float xRadius, yRadius;
	local bool longdist;
	local float CONS_Radius;
	local int i;


    teammates = 0;
	for(i=0; i<GetGRI().PRIArray.length; i++)
	{
		pri = KFXPlayerReplicationInfo(GetGRI().PRIArray[i]);
		if(pri == ViewerPRI || pri.Team.TeamIndex != ViewerPRI.Team.TeamIndex || pri.bSpectatorView)
			continue;
		bfoundpawn = false;
		//¶ÓÓÑËÀÁËÒ²ÒªÇóÏÔÊ¾ÔÚÀ×´ïÉÏ£¬ËùÒÔ¡£²»ÄÜËÑË÷ËùÓÐµÄpawnÁË
		foreach DynamicActors(class'pawn', P)
		{
        	if(p.PlayerReplicationInfo == pri)
        	{
				bfoundpawn = true;
				break;
			}
		}
		if(!bfoundpawn)
		{
	    	P = none;
		}
		x = locPlayer.X - pri.fxLocation.X;
        y = locPlayer.Y - pri.fxLocation.Y;

		Radius = sqrt(x*x+y*y);

		rotPlayer.Yaw = rotPlayer.Yaw & 65535;

        // µÚÒ»ÏóÏÞ
        if( x >= 0 && y >= 0 )
        {
            fAngle = ACos(x/Radius);
        }
        // µÚ¶þÏóÏÞ
        else if( x < 0 && y >= 0 )
        {
            fAngle = Pi - ASin(y/Radius);
        }
        // µÚÈýÏóÏÞ
        else if( x < 0 && y < 0 )
        {
            fAngle = Pi - ASin(y/Radius);
        }
        // µÚËÄÏóÏÞ
        else if( x >= 0 && y < 0 )
        {
            fAngle = ASin(y/Radius) + Pi*2;
        }

        dx = Radius * Cos(fAngle - float(rotPlayer.Yaw)/32768.0f * Pi);
        dy = Radius * Sin(fAngle - float(rotPlayer.Yaw)/32768.0f * Pi);

        //ÏÖÔÚÊÇÒ»¸ö¾ØÐÎ¿ò£¬ËùÒÔÅÐ¶Ïx£¬yÊÇ·ñÔÚ¾ØÐÎ·¶Î§ÄÚ
		xRadius = 1925/fxSmallMap.MapScaler.UScale;
		yRadius = 1925/fxSmallMap.MapScaler.VScale;
		CONS_Radius = 1925/fxSmallMap.MapScaler.UScale;
		x = dx;
		y = dy;
		//Èç¹ûÊÇÔÚÊÓ¾à·¶Î§Ö®Íâ£¬ÄÇÃ´¸øÕâÈËÓ³Éäµ½ÏàÓ¦±ß¿òÉÏ

		//if(x>-xRadius && x<xRadius && y>-yRadius && y<yRadius)
		if(Radius < CONS_Radius)
		{
        	longdist = false;
		}
		else
		{
			x = x/Radius * CONS_Radius;
			y = y/Radius * CONS_Radius;
			longdist = false;   //ÔÚ±ßÔµÏÔÊ¾Ñù×ÓÒ»Ñù
		}

		//×ª»¯³ÉÀ×´ï¿ò´óÐ¡
		dx = x*fxSmallMap.MapScaler.UScale;
		dy = y*fxSmallMap.MapScaler.VScale;
		radar_teams[teammates].xpos = -dy / 25 * MapRoleSpeedFactor;
		radar_teams[teammates].ypos = dx / 25 * MapRoleSpeedFactor;
		radar_teams[teammates].longdist = longdist;
		radar_teams[teammates].p = p;
		radar_teams[teammates].pri = pri;
		teammates++;
	}
}
function DrawSomeoneRedar_DrawTeams(Canvas canvas, int teammates, rotator rotplayer, float xcycle, float ycycle,
				float iconUScale, float iconVScale)
{
	local int i;
	local Pawn p;
	local int teamcnt;
	//»æÖÆ¶ÓÓÑ
	for(i=0; i<teammates; i++)
	{
        teamcnt++;
        self.InitTeamMateRots(teamcnt);

		p = radar_teams[i].p;
        if(true)
        {
			if( radar_teams[i].pri.bDeadStatus || p == none)
            {
                Canvas.SetPos(
                    (radar_teams[i].xpos  + xcycle - 10*iconUScale/2),
                    (radar_teams[i].ypos + ycycle-10*iconVScale/2)
                    );
                KFXMatSrc = "mat2_hud_texs.HUD_rader_death";
                Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    19*iconUScale,
                    19*iconVScale,
                    2, 2, 19, 19 );
            }
            // ¿ª»ð×´Ì¬
            else
			{
	            if(radar_teams[i].pri.bSpeechState)
	            {
					//Èç¹ûÊÇÎÞÏßµçÓïÒô
	            	Canvas.SetPos(
	                    (radar_teams[i].xpos + xcycle-48*iconUScale/2),
	                    (radar_teams[i].ypos + ycycle-48*iconVScale/2)
	                    );
	                KFXMatSrc = "mat2_hud_texs.HUD_rader_radio";

	            	TeammateSpeech.MapRotator.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	            	TeammateSpeech.MapRotator.Rotation.Yaw = -p.Rotation.Yaw+rotPlayer.Yaw;
					TeammateSpeech.MapRotator.VOffset = 24;
					TeammateSpeech.MapRotator.UOffset = 24;
	                Canvas.DrawTile(TeammateSpeech.MapRotator,
	                    48*iconUScale,
	                    48*iconVScale,
	                    0, 0, 48, 48 );
				}
				if( P != none && KFXPawn(P).WeaponAttachment.FlashCount > 0 && KFXPawn(P).WeaponAttachment.FlashCount < 200 )
	            {
	            	Canvas.SetPos(
	                    (radar_teams[i].xpos + xcycle-24*iconUScale/2),
	                    (radar_teams[i].ypos + ycycle-24*iconVScale/2)
	                    );
	                KFXMatSrc = "mat2_hud_texs.HUD_rader_fire";
	            	fxTeamRotPic[teamcnt-1].MapRotator.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	            	fxTeamRotPic[teamcnt-1].MapRotator.Rotation.Yaw = -p.Rotation.Yaw+rotPlayer.Yaw;
					fxTeamRotPic[teamcnt-1].MapRotator.VOffset = 12;
					fxTeamRotPic[teamcnt-1].MapRotator.UOffset = 12;
	                Canvas.DrawTile(fxTeamRotPic[teamcnt-1].MapRotator,
	                    24*iconUScale,
	                    24*iconVScale,
	                    0, 0, 24, 24 );
	            }
	            else
	            {
	                Canvas.SetPos(
	                    (radar_teams[i].xpos + xcycle-24*iconUScale/2),
                     	(radar_teams[i].ypos + ycycle-24*iconVScale/2)
	                    );
	            	KFXMatSrc = "mat2_hud_texs.HUD_rader_team";
	            	fxTeamRotPic[teamcnt-1].MapRotator.Material = Material(DynamicLoadObject(KFXMatSrc, class'Material'));
	            	fxTeamRotPic[teamcnt-1].MapRotator.Rotation.Yaw = -p.Rotation.Yaw+rotPlayer.Yaw;
					fxTeamRotPic[teamcnt-1].MapRotator.VOffset = 12;
					fxTeamRotPic[teamcnt-1].MapRotator.UOffset = 12;
	            	Canvas.DrawTile(fxTeamRotPic[teamcnt-1].MapRotator, 24*iconUScale, 24*iconVScale, 0, 0, 24, 24);
				}
			}

		}
	}
}
function DrawSomeoneRadar(Canvas canvas, KFXPawn curViewer)
{
	//local KFXPawn curViewer;	//µ±Ç°¿´µØÍ¼µÄÈË
	local KFXPlayerReplicationInfo ViewerPRI;
	local vector locplayer;
	local rotator rotPlayer;
	local int i;
	local int xcycle, ycycle;
	local float iconUScale, iconVScale;
	local float myXPos, myYPos;
	local int teammates;		//ÓÐ¶àÉÙÃû¶ÓÓÑ

	if(curViewer == none)
		return;

	//Ð£Ñé
	for(i=0; i<GetGRI().PRIArray.length; i++)
	{
		if(curViewer.PlayerReplicationInfo == GetGRI().PRIArray[i])
		{
			ViewerPRI = KFXPlayerReplicationInfo(GetGRI().PRIArray[i]);
			break;
		}
	}
	if(ViewerPRI == none)
		return;


    if( !bInitSmallMap )
    {
        InitSmallMap(canvas);
    }
	Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.KFXSetPivot(DP_UpperLeft);


    if( KFXPlayer(PlayerOwner).fxSmallMapMode == SMALLMAPMODE_ROTATE_PLAYER )
    {
		//µØÍ¼²»×ª£¬ÈË×ª
	}
	else
	{
		//ÈË²»×ª£¬µØÍ¼×ª
		locPlayer = curViewer.Location;
		rotplayer = CurViewer.Rotation;


		xcycle = 80;
		ycycle = 80;

		//Ëõ·Åx£¬ Î§ÈÆx*centerÐý×ª£¬Æ½ÒÆx*center-80
		fxSmallMap.MapScaler.UScale = RadarMapScale * radarUScale;
		fxSmallMap.MapScaler.VScale = RadarMapScale * radarVScale;

		fxSmallMap.MapRotator.UOffset = (locPlayer.Y / 25 * MapRoleSpeedFactor + ( ( fxSmallMap.MapMaterial.MaterialUSize()/1024.0 - 1 ) * 512 ) + radarUOffset) * fxSmallMap.MapScaler.UScale;
		fxSmallMap.MapRotator.VOffset = (-locPlayer.X / 25 * MapRoleSpeedFactor + ( ( fxSmallMap.MapMaterial.MaterialVSize()/1024.0 - 1 ) * 512 ) + radarVOffset) * fxSmallMap.MapScaler.VScale;

		fxSmallMap.MapOffset.UOffset = fxSmallMap.MapRotator.UOffset - xcycle;
		fxSmallMap.MapOffset.VOffset = fxSmallMap.MapRotator.VOffset - ycycle;

        fxSmallMap.MapRotator.Rotation.Yaw = rotPlayer.Yaw;
		Canvas.SetDrawColor(255, 255, 255, 255);
	    //»æÖÆµØÍ¼
        Canvas.SetPos(0, 0);
        Canvas.bForceAlpha = true;
        Canvas.ForcedAlpha = radarAlpha;
		Canvas.DrawTile(fxSmallMap.MapShader, 179, 190,
					0,
					0, 179, 190);
		Canvas.bForceAlpha = false;

		//»æÖÆµØÍ¼¿ò
		Canvas.SetPos(0, 1);
		if(fxRadarFrame != none)
			Canvas.DrawTile(fxRadarFrame, 179, 190, 0, 0, 179, 190);

        iconUScale = radarUScale;
        iconVScale = radarVScale;
		if(iconUScale > 1.0)
			iconUScale = 1.0;
		if(iconVScale > 1.0)
			iconVScale = 1.0;

		//ÔÚÀ×´ïÖÐÐÄ»æÖÆ×Ô¼º
		myXPos = xcycle-24*iconUScale/2;//+8;
		myYPos = ycycle-24*iconVScale/2;//+8;
		Canvas.SetPos(myXPos, myYpos);
		Canvas.DrawTile(Material(DynamicLoadObject("mat2_hud_texs.HUD_rader_me", class'Material')),
					24*iconUScale, 24*iconVScale, 0, 0, 24, 24);

		//Èç¹ûÊÇÎÞÏßµçÓïÒô
        if(ViewerPRI.bSpeechState)
		{
			Canvas.SetPos(
                (xcycle-48*iconUScale/2+8-2),
                (ycycle-48*iconVScale/2+8)
                );
            KFXMatSrc = "mat2_hud_texs.HUD_rader_radio";
            Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                48*iconUScale,
                48*iconVScale,
                0, 0, 48, 48 );
		}

		//»ñµÃ¶ÓÓÑ×ø±ê
		DrawSomeoneRadar_Teaminfo(ViewerPRI, locplayer, rotplayer, teammates);

		//»æÖÆ¶ÓÓÑ
        DrawSomeoneRedar_DrawTeams(Canvas, teammates, rotplayer, xcycle, ycycle, iconUScale, iconVScale);
	}
}

// »­½ø¶ÈÌõ
simulated function DrawProgress(Canvas Canvas) {}

// »­Õ½¶·ÐÅÏ¢
simulated function DrawMessage(Canvas Canvas)
{
    local int i, j;

    /* Ç°ÖÃÔ¼Êø£ºÊý×éÖÐÔªËØÁ¬ÐøÅÅÁÐ£¬ºóÃæÊ±¼ä´óÓÚÇ°Ãæ»òÎª¿Õ*/
    for( i = 0; i < ArrayCount(fxGameMessages); i++ )
    {
        // ÐÅÏ¢´æÔÚ³¬¹ý5Ãë--¸Éµô
        if( fxGameMessages[i].Time > 0.0 && level.TimeSeconds - fxGameMessages[i].Time > 3.0 )
        {
            // Ë³ÐòÇ°ÒÆ£¬Åöµ½¿ÕÎ»ÖÃÖÐÖ¹
            for( j = i; j < ArrayCount(fxGameMessages)-1; j++ )
            {
                if( fxGameMessages[j+1].Time > 0.0 )
                {
                    fxGameMessages[j] = fxGameMessages[j+1];
                }
                else
                {
                    break;
                }
            }

            fxGameMessages[j].Time = 0.0;
            fxGameMessages[j].sMsgContent = "";
            fxGameMessages[j].PlayerRP_1 = none;
            fxGameMessages[j].PlayerRP_2 = none;
        }
    }

    // ÏÂÃæ¿ªÊ¼»­
    for( i = 0; i < ArrayCount(fxGameMessages); i++ )
    {
        if( fxGameMessages[i].Time > 0.0 )
        {
            Canvas.SetDrawColor(0, 255, 0, 255);
            Canvas.KFXFontAlias = KFXBaseFontAlias;
            Canvas.KFXDrawStrJustifiedWithBorder(fxGameMessages[i].sMsgContent, 1,
                312 * Canvas.SizeX / 1024, (200+i*40) * Canvas.SizeY / 768,
                712 * Canvas.SizeX / 1024, (250+i*40) * Canvas.SizeY / 768,    // Keep proportion style.
                ShadeColor, -1
                );

        }
    }

}


simulated function DrawUseItemMessage(Canvas Canvas)
{
    local int i, j;
    local float xl, yl;
    local string fxName;
    local int nLength;
    local Material  ItemIcon;
    local KFXCSVTable CFG_MagicItem;

    CFG_MagicItem  = class'KFXTools'.static.GetConfigTable(35);
    if ( CFG_MagicItem == none )
        return ;
    /* Ç°ÖÃÔ¼Êø£ºÊý×éÖÐÔªËØÁ¬ÐøÅÅÁÐ£¬ºóÃæÊ±¼ä´óÓÚÇ°Ãæ»òÎª¿Õ*/
    for( i = 0; i < ArrayCount(sUseItemMessage); i++ )
    {
        // ÐÅÏ¢´æÔÚ³¬¹ý5Ãë--¸Éµô
        if(level.TimeSeconds - sUseItemMessage[i].Time > 5.0)
        {
            // Ë³ÐòÇ°ÒÆ£¬Åöµ½¿ÕÎ»ÖÃÖÐÖ¹
            for( j = i; j < ArrayCount(sUseItemMessage) - 1; j++ )
            {
                if( sUseItemMessage[j+1].Time > 0.0 )
                {
                    sUseItemMessage[j] = sUseItemMessage[j+1];
                }
                else
                {
                    break;
                }
            }
            sUseItemMessage[j].Time = 0.0;
        }
    }
    Canvas.KFXFontAlias = KFXSpecFontAlias;
    for( i = 0; i < ArrayCount(sUseItemMessage); i++ )
    {
        if(sUseItemMessage[i].Time > 0.0 )
        {
            //Canvas.KFXStrLen(sUseItemMessage[i].Used.PlayerName, xl, yl);
//            // ¼ÓÎÄ×ÖÒõÓ°
//            Canvas.SetDrawColor(255, 255, 255, 255);
//            Canvas.SetPos( (1010-xl) * Canvas.SizeX / 1024, (550+i*30 ) * Canvas.SizeY / 768 );
//            Canvas.KFXDrawStr(sUseItemMessage[i].Used.PlayerName);

            // »­µÀ¾ßÍ¼±ê
            if (!CFG_MagicItem.SetCurrentRow(sUseItemMessage[i].ItemType))
               return ;
            fxName = CFG_MagicItem.GetString("Icon");
            ItemIcon = Material(DynamicLoadObject(fxName, class'Material'));

            nLength = xl + 28;
            Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.SetPos( (1009- nLength) * Canvas.SizeX / 1024, (600+i*30) * Canvas.SizeY / 768); // Remain as it were
            Canvas.DrawTile( ItemIcon, 27*Canvas.SizeX/1024, 27*Canvas.SizeY/768, 0, 0, 41, 41 );

            Canvas.KFXStrLen(sUseItemMessage[i].User.PlayerName$lUseItem, xl, yl);

            nLength = nLength + xl + 1;
            Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.SetPos( (1009- nLength) * Canvas.SizeX / 1024, (600+i*30) * Canvas.SizeY / 768 ); // Remain as it were
            Canvas.KFXDrawStr(sUseItemMessage[i].User.PlayerName$lUseItem);
        }
    }
}

simulated function KFXSetKilledColor(Canvas Canvas, int index)
{
//    if( fxCombatMessages[index].Killed == GetPRI() )
//    {
//        Canvas.SetDrawColor(128, 255, 0, 255);
//
//    }
//    else if( fxCombatMessages[index].Killed.Team == none )
//    {
//        Canvas.SetDrawColor(38, 176, 255, 255);
//    }
//    else
	if( KFXPlayerReplicationInfo(fxCombatMessages[index].Killed).IsBlueTeam() )	//À¶¶Ó
    {
        Canvas.SetDrawColor(67, 182, 243, 255);
    }
    else if( KFXPlayerReplicationInfo(fxCombatMessages[index].Killed).IsRedTeam() )	//ºì¶Ó£¬âùºì...
    {
        Canvas.SetDrawColor(252, 88, 88, 255);
    }
    else
    	Canvas.SetDrawColor(255, 255, 255, 255);
}

simulated function KFXSetKillerColor(Canvas Canvas, int index)
{
//    if( fxCombatMessages[index].Killer == GetPRI() )
//    {
//        Canvas.SetDrawColor(128, 255, 0, 255);
//    }
//    else if( fxCombatMessages[index].Killer.Team == none )
//    {
//        Canvas.SetDrawColor(38, 176, 255, 255);
//    }
//    else
	if( KFXPlayerReplicationInfo(fxCombatMessages[index].Killer).IsBlueTeam() )
    {
        Canvas.SetDrawColor(67, 182, 243, 255);
    }
    else if( KFXPlayerReplicationInfo(fxCombatMessages[index].Killer).IsRedTeam() )
    {
        Canvas.SetDrawColor(252, 88, 88, 255);
    }
    else
    	Canvas.SetDrawColor(255, 255, 255, 255);
}

simulated function DrawCombatMessage(Canvas Canvas)
{
    local int i, j;
    local float xl, yl;
    local string fxName;
    local int nLength;
    local string tset, timage;
    local float x, y;
	local int killn;
	local color bordercolor;
	local array<string> compntSrc;

	//ÓÉUI»æÖÆ
    return;

    /* Ç°ÖÃÔ¼Êø£ºÊý×éÖÐÔªËØÁ¬ÐøÅÅÁÐ£¬ºóÃæÊ±¼ä´óÓÚÇ°Ãæ»òÎª¿Õ*/
    for( i = 0; i < ArrayCount(fxCombatMessages); i++ )
    {
        // ÐÅÏ¢´æÔÚ³¬¹ý7Ãë--¸Éµô
        if( fxCombatMessages[i].Time > 0.0
        && (fxCombatMessages[i].Killed == none || level.TimeSeconds - fxCombatMessages[i].Time > 7.0) )
        {
            ;

            // Ë³ÐòÇ°ÒÆ£¬Åöµ½¿ÕÎ»ÖÃÖÐÖ¹
            for( j = i; j < ArrayCount(fxCombatMessages)-1; j++ )
            {
                if( fxCombatMessages[j+1].Time > 0.0 )
                {
                    fxCombatMessages[j] = fxCombatMessages[j+1];
                }
                else
                {
                    break;
                }
            }

            AssignCombatMessage(j,none,none,0,0,0,false,0,0,"", 0, 0, compntSrc);
//            fxCombatMessages[j].Time = 0.0;
//            fxCombatMessages[j].nTag = 0;
//            fxCombatMessages[j].Killer = none;
//            fxCombatMessages[j].Killed = none;
//            fxCombatMessages[j].sWeaponSrc = "";
//            fxCombatMessages[j].nKills = 0;
//            fxCombatMessages[j].bPlaySound=false;
//            fxCombatMessages[j].KillerInfo = 0;
//            fxCombatMessages[j].KilledInfo = 0;
        }
    }

    Canvas.KFXFontAlias = "heavytiny13";
    bordercolor.R = 0;
    bordercolor.G = 0;
    bordercolor.B = 0;
    bordercolor.A = 255;
    Canvas.KFXSetPivot(DP_UpperLeft);

    for( i = 0; i < ArrayCount(fxCombatMessages); i++ )
    {
        if( fxCombatMessages[i].Time > 0.0 )
        {
        	nLength = 6;	//¾àÀëÆÁÄ»ÓÒ±ß½ç
            //LOG(fxCombatMessages[i].Killer$fxCombatMessages[i].Killed$fxCombatMessages[i].nTag$fxCombatMessages[i].sWeaponSrc$fxCombatMessages[i].nKills);
            // ×ÔÉ±ÏûÏ¢
            if( fxCombatMessages[i].nTag == 1 && fxCombatMessages[i].Killed != none )
            {
                // ¼ÆËãÃû×Ö³¤¶È
                Canvas.KFXStrLen("   "$fxCombatMessages[i].Killed.PlayerName, xl, yl);

				nLength += xl;	//ÈËÃû³¤¶È
//                // ¼ÓÎÄ×ÖÒõÓ°
//                Canvas.SetDrawColor(0, 0, 0, 255);
//                //Canvas.SetPos((1010-xl) * Canvas.SizeX / 1024, (33+i*30) * Canvas.SizeY / 768 );
//                Canvas.SetPos( Canvas.SizeX - nLength, (33+i*30) );
//
//                //Canvas.KFXDrawStr(fxCombatMessages[i].Killed.PlayerName);
                nLength += 2;	//ÒõÓ°Æ«ÒÆ1
               // »­±»É±ÕßÃû×Ö
                KFXSetKilledColor(Canvas, i);
                //Canvas.SetPos( (1009-xl) * Canvas.SizeX / 1024, (32+i*30) * Canvas.SizeY / 768 );
                Canvas.SetPos( Canvas.SizeX - nLength, (32+i*30));

				//Èç¹û»æÖÆµÄÊÇ×Ô¼ºµÄÃû×Ö£¬ÄÇÃ´¸ü»»ÑÕÉ«
                if(fxCombatMessages[i].Killed.PlayerName == PlayerOwner.PlayerReplicationInfo.PlayerName)
                {
					Canvas.SetDrawColor(0xba, 0xf5, 0x3d, 0xff);
				}
                Canvas.KFXDrawStrWithBorder(fxCombatMessages[i].Killed.PlayerName, bordercolor, 0);

				nLength += 10 + 30;	//Á½¸öÔªËØ¼äµÄ¼ä¸ô+Í¼±êµÄ¿í¶È
                // ×ÔÉ±Í¼±ê
                Canvas.SetDrawColor(255, 255, 255, 255);
                //Canvas.SetPos( (979-xl) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                Canvas.SetPos( Canvas.SizeX - nLength, (26+i*30));
                KFXDrawKilledIcon(canvas, 0);

				//KFXMatSrc = "fx_ui_weapon_texs.hud_weapon_suicide";
                //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                //    26, 27,
                //    0, 0, 26, 27 );
            }
            else if ( (fxCombatMessages[i].Killer != none || fxCombatMessages[i].sWeaponSrc == "set:mat2_HUD_weaponkill image:NewImage31") && fxCombatMessages[i].Killed != none )
    	    {
    	        //-------------------------------------------------------------
                // ÏÈ»­±»É±Õß
                Canvas.KFXStrLen("   "$fxCombatMessages[i].Killed.PlayerName, xl, yl);

                nLength += xl;  // ÈËÃû³¤¶È
//                // ¼ÓÎÄ×ÖÒõÓ°
//                Canvas.SetDrawColor(0, 0, 0, 255);
//                //Canvas.SetPos( (1010-xl) * Canvas.SizeX / 1024, (33+i*30) * Canvas.SizeY / 768 );
//                Canvas.SetPos( (Canvas.SizeX - nLength), (33+i*30));
//                //Canvas.KFXDrawStr(fxCombatMessages[i].Killed.PlayerName);

                nLength += 2;	//ÒõÓ°Æ«ÒÆ1
                // »­±»É±ÕßÃû×Ö
                KFXSetKilledColor(Canvas, i);
                //Canvas.SetPos( (1009-xl) * Canvas.SizeX / 1024, (32+i*30) * Canvas.SizeY / 768 );
                Canvas.SetPos( (Canvas.SizeX - nLength), (32+i*30));

				if(fxCombatMessages[i].Killed.PlayerName == PlayerOwner.PlayerReplicationInfo.PlayerName)
                {
					Canvas.SetDrawColor(0xba, 0xf5, 0x3d, 0xff);
				}
                Canvas.KFXDrawStrWithBorder("   "$fxCombatMessages[i].Killed.PlayerName, borderColor, 0);

                //-------------------------------------------------------------

                //-------------------------------------------------------------
                // ÅÐ¶Ï×Ô¶¯Ãé×¼
                if( fxCombatMessages[i].nTag == 2 )
                {
//                    nLength += 30;
//
//                    Canvas.SetDrawColor(255, 255, 255, 255);
//                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
//                    Canvas.SetPos( (Canvas.SizeX -15-nLength), (26+i*30));
//                    KFXMatSrc = "fx_ui3_texs.hud_weapon_shot";
//                    Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
//                        26, 27,
//                        0, 0, 26, 27 );
                }
                //ÅÐ¶ÏÊÇ²»ÊÇ´©Ç½£¬´©Ç½Óë±¬Í·µÄÍ¼±ê²»ÄÜÍ¬Ê±´æÔÚ
                else if(fxCombatMessages[i].nTag == 16)
                {
				    nLength += 10+34;	//¼ä¸ô+Í¼±ê¿í¶È

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));

                    //KFXMatSrc = "fx_ui_weapon_texs.hud_weapon_shothead";
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                    KFXDrawKilledIcon(canvas, 16);
                }
                // ÅÐ¶Ï±¬Í·
                else if( fxCombatMessages[i].nTag == 3 )
                {
                    nLength += 10+26;	//¼ä¸ô+Í¼±ê¿í¶È

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));

                    //KFXMatSrc = "fx_ui_weapon_texs.hud_weapon_shothead";
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                    KFXDrawKilledIcon(canvas, 1);
                }
                // ÅÐ¶Ï±äÖí
                else if( fxCombatMessages[i].nTag == 4 )
                {
                    nLength += 10+26;	//¼ä¸ô+Í¼±ê¹Ù¶É

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));
                    //KFXMatSrc = "fx_ui_weapon_texs.hud_weapon_pig";
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                    KFXDrawKilledIcon(canvas, 2);
                }
                else if( fxCombatMessages[i].nTag == 5 )
                {
                    nLength += 10+26;	//¼ä¸ô+Í¼±ê¹Ù¶É

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));

                    //KFXMatSrc = "fx_ui_weapon_texs.HUD_weapon_Tortoise";
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                    KFXDrawKilledIcon(canvas, 3);

                }
                else if( fxCombatMessages[i].nTag == 12 )
                {
                    nLength += 10+26;	//¼ä¸ô+Í¼±ê¹Ù¶É

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));

                    //KFXMatSrc = "fx_ui_weapon_texs.HUD_weapon_Cat";
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //   0, 0, 26, 27 );
                    KFXDrawKilledIcon(Canvas, 4);
                }
                //É±¶¯Îï
                else if ( fxCombatMessages[i].nTag == 6 )
                {
                    nLength += 10+26;	//¼ä¸ô+Í¼±ê¹Ù¶É

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX -nLength), (26+i*30));

                    if (fxCombatMessages[i].nSpecialRole == 1)//Öí
                    {
                    	KFXDrawKilledIcon(canvas, 5);
					//     KFXMatSrc = "fx_ui_weapon_texs.hud_weapon_pig";
                    }
                    else if (fxCombatMessages[i].nSpecialRole == 2)//¹ê
                    {
                    	KFXDrawKilledIcon(canvas, 6);
                    //    KFXMatSrc = "fx_ui_weapon_texs.HUD_weapon_Tortoise";
                    }
                    else if ( fxCombatMessages[i].nSpecialRole == 3 )//Ã¨
                    {
                    	KFXDrawKilledIcon(canvas, 7);
                    //    KFXMatSrc = "fx_ui_weapon_texs.HUD_weapon_Cat";
                    }

                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                }
                else if( fxCombatMessages[i].nTag == 7 )
                {
                    nLength += 10+26;	//¼ä¸ô+Í¼±ê¹Ù¶É

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX -nLength), (26+i*30));
                    //KFXMatSrc = KFXGetStateMat(fxCombatMessages[i].nKills);
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                    //KFXDrawKilledIcon(canvas, fxCombatMessages[i].nKills);

                }
                else if(fxCombatMessages[i].nTag == 15)
                {
				    nLength += 10+22;	//¼ä¸ô+Í¼±ê¿í¶È

                    Canvas.SetDrawColor(255, 255, 255, 255);
                    //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                    Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));

                    //KFXMatSrc = "fx_ui_weapon_texs.hud_weapon_shothead";
                    //Canvas.DrawTile(Material(DynamicLoadObject(KFXMatSrc, class'Material')),
                    //    26, 27,
                    //    0, 0, 26, 27 );
                    KFXDrawKilledIcon(canvas, 15);
                }
                //-------------------------------------------------------------

				//Èç¹ûÊÇ´©Ç½»÷É±£¬ÄÇÃ´»­´©Ç½»÷É±Í¼±ê

                //-------------------------------------------------------------
                // »­É±ÈËÎäÆ÷
                Canvas.SetDrawColor(255, 255, 255, 255);

                //WeaponMat = Material(DynamicLoadObject(fxCombatMessages[i].sWeaponSrc, class'Material'));

                //Canvas.SetPos( (1009-nLength) * Canvas.SizeX / 1024, (26+i*30) * Canvas.SizeY / 768);
                GotSetAndImage(fxCombatMessages[i].sWeaponSrc, tset, timage);
                if(tset != "" && timage != "")
                {
					Canvas.KFXLoadXMLMaterial(tset, timage, x, y, xl, yl);
				}
				else
				{
					log("#### WARNING #### can't find killer's weapon:"$fxCombatMessages[i].sWeaponSrc);
                	xl = 50;
				}
				nLength += xl;	//É±ÈËÎäÆ÷
                if(tset != "" && tset != "")
                {
					Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));
                	Canvas.KFXDrawXMLTile(tset, timage, true, xl, yl);
				}

				//»­ÎäÆ÷¹Ò¼þ£¬¹Ò¼þÍ¼Æ¬ÓëÎäÆ÷Í¼Æ¬µþ¼Ó£¬ËùÒÔÊ¹ÓÃÓëÎäÆ÷ÏàÍ¬µÄÎ»ÖÃ¼´¿É
				compntSrc = fxCombatMessages[i].sWeapCompntSrc;
                for(j=0; j< compntSrc.Length; j ++)
                {
                    GotSetAndImage(compntSrc[j], tset, timage);
                    if(tset != "" && timage != "")
                    {
    					Canvas.KFXLoadXMLMaterial(tset, timage, x, y, xl, yl);
    					Canvas.SetPos( (Canvas.SizeX - nLength), (26+i*30));
    					Canvas.KFXDrawXMLTile(tset, timage, true, xl, yl);
    				}
                }


//                Canvas.DrawTile( WeaponMat,
//                    73 , 27 ,
//                    0, 0, 73, 27 );

                // C4²»»­É±ÈËÕß
//                if(fxCombatMessages[i].nTag == 17)
//                {
//                	return;
//				}
//				if (fxCombatMessages[i].sWeaponSrc == "set:mat2_HUD_weaponkill image:NewImage31")//ºÜWSµÄ×ö·¨£¬ÒÔºóÔÙÖØ¹¹wangkai
//                    return;
                //-------------------------------------------------------------

                //-------------------------------------------------------------
                // ×îºó»­É±ÈËÕß
                // Ãû×ÖºóÃæ¼ÓÉÏÉ±ÈËÊý
                if( fxCombatMessages[i].nTag == 7 )
                {
                    fxName = ""
                        $fxCombatMessages[i].Killer.PlayerName$" ";
    //                     $"("
    //                    //$KFXPlayerReplicationInfo(fxCombatMessages[i].Killer).fxKills
    //                    $fxCombatMessages[i].nKills
    //                    $")"
                }
                else if(fxCombatMessages[i].nTag == 17          //C4 kill
						&& fxCombatMessages[i].Killer == none)
				{
					fxName = "";
					return;
				}
				else if(fxCombatMessages[i].Killer == none)
				{
					fxName = "";
					return;
				}
                else
                {
                    fxName = ""
                        $fxCombatMessages[i].Killer.PlayerName
                        $" "
                        $"("
                        //$KFXPlayerReplicationInfo(fxCombatMessages[i].Killer).fxKills
                        $fxCombatMessages[i].nKills
                        $")";
                }
                fxName = fxName $ "   ";
                Canvas.KFXStrLen(fxName, xl, yl);

                nLength += xl;	//É±ÈËÕß

//                // ¼ÓÎÄ×ÖÒõÓ°
//                Canvas.SetDrawColor(0, 0, 0, 255);
//                //Canvas.SetPos( (1010-nLength-xl) * Canvas.SizeX / 1024, (33+i*30) * Canvas.SizeY / 768 );
//                Canvas.SetPos( (Canvas.SizeX - nLength), (33+i*30));

                //Canvas.KFXDrawStr(fxName);

                nLength += 2;	//ÒõÓ°Æ«ÒÆ1
				// »­É±ÈËÕßÃû×Ö
                KFXSetKillerColor(Canvas, i);
                //Canvas.SetPos( (1009-nLength-xl) * Canvas.SizeX / 1024, (32+i*30) * Canvas.SizeY / 768 );
                Canvas.SetPos( (Canvas.SizeX - nLength), (32+i*30));


				if(fxCombatMessages[i].Killer.PlayerName == PlayerOwner.PlayerReplicationInfo.PlayerName)
                {
					Canvas.SetDrawColor(0xba, 0xf5, 0x3d, 0xff);
				}
                Canvas.KFXDrawStrWithBorder(fxName, BorderColor, 0);
                //-------------------------------------------------------------

                //»­Á¬É±Í¼±ê
                if(fxCombatMessages[i].MultiKillTime > 1)
                {
                	killn = fxCombatMessages[i].MultiKillTime;
                	if(killn > 6)
                		killn = 6;
					Canvas.SetDrawColor(255, 255, 255, 255);
                	self.GotSetAndImage(sMultiKillImage[killn-1], tset, timage);
                	if(tset!="" && timage!="")
                	{
						Canvas.KFXLoadXMLMaterial(tset, timage, x, y, xl, yl);
                		nLength += xl;
                		Canvas.SetPos((Canvas.SizeX - nLength), 33+i*30-(yl-14)/2);
						Canvas.KFXDrawXMLTile(tset, timage, true, xl, yl);
					}
				}

            }
            else
            {
                ;
            }
        }
    }

	return;
}

simulated function string KFXGetStateMat(int id)
{

    local string MatSrc;

    switch(id)
    {
        case 1:
        MatSrc = "fx_ui_weapon_texs.wudi_Kill";
        break;
//        case 2:
//        MatSrc = "fx_ui3_texs.HUD_weapon_Tortoise";
//        break;
        case 3:
        MatSrc = "fx_ui_weapon_texs.jiasu_Kill";
        break;
        case 4:
        MatSrc = "fx_ui_weapon_texs.miaozhun_Kill";
        break;
        case 8:
        MatSrc = "fx_ui_weapon_texs.jiechu_Kill";
        break;
        case 9:
        MatSrc = "fx_ui_weapon_texs.yinshen_Kill";
        break;
        case 18:
        MatSrc = "fx_ui_weapon_texs.hunluan_Kill";
        break;
        case 19:
        MatSrc = "fx_ui_weapon_texs.jiansu_Kill";
        break;
        case 20:
        MatSrc = "fx_ui_weapon_texs.leiji_Kill";
        break;
    }
    return MatSrc;
}

// ÓÃÓÚ·µ»ØPRI¶ÔÓ¦PawnµÄ±äÉí×´Ì¬
simulated function int KFXGetSpecialRole(KFXPlayerReplicationInfo PRI)
{
    local KFXPawn P;
    if (PRI == none)
        return 0;

    foreach DynamicActors(class'KFXPawn',P)
    {
        if (KFXPlayerReplicationInfo(P.PlayerReplicationInfo) == PRI)
        {
            //Öí
            if (P.KFXPendingState.nRoleID == 1001)
                return 1;
            //¹ê
            else if (P.KFXPendingState.nRoleID == 1003)
                return 2;
            else if ( P.KFXPendingState.nRoleID == 1002 )
                return 3;
            //´íÎó
            else
                return 0;
        }
    }
}

simulated function bool KFXSetMessageTag( out int nTag,
                            class<LocalMessage> Message,
                            int Switch1,
                            optional PlayerReplicationInfo RelatedPRI_1,
                            optional PlayerReplicationInfo RelatedPRI_2 )
{
        if( class<KFXCombatMessage_KillCorpse>(Message) != none )
        {
            nTag = 12;
            return true;
        }

        if( class<KFXCombatMessage_CorpseKiller>(Message) != none )
        {
            nTag = 13;
            return true;
        }

        if( class<KFXCombatMessage_Normal>(Message) != none )// C4 hack, TODO
        {
            nTag = 0;
            return true;
        }

        if( class<KFXCombatMessage_Suicide>(Message) != none )
        {
            nTag = 1;
            return true;
        }
        else if( class<KFXCombatMessage_AutoAim>(Message) != none )
        {
            nTag = 2;
        }

        if( class<KFXCombatMessage_KillHead>(Message) != none )
        {
            nTag = 3;
            return true;
        }

        if( class<KFXCombatMessage_TransPig>(Message) != none )
        {
            nTag = 4;

            if (RelatedPRI_2 == GetPRI())//±»±äÖí
            {
                //°ïÖúÏûÏ¢
                KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(50), true,, 3, 2);
            }
            return true;
        }

        if( class<KFXCombatMessage_TransTortoise>(Message) != none )
        {
            nTag = 5;

            if (RelatedPRI_2 == GetPRI())//±»±ä¹ê
            {
                //°ïÖúÏûÏ¢
                KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(50), true,, 3, 2);
            }
            return true;
        }

        //<< wangkai added

        if ( class<KFXCombatMessage_KillAnimal>(Message) != none )//É±Öí/É±¹ê
        {
            nTag = 6;
            return true;
        }

        if(class<KFXCombatMessage_EPBState>(Message)!=none)
        {
            nTag = 7;
            return true;
        }
        if ( class<KFXCombatMessage_TeamKill>(Message)!= none )
        {
            nTag = 11;
            return true;
        }
		if(class<KFXCombatMessage_CWKill_HeadKill>(Message) != none)
		{
			nTag = 16;
			return true;
		}
        if(class<KFXCombatMessage_CWKill>(Message) != none)
        {
			nTag = 15;
			return true;
		}

		if(class<KFXCombatMessage_CFour>(Message) != none)
		{
			//c4 kill
			nTag = 17;
			return true;
		}

    return false;
}

simulated function bool KFXSetMessageSrcName( out string WeaponSrc, class<LocalMessage> Message, optional Object OptionalObject )
{
    return false;
}

function KFXSetKillMulByBot()
{
}
function KFXNotifyChangeWeapon(int nWeaponID)
{
	local int nTmpID;
	local int nMainWeaponID, nSecondWeaponID, nKnifeID;
    local Inventory inv;
	local KFXCSVTable csvWeaponMedia;
	local Pawn curViewer;

	ChangeWeaponMessage.nWeaponID = nWeaponID;
	ChangeWeaponMessage.nUpdateTime = Level.TimeSeconds;

    curViewer = PawnOwner;
    csvWeaponMedia = class'KFXTools'.static.GetConfigTable(10);

    if(csvWeaponMedia == none)
    	return;
   	if(CurViewer == none)
   		return;

	for(inv = CurViewer.Inventory; inv != none; inv = inv.Inventory)
	{
			if(KFXWeapBase(inv) != none)
			{
				nTmpID = KFXWeapBase(inv).KFXGetWeaponID() >> 16;
				if(nTmpID >= 1 && nTmpID <= 30 && nMainWeaponID == 0)
					nMainWeaponID = KFXWeapBase(inv).KFXGetWeaponID();
				else if(nTmpID >= 31 && nTmpID <= 40 && nSecondWeaponID == 0)
					nSecondWeaponID = KFXWeapBase(inv).KFXGetWeaponID();
				else if(nTmpID >= 41 && nTmpID <= 50 && nKnifeID == 0)
					nKnifeID = KFXWeapBase(inv).KFXGetWeaponID();
			}
	}
	//
if(_HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_ChangeWeapon(nWeaponID,
													nMainWeaponID,
													nSecondWeaponID,
													nKnifeID);
}

}
simulated function KFXLocalizedMessage
(
    class<LocalMessage> Message,
    optional int Switch1,
    optional PlayerReplicationInfo RelatedPRI_1,//killer
    optional PlayerReplicationInfo RelatedPRI_2,//killed
    optional Object OptionalObject,
    optional int Switch2,		//Èç¹ûÊÇµÀ¾ß£¬ÄÇÃ´±íÊ¾id£¬Èç¹û²»ÊÇ£¬ÄÇÃ´¸ß16Î»ÎªÁ¬É±ÊýÁ¿£¬µÍ16Î»Îª»÷É±Êý
    optional string sWeaponSrc
)
{
	local int i, j;
	local int nTag;
	local int nSpecRole;
	local int WeapType;
	local string WeaponSrc;
	local int MultiKillTime;
	local int specialkill;
	local array<string> sCompntSrc;
    local int CorpseType;
    local int Num;
    //ÁÙÊ±±äÁ¿£¬´æ·Å±¾´ÎÌí¼ÓµÄ¼¤ÀøÏûÏ¢
	local EEncourageType EncourageType;
    // ÅÐ¶ÏÊÇ·ñÊÇ¼´Ê±Õ½¶·ÐÅÏ¢
    if( ClassIsChildOf(Message, class'KFXInstCombatMessage') )
    {
        ;
        nSpecRole = KFXGetSpecialRole(KFXPlayerReplicationInfo(RelatedPRI_2));

        if ( !KFXSetMessageTag( nTag, Message, Switch1, RelatedPRI_1, RelatedPRI_2 ) )
        {
            return;
        }

        // ´¦Àí¼°Ê±Õ½¶·ÐÅÏ¢
        for( i = 0; i < ArrayCount(fxCombatMessages); i++ )
        {
            if (fxCombatMessages[i].Time < 0.001)
    		{
    			break;
    		}
        }

        if( i == ArrayCount(fxCombatMessages) )
        {
            for ( i = 0; i < ArrayCount(fxCombatMessages)-1; i++ )
            {
                fxCombatMessages[i] = fxCombatMessages[i+1];
            }
        }

        if ( !KFXSetMessageSrcName( WeaponSrc, Message, OptionalObject ) )
        {
            WeaponSrc = class'KFXInstCombatMessage'.static.GetWeaponSrc(Switch1);
        }

        class'KFXInstCombatMessage'.static.GetWeapCompntSrc(Switch1,KFXPlayerReplicationInfo(RelatedPRI_1), sCompntSrc);

		if(nTag != 4 && nTag != 5 && nTag != 12)
		{
			if( class<KFXUseItemMesaage>(Message) == none )
			{
				MultiKillTime = (Switch2 >> 16)&0xff;
				specialkill = Switch2>>24;
			}
		}

		//·þÎñÆ÷Í¨Öª»÷É±ÐÅÏ¢Ê±£¬²¥·ÅÒôÐ§¡£
        NotifyKillEvent(nTag, RelatedPRI_1, MultiKillTime);

		AssignCombatMessage( i, RelatedPRI_1, RelatedPRI_2, nTag, nSpecRole,
                            Level.TimeSeconds,true, Switch1, Switch2&0xff, WeaponSrc,
							MultiKillTime, specialkill, sCompntSrc);
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
		PlayerOwner.Player.GUIController.SetHUDData_CombatMsg(nTag, RelatedPRI_1,
								RelatedPRI_2, WeaponSrc, sCompntSrc, MultiKillTime,
								specialkill,
								Switch2&0xff);
}
    }
    if( class<KFXUseItemMesaage>(Message) != none )
    {
         // ´¦Àí¼°Ê±Õ½¶·ÐÅÏ¢
        for( i = 0; i < ArrayCount(sUseItemMessage); i++ )
        {
            if (sUseItemMessage[i].Time < 0.001)
    		{
    			break;
    		}
        }
        if( i == ArrayCount(fxCombatMessages) )
        {
            for ( i = 0; i < ArrayCount(fxCombatMessages)-1; i++ )
            {
                sUseItemMessage[i] = sUseItemMessage[i+1];
            }
        }
       if((RelatedPRI_2 ==  PlayerOwner.PlayerReplicationInfo )
          ||((RelatedPRI_2 == none)&&(Switch1 == 2)&&(RelatedPRI_1.Team.TeamIndex != PlayerOwner.PlayerReplicationInfo.Team.TeamIndex))
          ||((RelatedPRI_2 == none)&&(Switch1 == 3))
          ||((RelatedPRI_2 == none)&&(Switch1 == 4)&&(RelatedPRI_1.Team.TeamIndex == PlayerOwner.PlayerReplicationInfo.Team.TeamIndex)))
        {
           sUseItemMessage[i].User = RelatedPRI_1;
           sUseItemMessage[i].Used = PlayerOwner.PlayerReplicationInfo;
           sUseItemMessage[i].Time = level.TimeSeconds;
           sUseItemMessage[i].ItemType = Switch2;
        }
    }
    if(GetPRI().nIDLastKillMe > 0)
    	nInventoryID  = GetPRI().nIDLastKillMe;

    //<< wangkai, ¼¤ÀøÏµÍ³
    if (nTag != 4 && nTag != 5 && (Switch1 != 1))//²»ÊÇ±äÉíÏûÏ¢ÇÒ²»ÊÇÎÞËÀÍüÄ£Ê½
    {
		if(RelatedPRI_1 == GetPRI())
    	{
	    	//Èç¹ûÉ±ÈËÁË
	    	if(RelatedPRI_2 != none && KFXPlayerReplicationInfo(RelatedPRI_2) != none)
		    	KFXPlayer(PlayerOwner).DoCollectEnemyMsg(KFXPlayerReplicationInfo(RelatedPRI_2).fxPlayerDomain, 3);
		}
		else if(RelatedPRI_2 == GetPRI())
		{
            //Èç¹û±»É±ÁË
            KFXPlayer(PlayerOwner).DoCollectEnemyMsg(KFXPlayerReplicationInfo(RelatedPRI_2).fxPlayerDomain, 2);
		}
        if (RelatedPRI_1 == GetPRI())// É±ÁËÈË
        {
            /*
            ET_Normal,      //ÆÕÍ¨
            ET_FirstBlood,  //µÚÒ»µÎÑª
            ET_Combo2,      //2Á¬É±
            ET_Combo3,      //3Á¬É±
            ET_Combo4,      //4Á¬É±
            ET_Combo5,      //5Á¬É±
            ET_ComboN,      //>6Á¬É±
            ET_Knife,       //µ¶É±
            ET_HeadShot,    //±¬Í·
            ET_Bomb,        //±¬Õ¨
            ET_Special,     //ÌØÊâ»÷É±
            ET_Tank         //É±Ì¹¿Ë
            ET_Corpse,      //É±½©Ê¬
            ET_CorpseKiller,//½©Ê¬É±ÈË
            ET_TeamKill     //ÍÅ¶Ó»÷É±
            */
//            if (!GetGRI().bNotFirstBlood)//µÚÒ»´Î
//            {
//                EncourageType = ET_FirstBlood;      //µÚÒ»µÎÑª!
//                GetPRI().CheckRepValue(1, GetPRI().REP_VALUE,
//				GetPRI().REPVALUE_FIRSTBLOOD);  	///<µÚÒ»µÎÑª¸üÐÂ¿Í»§¶ËÍ¬²½Öµ
//            }
//            else
			if (false && KFXPlayer(PlayerOwner).MultiKillLevel > 1)
            {
                EncourageType = EEncourageType(Clamp(KFXPlayer(PlayerOwner).MultiKillLevel, 2, 6));           //Á¬É±
            }
            else
            {
                WeapType = (switch1 >> 16);

                if ( nTag == 12 )
                {

                    //EncourageType = ET_Corpse;   Unreal enum ²»Ö§³ÖÇ¿×ª°¡
//                    Num = int(ET_KillMotherCorpse );
//                    CorpseType = Num + GetCorpseType(RelatedPRI_2) -1;
                    CorpseType = GetCorpseType(RelatedPRI_2);
                    log("KFXHUD-----CorpseType "$CorpseType);
                    switch(CorpseType)
                    {
                        case 1:
                             EncourageType = ET_KillMotherCorpse;
                             break;
                        case 2:
                             EncourageType = ET_KillChildCorpse;
                             break;
                        case 3:
                             EncourageType = ET_KillFatCorpse;
                             break;
                        case 4:
                             EncourageType = ET_KillGirlCorpse;
                             break;
                        default:
                             EncourageType = ET_Corpse;
                             break;
                    }

                }
                else if ( nTag == 13 )
                {
                    EncourageType = ET_CorpseKiller;
                }
                else  if ( WeapType >= 41 && WeapType <= 50 || switch1 == 2)
				{
                    EncourageType = ET_Knife;       //µ¶É±/È­Í·
                }
                else if (nTag == 3)
                {
                    EncourageType = ET_HeadShot;    //±¬Í·
                }
                else if ((OptionalObject != none) && (OptionalObject.Name == 'KFXDmgTypeDelayed'))//±¬Õ¨É±,£¨ÎªÁË²»Ê¹ÓÃdependson£¬¹ÊÊ¹ÓÃÁËNameÕâ¸öÊôÐÔ£©
                {
                    EncourageType = ET_Bomb;        //±¬Õ¨É±
                    ;
                }
                else if (nTag == 6)
                {
                    EncourageType = ET_Special;     //É±Öí/É±¹ê/É±Ã¨
                }
                else if ( nTag == 8 )           //É±Ì¹¿Ë
                {
                    EncourageType = ET_Tank;
                }
                else if ( nTag == 11 )
                {
                    EncourageType = ET_TeamKill;
                }
                else if(nTag == 15)
                {
					KFXPlayer(PlayerOwner).PlayerCombatmessageDataSet.CrossWallKillNum++;
                    EncourageType = ET_Wall;
				}
				else if(nTag == 16)
				{
                    KFXPlayer(PlayerOwner).PlayerCombatmessageDataSet.CrossWallHeadKillNum++;;
                    EncourageType = ET_WallHeadShot;
				}
                else
                {
                    EncourageType = ET_Normal;      //µ¥É±
                }
            }

            for (i=0; i<ArrayCount(fxEncourageMsgs); i++)
            {
                if (fxEncourageMsgs[i].Time < 0.001)//¿ÕµÄ
                    break;
            }
            if (i == ArrayCount(fxEncourageMsgs))//¶ÓÀýÂú£¬Çå¿Õ
            {
                for (i=0; i<ArrayCount(fxEncourageMsgs); i++)
                {
                    fxEncourageMsgs[i].Time = 0;
                }
                i = 0;//¶¨Î»µ½µÚÒ»ÌõÏûÏ¢
            }
            fxEncourageMsgs[i].bMultiKill = Clamp(KFXPlayer(PlayerOwner).MultiKillLevel, 0, 6);
            fxEncourageMsgs[i].Type = EncourageType;
            fxEncourageMsgs[i].Time = Level.TimeSeconds;

			//¸´³ð±êÊ¶
			if(nTag == 12 || nTag == 13)
			{
                fxEncourageMsgs[i].bInventory = 0;
                nInventoryID = 0;
            }
			else if(nInventoryID > 0 && nInventoryID == KFXPlayerReplicationInfo(RelatedPRI_2).fxPlayerDBID)
			{
				fxEncourageMsgs[i].bInventory = 1;
				nInventoryID = 0;
			}
			else
			{
				fxEncourageMsgs[i].bInventory = 0;
			}

            log ("##### EncourageMsg Type: " $ EncourageType);
            log ("##### EncourageMsg Type: _HUD_NEW_" $ _HUD_NEW_);
if(_HUD_NEW_ == 2)
{
            PlayerOwner.Player.GUIController.SetHUDData_Encourage(fxEncourageMsgs[i].Type,
				fxEncourageMsgs[i].bMultiKill,
				fxEncourageMsgs[i].bInventory);
}
        }

        ////////////////////////////////////////////
        // ¼¤ÀøÏµÍ³Ö®Õ½ÊõÍ³¼Æ
        if (RelatedPRI_1 == GetPRI() || RelatedPRI_2 == GetPRI())//É±ÈË»ò±»É±
        {
            //<<ÏûÃðÍ³¼Æ      ChenJianye
            if (RelatedPRI_1 == GetPRI())//i'm the killer
            {
                KFXPlayerReplicationInfo(RelatedPRI_2).KFXKilledByMeCount++;
            }
            else if (RelatedPRI_2 == GetPRI())
            {
                KFXPlayerReplicationInfo(RelatedPRI_1).KFXKillMeCount++;
                // ÖÓ:ÐÖµÜÁ¬Ä£Ê½ÏÂ±»Í¬Ò»ÃûÂíÈø°ÂÊ¿±ø»÷É±15´Î
                if(KFXPlayerReplicationInfo(RelatedPRI_1).KFXKillMeCount == 15)
                {
                    KFXSetKillMulByBot();
                }
            }

            UpdatePlayerKillInfo();


            //ÕÒµ½µÚÒ»¸ö¿ÕÎ»
            for (i=0; i<ArrayCount(fxWhoKilledMeMsgs); i++)
            {
                if (fxWhoKilledMeMsgs[i].Time < 0.001)//¿ÕµÄ
                    break;
            }

            //×îºóÒ»ÌõÊÇ±»É±¼ÇÂ¼£¬ÔòÇå¿Õ
            j = Max(i-1, 0);
            if (fxWhoKilledMeMsgs[j].Killed == GetPRI())
            {
                for (j=0; j<ArrayCount(fxWhoKilledMeMsgs); j++)
                {
                    fxWhoKilledMeMsgs[j].Time = 0.0;
                }
                i = 0;//¶¨Î»µ½µÚÒ»Ìõ
            }
            //¶ÓÀýÂú£¬µ¯³öµÚÒ»¸ö
            if (i == ArrayCount(fxWhoKilledMeMsgs))
            {
                for (i=0; i<ArrayCount(fxWhoKilledMeMsgs)-1; i++)
                {
                    fxWhoKilledMeMsgs[i] = fxWhoKilledMeMsgs[i+1];
                }
            }
            //µ±Ç°ÏûÏ¢·ÅÈëÕâ¸ö¿ÕÎ»ÖÃ
            fxWhoKilledMeMsgs[i].Killer = RelatedPRI_1;
        	fxWhoKilledMeMsgs[i].Killed = RelatedPRI_2;
        	fxWhoKilledMeMsgs[i].Time = level.TimeSeconds;
        	fxWhoKilledMeMsgs[i].nTag = nTag;
        	fxWhoKilledMeMsgs[i].nKills = Switch2 & 0xff;
        	fxWhoKilledMeMsgs[i].sWeaponSrc = class'KFXInstCombatMessage'.static.GetWeaponSrc(Switch1);
            ;
        }
        ////////////////////////////////////////////ÕâÀïµÄÌõ¼þÅÐ¶ÏµÄÓÐµã¹îÒì
        if (RelatedPRI_2 == GetPRI() && nTag != 10 && (FMax(GetGRI().fxPlayerRestartDelay-GetPRI().fxRestartCardTime, 0) > 0))//±»É±
        {
            //bShowWhoKilledMe = true;
        }
    }
    //>>
}
function int GetCorpseType(PlayerReplicationInfo PRI);
function NotifyKillEvent(int KillType, PlayerReplicationInfo Killer, int MultikillCount)
{
	local bool bshow;
	MultiKillCount = Clamp(MultiKillCount, 0, 6);
    if(Killer == PlayerOwner.PlayerReplicationInfo)
	{
		//×Ô¼ºÉ±±ðÈË
		if(EncourageSoundOther[MultiKillCount].active && EncourageSoundMe[MultiKillCount].strSound[0] != "")
			PlaySound(Sound(DynamicLoadObject(EncourageSoundMe[MultiKillCount].strSound[0], class'sound')));
	}
	else
	{
		if(EncourageSoundOther[MultiKillCount].Scope == 1
				&& Killer.Team.TeamIndex == PlayerOwner.PlayerReplicationInfo.Team.TeamIndex)
		{
        	bshow = true;
		}
		else if(EncourageSoundOther[MultiKillCount].Scope == 2)
		{
			bshow = true;
		}
		else
		{
			bshow = false;
		}
		if(bshow && EncourageSoundOther[MultiKillCount].active && EncourageSoundOther[MultiKillCount].strSound[0] != "")
			PlaySound(Sound(DynamicLoadObject(EncourageSoundOther[MultiKillCount].strSound[0], class'sound')));
	}
}
simulated function AssignCombatMessage(
    int index,
    PlayerReplicationInfo RelatedPRI_1,//killer
    PlayerReplicationInfo RelatedPRI_2,//killed
    int nTag,
    int nSpecRole,
    float Time,
    bool bPlaySound,
    int Switch1,
    int Switch2,
    string sWeaponSrc,
    int nMultiKillTime,		//Á¬É±´ÎÊý
    int nSpecialKill,
    array<string> sCompntSrc
)
{
        local int loop;
        fxCombatMessages[index].Killer = RelatedPRI_1;
    	fxCombatMessages[index].Killed = RelatedPRI_2;
    	fxCombatMessages[index].Time = Time;
    	fxCombatMessages[index].nTag = nTag;
    	fxCombatMessages[index].nKills = Switch2;
    	fxCombatMessages[index].sWeaponSrc = sWeaponSrc;
        fxCombatMessages[index].nSpecialRole = nSpecRole;
        fxCombatMessages[index].bPlaySound = bPlaySound;
        fxCombatMessages[index].KillerInfo = 0;
        fxCombatMessages[index].KilledInfo = 0;
        fxCombatMessages[index].MultiKillTime = byte(nMultiKillTime);
        fxCombatMessages[index].SpecialKill = byte(nSpecialKill);
        fxCombatMessages[index].sWeapCompntSrc.Remove(0,fxCombatMessages[index].sWeapCompntSrc.Length);
        for(loop=0; loop < sCompntSrc.Length; loop++)
        {
            fxCombatMessages[index].sWeapCompntSrc[loop] = sCompntSrc[loop];
        }
}



// ´¦ÀíÏûÏ¢
simulated function LocalizedMessage
(
    class<LocalMessage> Message,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject,
    optional string CriticalString
)
{

	;

    /*
    // ÕÒ¿ÕÐÅÏ¢Î»ÖÃ±£´æ
    for ( i = 0; i < ArrayCount(fxLocalMessages); i++ )
	{
		if (fxLocalMessages[i].Message == None)
		{
			break;
		}
	}

	// ÕÒ²»µ½ÔòÇ°ÒÆ
	if( i == ArrayCount(fxLocalMessages) )
    {
        for ( i = 0; i < ArrayCount(fxLocalMessages)-1; i++ )
        {
            fxLocalMessages[i] = fxLocalMessages[i+1];
        }
    }

    // ±£´æÐÅÏ¢
    fxLocalMessages[i].Message = Message;
	fxLocalMessages[i].Switch = Switch;
	fxLocalMessages[i].RelatedPRI = RelatedPRI_1;
	fxLocalMessages[i].RelatedPRI2 = RelatedPRI_2;
	fxLocalMessages[i].OptionalObject = OptionalObject;
	fxLocalMessages[i].StringMessage = CriticalString;
    */

    // ÅÐ¶ÏÊÇ·ñÊÇÓÎÏ·ÐÅÏ¢
    if( class<KFXGameMessage>(Message) != none )
    {
        // Move 'player in&out' messages to chattextmessages
        // Modified by linsen 2008-5-9
        if( (1 == switch) || (2 == switch) )
        {
            //<<ÓÐÈËÍË³öÓÎÏ·¸üÐÂÏûÃðÍ³¼Æ      ChenJianye
            if (2 == switch)
            {
                UpdatePlayerKillInfo(RelatedPRI_1);
            }
            //>>
            log("KFXHUD-----KFXPlayer(PlayerOwner).bIsEnterLeaveGame "$KFXPlayer(PlayerOwner).bIsEnterLeaveGame);
            if(KFXPlayer(PlayerOwner).bIsEnterLeaveGame)
            {
                KFXAddTextMessage(
                    class'KFXGameMessage'.static.GetStringEx(Switch, RelatedPRI_1, RelatedPRI_1),
                    class'LocalMessage', none, PlayerInOutColor);
            }
            return;
        }

        //¸ßÓÅÏÈ¼¶ÏûÏ¢
        else if (switch > 10 && switch < 41)
        {
            //Ö»±£ÁôÒ»Ìõ
            KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(Switch, RelatedPRI_1, RelatedPRI_1, PlayerOwner),
                            true,, 3, 1);
        }
        //µÍÓÅÏÈ¼¶ÏûÏ¢
        else
        {
            //Ö»±£ÁôÒ»Ìõ
            KFXSendClewMessage(class'KFXGameMessage'.static.GetStringEx(Switch, RelatedPRI_1, RelatedPRI_1, PlayerOwner),
                            true,, 3, 2);
        }

        /*
        // ´¦ÀíÓÎÏ·ÐÅÏ¢
        for( i = 0; i < ArrayCount(fxGameMessages); i++ )
        {
            if (fxGameMessages[i].Time < 0.001)
    		{
    			break;
    		}
        }

        if( i == ArrayCount(fxGameMessages) )
        {
            for ( i = 0; i < ArrayCount(fxGameMessages)-1; i++ )
            {
                fxGameMessages[i] = fxGameMessages[i+1];
            }
        }

        fxGameMessages[i].PlayerRP_1 = RelatedPRI_1;
        fxGameMessages[i].PlayerRP_2 = RelatedPRI_1;
        fxGameMessages[i].Time = level.TimeSeconds;

        fxGameMessages[i].sMsgContent = class'KFXGameMessage'.static.GetString(Switch, RelatedPRI_1, RelatedPRI_1);

        LOG("[zjpwxh]KFXGameMessage");
        */
    }

    return;
}

// »­¹Û²ìÕßÄ£Ê½ÖÐ¹Û²ìÕß¿´µ½µÄÍæ¼ÒµÄÃû×Ö      °Ñ¿´²»µ½µÄÏÞÖÆ¶¼¸øÈ¡Ïûµô
simulated function KFXDrawPlayerNameInSpectating(Canvas Canvas)
{
    local Pawn P;
    local vector ScreenPos;

    local vector dir1, dir2;
    local float dist, DotV;

    local int iFont;

    local string    AdditionalInfo;

     foreach DynamicActors(class'Pawn',P)
    {
        // ²»ÊÇ×Ô¼º
        if ( P.PlayerReplicationInfo != none && P != PlayerOwner.Pawn && !P.bTearOff )
        {
            // »­Í·¶¥Ãû×Ö**test
            if( (p.GetTeamNum() != 255 /*&& p.GetTeamNum() == GetPRI().Team.TeamIndex*/)
                || GetPRI().bAdmin )
            {
                if ( PlayerOwner.Pawn != none )
                {
                    Dir1 = vector(PlayerOwner.Pawn.Rotation);
                    Dir2 = Normal(p.Location - PlayerOwner.Pawn.Location);
                    dist = VSize(p.Location - PlayerOwner.Pawn.Location);
                    DotV = Dir1 dot Dir2;

                    if (DotV <= 0.1)
                    {
                        continue;
                    }
                }
                else
                {
                    Dir1 = vector(PlayerOwner.Rotation);
                    Dir2 = Normal(p.Location - PlayerOwner.Location);
                    dist = VSize(p.Location - PlayerOwner.Location);
                    DotV = Dir1 dot Dir2;

                    if (DotV <= 0.1)
                    {
                        continue;
                    }
                }

                if ( p.GetTeamNum() != 255 && p.GetTeamNum() == GetPRI().Team.TeamIndex )
                {
                    Canvas.SetDrawColor(0, 153, 68, 255);
                }
                else
                {
                    Canvas.SetDrawColor(230, 0, 18, 255);
                }

                /*if( dist > self.fxShowNameDist3 )
                {
                    return;
                }
                else if ( dist > self.fxShowNameDist2 )
                {
                    iFont = 2;
                }
                else if( dist > self.fxShowNameDist1 )
                {
                    iFont = 1;
                }
                else
                {
                    iFont = 0;
                } */

                iFont = 0;

                if ( GetPRI().bAdmin )
                {
                    AdditionalInfo = " HP:"$P.Health;
                }
                //log("KFXHUD------ KFXDrawPlayerName");
                KFXDrawPlayerName(Canvas, P, ScreenPos, iFont ,AdditionalInfo);
            }
        }
    }
}


// »­¹Û²ìÕßÄ£Ê½ÖÐ¹Û²ìÕß¿´µ½µÄÍæ¼ÒµÄÃû×Ö      °Ñ¿´²»µ½µÄÏÞÖÆ¶¼¸øÈ¡Ïûµô
simulated function KFXDrawPlayerNameInDownViewState(Canvas Canvas)
{
    local Pawn P;
    local vector ScreenPos;

    local vector dir1, dir2;
    local float dist, DotV;

    local int iFont;

    local string    AdditionalInfo;

     foreach DynamicActors(class'Pawn',P)
    {
        // ²»ÊÇ×Ô¼º
        if ( P.PlayerReplicationInfo != none && P != PlayerOwner.Pawn && !P.bTearOff )
        {
            // »­Í·¶¥Ãû×Ö**test
            if( (p.GetTeamNum() != 255 /*&& p.GetTeamNum() == GetPRI().Team.TeamIndex*/)
                || GetPRI().bAdmin )
            {
                if ( PlayerOwner.Pawn != none )
                {
                    Dir1 = vector(PlayerOwner.Pawn.Rotation);
                    Dir2 = Normal(p.Location - PlayerOwner.Pawn.Location);
                    dist = VSize(p.Location - PlayerOwner.Pawn.Location);
                    DotV = Dir1 dot Dir2;

//                    if (DotV <= 0.1)
//                    {
//                        continue;
//                    }
                }
                else
                {
                    Dir1 = vector(PlayerOwner.Rotation);
                    Dir2 = Normal(p.Location - PlayerOwner.Location);
                    dist = VSize(p.Location - PlayerOwner.Location);
                    DotV = Dir1 dot Dir2;

//                    if (DotV <= 0.1)
//                    {
//                        continue;
//                    }
                }

                if ( p.GetTeamNum() != 255 && p.GetTeamNum() == GetPRI().Team.TeamIndex )
                {
                    Canvas.SetDrawColor(0, 153, 68, 255);
                }
                else
                {
                    Canvas.SetDrawColor(230, 0, 18, 255);
                }

                /*if( dist > self.fxShowNameDist3 )
                {
                    return;
                }
                else if ( dist > self.fxShowNameDist2 )
                {
                    iFont = 2;
                }
                else if( dist > self.fxShowNameDist1 )
                {
                    iFont = 1;
                }
                else
                {
                    iFont = 0;
                } */

                iFont = 0;

                if ( GetPRI().bAdmin )
                {
                    AdditionalInfo = " HP:"$P.Health;
                }
                //log("KFXHUD------ KFXDrawPlayerName");
                KFXDrawPlayerName(Canvas, P, ScreenPos, iFont ,AdditionalInfo);
            }
        }
    }
}

// »­Íæ¼ÒÍ·ÉÏÃû×Ö
simulated function KFXDrawSameTeamName(Canvas Canvas)
{
    local Pawn P;
    local vector ScreenPos;

    local vector dir1, dir2;
    local float dist, DotV;

    local int iFont;

    local string    AdditionalInfo;

     foreach DynamicActors(class'Pawn',P)
    {
        // ²»ÊÇ×Ô¼º
        if ( P.PlayerReplicationInfo != none && P != PlayerOwner.Pawn && !P.bTearOff )
        {
            // »­Í·¶¥Ãû×Ö**test
            if( (p.GetTeamNum() != 255 && p.GetTeamNum() == GetPRI().Team.TeamIndex)
                || GetPRI().bAdmin )
            {
                if ( PlayerOwner.Pawn != none )
                {
                    Dir1 = vector(PlayerOwner.Pawn.Rotation);
                    Dir2 = Normal(p.Location - PlayerOwner.Pawn.Location);
                    dist = VSize(p.Location - PlayerOwner.Pawn.Location);
                    DotV = Dir1 dot Dir2;

                    if (DotV <= 0.1)
                    {
                        continue;
                    }
                }
                else
                {
                    Dir1 = vector(PlayerOwner.Rotation);
                    Dir2 = Normal(p.Location - PlayerOwner.Location);
                    dist = VSize(p.Location - PlayerOwner.Location);
                }

                if ( p.GetTeamNum() != 255 && p.GetTeamNum() == GetPRI().Team.TeamIndex )
                {
                    Canvas.SetDrawColor(0, 153, 68, 255);
                }
                else
                {
                    Canvas.SetDrawColor(230, 0, 18, 255);
                }

                if( dist > self.fxShowNameDist3 )
                {
                    return;
                }
                else if ( dist > self.fxShowNameDist2 )
                {
                    iFont = 2;
                }
                else if( dist > self.fxShowNameDist1 )
                {
                    iFont = 1;
                }
                else
                {
                    iFont = 0;
                }

                if ( GetPRI().bAdmin )
                {
                    AdditionalInfo = " HP:"$P.Health;
                }

                KFXDrawPlayerName(Canvas, P, ScreenPos, iFont ,AdditionalInfo);
            }
        }
    }
}

simulated function KFXDrawPlayerName( Canvas Canvas, Pawn P, vector ScreenPos, int iFont ,string AdditionalInfo )
{
    local int Point;

    if ( KFXPlayer(PlayerOwner).bKFXIsNickName )
    {
        DrawPlayerName(Canvas, P, ScreenPos,
            P.PlayerReplicationInfo.PlayerName$AdditionalInfo, 1.0f, iFont);
    }
    else
    {
        Point = KFXPlayerReplicationInfo(P.PlayerReplicationInfo).KFXTotalSPoint;
        DrawPlayerName(Canvas, P, ScreenPos,
            KFXGetDesignation(Point), 1.0f, iFont);
    }
}

simulated function bool KFXDrawPlayerDolbyFlag( Canvas Canvas, Pawn P, vector ScreenPos, int iFont, Byte VoiceFont, string AdditionalInfo )
{
    local vector TraceEnd,TraceStart; // HitLocation,HitNormal,

    if( (KFXPlayerReplicationInfo(P.PlayerReplicationInfo) != none
        &&KFXPlayerReplicationInfo(P.PlayerReplicationInfo).bKFXTeamTalk) ) //¶ÓÎéÓïÒô
    {
        //Ö»ÓÐÍ¬Ò»¶ÓÎé²Å¿ÉÒÔ¿´µ½¶ÓÎé¶Å±È±êÖ¾
        if( KFXInSameTeam(KFXPlayerReplicationInfo(P.PlayerReplicationInfo)) )
        {
            if( P == PlayerOwner.Pawn )
                DrawPlayerDolbyFlag(Canvas, P, ScreenPos,
                    "", 1.0f, iFont,
                    VoiceFont);
            else
                DrawPlayerDolbyFlag(Canvas, P, ScreenPos,
                    P.PlayerReplicationInfo.PlayerName$AdditionalInfo, 1.0f, iFont,
                    VoiceFont);

            return true;
        }
    }
    else //3DÓïÒô
    {
         //ÆäËüÄ£Ê½ ÎÞÂÛÊÇ·ñÍ¬¶Ó¶¼¿ÉÒÔ¿´µ½3D¶Å±È±êÖ¾
        if( KFXInSameTeam(KFXPlayerReplicationInfo(P.PlayerReplicationInfo)) )
        {
            DrawPlayerDolbyFlag(Canvas, P, ScreenPos,
                P.PlayerReplicationInfo.PlayerName$AdditionalInfo, 1.0f, iFont, VoiceFont);

            return true;
        }
        else
        {
            //Èç¹û¿´µÃ¼ûµÐÈË²ÅÏÔÊ¾Dolby±êÖ¾
            TraceStart = PlayerOwner.CalcViewLocation;
            TraceEnd = KFXPawn(P).Location;
            if( PlayerOwner.FastTrace(TraceStart, TraceEnd) )
            {
                DrawPlayerDolbyFlag(Canvas, P, ScreenPos,
                    "", 1.0f, iFont, VoiceFont);

                return true;
            }
        }
        return false;
    }
}

//Ö¸ÏòË­¾Í»­Ë­µÄÃû×Ö
function DrawTargetName(Canvas canvas)
{
	local KFXPawn target;
//	local float xpos, ypos, xl, yl;
	local float xpos, ypos;
//	local float dist;
	local string distName;
	local float xl, yl;

	if(PlayerOwner.Pawn == none)
	{
		return;
	}
	if(KFXCurrTracePawn != none)
	{
		target = KFXPawn(KFXCurrTracePawn);
	}
	if(target != none && target != PlayerOwner.Pawn)
	{
		//Èç¹ûÊÇ¶Ô·½£¬ÄÇÃ´»­ºìÃû£¬·ñÔò»­ÂÌÃû


		xpos = 526;
		ypos = 410;
		Canvas.KFXSetPivot(DP_MiddleMiddle);
		if(target.PlayerReplicationInfo.Team.TeamIndex != PlayerOwner.PlayerReplicationInfo.Team.TeamIndex)
		{
			//µÐÈË
        	Canvas.SetDrawColor(164, 0, 0, 217);
	        Canvas.KFXFontAlias = "heavymedium14";
			Canvas.KFXDrawStrJustified(target.PlayerReplicationInfo.PlayerName, 1,
						TargetNameXPos, TargetNameYPos, TargetNameXL, TargetNameYL);
			distName = target.PlayerReplicationInfo.PlayerName;
			Canvas.KFXStrLen(distName, XL, YL);
		}
		else
		{
			//Ö¸Ïò¶ÓÓÑÄÇÃ´ÏÔÊ¾
			if(!KFXPlayer(PlayerOwner).bShowTeammates)
			{
	        	Canvas.SetDrawColor(0, 113, 48, 255);
		        Canvas.KFXFontAlias = "heavymedium14";
				Canvas.KFXDrawStrJustified(target.PlayerReplicationInfo.PlayerName, 1,
										TargetNameXPos, TargetNameYPos, TargetNameXL, TargetNameYL);
				distName = target.PlayerReplicationInfo.PlayerName;
				Canvas.KFXStrLen(distName, XL, YL);
			}
		}
		//Èç¹ûÓÐ¸´³ð±ê¼Ç£¬ÄÇÃ´»­¸´³ð
		if(GetPRI().nIDLastKillMe > 0 && GetPRI().nIDLastKillMe == KFXPlayerReplicationInfo(target.PlayerReplicationInfo).fxPlayerDBID
				&& target.PlayerReplicationInfo.Team.TeamIndex != PlayerOwner.PlayerReplicationInfo.Team.TeamIndex)
		{
			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.SetPos((TargetNameXL+TargetNameXPos)/2.0 - XL/2 - 23.0 - 2, (TargetNameYL+TargetNameYPos)/2.0 - 25.0/2);
			Canvas.KFXDrawXMLTile("mat2_HUD_interface", "NewImage17", true, 23, 25);
		}

	}
	//Èç¹ûÐèÒªÏÔÊ¾¶ÓÓÑ£¬ÄÇÃ´¾ÍÏÔÊ¾à¶
	if(KFXPlayer(PlayerOwner).bShowTeammates)
	{
	    KFXDrawSameTeamName(Canvas);
	}
}
simulated function DrawName(Canvas Canvas)
{
//    local Pawn P;
//    local vector ScreenPos;
//
//    local vector dir1, dir2;
//    local float dist, DotV;
//
//    local int iFont;
//
//    local string    AdditionalInfo;

    //<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 2.10
//	local Actor ClickActor;
//	local byte VoiceFont;
	//>>

    // ±éÀúËùÓÐÍæ¼Ò
//    foreach DynamicActors(class'Pawn',P)
//    {
//        //<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 1.19
//        // Ã»ÓÐ¿ª¶Å±È£¬¾Í²»»­Ïà¹ØHUD
//        if (KFXPlayer(PlayerOwner).DVClient == none
//            || !KFXPlayer(PlayerOwner).DVClient.bDVSpeakEnabled)
//        {
//            break;
//        }
//
//        //ÁÄÌìÊÒÖØÔØÁË»æÖÆGameHUD
//        if ( P.PlayerReplicationInfo != none && !P.bTearOff ) //×Ô¼ºÒ²»­À®°È
//        {
//            VoiceFont = KFXPlayerReplicationInfo(P.PlayerReplicationInfo).KFXCurVoiceFont;
//            if ( VoiceFont == 0)
//            {
//                VoiceFont = KFXPlayerReplicationInfo(P.PlayerReplicationInfo).KFXVoiceFont;
//            }
//            if (P == PlayerOwner.Pawn && KFXPlayer(PlayerOwner).bBehindView && KFXPlayerReplicationInfo(P.PlayerReplicationInfo).KFXTalkVolume != 0)//×Ô¼º
//            {
//                DrawPlayerDolbyFlag(Canvas, P, ScreenPos,
//                                    "", 1.0f, 0,
//                                    VoiceFont);
//                continue;
//            }
//
//            if (P == PlayerOwner.Pawn)// ×Ô¼º£¬ÇÒ²»ÊÇµÚÈýÈË³Æ
//            {
//                continue;
//            }
//
//            if( KFXPawn(P) != none && KFXPlayerReplicationInfo(P.PlayerReplicationInfo).KFXTalkVolume != 0 )
//            {
//                if ( PlayerOwner.Pawn != none )
//                {
//                    Dir1 = vector(PlayerOwner.Pawn.Rotation);
//                    Dir2 = Normal(p.Location - PlayerOwner.Pawn.Location);
//                    dist = VSize(p.Location - PlayerOwner.Pawn.Location);
//                    DotV = Dir1 dot Dir2;
//
//                    if (DotV <= 0.1)
//                    {
//                        continue;
//                    }
//                }
//                else
//                {
//                    Dir1 = vector(PlayerOwner.Rotation);
//                    Dir2 = Normal(p.Location - PlayerOwner.Location);
//                    dist = VSize(p.Location - PlayerOwner.Location);
//                }
//
//                if( dist > self.fxShowNameDist3 )
//                {
//                    continue;
//                }
//                else if ( dist > self.fxShowNameDist2 )
//                {
//                    iFont = 2;
//                }
//                else if( dist > self.fxShowNameDist1 )
//                {
//                    iFont = 1;
//                }
//                else
//                {
//                    iFont = 0;
//                }
//
//                if ( GetPRI().bAdmin )
//                {
//                    AdditionalInfo = " HP:"$P.Health;
//                }
//                KFXDrawPlayerDolbyFlag( Canvas, P, ScreenPos, iFont, VoiceFont , AdditionalInfo);
//
//            }
//        }
//    }
    KFXDrawSameTeamName(Canvas);
}

//µÃµ½Ä³¸öActorÔÚÆÁÄ»ÉÏµÄ×ø±ê
function GetActorScreenPos(Canvas C, Actor A, out float xpos, out float ypos, float ColExpand)
{
	local vector	TmpScrCorner[2], ScrCornerY[2], ScrCornerX[2];
	local vector 	ScrPos;
//	local float		XL, YL;
	local vector	CameraLocation;
	local rotator	CameraRotation;
//	local color     fxShadeColor;

	C.GetCameraLocation( CameraLocation, CameraRotation );
	C.Style = ERenderStyle.STY_Alpha;

	// µÃµ½Æ½Ãæ×ø±ê add by zjpwxh@kingsoft
	ScrPos = C.WorldToScreen( A.Location );

	// µÃµ½°üÎ§ºÐ¸ß¶È
	if ( CameraLocation.Z < A.Location.Z )
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect( 1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Front
		ScrCornerY[1] = GetScreenCorner( C, A, Vect(-1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Back
	}
	else
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect(-1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Back
		ScrCornerY[1] = GetScreenCorner( C, A, Vect( 1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Front
	}

	// µÃµ½°üÎ§ºÐ¿í¶È
	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0, 1, 1), ScrPos, CameraRotation, ColExpand ); // Left Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0, 1,-1), ScrPos, CameraRotation, ColExpand ); // Left Bottom
	ScrCornerX[0].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0,-1, 1), ScrPos, CameraRotation, ColExpand ); // Right Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0,-1,-1), ScrPos, CameraRotation, ColExpand ); // Right Bottom
	ScrCornerX[1].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	xpos = ScrPos.X;
	ypos = ScrPos.Y - ScrCornerY[0].Y;

//	if(xpos < 0)
//		xpos = 0;
//	if(ypos < 0)
//		ypos = 0;
//	if(xpos > c.SizeX)
//		xpos = c.SizeX;
//	if(ypos > c.SizeY)
//		ypos = c.SizeY;
}

function DrawPlayerName
(
    Canvas C,
    Actor A,
    vector ScrPos,
    string Description,
    float ColExpand,
    int Font
)
{
	local vector	TmpScrCorner[2], ScrCornerY[2], ScrCornerX[2];
	local float		XL, YL;
	local vector	CameraLocation;
	local rotator	CameraRotation;
	local color     fxShadeColor;

	C.GetCameraLocation( CameraLocation, CameraRotation );
	C.Style = ERenderStyle.STY_Alpha;

	// µÃµ½Æ½Ãæ×ø±ê add by zjpwxh@kingsoft
	ScrPos = C.WorldToScreen( A.Location );

	// µÃµ½°üÎ§ºÐ¸ß¶È
	if ( CameraLocation.Z < A.Location.Z )
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect( 1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Front
		ScrCornerY[1] = GetScreenCorner( C, A, Vect(-1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Back
	}
	else
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect(-1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Back
		ScrCornerY[1] = GetScreenCorner( C, A, Vect( 1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Front
	}

	// µÃµ½°üÎ§ºÐ¿í¶È
	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0, 1, 1), ScrPos, CameraRotation, ColExpand ); // Left Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0, 1,-1), ScrPos, CameraRotation, ColExpand ); // Left Bottom
	ScrCornerX[0].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0,-1, 1), ScrPos, CameraRotation, ColExpand ); // Right Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0,-1,-1), ScrPos, CameraRotation, ColExpand ); // Right Bottom
	ScrCornerX[1].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	// »­ÎÄ×Ö**¾ÓÖÐ
	if ( Description != "" )
	{
        switch( Font )
        {
            case 0:
                C.KFXFontAlias = "heavymedium14";
                break;

            case 1:
                C.KFXFontAlias = "heavymedium14";
                break;

            case 2:
                C.KFXFontAlias = "heavymedium14";
                break;
        }
        //C.KFXFontAlias = KFXSpecFontAlias;

		C.KFXStrLen(Description, XL, YL);
        if ( Description == "[C4]" )
        {
            ScrPos.Y=ScrPos.Y-20;
        }
		// ×ó±ßÎ»ÖÃ
		TmpScrCorner[0].X = ScrPos.X - ScrCornerX[0].X - XL/2;
		TmpScrCorner[0].Y = ScrPos.Y - ScrCornerY[0].Y - YL;
		if ( TmpScrCorner[0].X < 0 )
			TmpScrCorner[0].X = 0;
		if ( TmpScrCorner[0].X + XL > C.SizeX )
			TmpScrCorner[0].X = C.SizeX - XL;
		if ( TmpScrCorner[0].Y < 0 )
			TmpScrCorner[0].Y = 0;

		// ÓÒ±ßÎ»ÖÃ
		TmpScrCorner[1].X = ScrPos.X + ScrCornerX[1].X + XL/2;
		TmpScrCorner[1].Y = ScrPos.Y - ScrCornerY[0].Y;
		if ( TmpScrCorner[1].X < 0 )
			TmpScrCorner[1].X = XL;
		if ( TmpScrCorner[1].X > C.SizeX )
			TmpScrCorner[1].X = C.SizeX;
		if ( TmpScrCorner[1].Y < 0 )
			TmpScrCorner[1].Y = C.SizeY;

		// ¿ªÊ¼»­
		fxShadeColor.A = 255;
		fxShadeColor.R = 0;
        fxShadeColor.G = 0;
        fxShadeColor.B = 0;

        C.KFXDrawStrJustifiedWithBorder(Description, 1,
            TmpScrCorner[0].X, TmpScrCorner[0].Y,
            TmpScrCorner[1].X, TmpScrCorner[1].Y,
            fxShadeColor, -1
            );
        /*
        if( GetPRI().IsBlueTeam() )
        {
            s = "fx_ui2_texs.hud_banner_blue";
        }
        else if( GetPRI().IsRedTeam() )
        {
            s = "fx_ui2_texs.hud_banner_red";
        }

        C.SetPos( (TmpScrCorner[0].X + TmpScrCorner[1].X)/2 - 16, TmpScrCorner[0].Y - 16);
        C.SetDrawColor(255, 255, 255, 255);
        C.DrawTile(Material(DynamicLoadObject(s, class'Material')),
            32 * C.SizeX / 1024,
            32 * C.SizeY / 768,
            0, 0, 32, 32 );
        */
	}
}

//<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 1.19

function DrawPlayerDolbyFlag
(
    Canvas C,
    Actor A,
    vector ScrPos,
    string Description,
    float ColExpand,
    int Font,
    byte VoiceFont
)
{
	local vector	TmpScrCorner[2], ScrCornerY[2], ScrCornerX[2];
	local float		XL, YL;
	local vector	CameraLocation;
	local rotator	CameraRotation;
	local color     fxShadeColor;
	local string    MatURL;

	C.GetCameraLocation( CameraLocation, CameraRotation );
	C.Style = ERenderStyle.STY_Alpha;

	// µÃµ½Æ½Ãæ×ø±ê add by zjpwxh@kingsoft
	ScrPos = C.WorldToScreen( A.Location );

	// µÃµ½°üÎ§ºÐ¸ß¶È
	if ( CameraLocation.Z < A.Location.Z )
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect( 1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Front
		ScrCornerY[1] = GetScreenCorner( C, A, Vect(-1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Back
	}
	else
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect(-1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Back
		ScrCornerY[1] = GetScreenCorner( C, A, Vect( 1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Front
	}

	// µÃµ½°üÎ§ºÐ¿í¶È
	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0, 1, 1), ScrPos, CameraRotation, ColExpand ); // Left Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0, 1,-1), ScrPos, CameraRotation, ColExpand ); // Left Bottom
	ScrCornerX[0].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0,-1, 1), ScrPos, CameraRotation, ColExpand ); // Right Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0,-1,-1), ScrPos, CameraRotation, ColExpand ); // Right Bottom
	ScrCornerX[1].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	// »­ÎÄ×Ö**¾ÓÖÐ
	if ( Description != "" )
	{
        switch( Font )
        {
            case 0:
                C.KFXFontAlias = KFXBaseFontAlias;
                break;

            case 1:
                C.KFXFontAlias = KFXSpecFontAlias;
                break;

            case 2:
                C.KFXFontAlias = KFXChatFontAlias;
                break;
        }
        //C.KFXFontAlias = KFXSpecFontAlias;

		C.KFXStrLen(Description, XL, YL);
        if ( Description == "[C4]" )
        {
            ScrPos.Y=ScrPos.Y-20;
        }
		// ×ó±ßÎ»ÖÃ
		TmpScrCorner[0].X = ScrPos.X - ScrCornerX[0].X - XL/2;
		TmpScrCorner[0].Y = ScrPos.Y - ScrCornerY[0].Y - YL;
		if ( TmpScrCorner[0].X < 0 )
			TmpScrCorner[0].X = 0;
		if ( TmpScrCorner[0].X + XL > C.SizeX )
			TmpScrCorner[0].X = C.SizeX - XL;
		if ( TmpScrCorner[0].Y < 0 )
			TmpScrCorner[0].Y = 0;

		// ÓÒ±ßÎ»ÖÃ
		TmpScrCorner[1].X = ScrPos.X + ScrCornerX[1].X + XL/2;
		TmpScrCorner[1].Y = ScrPos.Y - ScrCornerY[0].Y;
		if ( TmpScrCorner[1].X < 0 )
			TmpScrCorner[1].X = XL;
		if ( TmpScrCorner[1].X > C.SizeX )
			TmpScrCorner[1].X = C.SizeX;
		if ( TmpScrCorner[1].Y < 0 )
			TmpScrCorner[1].Y = C.SizeY;

		// ¿ªÊ¼»­
		fxShadeColor.A = 255;
		fxShadeColor.R = 0;
        fxShadeColor.G = 0;
        fxShadeColor.B = 0;

        TmpScrCorner[1].X = (TmpScrCorner[0].X + TmpScrCorner[1].X)/2 + XL/2 ;
        TmpScrCorner[0].Y = (TmpScrCorner[0].Y + TmpScrCorner[1].Y)/2 - YL/2 ;
        //C.KFXDrawStrJustifiedWithBorder(Description, 1,
        //    TmpScrCorner[0].X, TmpScrCorner[0].Y,
        //    TmpScrCorner[1].X, TmpScrCorner[1].Y,
        //    fxShadeColor, -1
        //    );
	}
	else //²»ÏÔÊ¾Ãû×ÖµÄ×ø±ê´¦Àí
	{
	   //Ã»ÓÐÎÄ×ÖËùÒÔÖÃÁã
	   XL = 0;
	   YL = 0;

	   //ÒòÎª²»ÏÔÊ¾ÎÄ×Ö YLÎªÁã ËùÒÔ¿Õ³ö20ÏñËØµÄ×Ö¸ß
	   ScrPos.Y=ScrPos.Y-20;

       // ×ó±ßÎ»ÖÃ
		TmpScrCorner[0].X = ScrPos.X - ScrCornerX[0].X - XL/2;
		TmpScrCorner[0].Y = ScrPos.Y - ScrCornerY[0].Y - YL;
		if ( TmpScrCorner[0].X < 0 )
			TmpScrCorner[0].X = 0;
		if ( TmpScrCorner[0].X + XL > C.SizeX )
			TmpScrCorner[0].X = C.SizeX - XL;
		if ( TmpScrCorner[0].Y < 0 )
			TmpScrCorner[0].Y = 0;

		// ÓÒ±ßÎ»ÖÃ
		TmpScrCorner[1].X = ScrPos.X + ScrCornerX[1].X + XL/2;
		TmpScrCorner[1].Y = ScrPos.Y - ScrCornerY[0].Y;
		if ( TmpScrCorner[1].X < 0 )
			TmpScrCorner[1].X = XL;
		if ( TmpScrCorner[1].X > C.SizeX )
			TmpScrCorner[1].X = C.SizeX;
		if ( TmpScrCorner[1].Y < 0 )
			TmpScrCorner[1].Y = C.SizeY;

		TmpScrCorner[1].X = (TmpScrCorner[0].X+TmpScrCorner[1].X)/2;
    }

    C.SetDrawColor(255, 255, 255, 255);
    C.SetPos(TmpScrCorner[1].X, TmpScrCorner[0].Y-8);   //À®°È1// ¼õ8ÊÇÒòÎªÍ¼±ê´Ó16x16»»³É32x32ÁË

//    if( KFXPlayerReplicationInfo(Pawn(A).PlayerReplicationInfo).bKFXMute )
//        C.DrawTile(Material(DynamicLoadObject(fx_HUD_Dolby_smallhorn_x, class'Material')),
//                    16, 16, 0, 0, 16, 16);
//    else
//        C.DrawTile(Material(DynamicLoadObject(fx_HUD_Dolby_smallhorn, class'Material')),
//                    16, 16, 0, 0, 16, 16);
    MatURL = KFXPlayer(PlayerOwner).DVClient.DVGetSpeakIndicator(
                VoiceFont,
                KFXPlayerReplicationInfo(Pawn(A).PlayerReplicationInfo).bKFXMute,
                false);
    C.DrawTile(Material(DynamicLoadObject(MatURL, class'Material')),
                    32, 32, 0, 0, 32, 32);
}
/*
function DrawPlayerDolbyFlag
(
    Canvas C,
    Actor A,
    vector ScrPos,
    float ColExpand
)
{
	local vector	TmpScrCorner[2], ScrCornerY[2], ScrCornerX[2];
	local float		XL, YL;
	local vector	CameraLocation;
	local rotator	CameraRotation;
	local color     fxShadeColor;

	C.GetCameraLocation( CameraLocation, CameraRotation );
	C.Style = ERenderStyle.STY_Alpha;

	// µÃµ½Æ½Ãæ×ø±ê add by zjpwxh@kingsoft
	ScrPos = C.WorldToScreen( A.Location );

	// µÃµ½°üÎ§ºÐ¸ß¶È
	if ( CameraLocation.Z < A.Location.Z )
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect( 1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Front
		ScrCornerY[1] = GetScreenCorner( C, A, Vect(-1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Back
	}
	else
	{
		ScrCornerY[0] = GetScreenCorner( C, A, Vect(-1, 0, 1), ScrPos, CameraRotation, ColExpand );	// Top Back
		ScrCornerY[1] = GetScreenCorner( C, A, Vect( 1, 0,-1), ScrPos, CameraRotation, ColExpand );	// Bottom Front
	}

	// µÃµ½°üÎ§ºÐ¿í¶È
	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0, 1, 1), ScrPos, CameraRotation, ColExpand ); // Left Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0, 1,-1), ScrPos, CameraRotation, ColExpand ); // Left Bottom
	ScrCornerX[0].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );

	TmpScrCorner[0] = GetScreenCorner( C, A, Vect( 0,-1, 1), ScrPos, CameraRotation, ColExpand ); // Right Top
	TmpScrCorner[1] = GetScreenCorner( C, A, Vect( 0,-1,-1), ScrPos, CameraRotation, ColExpand ); // Right Bottom
	ScrCornerX[1].X	= Max( TmpScrCorner[0].X, TmpScrCorner[1].X );





	// ×ó±ßÎ»ÖÃ
	TmpScrCorner[0].X = ScrPos.X - ScrCornerX[0].X - XL/2;
	TmpScrCorner[0].Y = ScrPos.Y - ScrCornerY[0].Y - YL;
	if ( TmpScrCorner[0].X < 0 )
		TmpScrCorner[0].X = 0;
	if ( TmpScrCorner[0].X + XL > C.SizeX )
		TmpScrCorner[0].X = C.SizeX - XL;
	if ( TmpScrCorner[0].Y < 0 )
		TmpScrCorner[0].Y = 0;

	// ÓÒ±ßÎ»ÖÃ
	TmpScrCorner[1].X = ScrPos.X + ScrCornerX[1].X + XL/2;
	TmpScrCorner[1].Y = ScrPos.Y - ScrCornerY[0].Y;
	if ( TmpScrCorner[1].X < 0 )
		TmpScrCorner[1].X = XL;
	if ( TmpScrCorner[1].X > C.SizeX )
		TmpScrCorner[1].X = C.SizeX;
	if ( TmpScrCorner[1].Y < 0 )
		TmpScrCorner[1].Y = C.SizeY;

	// ¿ªÊ¼»­
	fxShadeColor.A = 255;
	fxShadeColor.R = 0;
    fxShadeColor.G = 0;
    fxShadeColor.B = 0;

    C.SetDrawColor(255, 255, 255, 255);
    C.SetPos((TmpScrCorner[0].X+TmpScrCorner[1].X)/2, TmpScrCorner[0].Y-18);   //À®°È1
    C.DrawTile(Material(DynamicLoadObject(fx_HUD_Dolby_smallhorn, class'Material')),
                    16, 16, 0, 0, 16, 16);

}
*/
//>>

/* Helper to get cylinder's "corners" (edges on projected canvas) */
static function vector GetScreenCorner
(
    Canvas C,
    Actor A,
    vector CornerVect,
    vector IPScrO,
    rotator CameraRotation,
    float ColExpand
)
{
	local vector	IPDir, IPCorner, IPScreenCorner;

	// Finding "corner's" 3D location...
	IPDir		= -1 * Vector(CameraRotation);
	IPDir.Z		= 0;											// we just need the horizontal direction..
	IPCorner	= CornerVect >> Normalize( Rotator(IPDir) );	// Rotate vector to point to specified "corner"...

	// Expand by collision radius...
	IPCorner.X *= A.CollisionRadius * ColExpand;
	IPCorner.Y *= A.CollisionRadius * ColExpand;
	IPCorner.Z *= A.CollisionHeight * ColExpand;

	// Screen coordinates of IP's "corner"
	IPScreenCorner		= C.WorldToScreen( A.Location + IPCorner );
	IPScreenCorner.X	= Abs( IPScreenCorner.X - IPScrO.X );
	IPScreenCorner.Y	= Abs( IPScreenCorner.Y - IPScrO.Y );

	return IPScreenCorner;
}

// »­¶ÔÊÖÃû×Ö
simulated function DrawActorInfo(Canvas C, Actor A)
{
    local KFXPawn P;

    local int Point;

    local int TempColor;

    TempColor = Rand(20)+30;

    P = KFXPawn(A);

    if( P != none && P.PlayerReplicationInfo != none && P != PlayerOwner.Pawn && !P.bTearOff)
    {
        if( P.PlayerReplicationInfo.Team == none || P.PlayerReplicationInfo.Team.TeamIndex != GetPRI().Team.TeamIndex )
        {
            C.SetDrawColor(255-TempColor, TempColor, TempColor, 255);
            C.KFXFontAlias = KFXSpecFontAlias;
            if ( KFXPlayer(PlayerOwner).bKFXIsNickName||
            ( P != none&&P.IsBot ) )
            {
                C.KFXDrawStrJustifiedWithBorder(P.PlayerReplicationInfo.PlayerName, 1,
                    412* C.SizeX/1024, 400* C.SizeY/768,        // Remain proportion
                    612* C.SizeX/1024, 500* C.SizeY/768,
                    ShadeColor, -1
                    );
            }
            else
            {
                Point = KFXPlayerReplicationInfo(P.PlayerReplicationInfo).KFXTotalSPoint;
                C.KFXDrawStrJustifiedWithBorder(KFXGetDesignation(Point), 1,
                    412* C.SizeX/1024, 400* C.SizeY/768,        // Remain proportion
                    612* C.SizeX/1024, 500* C.SizeY/768,
                    ShadeColor, -1
                    );
            }
        }
    }
}

// »­ÓïÒôÁÄÌìÌõ
function DisplayVoiceGain(Canvas Canvas)
{
	local float VoiceGain;

	VoiceGain = (1 - 3 * Min( Level.TimeSeconds - LastVoiceGainTime, 0.3333 )) * LastVoiceGain;

    if( VoiceGain > 1.0 )
    {
        VoiceGain = 1.0;
    }

	Canvas.SetDrawColor(255, 255, 255, 255);

    /*
    // ÏÈ»­¸ö¿ò
    Canvas.SetPos( 16 * Canvas.SizeX / 1024, 369 * Canvas.SizeY / 768 );
    Canvas.DrawTile( Material'fx_ui2_texs.yuyin',
        13 * Canvas.SizeX / 1024,
        109 * Canvas.SizeY / 768,
        0, 0, 13, 109 );

    // ÏÂÃæ»­½ø¶È
    Canvas.SetPos(16*Canvas.SizeX/1024, (460-90*VoiceGain)*Canvas.SizeY/768);
    Canvas.DrawTile( Material'fx_ui2_texs.yuyin_2',
        16 * Canvas.SizeX/1024,
        (90*VoiceGain) * Canvas.SizeY/768,
        0, 0, 16, 90*VoiceGain );
    */
}



// ´¦ÀíÆµµÀÐÅÏ¢
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
    local color TextColor;

    if ( bMessageBeep )
    {
        PlayerOwner.PlayBeepSound();
    }
    log("KFXHUD-------MsgType "$MsgType);
    if ( MsgType =='Say')
    {

        Msg = "["$lPublicChat$"]"$PRI.PlayerName$SMT_Semicolon$Msg;
        TextColor = PublicChatColor;
    }
    else if (MsgType == 'TeamSay')
    {
        Msg = "["$lTeamChat$"]"$PRI.PlayerName$SMT_Semicolon$Msg;
        TextColor = TeamChatColor;
        log("KFXHUD---111----Msg "$Msg);
    }
 //------
  //jinxin add 2011-12-20
     else if (MsgType == 'BotChat')
     {
       //   if(PRI.PlayerName)      //is bot has name?
          Msg = "["$lPublicChat$"]"$PRI.PlayerName$SMT_Semicolon$Msg;
          TextColor = BotChatcolor;
     }
 //------

    // ºêº°»°
    else if( MsgType == 'TeamShout' )
    {
        Msg = "["$lTeamChat$"]"$PRI.PlayerName$SMT_Semicolon$Msg;
        TextColor = TeamShoutColor;
        log("KFXHUD---222----Msg "$Msg);
    }
    else if( MsgType == 'System' )
    {
        Msg = "["$lSystem$"]"$SMT_Semicolon$Msg;
        TextColor = SystemColor;
    }
    else
    {
        TextColor = NormalColor;
    }

    KFXAddTextMessage(Msg, class'LocalMessage', PRI, TextColor);
    Log("[KFXHUD] jinxinbotautochathud------msg="$Msg);
}

exec function MyMacro(string PlayerName, string Msg, int MsgType, int nCityCode, int nIsMember)
{
	ChatMessageOutGame(PlayerName, Msg, MsgType, nCityCode, nIsMember);
}

/// ´¦ÀíÓÎÏ·ÍâÀ´µÄÁÄÌìÐÅÏ¢                                                                        //»áÔ±º°»°±êÖ¾
simulated function ChatMessageOutGame(string PlayerName, string Msg, int MsgType, int nCityCode, int nIsMember)
{                         //liubo,ÔÚÕâÀï´¦Àí»áÔ±µÄº°»°ÏûÏ¢¡£
    local color TextColor;
    local string sCityName;
    //local string sProvince;
    local KFXCSVTable CityCSV;      //³ÇÊÐÐÅÏ¢
    //local int  nTempID;
    CityCSV = class'KFXTools'.static.KFXCreateCSVTable("KFXCityinfo.csv");
    if (CityCSV != None)
    {
        if (!CityCSV.SetCurrentRow(nCityCode))
        {
            log ("[HUD_Chat] Invalid CityCode");
        }
        else
        {
//            sProvince = CityCSV.GetString("Province");
            sCityName = CityCSV.GetString("City");
//            if(sProvince != sCityName)
//               sCityName = sProvince$sCityName;
        }
    }
    else
    {
       log("ChatMessageOutGame create KFXCityinfo CSV failed!");
    }
    if ( bMessageBeep )
    {
        PlayerOwner.PlayBeepSound();
    }
    if ( MsgType == 1)         //È«ÌåÁÄÌì
    {
        if ( !KFXPlayer(PlayerOwner).bKFXKeyOfChat )
            return;
        log("KFXHUD-----KFXPlayer(PlayerOwner).bIsChatWithAll "$KFXPlayer(PlayerOwner).bIsChatWithAll);
        if(!KFXPlayer(PlayerOwner).bIsChatWithAll)
            return;
        if(nCityCode == 10001)
        	Msg = "["$lPublicChat$"]"$PlayerName$SMT_Semicolon$Msg;
        else
	        Msg = "["$lPublicChat$"]["$sCityName$"]"$PlayerName$SMT_Semicolon$Msg;
        TextColor = PublicChatColor;
    }
    if ( MsgType == 2)          //Ë½ÈËÁÄÌì
    {
        log("KFXHUD-----KFXPlayer(PlayerOwner).bIsChatWithPersonal "$KFXPlayer(PlayerOwner).bIsChatWithPersonal);
        if(!KFXPlayer(PlayerOwner).bIsChatWithPersonal)
            return;

        if(nCityCode == 10001)
        	Msg = PlayerName$lPersonnalChat$SMT_Semicolon$Msg;
        else
        	Msg = "["$sCityName$"]"$PlayerName$lPersonnalChat$SMT_Semicolon$Msg;

        TextColor = PersonnalChatColor;
    }
    if ( MsgType == 3)	//Õ½¶ÓÁÄÌì
    {
        log("KFXHUD-----KFXPlayer(PlayerOwner).bIsChatWithFaction "$KFXPlayer(PlayerOwner).bIsChatWithFaction);
        if(!KFXPlayer(PlayerOwner).bIsChatWithFaction)
            return;

        if(nCityCode == 10001)
        	Msg = "["$lGroupChat$"]"$PlayerName$SMT_Semicolon$Msg;
        else
        	Msg = "["$lGroupChat$"]["$sCityName$"]"$PlayerName$SMT_Semicolon$Msg;
        TextColor = GroupChatColor;
    }
    log("KFXHUD-----MsgType "$MsgType);
    if ( MsgType == 4)        //ÏµÍ³¹«¸æ
    {
        log("KFXHUD-----KFXPlayer(PlayerOwner).bIsSystemMessage "$KFXPlayer(PlayerOwner).bIsSystemMessage);
        if(!KFXPlayer(PlayerOwner).bIsSystemMessage)
            return;

        TextColor = SystemColor;
    }
     if ( MsgType == 5)
    {
        //Èç¹ûÊÇ»áÔ±ÇÒÊ¹ÓÃÁË´óÀ®°È¡¢Ð¡À®°È£¬ÄÇÃ´ sCityName = sCityName$"%MaterialName%";
		//ÎªÁËÍ³Ò»¾ö¶¨ÓÃ%&.´úÌæ/*°üÎ§×ÊÔ´Ãû×Ö
    	if(nIsMember>0)
        {
	    	TextColor = colorVipBugle;
		}
        else
        {
			log("KFXHUD-----KFXPlayer(PlayerOwner).bIsCanHearSpeaker "$KFXPlayer(PlayerOwner).bIsCanHearSpeaker);
//            if(!KFXPlayer(PlayerOwner).bIsCanHearSpeaker)
//                 return;

            if(nCityCode == 10001)
		        Msg = "["$SmallBugleChat$"]"$PlayerName$SMT_Semicolon$Msg;
    		else
    		    Msg = "["$SmallBugleChat$"]["$sCityName$"]"$PlayerName$SMT_Semicolon$Msg;

		    TextColor = SmallBugleColor;
    	}
    }
     if ( MsgType == 7)
    {
        //Èç¹ûÊÇ»áÔ±ÇÒÊ¹ÓÃÁË´óÀ®°È¡¢Ð¡À®°È£¬ÄÇÃ´ sCityName = sCityName$"%MaterialName%"; ²¢ÇÒÑÕÉ«±ä³É(255, 240, 5)
    	if(nIsMember>0)
        {
	    	TextColor = colorVipBugle;
		}
        else
        {
		    log("KFXHUD-----KFXPlayer(PlayerOwner).bIsCanHearSpeaker "$KFXPlayer(PlayerOwner).bIsCanHearSpeaker);
            if(!KFXPlayer(PlayerOwner).bIsCanHearSpeaker)
                 return;

            if(nCityCode == 10001)
		        Msg = "["$BigBugleChat$"]"$PlayerName$SMT_Semicolon$Msg;
			else
			    Msg = "["$BigBugleChat$"]["$sCityName$"]"$PlayerName$SMT_Semicolon$Msg;
			TextColor = BigBugleColor;
    	}
    }
    if (MsgType == 8)          //¶ÓÎéÁÄÌì
    {
        if ( !KFXPlayer(PlayerOwner).bKFXKeyOfChat )
            return;

        log("KFXHUD-----KFXPlayer(PlayerOwner).bIsChatWithTeam "$KFXPlayer(PlayerOwner).bIsChatWithTeam);
        if(!KFXPlayer(PlayerOwner).bIsChatWithTeam)
            return;

        if(nCityCode == 10001)
	        Msg = "["$lTeamChat$"]"$PlayerName$SMT_Semicolon$Msg;
    	else
    	    Msg = "["$lTeamChat$"]["$sCityName$"]"$PlayerName$SMT_Semicolon$Msg;

	    TextColor = TeamChatColor;
    }
    if(MsgType == 9){	//°ÔÆÁ
    	TextColor = colorPrado[0];                                                                        //¼Ó¿Õ¸ñ

	}else if(MsgType == 10){
		TextColor = colorPrado[1];

	}

    if ( MsgType == 30)
    {
        Msg = lYouPersonal$PlayerName$lSay$SMT_Semicolon$Msg;
        TextColor = PersonnalChatColor;
    }
    if ( MsgType == 31)
    {
        Msg = "["$lSystem$"]"$SMT_Semicolon$Msg;
        TextColor = SystemColor;
    }
	if(MsgType == 40)
	{
		Msg = SMT_ItemBroadcast$Msg;
		TextColor = COLOR_ItemBroadcast;
	}
	                               //ÔÚÉÏÃæ×î¶à¸ÄÒ»ÏÂº°»°µÄÑÕÉ«¡£Ïë°ì·¨ÔÚÆäÖÐ²åÈëÒ»¸övipÍ¼Æ¬°É£¡
    KFXAddTextMessage(Msg, class'LocalMessage', none, TextColor);    //Ïëµ½µÄµÚÒ»¸ö·½·¨¾ÍÊÇ:  $material$msg  ºÙºÙ¹þ¹þ
}


// Ìí¼ÓÏûÏ¢**ÐÞ¸Ä¿ÉÒÔÅäÖÃÑÕÉ«ºÍÌõÄ¿
/*function KFXAddTextMessage(string Msg, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI, color TextColor)
{
	local int i;

	if( bMessageBeep && MessageClass.Default.bBeep )
    {
		PlayerOwner.PlayBeepSound();
	}

    for( i = 0; i < ConsoleMessageCount; i++ )
    {
        if ( TextMessages[i].Text == "" )
        {
            break;
        }
    }

    if( i == ConsoleMessageCount )
    {
        for( i = 0; i < ConsoleMessageCount-1; i++)
        {
            TextMessages[i] = TextMessages[i+1];
        }
    }

    TextMessages[i].Text = Msg;
    TextMessages[i].PRI = PRI;
    TextMessages[i].MessageLife = Level.TimeSeconds + MessageClass.Default.LifeTime;
    TextMessages[i].TextColor = TextColor;
}*/

function KFXAddTextMessage(string Msg, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI, color TextColor)
{
	local int           i, ix, j;
	local Array<string> Contents;
	local Array<string> Lines;
    local string        alias;
    local string        MaterialName;
    local Array<MaterialInfo> MaterialNames;
    local bool          bResult;
    local KFXCSVTable   CSVIconInfos;
    local int           index;
    local int           nOrders;
    local string        blanks;
    local int           stringlen;
    local float          XL,YL;
    local int            ChangeLineLenth;
    local string         tempAlias;
	local int 			aForMember, bForMember;
	local string		strForMember;
	local string 		tmp;

if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_ChatMsg(msg,
			(TextColor.A<<24)|(TextColor.R<<16)|(TextColor.G<<8)|(TextColor.B<<0));
}
else
{
    blanks = "             ";
    CSVIconInfos = class'KFXTools'.static.KFXCreateCSVTable("SmileyIcons.csv");

	if( bMessageBeep && MessageClass.Default.bBeep )
    {
		PlayerOwner.PlayBeepSound();
	}

	//liubo,Õâ¶Î´úÂë»¹ÊÇ²»Áé»î£¬¶¼ÊÇ¹Ì¶¨µÄÖµ ,ÁÙÊ±½â¾ö°ì·¨¾ÍÊÇÔÚÍ¼Æ¬µÄºóÃæ¼Ó¿Õ¸ñÒÔÌî³ä
	//µ±Ê±ÒÔÎªÍ¦ºÃ£¬µ«ÏÖÔÚ¿´À´¿ÉÅäÐÔÊµÔÚÌ«²î£¡
	//liubo,Èç¹ûÊÇ»áÔ±£¬ÄÇÃ´´¦Àí½«Í¼Æ¬ÐÅÏ¢ÌáÁ¶³öÀ´¡£
	//¼ÓÈë·ûºÅÊÇ£º/**/£¬±êÖ¾°É£¬ºÙºÙ£¡
	strForMember = msg;
	msg = "";
	aForMember = Instr(strForMember, "%&.");
	bForMember = Instr(StrForMember, ".&%");
	while(aForMember>0 && bForMember>0){		//»áÔ±±êÖ¾Ö»ÓÐÒ»¸ö£¬µ«ÊÇ¼Ó¸öwhileÑ­»·¿ÉÒÔ·ÀÖ¹ÒÔºó¼Ó¶à¸öÍ¼±ê¡£
		msg = msg $ Left(strForMember, aForMember);	//½«/*×ó²¿·Ö¼ÓÈëµ½msgÖÐ

		strForMember = Right(strForMember, Len(strForMember) - aForMember - 3);
		tmp = Left(strForMember, bForMember-aForMember-3);
		strForMember = Right(strForMember, Len(strForMember)-(bForMember-aForMember));
		//¸ù¾ÝtmpÃû×Ö¼ÓÔØmaterial¡£
  		if(Material(DynamicLoadObject(tmp, class'Material'))!=none){
			MaterialNames.Insert(MaterialNames.Length, 1);
			MaterialNames[MaterialNames.length-1].MaterialName = tmp;
			MaterialNames[MaterialNames.length-1].MatPosx = len(msg);   //materialÒª»­µÄÆðÊ¼Î»ÖÃ
			MaterialNames[MaterialNames.length-1].U = 0;		//materialµÄX
			MaterialNames[MaterialNames.length-1].v = 0;        //	y
			MaterialNames[MaterialNames.length-1].UL = 52;      //	width;
			MaterialNames[MaterialNames.length-1].vl = 20;		//  height;
			msg = msg $ "      ";	//½«material¶ÔÓ¦µÄÎ»ÖÃ»»³É¿Õ¸ñ
		}else{
			log("#ERROR#  Can't Load <"$tmp$"> Material!");
			//Õý³£Çé¿öÏÂ¿Ï¶¨»á³É¹¦£¬Èç¹û²»³É¹¦£¬ÄÇÃ´¾Í°ÑËüµ±×÷Õý³£×Ö´®´¦Àí¡£
			msg = msg $ tmp;
		}
		aForMember = InStr(strForMember, "%&.");
		bForMember = InStr(StrForMember, ".&%");
	}
	msg = msg $ StrForMember;   //´ËÊ±msg½«ÓÐ"sth$materialName$sth" ----> "sth    sth"
	//<----¸ã¶¨»áÔ±
	Split(Msg, "/", Contents);
	nOrders = ChatTextMessages[ChatTextMessages.Length - 1].index + 1;
    for(i = 1; i < Contents.Length; i++ )
    {
        alias = Left(Contents[i] , 3);
        if(Left(alias, 1) != "0"){ 	//±íÇéµÚÒ»Î»Îª0£¬ÒòÎª¼ÓÈëÁËÒ»Ð©ÌØÊâµÄÍ¼Æ¬µ½±íÇé°üÀïÃæ£¬ËùÒÔµÃ¼ÓÈëÕâÌõÏÞÖÆ
        	contents[0] = Contents[0]$"/"$Contents[i];
			continue;
        }
		if (CSVIconInfos != none)
        {
            for (ix =0; true; ix++)
            {
                 bResult = CSVIconInfos.SetCurrentRow(ix);
                 if (bResult)
                 {
                    if(alias  == CSVIconInfos.GetString("alias"))
                     {
                        MaterialName = CSVIconInfos.GetString("material");
                        break;
                     }
                 }
                else
                {
                    break;
                }
            }
            if(MaterialName != "")
            {
                Contents[i] =  mid(Contents[i], 3);
                MaterialNames.Insert(MaterialNames.Length, 1);
                MaterialNames[MaterialNames.Length - 1].MaterialName = MaterialName;
                MaterialNames[MaterialNames.Length - 1].MatPosx = len(contents[0]);
                MaterialNames[MaterialNames.Length - 1].U = CSVIconInfos.GetInt("U");
                MaterialNames[MaterialNames.Length - 1].V = CSVIconInfos.GetInt("V");
                MaterialNames[MaterialNames.Length - 1].UL = CSVIconInfos.GetInt("UL");
                MaterialNames[MaterialNames.Length - 1].VL = CSVIconInfos.GetInt("VL");
                contents[0] = Contents[0]$"   "$Contents[i];
                MaterialName = "";
            }
            else
            {
                contents[0] = Contents[0]$"/"$Contents[i];
            }

         }
         else
         {
            contents[0] = Contents[0]$"/"$Contents[i];
         }

    }
    if(TempCanvas == none)
        return;
    contents[0]= contents[0]$" ";


    tempAlias = TempCanvas.KFXFontAlias;
    TempCanvas.KFXFontAlias = KFXChatFontAlias;

    TempCanvas.KFXWrapStrToArray(contents[0], Lines, TempCanvas.SizeX/3);
    TempCanvas.KFXStrLen("AAAAAA", XL, YL);
    TempCanvas.KFXFontAlias = tempAlias;
    for(i = 0; i < Lines.Length ; i++ )
    {
       ChangeLineLenth = 0;
       index = ChatTextMessages.Length;
       ChatTextMessages.Insert(index, 1);
       ChatTextMessages[index].text = Lines[i];
       ChatTextMessages[index].TextColor = TextColor;
       ChatTextMessages[index].MessageLife = Level.TimeSeconds + MessageClass.Default.LifeTime;
       ChatTextMessages[index].sizey = 1;
       for(j = 0 ; j < MaterialNames.Length; j++ )
       {
          if(MaterialNames[j].MatPosx + 3 - stringlen  <= len(Lines[i]))
          {
              ix = ChatTextMessages[index].Material.Length;
              ChatTextMessages[index].Material.Insert(ix, 1);
              ChatTextMessages[index].Material[ix] = MaterialNames[j];
              if(MaterialNames[j].MatPosx - stringlen < 0 )
              {
                 ChangeLineLenth = stringlen - MaterialNames[j].MatPosx + 1;
                 ChatTextMessages[index].text = left( blanks, ChangeLineLenth)$ ChatTextMessages[index].text;
              }
              ChatTextMessages[index].Material[ix].MatPosx = MaterialNames[j].MatPosx - stringlen + ChangeLineLenth ;
              ChatTextMessages[index].sizey = 1.5;
              MaterialNames.Remove(j, 1);
              j -- ;
           }
           else
           {
               break;
           }

       }
       stringlen = stringlen + len(lines[i]);
       ChatTextMessages[index].index = nOrders;
    }
    while(ChatTextMessages.Length > 8)
    {
       nOrders = ChatTextMessages[0].index;
       for(j = 0; j < ChatTextMessages.Length; j++)
       {
          if(ChatTextMessages[j].index == nOrders)
           {
               ChatTextMessages.Remove(j, 1);
               j --;
           }
           else
             break;
       }
    }
}
}
function string getBlackspace(int i)
{
 	if(i == 0)
 		return "";
 	else
 		return " "$getBlackspace(i-1);
}

function DisplayMessages(Canvas C)
{
    local int i, j;
    local float  MessageCount;
    local float XL, YL;
    local int XPos, YPos;
    local Material  ItemIcon;
    local string leftpart;
    local int MaterialU;
    local int MaterialV;
    local int MaterialUL;
    local int MaterialVL;
    local EDrawPivot pv;
    local float posy;


	return;

    if(TempCanvas == none)
       TempCanvas = C;
    // ±éÀúÏûÏ¢ÁÐ±í
    for( i = 0; i < ChatTextMessages.Length; i++ )
    {
        if( ChatTextMessages[i].MessageLife < Level.TimeSeconds - 40 )
        {
            ChatTextMessages.Remove(i, 1);
            i -- ;
        }
        else
        {
			MessageCount = MessageCount + ChatTextMessages[i].sizey;
		}
    }
    GetGameChatPos(C, posy, pv);

	C.KFXSetPivot(pv);
    C.KFXFontAlias = KFXChatFontAlias;
    C.bForceAlpha = false;
    C.KFXStrLen("A", XL, YL);

    XPos = 20;
    //YPos = 650 - (YL+2) * MessageCount; // Modified by Linsen 2008-3-11
    YPos = posy - (YL+2) * MessageCount; //C.SizeY - 118 - (YL+2) * MessageCount; // Modified by Linsen 2008-3-11

    if(!bDisPlayMessages)
         return;
    for( i = 0; i < ChatTextMessages.Length; i++ )
    {
        C.KFXStrLen("A", XL, YL);
        if(ChatTextMessages[i].Material.Length > 0)
        {
           for(j = 0 ; j < ChatTextMessages[i].Material.Length; j ++)
           {
                leftpart = left(ChatTextMessages[i].Text, ChatTextMessages[i].Material[j].MatPosx);
                C.KFXStrLen( leftpart, XL, YL );
                //C.SetPos((XPos + XL)* C.SizeX / 1024, YPos * C.SizeY / 768);
                C.SetPos((XPos + XL) , YPos );
                C.SetDrawColor(255, 255, 255, 255);
                ItemIcon = Material(DynamicLoadObject(ChatTextMessages[i].Material[j].MaterialName, class'Material'));
                MaterialU = ChatTextMessages[i].Material[j].U;
                MaterialV = ChatTextMessages[i].Material[j].V;
                MaterialUL = ChatTextMessages[i].Material[j].UL;
                MaterialVL = ChatTextMessages[i].Material[j].VL;
                //C.DrawTile( ItemIcon, MaterialUL*C.SizeX/1024, MaterialVL*C.SizeY/768, MaterialU, MaterialV, MaterialUL, MaterialVL );
                C.DrawTile( ItemIcon, MaterialUL-4 , MaterialVL-4 , MaterialU, MaterialV, MaterialUL, MaterialVL );
           }
          C.KFXStrLen("A", XL, YL);
          //C.SetPos(XPos * C.SizeX / 1024, (YPos + 1 + YL/4) * C.SizeY / 768);
          C.SetPos(XPos , (YPos + 1 + YL/4) );
          C.DrawColor = ChatTextMessages[i].TextColor;
          if(ChatTextMessages[i].TextColor == colorPrado[0]){
				c.KFXDrawStrWithBorder(ChatTextMessages[i].text, colorPradoShade[0], 0);
          }else if(ChatTextMessages[i].TextColor == colorPrado[1]){
          		c.KFXDrawStrWithBorder(ChatTextMessages[i].text, colorPradoShade[1], 0);
		  }else{
			 C.KFXDrawStrWithBorder(ChatTextMessages[i].text, ShadeColor, -1);
          }
		  YPos += 1.5*(YL + 2);
        }
        else
        {
           //C.SetPos(XPos * C.SizeX / 1024, YPos * C.SizeY / 768);
           C.SetPos(XPos , YPos );
           C.DrawColor = ChatTextMessages[i].TextColor;
           if(ChatTextMessages[i].TextColor == colorPrado[0])
        		c.KFXDrawStrWithBorder(ChatTextMessages[i].text, colorPradoShade[0], 0);
           else if(ChatTextMessages[i].TextColor == colorPrado[1])
           		c.KFXDrawStrWithBorder(ChatTextMessages[i].text, colorPradoShade[1], 0);
		   else
           		C.KFXDrawStrWithBorder(ChatTextMessages[i].text, ShadeColor, -1);
           YPos += (YL + 2);
        }
    }
}

// ÖØÔØÏÔÊ¾º¯Êý**ÁÄÌì¼°ÐÅÏ¢ÇþµÀ
/*
function DisplayMessages(Canvas C)
{
    local int i, j, MessageCount;
    local float XL, YL;
    local int XPos, YPos;

    // ±éÀúÏûÏ¢ÁÐ±í
    for( i = 0; i < ConsoleMessageCount; i++ )
    {
        // Í³¼Æµ±Ç°ÓÐÐ§ÏûÏ¢Êý
        if ( TextMessages[i].Text == "" )
        {
            break;
        }
        else if( TextMessages[i].MessageLife < Level.TimeSeconds - 40 )
        {
            TextMessages[i].Text = "";

            if( i < ConsoleMessageCount - 1 )
            {
                for( j=i; j<ConsoleMessageCount-1; j++ )
                    TextMessages[j] = TextMessages[j+1];
            }
            TextMessages[j].Text = "";
            break;
        }
        else
        {
			MessageCount++;
		}
    }

    C.KFXFontAlias = KFXChatFontAlias;
    C.KFXStrLen("A", XL, YL);

    XPos = 20;
    YPos = 680 - (YL+2) * MessageCount;

    if(!bDisPlayMessages)
         return;
    for( i = 0; i < MessageCount; i++ )
    {
        if ( TextMessages[i].Text == "" )
        {
            break;
        }

        C.KFXStrLen( TextMessages[i].Text, XL, YL );
        C.SetPos(XPos * C.SizeX / 1024, YPos * C.SizeY / 768);
        C.DrawColor = TextMessages[i].TextColor;
        C.KFXDrawStrWithBorder(TextMessages[i].Text, ShadeColor, -1);
        YPos += YL;
        YPos += 2;
    }
}
  */
// »­ÊäÈë×Ö·û
simulated function DrawTypingPrompt (Canvas C, String Text, optional int Pos)
{
    local string s,headStr;
    local float XL,YL;
    local Array<string> Content;
    local float ypos;
    local EDrawPivot pv;

	return;

    Split(Text, " ", Content);

    //C.SetDrawColor(153, 216, 253, 255);
    C.SetDrawColor(255, 255, 255, 255);

    // Heqingming. 2007-8-24. IME´°¿ÚÏÔÊ¾Ö§³Ö
    GetTypeGameChatPos(C, yPos, pv);
    PlayerConsole.TypedStrDrawX = 0;
    //PlayerConsole.TypedStrDrawY = 650 * C.SizeY / 768;    // Modified by Linsen 2008-3-11
    PlayerConsole.TypedStrDrawY = ypos;    // Modified by Linsen 2008-3-11
	C.KFXSetPivot(pv);
    C.SetPos(PlayerConsole.TypedStrDrawX ,PlayerConsole.TypedStrDrawY );

    if( Left(Text, 3) ~= "Say" )
    {
        s = Left(Text, Pos)$"_"$Mid(Text, Pos); //Eval(Pos < Len(Text), Mid(Text, Pos), "_");
        s = Mid(s, 4);
        headStr = lPublicChat;
        s = "["$lPublicChat$"] "$s;
    }
    else if( Left(Text, 7) ~= "TeamSay" )
    {
        s = Left(Text, Pos)$Eval(Pos < Len(Text), Mid(Text, Pos), "_");
        s = Mid(s, 8);
        headStr = lTeamChat;
        s = "["$lTeamChat$"] "$s;
    }
    else if( Left(Text, 13) ~= "PersonnalChat" )
    {
        s = Left(Text, Pos)$"_"$Mid(Text, Pos); //Eval(Pos < Len(Text), Mid(Text, Pos), "_");
        s = Mid(s, 15 + Len(Content[1]));
        headStr = Content[1];
        s = "["$Content[1]$"]:"$s;
    }
    else if( Left(Text, 9) ~= "GroupChat" )
    {
        s = Left(Text, Pos)$"_"$Mid(Text, Pos); //Eval(Pos < Len(Text), Mid(Text, Pos), "_");
        s = Mid(s, 10);
        headStr = lGroupChat;
        s = "["$lGroupChat$"] "$s;
    }

    headStr = Left(Text,Pos);//headStr $

    C.KFXFontAlias = KFXChatFontAlias;

    C.KFXStrLen(headStr, XL, YL);
    PlayerConsole.TypedStrDrawX += XL;

    C.KFXDrawStrWithBorder(s, ShadeColor, -1);
}
function AddTotalKill()
{
}
//»­·ÉÐÐµÄÉËÑªÍ¼±ê
simulated function AddFlyingBlood(byte BloodFlag)
{
     local int i;
     if(BloodFlag != 0)
     {
         for(i=0; i<arraycount(FlyingBloodMessage); i++)
         {
             if(FlyingBloodMessage[i].BloodFlag == 0)
             {
                 FlyingBloodMessage[i].BloodFlag = BloodFlag;
                 FlyingBloodMessage[i].bFlying = true;
                 FlyingBloodMessage[i].fxBeginTime = Level.TimeSeconds;

                 if(BloodFlag == 50)
                 {
                     FlyingFiftyBloodNum++;
                 }
                 else if(BloodFlag == 10)
                 {
                     FlyingTenBloodNum++;
                 }
                 break;
             }
         }
     }
}
simulated function DeleteFlyingBlood(int count)
{
     if(count >= 0 && count < arraycount(FlyingBloodMessage))
     {
         if(FlyingBloodMessage[count].BloodFlag == 50)
         {
             FlyingFiftyBloodNum--;
         }
         else if(FlyingBloodMessage[count].BloodFlag == 10)
         {
             FlyingTenBloodNum--;
         }
         FlyingBloodMessage[count].BloodFlag = 0;
         FlyingBloodMessage[count].bFlying = false;
         FlyingBloodMessage[count].Pos.X = 0;
         FlyingBloodMessage[count].Pos.Y = 0;
         FlyingBloodMessage[count].fxBeginTime = 0;
     }
}
//Ôö¼ÓÓÒ±ßÅÅÁÐÖÐµÄÉËÑªÍ¼±ê
simulated function AddFiftyBlood()
{
    if(fxBloodMessage.KillFiftyBloodNum < 10 && fxBloodMessage.KillFiftyBloodNum > -1)
    {
        fxBloodMessage.KillFiftyBloodNum++;
    }
}
simulated function AddTenBlood()
{
    if(fxBloodMessage.KillTenBloodNum < 40 && fxBloodMessage.KillTenBloodNum > -1)
    {
        fxBloodMessage.KillTenBloodNum++;
    }
}
simulated function  SubFiftyBlood()
{
    if(fxBloodMessage.KillFiftyBloodNum < 6 && fxBloodMessage.KillFiftyBloodNum > 1)
    {
        fxBloodMessage.KillFiftyBloodNum--;
    }
}
simulated function SubTenBlood()
{
    if(fxBloodMessage.KillTenBloodNum < 6 && fxBloodMessage.KillTenBloodNum > 1)
    {
        fxBloodMessage.KillTenBloodNum--;
    }
}
simulated function  SetFiftyBloodZero()
{
    if(fxBloodMessage.KillFiftyBloodNum != 0)
    {
        fxBloodMessage.KillFiftyBloodNum = fxBloodMessage.KillFiftyBloodNum % 2;
    }
}
simulated function  SetTenBloodZero()
{
   if(fxBloodMessage.KillTenBloodNum != 0)
   {
        fxBloodMessage.KillTenBloodNum = fxBloodMessage.KillTenBloodNum % 5;
   }
}
simulated function AddRealKills()
{
     local int i;
     if(OneKillsCount >= 0)
     {
         OneKillsCount++;
     }
     else
     {
         OneKillsCount = 0;
     }

     for (i=0; i<ArrayCount(fxEncourageMsgs); i++)
     {
        if (fxEncourageMsgs[i].Time < 0.001)//¿ÕµÄ
            break;
     }
     if (i == ArrayCount(fxEncourageMsgs))//¶ÓÀýÂú£¬Çå¿Õ
     {
        for (i=0; i<ArrayCount(fxEncourageMsgs); i++)
        {
            fxEncourageMsgs[i].Time = 0;
        }
        i = 0;//¶¨Î»µ½µÚÒ»ÌõÏûÏ¢
     }
     fxEncourageMsgs[i].bMultiKill = 0;
     fxEncourageMsgs[i].Type = ET_Normal;
     fxEncourageMsgs[i].Time = Level.TimeSeconds;
     fxEncourageMsgs[i].bIsBloodKill = true;

if(_HUD_NEW_ == 2)
{
    PlayerOwner.Player.GUIController.SetHUDData_Encourage(EEncourageType.ET_Normal,
		0,
		0);
}

}
simulated function AddFlyingOneKill()
{
    local int i;
    for(i=0; i<arraycount(FlyingOneKillMessage); i++)
    {
        if(!FlyingOneKillMessage[i].bOneKill)
        {
             FlyingOneKillMessage[i].fxBeginTime = Level.TimeSeconds;
             FlyingOneKillMessage[i].bOneKill = true;
             FlyingOneKillMessage[i].bFlying = true;
             FlyingOneKillNum++;
             break;
        }
    }
}
simulated function DeleteFlyingOneKill(int i)
{
    if(i >= 0)
    {
        FlyingOneKillMessage[i].bFlying = false;
        FlyingOneKillMessage[i].fxBeginTime = 0;
        FlyingOneKillMessage[i].bOneKill = false;
        FlyingOneKillNum--;
    }
}
simulated function GatherBloodMessage()
{
    if(fxBloodMessage.KillTenBloodNum >= 5)
    {
        AddFiftyBlood();
        SetTenBloodZero();
    }
    if(fxBloodMessage.KillFiftyBloodNum > 1)
    {
        AddFlyingOneKill();
        SetFiftyBloodZero();
    }
}
simulated function GetOneKillFinalPos(out float FinalPosX,out float FinalPosY)
{
   local int Kills;
   local int Counts;

   Kills = GetPRI().fxKills + OneKillsCount;
   Counts = (Kills/100) + (Kills/10%10) + (Kills%10);
   FinalPosX = KFXOneCent.PosX + Counts*(KFXOneCent.LengthX+1);
   FinalPosY = KFXOneCent.PosY + 5;
}
simulated function DrawFlyFiftyBloodPic(Canvas Canvas)
{
    local float DeltaTime;
    local vector BloodPicPos;

    local float OriginX,OriginY;
    local float FinalX,FinalY;
    local float BloodGivenTime;
    local float ScaleLargerTime;
    local int i;

    if(FlyingFiftyBloodNum <= 0)
       return;
    OriginX = Canvas.SizeX/2;
    OriginY = Canvas.SizeY/2;
    FinalX = FlyFiftyBloodTilePos.X;//FlyFiftyBloodTile.PosX;//Canvas.SizeX/1024*960;
    FinalY = FlyFiftyBloodTilePos.Y;///FlyFiftyBloodTile.PosY;//Canvas.SizeY/768 *151;
    BloodGivenTime = 0.5;
    ScaleLargerTime = 0.5;
    for(i=0; i<arraycount(FlyingBloodMessage); i++)
    {
        if(FlyingBloodMessage[i].BloodFlag == 50)
        {
            DeltaTime = Level.TimeSeconds - FlyingBloodMessage[i].fxBeginTime;

            if(DeltaTime < BloodGivenTime)
            {
                BloodPicPos.X = OriginX + (FinalX - OriginX) * DeltaTime / BloodGivenTime;
                BloodPicPos.Y = OriginY + (FinalY - OriginY) * DeltaTime / BloodGivenTime;
                FlyFiftyBloodTile.PosX = BloodPicPos.X;
                FlyFiftyBloodTile.PosY = BloodPicPos.Y;

                KFXDrawXMLTileInfo(Canvas,FlyFiftyBloodTile);
            }
            else if(DeltaTime < BloodGivenTime + ScaleLargerTime)
            {
               FlyFiftyBloodTile.LengthX = FlyFiftyBloodTile.ClipX * (2-(DeltaTime - BloodGivenTime)/ScaleLargerTime);
               FlyFiftyBloodTile.LengthY = FlyFiftyBloodTile.ClipY * (2-(DeltaTime - BloodGivenTime)/ScaleLargerTime);
               KFXDrawXMLTileInfo(Canvas,FlyFiftyBloodTile);
            }
            else
            {
                 AddFiftyBlood();  //ÓÒ±ßÊýÁ¿+1
                 DeleteFlyingBlood(i);   //¹é0
            }
        }
    }
}
simulated function DrawFlyTenBloodPic(Canvas Canvas)
{
    local float DeltaTime;
    local vector BloodPicPos;
    local float OriginX,OriginY;
    local float FinalX,FinalY;
    local float BloodGivenTime;
    local float ScaleLargerTime;
    local int   i;
    if(FlyingTenBloodNum <= 0)
        return;
    OriginX = Canvas.SizeX/2;
    OriginY = Canvas.SizeY/2;
    FinalX = FlyTenBloodTilePos.X;// Canvas.SizeX/1024*960;
    FinalY = FlyTenBloodTilePos.Y - 30 +(fxBloodMessage.KillTenBloodNum + 1) * 50;
    BloodGivenTime = 0.5;
    ScaleLargerTime = 0.5;
    for(i=0; i<arraycount(FlyingBloodMessage); i++)
    {
        if(FlyingBloodMessage[i].BloodFlag == 10)
        {
            DeltaTime = Level.TimeSeconds - FlyingBloodMessage[i].fxBeginTime;


            if(DeltaTime < BloodGivenTime)
            {
                BloodPicPos.X = OriginX + (FinalX - OriginX) * DeltaTime / BloodGivenTime;
                BloodPicPos.Y = OriginY + (FinalY - OriginY) * DeltaTime / BloodGivenTime;
                FlyTenBloodTile.PosX = BloodPicPos.X;
                FlyTenBloodTile.PosY = BloodPicPos.Y;
                KFXDrawXMLTileInfo(Canvas,FlyTenBloodTile);

            }
            else if(DeltaTime < BloodGivenTime + ScaleLargerTime)
            {
               FlyTenBloodTile.LengthX = FlyTenBloodTile.ClipX * (2-(DeltaTime - BloodGivenTime)/ScaleLargerTime);
               FlyTenBloodTile.LengthY = FlyTenBloodTile.ClipY * (2-(DeltaTime - BloodGivenTime)/ScaleLargerTime);
               KFXDrawXMLTileInfo(Canvas,FlyTenBloodTile);
            }
            else
            {
                 AddTenBlood();  //ÓÒ±ßÊýÁ¿+1
                 DeleteFlyingBlood(i);   //¹é0
            }
        }
    }
}
simulated function DrawRankedFiftyBlood(Canvas Canvas)
{
   local int OrginPosY;
    if(fxBloodMessage.KillFiftyBloodNum >= 1)
    {
//       FiftyBloodTile.PosX =  Canvas.SizeX/1024*900;
//       FiftyBloodTile.PosY = Canvas.SizeY/768*300;
       OrginPosY = FiftyBloodTile.PosY;
       KFXDrawXMLTileInfo(Canvas,FiftyBloodTile);
       FiftyBloodTile.PosY = OrginPosY;
    }
}
simulated function DrawRankedTenBlood(Canvas Canvas)
{
    local int i;

    local int OrginPosY;
    if(fxBloodMessage.KillTenBloodNum > 0 && fxBloodMessage.KillTenBloodNum < 6)
    {
        for(i=0; i<fxBloodMessage.KillTenBloodNum; i++)
        {
           //TenBloodTile.PosX =  Canvas.SizeX/1024*900;
           OrginPosY = TenBloodTile.PosY;
           TenBloodTile.PosY = /*Canvas.SizeY/768 **/FlyTenBloodTilePos.Y - 30 + (i + 1)*50;
           KFXDrawXMLTileInfo(Canvas,TenBloodTile);
           TenBloodTile.PosY = OrginPosY;

        }
    }
}

simulated function DrawFlyingOneKillMessage(Canvas Canvas)
{

    local float DeltaTime;
    local vector OneKillPicPos;
    local float OriginX,OriginY;
    local float FinalX,FinalY;
    local float BloodGivenTime;
    local float ScaleLargerTime;
    local int   i;
    if(FlyingOneKillNum <= 0)
         return;
    OriginX = Canvas.SizeX/1024*900;
    OriginY = Canvas.SizeY/768*300;
//    FinalX = Canvas.SizeX/1024/2;
//    FinalY = Canvas.SizeY/768*600;
    GetOneKillFinalPos(FinalX,FinalY);
    BloodGivenTime = 0.5;
    ScaleLargerTime = 0.5;
    for(i=0; i<arraycount(FlyingOneKillMessage); i++)
    {
        if(FlyingOneKillMessage[i].bOneKill)
        {
            DeltaTime = Level.TimeSeconds - FlyingOneKillMessage[i].fxBeginTime;
            if(DeltaTime < BloodGivenTime)
            {
                OneKillPicPos.X = OriginX + (FinalX - OriginX) * DeltaTime / BloodGivenTime;
                OneKillPicPos.Y = OriginY + (FinalY - OriginY) * DeltaTime / BloodGivenTime;
                FlyOneKillTile.PosX = OneKillPicPos.X;
                FlyOneKillTile.PosY = OneKillPicPos.Y;
                KFXDrawXMLTileInfo(Canvas,FlyOneKillTile);

            }
            else if(DeltaTime < BloodGivenTime + ScaleLargerTime)
            {
               FlyOneKillTile.LengthX = FlyOneKillTile.ClipX * (2-(DeltaTime - BloodGivenTime)/ScaleLargerTime);
               FlyOneKillTile.LengthY = FlyOneKillTile.ClipY * (2-(DeltaTime - BloodGivenTime)/ScaleLargerTime);
               KFXDrawXMLTileInfo(Canvas,FlyOneKillTile);
            }
            else
            {
                 if(FlyingOneKillMessage[i].bFlying)
                 {
                     AddRealKills();  //ÓÒ±ßÊýÁ¿+1
                     DeleteFlyingOneKill(i);   //¹é0
                 }
            }
        }
    }

}

simulated function ClearEncourageInfo()
{
    local int i;
    for (i=0; i<ARRAYCOUNT(fxEncourageMsgs); i++)
        fxEncourageMsgs[i].Time = 0;
}
// »­¼¤ÀøÍ¼±ê Õ½ÊõÍ³¼Æ»æÖÆ´úÂëÓ¦ºÍÕ½¼¨»æÖÆ´úÂë¹«ÓÃTODO
simulated function DrawEncourageInfo(Canvas Canvas)
{
    local int i, type, kills, killHi, killLow/*, lines*/;   //ÓÃÓÚ»æÖÆÊ±µÄÐÐÆ«ÒÆ
    local float xl, yl/*, xLen*/;                           //×ø±êÏà¹Ø
    //local string fxName;                                //ÁÙÊ±±äÁ¿£¬´æ·ÅÍæ¼ÒÃû×Ö
//    local Material BigIconMat;                          //¼¤Àø´óÍ¼±ê
    local float BigIconUL, BigIconVL;                   //¼¤Àø´óÍ¼±êµÄVL, VL
    local float pastTime;
//    local string sKillInfoTitle;                        //ÏûÃðÍ³¼Æ±êÌâ
//    local int   nKillInfoOffsizeY;                      //ÏûÃðÍ³¼Æ×Ý×ø±êÆ«ÒÆ
    local float BigIconOrigX, BigIconOrigY;             //´óÍ¼±ê±ê×¼Î»ÖÃ
    local float x, y;
    local float ul, vl;
//    local float ts;	//¼ä¸ôÊ±¼ä
    local string simg, sset;
    local KFXPlayer LocalPC;
    local bool use_evil;

	if(PlayerOwner.Pawn == none || pawnOwner.Controller == none)
		return;
    Canvas.Reset();
    Canvas.SetDrawColor(255, 255, 255, 255);


    //»­°ÙÎ»
    Canvas.KFXSetPivot(DP_LowerLeft);//×óÏÂ¶ÔÆë
    kills = GetPRI().fxKills + OneKillsCount;
    killHi = kills/100;
	killHi *= 100;
    if (killHi > 0)
    {
		if(!IsA('KFXPVEHUD'))
		{
	        Canvas.SetPos(KFXHundredCent.PosX, KFXHundredCent.PosY);
	//        Canvas.DrawTile(Material(DynamicLoadObject("fx_ui3_texs.HUD_CountSign_Hundred", class'Material')),
	//                    36, 57, 0, 0, 36, 57);
	 		KFXDrawXMLTileInfo(Canvas, KFXHundredCent);
	        Canvas.Font = self.LoadFoxFont(0);
	//        Canvas.SetPos(271, 701);
	//        Canvas.KFXDrawStr(killHi);
			// ÉÍ½ðÐ¡ÖíÄ£Ê½»÷É±ÊýÀ©³ä£¬°ÙÎ»¾ÓÖÐ´¦Àí
	        Canvas.KFXSetPivot(DP_LowerMiddle);
	        Canvas.DrawTextNarrowJustified(killHi,
						1,
						KFXHundredCent.PosX,
						KFXHundredCent.PosY,
						KFXHundredCent.PosX+KFXHundredCent.LengthX,
						KFXHundredCent.PosY+KFXHundredCent.LengthY, 4);
		}
    }

    //»­Ê®Î»
    killLow = (kills-killHi) / 10;
    killLow *= 10;
    if (killLow > 0)
    {
		if(!IsA('KFXPVEHUD'))
		{
	        Canvas.SetPos(KFXTenCent.PosX, KFXTenCent.PosY);
		//        Canvas.DrawTile(Material(DynamicLoadObject("fx_ui3_texs.HUD_CountSign_Ten", class'Material')),
		//                    36, 57, 0, 0, 36, 57);
		 	KFXDrawXMLTileInfo(Canvas, KFXTenCent);
	        Canvas.KFXSetPivot(DP_LowerMiddle);
	        Canvas.Font = self.LoadFoxFont(0);
	        Canvas.DrawTextNarrowJustified(killLow,
						1,
						KFXTenCent.PosX,
						KFXTenCent.PosY,
						KFXTenCent.PosX+KFXTenCent.LengthX,
						KFXTenCent.PosY+KFXTenCent.LengthY, 4);
		}
	}

    //»­Ò»ÅÅ¼¤ÀøÍ¼±ê

    if (fxEncourageMsgs[9].Time < 0.001 && fxEncourageMsgs[i].Type != ET_TeamKill )//ÎÞ½øÎ»
    {
        for (i=0; i<ArrayCount(fxEncourageMsgs); i++)
        {
            if (fxEncourageMsgs[i].Time > 0)//·Ç¿Õ
            {
            	//ÕâÀïÃ»ÓÐÁ¬É±Í¼±ê
                type = fxEncourageMsgs[i].Type;

                if(NeedDrawEncourageMsgs)
                {
                    self.GotSetAndImage(EncourageIconsSmall[type], sset, simg);
                    KFXOneCent.szImage = simg;
                    KFXOneCent.szImageSet = sset;
                    x = KFXOneCent.PosX;
                    KFXOneCent.PosX += i*(KFXOneCent.LengthX+1);
					if(!IsA('KFXPVEHUD'))
					{
		 				KFXDrawXMLTileInfo(Canvas, KFXOneCent);
		 				KFXOneCent.PosX = x;
	//                    Canvas.DrawTile(Material(DynamicLoadObject(EncourageIconsSmall[type], class'Material')),
	//                                    28, 28, 0, 0, 28, 28);
					}

                }
            }
            else
                break;
        }
        if (i != 0)
            i--;
    }
    else
    {
        i = 9;//½øÎ»ÁË£¬´óÍ¼±ê»¹ÊÇÒª»­µÄ
        type = fxEncourageMsgs[i].Type;
    }
    if(fxEncourageMsgs[i].bIsBloodKill && KFXPlayer(PlayerOwner).IsRedTeam())
        return;
    //¼¤ÀøÍ¼±êÊÇ»­Á¬É±µÄ
	if(fxEncourageMsgs[i].bMultiKill > 1)
	{
		type = EEncourageType(fxEncourageMsgs[i].bMultiKill);
	}


    // we need innovation not pirate... doing this with disappointment
    pastTime = Level.TimeSeconds - fxEncourageMsgs[i].Time;

    //»­µ±Ç°¼¤Àø´óÍ¼±ê
    //Ð§¹ûÎª£¬ÓÐÐ¡±ä´ó£¬ÔÚ±äµ½×î´ó£¬ÔÙ»Øµ½ÆÕÍ¨£¬½¥ÒþÏûÊ§
    Canvas.KFXSetPivot(DP_MiddleMiddle);//ÖÐÖÐ¶ÔÆë
    //2ÃëºóÏûÊ§
    if (KFXPlayer(PlayerOwner).bKFXKeyOfEncourage )
    {
		if (fxEncourageMsgs[i].Time > 0.0 && pastTime < 2.0 && fxEncourageMsgs[i].Type != ET_TeamKill )
        {
        	// ÖÓ£º¼ÓÈë±¬Í·ÌØÊâ¾­Ñé´óÍ¼±ê
//        	if(fxEncourageMsgs[i].Type == ET_HeadShot && GetPRI().fxHeadKillExpCard)
//        	{
//        		BigIconMat = Material(DynamicLoadObject("fx_ui3_texs.HUD_Cheer_gun_headshot20exp", class'Material'));
//			}
//			else
//			{
//            	BigIconMat = Material(DynamicLoadObject(EncourageIconsBig[type], class'Material'));
//			}
			//»­¼¤ÀøÍ¼±ê
//			Canvas.Reset();
//			Canvas.bForceAlpha = false;
//			GotSetAndImage(EncourageIconsBig[type], KFXRevengeInfo.szImageSet, KFXRevengeInfo.szImage);
//			if(KFXRevengeInfo.szImageSet != "" && KFXRevengeInfo.szImage != "")
//				Canvas.KFXLoadXMLMaterial(KFXRevengeInfo.szImageSet, KFXRevengeInfo.szImage, x, y, xl, yl);

//			//»æÖÆÌùÍ¼
//			if(pastTime < 1)
//			{
//            	ts = 1.0;	//1ÃëÄÚÓÉÐ¡±ä´óµ½1.2±¶
//				KFXRevengeInfo.ClipX = xl * pastTime * 1.2;
//				KFXRevengeInfo.ClipY = yl * pastTime * 1.2;
//			}
//			else if(pastTime < 1.2)
//			{
//				ts = 0.2;	//0.2ÃëÖ®ÄÚ±ã»áÔ­³ß´ç
//				KFXRevengeInfo.ClipX = (-1.0 * pastTime + 2.2)*xl;
//				KFXRevengeInfo.ClipY = (-1.0 * pastTime + 2.2)*yl;
//			}
//			else if(pastTime < 2)
//			{
//				Canvas.bForceAlpha = true;
//				Canvas.ForcedAlpha = -1.25*pastTime + 2.5;
//			}
//			if(KFXRevengeInfo.szImageSet != "" && KFXRevengeInfo.szImage != "")
//			{
//				Canvas.SetPos(KFXRevengeInfo.PosX-KFXRevengeInfo.ClipX/2,
//								KFXRevengeInfo.PosY-KFXRevengeInfo.Clipy/2);
//				Canvas.KFXDrawXMLTile(KFXRevengeInfo.szImageSet, KFXRevengeInfo.szImage,
//							true, KFXRevengeInfo.ClipX, KFXRevengeInfo.ClipY);
//			}



			//»­¼¤ÀøÍ¼±ê
			Canvas.Reset();
			Canvas.bForceAlpha = false;

			LocalPC = KFXPlayer(PlayerOwner);
			use_evil = LocalPC.life_style>0 && LocalPC.life_encourage_pic[type].mat!=none
						&& LocalPC.life_encourage_pic[type].valid;
			if(use_evil)
			{
				x = LocalPC.life_encourage_pic[type].u;
				y = LocalPC.life_encourage_pic[type].v;
				xl = LocalPC.life_encourage_pic[type].ul;
				yl = LocalPC.life_encourage_pic[type].vl;
			}
			else
			{
				GotSetAndImage(EncourageIconsBig[type], KFXEncourageInfo.szImageSet, KFXEncourageInfo.szImage);
				if(KFXEncourageInfo.szImageSet != "" && KFXEncourageInfo.szImage != "")
					Canvas.KFXLoadXMLMaterial(KFXEncourageInfo.szImageSet, KFXEncourageInfo.szImage, x, y, xl, yl);
			}

            BigIconUL = xl;//BigIconMat.MaterialUSize();
           	BigIconVL = yl;//BigIconMat.MaterialVSize();
           	BigIconOrigX = KFXEncourageInfo.PosX-BigIconUL/2;
       	    BigIconOrigY = KFXEncourageInfo.PosY-BigIconVL/2;
			KFXEncourageInfo.ClipX = xl;
			KFXEncourageInfo.ClipY = yl;

            //³öÏÖ£¬·Å´ó
            if (pastTime < 0.2)
            {
				KFXEncourageInfo.ClipX = BigIconUL*pastTime/0.12;
				KFXEncourageInfo.ClipY = BigIconVL*pastTime/0.12;
                BigIconOrigX = KFXEncourageInfo.PosX-BigIconUL*pastTime/0.24;
                BigIconOrigY = KFXEncourageInfo.PosY-BigIconVL*pastTime/0.24;
                Canvas.SetPos(BigIconOrigX, BigIconOrigY);
//                Canvas.DrawTile(BigIconMat, BigIconUL*pastTime/0.12, BigIconVL*pastTime/0.12,
//                    0, 0, BigIconUL, BigIconVL);
            }
            //»Ö¸´Õý³££¬ÏòÓÒÏÂ»Î¶¯
            else if (pastTime < 0.3)
            {
                Canvas.SetPos(BigIconOrigX+125*(0.26-pastTime), BigIconOrigY+125*(0.26-pastTime));
//                Canvas.DrawTile(BigIconMat, BigIconUL, BigIconVL,
//                    0, 0, BigIconUL, BigIconVL);

            }
            //×óÏÂ»Î¶¯
            else if (pastTime < 0.4)
            {
                Canvas.SetPos(BigIconOrigX-125*(0.36-pastTime), BigIconOrigY-125*(0.36-pastTime));
//                Canvas.DrawTile(BigIconMat, BigIconUL, BigIconVL,
//                    0, 0, BigIconUL, BigIconVL);
            }
            //ÏòÓÒ»Î¶¯
            else if (pastTime < 0.5)
            {
                Canvas.SetPos(BigIconOrigX-125*(0.46-pastTime), BigIconOrigY);
//                Canvas.DrawTile(BigIconMat, BigIconUL, BigIconVL,
//                    0, 0, BigIconUL, BigIconVL);
            }
            //Í£Áô0.2
            else if (pastTime < 0.7)
            {
                Canvas.SetPos(BigIconOrigX, BigIconOrigY);
//                Canvas.DrawTile(BigIconMat, BigIconUL, BigIconVL,
//                    0, 0, BigIconUL, BigIconVL);
            }
            //½¥Òþ
            else if (pastTime < 2.0)
            {
                Canvas.bForceAlpha = true;
                Canvas.ForcedAlpha = (2.0-pastTime)/1.5;
                Canvas.SetPos(BigIconOrigX, BigIconOrigY);
//                Canvas.DrawTile(BigIconMat, BigIconUL, BigIconVL,
//                    0, 0, BigIconUL, BigIconVL);
                Canvas.bForceAlpha = false;
            }

            if(use_evil)
            {
//            	log("[LABOR]---------draw encourage, xpos="$Canvas.CurX
//						@"ypos="$Canvas.CurY
//						@"u="$LocalPC.life_encourage_pic[type].u
//						@"v="$LocalPC.life_encourage_pic[type].v
//						@"ul="$LocalPC.life_encourage_pic[type].ul
//						@"vl="$LocalPC.life_encourage_pic[type].vl
//						@"mat="$LocalPC.life_encourage_pic[type].mat);

				Canvas.KFXSetPivot(KFXEncourageInfo.Pivot);//ÖÐÖÐ¶ÔÆë
				Canvas.DrawTile(LocalPC.life_encourage_pic[type].mat,
							KFXEncourageInfo.ClipX,
							KFXEncourageInfo.ClipY,
							LocalPC.life_encourage_pic[type].u,
							LocalPC.life_encourage_pic[type].v,
							LocalPC.life_encourage_pic[type].ul,
							LocalPC.life_encourage_pic[type].vl);
			}
			else
			{
				if(KFXRevengeInfo.szImageSet != "" && KFXRevengeInfo.szImage != "")
				{
					Canvas.KFXSetPivot(KFXEncourageInfo.Pivot);//ÖÐÖÐ¶ÔÆë
					Canvas.KFXDrawXMLTile(KFXEncourageInfo.szImageSet, KFXEncourageInfo.szImage,
								true, KFXEncourageInfo.ClipX, KFXEncourageInfo.ClipY);
				}
			}


			//¸´³ðÍ¼±êÔÚ¼¤ÀøÍ¼±êÖÐÐÄµãÉÏ£¨x,y£©´¦
			if( bNeedRevenge && fxEncourageMsgs[i].bInventory == 1)
			{
				//»æÖÆ¸´³ð
				Canvas.Reset();
				if(pastTime < 0.7)
				{
					Canvas.bForceAlpha = false;
				}
				else
				{
    	            Canvas.bForceAlpha = true;
	                Canvas.ForcedAlpha = (2.0-pastTime)/1.5;
				}
				GotSetAndImage(RevengeIcon, KFXRevengeInfo.szImageSet, KFXRevengeInfo.szImage);
	   			Canvas.KFXLoadXMLMaterial(KFXRevengeInfo.szImageSet, KFXRevengeInfo.szImage, x, y,
				   			ul, vl);
				Canvas.SetPos(KFXRevengeInfo.PosX,
							KFXRevengeInfo.PosY);
				if(KFXRevengeInfo.szImageSet != "" && KFXRevengeInfo.szImage != "")
				{
					Canvas.KFXSetPivot(KFXEncourageInfo.Pivot);//ÖÐÖÐ¶ÔÆë
					Canvas.KFXDrawXMLTile(KFXRevengeInfo.szImageSet, KFXRevengeInfo.szImage, true,
								ul, vl);
				}
			}

        }
        else
        {
			fxEncourageMsgs[i].bInventory = 0;
		}
    }

    /*
    if (fxEncourageMsgs[i].Time > 0.0 && (Level.TimeSeconds - fxEncourageMsgs[i].Time)< 1.0)
    {
        type = fxEncourageMsgs[i].Type;
        Canvas.KFXSetPivot(DP_MiddleMiddle);//ÖÐÖÐ¶ÔÆë

        BigIconMat = Material(DynamicLoadObject(EncourageIconsBig[type], class'Material'));
        BigIconUL = BigIconMat.MaterialUSize();
        BigIconVL = BigIconMat.MaterialVSize();

        Canvas.SetPos(512-BigIconUL/2, 566-BigIconVL/2);

        pastTime = Level.TimeSeconds - fxEncourageMsgs[i].Time;
        if (pastTime > 0.5)//ºóÒ»°ëÊ±¼äÓÃÓÚÒÔÍ¸Ã÷·½Ê½ÏûÒþ
        {
            Canvas.bForceAlpha = true;
            Canvas.ForcedAlpha = (1.0 - pastTime)/0.5;
        }

        Canvas.DrawTile(BigIconMat, BigIconUL, BigIconVL, 0, 0, BigIconUL, BigIconVL);

        //»Ö¸´Í¸Ã÷¶È
        Canvas.bForceAlpha = false;
        Canvas.ForcedAlpha = 1.0;
    }
    */
	if(PlayerController(PawnOwner.Controller).IsInState('GameEnded')
			|| PlayerController(PawnOwner.Controller).IsInState('Dead'))
	{
	    //KFXPlayer(PlayerOwner).bKFXKeyOfShowKill = true;
	}
	//°´¿Õ¸ñ»òÕßÍæ¼ÒËÀÍö»òÕßÓÎÏ·½áÊøÊ±
    if (KFXPlayer(PlayerOwner).bKFXKeyOfShowKill && bShowWhoKilledMe)
    {
        /*
        //±³¾°
        if ( GetPRI().IsGrayTeam() )
        {
            Canvas.SetPos(788, 174);
            Canvas.DrawTile(Material(DynamicLoadObject("fx_ui3_texs.HUD_KillCount_15", class'Material')),
                            226, 512, 0, 0, 226, 512);
            nKillInfoOffsizeY = 205;
        }
        else
        {
            Canvas.SetPos(788, 379);
            Canvas.DrawTile(Material(DynamicLoadObject("fx_ui3_texs.HUD_KillCount_8", class'Material')),
                            226, 307, 0, 0, 226, 307);
            nKillInfoOffsizeY = 0;
        }

        Canvas.KFXFontAlias = "heavysmall12";
        // ¶ÔÊÖêÇ³Æ
        Canvas.SetDrawColor(0, 0, 0, 255);
        Canvas.SetPos(832, 408 - nKillInfoOffsizeY);
        Canvas.KFXDrawStr(SMT_RivalName);
        Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.SetPos(831, 407 - nKillInfoOffsizeY);
        Canvas.KFXDrawStr(SMT_RivalName);

        // ÏûÃð/±»ÏûÃð
        Canvas.SetDrawColor(0, 0, 0, 255);
        Canvas.SetPos(932, 408 - nKillInfoOffsizeY);
        Canvas.KFXDrawStr(SMT_KillInfo);
        Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.SetPos(931, 407 - nKillInfoOffsizeY);
        Canvas.KFXDrawStr(SMT_KillInfo);

        Canvas.KFXFontAlias = "heavymedium14";
        // ±êÌâ
        sKillInfoTitle = GetPRI().PlayerName $ SMT_KillInfoTitle;
        Canvas.KFXStrLen(sKillInfoTitle, xl, yl);
        Canvas.SetDrawColor(0, 0, 0, 255);
        Canvas.SetPos(904 - xl/2, 386 - nKillInfoOffsizeY);
        Canvas.KFXDrawStr(sKillInfoTitle);
        Canvas.SetDrawColor(255, 255, 255, 255);
        Canvas.SetPos(903 - xl/2, 385 - nKillInfoOffsizeY);
        Canvas.KFXDrawStr(sKillInfoTitle);


        // Í³¼ÆÐÅÏ¢
        for (i=0; i<nKillInfoCount; i++)
        {
            Canvas.KFXStrLen(PlayerKillInfo[i].PlayerName, xl, yl);
            Canvas.SetDrawColor(0, 0, 0, 255);
            Canvas.SetPos(859 - xl/2 , 433 + 30*i -nKillInfoOffsizeY);
            Canvas.KFXDrawStr(PlayerKillInfo[i].PlayerName);
            Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.SetPos(858 - xl/2 , 432 + 30*i -nKillInfoOffsizeY);
            Canvas.KFXDrawStr(PlayerKillInfo[i].PlayerName);

            Canvas.KFXStrLen(PlayerKillInfo[i].KFXKilledByMeCount, xl, yl);
            Canvas.SetDrawColor(0, 0, 0, 255);
            Canvas.SetPos(955 - xl, 434 + 30*i - nKillInfoOffsizeY);
            Canvas.KFXDrawStr(PlayerKillInfo[i].KFXKilledByMeCount);
            Canvas.SetDrawColor(132, 221, 246, 255);
            Canvas.SetPos(954 - xl, 433 + 30*i - nKillInfoOffsizeY);
            Canvas.KFXDrawStr(PlayerKillInfo[i].KFXKilledByMeCount);


            Canvas.SetDrawColor(0, 0, 0, 255);
            Canvas.SetPos(972, 434 + 30*i - nKillInfoOffsizeY);
            Canvas.KFXDrawStr(PlayerKillInfo[i].KFXKillMeCount);
            Canvas.SetDrawColor(197, 117, 149, 255);
            Canvas.SetPos(971, 433 + 30*i - nKillInfoOffsizeY);
            Canvas.KFXDrawStr(PlayerKillInfo[i].KFXKillMeCount);

            if ((nKillInfoOffsizeY == 0) && (i >= 8))
                break;
        }
        */
    }

    //»Ö¸´CanvasµÄ¶ÔÆë·½Ê½£¬ÒÔ·ÀÖ¹ºóÀ´µÄÔÚ»­Ç°Íü¼Ç³õÊ¼»¯
    Canvas.KFXSetPivot(DP_UpperLeft);
}

// ¸ñÊ½»¯Ê±¼ä
simulated function String FormatTime( int Seconds )
{
    local int Minutes, Hours;
    local String Time;

    if( Seconds > 3600 )
    {
        Hours = Seconds / 3600;
        Seconds -= Hours * 3600;

//        Time = Hours$":";
	}
	Minutes = Seconds / 60;
    Seconds -= Minutes * 60;

    if( Minutes >= 10 )
        Time = Time $ Minutes $ ":";
    else
        Time = Time $ "0" $ Minutes $ ":";

    if( Seconds >= 10 )
        Time = Time $ Seconds;
    else
        Time = Time $ "0" $ Seconds;

    return Time;
}

// ÔØÈëÃÀÊõ×ÖÌå
function Font LoadFoxFont(int i)
{
	if( default.fxFontArray[i] == none )
	{
		default.fxFontArray[i] = Font(DynamicLoadObject(default.fxFontNames[i], class'Font'));

		if( default.fxFontArray[i] == none )
		{
			;
		}
	}

	return default.fxFontArray[i];
}

// Tracing View Target
simulated function bool KFXTraceView(canvas Canvas)
{
	//local actor Other;
	local vector HitLocation, HitNormal, StartTrace, EndTrace;
    KFXCurrTracePawn = none;

	if ( PlayerOwner.Pawn != None && PawnOwner == PlayerOwner.Pawn)
	{
	    StartTrace = PlayerOwner.Pawn.Location + PlayerOwner.Pawn.EyePosition();
        EndTrace = StartTrace + vector(PlayerOwner.Rotation) * 8192.0;
    	KFXCurrTracePawn = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
    }
    else if( KFXPlayer(PlayerOwner).IsInState('spectating')
        && !KFXPlayer(PlayerOwner).bBehindView
        && KFXPlayer(PlayerOwner).SpectateHook.CurSpectateWeap!= none )
    {
        StartTrace = PlayerOwner.ViewTarget.Location +
            KFXPlayer(PlayerOwner).SpectateHook.CurSpectateWeap.EyePosition();
        EndTrace = StartTrace + vector(PlayerOwner.CalcViewRotation) * 8192.0;
    	KFXCurrTracePawn = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
    }

	if(KFXLastTraceViewActor != KFXCurrTracePawn)
	{
		if(KFXPawn(KFXCurrTracePawn) != none
				&& !PlayerOwner.IsDead()
				&& !PlayerOwner.IsInState('Spectating')
				&& PlayerOwner.Pawn == PawnOwner
				&& KFXPawn(KFXCurrTracePawn).PlayerReplicationInfo.Team.TeamIndex != PlayerOwner.PlayerReplicationInfo.Team.TeamIndex)
		{
			if(KFXPawn(KFXCurrTracePawn).PlayerReplicationInfo != none)
				KFXPlayer(PlayerOwner).DoCollectEnemyMsg(KFXPlayerReplicationInfo(KFXPawn(KFXCurrTracePawn).PlayerReplicationInfo).fxPlayerDomain, 1);
		}
	}
	if(PlayerOwner.Pawn != KFXCurrTracePawn)          //TraceµÃµ½µÄ²»ÊÇ×Ô¼º
	{
        KFXLastTraceViewActor = KFXCurrTracePawn;
    }

	if ( KFXCurrTracePawn == none )
	{
	   return false;
	}

	return true;
}

// ÖØÔØÕâ¸ö¶«Î÷**Ð¡¾ÖºÍ×îºóÎÞ·¨Ê¹ÓÃ
exec function KFXShowScores()
{
    if( PlayerOwner.IsInState('GameEnded') || PlayerOwner.IsInState('RoundEnded') && PlayerOwner.IsGameRecorderPlaying() )
    {
        return;
    }
    SetScoreBoardVisible(true);
    UIShowScoreBoard(1);
}

exec function KFXHideTactics()
{
    if(KFXPlayer(PlayerOwner).bKFXKeyOfShowKill)
    {
        bShowWhoKilledMe = !bShowWhoKilledMe;
    }
    SetHitInfoVisible(bShowWhoKilledMe);
}

exec function KFXCloseScores()
{
//    if( PlayerOwner.IsInState('GameEnded') || PlayerOwner.IsInState('RoundEnded') )
//    {
//        return;
//    }
    SetScoreBoardVisible(false);
    UIShowScoreBoard(0);
}

exec function KFXShowWarMap()
{
    bDrawWapMap = true;
}

exec function KFXCloseWarMap()
{
    bDrawWapMap = false;
    warmap_begin_time = -1;
}

//zhong: 2010.9.14 ´òÓ¡Íæ¼ÒÔÚ3dµØÍ¼µÄÎ»ÖÃ
exec function KFXShowLocation()
{

    local Pawn  CompatiblePawn;
    //local vector maplocPlayer;
    CompatiblePawn = PlayerOwner.Pawn;
    maplocPlayer.X = CompatiblePawn.Location.X;
    maplocPlayer.y = CompatiblePawn.Location.Y;

    if(WarMap.ChangeXY == 1)
    {
        maplocPlayer.X = CompatiblePawn.Location.Y;
        maplocPlayer.y = CompatiblePawn.Location.X;
    }
    else if (WarMap.ChangeXY == 2)
    {
        maplocPlayer.X = CompatiblePawn.Location.Y;
        maplocPlayer.y = -CompatiblePawn.Location.X;

    }
    if (WarMap.ChangeXY == 3)
    {
        maplocPlayer.X = CompatiblePawn.Location.Y;
        maplocPlayer.y = CompatiblePawn.Location.X;
    }
    if (WarMap.ChangeXY == 4)
    {
        maplocPlayer.X = -CompatiblePawn.Location.Y;
        maplocPlayer.y = CompatiblePawn.Location.X;
    }
	log("--------WarMap.ChangeXY:"$WarMap.ChangeXY);
	log("--------player x:"$maplocPlayer.X);
	log("--------player y:"$maplocPlayer.Y);

}

//<<ÀîÍþ¹ú ¶Å±ÈHUDÏà¹Ø 2009 1.16
simulated function DrawDolbyHUD(Canvas Canvas, int PlayerInputDFOffset)
{
    local int i;
    local float TalkVolumeWidth;
    local string Indicator;
    local KFXPlayerReplicationInfo fxPRI;
    local byte VoiceFont;

    if( KFXPlayer(PlayerOwner).IsDVValid() )
    {
        TalkVolumeWidth = KFXPlayer(PlayerOwner).DVClient.DVStatus.TalkVolume;
        TalkVolumeWidth = TalkVolumeWidth/255.0*99.0;

        Canvas.KFXSetPivot(DP_LowerLeft);
        Canvas.SetDrawColor(255, 255, 255, 255);

        if( KFXPlayer(PlayerOwner).DVClient.DVIsTalking() )
        {
            //×óÏÂ½Ç À®°È
            Indicator = KFXPlayer(PlayerOwner).DVClient.DVGetSpeakIndicator(
                    KFXPlayer(PlayerOwner).DVClient.DVGetCurVoiceFont(),
                    !KFXPlayer(PlayerOwner).DVClient.bDVSpeakEnabled,
                    true);
            if (Indicator != "")
            {
                Canvas.SetPos(94, 656-PlayerInputDFOffset);
                Canvas.DrawTile(Material(DynamicLoadObject(Indicator, class'Material')),
                            32, 32, 0, 0, 32, 32);
            }

            // ÓïÒô½ø¶ÈÌõ
            if( KFXPlayer(PlayerOwner).DVClient.DVStatus.TalkVolume != 0 )
            {
                //LOG("TalkVolume"$TalkVolumeWidth);

                //×óÏÂ½Ç ±³¾°Ìõ
                Canvas.SetPos(125, 663-PlayerInputDFOffset);
                Canvas.DrawTile(Material(DynamicLoadObject(fx_HUD_Dolby_piece1, class'Material')),
                                105, 20, 0, 0, 105, 20);

                //×óÏÂ½Ç »ÆÉ«¸ßÁÁ
                Canvas.SetPos(128, 667-PlayerInputDFOffset);
                Canvas.DrawTile(Material(DynamicLoadObject(fx_HUD_Dolby_piece2, class'Material')),
                                TalkVolumeWidth, 12, 0, 0, TalkVolumeWidth, 12);
            }
        }
    }

    // ¹Ø±ÕÁËÓïÒô¹¦ÄÜ
    if ( KFXPlayer(PlayerOwner).DVClient!=none && !(KFXPlayer(PlayerOwner).DVClient.bDVSpeakEnabled) )
    {
        Canvas.KFXSetPivot(DP_UpperLeft);
        return;
    }

    Canvas.KFXSetPivot(DP_LowerRight);

    for( i = 0; i < ArrayCount(Dolby_TalkerNames); i++ )
    {
        Dolby_TalkerNames[i].needshow = false;
    }

    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkState == 2 )
            Dolby_TalkerArray[i].TalkState = 1;
    }
    // Ö±½Ó±éÀúPRIÁÐ±í
    for( i = 0; i < GetGRI().PRIArray.length; i++ )
    {
        fxPRI = KFXPlayerReplicationInfo(GetGRI().PRIArray[i]);

        if( fxPRI == none )
        {
            continue;
        }

        VoiceFont = fxPRI.KFXCurVoiceFont;
        if (VoiceFont == 0)
        {
            VoiceFont = fxPRI.KFXVoiceFont;
        }

        if( fxPRI.KFXTalkVolume != 0
            && fxPRI.bKFXTeamTalk
            && KFXInSameTeam(fxPRI) )
        {
            InsertTalkerName("["$lTeamChat$"]"$fxPRI.PlayerName,
            fxPRI.bKFXMute,
            VoiceFont
            );
        }
    }

    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkState == 1 )
            Dolby_TalkerArray[i].TalkState = 0;
    }

    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkState == 3 )
            Dolby_TalkerArray[i].TalkState = 1;
    }

    //Èç¹ûÒ»Ö±ÔÚËµ»°¾Í°ÑÏÔÊ¾×´Ì¬»Ö¸´¹ýÀ´ ÒÑ¾­Í£Ö¹Ëµ»°µÄ¾Í±»ÉèÖÃ³ÉÏÔÊ¾¿ÕÎ»
    //·Ö³ÉÁ½²¿·Ö×öÊÇÎªÁË±£Ö¤Ò»Ö±ÔÚËµ»°µÄ¿ÉÒÔ±£Ö¤ÓÅÏÈ»Ö¸´×Ô¼ºµÄÎ»ÖÃ
    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkState == 1 )
            InsertShowNames(Dolby_TalkerArray[i].TalkerName, Dolby_TalkerArray[i].mask, Dolby_TalkerArray[i].VoiceFont);
    }
    //ÕâÀïInsertÊ§°Üºóµ÷ÓÃInsteadÊÇÎªÁË±£Ö¤ÈÎºÎÒ»¸öÒ»Ö±ÔÚ½²»°µÄTalker¶¼ÓÐÒ»´Î½øÐÐÅÅÐòµÄ»ú»á
    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkState == 1 )
            if( !InsertShowNames(Dolby_TalkerArray[i].TalkerName, Dolby_TalkerArray[i].mask, Dolby_TalkerArray[i].VoiceFont) )
                InsteadShowNames(Dolby_TalkerArray[i].TalkerName,
                Dolby_TalkerArray[i].BeginTime,
                Dolby_TalkerArray[i].mask,
                Dolby_TalkerArray[i].VoiceFont);
    }

    //Èç¹ûÊÇÐÂµÄÍæ¼ÒËµ»°¾ÍÐèÑ°ÕÒ¿ÕÎ»ºÍÌæ»»½ÏÔçËµ»°µÄÍæ¼Ò
    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkState == 2 )
            InsteadShowNames(Dolby_TalkerArray[i].TalkerName,
            Dolby_TalkerArray[i].BeginTime,
            Dolby_TalkerArray[i].mask,
            Dolby_TalkerArray[i].VoiceFont);
    }

    //°Ñ×¼±¸ºÃµÄËµ»°ÁÐ±íËÍÈ¥ÏÔÊ¾
    for( i = 0; i < ArrayCount(Dolby_TalkerNames); i++ )
    {
        if( Dolby_TalkerNames[i].needshow )
        {
            DrawDolbyStringLine(Canvas, Dolby_TalkerNames[i].TalkerName, i, Dolby_TalkerNames[i].mask, Dolby_TalkerNames[i].VoiceFont, bShowWhoKilledMe);
        }
    }

    Canvas.KFXSetPivot(DP_UpperLeft);
}

// ¸ù¾ÝPRIÅÐ¶ÏÊÇ·ñÍ¬¶Ó£¬Ô¼¶¨×Ô¼ººÍ×Ô¼ºÍ¬¶Ó
simulated function bool KFXInSameTeam(KFXPlayerReplicationInfo OtherPRI)
{
    return OtherPRI.Team.TeamIndex == GetPRI().Team.TeamIndex;
}

// Text- text to draw
// line - line num, from 0
// mask - if draw muted icon
// bMoveUpper - if need move up vertically
simulated function DrawDolbyStringLine(Canvas Canvas, string Text, int line, bool mask, byte voicefont, bool bMoveUpper)
{
    local float VertOffset;
    local string MatURL;

    // ÕûÌåµÄÊúÖ±Æ«ÒÆÖµ
    if (bMoveUpper)
        VertOffset = -288;
    else
        VertOffset = 0;

    Canvas.SetDrawColor(255, 255, 255, 255);   //ÎÄ×Ö

    Canvas.SetPos(823, 579-28*line+VertOffset);   //À¶Ìõ1
    Canvas.DrawTile(Material(DynamicLoadObject(fx_HUD_Dolby_background2, class'Material')),
                    190, 24, 0, 0, 190, 24);

    Canvas.SetPos(982, 575-28*line+VertOffset);   //À®°È1

    MatURL = class'KFXGame.KFXDVClientAgent'.static.DVGetSpeakIndicator(voicefont, mask, false);
    Canvas.DrawTile(Material(DynamicLoadObject(MatURL, class'Material')),
                    32, 32, 0, 0, 32, 32);

    Canvas.KFXFontAlias = "heavysmall12";
    Canvas.KFXDrawStrJustifiedWithBorder(Text, 0, 826, 583-28*line+VertOffset, 990, 599-28*line+VertOffset, ShadeColor, 2);
}

simulated function InsertTalkerName(string TalkerName, bool mask, byte VoiceFont)
{
    local int i;
    local DolbyTalkerNameContainer TempTalkerName;
    for( i = 0; i < Dolby_TalkerArray.Length; i++ )
    {
        if( Dolby_TalkerArray[i].TalkerName ~= TalkerName )
        {   if( Dolby_TalkerArray[i].TalkState == 1||Dolby_TalkerArray[i].TalkState == 2 )
            {
                Dolby_TalkerArray[i].TalkState = 3;
                Dolby_TalkerArray[i].mask = mask;
                Dolby_TalkerArray[i].VoiceFont = VoiceFont;
            }
            else if( Dolby_TalkerArray[i].TalkState == 0 )
            {
                Dolby_TalkerArray[i].TalkState = 2;
                Dolby_TalkerArray[i].mask = mask;
                Dolby_TalkerArray[i].VoiceFont = VoiceFont;
                Dolby_TalkerArray[i].BeginTime = Level.TimeSeconds;
            }
            return;
        }
    }

    TempTalkerName.TalkerName = TalkerName;
    TempTalkerName.TalkState = 2;
    TempTalkerName.BeginTime = Level.TimeSeconds;
    TempTalkerName.mask = mask;
    TempTalkerName.VoiceFont = VoiceFont;

    Dolby_TalkerArray[Dolby_TalkerArray.Length] = TempTalkerName;
}

simulated function bool InsertShowNames(string TalkerName, bool mask, byte voicefont)
{
    local int i;
    for( i = 0; i < ArrayCount(Dolby_TalkerNames); i++ )
    {
        if( Dolby_TalkerNames[i].TalkerName == TalkerName )
        {
            Dolby_TalkerNames[i].needshow = true;
            Dolby_TalkerNames[i].mask = mask;
            Dolby_TalkerNames[i].VoiceFont = voicefont;
            return true;
        }
    }
    return false;
}

simulated function InsteadShowNames(string TalkerName, float BeginTime, bool mask, byte voicefont)
{
    local int TempIndex;
    local float TempTime;
    local int i;
    TempTime = -1;
    TempIndex = -1;

    //ÓÐ¿ÕÎ»ÏÈÌî¿ÕÎ»
    for( i = 0; i < ArrayCount(Dolby_TalkerNames); i++ )
    {
        if( !Dolby_TalkerNames[i].needshow )
        {
            Dolby_TalkerNames[i].TalkerName = TalkerName;
            Dolby_TalkerNames[i].needshow = true;
            Dolby_TalkerNames[i].BeginTime = BeginTime;
            Dolby_TalkerNames[i].mask = mask;
            Dolby_TalkerNames[i].VoiceFont = voicefont;

            ;
            return;
        }
    }

    //Ã»ÓÐ¿ÕÎ»°´Ê±¼äÌæ»»×îÔçµÄËµ»°
    for( i = 0; i < ArrayCount(Dolby_TalkerNames); i++ )
    {
        if( Dolby_TalkerNames[i].needshow )
        {
            if( TempTime == -1 )
            {
                TempTime = Dolby_TalkerNames[i].BeginTime;
                TempIndex = i;
            }
            else
            {
                if( TempTime > Dolby_TalkerNames[i].BeginTime )
                {
                    TempTime = Dolby_TalkerNames[i].BeginTime;
                    TempIndex = i;
                }
            }
        }
    }


    if( TempIndex >= 0&& TempIndex < ArrayCount(Dolby_TalkerNames) )
    {
        if( BeginTime > Dolby_TalkerNames[TempIndex].BeginTime )
        {
            Dolby_TalkerNames[TempIndex].TalkerName = TalkerName;
            Dolby_TalkerNames[TempIndex].needshow = true;
            Dolby_TalkerNames[TempIndex].BeginTime = BeginTime;
            Dolby_TalkerNames[TempIndex].mask = mask;
            Dolby_TalkerNames[TempIndex].VoiceFont = voicefont;
        }
    }

}
//>>

//<<ÏûÃðÍ³¼Æ        ChenJianye
function UpdatePlayerKillInfo(Optional PlayerReplicationInfo EndPRI)
{
    local int i;
    local GameReplicationInfo           GRI;
    local KFXPlayerReplicationInfo      PRI;

    nKillInfoCount = 0;
    GRI = GetGRI();
    PlayerKillInfo.Remove(0, PlayerKillInfo.Length);
    for (i=0; i<GRI.PRIArray.Length; i++)
    {
        PRI = KFXPlayerReplicationInfo(GRI.PRIArray[i]);

        if (PRI == GetPRI()||((PRI == EndPRI)&&(EndPRI != none)))
            continue;

		if ( ((PRI.Team == None)||(PRI.Team.TeamIndex != GetPRI().Team.TeamIndex)) && (!PRI.bIsSpectator || PRI.bWaitingPlayer) )
		{
            PlayerKillInfo.Insert(nKillInfoCount, 1);
    		PlayerKillInfo[nKillInfoCount] = PRI;
    		nKillInfoCount++;
        }
    }

    SortPKIArray();
}

function SortPKIArray()
{
    local int i,j;
    local KFXPlayerReplicationInfo tmp;

    for (i=0; i<PlayerKillInfo.Length-1; i++)
    {
        for (j=i+1; j<PlayerKillInfo.Length; j++)
        {
            if( !InOrder( PlayerKillInfo[i], PlayerKillInfo[j] ) )
            {
                tmp = PlayerKillInfo[i];
                PlayerKillInfo[i] = PlayerKillInfo[j];
                PlayerKillInfo[j] = tmp;
            }
        }
    }
}

simulated function bool InOrder( KFXPlayerReplicationInfo P1, KFXPlayerReplicationInfo P2 )
{
    if( P1.bOnlySpectator )
    {
        if( P2.bOnlySpectator )
            return true;
        else
            return false;
    }
    else if ( P2.bOnlySpectator )
        return true;

    if( P1.KFXKilledByMeCount < P2.KFXKilledByMeCount )
        return false;
    if( P1.KFXKilledByMeCount == P2.KFXKilledByMeCount )
    {
		if ( P1.KFXKillMeCount > P2.KFXKillMeCount )
			return false;
		if ( (P1.KFXKillMeCount == P2.KFXKillMeCount) && (P1.PlayerName > P2.PlayerName) )
			return false;
	}
    return true;
}
//>>

function string KFXGetDesignation(int nPoint)
{
    local KFXCSVTable CSVDesignation;
    local int index;

    CSVDesignation = class'KFXTools'.static.KFXCreateCSVTable("KFXDesignation.csv");
    if ( CSVDesignation == none )
    {
        ;
        return " ";
    }
    for ( index = -1; CSVDesignation.SetCurrentRow(index+1); index ++ )
    {
        if ( index > 8 )
        {
            break;
        }

        if ( nPoint < CSVDesignation.GetInt("TotalPoint") )
        {
            break;
        }
    }
    if ( index == -1 )
        index = 0;

    if ( CSVDesignation.SetCurrentRow(index) )
    {
        return CSVDesignation.GetString("Designation");
    }

}

// »­¹Ò»úÏà¹ØHUD
simulated function DrawHanging(Canvas C);

//a simulated function is a function in an Actor-derived class that can be called on a client in a network game
simulated function AddPrado(string sName, int nCityCode, string words, int colorCode)
{
	local KFXCSVTable CityCSV;
	local string /*sProvince,*/ sCityName;
	CityCSV = class'KFXTools'.static.KFXCreateCSVTable("KFXCityinfo.csv");
    if (CityCSV != None)
    {
        if (!CityCSV.SetCurrentRow(nCityCode))
        {
            log ("[HUD_Chat] Invalid CityCode");
        }
        else
        {
//            sProvince = CityCSV.GetString("Province");
            sCityName = CityCSV.GetString("City");
//            if(sProvince != sCityName)
//               sCityName = sProvince$sCityName;
        }
    }
    else
    {
       log("#### ERROR ####  can't find city csv");
    }
 	prados.Insert(prados.length, 1);
 	prados[prados.length-1].content = "[" $ sCityName $ "]"$ sName $ ":" $words;
	prados[prados.Length-1].nType = colorCode;
}


//<<HUD¿ÉÅä ôß»Ý
simulated function KFXDrawTextCsv(Canvas Canvas, int TextIndex,optional string Text)
{
    local KFXCSVTable CSVHUDText;

	local bool Active;
	local EDrawPivot Pivot;
	local int Shader;
	local int Justfied;
	local int LeftX;
	local int LeftY;
	local int RightX;
	local int RightY;

    CSVHUDText = class'KFXTools'.static.KFXCreateCSVTable("HUDTextInfo.csv");

    if( CSVHUDText == none )
    {
        return;
    }

    if( TextIndex == 0 || !CSVHUDText.SetCurrentRow(TextIndex) )
    {
        return;
    }

    Active = CSVHUDText.GetBool("Active");
    Justfied = CSVHUDText.GetInt("Justfied");
    Shader = CSVHUDText.GetInt("Shader");
    LeftX = CSVHUDText.GetFloat("LeftX");
    LeftY = CSVHUDText.GetFloat("LeftY");
    RightX = CSVHUDText.GetFloat("RightX");
    RightY = CSVHUDText.GetFloat("RightY");
    Pivot = EDrawPivot(CSVHUDText.GetInt("Pivot"));

	if ( !Active )
	{
		return;
	}

	if (Pivot > DP_UpperLeft && Pivot < DP_MiddleMiddle )
	{
    	Canvas.KFXSetPivot(Pivot);
	}

	Canvas.KFXDrawStrJustifiedWithBorder(
        Text,
        Justfied,
        LeftX, LeftY,
        RightX, RightY,
        ShadeColor,
        Shader
        );

    Canvas.KFXSetPivot(DP_UpperLeft);

}

simulated function KFXDrawTileCsv(Canvas Canvas, int TileIndex, optional string TileSrc)
{
    local KFXCSVTable CSVHUDTile;
    local Material Mat;

    local string MatSrc;
    local bool Active;
    local EDrawPivot Pivot;
    local int PosX, PosY;
    local int OrigX, OrigY;
    local int ClipX, ClipY;
    local int LengthX, LengthY;

    CSVHUDTile = class'KFXTools'.static.KFXCreateCSVTable("HUDTileInfo.csv");

    if( CSVHUDTile == none )
    {
        ;
        return;
    }

    if( TileIndex == 0 || !CSVHUDTile.SetCurrentRow(TileIndex) )
    {
        ;
        return;
    }

	if ( TileSrc != "" )
	{
    	MatSrc = CSVHUDTile.GetString("MatSrc");
    }
    else
    {
    	MatSrc = TileSrc;
    }

    Mat = Material(DynamicLoadObject(MatSrc, class'Material'));

    if( Mat == none )
    {
        ;
        return;
    }

    Active = CSVHUDTile.GetBool("Active");
    PosX = CSVHUDTile.GetFloat("PosX");
    PosY = CSVHUDTile.GetFloat("PosY");
    LengthX = CSVHUDTile.GetFloat("LengthX");
    LengthY = CSVHUDTile.GetFloat("LengthY");
    OrigX = CSVHUDTile.GetFloat("OrigX");
    OrigY = CSVHUDTile.GetFloat("OrigY");
    ClipX = CSVHUDTile.GetFloat("ClipX");
    ClipY = CSVHUDTile.GetFloat("ClipY");
    Pivot = EDrawPivot(CSVHUDTile.GetInt("Pivot"));


	if ( Active )
	{
	    Canvas.KFXSetPivot(Pivot);
	    Canvas.SetPos(PosX, PosY);
	    Canvas.DrawTile(
	        Mat,
	        LengthX, LengthY,
	        OrigX, OrigY,
	        ClipX, ClipY
	        );
    	Canvas.KFXSetPivot(DP_UpperLeft);
	}
}
simulated function KFXDrawTile(Canvas Canvas, KFXTileInfo Tile)
{
	if ( Tile.Active )
	{
	    Canvas.KFXSetPivot(Tile.Pivot);
		if ( Tile.ForcedAlpha < 1 )
		{
			Canvas.bForceAlpha = true;
			Canvas.ForcedAlpha = Tile.ForcedAlpha;
		}
		Canvas.SetPos(Tile.PosX, Tile.PosY);
		if(Tile.MatSrc != none)
			Canvas.DrawTile( Tile.MatSrc, Tile.LengthX,
		            Tile.LengthY, Tile.OrigX, Tile.OrigY, Tile.ClipX, Tile.ClipY );
	    Canvas.KFXSetPivot(DP_UpperLeft);
	    Canvas.bForceAlpha = false;
    }
}
simulated function KFXDrawXMLTileInfo(Canvas Canvas, KFXXMLTileInfo Tile,optional bool bClipRect)
{
	if(Tile.Active && Tile.szImageSet != "" && Tile.szImage != "")
	{
		Canvas.KFXSetPivot(Tile.Pivot);
		if(Tile.ForcedAlpha < 1)
		{
			Canvas.bForceAlpha = true;
			Canvas.ForcedAlpha = Tile.ForcedAlpha;
		}
		else
			Canvas.bForceAlpha = false;
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.SetPos(Tile.PosX, Tile.PosY);
		if(bClipRect)
		{
    		Canvas.KFXDrawXMLTile(Tile.szImageSet, Tile.szImage, false, Tile.LengthX,    				Tile.LengthY, Tile.OrigX, Tile.OrigY, Tile.ClipX, Tile.ClipY);		}		else		{            Canvas.KFXDrawXMLTile(Tile.szImageSet, Tile.szImage, true, Tile.LengthX,    				Tile.LengthY, Tile.OrigX, Tile.OrigY, Tile.ClipX, Tile.ClipY);        }
		//»¹Ô­ÊôÐÔ
		Canvas.KFXSetPivot(DP_UpperLeft);
		Canvas.bForceAlpha = false;
	}
}

function KFXDrawNarrowText(Canvas Canvas, KFXTextInfo TextInfo, coerce string TextSrc, byte narrow)
{
	if ( !TextInfo.Active )
	{
		return;
	}

    Canvas.KFXSetPivot(TextInfo.Pivot);
	Canvas.DrawTextNarrowJustified(
        TextSrc,
        TextInfo.Justfied,
        TextInfo.LeftX, TextInfo.LeftY,
        TextInfo.RightX, TextInfo.RightY,
        narrow
        );
    Canvas.KFXSetPivot(DP_UpperLeft);
}
simulated function KFXDrawText(Canvas Canvas, KFXTextInfo TextInfo, coerce string TextSrc)
{

	if ( !TextInfo.Active )
	{
		return;
	}

    Canvas.KFXSetPivot(TextInfo.Pivot);
	Canvas.DrawTextJustified(
        TextSrc,
        TextInfo.Justfied,
        TextInfo.LeftX, TextInfo.LeftY,
        TextInfo.RightX, TextInfo.RightY
        );
    Canvas.KFXSetPivot(DP_UpperLeft);
}
function KFXInitBloodTilePos()
{
    FlyFiftyBloodTilePos.X =  FlyFiftyBloodTile.PosX;
    FlyFiftyBloodTilePos.Y =  FlyFiftyBloodTile.PosY;
    FlyTenBloodTilePos.X   =  FlyTenBloodTile.PosX;
    FlyTenBloodTilePos.Y   =  FlyTenBloodTile.PosY;

}

simulated function KFXInit()
{
	local KFXCSVTable CSVHUDTile, CSVHUDText;
    local int i;
	CSVHUDTile = class'KFXTools'.static.KFXCreateCSVTable("HUDTileInfo.csv");
	CSVHUDText = class'KFXTools'.static.KFXCreateCSVTable("HUDTextInfo.csv");

	if( CSVHUDTile == none )
    {
        log("[KFXHUD]KFXDrawTile HUDTileInfo Table error");
        return;
    }

    if( CSVHUDText == none )
    {
    	log("[KFXHUD]KFXDrawTile HUDTextInfo Table error");
        return;
    }

	//<< À×´ïÏà¹Ø
    KFXInitTile(1, CSVHUDTile, KFXRadarBox);
    KFXInitTile(2, CSVHUDTile, KFXRadarFinger);
    KFXInitTile(3, CSVHUDTile, KFXRadarDolbyIcon);
    KFXInitTile(4, CSVHUDTile, KFXRadarFire);
    KFXInitTile(5, CSVHUDTile, KFXRadarDead);
    KFXInitTile(6, CSVHUDTile, KFXRadarSpeech);
    KFXInitTile(7, CSVHUDTile, KFXRadarTeamMate);
    //>>

    //<<µ¹¼ÆÊ±°æ£¨µÃ·Ö°æ£©
    KFXInitTile(8, CSVHUDTile, KFXTimeTableBlue);
    KFXInitTile(9, CSVHUDTile, KFXTimeTableRed);
    KFXInitTile(10, CSVHUDTile, KFXTimeTableGray);
	//>>

	//<<µÐÎÒ
    KFXInitTile(11, CSVHUDTile, KFXOurPartBlue);
    KFXInitTile(12, CSVHUDTile, KFXOurPartRed);
    KFXInitTile(13, CSVHUDTile, KFXEnemyBlue);
    KFXInitTile(14, CSVHUDTile, KFXEnemyRed);
    //>>

    //<<HP
    KFXInitTile(15, CSVHUDTile, KFXHPDownBox);
    KFXInitTile(16, CSVHUDTile, KFXHPBar);
    KFXInitTile(31, CSVHUDTile, KFXAPBar);
    KFXInitText(8,  CSVHUDText, KFXHPValue);
    KFXInitText(9,  CSVHUDText, KFXArmorValue);
	//>>
	KFXInitTile(30, CSVHUDTile, KFXWeaponDownInfo);
	KFXInitTile(32, CSVHUDTile, KFXWeaponUpInfo);
	KFXInitText(10, CSVHUDText, KFXCurBulletInfo);
	KFXInitText(11, CSVHUDText, KFXMaxBulletInfo);

	KFXInitXMLTile(132, CSVHUDtile, KFXTeamPicRed);
	KFXInitXMLTile(133, CSVHUDtile, KFXTeamPicBlue);
	KFXInitXMLTile(134, CSVHUDtile, KFXHPPic);
	KFXInitXMLTile(135, CSVHUDtile, KFXAPPic);
	KFXInitXMLTile(136, CSVHUDtile, KFXAmmoCountLine);
	KFXInitXMLTile(137, CSVHUDtile, KFXFlashPic);
	KFXInitXMLTile(138, CSVHUDtile, KFXFlashPicHighlight);
	KFXInitXMLTile(139, CSVHUDtile, KFXGrenadePic);
	KFXInitXMLTile(140, CSVHUDtile, KFXGrenadePicHighlight);
	KFXInitXMLTile(141, CSVHUDtile, KFXSmokePic);
	KFXInitXMLTile(142, CSVHUDtile, KFXSmokePicHighlight);
	KFXInitXMLTile(143, CSVHUDtile, KFXTimeFrameRed);
	KFXInitXMLTile(144, CSVHUDtile, KFXTimeFrameBlue);
	KFXInitXMLTile(145, CSVHUDtile, KFXTimeFrameNormal);
	KFXInitXMLTile(146, CSVHUDtile, KFXMainWeaponPic);
	KFXInitXMLTile(147, CSVHUDtile, KFXSecondWeaponPic);
	KFXInitXMLTile(148, CSVHUDtile, KFXKnifePic);
	KFXInitXMLTile(149, CSVHUDtile, KFXACEInfo);
	KFXInitXMLTile(150, CSVHUDTile, KFXRadraFrameInfo);
    KFXInitXMLTile(151, CSVHUDTile, KFXRevengeInfo);
    KFXInitXMLTile(152, CSVHUDTile, KFXHitInfoBackground);
    KFXInitXMLTile(153, CSVHUDTile, KFXHitOtherLevel);
    KFXInitXMLTile(154, CSVHUDTile, KFXHitOtherHeadIcon);
    KFXInitXMLTile(155, CSVHUDTile, KFXHitOtherNormalIcon);
    KFXInitXMLTile(156, CSVHUDTile, KFXBeHitedLevel);
    KFXInitXMLTile(157, CSVHUDTile, KFXBeHitedHeadIcon);
    KFXInitXMLTile(158, CSVHUDTile, KFXBeHitedNormalIcon);
    KFXInitXMLTile(159, CSVHUDTile, KFXBeHitedWeapIcon);
    KFXInitXMLTile(160, CSVHUDTile, KFXHundredCent);
    KFXInitXMLTile(161, CSVHUDTile, KFXTenCent);
    KFXInitXMLTile(162, CSVHUDTile, KFXOneCent);
    KFXInitXMLTile(163, CSVHUDTile, KFXHitInfoHint);
	KFXInitXMLTile(164, CSVHUDTile, KFXEncourageInfo);

	//»÷É±Í³¼Æ
 	KFXInitXMLTile(171, CSVHUDTile, KFXLastKillerHeadIcon);
 	KFXInitXMLTile(172, CSVHUDTile, KFXLastKillerWeaponIcon);
 	KFXInitXMLTile(173, CSVHUDTile, KFXHitterHeadIcon[0]);
 	KFXInitXMLTile(174, CSVHUDTile, KFXHitterHeadIcon[1]);
 	KFXInitXMLTile(175, CSVHUDTile, KFXHittedHeadIcon[0]);
 	KFXInitXMLTile(176, CSVHUDTile, KFXHittedHeadIcon[1]);
 	KFXInitXMLTile(177, CSVHUDTile, KFXHittedHeadIcon[2]);
 	KFXInitXMLTile(178, CSVHUDTile, KFXHittedHeadIcon[3]);
 	KFXInitXMLTile(179, CSVHUDTile, KFXHittedHeadIcon[4]);
 	KFXInitXMLTile(180, CSVHUDTile, KFXHittedHeadIcon[5]);
	KFXInitXMLTile(181, CSVHUDTile, KFXShopSignal);
 	KFXInitXMLTile(182, CSVHUDTile, KFXKnifeBulletPic);
	KFXInitXMLTile(183, CSVHUDTile, FiftyBloodTile);
 	KFXInitXMLTile(184, CSVHUDTile, TenBloodTile);
    KFXInitXMLTile(183, CSVHUDTile, FlyFiftyBloodTile);
    KFXInitXMLTile(184, CSVHUDTile, FlyTenBloodTile);
    KFXInitXMLTile(185, CSVHUDTile, FlyOneKillTile);

    KFXInitBloodTilePos();
    KFXInitXMLTile(186, CSVHUDTile, KFXKnifeLeftCanAttack);
    KFXInitXMLTile(187, CSVHUDTile, KFXKnifeRightCanAttack);
    KFXInitXMLTile(188, CSVHUDTile, KFXKnifeBothCanAttack);
    KFXInitXMLTile(189, CSVHUDTile, KFXKnifeCannotAttack);

	KFXInitXMLTile(190, CSVHUDTile, KFXGameLogo);
	KFXInitXMLTile(191, CSVHUDTile, DropItemTile);
	KFXInitText(16, CSVHUDText, KFXWeaponName);
	KFXInitText(17, CSVHUDText, KFXBulletLine);
	KFXInitText(18, CSVHUDText, KFXFlashCnt);
	KFXInitText(19, CSVHUDText, KFXGrenadeCnt);
	KFXInitText(20, CSVHUDText, KFXSmokeCnt);
	KFXInitText(23, CSVHUDText, KFXHitOtherName);
	KFXInitText(24, CSVHUDText, KFXHitOtherHP);
	KFXInitText(25, CSVHUDText, KFXBeHitedName);
	KFXInitText(26, CSVHUDText, KFXBeHitedHP);
	KFXInitText(27, CSVHUDText, KFXBeHitedShotCutKey);

	//»÷É±Í³¼Æ
	KFXInitText(28, CSVHUDText, KFXLastKillerName);
	KFXInitText(29, CSVHUDText, KFXLastKillerHP);
	KFXInitText(30, CSVHUDText, KFXLastKillerWeaponName);
	KFXInitText(31, CSVHUDText, KFXHitterName[0]);
	KFXInitText(32, CSVHUDText, KFXHitterName[1]);
	KFXInitText(33, CSVHUDText, KFXHitterHP[0]);
	KFXInitText(34, CSVHUDText, KFXHitterHP[1]);
	KFXInitText(35, CSVHUDText, KFXHittedName[0]);
	KFXInitText(36, CSVHUDText, KFXHittedName[1]);
	KFXInitText(37, CSVHUDText, KFXHittedName[2]);
	KFXInitText(38, CSVHUDText, KFXHittedName[3]);
	KFXInitText(39, CSVHUDText, KFXHittedName[4]);
	KFXInitText(40, CSVHUDText, KFXHittedName[5]);
	KFXInitText(41, CSVHUDText, KFXHittedHP[0]);
	KFXInitText(42, CSVHUDText, KFXHittedHP[1]);
	KFXInitText(43, CSVHUDText, KFXHittedHP[2]);
	KFXInitText(44, CSVHUDText, KFXHittedHP[3]);
	KFXInitText(45, CSVHUDText, KFXHittedHP[4]);
	KFXInitText(46, CSVHUDText, KFXHittedHP[5]);
    for(i=1; i<=14; i++)
    {
        KFXInitText(4000+i, CSVHUDText, KFXHelpInSpectating[i-1]);
    }

}

exec function TileChangeCoordinate(int index, int x, int y, int xl, int yl)
{

}

simulated function KFXInitTile(int Index, KFXCSVTable Table, out KFXTileInfo Tile)
{

	if( Index == 0 || !Table.SetCurrentRow(Index) )
    {
        ;
        return;
    }

    Tile.Active = Table.GetBool("Active");

    if ( !Tile.Active )
    {
    	return;
    }
    Tile.MatSrc = Material(DynamicLoadObject(Table.GetString("MatSrc"), class'Material'));
    Tile.PosX = Table.GetFloat("PosX");
    Tile.PosY = Table.GetFloat("PosY");
    Tile.LengthX = Table.GetFloat("LengthX");
    Tile.LengthY = Table.GetFloat("LengthY");
    Tile.OrigX = Table.GetFloat("OrigX");
    Tile.OrigY = Table.GetFloat("OrigY");
    Tile.ClipX = Table.GetFloat("ClipX");
    Tile.ClipY = Table.GetFloat("ClipY");
    Tile.Pivot = EDrawPivot(Table.GetInt("Pivot"));
    Tile.ForcedAlpha = Table.GetFloat("ForcedAlpha");

}
simulated function KFXInitXMLTile(int index, KFXCSVTable Table, out KFXXMLTileInfo Tile)
{
	local string s;
	local int colon;
	if(Index == 0 || !Table.SetCurrentRow(index))
	{
		;
		return;
	}
    Tile.Active = Table.GetBool("Active");

	//xmltileÔÚcsvÖÐ´æÖü×ÊÔ´Ãû³ÆÊ±£¬ÐèÒªÊ¹ÓÃ"set:imagetsetname image:imagename"ÕâÖÖÐÎÊ½
	s = Table.GetString("MatSrc");

	if (s != "null" && s != "none" && s != "0")
	{
		colon = InStr(s, ":");
	 	s = Right(s, Len(s)-colon-1);
	 	Tile.szImageSet = Left(s, InStr(s, " "));
	 	colon = InStr(s, ":");
	 	if(colon == -1)
	 	{
			Tile.szImage = "";
			Tile.szImageSet = "";
			//return;
		}
		else
		{
		 	Tile.szImage = Right(s, Len(s)-colon-1);
		}
 	}
 	else
 	{
		Tile.szImage = "";
		Tile.szImageSet = "";
		//return;
	}
	if(Tile.szImage == "")
	{
		log("#### WARNING #### init tile info failed, idx="$index);
	}
    Tile.PosX = Table.GetFloat("PosX");
    Tile.PosY = Table.GetFloat("PosY");
    Tile.LengthX = Table.GetFloat("LengthX");
    Tile.LengthY = Table.GetFloat("LengthY");
    Tile.OrigX = Table.GetFloat("OrigX");
    Tile.OrigY = Table.GetFloat("OrigY");
    Tile.ClipX = Table.GetFloat("ClipX");
    Tile.ClipY = Table.GetFloat("ClipY");
    Tile.Pivot = EDrawPivot(Table.GetInt("Pivot"));
    Tile.ForcedAlpha = Table.GetFloat("ForcedAlpha");

}

simulated function KFXInitText(int index, KFXCSVTable Table, out KFXTextInfo TextInfo)
{
	if( Index == 0 || !Table.SetCurrentRow(Index) )
    {
        ;
        return;
    }

    TextInfo.Active = Table.GetBool("Active");

    if ( !TextInfo.Active )
    {
    	return;
    }

    TextInfo.Text = Table.GetString("Text");
    TextInfo.Justfied = Table.GetInt("Justfied");
    TextInfo.Shader = Table.GetInt("Shader");
    TextInfo.LeftX = Table.GetFloat("LeftX");
    TextInfo.LeftY = Table.GetFloat("LeftY");
    TextInfo.RightX = Table.GetFloat("RightX");
    TextInfo.RightY = Table.GetFloat("RightY");
    TextInfo.Pivot = EDrawPivot(Table.GetInt("Pivot"));
}
//HUD¿ÉÅä>>
//»æÖÆÕ½¶·ÐÅÏ¢ÖÐµÄ»÷É±Í¼±ê
function KFXDrawKilledIcon(Canvas canvas, int id)
{
//		0,×ÔÉ±
//		1£¬±¬Í·
//		2£¬±äÖí
//		3£¬±ä¹ê
//		4£¬±äÃ¨
//		5-7£¬É±Öí¡¢¹ê¡¢Ã¨
	local string tset, timage;
	local float  x, y, xl, yl;
	tset="mat2_HUD_weaponkill";
	switch(id)
	{
		case 0:
			timage="NewImage30";
			break;
		case 1:
			timage="NewImage13";
			break;
		case 15:
			timage = "NewImage15";
			break;
		case 16:
			timage = "NewImage12";
			break;
		default:
			log("#### WARNING #### unknown killed type="$id);
			tset="";
			timage="";
			break;
	}
	if(tset != "" && timage != "")
	{
		Canvas.KFXLoadXMLMaterial(tset, timage, x, y, xl, yl);
		canvas.KFXDrawXMLTile(tset, timage, true, xl, yl);
	}
}
function GetWeaponInfo(int weaponID, out string WeaponName, out String WeaponIcon)
{
	local KFXCSVTable csvWeaponMedia;
	csvWeaponMedia = class'KFXTools'.static.KFXCreateCSVTable("weaponMedia.csv");
	if(csvWeaponMedia != none && csvWeaponMedia.SetCurrentRow(WeaponId))
	{
		WeaponName = csvWeaponMedia.GetString("Name");
		WeaponIcon = csvWeaponMedia.GetString("HUDRes_Kill");
	}
}
function SetHitInfoVisible(bool visible)
{
if(_HUD_NEW_ == 2)
{
	if(HitInfoVisible == int(visible))
	{
		PlayerOwner.Player.GUIController.SetHUDData_HitInfo(PlayerOwner.PlayerReplicationInfo, false);
	}
	else
	{
		PlayerOwner.Player.GUIController.SetHUDData_HitInfo(PlayerOwner.PlayerReplicationInfo, visible);
	}
}
}
function DrawHitInfo(Canvas Canvas)
{
	local int i;
	local int HitInfoNum, HitOtherCnt, BeHitedCnt;
	local string sWeaponIcon, sWeaponName;
	local string sSet, sImage;
	local float x, y, xl, yl;

    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.KFXFontAlias = "heavymedium15";

	HitInfoNum = GetPRI().HitCollect_CNT;
	HitOtherCnt = 0;
	BeHitedCnt = 0;

	if (KFXPlayer(PlayerOwner).bKFXKeyOfShowKill)
    {

    	if (PlayerOwner.IsDead())
    	{
    		bShowHitCollectInfo = true;
    	}

    	if (level.TimeSeconds - GetPRI().fxClientDeadTime > ShowHitCollectTime
			|| level.TimeSeconds - GetPRI().fxClientDeadTime < 0)
    	{
    		bShowHitCollectInfo = false;
    	}

        if (bShowWhoKilledMe
			|| (bShowHitCollectInfo
			&& level.TimeSeconds - GetPRI().fxClientDeadTime <= ShowHitCollectTime
			&& GetPRI().fxClientDeadTime > 0.0))
        {
if(_HUD_NEW_ == 2)
{
        	SetHitInfoVisible(true);
}
else
{
        	// »­±³¾°
			KFXDrawXMLTileInfo(Canvas, KFXHitInfoBackground);
//			KFXDrawXMLTileInfo(Canvas, KFXHitInfoHint);

			//»æÖÆ±»»÷É±ÐÅÏ¢
			//×îºóÒ»¸ö»÷ÖÐ×Ô¼ºµÄÈË
			//×îºóÒ»¸ö¼¯ÖÐ×Ô¼ºµÄÈËËùÊ¹ÓÃµÄÎäÆ÷
			//µ¹ÊýµÚ¶þ¸ö
			//µ¹ÊýµÚÈý¸ö
            if(GetPRI().BeHitedListHUD.HiterName[0] != "")
            {
            	Canvas.KFXFontAlias = "heavytiny13";
				Canvas.SetDrawColor(0xdc, 0xdc, 0xdc, 0xff);

            	KFXDrawStrYOffsett(Canvas, KFXLastKillerName, GetPRI().BeHitedListHUD.HiterName[0], 0);
				KFXDrawStrYOffsett(Canvas, KFXLastKillerHP, GetPRI().BeHitedListHUD.HitHP[0], 0);
				GetWeaponInfo(GetPRI().BeHitedListHUD.HitWeapID[0], sWeaponName, sWeaponIcon);
				KFXDrawStrYOffsett(Canvas, KFXLastKillerWeaponName, sWeaponName, 0);

				if(GetPRI().BeHitedListHUD.bHeadKill[0] == 1)
				{
					KFXLastKillerHeadIcon.szImageSet = "mat2_HUD_cheer";
                	KFXLastKillerHeadIcon.szImage = "NewImage21";
				}
                else if(GetPRI().BeHitedListHUD.bShootDown[0] == 1)
                {
					KFXLastKillerHeadIcon.szImageSet = "mat2_HUD_cheer";
                	KFXLastKillerHeadIcon.szImage = "NewImage20";
				}
				else
				{
					KFXLastKillerHeadIcon.szImageSet = "";
                	KFXLastKillerHeadIcon.szImage = "";
				}

				Canvas.SetDrawColor(255, 255, 255);
				KFXDrawXMLTileInfo(Canvas, KFXLastKillerHeadIcon);

				GotSetAndImage(sWeaponIcon, sSet, sImage);
//				KFXLastKillerWeaponIcon.szImageSet = sSet;
//				KFXLastKillerWeaponIcon.szImage = sImage;

				//»æÖÆÎäÆ÷µÄÍ¼±ê
				Canvas.KFXLoadXMLMaterial(sSet, sImage, x, y, xl, yl);
				x = xl;
				y = yl;
				//µÈ±ÈÀýËõ·Å
				if(xl > KFXLastKillerWeaponIcon.LengthX)
				{
					yl = yl * KFXLastKillerWeaponIcon.LengthX / xl;
					xl = KFXLastKillerWeaponIcon.LengthX;
				}
				if(yl > KFXLastKillerWeaponIcon.LengthY)
				{
					xl = xl * KFXLastKillerWeaponIcon.LengthY / yl;
					yl = KFXLastKillerWeaponIcon.LengthY;
				}
				Canvas.SetPos(KFXLastKillerWeaponIcon.PosX+(KFXLastKillerWeaponIcon.LengthX-xl)/2, KFXLastKillerWeaponIcon.PosY+(KFXLastKillerWeaponIcon.LengthY-yl)/2);
				Canvas.KFXSetPivot(KFXLastKillerWeaponIcon.Pivot);
				Canvas.KFXDrawXMLTile(sSet, sImage, true, xl, yl);

			}
			for(i=0; i<2; i++)
			{
				if(GetPRI().BeHitedListHUD.HiterName[1+i] != "")
				{
					if(GetPRI().BeHitedListHUD.bHeadKill[i+1] == 1)
					{
						KFXHitterHeadIcon[i].szImageSet = "mat2_HUD_cheer";
                    	KFXHitterHeadIcon[i].szImage = "NewImage21";
                    	KFXHitterHeadIcon[i].LengthX = 30;
                    	KFXHitterHeadIcon[i].LengthY = 25;
					}
                    else if(GetPRI().BeHitedListHUD.bShootDown[i+1] == 1)
                    {
						KFXHitterHeadIcon[i].szImageSet = "mat2_HUD_cheer";
                    	KFXHitterHeadIcon[i].szImage = "NewImage20";
                    	KFXHitterHeadIcon[i].LengthX = 45*25/49;
                    	KFXHitterHeadIcon[i].LengthY = 25;
					}
					else
					{
						KFXHitterHeadIcon[i].szImageSet = "";
                    	KFXHitterHeadIcon[i].szImage = "";
					}
					Canvas.SetDrawColor(255, 255, 255);
	             	KFXDrawXMLTileInfo(Canvas, KFXHitterHeadIcon[0+i]);

            		Canvas.KFXFontAlias = "heavytiny13";

					Canvas.SetDrawColor(0xdc, 0xdc, 0xdc, 0xff);
					KFXDrawStrYOffsett(Canvas, KFXHitterName[0+i], GetPRI().BeHitedListHUD.HiterName[1+i], 0);
					KFXDrawStrYOffsett(Canvas, KFXHitterHP[0+i], GetPRI().BeHitedListHUD.HitHP[1+i], 0);
				}
			}

			//»æÖÆ»÷ÖÐÐÅÏ¢
			//×î½üÒ»´ÎµÄ£¬µÚ¶þ½üµÄ£¬¡£¡£¡£
            for(i=0; i<6; i++)
			{
				if(GetPRI().HitOtherListHUD.OtherName[i] != "")
				{
					if(GetPRI().HitOtherListHUD.bHeadKill[i] == 1)
					{
						KFXHittedHeadIcon[i].szImageSet = "mat2_HUD_cheer";
                    	KFXHittedHeadIcon[i].szImage = "NewImage21";
					}
                    else if(GetPRI().HitOtherListHUD.bShootDown[i] == 1)
                    {
						KFXHittedHeadIcon[i].szImageSet = "mat2_HUD_cheer";
                    	KFXHittedHeadIcon[i].szImage = "NewImage20";
					}
					else
					{
						KFXHittedHeadIcon[i].szImageSet = "";
                    	KFXHittedHeadIcon[i].szImage = "";
					}

					Canvas.SetDrawColor(255, 255, 255);
	             	KFXDrawXMLTileInfo(Canvas, KFXHittedHeadIcon[0+i]);

            		Canvas.KFXFontAlias = "heavytiny13";
            		Canvas.SetDrawColor(0xdc, 0xdc, 0xdc, 0xff);
					if(GetPRI().HitOtherListHUD.HitHP[i] >= 100 || GetPRI().HitOtherListHUD.bShootDown[i]==1)
					{
					    Canvas.SetDrawColor(0xfc, 0x58, 0x58, 0xff);
					}
					else
					{
						Canvas.SetDrawColor(0xdc, 0xdc, 0xdc, 0xff);
					}
					KFXDrawStrYOffsett(Canvas, KFXHittedName[0+i], GetPRI().HitOtherListHUD.OtherName[0+i], 0);
					KFXDrawStrYOffsett(Canvas, KFXHittedHP[0+i], GetPRI().HitOtherListHUD.HitHP[0+i], 0);
				}
			}
}
        }
        else if ((PlayerOwner.IsDead() || PlayerOwner.IsInState('Spectating'))
			&& PlayerOwner.Pawn == none)
        {
if(_HUD_NEW_ == 2)
{
            SetHitInfoVisible(false);
}
else
{
			Canvas.SetDrawColor(255, 255, 255);
        	KFXDrawXMLTileInfo(Canvas, KFXHitInfoHint);
}
        }

    }

    Canvas.SetDrawColor(255, 255, 255, 255);
}

simulated function string GetWeapShotCutKey(int WeapID)
{
    local KFXCSVTable CsvChangeWeap;
    local string sWeapIcon;
    local int i, j, tempID;

    CsvChangeWeap = class'KFXTools'.static.KFXCreateCSVTable("changeweapon.csv");

    if (CsvChangeWeap == none)
    {
        return "";
    }

    sWeapIcon = "B+";
    for (i = 1; i < 9; i++)
    {
		if (!CsvChangeWeap.SetCurrentRow(i))
	    {
	        continue;
	    }

    	for (j = 1; j < 9; j++)
    	{
    		tempID = CsvChangeWeap.GetInt("itemID" $ j);
    		if (WeapID == tempID)
    		{
    			sWeapIcon = sWeapIcon $ i $ "+";
            	sWeapIcon = sWeapIcon $ j;
            	return sWeapIcon;
    		}
    	}
    }

    return "";

}

// »­YÖáÉÏÓÐÆ«ÒÆ
simulated function DrawXMLTileYOffsett(Canvas Canvas, KFXXMLTileInfo Tile, int YOffsett)
{
	if(Tile.Active && Tile.szImageSet != "" && Tile.szImage != "")
	{
		Canvas.KFXSetPivot(Tile.Pivot);
		if(Tile.ForcedAlpha < 1)
		{
			Canvas.bForceAlpha = true;
			Canvas.ForcedAlpha = Tile.ForcedAlpha;
		}
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.SetPos(Tile.PosX, Tile.PosY + YOffsett);
		Canvas.KFXDrawXMLTile(Tile.szImageSet, Tile.szImage, true, Tile.LengthX,
				Tile.LengthY, Tile.OrigX, Tile.OrigY, Tile.ClipX, Tile.ClipY);

		//»¹Ô­ÊôÐÔ
		Canvas.KFXSetPivot(DP_UpperLeft);
		Canvas.bForceAlpha = false;
	}
}

simulated function KFXDrawStrYOffsett(Canvas Canvas, KFXTextInfo TextInfo, coerce string TextSrc, int YOffsett)
{

	if ( !TextInfo.Active )
	{
		return;
	}

    Canvas.KFXSetPivot(TextInfo.Pivot);
	Canvas.KFXDrawStrJustified(
        TextSrc,
        TextInfo.Justfied,
        TextInfo.LeftX, TextInfo.LeftY + YOffsett,
        TextInfo.RightX, TextInfo.RightY + YOffsett
        );
    Canvas.KFXSetPivot(DP_UpperLeft);
}

// »­ÈËÎïµÈ¼¶
simulated function string GetPlayerLevelIcon(int Level)
{
    local KFXCSVTable fxCsvLevel;
    local string sLevelIcon;

    fxCsvLevel = class'KFXTools'.static.KFXCreateCSVTable("LevelUpgradeTable.csv");

    if (fxCsvLevel == none)
    {
        return "";
    }

    if (!fxCsvLevel.SetCurrentRow(Level))
    {
        return "";
    }

    sLevelIcon = fxCsvLevel.GetString("SmallLevelIcon");

    return sLevelIcon;
}

simulated function ResetXMLTile(out KFXXMLTileInfo Tile, string sSetting)
{
	local int colon;

	if (sSetting != "null" && sSetting != "none" && sSetting != "0")
	{
		colon = InStr(sSetting, ":");
	 	sSetting = Right(sSetting, Len(sSetting)-colon-1);
	 	Tile.szImageSet = Left(sSetting, InStr(sSetting, " "));
	 	colon = InStr(sSetting, ":");
	 	if(colon == -1)
	 	{
			Tile.szImage = "";
			Tile.szImageSet = "";
			//return;
		}
		else
		{
	 		Tile.szImage = Right(sSetting, Len(sSetting)-colon-1);
	 	}
	}
	else
	{
		Tile.szImage = "";
		Tile.szImageSet = "";
	}
}
function DrawTaskTip(Canvas canvas)
{
	local KFXCSVTable csvTask;
//	local float xpos, ypos;
	local string sset, simage;
	local float ou, ov, oul, ovl;
	//»æÖÆ¸ÃÍæ¼ÒµÄÈÎÎñÌáÊ¾
	if(MyTaskTips.Length > 0)
	{
		csvTask = class'KFXTools'.static.GetConfigTable(706);
		if(MyTaskTips[0].passtime == -1)
		{
			MyTaskTips[0].passtime = Level.TimeSeconds;
		}
		//³¬¹ý5ÃëµÄ£¬É¾³ý
		if(Level.TimeSeconds - MyTaskTips[0].passtime > 5.0f)
		{
        	MyTaskTips.Remove(0, 1);
		}
		else
		{
			Canvas.ForcedAlpha = - (Level.TimeSeconds - MyTaskTips[0].passtime)*(Level.TimeSeconds - MyTaskTips[0].passtime) / (5.0f * 5.0f) + 1;
			Canvas.bForceAlpha = true;
			Canvas.KFXSetPivot(DP_LowerMiddle);
			if(csvTask == none || !csvTask.SetCurrentRow(MyTaskTips[0].taskid))
			{
				log("#### WARNING #### can't find task, id="$MyTaskTips[0].taskid);
				return;
			}
			Canvas.SetDrawColor(255, 255, 255, 255);
			if(MyTaskTips[0].tasktype == 0)
        	{
				//ÈÎÎñ
    			Canvas.SetPos(SMT_TipXPos, SMT_TipYPos);
    			Canvas.KFXDrawXMLTile("mat2_taskbackdroppage01", "NewImage8", true, 520, 70);
				Canvas.KFXFontAlias = "heavymedium15";
				Canvas.KFXDrawStrJustified(csvTask.GetString("Name")$SMT_TaskComplete,
							1,
							SMT_TipXPos, SMT_TipYPos,
							SMT_TipXPos+517, SMT_TipYPos+28);
				Canvas.KFXDrawStrJustified(csvTask.GetString("Des"),
							1,
							SMT_TipXPos, SMT_TipYPos+28,
							SMT_TipXPos+517, SMT_TipYPos+70);
			}
			else
			{
				//³É¾Í
				Canvas.SetPos(SMT_TipXPos, SMT_TipYPos);
				Canvas.KFXDrawXMLTile("mat2_taskbackdroppage01", "NewImage8", true, 520, 70);
				Canvas.KFXFontAlias = "heavymedium15";
    			Canvas.KFXDrawStrJustified(csvTask.GetString("Name")$SMT_TaskComplete,
							1,
							SMT_TipXPos+102, SMT_TipYPos,
							SMT_TipXPos+416, SMT_TipYPos+28);
				Canvas.KFXDrawStrJustified(csvTask.GetString("Des"),
							1,
							SMT_TipXPos+102, SMT_TipYPos+28,
							SMT_TipXPos+416, SMT_TipYPos+70);

				//»­Í¼±ê
				GotSetAndImage(csvTask.GetString("MedalReward"), sset, simage);
				if(sset != "" && simage != "")
				{
					Canvas.SetPos(SMT_TipXPos+5, SMT_TipYPos+5);
					Canvas.KFXLoadXMLMaterial(sset, simage, ou, ov, oul, ovl);
					Canvas.KFXDrawXMLTile(sset, simage, true, oul, ovl);
				}

				//»­½ðÒø±Ò
				Canvas.KFXFontAlias = "heavylarge16";
				Canvas.KFXDrawStrJustified(""$csvTask.GetInt("AchievementPointReward"),
							1,
							SMT_TipXPos+454, SMT_TipYPos+12,
							SMT_TipXPos+481, SMT_TipYPos+34);
				Canvas.KFXFontAlias = "heavytiny11";
				Canvas.KFXDrawStrJustified(csvTask.GetInt("SilverReward")$SMT_Sivler,
							1,
							SMT_TipXPos+448, SMT_TipYPos+47,
							SMT_TipXPos+507, SMT_TipYPos+56);

				Canvas.SetPos(SMT_TipXPos+484, SMT_TipYPos+22);
				Canvas.KFXDrawXMLTile("mat2_Achievementbackdroppage", "NewImage15", true, 18, 16);
			}
		}
		Canvas.bForceAlpha = false;
		Canvas.Reset();
	}
}
exec function PushTaskTip(int taskid, int taskstatus, int tasktype)
{
	//0ÊÇÈÎÎñ£¬1ÊÇ³É¾Í£¬0·ÅÔÚÇ°Ãæ
//	local int i;

	GUIController(PlayerOwner.Player.GUIController).ShowTaskTip(taskid, taskstatus, tasktype);
//	if(!KFXPlayer(PlayerOwner).pushTaskInfo(taskid))
//		return;
//	for(i=0; i<MyTaskTips.length; i++)
//	{
//		//Ð¡µÄ·ÅÇ°Ãæ
//		if(MyTaskTips[i].tasktype > taskstatus)
//		{
//			break;
//		}
//	}
//	MyTaskTips.Insert(i, 1);
//	MyTaskTips[i].taskid = taskid;
// 	MyTaskTips[i].taskstatus = taskstatus;
// 	MyTaskTips[i].tasktype = tasktype;
//	MyTaskTips[i].passtime = -1;
}
exec function SetRadarScale(int u, int v)
{
	radarUScale = u/100.0;
	radarVScale = v/100.0;
}
exec function SetRadarOffset(int u, int v)
{
	radarUOffset = u;
	radarVOffset = v;
}
exec function SetRadarOrigScale(float a)
{
	//MapRoleSpeedFactor = a;
	RadarMapScale = a;
}
function InitEncourageSound()
{
	local KFXCSVTable csvEncourageSound;
	local int i, j;
	csvEncourageSound = class'KFXTools'.static.KFXCreateCSV("KFXEncourageSound.csv");
	if(csvEncourageSound == none)
		return;
	for(i=0; i<7; i++)
	{
		if(csvEncourageSound.SetCurrentRow(i))
		{
			EncourageSoundMe[i].active = csvEncourageSound.GetBool("Active");
			EncourageSoundMe[i].Scope = csvEncourageSound.GetInt("Scope");
			for(j=0; j<3; j++)
			{
				EncourageSoundMe[i].strSound[j] = csvEncourageSound.GetString("Role"$j);
				EncourageSoundMe[i].vol[j] = csvEncourageSound.GetInt("vol"$j);
			}
		}
	}

	for(i=0; i<7; i++)
	{
		if(csvEncourageSound.SetCurrentRow(i+10))
		{
			EncourageSoundOther[i].active = csvEncourageSound.GetBool("Active");
			EncourageSoundOther[i].Scope = csvEncourageSound.GetInt("Scope");
			for(j=0; j<3; j++)
			{
				EncourageSoundOther[i].strSound[j] = csvEncourageSound.GetString("Role"$j);
				EncourageSoundOther[i].vol[j] = csvEncourageSound.GetInt("vol"$j);
			}
		}
	}
	bInitEncourage = true;
}
exec function ChangeRadarAlpha(int value)
{
	radarAlpha = value;
}
exec function ChangeShaderType(int value)
{
	fxSmallMap.MapShader.OutputBlending = EOutputBlending(value);
}
exec function SetTargetNamePos(int x, int y, int xl, int yl)
{
	TargetNameXPos = x;
	TargetNameYPos = y;
	TargetNameXL = xl;
	TargetNameYL = yl;
}
exec function SetBulletPicTime(float t)
{
	BulletPicTime = t;
	if(BulletPicTime < 0)
		BulletPicTime = 1;
}

exec function DoViewPerson(int pid)
{
	KFXPlayer(PlayerOwner).ServerViewPriorPlayer(pid);
}
function SetScoreBoardVisible(bool visible)
{
	bDrawKFXScoreBoard = visible;

if(_HUD_NEW_ == 2)
{
	if(PlayerOwner.IsInState('GameEnded') || PlayerOwner.IsInState('RoundEnded'))
	{
		if(visible)
			GUIController(PlayerOwner.Player.GUIController).OpenGamePage("GameEndTip");
		else
			GUIController(PlayerOwner.Player.GUIController).CloseGamePage("GameEndTip");
    	//bDrawKFXScoreBoard = false;
	}
	else
	{
		bDrawKFXScoreBoard = visible;
	}
}

}

function NotifyBombMsg(int idx)
{
	//0±íÊ¾Ã»ÓÐ±¬Õ¨³É¹¦
	//1±íÊ¾²ð³ýÕ¨µ¯Ê§°Ü
	switch(idx)
	{
		case 0:
			KFXSendClewMessage(SMT_NotExplode, true, , 3, 1);
			break;
		case 1:
			KFXSendClewMessage(SMT_RemoveBombFailed, true, , 3, 1);
			break;
	}


}
function GetDropItemID(int ID)
{

     local KFXCSVTable  CSVItemInfo;
     CSVItemInfo = class'KFXTools'.static.KFXCreateCSVTable("DropItemInfo.csv");
     if(CSVItemInfo == none)
     {
         log("KFXHUD Read DropItemInfo.csv is error");
         return;
     }
     if(!CSVItemInfo.SetCurrentRow(ID))
     {
         log("KFXHUD Read DropItemInfo.csv Row is error,ID is "$ID);
         return;
     }
     DroppedItemInfo.bFlying = true;
     DroppedItemInfo.ItemID = ID;
     DroppedItemInfo.DropItemBeginTime = Level.TimeSeconds;
     DroppedItemInfo.ItemName = CSVItemInfo.GetString("ItemName1");
     DroppedItemInfo.ItemPicPackage = CSVItemInfo.GetString("HUDPicPackage");
     DroppedItemInfo.ItemPicFile = CSVItemInfo.GetString("HUDPicFile");
     DroppedItemInfo.ItemSound = sound(DynamicLoadObject(CSVItemInfo.GetString("ItemSound1"),class'sound'));
     DroppedItemNum++;
     PlayGetItemSound(DroppedItemInfo.ItemSound );
     DrawGetItemText();
     log("KFXHUD------DroppedItemInfo.ItemID "$DroppedItemInfo.ItemID);
     log("KFXHUD------DroppedItemInfo.DropItemBeginTime "$DroppedItemInfo.DropItemBeginTime);
     log("KFXHUD------DroppedItemInfo.ItemName "$DroppedItemInfo.ItemName);
     log("KFXHUD------DroppedItemInfo.ItemPicPackage "$DroppedItemInfo.ItemPicPackage);
     log("KFXHUD------DroppedItemInfo.ItemPicFile "$DroppedItemInfo.ItemPicFile);
     log("KFXHUD------DroppedItemInfo.ItemSound "$DroppedItemInfo.ItemSound);

}
function PlayGetItemSound(sound ItemSound)
{
    PlayerOwner.Pawn.PlaySound(ItemSound,SLOT_None, 1.0, false, 100, 1.0, false);
    log("KFXHUD-------ItemSound: "$ItemSound);
}
function DrawGetItemText()
{
    local string Text;
    Text = class'KFXGameMessage'.static.GetStringEx(211, PlayerOwner.PlayerReplicationInfo);
    log("KFXHUD----111---Text "$Text);
    ReplaceText(Text,"%s",DroppedItemInfo.ItemName);
    log("KFXHUD----222---Text "$Text);
    KFXSendClewMessage(Text, true,, 3.5,1);
}
function DrawFlyingItem(Canvas Canvas)
{
    local float DeltaTime;
    local vector PicPos;
    local float OriginX,OriginY;
    local float FinalX,FinalY;
    local float FlyingGivenTime;
    local float FlashLargerTime;

    if(DroppedItemInfo.bFlying == false)
         return;
    OriginX = Canvas.SizeX/1024.0*50;
    OriginY = Canvas.SizeY/768.0*200;
    FinalX = Canvas.SizeX/1024.0*500;
    FinalY = Canvas.SizeY/1024.0*400;
    FlyingGivenTime = 0.4;
    FlashLargerTime = 1.5;
    DeltaTime = Level.TimeSeconds - DroppedItemInfo.DropItemBeginTime;
    log("KFXHUD------DeltaTime "$DeltaTime);
    log("KFXHUD------FlyingGivenTime "$FlyingGivenTime);
    log("KFXHUD------OriginX "$OriginX);
    log("KFXHUD------OriginY "$OriginY);
    log("KFXHUD------FinalX "$FinalX);
    log("KFXHUD------FinalY "$FinalY);


    if(DeltaTime < FlyingGivenTime)
    {
        PicPos.X = FinalX + (OriginX - FinalX) * DeltaTime / FlyingGivenTime;
        PicPos.Y = FinalY + (OriginY - FinalY) * DeltaTime / FlyingGivenTime;
        DropItemTile.PosX = PicPos.X;
        DropItemTile.PosY = PicPos.Y;
        DropItemTile.szImage = DroppedItemInfo.ItemPicFile;
        DropItemTile.szImageSet = DroppedItemInfo.ItemPicPackage;
        log("KFXHUD------DropItemTile.PosX  "$DropItemTile.PosX );
        log("KFXHUD------DropItemTile.PosY  "$DropItemTile.PosY );
        KFXDrawXMLTileInfo(Canvas,DropItemTile);
    }
    else if(DeltaTime < FlyingGivenTime + FlashLargerTime)
    {
        Canvas.bForceAlpha = true;
        Canvas.ForcedAlpha = (DeltaTime - FlyingGivenTime)/FlashLargerTime;
        DropItemTile.PosX = OriginX;
        DropItemTile.PosY = OriginY;
        KFXDrawXMLTileInfo(Canvas,DropItemTile);
        Canvas.bForceAlpha = false;
    }
    else
    {
        DroppedItemInfo.bFlying = false;
    }
}

//event tick(float deltaTime)
//{
//	//log("[LABOR]---------delta time!");
//}

exec function setradar(int b)
{
	KFXPlayer(PlayerOwner).bKFXKeyOfRadar = b>0;
}
exec function showdeathview(int b)
{
		if(b > 0)
			PlayerOwner.Player.GUIController.OpenGamePage("KFXHUDTeamMembersInfo");
		else
			PlayerOwner.Player.GUIController.CloseGamePage("KFXHUDTeamMembersInfo");
}
exec function UIHUD(int va)
{
	_HUD_NEW_ = va;
	if(_HUD_NEW_ == 2)
	{
	    PlayerOwner.Player.GUIController.OpenGamePage("KFXGameHUD" );
    	PlayerOwner.Player.GUIController.ResetHUDData();
    	PlayerOwner.Player.GUIController.SetHUDData_ModeReset(PlayerOwner);
	}
	else
	{
	    PlayerOwner.Player.GUIController.CloseGamePage("KFXGameHUD" );
	}
}
exec function showenc(int x, int y, int z)
{
if(_HUD_NEW_ == 2)
{
            PlayerOwner.Player.GUIController.SetHUDData_Encourage(x,
				y,
				z);
}
}
exec function UIShowWarMap(int visible)
{
if(_HUD_NEW_ == 2)
{
	if(visible>0)
	{
		PlayerOwner.Player.GUIController.OpenGamePage("KFXWarMap");
	}
	else
	{
		PlayerOwner.Player.GUIController.CloseGamePage("KFXWarMap");
		warmap_begin_time = -1;
	}
}
}
exec function UIShowScoreBoard(int visible)
{
	log("[LABOR]------------ui show scoreboard:"$visible@self@PlayerOwner);
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	if(visible>0)
	{
		if(PlayerOwner != none)
			if(!PlayerOwner.IsA('KFXPVEPlayer'))
				PlayerOwner.Player.GUIController.OpenGamePage("KFXScoreBoard");
			else
				PlayerOwner.Player.GUIController.OpenGamePage("KFXPVEScoreBoard");
	}
	else
	{
		if(!PlayerOwner.IsA('KFXPVEPlayer'))
			PlayerOwner.Player.GUIController.CloseGamePage("KFXScoreBoard");
		else
			PlayerOwner.Player.GUIController.CloseGamePage("KFXPVEScoreBoard");
	}
}
}

exec function UIPromptInfo(string msg)
{
if(_HUD_NEW_ == 2)
{
	PlayerOwner.Player.GUIController.SetHUDData_PromptInfo(msg);
}
}

exec function UISetBombState(int installed, int inre)
{
	PlayerOwner.Player.GUIController.SetHUDData_BombInstalled(installed>0, 100);
	PlayerOwner.Player.GUIController.SetHUDData_InBombRegion(inre>0);
}
exec function UIDrawTeamMembers(int va)
{
	bDrawTeamMembers = va>0;
}
exec function UISetCombatMsg()
{
	local array<string> weaps;
if(_HUD_NEW_ == 1 || _HUD_NEW_ == 2)
{
	weaps.Length = 3;
	weaps[0] = "set:mat2_HUD_weaponkill_fitting image:101051102";
	weaps[1] = "set:mat2_HUD_weaponkill_fitting image:131034101";
	weaps[2] = "set:mat2_HUD_weaponkill_fitting image:101113101";
	PlayerOwner.Player.GUIController.SetHUDData_CombatMsg(3, none,
								none, "set:mat2_HUD_weaponkill image:NewImage4", weaps, 3,
								3,
								1);
}
}
function DrawBotMessage(Canvas C,string message)
{


   // str =  class'KFXBotChatMesaage'.static.GetFirstChat();
 //    if(Level.TimeSeconds - ShowTimes > 5)
  //  {
    //    return;
    //  str =  class'KFXBotChatMesaage'.static.GetFirstChat();
   // }
    log("KFXHUD------message "$message);
    C.KFXSetPivot(DP_LowerLeft);
    C.KFXDrawStrJustifiedWithBorder(message,1,30,600,200,700,C.DrawColor,-1);
    C.KFXSetPivot(DP_UpperLeft);
}
// Ä¬ÈÏÊôÐÔ

defaultproperties
{
     _HUD_NEW_=2
     changedangerinfo=是
     dangertime=2.000000
     KFXBaseFontAlias="heavylarge16"
     KFXChatFontAlias="heavymedium14"
     KFXSpecFontAlias="heavymedium15"
     bDisplayMessages=是
     fxShowNameDist1=3000
     fxShowNameDist2=6000
     fxShowNameDist3=9000
     fxFontNames(0)="DigiNumFonts14.DigiNumFonts14"
     fxFontNames(1)="DigiNumFonts12.DigiNumFonts12"
     fxFontNames(2)="DigiNumFonts21.DigiNumFonts21"
     fxFontNames(3)="DigiNumFonts66.DigiNumFonts66"
     fxFontNames(4)="DigiNumFonts23.DigiNumFonts23"
     fxFontNames(5)="DigiNumFonts51.DigiNumFonts51"
     fxFontNames(6)="DigiNumFonts8.DigiNumFonts8"
     fxFontNames(7)="fx_SwissNumfonts_texs.SwissNumfontBasic"
     fxFontNames(8)="DigiNumFonts53.DigiNumFonts53"
     fxFontNames(9)="diginumfonts1130.diginumfonts1130"
     EncourageIconsBig(0)="set:mat2_HUD_cheer image:NewImage1"
     EncourageIconsBig(1)="set:mat2_HUD_cheer image:NewImage1"
     EncourageIconsBig(2)="set:mat2_HUD_cheer image:NewImage17"
     EncourageIconsBig(3)="set:mat2_HUD_cheer image:NewImage16"
     EncourageIconsBig(4)="set:mat2_HUD_cheer image:NewImage15"
     EncourageIconsBig(5)="set:mat2_HUD_cheer image:NewImage14"
     EncourageIconsBig(6)="set:mat2_HUD_cheer image:NewImage13"
     EncourageIconsBig(7)="set:mat2_HUD_cheer image:NewImage11"
     EncourageIconsBig(8)="set:mat2_HUD_cheer image:NewImage10"
     EncourageIconsBig(9)="set:mat2_HUD_cheer image:NewImage8"
     EncourageIconsBig(12)="set:mat2_HUD_shenghua image:NewImage23"
     EncourageIconsBig(13)="set:mat2_HUD_shenghua image:NewImage25"
     EncourageIconsBig(15)="set:mat2_HUD_cheer image:NewImage12"
     EncourageIconsBig(16)="set:mat2_HUD_cheer image:NewImage7"
     EncourageIconsBig(17)="set:mat2_HUD_cheer image:NewImage15"
     EncourageIconsBig(18)="set:mat2_HUD_cheer image:NewImage14"
     EncourageIconsBig(19)="set:mat2_HUD_cheer image:NewImage13"
     EncourageIconsBig(20)="set:mat2_HUD_cheer image:NewImage11"
     EncourageIconsSmall(0)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(1)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(2)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(3)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(4)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(5)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(6)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(7)="set:mat2_HUD_cheer image:NewImage22"
     EncourageIconsSmall(8)="set:mat2_HUD_cheer image:NewImage21"
     EncourageIconsSmall(9)="set:mat2_HUD_cheer image:NewImage23"
     EncourageIconsSmall(10)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(11)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(12)="set:mat2_HUD_shenghua image:NewImage22"
     EncourageIconsSmall(13)="set:mat2_HUD_shenghua image:NewImage24"
     EncourageIconsSmall(15)="set:mat2_HUD_cheer image:NewImage20"
     EncourageIconsSmall(16)="set:mat2_HUD_cheer image:NewImage21"
     EncourageIconsSmall(17)="set:mat2_HUD_shenghua01 image:NewImage2"
     EncourageIconsSmall(18)="set:mat2_HUD_shenghua01 image:NewImage4"
     EncourageIconsSmall(19)="set:mat2_HUD_shenghua01 image:NewImage1"
     EncourageIconsSmall(20)="set:mat2_HUD_shenghua01 image:NewImage3"
     bSexUpdate=是
     MapRoleSpeedFactor=1.000000
     bDrawKFXHUD=是
     bDrawTeamMembers=是
     warmap_begin_time=-1.000000
     warmap_cartoon_time=0.600000
     BotChatcolor=(B=242,G=242,R=249,A=255)
     PublicChatColor=(B=233,G=233,R=239,A=255)
     PersonnalChatColor=(B=255,G=255,A=255)
     GroupChatColor=(B=38,G=148,R=26,A=255)
     TeamChatColor=(B=223,G=160,R=87,A=255)
     TeamShoutColor=(B=224,G=160,R=39,A=255)
     SystemColor=(B=120,G=233,R=250,A=255)
     SmallBugleColor=(B=72,G=79,R=252,A=255)
     BigBugleColor=(G=186,R=255,A=255)
     NormalColor=(B=242,G=242,R=249,A=255)
     ShadeColor=(A=255)
     PlayerInOutColor=(B=48,G=230,R=15,A=255)
     ClewMsgColor(0)=(B=255,G=255,R=255,A=255)
     ClewMsgColor(1)=(B=6,G=227,R=227,A=255)
     ClewMsgColor(2)=(B=30,G=230,R=39,A=255)
     ClewMsgColor(3)=(B=255,G=255,R=255,A=255)
     colorVipBugle=(B=5,G=240,R=255,A=255)
     colorPrado(0)=(G=246,R=255,A=255)
     colorPrado(1)=(B=6,G=6,R=192,A=255)
     colorPradoShade(0)=(B=2,G=2,R=120,A=255)
     colorPradoShade(1)=(G=253,R=250,A=255)
     COLOR_ItemBroadcast=(B=72,G=79,R=252,A=255)
     sRealmName="none Realm"
     sChannelName="none channel"
     sRoomName="none room"
     fx_HUD_Dolby_piece1="fx_ui3_texs.HUD_Dolby_piece1"
     fx_HUD_Dolby_piece2="fx_ui3_texs.HUD_Dolby_piece2"
     fx_HUD_Dolby_bighorn="fx_ui3_texs.HUD_Dolby_bighorn"
     fx_HUD_Dolby_smallhorn="fx_ui3_texs.HUD_Dolby_smallhorn"
     fx_HUD_Dolby_background1="fx_ui3_texs.HUD_Dolby_background1"
     fx_HUD_Dolby_background2="fx_ui3_texs.HUD_Dolby_background2"
     fx_HUD_Dolby_bighorn_x="fx_ui3_texs.HUD_Dolby_bighorn_x"
     fx_HUD_Dolby_smallhorn_x="fx_ui3_texs.HUD_Dolby_smallhorn_x"
     //marquee=KFXMarqueeOnHUD'KFXGame.KFXHUD.marquee'
     pradoNeedTime=9.000000
     pradoPic2=1.000000
     pradoWait=1.000000
     NeedDrawEncourageMsgs=是
     RevengeIcon="set:mat2_HUD_cheer image:NewImage9"
     sMultiKillImage(1)="set:mat2_HUD_cheer image:NewImage6"
     sMultiKillImage(2)="set:mat2_HUD_cheer image:NewImage5"
     sMultiKillImage(3)="set:mat2_HUD_cheer image:NewImage4"
     sMultiKillImage(4)="set:mat2_HUD_cheer image:NewImage3"
     sMultiKillImage(5)="set:mat2_HUD_cheer image:NewImage2"
     ShowHitCollectTime=5.000000
     radarUScale=1.000000
     radarVScale=1.000000
     radarUOffset=512.000000
     radarVOffset=512.000000
     radarAlpha=200
     BulletPicTime=1.000000
     TargetNameXPos=262
     TargetNameYPos=425
     TargetNameXL=762
     TargetNameYL=475
     ProbeDistance=3000
     bDrawCombatMsg=是
     DeadStatusOnRadar=5.000000
     bNoManDeadInFive=是
     bDrawWeaponInfo=是
     bNeedRevenge=是
     FontScreenWidthMedium(0)=1600
     FontScreenWidthMedium(1)=1600
     FontScreenWidthMedium(2)=1600
     FontScreenWidthMedium(3)=1600
     FontScreenWidthMedium(4)=1280
     FontScreenWidthMedium(5)=1024
     FontScreenWidthMedium(6)=800
     FontScreenWidthMedium(7)=640
}
