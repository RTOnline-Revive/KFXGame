//-----------------------------------------------------------
//  Class:      KFXGame.KFXGameReplicationInfo
//  Creator:    zhangjinpin@kingsoft ÕÅ½ðÆ·
//  Data:       2007-03-26
//  Desc:       FoxÓÎÏ·¹æÔòÍ¬²½Êý¾Ý
//  Update:
//  Special:    ÎªÁËÍ³Ò»¹ÜÀí£¬ÔÝÊ±°ÑËùÓÐÂß¼­Êý¾Ý¶¼´¢´æÔÚ´Ë
//-----------------------------------------------------------

class KFXGameReplicationInfo extends GameReplicationInfo
	config(KFXGameRPInfo);


// ÐèÒªÍ¬²½µÄÊý¾Ý
var config int      fxKilledLimit;          // »÷±ÐÉÏÏÞ
var config int      fxTimeLimit;            // Ê±¼äÉÏÏÞ
var int             fxRemainingTime;        // Ê£ÓàÊ±¼ä
var int             fxElapsedTime;          // ¾­¹ýÊ±¼ä
var int             fxRemainingFix;         // Ê±¼äÐ£Õý
var int             fxMapID;                // µØÍ¼±àºÅ
var bool            fxTeamHurt;             // ÍÅ¶ÓÉËº¦

//-----»»¶ÓÂß¼­--Èç¹ûÆäÎªÆæÊýÔòÖ¸¶ÓÎéÓë¶ÓÎéÐÅÏ¢Ïà·´---   ·ñÔòÒ»ÖÂ--------
var int             fxChangeTeamCount;      // »»¶Ó´ÎÊý¼ÇÂ¼

//var config float    fxPlayerRestartDelay;   // ËÀÍöºóÑÓ³ÙÖØÉúÊ±¼ä
var config float           fxPlayerRestartDelay;   // ËÀÍöºóÑÓ³ÙÖØÉúÊ±¼ä wangkai, 2008-08-04, ¸´ÉúÊ±¼ä¸ÄÎª´ÓFaeryAgentµÃµ½
var int             fxWeapLimit;            //ÎäÆ÷ÏÞÖÆ

var config int      fxWinnerExp;            // Ê¤Àû½±Àø


// ÎÞÐèÍ¬²½µÄÊý¾Ý
var config float    fxExpAdjustFactor;      //ÓÎÏ·ÈÙÓþÖµÕûÌåµ÷½ÚÏµÊý
var config float    fxRestartDelay;         // ÓÎÏ·ÖØÆðÑÓ³ÙÊ±¼ä
var config float    fxSuperLimit;           // ÎÞµÐÊ±¼ä
var config float    fxSeriateKillTime;      // Á¬É±Ê±¼ä
var config float    fxBasicExp;             // »ù±¾¾­ÑéÖµ
var config float    fxKillNumLimit;         //»÷±ÐÏÞÖÆÏµÊý
var config float    fxSpecialExpLimit;      //ÌØÊâÈÙÓþÏÞÖÆÏµÊý
var config float    fxKillExp;              // »÷±Ð½±Àø¾­ÑéÖµ
var config float    fxKillHeadExp;          // ±¬Í·½±Àø¾­ÑéÖµ
var config float    fxSpecialExp;           // ÌØÊâ»÷±Ð¾­ÑéÖµ
var config float    fxDaggerExp;            // µ¶É±»÷±Ð½±ÀøÖµ
var config float    fxMultiKillExp;         // Á¬É±½±Àø¾­ÑéÖµ
var config float    fxTransPigExp;          // ±äÖí½±Àø¾­ÑéÖµ
var config float    fxDeadExp;              // ËÀÍö³Í·£¾­ÑéÖµ
var config float    fxWinFactor;            //Ê¤ÀûÕûÌåÈÙÓþÖµÐÞÕýÏµÊý
var config float    fxFriendlyFireScale;    // Í¬¶ÓÉËº¦ÏµÊý

