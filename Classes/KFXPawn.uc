class KFXPawn extends KFXPawnBase
	  config(kfxplayer);

#exec OBJ LOAD FILE=mat2_player_anims.ukx
#exec OBJ LOAD FILE=fx_death_sounds.uax

//=============================================================================
// - Pawn³ÖÐø×´Ì¬Buffer

//TODO: ½ÇÉ«ËÀÍöºóÇå³ýËùÓÐµÄ×´Ì¬Buffer

// ³ÖÐø×´Ì¬
enum EPawnBitState
{
	// ÓÐÒæ×´Ì¬
	EPB_UseItem,    // 0 ÊÍ·ÅÒ»¸öÌØÐ§
	EPB_God,        // 1 ÎÞµÐ
	EPB_2,      // 2 ÌøÎè
	EPB_Speedup,    // 3 ¼ÓËÙ
	EPB_AutoAim,    // 4 ×Ô¶¯Ãé×¼
	EPB_Mini,       // 5 ±äÐ¡
	EPB_Talking,    // 6 ÕýÔÚËµ»°
	EPB_7,          //7
	EPB_FilterBadState,//8½â¾ö²»Á¼×´Ì¬
	EPB_Hide,          //9ÒþÉí
	EPB_Second,        //10 µÚ¶þÃû
	EPB_Third,         //11µÚÈýÃû
	EPB_12,
	EPB_13,
	EPB_14,
	EPB_15,
	// ÓÐº¦×´Ì¬
	EPB_MagicChange,// 16 ±äÉí
	EPB_Frozen,     // 17 ±ù¶³
	EPB_Chaos,      // 18 »ìÂÒ
	EPB_Speeddown,  // 19 ¼õËÙ£¨Óë3¼ÓËÙ¶ÔÓ¦£©
	EPB_LightingStrike,// 20 À×»÷
	EPB_Vertigo,       //21Ñ£ÔÎ
	EPB_CorpseChange,  //22½©Ê¬±äÉí
	EPB_EvilPigChange, //23Ð°¶ñÐ¡Öí±äÉí
	EPB_Terminator,    //24ÖÕ½áÕß
	EPB_FlameFire,     //25½ÇÉ«ÊÜµ½Åç»ðÆ÷ÉËº¦
	EPB_26,
	EPB_27,
	EPB_28,
	EPB_29,
	EPB_30,
	EPB_Max         // 31 ±£Áô
};

var int KFXPendingPawnBitState; // ´ý±ä×´Ì¬Âë(Replication)
var int KFXCurrentPawnBitState; // µ±Ç°×´Ì¬Âë
var int KFXFilterMasks[32];     // ¹ýÂËÑÚÂë(ÐèÒª¹ýÂËµôµÄ×´Ì¬Î»Îª1£¬·ñÔòÎª0),´ËÑÚÂëÓÃÀ´×èÖ¹ÏàµÖ´¥µÄ×´Ì¬¼ÓÈë
var int KFXFilterMask;

var bool NeedInitCrouch;
var bool bQuickChangeToss;

struct KFXPawnBitStateStruct
{
	var bool    bUseTimer;
	var float   Timer;
	var Actor   Effect;

	var float   Param1;
	var float   Param2;
	var float   Param3;
	var float   Param4;

	// Optim
	var float   Param5;
	var float   Param6;
};

var Shader SpecialSkin;
var KFXPawnBitStateStruct KFXPawnBitStateData[32];
var string KFXPawnBitStateEffect[32];

var string KFXCurPawnOrderEffect;
var string KFXPawnOrderEffect[3];
var actor KFXCurPawnOrderActor;

//var float KFXPawnBitStateTimers[32];    // ¼ÆÊ±Æ÷
//var int   KFXPawnBitStateParamA[32];    // ²ÎÊýA
//var int   KFXPawnBitStateParamB[32];    // ²ÎÊýB

//=============================================================================

// µÀ¾ß¿ÉÓ°ÏìµÄ×´Ì¬×Ö
var bool    KFXCanPickupWeapon; // ÊÇ·ñ¿ÉÊ°È¡ÎäÆ÷
var byte    KFXReloadAddon;     // ¸½¼ÓµÄµ¯¼ÐÊý         old version
//=============================================================================

//////////////////////////////////////
// ÊÜÉËÒÆ¶¯±äÂýÏà¹Ø
var float LastDamagedTime;
var int    HitDamageMomentum;

var float     KFXStopMoveTime;
var bool      KFXCalcMeleeDamage;//ÊÇ·ñ¼ÆËãÍÅ¶ÓÉËº¦

// Ë®Ãæ×ßÂ·Ë®»¨ÌØÐ§Àà
var class<Actor> StepOnWaterEffectClass;



var bool bCanAttachEffect;

var bool bVelocityShow;
var float ExplodeFlyTime;
var vector ExplodeFlyVel;

var float fKickAngleX;
var float fKickAngleY;
var float fMaxKickAngleX;
var float fMaxKickAngleY;

// --------------------------------

var globalconfig float fMinTimeBetweenTakeHit;
var globalconfig float fLastTakeHit;

// FIXME: will delete
var class<Actor> AttachEffectClass;
var Actor AttachEffect;
//var name FireAnim;  //Current fire anim(really neccessary???)
//Dead effect class
var class<Emitter> DeadEffectClass;
////////////////////////////////

//<ÉÁ¹âµ¯ Ð§¹ûÏà¹Ø²ÎÊý
var float KFXFlashPersist;      // ³ÖÐø²ÎÊý
var float KFXFlashIntensity;    // Ç¿¶È
var float KFXFlashDecayTime;    // ³ÖÐøÊ±¼ä½áÊøºóµÄË¥¼õÊ±¼ä
//>ÉÁ¹âµ¯ Ð§¹ûÏà¹Ø²ÎÊý

//<ÌáÊ¾ÏûÏ¢²ÎÊý
var localized string KFXHintStrings[8]; // ÌáÊ¾ÐÅÏ¢
//>ÌáÊ¾ÏûÏ¢²ÎÊý

// ÏÔÊ¾±»»÷ÖÐÐ§¹û
var bool bShowByHit;
var float fxShowByHitTime;
var Material fxHitMat;
var float HitX, HitY;
var float HitViewShakeFactor;
//-------------------------------------------

//-------------------------------------------
// ×¼ÐÇÌø¶¯
var rotator PunchAngle;     // PunchAngle
var rotator PunchAngleVel;  // PunchAngleSpeed
var int     PunchDirection;  // CurrentPunchDirection

//------------½ØÖÁµ½2009.10.12    ¸Ã¹¦ÄÜ½öÏÞÓÚÔÚÖÕ½áÕßÄ£Ê½ÏÂÊ¹ÓÃ----------------
var float     RoleDamageAdjustFactor;           //½ÇÉ«¹¥»÷µ÷ÕûÏµÊý
var float     RoleHealthAdjuseFactor;           //½ÇÉ«HP»ù´¡ÖµµÄµ÷ÕûÏµÊý
//------------------------------------------------------------------------------

var int       HasInitWeapon;  //ÎäÆ÷ÊÇ·ñ½øÐÐÁË³õÊ¼»¯ -1,Ã»ÓÐ ³õÊ¼»¯
								//0¸Õ½øÐÐ ³õÊ¼»¯½øÐÐÑéÖ¤
								//1Íê³É³õÊ¼»¯
var string     SaurianTransMat;
var string     CurSaurianTransMat;
///////////////////////////////////////////

//<<bufferÏà¹Ø
var int m_BufferType;
var int m_OldBufferType;
var float m_BufferTimeCounter;
var float m_BufferLastTime;

//>>

var bool KFXCurSmokeAffect;                      //µ±Ç°ÊÇ·ñÊÜµ½ÑÌÎíµ¯µÄÓ°Ïì
var bool KFXAllowHide;                           //ÊÇ·ñÔÊÐíÒþÉí
var int       KFXCurInvisLevel; //µ±Ç°ÒþÉí¼¶±ð
var int       KFXMaxInvisLevel; //ÒþÉí¼¶±ð£¬0£¬1£¬2 £º0ÎªÈ«Òþ£¬1ÎªÇáÒþ£¬2Îª°ëÒþ
var string    KFXInvisMatStr[3];   //ÓÄÁéµÚÈýÈË³ÆÒþÐÎÐ§¹û
var string    KFXFirstPersonInvisMatStr[3];//ÓÄÁéµÚÒ»ÈË³ÆÒþÐÎÐ§¹û
var bool IsBot;

var bool EnableFlying;

var bool bPlayRestartVoice;     //ÊÇ·ñ²¥·Å¸´Éú10ÃëÎ´ÉÏÌ¹¿ËµÄ×Ô¶¯ÓïÒô

var byte fxHangingLevel;       // ¹Ò»ú¼¶±ð

///ÅçÆá¹¦ÄÜ
struct PrintDoodleData
{
	var int Revasion;         //°æ±¾ºÅ
	var vector PrintLocation;//ÅçÆáµÄÎ»ÖÃ
	var vector PrintNormal;  //ÅçÆáÎ»ÖÃµÄ·¨Ïß·½Ïò
	var int    ItemID;       //ÅçÆáµÄµÀ¾ßid
};
var PrintDoodleData PendingPrintDoodleData,CurPrintDoodleData;
var int CurPrintTimes;  //µ±Ç°Ê¹ÓÃµÄÅçÆá´ÎÊý

///·À»¤¿¨µÀ¾ßÊôÐÔÊý¾Ý
struct ArmorDataBlock
{
	var int ValidPart;          //<¼¤»îµÄ²¿Î»£¬0Îª²»¼¤»î£¬È»ºó°´ÕÕhitboxµÄË³Ðò¶¨ÄÇ¸ö²¿Î»¼¤»î£¨Ê¹ÓÃÎ»£©
	var int Level;              //·À»¤¿¨µÄ¼¶±ð£¨´ÓÄ³ÖÖ½Ç¶ÈÉÏÀ´½²Ò²ÊÇÀà±ð£©
	var int ArmorValue;         //<·À»¤¿¨µÄÄÍ¾Ã
	var float ArmorReducePct;     //·À»¤¿¨ÄÍ¾ÃµÄ¼õÃâÏµÊý
};

var ArmorDataBlock HeadArmor;   //Í·¿ø¿¨
var ArmorDataBlock BodyArmor;    //ÉíÌå»¤¼×¿¨
const KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM = 1;  //<ÓÐ¶àÉÙÖÖ»¤¼×µÈ¼¶
const KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM = 2;//<ÓÐ¶àÉÙÖÖ»¤¼×¿¨£¬ÏÖÔÚ°üÀ¨Í·¿øºÍ»¤¼×£¨·À»¤ÉíÌå£©
const KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM = 2;

var float KFXArmorWeaponPct[KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM];
var float KFXDmgArmorPct[KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM];

var float fxC4PliersReduceFactor;        // C4¹¤¾ßÇ¯:²ð³ýC4¼õÉÙµÄÊ±¼ä
var float fxC4InstallReduceFactor;      // C4¹¤¾ßÇ¯:°²×°C4¼õÉÙµÄÊ±¼ä

var int fxChargeCartridgeClip;      // ³å·æÇ¹µ¯¼Ð¿¨
var int fxShockCartridgeClip;       // Í»»÷²½Ç¹µ¯¼Ð¿¨
var int fxSnipeCartridgeClip;       // ¾Ñ»÷Ç¹µ¯¼Ð¿¨
var int fxLightCartridgeClip;       // Çá»úÇ¹µ¯¼Ð¿¨
var int fxHeavyCartridgeClip;       // ÖØ»úÇ¹µ¯¼Ð¿¨
var int fxShotCartridgeClip;        // É¢µ¯Ç¹µ¯¼Ð¿¨
var int fxHowitzerCartridgeClip;    // Áñµ¯ÅÚµ¯¼Ð¿¨
var int fxPistolCartridgeClip;      // ÊÖÇ¹µ¯¼Ð¿¨
var int fxBazookaCartridgeClip;     // »ð¼ýÍ²µ¯¼Ð¿¨

var bool bKFXMinePrevent;           // ·ÀÀ×¿¨
var bool bKFXGasPrevent;            // Õ½¶ÓÈü¶¾Æø·À»¤¿¨

var bool bKFXHasLevelDadge;         // µÈ¼¶»ÕÕÂ
var bool bKFXInitLevelDadge;        // ÊÇ·ñ³õÊ¼»¯µÈ¼¶»ÕÕÂ

var class<Arming> KFXArmingName;
var Actor KFXArming;

var FactionBadge KFXFactionBadge;   // Õ½¶Ó»ÕÕÂ
var bool bKFXInitFactionBadge;      // ÊÇ·ñ³õÊ¼»¯Õ½¶Ó»ÕÕÂ

var float KFXShockArmorPierce;      // Í»»÷²½Ç¹´©¼×¿¨
var float KFXChargeArmorPierce;     // Î¢ÐÍ³å·æ²½Ç¹´©¼×¿¨

// ¿ìËÙÇÐÇ¹¿¨
struct FostSwitchWeapon
{
	var float SwitchDown;   // ÇÐ»»ËÙ¶È¸Ä±äÁ¿
	var float BringUpDown;  // ÇÐÇ¹ÀäÈ´¸Ä±äÁ¿
};

var FostSwitchWeapon KFXFostSwitchWeapon;
var string KFXSingleBadge;

var float KFXBombPrevent;   // ±¬Õ¨ÉËº¦·À»¤¿¨

// ×Ô¶¯»ØÑªÊôÐÔ
var float KFXHealthRecoverScale;

var int nBloodColor;                         //¼ÇÂ¼¸ü¸ÄÇ°µÄÑªµÄÑÕÉ«

struct KFXHealthRecover
{
	var int RecoverCount;
	var float Time;
};

var KFXHealthRecover KFXSuitHPRecover;

var bool bCanSmokeEffect;

// »»Ç¹½çÃæÊÇ·ñ¿ª»ð
var bool IsFired;
var bool IsWeaponThrown;
var bool bTransWeaponMenuOpened;
var bool bSelectWeaponClass;
var int TransWeaponID;

var KFXWeapBase LastWeap;

var vector JumpLocation;
var vector LandLocation;

var float  SeriesDistance;
var vector LastLocation;

//¼ÇÂ¼¸ÃÍæ¼ÒµÄ¹Ò¼þ£¬ÒÔÁ´±íÐÎÊ½×éÖ¯
var KFXDecoration   MyDecorations;
var bool        bHasInitDecoration;
var byte        IsRedRole;      //ÊÇ²»ÊÇºìÉ«½ÇÉ«£¬1ÊÇ£¬0²»ÊÇ£¬255ÎªÎ´ÉèÖÃ
//¼ÇÂ¼½ÇÉ«¹Ò¼þ²úÉúµÄ¶îÍâÊôÐÔ
var int TotalBackAmmoCount;         //ºó±¸µ¯¼ÐÊý
var int TotalGrenadeEx;             //À×°ü
var float TotalArmorExBody;         //»¤¼×
var float TotalArmorExHead;
var float TotalChangeSpeedEx;       //»»Ç¹ËÙ¶È
var float TotalWeaponBrightUpDown;  //ÇÐÇ¹ÀäÈ´ËÙ¶È
var float TotalMoveSpeedEx;         //ÒÆ¶¯ËÙ¶È
var float TotalC4Ex;                //c4¹¤¾ßÇ¯£¬¸ü¸Ä°´²ðÊ±¼ä
var float TotalAntiFlashEx;         //·ÀÉÁÑÛ¾µ
var float TotalStepSoundVolumeEx;   //½Å²½ÉùÒôÁ¿ÏµÊý
var float TotalStepSoundRadiusEx;   //½Å²½Éù·¶Î§ÏµÊý
var float TotalFallDownHurtEx;      //µôÂäÉËº¦
var float TotalHoldBreathEx;        //ÓÄÁé±ÕÆø
var int TotalBackAmmoForRifle;      //Í»»÷
var int TotalBackAmmoForSubMachine; //Î¢ÐÍ
var int TotalBackAmmoForSniper;     //¾Ñ»÷
var int TotalBackAmmoForShotgun;    //ö±µ¯
var int TotalBackAmmoForPistol;     //ÊÖÇ¹
var int TotalBackAmmoForMachinegun; //»úÇ¹


//<
var Pawn LastKillMe;
var int KFXPlayerId;
var bool bJustSwitchWeapon;     //ÊÇ·ñ¸Õ¸ÕÔÚ»»Ç¹

var bool isOwnerIsController;   //ÅÐ¶ÏÊÇ·ñÔø¾­µÄownerÊÇController ËÀÍöºóÊ¹ÓÃµÄ

var sound weaponattachment_sound;   //µÚÈýÈË³ÆÒôÐ§
var int time_calculate_decoration;

var KFXSkillManager skmgr;

var int PlayerID;    //¶ÔÓ¦ÓÚPlayerReplictionInfo PlayerID

struct HitBoxDmgFactor
{
	var int HitBoxID;
	var float Factor;
};

var array<HitBoxDmgFactor> HBFactor;

var globalconfig float BossChestDmgFactor;
var globalconfig float BossHeadDmgFactor;

var bool bWeaponSwitchAnim;       //ÎäÆ÷ÇÐ»»Ê±ÊÇÇÐ»»¶¯»­£¬·ñÔòÊÇ¶¯»­ÈÚºÏ

replication
{
	reliable if( Role==ROLE_Authority && bNetDirty )
		KFXPendingPawnBitState, KFXStopMoveTime,SaurianTransMat,m_BufferType, m_BufferLastTime,
		fxHangingLevel,PendingPrintDoodleData,CurPrintTimes, fxC4PliersReduceFactor, fxC4InstallReduceFactor,
		bKFXGasPrevent, bKFXHasLevelDadge, KFXFostSwitchWeapon, KFXSingleBadge,IsBot, TotalWeaponBrightUpDown,
		TotalC4Ex, TotalChangeSpeedEx, TotalBackAmmoCount, KFXPlayerId,skmgr;
	reliable if( Role==ROLE_Authority && bNetDirty && bNetOwner)
		fKickAngleX, fKickAngleY, fMaxKickAngleX, fMaxKickAngleY;
	unreliable if(Role==ROLE_Authority)
		KickBackMuzzle, KFXClientSpeedDown;
	// Debug Mode Only
	reliable if (Role < ROLE_Authority)
		KFXServerDebug, KFXSetPB, ServerDoAfterArmorAbsorbDmg,KFXSetCollisionSize;
	unreliable if(Role == ROLE_Authority)
		KFXNotifyCannotPickupWeapon, KFXNotifyPickupMagicItem;
	reliable if ( Role == ROLE_Authority )
		ClientDoAfterArmorAbsorbDmg,ExplodeFly;
	reliable if( Role==ROLE_Authority)
	    PlayerID;

}

simulated function PlayWeapSwitch()
{

}
simulated function ChildSetAttrID( int BaseID )
{
	local KFXCSVTable CFG_ATTR;

	CFG_ATTR = class'KFXTools'.static.GetConfigTable(41);
	super.ChildSetAttrID( BaseID );
	if ( !CFG_ATTR.SetCurrentRow(BaseID) )
		return;
	HitViewShakeFactor = CFG_ATTR.GetFloat("HitViewShakeFactor");

}

simulated function InitSkills()
{
	log("InitSkills");
	skmgr = Spawn(class'KFXSkillManager');
	skmgr.skmgrOwner = self;
	skmgr.AddSkill(1);

}

exec function PlaySkill(int index)
{
	log("ClientPlaySkill");
	skmgr.ClientPlaySkill(1,none);
}

// Server Only
function bool AddInventory( inventory NewItem )
{
	local bool RetVal;
	local int loop;
	local int OldFireGroup;

	RetVal = super.AddInventory(NewItem);

	if ( RetVal && KFXWeapBase(NewItem) != none )
	{
		KFXWeapBase(NewItem).KFXSetupAddonAmmo(self);
	}

	OldFireGroup = KFXWeapBase(NewItem).KFXGetFireGroup();

	for ( loop = 0; loop<2; loop++ )
	{
		KFXWeapBase(NewItem).KFXSetFireGroup(loop);
		KFXWeapBase(NewItem).KFXMaxAmmo[loop] = KFXWeapBase(NewItem).KFXGetAllAmmo();
	}

	KFXWeapBase(NewItem).KFXSetFireGroup(OldFireGroup);
	return RetVal;
}

simulated function Vector KFXGetWeaponLocation(int WeaponId)
{
	local KFXCSVTable table;
	local vector KFXWeaponLocation;

	Table = class'KFXTools'.static.KFXCreateCSVTable(KFXWeapLocTableName);

	if(Table != none)
	{
		table.SetCurrentRow(WeaponId);

		KFXWeaponLocation.X = table.GetFloat("LocationX");
		KFXWeaponLocation.Y = table.GetFloat("LocationY");
		KFXWeaponLocation.Z = table.GetFloat("LocationZ");
	}
	else
		Log("[Kevin] Fetal Error! Can't Load CSV Table:"$KFXWeapLocTableName);

	return KFXWeaponLocation;
}

simulated function Vector KFXGetLeftWeaponLocation(int WeaponId)
{
	local KFXCSVTable table;
	local vector KFXWeaponLocation;

	Table = class'KFXTools'.static.KFXCreateCSVTable(KFXWeapLocTableName);

	if(Table != none)
	{
		table.SetCurrentRow(WeaponId);

		KFXWeaponLocation.X = table.GetFloat("LeftLocationX");
		KFXWeaponLocation.Y = table.GetFloat("LeftLocationY");
		KFXWeaponLocation.Z = table.GetFloat("LeftLocationZ");
	}
	else
		Log("[Kevin] Fetal Error! Can't Load CSV Table:"$KFXWeapLocTableName);

	return KFXWeaponLocation;
}

simulated function Rotator KFXGetWeaponRotation(int WeaponID)
{
	local KFXCSVTable table;
	local Rotator KFXWeaponRotation;

	Table = class'KFXTools'.static.KFXCreateCSVTable(KFXWeapLocTableName);

	if(Table != none)
	{
		table.SetCurrentRow(WeaponId);

		KFXWeaponRotation.Roll = table.GetFloat("RotRoll");
		KFXWeaponRotation.Yaw = table.GetFloat("RotYaw");
		KFXWeaponRotation.Pitch = table.GetFloat("RotPitch");
	}
	else
		Log("[Kevin] Fetal Error! Can't Load CSV Table:"$KFXWeapLocTableName);

	return KFXWeaponRotation;
}

