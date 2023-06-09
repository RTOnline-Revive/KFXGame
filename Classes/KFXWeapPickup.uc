// ====================================================================
//  Class:  KFXGame.KFXWeapPickup
//  Creator: Kevin Sun
//  Date: 2007.06.30
//  Description: Base class of all kfx weapon pickups
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXWeapPickup extends WeaponPickup
	  placeable;

var float   TimetoFadeOut;
var bool    KFXNotifyCannotPickup;

const KFX_MAX_ACCESSORY_NUM = 7;       // Åä¼þÊýÁ¿

var int KFXWeaponID;
var protected int KFXReloadCount[2];
var protected int KFXAmmoCount[2];
var protected int KFXAccessoryID[KFX_MAX_ACCESSORY_NUM];
var int ComponentID[6];
var KFXAttachComponent ComAttachment[6];
var private bool KFXInitialized;
var bool bNeedLandEffect;

var private sound KFXRifleGroundSounds[4];
var private sound KFXPistalGroundSounds[4];

var protected byte KFXOldHasCartridgeClip[2];       // ÅÐ¶ÏÖ®Ç°µÄÊ¹ÓÃÕßÊÇ·ñ×°±¸µ¯¼Ð¿¨

var int WeapDurable;
var vector RelLocation;
var rotator RelRotation;

replication
{
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority )
	   KFXWeaponID, KFXAccessoryID,ComponentID;
}


// Get Weapon ID
simulated function int KFXGetWeaponID()
{
	return KFXWeaponID;
}

function KFXNoInvInit(int WeapID)
{
	local int loop;
	local KFXCSVTable CFG_GunExplain,CFG_WeapAttr;
	local array<int> Ids;


	CFG_GunExplain = class'KFXTools'.static.GetConfigTable(55);
	CFG_WeapAttr = class'KFXTools'.static.GetConfigTable(11);

	SetPhysics(PHYS_Falling);
	GotoState('FallingPickup');

	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
	bNeedLandEffect = false;
	LifeSpan = 0.0;
	RespawnTime = 0.0;
	bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
	NetUpdateFrequency = 8;
	WeapDurable = 10000;

	KFXWeaponID = WeapID;

	WeapDurable = 10000;
	if( !CFG_GunExplain.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve KFXWeaponID (WeaponGunExplain table): "$KFXWeaponID);
		return;
	}

	for(loop=0; loop< 6; loop++)
	{
		ComponentID[loop] = CFG_GunExplain.GetInt("DefComponent"$(loop+1));
	}

	if( !CFG_WeapAttr.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve KFXWeaponID (WeaponAttribute table): "$KFXWeaponID);
		return;
	}

	KFXReloadCount[0] = CFG_WeapAttr.GetInt("ReloadMax1");
	KFXAmmoCount[0] = CFG_WeapAttr.GetInt("Ammo1");
	KFXReloadCount[0] = CFG_WeapAttr.GetInt("ReloadMax2");
	KFXAmmoCount[0] = CFG_WeapAttr.GetInt("Ammo2");

	for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
	{
		KFXAccessoryID[loop] = CFG_WeapAttr.GetInt("Accessory"$loop);
	}

	//¶ÔÓÚcsgame  Ê¹ÓÃ¾ÉµÄ·½Ê½½øÐÐ³õÊ¼»¯
	Ids[0] = WeapID;
	Ids[1] = KFXAccessoryID[0];
	csvConfig(Ids);

	;
}

