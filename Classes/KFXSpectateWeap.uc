//Ä£ÄâÎäÆ÷ºÍFireMode·Ö±ðÖ»ÓÐÒ»¸öÀà£¬ÓÉÓÚÖ»Ä£Äâ¶¯»­ºÍÒ»Ð©Ïà¹ØÄÚÈÝ£¬¶ÔÓÚ²»ÈÝÀàÐÍµÄÎäÆ÷ºÍ¿ª»ðÄ£Ê½£¬
//Ö»´æÔÚ¶¯»­Ãû³Æ¡¢Ä£Ê½×ª»»µÈµÈ²î±ð£¬ÕâÐ©²î±ðÊ¹ÓÃÒ»Ð©¼¼ÇÉ·â×°ÆðÀ´£¬Ê¹µÃ¶ÔÍâÓÐÍ³Ò»µÄ½Ó¿Ú£¬±íÏÖ³ö²»Í¬µÄÂß¼­
//
//1£ºÓÒ¼üÏà¹ØµÄ¶¯»­Ãû±äÁ¿Í³Ò»Ê¹ÓÃAltÇ°×ºÃüÃû£¬·ÅÆúDeployµÈÃû³Æ£¬ÕâÓÐÀûÓÚÌáÈ¡¸÷ÖÖÓÒ¼üÄ£Ê½ÖÐÏàÍ¬µÄ²¿·Ö£¬
//     ½øÐÐÍ³Ò»´¦Àí£¬¶Ô²»Í¬µÄ²¿·Ö²îÒì»¯¹ÜÀí£¬²¢·â×°Í³Ò»½Ó¿Ú
//2£ºÕâÖÖ·½·¨ÒÀÀµWeaponAttribute±íÖÐµÄFireMode1ºÍFireMode2ÁÐ£¬ÒÔ¼°WeaponFireMode±í£¬ÐèÒªÔÚFireMode±íµÄÐòºÅ±ä¶¯»òÔö¼ÓÊ±£¬
//  ¶ÔÔ´´úÂëÊÊµ±ÐÞ²¹
//3£º
//
//
class KFXSpectateWeap extends SpectateWeap;

const NUM_FIRE_MODES = 2;
const NUM_SND_FPFIRE_SW = 4;

var int KFXWeaponID;
var KFXSpectateComponent Component[6];           //ÎäÆ÷×é¼þ£¬×î¶àÁù¸öÎ»ÖÃ

var int KFXFPHandID;                                // µÚÒ»ÈË³ÆÊÖ±ÛID

var bool AltFirePlayOld; //¿Í»§¶Ë¼ÇÂ¼ÉÏÒ»´Î·þÎñÆ÷Í¬²½¹ýÀ´µÄÓÒ¼üÄ£Ê½µ÷ÓÃÖµ
var byte WeaponStateValue; //·þÎñÆ÷Í¬²½µ½¿Í»§¶Ë£¬ÎäÆ÷µ±Ç°´¦ÓÚµÄ×´Ì¬Öµ
						//£¨Èç¼ÜÇ¹¡¾0£¬1¡¿¡¢¿ª¾µ¡¾0£¬1£¬2¡¿¡¢ÈýÁ¬·¢¡¾0£¬1¡¿£©
						//´ËÖµ´óÐ¡ºÍ´ËÖµ¶ÔÓ¦µÄÒâÒå£¬ÒòÎäÆ÷µÄ²»Í¬¶ø²»Í¬

var bool bEnterState; //ÕýÔÚ½øÈë×´Ì¬£¨¶ÔÓÚÓÐ×´Ì¬½øÈëÊ±¼äµÄÎäÆ÷ºÍ¿ª»ðÄ£Ê½£©
var bool bQuitState; //ÕýÔÚÍË³ö×´Ì¬
var float EQBeginTime; //½øÈë»òÍË³ö×´Ì¬µÄ¿ªÊ¼Ê±¼ä

var float KFXZoomLevelMax; //Ò»±¶¾µµÄËõ·Å¼¶±ð
var float KFXZoomLevelMin; //¶þ±¶¾µµÄËõ·Å¼¶±ð

var float  KFXUserData;  //ÒâÒåÈ¡¾öÓÚÎäÆ÷£¨Èç¼ÜÇ¹¸ß¶È£©

var float BobTime;
var float AppliedBob;
var vector WalkBob;


var private sound KFXSndTPFire[NUM_FIRE_MODES];     // ¿ª»ðÉùÒô
// Ç°Á½¸öÊÇ×ó¼ü¿ª»ðÒôÐ§£¬ºóÁ½¸öÊÇÓÒ¼ü¿ª»ðÒôÐ§
var private sound KFXSndFPFire[NUM_SND_FPFIRE_SW];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
var private sound KFXSndReload;                   // »»µ¯ÉùÒô
var private sound KFXSndNoammo;                   // ¿ÕÉä»÷ÉùÒô

