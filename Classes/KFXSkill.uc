//-----------------------------------------------------------
//¼¼ÄÜÀà£¬ËùÓÐ¹¦ÄÜ¶¼¼Óµ½ÕâÀï£¬°üÀ¨ÊôÐÔÅäÖÃ£¬ºÍ¹¦ÄÜ´úÂë
//-----------------------------------------------------------
class KFXSkill extends Skill;


var KFXPawn SkillOwner;

var int   SkillID;
var float SkillCD;   //ÎÞCDÎª0
var float RemainSkillCD;  //Ê£ÓàCDÊ±¼ä
var int   RemainSkillTimes; //Ê£Óà¼¼ÄÜ´ÎÊý£¬ÎÞÏÞÎª-1
var float SkillDistance;    //¼¼ÄÜÊ©·¨¾àÀë

var float SkillPreSec;  //¼¼ÄÜÇ°ÖÃÊ±¼ä,ÎÞÇ°ÖÃÎª0
var bool  bPreCanMove;    //¼¼ÄÜÇ°ÖÃÆÚ¼äÊÇ·ñ¿ÉÒÆ¶¯
var float SkillPreStartSec;
var name  PreSkillAnim;  //Ç°ÖÃ¼¼ÄÜ¶¯×÷

var float SkillDurSec;    //¼¼ÄÜ³ÖÐøÊ±¼ä£¬Ë³·¢Îª0
var bool  bDurCanMove;     //¼¼ÄÜÊÇ·ñ¿ÉÒÔÒÆ¶¯ÖÐÊÍ·Å
var float SkillStartSec;
var name  SkillAnim;  //¼¼ÄÜÊ©·Å¶¯×÷

var bool  bNeedKeep;          //ÊÇ·ñÐèÒª±£³ÖÊ©·¨
var int   NeedTarget;    //0²»ÐèÒªÄ¿±ê£¬Î»ÖÃÐÍ¼¼ÄÜ£¬1ÐèÒª¶Ô×¼Ä¿±ê£¬2ÐèÒª¶Ô×¼Ä¿±ê£¬µ«ÊÇÃ»ÓÐÄ¿±ê»òÕßÄ¿±êÎÞÐ§µÄÇé¿öÏÂ½øÐÐ×Ô¶¯Ä¿±êÆ¥Åä£¬3ÍêÈ«×Ô¶¯Ä¿±êÆ¥Åä£¬ºöÂÔÍâ²¿Ä¿±ê
var int   AutoTargetType;     //Èç¹ûÐèÒªÄ¿±ê£¬ÄÇÃ´×Ô¶¯Ä¿±êµÄÀàÐÍ£¬0Ã»ÓÐ×Ô¶¯Ä¿±ê£¬1×Ô¼º£¬2×î½ü¶ÓÓÑ(²»º¬×Ô¼º)£¬3×î½üµÐÈË£¬4×î½üÈ«ÌåÈÎÒâ£¨²»º¬×Ô¼º£©
var int   TargetLimit;        //Ä¿±êÏÞÖÆ£¬0È«ÌåÈÎÒâ£¬1½öÓÑ·½£¬2²»º¬×Ô¼ºµÄÓÑ·½£¬3½ö×Ô¼º£¬4½öµÐ·½
var int   AutoLocType;       //Èç¹û²»ÐèÒªÄ¿±ê£¬ÄÇÃ´È·¶¨¼¼ÄÜÎ»ÖÃµÄ·½·¨£¨¸ÃÖµÔÝÊ±²»ÓÃ£©

var int   SkillStateID;     //²úÉúµÄ¼¼ÄÜ×´Ì¬ID£¬Ã¿¸ö¼¼ÄÜÓÐÇÒÖ»ÓÐÒ»¸ö¼¼ÄÜ×´Ì¬£¬µ«ÊÇÒ»¸ö¼¼ÄÜ×´Ì¬¿ÉÄÜÓÐ¶àÖÖÐ§¹û£¬ÕâÌåÏÖÔÚ¼¼ÄÜ×´Ì¬ÖÐ

