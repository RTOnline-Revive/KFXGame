//-----------------------------------------------------------
//  Class:      KFXGame.KFXTaskManager
//  Creator:    zhongxiaoye@kingsoft ÖÓ
//  Data:       2010-01-06
//  Desc:       ÈÎÎñÏµÍ³¹ÜÀíÀà
//  Update:
//  Special:
//-----------------------------------------------------------

class KFXTaskManager extends Actor;
var KFXPlayer fxPlayer;

//<< ÈÎÎñÌõ¼þ
struct TaskCondition
{
	var int Factor;                         ///<Ìõ¼þÒòËØ
	var int Value1;                         ///<ÊýÖµ¹ØÏµ 0:ÏàµÈ 1:´óÓÚ 2:Ð¡ÓÚ
	var int Value2;                         ///<ÊýÖµ
};

//<< ÈÎÎñÊý¾Ý
struct ServerTaskData
{
	var byte TaskClass;						///<ÈÎÎñËùÊô
	var byte PosInArray;					///<´«ÈëÊý×éËùÔÚÎ»ÖÃ realmÄÇÃ´Ê¡£¬²»»á´«255ÒÔÉÏµ¥¾ÖÈÎÎñ¹ýÀ´°É¡£¡£
	var int TaskID;							///<ÈÎÎñID
	var int TaskTarget;						///<ÈÎÎñÄ¿±ê
	var int TaskProcess;					///<ÈÎÎñÍê³É¶È
	var array<TaskCondition> Conditions;	///<ÈÎÎñÌõ¼þ
};

struct ClientTaskData
{
	var int TaskID;
	var int Target;
	var int StartProcess;
	var int BaseDataID1;
	var int BaseDataID2;
};
var array<ClientTaskData> ClientTasks;

var array<int> ServerTaskSynArray;//ÓÃÓÚ·þÎñÆ÷Í¬²½¸ø¿Í»§¶ËµÄÈÎÎñ×·×ÙÈÕÖ¾£¬²»ÊÇÍêÈ«ÊµÊ±µÄ£¬ÊÇÄ£ÄâÊµÊ±µÄ¡£Ã¿Ö¡Ö»Ë¢Ò»¸ö¡£

///<ÈÎÎñËùÊô
const TASKCLASS_ACHIVEMENT 	= 0;			///<³É¾ÍÈÎÎñ
const TASKCLASS_CLASSICS	= 1;			///<¾­µäÈÎÎñ

///<ÈÎÎñ·ÖÀà
const TASKTYPE_KILL			= 0;          	///<»÷É±ÈÎÎñ  none£ºkilled
const TASKTYPE_ITEM			= 1;          	///<µôÂäÈÎÎñ
const TASKTYPE_HURT			= 2;          	///<ÉËº¦ÈÎÎñ
const TASKTYPE_MODE0		= 16;           ///<Ä£Ê½ÈÎÎñ0 team£ºKFXGameEndTask
const TASKTYPE_MODE1        = 17;           ///<Ä£Ê½ÈÎÎñ1 bomb£ºKFXInstallC4
const TASKTYPE_MODE2        = 18;           ///<Ä£Ê½ÈÎÎñ2 bomb£ºKFXRemoveC4
const TASKTYPE_COUNT		= 19;

struct TypeTasks
{
	var array<ServerTaskData> Tasks;
};
var TypeTasks fxTasks[TASKTYPE_COUNT];		///<ÈÎÎñ¾ßÌåÊý¾Ý

///Ò»¼¶ÀàÐÍ£º»÷É±ÈÎÎñÒòËØ ºó¸úÃèÊö
const KILLFACTOR_KILLER		   = 0;        ///<»÷É±¶ÔÏó(Ìõ¼þ±ØÑ¡)
const KILLFACTOR_KILLED		   = 1;        ///<±»»÷É±¶ÔÏó(Ìõ¼þ±ØÑ¡)
const KILLFACTOR_WEAPONTYPE	   = 2;        ///<ÏÞÖÆÎäÆ÷ÀàÐÍ
const KILLFACTOR_WEAPONID	   = 3;        ///<ÏÞÖÆÎäÆ÷ID
const KILLFACTOR_HITBOXID      = 4;        ///<2 = ±¬Í·
const KILLFACTOR_KILLER_SUITID = 5;        ///<»÷É±Õß×Å×°
const KILLFACTOR_KILLED_SUITID = 6;        ///<±»É±Õß×Å×°
const KILLFACTOR_REMAIN_HP     = 7;        ///<»÷É±Õß HP Öµ
const KILLFACTOR_ZOOMLEVEL     = 8;        ///<»÷É±Õß£¬ÊÇ·ñ¿ª¾µ
const KILLFACTOR_KILL_DISTANCE = 9;        ///<»÷É±Õß£¬ÉäÉ±¾àÀë
const KILLFACTOR_KILL_COMBO    = 10;       ///<»÷É±Õß£¬Á¬ÐøÉäÉ±´ÎÊý
const KILLFACTOR_KILL_ONE_TIME = 11;       ///<»÷É±Õß£¬Í¬Ê±ÉäÉ±
const KILLFACTOR_KILLED_ROUND  = 12;	   ///<±¾¾ÖÄÚ»÷É±£¨Ð¡¾ÖÄ£Ê½£©
const C4FACTOR_TIME					= 13;	///<°²×°(²ð³ý)C4£¬Ê±¼äÏÞÖÆ
const C4FACTOR_NUM					= 14;	///<°²×°(²ð³ý)C4£¬´ÎÊýÏÞÖÆ


//¶þ¼¶ÀàÐÍ£º»÷É±¶ÔÏó¹ØÏµ
const RELATIONSHIP_SELF				     = 0;	///<×Ô¼º
const RELATIONSHIP_ENEMY			     = 1;	///<ÈÎÒâµÐÈË
const RELATIONSHIP_LAST_ENEMY_KILL_ME	 = 2;	///<ÉÏ´Î»÷É±×Ô¼ºµÄµÐÈË
const RELATIONSHIP_LAST_ENEMY_I_KILL	 = 3;	///<ÉÏ´Î×Ô¼º»÷É±µÄµÐÈË
const RELATIONSHIP_REDTEAM			     = 4;	///<ºì¶Ó
const RELATIONSHIP_BLUETEAM			     = 5;   ///<À¶¶Ó
const RELATIONSHIP_FRIEND                = 6;   ///<¶ÓÓÑ
const RELATIONSHIP_REVANGE               = 7;   ///<¸´³ð£¬É±ËÀÁËÉÏ´ÎÉ±ËÀ×Ô¼ºµÄµÐÈË¡£

//-----ÌØ±ð³ÉÔ±±äÁ¿£¬ºÍ»ù´¡Êý¾ÝÎÞ¹Ø£¬µ«ÊÇÓÃÓÚ·þÎñÆ÷ÈÎÎñµÄ³ÉÔ±±äÁ¿ ----
//-----
//----------Á¬ÐøÉ±Ä³ÈËºÍÁ¬Ðø±»Ä³ÈËÉ±ËÀ
var PlayerReplicationInfo PRILastKillMe;
var PlayerReplicationInfo PRILastIKill;
//----------ÔÚÍ¬Ò»Ê±¼äÉ±ËÀµÄµÐÈË
var Array<float> InstantMultiKillQueue;
var float InstantMultiKillDeltaTime;

