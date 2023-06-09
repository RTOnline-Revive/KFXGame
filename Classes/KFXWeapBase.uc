// ====================================================================
//  Class:  KFXGame.KFXWeapBase
//  Creator: Kevin Sun
//  Date: 2007.06.26
//  Description: Base class of all kfx game weapons
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXWeapBase extends Weapon
	native
	abstract;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

const NUM_SND_FPFIRE_WB = 8;

//< for cs weapon effect
var bool   bIsReload;       // ÊÇ·ñ´¦ÓÚ»»µ¯×´Ì¬
var bool   bCannotSwitchWhileFiring; // ¿ª»ðÊ±²»ÄÜ»»Ç¹

//var localized string KFXWeaponHint[8]; // ÌáÊ¾ÐÅÏ¢
//var byte   KFXWeaponHintFlag[8];        // ÌáÊ¾ÐÅÏ¢±ê¼Ç
var bool   KFXWeaponShowHint;           // ÎäÆ÷ÌáÊ¾¿ª¹Ø
//>
var int KFXMaxAmmo[2];                     //×Óµ¯µÄ×î´óÊýÁ¿

var Actor  KFXLockedTarget;     // Ëø¶¨µÄÄ¿±ê

var int    KFXMagicItemID;      // µÀ¾ßÎäÆ÷ID(´ÓµÀ¾ß²úÉúµÄÎäÆ÷Ê¹ÓÃ)

//wangkai, ÊÇ·ñÏÔÊ¾¹ýHintÌáÊ¾
var bool bKFXShowBringUpHint;
var bool bKFXShowPickupWeapHint;

var protected int KFXInitAmmoCount[2];  // ±¸·ÝÃ»ÓÐ°²×°µ¯¼ÐÇ°µÄ±¸ÓÃ×Óµ¯Êý
var protected int KFXInitReload[2];     // ±¸·ÝÃ»ÓÐ°²×°µ¯¼ÐÇ°µÄ×Óµ¯Êý
var protected int KFXInitReloadMax[2];  // ±¸·ÝÃ»ÓÐ°²×°µ¯¼ÐÇ°µÄ×î´ó×Óµ¯Êý
var protected byte KFXHasCartridgeClip[2];// ÅÐ¶ÏÊÇ·ñ×°±¸µ¯¼Ð

var bool bNoAmmo;
replication
{
	// Refactor Version
	// Things the server should send to the client.
	reliable if( (Role==ROLE_Authority) && bNetDirty && bNetOwner )
		bIsReload, KFXFireGroup, KFXAmmoCount, KFXReload, KFXReloadMax;

	reliable if ( Role==ROLE_Authority )
		KFXClientInit, KFXClientInitMagicItem, ClientPreReload, ClientTickReload, ClientPostReload,KFXClientAddComponent,KFXClientDurableFact,KFXClientConsumeAmmo;

	// client to server
	reliable if ( Role < ROLE_Authority )
		ServerPreReload, KFXLockTarget, KFXLossTarget,KFXServerRemoveComponent,/*ServerTakeDamage,SetWorldTakeDamage,SetNotPawnTakeDamage*/KFXServerConsumeAmmo;

	reliable if (Role == ROLE_Authority && bNetInitial)
		bRepForceSwitch;
	// client to server
	reliable if ( Role < ROLE_Authority )
		ServerPlayNoAmmoSound;
	reliable if ( Role==ROLE_Authority )
		bHasTossed,KFXClientSetGroupDamage,bShowTrack,bShowAnoFireSound;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

// ====================================================================
// ÎäÆ÷³£¹æ²ÎÊý²ÎÊý
// ====================================================================

var private int KFXWeaponID;           // ÎäÆ÷ID(È·¶¨ÎäÆ÷¹ÌÓÐÊôÐÔ)

var float KFXSpeedFactor[NUM_FIRE_MODES];   // ËÙ¶ÈÓ°Ïì²ÎÊý

var int   KFXReloadMode;                      // 0 - can't reload; 1 - normal; 2- one by one
var float KFXPreReloadTime;
var float KFXNormalReloadTime;
var float KFXNullReloadTime;
var float KFXEndReloadTime;

var float KFXFinishReloadTime;                // Transient, Keep the Reload Finish Time

var protected int     KFXAmmoCount[NUM_FIRE_MODES];
var protected int     KFXReload[NUM_FIRE_MODES];
var protected int     KFXReloadMax[NUM_FIRE_MODES];
var protected int     KFXClientSimReload[NUM_FIRE_MODES];  // ÓÃÓÚ¿Í»§¶ËÄ£ÄâµÄ×Óµ¯ÊýÁ¿£¬±ÜÃâÓë·þÎñÆ÷²»Í¬²½µÄÏÖÏó

// FireMode Ê¹ÓÃµÄÅäÖÃ²ÎÊý
//var private int     KFXMode0Damage[11];
//var private int     KFXMode1Damage[11];
var private int KFXModeDamage[NUM_FIRE_MODES];
var private float   KFXModeRate[NUM_FIRE_MODES];
var private int     KFXModeRange[NUM_FIRE_MODES];

//----------------ÆðÌøÎäÆ÷¿ª»ð¿ØÖÆ²ÎÊý------------------------------------

var private bool    KFXCanJumpFire;         //ÊÇ·ñÔÊÐíÆðÌøºó¿ª»ð
var private bool    KFXCanJumpSwitchState;     //ÆðÌøºóÊÇ·ñÇÐ»»×´Ì¬
var private float   KFXLandFireStopSec;     //Âäµ½µØÃæºóÔÊÐíÖØÐÂ¿ªÇ¹µÄÊ±¼ä
var         float   KFXLandFireStopTime;    //ÆðÌø½ûÇ¹½áÊøµÄÊ±¿Ì

//-------------------------------------------------------------------------

var private int KFXCornerStaticShotsCount[NUM_FIRE_MODES];

//-----------------ÎäÆ÷ÉËº¦µÄÓ°Ïì²ÎÊý£º¾àÀëºÍ°Ù·Ö±È------------------------
var private int     KFXMode0ValidRange[4];   // Ä£Ê½0ÓÐÐ§ÉËº¦¾àÀë(ÉËº¦¾àÀëË¥¼õ)
var private int     KFXMode1ValidRange[4];   // Ä£Ê½1ÓÐÐ§ÉËº¦¾àÀë(ÉËº¦¾àÀëË¥¼õ)
var private float   KFXMode0ValidDmgFactor[4]; // Ä£Ê½0ÓÐÐ§ÉËº¦Òò×Ó(ÉËº¦¾àÀëË¥¼õ)
var private float   KFXMode1ValidDmgFactor[4]; // Ä£Ê½1ÓÐÐ§ÉËº¦Òò×Ó(ÉËº¦¾àÀëË¥¼õ)
//--------------ÎÞËÀÍöÄ£Ê½Ç¹ÐµÉËº¦·ÖÊýÐÞÕýÖµ--------------------------------------------------
var float      KFXScoreDmgPct[2];//Ä£Ê½1Ç¹ÐµÉËº¦·ÖÊýÐÞÕý
//-------------½ÇÉ«Íæ¼Ò±¬Í·¼¸ÂÊµ÷Õû-----------------
var float      KFXHeadKillProp[NUM_FIRE_MODES];

var float      KFXAddHeadKill[NUM_FIRE_MODES];       ///<±¬Í·¿¨ÅäÖÃ²ÎÊý
var float      KFXReHeadKill[NUM_FIRE_MODES];        ///<·À±¬Í·¿¨ÅäÖÃ²ÎÊý
//-------------------------------------------------
//var private int     KFXModePTFactor[NUM_FIRE_MODES];    // ´©Ç½ÏµÊý
//var private float   KFXModePTDmg[NUM_FIRE_MODES];       // ´©Ç½ÉËº¦Ë¥¼õÏµÊý
var private int     KFXModeAmmoPerFire[NUM_FIRE_MODES];  // Ã¿´ÎÉä»÷ºÄ·ÑµÄµ¯Ò©Êý
var private int     KFXModeShotPerFire[NUM_FIRE_MODES];  // Ã¿´ÎÉä»÷´ò³öµÄµ¯¿×Êý
var private int     KFXModeMomentum[NUM_FIRE_MODES];   // ¶¯Á¿ÏµÊý
var private float   KFXModeArmorPct[NUM_FIRE_MODES];   // ´©¼×ÏµÊý
var private bool    KFXShareAmmo;                      // ÊÇ·ñ¹²ÏíAmmo£¨Ammo0£©
var private int     KFXFireGroup;                      // µ±Ç°Éä»÷Ä£Ê½µÄÊýÖµ×éºÅ(ÓëFireModeÎÞ¹Ø)

var private int     KFXCrossWoodLength[NUM_FIRE_MODES];
var private int     KFXCrossMetalLength[NUM_FIRE_MODES];
var private int     KFXCrossOtherLength[NUM_FIRE_MODES];

var private float   KFXModeWoodPTDmg[NUM_FIRE_MODES];       // ´©Ç½ÉËº¦Ë¥¼õÏµÊý
var private float   KFXModeMetalPTDmg[NUM_FIRE_MODES];       // ´©Ç½ÉËº¦Ë¥¼õÏµÊý
var private float   KFXModeOtherPTDmg[NUM_FIRE_MODES];       // ´©Ç½ÉËº¦Ë¥¼õÏµÊý

var float SpeedDownFactor[2];                              //ÎäÆ÷¶Ô½ÇÉ«ÊÜÉËÊ±µÄËÙ¶ÈË¥¼õ
var float SpeedDownTime[2];                                //ÎäÆ÷¶Ô½ÇÉ«ÊÜÉËÖÍÁôÊ±¼äµÄÐÞ¸Ä
// ====================================================================
// µ¯µÀ¼ÆËãÏà¹Ø²ÎÊý
// ====================================================================

const KFX_CFG_TRACK_FACTOR_NUM = 10;   // ¿É±äµ¯µÀ²ÎÊýÊýÁ¿

var int KFXCfgTrackFactor[KFX_CFG_TRACK_FACTOR_NUM];   // ¿É±äµ¯µÀ²ÎÊý (´ÓÍøÂç»ñÈ¡)

// ====================================================================
// ÏÔÊ¾Ïà¹ØÊý¾Ý
// ====================================================================

const KFX_MAX_ACCESSORY_NUM = 7;       // Åä¼þÊýÁ¿

var int KFXFPHandID;                      // µÚÒ»ÈË³ÆÊÖ±ÛID
var int KFXAccessory[KFX_MAX_ACCESSORY_NUM];       // Áã¼þID
var KFXWeapAccesory KFXAccessoryMesh[KFX_MAX_ACCESSORY_NUM];

// ====================================================================
// »¤¼×¹¦ÄÜÏà¹ØÏµÊý
// ====================================================================
///¸Ã²¿·ÖµÄconstÖµÐèÒªÓëKFXPawn KFXFireBaseÒ»Í¬¸üÐÂ
const KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM = 1;  //<ÓÐ¶àÉÙÖÖ»¤¼×µÈ¼¶
const KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM = 2;//<ÓÐ¶àÉÙÖÖ»¤¼×¿¨£¬ÏÖÔÚ°üÀ¨Í·¿øºÍ»¤¼×£¨·À»¤ÉíÌå£©
const KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM = 2;  //< KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM * KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM
var private float  KFXWeaponArmorPct[KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM];//<ÎäÆ÷»¤¼×ÉËº¦¼õÃâÏµÊý
struct native ArmorPctData
{
	var float ArmorPct[KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM];
};
///ÎäÆ÷µÄ´©¼×ÏµÊý
var private ArmorPctData KFXModeDmgArmorPct[NUM_FIRE_MODES];
// anims
var name   StartReloadAnim;
var name   AfterReloadAnim;
var name   ReloadNormalAnim;
var name   ReloadNullAnim;

var float  StartReloadAnimRate;
var float  AfterReloadAnimRate;
var float  ReloadNormalAnimRate;
var float  ReloadNullAnimRate;

// View Offset: for Change Hand Backup
var vector  KFXInitPlayerViewOffset;
var rotator KFXInitPlayerViewPivot;

var private float   PunchAngleDecayDamp[2];
var private float   PunchAngleDecaySpring[2];

//----Êó±êÁéÃô¶È
var float KFXMouseSens[NUM_FIRE_MODES];

var float       KFXDefDisplayFov[2];
var vector      KFXPlayerViewOffset[2];
var rotator     KFXPlayerViewPivot[2];

//---------
var string KFXWeapHotStr;//¹ýÈÈµÄÌùÍ¼×Ö·û´®
var texture KFXWeapHotTex;//¹ýÈÈµÄÌùÍ¼
var string KFXWeapHotBGStr;//¹ýÈÈµÄ±³¾°ÌùÍ¼×Ö·û´®
var texture KFXWeapHotBGTex;//¹ýÈÈµÄ±³¾°ÌùÍ¼
var     class<Emitter> KFXWeapHotEffectClass;
var     actor          KFXWeapHotEffect;

// ====================================================================
// ÉùÒôÏà¹ØÊý¾Ý
// ====================================================================
//SelectSound // ÇÐÇ¹ÉùÒô

var private sound KFXSndTPFire[NUM_FIRE_MODES];     // ¿ª»ðÉùÒô
// Ç°ËÄ¸öÊÇ×ó¼ü¿ª»ðÒôÐ§£¬ºóËÄ¸öÊÇÓÒ¼ü¿ª»ðÒôÐ§
var private sound KFXSndFPFire[NUM_SND_FPFIRE_WB];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
var private sound KFXSndReload;                   // »»µ¯ÉùÒô
var private sound KFXSndNoammo;                   // ¿ÕÉä»÷ÉùÒô

// ====================================================================
// ÇÐ³öÇ¹Ê±µÄÌáÊ¾
// ====================================================================
var string KFXBringUpHint;
// ====================================================================
// Êý¾Ý³õÊ¼»¯Âß¼­
// ====================================================================

// Called immediately after gameplay begins.
//

//ÎäÆ÷×é¼þ,×î¶à6¸öÎ»ÖÃ
var WeaponComponent KFXWeapComponent[6];
var float WeapDurable;
var bool  bRepForceSwitch;

var bool bZeroCount;
var float CurTime;
var bool bStartFire;
var bool bHasTossed;            //À×ÒÑ¾­ÈÓ³öÈ¥ÁË
var int GroupOfLastKill;        //×îºóÒ»´ÎÉ±ÈËµÄFireGroup

var bool bShowTrack;
var bool bShowAnoFireSound;
var string AnoFireSound;
const NUM_SND_FPSMALLFIRE = 4;
var sound KFXSndTPSmallFire[NUM_FIRE_MODES];     // ¿ª»ðÉùÒô
//// Ç°Á½¸öÊÇ×ó¼ü¿ª»ðÒôÐ§£¬ºóÁ½¸öÊÇÓÒ¼ü¿ª»ðÒôÐ§
var sound KFXSndFPSmallFire[NUM_SND_FPSMALLFIRE];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
var float BeginFireSoundTime;
//Îª½â¾öÉú»¯»ÙÃð¹«¾ôÄ£Ê½ÎÞÏÞ×Óµ¯Ìí¼Ó´úÂë
var int   ErrorReloadNum;

var bool  bIsDoubleComponent;///ÊÇ·ñÊÇË«Åä¼þÎäÆ÷
native function DestroyFireMode(int Index);

function CSVConfig(array<int> Ids)
{
	KFXWeaponID = Ids[0];
	log("kfxweapbase CSVConfig"$KFXWeaponID);
	csvKFXInit(KFXWeaponID);
}

simulated function PostBeginPlay()
{
	// do Nothing !
}

// called after PostBeginPlay.  On a net client, PostNetBeginPlay() is spawned after replicated variables have been initialized to
// their replicated values
simulated function PostNetBeginPlay()
{
	// do Nothing !
}

// KFXWeaponµÄ³õÊ¼»¯Èë¿Ú
// Server Only
// TODO: ´«Èë²ÎÊý¸ÄÎªWeaponµÄ½á¹¹Ìå
simulated function KFXServerInit(int WeaponID, optional int MagicItemID,optional int Component[6],optional bool bFemale)
{
	// Server Init
	if ( Level.NetMode == NM_DedicatedServer )
	{
		;

		KFXWeaponID     = WeaponID;
		KFXMagicItemID  = MagicItemID;
		KFXSetupOrgData();
		KFXSetupCfgData();
		KFXSetupFireModes();
		KFXSetupSoundData();
        bSniping = WeaponID >> 16 == 3; ///¾Ñ»÷ÀàÎäÆ÷BOTO×¨ÓÃ
		if ( KFXMagicItemID > 0 )
		{
			bCanThrow      = false;
			InventoryGroup = 6;
			Priority       = 0;
		}
	}

	// Client Init
	KFXClientInit(WeaponID,bFemale);

	if ( KFXMagicItemID > 0 )
	{
		KFXClientInitMagicItem(KFXMagicItemID);
	}
	if ((Level.NetMode == NM_Standalone ) || Role == ROLE_Authority )
	{
		KFXServerComponentInit(Component);
	}
}

// replication To Client
// Client Only

simulated function KFXClientInit(int WeaponID,optional bool bFemale)
{

	log("[Weapon] KFXClientInit: "$WeaponID$"  Weapon Owner name Is "$Instigator.PlayerReplicationInfo.PlayerName);
	log("KFXWeapBase--------bIsFemale "$bFemale);
	if(bFemale)
	{
		GetFemaleWeaponMesh();
	}
	if( Role!= ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		KFXSetupOrgData();
		KFXSetupCfgData();
		KFXSetupFireModes();
		KFXSetupSoundData();
		KFXSetupRenderData();
	}
}
simulated  function string GetFemaleWeaponMesh()
{
	local string MeshName,SkelName;
	local KFXCSVTable CFG_Accessory;

	CFG_Accessory  = class'KFXTools'.static.GetConfigTable(13);
	if ( !CFG_Accessory.SetCurrentRow(KFXFPHandID) )
	{
		Log("[Kevin] Can't Resolve the FP Main Accessory (Hand) KFXFPHandID:"$KFXFPHandID );
	}

	MeshName = CFG_Accessory.GetString("FPMesh");
	MeshName = MeshName$"_W";
	SkelName = CFG_Accessory.GetString("FPSkeleton");
	LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );
	log("KFXWeapBase--------MeshName "$MeshName);
	log("KFXWeapBase--------SkelName "$SkelName);

	if ( !(SkelName ~= "null" ))
		LinkSkelAnim(
			MeshAnimation(DynamicLoadObject(SkelName, class'MeshAnimation'))
			);

	BoneRefresh();
}
// TODO: ´«Èë²ÎÊý¸ÄÎªWeaponµÄ½á¹¹Ìå
simulated function csvKFXInit(int WeaponID)
{
	log("[Weapon] csvKFXInit: "$WeaponID);

	csvKFXSetupOrgData();
	csvKFXSetupCfgData();
	csvKFXSetupFireModes();
	csvKFXSetupSoundData();
	csvKFXSetupRenderData();
}

// replication To Client
// Client Only
simulated function KFXClientInitMagicItem(int MagicItemID)
{
	;

	KFXMagicItemID = MagicItemID;
	bCanThrow      = false;
	InventoryGroup = 6;
	Priority       = 0;
}

// ÔØÈë¹ÌÓÐÊôÐÔ
simulated function KFXSetupOrgData()
{
}
simulated function csvKFXSetupOrgData()
{
	local KFXCSVTable CFG_Weapon, CFG_FireMode, CFG_WeapTrack;
	local int ModeID1, ModeID2;
	local int loop,loopi,loopj;
	local array<string>  strParts;

	;

	// Load Config Table
	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
	CFG_FireMode    = class'KFXTools'.static.GetConfigTable(12);
	CFG_WeapTrack   = class'KFXTools'.static.GetConfigTable(16);

	if ( !CFG_Weapon.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Attr Table): "$KFXWeaponID);
		return;
	}
	if ( !CFG_WeapTrack.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (WeapTrack Table): "$KFXWeaponID);
		return;
	}

	// Set HandID
	KFXFPHandID = CFG_Weapon.GetInt("FPHand");
    bIsDoubleComponent = CFG_Weapon.GetBool("bIsDoubleComponent");
	// Set Accessory
	for (loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++)
	{
		KFXAccessory[loop] = CFG_Weapon.GetInt("Accessory"$loop);
	}
