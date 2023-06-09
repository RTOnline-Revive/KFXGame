//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXRandPickup extends Pickup;

enum PickupType
{
	PickWeap,
	PickAmmo
};

var int PickupID;
var PickupType PickupTypeValue;
var actor PickupEffect;


///
///³õÊ¼»¯¿Í»§¶ËµôÂäÎïÆ·µÄÍâ¹Û
///
simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	;
	SetPhysics(PHYS_Falling);
	LinkMesh( Mesh(DynamicLoadObject("fx_weapon2_anims.mesh_MaxMbulletBag_3",class'Mesh',false)) );
	log("KFXRandPickUp-------KFXPlayer(Level.GetLocalPlayerController()) "$KFXPlayer(Level.GetLocalPlayerController()));
	if(Level.NetMode == NM_Client && KFXPlayer(Level.GetLocalPlayerController()) != none)
	{
		KFXPlayer(Level.GetLocalPlayerController()).ClientKnowPickUpSpawn();
	}
	if(level.NetMode == NM_Client )
	{
		PickupEffect = spawn(class'KFXEffects.bujixiang',,,Location);
		AttachToBone(PickupEffect,'');
	}
}



auto state Pickup
{
	///
	///Ö¸¶¨ÁËµôÂäÎïÆ·³ÖÐøµÄÊ±¼ä
	///
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
	}

	/* ValidTouch()
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/

	///
	///ÖØÔØÁËµôÂäÎïÆ·Ê°È¡µÄÂß¼­
	///
	function bool ValidTouch( actor Other )
	{
		local weapon newWeapon;
		if ( !super.ValidTouch(Other) )
		{
		   ;
		   return false;
		}
		;
		return true;
	}

	function Touch( actor Other )
	{
		local KFXWeapBase weap;
		local byte WeapGroup;
		local KFXCSVTable CFG_Weapon;
		local Vector X,Y,Z;
		local vector TossVel;
		local rotator PawnViewRot;
		local KFXWeapBase newWeap;
		local int newWeapType;

		CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);

		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			if( KFXPawn(Other)!=none && KFXPawn(Other).Controller != none)
			{
				switch(PickupTypeValue)
				{
				case PickWeap:
					if ( !CFG_Weapon.SetCurrentRow(PickupID) )
					{
						Log("[KFXRandPickup] Can't Resolve The Weapon ID (Attribute Table): "$PickupID);
						return;
					}
					WeapGroup = CFG_Weapon.GetInt("InvGroup");
					newWeapType = PickupID;
					newWeapType = newWeapType>>16;

					weap = KFXWeapBase(KFXPawn(Other).Inventory.WeaponChange(WeapGroup,true));


					if(Weap!= none)
					{
						PawnViewRot =  KFXPawn(Other).GetViewRotation();
						if(PawnViewRot.Pitch  > 32768)
							PawnViewRot.Pitch = 0;
						TossVel = Vector(PawnViewRot);

						if(KFXPawn(Other).GetViewRotation().Pitch < 32768)
						{
							 TossVel = (TossVel)* ((Other.Velocity dot TossVel) + 750);// + Vect(0,0,200);
						}
						else
						{
							TossVel = (TossVel)* ((Other.Velocity dot TossVel) + 1000) + Vect(0,0,200);
						}
						GetAxes(Other.Rotation,X,Y,Z);
						Weap.Velocity = TossVel;
						Weap.DropFrom(Other.Location + 0.8 * Other.CollisionRadius * X - 0.5 * Other.CollisionRadius * Y);

						log("WeapID"@Weap.KFXGetWeaponID()@"DropFrom pawn because of Randpickup"@PickupID);
					}

					log("Need to Drop Weap"@weap@"WeapGroup"@WeapGroup@"BCanThrow"@weap.bCanThrow);
					newWeap = class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Other), PickupID,,,,true);

					if(newWeapType>0 && newWeapType < 41)
					{
						newWeap.KFXSetAmmo(CFG_Weapon.GetInt("ShenghuaAmmo1"));
					}

				break;
		
				case PickAmmo:
					
					for(Weap = KFXWeapBase(KFXPawn(Other).Inventory); Weap != none; Weap = KFXWeapBase(Weap.Inventory) )
					{
						if(Weap.InventoryGroup == 1 || Weap.InventoryGroup == 2)
						{
							if ( !CFG_Weapon.SetCurrentRow(Weap.KFXGetWeaponID()) )
							{
								Log("[KFXRandPickup] Can't Resolve The Weapon ID (Attribute Table): "$Weap.KFXGetWeaponID());
								continue;
							}
		
							Weap.KFXSetAmmo(CFG_Weapon.GetInt("Ammo1"));
							Weap.KFXSetReload(CFG_Weapon.GetInt("ReloadMax1"));
						}
					}
				    
				break;
				}

				Destroy();

			}
		}
	}

}

function SetRespawn()
{
	;
	Destroy();
}

function inventory SpawnCopy( pawn Other )
{
	return none;
}

simulated function Destroyed()
{
	super.Destroyed();
	if(level.NetMode == NM_Client)
	{
		if(PickupEffect!=none)
			PickupEffect.Destroy();
	}
}
//---- add by jinxin 2011-12-26
 function int RandomAWeaponId()
 {
   return Rand(30)+65537; //¸ù¾Ýµ±Ç° WeaponAttribute.csv±í£¬Èç¹û±í±ä»¯ÔòÐèÒª±ä»¯¡£
 }
//----

defaultproperties
{
     MaxDesireability=0.500000
     bAmbientGlow=是
     bPredictRespawns=是
     CullDistance=6500.000000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1800.000000
     Texture=Texture'Engine.S_Weapon'
     DrawScale=0.300000
     AmbientGlow=128
     CollisionRadius=50.000000
     CollisionHeight=4.000000
     bNetNotify=是
     RotationRate=(Roll=32768)
     DesiredRotation=(Roll=16384)
}