///Ò»¼¶ÀàÐÍ£ºµôÂäÈÎÎñÒòËØ
const CON_IS_LEADER		= 0;			///<ÊÇ²»ÊÇ¶Ó³¤µôÂä

///Ò»¼¶ÀàÐÍ£ºÉËº¦ÀàÈÎÎñÒòËØ
const CON_DAMAGE_FALL   = 0;            ///<Ë¤ÉËºóÊ£ÓàÑªÁ¿

///<Í¬²½·þÎñÆ÷ÈÎÎñÊý¾Ýµ½¿Í»§¶Ë£¬ÓÃÓÚ×·×ÙÈÎÎñ ¸ß°ËÎ»ÊÇid µÍ°ËÎ»ÊÇÈÎÎñ½ø¶È
var int fxTaskProgress;
var int fxLastTaskProgress;

replication
{
	// ÊýÖµ±ä»¯¾ÍÍ¬²½
    reliable if ( bNetDirty && (Role == ROLE_Authority) )
    	fxTaskProgress;
}

///
///       ·þÎñÆ÷£¨µ¥¾Ö£©ÈÎÎñ
///
function InitServerTaskArray(array<int> arrTaskInfo)
{
	local KFXCSVTable CFG_TASKATT, CFG_TASKSERVER, CFG_TASKTYPE, CFG_TASKCOND;
	local int i, j, condNum;
	local int taskType;
	local bool defineKillOBJ;  	// ÊÇ·ñÉè¶¨Ä¬ÈÏ»÷É±Ìõ¼þ
 	local ServerTaskData tempTask;
	local TaskCondition tempCond;
	local string ModeName;

	CFG_TASKATT = class'KFXTools'.static.GetConfigTable(700);
	CFG_TASKSERVER = class'KFXTools'.static.GetConfigTable(701);
	CFG_TASKTYPE = class'KFXTools'.static.GetConfigTable(703);
	CFG_TASKCOND = class'KFXTools'.static.GetConfigTable(704);

	for(i=0; i<arrTaskInfo.length; i++)
	{
        if ( !CFG_TASKATT.SetCurrentRow(arrTaskInfo[i]) )
        {
        	log("[KFXTaskManager] InitTaskArray CFG_TASKATT no task id:"$arrTaskInfo[i]);
        	continue;
        }
        if ( !CFG_TASKSERVER.SetCurrentRow(arrTaskInfo[i]) )
        {
        	log("[KFXTaskManager] InitTaskArray CFG_TASKSERVER no task id:"$arrTaskInfo[i]);
        	continue;
        }
        log("\\\\\\\\\arrTaskInfo"$i$" "$arrTaskInfo[i]);

        tempTask.TaskProcess = 0;
        tempTask.Conditions.Length = 0;
        tempTask.TaskID = arrTaskInfo[i];
        tempTask.PosInArray = i;

        // ±íÖÐ¶ÁÈë¸ÃÈÎÎñÊôÐÔ
        tempTask.TaskClass = CFG_TASKATT.GetInt("TaskClass");
        tempTask.TaskTarget = CFG_TASKATT.GetInt("Target");

        log("\\\\\\\\\tempTask.TaskTarget:"$tempTask.TaskTarget);

        taskType = CFG_TASKSERVER.GetInt("TaskType");
        if ( !CFG_TASKTYPE.SetCurrentRow(taskType) )
	    {
	    	log("[KFXTaskManager] InitTaskArray CFGTASKTYPE no task type:"$taskType);
	        continue;
		}
		taskType = CFG_TASKTYPE.GetInt("value");
        ModeName = CFG_TASKTYPE.GetString("FatherMode");
        log("\\\\\\\\\\taskType:"$taskType);

        // ÎªÔ¼ÊøÌõ¼þ¸³Öµ
        condNum = CFG_TASKSERVER.GetInt("CondNum");
        for(j=0; j<condNum; j++)
        {
        	tempCond.Factor = CFG_TASKSERVER.GetInt("CondID"$j+1);

        	if ( !CFG_TASKCOND.SetCurrentRow(tempCond.Factor) )
	        {
	        	log("[KFXTaskManager] InitTaskArray CFG_TASKCOND no task cond:"$tempCond.Factor);
	        	continue;
	        }
	        tempCond.Factor = CFG_TASKCOND.GetInt("param1");
	        tempCond.Value1 = CFG_TASKSERVER.GetInt("Cond"$j+1$"Value"$1);
        	tempCond.Value2 = CFG_TASKSERVER.GetInt("Cond"$j+1$"Value"$2);
        	log("\\\\\\\\\tempCond.Factor:"$tempCond.Factor);
        	log("\\\\\\\\\tempCond.Value1:"$tempCond.Value1);
        	log("\\\\\\\\\tempCond.Value2:"$tempCond.Value2);
        	if(CFG_TASKCOND.GetInt("param2") >= 0)
        	{
        		tempCond.Value2 = CFG_TASKCOND.GetInt("param2");
			}
        	tempTask.Conditions[tempTask.Conditions.Length] = tempCond;

        	if(taskType == TASKTYPE_KILL && !defineKillOBJ && tempCond.Factor < 2 )
	        {
	        	defineKillOBJ = true;
			}
		}

		// »÷É±ÈÎÎñ±Ø±¸Ìõ¼þÌí¼Ó

		if(!defineKillOBJ && taskType == TASKTYPE_KILL)
		{
            SetDefaultCondition(tempTask.Conditions, KILLFACTOR_KILLER, RELATIONSHIP_SELF);
            SetDefaultCondition(tempTask.Conditions, KILLFACTOR_KILLED, RELATIONSHIP_ENEMY);
		}
		log("\\\\\\\\\\\cond len:"$tempTask.Conditions.Length);
		if(FilterModeTask(tempTask.TaskID) && CheckGameMode(ModeName))
		{
			fxTasks[taskType].Tasks[fxTasks[taskType].Tasks.Length] = tempTask;
		}
	}
	LogServerTaskData();
}

///
///ÊÇ·ñÊôÓÚ±¾Ä£Ê½ÒÔÉÏ
///
simulated function bool CheckGameMode(string ModeName)
{
	return "None" == ModeName;
}

