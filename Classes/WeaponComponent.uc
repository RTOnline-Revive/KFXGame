//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WeaponComponent extends Inventory
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



const KFX_PAWN_STATE_NUM = 5;
const NUM_SND_FPFIRE_WC = 4;
const NUM_FIRE_MODES = 2;



var bool bInitToWeapon;
var int ComponentTypeID;
var int WeaponTypeID;
var int WeaponPart;

var KFXWeapBase FirstPersonWeapon;

var int FireModeValue[2];

var float KFXFireFlyFactor[2];

// Accuracy¼ÆËã²ÎÊý
var float KFXAccuracyDivision[2];
var float KFXAccuracyOffset[2];
var float KFXMaxInaccuracy[2];

// Spread¼ÆËã¹«Ê½
var int KFXSpreadType[2];


// KickBack²ÎÊý½á¹¹
struct native KFXKickBackParams
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
struct native KFXSpreadParams
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

var int KFXCornerStaticShotsCount[2];


var int KFXFPHandID;

const KFX_MAX_ACCESSORY_NUM = 7;
var int KFXAccessory[KFX_MAX_ACCESSORY_NUM];

var float KFXReloadTime;

var float KFXSpeedFactor[2];   // ËÙ¶ÈÓ°Ïì²ÎÊý
var float  KFXModeRate[2];
var  int   KFXModeDamage[2];
var  int     KFXModeRange[2];
var  int     KFXMode0ValidRange[4];
var  int     KFXMode1ValidRange[4];
var  float   KFXMode0ValidDmgFactor[4];
var  float   KFXMode1ValidDmgFactor[4];

var  int     KFXAmmoCount[2];
var  int     KFXReloadMax[2];

var int DamageTypeValue;
var int AltDamageTypeValue;

//var int     KFXShakeView[2];
//struct KFXPBDamageInfo
//{
//    var int   BitState;
//    var float Timer;
//    var float Param1;
//    var float Param2;
//};
//var KFXPBDamageInfo KFXPBDamageType[2];


///ÎäÆ÷µÄ´©¼×ÏµÊý
var KFXWeapBase.ArmorPctData KFXModeDmgArmorPct[2];

var float  KFXWeaponArmorPct[2];//<ÎäÆ÷»¤¼×ÉËº¦¼õÃâÏµÊý

//ÇÐ»»ÎäÆ÷ËÙ¶È
var float BringUpTime;
var float SelectAnimRate;
var float PutDownAnimRate;

//»»µ¯ËÙ¶Èµ÷Õû
var float KFXPreReloadTime;
var float KFXNormalReloadTime;
var float KFXNullReloadTime;
var float KFXEndReloadTime;

var float  StartReloadAnimRate;
var float  AfterReloadAnimRate;
var float  ReloadNormalAnimRate;
var float  ReloadNullAnimRate;


var float   PunchAngleDecayDamp;
var float   PunchAngleDecaySpring;


//»ðÃ°ÌØ±ðÏà¹Ø±äÁ¿
var class<Emitter> FireFlashClass;


//»ðÃ°»ð»¨µÄÁíÒ»Ì×½â¾ö·½°¸£¨¼æÈÝËÀÍö»Ø·Å£©
var name FireAnim;

//ÏûÑæÆ÷ÏûÒôÆ÷»ðÃ°Ìí¼Ó²¿·ÖÂß¼­
var bool bShowTrack;           //ÊÇ·ñÏÔÊ¾µ¯Ïß
var bool bShowAnotherFireSound;

var sound KFXSndTPFire[NUM_FIRE_MODES];     // ¿ª»ðÉùÒô
var string KFXSndTPFireString[NUM_FIRE_MODES];
// Ç°Á½¸öÊÇ×ó¼ü¿ª»ðÒôÐ§£¬ºóÁ½¸öÊÇÓÒ¼ü¿ª»ðÒôÐ§
var sound KFXSndFPFire[NUM_SND_FPFIRE_WC];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
var string KFXSndFPFireString[NUM_SND_FPFIRE_WC];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
//
var vector  RelLocation;
var rotator RelRottation;
var array<string>  FPWeapSkins;