var KFXSkillState skillState;  //µ±Ç°¼¼ÄÜ¹ØÁªµÄ¼¼ÄÜ×´Ì¬
var KFXPawn TempTarget;         //ÁÙÊ±´æ´¢µÄÄ¿±ê£¬Ã¿´Î¼¼ÄÜ´¥·¢Ç°ÇåÀí
var vector  TempLoc;             //ÁÙÊ±´æ´¢Ê©·¨Î»ÖÃ£¬Ã¿´Î¼¼ÄÜ´¥·¢Ç°ÇåÀí

var bool bClientInList;            //ÒÑ¾­ÔÚ¿Í»§¶ËµÄ¼¼ÄÜÁÐ±í

var byte SkillCount;               //0ÎÞ¼¼ÄÜ¶¯×÷£¬1-20¼¼ÄÜÇ°ÖÃ¶¯×÷£¬21-40¼¼ÄÜÊ©·Å¶¯×÷

var byte  BotAutoPlayType;         //Bot×Ô¶¯Ê©·¨µÄÀàÐÍ£¬0²»ÄÜ×Ô¶¯Ê©·¨£¬1Ê±¼äÖÜÆÚÏÞÖÆ£¬2ÑªÁ¿°Ù·Ö±ÈÏÞÖÆ £¬3ËÀÍö´¥·¢£¬4Åö×²µÐ·½´¥·¢ £¬5ËÀÍö»òÕßÅö×²µÐ·½´¥·¢ 
var int  BotAutoPlayParam;          //Bot×Ô¶¯Ê©·¨²ÎÊý£¬ÈçÊ±¼ä±ä»¯ 
var int  AutoPlayParamVar;          //Bot×Ô¶¯Ê©·¨²ÎÊý±ä»¯Öµ


replication
{
	reliable if( bNetInitial && Role==ROLE_Authority )
		SkillID,SkillOwner;
	reliable if( (bNetInitial || bNetDirty) && Role==ROLE_Authority && bNetOwner )
		RemainSkillCD ,RemainSkillTimes;
	reliable if( (bNetInitial || bNetDirty) && Role==ROLE_Authority )
		SkillCount;
	reliable if( Role < ROLE_Authority  )
		SkillStart;
}

simulated function bool CheckBotNeedPlay()
{
  	switch(BotAutoPlayType)
  	{
  		case 0:
  			return false;
  		case 1:
  			if( AutoPlayParamVar > BotAutoPlayParam )
  				return true;
  			break;
  		case 2:
		  	if( SkillOwner.Health  < SkillOwner.HealthMax*BotAutoPlayParam )
			  	return true;
			break; 
  		default:
  			return false;
	}
	return false;

}

simulated function TickBotSkillCondition(float DeltaTime)
{
	switch(BotAutoPlayType)
	{
		case 1:
			AutoPlayParamVar += DeltaTime;
			break;
		default:
			break;
	} 

}

function OwnerDeadNotify()
{
	if(KFXBot(SkillOwner.Controller)==none)
		return; 
	switch(BotAutoPlayType)
  	{
  		case 3:
  			SkillStart(none);
  			break;
  		case 5:
		  	SkillStart(none);
			break; 
  		default:
	}
}

function OwnerTouchNotify(actor other)
{
	if(KFXBot(SkillOwner.Controller)==none)
		return; 
		
	switch(BotAutoPlayType)
	{
		case 4:
		if(KFXPawn(other)!=none)
		{
			if(KFXPawn(other).GetPRI().Team != SkillOwner.GetPRI().Team)
			{
				 SkillStart(KFXPawn(other));
			}
		}
		break;
		case 5:
		if(KFXPawn(other)!=none)
		{
			if(KFXPawn(other).GetPRI().Team != SkillOwner.GetPRI().Team)
			{
				 SkillStart(KFXPawn(other));
			}	
		}
		break;
	}	
} 

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();

	if(level.NetMode == NM_Client)
	{
		if(SkillID != 0)
		{
			KFXInit(SkillID);
		}
		else
		{
			log("KFXSkill PostNetBeginPlay failed SkillID is 0");
		}
	}
}