///
/// ³õÊ¼»¯¿Í»§¶Ë£¨¶à¾Ö£©ÈÎÎñ
///
simulated function InitClientTaskArray()
{
	local int i;
	local ClientTaskData tempTask;
	local string modeName;
	local KFXCSVTable CFG_TASKATT, CFG_TASKCLIENT, CFG_TASKBASEDATA;
	CFG_TASKATT = class'KFXTools'.static.GetConfigTable(700);
	CFG_TASKCLIENT = class'KFXTools'.static.GetConfigTable(702);
	CFG_TASKBASEDATA = class'KFXTools'.static.GetConfigTable(705);

	for(i=0; i<fxPlayer.ClientTaskArray.length; i++)
	{
		tempTask.TaskID = fxPlayer.ClientTaskArray[i].TaskID;
		tempTask.StartProcess = fxPlayer.ClientTaskArray[i].TaskProcess;

        if ( !CFG_TASKATT.SetCurrentRow(tempTask.TaskID) )
        {
        	log("[KFXTaskManager] InitClientTaskArray CFG_TASKATT no task id:"$tempTask.TaskID);
        	continue;
        }
        if ( !CFG_TASKCLIENT.SetCurrentRow(tempTask.TaskID) )
        {
        	log("[KFXTaskManager] InitClientTaskArray CFG_TASKCLIENT no task id:"$tempTask.TaskID);
        	continue;
        }
        tempTask.Target = CFG_TASKATT.GetInt("Target");
        tempTask.BaseDataID1 = CFG_TASKCLIENT.GetInt("BaseDataID");
        if ( !CFG_TASKBASEDATA.SetCurrentRow(tempTask.BaseDataID1) )
        {
        	log("[KFXTaskManager] InitClientTaskArray CFG_TASKSERVER no base data:"$tempTask.BaseDataID1);
        	continue;
        }
        tempTask.BaseDataID1 = CFG_TASKBASEDATA.GetInt("Param1");
        tempTask.BaseDataID2 = CFG_TASKBASEDATA.GetInt("Param2");
        modeName = CFG_TASKBASEDATA.GetString("FatherMode");
        if(FilterModeTask(tempTask.TaskID) && CheckGameMode(modeName))
		{
			ClientTasks[ClientTasks.Length] = tempTask;
		}
		else
		{

		}
	}
	//LogClientTaskData();
	SetTimer(1, true);
}

///
/// Ë¢»ù´¡Êý¾Ý,¸üÐÂ¿Í»§¶ËÈÎÎñ
///
simulated event Timer()
{
	local KFXPlayerReplicationInfo PRI;
	local int i, j, value1, value2, arrValue;
	if( Level.NetMode != NM_DedicatedServer )
	{
		PRI = KFXPlayerReplicationInfo(fxPlayer.PlayerReplicationInfo);
		for(i=PRI.fxChangedRepValues.length-1; i>=0; i--)
		{
			if(Level.TimeSeconds - PRI.fxChangedRepValues[i].timeSecond <= 1)
			{
				value1 = PRI.fxChangedRepValues[i].value1;
				value2 = PRI.fxChangedRepValues[i].value2;
				for(j=ClientTasks.length-1; j>=0; j--)
				{
					if(value1 == ClientTasks[j].BaseDataID1 &&
						value2 == ClientTasks[j].BaseDataID2)
					{
						 arrValue = PRI.fxRepArray[value1].arrData[value2];
						 SetClientProgress(j, arrValue);
					}
				}
			}
			else
			{
				break;
			}
		}
	}
}


function SetDefaultCondition(out array<TaskCondition> conds, int factor, int defValue)
{
	local int i, insertPos;
	local bool bItemExist;
	local TaskCondition tempCond;
	insertPos = -1;
	tempCond.Factor = factor;
	tempCond.Value2 = defValue;
	for(i=0; i<conds.length; i++)
    {
    	if(conds[i].Factor == factor)
    	{
    		bItemExist = true;
    		break;
		}
		if(conds[i].Factor > factor)
		{
			insertPos = i;
			break;
		}
	}
	if(!bItemExist)
	{
		if(insertPos == -1)
		{
			conds[conds.length] = tempCond;
		}
		else
		{
			conds.insert(insertPos, 1);
			conds[insertPos] = tempCond;
		}
	}
}

///
///ÅÅ³ýÄ£Ê½²»Ïà¹ØµÄÈÎÎñ ·µ»ØÕæÔò½«¸ÃÈÎÎñ±£Áô£¬¼ÙÔòÉ¾³ý
///
simulated function bool FilterModeTask(int id)
{
	local KFXCSVTable CFG_TASK;
	local int k, ModeNum;
	local string modeName;
	if(Role == ROLE_Authority)
	{
		CFG_TASK = class'KFXTools'.static.GetConfigTable(701);
	}
	else
	{
		CFG_TASK = class'KFXTools'.static.GetConfigTable(702);
	}

	if ( !CFG_TASK.SetCurrentRow(id) )
    {
    	log("[KFXTaskManager] FilterModeTask no task id:"$id);
    	return false;
    }
    ModeNum = CFG_TASK.GetInt("ActModeNum");
    if(ModeNum != 0)
    {
    	for(k=0; k<ModeNum; k++)
		{
			modeName = CFG_TASK.GetString("ActMode"$k+1);
			if(CheckGameMode(modeName))
			{
				return true;
			}
		}
		return false;
	}

	ModeNum = CFG_TASK.GetInt("NotActModeNum");
    if(ModeNum != 0)
    {
	    for(k=0; k<ModeNum; k++)
		{
			modeName = CFG_TASK.GetString("NotActMode"$k+1);
			if(CheckGameMode(modeName))
			{
				return false;
			}
		}
		return true;
	}
	return true;
}

function LogServerTaskData()
{
	local int i, j;
	for(i=0; i<TASKTYPE_COUNT; i++)
	{
		for(j=0; j<fxTasks[i].Tasks.Length; j++)
		{
			log("[KFXTaskManager] TaskType:"$i$" id:"$fxTasks[i].Tasks[j].TaskID$
				" TaskTarget:"$fxTasks[i].Tasks[j].TaskTarget);
		}
	}
}

simulated function LogClientTaskData()
{
	local int i;
	for(i=0; i<ClientTasks.length; i++)
	{
		;
	}
}

///
/// »÷É±º¯ÊýÖÐ´¦ÀíÏà¹ØÈÎÎñ
///
function Killed( Controller Killer, Controller Killed )
{
	local int i, j;
	local bool bAllConditionMatched;
	local bool bCurrentConditionMatched;
	local ServerTaskData CurrentTask;       //¼ÍÂ¼µ±Ç°ÕýÔÚ´¦ÀíµÄÈÎÎñ
    bCurrentConditionMatched = false;       //ÒÔºó»áÓÃµ½

	//Íâ²ã±éÀú£º´¦ÀíÃ¿¸öÈÎÎñ
	for(i= fxTasks[TASKTYPE_KILL].Tasks.Length - 1 ; i >= 0 ; i-- )
	{
        //ËùÓÐÌõ¼þÂú×ãµÄ±êÖ¾Î»¡£
	    bAllConditionMatched = true;

        //»ñÈ¡µ±Ç°ÈÎÎñ
        CurrentTask = fxTasks[TASKTYPE_KILL].Tasks[i];

	    //ÄÚ²ã±éÀú£º´¦ÀíÃ¿¸öÈÎÎñµÄÃ¿¸öÌõ¼þ
		for(j=0; j<CurrentTask.Conditions.Length; j++)
		{
			bCurrentConditionMatched = OperKilled(Killer, Killed, CurrentTask.Conditions[j],i);
			if( bCurrentConditionMatched == false)
			{
                bAllConditionMatched = false;
                break;//ÓÐÒ»¸ö²»Âú×ã£¬Ö±½ÓÌø³ö¾ÍºÃÁË
            }
		}
		if(bAllConditionMatched == true)
		{
		    //ËùÓÐµÄÌõ¼þ¶¼Âú×ã£¬¿ÉÒÔÎªProcess + 1,ÕâÀï²»ÓÃÊ¹ÓÃÁÙÊ±±äÁ¿£¬·ñÔòÎÞ·¨ÕýÈ·µÄ½«ÖµÐ´»ØÔ­Êý×é
            log("\\\\\\\\\\\before SetServerProgress1 i:"$i@"task id="$fxTasks[TASKTYPE_KILL].Tasks[i].TaskID);
			SetServerProgress(TASKTYPE_KILL, i, 1);
        }
	}
}