simulated function Rotator KFXGetLeftWeaponRotation(int WeaponID)
{
	local KFXCSVTable table;
	local Rotator KFXWeaponRotation;

	Table = class'KFXTools'.static.KFXCreateCSVTable(KFXWeapLocTableName);

	if(Table != none)
	{
		table.SetCurrentRow(WeaponId);

		KFXWeaponRotation.Roll = table.GetFloat("LeftRotRoll");
		KFXWeaponRotation.Yaw = table.GetFloat("LeftRotYaw");
		KFXWeaponRotation.Pitch = table.GetFloat("LeftRotPitch");
	}
	else
		Log("[Kevin] Fetal Error! Can't Load CSV Table:"$KFXWeapLocTableName);

	return KFXWeaponRotation;
}

//===client only
simulated function SetInitCrouch( Bool Need )
{
	NeedInitCrouch = Need;
}

simulated function bool GetInitCrouch()
{
	return NeedInitCrouch;
}
//-----------movecount---------
function KFXIncreaseMoveCount()
{
	self.CanMoveCount++;
	NetUpdateTime = Level.TimeSeconds - 1;
}
function KFXReduceMoveCount(optional bool bForceMove)
{
	if(bForceMove)
		self.CanMoveCount = 0;
	else
		self.CanMoveCount--;
	if(CanMoveCount<0)
		CanMoveCount = 0;
	NetUpdateTime = Level.TimeSeconds - 1;
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	local vector X,Y,Z, TraceStart, TraceEnd, Dir, Cross, HitLocation, HitNormal;
	local Actor HitActor;
	local rotator TurnRot;

	if (!bKFXCanDodge || CanMoveCount>0 || bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking && Physics != PHYS_Falling) )
		return false;

	TurnRot.Yaw = Rotation.Yaw;
	GetAxes(TurnRot,X,Y,Z);

	if ( Physics == PHYS_Falling )
	{
		if ( !bCanWallDodge )
			return false;
		if (DoubleClickMove == DCLICK_Forward)
			TraceEnd = -X;
		else if (DoubleClickMove == DCLICK_Back)
			TraceEnd = X;
		else if (DoubleClickMove == DCLICK_Left)
			TraceEnd = Y;
		else if (DoubleClickMove == DCLICK_Right)
			TraceEnd = -Y;
		TraceStart = Location - CollisionHeight*Vect(0,0,1) + TraceEnd*CollisionRadius;
		TraceEnd = TraceStart + TraceEnd*32.0;
		HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(1,1,1));
		if ( (HitActor == None) || (!HitActor.bWorldGeometry && (Mover(HitActor) == None)) )
			 return false;
	}

	if (DoubleClickMove == DCLICK_Forward)
	{
		Dir = X;
		Cross = Y;
		return false;
	}
	else if (DoubleClickMove == DCLICK_Back)
	{
		Dir = -1 * X;
		Cross = Y;
		return false;
	}
	else if (DoubleClickMove == DCLICK_Left)
	{
		Dir = -1 * Y;
		Cross = X;
	}
	else if (DoubleClickMove == DCLICK_Right)
	{
		Dir = Y;
		cross = X;
	}
	if ( AIController(Controller) != None )
		cross = vect(0,0,0);
	return PerformDodge(DoubleClickMove, Dir,Cross);
}

function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross)
{
	local float VelocityZ;
	local name Anim;

	if ( Physics == PHYS_Falling )
	{
		if (DoubleClickMove == DCLICK_Forward)
			Anim = DodgeAnims[0];
		else if (DoubleClickMove == DCLICK_Back)
			Anim = DodgeAnims[1];
		else if (DoubleClickMove == DCLICK_Left)
			Anim = DodgeAnims[2];
		else if (DoubleClickMove == DCLICK_Right)
			Anim = DodgeAnims[3];

		if ( PlayAnim(Anim, 1.0, 0.1) )
			bWaitForAnim = true;
			AnimAction = Anim;

		TakeFallingDamage();
		if (Velocity.Z < -DodgeSpeedZ*0.5)
			Velocity.Z += DodgeSpeedZ*0.5;
	}

	VelocityZ = Velocity.Z;
	Velocity = DodgeSpeedFactor*GroundSpeed*Dir + (Velocity dot Cross)*Cross;

	Velocity.Z = DodgeSpeedZ;

	CurrentDir = DoubleClickMove;

	SetPhysics(PHYS_Falling);
	return true;
}

function DoDoubleJump( bool bUpdating )
{
	PlayDoubleJump();

	if ( !bIsCrouched && !bWantsToCrouch )
	{
		if ( !IsLocallyControlled() || (AIController(Controller) != None) )
			MultiJumpRemaining -= 1;
		Velocity.Z = DoubleJumpZ;
		SetPhysics(PHYS_Falling);
	}
}

function bool CanDoubleJump()
{
	return ( (MultiJumpRemaining > 0) && (Physics == PHYS_Falling) );
}

function bool CanMultiJump()
{
	return ( MaxMultiJump > 0 );
}

function bool DoJump( bool bUpdating )
{
	local int nRoleID;
	;
	;
	JumpLocation = Location;
	// This extra jump allows a jumping or dodging pawn to jump again mid-air
	// (via thrusters). The pawn must be within +/- 100 velocity units of the
	// apex of the jump to do this special move.
	if ( !bUpdating && CanDoubleJump()&& (Abs(Velocity.Z) < DoubleJumpZThresh) && IsLocallyControlled() )
	{
		if ( PlayerController(Controller) != None )
			PlayerController(Controller).bDoubleJump = true;
		DoDoubleJump(bUpdating);
		MultiJumpRemaining -= 1;
		return true;
	}

	//< From Pawn
	if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
	{
		if ( Role == ROLE_Authority )
		{
			// ÖÓ:ÌøÔ¾Ê±»á´¥·¢botµÄhearnoise
			if ( (Level.Game != None) /*&& (Level.Game.GameDifficulty > 2)*/ )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
			if ( bCountJumps && (Inventory != None) )
				Inventory.OwnerEvent('Jumped');
		}
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )
			Velocity.Z = DefJumpZ;
		else
			Velocity.Z = JumpZ;
		if ( (Base != None) && !Base.bWorldGeometry )
			Velocity.Z += Base.Velocity.Z;
		SetPhysics(PHYS_Falling);

		nRoleID = KFXPendingState.nRoleID;
//---------------ÆðÌøÉùÒô---------------
		if ( bSpecialRoleState )
		{
			return true;
		}
		//Ç¿ÖÆÆðÌøÅÐ¶ÏÊÇ·ñÊÕÇ¹
		if(Role<ROLE_Authority || Level.NetMode == NM_Standalone)
		{
			KFXLevelAllowHideWeap = true;
			NotifyWeapJump();
		}

		//²»²¥·ÅÌøµÄÉùÒô
		//PlayJumpSound( nRoleID );
		return true;
	}
	return false;
	//>
}

simulated function PlayJumpSound( int RoleID )
{
	if ( RoleID % 2 == 0 )
		self.PlaySound(Sound(DynamicLoadObject("fx_death_sounds.female_leap1", class'Sound')),SLOT_None,
		KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),False,
		FootstepRadius+10*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
	else
		PlaySound(Sound(DynamicLoadObject("fx_death_sounds.male_leap1", class'Sound')),SLOT_None,
		KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),False,
		FootstepRadius+10*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));

}

simulated function PlayDoubleJump()
{
	local name Anim;

	Anim = TakeoffAnims[Get4WayDirection()];
	if ( PlayAnim(Anim, 1.0, 0.1) )
		bWaitForAnim = true;
	AnimAction = Anim;
}

function function Landed(vector HitNormal)
{
	super.Landed(HitNormal);
	LandLocation = Location;
}
// for Debug Only
exec function KFXDebug(string cmd, int param)
{
	KFXServerDebug(cmd, param);
}

function KFXServerDebug(string cmd, int param)
{
	local int IntTemp;
	local bool BoolTemp;
	local KFXDVServerAgent.DVAudioServerStatus   ss;
	local KFXDVServerAgent.DVPlayerStatus        ps;

	if( class'KFXFaeryAgent'.static.KFXIsKFXServerMode() )
		return;

	if ( cmd ~= "newweapons" )
	{
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65549);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65550);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65551);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65552);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65553);

		class'KFXPropSystem'.static.KFXCreateWeapon(self, 196617);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 262158);


		class'KFXPropSystem'.static.KFXCreateWeapon(self, 131078);

		class'KFXPropSystem'.static.KFXCreateWeapon(self, 262154);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 262155);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 262156);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 262157);

		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65537);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65543);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65541);
		class'KFXPropSystem'.static.KFXCreateWeapon(self, 65548);

		Controller.ClientSwitchToBestWeapon();
	}
	else if ( cmd ~= "weapon" )
	{
		class'KFXPropSystem'.static.KFXCreateWeapon(self, param);
	}
	else if ( cmd~= "spector" )
	{
		Controller.PlayerReplicationInfo.bAdmin = true;
		Controller.PlayerReplicationInfo.bOnlySpectator = true;
		Controller.PlayerReplicationInfo.bIsSpectator = true;
		Controller.PlayerReplicationInfo.bOutOfLives = true;
		Controller.GotoState('Spectating');

		Level.Game.NumSpectators++;
	}
	else if ( cmd ~= "admin" )
	{
		Controller.PlayerReplicationInfo.bAdmin = true;
	}
	//<< wangkai, Dolby Voice, 2008-10-09
	else if ( cmd ~= "DVChannelListenJoin" )
	{
		KFXGameInfo(Level.Game).DVServer.DVChannelListenJoin(KFXPlayer(Controller), param, PRI_0);
	}
	else if ( cmd ~= "DVChannelListenLeave" )
	{
		KFXGameInfo(Level.Game).DVServer.DVChannelListenLeave(KFXPlayer(Controller), param);
	}
	else if ( cmd ~= "DVChannelListenLeaveAll" )
	{
		KFXGameInfo(Level.Game).DVServer.DVChannelListenLeaveAll(KFXPlayer(Controller));
	}
	else if ( cmd ~= "DVChannelTalkJoin" )
	{
		KFXGameInfo(Level.Game).DVServer.DVChannelTalkJoin(KFXPlayer(Controller), param, 0, PRI_0);
	}
	else if ( cmd ~= "DVChannelTalkLeave" )
	{
		KFXGameInfo(Level.Game).DVServer.DVChannelTalkLeave(KFXPlayer(Controller), param);
	}
	else if ( cmd ~= "DVChannelTalkLeaveAll" )
	{
		KFXGameInfo(Level.Game).DVServer.DVChannelTalkLeaveAll(KFXPlayer(Controller));
	}
//    else if ( cmd ~= "DVDestory" )
//    {
//        KFXGameInfo(Level.Game).DVServer.DVDestroy();
//    }
	else if ( cmd ~= "DVInit" )
	{
		KFXGameInfo(Level.Game).DVServer.DVInit();
	}
	else if ( cmd ~= "DVCreateChannel" )
	{
		KFXGameInfo(Level.Game).DVServer.DVCreateChannel(CHN_SPATIAL);
	}
	else if ( cmd ~= "DVDestroyChannel" )
	{
		KFXGameInfo(Level.Game).DVServer.DVDestroyChannel(param);
	}
	else if ( cmd ~= "DVConnectPlayer" )
	{
		KFXGameInfo(Level.Game).DVServer.DVConnectPlayer(KFXPlayer(Controller));
		//KFXGameInfo(Level.Game).DVServer.DVTEMPConnectPlayer(KFXPlayer(Controller), "192.168.64.171");
	}
	else if ( cmd ~= "DVDisconnectPlayer" )
	{
		KFXGameInfo(Level.Game).DVServer.DVDisconnectPlayer(KFXPlayer(Controller));
	}
	else if ( cmd ~= "DVGetAudioServerStatus" )
	{
		KFXGameInfo(Level.Game).DVServer.DVGetAudioServerStatus(ss);
		log ("---- Audio Server Status ----");
		log ("audio_server_connected:    "$ ss.audio_server_connected);
		log ("audio_server_load:         "$ ss.audio_server_load);
		log ("audio_server_uptime:       "$ ss.audio_server_uptime);
		log ("bytes_in_sec:              "$ ss.bytes_in_sec);
		log ("bytes_out_sec:             "$ ss.bytes_out_sec);
		log ("clients_connected:         "$ ss.clients_connected);
		log ("clients_connected2:        "$ ss.clients_connected2);
		log ("control_server_connected:  "$ ss.control_server_connected);
		log ("control_server_load:       "$ ss.control_server_load);
		log ("control_server_uptime:     "$ ss.control_server_uptime);
		log ("kbytes_in:                 "$ ss.kbytes_in);
		log ("kbytes_out:                "$ ss.kbytes_out);
		log ("packets_in:                "$ ss.packets_in);
		log ("packets_in_sec:            "$ ss.packets_in_sec);
		log ("packets_out:               "$ ss.packets_out);
		log ("packets_out_sec:           "$ ss.packets_out_sec);
		log ("------------------------------");
	}
	else if ( cmd ~= "DVGetChannelAvatarNum" )
	{
		IntTemp = KFXGameInfo(Level.Game).DVServer.DVGetChannelAvatarNum(Param);
		log("[Dolby Voice] Avatar Number: "$ IntTemp);
	}
	else if ( cmd ~= "DVGetPlayerID" )
	{
		IntTemp = KFXGameInfo(Level.Game).DVServer.DVGetPlayerID(KFXPlayer(Controller));
		log("[Dolby Voice] Player ID: "$ IntTemp);
	}
	else if ( cmd ~= "DVGetPlayerStatus" )
	{
		KFXGameInfo(Level.Game).DVServer.DVGetPlayerStatus(KFXPlayer(Controller), ps);
		log ("---- Player Status ----");
		log ("Connnect:  "$ ps.bConnected);
		log ("Premium:   "$ ps.bPremium);
		log ("Talking:   "$ ps.TalkVolume);
		log ("LastContactSeconds: "$ ps.nLastContactSeconds);
		log ("MorphID:   "$ ps.nMorphID);
		log ("-----------------------");
	}
	else if ( cmd ~= "DVIsChannelNoisy" )
	{
		BoolTemp = KFXGameInfo(Level.Game).DVServer.DVIsChannelNoisy(Param);
		log("[Dolby Voice] Is Channel Noisy: "$ BoolTemp);
	}
	else if ( cmd ~= "DVMuteOneToOne" )
	{
		log ("[Dolby Voice] To Do");
	}
	else if ( cmd ~= "DVMuteOneToMany" )
	{
		log ("[Dolby Voice] To Do");
	}
	else if ( cmd ~= "DVMuteManyToOne" )
	{
		log ("[Dolby Voice] To Do");
	}
	else if ( cmd ~= "DVToggleChannelNoisy" )
	{
		BoolTemp = KFXGameInfo(Level.Game).DVServer.DVIsChannelNoisy(param);
		KFXGameInfo(Level.Game).DVServer.DVSetChannelNoisy(param, !BoolTemp);
	}
	else if ( cmd ~= "DVGetChannelHearingRange" )
	{
		IntTemp = KFXGameInfo(Level.Game).DVServer.DVGetChannelHearingRange(Param);
		log ("[Dolby Voice] Hearing Range: "$ IntTemp);
	}
	else if ( cmd ~= "SetPlayerChannelPos" )
	{
		log ("[Dolby Voice] To Do");
		//KFXGameInfo(Level.Game).DVServer.DVSetPlayerChannelPos(Param, );
	}
	//>> Dolby Voice
}

function CreateAttachEffect()
{
	local vector Pos;

	Pos = Location;
	Pos.Z += self.CollisionHeight + 30;
	AttachEffect = Spawn(AttachEffectClass, self,,Pos);
	AttachToBone(AttachEffect,'');
}
function DestroyAttachEffect()
{
	if(AttachEffect != none)
	{
		AttachEffect.Destroy();
		AttachEffect = none;
	}
}
//simulated function Destroy()
//{
//    if(self.Controller!=none)
//    {
//
//    }
//}

// 2007-03-22 start ---- added by duodonglai to support hit effect of view
// on server only
function KickBackMuzzle(float up_base,
						float lateral_base,
						float up_max,
						float lateral_max)
{
	fKickAngleY = up_base;
	fKickAngleX = lateral_base;
	fMaxKickAngleX = lateral_max;
	fMaxKickAngleY = up_max;

	self.NetUpdateTime = Level.TimeSeconds - 1;

	//LOG("[DDL] -------  KickBackMuzzle begin !");
	KFXWeapBase(Weapon).KFXGetFireMode(0).KickBack(up_base,
															 lateral_base,
															 0,
															 0,
															 up_max,
															 lateral_max,
															 0);
}

// 2010-12-3 start ---- added by duodonglai to support hit effect of view
// on Client only    Client Simulated Fire by sunqiang
simulated function ClientKickBackMuzzle(float up_base,
						float lateral_base,
						float up_max,
						float lateral_max)
{
	fKickAngleY = up_base;
	fKickAngleX = lateral_base;
	fMaxKickAngleX = lateral_max;
	fMaxKickAngleY = up_max;

	self.NetUpdateTime = Level.TimeSeconds - 1;

	//LOG("[DDL] -------  KickBackMuzzle begin !");
	KFXWeapBase(Weapon).KFXGetFireMode(0).KickBack(up_base,
															 lateral_base,
															 0,
															 0,
															 up_max,
															 lateral_max,
															 0);
}

// CS angle to UT angle
simulated function float AngleCS2UT(float CSAngle)
{
	return CSAngle * 65536.0 / 360.0;
}

// move from weapon fire.
function KickBack(
	float up_base,     float lateral_base,
	float up_max,      float lateral_max)
{
//    local float
//        up_base_ut,      lateral_base_ut,
//        up_max_ut,       lateral_max_ut;
//
//    local float
//        KickUp, KickLateral;
//
//    local rotator
//        ViewAngle, NewPunchAngle;
//
//    up_base_ut           = AngleCS2UT(up_base);
//    lateral_base_ut      = AngleCS2UT(lateral_base);
//    up_max_ut            = AngleCS2UT(up_max);
//    lateral_max_ut       = AngleCS2UT(lateral_max);
//
//    NewPunchAngle.Pitch = PunchAngle.Pitch + KickUp;
//    if ( Abs(NewPunchAngle.Pitch) > Abs(up_max_ut) )
//    {
//        if(NewPunchAngle.Pitch > 0)
//        {
//            NewPunchAngle.Pitch = Abs(up_max_ut);
//        }else
//        {
//            NewPunchAngle.Pitch = -Abs(up_max_ut);
//        }
//    }
//
//    NewPunchAngle.Yaw = PunchAngle.Yaw + KickLateral;
//    if ( NewPunchAngle.Yaw > lateral_max_ut )
//    {
//        if(NewPunchAngle.Yaw > 0)
//        {
//            NewPunchAngle.Yaw = Abs(lateral_max_ut);
//        }else
//        {
//            NewPunchAngle.Yaw = -Abs(lateral_max_ut);
//        }
//    }
//
//
//    ViewAngle = Controller.Rotation;
//
//    ViewAngle.Yaw = ViewAngle.Yaw + (NewPunchAngle.Yaw - PunchAngle.Yaw);
//    ViewAngle.Pitch = ViewAngle.Pitch + (NewPunchAngle.Pitch - PunchAngle.Pitch);
//
//    Controller.SetRotation(ViewAngle);
//
//    PunchAngle = NewPunchAngle;
}

// Decay Punch Angle
// Client Only

simulated function DecayPunchAngle(float DeltaTime)
{
//    local rotator NewPunchAngle, ViewAngle;
//    local float springForceMagnitude;
//
//    if ( VSize(vector(PunchAngle)) > 0 || VSize(vector(PunchAngleVel)) > 0)
//    {
//        // calc new punch angle
//        NewPunchAngle = PunchAngle + PunchAngleVel * DeltaTime;
//
//        // torsional spring
//        // UNDONE: Per-axis spring constant?
//        springForceMagnitude = PunchAngleDecaySpring * DeltaTime;
//        springForceMagnitude = FClamp(springForceMagnitude, 0.0, 2.0 );
//        PunchAngleVel = PunchAngleVel - PunchAngle * springForceMagnitude;
//
//        // apply punch angle change
//        ViewAngle = Instigator.Controller.Rotation;
//
//        ViewAngle.Yaw = ViewAngle.Yaw + (NewPunchAngle.Yaw - PunchAngle.Yaw);
//        ViewAngle.Pitch = ViewAngle.Pitch + (NewPunchAngle.Pitch - PunchAngle.Pitch);
//
//        Controller.SetRotation(ViewAngle);
//
//        // record punch angle
//        PunchAngle = NewPunchAngle;
//    }
}

/*
simulated function ShowDeadEffect()
{
	local MaterialSequence MaterialSequence;

	MaterialSequence = MaterialSequence(DynamicLoadObject(DeadSkingName, class'MaterialSequence'));
	MaterialSequence.SequenceItems[0].Time = AshesDisappearTime;
	MaterialSequence.SequenceItems[1].Time = AshesKeepingTime - AshesDisappearTime;
	SetOverlayMaterial(MaterialSequence, AshesKeepingTime, true);
}
*/
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
		//ÖØÖÃpawnÊý¾Ý
	ResetPawnStateData();

	super.Died(Killer, damageType, HitLocation);
}
//Server Died [Client simulated Fire]
function ServerDied(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if(skmgr!=none)
	{
		skmgr.OwnerDeadNotify();
	}
	//ÖØÖÃpawnÊý¾Ý
	ResetPawnStateData();

	 super.ServerDied(Killer,damageType,HitLocation);
}

// Server & Client
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	KFXClearAllBitStates( 1 << EPawnBitState.EPB_MagicChange );
	super.PlayDying(DamageType, HitLoc);
}

// Server & Client
simulated function ClientPlayDying(class<DamageType> DamageType, vector HitLoc)
{
	KFXClearAllBitStates( 1 << EPawnBitState.EPB_MagicChange );
	super.ClientPlayDying(DamageType, HitLoc);
}

