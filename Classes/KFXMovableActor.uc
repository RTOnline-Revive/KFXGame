class KFXMovableActor extends KFXMovableActorbase
placeable
;
var bool bcanDamage;
var bool brealactor;

function TakeDamage( float Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
    Damage=Damage*0.4;
    if (Damage > 0&&NewEndure > 0&&bcanDamage)
    {
        NewEndure-=Damage;
    }
    if(NewEndure<=0)
    {
        Destroy();
    }
}
event BaseChange()
{
   if(!Bbushingbox)
   {
      if(brealactor==true)
         SetPhysics(PHYS_Falling);
   }
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

defaultproperties
{
     Index=1
     NewEndure=600
     DrawScale=0.600000
}
