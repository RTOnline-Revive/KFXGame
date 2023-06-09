// ====================================================================
//  Class:  KFXGame.KFXFireBase
//  Creator: Kevin Sun
//  Date: 2007.06.26
//  Description: Base Class of KFX Weapon Fire
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXFireBase extends WeaponFire
	abstract;

//< MuzzleFlash
var float   FlashTime;          // time when muzzleflash will be cleared (set in RenderOverlays())
var float   MuzzleScale;        // scaling of muzzleflash
var float   FlashOffsetY;       // flash center offset from centered Y (as pct. of Canvas Y size)
var float   FlashOffsetX;       // flash center offset from centered X (as pct. of Canvas X size)
var float   FlashLength;        // How long muzzle flash should be displayed in seconds
var float   MuzzleFlashSize;    // size of (square) texture
var byte    FlashCount;         // when incremented, draw muzzle flash for current frame
var bool    bMuzzleFlash;       // if!=0 show first-person muzzle flash
var bool    bSetFlashTime;      // reset FlashTime clock when false
var bool    bDrawMuzzleFlash;   // enable first-person muzzle flash
var TexRotator       MuzzleMaterial;
//> MuzzleFlash

//< Damage
var class<DamageType> DamageType;
var class<DamageType> AltDamageType;
var int     KFXShakeView[2];

// ×´Ì¬ÉËº¦ÐÅÏ¢
struct KFXPBDamageInfo
{
	var int   BitState;
	var float Timer;
	var float Param1;
	var float Param2;
};
var KFXPBDamageInfo KFXPBDamageType[2];

var bool    bCanAutoAim;      // ÊÇ·ñ¿ÉÒÔÊ¹ÓÃ×Ô¶¯Ãé×¼

var float   FrameTime;       // Frame Time
//>

//< fire effect
//var float  AccuracyDivisor;  // Accuracy ¹«Ê½¼ÆËãÏµÊý
//var float  AccuracyOffset;   // Accuracy ¹«Ê½¼ÆËãÏµÊý
//var float  MaxInaccuracy;    // Accuracy ×î´óÖµ

//var float  SpreadFlyFactor; // À©É¢Æ¯ÒÆÏµÊý
var bool   bIsPistol;       // ÊÇ·ñÊÇÊÖÇ¹
var int    ShotsFired;      // ×Óµ¯Á¬ÉäÊýÁ¿
var float  ShotsFiredDecreaseTime; // ×Óµ¯Á¬ÉäÊýÁ¿Ë¥¼õÊ±¼ä
var bool   bDelayFire;      // This variable is used to delay the time between subsequent button pressing.
var float  Accuracy;        // affect spread

var rotator PunchAngle;     // PunchAngle
var rotator PunchAngleVel;  // PunchAngleSpeed
var int     PunchDirection;  // CurrentPunchDirection
//>

//< Cross Hair
var int     KFXCrossHairType;     // Type Of CrossHair
var color   KFXCHColorNormal;
var color   KFXCHColorEnemy;
var color   KFXCHColorFriend;
var float   CrossHairLength;       // cross Hair Affected by Firing
var float   CrossHairSpread;       // cross Hair Affected by Accuracy
var float   CrossHairLengthFireToFill;   // when fire, the length to fill
var float   CrossHairSpreadFireToFill;   // when fire, the spread to fill

var float   CrossHairRaiseFactor[3];
var float   CrossHairDecayFactor[3];

var float   CrossHairMaxLength[3];    // Max length
var float   CrossHairMaxSpread[3];    // Max Spread
var float   CrossHairMinLength[3];    // Min length
var float   CrossHairMinSpread[3];    // Min Spread

var float   CrossHairSpreadCrouch[3];    // Crosshair Spread for state
var float   CrossHairSpreadStand[3];
var float   CrossHairSpreadRun[3];
var float   CrossHairSpreadWalk[3];
var float   CrossHairSpreadJump[3];
var texture KFXCrossHairTex[3];      //×¼¾µµÄ²ÄÖÊ
//>

//< additional anims
var name   EmptyFireAnim;
var float  EmptyFireAnimRate;
//>

var int     ProjPerFire;
var vector  ProjSpawnOffset; // +x forward, +y right, +z up
var float   TossPitchOffset;

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

// ====================================================================
// ¿ª»ð»ù±¾ÊôÐÔ²ÎÊý
// ====================================================================
var int KFXRemainedShots;   // Ê£ÓàµÄShots
var int KFXFireGroup;

var int KFXProjectileID;    // Projectile ID
var int KFXWeaponTrackID;//   weapontrack ID
var int KFXMediaID;
var int KFXFireModeID;
var int KFXDmgTypeID[2];
// ====================================================================
// µ¯µÀÏà¹Ø²ÎÊý
// ====================================================================

// ÓÃÓÚÇø·Öµ¯µÀµÄPawnµÄ×´Ì¬ÊýÁ¿
const KFX_PAWN_STATE_NUM = 5;

///»¤¼×¼õÃâÏµÊýÊý×é´óÐ¡
const KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM = 2;  //< KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM * KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM


// KickBack²ÎÊý½á¹¹
struct KFXKickBackParams
{
	var float up_base;
	var float lateral_base;
	var float up_modifier;
	var float lateral_modifier;
	var float up_max;
	var float lateral_max;
	var int   direction_change;
};

// Spread²ÎÊý½á¹¹
struct KFXSpreadParams
{
	var float Param1;
	var float Param2;
};

// Kickback²ÎÊý±í
var KFXKickBackParams KFXParam_KB1[KFX_PAWN_STATE_NUM];
var KFXKickBackParams KFXParam_KB2[KFX_PAWN_STATE_NUM];

// Spread²ÎÊý±í
var KFXSpreadParams KFXParam_SP1[KFX_PAWN_STATE_NUM];
var KFXSpreadParams KFXParam_SP2[KFX_PAWN_STATE_NUM];

// Accuracy¼ÆËã²ÎÊý
var float KFXAccuracyDivision[2];
var float KFXAccuracyOffset[2];
var float KFXMaxInaccuracy[2];

// Spread¼ÆËã¹«Ê½
var int KFXSpreadType[2];

// FireFlyFactor
var float KFXFireFlyFactor[2];

// transient Values
var float KFXFireSpread;

//<<ÀîÍþ¹ú ¼¼ÄÜCDÊ±¼äÂß¼­
var float CD_Time;                   //¼¼ÄÜµÄCDÊ±¼ä
var float SkillCoolDownTimer;        //CDÊ±¼ä¼ÆÊ±Æ÷

var float UpdateRedCrossHairTime;

var int TrackType;                   //¿ª»ðÄ£Ê½¶ÔÓ¦µÄµ¯ÏßÌØÐ§ 


var bool    PunchHorizonEnable;
var int    FireStartArmmo;
var int CurCornerStaticShotNum;//µ±Ç°µ¯µÀÎª¹Õ½Ç´¦Ê±Í£ÁôµÄ¿ª»ðÊýÁ¿


var int         ShotsFiredDecrease;     //Á¬ÉäÊýÁ¿Ë¥¼õ
var float       AccuracyDecrease;       //¾«¶ÈË¥¼õ
var int         ShotsFiredDecLimit;     //Á¬ÉäÊýÁ¿Ë¥¼õÏÞÖÆ
var float       TimeShotFiredDec;       //Á¬ÉäÊýÁ¿Ë¥¼õÊ±¼ä

var float       TimeLastUpdateCH;

//¿Í»§¶ËÄ£Äâ¿ª»ðÐ§¹û
var float   SimNextFireTime; //Ä£ÄâÏÂ´Î¿ª»ðµÄÊ±¼ä

var int RightFireTimes;
var bool bNeedClientSimulate;
function bool IsSkillCoolDown()
{
	;
	if( Level.TimeSeconds < SkillCoolDownTimer )
		return true;

	return false;
}

function SkillBeginCoolDown()
{
	if ( instigator != none && instigator.Controller != none )
		CD_Time = KFXPlayer( instigator.Controller ).GetPlayerSkillCdTime();
	SkillCoolDownTimer = Level.TimeSeconds + CD_Time;
	;
}
function CSVConfig(array<int> Ids)
{
	KFXWeaponTrackID = Ids[0];
	KFXMediaID = Ids[0];
	KFXFireModeID = Ids[1];
	KFXDmgTypeID[0] = Ids[2];
	KFXDmgTypeID[1] = Ids[3];
	KFXProjectileID = Ids[4];
	csvKFXInit(KFXFireModeID);
}
//>>
// ====================================================================
// FireMode³õÊ¼»¯Âß¼­
// ====================================================================