function KFXInitWithBase(int WeapID)
{
	local int loop;
	local KFXCSVTable CFG_GunExplain,CFG_WeapAttr;
	local array<int> Ids;


	CFG_GunExplain = class'KFXTools'.static.GetConfigTable(55);
	CFG_WeapAttr = class'KFXTools'.static.GetConfigTable(11);
	
	SetPhysics(PHYS_Rotating); 
    RotationRate.Yaw = 32768;
    RotationRate.pitch = 0;
    RotationRate.Roll = 0;

	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
	bNeedLandEffect = false;
	LifeSpan = 0.0;
	RespawnTime = 0.0;
	bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
	NetUpdateFrequency = 8;
	WeapDurable = 10000;

	KFXWeaponID = WeapID;

	WeapDurable = 10000;
	if( !CFG_GunExplain.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve KFXWeaponID (WeaponGunExplain table): "$KFXWeaponID);
		return;
	}

	for(loop=0; loop< 6; loop++)
	{
		ComponentID[loop] = CFG_GunExplain.GetInt("DefComponent"$(loop+1));
	}

	if( !CFG_WeapAttr.SetCurrentRow(KFXWeaponID) )
	{
		Log("[KFXWeaponBase] Can't Resolve KFXWeaponID (WeaponAttribute table): "$KFXWeaponID);
		return;
	}

	KFXReloadCount[0] = CFG_WeapAttr.GetInt("ReloadMax1");
	KFXAmmoCount[0] = CFG_WeapAttr.GetInt("Ammo1");
	KFXReloadCount[0] = CFG_WeapAttr.GetInt("ReloadMax2");
	KFXAmmoCount[0] = CFG_WeapAttr.GetInt("Ammo2");

	for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
	{
		KFXAccessoryID[loop] = CFG_WeapAttr.GetInt("Accessory"$loop);
	}

	//¶ÔÓÚcsgame  Ê¹ÓÃ¾ÉµÄ·½Ê½½øÐÐ³õÊ¼»¯
	Ids[0] = WeapID;
	Ids[1] = KFXAccessoryID[0];
	csvConfig(Ids);

	;
}



