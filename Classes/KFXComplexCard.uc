//-----------------------------------------------------------
//Author: hawk Wang 王皓 2009-12-08
//KFXComplexCard 功能完备的Card，支持属性改变，
//触发类卡片的功能启动
//附加功能1，如果需要计时，有使用时间和冷却时间
//只要对象被创建，那么卡片一定已经被装备
//只需检测卡片是否能被使用即可
//--------------------------------------------
class KFXComplexCard extends KFXCard;

//------------Event---------------------------
simulated event Tick( float DeltaTime );

defaultproperties
{
}