var config float    fxGameCashBaseValue;    // ÓÎÏ·±Ò»ù´¡Öµ
var config float    fxGameCashPlayerNumFactor; // ÓÎÏ·±ÒÈËÊýÆ½ºâÏµÊý
var config float    fxGameCashRankFactor;   // ÓÎÏ·±ÒÅÅÃûÓ°ÏìÏµÊý
var config float    fxGameCashFinalFactor;   // ÓÎÏ·±Ò×ÜÌåÓ°ÏìÏµÊý
var config float    fxGameCashKillFactor;    // ÓÎÏ·±Ò»÷É±Ó°ÏìÏµÊý
var config float    fxGameCashDeathFactor;   // ÓÎÏ·±ÒËÀÍöÓ°ÏìÏµÊý
var config float    fxGameCashGameResultFactor; // ÓÎÏ·±ÒËÀÍöÓ°ÏìÏµÊý
var config float    fxGameCashFactor;           //ÓÎÏ·±ÒÄ£Ê½Ó°ÏìÏµÊý


var config int NonePickupTime;         //µÀ¾ßÏûÊ§µÄÊ±¼ä
var config int PickupTime;             //µÀ¾ß³ÖÐøÊ±¼ä

//ÊÇ·ñÄÜµÃµ½µÚÒ»µÎÑª£¬±äÁ¿²»Í¬²½, wangkai
var bool bNotFirstBlood;
var bool bFinalKill;		//ÊÇ·ñÒÑ¾­´æÔÚ×îÖÕÉ±£¬

var int TotalGameTime;
var bool ClientStart;

///<ÅçÆá¹¦ÄÜÅäÖÃÊôÐÔ

var config int fxMaxTimesToUsePrint;                 //½ÇÉ«Ã¿´ÎÖØÉú¿ÉÒÔÊ¹ÓÃÅçÆáµÄ´ÎÊý

var config float fxDurableFactor;       //Íæ¼ÒÖÐÍ¾ÍË³ö£¬ÄÍ¾Ã¶ÈÏûºÄ¼õÉÙÒò×Ó

var bool bEnableThirdAngle;             // ÊÇ·ñ¿ÉÒÔ¹Û²ìµÚÈýÈË³Æ£¬²¢Ä¬ÈÏµÚÈýÈË³Æ
var bool bEnableEnemyAngle;             //ÊÇ·ñÄÜ¿´µ½µÐÈËÊÓ½Ç

var config int GameModeID;              //Ã¿¸öÄ£Ê½ID£¬¶ÔÓ¦ÓÚUpdateExpFactor.csvÐÐID
var config float                UpdateEnemyMsgTime;
var config int                          MiniKilledMeCount;  //×îÉÙÉ±ÎÒ¶àÉÙ´ÎµÄÈË²Å¼ÇÂ¼

//var int GameMVPUsedWeaponID;
var int GameMode;                               //ÓïÒô±í¶ÔÓ¦µÄÄ£Ê½ID
var config int NearWinScore;                    //ÍÅ¶ÓÖÐ²îÉ±¶àÉÙNearWinScore=10ÈË¾Í½áÊøÓÎÏ·£¬Ð¡¾ÖÖÐ²îNearWinScore=1¾Ö¾ÍÓÎÏ·ÓÎÏ·
var int     nGameType;                          //ÓÎÏ·ÀàÐÍ£¬ÆÕÍ¨£¬Õ½¶Ó£¬µç¾º

//<use for faction match
var bool   bAllowTeamChange;                    //ÊÇ·ñ¿ÉÒÔÖÐÍ¾»»¶Ó
var int    ReWinOnDraw;                         //Æ½¾ÖÊ±¾ö¶¨Ê¤ÀûµÄ·½Ê½£¬0£º±£³ÖÆ½¾Ö 1£ºÄ¬ÈÏÀ¶·½Ê¤Àû 2:Ëæ»úÒ»·½Ê¤Àû
var bool   bBlueWinOnDraw;                      //Æ½¾ÖÇé¿öÏÂÊÇ·ñÀ¶¶ÓÄ¬ÈÏÎªÊ¤Àû¶ÓÎé£¬·ñÔòÅÐ¶ÏËæ»úÊ¤ÀûÕß
var bool   bRandWinner;                         //ÊÇ·ñËæ»úÊ¤ÀûÕß

