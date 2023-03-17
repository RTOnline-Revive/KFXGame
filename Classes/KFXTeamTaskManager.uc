//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXTeamTaskManager extends KFXDeathTaskManager;

var int TASKTYPE_GAMEEND;

const GAMEENDFACTOR_DISPERSION		= 0;	///<分数差量
const GAMEENDFACTOR_OURSCORE		= 1;    ///<我方分数
const GAMEENDFACTOR_ENEMYSCORE		= 2;    ///<敌方分数
const GAMEENDFACTOR_TEAMID			= 3;	///<team id

///
/// 必要将模式信息赋值
///
function InitServerTaskArray(array<int> arrTaskInfo)
{
	TASKTYPE_GAMEEND = TASKTYPE_MODE0;
	super.InitServerTaskArray(arrTaskInfo);
}


// SetEndGameFocus
function KFXGameEndTask(int TeamIndex, int SelfScore, int EnemyScore)
{
	local int TaskIndex, CondIndex;
	local ServerTaskData Task;
	local bool bFail;

	for ( TaskIndex = fxTasks[TASKTYPE_GAMEEND].Tasks.Length-1; TaskIndex >= 0; TaskIndex-- )
	{
		Task = fxTasks[TASKTYPE_GAMEEND].Tasks[TaskIndex];
		bFail = false;

		for ( CondIndex = 0; CondIndex < Task.Conditions.Length; CondIndex ++ )
		{
            if(!OperGameEnd(TeamIndex, SelfScore, EnemyScore, Task.Conditions[CondIndex]))
			{
				bFail = true;
				break;
			}
		}

		if ( !bFail )
		{
			SetServerProgress(TASKTYPE_GAMEEND, TaskIndex, 1);
		}

	}
}

function bool OperGameEnd(int TeamIndex, int SelfScore, int EnemyScore, TaskCondition condition)
{
	switch(condition.Factor)
	{
	case GAMEENDFACTOR_DISPERSION:
		return CheckComparation( SelfScore-EnemyScore, condition );
	case GAMEENDFACTOR_OURSCORE:
		return CheckComparation( SelfScore, condition );
	case GAMEENDFACTOR_ENEMYSCORE:
		return CheckComparation( EnemyScore, condition );
	}
}

defaultproperties
{
}