//Add default inventory(TO BE CLEANED)
function AddDefaultInventory()
{
	local int ComponentID[6];
	//É¾³ýM1µÀ¾ß Íõð©  4915201  3407873  655361
    class'KFXPropSystem'.static.KFXCreateWeapon(self, 65537,0,0,ComponentID);
    class'KFXPropSystem'.static.KFXCreateWeapon(self, 65538,0,0,ComponentID);

    class'KFXPropSystem'.static.KFXCreateWeapon(self, 196616,0,0,ComponentID);
	class'KFXPropSystem'.static.KFXCreateWeapon(self, 2031618,0,0,ComponentID);
	class'KFXPropSystem'.static.KFXCreateWeapon(self, 2686982,0,0,ComponentID);
    class'KFXPropSystem'.static.KFXCreateWeapon(self, 3407873,0,0,ComponentID);
	class'KFXPropSystem'.static.KFXCreateWeapon(self, 3473409,0,0,ComponentID);
	class'KFXPropSystem'.static.KFXCreateWeapon(self, 2686980,0,0,ComponentID);
	class'KFXPropSystem'.static.KFXCreateWeapon(self, 2686978,0,0,ComponentID);



	// HACK FIXME
	if ( inventory != None )
		inventory.OwnerEvent('LoadOut');

	Controller.ClientSwitchToBestWeapon();
}

//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø
function AddBotInventory(int MainWeapon, int SubWeapon, int MeleeWeapon, int TossWeapon)
{
	if( MainWeapon != 0 )
		class'KFXPropSystem'.static.KFXCreateWeapon(self, MainWeapon);
	if( SubWeapon != 0 )
		class'KFXPropSystem'.static.KFXCreateWeapon(self, SubWeapon);
	if( MeleeWeapon != 0 )
		class'KFXPropSystem'.static.KFXCreateWeapon(self, MeleeWeapon);
	if( TossWeapon != 0 )
		class'KFXPropSystem'.static.KFXCreateWeapon(self, TossWeapon);
	// HACK FIXME
	//if ( inventory != none )
	//    inventory.OwnerEvent('LoadOut');
	if( Controller != none)
	{
		Controller.ClientSwitchToBestWeapon();
	}
}
//>>

//-----------------------------------------------------------------------------

function KFXClientSpeedDown( optional vector Hitnormal, optional int WeapID,optional float  SpeedDownFactor)
{
	LastDamagedTime = Level.TimeSeconds;

	Velocity.X *= (SpeedDownFactor * DamagedSpeedDownRate);
	Velocity.Y *= (SpeedDownFactor * DamagedSpeedDownRate);
	//log("KFXPawn---222--- DamagedSpeedDownRate: "$DamagedSpeedDownRate);
}

function KFXSpeedDown( optional vector Hitnormal, optional int WeapID )
{
	LastDamagedTime = Level.TimeSeconds;
	Velocity.X *= (SpeedDownFactor * DamagedSpeedDownRate);
	Velocity.Y *= (SpeedDownFactor * DamagedSpeedDownRate);

	KFXClientSpeedDown(Hitnormal,WeapID,SpeedDownFactor);
}

simulated event StopDriving(Vehicle V)
{
	super.StopDriving(V);

	if ( AvatarHead != none )
	{
		AvatarHead.SetRelativeLocation(vect(0,0,0));
	}

	if ( AvatarLegs != none )
	{
		AvatarLegs.SetRelativeLocation(vect(0,0,0));
	}
}
// ·þÎñÆ÷¶ËÃ»ÓÐµ÷ÓÃ£¡£¡£¡
simulated event ModifyVelocity(float DeltaTime, vector OldVelocity)
{
	// TODO: ²»ÄÜÓÃdefault.GroundSpeed !
	local float SpeedFactor;
	local float VelSize;

	if(Weapon != none && KFXWeapBase(Weapon) != none)
	{
		GroundSpeed = KFXWeapBase(Weapon).KFXGetSpeedFactor() * DefGroundSpeed * KFXSpeedScale;
	}
	else
	{
		GroundSpeed = DefGroundSpeed * KFXSpeedScale;
	}

	if((LastDamagedTime > 0.f) && (Level.TimeSeconds - LastDamagedTime < SpeedDownTime))
	{
		GroundSpeed *= SpeedDownFactor;
	}

    SpeedFactor = skmgr.GetSpeedFactor();
    if(SpeedFactor != 0.0)
    {
    	GroundSpeed *=(1.0 + SpeedFactor);
    	VelSize = VSize(Velocity);
    	if( VelSize > GroundSpeed)
    		Velocity = Velocity *GroundSpeed/VelSize;
}

}

function AddVelocity( vector NewVelocity)
{
	if ( bIgnoreForces || (NewVelocity == vect(0,0,0)) )
		return;
	if ( (Physics == PHYS_Falling) && (AIController(Controller) != None) )
		ImpactVelocity += NewVelocity;
	if ( (Physics == PHYS_Walking)
		|| (((Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) && (NewVelocity.Z > DefJumpZ)) )
		SetPhysics(PHYS_Falling);
	if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
		NewVelocity.Z *= 0.5;
	Velocity += NewVelocity;
}

simulated function ExplodeFly(vector VelInc,float time)
{
	local vector lLoc;
	Velocity = VelInc;
	lLoc = Location;
	lLoc.Z += 40;
	ExplodeFlyVel = VelInc;
	ExplodeFlyTime = time/1000.f;
	SetPhysics(PHYS_Falling);
	SetLocation(lLoc);
	log("ExplodeFly"@VelInc);
}

simulated event Touch( Actor Other )
{
	;
	if( Role == ROLE_Authority )
	{
		ProcessTouch( Other );
		skmgr.OwnerTouchNotify(Other);
	}

}
simulated function KFXPlayerReplicationInfo GetPRI()
{
	return KFXPlayerReplicationInfo(PlayerReplicationInfo);
}

//¶Ôpawnµ±Ç°×´Ì¬Êý¾Ý½øÐÐÖØÖÃ
function ResetPawnStateData()
{
	if( GetPRI() != none )
	{
		GetPRI().bKFXTestGod = false;
		GetPRI().fxTestGodBeginTime = 0;
		GetPRI().bKFXTestHide = false;
		GetPRI().fxTestHideBeginTime = 0;
		GetPRI().bKFXTestScale = false;
		GetPRI().fxTestScaleBeginTime = 0;
	}
}

//ºË¶ÔÎÞµÐÊý¾Ý
function TestPawnGodData()
{
	//¼ì²éÎÞµÐ
	if(KFXGameInfo(Level.Game).nGameState == KFXGameInfo(Level.Game).EGameState.EGameState_MatchOver)
		return;
	//log("KFXPawn-----KFXIsBitStateOn(EPB_God) "$KFXIsBitStateOn(EPB_God));
	//log("KFXPawn-----KFXCurrentPawnBitState "$KFXCurrentPawnBitState);
	if( KFXIsBitStateOn(EPB_God) )
	{
		//log("[kfxpawn Tick] god mode on!!!");
		//log("KFXPawn-----GetPRI() "$GetPRI());
		if(GetPRI() != none)
		{
//          log("KFXPawn-----GetPRI().bKFXTestGod"$GetPRI().bKFXTestGod);
			if( !GetPRI().bKFXTestGod )
			{
				GetPRI().bKFXTestGod = true;
				GetPRI().fxTestGodBeginTime = level.TimeSeconds;
			}
			else
			{
			//  log("KFXPawn-----level.TimeSeconds "$level.TimeSeconds);
				//log("KFXPawn-----GetPRI().fxTestGodBeginTime "$GetPRI().fxTestGodBeginTime);
				//log("KFXPawn-----GetPRI().fxTestGodLastTime "$GetPRI().fxTestGodLastTime);

				if( level.TimeSeconds - GetPRI().fxTestGodBeginTime > GetPRI().fxTestGodLastTime )
				{
					//self.Controller.Destroy();
					if( !GetPRI().bKFXGodError )
					{
						GetPRI().bKFXGodError = true;
						//log("[TestPawnGodData] god test!!!");
						//LogErrorStatePawnData("god hook");
					}
				}
			}
		}
	}
	else
	{
		GetPRI().bKFXTestGod = false;
	}
}
//ºË¶ÔÒþÉíÊý¾Ý
function TestPawnHideData()
{
	//¼ì²éÒþÉí
	if( KFXPawnCanHid() )
	{
		return;
	}
	if( KFXIsBitStateOn(EPB_Hide) )
	{
		log("[kfxpawn Tick] hide mode on!!!");
		if(GetPRI() != none)
		{
			if( !GetPRI().bKFXTestHide )
			{
				GetPRI().bKFXTestHide = true;
				GetPRI().fxTestHideBeginTime = level.TimeSeconds;
			}
			else
			{
				if( level.TimeSeconds - GetPRI().fxTestHideBeginTime > GetPRI().fxTestHideLastTime )
				{
					//self.Controller.Destroy();
					if( !GetPRI().bKFXHideError )
					{
						GetPRI().bKFXHideError = true;
						log("[TestPawnHideData] hide test!!!");
						LogErrorStatePawnData("hide hook");
					}
				}
			}
		}
	}
	else
	{
		GetPRI().bKFXTestHide = false;
	}
}

//ºË¶Ô±ä´ó±äÐ¡Êý¾Ý
function TestPawnScaleData()
{
	local KFXCSVTable CFG_LIST, CFG_ATTR;
	local int PawnStateID;
	//log("[kfxpawn Tick] DrawScale:"$self.DrawScale);
	//log("[kfxpawn Tick] DrawScale3D:"$self.DrawScale3D);

	CFG_LIST = class'KFXTools'.static.GetConfigTable(40);
	if ( CFG_LIST == none )
		return;
	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return;
	}
	PawnStateID         = CFG_LIST.GetInt("BaseID");

	CFG_ATTR = class'KFXTools'.static.GetConfigTable(41);

	if ( CFG_ATTR == none )
		return;

	if ( !CFG_ATTR.SetCurrentRow(PawnStateID) )
		return;

	if( CFG_ATTR.GetFloat("DrawScale") != self.DrawScale )
	{
		//self.Controller.Destroy();
		if(GetPRI() != none)
		{
			if( !GetPRI().bKFXScaleError )
			{
				GetPRI().bKFXScaleError = true;
				log("[TestPawnScaleData] scale test!!!");
				LogErrorStatePawnData("Scale hook");
			}
		}
	}
}

//´òÓ¡·Ç·¨²Ù×÷pawn Êý¾Ý
function LogErrorStatePawnData(string DoWhat)
{
	local KFXPlayer Contr;
	Contr = KFXPlayer(self.Controller);
	if( Contr != none )
	{
		log("[LogErrorStatePawnData] SessionID:"$ Contr.fxDBPlayerInfo.SessionID
		 $" LowSessionID: "$Contr.fxDBPlayerInfo.SessionID&0xffff
		 $" PlayerID: "$Contr.fxDBPlayerInfo.PlayerID
		 $" PlayerName: "$Contr.fxDBPlayerInfo.PlayerName
		 $" use "$DoWhat$
			" at "$level.TimeSeconds);
		Contr.Destroy();
	}
}

//¶Ôpawnµ±Ç°×´Ì¬Êý¾Ý½øÐÐºË¶Ô
function TestPawnStateData()
{
	//´òÓ¡µ±Ç°pawnµÄ×´Ì¬
	TestPawnGodData();
	TestPawnHideData();
	TestPawnScaleData();
}
function ProcessTouch( Actor Other )
{
	if( !KFXGameInfo(Level.Game).KFXMGAllowLostCollision )
	{
		if( Pawn(Other)!=none )
		{
			if( KFXWeapBase( self.Weapon )!=none )
			{
				KFXWeapBase( self.Weapon ).HackTouchPawn( Pawn(Other) );
			}
		}
	}
}

simulated event Bump( Actor Other )
{
	//LOG("[DDL] ----- Bumping="$Other);
}

// äÖÈ¾ÓÎÏ·Ïà¹ØÐ§¹û
simulated function KFXRenderGameEffects(Canvas c)
{
	KFXRenderFlashed(c);

	// »­±»»÷ÖÐÌØÐ§
	if( bShowByHit )
	{
		DrawByHit(c);
	}
}

//--------------------------------------------------------------
// »­±»»÷ÖÐÐ§¹û
function DrawByHit(Canvas Canvas)
{
	if( fxShowByHitTime > 0.0 )
	{
		Canvas.bForceAlpha = true;
		Canvas.ForcedAlpha = 1.0 - (Level.TimeSeconds - fxShowByHitTime)/3;

		Canvas.SetPos(HitX * Canvas.SizeX / 1024, HitY * Canvas.SizeY / 768);
		Canvas.DrawTile(fxHitMat,
			256* Canvas.SizeX / 1024,
			256* Canvas.SizeY / 768,
			0, 0, 256, 256 );

		Canvas.ForcedAlpha = 1.0;
		Canvas.bForceAlpha = false;
	}
}

function ShowByHit(int nDirection)
{
	local string s;

	bShowByHit = true;
	fxShowByHitTime = Level.TimeSeconds;

	switch(nDirection)
	{
		case 0:
			s = "fx_ui3_texs.hit_up";
			HitX = 392;
			HitY = 183;
			break;
		case 1:
			s = "fx_ui3_texs.hit_back";
			HitX = 392;
			HitY = 384;
			break;
		case 2:
			s = "fx_ui3_texs.hit_left";
			HitX = 311;
			HitY = 265;
			break;
		case 3:
			s = "fx_ui3_texs.hit_right";
			HitX = 512;
			HitY = 265;
			break;
	}

	fxHitMat = Material(DynamicLoadObject(s, class'Material'));

	SetTimer(3.0, false);
}

function Timer()
{
	super.Timer();

	bShowByHit = false;
	fxShowByHitTime = 0.0;
}


// Client Only
simulated event PlayHitPawnEffects(
	optional vector HitLocation,
	optional vector HitNormal)
{
	local int SoundRnd;
	local Actor SndVol;
//    local KFXCSVTable CFG_Attachment, CFG_Effect;
	local int loop,nTemp;
	local KFXWeapAttachment DmgWeap;
	local int WeapFireMode;
	local int RandEffectID;
	local Projector BloodProj;
	local vector NormalHit;

	local vector TraceStart;
	local vector TraceEnd;
	local actor HitActor;
	local vector tHitLocation;
	local vector tHitNormal;

	local float OldDrawScale;
	local class<Emitter> hiteffect;
	local bool useevil;
	local KFXPlayer LocalPC;

	if ( KFXSavedDmgRepInfo.InstigatedBy != none && KFXSavedDmgRepInfo.InstigatedBy.Weapon != none )
		DmgWeap = KFXWeapAttachment(KFXSavedDmgRepInfo.HitWeapon);

	if(Level.NetMode == NM_Standalone && DmgWeap == none)
	{
		DmgWeap = KFXWeapAttachment(KFXSavedDmgRepInfo.InstigatedBy.Weapon.ThirdPersonActor);
	}

	if ( DmgWeap == none )
	{
		return;
	}
//    CFG_Attachment = class'KFXTools'.static.GetConfigTable(17);
//    CFG_Effect     = class'KFXTools'.static.GetConfigTable(18);
//
//  if(!CFG_Attachment.SetCurrentRow(KFXDmgRepInfo.HitWeaponID))
//  {
//      return;
//  }

	//Ê¹ÓÃ·ÇºÍÐ³ÌØÐ§
	LocalPC = KFXPlayer(Level.GetLocalPlayerController());

	useevil = bool(LocalPC.life_style);
  log("[LABOR]--------------1 use evil?="$useevil@LocalPC.life_blood_shoot_effect_valid@LocalPC.life_blood_shoot_effect);
	if(useevil && LocalPC.life_blood_shoot_effect_valid)
	{
		hiteffect = class<Emitter>(DynamicLoadObject(LocalPC.life_blood_shoot_effect, class'Class'));
		DmgWeap.KFXEmitter_HitBody[0] =  hiteffect;
		DmgWeap.KFXEmitter_HitBody[1] = hiteffect;
		//hiteffect = class<Emitter>(DynamicLoadObject(LocalPC.life_blood_head_effect, class'Class'));
		DmgWeap.KFXEmitter_HitHead[0] = hiteffect;
		DmgWeap.KFXEmitter_HitHead[1] = hiteffect;
	}
	else
	{
		RandEffectID = Rand(2);
					}

	//WeapFireMode = DmgWeap.FiringMode;
	DmgWeap.mHitActor = self;
	DmgWeap.mHitLocation = HitLocation;
	DmgWeap.mHitNormal = HitNormal;

		SoundRnd = DmgWeap.FiringMode;
	log("[LABOR]---------spawn effect, location:"$HitLocation
				@"normal:"$HitNormal);
	if ( SetModeRoleHitedEffects(SndVol, WeapFireMode, SoundRnd,HitLocation,HitNormal) )
	{
		return;
	}
	else if ( KFXDmgInfo.HitBoxID == 2 )  // HeadShot
	{

		SndVol = Spawn(DmgWeap.KFXEmitter_HitHead[RandEffectID],,, HitLocation, Rotator(HitNormal));
		SndVol.PlaySound(DmgWeap.KFXSound_HitHead[SoundRnd], SLOT_None,
						TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
					HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false);
	}
	else
	{

		SndVol = Spawn(DmgWeap.KFXEmitter_HitHead[RandEffectID],,, HitLocation, Rotator(HitNormal));
		SndVol.PlaySound(DmgWeap.KFXSound_HitBody[SoundRnd], SLOT_None,
						TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
					HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false);
	}

	NormalHit = Normal(vect(1,1,0)*(HitLocation - Location));
	TraceStart = Location - CollisionRadius*(-NormalHit);
	TraceStart.Z = HitLocation.Z;
	TraceEnd = TraceStart - NormalHit*300.0;
	HitActor = Trace(tHitLocation, tHitNormal, TraceEnd, TraceStart, false);
	if ( HitActor != none && HitActor.bWorldGeometry )
	{
		OldDrawScale = class'BloodBulletDecal'.default.DrawScale;// = 0.8;
		if(DamageValue < 25)
		{
			class'BloodBulletDecal'.default.DrawScale = 0.6 * class'BloodBulletDecal'.default.DrawScale;
		}
		else if(DamageValue < 80)
		{

		}
		else
		{
			class'BloodBulletDecal'.default.DrawScale = 1.2 * class'BloodBulletDecal'.default.DrawScale;
		}
		if(useevil && LocalPC.life_blood_texture_valid)
		{
		   log(" LocalPC.life_blood_texture "@LocalPC.life_blood_texture);
			BloodProj = spawn(class<KFXBulletDecal>(DynamicLoadObject(LocalPC.life_blood_texture, class'class')),
							,,tHitLocation+3*tHitNormal, Rotator(-tHitNormal));

//          BloodProj = Spawn(class<KFXBulletDecal>(DynamicLoadObject("KFXEffectsEx.BloodBulletDecal_1", class'class')),
//                          ,,tHitLocation+3*tHitNormal, Rotator(-tHitNormal));
		}
		else
		{
			BloodProj = Spawn(class'BloodBulletDecal',,,tHitLocation+3*tHitNormal, Rotator(-tHitNormal));
		}
		class'BloodBulletDecal'.default.DrawScale = OldDrawScale;
		log("[BloodBulletDecal] spawn BloodBulletDecal");
	}


}
simulated function bool SetModeRoleHitedEffects( out actor SndVol, int FiringMode, int SoundRand , vector HitLoc, vector HitNormal )
{
//  if(bSpecialRoleState)
//    {
//        SndVol = Spawn(KFXEmitter_HitPig[FiringMode],,, HitLoc, Rotator(HitNormal));
//        SndVol.PlaySound(KFXSound_HitPig[SoundRand], SLOT_None,
//                        TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
//                        TransientSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false);
//        return true;
//    }

	return false;
}

function bool CanPassRadiusDamage()
{
	return false;
}


//--------------------------------------------------------------

// äÖÈ¾ÉÁ¹âµ¯Ð§¹û
simulated function KFXRenderFlashed(Canvas c)
{
	if ( KFXFlashIntensity == 0 )
		return;

	c.SetDrawColor(255, 255, 255, 255);
	c.SetPos(0, 0);
	c.bForceAlpha = true;
	c.ForcedAlpha = KFXFlashIntensity;
	c.DrawTileScaled(material'engine.DecoPaint', 100, 100);
	c.ForcedAlpha = 1.0;
}

// ÉÁ¹âµ¯Ð§¹ûË¥¼õ
simulated function KFXTickFlashed(float DeltaTime)
{
	if ( KFXFlashIntensity == 0 )
		return;

	// Decay Persist
	KFXFlashPersist -= DeltaTime;
	KFXFlashPersist = FMax(KFXFlashPersist, 0);

	// Decay Intensity
	if ( KFXFlashPersist == 0 )
	{
		KFXFlashIntensity -= DeltaTime/KFXFlashDecayTime;
		KFXFlashIntensity = FMax(KFXFlashIntensity, 0);
	}
}

// ÉèÖÃ±»ÉÁ¹âµ¯Ó°Ïì²ÎÊý
simulated function KFXSetFlashed(float Intensity, float Persist)
{
	if(TotalAntiFlashEx > 0)
	{
		KFXFlashIntensity = Intensity;// * TotalAntiFlashEx;
		KFXFlashPersist = Persist * TotalAntiFlashEx;
		KFXFlashDecayTime = KFXFlashPersist;
	}
	else
	{
		KFXFlashIntensity = Intensity;
		KFXFlashPersist = Persist;
		KFXFlashDecayTime = KFXFlashPersist;
	}
}

// Client Only
simulated function KFXSetHintMsg(string Message, float ShowTime, int Priority, bool bForceHint)
{
	if(PlayerController(Controller) == none)
	{
		return;
	}

	if (Message != "0" && Message != "Null" && Message != "none")
	{
		KFXHud(PlayerController(Controller).myHUD).KFXSendClewMessage(Message, bForceHint,, ShowTime, Priority);
	}
}

// Server rep to Client
simulated function KFXNotifyCannotPickupWeapon()
{
	KFXSetHintMsg(KFXHintStrings[1], 3, 2, true);
}

// Server rep to Client
simulated function KFXNotifyPickupMagicItem(int ItemID)
{
	local KFXCSVTable CFG_MagicItem;
	local string ItemName;
	local string PickupHint;

	if ( ItemID == 0 )
	{
		//°ïÖúÏûÏ¢£ºµÀ¾ßÈüÏà¹Ø£¬ÁÙÊ±
		KFXHud(KFXPlayer(Controller).myHUD).KFXSendClewMessage(KFXHintStrings[3], true,, 3, 2);
		return;
	}

	CFG_MagicItem  = class'KFXTools'.static.GetConfigTable(35);

	if ( CFG_MagicItem == none )
		return;

	if ( !CFG_MagicItem.SetCurrentRow(ItemID) )
		return;

	ItemName = CFG_MagicItem.GetString("Name");

	PickupHint = KFXHintStrings[2];
	ReplaceText(PickupHint, "%s", ItemName);

	//°ïÖúÏûÏ¢£ºµÀ¾ßÈüÏà¹Ø£¬ÁÙÊ±
	KFXSetHintMsg(PickupHint, 3, 2, true);
}

