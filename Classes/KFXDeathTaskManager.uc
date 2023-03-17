//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXDeathTaskManager extends KFXTaskManager;

///
///是否属于本模式以上
///
simulated function bool CheckGameMode(string ModeName)
{
	if("Death" == ModeName)
	{
		return true;
	}
	else
	{
		return super.CheckGameMode(ModeName);
	}
}

defaultproperties
{
}
