//-----------------------------------------------------------
//ÉÍ½ðÄ£Ê½×Óµ¯µ¯¼Ð  ËïÇ¿ 2010.9.4
//-----------------------------------------------------------
class KFXAmmoPickUp extends pickUp;

var float   TimetoFadeOut;
//==================pickupÔö¼ÓµÄ½ÇÉ«ÊôÐÔ===================
var int AttributeType;
var float AttributeValue[32];
//var Emitter ItemEffect;
//var Emitter PickupEffect;
//var Pawn PickupPawn;
var int     nTimerCount;
//var bool bHiddenEffect;
var int nAmmoBagValue;
var float fxAddAmmoRate;
//replication
//{
//    reliable if ( bNetDirty && (Role==ROLE_Authority) )
//         bHiddenEffect;
//}
//simulated function Tick(float DeltaTime)
//{
//	super.Tick(DeltaTime);
//    if(level.NetMode != NM_DedicatedServer)
//    {
//        if(ItemEffect.bHidden != bHiddenEffect)
//            ItemEffect.bHidden = bHiddenEffect;
//    }
//}
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

//    if(level.NetMode != NM_DedicatedServer)
//    {
//        ItemEffect=Spawn(class'KFXEffects.fx_effect_prophover1', self,,Location);
//    }
    if(Role == ROLE_Authority)
    {
//        if(KFXAIGame(Level.Game) != none)
//        {
//            if(KFXAIGame(Level.Game).GetAIGRI().AmmoToFadeOut > 0)
//            {
//                //ItemEffect=Spawn(class'KFXEffects.fx_effect_prophover1', self,,Location);
//                TimetoFadeOut = KFXAIGame(Level.Game).GetAIGRI().AmmoToFadeOut;
//            }
//            fxAddAmmoRate = KFXAIGame(Level.Game).GetAIGRI().fxAddAmmoRate;
//            nAmmoBagValue = KFXAIGame(Level.Game).GetAIGRI().nAmmoBagValue;
//        }
    }
//    LOG("[KFXAmmoPickUp]  fxAddAmmoRate"$fxAddAmmoRate);
//    LOG("[KFXAmmoPickUp]  nAmmoBagValue"$nAmmoBagValue);
//    LOG("[KFXAmmoPickUp]  TimetoFadeOut"$TimetoFadeOut);
}

function SetRespawn()
{
//    if( Level.Game.ShouldRespawn(self) )
//        StartSleeping();
//	else
		Destroy();
		log("KFXAmmoPickUp-----Destroy");
}

//simulated function Destroyed()
//{
//    if(level.NetMode!=NM_DedicatedServer)
//        PickupEffect=Spawn(class'fx_effect_pickup1',,,Location);
//    if( ItemEffect != none )
//    {
//        ItemEffect.Destroy();
//    }
//    super.Destroyed();
//}
auto state Pickup
{
	function BeginState()
	{
	    UntriggerEvent(Event, self, None);
	    SetTimer(1, true);
	    nTimerCount = 0;
	}

	/* ValidTouch()
	 Validate touch (if valid return true to let other pick me up and trigger event).
	*/
	function bool ValidTouch( actor Other )
	{
	    if ( !super.ValidTouch(Other) )
	    {
	       ;
           return false;
        }
        ;
//        if( KFXPawn(Other)!=none )
//        {
//            log("KFXAmmoPickUp----KFXWeapBase(KFXPawn(Other).Weapon).KFXGetAmmo() ="$KFXWeapBase(KFXPawn(Other).Weapon).KFXGetAmmo()
//            $"KFXWeapBase(KFXPawn(Other).Weapon).KFXGetAmmoMax(0)  ="$KFXWeapBase(KFXPawn(Other).Weapon).KFXGetAmmoMax(0)
//            $"KFXWeapBase(KFXPawn(Other).Weapon).KFXGetReload()  ="$KFXWeapBase(KFXPawn(Other).Weapon).KFXGetReload()
//            $"KFXWeapBase(KFXPawn(Other).Weapon).KFXGetReloadMax() ="$KFXWeapBase(KFXPawn(Other).Weapon).KFXGetReloadMax());
//
//            if(KFXWeapBase(KFXPawn(Other).Weapon).KFXGetAmmo() >=
//                KFXWeapBase(KFXPawn(Other).Weapon).KFXGetAmmoMax(0) * fxAddAmmoRate)
//               //KFXWeapBase(KFXPawn(Other).Weapon).KFXGetReload()==
//               //KFXWeapBase(KFXPawn(Other).Weapon).KFXGetReloadMax() )
//                   return false;
//
//            UpdatedWeaponAttribute( KFXWeapBase(KFXPawn(Other).Weapon) );
//            return true;
//        }
        return false;
	}
	function Timer()
	{
        nTimerCount++;

        if(nTimerCount >= TimeToFadeOut)
        {
           SetRespawn();
           log("KFXAmmoPickUp---Pickup---SetRespawn");
        }
    }
}

