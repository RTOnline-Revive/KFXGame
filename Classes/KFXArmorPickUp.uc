//-----------------------------------------------------------
//»¤¼×
//-----------------------------------------------------------
class KFXArmorPickUp extends PickUp;

var int     nTimerCount;
simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    if(Role == ROLE_Authority)
    {
    }
    ;
}
function SetRespawn()
{
//    if( Level.Game.ShouldRespawn(self) )
//		StartSleeping();
//	else
		Destroy();
		log("KFXArmorPickUp-----Destroy");
}

auto state Pickup
{
	function BeginState()
	{
	    UntriggerEvent(Event, self, None);
	    SetTimer(TimeToFadeOut, true);
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

        return false;
	}
}


function inventory SpawnCopy( pawn Other )
{
    return none;
}

defaultproperties
{
     MaxDesireability=0.500000
     bAmbientGlow=是
     bPredictRespawns=是
     RespawnTime=1.000000
     TimetoFadeOut=150.000000
     CullDistance=6500.000000
     Physics=PHYS_Rotating
     Mesh=SkeletalMesh'fx_weapon2_anims.mesh_ArmorBag_3rd'
     DrawScale=0.270000
     AmbientGlow=128
     CollisionRadius=100.000000
     CollisionHeight=80.000000
     RotationRate=(Yaw=32768)
}
