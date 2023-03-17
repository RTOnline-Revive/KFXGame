//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCampPoint extends NavigationPoint
    placeable;

var() actor ShootPoint;
var bool bCamped;       // 当前有bot在这里camp?

defaultproperties
{
     Texture=Texture'Engine.S_Pickup'
}
