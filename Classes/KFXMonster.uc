//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXMonster extends MonsterController;

var int Suit;

var float kfx_firerate;
var float kfx_fireoffset;
var float kfx_rotationrate;
var float kfx_PeripheralVision;

var int Health;
var float BotVelocity;
var float HearDist;

var localized string BotNameStr;
var localized string LeaderBotNameStr;
var NavigationPoint BotStartSpot;
var            actor                       LastDestination;

var            actor                       MoveFocus;
var int WeaponTypeLimit;
var bool Leader;
var bool bHeadKill;


var            int                        nBotType;

var            int                         RowWeaponID;

var            float                       DodgeBulletDist;
var            float                       DodgeBulletRate;
var            float                       CrouchRate;
var            float                       CrouchTime;
var            float                       JumpRate;
var            float                       BotSpeedWhenDamaged;
//var            float                       OldSpeedScale;//BOTÏÈÇ°µÄSpeedScale
var            float                       DamageFactor;
var            bool                        bIsGhost;       //ÊÇ·ñÊÇÓÄÁéÀàBOT
var            name                        PlayerStartTag;

var            float                       FirstRestartTime;//µÚÒ»´Î¸´»î¼ä¸ô
var            float                       NextRestartTime;//¾àÀëÏÂÒ»´Î¸´»î¼ä¸ô
var            bool                        bFirstRestart;

var            int                         AddHealth;    //Ã¿¹ØBOTÔö¼ÓµÄÐÅÏ¢
var            int                         AddDamage;
var            int                         AddSpeed;
var            int                         AddRepulsed;
var            byte                        BotType;         //0ÆÕÍ¨£¬1 BOSS
var            float                       BotDropRate;


var            int                         MainWeaponID;
var            int                         SubWeaponID;
var            int                         MeleeWeaponID;
var            int                         TossWeaponID;


var            bool                        bIsHostage;
var            float                       SaveSpeedScale;

var int nOrgBotType;

function AddBotInventory()
{
    log("KFXBot-------MainWeaponID "$MainWeaponID);
    log("KFXBot-------SubWeaponID "$SubWeaponID);
    log("KFXBot-------MeleeWeaponID "$MeleeWeaponID);
    log("KFXBot-------TossWeaponID "$TossWeaponID);

    class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn),MainWeaponID);
    class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn),SubWeaponID);
    class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn),MeleeWeaponID);
    class'KFXPropSystem'.static.KFXCreateWeapon(KFXPawn(Pawn),TossWeaponID);
}
function AddEnermy(Controller C)
{
    log("KFXBot--------C "$C);
    if(Enemy == none)
    {
        Enemy = C.Pawn;
    }
}
function InitBotInfo(int nBot)
{
    local KFXCSVTable CFG_BotInfo;

    CFG_BotInfo = class'KFXTools'.static.GetConfigTable(309);

    if ( !CFG_BotInfo.SetCurrentRow( nBot ) )
    {
        Log("[Kevin] Can't Resolve The BotBasic Info ID : "$nBot);
        return ;
    }

//    Aggressiveness   = CFG_BotInfo.GetFloat("Aggressiveness");
    Accuracy = CFG_BotInfo.GetFloat("Accuracy");
    CombatStyle = CFG_BotInfo.GetFloat("CombatStyle");
//    Tactics   = CFG_BotInfo.GetFloat("Tactics");
//    Jumpiness = CFG_BotInfo.GetFloat("Jumpiness");
    ReactionTime = CFG_BotInfo.GetFloat("ReactionTime");
    StrafingAbility = CFG_BotInfo.GetFloat("StrafingAbility");
//	Aggressiveness = FClamp(Aggressiveness, 0, 1);
	Accuracy = FClamp(Accuracy, -5, 5);
	StrafingAbility = FClamp(StrafingAbility, -5, 5);
	CombatStyle = FClamp(CombatStyle, 0, 1);
//	Tactics = FClamp(Tactics, -5, 5);
	ReactionTime = FClamp(ReactionTime, -5, 5);

//    log("KFXBot----Aggressiveness"$Aggressiveness);
    log("KFXBot----Accuracy"$Accuracy);
    log("KFXBot----CombatStyle"$CombatStyle);
//    log("KFXBot----Tactics"$Tactics);
//    log("KFXBot----Jumpiness"$Jumpiness);
    log("KFXBot----ReactionTime"$ReactionTime);


//	BaseAggressiveness = Aggressiveness;
}
function InitMonster(int nBot, optional int RowID)
{
    nBotType =  nBot;
    InitBotSuperSkill(nBot);
    InitBotBasicInfo(nBot);
    InitBotSuit(nBot);
    InitBotWeapon(nBot);
    InitializeKFXSkill(nBot);

    InitBotPerGuanInfo();
    InitBonusFactor(0);
    RowWeaponID = nBot;
    log("KFXBot---nBotType"$nBotType);
    log("KFXBot---RowID"$nBot);
}