// KFXWeapPickup Initialize
// Client Only
simulated function KFXInit()
{
	local KFXCSVTable CFG_Component;
	local string TexString;
	local int loop,loop1;
	local name BoneName;
	local string temstr;
	local vector ComRelLocation;
	local rotator ComRelRotation;
	//×é¼þÄ£ÐÍ
	CFG_Component      = class'KFXTools'.static.GetConfigTable(22);
	for(loop = 0; loop < 6; loop++)
	{
		if( ComponentID[loop] != 0 )
		{
			CFG_Component.SetCurrentRow(ComponentID[loop]);
			ComAttachment[loop] = spawn(class'KFXAttachComponent',self);

			//ÅçÆá²»ÐèÒªÄ£ÐÍ,Ö»ÐèÒªÌùÍ¼£¬µ«ÊÇ×é¼þ¶ÔÏóÒª±£Áô£¬ÒòÎª´æÔÚÒ»Ð©ÎäÆ÷ÐÔÄÜÊôÐÔÉÏµÄÐÞ¸Ä
			if(loop == 5)
			{
				for(loop1=0; true; loop1++)
				{
					TexString = CFG_Component.GetString("TPViewSkin"$loop1);
					if(TexString=="")
					{
						break;
					}
					else if(TexString == "null")
					{
						continue;
					}
					else
					{
						Skins[loop1]=Material(DynamicLoadObject(TexString,class'Material',false));
					}
				}
				continue;
			}

			ComAttachment[loop].LinkMesh(Mesh(DynamicLoadObject(CFG_Component.GetString("TPViewMesh"),class'Mesh',false)));

			//Èç¹ûÅäÖÃÁËÌùÍ¼£¬ÄÇÃ´¾Í²»Ê¹ÓÃÄ¬ÈÏÌùÍ¼
			for(loop1=0; true; loop1++)
			{
				temstr = CFG_Component.GetString("TPViewSkin"$loop1);
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
					ComAttachment[loop].Skins[loop1]=Material(DynamicLoadObject(temstr,class'Material',false));
					if ( loop1 == 0)
					   ComAttachment[loop].RequestRecord(""$"5 "$ComAttachment[loop].Skins[0]);
					if ( loop1 == 1 )
					   ComAttachment[loop].RequestRecord(""$"6 "$ComAttachment[loop].Skins[1]);
				}
			}

			switch(loop)
			{
				case 0: BoneName = 'BONE_FIRERISK';break;
				case 1: BoneName = 'BONE_INFRARED';break;
				case 2: BoneName = 'BONE_AGOGRIP';break;
				case 3: BoneName = 'BONE_SIGHT';break;
				case 4: BoneName = 'BONE_CARTRIDGES';break;
			}
			if(AttachToBone(ComAttachment[loop],BoneName))
			{
				log("ThirdPerson Component Attach success");
			}

			ComRelLocation.X = CFG_Component.GetFloat("TPLocationX");
			ComRelLocation.Y = CFG_Component.GetFloat("TPLocationY");
			ComRelLocation.Z = CFG_Component.GetFloat("TPLocationZ");

			ComRelRotation.Pitch= CFG_Component.GetInt("TPRotPitch");
			ComRelRotation.Yaw  = CFG_Component.GetInt("TPRotYaw");
			ComRelRotation.Roll = CFG_Component.GetInt("TPRotRoll");

			ComAttachment[loop].SetRelativeLocation( ComRelLocation);
			ComAttachment[loop].SetRelativeRotation( ComRelRotation);
		}

	}

	BoneRefresh();

	if ( Skins.length>0 )
	   RequestRecord(""$"5 "$Skins[0]);
	if ( Skins.length>1 )
	   RequestRecord(""$"6 "$Skins[1]);



}
simulated function csvConfig(array<int> ids)
{
	KFXWeaponID = Ids[0];
	KFXAccessoryID[0] = Ids[1];
	log("kfxweapbase CSVConfig"$KFXWeaponID$"KFXAccessoryID[0]"$KFXAccessoryID[0]);
	csvKFXInit();
}
simulated function csvKFXInit()
{
	local KFXCSVTable CFG_Attachment, CFG_Accessory, CFG_Media, CFG_Sound,CFG_Component;
	local int SoundIndex;
	local string MeshName, MaterialName, SkelName;
	local bool bManuFixed;
	local string TexString;
	local Material mat;
	local int loop,loop1;
	local name BoneName;
	local string temstr;


	;
	CFG_Accessory  = class'KFXTools'.static.GetConfigTable(13);
	CFG_Attachment = class'KFXTools'.static.GetConfigTable(17);
	CFG_Media      = class'KFXTools'.static.GetConfigTable(10);
	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);

	// Setup Pickup
	if ( !CFG_Attachment.SetCurrentRow(KFXWeaponID) )
	{
		Log("[Kevin] Can't Resolve the Weapon ID(Attachment Table) :"$KFXWeaponID );
		return;
	}

	// Pickup Sound
	if ( CFG_Media.SetCurrentRow(KFXWeaponID) )
	{
		SoundIndex = CFG_Media.GetInt("SndPickup");

		if ( SoundIndex != 0 && CFG_Sound.SetCurrentRow(SoundIndex) )
		{
			PickupSound =
				Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
		}
	}
	DrawScale = CFG_Attachment.GetFloat("DrawScale");
	//SetDrawScale(  );

	// Init the Accessory Meshes
	if ( !CFG_Accessory.SetCurrentRow(KFXAccessoryID[0]) )
	{
		Log("[Kevin] Can't Resolve the TP Main Accessory ID:"$KFXAccessoryID[0] );
		return;
	}
	MeshName     = CFG_Accessory.GetString("TPMesh");
	MaterialName = CFG_Accessory.GetString("TPMaterial");
	SkelName     = CFG_Accessory.GetString("TPSkeleton");

	bManuFixed = CFG_Accessory.GetBool("ManuFix");

	LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );

	if(bManuFixed)
	{
		log("[WeaponPickUp] manufixed skins");
		for( loop=0; loop<12; loop++ )
		{
			TexString = "TPMaterial"$loop;
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
			}
		}
	}

	BoneRefresh();

	;
}

