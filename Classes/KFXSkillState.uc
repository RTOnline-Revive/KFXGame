//-----------------------------------------------------------
//¼¼ÄÜ×´Ì¬
//-----------------------------------------------------------
class KFXSkillState extends SkillState;

var int stateID;

var float stateTime;      //×´Ì¬Ê£ÓàÊ±¼ä£¬-1ÎªË²·¢¼¼ÄÜµÄÐ§¹û£¬-2ÎªÓë¼¼ÄÜÍ¬²½
var float stateCycle;     //Ð§¹ûÖÜÆÚ

var string StrStateEffect;  //×´Ì¬ÌØÐ§×Ö·û´®
var actor StateEffect;      //×´Ì¬ÌØÐ§
var float Health;           //ÊÜÓ°Ïìµ¥Î»µÄÉúÃüÖµÔö¼õ
var int  buffID;            //ÊÜÓ°Ïìµ¥Î»ÉíÉÏµÄbuff

var bool  bSelfState;        //×´Ì¬³ÖÓÐÕßÊÇ·ñÊÜ×´Ì¬Ð§¹ûÓ°Ïì
var float StateRadius;        //×´Ì¬Ó°ÏìµÄ·¶Î§£¬0Îªµ¥Ìå¼¼ÄÜ
var int   StateTeamType;         //·¶Î§ÄÚ£¬1Ê©·¨ÕßÓÑ·½ÓÐÐ§£¬2Ê©·¨ÕßµÐ·½ÓÐÐ§£¬0È«ÌåÓÐÐ§

//ÆäËû¹ØÁª
var KFXSkill Skill;        //Ôì³ÉÕâ¸ö¼¼ÄÜ×´Ì¬µÄ¼¼ÄÜ
var KFXPawn  Skiller;       //Ê©·ÅÕß
var KFXPawn  StateOwner;       //±»Ê©·ÅÕß£¬¸Ã¼¼ÄÜµÄÖÐÐÄÔÚÕâ¸öpawnÉÏ£¬Èç¹ûÎªnone£¬ÔòÊÇÎÞÄ¿±êµÄ·¶Î§ÐÔ¼¼ÄÜ

replication
{
	reliable if( bNetInitial && Role==ROLE_Authority )
		StateOwner,Skiller,stateID;
	reliable if( (bNetInitial || bNetDirty) && Role==ROLE_Authority )
		stateTime;
}



//todo£ºÆäËûÊôÐÔÓ°Ïì£¬ÒÔ¼°ÌØÊâ¹¦ÄÜ


simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();

	if( level.NetMode == NM_Client )
	{
		if(StateID != 0)
		{
			KFXInit(StateID);
		}
		else
		{
			log("KFXSkillState PostNetBeginPlay Failed StateID is 0");
		}
	}
}



simulated function KFXInit(int ID)
{
	local KFXCSVTable CSV_skillstate;

	log("KFXSkillState KFXInit"@ID);

	StateID = id;
	CSV_skillstate = class'KFXTools'.static.GetConfigTable(802);

	if(! CSV_skillstate.SetCurrentRow(StateID))
	{
		log("KFXSkill KFXInit can not find SkillID"@StateID);
		return;
	}

	if(Role==ROLE_Authority)
	{
		stateTime = CSV_skillstate.GetFloat("stateTime");
	}
	stateCycle = CSV_skillstate.GetFloat("stateCycle");
	StateTeamType = CSV_skillstate.GetInt("StateTeamType");
	StateRadius = CSV_skillstate.GetFloat("StateRadius");
	bSelfState =  CSV_skillstate.GetBool("bSelfState");
	StrStateEffect = CSV_skillstate.GetString("StateEffect");

	Health =  CSV_skillstate.GetFloat("Health");
	buffID =   CSV_skillstate.GetInt("BuffID");

	//Õâ¾ä´úÂëÓÐÇ°ÌáµÄ£¬¾ÍÊÇÕâ¸ö¶ÔÏó²»ÄÜÔÚstateowner´´½¨Ö®ºóÁ¢¼´´´½¨£¬ÒòÎªpawnÍ¬²½½ÏÂý
	stateOwner.AttachToBone(self,'');

}


simulated function Tick(float DeltaTime)
{
	local Controller pc;
	local float Distance;
	//×Ô¼õ×´Ì¬³ÖÐøÊ±¼ä
	stateTime -= DeltaTime;
	if( stateTime < 0 )
	{
		stateTime = 0;
	}

	if( Role==ROLE_Authority )
	{

		//´úÂëÖÐ´æÔÚÈý´¦Ö÷¶¯Ïú»Ù×´Ì¬µÄÇé¿ö£º
		//1.×´Ì¬µ½ÆÚ×Ô¶¯Ïú»Ù£¬ÔÚÕâÀï
		//2.×´Ì¬ÔÚÄ³¸öpawnÉÏ£¬pawn±»Ïú»ÙÊ±£¬ÉíÉÏµÄ×´Ì¬Ò²ÒªÏú»Ù
		//3.×´Ì¬ÊÇÓë¼¼ÄÜÊÍ·Å±£³ÖÍ¬²½µÄ£¬¼¼ÄÜ½áÊø»òÖÕÖ¹£¬×´Ì¬¾ÍÍ¬Ê±±»Ïú»ÙÁË
		if( stateTime == 0 )
		{
			Destroy();           //ËùÓÐ×´Ì¬¶¼ÊÇµ½ÆÚ×Ô¶¯Ïú»Ù
		}


		if(bSelfState)
		{
			StateOwner.skmgr.AddBuff(buffID);
		}

		if(StateRadius > 0)
		{
			log("KFXSkillManager Tick AddBuff");
			if(StateTeamType == 1)
			{
				for(pc = level.ControllerList; pc != none ; pc = pc.nextController )
				{
					if( pc.GetTeamNum() != StateOwner.GetTeamNum())
						continue;
					Distance = Vsize(pc.Pawn.Location - StateOwner.Location);
					if( Distance < StateRadius )
					{
						KFXPawn(pc.Pawn).skmgr.AddBuff(buffID);
					}
				}
			}

			if(StateTeamType == 0)
			{
				for(pc = level.ControllerList; pc != none ; pc = pc.nextController )
				{
					Distance = Vsize(pc.Pawn.Location - StateOwner.Location);
					if( Distance < StateRadius )
					{
						KFXPawn(pc.Pawn).skmgr.AddBuff(buffID);
					}
				}
			}

			if(StateTeamType == 2)
			{
				for(pc = level.ControllerList; pc != none ; pc = pc.nextController )
				{
					if( pc.GetTeamNum() == StateOwner.GetTeamNum())
						continue;
					Distance = Vsize(pc.Pawn.Location - StateOwner.Location);
					if( Distance < StateRadius )
					{
						KFXPawn(pc.Pawn).skmgr.AddBuff(buffID);
					}
				}
			}


		}
	}


}

simulated function Destroyed()
{
	super.Destroyed();

	log("KFXSkillState Destroyed");

	if(StateOwner!= none)
		StateOwner.skmgr.UpdateStateList(self);

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