function InitBotBasicInfo(int RowID)
{
    local KFXCSVTable CFG_BotInfo;

    CFG_BotInfo = class'KFXTools'.static.GetConfigTable(309);

    if ( !CFG_BotInfo.SetCurrentRow( RowID ) )
    {
        Log("[Kevin] Can't Resolve The BotBasic Info ID : "$RowID);
        return ;
    }
//    log("KFXBot----InitBotBasicInfo");
    Health   = CFG_BotInfo.GetFloat("BotHealthLimit");
    BotVelocity = CFG_BotInfo.GetFloat("BotVelocity");
    kfx_PeripheralVision = CFG_BotInfo.GetFloat("SeeAngle");
    kfx_PeripheralVision = FClamp(kfx_PeripheralVision, 30, 175);
    kfx_PeripheralVision = kfx_PeripheralVision/180.0*3.1415926;
    kfx_PeripheralVision = Cos(kfx_PeripheralVision);
    HearDist             = CFG_BotInfo.GetFloat("HearDistance");
    FirstRestartTime     = CFG_BotInfo.GetFloat("FirstRestartTime");
    NextRestartTime      = CFG_BotInfo.GetFloat("NextRestartTime");
    BotType              = CFG_BotInfo.GetFloat("BotType");
    BotDropRate          = CFG_BotInfo.GetFloat("BotDropRate");

    log("KFXBot----Health "$Health);
    log("KFXBot----BotType "$BotType);
    log("KFXBot----BotVelocity "$BotVelocity);
    log("KFXBot----kfx_PeripheralVision "$kfx_PeripheralVision);
    log("KFXBot----FirstRestartTime "$FirstRestartTime);
    log("KFXBot----NextRestartTime "$NextRestartTime);
    log("KFXBot----BotDropRate "$BotDropRate);
}

function InitializeKFXSkill(optional int RowID)
{
    local KFXCSVTable CFG_BotSkill;

	CFG_BotSkill= class'KFXTools'.static.GetConfigTable(309);
	if ( !CFG_BotSkill.SetCurrentRow( RowID ) )
    {
        Log("[Kevin] Can't Resolve The Bot Skill ID : "$RowID);
        return ;
    }
    else
	{
	    log("KFXBot----InitializeSkill");
        kfx_firerate = CFG_BotSkill.GetFloat("Firerate");
        kfx_fireoffset = CFG_BotSkill.GetFloat("FireOffset");
        kfx_rotationrate = CFG_BotSkill.GetFloat("RotationRate");
        RotationRate.Yaw = kfx_rotationrate;
    }
}

function InitBotSuperSkill(optional int RowID)
{
    local KFXCSVTable CFG_BotSuperSkill;

	CFG_BotSuperSkill= class'KFXTools'.static.GetConfigTable(309);
	if ( !CFG_BotSuperSkill.SetCurrentRow( RowID ) )
    {
        Log("[Kevin] Can't Resolve The Bot super Skill ID : "$RowID);
        return ;
    }
    else
	{
	    log("KFXBot----Init super Skill");
        DodgeBulletDist = CFG_BotSuperSkill.GetFloat("DodgeBulletDist");  //¶ã×Óµ¯Ê±£¬×óÓÒÒÆ¶¯¾àÀë
        DodgeBulletRate = CFG_BotSuperSkill.GetFloat("DodgeBulletRate");  //¶ã×Óµ¯Ê±£¬×óÓÒÒÆ¶¯¸ÅÂÊ
        CrouchRate      = CFG_BotSuperSkill.GetFloat("CrouchRate");       //ÏÂ¶×¸ÅÂÊ
        CrouchTime      = CFG_BotSuperSkill.GetFloat("CrouchTime");       //ÏÂ¶×Ê±¼ä
        JumpRate        = CFG_BotSuperSkill.GetFloat("JumpRate");         //ÆðÌø¸ÅÂÊ
        BotSpeedWhenDamaged = CFG_BotSuperSkill.GetFloat("BotVelocityWhenDamaged");  //ÊÜÉËµÄÊ±ºòBOTÅÜ¶¯ËÙ¶È
        DamageFactor    = CFG_BotSuperSkill.GetFloat("DamageFactor");
        bIsGhost        = CFG_BotSuperSkill.GetBool("bIsGhost");
        PlayerStartTag  = CFG_BotSuperSkill.GetName("PlayerStartTag");
        log("KFXBot----Init super bIsGhost "$bIsGhost);
        log("KFXBot----Init super PlayerStartTag "$PlayerStartTag);
    }
}
function InitBotPerGuanInfo();
function InitBonusFactor(int GameType);

