//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXSkillManager extends SkillManager;


var Array<KFXBuff> buffInfos;     //µ±Ç°pawnÉíÉÏµÄbuffÊý×é
var Array<KFXBuff> deBuffInfos;   //µ±Ç°pawnÉíÉÏµÄdebuffÊý×é


var KFXCSVTable CSV_skill;
var KFXCSVTable CSV_skillstate;
var KFXCSVTable CSV_skillbuff;

var KFXPawn skmgrOwner;
var Array<KFXSkill> SkillList;   //½ÇÉ«¼¼ÄÜÁÐ±í£¬ownerÊ¹ÓÃÍ¬²½º¯ÊýÎ¬»¤

var KFXSkill ActiveSkill;         //µ±Ç°ÕýÔÚ±£³ÖÊ©·¨µÄ¼¼ÄÜ£¬ownerÍ¬²½
var AnimRep SkillAnim;              //Í¬²½µÄ¼¼ÄÜ¶¯×÷
var AnimRep ClientSkillAnim;         //¿Í»§¶Ë¼ÇÂ¼ÉÏ´ÎµÄ¼¼ÄÜ¶¯×÷

var Array<KFXSkillState> SkillStateList;   //¼¼ÄÜ×´Ì¬ÁÐ±í£¬×´Ì¬¸÷×Ô½øÐÐÍ¬²½£¬¸ÃÁÐ±í²»½øÐÐÍ¬²½£¬Õâ¸öÁÐ±íÖ»ÔÚ·þÎñ¶ËÓÐ

var actor LockTarget;       //¸ú×ÙµÄ¹¥»÷Ä¿±ê£¨AI×¨ÓÃ£©

replication
{
	reliable if( (bNetDirty || bNetInitial) && Role==ROLE_Authority )
		SkillAnim;

	reliable if( (bNetDirty || bNetInitial) && Role==ROLE_Authority && bNetOwner )
		ActiveSkill;
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	log("KFXSkillManager PostNetBeginPlay"@self);
}

simulated function PostBeginPlay()
{
	CSV_skill = class'KFXTools'.static.GetConfigTable(801);
	CSV_skillstate = class'KFXTools'.static.GetConfigTable(802);
	CSV_skillbuff = class'KFXTools'.static.GetConfigTable(803);
}

//ÄÜ·ñÔÚµ±Ç°pawnÉÏ¼ÓÉÏÄ³¸ö¼¼ÄÜÐ§¹û
simulated function bool CanAddSkillState(int SkillStateID)
{
	local int loop;
	local int priority,group;
	local bool buffOrDebuff;


	return true;

}

function KFXSkillState AddSkillState(int SkillStateID)
{
	local int loop;
	local int priority,group;
	local bool buffOrDebuff;
	local KFXSkillState newState;


	if(!CSV_skillstate.SetCurrentRow(SkillStateID))
	{
		log("AddSkillState skillstate table can not find id"@SkillStateID);
		return none;
	}

	newState = Spawn(class'KFXSkillState',skmgrOwner);

	if(newState == none)
	{
		log("AddSkillState spawn newstate failed");
		return none;
	}

	newState.StateOwner = skmgrOwner;
	newState.KFXInit(SkillStateID);


	SkillStateList[SkillStateList.Length]= newState;


	return newState;
}

function AddBuff(int buffID)
{
	local KFXBuff newBuff;
	local int loop;
	local int priority,group;
	local bool buffOrDebuff;

	if(!CSV_skillbuff.SetCurrentRow(buffID))
	{
		log("KFXSkillManager AddBuff Failed buffID"@buffID);
		return;
	}

	priority = CSV_skillbuff.GetInt("BuffPriority");
	group = CSV_skillbuff.GetInt("BuffGroup");
	buffOrDebuff = CSV_skillbuff.GetBool("bBuffOrDebuff");

	if(buffOrDebuff)
	{
		//¼õÒæÐ§¹ûÓÅÏÈ
		for(loop=0; loop < DebuffInfos.Length; loop ++)
		{
			if(DebuffInfos[loop].BuffGroup == group && DebuffInfos[loop].BuffPriority >= priority)
				return;
		}

		//¸ß¼¶Ð§¹ûÓÅÏÈ,Í¬Ò»¸öbuff¸üÐÂÊ£ÓàÊ±¼ä£¬·ñÔòÉ¾µô¸Ãbuff£¬Ê¹ÓÃÐÂbuff
		for(loop=0; loop < BuffInfos.Length; loop ++)
		{
			if(BuffInfos[loop].BuffGroup == group )
			{
				if( buffID == BuffInfos[loop].buffID )
				{
					BuffInfos[loop].updateTick = 0;
					if(BuffInfos[loop].buffTime > 0)
						BuffInfos[loop].buffTime = CSV_skillbuff.GetFloat("BuffTime");
					return;
				}
				else if ( BuffInfos[loop].BuffPriority > priority )
					return;
				else
				{
					BuffInfos[loop].Destroy();
					BuffInfos.Remove(loop,1);
					break;
				}
			}
		}
	}
	else
	{
		//¸ß¼¶Ð§¹ûÓÅÏÈ
		for(loop=0; loop < DebuffInfos.Length; loop ++)
		{
			if(DeBuffInfos[loop].BuffGroup == group )
			{
				if( buffID == DeBuffInfos[loop].buffID )
				{
					DeBuffInfos[loop].updateTick = 0;
					if(BuffInfos[loop].buffTime > 0)
						DeBuffInfos[loop].buffTime = CSV_skillbuff.GetFloat("BuffTime");
					return;
				}
				else if ( DeBuffInfos[loop].BuffPriority > priority )
					return;
				else
				{
					DeBuffInfos[loop].Destroy();
					DeBuffInfos.Remove(loop,1);
					break;
				}
			}
		}
	}

	newBuff = Spawn(class'KFXBuff',skmgrOwner);
	newBuff.buffOwner = skmgrOwner;
	if(buffOrDebuff)
	{
  		BuffInfos[BuffInfos.Length]=newBuff;
	}
	else
	{
		DebuffInfos[DebuffInfos.Length]=newBuff;
	}

	newBuff.KFXInit(buffID);
}