// KFXFireBaseµÄ³õÊ¼»¯Èë¿Ú
// Client & Server
// TODO: ÐèÒªÓÅ»¯£¬ºÜ¶àÎäÆ÷²»ÐèÒªµ¯µÀ²ÎÊý
// ×¢Òâ£ºÓÉÓÚ»æÖÆ×¼ÐÇÊ±ÏÈµ÷ÓÃÓÒ¼ü¿ª»ðÄ£Ê½µÄ×¼ÐÇ£¬¶øÊµ¼ÊÓÃµÄÊÇ×ó¼ü¿ª»ðÄ£Ê½µÄ×¼ÐÇ
// Òò´ËÓÒ¼ü¿ª»ðÄ£Ê½²»ÐèÒªµ÷ÓÃ´ËÀàµÄKFXInit, Ó¦ÖØÐ´´Ëº¯Êý»ò²»µ÷ÓÃKFXInitCrosshairº¯Êý
simulated function KFXInit( int WeaponID )
{
}
simulated function csvKFXInit( int FireModeID )
{
	local KFXCSVTable CFG_Track, CFG_Media, CFG_DmgType, CFG_Proj,CFG_FireMode;
	local string StateName, TempString;
	local int nTemp, loop;
	local name nAnimTemp;

	CFG_Track       = class'KFXTools'.static.GetConfigTable(16);
	CFG_DmgType     = class'KFXTools'.static.GetConfigTable(21);
	CFG_Proj        = class'KFXTools'.static.GetConfigTable(20);
	CFG_FireMode    = class'KFXTools'.static.GetConfigTable(12);

	if ( !CFG_Track.SetCurrentRow(KFXWeaponTrackID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Track Table): "$KFXWeaponTrackID);
		return;
	}
	if ( !CFG_FireMode.SetCurrentRow(FireModeID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Fire Mode Table): "$FireModeID);
		return;
	}

	// Load DamageType
	nTemp = KFXDmgTypeID[0];//CFG_Weapon.GetInt("DmgType1");
	if ( nTemp != 0 && CFG_DmgType.SetCurrentRow(nTemp) )
	{
		DamageType = class<DamageType>(
			DynamicLoadObject(CFG_DmgType.GetString("Class"), class'Class'));
		KFXShakeView[0]   = CFG_DmgType.GetInt("ShakeView");

		KFXPBDamageType[0].BitState = CFG_DmgType.GetInt("PBState");
		if ( KFXPBDamageType[0].BitState >= 0 )
		{
			KFXPBDamageType[0].Timer    = CFG_DmgType.GetFloat("PBTimer");
			KFXPBDamageType[0].Param1   = CFG_DmgType.GetFloat("PBParam0");
			KFXPBDamageType[0].Param2   = CFG_DmgType.GetFloat("PBParam1");
		}
	}

	nTemp = KFXDmgTypeID[1];//= CFG_Weapon.GetInt("DmgType2");
	if ( nTemp != 0 && CFG_DmgType.SetCurrentRow(nTemp) )
	{
		AltDamageType = class<DamageType>(
			DynamicLoadObject(CFG_DmgType.GetString("Class"), class'Class'));
		KFXShakeView[1]   = CFG_DmgType.GetInt("ShakeView");

		KFXPBDamageType[1].BitState = CFG_DmgType.GetInt("PBState");
		if ( KFXPBDamageType[1].BitState >= 0 )
		{
			KFXPBDamageType[1].Timer    = CFG_DmgType.GetFloat("PBTimer");
			KFXPBDamageType[1].Param1   = CFG_DmgType.GetFloat("PBParam0");
			KFXPBDamageType[1].Param2   = CFG_DmgType.GetFloat("PBParam1");
		}
	}

	// Load Projectile ID
//    KFXProjectileID = CFG_Weapon.GetInt("PJClass1");
	if ( KFXProjectileID != 0 && CFG_Proj.SetCurrentRow(KFXProjectileID) )
	{
		ProjectileClass = class<Projectile>(
			DynamicLoadObject(CFG_Proj.GetString("Class"), class'Class'));
	}
	log("KFXProjectileID:"$CFG_Proj.GetString("Class")$"ProjectileClass:"$ProjectileClass);
	// TODO: PJClass2 ?

	// Load Spread Config
	KFXSpreadType[0] = CFG_Track.GetInt("SP1Type");
	KFXSpreadType[1] = CFG_Track.GetInt("SP2Type");

	KFXFireFlyFactor[0] = CFG_Track.GetFloat("FlyFactor1");
	KFXFireFlyFactor[1] = CFG_Track.GetFloat("FlyFactor2");

	// Load Accuracy config
	KFXAccuracyDivision[0]  = CFG_Track.GetFloat("AccDiv1");
	KFXAccuracyDivision[1]  = CFG_Track.GetFloat("AccDiv2");
	KFXAccuracyOffset[0]    = CFG_Track.GetFloat("AccOff1");
	KFXAccuracyOffset[1]    = CFG_Track.GetFloat("AccOff2");
	KFXMaxInaccuracy[0]     = CFG_Track.GetFloat("MaxInacc1");
	KFXMaxInaccuracy[1]     = CFG_Track.GetFloat("MaxInacc2");

	ShotsFiredDecrease      = CFG_FireMode.GetInt("SF_Dec");
	AccuracyDecrease        = CFG_FireMode.GetFloat("Acc_Dec");

	ShotsFiredDecLimit      = CFG_FireMode.GetFloat("SFDecLimit");
	TimeShotFiredDec        = CFG_FireMode.GetFloat("TimeSFDec");

	// Load Params
	for ( loop = 0; loop < KFX_PAWN_STATE_NUM; loop++ )
	{
		StateName = KFXGetPawnStateString(loop);

		// Kickback Params
		TempString = "KB1_"$StateName;
		KFXParam_KB1[loop].up_base          = CFG_Track.GetFloat(TempString$"1");
		KFXParam_KB1[loop].lateral_base     = CFG_Track.GetFloat(TempString$"2");
		KFXParam_KB1[loop].up_modifier      = CFG_Track.GetFloat(TempString$"3");
		KFXParam_KB1[loop].lateral_modifier = CFG_Track.GetFloat(TempString$"4");
		KFXParam_KB1[loop].up_max           = CFG_Track.GetFloat(TempString$"5");
		KFXParam_KB1[loop].lateral_max      = CFG_Track.GetFloat(TempString$"6");
		KFXParam_KB1[loop].direction_change = CFG_Track.GetInt(TempString$"7");

		TempString = "KB2_"$StateName;
		KFXParam_KB2[loop].up_base          = CFG_Track.GetFloat(TempString$"1");
		KFXParam_KB2[loop].lateral_base     = CFG_Track.GetFloat(TempString$"2");
		KFXParam_KB2[loop].up_modifier      = CFG_Track.GetFloat(TempString$"3");
		KFXParam_KB2[loop].lateral_modifier = CFG_Track.GetFloat(TempString$"4");
		KFXParam_KB2[loop].up_max           = CFG_Track.GetFloat(TempString$"5");
		KFXParam_KB2[loop].lateral_max      = CFG_Track.GetFloat(TempString$"6");
		KFXParam_KB2[loop].direction_change = CFG_Track.GetInt(TempString$"7");

		// Spread Params
		TempString = "SP1_"$StateName;
		KFXParam_SP1[loop].Param1   =   CFG_Track.GetFloat(TempString$"1");
		KFXParam_SP1[loop].Param2   =   CFG_Track.GetFloat(TempString$"2");

		TempString = "SP2_"$StateName;
		KFXParam_SP2[loop].Param1   =   CFG_Track.GetFloat(TempString$"1");
		KFXParam_SP2[loop].Param2   =   CFG_Track.GetFloat(TempString$"2");
	}

	CFG_Media      = class'KFXTools'.static.GetConfigTable(10);

	if ( !CFG_Media.SetCurrentRow(KFXMediaID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Media Table): "$KFXMediaID);
		return;
	}

	// Load Anim
	nAnimTemp = CFG_Media.GetName("PreFireAni");
	if ( nAnimTemp != '0' )
	{
		PreFireAnim = nAnimTemp;
		PreFireAnimRate = CFG_Media.GetFloat("PreFireAniRate");
	}

	nAnimTemp = CFG_Media.GetName("FireAni");
	if ( nAnimTemp != '0' )
	{
		FireAnim = nAnimTemp;
		FireAnimRate = CFG_Media.GetFloat("FireAniRate");
	}

	nAnimTemp = CFG_Media.GetName("FireLoopAni");
	if ( nAnimTemp != '0' )
	{
		FireLoopAnim = nAnimTemp;
		FireLoopAnimRate = CFG_Media.GetFloat("FireLoopAniRate");
	}

	nAnimTemp = CFG_Media.GetName("FireEndAni");
	if ( nAnimTemp != '0' )
	{
		FireEndAnim = nAnimTemp;
		FireEndAnimRate = CFG_Media.GetFloat("FireEndAniRate");
	}

	nAnimTemp = CFG_Media.GetName("EmptyFireAni");
	if ( nAnimTemp != '0' )
	{
		EmptyFireAnim = nAnimTemp;
		EmptyFireAnimRate = CFG_Media.GetFloat("EmptyFireAniRate");
	}

	TweenTime = CFG_Media.GetFloat("TweenTime");

	// Load MuzzleFlash
	TempString = CFG_Media.GetString("MFMaterial");

	if ( !(TempString ~= "null") )
	{
		MuzzleMaterial = TexRotator(
			DynamicLoadObject(TempString, class'TexRotator'));
		MuzzleFlashSize = CFG_Media.GetFloat("MFSize");
		MuzzleScale     = CFG_Media.GetFloat("MFScale");
		FlashOffsetX    = CFG_Media.GetFloat("MFOffsetX");
		FlashOffsetY    = CFG_Media.GetFloat("MFOffsetY");
		FlashLength     = CFG_Media.GetFloat("MFTime");
	}

	// ³õÊ¼»¯×¼ÐÄÅäÖÃÊý¾Ý
	KFXInitCrosshair(CFG_Media);
	PreFireTime = CFG_FireMode.GetFloat("PreFireTime");
	//LOG("KFXFireBase  PreFireTime:"$self$PreFireTime);
}

simulated function KFXInitCrosshair( KFXCSVTable CFG_Media )
{
	local string TempString;

	KFXCrossHairType  = CFG_Media.GetInt("CHType");
	// set 1
	CrossHairRaiseFactor[0] = CFG_Media.GetFloat("CHRaise1");
	CrossHairDecayFactor[0] = CFG_Media.GetFloat("CHDecay1");

	CrossHairMaxLength[0] = CFG_Media.GetFloat("CHShMax1");
	CrossHairMaxSpread[0] = CFG_Media.GetFloat("CHSpMax1");
	CrossHairMinLength[0] = CFG_Media.GetFloat("CHShMin1");
	CrossHairMinSpread[0] = CFG_Media.GetFloat("CHSpMin1");

	CrossHairSpreadJump[0]    = CFG_Media.GetFloat("CHSpJump1");
	CrossHairSpreadRun[0]     = CFG_Media.GetFloat("CHSpRun1");
	CrossHairSpreadWalk[0]    = CFG_Media.GetFloat("CHSpWalk1");
	CrossHairSpreadStand[0]   = CFG_Media.GetFloat("CHSpStand1");
	CrossHairSpreadCrouch[0]  = CFG_Media.GetFloat("CHSpCrouch1");

	TempString = CFG_Media.GetString("CHMaterial1");
	if ( !(TempString ~= "null") )
		KFXCrossHairTex[0] = texture(DynamicLoadObject(TempString, class'texture'));

	// set 2
	CrossHairRaiseFactor[1] = CFG_Media.GetFloat("CHRaise2");
	CrossHairDecayFactor[1] = CFG_Media.GetFloat("CHDecay2");

	CrossHairMaxLength[1] = CFG_Media.GetFloat("CHShMax2");
	CrossHairMaxSpread[1] = CFG_Media.GetFloat("CHSpMax2");
	CrossHairMinLength[1] = CFG_Media.GetFloat("CHShMin2");
	CrossHairMinSpread[1] = CFG_Media.GetFloat("CHSpMin2");

	CrossHairSpreadJump[1]    = CFG_Media.GetFloat("CHSpJump2");
	CrossHairSpreadRun[1]     = CFG_Media.GetFloat("CHSpRun2");
	CrossHairSpreadWalk[1]    = CFG_Media.GetFloat("CHSpWalk2");
	CrossHairSpreadStand[1]   = CFG_Media.GetFloat("CHSpStand2");
	CrossHairSpreadCrouch[1]  = CFG_Media.GetFloat("CHSpCrouch2");

	TempString = CFG_Media.GetString("CHMaterial2");
	if ( !(TempString ~= "null") )
		KFXCrossHairTex[1] = texture(DynamicLoadObject(TempString, class'texture'));

	// set 3
	CrossHairRaiseFactor[2] = CFG_Media.GetFloat("CHRaise3");
	CrossHairDecayFactor[2] = CFG_Media.GetFloat("CHDecay3");

	CrossHairMaxLength[2] = CFG_Media.GetFloat("CHShMax3");
	CrossHairMaxSpread[2] = CFG_Media.GetFloat("CHSpMax3");
	CrossHairMinLength[2] = CFG_Media.GetFloat("CHShMin3");
	CrossHairMinSpread[2] = CFG_Media.GetFloat("CHSpMin3");

	CrossHairSpreadJump[2]    = CFG_Media.GetFloat("CHSpJump3");
	CrossHairSpreadRun[2]     = CFG_Media.GetFloat("CHSpRun3");
	CrossHairSpreadWalk[2]    = CFG_Media.GetFloat("CHSpWalk3");
	CrossHairSpreadStand[2]   = CFG_Media.GetFloat("CHSpStand3");
	CrossHairSpreadCrouch[2]  = CFG_Media.GetFloat("CHSpCrouch3");

	TempString = CFG_Media.GetString("CHMaterial3");
	if ( !(TempString ~= "null") )
		KFXCrossHairTex[2] = texture(DynamicLoadObject(TempString, class'texture'));
}

