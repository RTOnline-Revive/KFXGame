//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXDeathTaskManager extends KFXTaskManager;

///
///�Ƿ����ڱ�ģʽ����
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
