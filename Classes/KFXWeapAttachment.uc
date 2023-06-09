// ====================================================================
//  Class:  KFXGame.KFXWeapAttachment
//  Creator: Kevin Sun
//  Date: 2007.06.28
//  Description: KFX Attachment class
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXWeapAttachment extends WeaponAttachment;

const KFX_MAX_ACCESSORY_NUM = 7;        // Åä¼þÊýÁ¿
var int KFXAccessory[KFX_MAX_ACCESSORY_NUM];            // Áã¼þID

var int ComponentID[6];
var KFXAttachComponent ComAttachment[6];

var     byte    ServerFlashCount;   //
var     byte    ServerHitCount;
// player animation specification
var vector mHitNormal;
var actor mHitActor;
var material mHitMaterial;
var Weapon LitWeapon;
var bool  KFXWeaponLight;        // ÊÇ·ñÐèÒªµÆ¹â
var class<DamageType> damageType;
var bool bInitToPawn;
var float KFXUserData;          // ÓÃ»§Êý¾Ý
var bool  KFXOnlyEffect;        // Ö»²¥ÌØÐ§£¬²»²¥¶¯×÷

const KFX_MAX_HIT_COUNT = 8;   // ×î¶àÒ»´ÎÄÜ²úÉúµÄµ¯¿×ÊýÁ¿
var vector HitLocs[KFX_MAX_HIT_COUNT]; // Kevin Sun: for multi-hits implements

// animation index
var name ThirdPersonFireAnim;
var name ThirdPersonAltFireAnim;

var int   KFXAnimGroupIndex;      // ÈËÎï¶¯»­×éºÅ
var name  KFXTPAnimFire[2];       // ThirdPerson¿ª»ð¶¯»­
var int   KFXShotPerfire[2];      // ¶àÉÙ·¢×Óµ¯²¥Ò»´ÎÉä»÷¶¯»­

// sound Effects
var int   KFXSoundType;
var sound KFXSound_HitWall[5];
var sound KFXSound_HitMetal[5];
var sound KFXSound_HitWood[5];
var sound KFXSound_HitGlass[5];
var sound KFXSound_HitWater[5];

// Hit Effects
var class<Emitter> KFXEmitter_HitWall[2];
var class<Emitter> KFXEmitter_HitMetal[2];
var class<Emitter> KFXEmitter_HitWood[2];
var class<Emitter> KFXEmitter_HitWater[2];

var class<Projector> KFXScorch_HitWall[2];
var class<Projector> KFXScorch_HitMetal[2];
var class<Projector> KFXScorch_HitWood[2];
var class<Projector> KFXScorch_HitGlass[2];
var     class<Emitter> KFXWeapHotEffectClass3rd;
var     actor          KFXWeapHotEffect3rd;


// Pawn Weapon Dependent Anims
var name KFXPawnAnimFire[2];
var name KFXPawnAnimCrouchFire[2];
var name KFXPawnAnimSwitch;
var name KFXPawnAnimReload;
var name KFXPawnAnimCrouchReload;
var name KFXPawnAnimHit[4];
//------------------------------
struct MGDeployAnims
{
	var name Fire;
	var name Down;
	var name CrouchDown;
	var name Idle;
	var name Up;
	var name Reload;
};

var Array<MGDeployAnims> MGDeployStepAnims;
var Array<int>           MGDeployStepHeights;

//-------------------------------
// ×´Ì¬ÐÅÏ¢
var bool KFXWeaponDeployed;
var bool KFXWeaponDeployedOld;

var bool AltFirePlay;   //ÓÒ¼üÄ£Ê½µ÷ÓÃÒ»´Î£¬¸ÃÖµ¾Í·´×ªÒ»´Î
var bool AltFirePlayOld; //¿Í»§¶Ë¼ÇÂ¼ÉÏÒ»´Î·þÎñÆ÷Í¬²½¹ýÀ´µÄÓÒ¼üÄ£Ê½µ÷ÓÃÖµ
var byte FireStateValue; //·þÎñÆ÷Í¬²½µ½¿Í»§¶Ë£¬ÎäÆ÷µ±Ç°´¦ÓÚµÄ×´Ì¬Öµ
						//£¨Èç¼ÜÇ¹¡¾0£¬1¡¿¡¢¿ª¾µ¡¾0£¬1£¬2¡¿¡¢ÈýÁ¬·¢¡¾0£¬1¡¿£©
						//(ÓÐÊÓ¸ß±ä»¯µÄ¼ÜÇ¹¡¾0,1,2,3¡¿)
						//´ËÖµ´óÐ¡ºÍ´ËÖµ¶ÔÓ¦µÄÒâÒå£¬ÒòÎäÆ÷µÄ²»Í¬¶ø²»Í¬

var bool bHideAlready;                       //ÊÇ·ñÒÑ¾­Òþ²ØÁË
var sound sound_attachment_switch;      //ÇÐ»»µ½¸ÃÎäÆ÷µÄÊ±ºò£¬²¥·ÅµÄµÚÈýÈË³ÆÒôÐ§
var sound sound_attachment_reload;      //»»×Óµ¯µÄÊ±ºò£¬²¥·ÅµÄµÚÈýÈË³ÆÌØÐ§

var float lastFireTraceTime;

var vector  RelLocation;
var rotator RelRotation;
var bool   bShowTrack;
var int    TrackType; //0,Ä¬ÈÏÐ¡µ¯Ïß£¬1µ¥·¢¼¤¹â£¬2³ÖÐø¼¤¹â
var float  LastFireSec;  //±¾µØµÚÈýÈË³Æ×îºóÒ»´Î¿ª»ðµÄÊ±¼ä
var Emitter TPEffect;  //¼ÇÂ¼µÄµÚÈýÈË³ÆÌØÐ§£¬ÓÃÓÚ²»¼ä¶ÏÌØÐ§
//--ÉËº¦Ð§¹û±äÁ¿ --wangxuebin
var class<Emitter> KFXEmitter_HitBody[2];
var class<Emitter> KFXEmitter_HitHead[2];
var class<Emitter> KFXEmitter_HitPig[2];
var sound KFXSound_HitBody[5];
var sound KFXSound_HitHead[5];
var sound KFXSound_HitPig[5];
var int nBloodColor;

var float BringupTime;
var float PutDownTime;        //ÔÝÊ±ÓëKFXWeapBaseÒ»Ñù£¬Ð´ËÀÎª0.01 