//const KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM = 1;  //<ÓÐ¶àÉÙÖÖ»¤¼×µÈ¼¶
//const KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM = 2;//<ÓÐ¶àÉÙÖÖ»¤¼×¿¨£¬ÏÖÔÚ°üÀ¨Í·¿øºÍ»¤¼×£¨·À»¤ÉíÌå£©
	for ( loopi = 0; loopi<KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM; loopi++ )
	{
		for( loopj = 0; loopj<KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM; loopj++ )
		{
			KFXWeaponArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] = CFG_Weapon.GetFloat("Armor"$(loopi+1)$"Level"$(loopj+1)$"ReducePct");
		}
	}

	// Set Fire Mode
	ModeID1 = CFG_Weapon.GetInt("FireMode1");
	ModeID2 = CFG_Weapon.GetInt("FireMode2");

	if ( !CFG_FireMode.SetCurrentRow(ModeID1) )
	{
		Log("[Kevin] Can't Resolve The FireMode ID: "$ModeID1);
		return;
	}
	log("Weapon name:"$CFG_Weapon.GetString("Name"));
	Split( CFG_FireMode.GetString("Class"), ".", strParts );
	FireModeClass[0] = class<WeaponFire>( DynamicLoadObject( "XXXWeapons.XXX_"$CFG_Weapon.GetString("Name")$"_"$strParts[strParts.Length-1]$"0", class'Class' ,true) );

	if ( !CFG_FireMode.SetCurrentRow(ModeID2) )
	{
		Log("[Kevin] Can't Resolve The FireMode ID: "$ModeID2);
		return;
	}
	Split( CFG_FireMode.GetString("Class"), ".", strParts );
	FireModeClass[1] = class<WeaponFire>( DynamicLoadObject( "XXXWeapons.XXX_"$CFG_Weapon.GetString("Name")$"_"$strParts[strParts.Length-1]$"1", class'Class' ,true) );
	log("Weapon ID"$KFXWeaponID$"FireMode0"$FireModeClass[0]$"FireMode1"$FireModeClass[1]);

	log("AttachmentClass:"$"XXXWeapons.XXX_"$CFG_Weapon.GetString("Name")$"Attachment");
	AttachmentClass = class<WeaponAttachment>( DynamicLoadObject( "XXXWeapons.XXX_"$CFG_Weapon.GetString("Name")$"Attachment", class'Class' ,true) );
	PickupClass = class<WeaponPickup>( DynamicLoadObject( "XXXWeapons.XXX_"$CFG_Weapon.GetString("Name")$"Pickup", class'Class' ,true) );

	// Set Common Attributes
	InventoryGroup      = CFG_Weapon.GetInt("InvGroup");
	Priority            = CFG_Weapon.GetInt("Priority");

	KFXReloadMode       = CFG_Weapon.GetInt("ReloadMode");
	KFXPreReloadTime    = CFG_Weapon.GetFloat("PreReloadTime");
	KFXNormalReloadTime = CFG_Weapon.GetFloat("NormalReloadTime");
	KFXNullReloadTime   = CFG_Weapon.GetFloat("NullReloadTime");
	KFXEndReloadTime    = CFG_Weapon.GetFloat("EndReloadTime");

	KFXModeDamage[0]    = CFG_Weapon.GetInt("Damage1");
	KFXModeDamage[1]    = CFG_Weapon.GetInt("Damage2");
	KFXModeRate[0]      = CFG_Weapon.GetFloat("FireRate1");
	KFXModeRate[1]      = CFG_Weapon.GetFloat("FireRate2");
	KFXModeRange[0]     = CFG_Weapon.GetInt("Range1");
	KFXModeRange[1]     = CFG_Weapon.GetInt("Range2");

//-----ÉËº¦Ó°Ïì²ÎÊý -----------------------------

	//1 ÓÐÐ§ÉËº¦¾àÀë
	KFXMode0ValidRange[0]   = CFG_Weapon.GetInt("Range1Seg1");   //
	KFXMode0ValidRange[1]   = CFG_Weapon.GetInt("Range1Seg2");   //
	KFXMode0ValidRange[2]   = CFG_Weapon.GetInt("Range1Seg3");   //
	KFXMode0ValidRange[3]   = CFG_Weapon.GetInt("Range1Seg4");   //
	KFXMode1ValidRange[0]   = CFG_Weapon.GetInt("Range2Seg1");   //
	KFXMode1ValidRange[1]   = CFG_Weapon.GetInt("Range2Seg2");   //
	KFXMode1ValidRange[2]   = CFG_Weapon.GetInt("Range2Seg3");   //
	KFXMode1ValidRange[3]   = CFG_Weapon.GetInt("Range2Seg4");   //


	//2 ÉËº¦°Ù·Ö±È
	KFXMode0ValidDmgFactor[0]    = CFG_Weapon.GetFloat("Range1DmgFactor1"); //
	KFXMode0ValidDmgFactor[1]    = CFG_Weapon.GetFloat("Range1DmgFactor2"); //
	KFXMode0ValidDmgFactor[2]    = CFG_Weapon.GetFloat("Range1DmgFactor3"); //
	KFXMode0ValidDmgFactor[3]    = CFG_Weapon.GetFloat("Range1DmgFactor4"); //
	KFXMode1ValidDmgFactor[0]    = CFG_Weapon.GetFloat("Range2DmgFactor1"); //
	KFXMode1ValidDmgFactor[1]    = CFG_Weapon.GetFloat("Range2DmgFactor2"); //
	KFXMode1ValidDmgFactor[2]    = CFG_Weapon.GetFloat("Range2DmgFactor3"); //
	KFXMode1ValidDmgFactor[3]    = CFG_Weapon.GetFloat("Range2DmgFactor4"); //
//-----------ÆðÌøºÍÔÚ¿ÕÖÐ¿ØÖÆ²ÎÊý---------------------
	KFXCanJumpFire               = CFG_Weapon.GetBool("bCanJumpFire");
	KFXCanJumpSwitchState        = CFG_Weapon.GetBool("bJumpSwitchState");
	KFXLandFireStopSec           = CFG_Weapon.GetFloat("LandFireStopSec");
//------------------------------------------

	KFXModeMomentum[0]      = CFG_Weapon.GetInt("Momentum1");
	KFXModeMomentum[1]      = CFG_Weapon.GetInt("Momentum2");
	KFXModeAmmoPerFire[0]   = CFG_Weapon.GetInt("AmmoPerFire1");
	KFXModeAmmoPerFire[1]   = CFG_Weapon.GetInt("AmmoPerFire2");
	KFXModeShotPerFire[0]   = CFG_Weapon.GetInt("ShotPerFire1");
	KFXModeShotPerFire[1]   = CFG_Weapon.GetInt("ShotPerFire2");
	KFXShareAmmo            = CFG_Weapon.GetBool("ShareAmmo");

	KFXCrossWoodLength[0]      = CFG_Weapon.GetInt("WoodPTFactor1");
	KFXCrossWoodLength[1]      = CFG_Weapon.GetInt("WoodPTFactor2");
	KFXModeWoodPTDmg[0]         = CFG_Weapon.GetFloat("WoodPTDmg1");
	KFXModeWoodPTDmg[1]         = CFG_Weapon.GetFloat("WoodPTDmg2");

	KFXCrossMetalLength[0]      = CFG_Weapon.GetInt("MetalPTFactor1");
	KFXCrossMetalLength[1]      = CFG_Weapon.GetInt("MetalPTFactor2");
	KFXModeMetalPTDmg[0]         = CFG_Weapon.GetFloat("MetalPTDmg1");
	KFXModeMetalPTDmg[1]         = CFG_Weapon.GetFloat("MetalPTDmg2");

	KFXCrossOtherLength[0]      = CFG_Weapon.GetInt("OtherPTFactor1");
	KFXCrossOtherLength[1]      = CFG_Weapon.GetInt("OtherPTFactor2");
	KFXModeOtherPTDmg[0]         = CFG_Weapon.GetFloat("OtherPTDmg1");
	KFXModeOtherPTDmg[1]         = CFG_Weapon.GetFloat("OtherPTDmg2");



	KFXHeadKillProp[0]      = CFG_Weapon.GetFloat("HeadKillProp1");
	KFXHeadKillProp[1]      = CFG_Weapon.GetFloat("HeadKillProp2");

	KFXAddHeadKill[0]      = CFG_Weapon.GetFloat("HeadKill1");
	KFXAddHeadKill[1]      = CFG_Weapon.GetFloat("HeadKill2");
	KFXReHeadKill[0]      = CFG_Weapon.GetFloat("ReHeadKill1");
	KFXReHeadKill[1]      = CFG_Weapon.GetFloat("ReHeadKill2");

	KFXModeArmorPct[0]      = CFG_Weapon.GetFloat("ArmorPct1");
	KFXModeArmorPct[1]      = CFG_Weapon.GetFloat("ArmorPct2");

	for ( loopi = 0; loopi<KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM; loopi++ )
	{
		for( loopj = 0; loopj<KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM; loopj++ )
		{

			KFXModeDmgArmorPct[0].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] = CFG_Weapon.GetFloat("Armor"$(loopi+1)$"Level"$(loopj+1)$"Pct1");
			//KFXModeDmgArmorPct[0].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] *= KFXPlayer(Instigator.Controller).KFXGetSuitBodyArmor();
		}
	}
	for ( loopi = 0; loopi<KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM; loopi++ )
	{
		for( loopj = 0; loopj<KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM; loopj++ )
		{
			KFXModeDmgArmorPct[1].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] = CFG_Weapon.GetFloat("Armor"$(loopi+1)$"Level"$(loopj+1)$"Pct2");
			//KFXModeDmgArmorPct[1].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] *= KFXPlayer(Instigator.Controller).KFXGetSuitHeadArmor();
		}
	}
	PunchAngleDecayDamp[0] = CFG_Weapon.GetFloat("PunchDecayDamp1");
	PunchAngleDecayDamp[1] = CFG_Weapon.GetFloat("PunchDecayDamp2");
	PunchAngleDecaySpring[0] = CFG_Weapon.GetFloat("PunchDecaySpring1");
	PunchAngleDecaySpring[1] = CFG_Weapon.GetFloat("PunchDecaySpring2");
	// Set Speed
	KFXSpeedFactor[0] = CFG_Weapon.GetFloat("SpeedFactor1");
	KFXSpeedFactor[1] = CFG_Weapon.GetFloat("SpeedFactor2");

	SpeedDownFactor[0] = CFG_Weapon.GetFloat("SpeedDownFactor1");
	SpeedDownFactor[1] = CFG_Weapon.GetFloat("SpeedDownFactor2");
	SpeedDownTime[0] = CFG_Weapon.GetFloat("SpeedDownTime1");
	SpeedDownTime[1] = CFG_Weapon.GetFloat("SpeedDownTime2");


	// Set Ammo
	KFXAmmoCount[0]     = CFG_Weapon.GetInt("Ammo1");
	KFXAmmoCount[1]     = CFG_Weapon.GetInt("Ammo2");
	KFXReloadMax[0]     = CFG_Weapon.GetInt("ReloadMax1");
	KFXReloadMax[1]     = CFG_Weapon.GetInt("ReloadMax2");
	KFXReload[0]        = KFXReloadMax[0];
	KFXReload[1]        = KFXReloadMax[1];
	KFXClientSimReload[0] = KFXReload[0];
	KFXClientSimReload[1] = KFXReload[1];

	KFXCornerStaticShotsCount[0] = CFG_WeapTrack.GetInt("CornerStaticShots1");
	KFXCornerStaticShotsCount[1] = CFG_WeapTrack.GetInt("CornerStaticShots2");

	// Other
	self.BringUpTime    = CFG_Weapon.GetFloat("TimeBringUp");
	//--·þÎñÆ÷¸ù¾ÝÄ£Ê½²»Í¬½øÐÐ¶ÔÊôÐÔµÄÉèÖÃ        ¸Ã´úÂëÎÞÓÃ£¬ÏÖÔÚ¸ÄÎªÏÂÃæµÄº¯ÊýÁË
//    if ( Level.NetMode == NM_DedicatedServer )
//        KFXGameInfo(Level.Game).AdjustWeapAttribute( self );
}
function  AdjustWeapAttribute()
{
	if ( Level.NetMode == NM_DedicatedServer )
	{
		if(Level.Game != none)
		{
			KFXGameInfo(Level.Game).AdjustWeapAttribute( self );
		}
	}
}
// ¸½¼Óµ¯¼Ð
// Server Only
function KFXSetupAddonAmmo(KFXPawn p)
{
	local int weaponHighID;
	local int factor;
	if(p == none)
		return;

	//pawn µÄ¹Ò¼þÊôÐÔ»¹Ã»ÓÐ¼Ó½øÀ´
	if(p.time_calculate_decoration != 4)
	{
		return;
	}
	// Add on Ammo
//    if ( p != none  )
//    {
//        if (  InventoryGroup < 4 && KFXReloadMax[0] > 0 && KFXReloadMax[0] < 10000 )
//        {
//            KFXAmmoCount[0] += p.KFXReloadAddon * KFXReloadMax[0];
//        }
//
//        if ( !KFXShareAmmo )
//        {
//            if (InventoryGroup < 4 && KFXReloadMax[1] > 0 && KFXReloadMax[1] < 10000 )
//            {
//                KFXAmmoCount[1] += p.KFXReloadAddon * KFXReloadMax[1];
//            }
//        }
//    }

	//¼ì²éÎäÆ÷µÄÀàÐÍ£¬²»Í¬µÄÎäÆ÷£¬¸½¼Óµ¯¼ÐÊ¹ÓÃµÄÏµÊý²»Ò»Ñù
	weaponHighID = KFXWeaponID >> 16;

	switch(weaponHighID)
	{
		case 1:
			factor = p.TotalBackAmmoForRifle;
			break;
		case 2:
			factor = p.TotalBackAmmoForSubMachine;
			break;
		case 3:
			factor = p.TotalBackAmmoForSniper;
			break;
		case 4:
			factor = p.TotalBackAmmoForShotgun;
			break;
		case 5:
			factor = p.TotalBackAmmoForMachinegun;
			break;
		case 31:
			factor = p.TotalBackAmmoForPistol;
			break;
		default:
			factor = 0;
			break;
	}

	if ( p != none  )
	{
		if (  InventoryGroup < 4 && KFXReloadMax[0] > 0 && KFXReloadMax[0] < 10000 )
		{
			KFXAmmoCount[0] += factor * KFXReloadMax[0];
		}

		if ( !KFXShareAmmo )
		{
			if (InventoryGroup < 4 && KFXReloadMax[1] > 0 && KFXReloadMax[1] < 10000 )
			{
				KFXAmmoCount[1] += factor * KFXReloadMax[1];
			}
		}
	}


}


// ÔØÈë¿ÉÅäÖÃÊôÐÔ
simulated function KFXSetupCfgData()
{
	;

	// TODO:
}
simulated function csvKFXSetupCfgData()
{
	;

	// TODO:
}

// ³õÊ¼»¯ÎäÆ÷¿ª»ðÂß¼­
simulated function csvKFXSetupFireModes()
{
}
simulated function KFXSetupFireModes()
{
	// ²úÉúFireModeÊµÀý,²¢Íê³É³õÊ¼»¯
	local int m;
	local int FireModeID[NUM_FIRE_MODES];
	local KFXCSVTable CFG_Weapon;

	;


	// Check Already Setup
	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if ( FireMode[m] != none )
			return;
	}

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireModeClass[m] != None)
		{
			FireMode[m] = new(self) FireModeClass[m];
		}
	}
	InitWeaponFires();

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m] != None)
		{
			FireMode[m].ThisModeNum = m;
			FireMode[m].Weapon = self;
			FireMode[m].Instigator = Instigator;
			FireMode[m].Level = Level;
			FireMode[m].Owner = self;
			FireMode[m].PreBeginPlay();
			FireMode[m].BeginPlay();
			FireMode[m].PostBeginPlay();
			FireMode[m].SetInitialState();
			FireMode[m].PostNetBeginPlay();

			KFXFireBase(FireMode[m]).KFXInit(KFXWeaponID);

		}
	}

	/*
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
		MaxLights = Min(4,MaxLights);

	if ( SmallViewOffset == vect(0,0,0) )
		SmallViewOffset = Default.PlayerviewOffset;

	if ( SmallEffectOffset == vect(0,0,0) )
		SmallEffectOffset = EffectOffset + Default.PlayerViewOffset - SmallViewOffset;

	if ( bUseOldWeaponMesh && (OldMesh != None) )
	{
		bInitOldMesh = true;
		LinkMesh(OldMesh);
	}
	if ( Level.GRI != None )
		CheckSuperBerserk();
	*/
}

// ³õÊ¼»¯ÉùÒô×ÊÔ´(Client & Server)
simulated function KFXSetupSoundData()
{
}
simulated function csvKFXSetupSoundData()
{
	local KFXCSVTable CFG_Media, CFG_Sound;
	local int nTemp;

	;

	// ¼ÓÔØÅäÖÃÎÄ¼þ
	CFG_Media      = class'KFXTools'.static.GetConfigTable(10);
	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);

	if ( !CFG_Media.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Media Table): "$KFXWeaponID);
		return;
	}