simulated function bool KFXInit(int id)
{
	local KFXCSVTable CSV_skill;

	log("KFXSkill KFXInit"@id);


	SkillID = id;
	CSV_skill = class'KFXTools'.static.GetConfigTable(801);

	if(! CSV_skill.SetCurrentRow(SkillID))
	{
		log("KFXSkill KFXInit can not find SkillID"@SkillID);
		return false;
	}

	SkillCD  = CSV_skill.GetFloat("SkillCD");
	if( Role==ROLE_Authority )
	{
		RemainSkillCD = SkillCD;
		RemainSkillTimes = CSV_skill.GetInt("SkillTimes");
	}
	SkillDistance =  CSV_skill.GetFloat("SkillDistance");

	bPreCanMove = CSV_skill.GetBool("bPreCanMove");
	SkillPreSec = CSV_skill.GetFloat("SkillPreSec");
	PreSkillAnim = CSV_skill.GetName("PreSkillAnim");

	bDurCanMove = CSV_skill.GetBool("bDurCanMove");
	SkillDurSec = CSV_skill.GetFloat("SkillDurSec");
	SkillAnim = CSV_skill.GetName("SkillAnim");

	bNeedKeep = CSV_skill.GetBool("bNeedKeep");
	NeedTarget = CSV_skill.GetInt("NeedTarget");
	AutoTargetType = CSV_skill.GetInt("AutoTargetType");
	TargetLimit = CSV_skill.GetInt("TargetLimit");
	AutoLocType = CSV_skill.GetInt("AutoLocType");

	SkillStateID = CSV_skill.GetInt("SkillStateID");

}

//ÓÉÓÚÄÚ²¿ÊµÏÖÊ¹ÓÃºÜ¶àPawnµÄconroller£¬¸Ãº¯Êý±ØÐëÔÚ·þÎñ¶ËÖ´ÐÐ
function bool FilterTarget(KFXPawn target)
{
	local int loop;
	local Controller pc;
	local float distance1,distance2;


	distance2 = SkillDistance;

	TempTarget = none;

	//ÅÐ¶ÏÍâ²¿Ä¿±êÊÇ·ñÄ¿±êÀàÐÍÊÜÏÞ
	if(target != none && (NeedTarget == 1 || NeedTarget == 2))
	{
		TempTarget = target;
		switch(TargetLimit)
		{
		case 0:
			break;
		case 1:
			if(TempTarget.GetTeamNum() == SkillOwner.GetTeamNum())
				break;
			else
				TempTarget = none;
			break;
		case 2:
			if(TempTarget.GetTeamNum() == SkillOwner.GetTeamNum() && TempTarget != SkillOwner)
				break;
			else
				TempTarget = none;
			break;
		case 3:
			if(TempTarget == SkillOwner)
				break;
			else
				TempTarget = none;
			break;
		case 4:
			if(TempTarget.GetTeamNum() != SkillOwner.GetTeamNum() )
				break;
			else
				TempTarget = none;
			break;
		}

		//¼ì²é¾àÀëÏÞÖÆ
		if(TempTarget != none)
		{
			distance1 = VSize(SkillOwner.Location - TempTarget.Location);
			if(distance1 > SkillDistance)
			{
				TempTarget = none;
			}
		}

	}

	//ÊÇ·ñÐèÒªºóÐøµÄ×Ô¶¯Ä¿±êÑ°ÕÒ
	if(TempTarget == none )
	{
		if(NeedTarget == 1)
			return false;
	}
	else if(NeedTarget == 1 || NeedTarget == 2)
	{
		return true;
	}

	//×Ô¶¯ËÑÑ°Ä¿±ê
	if(TempTarget == none)
	{

		switch(AutoTargetType)
		{
		case 0:
			break;
		case 1:
			TempTarget = SkillOwner;
			break;
		case 2:              //Àë×Ô¼º×î½üµÄ¶ÓÓÑ
			for(pc = level.ControllerList; pc != none ; pc = pc.nextController )
			{
				if(pc == SkillOwner.Controller || pc.GetTeamNum() != SkillOwner.GetTeamNum())
					continue;
				distance1 = Vsize(pc.Pawn.Location - SkillOwner.Location);
				if(distance1 < SkillDistance && distance1 < distance2)
				{
					distance2  = distance1;
					TempTarget = KFXPawn(pc.Pawn);
				}
			}
			break;

		case 3:           //Àë×Ô¼º×î½üµÄµÐÈË
			for(pc = level.ControllerList; pc != none ; pc = pc.nextController )
			{
				if( pc.GetTeamNum() == SkillOwner.GetTeamNum())
					continue;
				distance1 = Vsize(pc.Pawn.Location - SkillOwner.Location);
				if(distance1 < SkillDistance && distance1 < distance2)
				{
					distance2  = distance1;
					TempTarget = KFXPawn(pc.Pawn);
				}
			}
			break;


		case 4:       //Àë×Ô¼º×î½üµÄÈÎºÎÈË£¬²»º¬×Ô¼º
			for(pc = level.ControllerList; pc != none ; pc = pc.nextController )
			{
				if(pc == SkillOwner.Controller)
					continue;
				distance1 = Vsize(pc.Pawn.Location - SkillOwner.Location);
				if(distance1 < SkillDistance && distance1 < distance2)
				{
					distance2  = distance1;
					TempTarget = KFXPawn(pc.Pawn);
				}
			}
			break;

			//¼ì²é¾àÀëÏÞÖÆ
			if(TempTarget != none)
			{
				if(distance2 > SkillDistance)
				{
					TempTarget = none;
				}
			}

		}
	}

	if(TempTarget != none)
		return true;

}