//Ôö¼ÓÁËµ±ÎäÆ÷Ã»ÓÐ×Óµ¯µÄÊ±ºò×Ô¶¯ÇÐ»»ÏÂÒ»¼¶ÎäÆ÷µÄ¹¦ÄÜ
function SwitchToBestWeapon()
{
    local float rating;

    if ( Pawn == None || Pawn.Inventory == None )
        return;

    //if ( (Pawn.PendingWeapon == None) || (AIController(self) != None) )
    //{
    Pawn.PendingWeapon = Pawn.Inventory.RecommendWeapon(rating);

    //<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø
    if( Pawn.PendingWeapon != none
    &&KFXWeapBase(Pawn.PendingWeapon) != none
    &&!KFXWeapBase(Pawn.PendingWeapon).KFXHasAmmo() )
    {
        ;
        Pawn.PendingWeapon = Pawn.Inventory.WeaponChange(2, false);

        if( Pawn.PendingWeapon == none )
            ;

        if( KFXWeapBase(Pawn.PendingWeapon).KFXHasAmmo() )
            ;
        else
            ;
    }

    if( Pawn.PendingWeapon != none
    &&KFXWeapBase(Pawn.PendingWeapon) != none
    &&!KFXWeapBase(Pawn.PendingWeapon).KFXHasAmmo() )
    {
        ;
        Pawn.PendingWeapon = Pawn.Inventory.WeaponChange(4, false);
    }

    if( Pawn.PendingWeapon == none
    ||(KFXWeapBase(Pawn.PendingWeapon) != none
    &&!KFXWeapBase(Pawn.PendingWeapon).KFXHasAmmo()) )
    {
        ;
        Pawn.PendingWeapon = Pawn.Inventory.WeaponChange(3, false);
    }
    //>>

    if ( Pawn.PendingWeapon == Pawn.Weapon )
    {
        //LOG("KFXBot SwitchToBestWeapon return");
        Pawn.PendingWeapon = None;
    }


    if ( Pawn.PendingWeapon == None )
    {
        ;
        return;
    }
    StopFiring();
    if ( Pawn.Weapon == None )
        Pawn.ChangedWeapon();
    else if ( Pawn.Weapon != Pawn.PendingWeapon )
    {
        Pawn.Weapon.PutDown();
    }
}

function int GetGameTaskType()
{
    return -1;
}

function bool CheckHasArrived(Actor Target)
{
}