//state Sleeping
//{
//	ignores Touch;
//
//	function bool ReadyToPickup(float MaxWait)
//	{
//		return ( bPredictRespawns && (LatentFloat < MaxWait) );
//	}
//
//	function StartSleeping() {}
//
//	function BeginState()
//	{
//		local int i;
//
//        log("KFXAmmoPickUp----BeginState");
//		SetTimer(1,true);
//        NetUpdateTime = Level.TimeSeconds - 1;
//		bHidden = true;
//		bHiddenEffect = bHidden;
//
//		for ( i=0; i<4; i++ )
//			TeamOwner[i] = None;
//	}
//
//	function EndState()
//	{
//		NetUpdateTime = Level.TimeSeconds - 1;
//		bHidden = false;
//		bHiddenEffect = bHidden;
//	}
//    function Timer()
//    {
////       if(KFXAIGame(Level.Game) != none)
////       {
////           if(KFXAIGame(Level.Game).bRestartRound)
////           {
////                RespawnEffect();
////                if (PickUpBase != None)
////            		PickUpBase.TurnOn();
////                GotoState('Pickup');
////                log("KFXAmmoPickUp----Respawn");
////           }
////       }
//    }
//Begin:
//Respawn:
//}

function UpdatedWeaponAttribute(  KFXWeapBase weapon )
{
    local int index;
    for( index = 0; index<32; index++ )
    {
        if( ( 1<<index & AttributeType ) == 1 )
        {
            SetWeaponAttribute( index, weapon );
        }
    }
}

function SetWeaponAttribute( int Index, KFXWeapBase weapon )
{
    switch( Index )
    {
        case 0:
            if(weapon.InventoryGroup==1 || weapon.InventoryGroup==2)
            {

               if(weapon.KFXGetAmmo() + nAmmoBagValue >= fxAddAmmoRate * weapon.KFXGetAmmoMax(0))
                      weapon.KFXSetAmmo(fxAddAmmoRate * weapon.KFXGetAmmoMax(0));
               else
                      weapon.KFXSetAmmo(weapon.KFXGetAmmo() + nAmmoBagValue);
               //weapon.KFXSetAmmo(weapon.KFXGetAmmoMax(0));
               //weapon.KFXSetReload(weapon.KFXGetReloadMax());
               //nAmmoBagValue
            }
        break;
    }

}

function inventory SpawnCopy( pawn Other )
{
    return none;
}

defaultproperties
{
     TimetoFadeOut=150.000000
     AttributeType=1
     AttributeValue(0)=100.000000
     fxAddAmmoRate=3.000000
     MaxDesireability=0.500000
     bAmbientGlow=是
     bPredictRespawns=是
     RespawnTime=1.000000
     CullDistance=6500.000000
     Physics=PHYS_Rotating
     Mesh=SkeletalMesh'fx_weapon2_anims.mesh_MbulletBag_3rd'
     DrawScale=0.270000
     AmbientGlow=128
     CollisionRadius=100.000000
     CollisionHeight=80.000000
     RotationRate=(Yaw=32768)
}