var bool bDoubleComponent;
var vector AnoLocation;
var rotator AnoRotation;
replication
{
	// Things the server should send to the client.
	reliable if( bNetInitial && Role==ROLE_Authority )
	   KFXAccessory,ComponentID;

	reliable if ( bNetDirty && (Role==ROLE_Authority) )
	   HitLocs, KFXWeaponDeployed, KFXUserData, KFXOnlyEffect,AltFirePlay,FireStateValue,TrackType;
}
function CSVConfig(array<int> Ids)
{
	KFXWeaponID = Ids[0];
	KFXAccessory[0] = Ids[1];
	log("kfxweapbase CSVConfig"$KFXWeaponID$"KFXAccessory[0]"$KFXAccessory[0]);
	csvKFXInit();
}

// Client Only
// ¶ÁÈ¡£¬ÉèÖÃPawnsÊÜÉËÊ±µÄÌØÐ§ºÍÉùÒô
simulated function csvKFXInitAttachmentData(int KFXWeaponID)
{
	local int nTemp, loop;
	local KFXCSVTable CFG_Attachment,CFG_Sound,CFG_Effect;
	CFG_Attachment = class'KFXTools'.static.GetConfigTable(17);
	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);
	CFG_Effect     = class'KFXTools'.static.GetConfigTable(18);

	if ( !CFG_Attachment.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXPawn] InitAttachmentData Can't Resolve the Weapon ID(Attachment Table) :"$KFXWeaponID );
		return;
	}

	for ( loop = 0; loop < 5; loop++ )
	{
		nTemp = CFG_Attachment.GetInt( "SndBody"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitBody[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
		nTemp = CFG_Attachment.GetInt( "SndHead"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitHead[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
		nTemp = CFG_Attachment.GetInt( "SndPig"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitPig[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
	}


	for ( loop = 0; loop < 2; loop++ )
	{
		nTemp = CFG_Attachment.GetInt( "EmtBody"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			if(nBloodColor==0)
			{
				KFXEmitter_HitBody[loop] =
					class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class")$"1", class'Class') );
			}
			else if(nBloodColor == 1)
			{
				 KFXEmitter_HitBody[loop] =
					class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class")$"3", class'Class') );
			}
			else
			{
				KFXEmitter_HitBody[loop] =
					class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class")$"5", class'Class') );
			}
		}
		;
		nTemp = CFG_Attachment.GetInt( "EmtHead"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			if(nBloodColor==0)
			{
				KFXEmitter_HitHead[loop] =
					class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class")$"2", class'Class') );
			}
			else if(nBloodColor==1)
			{
				KFXEmitter_HitHead[loop] =
					class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class")$"3", class'Class') );
			}
			else
			{
				KFXEmitter_HitHead[loop] =
					class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class")$"5", class'Class') );
			}
		}
		nTemp = CFG_Attachment.GetInt( "EmtPig"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXEmitter_HitPig[loop] =
				class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
	}

}




//
// Client Only
simulated function csvKFXInit()
{
	local KFXCSVTable CFG_Attachment, CFG_Accessory, CFG_Sound, CFG_Effect,CFG_Weapon;
	local string MeshName, MaterialName, SkelName;
	local int nTemp, loop,loop1;
	local name nAnimTemp;
	local bool bManuFixed;
	local Material mat;
	local string temstr;
	local string TexString;

	;

	CFG_Accessory  = class'KFXTools'.static.GetConfigTable(13);
	CFG_Attachment = class'KFXTools'.static.GetConfigTable(17);
	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);
	CFG_Effect     = class'KFXTools'.static.GetConfigTable(18);
	CFG_Weapon 	   = class'KFXTools'.static.GetConfigTable(11);
	
	if ( !CFG_Weapon.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve the Weapon ID(Weap Table) :"$KFXWeaponID );
		return;
	}
	
	BringupTime = CFG_Weapon.GetFloat("TimeBringup");
	
	

	if ( !CFG_Attachment.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve the Weapon ID(Attachment Table) :"$KFXWeaponID );
		return;
	}

	// Common View Attributes
	KFXAnimGroupIndex = CFG_Attachment.GetInt("AniGroup");
	KFXWeaponLight = CFG_Attachment.GetBool("WeaponLight");
    bDoubleComponent = CFG_Attachment.GetBool("bDoubleComponent");
	nAnimTemp = CFG_Attachment.GetName("AnimFire1");
	if ( nAnimTemp != '0' )
	{
		KFXTPAnimFire[0] = nAnimTemp;
	}
	nAnimTemp = CFG_Attachment.GetName("AnimFire2");
	if ( nAnimTemp != '0' )
	{
		KFXTPAnimFire[1] = nAnimTemp;
	}

	// Shot Per Fire
	KFXShotPerFire[0] = CFG_Attachment.GetInt("ShotPerAnim1");
	KFXShotPerFire[1] = CFG_Attachment.GetInt("ShotPerAnim2");

	// Draw Params
	SetDrawScale( CFG_Attachment.GetFloat("DrawScale") );


	RelLocation.X = CFG_Attachment.GetFloat("LocationX");
	RelLocation.Y = CFG_Attachment.GetFloat("LocationY");
	RelLocation.Z = CFG_Attachment.GetFloat("LocationZ");

	RelRotation.Roll   = CFG_Attachment.GetInt("RotRoll");
	RelRotation.Yaw    = CFG_Attachment.GetInt("RotYaw");
	RelRotation.Pitch  = CFG_Attachment.GetInt("RotPitch");

	// Load Sound & Effect config
	KFXSoundType = CFG_Attachment.GetInt("SndType");

	for ( loop = 0; loop < 5; loop++ )
	{
		// sound
		nTemp = CFG_Attachment.GetInt( "SndWall"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitWall[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
		nTemp = CFG_Attachment.GetInt( "SndMetal"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitMetal[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
		nTemp = CFG_Attachment.GetInt( "SndWood"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitWood[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
		nTemp = CFG_Attachment.GetInt( "SndGlass"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitGlass[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
		nTemp = CFG_Attachment.GetInt( "SndWater"$(loop + 1) );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSound_HitWater[loop] =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}

	}

	for ( loop = 0; loop < 2; loop++ )
	{
		// Emitter
		nTemp = CFG_Attachment.GetInt( "EmtWall"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXEmitter_HitWall[loop] =
				class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}

		//LOG("[weapattatchment] effect is :"$nTemp);

		nTemp = CFG_Attachment.GetInt( "EmtMetal"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXEmitter_HitMetal[loop] =
				class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
		//LOG("[weapattatchment] effect is :"$nTemp);
		nTemp = CFG_Attachment.GetInt( "EmtWood"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXEmitter_HitWood[loop] =
				class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
		//LOG("[weapattatchment] effect is :"$nTemp);
		nTemp = CFG_Attachment.GetInt( "EmtBody"$(loop + 1) );
		nTemp = CFG_Attachment.GetInt( "EmtWater"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXEmitter_HitWater[loop] =
				class<Emitter>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
		//LOG("[weapattatchment] effect is :"$nTemp);
		// Scorch
		nTemp = CFG_Attachment.GetInt( "ScoWall"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXScorch_HitWall[loop] =
				class<Projector>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
		nTemp = CFG_Attachment.GetInt( "ScoMetal"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXScorch_HitMetal[loop] =
				class<Projector>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
		//LOG("[weapattatchment] effect is :"$nTemp);
		nTemp = CFG_Attachment.GetInt( "ScoWood"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXScorch_HitWood[loop] =
				class<Projector>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
		//LOG("[weapattatchment] effect is :"$nTemp);
		nTemp = CFG_Attachment.GetInt( "ScoGlass"$(loop + 1) );
		if ( nTemp != 0 && CFG_Effect.SetCurrentRow(nTemp) )
		{
			KFXScorch_HitGlass[loop] =
				class<Projector>( DynamicLoadObject(CFG_Effect.GetString("Class"), class'Class') );
		}
	}

	// Init the Main Part
	if ( !CFG_Accessory.SetCurrentRow(KFXAccessory[0]) )
	{
		Log("[Kevin] Can't Resolve the TP Main Accessory ID:"$KFXAccessory[0] );
		return;
	}
	MeshName     = CFG_Accessory.GetString("TPMesh");
	MaterialName = CFG_Accessory.GetString("TPMaterial");
	SkelName     = CFG_Accessory.GetString("TPSkeleton");
	bManuFixed = CFG_Accessory.GetBool("ManuFix");

	LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );

	if(bManuFixed)
	{
		log("[weaponAttachment] manufixed skins");
		for( loop=0; loop<12; loop++ )
		{
			TexString = "TPMaterial"$loop;
			TexString = CFG_Accessory.GetString(TexString);

			if(TexString ~= "null"||TexString=="")
			{
				;
				break;
			}

			mat = Material( DynamicLoadObject( TexString, class'Material' ) );
			;
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
			}
		}
	}
	//´Ë´¦ÓÐwearning CFG_Attachment.GetString("SwitchingSound") ¿ÉÄÜÎª¿Õ
	sound_attachment_switch = Sound(DynamicLoadObject(CFG_Attachment.GetString("SwitchingSound"), class'Sound'));
	sound_attachment_reload = sound(DynamicLoadObject(CFG_Attachment.GetString("ReloadingSound"), class'Sound'));

	BoneRefresh();

	csvKFXInitAttachmentData(KFXWeaponID);
	// TODO: Init Accessories
}

simulated function KFXInit()
{
	local int PRIWeapListIndex;
	local KFXPlayerReplicationInfo PawnPRI;
	local int loop, loop1;
	local KFXCSVTable CFG_Component;

	PawnPRI = KFXPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	// Fixed the no Attachment Location Bug
	if (Instigator != none)
		Instigator.AttachToBone(self, Instigator.GetWeaponBoneFor(none));

	if (Instigator != none)
		RelLocation = RelLocation + KFXPawn(Instigator).KFXGetWeaponLocation(KFXWeaponID);
	SetRelativeLocation(RelLocation);

	if (Instigator != none)
		RelRotation = RelRotation + KFXPawn(Instigator).KFXGetWeaponRotation(KFXWeaponID);
	SetRelativeRotation(RelRotation);

	CFG_Component  = class'KFXTools'.static.GetConfigTable(22);

	PawnPRI = KFXPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	PRIWeapListIndex = -1;
	for(loop=0; loop < PawnPRI.WeapAndCompntIdList.Length; loop++)
	{
		if(PawnPRI.WeapAndCompntIdList[loop].weaponID == KFXWeaponID)
		{
			PRIWeapListIndex = loop;
			break;
		}
	}
	if(PRIWeapListIndex == -1)
	{
		PawnPRI.WeapAndCompntIdList.Insert(PawnPRI.WeapAndCompntIdList.Length,1);
		PawnPRI.WeapAndCompntIdList[PawnPRI.WeapAndCompntIdList.Length-1].weaponID=KFXWeaponID;
		PRIWeapListIndex = PawnPRI.WeapAndCompntIdList.Length-1;
	}

	//×é¼þÄ£ÐÍ
	for(loop = 0; loop < 6; loop++)
	{
		break;
		PawnPRI.WeapAndCompntIdList[PRIWeapListIndex].CompntID[loop] = ComponentID[loop];
		if( ComponentID[loop] != 0 )
		{
			if(!CFG_Component.SetCurrentRow(ComponentID[loop]))
			{
				log("[KFXWeapAttachment] wrong CompntID"@ComponentID[loop]);
				return;
			}
			ComAttachment[loop] = Spawn(
				class<KFXAttachComponent>(
					DynamicLoadObject("XXXWeapons.XXX_"$CFG_Component.GetString("Name")$"AttachComponent", class'Class',true)),
				self);

			bShowTrack =  bShowTrack && ComAttachment[loop].bShowTrack;
			if ( ComAttachment[loop].PartIndex == 1 )
			{
				ComAttachment[loop].RequestRecord("24 "$ComAttachment[loop].FireFlashClass);
				log("[Record]  "$"24 "$ComAttachment[loop].FireFlashClass);
			}

			if(loop == 5)
			{
				for(loop1=0; loop1<ComAttachment[loop].Skins.length; loop1++)
				{
					Skins[loop1]=ComAttachment[loop].Skins[loop1];
				}
				continue;
			}
			else
			{
    			ComAttachment[loop].RequestRecord(""$"5 "$ComAttachment[loop].Skins[0]);
			}

			if(AttachToBone(ComAttachment[loop],ComAttachment[loop].AttachedBone))
			{
				log("ThirdPerson Component Attach success"$ComAttachment[loop]$"to bone:"$ComAttachment[loop].AttachedBone@ComAttachment[loop].Skins[0]);
			}
			else
			{
				log("ThirdPerson WeaponComponent AttachtoBone fail weaponid"@KFXWeaponID@"ComponentID"@ComponentID[loop]);
			}

			ComAttachment[loop].SetRelativeLocation( ComAttachment[loop].ComRelLocation);
			ComAttachment[loop].SetRelativeRotation( ComAttachment[loop].ComRelRotation);

           if(bDoubleComponent)
           {
                if(AttachToBone(ComAttachment[loop].DBComponent,class'DataTable'.static.StringToName(ComAttachment[loop].AttachedBone$"01")))
                {
                	log("ThirdPerson Component Attach success"$ComAttachment[loop].DBComponent$"to bone:"$ComAttachment[loop].AttachedBone$"01");
                }
                else
                {
                	log("ThirdPerson WeaponComponent AttachtoBone fail weaponid"@KFXWeaponID@"ComponentID"@ComponentID[loop]);
                }

                ComAttachment[loop].DBComponent.SetRelativeLocation( ComAttachment[loop].AnoRelLocation);
                ComAttachment[loop].DBComponent.SetRelativeRotation( ComAttachment[loop].AnoRelRotation);

           }
		}
	}
	BoneRefresh();
	if ( Skins.length>0 )
	   RequestRecord(""$"5 "$Skins[0]);
	if ( Skins.length>1 )
	   RequestRecord(""$"6 "$Skins[1]);
	//¼ÇÂ¼linkÊý¾Ý
	RequestRecord("7 "$int(LinkType));
	RequestRecord("8 "$int (LinkData));
}

//
// Server Only
function InitFor(Inventory I)
{
	local KFXWeapBase weap;
	local int loop;

	Instigator = I.Instigator;

	weap = KFXWeapBase(I);

	if ( Weap == none )
	{
	   Log("[Kevin] Error Can't Resovle the Weapon Type for KFXWeapAttachment: "$I);
	   return;
	}

	KFXWeaponID = weap.KFXGetWeaponID();

	//°ÑµÚÒ»ÈË³ÆÎäÆ÷×é¼þID¸³Öµ¸øµÚÈýÈË³Æ£¬ÒÑ¾­°üº¬Ä¬ÈÏ×é¼þID
	for(loop =0; loop < 6; loop++)
	{
		if( weap.KFXWeapComponent[loop] != none )
		{
			ComponentID[loop] = weap.KFXWeapComponent[loop].ComponentTypeID;
		}
		else
		{
			ComponentID[loop] = 0;
		}
	}

	;
	//------ÇÐÇ¹ÖÐ¶ÏÉùÒô¼°¶¯»­£¨Ö÷ÒªÊÇÉùÒô£©
	IncrementSwitchCount();
	for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
	{
		KFXAccessory[loop] = weap.KFXAccessory[loop];
	}
}

//
// Get the AnimGroup Index
simulated function int KFXGetAnimIndex()
{
	return KFXAnimGroupIndex;
}

//
// Get Hacked FireAnim
simulated function name KFXHackFireAnim(name OrgAnim)
{
	return OrgAnim;
}

//
// GetHacked ReloadAnim
simulated function name KFXHackReloadAnim(name OrgAnim)
{
	return OrgAnim;
}

// fake trace
// clients only
simulated function GetHitInfo()
{
	local vector HitLocation, Offset;

	// Èç¹û¼ÓÉÏÒÔÏÂ´úÂë£¬Netowner½«ÎÞ·¨ÅÐ¶Ï»÷ÖÐµÄ²ÄÖÊÀà±ð
	// if standalone, already have valid HitActor and HitNormal
	//if ( Level.NetMode == NM_Standalone || Instigator.IsLocallyControlled() )
	//    return;

	Offset = 20 * Normal(Instigator.Location - mHitLocation);
	mHitActor = Trace(HitLocation,mHitNormal,mHitLocation-Offset,mHitLocation+Offset, true, ,mHitMaterial);

	//mHitActor = Trace(HitLocation,mHitNormal,mTraceEnd,mTraceStart, true, ,mHitMaterial);
	if (KFXPawn(mHitActor) != none)
	{
		KFXPawn(mHitActor).KFXDmgInfo.HitBoxID = KFXPawn(mHitActor).TraceHitBox(mHitLocation-Offset, mHitLocation+Offset);

		if ( KFXPawn(mHitActor).KFXDmgInfo.HitBoxID == -1 )
		{
			mHitActor = none;
		}
	}

	NetUpdateTime = Level.TimeSeconds - 1;
}

/* UpdateHit
- used to update properties so hit effect can be spawn client side
*/
simulated function UpdateHit(Actor HitActor, vector HitLocation, vector HitNormal,optional bool bSimuFire)
{
	 if(bSimuFire)
	 {
		UpdateHitData(HitActor,HitLocation,HitNormal,bSimuFire);
	 }
	 else
	 {
		SpawnHitCount++;
		if (SpawnHitCount > KFX_MAX_HIT_COUNT)
			return;
		HitLocs[SpawnHitCount-1] = HitLocation;
		//mHitLocation = HitLocation;
		//mHitActor = HitActor;
		//mHitNormal = HitNormal;
	 }
}

simulated function UpdateHitData(Actor HitActor, vector HitLocation, vector HitNormal,optional bool bSimuFire)
{
	if ( Role<Role_Authority )
	{
		SpawnHitCount++;
		if (SpawnHitCount > KFX_MAX_HIT_COUNT)
			return;
		HitLocs[SpawnHitCount-1] = HitLocation;

	}
	else
	{
		ServerHitCount++;
		if (ServerHitCount > KFX_MAX_HIT_COUNT)
			return;
		HitLocs[ServerHitCount-1] = HitLocation;   //·þÎñÆ÷Í¬²½¸Ã±äÁ¿

	}

//    log("KFXWeapAttachment-----SpawnHitCount"$SpawnHitCount);
//    log("KFXWeaponAttachment-----HitLocation"$HitLocation);

}

// ThirdPersonEffectsÖ»²¥·ÅÐ§¹û£¬²»²¥·Å¶¯×÷
// Server Only
simulated function SetOnlyEffect(bool b)
{
	KFXOnlyEffect = b;
}

simulated function Hide(bool NewbHidden)
{
	bHidden = NewbHidden;
}

simulated function KFXAdjustBloodColor(KFXPawn P);

simulated function KFXGetOthersWeaponTraceLocation(Pawn Instigator,out vector HitLocation)
{
	local vector StartTrace;
	local rotator PawnRot;
	if ( (KFXWeaponID >> 16) >= 41 && (KFXWeaponID >> 16) < 51)
	{
		StartTrace = Instigator.Location + Instigator.EyePosition()/2;
		//StartTrace += vector(Instigator.Rotation)*(Instigator.CollisionRadius /2 );
	}
	else
	{
		StartTrace = Location;
	}
//    StartTrace = Instigator.Location + Instigator.EyePosition()/2;
	PawnRot = Instigator.Rotation;
	PawnRot.Pitch = Instigator.ViewPitch*256;
	KFXOtherDoTrace(HitLocation,StartTrace, PawnRot);
}

// Calculate Trace Direction
// server & owner client predict
simulated function KFXOtherCalcTrace(
	out vector TraceX, out vector End,
	vector Start, rotator Dir, float TraceRange)
{
	local vector ShootX, ShootY, ShootZ;
	local float dx, dy;

	// Apply Kickback Stuff
	//Dir += PunchAngle;

	GetAxes(Dir, ShootX, ShootY, ShootZ);

	dx = FRand() - 0.5;
	dy = FRand() - 0.5;


	TraceX = ShootX
		+ 0.02 * dx * ShootY
		+ 0.02 * dy * ShootZ;

	End = Start + 10800 * TraceX;
}
simulated function int GetPenetrationFactor()
{
	local KFXCSVTable CFG_Weapon;
	local int Penetration;
	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
	if ( !CFG_Weapon.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Attr Table): "$KFXWeaponID);
		return 0;
	}
	Penetration = CFG_Weapon.GetInt("PTFactor1");
	return Penetration;
}
//
// Get Other Perple Trace Location
simulated function KFXOtherDoTrace(out vector HitLocation,Vector Start, Rotator Dir)
{
	local Vector RealStart, End, X, HitNormal;
	local Actor Other;
	local float Damage;
	local int Penetration,RealPenetration, Times, TimesCrossWall;
	local float Dist, DecayFactor;
	local bool bFakeTrace;
	local int HitboxIndex;

	Penetration     = GetPenetrationFactor();
	RealPenetration = Penetration;
	RealStart       = Start;
	Times           = 0;    // ´©Ô½Éä»÷´ÎÊý
	TimesCrossWall  = 0;
	DecayFactor     = 1.0;  // ´©Í¸Á¦ÏµÊý Pawn - 1.5, Other - 1.0

	// Calc Trace End
	KFXOtherCalcTrace(X, End, Start, Dir, 10800);
	log("HitStart"@Start@"HitEnd"@End);

	if ( true )
	{
		bFakeTrace = false;

		// Trace Hit
		Other = Trace(HitLocation, HitNormal, End, Start, true);
		// Apply Damage
		if ( Other != None && (Other != Instigator) )
		{
			// Calc Distance
			Dist = VSize(HitLocation - RealStart);

			// Trace End
			if ( Dist > 10800)//KFXWeapBase(Weapon).KFXGetRange() )  ÔÝÊ±Ð´ËÀ£¬ÒòÎªÖ»ÓÐÖ÷ÎäÆ÷ºÍ¸±ÎäÆ÷²ÅÊÇClient Simulated Fire,Á½Õß¶¼ÊÇ10800
			{
				return;
			}

			if ( !Other.bWorldGeometry )
			{

				 if ( Times == 0 )
				 {
					UpdateHit(Other,HitLocation,HitNormal);
				 }
			}
		}
		else
		{
			HitLocation = End;
			HitNormal = Vect(0,0,0);
			UpdateHit(Other,HitLocation,HitNormal);
		}
	}

}
// µÚÈýÈË³ÆÐ§¹û
// client simulated
simulated event ThirdPersonEffects()
{
	local PlayerController PC;
	local int SoundRnd;
	local Actor SndVol;
	local int loop;

	local float DotV;
	local vector ScorchDir;
	local rotator ScorchRot;
	local bool  DrawScorch;
    local vector ExtraLoc;
    local coords TrackCoords;
    local float  Dist;
    local rotator TrackRotator;    //µ¯µÀRotation
//    local vector RandHitLocs;      //µ¯¿×Î»ÖÃÆ«ÒÆÒ»Ð©
//    local float MaxValue;

	local vector TrackLocation;
	if ( Level.NetMode == NM_DedicatedServer
		|| KFXPawn(Instigator) == none )
	   return;
	log("KFXWeapPAttachment--------Controller "$KFXPlayer(Instigator.Controller));
	log("KFXWeapPAttachment--------fireeffectctrl "$KFXPlayer(Instigator.Controller).fireeffectctrl);
	if (KFXPlayer(Instigator.Controller) != none && KFXPlayer(Instigator.Controller).fireeffectctrl )
		return;
//    MaxValue = 8;
//    RandHitLocs.X = rand(MaxValue);
//    RandHitLocs.Y = rand(MaxValue);
//    RandHitLocs.Z = rand(MaxValue);

	// Fixed the Track Rot on the Ground
	DrawScorch = true;
	ScorchDir = -mHitNormal;
	ScorchRot = rotator(ScorchDir);
	if ( (KFXWeaponID >> 16) >= 41 && (KFXWeaponID >> 16) < 51)
	{
		ScorchRot.Yaw = Instigator.Rotation.Yaw;
	}
	log("KFXWeapPAttachment--------FlashCount "$FlashCount);
	// Play Hit
	if ( FlashCount > 0 && FlashCount < 200 )
	{
		PC = Level.GetLocalPlayerController();
		log("KFXWeapPAttachment--------KFXOnlyEffect "$KFXOnlyEffect);
		// ThirdPerson Play Firing
		LastFireSec = level.TimeSeconds;
		if ( !KFXOnlyEffect )
			ThirdPersonPlayFiring();

		for ( loop = 0; loop < SpawnHitCount; loop++ )
		{
//            if(VSize(HitLocs[loop]) <= 0)
//            {
//                KFXGetOthersWeaponTraceLocation(Instigator,HitLocs[loop]);
//                mHitLocation = HitLocs[loop] ;//+ RandHitLocs;
//                HitLocs[loop].X = 0;
//                HitLocs[loop].Y = 0;
//                HitLocs[loop].Z = 0;
//            }
//            else
//            {
//                mHitLocation = HitLocs[loop];
//            }
//

			mHitLocation = HitLocs[loop];

			// Fake Trace
			GetHitInfo();
			//½â¾öµÚÒ»Ç¹ÓÐÊ±ºò´ò²»ÉÏµ¯¿×bug
			ScorchDir = -mHitNormal;
			ScorchRot = rotator(ScorchDir);
			if ( (KFXWeaponID >> 16) >= 41 && (KFXWeaponID >> 16) < 51)
			{
				ScorchRot.Yaw = Instigator.Rotation.Yaw;
			}

			// Fire Effect
			// Ö»¶Ô·ÇÖ÷¿Ø¿Í»§¶Ë½øÐÐµÄÐ§¹û´¦Àí
			if ( ((Instigator != None) && (Instigator.Controller == PC)) || (VSize(PC.ViewTarget.Location - mHitLocation) < 4000) )//Instigator.Controller != PC
			{
				if ( KFXSoundType == 0 )
					SoundRnd = Rand(5);
				else
					SoundRnd = FiringMode;
				if (KFXPawn(mHitActor) != none)
				{
				}
				else if (mHitMaterial != none)
				{
					switch (mHitMaterial.SurfaceType)
					{
						case EST_Wood:
							SndVol = Spawn(KFXEmitter_HitWood[FiringMode],,, mHitLocation+ 2 * mHitNormal, Rotator(mHitNormal));
							if ( DrawScorch )
								Spawn(KFXScorch_HitWood[FiringMode],,,mHitLocation + 2 * mHitNormal, ScorchRot);
							if(SndVol!=none)
							{
							SndVol.PlaySound(KFXSound_HitWood[SoundRnd], SLOT_None,
											TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
											TransientSoundRadius,,false);//*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0)
							}
							else
							{
								log("[weaponattachment] spawn SndVol Error");
							}
							break;
						case EST_metal:
							SndVol = Spawn(KFXEmitter_HitMetal[FiringMode],,, mHitLocation+ 2 * mHitNormal, Rotator(mHitNormal));
							if ( DrawScorch )
								Spawn(KFXScorch_HitMetal[FiringMode],,,mHitLocation + 2 * mHitNormal, ScorchRot);
							if(SndVol!=none)
							SndVol.PlaySound(KFXSound_HitMetal[SoundRnd], SLOT_None,
											TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
											TransientSoundRadius,,false); //*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0)
							else
							{
								log("[weaponattachment] spawn SndVol Error");
							}
							break;
						case EST_Glass:
							SndVol = Spawn(KFXScorch_HitGlass[FiringMode],,,mHitLocation + 2 * mHitNormal, ScorchRot);
							if(SndVol!=none)
							SndVol.PlaySound(KFXSound_HitGlass[SoundRnd], SLOT_None,
											TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
											TransientSoundRadius,,false);//*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0)
							else
							{
								log("[weaponattachment] spawn SndVol Error");
							}
							break;
						case EST_Water:
							SndVol = Spawn(KFXEmitter_HitWater[FiringMode],,,mHitLocation + 2 * mHitNormal, Rotator(mHitNormal));
							if(SndVol!=none)
							SndVol.PlaySound(KFXSound_HitWater[SoundRnd], SLOT_None,
											TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
											TransientSoundRadius,,false);//*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0)
							else
							{
								log("[weaponattachment] spawn SndVol Error");
							}
							break;
						default:

							SndVol = Spawn(KFXEmitter_HitWall[FiringMode],,, mHitLocation+ 2 * mHitNormal, Rotator(mHitNormal));
							if ( DrawScorch )
							{
								Spawn(KFXScorch_HitWall[FiringMode],,,mHitLocation + 2 * mHitNormal, ScorchRot);
							}
							if(SndVol!=none)
							SndVol.PlaySound(KFXSound_HitWall[SoundRnd], SLOT_None,
											TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
											TransientSoundRadius,,false);//*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0)
							else
							{
								log("[weaponattachment] spawn SndVol Error");
							}
					}

				}
                TrackCoords = GetBoneCoords('BONE_Flash');
				TrackLocation = TrackCoords.Origin;
//				log("WeapAttachment------TrackLocation "$TrackLocation);
//				log("WeapAttachment------Location "$Location);
//				log("WeapAttachment------Instigator.Location "$Instigator.Location);

                if(VSize(TrackLocation) > 0.01)
				{
                }
                else
                {
				     TrackLocation = Location;//Instigator.Location + Instigator.EyePosition();
				     log("WeapAttachment------use weaponattachment.Location");
                }

                if(VSize(TrackLocation - Instigator.Location) > 500)
                {
                     TrackLocation = Instigator.Location;
                     log("WeapAttachment------use Instigator.Location");
                }
				if(bShowTrack)
				{
					if ( KFXPlayer(Instigator.Controller) == none && KFXPlayer(Level.GetLocalPlayerController()).bShowWeaponFireTrace && (KFXWeaponID >> 16)<41 )
					{
						if(TrackType == 0)
						{
						ExtraLoc.X = 50;
                        if(level.TimeSeconds - lastFireTraceTime > 0.18)
						{
							//////////////////////////////////////
							//Added by zhangrui -----ÐÞ¸ÄÀëÇ½¹ý½üÊ±ÎäÆ÷µ¯µÀ²»ÕýÈ·µÄBug
                            TrackRotator = Rotator(mHitLocation - TrackLocation);
                            TrackRotator.Yaw = Instigator.Rotation.Yaw;
                            Spawn(class'fx_effect_fire_track1',,, TrackLocation, TrackRotator);
							//////////////////////////////////////
                            //Spawn(class'fx_effect_fire_track1',,, TrackLocation, Rotator(mHitLocation - TrackLocation));
							lastFireTraceTime = level.TimeSeconds;
//							log("[zhangrui]WeapAttachment------TrackLocation = "$TrackLocation);
//							log("[zhangrui]WeapAttachment------Location = "$Location);
//							log("[zhangrui]WeapAttachment------Instigator.Location = "$Instigator.Location);
//							log("[zhangrui]WeapAttachment------mHitLocation = "$mHitLocation);
//							log("[zhangrui]WeapAttachment------mHitLocation - TrackLocation = "$Rotator(mHitLocation - TrackLocation));
//							log("[zhangrui]WeapAttachment------Instigator.Rotation = "$Instigator.Rotation);

						}
					}
						else if(TrackType == 1)
						{
							if(Instigator.Controller==none || (PlayerController(Instigator.Controller)!=none && PlayerController(Instigator.Controller).bbehindview))
							{
								log("KFXWeapAttachment fx_effect_laser_fire");
								if(TPEffect== none)
								{
								    TPEffect = Spawn(class'fx_effect_laser_fire',,, TrackLocation, Rotator(mHitLocation - TrackLocation));
									//ÉèÖÃÌØÐ§µÄ³¤¶È
									Dist = VSize(mHitLocation - TrackLocation);
									BeamEmitter(TPEffect.Emitters[0]).BeamDistanceRange.Min = Dist;
									BeamEmitter(TPEffect.Emitters[0]).BeamDistanceRange.Max = Dist;
									TPEffect = none;    //¼´Ê±ÌØÐ§²»ÒªÒ»Ö±´æÔÚTPEffectÖÐ
				}
								lastFireTraceTime = level.TimeSeconds;
							}
						}
						else if(TrackType == 2)
						{
							if(Instigator.Controller==none || (PlayerController(Instigator.Controller)!=none && PlayerController(Instigator.Controller).bbehindview))
							{
								log("KFXWeapAttachment fx_effect_laser_altfire");
								if(TPEffect== none)
								{
//								    TPEffect = Spawn(class'fx_effect_laser_altfire',,, TrackLocation, Rotator(mHitLocation - TrackLocation + ExtraLoc));
									AttachToBone(TPEffect,'Bone_flash');
								}
								//ÉèÖÃÌØÐ§µÄ³¤¶È
								Dist = VSize(mHitLocation - TrackLocation);
								BeamEmitter(TPEffect.Emitters[0]).BeamDistanceRange.Min = Dist;
								BeamEmitter(TPEffect.Emitters[0]).BeamDistanceRange.Max = Dist;
								lastFireTraceTime = level.TimeSeconds;
							}
						}
					}
				}
				CheckForSplash();

			}
		}

		// Weapon light
		if (KFXWeaponLight)
			WeaponLight();
	}
	// Play Reload (200 ~ 204)
	else if ( FlashCount >= 200 && FlashCount < 205 )
	{
       	log("[LABOR]---------flash count++");
		ThirdPersonPlayReload();
		FlashCount = 0;
		Instigator.FlashCount = 0;
	}
	else if(FlashCount>=220&&FlashCount<=225)//----ÇÐÇ¹
	{
		ThirdPersonSwitchStop();
		FlashCount = 0;
		Instigator.FlashCount = 0;
		if(Instigator!=none&&Instigator.Weapon!=none)
		KFXWeapBase(Instigator.Weapon).bIsReload=false;
	}
		// Zero Flash Count
	else
	{
		ThirdPersonStopFiring();
	}
}

// Replication for Reload
// server only
function IncrementReloadCount()
{
	if ( FlashCount >= 200 && FlashCount < 204 )
		FlashCount++;
	else
		FlashCount = 200;

	NetUpdateTime = Level.TimeSeconds - 1;
}
//ÇÐÇÀÊ±ÓÃµ½µÄflashcount
function IncrementSwitchCount()
{
	if(FlashCount>=220&&FlashCount<225)
		FlashCount++;
	else
		FlashCount=220;
	NetUpdateTime = Level.TimeSeconds - 1;
//   ThirdPersonEffects();
}

// Replication for Deploy & Undeploy
// server only
function ServerToggleDeploy(bool Deploy, optional float UserData)
{
	KFXWeaponDeployed = Deploy;
	KFXUserData = UserData;

	NetUpdateTime = Level.TimeSeconds - 1;
}

simulated function Tick(float DeltaTime)
{
	if(Level.NetMode != NM_DedicatedServer)
	{
		if ( KFXWeaponID <= 0 )
			return;
		if(!bInitToPawn)
		{
			if(Instigator != none && KFXPawn(Instigator) != none && Instigator.GetWeaponBoneFor(none) != '')
			{
				KFXInit();  // Init Attachment
				KFXPawn(Instigator).SetWeapAttachment(self);
				NotifyInitEnd();
				//RequestRecord(""$60$" "$KFXWeaponID);//RDN_InitID
				bInitToPawn = true;
			}
		}
		if( bInitToPawn && !bHideAlready && Instigator != none && KFXPawn(Instigator).KFXPawnCanHid() && KFXPawn(Instigator).KFXIsBitStateOn(EPB_Hide) )
		{
			KFXPawn(Instigator).ProcessMultiLevelHide(true);
			bHideAlready = true;
		}

		if(AltFirePlayOld != AltFirePlay)
		{
			AltFirePlayOld = AltFirePlay;
		}
		if(KFXWeaponDeployedOld != KFXWeaponDeployed)
		{
			if(KFXWeaponDeployed)
				NotifyWeaponDeploy();
			else
				NotifyWeaponUnDeploy();
			KFXWeaponDeployedOld = KFXWeaponDeployed;
		}

		if(self.KFXWeaponID == 65550)
		{
			log("sight skins"@self.ComAttachment[3].Skins[0]@self.ComAttachment[3].Skins[1]);
		}
		if(TrackType == 2 && level.TimeSeconds - LastFireSec > 0.15)
		{
			if(TPEffect != none)
			{
				DetachFromBone(TPEffect);
				TPEffect.Destroy();
			}
		}
	}
}

simulated function Vector GetTipLocation()
{
	local coords C;
	C = GetBoneCoords('tip');
	return C.Origin;
}

simulated function WeaponLight()
{
	if ( (FlashCount > 0) && !Level.bDropDetail && (Instigator != None)
		&& ((Level.TimeSeconds - LastRenderTime < 0.2) || (PlayerController(Instigator.Controller) != None)) )
	{
		if ( Instigator.IsFirstPerson() )
		{
			LitWeapon = Instigator.Weapon;
			LitWeapon.bDynamicLight = true;
		}
		else
			bDynamicLight = true;
		SetTimer(0.10, false);
	}
	else
		Timer();
}

simulated function Timer()
{
	if ( LitWeapon != None )
	{
		LitWeapon.bDynamicLight = false;
		LitWeapon = None;
	}
	bDynamicLight = false;
}

// Play Third Person Reload
// proxy client only
simulated function ThirdPersonPlayReload()
{
	local KFXPlayer localPlayer;
	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//if ( Instigator == none ||
	//     ( Instigator.IsLocallyControlled() && !PlayerController(Instigator.Controller).bBehindView ) )
	//    return;
	if ( Instigator == none ||
		 ( Instigator.IsLocallyControlled() && PlayerController(Instigator.Controller) != none && !PlayerController(Instigator.Controller).bBehindView ) )
		return;

	//>>
	/*localPlayer = KFXPlayer(level.GetLocalPlayerController());
	if(localPlayer.ViewTarget != Instigator)
	{
		// Play Reload Animation Here
		KFXPawnBase(Instigator).KFXPlayReload(self);
	}
	else
	{
		if(localPlayer.IsInState('spectating'))// && !localPlayer.bBehindView)
		{
			localPlayer.SpectateHook.ClientPlayReload();
		}
	} */

	if(!bInitToPawn)
	{
		log("[LABOR]-------------not init weaponattachment!");
		KFXInit();  // Init Attachment
		KFXPawn(Instigator).SetWeapAttachment(self);
		NotifyInitEnd();
		//RequestRecord(""$60$" "$KFXWeaponID);//RDN_InitID
		bInitToPawn = true;
	}

	KFXPawnBase(Instigator).KFXPlayReload(self);

	localPlayer = KFXPlayer(level.GetLocalPlayerController());
//    log("KFXWeapAttachment--ThirdPersonPlayReload---localPlayer.IsInState('spectating') "$localPlayer.IsInState('spectating'));
//    log("KFXWeapAttachment--ThirdPersonPlayReload---localPlayer.ViewTarget  "$localPlayer.ViewTarget );
//    log("KFXWeapAttachment--ThirdPersonPlayReload---Instigator "$Instigator);

	if(localPlayer.IsInState('spectating') && //!localPlayer.bBehindView &&
		 localPlayer.ViewTarget == Instigator)
	{
		localPlayer.SpectateHook.ClientPlayReload();
	}
}

// Play Fire Anim
// proxy client only
simulated function ThirdPersonPlayFiring()
{
	local bool bFirst;
	local KFXPlayer localPlayer;

	bFirst = ( Instigator == none ||
		 ( Instigator.IsLocallyControlled() && !PlayerController(Instigator.Controller).bBehindView ) );

	bFirst = false;
	if( !bFirst )
		PlayAnim(KFXTPAnimFire[FiringMode]);

	if(ComAttachment[0]!=none && ComAttachment[0].FireAnim!=''&& ComAttachment[0].FireAnim!='null')
		ComAttachment[0].PlayAnim(ComAttachment[0].FireAnim);


//    localPlayer = KFXPlayer(level.GetLocalPlayerController());
//    if(localPlayer.ViewTarget != Instigator)
//    {
//        KFXPawnBase(Instigator).KFXPlayFiring( self, FiringMode, bFirst );
//    }
//    else
//    {
//        if(localPlayer.IsInState('spectating') )//&& !localPlayer.bBehindView)
//        {
//          localPlayer.SpectateHook.ClientPlayFire(FiringMode);
//      }
//  }


	KFXPawnBase(Instigator).KFXPlayFiring( self, FiringMode, bFirst );
	localPlayer = KFXPlayer(level.GetLocalPlayerController());

//    log("KFXWeapAttachment--ThirdPersonPlayFiring---localPlayer.IsInState('spectating') "$localPlayer.IsInState('spectating'));
//    log("KFXWeapAttachment--ThirdPersonPlayFiring---localPlayer.ViewTarget  "$localPlayer.ViewTarget );
//    log("KFXWeapAttachment--ThirdPersonPlayFiring---Instigator "$Instigator);

	if(localPlayer.IsInState('spectating') && !localPlayer.bBehindView &&
		 localPlayer.ViewTarget == Instigator)
	{
		localPlayer.SpectateHook.ClientPlayFire(FiringMode);
	}

}

// Play Stop Firing Anim
// proxy client only
simulated function ThirdPersonStopFiring()
{
//    log("KFXWeapAttachment--ThirdPersonStopFiring---Instigator "$Instigator);
//    log("KFXWeapAttachment---ThirdPersonStopFiring--Instigator.IsLocallyControlled()  "$Instigator.IsLocallyControlled() );
//    log("KFXWeapAttachment--ThirdPersonStopFiring---PlayerController(Instigator.Controller).bBehindView "$PlayerController(Instigator.Controller).bBehindView);

	if ( Instigator == none ||
		 ( Instigator.IsLocallyControlled() && !PlayerController(Instigator.Controller).bBehindView ) )
		return;
//    log("KFXWeapAttachment-----ThirdPersonStopFiring");
	KFXPawnBase(Instigator).KFXStopFiring(self, FiringMode);
}
//--------------µÚÈýÈË³ÆÇÐÇ¹ÖÐ¶Ï½ÇÉ«ÉùÒô--add by wxb
simulated function ThirdPersonSwitchStop()
{
	if ( Instigator == none ||
		 ( Instigator.IsLocallyControlled() && !PlayerController(Instigator.Controller).bBehindView ) )
		return;
	KFXPawnBase(Instigator).KFXSwitchStop();
}
simulated function Destroyed()
{
	local int loop;
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( LitWeapon != none )
			LitWeapon.bDynamicLight = false;

		bDynamicLight = false;
		StopAnimating();
	}

	if( Role != ROLE_Authority || Level.NetMode == NM_Standalone )
	{
		for(loop =0; loop < 6; loop++)
		{
			if(ComAttachment[loop]!= none)
			{
				ComAttachment[loop].Destroy();
			}
		}
	}
	super.Destroyed();
}

simulated function SetComponent(int part,int CompntID)
{
	local KFXCSVTable CFG_Component;
	local name  BoneName;
	local vector  RelLocation;
	local rotator RelRotation;
	local string temstr;
	local int loop;

	if(CompntID == 0)
	{
		ComponentID[part-1] = 0;
		ComAttachment[part-1].Destroy();
		if( part == 6 )
		{
			skins.Remove(0,skins.length);
		}
		return;
	}
	CFG_Component  = class'KFXTools'.static.GetConfigTable(22);

	if( !CFG_Component.SetCurrentRow(CompntID))
	{
		log("[KFXWeapAttachment] wrong CompntID"@CompntID);
		ComponentID[part-1] = 0;
		ComAttachment[part-1].Destroy();
		return;
	}

	part = CFG_Component.GetInt("Part");
	ComponentID[part-1] = CompntID;
	if(ComAttachment[part-1]!= none)
	{
		ComAttachment[part-1].Destroy();
	}

	ComAttachment[part-1] = spawn(class'KFXAttachComponent',self);
	if(part == 6)
	{
		for(loop=0; true; loop++)
		{
			temstr = CFG_Component.GetString("TPViewSkin"$loop);
			if(temstr=="" || temstr == "null" )
			{
				break;
			}
			else if(temstr == "null")
			{
				continue;
			}
			else
			{
				Skins[loop]=Material(DynamicLoadObject(temstr,class'Material',false));
			}
		}
		return; //ºóÐø´¦Àí¶¼ÊÇ¶ÔÓÚÓÐÄ£ÐÍµÄ×é¼þ£¬ÓÉÓÚÅçÆáÎÞÄ£ÐÍ£¬ËùÒÔµ¥¶À´¦Àí£¬µ½´ËÎªÖ¹
	}

	ComAttachment[part-1].LinkMesh(Mesh(DynamicLoadObject(CFG_Component.GetString("TPViewMesh"),class'Mesh',false)));
	for(loop=0; true; loop++)
	{
		temstr = CFG_Component.GetString("TPViewSkin"$loop);
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
			ComAttachment[part-1].Skins[loop]=Material(DynamicLoadObject(temstr,class'Material',false));
		}
	}

	switch(part-1)
	{
		case 0: BoneName = 'BONE_FIRERISK';break;
		case 1: BoneName = 'BONE_INFRARED';break;
		case 2: BoneName = 'BONE_AGOGRIP';break;
		case 3: BoneName = 'BONE_SIGHT';break;
		case 4: BoneName = 'BONE_CARTRIDGES';break;
	}
	if(AttachToBone(ComAttachment[part-1],BoneName))
	{
		log("ThirdPerson Component Attach success");
	}

	RelLocation.X = CFG_Component.GetFloat("TPLocationX");
	RelLocation.Y = CFG_Component.GetFloat("TPLocationY");
	RelLocation.Z = CFG_Component.GetFloat("TPLocationZ");

	RelRotation.Pitch= CFG_Component.GetInt("TPRotPitch");
	RelRotation.Yaw  = CFG_Component.GetInt("TPRotYaw");
	RelRotation.Roll = CFG_Component.GetInt("TPRotRoll");

	ComAttachment[part-1].SetRelativeLocation( RelLocation);
	ComAttachment[part-1].SetRelativeRotation( RelRotation);
}

simulated function NotifyWeaponDeploy();
simulated function NotifyWeaponUnDeploy();

defaultproperties
{
     bShowTrack=是
     PutDownTime=0.010000
     LightType=LT_Pulse
     LightHue=32
     LightSaturation=120
     LightBrightness=220.000000
     LightRadius=10.000000
     LinkType=RLT_FPWeapon
     LinkData=RLD_Life
     SoundRadius=25.000000
     TransientSoundVolume=1.000000
     TransientSoundRadius=100.000000
     bNoRepMesh=是
}