function GasDamageAlarm()
{
}
function InitBotSuit(int RowID)
{
    local KFXCSVTable BotDifficult;
    local int RandNum;
    //local int Suit;
    local int SuitNum;
    BotDifficult = class'KFXTools'.static.GetConfigTable(309);
    if(BotDifficult == none)
    {
        log("KFXBot KFXPVEbotdifficult.csv is not exist");
        return;
    }
    if(!BotDifficult.SetCurrentRow(RowID))
    {
        log("KFXBot KFXPVEbotdifficult.csv RowID is none "$RowID);
        return;
    }
    SuitNum = BotDifficult.GetInt("SuitNum");
    RandNum = rand(SuitNum) + 1;
    Suit = BotDifficult.GetInt("Suit"$RandNUm);
    log("KFXBOt--------SuitNum "$SuitNum);
    log("KFXBOt--------Suit "$Suit);
}
function InitBotAfterRestart()
{
    log("KFXBOt---------Pawn "$Pawn);
    if( Pawn != none )
	{
	   log("KFXBOt-----111----KFXPawnBase(Pawn).KFXSpeedScale "$KFXPawnBase(Pawn).KFXSpeedScale);
	   log("KFXBOt---------AddSpeed "$AddSpeed);
	   log("KFXBOt---------BotVelocity "$BotVelocity);
	   log("KFXBOt---------AddRepulsed "$AddRepulsed);
	   log("KFXBOt---------KFXPawn(Pawn).DamagedSpeedDownRate "$KFXPawn(Pawn).DamagedSpeedDownRate);
       if(bIsGhost)
       {
	       SaveSpeedScale = KFXPawnBase(Pawn).KFXSpeedScale * BotVelocity * AddSpeed;
           KFXPawnBase(Pawn).KFXSpeedScale =  0;
           log("KFXBOt-----222----SaveSpeedScale "$SaveSpeedScale);
       }
       else
       {
	       KFXPawnBase(Pawn).KFXSpeedScale *=  BotVelocity * AddSpeed;
       }
	   KFXPawn(Pawn).DamagedSpeedDownRate *=  AddRepulsed;
	   log("KFXBOt-----222----KFXPawnBase(Pawn).KFXSpeedScale "$KFXPawnBase(Pawn).KFXSpeedScale);
	   log("KFXBOt---------KFXPawn(Pawn).DamagedSpeedDownRate "$KFXPawn(Pawn).DamagedSpeedDownRate);
	}
}
function InitBotWeapon(int RowID)
{
    local KFXCSVTable BotDifficult;
    local int MajorNum,MinorNum,MeleeNum,TossNum;
    local int RandWeapon;
    local int RandNum;

    BotDifficult = class'KFXTools'.static.GetConfigTable(309);
    if(BotDifficult == none)
    {
        log("KFXBot KFXPVEbotdifficult.csv is not exist");
        return;
    }
    if(!BotDifficult.SetCurrentRow(RowID))
    {
        log("KFXBot KFXPVEbotdifficult.csv RowID is none "$RowID);
        return;
    }
    Health = BotDifficult.GetInt("BotHealthLimit");
    //HealthMax = BotDifficult.GetInt("BotHealthLimit");
    log("KFXBot-------Health "$Health);
    MajorNum = BotDifficult.GetInt("MajorWeaponNum");
    log("KFXBot-------MajorNum "$MajorNum);
    RandNum = rand(MajorNum) + 1;
    MainWeaponID =  BotDifficult.GetInt("Major"$RandNum);
    log("KFXBot-------MainWeaponID "$MainWeaponID);
    if(MainWeaponID >> 16 < 1 || MainWeaponID >> 16 > 30)
    {
        MainWeaponID = 0;
    }

    MinorNum = BotDifficult.GetInt("MinorWeaponNum");
    log("KFXBot-------MinorNum "$MinorNum);
    RandNum = rand(MinorNum) + 1;
    SubWeaponID =  BotDifficult.GetInt("Minor"$RandNum);
    log("KFXBot-------SubWeaponID "$SubWeaponID);
    if(SubWeaponID >> 16 < 30 || SubWeaponID >> 16 > 40)
    {
        SubWeaponID = 0;
    }

    MeleeNum = BotDifficult.GetInt("MeleeWeaponNum");
    log("KFXBot-------MeleeNum "$MeleeNum);
    RandNum = rand(MeleeNum) + 1;
    MeleeWeaponID =  BotDifficult.GetInt("Melee"$RandNum);
    log("KFXBot-------MeleeWeaponID "$MeleeWeaponID);
    if(MeleeWeaponID >> 16 < 40 || MeleeWeaponID >> 16 > 50)
    {
        MeleeWeaponID = 0;
    }

    TossNum = BotDifficult.GetInt("TossWeaponNum");
    log("KFXBot-------TossNum "$TossNum);
    RandNum = rand(TossNum) + 1;
    TossWeaponID =  BotDifficult.GetInt("Toss"$RandNum);
    log("KFXBot-------TossWeaponID "$TossWeaponID);
    if(TossWeaponID >> 16 < 50 || TossWeaponID >> 16 > 60)
    {
        TossWeaponID = 0;
    }

    if( KFXPawn(Pawn) != none )
        KFXPawn(Pawn).AddBotInventory(MainWeaponID, SubWeaponID, MeleeWeaponID, TossWeaponID);
}
function InitBotPawn()
{
    log("KFXBot-----InitBotPawn ");
    InitBotAfterRestart();
}
function DoAfterReStartPlayer()
{

    log("KFXBot--------bFirstRestart "$bFirstRestart);
    if(bFirstRestart)
    {
        bFirstRestart = false;
    }
    InitBotPawn();
}

state Dead
{
    function float GetNextRestartTime()
    {
        log("GetNextRestartTime--------bFirstRestart "$bFirstRestart);
        log("GetNextRestartTime--------FirstRestartTime "$FirstRestartTime);
        log("GetNextRestartTime--------NextRestartTime "$NextRestartTime);
        if(bFirstRestart)
        {
            return FirstRestartTime;

        }
        else
        {
            return NextRestartTime;
        }
    }
}
simulated function int  KFXGetSuitID()
{
    log("KFXBot------suit "$suit);
    if(bIsHostage)
         return 1104;
    return suit;
}

event Tick(float DeltaTime)
{
	local int loop;
	if(KFXPawn(Pawn)!=none &&  KFXPawn(Pawn).skmgr != none)
	{
		KFXPawn(Pawn).skmgr.TickBotSkillCondition(DeltaTime);
	}
}

defaultproperties
{
     kfx_firerate=1.000000
     Health=100
     bFirstRestart=是
     BotDropRate=1.000000
     PlayerReplicationInfoClass=Class'KFXGame.KFXPlayerReplicationInfo'
     PawnClass=Class'KFXGame.KFXPawn'
}