// Server rep to Client
simulated function KFXNotifySwitchMagicItem(int ItemID)
{
	local KFXCSVTable CFG_MagicItem;
	local string ItemName;

	if ( ItemID == 0 )
		return;

	CFG_MagicItem  = class'KFXTools'.static.GetConfigTable(35);

	if ( CFG_MagicItem == none )
		return;

	if ( !CFG_MagicItem.SetCurrentRow(ItemID) )
		return;

	ItemName = CFG_MagicItem.GetString("Name");
	//°ïÖúÏûÏ¢£ºµÀ¾ßÈüÏà¹Ø£¬ÁÙÊ±
	KFXSetHintMsg(ItemName, 3, 2, true);
}

// Create Weapon
// Server or Standalone
exec function KFXWeapBase KFXCreateWeapon(int WeaponID)
{
	return class'KFXPropSystem'.static.KFXCreateWeapon(self, WeaponID);
}

function ServerDoAfterArmorAbsorbDmg(KFXPawn pa, int armorpoint, int headarmor_value, int bodyarmor_value)
{
	local Controller ctrl;
	pa.KFXArmorPoints = armorpoint;
	pa.HeadArmor.ArmorValue = headarmor_value;
	pa.BodyArmor.ArmorValue = bodyarmor_value;
	for(ctrl=Level.ControllerList; ctrl != none; ctrl = ctrl.nextController)
	{
		if(Ctrl.Pawn != none)
			KFXPawn(Ctrl.Pawn).ClientDoAfterArmorAbsorbDmg(pa, armorpoint, headarmor_value, bodyarmor_value);
	}
	log("[LABOR]---------------server, absorb dmg:"$armorpoint@headarmor_value@bodyarmor_value
			@pa.PlayerReplicationInfo.PlayerName);
}
function ClientDoAfterArmorAbsorbDmg(KFXPawn pa, int armorpoint, int headarmor_value, int bodyarmor_value)
{
	pa.KFXArmorPoints = armorpoint;
	pa.HeadArmor.ArmorValue = headarmor_value;
	pa.BodyArmor.ArmorValue = bodyarmor_value;
	log("[LABOR]---------------client, absorb dmg:"$armorpoint@headarmor_value@bodyarmor_value
			@pa.PlayerReplicationInfo.PlayerName);
}
// KFX Armor Absorb Damage
// Server Only
simulated function float KFXArmorAbsorbDmg(float dmg, byte HitBoxID )
{
	local float     ActualDmg;
	local float     wpn_armor_factor;
	local float     ArmorReduceCount;
	local float     wpn_factor;

	log("[LABOR]----------`"$HeadArmor.ValidPart@BodyArmor.ValidPart
			@HitBoxID@HeadArmor.ValidPart@HeadArmor.Level
			@"HeadArmor:"$HeadArmor.ArmorValue
			@"BodyArmor:"$BodyArmor.ValidPart
			@"Armor:"$KFXArmorPoints);
	if( HeadArmor.ValidPart == 0 && BodyArmor.ValidPart ==0 )
		return dmg;

	if( ( (1<<HitBoxID) & HeadArmor.ValidPart ) > 0 )//<Í·²¿¼õÉË
	{

		if( HeadArmor.ArmorValue >0 && KFXArmorPoints>0 )
		{
			wpn_armor_factor = KFXArmorWeaponPct[HeadArmor.Level-1];
			wpn_factor = KFXDmgArmorPct[HeadArmor.Level-1];
			ActualDmg = wpn_factor * dmg;
			ArmorReduceCount = dmg*(1-wpn_factor)*wpn_armor_factor*HeadArmor.ArmorReducePct;
			HeadArmor.ArmorValue -= ArmorReduceCount;
			KFXArmorPoints -= ArmorReduceCount;
			log("[KFXPawn] KFXArmorAbsorbDmg hit head wpn_factor:"$wpn_factor
						@"dmg:"$ActualDmg
						@"ArmorReducePct:"$HeadArmor.ArmorReducePct
						@"wpn_armor_factor"$wpn_armor_factor
						@"KFXArmorPoints:"$KFXArmorPoints);
		}
		else
		{
			ActualDmg = dmg;
		}
	}
	else if( ( (1<<HitBoxID) & BodyArmor.ValidPart ) > 0 )//ÉíÌå¼õÉË
	{
		if( BodyArmor.ArmorValue >0 && KFXArmorPoints>0 )
		{
			wpn_armor_factor = KFXArmorWeaponPct[KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+BodyArmor.Level-1];
			wpn_factor = KFXDmgArmorPct[KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+BodyArmor.Level-1];
			ActualDmg = wpn_factor * dmg;
			ArmorReduceCount = dmg*(1-wpn_factor)*wpn_armor_factor*BodyArmor.ArmorReducePct;
			BodyArmor.ArmorValue -= ArmorReduceCount;
			KFXArmorPoints -= ArmorReduceCount;
			log("[KFXPawn] KFXArmorAbsorbDmg hit body wpn_factor:"$wpn_factor
					@"dmg:"$ActualDmg
					@"ArmorReducePct:"$BodyArmor.ArmorReducePct
					@"wpn_armor_factor:"$wpn_armor_factor
					@"KFXArmorPoints:"$KFXArmorPoints);
		}
		else
		{
			ActualDmg = dmg;
		}
	}
	else
	{
		ActualDmg = dmg;
	}
	if ( KFXArmorPoints < 0 )
		KFXArmorPoints = 0;

//  KFXArmorPoints -= 1;
//  HeadArmor.ArmorValue -= 1;
//  BodyArmor.ArmorValue -= 1;

	KFXPawn(Level.GetLocalPlayerController().pawn).ServerDoAfterArmorAbsorbDmg(self, KFXArmorPoints, HeadArmor.ArmorValue, BodyArmor.ArmorValue);
	log("KFXArmorAbsorbDmg ActualDmg"$ActualDmg);
	return ActualDmg;
}

simulated function float KFXGetHitboxDmgFactor(int HitboxID)
{
	local int loop;

	for(loop = 0; loop < HBFactor.Length; loop++ )
	{
		if(HBFactor[loop].HitBoxID == HitboxID )
		{
			return HBFactor[loop].Factor;
		}
	}

	return 1.0;
}
// KFX Hitbox ÉËº¦Âß¼­
// Client Only
// ÖÓ£º ±¬Í·¿¨ÅÐ¶¨£¬ ¶Ô·½Êý¾ÝÐèÒª´«½øÀ´
simulated function float KFXClientHixBoxDmg(float Damage, int nHitBoxNum, pawn instigatedBy)
{
	local float pitch, yaw;
	local int RealDmg;

	RealDmg = Damage + 0.5;
	RealDmg *= KFXDiffPartDmg[nHitBoxNum];
	RealDmg *= KFXGetHitboxDmgFactor(nHitBoxNum);
	switch(HITBOX(nHitBoxNum))
	{
		case HITBOX_CHEST:
			// cumputer view rot
			pitch = RealDmg * HitViewShakeFactor * 0.025;
			ClientKickBackMuzzle(pitch,
											   0,
											   4,
											   1);
			break;
		case HITBOX_STOMACH:
		   // cumputer view rot
			pitch = RealDmg * HitViewShakeFactor * 0.025;
			ClientKickBackMuzzle(pitch,
											   0,
											   1,
											   1);
			break;
		case HITBOX_HEAD:
			pitch = RealDmg * HitViewShakeFactor * 0.15;
			yaw = RealDmg * HitViewShakeFactor * ((FRand() - 0.5) * 2);
			ClientKickBackMuzzle(pitch,
										   0,
										   6,
										   3);
			break;
		case HITBOX_LEFTUPPERARM:
		break;
		case HITBOX_LEFTFOREARM:
		break;
		case HITBOX_RIGHTUPPERARM:
		break;
		case HITBOX_RIGHTFOREARM:
			break;
		case HITBOX_LEFTTHIGH:
		break;
		case HITBOX_LEFTCALF:
		break;
		case HITBOX_RIGHTTHIGH:
		break;
		case HITBOX_RIGHTCALF:
		break;
		default:
			RealDmg = 1.0;
	}
	return RealDmg;
}