simulated function bool FilterLoc()
{
	TempLoc = vect(0,0,0);

	TempLoc = SkillOwner.Location;
	return true;
}


simulated function float CDingTime()
{
	return RemainSkillCD;
}

simulated function int LimitTImes()
{
	return RemainSkillTimes;
}

simulated function ClientSkillStart(KFXPawn Target)
{
	log("KFXSkill ClientSkillStart"@target);
	if(RemainSkillCD > 0 )
		return;

	SkillStart(Target);
}


simulated function SkillStart(KFXPawn Target)
{
	log("KFXSkill SkillStart"@target);
	if(RemainSkillCD > 0 )
		return;

	if(NeedTarget > 0)
	{
		if(!FilterTarget(Target))
			return;
	}
	else
	{
		if(!FilterLoc())
			return;
	}

	skillOwner.skmgr.SkillStartCallBack(self);

	if(SkillPreSec > 0 )
	{
		SkillPreBegin();
	}
	else
	{
		SkillBegin();
	}
}

function SkillBreak()
{
	log("KFXSkill SkillBreak");
	//¹Øµô¼¼ÄÜÊÇ·ñ½øÐÐÖÐµÄÅÐ¶Ï±äÁ¿
	if(SkillPreStartSec > 0)
	{
		SkillPreStartSec = 0;
	}
	if(SkillStartSec > 0 )
	{
		SkillStartSec = 0;
	}

	//¿ÉÒÔ×ö¼¼ÄÜÖÐ¶ÏµÄÆäËû¹¦ÄÜ

}

simulated function SkillPreBegin()
{

	SkillPreStartSec = level.TimeSeconds;


	//ÓÃÓÚÍ¬²½¸ø¿Í»§¶Ë
    if( SkillCount >= 1 && SkillCount < 20 )
    {
    	SkillCount++;
	}
	else
	{
		SkillCount = 1;
	}

}

