//=============================================================================
// xWeaponBase
//=============================================================================
class WeapPickupBase extends xPickUpBase 
    placeable;
    
var class<PickUp>   pickupclass;

simulated event PostBeginPlay()
{
	PowerUp = none;
	
	Super.PostBeginPlay();
}

function SpawnPickup()
{
	local KFXCSVTable WeapAttachTable;
	local int WeapID;
	local int tempNum;
	
	log("SpawnPickup");
	
	tempNum = KFXGameReplicationInfo(level.Game.GameReplicationInfo).PVEPickupsA.Length;
	WeapID = KFXGameReplicationInfo(level.Game.GameReplicationInfo).PVEPickupsA[Rand(tempNum)];
	
	WeapID = 65537;
	
	WeapAttachTable = class'KFXTools'.static.GetConfigTable(17);
	
	if(!WeapAttachTable.SetCurrentRow(WeapID))
	{
		log("WeapBasePick Can not find PickupID"@WeapID);
	}
	pickupclass = class<WeaponPickup>( DynamicLoadObject( "XXXWeapons.XXX_"$WeapAttachTable.GetString("Name")$"Pickup", class'Class' ,true) );

    myPickUp = Spawn(pickupclass,,,Location + SpawnHeight * vect(0,0,1), rot(0,0,0));
    
    KFXWeapPickup(myPickUp).KFXInitWithBase(WeapID);

    if (myPickUp != None)
    {
        myPickUp.PickUpBase = self;
        myPickup.Event = event;
    }

}

defaultproperties
{
     SpiralEmitter=Class'KFXEffects.fx_effect_blueflag'
     NewStaticMesh=StaticMesh'fx_effect_smeshs.stone.stone_006'
     NewPrePivot=(Z=3.700000)
     NewDrawScale=0.500000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'fx_effect_smeshs.stone.stone_006'
     Texture=None
     DrawScale=0.500000
     CollisionRadius=60.000000
     CollisionHeight=3.000000
}