//Usage:Ò»¼¶´¦Àíº¯Êý£ºÓÃÀ´´¦Àí»÷É±ÀàÈÎÎñµÄ¾ßÌåÂß¼­ £¬ÐÂ»÷É±ÅÐ¶¨Ìõ¼þÐ´ÔÚÕâÀï£¡
//param1-2£º»÷É±ÕßºÍ±»É±Õß
//param3:µ±Ç°ÈÎÎñµÄÈÎÎñÌõ¼þ£¬ÕâÊÇÒòÎªÄ³Ð©ÈÎÎñ»áÐèÒªÊýÖµ±È½Ï¡£
//param4:µ±Ç°ÈÎÎñµÄÈÎÎñID£¬ÕâÊÇÒòÎªÁ¬É±ÈÎÎñÐèÒªÖØÖÃÈÎÎñ½ø³Ì¡£TaskProcess
//Author:Hawk Wang 2010-01-22
function bool OperKilled( Controller Killer, Controller Killed, TaskCondition condition,int TaskID )
{
	//ÔÝÊ±²»ÒªÔÚ¿ªÊ¼ÅÐ¶¨ killer Îª none µÄÇé¿ö£¬ÒòÎª¿ÉÄÜÐèÒªÔÚºóÃæÅÐ¶¨±»C4
    //Õ¨ËÀµÄÇé¿ö ,ÔÚÕâÀïÐ´ËÀ¾Í²»ºÃÅÐ¶¨c4ÁË£¬ËäÈ»ÕâÑù»áºÜÂé·³£¬åRX¡£
//	log("\\\\\\\OperKilled condition.Factor:"$condition.Factor);
//	log("\\\\\\\OperKilled condition.Value1:"$condition.Value1);
//	log("\\\\\\\OperKilled condition.Value2:"$condition.Value2);
    switch(condition.Factor)
	{
	case KILLFACTOR_KILLER:            //»÷É±¶ÔÏó(Ìõ¼þ±ØÑ¡)
		return CheckRelation( Killer,condition,TaskID );
	case KILLFACTOR_KILLED:            //±»»÷É±¶ÔÏó(Ìõ¼þ±ØÑ¡)
		return CheckRelation( Killed,condition,TaskID );
	case KILLFACTOR_WEAPONTYPE:        //<ÏÞÖÆ»÷É±ÕßµÄÎäÆ÷ÀàÐÍ
	    return CheckWeaponType( Killer,condition );
    case KILLFACTOR_WEAPONID:          //<ÏÞÖÆÎäÆ÷ID
        if( killer != none && KFXWeapBase(killer.Pawn.Weapon) != none )
        {
            return ( KFXWeapBase(killer.Pawn.Weapon).KFXGetWeaponID() == condition.Value2 );
        }
        else return false;
    case KILLFACTOR_HITBOXID:          //<2 = ±¬Í·
        if( killed != none && KFXPawn(killed.Pawn) != none )
        {
            return ( KFXPawn(killed.Pawn).KFXDmgInfo.HitBoxID == condition.Value2 );
        }
        else return false;
    case KILLFACTOR_KILLER_SUITID:     //<»÷É±Õß×Å×°
        if( killer != none && KFXPawn( Killer.Pawn ) != none )
        {
            return ( KFXPawn( Killer.Pawn ).KFXPendingState.nSuitID == condition.Value2 );
        }
        else return false;
    case KILLFACTOR_KILLED_SUITID:     //<±»É±Õß×Å×°
        if( killed != none && KFXPawn( Killed.Pawn ) != none )
        {
            return ( KFXPawn( Killed.Pawn ).KFXPendingState.nSuitID == condition.Value2 );
        }
        else return false;
    case KILLFACTOR_REMAIN_HP:         //<»÷É±Õß HP Öµ
        if( killer != none && KFXPawn( KIller.Pawn ) != none )
        {
            return CheckComparation( KFXPawn( Killer.Pawn ).Health, condition );
        }
        else return false;
    case KILLFACTOR_ZOOMLEVEL:        //<»÷É±Õß£¬ÊÇ·ñ¿ª¾µ
        //KFXWeapSniperÔÚÕâÀïÊÇÊ¶±ð²»³öÀ´µÄ£¬Òò´ËÕâÀïÈÎÎñÊÇÐèÒª2¸öÌõ¼þµÄ
        //Ìõ¼þ1£¬ÎäÆ÷×é±ð£¬Ìõ¼þ2£¬ÊÇ·ñ¿ª¾µÁË¡£
        //Ê¹ÓÃ KFXFireGroup ÅÐ¶Ï£¬Èç¹ûÊÇ0£¬ÄÇÃ´Ã»¿ª¾µ£¬Èç¹ûÊÇ1£¬ÄÇÃ´¿ª¾µÁË
        if( killer != none && KFXWeapBase(killer.Pawn.Weapon) != none
				&& IsSniper(KFXWeapBase(killer.Pawn.Weapon).KFXGetWeaponID()))
        {
            return ( KFXWeapBase(killer.Pawn.Weapon).GroupOfLastKill == condition.Value2 );
        }
        else return false;
    case KILLFACTOR_KILL_DISTANCE:     //<»÷É±Õß£¬ÉäÉ±¾àÀë
        return CheckDistance(killer,killed,condition);
    case KILLFACTOR_KILL_COMBO:        //<»÷É±Õß£¬Á¬ÐøÉäÉ±´ÎÊý
        if( killer != none )
        {
            if( KFXPlayer(killer)!= none)
                return CheckComparation( KFXPlayer(killer).MultiKillLevel , condition );
            else return false;
        }
        else return false;
    case KILLFACTOR_KILL_ONE_TIME:     //<»÷É±Õß£¬Í¬Ê±ÉäÉ±
        if( killer != none)
        {
            if( CheckComparation( CheckAnnihilation() , condition ) == true )
            {
                InstantMultiKillQueue.Length = 0;
                return true;
            }
            else return false;
        }
        else return false;
    default:
        return false;
	}
}