simulated function SkillBegin( )
{

	log("KFXSkill SkillBegin");

	//ÓÃÓÚÍ¬²½¸ø¿Í»§¶Ë
    if( SkillCount >= 21 && SkillCount < 40 )
    {
    	SkillCount++;
	}
	else
	{
		SkillCount = 21;
	}


	if( SkillDurSec > 0 )
	{
		//³ÖÐøÐÔ¼¼ÄÜ¼ÇÂ¼¿ªÊ¼Ê±¼ä
		SkillStartSec = level.TimeSeconds;
	}

	TempTarget.skmgr.AddSkillState(SkillStateID);

	RemainSkillCD = SkillCD;
}

simulated function Tick(float DeltaTime)
{
	local float distance1;
	local KFXSkillManager lSkMgr;
	super.Tick(DeltaTime);

	if(level.NetMode == NM_Client)
	{
	//µ±³ÖÓÐ¸Ã¼¼ÄÜµÄpawn±»Í¬²½¹ýÀ´Ö®ºó£¬Á¢¼´½«¸Ã¼¼ÄÜ¼ÓÈë¸ÃpawnµÄ¼¼ÄÜÁÐ±í
		if(SkillOwner!=none && SkillOwner.skmgr != none && !bClientInList)
		{
	        SkillOwner.skmgr.AddSkillRef(self);
	        bClientInList = true;
		}

		if(SkillCount >= 1 && SkillCount <= 20)
		{
			log("Begin PreSkillAnim");
			if(PreSkillAnim!='')
			{
				SkillOwner.PlayAnim(PreSkillAnim);
			}
			SkillCount=0;
		}

		if( SkillCount >= 21 && SkillCount <= 40 )
		{
			log("Begin SkillAnim");
			if(SkillAnim!='')
			{
				SkillOwner.PlayAnim(SkillAnim);
			}
			SkillCount=0;
		}
	}

	//µÝ¼õcdÊ±¼ä
	if( RemainSkillCD > 0 )
	{
		RemainSkillCD -= DeltaTime;
		if(RemainSkillCD < 0)
		{
			RemainSkillCD = 0;
		}
	}

	if(Role==ROLE_Authority)
	{


		if( SkillStartSec > 0 && SkillDurSec > 0)
		{
			//¼¼ÄÜ³ÖÐøÊ±¼äÄÚµÄtick´¦Àí


			//¼¼ÄÜÊ±¼ä½áÊø£¬´¦Àí
			if( level.TimeSeconds - SkillStartSec > SkillDurSec )
			{
				SkillStartSec = 0;

				if(bNeedKeep)
				{
					if(skillState != none)
					{
						skillState.Destroy();
					}
					TempTarget = none;
					TempLoc = vect(0,0,0);
				}
			}
		}
		else if( SkillPreStartSec > 0 && SkillPreSec > 0)
		{
			//¼¼ÄÜÇ°ÖÃÊ±¼äÄÚµÄtick´¦Àí
			if(level.TimeSeconds - SkillPreStartSec >= SkillPreSec)
			{
				distance1 = VSize(TempTarget.Location - SkillOwner.Location);

				//¼¼ÄÜÇ°ÖÃÊ±¼ä¹ýºó£¬ÔÙÒ»´Î¼ì²éÄ¿±êÊÇ·ñÔÚÇ°ÖÃÊ±¼äÄÚÅÜ³ö¼¼ÄÜ·¶Î§
				if(distance1 > SkillDistance)
				{
					SkillBreak();
					log("after pretime, distance over");
				}

				//Ç°ÖÃÊ±¼ä¹ýÁË£¬¼¼ÄÜ¿ªÊ¼
				SkillPreStartSec = 0;

				//¼¼ÄÜÕýÊ½¿ªÊ¼
				SkillBegin();
			}
			else
			{

			}
		}
	}
}

defaultproperties
{
     bHidden=是
     bAlwaysRelevant=是
     bOnlyDirtyReplication=是
     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=10.000000
     bNetNotify=是
}