// KFX Hitbox ÉËº¦Âß¼­
// Server Only
// ÖÓ£º ±¬Í·¿¨ÅÐ¶¨£¬ ¶Ô·½Êý¾ÝÐèÒª´«½øÀ´
function float KFXHixBoxDmg(float Damage, int nHitBoxNum, pawn instigatedBy)
{
	local float pitch, yaw;
	local int RealDmg;

	RealDmg = Damage + 0.5;
	RealDmg *= KFXDiffPartDmg[nHitBoxNum];
	RealDmg *= KFXGetHitboxDmgFactor(nHitBoxNum);
	switch(HITBOX(nHitBoxNum))
	{
		case HITBOX_CHEST:
			// cumputer view rot
			pitch = RealDmg * HitViewShakeFactor * 0.025;
			KickBackMuzzle(pitch,
											   0,
											   4,
											   1);
			break;
		case HITBOX_STOMACH:
		   // cumputer view rot
			pitch = RealDmg * HitViewShakeFactor * 0.025;
			KickBackMuzzle(pitch,
											   0,
											   1,
											   1);
			break;
		case HITBOX_HEAD:
			pitch = RealDmg * HitViewShakeFactor * 0.15;
			yaw = RealDmg * HitViewShakeFactor * ((FRand() - 0.5) * 2);
			KickBackMuzzle(pitch,
										   0,
										   6,
										   3);
			break;
		case HITBOX_LEFTUPPERARM:
		break;
		case HITBOX_LEFTFOREARM:
		break;
		case HITBOX_RIGHTUPPERARM:
		break;
		case HITBOX_RIGHTFOREARM:
			break;
		case HITBOX_LEFTTHIGH:
		break;
		case HITBOX_LEFTCALF:
		break;
		case HITBOX_RIGHTTHIGH:
		break;
		case HITBOX_RIGHTCALF:
		break;
		default:
			RealDmg = 1.0;
	}
	return RealDmg;
}
function CheckClientHaveWeapon()
{
	local  Inventory Inv;
	local  int i;

	if(Level.TimeSeconds - self.PlayerReplicationInfo.StartTime > 20)
	{
		for(inv = Inventory; inv != none; inv = inv.Inventory)
		{
			if(KFXWeapBase(Inv) != none)
			{
				i++;
			}
		}
		if(i == 0)
		{
			log("Client No Weapon");
			i++;

		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////
simulated event Tick(float DeltaTime)
{
//    local name anim;
//    local float Frame,Rate;
//    GetAnimParams(0,anim,Frame,Rate);
//
//    LOG("weapon is "$Weapon$"and anim is "$anim);
	// Dirty Tick, Receive state Packs
	local float planSpeed;
	local vector planVelocity, dir;


	local name OldIdleAnim;
	local float OldIdleFrame, OldIdleRate;
	local Inventory inv;

	if( ExplodeFlyTime > 0 )
	{
		if(Physics == PHYS_Falling)
	{
			Velocity = ExplodeFlyVel;
			ExplodeFlyTime -= DeltaTime;
	}
		else
	{
			ExplodeFlyTime = -1.0;
	}
	}
/*  ÓÅ»¯½Å±¾´úÂë
	if(Role < Role_Authority)
	{
		if(Level.GetLocalPlayerController().Pawn == self)
		{
			 CheckClientHaveWeapon();
		}
	}
*/  if(time_calculate_decoration == 1 && PlayerReplicationInfo!=none)
	{
		//KFXAddAgentDecoration(self);
		time_calculate_decoration = 2;
	}
	if(time_calculate_decoration == 2)
	{
		CalculateDecorationAttribute(self);
		time_calculate_decoration = 3;
	}
	if(time_calculate_decoration == 3)
	{
		//ÓÉÓÚ¹Ò¼þÊôÐÔ±ä»¯£¬ÐèÒªÖØÐÂ¼ÓÔØÒ»Ð©Êý¾Ý
		time_calculate_decoration = 4;
		for(inv = self.Inventory; inv != none; inv = inv.Inventory)
		{
			if(KFXWeapBase(Inv) != none)
			{
				KFXWeapBase(Inv).KFXSetupAddonAmmo(self);
			}
		}
	}

	if ( Level.NetMode != NM_DedicatedServer )
	{
/*  ÓÅ»¯½Å±¾´úÂë
	if ( SeriesDistance < 0.01 )
	{
		LastLocation = Location;
		SeriesDistance = 0.02;
	}
	else
	{
		SeriesDistance += abs(VSize( Location - LastLocation ));
		LastLocation = Location;
	}
*/
		KFXPostReceiveTick();
	}
	_KFXTickAllBitStates(DeltaTime);
	if ( bTearOff || IsInState('Dying') )
		return;

	planVelocity = Velocity;
	planVelocity.Z = 0;
	planSpeed = VSize(planVelocity);

	//·þÎñÆ÷¼ì²éÊý¾Ý
	if(Role == ROLE_Authority)
	{
		//¼ì²épawnÊý¾Ý
		TestPawnStateData();
	}

    // ÖÓ:×ßÂ·Ê±»á´¥·¢botµÄhearnoise
    if(Role == ROLE_Authority)
    {
        if(KFXPlayer(controller) != none)
        {
            if(!( bIsCrouched || bIsWalking ))
            {
                if(Physics == PHYS_Walking && planSpeed > 10
                && ( Level.TimeSeconds - LastFootStepTime ) > 0.5)
                {
                    MakeNoise(0.1);
                }
            }
        }
    }
    if(Controller != none)
    {
        if(KFXPlayerReplicationInfo(Controller.PlayerReplicationInfo) != none)
        {
            if(Health != KFXPlayerReplicationInfo(Controller.PlayerReplicationInfo).PlayerHealth)
            {
                 KFXPlayerReplicationInfo(Controller.PlayerReplicationInfo).PlayerHealth = Health;
                 //log("KFXPawn----5--Health"$Health);
            }
        }
    }


    // Some Client Stuff

	if(level.NetMode != NM_DedicatedServer)
	{
		// ½Å²½Éù
/* ÓÅ»¯½Å±¾´úÂë
		if(bLeftStep)
			PlayFootStepLeft();
		else
			PlayFootStepRight();
		bLeftStep = !bLeftStep;
*/
		FootStepping(0);

		if(AvatarHead != none && AvatarLegs != none && bHidden!=AvatarHead.bHidden )
		{
			AvatarHead.bHidden = bHidden;
			AvatarLegs.bHidden = bHidden;
		}
		// switch Hitbox Group
		if ( CanMoveCount>0 )
		{
			if(bIsCrouched)
				SwitchHitBoxGroup(1);
			else
				SwitchHitBoxGroup(0);
		}
/*  ÓÅ»¯½Å±¾´úÂë
		if ( SaurianTransMat != CurSaurianTransMat )
		{
			 KFXSaurianTrans();
			 CurSaurianTransMat = SaurianTransMat;
		}

		KFXPlayRandomCry();
*/
		//ÓÉ¿Í»§¶Ë¿ØÖÆ¶à²ãÍ¸Ã÷ÎÆÀíµÄÂß¼­
		if( KFXAllowHide && KFXIsBitStateOn( EPB_Hide ) && DrivenVehicle == none && KFXPawnCanHid() )
		{
//            LOG("[KFXPawn]  Tick ProcessMultiLevelHide");
			ProcessMultiLevelHide();
		}
/*  ÓÅ»¯½Å±¾´úÂë
		if( PendingPrintDoodleData.Revasion != CurPrintDoodleData.Revasion )
		{
			CurPrintDoodleData.Revasion = PendingPrintDoodleData.Revasion;
			CurPrintDoodleData.PrintLocation = PendingPrintDoodleData.PrintLocation;
			CurPrintDoodleData.PrintNormal = PendingPrintDoodleData.PrintNormal;
			CurPrintDoodleData.ItemID = PendingPrintDoodleData.ItemID;

			class'ProjectorDesc'.default.HitLoction = CurPrintDoodleData.PrintLocation;
			class'ProjectorDesc'.default.HitNormal  = CurPrintDoodleData.PrintNormal;

			class'ProjectorDesc'.default.ProjectorTex = KFXGetDoodleTexName(CurPrintDoodleData.ItemID);
			LOG("[KFXPawn]  Print Doodle ProjectorTex:"$class'ProjectorDesc'.default.ProjectorTex);
//            if( CurPrintDoodleData.ItemID > 0 )
			Dir = Normal(Location + EyePosition() -  CurPrintDoodleData.PrintLocation);
			LOG("[KFXPawn]  Dir:"$Dir$"Rot:"$vector( self.Controller.Rotation ));
			Spawn(class'DoodleProjector',,,CurPrintDoodleData.PrintLocation + FMax( VSize( Location + EyePosition() -  CurPrintDoodleData.PrintLocation), 2 ) * Dir, Rotator(-Dir) );//Rotator(-vector(

		}



		// ´´½¨»ÕÕÂ
		if ( (bKFXHasLevelDadge || KFXSingleBadge != "")
			&& !bKFXInitLevelDadge && ( KFXPendingState.nSuitID != 0 || KFXIsAvatar ) )
		{
			KFXInitArming();
			bKFXInitLevelDadge = true;
		}
*/
		if(!bHasInitDecoration)
		{
			//³õÊ¼»¯¹Ò¼þ
			bHasInitDecoration = true;
			//KFXAddAgentDecoration(self);
		}
/*  ÓÅ»¯½Å±¾´úÂë
		if ( PlayerReplicationInfo != none
			&& KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXHasFactionBadge
			&& !bKFXInitFactionBadge
			&& ( KFXPendingState.nSuitID != 0 || KFXIsAvatar )
			&& KFXPlayerReplicationInfo(PlayerReplicationInfo).fxFactionIcon != 0
			&& KFXPlayerReplicationInfo(PlayerReplicationInfo).fxFactionBackGround != 0 )
		{
			KFXInitFactionBadge();
			bKFXInitFactionBadge = true;
		}
*/

	}

	// Some Owner Client Stuff
	if ( IsLocallyControlled() )
	{
		// Tick Flashed
		KFXTickFlashed(DeltaTime);
	}
        //ÓÎÏ·¸Õ¿ªÊ¼µÄÊ±ºò³õÊ¼»°ÏûÃðÐÅÏ¢        ChenJianye
        //<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
    if (Controller!=none&&KFXPlayer(self.Controller)!=none&&KFXPlayer(self.Controller).KFXFirstLogin)
    //if (Controller!=none&&KFXPlayer(self.Controller).KFXFirstLogin)
    //>>
    {
        KFXHUD(PlayerController(self.Controller).myHUD).UpdatePlayerKillInfo();
        KFXPlayer(self.Controller).KFXFirstLogin = false;
    }
    //Edit by lwg
    if(KFXPLayer(Controller) != none&&Level.GetLocalPlayerController() == KFXPLayer(Controller))
    {
        if(VSize(PawnLocation - PawnPosition.Location) > KFXPlayer(Controller).AllowMaxDistForG)
        {
             log("KFXPawn-------Really Larger ");
             PawnPosition.Location = PawnLocation;
        }
    }


/*  ÓÅ»¯½Å±¾´úÂë
	KFXSuitHealthRecover();

	TickBuffer(DeltaTime);
*/
}
function KFXRewearDecoration()
{
	local KFXDecoration de;
	local array<int> items;
	local int i;
	for(de=self.MyDecorations; de != none; de = de.NextDecoration)
	{
		items.Insert(items.length, 1);
		items[items.length-1] = de.did;
	}
	DestroyAllMyDecoration();
	for(i=0; i<items.length; i++)
	{
		class'KFXDecoration'.static.KFXCreateDecoration(items[i], self);
	}
}
//ÓÐÏàÍ¬²¿·ÖµÄÌæ»»µô£¬Ã»ÓÐµÄÖ±½ÓÌí¼Ó
exec function DoChangeDecoration(int id)
{
	KFXChangeDecoration(id);
}
simulated function KFXChangeDecoration(int id)
{
	local KFXDecoration de;
	local int highid;
	local int bFind;
	highid = id >> 16;
	for(de = self.MyDecorations; de != none; de = de.NextDecoration)
	{
		if(de.did >> 16 == highid)
		{
			class'KFXDecoration'.static.KFXReplaceSelf(de.did, id, self);
			bFind = 1;
			break;
		}
	}
	if(bFind == 0)
	{
		class'KFXDecoration'.static.KFXCreateDecoration(id, self);
	}
}
exec function DoDeleteDecoration(int id)
{
	KFXDeleteDecoration(id);
}
simulated function KFXDeleteDecoration(int id)
{
//    local int item[7];    //7¸ö¹Ò¼þ
//    local int i;
//    local int tp;
	local KFXCSVTable csvPawnAvatar;
	local int createid;
	//É¾µô
	class'KFXDecoration'.static.KFXDeleteSelf(id, self);

	//´øÉÏÄ¬ÈÏµÄ
	csvPawnAvatar = class'KFXTools'.static.KFXCreateCSVTable("pawnavatar.csv");
	if(csvPawnAvatar != none && csvPawnAvatar.SetCurrentRow(KFXPendingState.nSuitID&0xffff))
	{
		createid = csvPawnAvatar.GetInt("lian");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("shou");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("bei");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("yao");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("zuotui");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("youtui");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("jiao");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("juese");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}
		createid = csvPawnAvatar.GetInt("xiong");
		if((createid>>16) == (id>>16))
		{
			KFXChangeDecoration(createid);
			return;
		}

	}
}
//ÊÇ·ñÏÔÊ¾½ÇÉ«¹Ò¼þ£¬vipÄ£ÐÍ²»ÏÔÊ¾½ÇÉ«¹Ò¼þ
simulated function bool CanShowDecoration()
{
	return true;
}
//´´½¨pawnµÄ¹Ò¼þ£¬×îºÃ×öºÃ¼ì²é£¬²»ÒªÈÃÍ¬Ò»Î»ÖÃ³öÏÖÁ½¸ö¹Ò¼þ
simulated function  KFXAddAgentDecoration(Pawn pa)
{
	local int item[CONS_decoration_count];  //7¸ö¹Ò¼þ
	local int i;
	local int tp;
	local KFXCSVTable csvPawnAvatar;
//    local KFXDecoration de;

	if(pa == none)
		return;
    ;
//  if(time_calculate_decoration != 1)
//  {
		if(time_calculate_decoration == 0)
		{
			time_calculate_decoration = 1;
		}
//      return;
//  }
//  if(Level.NetMode != NM_Client)
//      return;

	for(i=0; i<CONS_decoration_count; i++)
	{
		tp = class'KFXDecoration'.static.GetDecorationType(KFXPawn(pa).KFXPendingState.nDecorations[i]);
		if(tp > 0)
			item[tp-1] = KFXPawn(pa).KFXPendingState.nDecorations[i];
//      else
//          log("#### WARNING #### can't identify this decoration "$KFXPawn(pa).KFXPendingState.nDecorations[i]);
	}
	csvPawnAvatar = class'KFXTools'.static.KFXCreateCSVTable("pawnavatar.csv");
//  if((KFXPendingState.nSuitID&0xffff) == 0)
//      KFXPendingState.nSuitID = 1101;
    ;
	;
    if(csvPawnAvatar != none && csvPawnAvatar.SetCurrentRow(KFXPendingState.nSuitID&0xffff))
	{
		if(item[0] == 0)
		{
			item[0] = csvPawnAvatar.GetInt("lian");
		}
		if(item[1] == 0)
			item[1] = csvPawnAvatar.GetInt("shou");
		if(item[2] == 0)
			item[2] = csvPawnAvatar.GetInt("bei");
		if(item[3] == 0)
			item[3] = csvPawnAvatar.GetInt("yao");
		if(item[4] == 0)
			item[4] = csvPawnAvatar.GetInt("zuotui");
		if(item[5] == 0)
			item[5] = csvPawnAvatar.GetInt("youtui");
		if(item[6] == 0)
			item[6] = csvPawnAvatar.GetInt("jiao");
		if(item[7] == 0)
			item[7] = csvPawnAvatar.GetInt("juese");    //½ÇÉ«¹Ò¼þ
		if(item[8] == 0)
			item[8] = csvPawnAvatar.GetInt("xiong");
	}
	//ÏÈÉ¾³ý¾ÉµÄ
	DestroyAllMyDecoration();
	for(i=0; i<CONS_decoration_count; i++)
	{
		if(item[i] > 0)
		{
			KFXChangeDecoration(item[i]);
			//class'KFXDecoration'.static.KFXCreateDecoration(item[i], pa);
		}
	}
	//¼ÆËãÊôÐÔÐèÒªpriºÍcontroller£¬ËùÒÔ²»ÄÜÔÚÕâÀïÐ´¡£
	//CalculateDecorationAttribute(pa);
}
function UpdatePawnSpeedScale()
{
	local int i;
	local float SpeedScale;
	local KFXPlayerReplicationInfo PRI;

	PRI =  KFXPlayerReplicationInfo(PlayerReplicationInfo);
	log("KFXpawn------KFXSpeedScale "$KFXSpeedScale$"  PRI:"$PRI);
	if(PRI != none)
	{
		 if(Level.Game != none)
		 {
			  SpeedScale = KFXGameInfo(Level.Game).UpdatePawnSpeed(PRI);
			  KFXSpeedScale *= (1 + SpeedScale);
			  log("KFXpawn------KFXSpeedScale "$KFXSpeedScale$"  SpeedScale:"$SpeedScale);
		 }
	}
}
//¼ÆËãpawn¹Ò¼þµÄÊôÐÔ
simulated function CalculateDecorationAttribute(Pawn pa)
{
	class'KFXDecoration'.static.GetTotalGrenadeEx(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalArmorEx(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalChangeSpeedEx(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalWeaponBrightUpDown(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalMoveSpeed(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalC4Ex(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalAntiFlashEx(KFXPawn(pa));

	class'KFXDecoration'.static.GetTotalHonorPointEx(KFXPawn(pa), KFXPlayerReplicationInfo(pa.PlayerReplicationInfo).nHonorPointEx);
	class'KFXDecoration'.static.GetTotalSilverEx(KFXPawn(pa), KFXPlayerReplicationInfo(pa.PlayerReplicationInfo).nSilverEx);
	class'KFXDecoration'.static.GetTotalStepSoundVolumeEx(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalStepSoundRadiusEx(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalFallDownHurtEx(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalHoldBreathEx(KFXPawn(pa));

	class'KFXDecoration'.static.GetTotalBackAmmoForRifle(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalBackAmmoForSubMachine(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalBackAmmoForSniper(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalBackAmmoForShotgun(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalBackAmmoForMachinegun(KFXPawn(pa));
	class'KFXDecoration'.static.GetTotalBackAmmoForPistol(KFXPawn(pa));


	log("[LABOR]-------------player="$Pa.Controller@pa.PlayerReplicationInfo);

//    KFXPawn(pa).TotalArmorExBody = 1.0;
//    KFXPawn(pa).TotalArmorExHead = 1.0;
//    KFXPawn(pa).KFXArmorPoints  = 30;



	KFXPawn(pa).KFXSpeedScale += KFXPawn(pa).TotalMoveSpeedEx;

	//¼ÆËãÍêÊôÐÔÖ®ºó£¬½«Ò»Ð©ÄÚÈÝÉúÐ§
//  if(KFXPawn(pa) != none)
//  {
		KFXPawn(pa).SetBodyArmor();
		KFXPawn(pa).SetHeadArmor();
//  }
	log("[LABOR]-----------pawn, exbody="$KFXPawn(pa).TotalArmorExBody
			@"exhead="$KFXPawn(pa).TotalArmorExHead);

	if(pa.Controller != none)
		class'KFXDecoration'.static.GetTotalBombLevel(KFXPawn(pa), KFXPlayer(pa.Controller).bomb_bag_level);

//  //²»ÉÏÀ×°ü¹¦ÄÜ£¬ËùÒÔÔÊÐíÈÃËùÓÐÈË¹ºÂòÀ×
//  if(pa.Controller != none)
//  {
//      KFXPlayer(pa.Controller).bomb_bag_level = 6;
//  }

}
simulated function SetBodyArmor()
{
	if ( TotalArmorExBody > 0 )
	{
		BodyArmor.ArmorValue =  KFXArmorPoints;
		BodyArmor.Level = 1;
		BodyArmor.ArmorReducePct = 2;
		BodyArmor.ValidPart = 0x7b;
		log("[LABOR]----------set body armor!"$playerReplicationInfo.PlayerName);
	}
}

simulated function SetHeadArmor()
{
	if ( TotalArmorExHead > 0 )
	{
		HeadArmor.ArmorValue =  KFXArmorPoints;
		HeadArmor.Level = 2;
		HeadArmor.ArmorReducePct = 2;
		HeadArmor.ValidPart = 0x4;
		log("[LABOR]----------set head armor!"$playerReplicationInfo.PlayerName);
	}
}
///<¸ù¾Ýitemid»ñµÃÅçÆáÍ¼Æ¬µÄ×Ö·û´®
simulated function string KFXGetDoodleTexName( int itemid )
{
	local KFXCSVTable CFG_Props;
	if ( itemid == 0 )
	{
		Log("[KFXPawn] Error! Item ID is zero !");
		return"";
	}

	CFG_Props = class'KFXTools'.static.GetConfigTable(32);
	if ( !CFG_Props.SetCurrentRow(itemid) )
	{
		Log("[Projectile] Can't Resolve The item ID (Item Table): "$itemid);
		return"";
	}
	return(CFG_Props.GetString("Param2"));

}
simulated function KFXSaurianTrans()
{

	 if( SaurianTransMat=="Resume" )
	 {
		 self.Skins.remove(0,Skins.Length);

		 Skins = KFXGetMeshMatList();
		 AvatarHead.Skins.remove(0,AvatarHead.Skins.Length);
		 AvatarHead.Skins = AvatarHead.KFXGetMeshMatList();
		 AvatarLegs.Skins.remove(0,AvatarLegs.Skins.Length);
		 AvatarLegs.Skins = AvatarLegs.KFXGetMeshMatList();
		 return;
	 }
	 Skins[0] = Material( DynamicLoadObject(SaurianTransMat,class'Material') );
	 Skins[1] = Material( DynamicLoadObject(SaurianTransMat,class'Material') );
	 AvatarHead.Skins[0] = Material( DynamicLoadObject(SaurianTransMat,class'Material') );
	 AvatarHead.Skins[1] = Material( DynamicLoadObject(SaurianTransMat,class'Material') );
	 AvatarLegs.Skins[0] = Material( DynamicLoadObject(SaurianTransMat,class'Material') );
	 AvatarLegs.Skins[1] = Material( DynamicLoadObject(SaurianTransMat,class'Material') );

}

// Client Only
// Ð¡¶¯ÎïËæ»ú½Ð
simulated function KFXPlayRandomCry()
{
	if ( !CheckPlayRandomCry() )
	return;

	// Ëæ»ú½Ð
	if ( Rand(180) <100)//&&
	{
		;
		LastPainSound = Level.TimeSeconds;
		PlaySound(CrySound[Rand(5)], SLOT_Pain,
		HitSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
		HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
	}
}

simulated function bool CheckPlayRandomCry()
{
	if ( !bSpecialRoleState)
	{
		return false;
	}
	if( Level.TimeSeconds < LastPainSound + 3 &&bSpecialRoleState)
	{
		return false;
	}

	return true;
}

simulated function ServerBumpMover(Mover Mover)
{
	//·ÀÖ¹ËÀÑ­»·±ÀÀ£
	if( Level.NetMode == NM_DedicatedServer )
	Mover.Bump(self);
}

state Dying
{
	simulated function BeginState()
	{
		local PlayerController P;

		AddDeadPawn();
		if( KFXIsBitStateOn( EPB_Hide ) )
		KFXRemoveBitState(EPB_Hide);
		KFXChangeSkinSpecial(false);
		if ( Level.NetMode != NM_DedicatedServer )
		{
			P = Level.GetLocalPlayerController();
			if ( KFXPlayerId == KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxRoleGUID )
			{
				isOwnerIsController = true;
			}
		}
		super.BeginState();


		;
	}

	simulated function AnimEnd( int Channel )
	{
		local Actor A;
		local KFXPawn P;
		local int killID;
		local PlayerController PC;
		log("AnimEnd"$self.KFXPlayerId);
		PC = Level.GetLocalPlayerController();
		if ( Channel == 2 )
		{
			if ( isOwnerIsController && PC.Pawn==none )
			{
				if ( LastKillMe == none )
				{
					LastKillMe = KFXPlayer(Level.GetLocalPlayerController()).FindLastKillMePawn();
				}

				SetTargetPawn(LastKillMe, self);
				ConsoleCommand("StopRecord");
				consolecommand("Play");
				if ( !PC.IsGameRecorderPlaying() )
					PC.NotifyManagerPlayEnd();
				isOwnerIsController = false;
			}
		}
		ReduceCylinder();
	}
}

// Client Only
// KFXClientPlayDirectionalHit
simulated function KFXClientPlayDirectionalHit(Vector HitLoc)
{
	local Vector X,Y,Z, Dir;
	local int Direction,HitPart;
	local name HitAnimation;
	local Vector DmgerLoc;
	local KFXPawn P;
	HitPart=KFXGetHitPartByHeight(HitLoc);
	if(HitPart<0)
	{
		log("Pawn KFXClientPlayDirectionalHit HitPart:"$HitPart);
		return;
	}
	GetAxes(Rotation, X,Y,Z);
	HitLoc.Z = Location.Z;

	// random
	if ( VSize(Location - HitLoc) < 1.0 )
	{
		Dir = VRand();
	}
	// hit location based
	else
	{
		//×Ô¼ºÊÜµ½ÉËº¦Ê±µÄ±íÏÖ
		if(Controller != none || KFXPlayerId == KFXPlayerReplicationInfo(Level.GetLocalPlayerController().PlayerReplicationInfo).fxRoleGUID)    //¿´×Ô¼ºÊÜÉËº¦
		{
			DmgerLoc = KFXDmgRepInfo.InstigatedBy.Location;

			if(VSize(DmgerLoc ) <= 1)        //Öµ»¹Ã»ÓÐ´«µ½
			{
				Dir = -Normal(Location - HitLoc);
			}
			else
			{
				Dir = -Normal(Location - DmgerLoc);
			}
		}
		else         //¿´±ðÈËÊÜÉËº¦
		{
			//Dir = -Normal(Location - HitLoc);
			DmgerLoc = KFXDmgRepInfo.InstigatedBy.Location;
			if(VSize(DmgerLoc ) <= 1)        //Öµ»¹Ã»ÓÐ´«µ½
			{
				Dir = -Normal(Location - HitLoc);
			}
			else
			{
				Dir = -Normal(Location - DmgerLoc);
			}

		}
	}


	if ( Dir dot X > 0.7 || Dir == vect(0,0,0))
	{
		Direction = 0;
	}
	else if ( Dir dot X < -0.7 )
	{
		Direction = 1;
	}
	else if ( Dir dot Y > 0 )
	{
		Direction = 3;
	}
	else
	{
		Direction = 2;
	}

	switch(HitPart)
	{
		case 0:
		HitAnimation=HitHeadAnimExt[Direction + 4 * Rand(3)];
		break;
		case 1:
		HitAnimation=HitBodyAnimExt[Direction + 4 * Rand(3)];
		break;
		case 2:
		HitAnimation=HitLegAnimExt[Direction + 4 * Rand(3)];
		break;
	}

	if ( bIsCrouched )
	{
		HitAnimation = CHitAnimExt[rand(3)];
	}

//    if ( HasAnim(HitAnimation) )// && KFXHitWeaponID != 524289
//    {
		AnimBlendParams(2, 1.0, 0.0, 0.0,Spine1Bone);
		PlayAnim(HitAnimation, 1.0, 0, 2);
		PlayAnim(HitAnimation, 1.0, 0, 1);
		PlayAnim(HitAnimation, 1.0, 0, 0);
//    }

	if(IsLocallyControlled())
	{
		if ( KFXPlayer(Controller) != none )
		{
			KFXPlayer(Controller).TakeHit(Direction);
		}
	}
}

// Client Only
simulated function KFXPlayDyingAnimation(class<DamageType> DamageType, int HitWeaponID, vector HitLoc)
{
	local int WeaponType;

	local Vector X,Y,Z, Dir;
	local int Direction,HitPart,i;
	local name HitAnimation;
	local Vector KillerLoc;
	local Vector DmgerLoc;
	local vector pos;
	local PlayerReplicationInfo PRI;
	HitPart=KFXGetHitPartByHeight(HitLoc);
	if(HitPart<0)
	{
		log("[KFXPawnBase] HitPart is error!!!!");
		return;
	}
	GetAxes(Rotation, X,Y,Z);
	HitLoc.Z = Location.Z;

	// random
	if ( VSize(Location - HitLoc) < 1.0 )
	{
		Dir = VRand();
	}
	// hit location based
	else
	{
		//ÊÇ±¾µØpawnËÀÍö
		if(KFXPlayerId == KFXPlayerReplicationInfo(Level.GetLocalPlayerController().PlayerReplicationInfo).fxRoleGUID )    //¿´×Ô¼ºËÀ
		{
			KillerLoc = KFXPlayer(Level.GetLocalPlayerController()).KillMePawn.Location;   //±£ÁôÉ±ËÀÎÒµÄÄÇ¸öÈËµÄÎ»ÖÃ
			if(VSize(KillerLoc ) <= 1)        //Öµ»¹Ã»ÓÐ´«µ½
			{
				Dir = -Normal(Location - HitLoc);
			}
			else
			{
				Dir = -Normal(Location - KillerLoc);
			}

		}
		else         //¿´±ðÈËËÀ
		{
			//Dir = -Normal(Location - HitLoc);
			DmgerLoc = KFXDmgRepInfo.InstigatedBy.Location;
			if(VSize(DmgerLoc ) <= 1)        //Öµ»¹Ã»ÓÐ´«µ½
			{
				Dir = -Normal(Location - HitLoc);
			}
			else
			{
				Dir = -Normal(Location - DmgerLoc);
			}
		}
	}

	if ( Dir dot X > 0.7 || Dir == vect(0,0,0))
	{
		Direction = 0;
	}
	else if ( Dir dot X < -0.7 )
	{
		Direction = 1;
	}
	else if ( Dir dot Y > 0 )
	{
		Direction = 3;
	}
	else
	{
		Direction = 2;
	}

	//ÊÇ±¾µØpawnËÀÍö
	if(KFXPlayerId == KFXPlayerReplicationInfo(Level.GetLocalPlayerController().PlayerReplicationInfo).fxRoleGUID )    //¿´×Ô¼ºËÀ
	{
		 KFXPlayer(Level.GetLocalPlayerController()).DyingDirection = Direction;
		 log("KFXpawn-------Direction "$Direction);

//         if(KFXPlayer(Level.GetLocalPlayerController()).bShakeViewAfterDead)
//         {
//             log("I Want ShakeView while Dead Animation");
//             return;
//         }

	}

	WeaponType = HitWeaponID >> 16;
	if ( bIsCrouched )
	{
		DefPrePivot.Z += 40;
		PrePivot = DefPrePivot;
//        pos = Location;
//
//        pos.Z += 24;
//        SetLocation(pos);
	}
	else
	{
		SetCollisionSize(default.CollisionRadius, default.CollisionHeight + 24);
		pos = Location;
		pos.Z += 24;
		SetLocation(pos);
	}

	KFXPlayDyingSound();

	AnimBlendParams( 2,1,0,1);
	log("KFXPlayDyingAnimation ------DamageType.default.bDelayedDamage "$DamageType.default.bDelayedDamage);
	if (DamageType.default.bDelayedDamage)
	{
		i = rand(3);
		PlayAnim(ExplodeDeathAnimExt[i],1.0,,2);
		PlayAnim(ExplodeDeathAnimExt[i],1.0,,1);
		PlayAnim(ExplodeDeathAnimExt[i],1.0,,0);
		log("[KFXPawnBase]  KFXPlayDyingAnimation  ExplodeAnim:"$ExplodeDeathAnimExt[i]);
		return;
	}
	log("KFXPlayDyingAnimation ------HitPart "$HitPart);
	log("KFXPlayDyingAnimation ------Direction "$Direction);
	log("KFXPlayDyingAnimation ------bIsCrouched "$bIsCrouched);
	switch(HitPart)
	{
		case 0:
		if ( bIsCrouched )
		{
			HitAnimation=HitCrouchHeadDeathAnimExt[Direction*3+rand(3)];
		}
		else
		{
			HitAnimation=HitHeadDeathAnimExt[Direction*3+rand(3)];
		}

		Spawn(class<Actor>(DynamicLoadObject("KFXEffects.fx_effect_headshot",Class'class')),self,,Location,Rotation);
		break;
		case 1:
		if ( bIsCrouched )
		{
			HitAnimation=HitCrouchBodyDeathAnimExt[Direction*3+rand(3)];
		}
		else
		{
			HitAnimation=HitBodyDeathAnimExt[Direction*3+rand(3)];
		}
		break;
		case 2:
		if ( bIsCrouched )
		{
			HitAnimation=HitCrouchBodyDeathAnimExt[Direction*3+rand(3)];
		}
		else
			HitAnimation = HitLegsDeathAnimExt[rand(3)];

		break;
	}
	;
	PlayAnim(HitAnimation, 1.0, 0, 2);
	PlayAnim(HitAnimation, 1.0, 0, 1);
	PlayAnim(HitAnimation, 1.0, 0, 0);

}

simulated function ClientTakeDamage(out float HealthVP,out float Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local float DmgFactor;
	local Controller Killer;

	if ( instigatedBy != None )
	{
		Killer = instigatedBy.GetKillerController();
	}
	log("KFXPawn-------KFXIsGodMode()"$KFXIsGodMode());

	if ( KFXIsGodMode() )
	{
		HealthVP = Health;
		Damage = 0;     //DamageÖµ»Ø´«·þÎñÆ÷
		log("KFXPawn------HealthVP "$HealthVP);

		return;
	}

	Damage *= KFXDamageFactor;
	log("KFXPawn TakeDamage dmg"$Damage);
	if ( instigatedBy != none&&KFXPawn(instigatedBy) != none )
	{
		KFXPawn(instigatedBy).MakeDamage();
	}

	KFXDmgRepInfo.InstigatedBy  = instigatedBy;
	KFXDmgRepInfo.HitLocation   = Hitlocation;
	KFXDmgRepInfo.Momentum      = momentum;
	KFXDmgRepInfo.DmgShakeView  = KFXDmgInfo.DmgShakeView;
	KFXDmgRepInfo.HitWeapon = WeaponAttachment(instigatedBy.Weapon.ThirdPersonActor);
	//KFXDmgRepInfo.HitWeaponID = KFXDmgInfo.WeaponID;
	KFXHitWeaponID = KFXDmgInfo.WeaponID;
	super.ClientTakeDamage(HealthVP,Damage, InstigatedBy, Hitlocation, Momentum, damageType);
	DmgFactor = SetDmgFactor();

	if ( Health > 0 )
	{
		NeedEnableMomentum( Killer, momentum, damageType );
	}

	;

	if( !EnableFlying )
		Momentum = vect(0,0,0);

	//ClientSpeedDown(Normal(Momentum),KFXHitWeaponID);
}

//Client Only
simulated function ClientSpeedDown( optional vector Hitnormal, optional int WeapID )
{
	LastDamagedTime = Level.TimeSeconds;

	Velocity.X *= SpeedDownFactor;
	Velocity.Y *= SpeedDownFactor;
}

function ServerTakeDamage( float Damage, float HealthVP,Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	KFXDmgRepInfo.InstigatedBy  = instigatedBy;
	KFXDmgRepInfo.HitLocation   = Hitlocation;
	KFXDmgRepInfo.Momentum      = momentum;
	KFXDmgRepInfo.DmgShakeView  = KFXDmgInfo.DmgShakeView;
	KFXDmgRepInfo.HitWeapon = WeaponAttachment(instigatedBy.Weapon.ThirdPersonActor);
	//KFXDmgRepInfo.HitWeaponID = KFXDmgInfo.WeaponID;
	KFXDmgRepInfo.DamageVal     = Damage;
	KFXHitWeaponID = KFXDmgInfo.WeaponID;

	_ServerTakeDamage(Damage, HealthVP,InstigatedBy, Hitlocation, Momentum, damageType);

	KFXSpeedDown(Momentum,KFXHitWeaponID);    //¿Í»§¶Ë½µËÙ
}
function TakeDamage( float Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	local Controller Killer;
	local float DmgFactor;

	if ( instigatedBy != None )
	{
		Killer = instigatedBy.GetKillerController();
	}

	if ( KFXIsGodMode() ) return;

	//Èç¹ûÊÇµôÏÂÀ´£¬ÄÇÃ´¹Ò¼þÆð×÷ÓÃ
	if(damageType == class'Fell')
	{
		Damage *= (1-TotalFallDownHurtEx);
		log("[LABOR]------------when fall down:"$Damage@(1-TotalFallDownHurtEx));
	}

	Damage *= KFXDamageFactor;

	log("KFXPawn TakeDamage dmg"$Damage);
	if ( instigatedBy != none&&KFXPawn(instigatedBy) != none )
	{
		KFXPawn(instigatedBy).MakeDamage();
	}

	super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType);

	DmgFactor = SetDmgFactor();

	if ( Health > 0 )
	{
		NeedEnableMomentum( Killer, momentum, damageType );
	}

	;

	if( !EnableFlying )
		Momentum = vect(0,0,0);

	KFXClientSpeedDown(Normal(Momentum),KFXHitWeaponID,SpeedDownFactor);
}


//Client ReduceTakeDamage   Client Only
// Í¬×éÖ®¼ä²»¿É»¥É±
simulated function float ClientReduceDamage
(
	float Damage,
	pawn injured,
	pawn instigatedBy,
	vector HitLocation,
	out vector Momentum,
	class<DamageType> DamageType
)
{
	local int InjuredTeam, InstigatorTeam;
	local controller InstigatorController;
	local KFXGameReplicationInfo GRI;

	GRI = KFXGameReplicationInfo(KFXPlayer(Controller).GameReplicationInfo);
	// ÕÒµ½¹¥»÷ÕßµÄController
	if ( InstigatedBy != None )
	{
		InstigatorController = InstigatedBy.Controller;
	}
	else
	{
		InstigatorController = injured.DelayedDamageInstigatorController;
	}

	// ÕÒ²»µ½·µ»ØÄ¬ÈÏµÄReduceDamage
	if ( InstigatorController == None )
	{
		if ( DamageType.default.bDelayedDamage )
		{
			InstigatorController = injured.DelayedDamageInstigatorController;
		}
		if ( InstigatorController == None )
		{
			return Super.ClientReduceDamage( Damage,injured,instigatedBy,HitLocation,Momentum,DamageType );
		}
	}

	// È¡Á½¸öÈËµÄ¶ÓÎé±àºÅ
	ClientGetDmgTwoSideTeamNum(Injured, InstigatorController,
							InjuredTeam, InstigatorTeam );
	if(KFXVehiclesBase(injured)==none)
	{
		if ( InstigatorController != injured.Controller ) //Injured.COntroller ¿Ï¶¨Îªnone
		{
			if ( InjuredTeam != 255 && InstigatorTeam != 255 && InjuredTeam == InstigatorTeam )
			{
				KFXFriendlyDamage(Damage, injured, instigatedBy);
				if( !KFXFriendlyDamage(Damage, injured, instigatedBy) )
				{
					Damage *= GRI.fxFriendlyFireScale;
				}
			}
		}
	}

	return Super.ClientReduceDamage( Damage, injured, instigatedBy, HitLocation, Momentum, DamageType );
}

simulated function ClientGetDmgTwoSideTeamNum(pawn injured, Controller InstigatorController,
							out int InjuredTeam, out int instigatedByTeam )
{
	InjuredTeam = Injured.GetTeamNum();
	instigatedByTeam = InstigatorController.GetTeamNum();
}

// ¶ÓÓÑÖ®¼äµÄÌØÊâÉËº¦
simulated function bool KFXFriendlyDamage(int Damage, pawn injured, pawn instigatedBy)
{
	// C4 Õ¨µ¯
	if( KFXPawn(injured).KFXDmgInfo.WeaponID == 1 )
	{
		return true;
	}

	return false;
}

//==== Param1 ¿ÉÒÔ´«3¸öfloatÐÍ»î×ÅÒ»¸övector²ÎÊý£¬¶ø Param2Ôò¿ÉÒÔ´«Ò»¸örotatorºÍ3¸öintÐÍ±äÁ¿
function KFXSpecialAffect( vector Param1,rotator Param2 ) ;

function float SetDmgFactor()
{
	return (-1);
}

// Server Only
// µÀ¾ß×´Ì¬Ó¦ÓÃ
function KFXTakePBDamage(Pawn InstigatedBy, class<DamageType> damageType,
	int BitState, float Timer,
	optional float Param1, optional float Param2)
{
	local PlayerReplicationInfo PlayerRP;

    ;
	// Send Message
	switch(EPawnBitState(BitState))
	{


	case EPB_MagicChange:
		// add by zjpwxh@kingsoft ÕÅÉñÏÉ 2007-9-15 ¸Â¸Â¸Â
		// Apply state
		// ÖÓ£º Õë¶Ô¼º·½µÄ±äÉíÀ×±£»¤ÔòÌøÈ¥Õâ¶ÎÂß¼­

		if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
		{
			PlayerRP = DelayedDamageInstigatorController.PlayerReplicationInfo;
		}
		else
		{
			PlayerRP = instigatedBy.PlayerReplicationInfo;
		}

		// ±äÉí±£»¤¶Ô×Ô¼ºÈÓµÄÀ×²»Æð×÷ÓÃ
//        if(PlayerRP == PlayerReplicationInfo &&
//             KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXAnimalResist)
//             return;
		// Õë¶Ô¶ÓÓÑÈÓµÄÀ×ÊÇÓÐ×÷ÓÃµÄ
		if(PlayerReplicationInfo.Team != none && PlayerReplicationInfo.Team.TeamIndex != 255 &&
			  PlayerRP.Team.TeamIndex == PlayerReplicationInfo.Team.TeamIndex &&
			  PlayerRP != PlayerReplicationInfo &&
			  KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXAnimalResist)
			return;

		if ( !KFXAddBitState(EPawnBitState(BitState), Timer - KFXAnimalRecoverTime, Param1, Param2) )
			return;


		if ( Param1 == 1001 )//pig
		{
			// add by zjpwxh@kingsoft ÕÅÉñÏÉ 2007-9-5 ±äÖíÏûÏ¢
			KFXGameInfo(Level.Game).KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_TransPig',
				self.KFXDmgInfo.WeaponID,
				PlayerRP,
				self.PlayerReplicationInfo,
				damageType,
				KFXPlayerReplicationInfo(PlayerRP).fxKills
				);
		}
		else if ( Param1 == 1003 )//Tortoise
		{
			KFXGameInfo(Level.Game).KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_TransTortoise',
				self.KFXDmgInfo.WeaponID,
				PlayerRP,
				self.PlayerReplicationInfo,
				damageType,
				KFXPlayerReplicationInfo(PlayerRP).fxKills
				);
		}
		else if ( Param1 == 1002 )//cat
		{
			KFXGameInfo(Level.Game).KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_TransCat',
				self.KFXDmgInfo.WeaponID,
				PlayerRP,
				self.PlayerReplicationInfo,
				damageType,
				KFXPlayerReplicationInfo(PlayerRP).fxKills
				);
		}
		// ±äÖíÍ³¼Æ
		KFXPlayerReplicationInfo(PlayerRP).fxTransPigNum++;
		break;
		case EPB_FlameFire:
		if ( KFXAddBitState(EPawnBitState(BitState), Timer, Param1, Param2) )
		    SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        else
        	return;

	}
}
//=============================================================================
// - Pawn³ÖÐø×´Ì¬
//client && server
simulated function _KFXProcessBitStates(optional EPawnBitState Bit)
{
	local int Loop, PendingBit, CurrentBit;

	// ÅÐ¶ÏÊÇ·ñÓÐ×´Ì¬±ä»¯
	if ( KFXPendingPawnBitState != KFXCurrentPawnBitState || Level.NetMode==NM_DedicatedServer)
	{
		if(Bit!=0)
		{
			_KFXBeginBitState( Bit );
			KFXCurrentPawnBitState = KFXPendingPawnBitState;
			return;
		}

		for ( loop = 0; loop < EPawnBitState.EPB_Max; loop++ )
		{
			PendingBit = (KFXPendingPawnBitState >> loop) & 0x1;
			CurrentBit = (KFXCurrentPawnBitState >> loop) & 0x1;

			if ( PendingBit != CurrentBit )
			{
				// Add Bit state
				if ( PendingBit == 1 )
					_KFXBeginBitState( EPawnBitState(loop) );
				// Remove Bit state
				else
					_KFXEndBitState( EPawnBitState(loop) );
				;
			}
		}

		KFXCurrentPawnBitState = KFXPendingPawnBitState;
	}

}
// Client & Server
simulated function _KFXTickAllBitStates(float DeltaTime)
{
	local int Loop , CurrentBit;

	DeltaTime = DeltaTime / 1.1;
	// ¸üÐÂ¼ÆÊ±Æ÷
	if ( Role == ROLE_Authority )
	{
		if(self.Controller==none||self.Controller.IsInState('RoundEnded')||self.Controller.IsInState('GameEnded'))
			return;
		for ( loop = 0; loop < EPawnBitState.EPB_Max; loop++ )
		{
			CurrentBit = (KFXCurrentPawnBitState >> loop) & 0x1;
			// ÓÐÐ§µÄ×´Ì¬
			if ( CurrentBit == 1 )
			{
				_KFXTickBitState( EPawnBitState(loop), DeltaTime );

				if ( KFXPawnBitStateData[loop].bUseTimer )
				{
					KFXPawnBitStateData[loop].Timer -= DeltaTime;

					if ( KFXPawnBitStateData[loop].Timer <= 2)
					{
					   NetUpdateTime=Level.TimeSeconds-1;
					}
					if ( KFXPawnBitStateData[loop].Timer <= 0 )
					{
						KFXPawnBitStateData[loop].Timer = 0;
						KFXRemoveBitState( EPawnBitState(loop) );
					}
				}
			}
		}
	}
	else
	{
		_KFXProcessBitStates();//Æô¶¯»òÕß¹Ø±Õ BitStates(¿Í»§¶Ë)
	}
}

// Client & Server
simulated function _KFXBeginBitState(EPawnBitState Bit)
{
	local vector RelLocation;
	local string EffectString;
	local class<Actor> EffectClass;
	local byte VoiceFont;

	;

	// ¿Í»§¶ËÐ§¹û
	if ( Level.NetMode != NM_DedicatedServer )
	{
		switch(Bit)
		{
			case EPB_Hide:
				log("[KFXPawn]  BeginState EPB_Hide");
				KFXInitInvisLevel();
				break;
			 case EPB_MagicChange:
				// ±äÉíÒþ²ØµÈ¼¶»ÕÕÂ
				KFXArmingHidden(true);
				if( KFXAllowHide && KFXPawnCanHid() && ( Controller!=none && (KFXBot(Controller) != none||KFXPlayer(Controller).bServerAllowHide) ) && DrivenVehicle == none )
				{
					;

					ProcessMultiLevelHide(true);
				}
				break;
			case EPB_God:
				KFXChangeSkinSpecial(true);
				break;

		}
		//<< dolby voice font
		if (Bit == EPB_MagicChange)
		{
			VoiceFont = class'KFXGame.KFXPlayer'.static.DVGetAnimVoiceFont(KFXPendingState.nRoleID);
			;
			if (VoiceFont != 0)
			{
				KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXCurVoiceFont = VoiceFont;
			}

			// ±¾µØ¿Í¶Ë£¬ÉèÖÃDVClientµÄVoiceFont
			if (Controller != none && KFXPlayer(Controller).DVClient != none)
			{
				KFXPlayer(Controller).DVClient.DVSetVoiceFont(
					KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXCurVoiceFont
					);
			}
		}
		//>>

		// Spawn Effect
		if ( KFXPawnBitStateEffect[Bit] != "" )
		{
			if ( KFXPawnBitStateData[Bit].Effect != none )
			{
				KFXPawnBitStateData[Bit].Effect.Destroy();
			}
//			if( !NeedChangeEffect(Bit) )
//				return;

			if ( KFXPawnCanHid() )
				return;

			RelLocation = Location;
			RelLocation.Z -= CollisionHeight;

			EffectString = KFXGetTeamColoredString(KFXPawnBitStateEffect[Bit], KFXCurrentState.TeamID);
			EffectClass = class<Actor>(DynamicLoadObject(EffectString, class'Class'));
			KFXPawnBitStateData[Bit].Effect = Spawn(EffectClass,,,RelLocation);
			KFXPawnBitStateData[Bit].Effect.SetBase( self, vect(0,0,1) );
		}
	 }

	// Ö÷¿ØÂß¼­
	if ( Role == ROLE_Authority )
	{
		switch(Bit)
		{
		case EPB_God:
			KFXFilterMasks[Bit] = 0x7fff0000;
			_KFXComputeFinalFilterMask();
			break;

		case EPB_MagicChange:
			KFXFilterMasks[Bit] = 0x00000021a;//ÎÞµÐ¼ÓËÙ×Ô¶¯Ãé×¼ÒþÉí
			_KFXComputeFinalFilterMask();
			KFXMagicChange(KFXPawnBitStateData[Bit].Param1);
			break;

		case EPB_Hide:

			KFXFilterMasks[9] = 0x0000200;
			_KFXComputeFinalFilterMask();

			break;
		}
	}
}
simulated function bool NeedChangeEffect( EPawnBitState Bit )
{
	return false;
//        switch(Bit)
//        {
////            case EPB_MagicChange:
////            break;
//        }
//    return true;
}
// Client & Server
simulated function _KFXEndBitState(EPawnBitState Bit)
{
	;

	// ¿Í»§¶ËÐ§¹û
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( KFXPawnBitStateData[Bit].Effect != none )
		{
			KFXPawnBitStateData[Bit].Effect.Destroy();
		}

		switch(Bit)
		{
			case EPB_Hide:
				log("[KFXPawn]  KFXEndBitState "$PlayerReplicationInfo$PlayerReplicationInfo.Team);
				if( KFXAllowHide && ( KFXPawnCanHid() || PlayerReplicationInfo == none || PlayerReplicationInfo.Team == none ) )
					KFXRemoveInvis(KFXPendingState.nRoleID);
				break;

			//ÖÕÖ¹¶¯Îï½ÐÉù
			case EPB_MagicChange:
			// ±äÉí»Ö¸´Ê±ÏÔÊ¾»ÕÕÂ
			KFXArmingHidden(false);
			KFXStopSound(self,none);

			//<< dolby voice font
			// »Ö¸´VoiceFont
			KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXCurVoiceFont
				= KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXVoiceFont;
			// ±¾µØ¿Í»§¶Ë£¬»¹Ô­DVClientµÄVoiceFont
			if (Controller != none && KFXPlayer(Controller).DVClient != none)
			{
				// reset voice font
				KFXPlayer(Controller).DVClient.DVSetVoiceFont(
					KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXCurVoiceFont);
			}
			if( KFXAllowHide && KFXPawnCanHid() && (KFXBot(Controller) != none||KFXPlayer(Controller).bServerAllowHide) && DrivenVehicle == none )
			{
				;
				ProcessMultiLevelHide(true);
			}
			//>>

			break;
			case EPB_God:
				KFXChangeSkinSpecial(false);
				log("KFXPawn----- EPB_God");
				ClientEndStateToDo(EPB_God);
			break;
		}
	}
	// Ö÷¿ØÂß¼­
	if ( Role == ROLE_Authority )
	{
		switch(Bit)
		{
		case EPB_God:
			KFXFilterMasks[Bit] = 0x0;
			_KFXComputeFinalFilterMask();
			break;
		case EPB_MagicChange:
			if( KFXAllowHide && KFXPawnCanHid() && (KFXBot(Controller) != none||KFXPlayer(Controller).bServerAllowHide) && DrivenVehicle == none )
			{
				;

				ProcessMultiLevelHide(true);
			}

			KFXFilterMasks[Bit] = 0x0;
			_KFXComputeFinalFilterMask();
			KFXMagicResume();
			break;
		}
	}
}
simulated function ClientEndStateToDo(EPawnBitState Bit)
{
	switch (Bit)
	{
		 case EPB_God:
			 break;
		 case EPB_MagicChange:
			  break;
		 case EPB_Hide:
			  break;
	}
}
// Client & Server
simulated function _KFXTickBitState(EPawnBitState Bit, float DeltaTime)
{
    switch( Bit )
    {
        case EPB_FlameFire:
            if ( Role == ROLE_Authority )
            {
                //log("_KFXTickBitState EPB_FlameFire Param5:"$KFXPawnBitStateData[25].Param5$"Param2:"$KFXPawnBitStateData[25].Param2$"TimeSeconds:"$Level.TimeSeconds$"Param1:"$KFXPawnBitStateData[25].Param1);
                if ( Level.TimeSeconds -  KFXPawnBitStateData[25].Param5 > KFXPawnBitStateData[25].Param2 )
                {
                     KFXPawnBitStateData[25].Param5 = Level.TimeSeconds;
                     self.ServerTakeDamage(KFXPawnBitStateData[25].Param1,Health-KFXPawnBitStateData[25].Param1,none,self.Location,vect(0,0,0),class'KFXGame.KFXFlameDamageType');
                }
            }
        break;
    }

}

// Server Only
// ×´Ì¬ÖØµþ
function bool _KFXBitStateOverlapCheck(EPawnBitState Bit,
	optional float Timer, optional float Param1, optional float Param2)
{
	local int Loop, PendingBit, RemoveBit;

	;


	// ÒÆ³ýÓ¦¸Ã¸²¸ÇµÄµôµÄ×´Ì¬
	for ( loop = 0; loop < EPawnBitState.EPB_Max; loop++ )
	{
		//È¡×îºóÒ»Î»½øÐÐ±È½Ï
		PendingBit = (KFXPendingPawnBitState >> loop) & 0x1;
		RemoveBit = (KFXOverLapMasks[Bit] >> loop) & 0x1;
		if ( PendingBit == RemoveBit )
		{
			if ( PendingBit == 1 )
			{
				;
				// Remove Bit state
				self.KFXRemoveBitState(EPawnBitState(loop));
			}
		}
	}
	return true;

}

// Server Only
// ÖØÐÂ¼ÆËã¹ýÂËÑÚÂë
function _KFXComputeFinalFilterMask()
{
	local int loop;

	KFXFilterMasks[EPawnBitState.EPB_Max] = 0;
	for ( loop = 0; loop < EPawnBitState.EPB_Max; loop++ )
	{
		KFXFilterMasks[EPawnBitState.EPB_Max] =
			KFXFilterMasks[EPawnBitState.EPB_Max] | KFXFilterMasks[loop];
	}
}

// Server Only
// Ôö¼ÓÄ³ÖÖ×´Ì¬
function bool KFXAddBitState(EPawnBitState Bit,
	optional float Timer, optional float Param1, optional float Param2)
{
	;
	if(Controller.IsInState('RoundEnded')||Controller.IsInState('GameEnded'))
		return false;
	// Filter state Bit
	if ( ( (1 << Bit) & KFXFilterMasks[EPawnBitState.EPB_Max] ) != 0 )
	{
		;
		return false;
	}

	// check overlapped
	if ( (KFXCurrentPawnBitState & ( 1 << Bit )) != 0 &&
		!_KFXBitStateOverlapCheck(Bit, Timer, Param1, Param2) )
		{
			;
			return true;
		}
	// Add state Bit
	KFXPendingPawnBitState = KFXPendingPawnBitState | ( 1 << Bit );

	if ( Timer > 0 )
	{
		KFXPawnBitStateData[Bit].bUseTimer = true;
		KFXPawnBitStateData[Bit].Timer = Timer;
	}
	else
	{
		KFXPawnBitStateData[Bit].bUseTimer = false;
		KFXPawnBitStateData[Bit].Timer = 0;
	}

	// Set Param
	KFXPawnBitStateData[Bit].Param1 = Param1;
	KFXPawnBitStateData[Bit].Param2 = Param2;
	KFXPawnBitStateData[Bit].Param3 = 0;
	KFXPawnBitStateData[Bit].Param4 = 0;
	_KFXProcessBitStates(Bit);//Ö±½Ó½øÐÐÎ»×´Ì¬µÄ´¦Àí£¬·þÎñÆ÷¶ËÓÅÏÈ½øÈëÏà¹Ø×´Ì¬

	NetUpdateTime = Level.TimeSeconds - 1;

	return true;
}
function bool KFXSetPBState(int Bit,
	optional float Timer, optional float Param1, optional float Param2)
{
	if ( Bit < EPawnBitState.EPB_Max )
	{
		KFXAddBitState(EPawnBitState(Bit), Timer, Param1, Param2);
		return true;
	}
	return false;
}
// Server Only
// ÒÆ³ýÄ³ÖÖ×´Ì¬
function KFXRemoveBitState(EPawnBitState Bit)
{
	;
	if( Level.NetMode != NM_DedicatedServer )
	{
		KFXCurrentPawnBitState = KFXCurrentPawnBitState & (~( 1 << Bit ));
		;

		_KFXEndBitState( Bit );
	}
	else
	{
		KFXPendingPawnBitState = KFXPendingPawnBitState & (~( 1 << Bit ));
		;

		KFXCurrentPawnBitState = KFXPendingPawnBitState;
		;

		_KFXEndBitState( Bit );

		 NetUpdateTime = Level.TimeSeconds - 1;
	}
}
//server && client
simulated function KFXRemoveAllStates()
{
	local int Loop, PendingBit;
	;

	// ±éÀúËùÓÐµÄbitState
	for ( loop = 0; loop < EPawnBitState.EPB_Max; loop++ )
	{
		PendingBit = (KFXPendingPawnBitState >> loop) & 0x1;
		// Add Bit state
		if ( PendingBit == 1 )
			_KFXEndBitState( EPawnBitState(loop) );
	}
	KFXPendingPawnBitState = 0;
	KFXCurrentPawnBitState = 0;

	NetUpdateTime = Level.TimeSeconds - 1;
}
// Server Only
// ÓÃÓÚ½â³ýÏà³â×´Ì¬
function KFXFilterBitStates(int FilterMask)
{
	KFXPendingPawnBitState = KFXPendingPawnBitState & (~FilterMask);

	NetUpdateTime = Level.TimeSeconds - 1;
}
// Server Only
// È¡ÏûËùÓÐ×´Ì¬
function KFXClearAllBitStates(optional int ReservedBitMask)
{
	local int loop;
	KFXPendingPawnBitState = KFXPendingPawnBitState & ReservedBitMask;
	for ( loop = 0; loop <= EPawnBitState.EPB_Max; loop++ )
	{
		if ( ( (1 << EPawnBitState.EPB_Max ) & ReservedBitMask ) == 0  )
			KFXFilterMasks[loop] = 0;
	}
	NetUpdateTime = Level.TimeSeconds - 1;
}

simulated function bool IsGodPawn()
{
	return KFXIsBitStateOn(EPB_God);
}

//---------------added by wxb---fix bug: ½ÇÉ«ËÀÍöÌØÐ§²»ÏûÊ§ --------------------
simulated function Destroyed()
{
//    local int loop;

//    for ( loop = 0; loop < 32; loop++ )
//    {
//    if(KFXPawnBitStateData[loop].Effect!=none)
//         KFXPawnBitStateData[loop].Effect.Destroy();
//    }

	local Emitter Emt;
	if(Level.NetMode!=NM_DedicatedServer)
	{
		foreach BasedActors(class'Emitter', Emt)
		{
			Emt.Destroy();
		}

		if ( KFXArming != none )
		{
			KFXArming.Destroy();
			KFXArming = none;
		}

		if ( self.KFXFactionBadge != none )
		{
			KFXFactionBadge.Destroy();
			KFXFactionBadge = none;
		}
	}
	DestroyAllMyDecoration();
	super.Destroyed();
}
simulated function DestroyAllMyDecoration()
{
	local KFXDecoration de;
	if(MyDecorations != none)
	{
		for(de = MyDecorations.NextDecoration; de != none; de = MyDecorations.NextDecoration)
		{
			MyDecorations.DestroyDecoration();
			MyDecorations = de;
		}
		MyDecorations.DestroyDecoration();
	}
}

//---------------added by wxb-----------------------------
//-----ÒþÉíÏà¹Ø----------------

simulated function bool KFXPawnCanHid()
{
	return false;
}

//true ÎªÔÊÐíÏÔ¿¨²»»­
//false ÔòÎª²»ÔÊÐí
simulated function bool KFXCheckHide()
{
	local KFXPlayer localController;
	localController = KFXPlayer(level.GetLocalPlayerController());
	if(localController.IsInState('spectating') && localController.ViewTarget == self &&
		!localController.bBehindView)
	{
		return true;
	}
	if(KFXCurInvisLevel!=0)
	{
		return false;
	}
	if(KFXCurSmokeAffect)
	return false;

	return true;
}

// client only ÒþÉí³õÊ¼»¯
simulated function KFXInitInvisLevel()
{
	KFXSetInvisLevel(0,true);//Ç¿ÖÆ½øÐÐÒþÉí
}

//client only
simulated function ChangedWeapon()
{
	super.ChangedWeapon();

	if( KFXAllowHide && KFXPawnCanHid() && (KFXBot(Controller) != none||KFXPlayer(Controller).bServerAllowHide) && DrivenVehicle == none )
	{
		;
		ProcessMultiLevelHide(true);
	}
	;
}
simulated function SetFallPhysicsInvisLevel(int Level)
{
	if(KFXCurInvisLevel == Level && Physics == PHYS_Falling)
	{
		KFXCurInvisLevel = 2;    //À´¸öÓ²±àÂë°É¸ÄÓÄÁéÌøÆðºó°´ctrl»áÒþÐÎbug
	}
	else
	{
		KFXCurInvisLevel = Level;
	}
}
//client
simulated function KFXSetInvisLevel(int Level,optional bool bForced)
{
	if(KFXCurInvisLevel > -1 && KFXCurInvisLevel < 3)
	{
		RequestRecord(""$"31 "$KFXCurInvisLevel);  //RDN_Invisible
	}
	if( !KFXPawnCanHid() )
		return;

	if(KFXCurInvisLevel == Level && !bForced && Physics != PHYS_Falling)
		return;

	;
	SetFallPhysicsInvisLevel(Level);

	///KFXInvisSkin = Material(DynamicLoadObject( KFXInvisMatStr[KFXCurInvisLevel], class'Material' ));
	KFXInvisSkin = GetInvisSkim(KFXCurInvisLevel) ;
	if(KFXInvisSkin!=none)
	{

		KFXSetInvis(KFXInvisSkin,3000,false);
	}
	else
	{
		log("[KFXPawn] KFXInvisSkin is none");
	}
}
simulated function Material GetInvisSkim(int CurLevel)
{
	local KFXPlayer localController;
	localController = KFXPlayer(level.GetLocalPlayerController());

	//zhong:µÚÒ»ÈË³Æcheat weap´¦Àí,×¢:curweaponµÄÖ÷ÈË±ØÐëÊÇÕâ¸öpawn²Å¿ÉÒÔ
	if(localController.IsInState('spectating') && localController.ViewTarget == self &&
	 !localController.bBehindview && localController.SpectateHook.CurSpectateWeap != none &&
		localController.SpectateHook.CurSpectateWeap.Instigator == self)
	{
	   KFXInvisSkin = Material(DynamicLoadObject( KFXFirstPersonInvisMatStr[CurLevel], class'Material' ));
	}
	else if(!localController.IsInState('spectating') && Controller!=none&&PlayerController(Controller)!=none&&!PlayerController(Controller).bBehindview)
	{
	   KFXInvisSkin = Material(DynamicLoadObject( KFXFirstPersonInvisMatStr[CurLevel], class'Material' ));
	}
	else
	{
	   KFXInvisSkin = Material(DynamicLoadObject( KFXInvisMatStr[CurLevel], class'Material' ));
	}

	return  KFXInvisSkin;
}
// È¡µÃPawnµ±Ç°ÔË¶¯×´Ì¬ºÅ
simulated function int KFXGetPawnState()
{
	if(!bIsCrouched)
	{
		//Ö±Á¢Ìø
		if ( Physics != PHYS_Walking &&Physics != PHYS_Ladder)
			return 2;
		//Ö±Á¢ÅÜ
		else if( VSize(Velocity) > 10  && !bIsWalking )//( WalkingPct * GroundSpeed + 10 ) )
		   return 2;
		//Ö±Á¢×ß
		else if( VSize(Velocity) > 10  && bIsWalking)
			return 1;
		//¾²Ö¹
		else
			return 0;
	}
	else
	{
		//¶×Ìø
		if ( Physics != PHYS_Walking )
			return 0;
		//¶××ß
		else if( VSize(Velocity) > 10 )
			return 1;
		//¶×¾²Ö¹
		else
			return 0;
	}
}
simulated function Shader GetSpecialSkin()
{
	return SpecialSkin;
}

//client only
simulated function ProcessMultiLevelHide(optional bool bForced)
{
	local int nLevel;
	nLevel = KFXGetPawnState();
	KFXSetInvisLevel(nLevel,bForced);
}

simulated function KFXLogMat(int nPart)
{
	local array<material> MeshMaterialList;
	local int loop;
	local actor user;

	KFXCheckNPartData(nPart,user);

	if(user==none)
	return;


	MeshMaterialList = user.KFXGetMeshMatList();
	for(loop = 0;loop<MeshMaterialList.Length;loop++)
	{
		;
	}
}

simulated function KFXCreateInvisMat(int nPart,Material KFXInvisSkin)
{
	local actor user;

	KFXCheckNPartData(nPart,user);
	if(user != none)
		KFXCreateInvisMatUseActor(user, KFXInvisSkin, npart == 3);
}
//´´½¨nPartÍ¸Ã÷Ð§¹û
simulated function KFXCreateInvisMatUseActor(Actor user, Material KFXInvisSkin, optional bool bForceShow)
{
	local array<material> MeshMaterialList;
	local array<FinalBlend> FinalMaterialList;
	local array<Combiner> CombMaterialList;
	local int loop,CurLength;


	MeshMaterialList = user.KFXGetMeshMatList();
	;
	if(MeshMaterialList.Length == 0 && user.skins.Length==0)
	{
		//log("[GhostPawn]mesh skin can't access");
		return ;
	}
	//skinÓÅÏÈ
	if(MeshMaterialList.Length<=user.skins.Length)
	{
		;
		if(MeshMaterialList.Length>0)
			MeshMaterialList.Remove(0,MeshMaterialList.length);
		MeshMaterialList = user.skins;
	}

	if((user.Skins.Length==1&&user.Skins[0].IsA('FinalBlend'))
		||(user.Skins.Length>1
		&&((user.Skins[0].IsA('FinalBlend')&&user.Skins[1]==none)
		||(user.Skins[0].IsA('FinalBlend')&&user.Skins[1].IsA('FinalBlend'))
		)
		)
		)

	{
		;
		for(loop = 0;loop<user.Skins.Length;loop++)
		{
			if(user.Skins[loop]!=none)
			{
				;
				Combiner(FinalBlend(user.Skins[loop]).Material).Material1 = KFXInvisSkin;
			}
		}
		;
		if(bForceShow)
		return;

		if(KFXCheckHide())
		{
			user.bHidden = true;
		}
		else
		user.bHidden = false;
		return;
	}
	;
	if(user.Skins.Length>0)
	user.Skins.Remove(0,user.Skins.Length);
	CombMaterialList.Insert(0,MeshMaterialList.Length);
	FinalMaterialList.Insert(0,MeshMaterialList.Length);


	CurLength = MeshMaterialList.Length;
	//ÉèÖÃ²ÄÖÊ²ÎÊý
	for(loop = 0;loop<CurLength;loop++)
	{
		log("MeshMaterialList mat is "$MeshMaterialList[loop]$" and CombMaterialList[loop].Material2 is "$CombMaterialList[loop].Material2);
		if(FinalMaterialList[loop]==none)
		{

			//FinalMaterialList[loop] = new(self) class'FinalBlend';
			FinalMaterialList[loop] = FinalBlend(Level.ObjectPool.AllocateObject(class'FinalBlend'));
		}
		if(FinalMaterialList[loop]==none)
		{
			log("[GhostPawn]new FinalMaterialList is ERROR");
		}


		if(CombMaterialList[loop]==none)
		{
			//CombMaterialList[loop] = new(FinalMaterialList[loop]) class'Combiner';
			CombMaterialList[loop] = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
		}

		CombMaterialList[loop].CombineOperation = CO_Multiply;
		CombMaterialList[loop].Material1 = KFXInvisSkin;
		if(MeshMaterialList[loop]!=none&&MeshMaterialList[loop].IsA('Shader'))
		{
			if(Shader(MeshMaterialList[loop]).Diffuse!=none)
			CombMaterialList[loop].Material2 = Shader(MeshMaterialList[loop]).Diffuse;
			else
			CombMaterialList[loop].Material2 = Shader(MeshMaterialList[loop]).SpecularityMask;
		}
		else if(MeshMaterialList[loop]!=none)
			CombMaterialList[loop].Material2 = MeshMaterialList[loop];
		else
		{
		;
		}




		//ÉèÖÃÍ¸Ã÷
		FinalMaterialList[loop].FrameBufferBlending = FB_Translucent;//FB_AlphaBlend;//FB_Darken FB_AlphaBlend; FB_Translucent
		//·ÀÖ¹zÖáÎÞÐò
		FinalMaterialList[loop].ZWrite = true;
		//¹ØµôË«ÃæÏÔÊ¾
		FinalMaterialList[loop].TwoSided = false;
		//ÉèÖÃ²ÄÖÊ
		FinalMaterialList[loop].Material = CombMaterialList[loop];
	}

	user.Skins = FinalMaterialList;
	if(bForceShow)
	return;
	if(KFXCheckHide())
	{
		user.bHidden = true;
	}
	else
	user.bHidden = false;
}

//client only
simulated function KFXCheckNPartData(int nPart,out actor user)
{
	local KFXSpectateWeap SpectateWeap;
	local KFXPlayer localController;
	localController = KFXPlayer(level.GetLocalPlayerController());
	if(localController.IsInState('spectating') && localController.SpectateHook.CurSpectateWeap != none
		&& self == localController.ViewTarget)
	{
		SpectateWeap = localController.SpectateHook.CurSpectateWeap;
	}

	switch(nPart)
	{
		case 0://Í·
		if(self.AvatarHead==none)
		return;

		;
		user = self.AvatarHead;
		break;
		case 1://Çû¸É
		;
		user = self;
		break;
		case 2://ÍÈ
		if(self.AvatarLegs==none)
		return;
		;
		user = self.AvatarLegs;
		break;
		case 3://µÚÒ»ÈË³ÆÎäÆ÷
		if(self.Weapon==none && SpectateWeap == none)
			return;
		;
		if(SpectateWeap != none)
		{
			user = SpectateWeap;
		}
		else
		{
			user = self.Weapon;
		}
		break;
		case 4://µÚÈýÈË³ÆÎäÆ÷
		if(self.WeaponAttachment==none)
		return;
		;
		user = self.WeaponAttachment;
		break;
		case 5: // µÈ¼¶±ÛÕÂ
		user = KFXArming;
		break;
		case 6: // Õ½¶Ó±ÛÕÂ
		user = KFXFactionBadge;
		break;
		default:
		;
		break;
	}
}

//client only
simulated function KFXSetInvis(Material KFXInvisSkin, float Timer, bool bOverride)
{
	local KFXDecoration de;

	local KFXPlayer localController;
	local KFXSpectateWeap SpectateWeap;
	localController = KFXPlayer(level.GetLocalPlayerController());

	//zhong:µÚÒ»ÈË³Æcheat weap´¦Àí,×¢:curweaponµÄÖ÷ÈË±ØÐëÊÇÕâ¸öpawn²Å¿ÉÒÔ
	if(localController.IsInState('spectating') && localController.ViewTarget == self &&
	 !localController.bBehindview && localController.SpectateHook.CurSpectateWeap != none &&
		localController.SpectateHook.CurSpectateWeap.Instigator == self)
	{
		SpectateWeap = localController.SpectateHook.CurSpectateWeap;
		if(SpectateWeap.Skins.length > 0 &&PlayerReplicationInfo!=none&&PlayerReplicationInfo.Team!=none)
		{
			KFXCreateInvisMat(3,KFXInvisSkin); //&&
		}
		else if(Weapon.Skins.length == 0)
		{
			SpectateWeap.KFXSetWeaponMaterial();
			KFXCreateInvisMat(3,KFXInvisSkin); //&&
			;
		}
	}

	if(Controller!=none&&PlayerController(Controller)!=none&&!PlayerController(Controller).bBehindview)
	{
		//Èç¹ûÊÇ×Ô¼º£¬ÇÒÎªµÚÒ»ÈË³ÆÊ±
		if(weapon!=none&& Weapon.Skins.length > 0 && ( Weapon.Instigator==self || Weapon.Instigator == none ) &&PlayerReplicationInfo!=none&&PlayerReplicationInfo.Team!=none)
		{
			KFXWeapBase(Weapon).KFXSetWeaponMaterial();
			KFXCreateInvisMat(3,KFXInvisSkin); //&&
			log("KFXPawnBase---------2222 ");
		}
		else if(Weapon != none && Weapon.Skins.length == 0)
		{
			KFXWeapBase(Weapon).KFXSetWeaponMaterial();
			KFXCreateInvisMat(3,KFXInvisSkin); //&&
			log("KFXPawnBase---------1111 ");
			;
		}
	}
	else
	{
		//Èç¹ûÊÇµÚÈýÈË³ÆµÄÊÓ½Ç
		KFXCreateInvisMat(0,KFXInvisSkin);
		KFXCreateInvisMat(1,KFXInvisSkin);
		KFXCreateInvisMat(2,KFXInvisSkin);
		if ( KFXArming != none )
			KFXCreateInvisMat(5,KFXInvisSkin);

		if ( KFXFactionBadge != none )
			KFXCreateInvisMat(6,KFXInvisSkin);

		if( WeaponAttachment != none )
			KFXCreateInvisMat(4,KFXInvisSkin);

		KFXSetShadowEnable(false);

		//Òþ²Ø¹Ò¼þ
		for(de=self.MyDecorations; de != none; de = de.NextDecoration)
		{
			KFXCReateInvisMatUseActor(de, KFXInvisSkin, false);
		}
	}
}

simulated function KFXRemoveInvis(int nRoleID)
{
	local int NumSkins;
	local KFXCSVTable CFG_LIST,CFG_Avatar;
	//local int DefMeshID,BodyID, HeadID, LegsID,TeamID;
	local int DefMeshID;
	local string Skin1, Skin2;
	//local KFXCSVTable DecorAttrTable,DecorModeTable;
	local KFXDecoration de;

	local int loop;

	log("[KFXPawn] KFXRemoveInvis ");

	if(Level.NetMode!=NM_DedicatedServer)
	{
		NumSkins = self.Clamp(self.Skins.Length,2,4);
		//»Ö¸´²ÄÖÊ
		CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
		CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);

		if ( CFG_LIST == none || CFG_Avatar ==none )
			return;

		if ( !CFG_LIST.SetCurrentRow(nRoleID) )
			return;
		DefMeshID   = CFG_LIST.GetInt("MeshID");
		log("[KFXPawn] KFXRemoveInvis DefMeshID"$DefMeshID);

		if(KFXIsAvatar)
		{
			//ÉíÌå²¿·Ö»Ö¸´
			if ( !CFG_Avatar.SetCurrentRow(KFXPendingState.nSuitID) )
				return;

			Skin1 = CFG_Avatar.GetString("skin1");
			Skin2 = CFG_Avatar.GetString("skin2");

			for (loop = 0; loop<self.Skins.Length; loop++)
			{
			}

			KFXChangeSkin(Skin1,Skin2,false);
			bHidden = false;


//            //½Å»Ö¸´
//            DecorModeTable =  class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationModel.csv");
//            log("AvatarLegs.modeid "$AvatarLegs.modeid);
//            if ( !DecorModeTable.SetCurrentRow(AvatarLegs.modeid) )
//                return;
//
//            Skin1 = DecorModeTable.GetString("ViewSkin");
//            AvatarLegs.KFXChangeSkin(Skin1,"none");
//            AvatarLegs.bHidden = false;
//
//            // Body
//            if ( KFXAvatar.nBodyID != 0 )
//                BodyID   = KFXAvatar.nBodyID;
//            else
//                BodyID   = CFG_LIST.GetInt("DefBody");
//            // Head
//            if ( KFXAvatar.nHeadID != 0 )
//                HeadID   = KFXAvatar.nHeadID;
//            else
//                HeadID   = CFG_LIST.GetInt("DefHead");
//            // Legs
//            if ( KFXAvatar.nLegsID != 0 )
//                LegsID   = KFXAvatar.nLegsID;
//            else
//                LegsID   = CFG_LIST.GetInt("DefLeg");
//
//             TeamID = KFXPendingState.TeamID;
//////////////////////////////////////////////////////////////////////
//            //»Ö¸´Í·²¿µÄ²ÄÖÊ
//
//            if ( !CFG_Avatar.SetCurrentRow(HeadID) )
//            {
//                AvatarHead.Destroy();
//                return;
//            }
//
//            Skin1 = CFG_Avatar.GetString("skin1");
//            Skin2 = CFG_Avatar.GetString("skin2");
//
//            AvatarHead.KFXChangeSkin(Skin1,Skin2,TeamID);
//            AvatarHead.bHidden = false;

		}
		else
		{
		//ÏÖÔÚavatarºÍsuit¹²´æÁË£¬ÔÝÊ±°ÑÏÂÃæ´úÂëÒÆµ½ÉÏÃæÈ¥
			//log("Remove the Invs not KFXIsAvatar");
//            // »Ö¸´·Çavatar²ÄÖÊ »Ö¸´Ê¹ÓÃµÄÌ××°
//            if ( !CFG_Avatar.SetCurrentRow(DefMeshID) )
//                return;
//
//            Skin1 = CFG_Avatar.GetString("skin1");
//            Skin2 = CFG_Avatar.GetString("skin2");
//            log("[KFXPawn]  CFG_Avatar in KFXIsAvatar false");
//            KFXChangeSkin(Skin1,Skin2);
//            bHidden = false;
		}
		//½ÇÉ«¹Ò¼þÏÔÐÔ
		for(de = self.MyDecorations; de != none; de = de.NextDecoration)
		{
			de.ReShow(self, 1);
		}

		//»Ö¸´ÒõÓ°
		KFXSetShadowEnable(true);
	}
//ÎäÆ÷²¢Ã»ÓÐ»Ö¸´
}
//-----ÒþÉíÏà¹Ø----------------
//---------------added by wxb-----------------------------

// Client & Server
simulated function bool KFXIsBitStateOn(EPawnBitState Bit)
{
	return ((KFXCurrentPawnBitState >> Bit) & 0x1) == 1;
}

// Client & Server
// IsGodMode?
simulated function bool KFXIsGodMode()
{
	return KFXIsBitStateOn(EPB_God);
}

// Server Only
// SetGodMode
function KFXSetGodMode(bool IsOn, optional float Timer)
{
	if ( IsOn )
	{
		KFXAddBitState(EPB_God, Timer);
	}
	else
	{
		KFXRemoveBitState(EPB_God);
	}
}

// Client & Server
simulated function KFXUseItem(float Timer)
{
	KFXSetPB(EPawnBitState.EPB_UseItem, Timer);
}

// ÉèÖÃ×´Ì¬Î»
// only for debug
exec function KFXSetPB(int Bit, optional float Timer,optional float param1)
{
	KFXAddBitState(EPawnBitState(Bit), Timer,param1);
}

//=============================================================================
simulated function MakeDamage()
{
}

function float GetBufferLastTime(int BufferType)
{
	return 0;
}

function AddBuffer(int BufferType)
{
	m_BufferLastTime = GetBufferLastTime(BufferType);

	m_BufferType = BufferType;
	m_BufferTimeCounter = m_BufferLastTime;
}

function DeleteBuffer()
{
	m_BufferType = 0;
}

simulated function AddClientBuffer()
{
	;
}

simulated function DeleteClientBuffer()
{
	;
}

simulated function TickBuffer(float DeltaTime)
{
	if( Level.NetMode != NM_DedicatedServer )  //¿Í»§¶Ë
	{
		if( m_OldBufferType != m_BufferType )
		{
			if( m_OldBufferType == 0 )
			{
				AddClientBuffer();
			}
			else if( m_BufferType == 0 )
			{
				DeleteClientBuffer();
			}

			m_OldBufferType = m_BufferType;
		}
		//LOG("ClientTickBuffer");
	}
	else                                       //·þÎñÆ÷
	{
		if( m_BufferType == 0 )
			return;

		m_BufferTimeCounter -= DeltaTime;

		if( m_BufferTimeCounter < 0 )
		{
			m_BufferTimeCounter = -1;
			DeleteBuffer();
		}

		//LOG("ServerTickBuffer");
	}
}

function int KFXGetDesignationID(int nPoint)
{
	local KFXCSVTable CSVDesignation;
	local int index;

	CSVDesignation = class'KFXTools'.static.KFXCreateCSVTable("KFXDesignation.csv");
	if ( CSVDesignation == none )
	{
		;
		return 0;
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

	return index;

}

// ´´½¨»ÕÕÂ
simulated function KFXInitArming()
{
	local KFXCSVTable CFG_LIST, CFG_Avatar;
	local int DefMeshID;
	local bool bArmDadge;

	if ( Level.NetMode == NM_DedicatedServer )
		return;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
			return;
	}

	DefMeshID   = CFG_LIST.GetInt("MeshID");

	// Ì××°×°±¸
	if( DefMeshID == 0 )
	{
		if ( KFXPendingState.nSuitID != 0 )
		{
			DefMeshID = KFXPendingState.nSuitID;
		}
		else if ( KFXAvatar.nBodyID != 0 )
		{
			DefMeshID   = KFXAvatar.nBodyID;
		}
		else
		{
			DefMeshID = CFG_LIST.GetInt("DefBody");
		}
	}

	if ( !CFG_Avatar.SetCurrentRow(DefMeshID) )
	{
		log("[KFXInitArming] error: Wrong mesh ID with DefMeshID:" @ DefMeshID);
		return;
	}

	// ´´½¨µÈ¼¶±ÛÕÂ
	if ( bKFXHasLevelDadge )
	{
		bArmDadge = CFG_Avatar.GetBool("levelbadge");
		if ( bArmDadge )
		{
			KFXArming = Spawn(KFXArmingName, self);
			AttachToBone(KFXArming,'Bip01 L UpperArm');
			Arming(KFXArming).KFXInitLevelDadge(KFXPlayerReplicationInfo(PlayerReplicationInfo).fxLevel, DefMeshID);
		}
	}
	// ´´½¨µ¥Éí±ÛÕÂ
	else if ( KFXSingleBadge != "" )
	{
		bArmDadge = CFG_Avatar.GetBool("singlebadge");
		if ( bArmDadge )
		{
			KFXArming = Spawn(KFXArmingName, self);
			AttachToBone(KFXArming,'Bip01 L UpperArm');
			Arming(KFXArming).KFXInitSingleBadge(DefMeshID, KFXSingleBadge);
		}
	}
}

simulated function KFXCreateArming(int MeshID, optional int Grade, optional int SingleBadgeID)
{
	if ( KFXArming != none )
	{
		if ( bKFXHasLevelDadge )
		{
			AttachToBone(KFXArming,'Bip01 L UpperArm');
			Arming(KFXArming).KFXInitLevelDadge(Grade, MeshID);
		}
	}
}

simulated function KFXInitGuiArming()
{
	KFXArming = Spawn(KFXArmingName, self);
	KFXFactionBadge = Spawn(class'FactionBadge', self);

}

simulated function KFXCreateGuiArming(
	int MeshID,
	optional int Grade,
	optional int BadgeID,
	optional string FactionIcon,
	optional string FactionBackGround
	)
{
	local int Type, HighID;
	local KFXCSVTable CFG_Props;
	local string sIcon;
	if ( KFXGetArmingAuthority(MeshID, BadgeID) )
	{
		Type = BadgeID % 65536;
		HighID = BadgeID >> 16;

		if ( HighID == 59 )
		{
			if (Type == 1 )
			{
				AttachToBone(KFXArming,'Bip01 L UpperArm');
				Arming(KFXArming).KFXInitLevelDadge(Grade, MeshID);
			}
			else
			{
				CFG_Props = class'KFXTools'.static.GetConfigTable(32);
				if ( CFG_Props == none )
				{
					return;
				}

				if ( !CFG_Props.SetCurrentRow(BadgeID) )
				{
					log("[Arming] error: Wrong SingleBadge ID with BadgeID:" @ BadgeID);
					return;
				}
				sIcon = CFG_Props.GetString("Param1");
				AttachToBone(KFXArming,'Bip01 L UpperArm');
				Arming(KFXArming).KFXInitSingleBadge(MeshID, sIcon);
			}
		}
		else if ( HighID == 65 )
		{
			AttachToBone(KFXFactionBadge,'Bip01 R UpperArm');
			KFXFactionBadge.KFXInit(FactionIcon, FactionBackGround, MeshID);
		}
	}
}

simulated function KFXDetachArming()
{
	if ( KFXArming != none )
	{
		DetachFromBone(KFXArming);
	}
	if ( KFXFactionBadge != none )
	{
		DetachFromBone(KFXFactionBadge);
	}
}

simulated function bool KFXGetArmingAuthority(int MeshID, optional int BadgeID)
{
	local KFXCSVTable CFG_Avatar;
	local bool Levelbadge;
	local int Type, HighID;

	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);
	if ( !CFG_Avatar.SetCurrentRow(MeshID) )
	{
		log("[KFXGetArmingAuthority] error: Wrong mesh ID with MeshID:" @ MeshID);
		return false;
	}
	HighID = BadgeID >> 16;
	Type = BadgeID % 65536;

	if ( HighID == 59 ) // µ¥Éí±ÛÕÂ
	{
		if (Type == 1 )
		{
			Levelbadge = CFG_Avatar.GetBool("levelbadge");
		}
		else
		{
			Levelbadge = CFG_Avatar.GetBool("singlebadge");
		}
	}
	else if ( HighID == 65 )
	{
		Levelbadge = CFG_Avatar.GetBool("factionbadge");
	}

	return Levelbadge;
}

simulated function KFXArmingHidden(bool HiddenState)
{
	if ( KFXArming != none )
	{
		KFXArming.bHidden = HiddenState;
	}

	if ( KFXFactionBadge != none )
	{
		KFXFactionBadge.bHidden = HiddenState;
	}
}

simulated function KFXInitFactionBadge()
{
	local KFXCSVTable CFG_LIST, CFG_Avatar;
	local int DefMeshID;
	local bool bArmDadge;
	local string FactionIcon, FactionBackGround;

	if ( Level.NetMode == NM_DedicatedServer )
		return;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
			return;
	}

	DefMeshID   = CFG_LIST.GetInt("MeshID");

	// Ì××°×°±¸
	if( DefMeshID == 0 )
	{
		if ( KFXPendingState.nSuitID != 0 )
		{
			DefMeshID = KFXPendingState.nSuitID;
		}
		else if ( KFXAvatar.nBodyID != 0 )
		{
			DefMeshID   = KFXAvatar.nBodyID;
		}
		else
		{
			DefMeshID = CFG_LIST.GetInt("DefBody");
		}
	}

	if ( !CFG_Avatar.SetCurrentRow(DefMeshID) )
	{
		log("[KFXInitArming] error: Wrong mesh ID with DefMeshID:" @ DefMeshID);
		return;
	}

	bArmDadge = CFG_Avatar.GetBool("factionbadge");
	if ( bArmDadge )
	{
		FactionIcon = "fx_ui3_texs.FactionIcon_L_" $ KFXPlayerReplicationInfo(PlayerReplicationInfo).fxFactionIcon;
		FactionBackGround = "fx_ui3_texs.FactionIcon_L_" $ KFXPlayerReplicationInfo(PlayerReplicationInfo).fxFactionBackGround;
		KFXFactionBadge = Spawn(class'FactionBadge', self);
		AttachToBone(KFXFactionBadge,'Bip01 R UpperArm');
		KFXFactionBadge.KFXInit(FactionIcon, FactionBackGround, DefMeshID);
	}
}

function GasDamage( int Damage, Pawn instigatedBy, Vector Hitlocation,
						vector momentum, class<DamageType> damageType)
{
	if ( KFXIsGodMode() )
		return;
	super.GasDamage(Damage, instigatedBy, Hitlocation, momentum, damageType);
}

function KFXSuitHealthRecover()
{
	if ( KFXSuitHPRecover.Time != 0 && Health < HealthMax
		&& Level.TimeSeconds % KFXSuitHPRecover.Time == 0 )
	{
		Health += Min(HealthMax - Health, KFXSuitHPRecover.RecoverCount);
	}
}

function KFXSetHealthRecoverScale(float ScaleFactor)
{
	KFXHealthRecoverScale = ScaleFactor;
}

function KFXSetSuitHPRecover(int Count, float Time)
{
	KFXSuitHPRecover.RecoverCount = Count;
	KFXSuitHPRecover.Time = Time;
}

simulated function bool UIChangeWeapon(int WeaponID)
{
	local KFXWeapBase NewWeapon;

	NewWeapon = class'KFXPropSystem'.static.KFXCreateWeapon(self, WeaponID);

	if (NewWeapon != none)
	{
		if (Weapon == None)
		{
			PendingWeapon = NewWeapon;
			ChangedWeapon();
		}
		else if (Weapon != NewWeapon || PendingWeapon != None)
		{
			PendingWeapon = NewWeapon;
			Weapon.Destroyed();
			ChangedWeapon();
		}
		else if (Weapon == NewWeapon)
		{
			Weapon.Reselect();
		}

		bSelectWeaponClass = false;

		return true;
	}

	return false;
}

simulated function _PlayDying_Normal(class<DamageType> DamageType, vector HitLoc)
{
	super._PlayDying_Normal(DamageType, HitLoc);

	if (Level.NetMode != NM_DedicatedServer)
	{
		// ËÀÍöÊ±¹Ø±ÕÎ´¹Ø±ÕµÄ»»Ç¹½çÃæ
		if (bTransWeaponMenuOpened)
		{
			KFXPlayer(Controller).CloseTransWeaponPage();
		}

	}
}

simulated function SwitchWeapon(byte F)
{
	local weapon newWeapon;
	if ( CanSwitchWeapon() )
	{
		if ( (Level.Pauser!=None) || (Inventory == None) )
			return;
		if ( (Weapon != None) && (Weapon.Inventory != None) )
			newWeapon = Weapon.Inventory.WeaponChange(F, false);
		else
			newWeapon = None;
		if ( newWeapon!=none&&KFXWeapBase(newWeapon).KFXGetWeaponID()==2&&
			 KFXWeapBase(Weapon).KFXGetWeaponID()!=2&&F==3)
		{
			newWeapon = None;
		}
		if ( newWeapon == None )
			newWeapon = Inventory.WeaponChange(F, true);
		if ( newWeapon == None )
		{
			if ( F == 10 )
				ServerNoTranslocator();

			return;
		}
		log("[PawnBase] SwitchWeapon "$PendingWeapon$"Weapon:"$Weapon$"newWeapon"$newWeapon);
		if ( PendingWeapon != None && PendingWeapon.bForceSwitch )
		{
			PendingWeapon = none;
			return;
		}
		if ( Weapon == None )
		{
			PendingWeapon = newWeapon;
			ChangedWeapon();
		}
		else if ( Weapon != newWeapon || PendingWeapon != None )
		{
			PendingWeapon = newWeapon;
			bJustSwitchWeapon = true;
			if((KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) >= 51 && (KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) <= 60)
				//&& ((KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) >= 61 || (KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) <= 50))
			{
				bQuickChangeToss = true;
				ServerSetQuickChangeToss(true);
				log("KFXpawnBase------bQuickChangeToss "$bQuickChangeToss);
			}
			Weapon.PutDown();
			log("[LABOR]----------weapon put down");
		}
		else if ( Weapon == newWeapon )
			Weapon.Reselect(); // sjs
		KFXPlayer(Controller).bHasJustRestarted = false;
	}
}

simulated function  ServerSetQuickChangeToss(bool bChangeToss)
{
	bQuickChangeToss = bChangeToss;
	log("KFXPawnBase-------bQuickChangeToss "$bQuickChangeToss);
}

simulated function CheckJustRestartSwitchWeapon()
{
	local bool bHasMajorWeapon,bHasMinorWeapon,bHasMeleeWeapon,bHasTossWeapon;
	local Weapon MinorWeapon,MeleeWeapon,TossWeapon;
	local Inventory Inv;

	bHasMajorWeapon = false;
	bHasMinorWeapon = false;
	bHasMeleeWeapon = false;
	bHasTossWeapon  = false;

	for(Inv = Inventory; Inv != none; Inv = Inv.Inventory)
	{
		if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=1 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=30)
		{
			 bHasMajorWeapon = true;
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=31 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=40)
		{
			 bHasMinorWeapon = true;
			 MinorWeapon = KFXWeapBase(Inv);
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=41 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=50)
		{
			 bHasMeleeWeapon = true;
			 MeleeWeapon = KFXWeapBase(Inv);
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=51 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=60)
		{
			 bHasTossWeapon  = true;
			 TossWeapon =KFXWeapBase(Inv);
			 break;
		}
	}

	KFXPlayer(Controller).bHasJustRestarted = false;
	if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=1 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=30)
	{
		if(bHasMinorWeapon)
		{
			Weapon.OldWeapon = MinorWeapon;
		}
	}
	else if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=41 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=50)
	{
		 if(!bHasMajorWeapon && !bHasMinorWeapon)
		 {
			if(bHasTossWeapon)
			{
				Weapon.OldWeapon = TossWeapon  ;
			}
		 }
	}
	else if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=51 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=60)
	{
		 if(!bHasMajorWeapon && !bHasMinorWeapon)      //³öÉúÊ±£¬Ã»ÓÐÖ÷ÎäÆ÷ºÍ¸±ÎäÆ÷£¬Ö»ÓÐµ¶ºÍÀ×µÄÊ±ºòÒªÀ´»ØÇÐ
		 {
			 if(bHasMeleeWeapon)
			{
				Weapon.OldWeapon = MeleeWeapon;
			}
		 }
	}

	if ( Weapon.OldWeapon != None )
	{
		if ( KFXWeapBase(Weapon.OldWeapon).KFXHackCanSwitchTo() )
		{
			PendingWeapon = Weapon.OldWeapon;
			bJustSwitchWeapon = true;
			if((KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) >= 51 && (KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) <= 60)
			//&& ((KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) >= 61 || (KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) <= 50))
			{
				bQuickChangeToss = true;
				ServerSetQuickChangeToss(true);
				log("KFXpawnBase------bQuickChangeToss "$bQuickChangeToss);
			}
			Weapon.PutDown();
		}
	}
	else
	{
		switchweapon(3);
	}
}

exec function SwitchToLastWeapon()
{
	if ( CanSwitchWeapon() )
	{
		if(KFXPlayer(Controller).bHasJustRestarted)
		{
			CheckJustRestartSwitchWeapon();
		}
		else
		{
			if ( Weapon.OldWeapon != None )
			{
				if ( KFXWeapBase(Weapon.OldWeapon).KFXHackCanSwitchTo() )
				{
					PendingWeapon = Weapon.OldWeapon;
					bJustSwitchWeapon = true;
					if((KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) >= 51 && (KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) <= 60)
					//&& ((KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) >= 61 || (KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) <= 50))
					{
						bQuickChangeToss = true;
						ServerSetQuickChangeToss(true);
						log("KFXpawnBase------bQuickChangeToss "$bQuickChangeToss);
					}
					Weapon.PutDown();
				}
				else
				{
					SwitchToLastWeaponWhenTossed();
				}
			}
			else
			{
				switchweapon(3);
			}
		}
	}
}
simulated function SwitchToLastWeaponWhenTossed()
{
	local bool bHasMajorWeapon,bHasMinorWeapon,bHasMeleeWeapon,bHasTossWeapon;
	local Weapon MajorWeapon,MinorWeapon,MeleeWeapon,TossWeapon;
	local Inventory Inv;
	local Weapon TempWeapon;
	if(KFXWeapBase(Weapon.OldWeapon).KFXGetWeaponID() >> 16 >=51 && KFXWeapBase(Weapon.OldWeapon).KFXGetWeaponID() >> 16 <=60) //ÈÓ³öÈ¥µÄÊÇÀ×
	{
		if(KFXWeapBase(Weapon.OldWeapon).bHasTossed)
		{}
		else
		{
			return;
		}
	}
	else
	{
		return;
	}
	bHasMajorWeapon = false;
	bHasMinorWeapon = false;
	bHasMeleeWeapon = false;
	bHasTossWeapon  = false;

	for(Inv = Inventory; Inv != none; Inv = Inv.Inventory)
	{
		if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=1 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=30)
		{
			 bHasMajorWeapon = true;
			 MajorWeapon = KFXWeapBase(Inv);
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=31 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=40)
		{
			 bHasMinorWeapon = true;
			 MinorWeapon = KFXWeapBase(Inv);
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=41 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=50)
		{
			 bHasMeleeWeapon = true;
			 MeleeWeapon = KFXWeapBase(Inv);
		}
	}
	if(KFXWeapBase(Weapon.OldWeapon).KFXGetWeaponID() >> 16 >=51 && KFXWeapBase(Weapon.OldWeapon).KFXGetWeaponID() >> 16 <=60) //ÈÓ³öÈ¥µÄÊÇÀ×
	{
		if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=1 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=30)
		{
			if(bHasMinorWeapon)
			{
				Weapon.OldWeapon = MinorWeapon;
			}
			else if(bHasMeleeWeapon)
			{
				Weapon.OldWeapon = MeleeWeapon;
			}
			if(TempWeapon != Weapon.OldWeapon)
			{
				SwitchToLastWeapon();
			}
		}
		else if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=31 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=40)
		{
//             if(bHasMajorWeapon)
//             {
//                 Weapon.OldWeapon = MajorWeapon;
//             }
			 if(bHasMeleeWeapon)
			 {
				Weapon.OldWeapon = MeleeWeapon  ;
			 }
			 if(TempWeapon != Weapon.OldWeapon)
			{
				SwitchToLastWeapon();
			}
		}
		else if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=41 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=50)
		{
//             if(bHasMajorWeapon )
//             {
//                Weapon.OldWeapon = MajorWeapon;
//             }
//             else if(bHasMinorWeapon )
//             {
//                Weapon.OldWeapon = MinorWeapon;
//             }
		}
	}

}
simulated function SwitchGrenade(int WeapID)
{
	local Inventory Invi,Invj;
	local weapon newWeapon;
	if ( CanSwitchWeapon() )
	{
		if ((Level.Pauser != None) || (Inventory == None))
		{
			return;
		}

		if (Weapon != none && KFXWeapBase(Weapon).KFXGetWeaponID() == WeapID)
		{
			Weapon.Reselect();
		}

		for (Invi = Inventory; Invi!=none; Invi = Invj)
		{
			Invj = Invi.Inventory;

			if (KFXWeapBase(Invi).KFXGetWeaponID() == WeapID)
			{
				newWeapon = Weapon(Invi);
				break;
			}
		}

		if ( PendingWeapon != None && PendingWeapon.bForceSwitch )
			return;

		if ( Weapon == None )
		{
			PendingWeapon = newWeapon;
			ChangedWeapon();
		}

		else if ( Weapon != newWeapon || PendingWeapon != None )
		{
			PendingWeapon = newWeapon;
			Weapon.PutDown();
		}
	}
}
function SetWeapon(Weapon weap)
{
	super.SetWeapon(weap);
	//½ÇÉ«ÔÚµ÷ÓÃ SetWeaponÊ±ControllerÓÐ¿ÉÄÜÎª¿Õ
	if ( Controller == none )
	   return;
	if(weap != none)
		KFXPlayerReplicationInfo(Controller.PlayerReplicationInfo).fxCurrWeaponID = KFXWeapBase(weap).KFXGetWeaponID();
	else
		KFXPlayerReplicationInfo(Controller.PlayerReplicationInfo).fxCurrWeaponID = 0;
}
function bool CheckPawnCanHaveThisWeapon(int WeaponID)
{
	return true;
}
simulated function float GetExSoundFactor(float NormalSoundScale)
{
	return  NormalSoundScale * (1+TotalStepSoundVolumeEx);
}
simulated function float GetExSoundRadius(float NormalSoundRadius)
{
	return NormalSoundRadius * (1+TotalStepSoundRadiusEx);
}
simulated function KFXPlayReload(KFXWeapAttachment weap)
{
	super.KFXPlayReload(weap);
	log("[LABOR]--------------play reload!");
	if(weap.sound_attachment_reload != none)
	{
		if(weaponattachment_sound != none)
		{
			KFXStopSound(self, weaponattachment_sound);
		}
		weaponattachment_sound = weap.sound_attachment_reload;
		PlaySound(weaponattachment_sound);
	}

	//FireState = FAS_PlayOnce;
}
simulated function SetWeapAttachment(KFXWeapAttachment NewAtt)
{
	super.SetWeapAttachment(NewAtt);
	//°ó¶¨Íê³ÉÖ®ºó£¬²¥·ÅÇÐÇ¹ÒôÀÖ
	log("[LABOR]------------set weapon attachement!");
	if(NewAtt.sound_attachment_switch != none)
	{
		if(weaponattachment_sound != none)
			KFXStopSound(self, weaponattachment_sound);

		weaponattachment_sound = NewAtt.sound_attachment_switch;
		PlaySound(weaponattachment_sound);
	}
}