//Usage:¶þ¼¶Ìõ¼þ¼ì²â£¬ÓÃÀ´¼ì²âÄ¿±êControllerµÄ¹ØÏµ
//Author:Hawk Wang 2010-01-22
function bool CheckRelation(Controller player, TaskCondition condition,int TaskID)
{
    if(player == none)
    {
        return false;
    }

	switch(condition.Value2)
	{
	case RELATIONSHIP_SELF:			        //×Ô¼º
		return player == fxPlayer;
	case RELATIONSHIP_ENEMY:		        //ÈÎÒâµÐÈË,ÅÐ¶Ï²»ÔÙÒ»¸ö¶ÓÎéÀïÃæ
	    return !(fxPlayer.SameTeamAs(player));
	case RELATIONSHIP_LAST_ENEMY_KILL_ME:   //<ÉÏ´Î»÷É±×Ô¼ºµÄµÐÈË
	    ;
	    //Ê×ÏÈplayer±ØÐëÊÇµÐÈË¡£
	    if( player == fxPlayer )
	    {
	        return false;
        }
	    if(PRILastKillMe == none)
	    {
	        PRILastKillMe = player.Pawn.PlayerReplicationInfo;
	        return true;
        }
        else if( PRILastKillMe == player.Pawn.PlayerReplicationInfo)
        {
            //É±ÎÒµÄÈË»¹ÊÇÉÏ´ÎÉ±ÎÒµÄÄÇ¸öÈË¡£
            return true;
        }
        else if(PRILastKillMe != player.Pawn.PlayerReplicationInfo)
        {
            //É±ÎÒµÄÈË²»ÊÇÉÏ´ÎÉ±ÎÒµÄÄÇ¸öÈË¡£¸³Öµ£¬¸üÐÂTaskProcess·µ»ØÕæ
            PRILastKillMe = player.Pawn.PlayerReplicationInfo;
            //Õâ¸öÏàµ±ÓÚÒ»¸öÐÂµÄÈË¡°µÚÒ»´Î¡±É±ÎÒ£¬½«tasksÖÃÎª 0
            SetServerProgress(TASKTYPE_KILL, TaskID, 0, true);
            return true;
        }
        else//ÎÒÖªµÀÕâÃ´Ð´ºÜÂé·³,µ«ÊÇÂß¼­Ò»Ä¿ÁËÈ»£¬Ð¡ÐÄÊ»µÃÍòÄê´¬
        {
            return false;
        }
    case RELATIONSHIP_LAST_ENEMY_I_KILL:    //<ÉÏ´Î×Ô¼º»÷É±µÄµÐÈË
        ;
        //´«½øÀ´µÄ±ØÐëÊÇµÐÈË£¬²»ÄÛÊÇ×Ô¼º
        if( Player == fxPlayer)
        {
            return false;
        }
        if( PRILastIKill == none )
        {
            PRILastIKill = player.Pawn.PlayerReplicationInfo;
            return true;
        }
        else if( PRILastIKill == player.Pawn.PlayerReplicationInfo )
        {
            return true;
        }
        else if( PRILastIKill != player.Pawn.PlayerReplicationInfo )
        {
            PRILastIKill = player.Pawn.PlayerReplicationInfo;
            SetServerProgress(TASKTYPE_KILL, TaskID, 0, true);
            return true;
        }
        else
        {
            return false;
        }
    case RELATIONSHIP_REDTEAM:              //ºì¶Ó
        ;
        return KFXPlayer(player).IsRedTeam();
    case RELATIONSHIP_BLUETEAM:             //À¶¶Ó
        ;
        return KFXPlayer(player).IsBlueTeam();
    case RELATIONSHIP_FRIEND:             //¶ÓÓÑ
        ;
        return ( player != fxPlayer && fxPlayer.SameTeamAs(player) == true );
    case RELATIONSHIP_REVANGE:
        ;
        //É±×Ô¼º²»Ëã¸´³ð
        if( player == fxPlayer )
        {
            return false;
        }
        //Ä¿Ç°»¹Ã»ÓÐÈËºÍÄã¹ý²»È¥¡£
        if( PRILastKillMe == none )
        {
            return false;
        }
        //Ñ¾£¬ÎÒÀ´±¨³ðÁË£¡£¡£¡£¡£¡
        else if(PRILastKillMe == player.Pawn.PlayerReplicationInfo)
        {
            return true;
        }
        else return false;
    default:
        return false;
	}
}

function bool IsSniper(int weaponid)
{
    local KFXCSVTable CSV_Weapon;
    local int WeaponGroup;
    CSV_Weapon = class'KFXTools'.static.GetConfigTable(11);
    if( CSV_Weapon.SetCurrentRow(WeaponID) )
    {
        WeaponGroup = CSV_Weapon.GetInt("WeaponGroup1");
        return (WeaponGroup == 4);
    }
	return false;
}

//Usage:¼ì²â»÷É±ÕßµÄÎäÆ÷ÀàÐÍ¡£
//Author:Hawk Wang 2010-01-22
Function bool CheckWeaponType(controller killer, TaskCondition condition)
{
    local int WeaponID;
    local int WeaponGroup;
    local KFXCSVTable CSV_Weapon;

    if( killer == none )
    {
        return false;
    }

    //»ñÈ¡ÎäÆ÷IDÏÈ¡£
    //if( KFXWeapBase(killer.Pawn.Weapon) != none )
    //{
        weaponID = killer.Pawn.KFXDmgInfo.WeaponID;
    //}
    log("[LABOR]--------------check weapon type:"$weaponID);

    CSV_Weapon = class'KFXTools'.static.GetConfigTable(11);

    //´ÓCSV±íÖÐ»ñÈ¡×é±ð
    if( CSV_Weapon.SetCurrentRow(WeaponID) )
    {
        WeaponGroup = CSV_Weapon.GetInt("WeaponGroup1");
    }
    else
    {
        log("[Task Manager][Kill] Could not Get WeaponGroup Error While Reading CSV");
        return false;
    }

    return ( WeaponGroup == condition.Value2 );
}

//Usage£ºÓÃÀ´¼ÆËãÁ½¸öPawnÖ®¼äµÄ¾àÀëµÄº¯Êý £¬Ö÷ÒªÓÃÓÚ»÷É±ÈÎÎñ
//Author£ºHawkWang 2010-01-25
Function bool CheckDistance(controller killer, controller killed, TaskCondition condition)
{
    local int       nDistance;
    local vector    vecDistance;

    //»÷É±ºÍ±»»÷É±£¬ÔÚ¸ÃÌõ¼þÖÐ¶¼²»ÄÜÎª¿Õ
    if( killer == none || killed == none )
    {
        return false;
    }
    vecDistance = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxLocation
						- KFXPlayerReplicationInfo(killed.PlayerReplicationInfo).fxLocation;

	//vecDistance = killer.Location-killed.Location;
	nDistance = int ( self.VSize(vecDistance) );

    //¶þÕßµÄ¶¼±ØÐëÄÜ×ª³ÉKFXPawn
//    if( KFXPawn(killer.Pawn) == none || KFXPawn(killed.Pawn) == none )
//    {
//    	log("[LABOR]------------killer pawn="$killer.Pawn@"killed pawn="$killed.pawn);
//        return false;
//    }
//
//    vecDistance = KFXPawn(killed.Pawn).Location - KFXPawn(killer.Pawn).Location;

//    nDistance = int ( self.VSize(vecDistance) );

    return self.CheckComparation( nDistance , condition );
}

