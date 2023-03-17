//-----------------------------------------------------------
//ÑÚÌåÄ£ÐÍ
//-----------------------------------------------------------
class DodgingPlace extends StaticMeshActor
placeable
;

var(Advanced) int nPosIndex;
var array <KFXCampPoint> KCP;
var array <PathNode> Path;
var bool bHasArrived;

defaultproperties
{
     StaticMesh=StaticMesh'fx_effect_smeshs.stone.stone_004'
}