// ====================================================================
// µ¯µÀ¼ÆËãÏà¹Ø²ÎÊý
// ====================================================================

// È¡µÃPawn×´Ì¬ºÅ¶ÔÓ¦µÄ×Ö·û´®
simulated function string KFXGetPawnStateString(int nState)
{
	// Jumping
	if ( nState == 0 )
		return "Jump";

	// Running
	else if ( nState == 1 )
		return "Run";

	// Walking
	else if ( nState == 2 )
		return "Walk";

	// Crouched
	else if ( nState == 3 )
		return "Stand";

	// Standing
	else if ( nState == 4 )
		return "Crouch";

	return "";
}

// È¡µÃPawnµ±Ç°×´Ì¬ºÅ
simulated function int KFXGetPawnState()
{
	// Jumping
	if ( Instigator.Physics != PHYS_Walking )
		return 0;

	// Running
	else if ( VSize(Instigator.Velocity) > 10 && KFXPlayer(Instigator.Controller).bRun == 0)///(Instigator.WalkingPct * Instigator.GroundSpeed + 10) )
		return 1;

	// Walking
	else if ( VSize(Instigator.Velocity) > 10 && KFXPlayer(Instigator.Controller).bRun == 1)
		return 2;

	// Standing
	else if ( !Instigator.bIsCrouched )
		return 3;

	// Crouched
	else
		return 4;
}

// »ñÈ¡ÁíÍâÒ»ÖÖÉä»÷Ä£Ê½
simulated function KFXFireBase KFXGetOtherFireMode()
{
	if ( ThisModeNum == 0 )
		return KFXWeapBase(Weapon).KFXGetFireMode(1);
	else
		return KFXWeapBase(Weapon).KFXGetFireMode(0);
}

// KickBack¼ÆËã
simulated function KFXCalcKickback()
{
	local KFXKickBackParams KBParam;

	KFXGetKBParam(KBParam);

	KickBack (
		KBParam.up_base,
		KBParam.lateral_base,
		KBParam.up_modifier,
		KBParam.lateral_modifier,
		KBParam.up_max,
		KBParam.lateral_max,
		KBParam.direction_change );

}

// ¼ÆËãÀ©É¢¶È£¬¾«¶È¹«Ê½(×ÓÀàÊµÏÖ)
simulated function KFXCalcSpread();
simulated function KFXCalcAccuracy();

// ====================================================================
// ×¼ÐÇ×´Ì¬Âß¼­
// ====================================================================