// animation //  µ±Ç°
var name IdleAnim;
var name RestAnim;
var name AimAnim;
var name RunAnim;
var name SelectAnim;
var name PutDownAnim;

var float IdleAnimRate;
var float RestAnimRate;
var float AimAnimRate;
var float RunAnimRate;
var float SelectAnimRate;
var float PutDownAnimRate;

// anims
var name   StartReloadAnim;
var name   AfterReloadAnim;
var name   ReloadNormalAnim;
var name   ReloadNullAnim;

var float  StartReloadAnimRate;
var float  AfterReloadAnimRate;
var float  ReloadNormalAnimRate;
var float  ReloadNullAnimRate;

var name AltIdleAnim;
var name AltReloadAnim;
var float AltIdleAnimRate;
var float AltReloadAnimRate;


// animation // Ô­Ê¼
var name IdleAnimOrg;
var name RestAnimOrg;
var name AimAnimOrg;
var name RunAnimOrg;
var name SelectAnimOrg;
var name PutDownAnimOrg;

// anims
var name StartReloadAnimOrg;
var name AfterReloadAnimOrg;
var name ReloadNormalAnimOrg;
var name ReloadNullAnimOrg;

var name AltIdleAnimOrg;
var name AltReloadAnimOrg;

// animation // ÎÕ°Ñ
var name IdleAnim_G;
var name RestAnim_G;
var name AimAnim_G;
var name RunAnim_G;
var name SelectAnim_G;
var name PutDownAnim_G;

// anims
var name StartReloadAnim_G;
var name AfterReloadAnim_G;
var name ReloadNormalAnim_G;
var name ReloadNullAnim_G;

var name AltIdleAnim_G;
var name AltReloadAnim_G;

var float       KFXDefDisplayFov[2];
var vector      KFXPlayerViewOffset[2];
var rotator     KFXPlayerViewPivot[2];

// View Offset: for Change Hand Backup
var vector  KFXInitPlayerViewOffset;
var rotator KFXInitPlayerViewPivot;

var float Hand;
var float RenderedHand;

var KFXPlayer Viewer;
var KFXSpectateFire FireMode;
var KFXSpectateHook SpectateHook;           // Í¬²½ÐÅÏ¢²¿·Ö


//ÏûÑæÆ÷ÏûÒôÆ÷»ðÃ°Ìí¼Ó²¿·ÖÂß¼­
var bool bShowTrack;           //ÊÇ·ñÏÔÊ¾µ¯Ïß
var bool bShowAnotherFireSound;
var sound KFXSndTPSmallFire[NUM_FIRE_MODES];     // ¿ª»ðÉùÒô

// Ç°Á½¸öÊÇ×ó¼ü¿ª»ðÒôÐ§£¬ºóÁ½¸öÊÇÓÒ¼ü¿ª»ðÒôÐ§
var sound KFXSndFPSmallFire[NUM_SND_FPFIRE_SW];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§

var float showskinTime;


//Ë«Åä¼þÎäÆ÷Ö§³Ö¹Û²ìÕß
var bool  bIsDoubleComponent;
simulated function KFXInit(int WeaponID)
{
	local KFXCSVTable CFG_Weapon;

	Viewer = KFXPlayer(level.GetLocalPlayerController());

	KFXWeaponID = WeaponID;

	CFG_Weapon = class'KFXTools'.static.GetConfigTable(11);
	if ( !CFG_Weapon.SetCurrentRow(KFXWeaponID) )
	{
		Log("[SpectateWeap] Can't Resolve The Weapon ID (Attr Table): "$KFXWeaponID);
		return;
	}
	KFXFPHandID = CFG_Weapon.GetInt("FPHand");
    bIsDoubleComponent = CFG_Weapon.GetBool("bIsDoubleComponent");

    log("SpectateWeap-------bIsDoubleComponent "$bIsDoubleComponent);
	// ²úÉúFireModeÊµÀý,²¢Íê³É³õÊ¼»¯
	FireMode = spawn(class<KFXSpectateFire>(
		DynamicLoadObject("KFXGame.KFXSpectateFire",
		class'Class'))
		);
	if (FireMode != None)
	{
		FireMode.Viewer = Viewer;
		FireMode.Weapon = self;
		FireMode.KFXInit(KFXWeaponID);
	}

	KFXSetupSoundData();
	KFXSetupRenderData();
}

simulated function SetRelation()
{
	Instigator = SpectateHook.ViewTarget;
	SetOwner(Instigator);
	FireMode.Instigator = Instigator;
}

simulated function Destroyed()
{
	if(FireMode != none)
	{
		FireMode.Destroy();
	}
}

simulated function KFXSetupOrgData()
{


}