//>

var int     nWinSpoint;
var int     nLostSpoint;

//PVE³É³¤ÌåÏµ
var int   BaseLevel;                            //»ù´¡ÊôÐÔµÈ¼¶
var float BaseHP;                               //»ù´¡ÊôÐÔHP
var float BaseDmgFactor;                         //»ù´¡ÊôÐÔDmgFactor
var float LevelupHP;                             //Éý¼¶HPÔö³¤Á¿
var float LevelupDmgFactor;                       //Éý¼¶ÉËº¦ÏµÊýÔö³¤Á¿
var float DmgExpRate;                            //ÉËº¦¾­Ñé±ÈÂÊ
var float DmgedExpRate;                          //±»ÉËº¦¾­Ñé±ÈÂÊ
var int   MaxPlayerLevel;                        //µ±Ç°»ù´¡µÈ¼¶ÉÏµÄÍæ¼Ò×î¸ßµÈ¼¶
var array<int> LevelExps;                        //Ã¿¸öµÈ¼¶ÐèÒªµÄ¾­ÑéÊý£¨×Ü¾­Ñé¶ø²»ÊÇÉý¼¶¾­Ñé²î£©

//PVE Farm
var array<int> PVEPickupsA;
var array<int> PVEPickupsB;

replication
{
	// Ö»Í¬²½Ò»´Î
	reliable if ( bNetInitial && (Role==ROLE_Authority) )
		fxTimeLimit, fxRemainingTime, fxElapsedTime, fxWinnerExp,fxWeapLimit, UpdateEnemyMsgTime;

	// ÒÔºóÃ¿´Î±ä»¯Í¬²½
	//<< wangkai, fixed bug
	//reliable if ( !bNetInitial && bNetDirty && (Role == ROLE_Authority) )
	reliable if (bNetDirty && (Role == ROLE_Authority))
		fxMapID, fxRemainingFix, fxPlayerRestartDelay, fxChangeTeamCount,fxKilledLimit,fxMaxTimesToUsePrint,TotalGameTime,
		bEnableThirdAngle, bEnableEnemyAngle,fxSeriateKillTime,/*GameMVPUsedWeaponID,*/ fxRestartDelay,nGameType,bRandWinner,bBlueWinOnDraw;
	//>>
}

event PreBeginPlay()
{
	/*
	LOG("[zjpwxh]Saving KFXGameReplicationInfo");

	SaveConfig();
	*/
	super.PreBeginPlay();
}

simulated function SetBaseLevelData(int newBaseLevel)
{
    local KFXCSVTable CSVLevelUp;
    local KFXCSVTable CSVLevelExp;
	local int LevelExpID;
	local int loop;

	CSVLevelUp = class'KFXTools'.static.KFXCreateCSVTable("KFXPVElevelup.csv");
	CSVLevelExp = class'KFXTools'.static.KFXCreateCSVTable("KFXPVEExp.csv");

	if(!CSVLevelUp.SetCurrentRow(newBaseLevel))
	{
		log("SetBaseLevelData Wrong BaseLevel"@newBaseLevel);
	}

    LevelExpID = CSVLevelUp.GetInt("ExpID");
	BaseLevel = CSVLevelUp.GetInt("BaseLevel");
	BaseHP = CSVLevelUp.GetFloat("BaseHP");
	BaseDmgFactor = CSVLevelUp.GetFloat("BaseDmgFactor");
	LevelupHP = CSVLevelUp.GetFloat("LevelupHP");
	LevelupDmgFactor = CSVLevelUp.GetFloat("LevelUpDmgFactor");
	DmgExpRate = CSVLevelUp.GetFloat("DmgExpRate");
	DmgedExpRate = CSVLevelUp.GetFloat("DmgedExpRate");

	if(!CSVLevelExp.SetCurrentRow(LevelExpID))
	{
		log("SetBaseLevelData Wrong LevelExpID"@LevelExpID);
	}

	MaxPlayerLevel = CSVLevelExp.GetInt("MaxLevel");
	for(loop=0; loop < MaxPlayerLevel; loop ++)
	{
		LevelExps[loop] = CSVLevelExp.GetInt("Exp"$loop+1);
	}

	log("[LABOR]----------PVE base level up:"$LevelExpID
			@BaseLevel@BaseHP@BaseDmgFactor@LevelupHP
			@LevelupDmgFactor@DmgExpRate@DmgedExpRate
			@MaxPlayerLevel@LevelExps[0]@LevelExps[1]);
}