// Draw CrossHair
// Client Only
simulated function bool KFXDrawCrossHair(Canvas C)
{
	local float CenterX, CenterY, UL, VL;
	local Actor TraceActor;
	local color CrossHairColor;
	local byte CrosshairIndex;
	local KFXPlayer Player;
	local int bold; //×¼ÐÇ¿í¶È
	local bool bEnermy;
	bEnermy = false;
	if ( Instigator.Controller != none )
	{
		Player = KFXPlayer(Instigator.Controller);
	}

	if ( Player != none)
	{
		CrosshairIndex = KFXPlayer(Instigator.Controller).KFXCrosshairSizeIndex;
	}


	CenterX = C.SizeX * 0.5;
	CenterY = C.SizeY * 0.5;

	// CrossHair color
	if(Instigator==none||Instigator.Controller==none)
	return false;

	TraceActor = KFXHud(KFXPlayer(Instigator.Controller).myHUD).KFXLastTraceViewActor;

	if ( Player.CrossHairDrawType == 3 )
	{
		TraceActor = none;
		KFXGetTraceActor(TraceActor);
	}

	if ( KFXPawn(TraceActor) != none && !KFXPawn(TraceActor).bTearOff && KFXPawn(TraceActor) != Instigator )
		{
			if( KFXPawn(Instigator).KFXInTheSameTeam(KFXPawn(TraceActor) ))
				C.DrawColor = KFXCHColorFriend;
			else if ( Player.CrossHairDrawType == 2 )
			{
				if ( !bIsFiring || ShotsFired == 0 )
				{
					log("[KFXFireBase]  DrawCrossHair  ShotsFired"$ShotsFired);
					TimeLastUpdateCH = 0;
					C.DrawColor = KFXCHColorNormal;
				}
				else if ( TimeLastUpdateCH == 0 )
				{
					TimeLastUpdateCH = Level.TimeSeconds + 1.0;
				}
				else if ( Level.TimeSeconds > TimeLastUpdateCH )
				{
					C.DrawColor = KFXCHColorNormal;
				}
				else
				{
					C.DrawColor = KFXCHColorEnemy;
					bEnermy = true;
				}
			}
			else
			{
				C.DrawColor = KFXCHColorEnemy;;
				bEnermy = true;

			}
	}
	else
	{
		C.DrawColor = KFXCHColorNormal;
	}



	C.Style = 5;

	bold = 2;   //×¼ÐÇ¿í¶È£¬Ä¬ÈÏÎª1

	switch (KFXCrossHairType)
	{
	case -1: //none
		return false;
	case 1:
		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
		break;
	case 2:
		// center
		C.SetPos(CenterX-bold/2, CenterY-bold/2);
		C.DrawLine(3, bold, bold);

		// up
		C.SetPos(CenterX-bold/2, CenterY - CrossHairSpread);
		C.DrawLine(0, CrossHairLength, bold);

		// down
		C.SetPos(CenterX-bold/2, CenterY + CrossHairSpread + 1);
		C.DrawLine(1, CrossHairLength, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
	case 3:
		// center
		C.SetPos(CenterX-bold/2, CenterY-bold/2);
		C.DrawLine(3, bold, bold);

		// down
		C.SetPos(CenterX-bold/2, CenterY + CrossHairSpread + 1);
		C.DrawLine(1, CrossHairLength, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
		break;
	case 4:
		// center
		C.SetPos(CenterX-bold/2, CenterY-bold/2);
		C.DrawLine(3, bold, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
		break;
	case 5:
		// center
		C.SetPos(CenterX - 1, CenterY - 1 - bold/2);
		C.DrawLine(3, 3, bold);
		C.SetPos(CenterX - 1, CenterY - bold/2);
		C.DrawLine(3, 3, bold);
		C.SetPos(CenterX - 1, CenterY + 1 - bold/2);
		C.DrawLine(3, 3, bold);
		break;
	case 6:
		if ( KFXPawn(TraceActor) != none && !KFXPawn(TraceActor).bTearOff && KFXPawn(TraceActor) != Instigator )
				{
					if( KFXPawn(Instigator).KFXInTheSameTeam(KFXPawn(TraceActor) ))
					{
						C.DrawColor = KFXCHColorFriend;
					}

					else
					{
						C.DrawColor = KFXCHColorEnemy;
						bEnermy = true;
					}
		}
		else
		{
			if ( KFXPlayer(Instigator.Controller).KFXCrosshairColorType == 1 )
			{
				CrossHairColor.R = 0xff;
				CrossHairColor.G = 0xd3;
				CrossHairColor.B = 0x0b;
				CrossHairColor.A = 0xff;
				C.DrawColor = CrossHairColor;
			}
			else if ( KFXPlayer(Instigator.Controller).KFXCrosshairColorType == 2 )
			{
				CrossHairColor.R = 0x00;
				CrossHairColor.G = 0xd8;
				CrossHairColor.B = 0xfd;
				CrossHairColor.A = 0xff;
				C.DrawColor = CrossHairColor;
			}
			else
			{
				CrossHairColor.R = 0x03;
				CrossHairColor.G = 0xf3;
				CrossHairColor.B = 0x01;
				CrossHairColor.A = 0xff;
				C.DrawColor = CrossHairColor;
			}
		}
		if ( KFXPlayer(Instigator.Controller).KFXCrosshairShapeType == 0 )
		{
			// up
			C.SetPos(CenterX - bold/2, CenterY - CrossHairSpread);
			C.DrawLine(0, CrossHairLength, bold);

			// down
			C.SetPos(CenterX - bold/2, CenterY + CrossHairSpread + 1);
			C.DrawLine(1, CrossHairLength, bold);

			// left
			C.SetPos(CenterX - CrossHairSpread, CenterY - bold/2);
			C.DrawLine(2, CrossHairLength, bold);

			// right
			C.SetPos(CenterX + CrossHairSpread + 1, CenterY - bold/2);
			C.DrawLine(3, CrossHairLength, bold);
		}
		else if ( KFXPlayer(Instigator.Controller).KFXCrosshairShapeType == 1 )
		{
			// center
			C.SetPos(CenterX-bold/2, CenterY-bold/2);
			C.DrawLine(3, bold, bold);

			// up
			C.SetPos(CenterX - bold/2, CenterY - CrossHairSpread);
			C.DrawLine(0, CrossHairLength, bold);

			// down
			C.SetPos(CenterX - bold/2, CenterY + CrossHairSpread + 1);
			C.DrawLine(1, CrossHairLength, bold);

			// left
			C.SetPos(CenterX - CrossHairSpread, CenterY - bold/2);
			C.DrawLine(2, CrossHairLength, bold);

			// right
			C.SetPos(CenterX + CrossHairSpread + 1, CenterY - bold/2);
			C.DrawLine(3, CrossHairLength, bold);
		}
		else if ( KFXPlayer(Instigator.Controller).KFXCrosshairShapeType == 2 )
		{
			//CrossHairTex = texture(DynamicLoadObject("fx_ui3_texs.crosshair_c", class'texture'));
			if ( KFXCrossHairTex[CrosshairIndex] != none )
			{
				CenterX = C.SizeX * 0.5;
				CenterY = C.SizeY * 0.5;
				UL = KFXCrossHairTex[CrosshairIndex].USize;
				VL = KFXCrossHairTex[CrosshairIndex].VSize;
				C.SetPos(CenterX - UL / 2, CenterY - VL / 2);
				C.DrawTile(KFXCrossHairTex[CrosshairIndex], UL, VL, 0, 0, UL, VL);
			}
		}
		break;
	case 10:
		// DrawTile
		if ( KFXCrossHairTex[CrosshairIndex] != none )
		{
			CenterX = C.SizeX * 0.5;
			CenterY = C.SizeY * 0.5;
			UL = KFXCrossHairTex[CrosshairIndex].USize;
			VL = KFXCrossHairTex[CrosshairIndex].VSize;
			C.SetPos(CenterX - UL / 2, CenterY - VL / 2);
			C.DrawTile(KFXCrossHairTex[CrosshairIndex], UL, VL, 0, 0, UL, VL);
		}
		break;
	default:
		// up
		C.SetPos(CenterX - bold/2, CenterY - CrossHairSpread);
		C.DrawLine(0, CrossHairLength, bold);

		// down
		C.SetPos(CenterX - bold/2, CenterY + CrossHairSpread + 1);
		C.DrawLine(1, CrossHairLength, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY - bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY - bold/2);
		C.DrawLine(3, CrossHairLength, bold);
	}
	if(KFXHUD(KFXPlayer(Instigator.Controller).myHUD).bDrawKnifeAttack)
	{
		 KFXDrawKnifeAttackInfo(C,TraceActor,bEnermy);
	}
	return true;
}
function KFXDrawKnifeAttackInfo(Canvas C,Actor TraceActor,bool bEnermy);
//client only with spread
function bool KFXGetTraceActor( out Actor TraceActor )
{
	local vector TraceX, StartTrace, End, ShootX, ShootY, ShootZ;
	local float dx, dy;
	local float TraceRange;
	local int iPawnState;
	local float  FireSpread;
	local int i, j;
	local vector HitLocation, HitNormal;
	local float MaxInAcc;
	local float FlyFactor;
	local KFXSpreadParams spParam;

	if ( TraceActor != none )
		return true;

	log("[KFXFireBase] KFXGetTraceActor Check Corner");

	StartTrace = Instigator.Location + Instigator.EyePosition();

	iPawnState = KFXGetPawnState();
	KFXGetSPParam(spParam);

	FireSpread = spParam.Param1 + spParam.Param2 * Accuracy;

	TraceRange = KFXWeapBase(Weapon).KFXGetRange();
	Weapon.GetAxes(Weapon.Rotation, ShootX, ShootY, ShootZ);

	if ( ShotsFired > 1 )
	{
		MaxInAcc = KFXGetMaxInaccuracy();
		FlyFactor = KFXGetFireFlyFactor();
		if ( MaxInAcc != 0 )
			dy += ( Accuracy / MaxInAcc )
				* FlyFactor;
	}
	End = StartTrace + vector(Instigator.Rotation) * 8192.0;
	TraceActor = Trace(HitLocation, HitNormal, End, StartTrace, true);
	if ( TraceActor != none && Pawn(TraceActor)!=none && TraceActor != self.Instigator)
	{
		log("[KFXFireBase]  Find  New TraceActor"$TraceActor);
		return true;
	}

	for ( i = 0; i<2; i++ )
	{
		for ( j = 0; j<2; j++ )
		{
			dx = 0.5 - i;
			dy = 0.5 - i;

			TraceX = ShootX
				+ FireSpread * dx * ShootY
				+ FireSpread * dy * ShootZ;

			End = StartTrace + 8192 * TraceX;
			TraceActor = Trace(HitLocation, HitNormal, End, StartTrace, true);
			if ( TraceActor != none && Pawn(TraceActor)!=none && TraceActor != self.Instigator)
			{
				log("[KFXFireBase]  Find  New TraceActor"$TraceActor$"at i:"$i$"j"$j);
				return true;
			}
		}
	}
	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function FlashMuzzleFlash()
{
	bMuzzleFlash = true;
	bSetFlashTime = false;
}

function KFXDrawMuzzleFlash(Canvas Canvas)
{
	local float ULength, VLength, UStart, VStart;
	local float ScaledFlash;

	MuzzleMaterial.Rotation.Yaw = Rand(8) * 8192;

	UStart = 0;
	VStart = 0;
	ULength = MuzzleMaterial.UOffset * 2;
	VLength = MuzzleMaterial.VOffset * 2;
	ScaledFlash = MuzzleFlashSize * MuzzleScale * Canvas.ClipX / 1024.0;

	Canvas.Style = Weapon.ERenderStyle.STY_Translucent;

	Canvas.SetPos(
		0.5 * (Canvas.ClipX - ScaledFlash) + Canvas.ClipX * FlashOffsetX * Weapon.Instigator.Controller.Handedness,
		0.5 * (Canvas.ClipY - ScaledFlash) + Canvas.ClipY * FlashOffsetY);

	Canvas.DrawTile(
		MuzzleMaterial,
		ScaledFlash,
		ScaledFlash,
		UStart, VStart,
		ULength, VLength);

	Canvas.Style = Weapon.ERenderStyle.STY_Normal;
}

function DrawMuzzleFlash(Canvas Canvas)
{
	if ( bMuzzleFlash && bDrawMuzzleFlash && (MuzzleMaterial != None) )
	{
		if ( !bSetFlashTime )
		{
			FlashTime = Level.TimeSeconds + FlashLength;
			bSetFlashTime = true;
		}
		else if ( FlashTime < Level.TimeSeconds )
			bMuzzleFlash = false;

		if ( bMuzzleFlash )
		{
			KFXDrawMuzzleFlash(Canvas);
		}
	}
	else
		bSetFlashTime = false;
}

////////////////////////  for cs weapon effect head ///////////////////////////

// real fire entry
// owner client & server
event ModeDoFire()
{

	KFXFireGroup = KFXWeapBase(Weapon).KFXGetFireGroup();
	log("KFXFireToss-----4343 ");
    if (!AllowFire())
		return;
    log("KFXFireToss-----MaxHoldTime "$MaxHoldTime);
	if (MaxHoldTime > 0.0)
		HoldTime = FMin(HoldTime, MaxHoldTime);
	KFXWeapBase(Weapon).bStartFire = true;
	KFXFireEntry();

    //ÎÞÏÞ×Óµ¯¸Ä±ä´úÂë
    if(Instigator.IsA('KFXCmdPawn') || Instigator.IsA('KFXMutatePawn'))
	{
    	if(!KFXWeapBase(Weapon).bIsReload && KFXWeapBase(Weapon).KFXGetReload() > KFXWeapBase(Weapon).KFXGetSimReload() && KFXWeapBase(Weapon).KFXGetSimReload() == 0)
    	{
           KFXWeapBase(Weapon).ErrorReloadNum++;
           log("KFXWeapBase-------ErrorReloadNum "$KFXWeapBase(Weapon).ErrorReloadNum$"   KFXGetReload(): "$KFXWeapBase(Weapon).KFXGetReload()$"   KFXGetSimReload(): "$KFXWeapBase(Weapon).KFXGetSimReload());
           if(KFXWeapBase(Weapon).ErrorReloadNum > KFXWeapBase(Weapon).KFXGetReload())
           {
               KFXWeapBase(Weapon).KFXSetReload(0);
				KFXWeapBase(Weapon).ErrorReloadNum = 0;
           }
        }
    }

	HoldTime = 0;

	if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
	{
		bIsFiring = false;
		Weapon.PutDown();
	}

	if ( Weapon.Role == ROLE_Authority )
	{
		if ( Weapon.nMultiFireAmmo == 0 && Weapon.bMultiFireMode )
		{

			Weapon.ServerStopFire(0);
		}
	}
}

// AllowFire?
// Client & Server
simulated function bool AllowFire()
{
	log("KFXFireBase-----KFXPawn(Instigator).bCanFire "$KFXPawn(Instigator).bCanFire);
	log("KFXFireBase-----KFXWeapBase(Weapon).KFXHasReload() "$KFXWeapBase(Weapon).KFXHasReload());

    return KFXPawn(Instigator).bCanFire&& KFXWeapBase(Weapon).KFXHasReload();
}

// KFX Fire Entry
// owner client & server
simulated function KFXFireEntry();

//----client only
simulated function bool KFXNotifySuccFire();

///// ÖÓ:»úÆ÷ÈËÈ¡µÃ¼ÜÇ¹¹¦ÄÜÏà¹Ø
simulated function KFXBotDeploy();
simulated function KFXBotUndeploy();
simulated function bool KFXBotGetDeploy();

// Trace Fire Entry
// server & owner client predict
simulated function KFXTraceFire()
{
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//local PlayerController P;
	local Controller P;
	local Rotator Aim;    //¼ÓÈëÁË»úÆ÷ÈË¸ù¾ÝÄ¿±êÎ»ÖÃµ÷ÕûÇ¹¿ÚµÄ¹¦ÄÜ
	//>>
	local vector StartTrace;

	// Do auto aim
	if ( bCanAutoAim && Instigator.IsLocallyControlled() )
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
		if( KFXPlayer(Instigator.Controller) != none )
			KFXPlayer(Instigator.Controller).KFXFireAutoAim();
		//KFXPlayer(Instigator.Controller).KFXFireAutoAim();
	//>>

	// Make Noise
	Instigator.MakeNoise(1.0);

	// the to-hit trace always starts right in front of the eye
	StartTrace = Instigator.Location + Instigator.EyePosition();

	// get view rotation
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//P = PlayerController(Instigator.Controller);
	P = Instigator.Controller;
	//>>

	if ( P == none )
		return;

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//if ( p.bBehindView )
	//    KFXDoTrace(StartTrace, Instigator.Rotation);
	//else
	//    KFXDoTrace(StartTrace, p.Rotation);
	if ( PlayerController(p) != none&&PlayerController(p).bBehindView )
		KFXDoTrace(StartTrace, Instigator.Rotation);
	else
	{
		if( KFXBot(p) != none )
		{
			Aim = AdjustAim(StartTrace, 0); //Ìí¼ÓÁË¸ù¾ÝÄ¿±êµ÷ÕûÇ¹¿ÚµÄ¹¦ÄÜ
			KFXDoTrace(StartTrace, Aim);
		}
		else
			KFXDoTrace(StartTrace, p.Rotation);
	}
	//>>
}

function projectile KFXSpawnProjectile(Vector Start, Rotator Dir,optional KFXPawn EnemyPerson)
{
	local Projectile p;
	local vector X, Y, Z;
	local float pawnSpeed;
	local int loop;

	// Set Pitch Offset
	Dir.Pitch += TossPitchOffset;
	log("ProjectileClass"$ProjectileClass$"DamageType"$DamageType);
	if( ProjectileClass != None )
	{
		p = Weapon.Spawn(ProjectileClass,,, Start, Dir);

		if ( KFXProjectile(p) != none )
		{
			KFXProjectile(p).KFXProjectileID = KFXProjectileID;
			KFXProjectile(p).KFXInit();
			KFXProjectile(p).KFXWeaponID = KFXWeapBase(Weapon).KFXGetWeaponID();
			KFXProjectile(p).KFXArmorPct = KFXWeapBase(Weapon).KFXGetArmorPct();
			KFXProjectile(p).KFXDmgShakeView  = KFXShakeView[KFXFireGroup];
			KFXProjectile(p).KFXPBDamageType = KFXPBDamageType[KFXFireGroup];

			for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
			{
				KFXProjectile(p).KFXArmorWeaponPct[loop] = KFXWeapBase(Weapon).KFXGetWeapArmorPct(loop);
			}

			for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
			{
				KFXProjectile(p).KFXDmgArmorPct[loop] = KFXWeapBase(Weapon).KFXGetDmgArmorPct(loop);
			}
		}
	}
	log("KFXFireBase------Spawn Projectile Is P "$P$"ProjectileClass"$ProjectileClass);
	if( p == none )
	{
		log("KFXFireBase-------Spawn Projectile Failed");
		return None;
	}

	// Set Damage Info
	p.Damage        = KFXWeapBase(Weapon).KFXGetDamage();
	p.DamageRadius  = KFXWeapBase(Weapon).KFXGetRange();
	p.Damage       *= DamageAtten;

	// µþ¼ÓPawnµÄËÙ¶È
	Weapon.GetViewAxes(X,Y,Z);
	pawnSpeed = X dot Instigator.Velocity;
	p.Velocity = p.Speed * Vector(Dir);

	return p;
}

// Calculate Trace Direction for Do Trace
// server & owner client predict
simulated function KFXCalcTrace(
	out vector TraceX, out vector End,
	vector Start, rotator Dir, optional float TraceRange);

// Do Real Trace Fire
// server & owner client predict
simulated function KFXDoTrace(Vector Start, Rotator Dir);

// KFX Trace Pawn
// Client only
simulated function bool KFXClientTracePawn(
	Actor TraceActor, out float Damage,out float HealthVP,                           //DamageÊÇÒª´«µÝ¸ø·þÎñÆ÷µÄ£¬ËùÒÔÊÇout
	vector HitDir, vector HitLocation, vector HitNormal,
	vector TraceStart, vector TraceEnd, int CrossWallTimes)
{
	local KFXPawn Other;
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//local KFXPlayer Ctrl;
	local Controller Ctrl;
	//>>
	local int HitBoxID;
	local int loop,HitLength;
	local vector Dir;
	Other = KFXPawn(TraceActor);
	Dir = Normal( TraceEnd - TraceStart );

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot  ÎªÁË·ÀÖ¹ Ctrl == noneÅÐ¶¨²»¹ý·µ»Ø
	//Ctrl = KFXPlayer(Instigator.Controller);
	Ctrl = Instigator.Controller;

	//>>
	//---------ÉèÖÃtraceÊÇ·ñ¼ÆËãÍÅ¶ÓÉËº¦
	if ( Level.NetMode == NM_Standalone )
	{
	}
	else if( Other == none || Ctrl == none
		|| ( KFXPawn(TraceActor).KFXInTheSameTeam(KFXPawn(Instigator)) && ( !KFXPawn(Instigator).KFXCalcMeleeDamage || !KFXGameInfo(Level.Game).GetGameOptFlag(0))) )
		return false;

	if ( (Other.bUseHitboxDamage && !Other.bTearOff) || Level.NetMode == NM_Standalone )
	{
		HitBoxID = Other.TraceHitBox(TraceEnd /*+ 2*Dir*TraceActor.CollisionRadius*/, TraceStart);
//        if(KFXPlayer(Ctrl).bGodLike)
//        {
//            HitBoxID = 2;
//        }
		if ( HitBoxID == -1 )
		{
			;
			return false;
		}
		Other.KFXDmgInfo.HitBoxID = HitBoxID;
		log("Head box hit");
	}
	else
	{
		Other.KFXDmgInfo.HitBoxID = 0;
	}
	if ( Level.NetMode == NM_Standalone )
	{
		HitLength = KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList.Length;
		KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList[HitLength-1].HitboxIndex = HitBoxID;
	}

//    log("Other.KFXDmgInfo.HitBoxID"$Other.KFXDmgInfo.HitBoxID);
//
//    log("KFXFireBase----2-----Weapon.bClientSimuFire"$Weapon.bClientSimuFire);


	Other.KFXDmgInfo.WeaponID       = KFXWeapBase(Weapon).KFXGetWeaponID();
	Other.KFXDmgInfo.ArmorPct       = KFXWeapBase(Weapon).KFXGetArmorPct();
	Other.KFXDmgInfo.DmgShakeView   = KFXShakeView[KFXFireGroup];
	Other.KFXDmgInfo.HeadKillProp   = KFXWeapBase(Weapon).KFXGetHeadKillProp();
	Other.KFXDmgInfo.AddHeadKill    = KFXWeapBase(Weapon).KFXGetAddHeadKill();
	Other.KFXDmgInfo.ReHeadKill     = KFXWeapBase(Weapon).KFXGetReHeadKill();

	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXArmorWeaponPct[loop] = KFXWeapBase(Weapon).KFXGetWeapArmorPct(loop);
		;
	}
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXDmgArmorPct[loop] = KFXWeapBase(Weapon).KFXGetDmgArmorPct(loop);
	}
	Other.KFXDmgInfo.bAutoAim = 0;
	Other.SpeedDownFactor = KFXWeapBase(Weapon).KFXGetSpeedDownFactor();
	Other.SpeedDownTime = KFXWeapBase(Weapon).KFXGetSpeedDownTime();

	// Take Damage
	if ( KFXFireGroup == 0 || AltDamageType == none )
	{
		if ( CrossWallTimes>0 )
		{
			Other.ClientTakeDamage(HealthVP,Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, class'KFXGame.KFXDmgTypeCrossWall');
		}
		else
			Other.ClientTakeDamage(HealthVP,Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, DamageType);

	}
	else
	{
		if ( CrossWallTimes>0 )
		{
			Other.ClientTakeDamage(HealthVP,Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, class'KFXGame.KFXDmgTypeCrossWall');
		}
		else
		{
			Other.ClientTakeDamage(HealthVP,Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, AltDamageType);
		}
	}

	// Take PBState
	if ( KFXPBDamageType[KFXFireGroup].BitState >= 0 )
	{
		if ( KFXFireGroup == 0 || AltDamageType == none )
			Other.KFXTakePBDamage(Instigator, DamageType,
				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
		else
			Other.KFXTakePBDamage(Instigator, AltDamageType,
				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
	}

	//Clear Damage Info
//    Other.KFXDmgInfo.WeaponID = 0;
//    Other.KFXDmgInfo.ArmorPct  = 0;
//    Other.KFXDmgInfo.bAutoAim = 0;
//    Other.KFXDmgInfo.HitBoxID = 0;
//    Other.KFXDmgInfo.HeadKillProp = 0;
//    Other.KFXDmgInfo.DmgShakeView = 0;
//    ///»¤¼×ÐÅÏ¢¹é0
//    for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
//    {
//        Other.KFXArmorWeaponPct[loop] = 0;
//    }
//    for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
//    {
//        Other.KFXDmgArmorPct[loop] = 0;
//    }

	return true;
}

// KFX Trace Pawn
// server only
function bool KFXTracePawn(
	Actor TraceActor, out float Damage,
	vector HitDir, vector HitLocation, vector HitNormal,
	vector TraceStart, vector TraceEnd, int CrossWallTimes)
{
	local KFXPawn Other;
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//local KFXPlayer Ctrl;
	local Controller Ctrl;
	//>>
	local int HitBoxID;
	local int loop,HitLength;
	local vector Dir;

	Other = KFXPawn(TraceActor);
	Dir = Normal( TraceEnd - TraceStart );

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot  ÎªÁË·ÀÖ¹ Ctrl == noneÅÐ¶¨²»¹ý·µ»Ø
	//Ctrl = KFXPlayer(Instigator.Controller);
	Ctrl = Instigator.Controller;

	//>>
	//---------ÉèÖÃtraceÊÇ·ñ¼ÆËãÍÅ¶ÓÉËº¦
	if ( Level.NetMode == NM_Standalone )
	{
	}
	else if( Other == none || Ctrl == none
		|| ( KFXPawn(TraceActor).KFXInTheSameTeam(KFXPawn(Instigator)) && ( !KFXPawn(Instigator).KFXCalcMeleeDamage || !KFXGameInfo(Level.Game).GetGameOptFlag(0))) )
		return false;

	if ( (Other.bUseHitboxDamage && !Other.bTearOff) || Level.NetMode == NM_Standalone )
	{
		HitBoxID = Other.TraceHitBox(TraceEnd /*+ 2*Dir*TraceActor.CollisionRadius*/, TraceStart);

		if ( HitBoxID == -1 )
		{
			;
			return false;
		}
		Other.KFXDmgInfo.HitBoxID = HitBoxID;
	}
	else
	{
		Other.KFXDmgInfo.HitBoxID = 0;
	}
	if ( Level.NetMode == NM_Standalone )
	{
		HitLength = KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList.Length;
		KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList[HitLength-1].HitboxIndex = HitBoxID;
	}

	Other.KFXDmgInfo.WeaponID       = KFXWeapBase(Weapon).KFXGetWeaponID();
	Other.KFXDmgInfo.ArmorPct       = KFXWeapBase(Weapon).KFXGetArmorPct();
	Other.KFXDmgInfo.DmgShakeView   = KFXShakeView[KFXFireGroup];
	Other.KFXDmgInfo.HeadKillProp   = KFXWeapBase(Weapon).KFXGetHeadKillProp();
	Other.KFXDmgInfo.AddHeadKill    = KFXWeapBase(Weapon).KFXGetAddHeadKill();
	Other.KFXDmgInfo.ReHeadKill     = KFXWeapBase(Weapon).KFXGetReHeadKill();
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXArmorWeaponPct[loop] = KFXWeapBase(Weapon).KFXGetWeapArmorPct(loop);
		;
	}
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXDmgArmorPct[loop] = KFXWeapBase(Weapon).KFXGetDmgArmorPct(loop);
	}
	Other.KFXDmgInfo.bAutoAim = 0;
	Other.SpeedDownFactor = KFXWeapBase(Weapon).KFXGetSpeedDownFactor();
	Other.SpeedDownTime = KFXWeapBase(Weapon).KFXGetSpeedDownTime();

	// Take Damage
	if ( KFXFireGroup == 0 || AltDamageType == none )
	{
		if ( CrossWallTimes>0 )
		{
			Other.TakeDamage(Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, class'KFXGame.KFXDmgTypeCrossWall');
		}
		else
			Other.TakeDamage(Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, DamageType);

	}
	else
	{
		if ( CrossWallTimes>0 )
		{
			Other.TakeDamage(Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, class'KFXGame.KFXDmgTypeCrossWall');
		}
		else
		{
			Other.TakeDamage(Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, AltDamageType);
		}
	}

	// Take PBState
	if ( KFXPBDamageType[KFXFireGroup].BitState >= 0 )
	{
		if ( KFXFireGroup == 0 || AltDamageType == none )
			Other.KFXTakePBDamage(Instigator, DamageType,
				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
		else
			Other.KFXTakePBDamage(Instigator, AltDamageType,
				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
	}

	// Clear Damage Info
	Other.KFXDmgInfo.WeaponID = 0;
	Other.KFXDmgInfo.ArmorPct  = 0;
	Other.KFXDmgInfo.bAutoAim = 0;
	Other.KFXDmgInfo.HitBoxID = 0;
	Other.KFXDmgInfo.HeadKillProp = 0;
	Other.KFXDmgInfo.DmgShakeView = 0;
	///»¤¼×ÐÅÏ¢¹é0
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXArmorWeaponPct[loop] = 0;
	}
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXDmgArmorPct[loop] = 0;
	}

	return true;
}

function bool TakeActorDamage( Actor TraceActor, float Damage,
	vector HitDir, vector HitLocation, vector HitNormal)
{
	local KFXPawn Other;
	local Controller Ctrl;
	local int loop;

	Other = KFXPawn(TraceActor);
	Ctrl = Instigator.Controller;

	Other.KFXDmgInfo.WeaponID       = KFXWeapBase(Weapon).KFXGetWeaponID();
	Other.KFXDmgInfo.ArmorPct       = KFXWeapBase(Weapon).KFXGetArmorPct();
	Other.KFXDmgInfo.DmgShakeView   = KFXShakeView[KFXFireGroup];
	Other.KFXDmgInfo.HeadKillProp   = KFXWeapBase(Weapon).KFXGetHeadKillProp();
	Other.KFXDmgInfo.AddHeadKill    = KFXWeapBase(Weapon).KFXGetAddHeadKill();
	Other.KFXDmgInfo.ReHeadKill     = KFXWeapBase(Weapon).KFXGetReHeadKill();
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXArmorWeaponPct[loop] = KFXWeapBase(Weapon).KFXGetWeapArmorPct(loop);
		;
	}
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXDmgArmorPct[loop] = KFXWeapBase(Weapon).KFXGetDmgArmorPct(loop);
	}
	if ( bCanAutoAim && KFXPlayer(Ctrl) != none&&KFXPlayer(Ctrl).KFXIsOnAutoAimMode && KFXPlayer(Ctrl).KFXAutoAimValidTime > 0 )
	{
		Other.KFXDmgInfo.bAutoAim = 1;
	}
	else
	{
		Other.KFXDmgInfo.bAutoAim = 0;
	}

	// Take Damage
	if ( KFXFireGroup == 0 || AltDamageType == none )
		Other.TakeDamage(Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, DamageType);
	else
		Other.TakeDamage(Damage, Instigator, HitLocation, KFXWeapBase(Weapon).KFXGetMomentum() * HitDir, AltDamageType);

	// Take PBState
	if ( KFXPBDamageType[KFXFireGroup].BitState >= 0 )
	{
		if ( KFXFireGroup == 0 || AltDamageType == none )
			Other.KFXTakePBDamage(Instigator, DamageType,
				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
		else
			Other.KFXTakePBDamage(Instigator, AltDamageType,
				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
	}

	// Clear Damage Info
	Other.KFXDmgInfo.WeaponID = 0;
	Other.KFXDmgInfo.ArmorPct  = 0;
	Other.KFXDmgInfo.bAutoAim = 0;
	Other.KFXDmgInfo.HitBoxID = 0;
	Other.KFXDmgInfo.HeadKillProp = 0;
	Other.KFXDmgInfo.DmgShakeView = 0;
	///»¤¼×ÐÅÏ¢¹é0
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXArmorWeaponPct[loop] = 0;
	}
	for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
	{
		Other.KFXDmgArmorPct[loop] = 0;
	}

	return true;
}

function bool KFXTraceTank(
	Actor TraceActor, int Damage,
	vector HitDir, vector HitLocation, vector HitNormal,
	vector TraceStart, vector TraceEnd)
{
	local KFXVehiclesBase Other;
	local KFXPlayer Ctrl;
	local int HitBoxID;

	Other = KFXVehiclesBase(TraceActor);
	Ctrl = KFXPlayer(Instigator.Controller);
	if( Other == none || Ctrl == none )
		//Í¬¶Ó¿ÉÒÔÉËº¦£¬Ò»»á½â¾ö
		 //|| KFXPawn(TraceActor).KFXInTheSameTeam(KFXPawn(Instigator))
		return false;
	if ( Other.bUseHitboxDamage && !Other.bTearOff )
	{

		HitBoxID = Other.TraceHitBox(TraceEnd, TraceStart);
		;
		if ( HitBoxID == -1 )
			return false;

		Other.KFXDmgInfo.HitBoxID = HitBoxID;
	}
	else
	{
		Other.KFXDmgInfo.HitBoxID = 0;
	}

	Other.KFXDmgInfo.WeaponID       = KFXWeapBase(Weapon).KFXGetWeaponID();
	Other.KFXDmgInfo.ArmorPct       = KFXWeapBase(Weapon).KFXGetArmorPct();
	Other.KFXDmgInfo.DmgShakeView   = KFXShakeView[KFXFireGroup];

	// Check AutoAim
	// Server Only
	if ( bCanAutoAim && Ctrl.KFXIsOnAutoAimMode && Ctrl.KFXAutoAimValidTime > 0 )
	{
		Other.KFXDmgInfo.bAutoAim = 1;
	}
	else
	{
		Other.KFXDmgInfo.bAutoAim = 0;
	}

	Damage *= KFXGameInfo(Level.Game).DmgFactorModifier;


	// Take Damage ÆÕÍ¨ÎäÆ÷¶ÔÌ¹¿ËÃ»ÓÐ³åÁ¿Ð§¹û
	if ( KFXFireGroup == 0 || AltDamageType == none )
		Other.TakeDamage(Damage, Instigator, HitLocation, vect(0,0,0) * HitDir, DamageType);
	else
		Other.TakeDamage(Damage, Instigator, HitLocation, vect(0,0,0) * HitDir, AltDamageType);

	// Clear Damage Info
	Other.KFXDmgInfo.WeaponID = 0;
	Other.KFXDmgInfo.ArmorPct  = 0;
	Other.KFXDmgInfo.bAutoAim = 0;
	Other.KFXDmgInfo.HitBoxID = 0;
	Other.KFXDmgInfo.DmgShakeView = 0;

	return true;
}

// KFX Use Ammo
// owner Client & Server
simulated function bool KFXConsumeAmmo(int Load)
{
	// out of ammo
	if ( !KFXWeapBase(Weapon).KFXHasReload() )
	{

		// Play Empty sound
		Weapon.PlayOwnedSound(
			KFXWeapBase(Weapon).KFXGetNoammoSound()
			);

		// Play Empty Fire Anim
		if ( Weapon.Mesh != none && KFXWeapBase(Weapon).KFXHasAnim(EmptyFireAnim) )
			Weapon.PlayAnim(EmptyFireAnim, EmptyFireAnimRate, 0.0);

		// set next fire time
		NextFireTime += 0.2;
        log("KFXTossFire-----false ");
		return false;
	}

	// Server Stuff or Onwer Client Predict
	KFXWeapBase(Weapon).KFXConsumeAmmo(Load);
	if(KFXWeapBase(Weapon).bClientSimuFire && !bTossed && bNeedClientSimulate)        //Ö»ÓÐ¿Í»§¶ËÄ£Äâ¿ª»ðµÄÊ±ºòÈÃ·þÎñÆ÷ÉÏÖ´ÐÐ
	{
		log("KFXTossFire-----KFXServerConsumeAmmo ");
        KFXWeapBase(Weapon).KFXServerConsumeAmmo(Load);
	}
	log("KFXTossFire-----true ");
	return true;
}

// Damage Decay
// Server Only   and Owner Client
simulated function float KFXDecayDamage(int OrgDmg, float Dist)
{
	local float Range, ValidRange,LastValidRange;
	local float Factor,LastFactor;
	local int   DataSegment;
	local float dmg;

	Range       = KFXWeapBase(Weapon).KFXGetRange();
	DataSegment = CalcRangeSegment(Dist,Range);
	if(DataSegment<0)
	return 0;
	//¾àÀë³¬¹ý4¶ÎÓÐÐ§¾àÀëÔòÉè¶¨ÓÐÐ§¾àÀëÎªÕû¸örange
	if(DataSegment>3)
	{
		LastFactor = KFXWeapBase(Weapon).KFXGetValidDmgFactor(3);
		LastValidRange = KFXWeapBase(Weapon).KFXGetValidRange(3);
		ValidRange=Range;
		Factor = 0.0f;
		;
		if(ValidRange == LastValidRange)
		return 0;
		dmg = OrgDmg*(LastFactor + (Factor-LastFactor)*(Dist-LastValidRange)/(ValidRange - LastValidRange));
		;
		return dmg;
	}

	ValidRange  = KFXWeapBase(Weapon).KFXGetValidRange(DataSegment);
	Factor      = KFXWeapBase(Weapon).KFXGetValidDmgFactor(DataSegment);
	if(DataSegment>0)
	{
		LastFactor = KFXWeapBase(Weapon).KFXGetValidDmgFactor(DataSegment-1);
		LastValidRange = KFXWeapBase(Weapon).KFXGetValidRange(DataSegment-1);
	}
	else
	{
		LastValidRange = 0;
		LastFactor = 1.0f;
	}
	;
	// Just at the Fire Place
	if ( Dist == 0 )
		return OrgDmg;
	dmg = OrgDmg*(LastFactor + (Factor-LastFactor)*(Dist-LastValidRange)/(ValidRange - LastValidRange));
	;
	return dmg;
}

function int CalcRangeSegment(float Dist,float Range)
{
	local int loop;
	if( Dist < 0)
		return -1;
	if ( Dist > Range )
		return -1;
	for(loop=0;loop<4;loop++)
	{
		if (Dist<= KFXWeapBase(Weapon).KFXGetValidRange(loop))
		return loop;
	}
	return 4;
}
// only called on currently held weapon firemode
// owner client & server
event ModeTick(float dt)
{
	// calc frame time
	FrameTime = dt;

	// no fire buttons down
	if ( !bIsFiring && !bFireOnRelease )
	{
		// ShotsFired Ë¥¼õ

		// The following code prevents the player from tapping the firebutton repeatedly
		// to simulate full auto and retaining the single shot accuracy of single fire
		if (bDelayFire == true)
		{
			bDelayFire = false;
			if (ShotsFired > ShotsFiredDecLimit)
				ShotsFired = ShotsFiredDecLimit;
			ShotsFiredDecreaseTime = Level.TimeSeconds + TimeShotFiredDec;
		}

		// if it's a pistol then set the shots fired to 0 after the player releases a button
		if ( bIsPistol )
		{
			ShotsFired = 0;
		}
		else
		{
			if ( (ShotsFired > 0) && (ShotsFiredDecreaseTime < Level.TimeSeconds)   )
			{
				ShotsFiredDecreaseTime = Level.TimeSeconds + TimeShotFiredDec;
				ShotsFired -= ShotsFiredDecrease;

				if ( ShotsFired < 0 )
					ShotsFired = 0;
			}

			// decay accuracy
			Accuracy = FMin( ShotsFired/AccuracyDecrease, 1.0) * Accuracy;
			//LOG("ModeTick   Accuracy"$Accuracy$"ShotsFired:"$ShotsFired);
		}
	}

	// PunchAngleË¥¼õ
	DecayPunchAngle();

	// ¼æÈÝµ¥»úÄ£Ê½,²¢ÓÅ»¯·þÎñÆ÷µÄÅÐ¶ÏÐ§ÂÊ
	if ( Level.NetMode == NM_DedicatedServer )
		return;

	// Onwer Operations
	if ( Instigator.IsLocallyControlled() )
	{
		// Update Lock Target
		UpdateLockTarget(dt);

		// Update Crosshair Params
		UpdateCrossHair();
	}
}

// Update Lock Target
// Client Only
simulated function UpdateLockTarget(float dt);

// Update CrossHair Params
// Client Only
simulated function UpdateCrossHair()
{
	local float DesiredSpread, DesiredLength;
	local byte CrosshairIndex;
	if (Instigator.Controller != none && KFXPlayer(Instigator.Controller) != none)
	{
		CrosshairIndex = KFXPlayer(Instigator.Controller).KFXCrosshairSizeIndex;
	}

	// Calc Desiared Cross Hair
	CalcDesiaredCrossHair(DesiredSpread, DesiredLength);

	// Decay cross Hair
	DecayCrossHair(DesiredSpread, DesiredLength);

	// clamp values
	CrossHairLength = FMax(CrossHairMinLength[CrosshairIndex], CrossHairLength);
	CrossHairSpread = FMax(CrossHairMinSpread[CrosshairIndex], CrossHairSpread);
}

// Calc Desiared cross Hair
// Client Only
simulated function CalcDesiaredCrossHair(out float DesiredSpread, out float DesiredLength)
{
	local float DecayValue;
	local byte CrosshairIndex;
	if (Instigator.Controller != none && KFXPlayer(Instigator.Controller) != none)
	{
		CrosshairIndex = KFXPlayer(Instigator.Controller).KFXCrosshairSizeIndex;
	}


	// calc real spread & Length - decay
	DecayValue = CrossHairRaiseFactor[CrosshairIndex] * FrameTime;

	if ( CrossHairSpreadFireToFill > 0 )
	{
		// fill fire spread
		DesiredSpread = CrossHairSpread + DecayValue;
		CrossHairSpreadFireToFill -= DecayValue;

		if ( CrossHairSpreadFireToFill < 0 )
			CrossHairSpreadFireToFill = 0;
	}
	else
	{
		// calc Spread
		if ( Instigator.Physics != PHYS_Walking )
		{
			DesiredSpread = CrossHairSpreadJump[CrosshairIndex];
		}
		else if ( KFXIsSpeedInRun() )
		{
			DesiredSpread = CrossHairSpreadRun[CrosshairIndex];
		}
		else if ( VSize(Instigator.Velocity) > 10 )
		{
			DesiredSpread = CrossHairSpreadWalk[CrosshairIndex];
		}
		else if ( Instigator.bIsCrouched )
		{
			DesiredSpread = CrossHairSpreadCrouch[CrosshairIndex];
		}
		else
		{
			DesiredSpread = CrossHairSpreadStand[CrosshairIndex];
		}
	}

	if ( CrossHairLengthFireToFill > 0 )
	{
		// fill fire spread
		DesiredLength = CrossHairLength + DecayValue;
		CrossHairLengthFireToFill -= DecayValue;

		if ( CrossHairLengthFireToFill < 0 )
			CrossHairLengthFireToFill = 0;
	}
	else
	{
		DesiredLength = CrossHairMinLength[CrosshairIndex];
	}
}

// Decay Cross Hair
// Client Only
simulated function DecayCrossHair(float DesiredSpread, float DesiredLength)
{
	local float DecayValue;
	local byte CrosshairIndex;
	if (Instigator.Controller != none && KFXPlayer(Instigator.Controller) != none)
	{
		CrosshairIndex = KFXPlayer(Instigator.Controller).KFXCrosshairSizeIndex;
	}

	// calc real spread & Length - decay
	DecayValue = CrossHairDecayFactor[CrosshairIndex] * FrameTime;

	if ( DesiredSpread - CrossHairSpread > DecayValue )
	{
		CrossHairSpread = CrossHairSpread + DecayValue;
	}
	else if ( DesiredSpread - CrossHairSpread < -DecayValue )
	{
		CrossHairSpread = CrossHairSpread - DecayValue;
	}
	else
	{
		CrossHairSpread =  DesiredSpread;
	}

	if ( DesiredLength - CrossHairLength > DecayValue )
	{
		CrossHairLength = CrossHairLength + DecayValue;
	}
	else if ( DesiredLength - CrossHairLength < -DecayValue )
	{
		CrossHairLength = CrossHairLength - DecayValue;
	}
	else
	{
		CrossHairLength = DesiredLength;
	}
}

// Update CrossHair Params on firing
// Client Only
simulated function FireUpdateCrossHair()
{
	local byte CrosshairIndex;
	if (Instigator.Controller != none && KFXPlayer(Instigator.Controller) != none)
	{
		CrosshairIndex = KFXPlayer(Instigator.Controller).KFXCrosshairSizeIndex;
	}
	CrossHairSpreadFireToFill = CrossHairMaxSpread[CrosshairIndex] - CrossHairSpread;
	CrossHairLengthFireToFill = CrossHairMaxLength[CrosshairIndex] - CrossHairLength;
}

// Decay Punch Angle
// Client Only
simulated function DecayPunchAngle()
{
	local rotator NewPunchAngle;
	local float damping, springForceMagnitude;
	local float  PunchAngleDecayDamp;
	local float  PunchAngleDecaySpring;
	local KFXWeapBase weap;

	if ( VSize(vector(PunchAngle)) > 0 || VSize(vector(PunchAngleVel)) > 0)
	{
		weap = KFXWeapBase(Weapon);
		PunchAngleDecayDamp = weap.KFXGetPunchAngleDecayDamp();
		PunchAngleDecaySpring = weap.KFXGetPunchAngleDecaySpring();
		// calc new punch angle
		NewPunchAngle = PunchAngle + PunchAngleVel * FrameTime;
		if ( NewPunchAngle.Pitch < 0 )
		{
			PunchAngle.Pitch = 0;
			PunchAngleVel.Pitch = 0;
			NewPunchAngle.Pitch = 0;
		}


		// calc punch angle velocity
		damping = 1 - (PunchAngleDecayDamp * frametime);
		if ( damping < 0 )
		{
			damping = 0;
		}

		PunchAngleVel = PunchAngleVel * damping;

		// torsional spring
		// UNDONE: Per-axis spring constant?
		springForceMagnitude = PunchAngleDecaySpring * FrameTime;
		springForceMagnitude = FClamp(springForceMagnitude, 0.0, 1.0 );
		PunchAngleVel = PunchAngleVel - PunchAngle * springForceMagnitude;

		// record punch angle
		PunchAngle = NewPunchAngle;
	}

//    if ( Level.NetMode == NM_DedicatedServer )
//    {
//        if ( bIsFiring )
//        {
//            PunchAngle *= 0.8;
//        }
//        else
//        {
//            PunchAngle *= 0.5;
//            return;
//        }
//    }
}


// Play Firing
// Owner Client Only
simulated function PlayFiring()
{
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//if ( Weapon.Mesh != none && !PlayerController(Instigator.Controller).bBehindView )
	if ( Weapon.Mesh != none &&PlayerController(Instigator.Controller) != none && !PlayerController(Instigator.Controller).bBehindView )
	//>>
	{
		if ( FireCount > 0 )
		{
			if ( KFXWeapBase(Weapon).KFXHasAnim(FireLoopAnim) )
			{
				Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
			}
			else
			{
				Weapon.PlayAnim(FireAnim, FireLoopAnimRate, TweenTime);
			}
		}
		else
		{
			Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
		}

		if(KFXWeapBase(Weapon).KFXWeapComponent[0]!=none
				&& KFXWeapBase(Weapon).KFXWeapComponent[0].FireAnim !=''
				&& KFXWeapBase(Weapon).KFXWeapComponent[0].FireAnim != 'null')
			KFXWeapBase(Weapon).KFXWeapComponent[0].PlayAnim(
				KFXWeapBase(Weapon).KFXWeapComponent[0].FireAnim);
		log("KFXFireBase-----KFXWeapBase(Weapon).bShowAnoFireSound "$KFXWeapBase(Weapon).bShowAnoFireSound);
		if(!KFXWeapBase(Weapon).bShowAnoFireSound)
		{
			Weapon.PlaySound(
				KFXWeapBase(Weapon).KFXGetFPFireSound(),
				SLOT_Interact,
				TransientSoundVolume,
				,
				Weapon.TransientSoundRadius,
				,
				false);
		}
		else
		{
			Weapon.PlaySound(
				KFXWeapBase(Weapon).KFXGetFPSmallFireSound(),
				SLOT_Interact,
				TransientSoundVolume,
				,
				Weapon.TransientSoundRadius,
				,
				false);
		}
		KFXWeapBase(Weapon).BeginFireSoundTime = Level.TimeSeconds;
		ClientPlayForceFeedback(FireForce);  // jdf
	}

	FireCount++;
}
//-----·þÎñÆ÷Ö÷µ¼µÄ¹¦ÄÜ¿Í»§¶ËÐèÒªÅäºÏµÄ
simulated function KFXClientFireEntry()
{

}
simulated function KFXFireOn()
{

}
function PlayPreFire()
{
	if ( Weapon.Mesh != None && KFXWeapBase(Weapon).KFXHasAnim(PreFireAnim) )
	{
		Weapon.PlayAnim(PreFireAnim, PreFireAnimRate, TweenTime);
	}
}

function PlayFireEnd()
{
	if ( Weapon.Mesh != None && KFXWeapBase(Weapon).KFXHasAnim(FireEndAnim) )
	{
		Weapon.PlayAnim(FireEndAnim, FireEndAnimRate, TweenTime);
	}
}

//// server propagation of firing ////
function ServerPlayFiring()
{
	log("KFXFireBase------KFXWeapBase(Weapon).bShowAnoFireSound "$KFXWeapBase(Weapon).bShowAnoFireSound);
	if(!KFXWeapBase(Weapon).bShowAnoFireSound)
	{
			Weapon.PlayOwnedSound(
			KFXWeapBase(Weapon).KFXGetFireSound(),
			SLOT_Interact,
			TransientSoundVolume,
			,
			Weapon.TransientSoundRadius,
			,
			false
			);
	}
	else
	{
			Weapon.PlayOwnedSound(
			KFXWeapBase(Weapon).KFXGetTPSmallFireSound(),
			SLOT_Interact,
			Weapon.TransientSoundVolume,
			,
			Weapon.TransientSoundRadius,
			,
			false);

	}
}

// Client & Server
function StopFiring()
{
	// Prevent Client Predicting Failure
	if (Weapon.Role != ROLE_Authority)
		NextFireTime += 0.05;
	FireStartArmmo = -1;
	CurCornerStaticShotNum = 0;
	PunchHorizonEnable = false;
}

// CS angle to UT angle
simulated function float AngleCS2UT(float CSAngle)
{
	return CSAngle * 65536.0 / 360.0;
}

// kick the player back, affect the crosshair
// owner client only, because of random
simulated function KickBack(
	float up_base,     float lateral_base,
	float up_modifier, float lateral_modifier,
	float up_max,      float lateral_max,
	int direction_change )
{
	local float
		up_base_ut,      lateral_base_ut,
		up_modifier_ut,  lateral_modifier_ut,
		up_max_ut,       lateral_max_ut;

	local float
		KickUp, KickLateral;

	local rotator NewPunchAngle;

	up_base_ut           = AngleCS2UT(up_base);
	lateral_base_ut      = AngleCS2UT(lateral_base);
	up_modifier_ut       = AngleCS2UT(up_modifier);
	lateral_modifier_ut  = AngleCS2UT(lateral_modifier);
	up_max_ut            = AngleCS2UT(up_max);
	lateral_max_ut       = AngleCS2UT(lateral_max);

	if ( ShotsFired == 1 )
	{
		KickUp = up_base_ut;
		KickLateral = lateral_base_ut;
	}
	else
	{
		KickUp = up_base_ut + ShotsFired * up_modifier_ut;
		KickLateral = lateral_base_ut + ShotsFired * lateral_modifier_ut;
	}

	NewPunchAngle.Pitch = PunchAngle.Pitch + KickUp;
	if ( NewPunchAngle.Pitch > up_max_ut )
	{
		if ( !PunchHorizonEnable )
		{
			PunchHorizonEnable = true;
			if ( FireStartArmmo%2 == 0 )
			{
				PunchDirection = 1;
			}
			else
			{
				PunchDirection = 0;
			}

		}
		NewPunchAngle.Pitch = up_max_ut;
		log("[KFXFireBase]  KickBack  FireStartArmmo :"$FireStartArmmo);
	}

	if ( PunchDirection == 1 )
	{
		NewPunchAngle.Yaw = PunchAngle.Yaw - KickLateral;
		if ( NewPunchAngle.Yaw < (-lateral_max_ut) )
		{
			CurCornerStaticShotNum++;
			if ( CurCornerStaticShotNum < KFXWeapBase(Weapon).GetCornerStaticShotsCount() )
			{
				;
				NewPunchAngle.Yaw = -lateral_max_ut;
			}
			else
			{
				NewPunchAngle.Yaw = -lateral_max_ut;
				PunchDirection = 0;
				CurCornerStaticShotNum = 0;
			}
		}
	}
	else
	{
		NewPunchAngle.Yaw = PunchAngle.Yaw + KickLateral;
		if ( NewPunchAngle.Yaw > lateral_max_ut )
		{
			CurCornerStaticShotNum++;
			if ( CurCornerStaticShotNum < KFXWeapBase(Weapon).GetCornerStaticShotsCount() )
			{
				;
				NewPunchAngle.Yaw = lateral_max_ut;
			}
			else
			{
				NewPunchAngle.Yaw = lateral_max_ut;
				PunchDirection = 1;
				CurCornerStaticShotNum = 0;
			}
		}
	}
	PunchAngle = NewPunchAngle;
}

// Get the PunchAngle
simulated function rotator KFXGetPunchAngle()
{
	return PunchAngle;
}

////////////////////////  for cs weapon effect tail ///////////////////////////

// ====================================================================
// Helper Functions
// ====================================================================
// Tool function
// Is Current Velocity Higher than Walk
simulated function bool KFXIsSpeedInRun()
{
	return VSize(Instigator.Velocity) > (Instigator.WalkingPct * Instigator.GroundSpeed + 10);
}

function float MaxRange()
{
	return KFXWeapBase(Weapon).KFXGetRange();
    //return 25000;
}

simulated function ModifyByWeapCmpnt(int CmpntID)
{

}

simulated function float KFXGetCalcAccuracy()
{
	local float TemAcc;
	local int loop;
	if ( KFXAccuracyDivision[KFXFireGroup] != 0 )
	{
		TemAcc = KFXAccuracyDivision[KFXFireGroup];
		for(loop=0; loop < 6; loop++ )
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			TemAcc += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXAccuracyDivision[KFXFireGroup];
		}
		return TemAcc;
	}
	else
	{
		return 0;
	}
}