//   ÓÉÃÀÊõ°î¶¨¸ÃÉùÒô
//    nTemp = CFG_Media.GetInt( "SndSelect" );
//    if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
//    {
//        SelectSound =
//            Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
//    }

	nTemp = CFG_Media.GetInt( "SndTPFire1" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndTPFire[0] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	nTemp = CFG_Media.GetInt( "SndTPFire2" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndTPFire[1] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	nTemp = CFG_Media.GetInt( "SndFPFire11" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[0] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase--000----nTemp "$nTemp);
	log("KFXWeapBase--000----KFXSndFPFire[0] "$KFXSndFPFire[0]);

	nTemp = CFG_Media.GetInt( "SndFPFire12" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[1] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase--111----nTemp "$nTemp);
	log("KFXWeapBase--111----KFXSndFPFire[1] "$KFXSndFPFire[1]);

	nTemp = CFG_Media.GetInt( "SndFPFire13" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[2] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase---222---nTemp "$nTemp);
	log("KFXWeapBase---222---KFXSndFPFire[2] "$KFXSndFPFire[2]);

	nTemp = CFG_Media.GetInt( "SndFPFire14" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[3] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase--333----nTemp "$nTemp);
	log("KFXWeapBase--333----KFXSndFPFire[3] "$KFXSndFPFire[3]);

	nTemp = CFG_Media.GetInt( "SndFPFire21" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[4] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase--444----nTemp "$nTemp);
	log("KFXWeapBase--444----KFXSndFPFire[4] "$KFXSndFPFire[4]);

	nTemp = CFG_Media.GetInt( "SndFPFire22" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[5] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase--555----nTemp "$nTemp);
	log("KFXWeapBase--555----KFXSndFPFire[5] "$KFXSndFPFire[5]);

	nTemp = CFG_Media.GetInt( "SndFPFire23" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[6] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase--666----nTemp "$nTemp);
	log("KFXWeapBase--666----KFXSndFPFire[6] "$KFXSndFPFire[6]);

	nTemp = CFG_Media.GetInt( "SndFPFire24" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[7] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	log("KFXWeapBase---777---nTemp "$nTemp);
	log("KFXWeapBase---777---KFXSndFPFire[7] "$KFXSndFPFire[7]);

	nTemp = CFG_Media.GetInt( "SndReload" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndReload =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	nTemp = CFG_Media.GetInt( "SndNoammo" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndNoammo =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
}
// ³õÊ¼»¯ÎäÆ÷µÚÒ»ÈË³Æ±íÏÖÂß¼­
simulated function KFXSetupRenderData()
{
	local KFXPlayer Player;
	local int  axisType;


	Player = KFXPlayer(Level.GetLocalPlayerController());
	axisType = Player.DrawWeaponAXIS;

	ExchangeWeaponAxisType(axisType);

}
// ³õÊ¼»¯ÎäÆ÷µÚÒ»ÈË³Æ±íÏÖÂß¼­
simulated function csvKFXSetupRenderData()
{
	local KFXCSVTable CFG_Media, CFG_Accessory;
	local string MeshName, MaterialName, SkelName;
	local name nTemp;
	local bool bManuFixed;
	local int  loop;
	local string TexString;
	local Material mat;
	;

//    KFXWeapHotTex = texture(DynamicLoadObject(KFXWeapHotStr, class'texture'));
//    KFXWeapHotBGTex = texture(DynamicLoadObject(KFXWeapHotBGStr, class'texture'));

	// ¼ÓÔØÅäÖÃÎÄ¼þ
	CFG_Media      = class'KFXTools'.static.GetConfigTable(10);
	CFG_Accessory  = class'KFXTools'.static.GetConfigTable(13);

	if ( !CFG_Media.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Media Table): "$KFXWeaponID);
		return;
	}

	// ¼ÓÔØÏÔÊ¾ÅäÖÃ²ÎÊý
	for ( loop = 1; loop < 3; loop++ )
	{
		KFXDefDisplayFov[loop-1] = CFG_Media.GetFloat("DisplayFOV"$loop);

		KFXPlayerViewOffset[loop-1].X = CFG_Media.GetFloat("ViewOffsetX"$loop);
		KFXPlayerViewOffset[loop-1].Y = CFG_Media.GetFloat("ViewOffsetY"$loop);
		KFXPlayerViewOffset[loop-1].Z = CFG_Media.GetFloat("ViewOffsetZ"$loop);

		KFXPlayerViewPivot[loop-1].Pitch = CFG_Media.GetInt("ViewPivotPitch"$loop);
		KFXPlayerViewPivot[loop-1].Roll  = CFG_Media.GetInt("ViewPivotRoll"$loop);
		KFXPlayerViewPivot[loop-1].Yaw   = CFG_Media.GetInt("ViewPivotYaw"$loop);
	}
	KFXMouseSens[0]            = CFG_Media.GetFloat("MouSensFac1");
	KFXMouseSens[1]            = CFG_Media.GetFloat("MouSensFac2");

	// TODO: ÆäËûÅäÖÃ²ÎÊý

	// ¼ÓÔØÊÖ±ÛÄ£ÐÍ,²ÄÖÊ
	if ( !CFG_Accessory.SetCurrentRow(KFXFPHandID) )
	{
		Log("[Kevin] Can't Resolve the FP Main Accessory (Hand) ID:"$KFXAccessory[0] );
	}


	MeshName = CFG_Accessory.GetString("FPMesh");
	SkelName = CFG_Accessory.GetString("FPSkeleton");
	MaterialName = CFG_Accessory.GetString("FPMaterial");
	bManuFixed = CFG_Accessory.GetBool("ManuFix");
	LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );

	if ( !(SkelName ~= "null" ))
		LinkSkelAnim(
			MeshAnimation(DynamicLoadObject(SkelName, class'MeshAnimation'))
			);

	if(bManuFixed)
	{
		log("[weaponbase] manufixed skins");

		for( loop=0; loop<12; loop++ )
		{
			TexString = "FPMaterial"$loop;
			TexString = CFG_Accessory.GetString(TexString);

			if(TexString ~= "null"||TexString~="")
			{
				;
				break;
			}

			mat = Material( DynamicLoadObject( TexString, class'Material' ) );
			if( mat!=none )
			{
				if( Skins.Length <= loop )
				{
					Skins.Insert( Skins.Length, 1);
				}
				Skins[loop] = mat;
			}
			else
			{
				;
				break;
			}
		}
	}
	BoneRefresh();

	// ¼ÓÔØÊÖÄ£ÐÍ,²ÄÖÊ
	// Fixme! ·þÎñÆ÷Ä£Ê½ÏÂ²»¹ÜÓÃ£¬ÕÒ²»µ½Instigator
	//KFXSetWeaponMaterial();  // Set Hand Material

	// ¼ÓÔØÁã¼þÄ£ÐÍ
	/* Ä¿Ç°°æ±¾²»¿ªÆôÁã¼þÄ£Ê½
	for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
	{
		if ( KFXAccessory[loop] != 0 )
		{
			KFXAccessoryMesh[loop] = Spawn(class'KFXWeapAccesory');
			KFXAccessoryMesh[loop].KFXInit(KFXAccessory[loop], self, true);
		}
	}
	*/

	// ¼ÓÔØ¶¯»­ÅäÖÃÎÄ¼þ
	nTemp = CFG_Media.GetName("IdleAni");
	if ( nTemp != '0' )
	{
		IdleAnim        = nTemp;
		IdleAnimRate    = CFG_Media.GetFloat("IdleAniRate");
	}

	nTemp = CFG_Media.GetName("RestAni");
	if ( nTemp != '0' )
	{
		RestAnim = nTemp;
		RestAnimRate = CFG_Media.GetFloat("RestAniRate");
	}

	nTemp = CFG_Media.GetName("AimAni");
	if ( nTemp != '0' )
	{
		AimAnim = nTemp;
		AimAnimRate = CFG_Media.GetFloat("AimAniRate");
	}

	nTemp = CFG_Media.GetName("RunAni");
	if ( nTemp != '0' )
	{
		RunAnim = nTemp;
		RunAnimRate = CFG_Media.GetFloat("RunAniRate");
	}

	nTemp = CFG_Media.GetName("SelectAni");
	if ( nTemp != '0' )
	{
		SelectAnim = nTemp;
		SelectAnimRate = CFG_Media.GetFloat("SelectAniRate");
	}

	nTemp = CFG_Media.GetName("PutDownAni");
	if ( nTemp != '0' )
	{
		PutDownAnim = nTemp;
		PutDownAnimRate = CFG_Media.GetFloat("PutDownAniRate");
	}

	nTemp = CFG_Media.GetName("PreReloadAni");
	if ( nTemp != '0' )
	{
		StartReloadAnim = nTemp;
		StartReloadAnimRate = CFG_Media.GetFloat("PreReloadAniRate");
	}

	nTemp = CFG_Media.GetName("ReloadNormalAni");
	if ( nTemp != '0' )
	{
		ReloadNormalAnim = nTemp;
		ReloadNormalAnimRate = CFG_Media.GetFloat("ReloadNormalAniRate");
	}

	nTemp = CFG_Media.GetName("ReloadNullAni");
	if ( nTemp != '0' )
	{
		ReloadNullAnim = nTemp;
		ReloadNullAnimRate = CFG_Media.GetFloat("ReloadNullAniRate");
	}

	nTemp = CFG_Media.GetName("EndReloadAni");
	if ( nTemp != '0' )
	{
		AfterReloadAnim = nTemp;
		AfterReloadAnimRate = CFG_Media.GetFloat("EndReloadAniRate");
	}

	//½èµØ·½¶ÁÈëÇÐÇ¹Ê±µÄ½øÊ¾
	KFXBringUpHint = CFG_Media.GetString("BringUpHintStr");
}

simulated function ExchangeWeaponAxisType( int Type )
{
	// View Params
	DisplayFOV              = KFXDefDisplayFov[Type];
	PlayerViewOffset        = KFXPlayerViewOffset[Type];
	PlayerViewPivot         = KFXPlayerViewPivot[Type];

	KFXInitPlayerViewOffset = PlayerViewOffset;
	KFXInitPlayerViewPivot  = PlayerViewPivot;
	log("ExchangeWeaponAxisType PlayerViewOffset:"$PlayerViewOffset$"PlayerViewPivot:"$PlayerViewPivot);

}

simulated function float KFXGetDefDisplayFov()
{
	local KFXPlayer  Player;

	if ( Instigator != none && Instigator.Controller != none )
	{
		Player = KFXPlayer(Instigator.Controller);
	}

	if(Player != none)
	{
		return KFXDefDisplayFov[Player.DrawWeaponAXIS];
	}
	else         //Ô¤·ÀPlayerÎªnone
	{
		return KFXDefDisplayFov[0];
	}
}
// ====================================================================
// Getter & Setter
// ====================================================================

simulated function int KFXGetWeaponID()
{
	return KFXWeaponID;
}

// Server Only!!
simulated function KFXSetFireGroup(int FireGroup)
{
	KFXFireGroup = FireGroup;
}

simulated function int KFXGetFireGroup()
{
	return KFXFireGroup;
}

// GetFireMode
simulated function KFXFireBase KFXGetFireMode(int mode)
{
	return KFXFireBase(FireMode[mode]);
}

simulated function float KFXGetSpeedFactor()
{
	local float RetSpeedFactor;
	local int loop;
	RetSpeedFactor = 0;
	for(loop = 0; loop < 6; loop ++)
	{
		if(KFXWeapComponent[loop] != none )
		{
			RetSpeedFactor+=KFXWeapComponent[loop].KFXSpeedFactor[KFXFireGroup];
		}
	}
	RetSpeedFactor += KFXSpeedFactor[KFXFireGroup];
	return RetSpeedFactor;
}

/// Ammo & Reload ///

simulated function bool KFXIsShareAmmo()
{
	return KFXShareAmmo;
}
simulated function int KFXGetAmmoMax(int mode)
{
return KFXMaxAmmo[mode];
}
simulated function int KFXGetAllAmmo()
{
	local int Ammos;
	local int loop;
	Ammos = 0;

	if ( KFXShareAmmo )
	{
		for(loop = 0; loop < 6; loop ++)
		{
			if(KFXWeapComponent[loop] != none )
			{
				Ammos+=KFXWeapComponent[loop].KFXAmmoCount[0];
			}
		}
		Ammos += KFXAmmoCount[0];

		return Ammos;
	}

	for(loop = 0; loop < 6; loop ++)
	{
		if(KFXWeapComponent[loop] != none )
		{
			Ammos+=KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup];
		}
	}
	Ammos += KFXAmmoCount[KFXFireGroup];

	return Ammos;
}

simulated function int KFXGetAmmo()
{
	 if ( KFXShareAmmo )
		return KFXAmmoCount[0];

	return KFXAmmoCount[KFXFireGroup];
}

simulated function KFXSetAmmo(int Ammo)
{
	if ( KFXShareAmmo )
		KFXAmmoCount[0] = Ammo;

	KFXAmmoCount[KFXFireGroup] = Ammo;
}
simulated function KFXSetMaxAmmo(int Ammo)
{
	if ( KFXShareAmmo )
		KFXMaxAmmo[0] = Ammo;

	KFXMaxAmmo[KFXFireGroup] = Ammo;
}
simulated function int KFXGetReload()
{
	if ( KFXShareAmmo )
		return KFXReload[0];

	return KFXReload[KFXFireGroup];
}

simulated function KFXSetReload(int Reload)
{
	if ( KFXShareAmmo )
		KFXReload[0] = Reload;

	KFXReload[KFXFireGroup] = Reload;
}

simulated function int KFXGetReloadMax()
{
	local int ReloadMax;
	local int loop;
	ReloadMax = 0;

	if ( KFXShareAmmo )
	{
		for(loop = 0; loop < 6; loop ++)
		{
			if(KFXWeapComponent[loop] != none )
			{
				ReloadMax+=KFXWeapComponent[loop].KFXReloadMax[0];
			}
		}
		ReloadMax += KFXReloadMax[0];

		return ReloadMax;
	}

	for(loop = 0; loop < 6; loop ++)
	{
		if(KFXWeapComponent[loop] != none )
		{
			ReloadMax+=KFXWeapComponent[loop].KFXReloadMax[KFXFireGroup];
		}
	}
	ReloadMax += KFXReloadMax[KFXFireGroup];

	return ReloadMax;
}

simulated function int KFXGetSimReload()
{
	if ( KFXShareAmmo )
		return KFXClientSimReload[0];

	return KFXClientSimReload[KFXFireGroup];
}

simulated function KFXSetSimReload(int Reload)
{
	if ( KFXShareAmmo )
		KFXClientSimReload[0] = Reload;

	KFXClientSimReload[KFXFireGroup] = Reload;
}

/// Fire Mode ///

// Damage
simulated function int KFXGetDamage()
{
	local int RetModeDamage;
	local int loop;
	RetModeDamage = 0;

	for(loop = 0; loop < 6; loop ++)
	{
		if(KFXWeapComponent[loop] != none )
		{
			RetModeDamage+=KFXWeapComponent[loop].KFXModeDamage[KFXFireGroup];
		}
	}
	RetModeDamage += KFXModeDamage[KFXFireGroup];

	return RetModeDamage;
}

function ServerTakePBDamage(Pawn Instigator,Pawn DamagedPerson,int KFXFireGroup,class<DamageType> DamageType,class<DamageType> AltDamageType)
{
	//KFXPawnBase(DamagedPerson).KFXDmgInfo.DmgShakeView   = KFXFireBase(FireMode[KFXFireGroup])).KFXShakeView[KFXFireGroup];
	DamagedPerson.KFXDmgInfo.DmgShakeView   = KFXFireBase(FireMode[KFXFireGroup]).KFXShakeView[KFXFireGroup];
	if ( KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].BitState >= 0 )
	{
		if ( KFXFireGroup == 0 || AltDamageType == none )
			KFXPawn(DamagedPerson).KFXTakePBDamage(Instigator, DamageType,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].BitState,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Timer,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param1,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param2);
		else
			KFXPawn(DamagedPerson).KFXTakePBDamage(Instigator, AltDamageType,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].BitState,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Timer,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param1,
				KFXFireBase(FireMode[KFXFireGroup]).KFXPBDamageType[KFXFireGroup].Param2);
	}
}

simulated function int KFXGetGroupDmg( int FireGroup )
{
	local int RetModeDamage;
	local int loop;
	RetModeDamage = 0;

	for(loop = 0; loop < 6; loop ++)
	{
		if(KFXWeapComponent[loop] != none )
		{
			RetModeDamage+=KFXWeapComponent[loop].KFXModeDamage[FireGroup];
		}
	}
	RetModeDamage += KFXModeDamage[FireGroup];

	return RetModeDamage;
}

simulated function KFXSetGroupDamage( int dmg, int FireGroup )
{
	KFXModeDamage[FireGroup] = dmg;
}
simulated function KFXClientSetGroupDamage( int dmg1, int FireGroup1, int dmg2, int FireGroup2)
{
	KFXModeDamage[FireGroup1] = dmg1;
	KFXModeDamage[FireGroup2] = dmg2;
}
// Rate
simulated function float KFXGetRate()
{
	local float RetModeRate;
	local int loop;
	RetModeRate = 0;

	for(loop = 0; loop < 6; loop ++)
	{
		if(KFXWeapComponent[loop] != none )
		{
			RetModeRate+=KFXWeapComponent[loop].KFXModeRate[KFXFireGroup];
		}
	}
	RetModeRate += KFXModeRate[KFXFireGroup];

	if( instigator != none )
		if( instigator.Controller != none )
			if( KFXBot(instigator.Controller) != none )
				return RetModeRate*(1.0 + KFXBot(instigator.Controller).kfx_firerate);

	return RetModeRate;
}
// Range
simulated function int KFXGetRange()
{
	return KFXModeRange[KFXFireGroup];
}
simulated function int KFXGetSpecificRange(int KFXFireGroup)
{
	return KFXModeRange[KFXFireGroup];
}
simulated function KFXSetRange(int Range)
{
	KFXModeRange[KFXFireGroup] = Range;
}
//------»ñµÃ¸ÃdistËùÔÚµÄÓÐÐ§ÇøÓò
simulated function int KFXGetValidRange(int Segment)
{
	if(KFXFireGroup==0)
	return KFXMode0ValidRange[Segment];
	if(KFXFireGroup==1)
	return KFXMode1ValidRange[Segment];
	return -1;
}

simulated function float KFXGetValidDmgFactor(int Segment)
{
	if(KFXFireGroup==0)
	return KFXMode0ValidDmgFactor[Segment];
	if(KFXFireGroup==1)
	return KFXMode1ValidDmgFactor[Segment];
	return -1;
}

simulated function float KFXGetPunchAngleDecayDamp()
{
	return PunchAngleDecayDamp[KFXFireGroup];
}
simulated function float KFXGetPunchAngleDecaySpring()
{
	return PunchAngleDecaySpring[KFXFireGroup];
}
simulated function float KFXGetHeadKillProp()
{
	return KFXHeadKillProp[KFXFireGroup];
}

///
/// ÖÓ£º±¬Í·¿¨Óë·Å±¬Í·¿¨Ïà¹ØÊý¾Ý
///
simulated function float KFXGetAddHeadKill()
{
	return KFXAddHeadKill[KFXFireGroup];
}

simulated function float KFXGetReHeadKill()
{
	return KFXReHeadKill[KFXFireGroup];
}


// Penetration
//simulated function int KFXGetPenetrationFactor()
//{
//    return KFXModePTFactor[KFXFireGroup];
//}
//simulated function float KFXGetPenetrationDmg()
//{
//  return KFXModePTDmg[KFXFireGroup];
//}
//´©Ä¾Í·£¬½ðÊô£¬ÆäËû¸÷ÖÖ²ÄÖÊ
simulated function int GetCrossWoodLength()
{
	return KFXCrossWoodLength[KFXFireGroup];
}
simulated function int GetCrossMetalLength()
{
	return KFXCrossMetalLength[KFXFireGroup];
}
simulated function int GetCrossOtherLength()
{
	return KFXCrossOtherLength[KFXFireGroup];
}

//´©Ä¾Í·£¬½ðÊô£¬ÆäËû¸÷ÖÖ²ÄÖÊÉËº¦Ë¥¼õ
simulated function float GetCrossWoodDmg()
{
	return KFXModeWoodPTDmg[KFXFireGroup];
}
simulated function float GetCrossMetalDmg()
{
	return KFXModeMetalPTDmg[KFXFireGroup];
}
simulated function float GetCrossOtherDmg()
{
	return KFXModeOtherPTDmg[KFXFireGroup];
}


// Ammos
simulated function int KFXGetAmmoPerFire()
{
	return KFXModeAmmoPerFire[KFXFireGroup];
}

simulated function int KFXGetShotPerFire()
{
	return KFXModeShotPerFire[KFXFireGroup];
}

simulated function int KFXGetMomentum()
{
	return KFXModeMomentum[KFXFireGroup];
}

// Armor Pct.
simulated function float KFXGetArmorPct()
{
	return KFXModeArmorPct[KFXFireGroup];;
}
simulated function float KFXGetDmgArmorPct( int loop )
{
	local float RetModeDmgArmorPct;
	local int loop1;
	RetModeDmgArmorPct = 0;

	for(loop1 = 0; loop1 < 6; loop1 ++)
	{
		if(KFXWeapComponent[loop1] != none )
		{
			RetModeDmgArmorPct+=KFXWeapComponent[loop1].KFXModeDmgArmorPct[KFXFireGroup].ArmorPct[loop];
		}
	}
	if(KFXFireGroup == 0)
	{
		RetModeDmgArmorPct +=  KFXModeDmgArmorPct[KFXFireGroup].ArmorPct[loop];// * KFXPlayer(Instigator.Controller).KFXGetSuitBodyArmor();
	}
	else
	{
		if(KFXFireGroup != 1)
			log("#### ERROR #### calculate error in KFXGetDmgArmorPct");
		RetModeDmgArmorPct +=  KFXModeDmgArmorPct[KFXFireGroup].ArmorPct[loop];// * KFXPlayer(Instigator.Controller).KFXGetSuitHeadArmor();
	}
	return RetModeDmgArmorPct;
}

simulated function float KFXGetWeapArmorPct( int loop )
{
	local float RetWeapArmorPct;
	local int loop1;
	RetWeapArmorPct = 0;

	for(loop1 = 0; loop1 < 6; loop1 ++)
	{
		if(KFXWeapComponent[loop1] != none )
		{
			RetWeapArmorPct+=KFXWeapComponent[loop1].KFXWeaponArmorPct[loop];
		}
	}
	RetWeapArmorPct +=  KFXWeaponArmorPct[loop];
	return RetWeapArmorPct;
}



simulated function float KFXGetSpeedDownFactor()
{
	return SpeedDownFactor[KFXFireGroup];
}
simulated function float KFXGetSpeedDownTime()
{
	return SpeedDownTime[KFXFireGroup];
}

// Sound
simulated function sound KFXGetFireSound()
{
	return KFXSndTPFire[KFXFireGroup];
}
//µÚÈýÈË³ÆÏûÒôÆ÷µÄÉùÒô
simulated function sound KFXGetTPSmallFireSound()
{
	if(KFXSndTPSmallFire[KFXFireGroup] == none)
	{
	   if(KFXWeapComponent[0].bShowAnotherFireSound)   //ÏûÒôÆ÷ÉùÒô
	   {
		  log("KFXWeapbase------KFXWeapComponent[0].KFXSndTPFireString[KFXFireGroup] "$KFXWeapComponent[0].KFXSndTPFireString[KFXFireGroup]);
		  if(KFXWeapComponent[0].KFXSndTPFireString[KFXFireGroup] != "")
		  {
			  KFXSndTPSmallFire[KFXFireGroup] = Sound(DynamicLoadObject(KFXWeapComponent[0].KFXSndTPFireString[KFXFireGroup], class'Sound'));
		  }
	   }

	}
	return KFXSndTPSmallFire[KFXFireGroup];
}
simulated function sound KFXGetFPFireSound()
{
	local int SndIndex;

	if (KFXFireGroup == 0)
	{
		SndIndex = Rand(4);
	}
	else
	{
		SndIndex = Rand(4) + 4;
	}
	return KFXSndFPFire[SndIndex];
}
simulated function sound KFXGetFPSmallFireSound()
{
	local int SndIndex;
	local int i;
	if (KFXFireGroup == 0)
	{
		SndIndex = Rand(2);
	}
	else
	{
		SndIndex = Rand(2) + 2;
	}

	if(KFXSndFPSmallFire[SndIndex] == none)
	{
	   if(i == 0)
	   {
		   if(KFXWeapComponent[i].bShowAnotherFireSound)
		   {
			  if(KFXWeapComponent[i].KFXSndFPFireString[SndIndex] != "")
			  {
				  KFXSndFPSmallFire[SndIndex] = Sound(DynamicLoadObject(KFXWeapComponent[i].KFXSndFPFireString[SndIndex], class'Sound'));
			  }
		   }
	   }
	}
	return KFXSndFPSmallFire[SndIndex];
}
simulated function sound KFXGetReloadSound()
{
	return KFXSndReload;
}

simulated function sound KFXGetNoammoSound()
{
	return KFXSndNoammo;
}

// Anim
simulated function name KFXGetAnimReload()
{

	if ( KFXGetReload() > 0 )
	{
		return ReloadNormalAnim;
	}
	else
	{
		return ReloadNullAnim;
	}
}

simulated function float KFXGetAnimReloadRate()
{
	local float reloadRate;
	local int loop;
	if ( KFXGetReload() > 0 )
	{
		reloadRate = ReloadNormalAnimRate;
		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapComponent[loop] == none)
				continue;
			reloadRate += KFXWeapComponent[loop].ReloadNormalAnimRate;
		}
		return reloadRate;
	}
	else
	{
		reloadRate = ReloadNullAnimRate;
		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapComponent[loop] == none)
				continue;
			reloadRate += KFXWeapComponent[loop].ReloadNullAnimRate;
		}
		return reloadRate;
	}
}


simulated function float KFXGetReloadTime()
{
	local float reloadTime;
	local int loop;
	if ( KFXGetReload() > 0 )
	{
		reloadTime = KFXNormalReloadTime;
		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapComponent[loop] == none)
				continue;
			reloadTime += KFXWeapComponent[loop].KFXNormalReloadTime;
		}
		return reloadTime;
	}
	else
	{
		reloadTime = KFXNullReloadTime;
		for(loop=0; loop < 6; loop++)
		{
			if( KFXWeapComponent[loop] == none)
				continue;
			reloadTime += KFXWeapComponent[loop].KFXNullReloadTime;
		}
		return reloadTime;
	}

}