// ³õÊ¼»¯ÉùÒô×ÊÔ´(Client & Server)
simulated function KFXSetupSoundData()
{
	local KFXCSVTable CFG_Media, CFG_Sound;
	local int nTemp;

	;

	// ¼ÓÔØÅäÖÃÎÄ¼þ
	CFG_Media      = class'KFXTools'.static.GetConfigTable(10);
	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);

	if ( !CFG_Media.SetCurrentRow(KFXWeaponID) )
	{
		Log("[SpectateWeap] Can't Resolve The Weapon ID (Media Table): "$KFXWeaponID);
		return;
	}

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

	nTemp = CFG_Media.GetInt( "SndFPFire12" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[1] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	nTemp = CFG_Media.GetInt( "SndFPFire21" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[2] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	nTemp = CFG_Media.GetInt( "SndFPFire22" );
	if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
	{
		KFXSndFPFire[3] =
			Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

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

simulated function ExchangeWeaponAxisType( int Type )
{
	// View Params
	DisplayFOV              = KFXDefDisplayFov[Type];
	PlayerViewOffset        = KFXPlayerViewOffset[Type];
	PlayerViewPivot         = KFXPlayerViewPivot[Type];

	KFXInitPlayerViewOffset = PlayerViewOffset;
	KFXInitPlayerViewPivot  = PlayerViewPivot;
	log("[KFXSpectateWeap]ExchangeWeaponAxisType PlayerViewOffset:"$PlayerViewOffset$"PlayerViewPivot:"$PlayerViewPivot);

}


// ³õÊ¼»¯ÎäÆ÷µÚÒ»ÈË³Æ±íÏÖÂß¼­
simulated function KFXSetupRenderData()
{
	local KFXCSVTable CFG_Media, CFG_Accessory;
	local string MeshName, MaterialName, SkelName;
	local name nTemp;
	local bool bManuFixed;
	local int  loop;
	local string TexString;
	local Material mat;

	local int  axisType;
	local KFXPlayer Player;
	Player = KFXPlayer(Level.GetLocalPlayerController());

	;

	// ¼ÓÔØÅäÖÃÎÄ¼þ
	CFG_Media      = class'KFXTools'.static.GetConfigTable(10);
	CFG_Accessory  = class'KFXTools'.static.GetConfigTable(13);

	if ( !CFG_Media.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Media Table): "$KFXWeaponID);
		return;
	}

	// ¼ÓÔØÏÔÊ¾ÅäÖÃ²ÎÊý

	// View Params
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
	axisType = Player.DrawWeaponAXIS;

	ExchangeWeaponAxisType(axisType);

	// TODO: ÆäËûÅäÖÃ²ÎÊý

	// ¼ÓÔØÊÖ±ÛÄ£ÐÍ,²ÄÖÊ
	if ( !CFG_Accessory.SetCurrentRow(KFXFPHandID) )
	{
		Log("[Kevin] Can't Resolve the FP Main Accessory (Hand) ID:"$KFXFPHandID );
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

	IdleAnimOrg             =    IdleAnim;
	RestAnimOrg             =    RestAnim;
	AimAnimOrg              =    AimAnim;
	RunAnimOrg              =    RunAnim;
	SelectAnimOrg           =    SelectAnim;
	PutDownAnimOrg          =    PutDownAnim;
	StartReloadAnimOrg      =    StartReloadAnim;
	AfterReloadAnimOrg      =    AfterReloadAnim;
	ReloadNormalAnimOrg     =    ReloadNormalAnim;
	ReloadNullAnimOrg       =    ReloadNullAnim;

	if(IdleAnim!='') IdleAnim_G = class'DataTable'.static.StringToName(IdleAnim$"_G");
	if(RestAnim!='') RestAnim_G = class'DataTable'.static.StringToName(RestAnim$"_G");
	if(AimAnim!='')  AimAnim_G = class'DataTable'.static.StringToName(AimAnim$"_G");
	if(RunAnim!='')   RunAnim_G = class'DataTable'.static.StringToName(RunAnim$"_G");
	if(SelectAnim!='') SelectAnim_G = class'DataTable'.static.StringToName(SelectAnim$"_G");
	if(PutDownAnim!='') PutDownAnim_G = class'DataTable'.static.StringToName(PutDownAnim$"_G");
	if(StartReloadAnim!='') StartReloadAnim_G = class'DataTable'.static.StringToName(StartReloadAnim$"_G");
	if(ReloadNormalAnim!='') ReloadNormalAnim_G = class'DataTable'.static.StringToName(ReloadNormalAnim$"_G");
	if(ReloadNullAnim!='') ReloadNullAnim_G = class'DataTable'.static.StringToName(ReloadNullAnim$"_G");
	if(AfterReloadAnim!='') AfterReloadAnim_G = class'DataTable'.static.StringToName(AfterReloadAnim$"_G");

	PlayIdle();
}

simulated function SetWeapComponent( KFXSpectateComponent NewComponent,int part)
{
	local int loop;
	switch(part)
	{
	case 1:
		if( Component[part-1] != NewComponent )
		{
			if(Component[part-1]!=none)
			{
				DetachFromBone(Component[part-1]);
				if(bIsDoubleComponent)
				{
                    DetachFromBone(Component[part-1].DBComponent);
                }
				log("SetWeapComponent1 dettach"@Component[part-1]);
			}
			if(NewComponent != none)
			{
				AttachToBone(NewComponent,'BONE_FIRERISK');
				if(bIsDoubleComponent)
				{
				     AttachToBone(NewComponent.DBComponent,'BONE_FIRERISK01');
				     log("SetDBComponent1 attach"@NewComponent.DBComponent);
                }
				log("SetWeapComponent1 attach"@NewComponent);
			}
			Component[part-1] = NewComponent;
		}
		break;

	case 2:
		if( Component[part-1] != NewComponent )
		{
			if(Component[part-1]!=none)
			{
				DetachFromBone(Component[part-1]);
				if(bIsDoubleComponent)
				{
                    DetachFromBone(Component[part-1].DBComponent);
                }

				log("SetWeapComponent2 dettach"@Component[part-1]);
			}
			if(NewComponent != none)
			{
				AttachToBone(NewComponent,'BONE_INFRARED');
				if(bIsDoubleComponent)
				{
				     AttachToBone(NewComponent.DBComponent,'BONE_INFRARED01');
				     log("SetDBComponent1 attach"@NewComponent.DBComponent);
                }

				log("SetWeapComponent2 attach"@NewComponent);
			}
			Component[part-1] = NewComponent;
		}
		break;
	case 3:
		if( Component[part-1] != NewComponent )
		{
			if(Component[part-1]!=none)
			{
				DetachFromBone(Component[part-1]);
				if(bIsDoubleComponent)
				{
                    DetachFromBone(Component[part-1].DBComponent);
                }
                log("SetWeapComponent3 dettach"@Component[part-1]);

				//ÔÚÐ¶ÔØ¹Ò¼þµÄÊ±ºò»Ö¸´Ö®Ç°µÄ¶¯»­Ãû
				IdleAnim = IdleAnimOrg;
				RestAnim = RestAnimOrg;
				AimAnim = AimAnimOrg;
				RunAnim = RunAnimOrg;
				SelectAnim = SelectAnimOrg;
				PutDownAnim = PutDownAnimOrg;
				StartReloadAnim = StartReloadAnimOrg;
				ReloadNormalAnim = ReloadNormalAnimOrg;
				ReloadNullAnim = ReloadNullAnimOrg;
				AfterReloadAnim = AfterReloadAnimOrg;

				FireMode.PreFireAnim = FireMode.PreFireAnimOrg;
				FireMode.FireAnim = FireMode.FireAnimOrg ;
				FireMode.FireLoopAnim = FireMode.FireLoopAnimOrg;
				FireMode.FireEndAnim = FireMode.FireEndAnimOrg;
				FireMode.EmptyFireAnim = FireMode.EmptyFireAnimOrg;

			}
			if(NewComponent != none)
			{
				AttachToBone(NewComponent,'BONE_AGOGRIP');
				log("SetWeapComponent3 attach"@NewComponent);
				if(bIsDoubleComponent)
				{
				     AttachToBone(NewComponent.DBComponent,'BONE_INFRARED01');
				     log("SetDBComponent1 attach"@NewComponent.DBComponent);
                }


				IdleAnim = IdleAnim_G;
				RestAnim = RestAnim_G;
				AimAnim = AimAnim_G;
				RunAnim = RunAnim_G;
				SelectAnim = SelectAnim_G;
				PutDownAnim = PutDownAnim_G;
				StartReloadAnim = StartReloadAnim_G;
				ReloadNormalAnim = ReloadNormalAnim_G;
				ReloadNullAnim = ReloadNullAnim_G;
				AfterReloadAnim = AfterReloadAnim_G;

				FireMode.PreFireAnim = FireMode.PreFireAnim_G;
				FireMode.FireAnim = FireMode.FireAnim_G ;
				FireMode.FireLoopAnim = FireMode.FireLoopAnim_G;
				FireMode.FireEndAnim = FireMode.FireEndAnim_G;
				FireMode.EmptyFireAnim = FireMode.EmptyFireAnim_G;

			}
			Component[part-1] = NewComponent;
		}
		break;
	case 4:
		if( Component[part-1] != NewComponent )
		{
			if(Component[part-1]!=none)
			{
				DetachFromBone(Component[part-1]);
				if(bIsDoubleComponent)
				{
                    DetachFromBone(Component[part-1].DBComponent);
                }

                log("SetWeapComponent4 dettach"@Component[part-1]);
				FireMode.KFXSniperMaterial = none;
				FireMode.SniperX = 0;
				FireMode.SniperY = 0;
			}
			if(NewComponent != none)
			{
				KFXZoomLevelMax = 0;
				KFXZoomLevelMin = 0;

				KFXZoomLevelMax+=NewComponent.KFXZoomLevelMax;
				KFXZoomLevelMin+=NewComponent.KFXZoomLevelMin;
				AttachToBone(NewComponent,'BONE_SIGHT');
				if(bIsDoubleComponent)
				{
				     AttachToBone(NewComponent.DBComponent,'BONE_INFRARED01');
				     log("SetDBComponent1 attach"@NewComponent.DBComponent);
                }

                log("SetWeapComponent4 attach"@NewComponent);
				if(NewComponent.SniperSightStr~="null")
				{
					//Ê¹ÓÃweaponattributeÔ­Ê¼Ä¬ÈÏÌùÍ¼
					FireMode.KFXSniperMaterial = texture(DynamicLoadObject(FireMode.OrgSniperSightStr, class'texture'));
				}
				else
				{
					FireMode.KFXSniperMaterial = texture(DynamicLoadObject(NewComponent.SniperSightStr, class'texture'));
				    FireMode.SniperX = NewComponent.SniperX;
				    FireMode.SniperY = NewComponent.SniperY;
				}
			}
			Component[part-1] = NewComponent;
		}
		break;
	case 5:
		if( Component[part-1] != NewComponent )
		{
			if(Component[part-1]!=none)
			{
				DetachFromBone(Component[part-1]);
				if(bIsDoubleComponent)
				{
                    DetachFromBone(Component[part-1].DBComponent);
                }

                log("SetWeapComponent5 dettach"@Component[part-1]);
			}
			if(NewComponent != none)
			{
				AttachToBone(NewComponent,'BONE_CARTRIDGES');
				if(bIsDoubleComponent)
				{
				     AttachToBone(NewComponent.DBComponent,'BONE_INFRARED01');
				     log("SetDBComponent1 attach"@NewComponent.DBComponent);
                }

                log("SetWeapComponent5 attach"@NewComponent);
			}
			Component[part-1] = NewComponent;
		}
		break;
	case 6:
		if( Component[part-1] != NewComponent )
		{
			if(Component[part-1]!=none)
			{
				skins.Remove(1,skins.length-1);
				log("SetWeapComponent6 dettach"@Component[part-1]);
			}
			if(NewComponent != none)
			{
				for(loop=0; loop < NewComponent.PaintTextures.Length; loop++)
				{
					if(NewComponent.PaintTextures[loop]!="null")
					{
						skins[loop+1]=Material(DynamicLoadObject(NewComponent.PaintTextures[loop],class'Material',false));
						log("SetWeapComponent6 attach"@NewComponent@skins[loop+1]);
					}
				}
			}
			Component[part-1] = NewComponent;
		}
		break;
	}
	if(NewComponent == none)
	{
		FireMode.ComponentChangeModeType(0,0,6);
	}
	else
	{
		FireMode.ComponentChangeModeType(0,NewComponent.WeapAltFireChangeNum,part);
	}
}

simulated function bool KFXSetWeaponMaterialEX()
{
	return false;
}

simulated function KFXSetWeaponMaterial()
{
	local Material HandTex;
	local string HandTexName;
	local KFXPlayerReplicationInfo PRI;


	if( KFXSetWeaponMaterialEX() )
		return;

	if( KFXPawn(Instigator) != none && KFXPawn(Instigator).KFXPawnCanHid() && Skins.Length>0 )
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

	PRI = KFXPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if(PRI == none)
		return;

	if ( PRI.Team != none )
	{
		//Èç¹ûÊ¹ÓÃÊÖ²¿ÌùÍ¼µÀ¾ß
		if(HandTexName != "")
		{
			//log("[HANDEX] Texture Name"$HandTexName);
			HandTexName $= "_thin";
			HandTex = Material(DynamicLoadObject(HandTexName$"_thin", class'Material'));
		}
		else//Èç¹û²»Ê¹ÓÃÌùÍ¼µÀ¾ß£¬ÄÇÃ´¾ÍÊÇÊ¹ÓÃÄ¬ÈÏÊÖ²¿ÌùÍ¼ÁË¡£
		{
			if ( PRI.IsBlueTeam() )
			{
				if( KFXPawn(Instigator) != none && KFXPawn(Instigator).KFXPawnCanHid())
				    HandTexName = "fx_weapon_texs.hand_blue_thin";
				else
					HandTexName = "fx_weapon_texs.hand_blue_thin_s";

				//skins.Remove(1,skins.length-1);
			}
			else if ( PRI.IsRedTeam() )
			{
				if( KFXPawn(Instigator) != none && KFXPawn(Instigator).KFXPawnCanHid() )
				    HandTexName = "fx_weapon_texs.hand_red_thin";
				else
					HandTexName = "fx_weapon_texs.hand_red_thin_s";
			}
			else
			{
				if( KFXPawn(Instigator) != none && KFXPawn(Instigator).KFXPawnCanHid() )
					HandTexName = "fx_weapon_texs.hand_gray_thin";
				else
				    HandTexName = "fx_weapon_texs.hand_gray_thin_s";

			}
		}
	}
	else//Õâ¸öÊÇ¶ÁÈ¡Ê§°ÜµÄÊ±ºòµÄÄ¬ÈÏµÀ¾ß£¬²»Òª¹ÜËû.Ä¾ÄËÒÁÄ£Ê½»á×ßÕâ¸öÂ·Ïß£¡£¿
	{
		if(HandTexName != "")
		{
			HandTexName $= "_thin";
		}
		else
		{
			if( KFXPawn(Instigator) != none && KFXPawn(Instigator).KFXPawnCanHid() )
				HandTexName = "fx_weapon_texs.hand_gray_thin";
			else
				HandTexName = "fx_weapon_texs.hand_gray_thin_s";
		}
	}
	if(KFXPawn(Instigator).bIsFemale)
	{
	    HandTexName = HandTexName$"_W";
    }

	HandTex = Material(DynamicLoadObject(HandTexName, class'Material'));
	Skins[0] = HandTex;
}

// Sound
simulated function sound KFXGetFireSound()
{
	if(WeaponStateValue == 0)
	{
		return KFXSndTPFire[0];
	}
	else
	{
		return KFXSndTPFire[1];
	}
}
//µÚÈýÈË³ÆÏûÒôÆ÷µÄÉùÒô
simulated function sound KFXGetTPSmallFireSound()
{
	if(KFXSndTPSmallFire[WeaponStateValue] == none)
	{
	   if(Component[0].bShowAnotherFireSound)   //ÏûÒôÆ÷ÉùÒô
	   {
		  if(Component[0].KFXSndTPFireString[WeaponStateValue] != "")
		  {
			  KFXSndTPSmallFire[WeaponStateValue] = Sound(DynamicLoadObject(Component[0].KFXSndTPFireString[WeaponStateValue], class'Sound'));
		  }
	   }

	}
	return KFXSndTPSmallFire[WeaponStateValue];
}
simulated function sound KFXGetFPSmallFireSound()
{
	local int SndIndex;
	local int i;
	if(WeaponStateValue == 0)
	{
		SndIndex = Rand(2);
	}
	else
	{
		SndIndex = Rand(2) + 2;
	}
	if(KFXSndFPSmallFire[SndIndex] == none)
	{
	   if(Component[0].bShowAnotherFireSound)  //ÏûÒôÆ÷ÉùÒô
	   {
		  if(Component[i].KFXSndFPFireString[SndIndex] != "")
		  {
			  KFXSndFPSmallFire[SndIndex] = Sound(DynamicLoadObject(Component[i].KFXSndFPFireString[SndIndex], class'Sound'));
		  }
	   }

	}
	return KFXSndFPSmallFire[SndIndex];
}
simulated function sound KFXGetFPFireSound()
{
	local int SndIndex;

	if(WeaponStateValue == 0)
	{
		SndIndex = Rand(2);
	}
	else
	{
		SndIndex = Rand(2) + 2;
	}

	return KFXSndFPFire[SndIndex];
}

simulated function sound KFXGetReloadSound()
{
	return KFXSndReload;
}

simulated function sound KFXGetNoammoSound()
{
	return KFXSndNoammo;
}

simulated function name KFXGetAnimIdle()
{
	return IdleAnim;
}

// Anim
simulated function name KFXGetAnimReload()
{
	log("[KFXSpectateWeap] KFXGetAnimReload ReloadNum is"@SpectateHook.KFXGetReload());
	if ( SpectateHook.KFXGetReload() > 0 )
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
	if ( SpectateHook.KFXGetReload() > 0 )
	{
		return ReloadNormalAnimRate;
	}
	else
	{
		return ReloadNullAnimRate;
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

simulated function name GetSelectAnim()
{
	return SelectAnim;
}

simulated function PlayIdle()
{
	LoopAnim(KFXGetAnimIdle(), IdleAnimRate, 0.1);
}

simulated function PlayFire()
{
	if(FireMode.KFXFireType == 2)
	{
		FireMode.PlayPreFire();
	}
	else
	{
	   FireMode.PlayFire();
	}
}

simulated function PlayAltFire()
{
	FireMode.PlayAltFire();
}

simulated function InitWeaponState(KFXWeapAttachment NewWeapAttach)
{
	AltFirePlayOld = NewWeapAttach.AltFirePlay;
	KFXUserData = NewWeapAttach.KFXUserData;
	KFXClientSetZoomLevel(0);
	FireMode.SetWeapState( NewWeapAttach.FireStateValue);
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

simulated function UpdateWeaponState(KFXWeapAttachment NewWeapAttach)
{
	if(NewWeapAttach == none)
	{
		return;
	}
	if(AltFirePlayOld != NewWeapAttach.AltFirePlay)
	{
		PlayAltFire();
		AltFirePlayOld = NewWeapAttach.AltFirePlay;
	}

	if(KFXUserData != NewWeapAttach.KFXUserData)
		KFXUserData = NewWeapAttach.KFXUserData;

	if(NewWeapAttach.FireStateValue != WeaponStateValue )
	{
		FireMode.ChangeWeapState(NewWeapAttach.FireStateValue);
	}
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	//if( level.TimeSeconds  - showskinTime > 1.0)
//	{
//		showskinTime = level.TimeSeconds;
//		log("spectate weap skins"@skins[0]@skins[1]);
//	}
}

///
/// È¡µÃ»»µ¯¼ÓËÙ±¶Êý
///
simulated function float KFXGetSwitchAmmoRate()
{
	return 1.0; // replication

}

// Play Reloading
// Client only
simulated function PlayReload()
{
	PlayAnim(KFXGetAnimReload(), KFXGetAnimReloadRate()*KFXGetSwitchAmmoRate(), FireMode.TweenTime);
	//PlayOwnedSound(FireMode[0].ReloadSound);
}
// Play Start Reloading
// Client only
simulated function PlayStartReload()
{
	PlayAnim(KFXGetAnimPreReload(), KFXGetAnimReloadRate()*KFXGetSwitchAmmoRate(), FireMode.TweenTime);

	//PlayOwnedSound(FireMode[0].ReloadSound);
}
// Play After Reloading
// Client only
simulated function PlayAfterReload()
{
	PlayAnim(KFXGetAnimEndReload(), KFXGetAnimReloadRate()*KFXGetSwitchAmmoRate(), FireMode.TweenTime);

	//PlayOwnedSound(FireMode[0].ReloadSound);
}

simulated function PlayChangeWeapon()
{
	PlayAnim(GetSelectAnim(), SelectAnimRate * KFXGetSwitchWeaponDown(), 0.0);
	EnableChannelNotify(0, 1);
	EnableChannelNotify(1, 1);
}

simulated function float KFXGetSwitchWeaponDown()
{
//  if ( Level.NetMode == NM_DedicatedServer )
//  {
//      return 1.0;
//  }
//    if ( Instigator != none && KFXPawn(Instigator).KFXFostSwitchWeapon.SwitchDown != 0 )
//  {
//      return KFXPawn(Instigator).KFXFostSwitchWeapon.SwitchDown;
//  }
//  else
//  {
		return 1.0;
//  }
}

simulated event RenderOverlays( Canvas Canvas )
{
	//local int m, loop;
	local vector /*NewScale3D,*/ CameraLoc;
	//local rotator temp;
	local rotator CameraRot;

	if (Instigator == none)
	{
		return;
	}

	if ( FireMode.KFXAltFireState == 1 && WeaponStateValue != 0 ) //¿ª¾µ×´Ì¬
	{
		return;
	}

	// FIXME: Set Hand Material
	KFXSetWeaponMaterial();

	Canvas.GetCameraLocation(CameraLoc, CameraRot);
	SetLocation( CameraLoc + CalcDrawOffset(CameraRot) );
	SetRotation( CameraRot );

	bDrawingFirstPerson = true;
	Canvas.DrawActor(self, false, false, DisplayFOV);
	bDrawingFirstPerson = false;


}

// Call to Draw Weapon CrossHair
simulated function DrawWeaponInfo(Canvas Canvas)
{
	// Draw CrossHair
	if (FireMode != none)
	{
		Canvas.KFXSetPivot(DP_UpperLeft);
		if(KFXWeaponID == 1)
		{
			FireMode.KFXDrawCFourProgress(Canvas);
		}
		else if(FireMode.KFXAltFireState == 1 && WeaponStateValue != 0)
		{
			FireMode.KFXDrawSniperCrossHair(Canvas);
		}
		else
		{
			FireMode.KFXDrawCrossHair(Canvas);
		}
	}
}

simulated function AngleChanged(bool bFirstAngle)
{
	if(FireMode.KFXAltFireState == 1)
	{
		if(bFirstAngle)
		{
			KFXClientSetZoomLevel(WeaponStateValue);
		}
		else
		{
			KFXClientSetZoomLevel(0);
		}
	}
}

simulated function CheckBob(float DeltaTime, vector Y)
{
	local float Speed2D;

	if(instigator.Physics == PHYS_Walking)
	{
		Speed2D = VSize(instigator.Velocity);

		if ( Speed2D < 10 )
			BobTime += 0.2 * DeltaTime;
		else
			BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/800);
		WalkBob = Y * 0.006 * Speed2D * sin(BobTime * 10.0) * 0.15; // 8, 1
		/*
		AppliedBob = AppliedBob * (1 - FMin(1, 16 * deltatime));
		WalkBob.Z = AppliedBob;
		if ( Speed2D > 10 )
		{
			WalkBob.Z = WalkBob.Z + 0.75 * 0.006 * Speed2D * sin(16 * BobTime) * 0.1; // 16, 1;
		}
		*/
	}
	else
	{
		BobTime = 0;
		WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
	}

}

simulated function vector CalcDrawOffset(rotator CameraRot)
{
	local vector DrawOffset;
	local rotator WeaponShakeRot;
	local KFXPawn target;

	target = KFXPawn(instigator);

	DrawOffset = ((0.9/DisplayFOV * 100 * PlayerViewOffset) >> (CameraRot + WeaponShakeRot) );

	DrawOffset += WalkBob;
	return DrawOffset;
}

simulated function vector CameraShake(rotator CameraRot)
{
	local vector x, y, z, shakevect;
	local PlayerController pc;

	pc = level.GetLocalPlayerController();

	GetAxes(CameraRot, x, y, z);

	shakevect = pc.ShakeOffset.X * x +
				pc.ShakeOffset.Y * y +
				pc.ShakeOffset.Z * z;

	return shakevect;
}

simulated function vector EyePosition()
{
	if( FireMode.KFXAltFireState == 4 )
	{
		return KFXHackEyePosition(instigator.EyeHeight * vect(0,0,1) + WalkBob);
	}
	else
	{
		return instigator.EyeHeight * vect(0,0,1) + instigator.WalkBob;
	}
}

// Hack Eyeheight
simulated function vector KFXHackEyePosition(vector OrgPos)
{
	local float HeightPct;
	local vector HackPos;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if( EQBeginTime + 0.5 < Level.TimeSeconds )
		{
			EQBeginTime = 0.0;
			bEnterState = false;
			bQuitState = false;
		}

		if(EQBeginTime == 0.0)
		{
			if( WeaponStateValue == 0 )
			{
				return OrgPos;
			}
			else
			{
				return vect(0,0,1) * (KFXUserData - Instigator.CollisionHeight + 30) - Instigator.WalkBob;
			}
		}
		else
		{
			HeightPct = (Level.TimeSeconds - EQBeginTime) / 0.5;
			if (HeightPct < 0) HeightPct = 0;
			if (HeightPct> 1) HeightPct = 1;

			HackPos =  vect(0,0,1) * (KFXUserData - Instigator.CollisionHeight + 30) - Instigator.WalkBob;
			if(bEnterState)
			{
				HackPos.Z += (OrgPos.Z - HackPos.Z) * (1.0 - HeightPct);
			}
			else if(bQuitState)
			{
				HackPos.Z += (OrgPos.Z - HackPos.Z) * HeightPct;
			}
			return HackPos;
		}
	}

	return OrgPos;
}

simulated function rotator KFXWeaponShakeView()
{
//    if ( KFXFireBase(FireMode[0]) != none )
//    {
//        return KFXFireBase(FireMode[0]).KFXGetPunchAngle();
//    }
	return rot(0,0,0);
}

event AnimEnd(int channel)
{
	if(FireMode.PlayedPreFire)
	{
		FireMode.PlayFire();
		FireMode.PlayedPreFire = false;
	}
	else
	{
	   PlayIdle();
	}
}

simulated function KFXClientDoZoom(int ZoomLevel,optional bool bSilent)
{

	if(self.Viewer == none || SpectateHook != self.Viewer.SpectateHook)
	{
		return;
	}

	KFXClientSetZoomLevel(ZoomLevel);

	//¿ª¾µÒôÐ§
	if(!bSilent)
	{
		PlaySound(Sound(DynamicLoadObject(
			"fx_wpncommon_sounds.rifle_sightsout1", class'Sound')),SLOT_None,
			KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),false,
			TransientSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0)
			);
	}
}

simulated function KFXClientSetZoomLevel(int ZoomLevel)
{
	local KFXPlayer pc;

	pc = KFXPlayer(Level.GetLocalPlayerController());

	if ( pc.Pawn != none )
		return;
	if ( ZoomLevel == 0 )    //Î´¿ª¾µµÄÊ±ºò
	{
		pc.SetFOV(pc.DefaultFOV); //ÉèÖÃÊÓ½ÇÎªÄ¬ÈÏÊÓ½Ç
		DisplayFOV = KFXDefDisplayFov[pc.DrawWeaponAXIS];
	}
	else if ( ZoomLevel == 1 )    //¿ª¾µµÄÇé¿öÏÂ·ÖÁ½ÖÖ-Ò»±¶ºÍ¶þ±¶
	{
		log("spec zoomlevelmax"@KFXZoomLevelMax);
		pc.DesiredFOV = KFXZoomLevelMax;  // Ò»±¶¾µ  40
		pc.SetFOV(pc.DesiredFOV);
		DisplayFOV = KFXDefDisplayFov[pc.DrawWeaponAXIS] * 0.66;
	}
	else  //Ïàµ±ÓÚelse if ( KFXZoomLevel == 2 )
	{
		log("spec zoomlevelmin"@KFXZoomLevelmin);
		pc.DesiredFOV = KFXZoomLevelMin;  //¶þ±¶¾µ 10
		pc.SetFOV(pc.DesiredFOV);
		DisplayFOV = KFXDefDisplayFov[pc.DrawWeaponAXIS] * 0.33;
	}

}

defaultproperties
{
     LightType=LT_Pulse
     LightHue=32
     LightSaturation=120
     LightBrightness=220.000000
     LightRadius=10.000000
     DrawType=DT_Mesh
     bHidden=是
}