//Usage:ÓÃÀ´¼ì²â¡°Í¬Ê± ¡±É±ËÀN¸öµÐÈËµÄÇéÐÎ
//ReturnValue:ÔÚµ±Ç°µÄ¡°Ò»Ë²¼ä  ¡±»÷É±µÄµÐÈËÊýÁ¿
//Author:Hawk Wang 2010-01-25
//Implement:1-ÊµÏÖË¼Â·£¬ÓÃÒ»¸ö¶¯Ì¬Êý×é£¬´æ·ÅÃ¿¸ö»÷É±ÊÂ¼þµÄµ÷ÓÃµÄÊ±¼ä´Á£¬Èç¹û×îºó
//Implement:2-µ½´ïµÄÊÂ¼þµÄÊ±¼ä´Á£¬¼õÈ¥¶ÓÁÐ¶¥¶ËµÄÊ±¼ä´Á£¬´óÓÚ¹æ¶¨µÄDeltaÖµ£¬ÄÇÃ´½«¶ÓÁÐ¶¥¶ËµÄ
//Implement:3-µÄÔªËØÒÆ³ý¡£×îºóÊ£ÏÂµÄArrayµÄ³¤¶È¾ÍÊÇ¡°Í¬Ê± ¡±»÷É±µÄÊýÁ¿¡£
//PS:ÐÒ¿÷ÎÒÊÇÑÐ¾¿Êý¾ÝÁ÷ÍÚ¾òµÄ£¬ÂíÉÏÏëµ½Õâ¸öÁË£¨8-£©¡£
Function int CheckAnnihilation()
{
    local float TimeStamp;
    local int Loop;

    //»ñÈ¡µ±Ç°ÈÎÎñµÄÊ±¼ä´Á
    TimeStamp = Level.TimeSeconds;

    //Ñ§±òËµ¿ÉÒÔÔÚForÑ­»·ÖÐ¶¯Ì¬É¾³ýArrayÖÐµÄÔªËØ£¬length ºÍ index ¶¼»á×Ô¶¯µÄ¸üÐÂ
    //Ì«ÈËÒ²Å®Âí·½±ãÁË[¾ªÌ¾ºÅ]
    for( Loop = InstantMultiKillQueue.Length -1 ; Loop >= 0 ; Loop-- )
    {
        //Èç¹û³¬¹ýDeltaÊ±¼ä£¬É¾µô¹ýÆÚµÄ»÷É±ÊÂ¼þµÄÊ±¼ä´Á¡£
        if( self.Abs(TimeStamp - InstantMultiKillQueue[Loop]) > InstantMultiKillDeltaTime )
        {
            InstantMultiKillQueue.Remove(loop,1);
        }
    }

    //½«µ±Ç°µÄÊ±¼ä´Á¼Óµ½ArrayµÄÄ©Î²¡£
    InstantMultiKillQueue[InstantMultiKillQueue.Length] = TimeStamp;

    ;

    //·µ»Øµ±Ç°µÄÍ¬Ê±»÷É±ÈËÊý¡£
    return InstantMultiKillQueue.Length;
}



//Uasge:´¦ÀíµôÂäÀàÈÎÎñµÄÊÂ¼þ
//param£º1-»÷É±Õß 2-±»É±µÄ
//param: 3-µôÂäÆ·µÄID£¬ÁôÕâ¸öÊÇÒòÎª KFXAIPickUpÀïÃ»°ì·¨µÃµ½killed µÄÒýÓÃ
//param: 4-Ôö¼Ó²ÎÊý£ºDroperID ±êÊ¶µôÂäÕßµÄID£¬killed ÀïµÄ leader ×Ö¶ÎÖ»ÄÜ¶ÔÖ±½Ó½ø°üµÄµÀ¾ßÉúÐ§£¡
//param: 4-DroperID ¿ÉÒÔÓ¦¶ÔÎ´À´NPCÀàÐÍÔö¶àµÄ ÎÊÌâ£¬Í¨¹ýDropperID¿ÉÒÔÔÚPickUpÖÐÅÐ¶ÏµôÂäÕß
//Author: Hawk Wang 2010-01-14
//notice£ºkilled ÀïµÄ leader ×Ö¶ÎÖ»¶ÔÖ±½Ó½ø°üµÄµÀ¾ßÉúÐ§£¬²»°²È«£¡
function Dropped( Controller Killer, Controller Killed, int DropItemID, optional int DroperID)
{
    local int Out_Loop;                     //Íâ²ãÑ­»·µÄ¿ØÖÆË÷Òý
    local int Inner_Loop;                   //ÄÚ³ÇÑ­»·µÄ¿ØÖÆË÷Òý
    local bool bAllConditionMatched;        //ËùÓÐÌõ¼þ¶¼Âú×ãµÄ±êÖ¾Î»
    local bool bCurrentConditionMatched;    //µ±Ç°µÄÌõ¼þµÃµ½Âú×ã
    local ServerTaskData CurrentTask;       //¼ÍÂ¼µ±Ç°ÕýÔÚ´¦ÀíµÄÈÎÎñ
    bCurrentConditionMatched = false;       //ÒÔºó»áÓÃµ½

    //¿ªÊ¼±éÀú
    For( Out_Loop = fxTasks[TASKTYPE_ITEM].Tasks.Length - 1; Out_Loop >= 0; Out_Loop-- )
    {
        //»ñÈ¡µ±Ç°ÈÎÎñ
        CurrentTask = fxTasks[TASKTYPE_ITEM].Tasks[Out_Loop];

        //³õÊ¼»¯£¨ÖØÖÃ£©Ìõ¼þÂú×ã±êÖ¾Î»
        bAllConditionMatched = true;

        //¶ÔÓÚÃ¿¸öÈÎÎñ£¬±éÀúÆäÃ¿¸öÌõ¼þ
        For( Inner_Loop = 0; Inner_Loop < CurrentTask.Conditions.Length; Inner_Loop++)
        {
            bCurrentConditionMatched = OperDropped(killer,killed,CurrentTask.Conditions[inner_Loop],DropItemID,DroperID);
            if( bCurrentConditionMatched == false )
            {
                bAllConditionMatched = false;
                break;//ÓÐÒ»¸ö²»Âú×ã£¬Ö±½ÓÌø³ö¾ÍºÃÁË£¬½ÚÊ¡Ê±¼ä
            }
        }//End Of Inner For:´¦ÀíÍê±ÏÒ»¸öÈÎÎñ

        //ËùÓÐÌõ¼þ¶¼Âú×ã£¬²ÅÄÜÎª¸ÃÈÎÎñµÄProgress Ôö¼ÓÒ»·Ö¡£
        if( bAllConditionMatched == true )
        {
            //Ö»ÓÐÕâÀï»áÖ´ÐÐ¡°Ð´ ¡±²Ù×÷£¬²»ÒªÔÚÕâÀïÊ¹ÓÃÁÙÊ±±äÁ¿CurrentTask
            SetServerProgress(TASKTYPE_ITEM, Out_Loop, 1);
        }
    }//End_Of_Out_For
}