simulated function float KFXGetAccuracyOffset()
{
	local float TemAccOffset;
	local int loop;
	if ( KFXAccuracyOffset[KFXFireGroup] != 0 )
	{
		TemAccOffset = KFXAccuracyOffset[KFXFireGroup];
		for(loop=0; loop < 6; loop++ )
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			TemAccOffset += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXAccuracyOffset[KFXFireGroup];
		}
		return TemAccOffset;
	}
	else
	{
		return 0;
	}
}

simulated function float KFXGetMaxInaccuracy()
{
	local float TemMaxInacc;
	local int loop;
	if ( KFXMaxInaccuracy[KFXFireGroup] != 0 )
	{
		TemMaxInacc = KFXMaxInaccuracy[KFXFireGroup];
		for(loop=0; loop < 6; loop++ )
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			TemMaxInacc += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXMaxInaccuracy[KFXFireGroup];
		}
		return TemMaxInacc;
	}
	else
	{
		return 0;
	}
}

simulated function float KFXGetFireFlyFactor()
{
	local float TemFlyFactor;
	local int loop;
	if ( KFXFireFlyFactor[KFXFireGroup] != 0 )
	{
		TemFlyFactor = KFXFireFlyFactor[KFXFireGroup];
		for(loop=0; loop < 6; loop++ )
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			TemFlyFactor += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXFireFlyFactor[KFXFireGroup];
		}
		return TemFlyFactor;
	}
	else
	{
		return 0;
	}
}