simulated function int GetPveLevelUpExp(int curLevel)
{
	if(curLevel <= 0)
		return LevelExps[curLevel];
	else
		return LevelExps[curLevel] - LevelExps[curLevel-1];
}

simulated function InitPVEPickupData()
{
   	local KFXCSVTable PVEWeapPickup;
   	local int loop;
   	local int Picknum;

   	log("InitPVEPickupData");

	PVEWeapPickup = class'KFXTools'.static.KFXCreateCSVTable("KFXPVEWeapPickupA.csv");

	if(!PVEWeapPickup.SetCurrentRow(1))
	{
		log("KFXPVEWeapPickupA can not SetCurrentRow 1");
		return;
	}

	Picknum = PVEWeapPickup.GetInt("WeapNum");
	for(loop=0; loop < Picknum; loop ++)
	{
		PVEPickupsA[loop] = PVEWeapPickup.GetInt("Weap"$loop+1);
	}

	PVEWeapPickup = class'KFXTools'.static.KFXCreateCSVTable("KFXPVEWeapPickupB.csv");

	if(!PVEWeapPickup.SetCurrentRow(1))
	{
		log("KFXPVEWeapPickupB can not SetCurrentRow 1");
		return;
	}

	Picknum = PVEWeapPickup.GetInt("WeapNum");
	for(loop=0; loop < Picknum; loop ++)
	{
		PVEPickupsB[loop] = PVEWeapPickup.GetInt("Weap"$loop+1);
	}
}

// ¿Í»§¶Ë×Ô¼º¼õÉÙÊ±¼ä
simulated function Timer()
{
	super.Timer();


	if ( Level.NetMode == NM_Client )
	{
		fxElapsedTime++;

		if ( fxRemainingFix != -1 )
		{
			fxRemainingTime = fxRemainingFix;
			fxRemainingFix = -1;
		}
		if ( fxRemainingTime > 0 && !bStopCountDown )
		{
			fxRemainingTime--;
		}
	}
}

simulated function int GetBlueTeam()
{
	if( fxChangeTeamCount%2 == 0 )
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

defaultproperties
{
     fxKilledLimit=100
     fxTimeLimit=10
     fxRemainingFix=-1
     fxPlayerRestartDelay=10.000000
     fxWinnerExp=20
     fxExpAdjustFactor=1.000000
     fxRestartDelay=15.000000
     fxSuperLimit=3.000000
     fxSeriateKillTime=4.500000
     fxBasicExp=50.000000
     fxKillExp=15.000000
     fxKillHeadExp=2.000000
     fxSpecialExp=2.000000
     fxDaggerExp=2.000000
     fxMultiKillExp=2.000000
     fxTransPigExp=2.000000
     fxDeadExp=2.000000
     NonePickupTime=30
     PickupTime=60
     fxMaxTimesToUsePrint=1
     UpdateEnemyMsgTime=1.000000
     MiniKilledMeCount=5
     NearWinScore=10
     bFastWeaponSwitching=是
}
