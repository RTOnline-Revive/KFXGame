//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXBuff extends Buff;

var int   buffID;
var int   buffGroup;       //buff×´Ì¬·Ö×é£¬Í¬Ò»×éµÄbuff×´Ì¬²»¿ÉÄÜÍ¬Ê±³öÏÖ
var bool  bBuffOrDebuff;    //Ôö¼õÒæ±êÖ¾£¬ÏàÍ¬ÓÅÏÈ¼¶ÏÂ£¬¼õÒæ×ÜÊÇÓÅÏÈÓÚÔöÒæ¶ø´æÔÚ
var int   buffPriority;   //ÓÅÏÈ¼¶£¬ÓÅÏÈ¼¶¸ßµÄbuff»á¼·µôÓÅÏÈ¼¶µÍµÄ
var string strBuffEffect;
var actor buffEffect;      //buffÌØÐ§
var float buffTime;        //buff³ÖÐøÊ±¼ä£¬0ÎªÓë×´Ì¬Í¬²½µÄbuff
var float buffCycle;          //ÖÜÆÚÐÔÐ§¹ûµÄÖÜÆÚ
var float speedFactor;         //ËÙ¶ÈÓ°ÏìÒò×Ó
var bool  bGodState;          //ÎÞµÐ×´Ì¬
var float health;           //ÉúÃüÔö¼õÖµ

var KFXPawn buffOwner;

var int updateTick;         //Ã¿´Î±»¸üÐÂÖÃ0£¬×Ô¼ºtick¸üÐÂ¼õ1

replication
{
	reliable if( bNetInitial && Role==ROLE_Authority )
		buffID,buffOwner;
	reliable if( (bNetInitial || bNetDirty) && Role==ROLE_Authority )
		buffTime;
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	if(level.NetMode == NM_Client)
	{
		KFXInit(buffID);
		if(buffOwner != none)
		{
			buffOwner.skmgr.AddBuffRef(self);
		}
		else
		{
			log("KFXBuff PostNetBeginPlay Error buffOwner is none");
		}
	}

}

simulated function Destroyed()
{
	super.Destroyed();

	log("KFXBuff Destroyed");

	if(bBuffOrDebuff)
	{
		buffOwner.skmgr.UpdateBuffList(self);
	}
	else
	{
		buffOwner.skmgr.UpdateDebuffList(self);
	}

	if(level.NetMode == NM_Client)
	{
		if(buffEffect != none)
		{
			buffEffect.Destroy();
		}
	}

}

simulated function KFXInit(int ID)
{
	local KFXCSVTable CSV_skillbuff;

	log("KFXBuff KFXInit"@ID);
	buffID = ID;

	CSV_skillbuff = class'KFXTools'.static.GetConfigTable(803);

	if(! CSV_skillbuff.SetCurrentRow(buffID))
	{
		log("KFXSkill KFXInit can not find SkillID"@buffID);
		return;
	}

	BuffPriority = CSV_skillbuff.GetInt("BuffPriority");
	BuffGroup = CSV_skillbuff.GetInt("BuffGroup");
	bBuffOrDebuff = CSV_skillbuff.GetBool("bBuffOrDebuff");

	if(Role==ROLE_Authority)
	{
		buffTime = CSV_skillbuff.GetFloat("BuffTime");
	}
	buffCycle = CSV_skillbuff.GetFloat("BuffCycle");
	speedFactor = CSV_skillbuff.GetFloat("SpeedFactor");
	bGodState = CSV_skillbuff.GetBool("bGodState");
	health = CSV_skillbuff.GetFloat("Health");

	if(level.NetMode == NM_Client)
	{
		strBuffEffect = CSV_skillbuff.GetString("StrBuffEffect");
		if(strBuffEffect!="null")
		{
			buffEffect = Spawn(class<Emitter>(DynamicLoadObject(strBuffEffect,class'class',false)),buffOwner,,buffOwner.Location);
			buffOwner.AttachToBone(buffEffect,'');
		}
	}

}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	buffTime -= DeltaTime;

	if(buffTime < 0)
	{
		buffTime = 0;
	}

	if(Role == ROLE_Authority)
	{
		if(buffTime == 0)
		{
			if(updateTick < -2)
			{
				Destroy();
			}
			updateTick--;
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