simulated function KFXGetKBParam(out KFXKickBackParams param)
{
	local int iPawnState;
	local int loop;

	local float up_base;
	local float lateral_base;
	local float up_modifier;
	local float lateral_modifier;
	local float up_max;
	local float lateral_max;
	local int   direction_change;

	iPawnState = KFXGetPawnState();

	if ( KFXFireGroup == 0 )
	{
		up_base         =KFXParam_KB1[iPawnState].up_base;
		lateral_base    =KFXParam_KB1[iPawnState].lateral_base;
		up_modifier     =KFXParam_KB1[iPawnState].up_modifier;
		lateral_modifier=KFXParam_KB1[iPawnState].lateral_modifier;
		up_max          =KFXParam_KB1[iPawnState].up_max;
		lateral_max     =KFXParam_KB1[iPawnState].lateral_max;
		direction_change =KFXParam_KB1[iPawnState].direction_change;

		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			up_base         += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].up_base;
			lateral_base    += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].lateral_base;
			up_modifier     += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].up_modifier;
			lateral_modifier+= KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].lateral_modifier;
			up_max          += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].up_max;
			lateral_max     += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].lateral_max;
			direction_change += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB1[iPawnState].direction_change;
		}
	}
	else
	{
		up_base         =KFXParam_KB2[iPawnState].up_base;
		lateral_base    =KFXParam_KB2[iPawnState].lateral_base;
		up_modifier     =KFXParam_KB2[iPawnState].up_modifier;
		lateral_modifier=KFXParam_KB2[iPawnState].lateral_modifier;
		up_max          =KFXParam_KB2[iPawnState].up_max;
		lateral_max     =KFXParam_KB2[iPawnState].lateral_max;
		direction_change =KFXParam_KB2[iPawnState].direction_change;

		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			up_base         += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].up_base;
			lateral_base    += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].lateral_base;
			up_modifier     += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].up_modifier;
			lateral_modifier+= KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].lateral_modifier;
			up_max          += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].up_max;
			lateral_max     += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].lateral_max;
			direction_change += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_KB2[iPawnState].direction_change;
		}
	}

	param.up_base           =  up_base;
	param.lateral_base      =  lateral_base;
	param.up_modifier       =  up_modifier;
	param.lateral_modifier  =  lateral_modifier;
	param.up_max            =  up_max;
	param.lateral_max       =  lateral_max;
	param.direction_change  =  direction_change;
}