simulated function name KFXGetAnimPreReload()
{
	return StartReloadAnim;
}

simulated function name KFXGetAnimEndReload()
{
	return AfterReloadAnim;
}

simulated function name KFXGetAnimIdle()
{
	return IdleAnim;
}
simulated function bool KFXGetCanJumpFire()
{
	return KFXCanJumpFire;
}
simulated function bool KFXGetCanJumpSwitchState()
{
	return KFXCanJumpSwitchState;
}

simulated function int GetCornerStaticShotsCount()
{
	return KFXCornerStaticShotsCount[KFXFireGroup];
}

//=====Ãé×¼µÄÍæ¼ÒËÀÍö
function AimDied()
{
	local int m;
	;
	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		;
		if (FireMode[m].bIsFiring)
		{
			;
			StopFire(m);
			if (FireMode[m].bFireOnRelease)
			{
				;
				FireMode[m].ModeDoFire();
			}
		}
	}
}

// ====================================================================
// »»µ¯Âß¼­
// ====================================================================

// HasAmmo?  from Weapon
simulated function bool HasAmmo()
{
	return KFXHasAmmo();
}

// HasReload?
simulated function bool KFXHasReload()
{
	if ( Level.NetMode == NM_Client )
		return KFXGetSimReload() > 0;
	else
		return KFXGetReload() > 0;
}
function ServerStopFire(byte Mode)
{
	if ( Mode == 0 && nMultiFireAmmo > 0 && bMultiFireMode )
		return;

	super.ServerStopFire(Mode);
}
// HasAmmo?
simulated function bool KFXHasAmmo()
{
	return KFXGetAllAmmo() > 0 || KFXGetReload() > 0;
}
simulated function bool KFXNeedFireBaseOnMode()
{
	return false;
}
//Consume Ammo
//Client Only        ·ÀÖ¹·þÎñÆ÷×Óµ¯ÊýÎª0£¬µ«ÊÇ¿Í»§¶Ë×Óµ¯Êý²»Îª0 bug
simulated function bool KFXClientConsumeAmmo()
{
   log("KFXWeapBase---------KFXGetReload() "$KFXGetReload());
   log("KFXWeapBase---------KFXGetAmmo() "$KFXGetAmmo());
   log("KFXWeapBase---------Self "$self);
   log("KFXWeapBase---------KFXFireGroup "$KFXFireGroup);
   log("KFXWeapBase---------KFXShareAmmo "$KFXShareAmmo);
   if(KFXGetReload() > 0 || KFXGetAmmo() > 0)
   {
		KFXSetReload(0);
		KFXSetSimReload(0);
		KFXSetAmmo(0);
	}
   return true;
}
// Consume Ammo
// Server Only
simulated function bool KFXConsumeAmmo(int load, optional bool bAmountNeededIsMax)
{
	log("KFXWeapBase KFXConsumeAmmo");
	if ( Level.NetMode == NM_Client )
	{
		if ( KFXGetSimReload() >= 10000 )
			return true;

        log("KFXWeapBase----------KFXGetSimReload()"$KFXGetSimReload());
        log("KFXWeapBase----------load "$load);

		if ( KFXGetSimReload() < load )
		{
			return false;   // Can't do it
		}

		KFXSetSimReload( KFXGetSimReload() - load );
	}
	else
	{
		if ( KFXGetReload() >= 10000 )
			return true;

		if ( KFXGetReload() < load )
		{
			return false;   // Can't do it
		}

		KFXSetReload( KFXGetReload() - load );

		///MultiFire Âß¼­£¿

		if( self.bMultiFireMode == true )
		{
			if(KFXGetReload() == 0)
			{
				nMultiFireAmmo=0;
			}
			else
			{
				nMultiFireAmmo--;
			}
		}
	}

	return true;
}
simulated function bool KFXServerConsumeAmmo(int load, optional bool bAmountNeededIsMax)
{
    log("KFXServerConsumeAmmo PlayerName: "$Instigator.PlayerReplicationInfo.PlayerName$"   WeaponID: "$KFXGetWeaponID()$"   Reload Is: "$KFXGetReload()$"   Ammo Is: "$KFXGetAmmo());
    if((KFXGetWeaponID() >> 16 >= 1 &&  KFXGetWeaponID() >> 16 <= 40) && KFXGetReload() <= 0 && KFXGetAmmo() <= 0)
    {
         KFXClientConsumeAmmo();
         log("Server Weapon No Ammo");
         return false;
    }
	if ( Level.NetMode == NM_Client )
	{
		if ( KFXGetSimReload() >= 10000 )
			return true;

		if ( KFXGetSimReload() < load )
		{
            return false;   // Can't do it
		}

		KFXSetSimReload( KFXGetSimReload() - load );
	}
	else
	{
		if ( KFXGetReload() >= 10000 )
			return true;

		if ( KFXGetReload() < load )
		{
			bNoAmmo = true;
            return false;   // Can't do it
		}
		else
		{
		    if(bNoAmmo)
		    {
		        bNoAmmo = false;
            }
        }

		KFXSetReload( KFXGetReload() - load );

		///MultiFire Âß¼­£¿

		if( self.bMultiFireMode == true )
		{
			if(KFXGetReload() == 0)
			{
				nMultiFireAmmo=0;
			}
			else
			{
				nMultiFireAmmo--;
			}
		}
	}

	return true;
}
// Stop Reload
simulated function KFXStopReload()
{
	bIsReload = false;
}

// Force Reload
// Client & Server
simulated function KFXForceReload()
{
	log("KFXPlayer-------KFXReloadMode "$KFXReloadMode);
	log("KFXPlayer-------bIsReload "$bIsReload);
	log("KFXPlayer-------FireMode[0].IsFiring() "$FireMode[0].IsFiring());
	log("KFXPlayer-------FireMode[1].IsFiring() "$FireMode[1].IsFiring());
	log("KFXPlayer-------KFXCanReload() "$KFXCanReload());

    if ( KFXReloadMode == 0
		 || bIsReload
		 || FireMode[0].IsFiring()
		 || FireMode[1].IsFiring()
		 || !KFXCanReload() )
		return;

	// call server to reload
	ServerPreReload();
}

// Can reload?
simulated function bool KFXCanReload()
{
    return ( KFXGetReload() < KFXGetReloadMax() )
	&& ( KFXGetAllAmmo() > 0 )
	&& ( KFXPawn(Instigator).bCanUseWeapon );
}

// Need Destroy?
// µ±ÇÐ³ö¸ÃÎäÆ÷Ê±Èç¹û¸Ãº¯Êý·µ»Ø¿ÕÔò×Ô¶¯Destroy¸ÃÎäÆ÷
// Server Only
function bool KFXNeedDestroy()
{
	if ( KFXMagicItemID > 0 && KFXGetReload() == 0 )
		return true;

	return false;
}

// if need to Reload
// Server & Client
simulated function bool KFXNeedReload()
{
	return KFXGetReload() == 0;
}

// reload
simulated function KFXReloadAmmo()
{
	local int AmmoToReload;
	local int loop;

	// Èç¹ûAmmo´óÓÚ10000£¬ÔòÊÓÎªÎÞÏÞ
	if ( KFXGetAmmo() >= 10000 )
	{
		KFXSetReload( KFXGetReloadMax() );
	}

	// Í¨ÓÃÉÏµ¯Âß¼­
	if ( KFXReloadMode == 2 )
		AmmoToReload = 1;
	else
		AmmoToReload = KFXGetReloadMax() - KFXGetReload();
	log("[LABOR]-------------weapon ammo info:"$self.KFXWeaponID@KFXGetReloadMax()
						@KFXGetReload()@KFXGetAmmo()
						@KFXGetAllAmmo());
	if ( KFXGetAllAmmo() > AmmoToReload )
	{
		KFXSetReload( KFXGetReload() + AmmoToReload );
		if(KFXGetAmmo() < AmmoToReload)
		{
			log("WeaponAmmo null but ");
			AmmoToReload -= KFXGetAmmo();
			KFXSetAmmo(0);

			for(loop=0; loop < 6; loop++ )
			{
				if( KFXWeapComponent[loop] == none )
				{
					continue;
				}
				if(KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup] >0 )
				{
					if(KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup] < AmmoToReload)
					{
						AmmoToReload -= KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup];
						KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup] = 0;
						if ( KFXShareAmmo )
						{
			    			KFXWeapComponent[loop].KFXAmmoCount[1 - KFXFireGroup] = 0;
						}
					}
					else
					{
						KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup] -= AmmoToReload;
						if ( KFXShareAmmo )
						{
			    			KFXWeapComponent[loop].KFXAmmoCount[1 - KFXFireGroup] -= AmmoToReload;
						}
						break;
					}
				}
			}

		}
		else
		{
			KFXSetAmmo( KFXGetAmmo() - AmmoToReload );
		}
	}
	else
	{
		KFXSetReload( KFXGetReload() + KFXGetAllAmmo() );
		KFXSetAmmo(0);
		for(loop=0; loop < 6; loop++ )
		{
			if( KFXWeapComponent[loop] == none )
			{
				continue;
			}
			KFXWeapComponent[loop].KFXAmmoCount[KFXFireGroup] = 0;
			if ( KFXShareAmmo )
			{
    			KFXWeapComponent[loop].KFXAmmoCount[1 - KFXFireGroup] = 0;
			}
		}
	}

	NetUpdateTime = Level.TimeSeconds - 1;
}

// ====================================================================
// ¹¦ÄÜº¯Êý
// ====================================================================
simulated function bool KFXHasAnim( name Sequence)
{
//    local int loop;
//
//    for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
//    {
//        if ( KFXAccessoryMesh[loop] != none
//            && KFXAccessoryMesh[loop].HasAnim(Sequence) )
//                return true;
//    }

	return HasAnim(Sequence);
}

// ====================================================================
// ÎäÆ÷ÌáÊ¾ÐÅÏ¢
// ====================================================================


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

simulated function KFXSetWeaponMaterial()
{
	local Material HandTex;
	local controller C;
	local string HandTextString;

	if ( Instigator.Controller != none )
		C = Instigator.Controller;
	else if( Level.GetLocalPlayerController().Pawn.Weapon == self )
		C =  Level.GetLocalPlayerController();
	else
		return;

	if( KFXPlayer( C ) != none && KFXPlayer( C ).KFXSetWeaponMaterialEX(self) )
		return;

	if( KFXPawn(C.Pawn).KFXPawnCanHid() && Skins.Length>0 )
	{
		if( Skins.Length == 1 )
		{
			if( Skins[0].IsA('FinalBlend') )
			{
//                LOG("[WeapBase]  Noneed to do hide111111");
				return;
			}
		}
		else if(self.Skins[0].IsA('FinalBlend') && self.Skins[1].IsA('FinalBlend'))
		{
//            LOG("[WeapBase]  Noneed to do hide 222222");
			return;
		}
	}

	if ( C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.Team != none )
	{
		if ( KFXPlayerReplicationInfo(C.PlayerReplicationInfo).IsBlueTeam() )
		{

			if( KFXPawn( C.Pawn ).KFXPawnCanHid())
				HandTextString = "fx_weapon_texs.hand_blue_thin";
			else
				HandTextString = "fx_weapon_texs.hand_blue_thin";
		}
		else if ( KFXPlayerReplicationInfo(C.PlayerReplicationInfo).IsRedTeam() )
		{
			if( KFXPawn(C.Pawn).KFXPawnCanHid() )
				HandTextString = "fx_weapon_texs.hand_red_thin";
			else
				HandTextString = "fx_weapon_texs.hand_red_thin";
		}
		else
		{
			if( KFXPawn(C.Pawn).KFXPawnCanHid() )
				HandTextString = "fx_weapon_texs.hand_gray_thin";
			else
				HandTextString = "fx_weapon_texs.hand_gray_thin_s";
		}
	}
	else
	{
		if( KFXPawn(C.Pawn).KFXPawnCanHid() )
			HandTextString = "fx_weapon_texs.hand_gray_thin";
		else
			HandTextString = "fx_weapon_texs.hand_gray_thin_s";
	}
	if(KFXPawn(C.Pawn).bIsFemale)
	{
		HandTextString = HandTextString$"_W";
	}
	HandTex = Material(DynamicLoadObject(HandTextString, class'Material'));
	Skins[0] = HandTex;
}

////////////////////////  for cs weapon effect head ///////////////////////////

// Call to Draw Weapon CrossHair
simulated function DrawWeaponInfo(Canvas Canvas)
{
	// Draw CrossHair
	if(Instigator==none )
	return;
	if (  !KFXPlayer(Instigator.Controller).bBehindView )
	{
		if ( !KFXFireBase(FireMode[1]).KFXDrawCrossHair(Canvas) )
			KFXFireBase(FireMode[0]).KFXDrawCrossHair(Canvas);
	}
	KFXDrawBulletPic(Canvas);
	KFXDrawWeaponHotInfo(Canvas);
}
simulated function KFXDrawKnifeCanAttack(Canvas Canvas,bool bLightAttack,bool bHeavyAttack);
//»æÖÆ×Óµ¯Êý¾Ý
simulated function KFXDrawBulletPic(Canvas canvas)
{
	//×îºÃ²»ÒªÔÚÕâÀï»æÖÆ£¬»æÖÆµÄµØ·½ÒªÍ³Ò»£¬±ÈÈç¶¼·ÅÔÚHUDÖÐ¡£ÕâÑù±ãÓÚ¹ÜÀí
	KFXHUD(KFXPlayer(Instigator.Controller).myHUD).KFXDrawBulletPic(canvas);
}
simulated function KFXDrawWeaponHotInfo(Canvas Canvas);
// Client Pre Reload
// Client Only
simulated function ClientPreReload()
{
	// Clear States
	bIsReload = true;
	KFXClearStates();

	if ( KFXReloadMode == 2 )
	{
		PlayStartReload();
	}
	else
	{
		// ThirdPerson Reload Anim
		KFXWeapAttachment(ThirdPersonActor).ThirdPersonPlayReload();
		// FirstPerson Reload Anim
		PlayReload();
	}
}

// Client Tick Reload
// Client Only
simulated function ClientTickReload()
{
	if ( KFXReloadMode == 2 )
	{
		// ThirdPerson Reload Anim
		KFXWeapAttachment(ThirdPersonActor).ThirdPersonPlayReload();
		// FirstPerson Reload Anim
		PlayReload();
	}
}

// Client Post Reload
// Client Only
simulated function ClientPostReload()
{
	if ( KFXReloadMode == 2 )
		PlayAfterReload();
	bIsReload = false;
}

// Server Pre Reload
// Server Only
function ServerPreReload()
{
	if ( bIsReload )
		return;

	// Client Reload
	ClientPreReload();

	// Clear States
	KFXClearStates();

	// Server Reload
	bIsReload = true;
	KFXFinishReloadTime = Level.TimeSeconds + (KFXGetReloadTime() + GetPreReloadTime())/KFXGetSwitchAmmoRate() - 0.2;

	if ( KFXReloadMode != 2 )
	{
		// Notify Other Clients Play Reload
		// 200~204 represent Reload
		KFXWeapAttachment(ThirdPersonActor).IncrementReloadCount();
	}
}

simulated function float GetPreReloadTime()
{
	local float preTime;
	local int loop;
	preTime = KFXPreReloadTime;
	for(loop=0; loop < 6; loop++)
	{
		if( KFXWeapComponent[loop] == none)
				continue;
		preTime += KFXWeapComponent[loop].KFXPreReloadTime;
	}
	return preTime;
}

// Server Tick Reload
// Server Only
function ServerTickReload()
{
	if ( KFXReloadMode == 2 )
	{
		if ( !KFXCanReload() )
		{
			ServerPostReload();
			ClientPostReload();
			return;
		}

		KFXReloadAmmo();
		KFXFinishReloadTime = Level.TimeSeconds + KFXGetReloadTime()/KFXGetSwitchAmmoRate();

		// Notify Other Clients Play Reload
		// 200~204 represent Reload
		KFXWeapAttachment(ThirdPersonActor).IncrementReloadCount();

		ClientTickReload();
	}
	else
	{
		KFXReloadAmmo();
		ServerPostReload();
		ClientPostReload();
	}
}

// Server Post Reload
// Server Only
function ServerPostReload()
{
	bIsReload = false;

	// Notify Other Clients Reload
	// -10 represent Reload
	KFXWeapAttachment(ThirdPersonActor).FlashCount = 0;
	ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
}

