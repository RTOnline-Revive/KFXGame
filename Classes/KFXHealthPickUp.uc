//-----------------------------------------------------------
// »ØÑª°ü
//-----------------------------------------------------------
class KFXHealthPickUp extends PickUp;

var float   TimetoFadeOut;
var int     nTimerCount;

function SetRespawn()
{

	Destroy();
	log("KFXHealthPickUp-----Destroy");
}


simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if(Role == ROLE_Authority)
    {
    }
    ;
}

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
        //Íæ¼ÒÈ±Ñª²¢ÇÒÃ»ÓÐÖØ¸´¼ñÑª°üµÄÇé¿öÏÂ²ÅÄÜ¼ñÆðÑª°ü
        log("KFXHealthPickUp----Other: "$Other);
        log("KFXHealthPickUp-----KFXPawn(Other).health ="$KFXPawn(Other).health);

        if(KFXPawn(Other) != none)
        {
            log("KFXHealthPickUp-----KFXPawn(Other).HealthMax :"$KFXPawn(Other).HealthMax);
        }
//        if(KFXGame(Level.Game) != none)
//        {
//            if( KFXPawn(Other)!=none )
//            {
//                if(KFXPawn(Other).health + 30 < KFXPawn(Other).HealthMax )
//                {
//
//                     KFXPawn(Other).health = KFXPawn(Other).health + 30;
//                     return true;
//                }
//                else if(KFXPawn(Other).health  < KFXPawn(Other).HealthMax )
//                {
//                     KFXPawn(Other).health = KFXPawn(Other).HealthMax;
//                     return true;
//                }
//            }
//        }
        return false;
	}
	function Timer()
	{
	   log("HealthPickUp--------nTimerCount "$nTimerCount);
       nTimerCount++;
       if(nTimerCount >= TimeToFadeOut)
       {
           SetRespawn();
           log("KFXAmmoPickUp---Pickup---SetRespawn");
       }
    }
}

function inventory SpawnCopy( pawn Other )
{
    return none;
}

defaultproperties
{
     TimetoFadeOut=150.000000
     MaxDesireability=0.500000
     bAmbientGlow=是
     bPredictRespawns=是
     RespawnTime=1.000000
     CullDistance=6500.000000
     Physics=PHYS_Rotating
     Mesh=SkeletalMesh'fx_weapon2_anims.mesh_MedicalBag_3rd'
     DrawScale=0.270000
     AmbientGlow=128
     CollisionRadius=100.000000
     CollisionHeight=80.000000
     RotationRate=(Yaw=32768)
}