// Tick for Initialize
// Client Only
simulated function Tick(float DeltaTime)
{
	if(Level.NetMode != NM_DedicatedServer)
	{
		if( !KFXInitialized )
		{
			KFXInit();
			KFXInitialized = true;
		}
	}
}

// Don't allow repeat pickup in MAT
function bool AllowRepeatPickup()
{
	return false;
}

// Set Dropped Pickup Item Info
function InitDroppedPickupFor(Inventory Inv)
{
	local int loop;
	;
	// From Pickup
	SetPhysics(PHYS_Falling);
	GotoState('FallingPickup');
	Inventory = Inv;
	bAlwaysRelevant = false;
	bOnlyReplicateHidden = false;
	bUpdateSimulatedPosition = true;
	bDropped = true;
	if(KFXWeapBase(Inv).KFXGetWeaponID()==1 || KFXGameInfo(level.Game).bPickupControll)
	{
		LifeSpan = 0;
		TimetoFadeOut = 0;
	}
	else
		LifeSpan = 12;
	bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
	NetUpdateFrequency = 8;

	// for KFXWeapPickup
	if ( KFXWeapBase(Inv) == none )
		return;

	// Get Weapon Infomation
	KFXWeaponID = KFXWeapBase(Inv).KFXGetWeaponID();
	WeapDurable = KFXWeapBase(Inv).WeapDurable;


	for(loop =0; loop <6 ; loop++)
	{
		if( KFXWeapBase(Inv).KFXWeapComponent[loop] != none )
		{
			ComponentID[loop] = KFXWeapBase(Inv).KFXWeapComponent[loop].ComponentTypeID;
			ComAttachment[loop] = Spawn(class'KFXAttachComponent',self);

			ComAttachment[loop].KFXAmmoCount[0] = KFXWeapBase(Inv).KFXWeapComponent[loop].KFXAmmoCount[0];
			ComAttachment[loop].KFXAmmoCount[1] = KFXWeapBase(Inv).KFXWeapComponent[loop].KFXAmmoCount[1];
		}
		else
		{
			ComponentID[loop] = 0;
		}
	}

	KFXWeapBase(Inv).KFXSetFireGroup(0);
	KFXReloadCount[0] = KFXWeapBase(Inv).KFXGetReload();
	KFXAmmoCount[0] = KFXWeapBase(Inv).KFXGetAmmo();

	if ( !KFXWeapBase(Inv).KFXIsShareAmmo() )
	{
		KFXWeapBase(Inv).KFXSetFireGroup(1);
		KFXReloadCount[1] = KFXWeapBase(Inv).KFXGetReload();
		KFXAmmoCount[1] = KFXWeapBase(Inv).KFXGetAmmo();
	}

	// ±£´æÕâ°ÑÎäÆ÷Ö®Ç°µÄÊ¹ÓÃÕßÊÇ·ñ×°±¸µ¯¼Ð¿¨
	KFXOldHasCartridgeClip[0] = KFXWeapBase(Inv).KFXGetHasCartridgeClip(0);
	KFXOldHasCartridgeClip[1] = KFXWeapBase(Inv).KFXGetHasCartridgeClip(1);

	for ( loop = 0; loop < KFX_MAX_ACCESSORY_NUM; loop++ )
	{
		KFXAccessoryID[loop] = KFXWeapBase(Inv).KFXAccessory[loop];
	}
	;
}

// reset
simulated function Reset()
{
	KFXWeaponID = 0;
	KFXInitialized = false;
	Destroy();
}