// Play Reloading
// Client only
simulated function PlayReload()
{
	PlayAnim(KFXGetAnimReload(), KFXGetAnimReloadRate()*KFXGetSwitchAmmoRate(), FireMode[0].TweenTime);
	//PlayOwnedSound(FireMode[0].ReloadSound);
}
// Play Start Reloading
// Client only
simulated function PlayStartReload()
{
	PlayAnim(KFXGetAnimPreReload(), GetPreReloadRate()*KFXGetSwitchAmmoRate(), FireMode[0].TweenTime);

	//PlayOwnedSound(FireMode[0].ReloadSound);
}

simulated function float GetPreReloadRate()
{
	local float preRate;
	local int loop;
	preRate = StartReloadAnimRate;
	for(loop = 0; loop < 6; loop++)
	{
		if( KFXWeapComponent[loop] == none)
				continue;
		preRate += KFXWeapComponent[loop].StartReloadAnimRate;
	}
	return preRate;
}


// Play After Reloading
// Client only
simulated function PlayAfterReload()
{
	PlayAnim(KFXGetAnimEndReload(), GetAfterReloadRate()*KFXGetSwitchAmmoRate(), FireMode[0].TweenTime);
	//PlayOwnedSound(FireMode[0].ReloadSound);
}

simulated function float GetAfterReloadRate()
{
	local float afterRate;
	local int loop;
	afterRate = AfterReloadAnimRate;
	for(loop = 0; loop < 6; loop++)
	{
		if( KFXWeapComponent[loop] == none)
				continue;
		afterRate += KFXWeapComponent[loop].AfterReloadAnimRate;
	}
	return afterRate;
}

// Deploy Flash Count
simulated function KFXFlashWeapDeployed(optional float UserData)
{
	KFXWeapAttachment(ThirdPersonActor).ServerToggleDeploy(true, UserData);
}
// Undeploy Flash Count
simulated function KFXFlashWeapUndeploy()
{
	KFXWeapAttachment(ThirdPersonActor).ServerToggleDeploy(false);
}
simulated function ClientZeroFlashCount(int Mode)
{
	if ( WeaponAttachment(ThirdPersonActor) != None )
	{
		if (Mode == 0)
			WeaponAttachment(ThirdPersonActor).FiringMode = 0;
		else
			WeaponAttachment(ThirdPersonActor).FiringMode = 1;
		ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
		if(KFXWeapAttachment(ThirdPersonActor).ServerFlashCount == 0
		&&(KFXWeapAttachment(ThirdPersonActor).FlashCount < 200 || KFXWeapAttachment(ThirdPersonActor).FlashCount > 204))
		{
			KFXWeapAttachment(ThirdPersonActor).FlashCount = 0 ;
		}
		KFXWeapAttachment(ThirdPersonActor).ServerFlashCount = 0;

		WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
		if(KFXWeapAttachment(ThirdPersonActor).FlashCount == 0)
		{
			bZeroCount = false;
		}
	}
}
simulated function ZeroFlashCount(int Mode)
{
	if(bClientSimuFire)
	{
		ClientZeroFlashCount(Mode);
	}
	else
	{
		super.ZeroFlashCount(Mode);
	}

}
function ZeroThirdEffectCount()
{
	if(bClientSimuFire)
	{
		if(Level.NetMode != NM_Standalone)
		{
			if(KFXWeapAttachment(ThirdPersonActor).ServerHitCount != KFXWeapAttachment(ThirdPersonActor).SpawnHitCount )
			{
				//log("[simclient] ServerHitCount:"$KFXWeapAttachment(ThirdPersonActor).ServerHitCount@
				//"SpawnHitCount"@KFXWeapAttachment(ThirdPersonActor).SpawnHitCount);
				KFXWeapAttachment(ThirdPersonActor).SpawnHitCount = KFXWeapAttachment(ThirdPersonActor).ServerHitCount;
			}
			ZeroHitCount();
			ZeroFlashCount(KFXFireGroup);
		}
	}
}
// only called on currently held weapon
// client & server
simulated event WeaponTick(float dt)
{
	local name anim;
	local float frame, rate;
	local int pawnstate;

	// Server Logical
	if ( Role == ROLE_Authority )
	{
		// Server Decide if Need Reload
		// Moved to Client Side: Because Server Can't Detect Empty Fire
		/*
		if ( !bIsReload
			&& KFXNeedReload()
			&& KFXCanReload()
			&& (FireMode[0].NextFireTime + 0.2 <= level.TimeSeconds)
			&& (FireMode[1].NextFireTime + 0.2 <= level.TimeSeconds) )
		{
			ServerPreReload();
		}
		else
		*/
		// Update Reload
		if(bZeroCount)
		{
			ZeroThirdEffectCount();     //µÚÈýÈË³Æ¿ª»ð¹é0
		}

		if ( bIsReload && (Level.TimeSeconds >= KFXFinishReloadTime) )
			ServerTickReload();

		//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø
		//ÓÉÓÚ²»È·¶¨µÄÔ­Òò botµÄpawnÔÚ¿Í»§¶ËµÄÊµÀýÃ»ÓÐcontroller ËùÒÔInstigator.IsLocallyControlled()
		if( KFXBot(Instigator.Controller) != none )
		{
			//LOG("KFXWeapBase KFXBotReload");
			if ( !bIsReload
				&& KFXNeedReload()
				&& (FireMode[0].NextFireTime + 0.2 <= level.TimeSeconds)
				&& (FireMode[1].NextFireTime + 0.2 <= level.TimeSeconds) )
			{

				if(KFXCanReload())
				{
					//---------------------------------------------
					//¿ÉÕ¹¿ªÎäÆ÷ÓÒ¼üÑÓ³ÙµÄÔ­Òò£¬µ±×Óµ¯ÏûºÄ¹âÖ®ºó £¬Ç°Ò»¸öifÌõ¼þºã³ÉÁ¢
					//¼´Ã¿¸ô0.2ÃëÖ´ÐÐÒ»´Î £¬NextFireTimeºÜÈÝÒ×´óÓÚlevel.TimeSeconds
					//Ò»µ©·¢ÉúÕâÖÖ×´¿ö£¬readytofire·µ»Øfalse¡£ËùÒÔ½«ÆäÐ´Èë´Ë´¦¶ø²»ÊÇ
					//Ö÷ÅÐ¶ÏÌõ¼þ´¦
					FireMode[0].NextFireTime = level.TimeSeconds + 0.5;
					FireMode[1].NextFireTime = level.TimeSeconds + 0.5;
					//----------------------------------------------
					KFXForceReload();
				}
				else
				{
					//botÈç¹ûÃ»×Óµ¯ ÐèÒª×öÊ²Ã´£¿£¿
					//OutOfAmmo();
				}
			}

			// Owner Client Stat botfireÊ¹ÓÃµ½ÁËÕâ¸öÅÐ¶¨ ²»ÄÜËæ±ãÈ¥µô´úÂë
			if ( !bEndOfRound )
			{
				if ( (ClientState == WS_None) || (ClientState == WS_Hidden) )
				{
					ClientState = WS_ReadyToFire;
				}
			}
		}
		//ÅÐ¶¨¹ý²»ÁË Òò´Ë²»ÄÜ»»×Óµ¯
		//>>
		// ¼æÈÝµ¥»úÄ£Ê½,²¢ÓÅ»¯·þÎñÆ÷µÄÅÐ¶ÏÐ§ÂÊ
		if ( Level.NetMode == NM_DedicatedServer )
			return;
	}

	// Owner Client
	if ( Instigator.IsLocallyControlled() )
	{
		// Owner Client Decide if Need Reload
		if ( !bIsReload
			&& KFXNeedReload() )
//            && (FireMode[0].NextFireTime + 0.2 <= level.TimeSeconds)
//            && (FireMode[1].NextFireTime + 0.2 <= level.TimeSeconds) )
		{

			if(KFXCanReload())
			{
				//---------------------------------------------
				//¿ÉÕ¹¿ªÎäÆ÷ÓÒ¼üÑÓ³ÙµÄÔ­Òò£¬µ±×Óµ¯ÏûºÄ¹âÖ®ºó £¬Ç°Ò»¸öifÌõ¼þºã³ÉÁ¢
				//¼´Ã¿¸ô0.2ÃëÖ´ÐÐÒ»´Î £¬NextFireTimeºÜÈÝÒ×´óÓÚlevel.TimeSeconds
				//Ò»µ©·¢ÉúÕâÖÖ×´¿ö£¬readytofire·µ»Øfalse¡£ËùÒÔ½«ÆäÐ´Èë´Ë´¦¶ø²»ÊÇ
				//Ö÷ÅÐ¶ÏÌõ¼þ´¦
				FireMode[0].NextFireTime = level.TimeSeconds + 0.5;
				FireMode[1].NextFireTime = level.TimeSeconds + 0.5;
				//----------------------------------------------
				KFXForceReload();
			}
			else
			{
				OutOfAmmo();
			}
			PlayEmptyFireSound();
		}
		pawnstate = KFXFireBase(FireMode[0]).KFXGetPawnState();
		//GetAnimParams(0, anim, frame, rate);
		/*if ( pawnstate == 2 || pawnstate == 3)
		{
			if ( anim == RunAnim )
			{
				PlayIdle();
			}
		}
		else if(pawnstate == 1)
		{
			if( anim == IdleAnim )
			{
				PlayAnim(RunAnim, 0.2 * RunAnimRate, 0.0);
			}
		}*/
		// Owner Client Stat
		if ( !bEndOfRound )
		{
			if ( (ClientState == WS_None) || (ClientState == WS_Hidden) )
			{
				ClientState = WS_ReadyToFire;
			}
		}

		//KFXClientComAttachToBone();

	  if(bMultiFireMode && bMultiFiring)
	  {
		  if(KFXGetSimReload() <= 0 && KFXGetAmmo() > 0)
		  {
			   if(nMultiFireAmmo > 0)     //¿ÉÄÜ»á³öÏÖÕâÖÖÇé¿ö
			   {
					nMultiFireAmmo = 0;
					bMultiFiring = false;
					log("Here To Set nMultiFireAmmo 0");
			   }
		  }
	  }
	}
}

function bool NeedReload()
{
    return KFXNeedReload();
}

simulated function QuickWeaponFire()
{
	log("KFXWeaponBase------KFXWeaponID "$KFXWeaponID);
	log("KFXWeaponBase------bQuickToss "$KFXPlayer(Instigator.Controller).bQuickToss);
	log("KFXWeaponBase------bQuickInstallC4 "$KFXPlayer(Instigator.Controller).bQuickInstallC4);

	if(KFXWeaponID == 1)
	{
		if(KFXPlayer(Instigator.Controller).bQuickInstallC4)
		{
			 ClientStartFire(0);
			 KFXPlayer(Instigator.Controller).bQuickInstallC4 = false;
		}

	}
	else if(KFXWeaponID >> 16 >= 51 && KFXWeaponID >> 16 <= 60)
	{
		if(KFXPlayer(Instigator.Controller).bQuickToss)
		{
			 ClientStartFire(0);
			 KFXPlayer(Instigator.Controller).bQuickToss = false;
		}
	}

}
simulated function PlayEmptyFireSound()
{
	if(Level.NetMode != NM_StandAlone
		&& !bIsReload
		&& !KFXHasReload()
		&& Level.TimeSeconds - BeginFireSoundTime >= GetSoundDuration(KFXGetFPFireSound()))     //²¥·Å¿ÕÇ¹ÉùÒô
	{
		// Play Empty sound
		if(FireMode[0].bIsFiring)
		{
			if(bStartFire || KFXGetAllAmmo() == 0)
			{
				if(Level.TimeSeconds - CurTime > GetSoundDuration(KFXGetNoammoSound()))
				{
					PlayOwnedSound(KFXGetNoammoSound(),SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
					CurTime = Level.TimeSeconds;
				}
			}
		}
	}

}
// GetFireMode
simulated function WeaponFire GetWeaponFire(int mode)
{
	return FireMode[mode];
}

// Detach From Pawn
// Server Only
simulated function DetachFromPawn(Pawn P)
{
	Super.DetachFromPawn(P);
	KFXPlayer(Instigator.Controller).WeapDurConsumeEnd();

	KFXClearStates();
}

simulated function AttachToPawn(Pawn p)
{
	super.AttachToPawn(p);
//    log("KFXWeapBase AttachToPawn "$p);

	KFXPlayer(Instigator.Controller).WeapDurConsumeStart(KFXWeaponID);

}

simulated function float KFXGetSelectAnimRate()
{
	local float rate;
	local int loop;
	rate = SelectAnimRate;
	for(loop=0; loop < 6; loop++)
	{
		if(KFXWeapComponent[loop] == none)
			continue;
		rate += KFXWeapComponent[loop].SelectAnimRate;
	}
	return rate;
}

// Bring up Weapon
// Client Only
simulated function BringUp(optional Weapon PrevWeapon)
{
	local int Mode;
	local float BringTime;
	local int loop;
	local float selectrate;

	BringTime = 0;
	for(loop=0; loop < 6; loop++)
	{
		if(KFXWeapComponent[loop]!=none)
		{
			BringTime += KFXWeapComponent[loop].BringUpTime;
		}
	}
	BringTime+=BringUpTime;

	if ( ClientState == WS_Hidden )
	{
		//PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

		if ( Instigator.IsLocallyControlled() )
		{
			if ( (Mesh!=None) && HasAnim(GetSelectAnim()) )
			{
				selectrate = KFXGetSelectAnimRate();
				PlayAnim(GetSelectAnim(), selectrate * KFXGetSwitchWeaponDown(), 0.0);
			}
		}
		ClientState = WS_BringUp;

		//°ïÖúÏûÏ¢£ºÇÐ³öÇ¹ºóµÄÌáÊ¾
		if (!bKFXShowBringUpHint && KFXBringUpHint != "null")
		{
			KFXPawn(Instigator.Controller.Pawn).KFXSetHintMsg(KFXBringUpHint, 3, 2, true);
			bKFXShowBringUpHint = true;
		}
		log("KFXWeappBase------BringTime "$BringTime);
		log("KFXWeappBase------KFXGetBringUpDown() "$KFXGetBringUpDown());
		if(PlayerController(Instigator.Controller).bFastToss)
		{
			SetTimer(BringTime/20, false);
		}
		else
		{
			SetTimer(BringTime * KFXGetBringUpDown(), false);
		}
	}
	for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}
	if ( (PrevWeapon != None) && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;

	// Fixme! Client Only Logic !!!
	FireMode[0].NextFireTime = Level.TimeSeconds + BringTime * KFXGetBringUpDown() + 0.0;
	FireMode[1].NextFireTime = FireMode[0].NextFireTime;

	//ÕâÊÇ¿Í»§¶Ë£¬·þÎñÆ÷Ò²ÐèÒªÉèÖÃ
	//log("[LABOR]-----------bring up, is reload?"$self.bIsReload);
	bIsReload = false;

    if ( Level.NetMode != NM_DedicatedServer )
    {
		// Èôµ±Ç°ÇÐ³öµÄÇ¹ÎÞ×Óµ¯£¬ÌáÊ¾ÈÓÇ¹
		if ( !HasAmmo() )
		{
			if ( !KFXIsShareAmmo() )
			{
				if ( KFXAmmoCount[1- KFXFireGroup] <= 0 && KFXReload[1- KFXFireGroup] <= 0 )
				{
					KFXPlayer(Instigator.Controller).ReceiveLocalizedMessage(class'KFXGameMessage', 51);
				}
			}
			else
			{
				KFXPlayer(Instigator.Controller).ReceiveLocalizedMessage(class'KFXGameMessage', 51);
			}
		}

		if (Instigator != none)
		{
			ExchangeWeaponAxisType(KFXPlayer(Instigator.Controller).DrawWeaponAXIS);
		}
	}
}

simulated function bool PutDown()
{
	local rotator ZeroPunchAngel;
	if ( Instigator.IsLocallyControlled() )
	{
		StopAnimating();
	}
	ZeroPunchAngel.Pitch = 0;
	ZeroPunchAngel.Roll = 0;
	ZeroPunchAngel.Yaw = 0;

	if(VSize(vector(KFXFireBase(FireMode[0]).PunchAngle)) > 0)     //set punch angle to zero
	{
		KFXFireBase(FireMode[0]).PunchAngle = ZeroPunchAngel;
	}
	if(VSize(vector(KFXFireBase(FireMode[1]).PunchAngle)) > 0)
	{
		KFXFireBase(FireMode[1]).PunchAngle = ZeroPunchAngel;
	}

	//ÕâÊÇ¿Í»§¶Ë£¬·þÎñÆ÷Ò²ÐèÒªÉèÖÃ
	log("[LABOR]-----------is reload?"$self.bIsReload);
	bIsReload = false;

	return super.PutDown();
}

// Don't loop Anim
simulated function PlayIdle()
{
	PlayAnim(KFXGetAnimIdle(), IdleAnimRate, 0.1);
}

// Weapon Change
simulated function Weapon WeaponChange( byte F, bool bSilent )
{
	local Weapon newWeapon;

	// ÇÐÀ× || C4
	if ( InventoryGroup == F )
	{
		if ( InventoryGroup >= 4 && !KFXHasAmmo() )
		{
			if ( Inventory == None )
				newWeapon = None;
			else
				newWeapon = Inventory.WeaponChange(F,bSilent);

			//if ( !bSilent && (newWeapon == None) && Instigator.IsHumanControlled() )
			//    Instigator.ClientMessage( ItemName$MessageNoAmmo );

			return newWeapon;
		}
		else
			return self;
	}
	else if ( Inventory == None )
		return None;
	else
		return Inventory.WeaponChange(F,bSilent);
}

simulated function float RateSelf()
{
	return Priority;
}

simulated function bool CanThrow()
{
	local int Mode;

	for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
			return false;
		//if ( FireMode[Mode].NextFireTime > Level.TimeSeconds)
		//    return false;
	}
	return (bCanThrow && (ClientState == WS_ReadyToFire || (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) );
}

function DropFrom(vector StartLocation)
{
	local int m;
	local Pickup Pickup;
	local vector X,Y,Z;
	local rotator tempRotation;

	if (!bCanThrow)
		return;

	ClientWeaponThrown();

	if ( bIsReload )
	{
		bIsReload = false;
	}

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m].bIsFiring)
			StopFire(m);
	}

	if ( Instigator != None )
	{
		DetachFromPawn(Instigator);
	}
	tempRotation = Instigator.Rotation;
	tempRotation.Pitch = 0;
	self.GetAxes(tempRotation,X,Y,Z);
	Pickup = Spawn(PickupClass,,, StartLocation);
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location);
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,2*Instigator.location-StartLocation);
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location+Y*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = VSize(Velocity)*Y;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location-Y*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = -VSize(Velocity)*Y;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location+X*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = VSize(Velocity)*X;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location-X*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = -VSize(Velocity)*X;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location+Z*(Instigator.CollisionHeight+PickupClass.default.CollisionHeight));
		Velocity = VSize(Velocity)*Z;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location-Z*(Instigator.CollisionHeight+PickupClass.default.CollisionHeight));
		Velocity = -VSize(Velocity)*Z;
	}




	if ( Pickup != None )
	{
		;
		Pickup.InitDroppedPickupFor(self);
		Pickup.Velocity = Velocity;
		if (Instigator.Health > 0)
			WeaponPickup(Pickup).bThrown = true;
	}
	else
	{
		;
	}

	Destroy();
}