//Ö§³ÖË«Åä¼þÎäÆ÷
var  Actor  DoubleComponent;
var string DBComponentMesh;
var bool    bIsDoubleComponent;
var vector  AnoLocation;
var rotator AnoRottation;
var float   AnoDrawScale;


replication
{
	// Refactor Version
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority && (bNetDirty || bNetInitial ))
		KFXAmmoCount;

	//reliable if ( Role==ROLE_Authority )
		//KFXClientInit;

	reliable if( Role==ROLE_Authority && bNetInitial )
		FirstPersonWeapon,ComponentTypeID;

	// client to server
	//reliable if ( Role < ROLE_Authority )
}



//szwtodo:ÐèÒªÌí¼ÓÎäÆ÷ÐÞ¸ÄµÄÐÐÎªº¯Êý


//ServerÖÐµÄ³õÊ¼»¯
function KFXServerInit(int ComponentID,KFXWeapBase WeaponBase)
{
	FirstPersonWeapon = WeaponBase;
	ComponentTypeID = ComponentID;

	KFXInit();

	//µ¥»úÄ£Ê½ÏÂÐèÒªäÖÈ¾Êý¾Ý
	if( Level.NetMode == NM_Standalone )
	{
		KFXRenderInit();
	}

}

//Ö»ÓÐ¿Í»§¶ËÖ´ÐÐ
simulated function KFXClientInit()
{
	KFXInit();
	KFXRenderInit();
}
function CSVConfig(array<int> ids)
{
	ComponentTypeID = ids[0];
	csvKFXInit();
}
//Server&Client
simulated function KFXInit()
{
	FirstPersonWeapon.KFXWeapComponent[WeaponPart-1]=self;
	DoubleComponent = spawn(class'DBWeaponComponent');
    DoubleComponent.LinkMesh( mesh(DynamicLoadObject(DBComponentMesh, class'Mesh')));
    log("WeaponComponent------DoubleComponent "$DoubleComponent);
    log("WeaponComponent------DBComponentMesh "$DBComponentMesh);
}
simulated function csvKFXInit()
{
	local KFXCSVTable CFG_WeaponComponent,CFG_Sound;
	local int nTemp;
	local string StateName, TempString;
	local int loop;

	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);

	CFG_WeaponComponent = class'KFXTools'.static.GetConfigTable(22);
	if( !CFG_WeaponComponent.SetCurrentRow(ComponentTypeID) )
	{
		Log("[WeaponComponent] Can't Resolve ComponentID (component Table): "$ComponentTypeID);
		return;
	}

	//--------------------------------
	//szwtodo·þÎñ¶ËºÍ¿Í»§¶Ë¶¼ÒªÌí¼Ó×é¼þ¶ÔÎäÆ÷µÄÊôÐÔÐÞ¸ÄÖµ
	//----------------------------------

	WeaponTypeID = CFG_WeaponComponent.GetInt("GunID");
	WeaponPart = CFG_WeaponComponent.GetInt("Part");

	FireModeValue[0] =  CFG_WeaponComponent.GetInt("FireMode1");
	FireModeValue[1] =  CFG_WeaponComponent.GetInt("FireMode2");

	KFXFireFlyFactor[0] = CFG_WeaponComponent.GetInt("FlyFactor1");
	KFXFireFlyFactor[1] = CFG_WeaponComponent.GetInt("FlyFactor2");

	// Load Spread config
	KFXSpreadType[0] = CFG_WeaponComponent.GetInt("SP1Type");
	KFXSpreadType[1] = CFG_WeaponComponent.GetInt("SP2Type");

	// Load Accuracy config
	KFXAccuracyDivision[0]  = CFG_WeaponComponent.GetFloat("AccDiv1");
	KFXAccuracyDivision[1]  = CFG_WeaponComponent.GetFloat("AccDiv2");
	KFXAccuracyOffset[0]    = CFG_WeaponComponent.GetFloat("AccOff1");
	KFXAccuracyOffset[1]    = CFG_WeaponComponent.GetFloat("AccOff2");
	KFXMaxInaccuracy[0] = CFG_WeaponComponent.GetInt("MaxInacc1");
	KFXMaxInaccuracy[1] = CFG_WeaponComponent.GetInt("MaxInacc2");


	for ( loop = 0; loop < KFX_PAWN_STATE_NUM; loop++ )
	{
		StateName = KFXGetPawnStateString(loop);

		// Kickback Params
		TempString = "KB1_"$StateName;
		KFXParam_KB1[loop].up_base          = CFG_WeaponComponent.GetFloat(TempString$"1");
		KFXParam_KB1[loop].lateral_base     = CFG_WeaponComponent.GetFloat(TempString$"2");
		KFXParam_KB1[loop].up_modifier      = CFG_WeaponComponent.GetFloat(TempString$"3");
		KFXParam_KB1[loop].lateral_modifier = CFG_WeaponComponent.GetFloat(TempString$"4");
		KFXParam_KB1[loop].up_max           = CFG_WeaponComponent.GetFloat(TempString$"5");
		KFXParam_KB1[loop].lateral_max      = CFG_WeaponComponent.GetFloat(TempString$"6");
		KFXParam_KB1[loop].direction_change = CFG_WeaponComponent.GetInt(TempString$"7");

		TempString = "KB2_"$StateName;
		KFXParam_KB2[loop].up_base          = CFG_WeaponComponent.GetFloat(TempString$"1");
		KFXParam_KB2[loop].lateral_base     = CFG_WeaponComponent.GetFloat(TempString$"2");
		KFXParam_KB2[loop].up_modifier      = CFG_WeaponComponent.GetFloat(TempString$"3");
		KFXParam_KB2[loop].lateral_modifier = CFG_WeaponComponent.GetFloat(TempString$"4");
		KFXParam_KB2[loop].up_max           = CFG_WeaponComponent.GetFloat(TempString$"5");
		KFXParam_KB2[loop].lateral_max      = CFG_WeaponComponent.GetFloat(TempString$"6");
		KFXParam_KB2[loop].direction_change = CFG_WeaponComponent.GetInt(TempString$"7");

		// Spread Params
		TempString = "SP1_"$StateName;
		KFXParam_SP1[loop].Param1   =   CFG_WeaponComponent.GetFloat(TempString$"1");
		KFXParam_SP1[loop].Param2   =   CFG_WeaponComponent.GetFloat(TempString$"2");

		TempString = "SP2_"$StateName;
		KFXParam_SP2[loop].Param1   =   CFG_WeaponComponent.GetFloat(TempString$"1");
		KFXParam_SP2[loop].Param2   =   CFG_WeaponComponent.GetFloat(TempString$"2");
	}

	KFXCornerStaticShotsCount[0] = CFG_WeaponComponent.GetInt("CornerStaticShots1");
	KFXCornerStaticShotsCount[1] = CFG_WeaponComponent.GetInt("CornerStaticShots2");




	KFXFPHandID = CFG_WeaponComponent.GetInt("FPHand");

	KFXAccessory[0] = CFG_WeaponComponent.GetInt("Accessory0");

	KFXReloadTime = CFG_WeaponComponent.GetInt("ReloadTime");

	KFXSpeedFactor[0] = CFG_WeaponComponent.GetInt("SpeedFactor1");
	KFXSpeedFactor[1] = CFG_WeaponComponent.GetInt("SpeedFactor2");

	KFXModeRate[0] = CFG_WeaponComponent.GetInt("FireRate1");
	KFXModeRate[1] = CFG_WeaponComponent.GetInt("FireRate2");

	KFXModeDamage[0] = CFG_WeaponComponent.GetInt("Damage1");
	KFXModeDamage[1] = CFG_WeaponComponent.GetInt("Damage2");

	KFXModeRange[0] = CFG_WeaponComponent.GetInt("Range1");
	KFXModeRange[1] = CFG_WeaponComponent.GetInt("Range2");

	KFXMode0ValidRange[0] = CFG_WeaponComponent.GetInt("Range1Seg1");
	KFXMode0ValidRange[1] = CFG_WeaponComponent.GetInt("Range1Seg2");
	KFXMode0ValidRange[2] = CFG_WeaponComponent.GetInt("Range1Seg3");
	KFXMode0ValidRange[3] = CFG_WeaponComponent.GetInt("Range1Seg4");

	KFXMode1ValidRange[0] = CFG_WeaponComponent.GetInt("Range2Seg1");
	KFXMode1ValidRange[1] = CFG_WeaponComponent.GetInt("Range2Seg2");
	KFXMode1ValidRange[2] = CFG_WeaponComponent.GetInt("Range2Seg3");
	KFXMode1ValidRange[3] = CFG_WeaponComponent.GetInt("Range2Seg4");

	KFXMode0ValidDmgFactor[0] = CFG_WeaponComponent.GetInt("Range1DmgFactor1");
	KFXMode0ValidDmgFactor[1] = CFG_WeaponComponent.GetInt("Range1DmgFactor2");
	KFXMode0ValidDmgFactor[2] = CFG_WeaponComponent.GetInt("Range1DmgFactor3");
	KFXMode0ValidDmgFactor[3] = CFG_WeaponComponent.GetInt("Range1DmgFactor4");

	KFXMode1ValidDmgFactor[0] = CFG_WeaponComponent.GetInt("Range2DmgFactor1");
	KFXMode1ValidDmgFactor[1] = CFG_WeaponComponent.GetInt("Range2DmgFactor2");
	KFXMode1ValidDmgFactor[2] = CFG_WeaponComponent.GetInt("Range2DmgFactor3");
	KFXMode1ValidDmgFactor[3] = CFG_WeaponComponent.GetInt("Range2DmgFactor4");

	KFXAmmoCount[0] = CFG_WeaponComponent.GetInt("Ammo1");
	KFXAmmoCount[1] = CFG_WeaponComponent.GetInt("Ammo2");

	KFXReloadMax[0] = CFG_WeaponComponent.GetInt("ReloadMax1");
	KFXReloadMax[1] = CFG_WeaponComponent.GetInt("ReloadMax2");

	DamageTypeValue = CFG_WeaponComponent.GetInt("DmgType1");
	AltDamageTypeValue = CFG_WeaponComponent.GetInt("DmgType2");

	KFXModeDmgArmorPct[0].ArmorPct[0] =  CFG_WeaponComponent.GetFloat("Armor1Level1Pct1");
	KFXModeDmgArmorPct[1].ArmorPct[0] =  CFG_WeaponComponent.GetFloat("Armor2Level1Pct1");
	KFXModeDmgArmorPct[0].ArmorPct[1] =  CFG_WeaponComponent.GetFloat("Armor1Level1Pct2");
	KFXModeDmgArmorPct[1].ArmorPct[1] =  CFG_WeaponComponent.GetFloat("Armor2Level1Pct2");


	KFXWeaponArmorPct[0] =  CFG_WeaponComponent.GetFloat("Armor1Level1ReducePct");
	KFXWeaponArmorPct[1] =  CFG_WeaponComponent.GetFloat("Armor2Level1ReducePct");

	BringUpTime = CFG_WeaponComponent.GetFloat("TimeBringUp");

	//»»µ¯ËÙ¶Èµ÷Õû
	KFXPreReloadTime    = CFG_WeaponComponent.GetFloat("PreReloadTime");
	KFXNormalReloadTime = CFG_WeaponComponent.GetFloat("NormalReloadTime");
	KFXNullReloadTime   = CFG_WeaponComponent.GetFloat("NullReloadTime");
	KFXEndReloadTime    = CFG_WeaponComponent.GetFloat("EndReloadTime");









	PunchAngleDecayDamp = CFG_WeaponComponent.GetFloat("PunchDecayDamp1");
	PunchAngleDecaySpring = CFG_WeaponComponent.GetFloat("PunchDecayDamp2");

	bShowTrack = CFG_WeaponComponent.GetBool("ShowTrack");
	bShowAnotherFireSound  = CFG_WeaponComponent.GetBool("ShowAnotherFireSound");
	if(bShowAnotherFireSound)
	{
		//Third Person Fire sound
		nTemp = CFG_WeaponComponent.GetInt( "SndTPFire1" );
		log("WeaponComponent-----11--nTemp "$nTemp);
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			log("WeaponComponent-----11--"$CFG_Sound.GetString("ResName"));
			KFXSndTPFireString[0] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndTPFire2" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndTPFireString[1] =CFG_Sound.GetString("ResName");
		}
		//First Person Fire Sound
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire11" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[0] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire12" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[2] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire21" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[1] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire22" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[3] = CFG_Sound.GetString("ResName");
		}
		log("WeaponComponent---------KFXSndTPFireString[0] "$KFXSndTPFireString[0]
		$"KFXSndTPFireString[1] :"$KFXSndTPFireString[1]
		$"KFXSndFPFireString[0] :"$KFXSndFPFireString[0]
		$"KFXSndFPFireString[2] :"$KFXSndFPFireString[2]
		$"KFXSndFPFireString[1] :"$KFXSndFPFireString[1]
		$"KFXSndFPFireString[3] :"$KFXSndFPFireString[3]);
	}
	log("WeaponComponent---------bShowTrack "$bShowTrack);
	csvKFXRenderInit();
}


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

