//-----------------------------------------------------------
// Éú³ÉpickupµÄ¹¤³§Àà, °ÑÕâ¸öpickup·ÅÔÚµØÍ¼Àï,ËûËµ²»¶¨»áÉú³ÉÊ²Ã´
//-----------------------------------------------------------
class KFXPickupFactory extends Actor
    placeable;

var Class<Pickup> PickupClass;
var Pickup PickUpItem;
var() int PickupNum;

function KFXSpawnPickup()
{
    if(PickupClass!=none)
    {
        PickUpItem=Spawn( PickupClass,none,,Location+vect(0,0,40),Rotation );
    }
}

function KFXDestoryPickup()
{
    if(PickupItem!=none)
    {
        PickupItem.Destroy();
    }
}

defaultproperties
{
     bStatic=是
     bHidden=是
     bNoDelete=是
     Texture=Texture'Engine.S_Inventory'
     bDirectional=是
}