simulated function KFXGetSPParam(out KFXSpreadParams param)
{
	local float param1;
	local float param2;
	local int loop;
	local int iPawnState;

	iPawnState = KFXGetPawnState();

	if ( KFXFireGroup == 0 )
	{
		param1 = KFXParam_SP1[iPawnState].Param1;
		param2 = KFXParam_SP1[iPawnState].Param2;
		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			param1 += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_SP1[iPawnState].Param1;
			param2 += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_SP1[iPawnState].Param2;
		}
	}
	else
	{
		param1 = KFXParam_SP2[iPawnState].Param1;
		param2 = KFXParam_SP2[iPawnState].Param2;
		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapBase(Weapon).KFXWeapComponent[loop] == none)
				continue;
			param1 += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_SP2[iPawnState].Param1;
			param2 += KFXWeapBase(Weapon).KFXWeapComponent[loop].KFXParam_SP2[iPawnState].Param2;
		}
	}
	param.Param1 = param1;
	param.Param2 = param2;

}

defaultproperties
{
     bDrawMuzzleFlash=是
     KFXCrossHairType=-1
     KFXCHColorNormal=(G=255,A=255)
     KFXCHColorEnemy=(R=255,A=255)
     KFXCHColorFriend=(G=255,A=255)
     FireStartArmmo=-1
     bNeedClientSimulate=是
     TransientSoundVolume=0.800000
     TransientSoundRadius=40.000000
}