simulated function KFXRenderInit()
{
	local KFXCSVTable CFG_WeaponComponent;
	local bool result;
	local int loop;
	local string temstr;
	if(bIsDoubleComponent)
	{
	    KFXRenderDBWeaponInit();
    }
    switch(WeaponPart)
	{
	case 1:
		result = FirstPersonWeapon.AttachToBone(self,'BONE_FIRERISK');
		break;
	case 2:
		result = FirstPersonWeapon.AttachToBone(self,'BONE_INFRARED');
		break;
	case 3:
		result = FirstPersonWeapon.AttachToBone(self,'BONE_AGOGRIP');
		break;
	case 4:
		result = FirstPersonWeapon.AttachToBone(self,'BONE_SIGHT');
		break;
	case 5:
		result = FirstPersonWeapon.AttachToBone(self,'BONE_CARTRIDGES');
		break;
	case 6:
		for(loop=1; loop<FPWeapSkins.Length; loop++)
		{
			//loop+1ÊÇÒòÎª0Î»ÖÃ±»ÊÖ±ÛÌùÍ¼Õ¼¾ÝÁË
			FirstPersonWeapon.Skins[loop]=Material(DynamicLoadObject(FPWeapSkins[loop],class'Material',false));
		}
		result = true;
		break;
	}
	if(result == false)
	{
		log("FirstPerson WeaponComponent AttachtoBone fail weaponid"@ComponentTypeID@"ComponentID"@ComponentTypeID);
	}



	SetRelativeLocation(RelLocation);
	SetRelativeRotation(RelRottation);
	SetDrawScale(DrawScale);
}
simulated function KFXRenderDBWeaponInit()
{
	local KFXCSVTable CFG_WeaponComponent;
	local bool result;
	local int loop;
	local string temstr;
	log("WeaponComponent-------WeaponPart "$WeaponPart);
    switch(WeaponPart)
	{
	case 1:
		result = FirstPersonWeapon.AttachToBone(DoubleComponent,'BONE_FIRERISK01');
        break;
	case 2:
		result = FirstPersonWeapon.AttachToBone(DoubleComponent,'BONE_INFRARED01');
		break;
	case 3:
		result = FirstPersonWeapon.AttachToBone(DoubleComponent,'BONE_AGOGRIP01');
		break;
	case 4:
		result = FirstPersonWeapon.AttachToBone(DoubleComponent,'BONE_SIGHT01');
		break;
	case 5:
		result = FirstPersonWeapon.AttachToBone(DoubleComponent,'BONE_CARTRIDGES01');
		break;
//	case 6:
//		for(loop=1; loop<FPWeapSkins.Length; loop++)
//		{
//			//loop+1ÊÇÒòÎª0Î»ÖÃ±»ÊÖ±ÛÌùÍ¼Õ¼¾ÝÁË
//			FirstPersonWeapon.Skins[loop]=Material(DynamicLoadObject(FPWeapSkins[loop],class'Material',false));
//		}
//		result = true;
//		break;
	}
	if(result == false)
	{
		log("FirstPerson WeaponComponent AttachtoBone fail weaponid"@ComponentTypeID@"ComponentID"@ComponentTypeID);
	}



	DoubleComponent.SetRelativeLocation(RelLocation);
	DoubleComponent.SetRelativeRotation(RelRottation);
	DoubleComponent.SetDrawScale(DrawScale);
}
simulated function csvKFXRenderInit()
{
	local KFXCSVTable CFG_WeaponComponent;
	local bool result;
	local string temstr;
	local int loop;
	if( ComponentTypeID == 0 )
	{
		return;
	}

	CFG_WeaponComponent = class'KFXTools'.static.GetConfigTable(22);
	if( !CFG_WeaponComponent.SetCurrentRow(ComponentTypeID) )
	{
		Log("[WeaponComponent] Can't Resolve ComponentID (component Table): "$ComponentTypeID);
		return;
	}
	bIsDoubleComponent = CFG_WeaponComponent.GetBool("bIsDoubleComponent");
	if ( WeaponPart != 6 )
	{
	    LinkMesh( mesh(DynamicLoadObject(CFG_WeaponComponent.GetString("FPViewMesh"), class'Mesh')));
	    log("WeaponComponent-------bIsDoubleComponent: "$bIsDoubleComponent);


        if(bIsDoubleComponent)
	    {
            DBComponentMesh = CFG_WeaponComponent.GetString("FPViewMesh");
            log("WeaponComponent-------DBComponentMesh: "$DBComponentMesh);
        }
    }
	log("WeaponComponent-------WeaponPart: "$WeaponPart);
	log("WeaponComponent-------ComponentTypeID: "$ComponentTypeID);


	StartReloadAnimRate = CFG_WeaponComponent.GetFloat("PreReloadAniRate");
	ReloadNormalAnimRate = CFG_WeaponComponent.GetFloat("ReloadNormalAniRate");
	ReloadNullAnimRate = CFG_WeaponComponent.GetFloat("ReloadNullAniRate");
	AfterReloadAnimRate = CFG_WeaponComponent.GetFloat("EndReloadAniRate");

	SelectAnimRate = CFG_WeaponComponent.GetFloat("SelectAniRate");
	PutDownAnimRate = CFG_WeaponComponent.GetFloat("PutDownAniRate");

	switch(WeaponPart)
	{
	case 1:
		temstr = CFG_WeaponComponent.GetString("FPEffect");
		log("WeaponComponent-------temstr: "$temstr);
		if(temstr != "null" && temstr != "")
		{
			FireFlashClass = class<Emitter>(DynamicLoadObject(temstr,class'Class'));
		}
		log("WeaponComponent-------FireFlashClass: "$FireFlashClass);
		FireAnim = CFG_WeaponComponent.GetName("FireAnim");

		csvKFXAttachInit();
		result = true;
		break;
	case 2:
		csvKFXAttachInit();
		result = true;
		break;
	case 3:
		csvKFXAttachInit();
		result = true;
		break;
	case 4:
		csvKFXAttachInit();
		result = true;
		break;
	case 5:
		csvKFXAttachInit();
		result = true;
		break;
	case 6:
		for(loop=0; true; loop++)
		{
			temstr = CFG_WeaponComponent.GetString("FPViewSkin"$loop);
			if(temstr=="")
			{
				break;
			}
			else if(temstr == "null")
			{
				continue;
			}
			else
			{
				//loop+1ÊÇÒòÎª0Î»ÖÃ±»ÊÖ±ÛÌùÍ¼Õ¼¾ÝÁË
				if ( FPWeapSkins.Length == 0 )
				FPWeapSkins.Length = FPWeapSkins.Length+2;
				else
				FPWeapSkins.Length = FPWeapSkins.Length+1;

				FPWeapSkins[loop+1]=temstr;
			}
		}
		result = true;
		break;
	}
	if(WeaponPart!=6)
	{
		//Èç¹ûÅäÖÃÁËÌùÍ¼£¬ÄÇÃ´¾Í²»Ê¹ÓÃÄ¬ÈÏÌùÍ¼
		for(loop=0; true; loop++)
		{
			temstr = CFG_WeaponComponent.GetString("FPViewSkin"$loop);
			if(temstr=="")
			{
				break;
			}
			else if(temstr == "null")
			{
				continue;
			}
			else
			{
				//ÎäÆ÷¹Ò¼þÌùÍ¼ÓëÊÖ±ÛÌùÍ¼ÎÞ¹Ø£¬²»ÐèÒª+1
				Skins[loop]=Material(DynamicLoadObject(temstr,class'Material',false));
			}
		}
	}
	if(result == false)
	{
		log("FirstPerson WeaponComponent AttachtoBone fail weaponid"@ComponentTypeID@"ComponentID"@ComponentTypeID);
	}

}
simulated function csvKFXAttachInit()
{

	local KFXCSVTable CFG_WeaponComponent;

	CFG_WeaponComponent = class'KFXTools'.static.GetConfigTable(22);
	if( !CFG_WeaponComponent.SetCurrentRow(ComponentTypeID) )
	{
		Log("[WeaponComponent] Can't Resolve ComponentID (component Table): "$ComponentTypeID);
		return;
	}

	RelLocation.X = CFG_WeaponComponent.GetFloat("FPLocationX");
	RelLocation.Y = CFG_WeaponComponent.GetFloat("FPLocationY");
	RelLocation.Z = CFG_WeaponComponent.GetFloat("FPLocationZ");

	RelRottation.Roll = CFG_WeaponComponent.GetInt("FPRotRoll");
	RelRottation.Yaw = CFG_WeaponComponent.GetInt("FPRotYaw");
	RelRottation.Pitch = CFG_WeaponComponent.GetInt("FPRotPitch");
	DrawScale = CFG_WeaponComponent.GetFloat("FPScale");

    bIsDoubleComponent = CFG_WeaponComponent.GetBool("bIsDoubleComponent");
	log("WeaponAttachment-------bIsDoubleComponent "$bIsDoubleComponent);

    if(bIsDoubleComponent)
    {
    	AnoLocation.X = CFG_WeaponComponent.GetFloat("AnotherFPLocationX");
    	AnoLocation.Y = CFG_WeaponComponent.GetFloat("AnotherFPLocationY");
    	AnoLocation.Z = CFG_WeaponComponent.GetFloat("AnotherFPLocationZ");

    	AnoRottation.Roll = CFG_WeaponComponent.GetInt("AnotherFPRotRoll");
    	AnoRottation.Yaw = CFG_WeaponComponent.GetInt("AnotherFPRotYaw");
    	AnoRottation.Pitch = CFG_WeaponComponent.GetInt("AnotherFPRotPitch");
    	AnoDrawScale = CFG_WeaponComponent.GetFloat("AnotherFPScale");

        log("WeaponAttachment------AnoLocation "$AnoLocation);
        log("WeaponAttachment------AnoRottation "$AnoRottation);
        log("WeaponAttachment------AnoDrawScale "$AnoDrawScale);

    }
}

simulated function Tick(float DeltaTime)
{
	if(Level.NetMode != NM_DedicatedServer)
	{
		if(!bInitToWeapon && FirstPersonWeapon!=none && ComponentTypeID != 0 )
		{
			KFXClientInit();
			bInitToWeapon = true;
		}
	}
}

defaultproperties
{
     DrawType=DT_Mesh
     bHidden=否
     bOnlyDrawIfAttached=是
     bCanRecord=否
}