//Usage:    ´¦ÀíµôÂäµÄÊµ¼Êº¯Êý
//param1-3: 1-»÷É±Õß 2-±»É±Õß 3-ÈÎÎñÌõ¼þ
//Param4-5: 4-µôÂäÎïÆ·£É£Ä  5-µôÂäÕß£É£Ä
//Author:   Hawk Wang 2010-01-21
Function bool OperDropped(controller killer,controller killed,TaskCondition condition,
                            int DropItemID, int DroperID)
{
    //ÐÂµÄµôÂäÀàÈÎÎñÅÐ¶¨Ìõ¼þÇëÈÓµ½ÕâÀï
    switch(condition.Factor)
    {
    //²»ÔÙÍ¨¹ýÊÇ·ñÉèÖÃIsLeader±êÖ¾Î»À´¶Ï¶¨ÊÇ·ñÎª¶Ó³¤µÄÌõ¼þÁË£¬
    //ÏÖÔÚÍ¨¹ýDropperIDÀ´ÅÐ¶Ï£¬Ö§³Ö¶à£É£ÄµÄÇé¿ö¡£
    case CON_IS_LEADER://ÅÐ¶ÏÊÇ·ñÎªÂíÈø°Â¶Ó³¤µÄÈÎÎñÌõ¼þ
            return (DroperID == condition.Value2);
        break;
    default:
        return false;
    }
}


//Usage:´¦ÀíµôÂäÀàÈÎÎñµÄÊÂ¼þ
//Author:Hawk Wang 2010-01-18
//Implement:1-Ö»ÒªÓÐÒ»¸öÈÎÎñÅÐ¶ÏÌõ¼þ²»Âú×ã£¬ÈÎÎñÅÐ¶Ï¼´¸æÊ§°Ü¡£
//Implement:2-ÓÀÔ¶²»ÒªÔÚÄÚ²ãÑ­»·³öÏÖ bAllConditionMatched = true ÕâÑùµÄÂß¼­
//Implement:3-Ö»ÄÜÍ¨¹ýÎªbAllConditionMatched = false Ê¹µÃÅÐ¶Ï¶ÌÂ·¡£
function DamageTook( Controller Killer, Controller Killed, class<DamageType> DmgType,optional int ActualDamage )
{
    local int Out_Loop;                     //Íâ²ãÑ­»·µÄ¿ØÖÆË÷Òý
    local int Inner_Loop;                   //ÄÚ³ÇÑ­»·µÄ¿ØÖÆË÷Òý
    local bool bAllConditionMatched;        //ËùÓÐÌõ¼þ¶¼Âú×ãµÄ±êÖ¾Î»
    local bool bCurrentConditionMatched;    //µ±Ç°µÄÌõ¼þµÃµ½Âú×ã
    local ServerTaskData CurrentTask;       //¼ÍÂ¼µ±Ç°ÕýÔÚ´¦ÀíµÄÈÎÎñ

    //¿ªÊ¼±éÀú
    For( Out_Loop = fxTasks[TASKTYPE_HURT].Tasks.Length - 1 ; Out_Loop >=0 ; Out_Loop-- )
    {
        //»ñÈ¡µ±Ç°ÈÎÎñ
        CurrentTask = fxTasks[TASKTYPE_HURT].Tasks[Out_Loop];

        //³õÊ¼»¯£¨ÖØÖÃ£©Ìõ¼þÂú×ã±êÖ¾Î»
        bAllConditionMatched = true;

        //¶ÔÓÚÃ¿¸öÈÎÎñ£¬±éÀúÆäÃ¿¸öÌõ¼þ
        For( Inner_Loop = 0; Inner_Loop < CurrentTask.Conditions.Length; Inner_Loop++)
        {
            //Èç¹ûÓÐÐÂÆ·ÖÖµÄÈÎÎñÌõ¼þ£¬ÇëÌí¼Óµ½ÕâÀïÀ´£¬Ð»Ð»ºÏ×÷
            bCurrentConditionMatched = OperDamageTook(killer,killed,CurrentTask.Conditions[inner_Loop],DmgType,ActualDamage);
            //Ö»ÒªÒ»¸öÌõ¼þÅÐ¶ÏÎª¼Ù£¬Õâ´ÎÅÐ¶¨Ê§Ð§£¡
            if(bCurrentConditionMatched == false)
            {
                bAllConditionMatched = false;
                break;//Ö±½ÓÌø³ö!
            }
        }//End Of Inner For:´¦ÀíÍê±ÏÒ»¸öÈÎÎñ

        //ËùÓÐÌõ¼þ¶¼Âú×ã£¬²ÅÄÜÎª¸ÃÈÎÎñµÄProgress Ôö¼ÓÒ»·Ö¡£
        if( bAllConditionMatched == true )
        {
            //ÕæÕýµÄ¡®Ð´  ¡¯²Ù×÷ÆäÊµÖ»ÓÐÕâÒ»´¦£¬ÕâÀï²»ÒªÊ¹ÓÃÁÙÊ±±äÁ¿£¬Ö±½ÓÐ´»ØArray¡£
            SetServerProgress(TASKTYPE_HURT, Out_Loop, 1);
        }
    }//End_Of_Out_For
}

//Usage Êµ¼Ê´¦ÀíÉËº¦µÄº¯Êý
//param1-3: 1-»÷É±Õß 2-±»É±Õß 3-ÈÎÎñÌõ¼þ
//Param4-5: 4-ÉËº¦ÀàÐÍ 5-ÉËº¦Öµ
//Author:Hawk Wang 2010-01-21
Function bool OperDamageTook(Controller killer,Controller killed,TaskCondition condition,
                            class<DamageType> DmgType,optional int ActualDamage)
{
    //Èç¹ûÓÐÐÂÆ·ÖÖµÄÈÎÎñÌõ¼þ£¬ÇëÌí¼Óµ½ÕâÀïÀ´£¬Ð»Ð»ºÏ×÷
    switch(condition.Factor)
    {
    case CON_DAMAGE_FALL://Ë¤ÉË
        return CheckFellRemainHeahth( Killed,condition,DmgType);
    default:
        return false;
    }
}

//Usage£ºÓÃÓÚÌ½²âPlayerÊÜÉËºóÊ£ÓàÑªÁ¿µÄÂß¼­¡£
//Param3:Êä³ö²ÎÊý£¬Èç¹ûÌõ¼þ²»Âú×ã£¬ÄÇÃ´±¾´ÎÅÐ¶ÏÊ§Ð§£¬ÖÃfalse£¬ÎÞÐ§µÄÈÎÎñ»ý·ÖÐÐÎª¡£
//Author: HawkWang
Function bool CheckFellRemainHeahth(Controller Killed,TaskCondition condition,class<DamageType> DmgType)
{
    local int RemainHealth;

    //Èç¹ûÉËº¦ÀàÐÍ²»ÊÇFell
    if( DmgType != class'fell' )
    {
        return false;
    }

    //Èç¹ûÉËº¦³ÐÔØÕß²»ÊÇ×Ô¼º
    if( Killed != fxPlayer )
    {
        return false;
    }

    //»ñÈ¡²ÐÓàÑªÁ¿
    RemainHealth = Killed.Pawn.Health;

    //Èý¼¶ÅÐ¶¨£ºµÈÓÚ´óÓÚÐ¡ÓÚºÍ¾ßÌåÖµµÄÅÐ¶¨
    return CheckComparation(RemainHealth, condition);
}