simulated function SpawnWeapPickUpWhenDied(vector StartLocation)
{
	local int m;
	local Pickup Pickup;
	local float ClockTime;
	local vector X,Y,Z;
	local rotator tempRotation;

	DetachFromPawn(Instigator);     //µÚÈýÈË³ÆÎäÆ÷ÏûÊ§ÁË

	tempRotation = Instigator.Rotation;
	tempRotation.Pitch = 0;
	self.GetAxes(tempRotation,X,Y,Z);
	Pickup = Spawn(PickupClass,,, StartLocation);


	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location);
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,2*Instigator.location-StartLocation);
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location+Y*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = VSize(Velocity)*Y;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location-Y*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = -VSize(Velocity)*Y;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location+X*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = VSize(Velocity)*X;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location-X*(Instigator.CollisionRadius+PickupClass.default.CollisionRadius));
		Velocity = -VSize(Velocity)*X;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location+Z*(Instigator.CollisionHeight+PickupClass.default.CollisionHeight));
		Velocity = VSize(Velocity)*Z;
	}
	if ( Pickup == None )
	{
		;
		Pickup = Spawn(PickupClass,,,Instigator.location-Z*(Instigator.CollisionHeight+PickupClass.default.CollisionHeight));
		Velocity = -VSize(Velocity)*Z;
	}
	if ( Pickup != None )
	{
		;
		clock(ClockTime);
		Pickup.InitDroppedPickupFor(self);
		UnClock(ClockTime);
		log("KFXWeapBase---InitDroppedPickupFor----ClockTime "$ClockTime);

		Pickup.Velocity = Velocity;
		if (Instigator.Health > 0)
			WeaponPickup(Pickup).bThrown = true;
	}
	else
	{
		;
	}
}

simulated function int AmmoAmount(int mode)
{
	return KFXGetAmmo();
}

function bool HandlePickupQuery( pickup Item )
{
	// ÓÐÏàÍ¬TypeIDµÄÎäÆ÷²»ÄÜÖØ¸´Ê°È¡
	if ( KFXWeapPickup(Item) != none)
	{
		if(KFXWeapPickup(Item).KFXGetWeaponID()!= 1)
		{
			if (((KFXWeapPickup(Item).KFXGetWeaponID() >> 16) <= 30) && (( KFXGetWeaponID() >> 16) <= 30)
			&& (((KFXWeapPickup(Item).KFXGetWeaponID() >> 16) >=  1) && (( KFXGetWeaponID() >> 16) >= 1)))
			{
				return true;
			}
			else if((((KFXWeapPickup(Item).KFXGetWeaponID() >> 16) <= 40) && ((KFXGetWeaponID() >> 16) <= 40))
				&&  (((KFXWeapPickup(Item).KFXGetWeaponID() >> 16) >  30) && ((KFXGetWeaponID() >> 16) >  30)))
			{
				return true;
			}
			else if((((KFXWeapPickup(Item).KFXGetWeaponID() >> 16) <= 50) && (( KFXGetWeaponID() >> 16) <= 50))
				&&  (((KFXWeapPickup(Item).KFXGetWeaponID() >> 16) >  40) && (( KFXGetWeaponID() >> 16) > 40)))
			{
				return true;
			}
		}
	}
	return super.HandlePickupQuery(Item);
}

// Client Only
simulated function ClientWeaponThrown()
{
	KFXPawn(Owner).IsWeaponThrown = true;
	KFXClearStates();
	super.ClientWeaponThrown();
}

simulated function ClientWeaponSet(bool bPossiblySwitch)
{
	local int Mode;

	Instigator = Pawn(Owner);

	bPendingSwitch = bPossiblySwitch;
//    log("[weaponchange] ClientWeaponSet");
//    log("KFXWeapBase-------Instigator "$Instigator);
//    log("KFXWeapBase-------self "$self);

	if( Instigator == None )
	{
		GotoState('PendingClientWeaponSet');
		return;
	}

	for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
	{
		if( FireModeClass[Mode] != None )
		{
			// laurent -- added check for vehicles (ammo not replicated but unlimited)
			if( ( FireMode[Mode] == None ) || ( FireMode[Mode].AmmoClass != None ) && !bNoAmmoInstances && Ammo[Mode] == None && FireMode[Mode].AmmoPerFire > 0 )
			{
				GotoState('PendingClientWeaponSet');
//                log("KFXWeapBase-------PendingClientWeaponSet return ");
				return;
			}
		}

		FireMode[Mode].Instigator = Instigator;
		FireMode[Mode].Level = Level;
	}

	ClientState = WS_Hidden;
	GotoState('Hidden');

	if( Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled() )
		return;

	if( Instigator.Weapon == self || Instigator.PendingWeapon == self ) // this weapon was switched to while waiting for replication, switch to it now
	{
		if (Instigator.PendingWeapon != None)
			Instigator.ChangedWeapon();
		else
			BringUp();
		return;
	}

	if(bRepForceSwitch)
	{
		Instigator.PendingWeapon = self;
		Instigator.ChangedWeapon();
	}

	if( Instigator.PendingWeapon != None && Instigator.PendingWeapon.bForceSwitch )
		return;
//    log("KFXWeapBase------Instigator.Weapon "$Instigator.Weapon);
//    log("KFXWeapBase------Instigator.PendingWeapon "$Instigator.PendingWeapon);
//    log("KFXWeapBase------bPossiblySwitch "$bPossiblySwitch);
//    log("KFXWeapBase------Instigator.Weapon.IsFiring() "$Instigator.Weapon.IsFiring());

	if( Instigator.Weapon == None )
	{
		Instigator.PendingWeapon = self;
		Instigator.ChangedWeapon();
	}
	else if ( bPossiblySwitch && !Instigator.Weapon.IsFiring() )
	{
//        log("KFXWeapBase------PlayerController(Instigator.Controller).bNeverSwitchOnPickup "$PlayerController(Instigator.Controller).bNeverSwitchOnPickup);
//        log("KFXWeapBase------RateSelf() "$RateSelf());
//        log("KFXWeapBase------Instigator.PendingWeapon.RateSelf() "$Instigator.PendingWeapon.RateSelf());
//        log("KFXWeapBase------Instigator.Weapon.RateSelf() "$Instigator.Weapon.RateSelf());

		if ( PlayerController(Instigator.Controller) != None && PlayerController(Instigator.Controller).bNeverSwitchOnPickup )
			return;
		if ( Instigator.PendingWeapon != None )
		{
			if ( RateSelf() > Instigator.PendingWeapon.RateSelf() )
			{
				Instigator.PendingWeapon = self;
				Instigator.Weapon.PutDown();
			}
		}
		else if ( RateSelf() > Instigator.Weapon.RateSelf() )
		{
			Instigator.PendingWeapon = self;
			Instigator.Weapon.PutDown();
		}
	}
	Instigator.NotifyWeaponChanged();
    log("To do SwitchToBestWeapon"$KFXWeaponID);
	//Instigator.Controller.SwitchToBestWeapon();
}

simulated function KFXSpecialAffect( KFXPawn TracePawn, vector Param1,rotator Param2 ) ;

// Clear the states
// When Reload, SwitchWeapon, DropFrom Pawn, This Method Shuold be Invoking
// Fixme! Ugly Implemnt!
// Client & Server
simulated function KFXClearStates()
{
	// Server Only
	//if ( Role == ROLE_Authority ) is error under standalone!
	if ( Level.NetMode == NM_DedicatedServer )
	{
		bIsReload = false;
	}

	if ( Instigator!=none&&Instigator.IsLocallyControlled() )
	{
		ClientState = WS_Hidden;
	}

	// È¡ÏûÄ¿±êËø¶¨
	KFXLockedTarget = none;
}
simulated function SimulatedFire( int Mode )
{

}
simulated function bool SimReadToFire( int Mode )
{

}
//// client only ////
simulated event ClientStartFire(int Mode)
{
	// wangkai, ÉÏÁË±£ÏÕ¾Í¿ª²»ÁË»ð
	if (KFXPlayer(Instigator.Controller).KFXGunSafeOn())
		return;
    if(FireMode[Mode].bTossed || !KFXFireBase(FireMode[Mode]).bNeedClientSimulate)
	{
	 	bClientSimuFire = false;
	}
    else if((KFXWeaponID >> 16) >=1 && (KFXWeaponID >> 16) <=50)   //ÕâÀï²»Òª¸ù¾ÝWeapIDÀ´×öÁË£¬ÔÚFireModeÀï¼ÓÒ»¸ö±äÁ¿°É
    {
		bClientSimuFire = true;
	}
	else
	{
		bClientSimuFire = false;
	}
	if(Level.NetMode == NM_StandAlone)
	{
		bClientSimuFire = false;
	}
	// Fixme!!!!!!!
	// ÓÐ¼«Ð¡µÄ¼¸ÂÊÔÚ·þÎñÆ÷¶Ë»¹Ã»ÓÐ½«µ¯Ò©ÊýÁ¿Í¬²½¹ýÀ´µÄÇé¿öÏÂ
	// ´¥·¢¸ÃÂß¼­£¬Òò´Ë¿Í»§¶Ë¿ÉÄÜ¿ª»ðÊ§°Ü£¬¶ø·þÎñÆ÷¶Ë¿ª»ð³É¹¦¡£
	// ÓÉÓÚ¶Ô×Óµ¯ÊýÁ¿½øÐÐÄ£Äâ£¬ËùÒÔÎÞ·¨¾«È·ÒÔ×Óµ¯ÊýÁ¿ÏÞÖÆ¿ª»ð
	// Ìõ¼þ ¡£AllowFireÐèÒªÖØÐÂÊµÏÖ£¡

//    if(Mode == 0 && (Instigator.IsA('KFXCmdPawn') || Instigator.IsA('KFXMutatePawn')))
//	{
//    	if(KFXGetReload() > KFXGetSimReload() && KFXGetSimReload() == 0)
//    	{
//           ErrorReloadNum++;
//           log("KFXWeapBase-------ErrorReloadNum "$ErrorReloadNum$"   KFXGetReload(): "$KFXGetReload()$"   KFXGetSimReload(): "$KFXGetSimReload());
//           if(ErrorReloadNum > KFXGetReload())
//           {
//               KFXSetReload(0);
//           }
//        }
//    }
	KFXSetSimReload(KFXGetReload());
	super.ClientStartFire(Mode);
}

//// client only ////
simulated event ClientStopFire(int Mode)
{
	bStartFire = false;
	if(KFXGetFireMode(1).RightFireTimes > 0)
		 KFXGetFireMode(1).RightFireTimes = 0;
	super.ClientStopFire(Mode);
}

simulated function bool StartFire(int Mode)
{
	local bool ret;
	KFXFireBase( GetWeaponFire(Mode) ).KFXFireOn();

	ret = super.StartFire(Mode);
	if(!KFXHasReload() && !KFXHasAmmo() && Mode ==0 )     //²¥·Å¿ÕÇ¹ÉùÒô
	{
		// Play Empty sound
		if(Level.TimeSeconds - CurTime > GetSoundDuration(KFXGetNoammoSound()))
		{
			PlayOwnedSound(KFXGetNoammoSound(),SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
			//ServerPlayNoAmmoSound();   //ÕâÖÖÍ¬²½¾ÍÉÙÓÃ°É£¬ÔÚweapontickÀïµ÷ÓÃÍ¬²½º¯Êý£¿¶øÇÒ×Ô¼º´ò¿ÕÇ¹Ò²ÒªÈÃ±ðÈËÌýµ½£¿
			CurTime = Level.TimeSeconds;
		}
	}
	if (ret && Instigator != none)
	{
		KFXPawn(Instigator).IsFired = true;
	}

	return ret;
}
// Client Rep to Server
function KFXLockTarget(Actor target)
{
	;
	KFXLockedTarget = target;
}
// Client Rep to Server
function KFXLossTarget()
{
	;
	KFXLockedTarget = none;
}

simulated function Destroyed()
{
	local int loop;
	log("KFXWeapBase ------ KFXWeaponID "$KFXWeaponID);
	if ( Instigator.IsLocallyControlled() )
	{
		if(Instigator!=none)
		StopAnimating();
	}

	if( Role == ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		for(loop =0; loop <6; loop++)
		{
			if( KFXWeapComponent[loop]!= none )
			{
				KFXWeapComponent[loop].Destroy();
			}
		}
	}
	KFXClearStates();
	super.Destroyed();
}

// TODO: ÇåÀí´úÂë
function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local int m;
	local weapon w;
	local bool bPossiblySwitch, bJustSpawned;

	Instigator = Other;
	W = Weapon(Instigator.FindInventoryType(class));
	if ( W == None || W.Class != class || W != self ) // added class check because somebody made FindInventoryType() return subclasses for some reason
	{
		bJustSpawned = true;
		Instigator = Other;
		if ( Other.AddInventory( Self ) )
			GotoState('');
		else
			Destroy();

		bPossiblySwitch = true;
		W = self;
	}
	else if ( !W.HasAmmo() )
		bPossiblySwitch = true;

	if ( Pickup == None )
		bPossiblySwitch = true;

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if ( FireMode[m] != None )
		{
			FireMode[m].Instigator = Instigator;
			W.GiveAmmo(m,WeaponPickup(Pickup),bJustSpawned);
		}
	}
	if ( Instigator.Weapon != W )
	{
		W.ClientWeaponSet(bPossiblySwitch);
		//Í³¼Æ¸ÃÎäÆ÷Ê±¼ä
	}

	if ( !bJustSpawned )
	{
		for (m = 0; m < NUM_FIRE_MODES; m++)
			Ammo[m] = None;
		Destroy();
	}
}

simulated function AnimEnd(int channel)
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if ( bIsReload && KFXReloadMode == 2 && ( anim == ReloadNormalAnim|| anim == ReloadNullAnim ) )
		return;

	if (ClientState == WS_ReadyToFire)
	{
		if (anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim)) // rocket hack
		{
			PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, 0.0);
		}
		else if (anim== FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
		{
			PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
		}
		/*else if ( KFXFireBase(FireMode[0]).KFXGetPawnState() == 1 )//ÅÜ
		{
			PlayAnim(RunAnim, 0.2 * RunAnimRate, 0.0);
		}*/
		else
		{
			PlayIdle();
		}
//        else if ((FireMode[0] == None || !FireMode[0].bIsFiring) && (FireMode[1] == None || !FireMode[1].bIsFiring))
//        {
//            PlayIdle();
//        }
//        else if( FireMode[0].bIsFiring )
//        {
//            PlayIdle();
//      }

	}
}
simulated event RenderOverlays( Canvas Canvas )
{
	local int m, loop;
	local vector NewScale3D;
	local rotator temp;
	local float XRate, Rate;//YRate;
	local float Left, Top, Width, Height;
	local vector PlaneNormal;

	if (Instigator == None)
		return;

	// FIXME: Set Hand Material
	KFXSetWeaponMaterial();

	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;
	else
		Hand = Level.GetLocalPlayerController().Handedness;

	// Do not support Center Hand
	if ((Hand < -1.0) || (Hand > 1.0) || (Hand == 0) )
		return;

	// draw muzzleflashes/smoke for all fire modes so idle state won't
	// cause emitters to just disappear
	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m] != None)
		{
			FireMode[m].DrawMuzzleFlash(Canvas);
		}
	}

	PlayerViewPivot.Roll = KFXInitPlayerViewPivot.Roll;
	PlayerViewPivot.Yaw  = KFXInitPlayerViewPivot.Yaw;

	PlayerViewOffset = KFXInitPlayerViewOffset;
	RenderedHand = Hand;

	SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self));
	SetRotation(Instigator.GetViewRotation() + KFXWeaponShakeView());

	if ( Hand == -1 )
	{
		PlaneNormal = vect(0,1,0);
		PlaneNormal = PlaneNormal>>Rotation;
		MirrorPlane.X = PlaneNormal.X;
		MirrorPlane.Y = PlaneNormal.Y;
		MirrorPlane.Z = PlaneNormal.Z;
		MirrorPlane.W = PlaneNormal dot (Instigator.Location+Instigator.EyePosition());
	}
	else
	{
		MirrorPlane.X = 0;
		MirrorPlane.Y = 0;
		MirrorPlane.Z = 0;
		MirrorPlane.W = 0;
	}

	if(self.Instigator.Physics==PHYS_Falling&&!KFXGetCanJumpFire()&&KFXPawnBase(Instigator).KFXLevelAllowHideWeap)
	{
		if(KFXPawn(self.Instigator).TickIndex*1000<16384)
		{
			KFXPawn(self.Instigator).TickIndex++;
			temp.Pitch = 65536 - KFXPawn(self.Instigator).TickIndex*1000;
			SetRotation( Instigator.GetViewRotation() + KFXWeaponShakeView() + temp );
		}
		else
		{
			self.SetRotation(Instigator.GetViewRotation() + KFXWeaponShakeView()+rot(49152,0,0));
		}
	}


	PreDrawFPWeapon();  // Laurent -- Hook to override things before render (like rotation if using a staticmesh)

	bDrawingFirstPerson = true;

	XRate = Canvas.SizeX/1024.0;
//    YRate = Canvas.SizeY/768.0;

//    if ( XRate>YRate )
		Rate = XRate;
//    else
//        Rate = YRate;
	if ( Hand < 0 )
	{
		Left = 0;
	}
	else if( Hand > 0 )
	{
		Left = FMax( Canvas.SizeX - 1024.0*Rate, 0 );
	}
	else
	{
		Left = FMax( Canvas.SizeX - 1024.0*Rate, 0 );
	}
	Top = FMax(Canvas.SizeY - 768.0*Rate, 0);
	Width = 1024.0*Rate;
	Height = 768.0*Rate;


	Canvas.DrawActorClipped(self,false,Left,Top,Width,Height,false,DisplayFOV);
//    Canvas.DrawActor(self, false, false, DisplayFOV);
	bDrawingFirstPerson = false;

	// Accessories Draw
	for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
	{
		if (KFXAccessoryMesh[loop] == none)
			continue;

		KFXAccessoryMesh[loop].SetDrawScale3D(newScale3D);
		KFXAccessoryMesh[loop].SetDrawScale(DrawScale);

		KFXAccessoryMesh[loop].PlayerViewOffset = PlayerViewOffset;
		KFXAccessoryMesh[loop].PlayerViewPivot = PlayerViewPivot;
		KFXAccessoryMesh[loop].SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );

		KFXAccessoryMesh[loop].SetRotation(Instigator.GetViewRotation());

		KFXAccessoryMesh[loop].bDrawingFirstPerson = true;
		KFXAccessoryMesh[loop].SetDrawType(DT_MESH);
		Canvas.DrawActor(KFXAccessoryMesh[loop], false, false, DisplayFOV);
		KFXAccessoryMesh[loop].SetDrawType(DT_NONE);
		KFXAccessoryMesh[loop].bDrawingFirstPerson = false;
	}


}

// Check Out of Ammo After
// Client Only
simulated function CheckOutOfAmmo();

// Do not auto Swtich When Out of Ammo
// Client Only
simulated function OutOfAmmo()
{
	//local bool bNeedDisplayHint;

	// µÀ¾ßÄ£Ê½£º×Ô¶¯ÇÐÇ¹
	if ( KFXMagicItemID > 0  )
	{
		Instigator.Controller.SwitchToBestWeapon();
		return;
	}

	// Weapon that Can't be Thrown
	if ( !bCanThrow || !KFXWeaponShowHint ) return;

	//bNeedDisplayHint = true;

	//if ( KFXHasAmmo() )
	//    bNeedDisplayHint = false;

	 if ( !KFXIsShareAmmo() )
	 {
		if ( KFXAmmoCount[1- KFXFireGroup] > 0 || KFXReload[1- KFXFireGroup] > 0 )
		{
			return;
		}
	 }

	//KFXPawn(Instigator).KFXSetHintMsg(KFXWeaponHint[0], 5);
	//°ïÖúÏûÏ¢£¬¼ñÇ¹
	if (!bKFXShowPickupWeapHint)
	{
		KFXPlayer(Instigator.Controller).ReceiveLocalizedMessage(class'KFXGameMessage', 51);
		bKFXShowPickupWeapHint = true;
		//PlayIdle();
	}
}

// Server Or Owner Client
simulated function IncrementFlashCount(int Mode)
{
	if ( WeaponAttachment(ThirdPersonActor) != None )
	{
		if(WeaponAttachment(ThirdPersonActor).FlashCount>=220&&WeaponAttachment(ThirdPersonActor).FlashCount<=225)
		WeaponAttachment(ThirdPersonActor).FlashCount = 1;
		if (Mode == 0)
			WeaponAttachment(ThirdPersonActor).FiringMode = 0; 
		else
		{
			KFXWeapAttachment(ThirdPersonActor).AltFirePlay = KFXWeapAttachment(ThirdPersonActor).AltFirePlay;
			WeaponAttachment(ThirdPersonActor).FiringMode = 1;
		}
		KFXWeapAttachment(ThirdPersonActor).TrackType = KFXFireBase(FireMode[Mode]).TrackType;
		log("TrackType "$KFXWeapAttachment(ThirdPersonActor).TrackType); 
		ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
		WeaponAttachment(ThirdPersonActor).FlashCount++;
		if ( WeaponAttachment(ThirdPersonActor).FlashCount == 200 )
			WeaponAttachment(ThirdPersonActor).FlashCount = 1;
		WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
	}
}
simulated function ServerPlayFiring(int mode)
{
	FireMode[Mode].ServerPlayFiring();
}

