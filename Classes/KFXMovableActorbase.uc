class KFXMovableActorbase extends actor
abstract
;
var bool Bbushingbox;
var int index;
var bool bUInMap;
var bool bistouch  ;
var actor PushMan;
var int NewEndure;
var int PushStateRange,PushStateOutRange;
var bool EnterVolume;
replication
{
    //< replication from xPlayer
    // client to server
    reliable if ( Role == ROLE_Authority )
           Entervolume,bistouch,PushMan;
}
function Touch(Actor Other)
{
    if ( Volume(Other).LocationName ~= "DiyVolume" )
    {

       Entervolume=true;
    }
    else
        bistouch=true;
}
function GetBetterloction(out vector      HitLocation)
{
    local vector  TraceEnd,hitnormal;
    TraceEnd=location;
    TraceEnd.Z=-100;
    Trace(HitLocation,hitnormal,TraceEnd,location,false,,);
    HitLocation.Z+=5;
}
function UnTouch(Actor Other)
{
    if ( Volume(Other).LocationName ~= "DiyVolume" )
    {
       Entervolume=false;
    }
    else
        bistouch=false;

}
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetCollision(true,true,true);
}
function changecollisionworld()
{
     bCollideWorld=  !bCollideWorld;
}
function TakeDamage( float Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType) ;
function ChangeTrace()
{
   bBlockNonZeroExtentTraces=false;
   bBlockZeroExtentTraces   =false;
}

defaultproperties
{
     bUInMap=是
     PushStateRange=15
     PushStateOutRange=25
     DrawType=DT_StaticMesh
     Physics=PHYS_Falling
     CollisionRadius=95.000000
     CollisionHeight=100.000000
     bCollideActors=是
     bCollideWorld=是
     bBlockActors=是
     bProjTarget=是
     bUseCylinderCollision=是
}