// Either give this inventory to player Other, or spawn a copy
// and give it to the player Other, setting up original to be respawned.
//
function inventory SpawnCopy( pawn Other )
{
	local KFXWeapBase wpn;
	local int loop;
	local int WeapType;

	if ( KFXPawn(Other) == none )
	{
		log("[Weapon] Pickup Error: KFXWeapPickup Can't Spawn Copy for non - KFXPawn!");
		return none;
	}

	log("[Weapon] Pickup Spawn Copy:"$self);

	wpn = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Other), KFXWeaponID,0,0,ComponentID);
	WeapType = KFXWeaponID/65536;
	if(WeapType > 0 && WeapType < 41)
	{
		wpn.KFXServerDurableFact(WeapDurable );
	}

	if ( wpn == none )
	{
		log("[Weapon] Pickup Error: Invalid Weapon ID:"$KFXWeaponID);
		return none;
	}

	for(loop =0; loop < 6; loop++ )
	{
		if( ComAttachment[loop]!= none )
		{
			wpn.KFXWeapComponent[loop].KFXAmmoCount[0] = ComAttachment[loop].KFXAmmoCount[0];
			wpn.KFXWeapComponent[loop].KFXAmmoCount[1] = ComAttachment[loop].KFXAmmoCount[1];
		}
	}

	wpn.KFXSetFireGroup(0);
	wpn.KFXSetReload(KFXReloadCount[0]);
	wpn.KFXSetAmmo(KFXAmmoCount[0]);

	if ( !wpn.KFXIsShareAmmo() )
	{
		wpn.KFXSetFireGroup(1);
		wpn.KFXSetReload(KFXReloadCount[1]);
		wpn.KFXSetAmmo(KFXAmmoCount[1]);
		wpn.KFXSetFireGroup(0);
	}

	KFXSetAmmoInfo(Other, wpn);
	return wpn;
}

