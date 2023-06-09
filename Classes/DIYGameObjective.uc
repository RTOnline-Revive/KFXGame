class DIYGameObjective extends PathNode
Placeable;

var bool Initialed;
var bool bOccupied;
var DestroyableActor Occupier;
var(DIYGameObjective) bool bLinkEnabled;//ÊÇ·ñÊ¹ÓÃÁ´½Ó¶ÔÏó£¬¼´¿ØÖÆÒÑ¾­´æÔÚµÄ¶ÔÏó
var(DIYGameObjective) int DiyActorType;//ÀûÓÃ¸÷¸öÎ»À´¿ØÖÆ¿ÉÒÔÉú³ÉÎï¼þµÄÀàÐÍ
var DestroyableActor LinkObjective; //±ØÐë½« bLinkEnabled ÖÃtrue

simulated function bool NeedRepaired()
{
    return ( ( Occupier !=none && Occupier.NeedRepaired()) || (bLinkEnabled && LinkObjective!=none && LinkObjective.NeedRepaired() ) );
}

simulated function PostBeginPlay()
{
    local DestroyableActor LinkActor;

    super.PostBeginPlay();

    if( !bLinkEnabled )
        return;

    foreach AllActors(class'DestroyableActor', LinkActor, Tag)
    {
        LinkObjective = LinkActor;
        ;
    }
}

defaultproperties
{
     DiyActorType=511
     bNotBased=是
     bHidden=否
     CollisionRadius=30.000000
     CollisionHeight=2.000000
     bCollideActors=是
}