simulated function ServerPlayNoAmmoSound()
{
	// Play Empty sound
	PlayOwnedSound(KFXGetNoammoSound(),SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
}

//Client Simulated Fire Server
simulated function ServerIncrementFlashCount(int mode)
{
	KFXWeapAttachment(ThirdPersonActor).SetOnlyEffect(false);

	if ( WeaponAttachment(ThirdPersonActor) != None )
	{
		if(WeaponAttachment(ThirdPersonActor).FlashCount>=220&&WeaponAttachment(ThirdPersonActor).FlashCount<=225)
			WeaponAttachment(ThirdPersonActor).FlashCount = 1;
		if(KFXWeapAttachment(ThirdPersonActor).ServerFlashCount>=220&&KFXWeapAttachment(ThirdPersonActor).ServerFlashCount<=225)
			KFXWeapAttachment(ThirdPersonActor).ServerFlashCount = 1;
		if (Mode == 0)
			WeaponAttachment(ThirdPersonActor).FiringMode = 0;
		else
		{
			KFXWeapAttachment(ThirdPersonActor).AltFirePlay = KFXWeapAttachment(ThirdPersonActor).AltFirePlay;
			WeaponAttachment(ThirdPersonActor).FiringMode = 1;
		}
		//if(!bClientSimuFire)
			ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
		WeaponAttachment(ThirdPersonActor).FlashCount++ ;///= 0;
		if(Role == Role_Authority)
			KFXWeapAttachment(ThirdPersonActor).ServerFlashCount++;


		if ( KFXWeapAttachment(ThirdPersonActor).ServerFlashCount >= 200 )
			KFXWeapAttachment(ThirdPersonActor).ServerFlashCount = 1;

		WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
		log("KFXWeapbase------FlashCount "$WeaponAttachment(ThirdPersonActor).FlashCount);
		log("KFXWeapbase------ServerFlashCount "$KFXWeapAttachment(ThirdPersonActor).ServerFlashCount);

//        log("WeaponAttachment(ThirdPersonActor).FlashCount"$WeaponAttachment(ThirdPersonActor).FlashCount);
//        log("4-----WeaponAttachment(ThirdPersonActor).SpawnHitCount"$WeaponAttachment(ThirdPersonActor).SpawnHitCount);
	}
}
// Zero Spawn Hit Count
simulated function ZeroHitCount()
{
	if(bClientSimuFire)
	{
		ClientZeroHitCount();
	}
	else
	{
		if ( WeaponAttachment(ThirdPersonActor) != None )
		{
			// Zero SpawnHitCount
			WeaponAttachment(ThirdPersonActor).SpawnHitCount = 0;
		}
	}
}
simulated function ClientZeroSpawnHitCount()
{
	if(WeaponAttachment(ThirdPersonActor) != none )
	{
		KFXWeapAttachment(ThirdPersonActor).SpawnHitCount = 0;
	}
}
//Client simulated Fire  Zero Spawn Hit Count
simulated function ClientZeroHitCount()
{
	if(WeaponAttachment(ThirdPersonActor) != none )
	{
		// Zero SpawnHitCount
		KFXWeapAttachment(ThirdPersonActor).ServerHitCount = 0;
	}
}

// Weapon Client Shake View
simulated function rotator KFXWeaponShakeView()
{
	if ( KFXFireBase(FireMode[0]) != none )
	{
		return KFXFireBase(FireMode[0]).KFXGetPunchAngle();
	}
	return rot(0,0,0);
}
//-------------½ÇÉ«ÌøÆðºóµÄ¿ØÖÆÂß¼­--------

//--client only
simulated function KFXNotifyJump()
{
	if(Level.NetMode!=NM_DedicatedServer&&!KFXGetCanJumpFire())
	{
		PlayHoldWeap();//¶¯»­²¥·Å
		if(FireMode[0].bIsFiring)
		   ClientStopFire(0);
		if(FireMode[1].bIsFiring)
		   ClientStopFire(1);
	}
}
function HackTouchPawn( Pawn P );
simulated function PlayHoldWeap()
{
}
//---client only
simulated function KFXNotifyLanded()
{
	if(Level.NetMode==NM_DedicatedServer)
		 return;
	;
	if(KFXFireBase(FireMode[0])!=none&&KFXFireBase(FireMode[1])!=none&&!KFXGetCanJumpFire())
	{
		if(self.Instigator!=none && KFXPawnBase(self.Instigator).KFXLevelAllowHideWeap)
		{
			FireMode[0].NextFireTime =Level.TimeSeconds+KFXLandFireStopSec;
			PlayReSelect();//¶¯»­²¥·Å
		}
	}
}
simulated function PlayReselect()
{
}
//-------------½ÇÉ«ÌøÆðºóµÄ¿ØÖÆÂß¼­--------

// Can switch Weapon
simulated function bool KFXHackCanSwitchWeapon()
{
	if ( (IsFiring() && bCannotSwitchWhileFiring) || bEndOfRound )
		return false;

	return true;
}

// Modify Mouse Sens
simulated function float KFXHackMouseSens()
{
	 return 0.0;
}

// Can switch to This Weapon
simulated function bool KFXHackCanSwitchTo()
{
	return true;
}

// Limit View
simulated function bool KFXWeapHackRotation(rotator OldRot, rotator NewRot, out rotator HackRot)
{
	return false;
}
// Hack Eyeheight
simulated function vector KFXHackEyePosition(vector OrgPos)
{
	return OrgPos;
}

// Hack View Pitch
simulated function bool KFXHackPitchLimit(out int Pitch)
{
	return false;
}

function bool IsTouchOtherPawn()
{
	return false;
}

//ÖÓ:¼ÜÇ¹Ç°È¡µÃ¼ÜÇ¹ºóÑÛ¾¦Î»ÖÃÒÔ±ãÅÐ¶¨¿É·ñ¼ÜÇ¹
simulated function vector KFXHackDeployEyePosition(actor target)
{
	local vector TraceStart, TraceEnd, X, Y, Z, BlockLoc, BlockNormal;
	local rotator PawnRotation;
	local float BlockHeight;

	PawnRotation = rotator(target.Location - Instigator.Location);
	//PawnRotation = Rotation;
	PawnRotation.Pitch = 0;
	GetAxes(PawnRotation, X, Y, Z);
	TraceStart = Instigator.Location + Instigator.EyePosition();
	TraceEnd = TraceStart + X * 80;
	//ÏòÇ°×·×Ù
	if ( !FastTrace(TraceEnd, TraceStart) )
	{
		return vect(10000, 10000, 10000);
	}
	//ÏòÏÂ×·×Ù
	TraceStart = TraceEnd;
	TraceEnd = Instigator.Location + X * 80;
	TraceEnd.Z = TraceEnd.Z - Instigator.CollisionHeight;
	if( !KFXGameInfo(Level.Game).KFXMGAllowLostCollision )
	{
		return vect(10000, 10000, 10000);
	}
	if ( Trace(BlockLoc, BlockNormal, TraceEnd, TraceStart) == none )
	{
		BlockHeight = 0;
	}
	else
	{
		BlockHeight = BlockLoc.Z - TraceEnd.Z;
	}

	if ( BlockHeight > 144/*Instigator.CollisionHeight * 1.5*/ )
	{
		return vect(10000, 10000, 10000);
	}

	if ( BlockHeight < 0 )
		BlockHeight = 0;

	return vect(0,0,1) * (BlockHeight - Instigator.CollisionHeight + 30) - Instigator.WalkBob + Instigator.Location;

}

function int BotGetWeaponType()
{
	return 0; //²½Ç¹
}

//<<ÖÓ:bot¼ÜÇ¹
function BotAltFire(bool open)
{
	local KFXFireBase F;
	F = KFXFireBase(FireMode[1]);

	if(F != none)
	{
		if(open)
		{
			F.KFXBotDeploy();
		}
		else
		{
			F.KFXBotUndeploy();
		}
	}
}

function bool BotGetDeploy()
{
	local KFXFireBase F;
	F = KFXFireBase(FireMode[1]);
	return F.KFXBotGetDeploy();
}
//>>

// ³õÊ¼»¯µ¯¼Ð
function KFXSetCartridgeClip(KFXPawn P)
{
	local KFXCSVTable CFG_Weapon;
	local int WeapType[2];
	local int ReloadNum;

	if ( P == none )
	{
		return;
	}

	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);

	if ( !CFG_Weapon.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve The Weapon ID (Attribute Table): "$KFXWeaponID);
		return;
	}

	WeapType[0] = CFG_Weapon.GetInt( "WeaponGroup1" );
	WeapType[1] = CFG_Weapon.GetInt( "WeaponGroup2" );

	// ±¸·Ý°²×°µ¯¼ÐÇ°µÄ×Óµ¯Êý
	KFXInitAmmoCount[0] = KFXAmmoCount[0];
	KFXInitAmmoCount[1] = KFXAmmoCount[1];
	KFXInitReload[0] = KFXReload[0];
	KFXInitReload[1] = KFXReload[1];
	KFXInitReloadMax[0] = KFXReloadMax[0];
	KFXInitReloadMax[1] = KFXReloadMax[1];

	Switch( WeapType[0] )
	{
		case 2: // ³å·æ
			if ( P.fxChargeCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxChargeCartridgeClip;
				KFXReload[0] += P.fxChargeCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxChargeCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 3: // Í»»÷²½Ç¹
			if ( P.fxShockCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxShockCartridgeClip;
				KFXReload[0] += P.fxShockCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxShockCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 4: // ¾Ñ»÷Ç¹
			if ( P.fxSnipeCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxSnipeCartridgeClip;
				KFXReload[0] += P.fxSnipeCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxSnipeCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 5: // Çá»úÇ¹
			if ( P.fxLightCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxLightCartridgeClip;
				KFXReload[0] += P.fxLightCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxLightCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 6: // ÖØ»úÇ¹
			if ( P.fxHeavyCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxHeavyCartridgeClip;
				KFXReload[0] += P.fxHeavyCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxHeavyCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 7: // Áñµ¯ÅÚ
			if ( P.fxHowitzerCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxHowitzerCartridgeClip;
				KFXReload[0] += P.fxHowitzerCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxHowitzerCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 8:
			if ( P.fxBazookaCartridgeClip > 0 )
			{
				KFXAmmoCount[0] += P.fxBazookaCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 9: // ÊÖÇ¹
			if ( P.fxPistolCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxPistolCartridgeClip;
				KFXReload[0] += P.fxPistolCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxPistolCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
		case 11: // É¢µ¯Ç¹
			if ( P.fxShotCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[0] / KFXReloadMax[0];
				KFXReloadMax[0] += P.fxShotCartridgeClip;
				KFXReload[0] += P.fxShotCartridgeClip;
				KFXAmmoCount[0] += ReloadNum * P.fxShotCartridgeClip;
				KFXHasCartridgeClip[0] = 1;
			}
			break;
	}

	if ( KFXIsShareAmmo() )
	{
		return;
	}

	Switch( WeapType[1] )
	{
		case 2: // ³å·æ
			if ( P.fxChargeCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxChargeCartridgeClip;
				KFXReload[1] += P.fxChargeCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxChargeCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 3: // Í»»÷²½Ç¹
			if ( P.fxShockCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxShockCartridgeClip;
				KFXReload[1] += P.fxShockCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxShockCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 4: // ¾Ñ»÷Ç¹
			if ( P.fxSnipeCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxSnipeCartridgeClip;
				KFXReload[1] += P.fxSnipeCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxSnipeCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 5: // Çá»úÇ¹
			if ( P.fxLightCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxLightCartridgeClip;
				KFXReload[1] += P.fxLightCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxLightCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 6: // ÖØ»úÇ¹
			if ( P.fxHeavyCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxHeavyCartridgeClip;
				KFXReload[1] += P.fxHeavyCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxHeavyCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 7: // Áñµ¯ÅÚ
			if ( P.fxHowitzerCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxHowitzerCartridgeClip;
				KFXReload[1] += P.fxHowitzerCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxHowitzerCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 8:
			if ( P.fxBazookaCartridgeClip > 0 )
			{
				KFXAmmoCount[1] += P.fxBazookaCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 9: // ÊÖÇ¹
			if ( P.fxPistolCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxPistolCartridgeClip;
				KFXReload[1] += P.fxPistolCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxPistolCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
		case 11: // É¢µ¯Ç¹
			if ( P.fxShotCartridgeClip > 0 )
			{
				ReloadNum = KFXAmmoCount[1] / KFXReloadMax[1];
				KFXReloadMax[1] += P.fxShotCartridgeClip;
				KFXReload[1] += P.fxShotCartridgeClip;
				KFXAmmoCount[1] += ReloadNum * P.fxShotCartridgeClip;
				KFXHasCartridgeClip[1] = 1;
			}
			break;
	}
}

// ³õÊ¼»¯´©¼×¿¨
function KFXSetArmourPierce(KFXPawn P)
{
	local KFXCSVTable CFG_Weapon;
	local int WeapType[2];
	local int loopi,loopj;

	if ( P == none )
	{
		return;
	}

	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);

	if ( !CFG_Weapon.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve The Weapon ID (Attribute Table): "$KFXWeaponID);
		return;
	}

	WeapType[0] = CFG_Weapon.GetInt( "WeaponGroup1" );

	Switch( WeapType[0] )
	{
		case 2:
			if ( P.KFXChargeArmorPierce > 0 )
			{
				for ( loopi = 0; loopi<KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM; loopi++ )
				{
					for( loopj = 0; loopj<KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM; loopj++ )
					{
						KFXModeDmgArmorPct[0].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] *= P.KFXChargeArmorPierce;
						KFXModeDmgArmorPct[1].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] *= P.KFXChargeArmorPierce;
						;
						;
						;

					}
				}
			}
			break;
		case 3:
			if ( P.KFXShockArmorPierce > 0 )
			{
				for ( loopi = 0; loopi<KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM; loopi++ )
				{
					for( loopj = 0; loopj<KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM; loopj++ )
					{
						KFXModeDmgArmorPct[0].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] *= P.KFXShockArmorPierce;
						KFXModeDmgArmorPct[1].ArmorPct[loopi*KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM+loopj] *= P.KFXShockArmorPierce;
						;
						;
						;

					}
				}
			}
			break;
	}
}

function int KFXGetInitReload(int mode)
{
	return KFXInitReload[mode];
}

function int KFXGetInitAmmo(int mode)
{
	return KFXInitAmmoCount[mode];
}

function int KFXGetHasCartridgeClip(int mode)
{
	return KFXHasCartridgeClip[mode];
}

function int KFXGetInitReloadMax(int mode)
{
	return KFXInitReloadMax[mode];
}

simulated function float KFXGetSwitchWeaponDown()
{
	if ( Level.NetMode == NM_DedicatedServer )
	{
		return 1.0;
	}
	//if ( Instigator != none && KFXPawn(Instigator).KFXFostSwitchWeapon.SwitchDown != 0 )
	if ( Instigator != none && KFXPawn(Instigator).TotalChangeSpeedEx != 0 )
	{
		return KFXPawn(Instigator).TotalChangeSpeedEx;
		//return KFXPawn(Instigator).KFXFostSwitchWeapon.SwitchDown;
	}
	else
	{
		return 1.0;
	}
}

simulated function float KFXGetBringUpDown()
{
	if ( Level.NetMode == NM_DedicatedServer )
	{
		return 1.0;
	}
	//if ( Instigator != none && KFXPawn(Instigator).KFXFostSwitchWeapon.BringUpDown != 0 )
	 if ( Instigator != none && KFXPawn(Instigator).TotalWeaponBrightUpDown != 0 )
	 {
		return KFXPawn(Instigator).TotalWeaponBrightUpDown;
		//return KFXPawn(Instigator).KFXFostSwitchWeapon.BringUpDown;
	}
	else
	{
		return 1.0;
	}
}

///
/// È¡µÃ»»µ¯¼ÓËÙ±¶Êý
///
simulated function float KFXGetSwitchAmmoRate()
{
	return KFXPlayerReplicationInfo(KFXPawn(Instigator).PlayerReplicationInfo).fxFastSwitchAmmoRate;

}

//Client&Server
function KFXServerComponentInit(int ComponentID[6])
{
	local KFXCSVTable CFG_GunExplain;
	local int i;
	local int OldFireGroup;
	local int OldReloadMode;
	CFG_GunExplain = class'KFXTools'.static.GetConfigTable(55);

	if( !CFG_GunExplain.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve KFXWeaponID (WeaponGunExplain table): "$KFXWeaponID);
		return;
	}

	for(i=0; i< 6; i++)
	{
		//Èç¹û¸Ã´¦Ã»ÓÐÅä¼þ£¬ÔòÓÃÄ¬ÈÏ×é¼þ
		log("KFXWeaponBase-------ComponentID[i] "$ComponentID[i]);
		if(ComponentID[i] == 0)
		{
			ComponentID[i] = CFG_GunExplain.GetInt("DefComponent"$(i+1));
		}
		if( ComponentID[i]!= 0 )
		{
			KFXServerAddComponent(i+1,ComponentID[i]);
		}
	}
	OldFireGroup = KFXFireGroup;
	OldReloadMode = KFXReloadMode;
	KFXReloadMode = 1;
	//KFXFireGroup = 0;
	KFXReloadAmmo();
	//KFXFireGroup = 1;
	//KFXReload[1] = KFXGetReloadMax();
	KFXFireGroup = OldFireGroup;
	KFXReloadMode = OldReloadMode;
}

function KFXServerAddComponent(int part,int ComponentID)
{
	 KFXAddComponent(part,ComponentID,KFXWeaponID);
	 if( Level.NetMode == NM_DedicatedServer )
	 {
		 KFXClientAddComponent(part,ComponentID,KFXWeaponID);
	 }
}

simulated function KFXClientAddComponent(int part,int ComponentID,optional int WeaponID)
{
	 KFXAddComponent(part,ComponentID,WeaponID);
}

//Ìí¼ÓÊ±½øÐÐµÄÐÞ¸Ä£¬ÒªºÍÒÆ³ýÊ±½øÐÐµÄÐÞ¸ÄÏà¶ÔÓ¦
//Client&Server
simulated function KFXAddComponent(int part,int ComponentID,int WeaponID)
{
	local KFXCSVTable CFG_WeaponComponent,CFG_WeaponAtribute,CFG_FireMode;
	local int FireModeID[2];
	local int loop;
	local class<WeaponFire> NewFireModeClass;
	local string str;
	FireModeID[0] = 0;
	FireModeID[1] = 0;

	if( ComponentID == 0 )
	{
		return;
	}

	CFG_WeaponComponent = class'KFXTools'.static.GetConfigTable(22);
	CFG_WeaponAtribute = class'KFXTools'.static.GetConfigTable(11);
	CFG_FireMode =  class'KFXTools'.static.GetConfigTable(12);

	if( !CFG_WeaponComponent.SetCurrentRow(ComponentID) )
	{
		Log("[KFXWeaponBase] Can't Resolve ComponentID (component Table): "$ComponentID);
		return;
	}
	if(!CFG_WeaponAtribute.SetCurrentRow(WeaponID))
	{
		Log("[KFXWeaponBase] Can't Resolve WeaponID (Attribute Table): "$WeaponID);
		return;
	}

	if( Role == ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		KFXWeapComponent[part-1]=spawn(class<WeaponComponent>( DynamicLoadObject( "XXXWeapons.XXX_"$CFG_WeaponComponent.GetString("Name")$"Component", class'Class' ,true) ),self);
		log("KFXWeapComponent:"$KFXWeapComponent[part-1]);
		KFXWeapComponent[part-1].SetOwner(Instigator);
		KFXWeapComponent[part-1].KFXServerInit(ComponentID,self);
	}

	if(CFG_WeaponComponent.GetInt("FireMode1") != 0 )
	{
		FireModeID[0] = CFG_WeaponComponent.GetInt("FireMode1")+CFG_WeaponAtribute.GetInt("FireMode1");
		if ( !CFG_FireMode.SetCurrentRow(FireModeID[0]) )
		{
			Log("[Kevin] Can't Resolve The FireMode ID: "$FireModeID[0]);
			return;
		}
		NewFireModeClass = class<WeaponFire>( DynamicLoadObject( CFG_FireMode.GetString("Class"), class'Class' ) );
		if(FireMode[0]!=none)
			DestroyFireMode( 0 );
		FireMode[0] = new(self) NewFireModeClass;

		Log("change firemode sucess 1");
	}

	if(CFG_WeaponComponent.GetInt("FireMode2") != 0 )
	{
		FireModeID[1] = CFG_WeaponComponent.GetInt("FireMode2")+CFG_WeaponAtribute.GetInt("FireMode2");
		if ( !CFG_FireMode.SetCurrentRow(FireModeID[1]) )
		{
			Log("[Kevin] Can't Resolve The FireMode ID: "$FireModeID[1]);
			return;
		}
		NewFireModeClass = class<WeaponFire>( DynamicLoadObject( CFG_FireMode.GetString("Class"), class'Class' ) );
		if(FireMode[1]!=none)
			DestroyFireMode( 1 );
		FireMode[1] = new(self) NewFireModeClass;
		Log("change firemode sucess 2");

	}
	//
	if( FireModeID[0]!=0 || FireModeID[1]!= 0)
	{
		InitWeaponFires();
		Log("NewFiremode InitWeaponFires");
	}

	if( Role == ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		bShowAnoFireSound = bShowAnoFireSound || KFXWeapComponent[part-1].bShowAnotherFireSound;
	   log("KFXWeapBase---------bShowAnoFireSound "$bShowAnoFireSound);

	}
	for (loop = 0; loop < 2; loop++)
	{
		if (FireModeID[loop] != 0)
		{
			FireMode[loop].ThisModeNum = loop;
			FireMode[loop].Weapon = self;
			FireMode[loop].Instigator = Instigator;
			FireMode[loop].Level = Level;
			FireMode[loop].Owner = self;
			FireMode[loop].PreBeginPlay();
			FireMode[loop].BeginPlay();
			FireMode[loop].PostBeginPlay();
			FireMode[loop].SetInitialState();
			FireMode[loop].PostNetBeginPlay();

			KFXFireBase(FireMode[loop]).KFXInit(WeaponID);
			Log("NewFiremode "$FireModeID[loop]);

			//szwtodo:ÓÉÓÚFireModeÖÐµÄ²¿·Ö±äÁ¿À´×ÔWeaponµÄÆäËûcsv±í£¬ËùÒÔÐèÒªÔÚÐÂFireMode³õÊ¼»¯Íê³ÉºóÔÙ¶ÔÊýÖµ½øÐÐÐÞ¸Ä
		}
		KFXFireBase(FireMode[loop]).ModifyByWeapCmpnt(ComponentID);
	}

	//°²×°ÎÕ°ÑµÄÎäÆ÷ÐèÒª°ÑËùÓÐ¶¯»­ÉèÖÃ³ÉÎÕ×¡ÎÕ°ÑµÄ¶¯»­
	if( Level.NetMode == NM_Client || Level.NetMode == NM_Standalone )
	{
		if(part == 3 && ComponentID != 0)
		{
			if(IdleAnim!='') IdleAnim = class'DataTable'.static.StringToName(IdleAnim$"_G");
			if(RestAnim!='') RestAnim = class'DataTable'.static.StringToName(RestAnim$"_G");
			if(AimAnim!='')  AimAnim = class'DataTable'.static.StringToName(AimAnim$"_G");
			if(RunAnim!='')   RunAnim = class'DataTable'.static.StringToName(RunAnim$"_G");
			if(SelectAnim!='') SelectAnim = class'DataTable'.static.StringToName(SelectAnim$"_G");
			if(PutDownAnim!='') PutDownAnim = class'DataTable'.static.StringToName(PutDownAnim$"_G");
			if(StartReloadAnim!='') StartReloadAnim = class'DataTable'.static.StringToName(StartReloadAnim$"_G");
			if(ReloadNormalAnim!='') ReloadNormalAnim = class'DataTable'.static.StringToName(ReloadNormalAnim$"_G");
			if(ReloadNullAnim!='') ReloadNullAnim = class'DataTable'.static.StringToName(ReloadNullAnim$"_G");
			if(AfterReloadAnim!='') AfterReloadAnim = class'DataTable'.static.StringToName(AfterReloadAnim$"_G");

			for(loop=0; loop < 2;loop++)
			{
				if(FireMode[loop].PreFireAnim!='')
					FireMode[loop].PreFireAnim = class'DataTable'.static.StringToName(FireMode[loop].PreFireAnim$"_G");
				if(FireMode[loop].FireAnim!='')
					FireMode[loop].FireAnim = class'DataTable'.static.StringToName(FireMode[loop].FireAnim$"_G");
				if(FireMode[loop].FireLoopAnim!='')
					FireMode[loop].FireLoopAnim = class'DataTable'.static.StringToName(FireMode[loop].FireLoopAnim$"_G");
				if(FireMode[loop].FireEndAnim!='')
					FireMode[loop].FireEndAnim = class'DataTable'.static.StringToName(FireMode[loop].FireEndAnim$"_G");
				if(KFXFireBase(FireMode[loop]).EmptyFireAnim!='')
					KFXFireBase(FireMode[loop]).EmptyFireAnim = class'DataTable'.static.StringToName(KFXFireBase(FireMode[loop]).EmptyFireAnim$"_G");
			}
		}
	}

	//ÎäÆ÷¹Ò¼þµÄÊôÐÔ£º
	KFXReload[0] += KFXWeapComponent[part-1].KFXReloadMax[0];
	KFXReload[1] += KFXWeapComponent[part-1].KFXReloadMax[1];



}
simulated function KFXCreateNewFireMode(int ModeID,int FireModeID,string FireModeClass,int WeaponID,optional int ComponentID)
{
	local int loop;
	local class<WeaponFire> NewFireModeClass;

	Loop = ModeID;
	NewFireModeClass = class<WeaponFire>( DynamicLoadObject( FireModeClass, class'Class' ) );
	if(FireMode[loop]!=none)
		DestroyFireMode( loop );
	FireMode[loop] = new(self) NewFireModeClass;

	Log("change firemode sucess 1");

	if (FireModeID != 0)
	{
		FireMode[loop].ThisModeNum = loop;
		FireMode[loop].Weapon = self;
		FireMode[loop].Instigator = Instigator;
		FireMode[loop].Level = Level;
		FireMode[loop].Owner = self;
		FireMode[loop].PreBeginPlay();
		FireMode[loop].BeginPlay();
		FireMode[loop].PostBeginPlay();
		FireMode[loop].SetInitialState();
		FireMode[loop].PostNetBeginPlay();

		KFXFireBase(FireMode[loop]).KFXInit(WeaponID);
		//Log("NewFiremode "$FireModeID);

		//szwtodo:ÓÉÓÚFireModeÖÐµÄ²¿·Ö±äÁ¿À´×ÔWeaponµÄÆäËûcsv±í£¬ËùÒÔÐèÒªÔÚÐÂFireMode³õÊ¼»¯Íê³ÉºóÔÙ¶ÔÊýÖµ½øÐÐÐÞ¸Ä
	}
	KFXFireBase(FireMode[loop]).ModifyByWeapCmpnt(ComponentID);
}
//Client&Server
simulated function KFXRemoveComponent(int part,optional int ComponentID)
{
	local KFXCSVTable CFG_WeaponComponent,CFG_WeaponAtribute,CFG_FireMode;
	local int FireModeID[2];
	local int loop;
	FireModeID[0] = 0;
	FireModeID[1] = 0;

	if(KFXWeapComponent[part-1] == none )
	{
		return;
	}

	CFG_WeaponComponent = class'KFXTools'.static.GetConfigTable(22);
	CFG_WeaponAtribute = class'KFXTools'.static.GetConfigTable(11);
	CFG_FireMode =  class'KFXTools'.static.GetConfigTable(12);

	if(!CFG_WeaponAtribute.SetCurrentRow(KFXWeaponID))
	{
		Log("[KFXWeaponBase] Can't Resolve KFXWeaponID (Attribute Table): "$KFXWeaponID);
		return;
	}

	if( Role!= ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		if( !DetachFromBone( KFXWeapComponent[part-1]))
		{
			return;
		}
	}


	//ÖØÐÂ¼ÆËã¿ª»ðÄ£Ê½
	if(CFG_WeaponComponent.GetInt("FireMode1") != 0 )
	{
		FireModeID[0] = CFG_WeaponComponent.GetInt("FireMode1")+CFG_WeaponAtribute.GetInt("FireMode1");
		if ( !CFG_FireMode.SetCurrentRow(FireModeID[0]) )
		{
			Log("[Kevin] Can't Resolve The FireMode ID: "$FireModeID[0]);
			return;
		}
		FireModeClass[0] = class<WeaponFire>( DynamicLoadObject( CFG_FireMode.GetString("Class"), class'Class' ) );
		FireMode[0] = new(self) FireModeClass[0];

	}

	if(CFG_WeaponComponent.GetInt("FireMode2") != 0 )
	{
		FireModeID[1] = CFG_WeaponComponent.GetInt("FireMode2")+CFG_WeaponAtribute.GetInt("FireMode2");
		if ( !CFG_FireMode.SetCurrentRow(FireModeID[1]) )
		{
			Log("[Kevin] Can't Resolve The FireMode ID: "$FireModeID[1]);
			return;
		}
		FireModeClass[1] = class<WeaponFire>( DynamicLoadObject( CFG_FireMode.GetString("Class"), class'Class' ) );
		FireMode[1] = new(self) FireModeClass[1];
	}

	if( FireModeID[0]!=0 || FireModeID[1]!= 0)
	{
		InitWeaponFires();
	}


	for (loop = 0; loop < 2; loop++)
	{
		if (FireModeID[loop] != 0)
		{
			FireMode[loop].ThisModeNum = loop;
			FireMode[loop].Weapon = self;
			FireMode[loop].Instigator = Instigator;
			FireMode[loop].Level = Level;
			FireMode[loop].Owner = self;
			FireMode[loop].PreBeginPlay();
			FireMode[loop].BeginPlay();
			FireMode[loop].PostBeginPlay();
			FireMode[loop].SetInitialState();
			FireMode[loop].PostNetBeginPlay();

			KFXFireBase(FireMode[loop]).KFXInit(KFXWeaponID);
		}
	}

}

//ÒÆ³ýÊ±ÏÈ´Ó¿Í»§¶Ë¿ªÊ¼£¬ÒòÎª´ËÊ±¿Í»§¶Ë»¹ÐèÒª¶Ô×é¼þ½øÐÐ·ÃÎÊ
simulated function KFXClientRemoveComponent(int part,optional int ComponentID)
{
	 KFXRemoveComponent(part,ComponentID);
	 KFXServerRemoveComponent(part,ComponentID);
}

simulated function KFXServerRemoveComponent(int part,optional int ComponentID)
{
	 KFXRemoveComponent(part,ComponentID);

	 //¸Ã×é¼þÖ»ÐèÒªÔÚ·þÎñ¶ËÏú»Ù
	 KFXWeapComponent[part-1].Destroy();
	 KFXWeapComponent[part-1] = none;

}

function KFXServerDurableFact(float durable)
{
	local KFXCSVTable CFG_Item;
	CFG_Item = class'KFXTools'.static.GetConfigTable(30);
	if(!CFG_Item.SetCurrentRow(KFXWeaponID))
	{
		log("[KFXServerDurableFact] can not locate the row with WeapID"@KFXWeaponID);
		return;
	}
	if(CFG_Item.GetFloat("RepairGameCoin") > 0.000f)
	{
		KFXClientDurableFact(durable);
		KFXDurableFact(durable);
	}
}

simulated function KFXClientDurableFact(float durable)
{
	KFXDurableFact(durable);
}

//ÔÚ´´½¨ÎäÆ÷Ö®ºóµ÷ÓÃ¸Ãº¯Êý£¬¸ù¾ÝÄÍ¾Ã¶È¶ÔÎäÆ÷ÊôÐÔ½øÐÐÐÞ¸Ä
simulated function KFXDurableFact(float durable)
{
	 local KFXCSVTable CFG_WeapAttr,CSVItems;
	 local int WeapType,loop;
	 local float DamageDown,CrossUp,FireTimeSecond;

	 WeapDurable = durable;
	 WeapType = KFXWeaponID>>16;

	 CSVItems = class'KFXTools'.static.GetConfigTable(30);
	 CFG_WeapAttr = class'KFXTools'.static.GetConfigTable(11);

	if( !CSVItems.SetCurrentRow(KFXWeaponID))
	{
		log("[KFXWeapBase] CSVItems.SetCurrentRow Failed KFXWeaponID "$KFXWeaponID);
		return;
	}
	 if( !CFG_WeapAttr.SetCurrentRow(KFXWeaponID))
	{
		log("[KFXWeapBase] CSVItems.SetCurrentRow Failed KFXWeaponID "$KFXWeaponID);
		return;
	}
	//Ö»ÓÐÄÍ¾Ã¶ÈµÄÖ÷ÎäÆ÷ºÍ¸±ÎäÆ÷²Å»áÊÜµ½Ó°Ïì
	if( WeapType < 41 && WeapType > 0 )
	{
		 //Ê±ÏÞÎäÆ÷ÎÞÐ§
		 if( CSVItems.GetInt("useType") != 0)
		 {
			 return;
		 }
		 else //¸ù¾ÝÊ£ÓàÄÍ¾Ã¶È°Ù·Ö±È£¬¶ÔÎäÆ÷ÊôÐÔ½øÐÐÐÞ¸Ä
		 {
			 DamageDown = CFG_WeapAttr.GetFloat("DurDamageDown");
			 FireTimeSecond = CFG_WeapAttr.GetFloat("DurFireTime");
			 CrossUp =  CFG_WeapAttr.GetFloat("DurCrossUp");
			 if( durable < 1 )
			 {
				KFXModeDamage[0]-= 3*DamageDown;
				KFXModeDamage[1]-= 3*DamageDown;

				//ÔÝÊ±²»¹ÜÁ¬Éä¼ä¸ô
				KFXModeRate[0] += 3*FireTimeSecond;
				KFXModeRate[1] +=  3*FireTimeSecond;

				//»¹ÐèÒªÌí¼Ó×¼ÐÇÀ©´ó
				//FireMode[0].CrossHairRaiseFactor *= ( 1 + 3*CrossUp );
				//FireMode[0].CrossHairDecayFactor *= ( 1 + 3*CrossUp );
				//FireMode[1].CrossHairRaiseFactor *= ( 1 + 3*CrossUp );
				//FireMode[1].CrossHairDecayFactor *= ( 1 + 3*CrossUp );

				for(loop=0; loop < 3; loop++)
				{
					//KFXFireBase(FireMode[0]).CrossHairMaxLength[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairMaxSpread[loop] *= ( 1 + 3*CrossUp );
					//KFXFireBase(FireMode[0]).CrossHairMinLength[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairMinSpread[loop] *= (  1 + 3*CrossUp );

					KFXFireBase(FireMode[0]).CrossHairSpreadCrouch[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadStand[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadRun[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadWalk[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadJump[loop] *= (  1 + 3*CrossUp );

					//KFXFireBase(FireMode[1]).CrossHairMaxLength[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairMaxSpread[loop] *= (  1 + 3*CrossUp );
					//KFXFireBase(FireMode[1]).CrossHairMinLength[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairMinSpread[loop] *= (  1 + 3*CrossUp );

					KFXFireBase(FireMode[1]).CrossHairSpreadCrouch[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadStand[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadRun[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadWalk[loop] *= (  1 + 3*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadJump[loop] *= (  1 + 3*CrossUp );
				}

			 }
			 else if( (durable/10000.0) < CFG_WeapAttr.GetFloat("DurFactor2"))
			 {
				KFXModeDamage[0]-= 2*DamageDown;
				KFXModeDamage[1]-= 2*DamageDown;

				//
				KFXModeRate[0] += 2*FireTimeSecond;
				KFXModeRate[1] +=  2*FireTimeSecond;

				//»¹ÐèÒªÌí¼Ó×¼ÐÇÀ©´ó
				for(loop=0; loop < 3; loop++)
				{
					//KFXFireBase(FireMode[0]).CrossHairMaxLength[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairMaxSpread[loop] *= (  1 + 2*CrossUp );
					//KFXFireBase(FireMode[0]).CrossHairMinLength[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairMinSpread[loop] *= (  1 + 2*CrossUp );

					KFXFireBase(FireMode[0]).CrossHairSpreadCrouch[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadStand[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadRun[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadWalk[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[0]).CrossHairSpreadJump[loop] *= (  1 + 2*CrossUp );

					//KFXFireBase(FireMode[1]).CrossHairMaxLength[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairMaxSpread[loop] *= (  1 + 2*CrossUp );
					//KFXFireBase(FireMode[1]).CrossHairMinLength[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairMinSpread[loop] *= (  1 + 2*CrossUp );

					KFXFireBase(FireMode[1]).CrossHairSpreadCrouch[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadStand[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadRun[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadWalk[loop] *= (  1 + 2*CrossUp );
					KFXFireBase(FireMode[1]).CrossHairSpreadJump[loop] *= (  1 + 2*CrossUp );
				}
			 }
			 else if((durable/10000.0) < CFG_WeapAttr.GetFloat("DurFactor1"))
			 {
				KFXModeDamage[0]-= DamageDown;
				KFXModeDamage[1]-= DamageDown;

				//ÔÝÊ±²»¹ÜÁ¬Éä¼ä¸ô
				KFXModeRate[0] += FireTimeSecond;
				KFXModeRate[1] += FireTimeSecond;

				//»¹ÐèÒªÌí¼Ó×¼ÐÇÀ©´ó
				for(loop=0; loop < 3; loop++)
				{
					//KFXFireBase(FireMode[0]).CrossHairMaxLength[loop] *=  (1 + CrossUp);
					KFXFireBase(FireMode[0]).CrossHairMaxSpread[loop] *= (1 + CrossUp);
					//KFXFireBase(FireMode[0]).CrossHairMinLength[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[0]).CrossHairMinSpread[loop] *= (1 + CrossUp);

					KFXFireBase(FireMode[0]).CrossHairSpreadCrouch[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[0]).CrossHairSpreadStand[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[0]).CrossHairSpreadRun[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[0]).CrossHairSpreadWalk[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[0]).CrossHairSpreadJump[loop] *= (1 + CrossUp);

					//KFXFireBase(FireMode[1]).CrossHairMaxLength[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[1]).CrossHairMaxSpread[loop] *= (1 + CrossUp);
					//KFXFireBase(FireMode[1]).CrossHairMinLength[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[1]).CrossHairMinSpread[loop] *= (1 + CrossUp);

					KFXFireBase(FireMode[1]).CrossHairSpreadCrouch[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[1]).CrossHairSpreadStand[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[1]).CrossHairSpreadRun[loop] *= (1 + CrossUp);
					KFXFireBase(FireMode[1]).CrossHairSpreadWalk[loop] *= (1 + CrossUp) ;
					KFXFireBase(FireMode[1]).CrossHairSpreadJump[loop] *= (1 + CrossUp);
				}

			 }
		 }
	}

	log("WeapType is"@KFXWeaponID/65536);

}






////////////////////////  for cs weapon effect tail ///////////////////////////

defaultproperties
{
     KFXWeaponShowHint=是
     PutDownTime=0.010000
     BringUpTime=1.000000
     bCanThrow=否
     bForceSwitch=是
     PickupClass=Class'KFXGame.KFXWeapPickup'
     BobDamping=2.200000
     AttachmentClass=Class'KFXGame.KFXWeapAttachment'
     LightType=LT_Pulse
     LightHue=32
     LightSaturation=120
     LightBrightness=220.000000
     LightRadius=10.000000
     bNoRepMesh=是
}