state Pickup
{
	function BeginState()
	{
		UntriggerEvent(Event, self, None);
		log("KFXWeaponPickUp----bDropped");
		if ( bDropped )
		{
			AddToNavigation();
			SetTimer(TimetoFadeOut, false);
		}
	}

	/* ValidTouch()
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( actor Other )
	{
		log("KFXWeaponPickUp----ValidTouch");
		if ( !super.ValidTouch(Other) )
		{
		   ;
		   return false;
		}
		if(KFXPawn(Other) != none)
		{
			;

			//¸Ã±äÁ¿Ö»ÊÇÓÃÀ´´¦ÀíµÀ¾ß¿¨Æ¬µÄ¼ñÇ¹¿¨
			if ( KFXPawn(Other).KFXCanPickupWeapon )
			{
				return true;
			}
		}

		// TODO: ÐèÒªÓÅ»¯µ÷ÓÃ´ÎÊý
		if ( KFXNotifyCannotPickup )
			KFXPawn(Other).KFXNotifyCannotPickupWeapon();
		log("KFXWeaponPickUp----return false");
		return false;
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	function CheckTouching()
	{
		local Pawn P;

		KFXNotifyCannotPickup = false;

		ForEach TouchingActors(class'Pawn', P)
			Touch(P);

		KFXNotifyCannotPickup = true;
	}

Begin:
	CheckTouching();
	Sleep(0.8);
	goto('Begin');
}

// ÆÁ±ÎÐý×ªfadeout
state FadeOut
{
	ignores Touch;

	function Tick(float DeltaTime)
	{
		//SetDrawScale(FMax(0.01, DrawScale - Default.DrawScale * DeltaTime));
	}

	function BeginState()
	{
		//RotationRate.Yaw=60000;
		//SetPhysics(PHYS_Rotating);
		//LifeSpan = 1.0;
	}

	function EndState()
	{
		//LifeSpan = 0.0;
		//SetDrawScale(Default.DrawScale);
		//if ( Physics == PHYS_Rotating )
		//  SetPhysics(PHYS_None);
	}

	function bool ReadyToPickup(float MaxWait)
	{
		return false;
	}
}

state FallingPickup
{
	/* ValidTouch()
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( actor Other )
	{
		log("FallingPickUp----ValidTouch");
		if ( !super.ValidTouch(Other) )
		   return false;
		log("FallingPickUp----KFXPawn(Other).KFXCanPickupWeapon"$KFXPawn(Other).KFXCanPickupWeapon);
		if ( KFXPawn(Other) != none && KFXPawn(Other).KFXCanPickupWeapon )
		{
			return true;
		}
		log("FallingPickUp----KFXPawn(Other).KFXCanPickupWeapon"$KFXPawn(Other).KFXCanPickupWeapon);
		return false;
	}


		// °ïÖúÏûÏ¢£º¹ã²¥Õ¨µ¯°²×°ÏûÏ¢
//    BroadcastLocalizedMessage(class'KFXGameMessage', 31, P.PlayerReplicationInfo);

}

simulated event Landed(Vector HitNormal)
{
	local rotator newRot;
	local vector TraceEnd, TraceStart, Loc, Normal;
	local material mat;
	local int SurType;
	local KFXPawn p;

	;

	super.Landed(HitNormal);

	RotationRate.Roll=0;
	newRot = Rotation;
	newRot.Roll = 16384;
	newRot.Pitch = 0;
	SetRotation(newRot);

	if ( Level.NetMode != NM_DedicatedServer )
	{
		SurType = 0;
		TraceStart = Location;
		TraceEnd = TraceStart + vect(0,0,-1) * (CollisionHeight + 10);

		Trace(Loc, Normal, TraceEnd, TraceStart, false,, mat);

		if ( mat != none )
		{
			if ( mat.SurfaceType == EST_Metal )
			{
				SurType = 1;
			}
			else if ( mat.SurfaceType == EST_Wood )
			{
				SurType = 2;
			}
			else if ( mat.SurfaceType == EST_Water )
			{
				SurType = 3;
			}
		}

		if(bNeedLandEffect)
		{
			if ( (KFXWeaponID >> 16) == 1 )
				PlaySound(KFXRifleGroundSounds[SurType], SLOT_Misc,
						1.0*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
						250*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false);
			else
				PlaySound(KFXPistalGroundSounds[SurType], SLOT_Misc,
				1.0*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
				250*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false);
			if(SurType == 3)
			{
				Spawn(class'KFXEffects.fx_effect_onwater', self,,Loc);
			}
		}

		if(self.Role==ROLE_Authority)
		return;
	}
	else
	{
		// °ïÖúÏûÏ¢£º¹ã²¥Õ¨µ¯°²×°ÏûÏ¢
		if(KFXWeaponID == 1)
		BroadcastLocalizedMessage(class'KFXGameMessage', 61, P.PlayerReplicationInfo);
	}

	;

}

function KFXSetAmmoInfo(pawn Other, KFXWeapBase wpn)
{
	local KFXCSVTable CFG_Weapon;
	local int WeapType[2];
//  local int ReloadNum;
//  local int ReloadMax;
	local int FireGroup;

	if ( Other == none )
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

	Switch( WeapType[0] )
	{
		case 2: // ³å·æ
			// Ê°Ç¹µÄÍæ¼ÒÃ»ÓÐ×°±¸µ¯¼Ð¿¨
			if ( KFXPawn(Other).fxChargeCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 3: // Í»»÷²½Ç¹
			if ( KFXPawn(Other).fxShockCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 4: // ¾Ñ»÷Ç¹
			if ( KFXPawn(Other).fxSnipeCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 5: // Çá»úÇ¹
			if ( KFXPawn(Other).fxLightCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 6: // ÖØ»úÇ¹
			if ( KFXPawn(Other).fxHeavyCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 7: // Áñµ¯ÅÚ
			if ( KFXPawn(Other).fxHowitzerCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 8:
			if ( KFXPawn(Other).fxBazookaCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 9: // ÊÖÇ¹
			if ( KFXPawn(Other).fxPistolCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
		case 11: // É¢µ¯Ç¹
			if ( KFXPawn(Other).fxShotCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[0] == 1 )
				{
					if ( KFXReloadCount[0] > wpn.KFXGetInitReload(0) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(0));
					}
					if ( KFXAmmoCount[0] > wpn.KFXGetInitAmmo(0) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(0));
					}
				}
			}
			break;
	}

	if ( wpn.KFXIsShareAmmo() )
	{
		return;
	}

	FireGroup = wpn.KFXGetFireGroup();
	if ( FireGroup == 0 )
	{
		wpn.KFXSetFireGroup(1);
	}
	Switch( WeapType[1] )
	{
		case 2: // ³å·æ
			// Ê°Ç¹µÄÍæ¼ÒÃ»ÓÐ×°±¸µ¯¼Ð¿¨
			if ( KFXPawn(Other).fxChargeCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 3: // Í»»÷²½Ç¹
			if ( KFXPawn(Other).fxShockCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 4: // ¾Ñ»÷Ç¹
			if ( KFXPawn(Other).fxSnipeCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 5: // Çá»úÇ¹
			if ( KFXPawn(Other).fxLightCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 6: // ÖØ»úÇ¹
			if ( KFXPawn(Other).fxHeavyCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 7: // Áñµ¯ÅÚ
			if ( KFXPawn(Other).fxHowitzerCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 8:
			if ( KFXPawn(Other).fxBazookaCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 9: // ÊÖÇ¹
			if ( KFXPawn(Other).fxPistolCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
		case 11: // É¢µ¯Ç¹
			if ( KFXPawn(Other).fxShotCartridgeClip <= 0 )
			{
				if ( KFXOldHasCartridgeClip[1] == 1 )
				{
					if ( KFXReloadCount[1] > wpn.KFXGetInitReload(1) )
					{
						wpn.KFXSetReload(wpn.KFXGetInitReload(1));
					}
					if ( KFXAmmoCount[1] > wpn.KFXGetInitAmmo(1) )
					{
						wpn.KFXSetAmmo(wpn.KFXGetInitAmmo(1));
					}
				}
			}
			break;
	}
	wpn.KFXSetFireGroup(FireGroup);
}

simulated function Destroyed()
{
	local int loop;
	for(loop =0; loop < 6; loop++)
	{
		if(ComAttachment[loop]!= none)
		{
			ComAttachment[loop].Destroy();
		}
	}
	super.Destroyed();
}

defaultproperties
{
     TimetoFadeOut=12.000000
     KFXNotifyCannotPickup=是
     bNeedLandEffect=是
     KFXRifleGroundSounds(0)=Sound'fx_wpncommon_sounds.rifle.rifle_dropgeneral1'
     KFXRifleGroundSounds(1)=Sound'fx_wpncommon_sounds.rifle.rifle_dropmetal1'
     KFXRifleGroundSounds(2)=Sound'fx_wpncommon_sounds.rifle.rifle_dropwood1'
     KFXRifleGroundSounds(3)=Sound'fx_wpncommon_sounds.rifle.rifle_dropwater1'
     KFXPistalGroundSounds(0)=Sound'fx_wpncommon_sounds.pistol.pistol_dropgeneral1'
     KFXPistalGroundSounds(1)=Sound'fx_wpncommon_sounds.pistol.pistol_dropmetal1'
     KFXPistalGroundSounds(2)=Sound'fx_wpncommon_sounds.pistol.pistol_dropwood1'
     KFXPistalGroundSounds(3)=Sound'fx_wpncommon_sounds.pistol.pistol_dropwater1'
     InventoryType=Class'KFXGame.KFXWeapBase'
     bOrientOnSlope=否
     Physics=PHYS_None
     RemoteRole=ROLE_SimulatedProxy
     CollisionRadius=50.000000
     CollisionHeight=4.000000
     RotationRate=(Roll=32768)
     DesiredRotation=(Roll=16384)
}