simulated function AddBuffRef(KFXBuff buff)
{
	if(buff.bBuffOrDebuff)
	{
		buffInfos[buffInfos.Length]= buff;
	}
	else
	{
		DebuffInfos[DebuffInfos.Length] = buff;
	}
}

simulated function UpdateBuffList(KFXBuff Removedbuff)
{
	local int loop;
	for(loop=0; loop < buffInfos.Length; loop++)
	{
		if(buffInfos[loop]==none || buffInfos[loop] == Removedbuff)
		{
			buffInfos.Remove(loop,1);
			loop--;
		}
	}
}

simulated function UpdateDebuffList(KFXBuff Removedbuff)
{
	local int loop;
	for(loop=0; loop < DebuffInfos.Length; loop++)
	{
		if(DebuffInfos[loop]==none || DebuffInfos[loop]==Removedbuff)
		{
			DebuffInfos.Remove(loop,1);
			loop--;
		}
	}
}

simulated function UpdateStateList(KFXSkillState RemovedState)
{
	local int loop;
	for(loop=0; loop < SkillStateList.Length; loop++)
	{
		if(SkillStateList[loop]==none || SkillStateList[loop]==RemovedState)
		{
			SkillStateList.Remove(loop,1);
		}
	}
}

simulated function float GetSpeedFactor()
{
	local int loop;
	local float speedFactor;

	for(loop=0; loop < buffInfos.Length; loop ++ )
	{
		speedFactor += buffInfos[loop].SpeedFactor;
	}
	for(loop =0; loop < DebuffInfos.Length; loop++)
	{
		speedFactor += DebuffInfos[loop].speedFactor;
	}
	return speedFactor;
}

function AddSkill(int skillID)
{
	local KFXSkill newSkill;

	log("AddSkill"@skillID@skmgrOwner);
	newSkill = Spawn(class'KFXSkill',skmgrOwner);
	if(newSkill == none)
	{
		log("Spawn KFXSkill Failed"@skillID);
		return;
	}

	newSkill.SkillOwner = skmgrOwner;
	newSkill.KFXInit(skillID);
}

simulated function AddSkillRef(KFXSkill skill)
{
	log("KFXSkillManager AddSkillRef"@skill);
	SkillList[SkillList.Length] = skill;
}


simulated function ClientPlaySkill(int Index,KFXPawn target)
{
	log("KFXSkillManager ClientPlaySkill"@index@target);
	if( SkillList[Index-1].CDingTime() > 0 )
		return;

	SkillList[Index-1].ClientSkillStart(target);

}

//¼¼ÄÜ±£Ö¤³É¹¦Ê©·ÅÇ°µÄ»Øµ÷º¯Êý
function SkillStartCallBack(KFXSkill skill)
{
	if(ActiveSkill != none )
	{
		ActiveSkill.SkillBreak();
	}
	ActiveSkill = skill;
}

function BotAutoPlaySkills()
{
	local int loop;
	for(loop=0; loop < SkillList.Length; loop++)
	{
		if(SkillList[loop].CheckBotNeedPlay())
		{
			SkillList[loop].SkillStart(none);
		}
	}
}

simulated function Destroyed()
{
	local int loop;
	super.Destroyed();
	for(loop=0; loop < SkillList.Length; loop++ )
	{
		if( SkillList[loop]!= none )
			SkillList[loop].Destroy();
	}

	for(loop=0; loop < SkillStateList.Length; loop++ )
	{
		if( SkillStateList[loop]!= none )
			SkillStateList[loop].Destroy();
	}

	for(loop=0; loop < buffInfos.Length; loop++ )
	{
		if(buffInfos[loop]!=none)
			buffInfos[loop].Destroy();
	}

	for(loop=0; loop < DebuffInfos.Length; loop++ )
	{
		if(DebuffInfos[loop]!=none)
			DebuffInfos[loop].Destroy();
	}


}

simulated function TickBotSkillCondition(float DeltaTime)
{
	local int loop;
	for(loop=0; loop < SkillList.Length; loop ++ )
	{
		SkillList[loop].TickBotSkillCondition(DeltaTime);
	}
}

function OwnerDeadNotify()
{
	local int loop;
	for(loop=0; loop < SkillList.Length; loop ++ )
	{
		SkillList[loop].OwnerDeadNotify();
	}
}

function OwnerTouchNotify(actor other)
{
	local int loop;
	for(loop=0; loop < SkillList.Length; loop ++ )
	{
		SkillList[loop].OwnerTouchNotify(other);
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