//Usage:ÓÃÀ´ÅÐ±ð´óÓÚ£¬µÈÓÚ£¬Ð¡ÓÚÈýÖÖÇé¿öµÄÖµµÄ±È½Ï
//Param1: Ô­Öµ£¬ÓÉÊÂ¼þ·¢ËÍ¶øÀ´
//Param2: ±È½ÏÄ¿±ê£¬ÓÉCSV¶ÁÈ¡¶øÀ´condition °üÀ¨±È½ÏÔËËã·û£¨value1£©ºÏ±È½ÏÔËËãÄ¿±êÖµ £¨value2£©
//Author: Hawk Wang 2010-01-21
Function bool CheckComparation(int sourceValue,TaskCondition condition)
{
    switch(condition.value1)
    {
    case 0://EQUAL
        return ( sourceValue == condition.Value2 );
    case 1://GREATER THAN
        return ( sourceValue > condition.Value2 );
    case 2://LESS THAN
        return ( sourceValue < condition.Value2 );
    default:
        return false;
    }
}

//
// ÖÓ£º¶Ô·þÎñÆ÷µ¥¾ÖÈÎÎñprogress½øÐÐ²Ù×÷£¬Ä¬ÈÏÎª¼ÓÖµ²Ù×÷£¬ºóÃæ²ÎÊýÖÃÎªtrueÔòÎª¸³Öµ²Ù×÷
//
function SetServerProgress(int taskType, int taskPos, int value, optional bool evaluate)
{
	local int taskID, progress;

	if(evaluate)
	{
		fxTasks[taskType].Tasks[taskPos].TaskProcess = value;
	}
	else
	{
		fxTasks[taskType].Tasks[taskPos].TaskProcess += value;
	}
	progress = fxTasks[taskType].Tasks[taskPos].TaskProcess;
	taskID = fxTasks[taskType].Tasks[taskPos].TaskID;
	fxTaskProgress = (progress + (taskID<<16))& 0xffffffff;
	;

	ServerTaskSynListAppend(fxTaskProgress);

	//TODO:¶ÔÈÎÎñÍê³ÉµÄÅÐ¶¨£¬Èç¹ûÍê³ÉÁËÈÎÎñ£¬¸üÐÂ·þÎñÆ÷Î»£¬É¾µô¶ÔÓ¦µÄÈÎÎñ£¡
    if(fxTasks[taskType].Tasks[taskPos].TaskProcess
    >= fxTasks[taskType].Tasks[taskPos].TaskTarget)
    {
        ;
        fxTasks[taskType].Tasks.Remove(taskPos, 1);
        fxPlayer.ServerOutTaskArray[fxPlayer.ServerOutTaskArray.Length] = TaskID;
    }
}

///
/// ÖÓ£ºÕë¶Ô¿Í»§¶ËÈÎÎñ£¬ÒªÇó´«Èë¸ÃÈÎÎñposºÍÔÚ±¾¾ÖÖÐµÄÍê³É¶È
///
simulated function SetClientProgress(int pos, int value)
{
	local int realProgress;
	realProgress = ClientTasks[pos].StartProcess + value;
	CallTaskMessage(ClientTasks[pos].TaskID, realProgress, "client:");
	if(realProgress >= ClientTasks[pos].Target)
	{
        ClientTasks.Remove(pos, 1);
	}
}

///
///ÖÓ£º½âÎöÍ¬²½ÐÅÏ¢£¬ÓÉÓÚÍ¬²½ÁË·þÎñÆ÷ÈÎÎñÊý¾Ý£¬ÐèÒª½âÎö³öÀ´idºÍ½ø¶È
///
simulated event PostNetReceive()
{
	local int taskID, taskProgress;
	if(fxLastTaskProgress != fxTaskProgress)
	{
		;
		taskID = GetBits(fxTaskProgress, 16, 16);
		taskProgress = GetBits(fxTaskProgress, 0, 16);
		fxLastTaskProgress = fxTaskProgress;
		CallTaskMessage(taskID, taskProgress, "server:");
	}
}

///
///×÷ÎªÍ¨ÖªhudÈÎÎñ½ø¶ÈµÄÈë¿Ú
///
simulated function CallTaskMessage(int taskID, int taskProgress, string where)
{
//	local string message;
	local KFXCSVTable CFG_TASKATT;
	local KFXCSVTable csvTask;
	local int target;
	CFG_TASKATT = class'KFXTools'.static.GetConfigTable(700);
	csvTask = class'KFXTools'.static.GetConfigTable(706);


	if ( !CFG_TASKATT.SetCurrentRow(taskID) )
    {
    	log("[KFXTaskManager] CallTaskMessage CFG_TASKATT no task id:"$taskID);
    	return;
    }
	if( csvTask == none || !csvTask.SetCurrentRow(TaskID))
	{
		log("##### WARNING #### can't find taskid="$taskID@"in task!");
		return;
    }
	target = CFG_TASKATT.GetInt("Target");

//	message = where$"task id:"$taskID$" taskProgress:"$taskProgress;
//	if(KFXHUD(fxPlayer.myHUD) != none)
//	{
//		KFXHUD(fxPlayer.myHUD).Message(none, message, 'System' );
//	}
//	message = "task complete:"$taskID;
	if(taskProgress >= target)
	{
		if(KFXHud(fxPlayer.myHUD) != none)
		{
			KFXHUD(fxPlayer.myHUD).PushTaskTip(TaskID, 2, csvTask.GetInt("TaskClass1st"));
		}
	}
	else
	{

	}
}

//Usage:ÓÃÀ´Ìí¼ÓÒ»¸öÈÎÎñ½ø³ÌÐÅÏ¢µ½Í¬²½ÁÐ±í£¬ ÓÃÒÔ¸üÐÂ¿Í»§¶ËÈÎÎñ×·×Ù
//Author:Hawk Wang 2010-02-03
Function ServerTaskSynListAppend( int TaskSynItem )
{
    ServerTaskSynArray[ServerTaskSynArray.Length] = TaskSynItem;
}

//Uasge:ÓÃÀ´Ä£Äâ·þÎñÆ÷µ½¿Í»§¶ËµÄÈÎÎñ×·×Ù£¬¸üÐÂ²Ù×÷¡£
Function ServerTaskSynListSimulateUpdate()
{
    if( ServerTaskSynArray.Length > 0 )
    {
        self.fxTaskProgress = ServerTaskSynArray[0];
        ServerTaskSynArray.Remove( 0, 1 );
    }
}

//Usage:Ä¿Ç°ÓÃÀ´ÔÚÃ¿Ö¡Ë¢ÐÂÈÎÎñµÄ½ø³Ì£¬Òì²½Ä£ÄâË¢ÐÂ£¡·ÇÍêÈ«Í¬²½£¡
Simulated event Tick( float DeltaTime )
{
    //Ö»ÔÚ·þÎñÆ÷¶Ë½øÐÐ¸üÐÂ
    if( Level.NetMode == NM_DedicatedServer )
    {
        ServerTaskSynListSimulateUpdate();
    }
}

defaultproperties
{
     InstantMultiKillDeltaTime=0.200000
     bHidden=是
     bAlwaysRelevant=是
     RemoteRole=ROLE_SimulatedProxy
     bCanRecord=否
     bNetNotify=是
}