exec function KFXSetCollisionSize(int radius,int height)
{
	setCollisionSize(radius,height);
}

defaultproperties
{
     SpecialSkin=Shader'fx_effect_texs.birth.birth_016'
     KFXPawnBitStateEffect(0)="KFXEffects.fx_effect_useitem"
     KFXPawnBitStateEffect(1)="KFXEffects.fx_effect_god"
     KFXPawnBitStateEffect(16)="KFXEffects.fx_effect_topig"
     KFXPawnBitStateEffect(25)="KFXEffects.fx_effect_flames_hitperson"
     KFXPawnOrderEffect(1)="KFXEffects.fx_effect_sliver"
     KFXPawnOrderEffect(2)="KFXEffects.fx_effect_copper"
     KFXCanPickupWeapon=是
     LastDamagedTime=-1.000000
     fMinTimeBetweenTakeHit=0.500000
     HitViewShakeFactor=10.000000
     HasInitWeapon=-1
     m_BufferTimeCounter=-1.000000
     KFXArmingName=Class'KFXGame.Arming'
     KFXBombPrevent=1.000000
     KFXHealthRecoverScale=1.000000
     bCanSmokeEffect=是
     IsRedRole=255
     TotalStepSoundVolumeEx=1.000000
     KFXPlayerId=-1
     FootstepVolume=1.000000
     FootstepRadius=100.000000
     HitSoundVolume=1.000000
     HitSoundRadius=120.000000
     MinTimeBetweenPainSounds=0.350000
     LandedSpeedDownScale=1.000000
     bSoakDebug=是
     bCanBeBaseForPawns=是
     ControllerClass=Class'KFXGame.KFXBot'
     LinkType=RLT_FPWeapon
     LinkData=RTD_Anim
}
