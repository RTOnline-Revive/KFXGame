//-----------------------------------------------------------
//    sunqiang
//-----------------------------------------------------------
class PVEGameManager extends Object;
enum PVERulesType
{
	PVE_BOSS,
	PVE_SCORER,
	PVE_NORMAL
};
struct PVEBotInfo
{
    var int BotType;
    var int BotNum;
};
struct PVEMonsterInfo
{
    var int MonsterType;
    var int MonsterNum;
};
//关卡类
struct PVEGuanInfo
{
	var PVERulesType Type;
    var int RulesID;
	var int MapID;
	var array<PVEBotInfo> BotInfo;
	var array<PVEMonsterInfo> MonsterInfo;
	var int AttackBotNum;
	var int DefendBotNum;
	var int FreeBotNum;
	var int TimeLimit;
	var int KillLimit;
};

//一个过关条件对应的地图信息
struct PVEGameMapInfo
{
	var int RulesID;
	var array<int> MapArray;
};
//struct PVEGameBotSuitInfo
//{
//    var int BotType;
//    //var int BotNum;
//    var array<int> BotSuit;
//};

var int CurChapter;//章的进度
var int CurProgress;//当前进行的关数
var int StartGuan;//从哪关开始的

var array<int> AllMapInfo;	//PVE所有关卡已随机的地图

var array<PVEGameMapInfo> PVEMapInfo;                        //相同过关条件下的所有地图
var array<PVEGameMapInfo> PVESavedMapInfo;

//关卡集合，主要数据是每关的过关条件和地图
var array<PVEGuanInfo> PVEAllGuanInfo;
//所有过关条件的集合
var array<int> AllBossRulesID;
var array<int> AllScorerRulesID;
var array<int> AllNormalRulesID;

var int g_PerChapterNum ;
const g_PerBossNum = 27;
const g_PerPartNum = 9;
const  TotalBossNum = 1;
const TotalScorerNum = 2;
const TotalNormalNum = 24;

static function SetMaxGuanNum(int MaxGuan)
{
    default.g_PerChapterNum = MaxGuan + 1;
//    default.g_PerPartNum = PerPart;
//    default.TotalBossNum = BossGuan;
//    default.TotalScorerNum = ScorerGuan;
//    default.TotalNormalNum =NormalGuan
    log("PVEGameManager-------g_PerChapterNum :"$default.g_PerChapterNum );
//                              "  g_PerPartNum :"$default.g_PerPartNum
//                              "  TotalBossNum :"$default.TotalBossNum
//                              "  TotalScorerNum :"$default.TotalScorerNum
//                              "  TotalNormalNum :"$default.TotalNormalNum);
}
static function bool InitAll()
{
	log("PVEGameManager--------InitAll ");
    InitGameRulesData();
	InitAllRandRulesData();

	InitAllRandMapData();
	InitAllRandBotData();
	return true;
}
static function bool DeleteAll()
{
    log("PVEGameManager--------DeleteAll ");
    default.PVEAllGuanInfo.Remove(0,default.PVEAllGuanInfo.Length);
    default.AllMapInfo.Remove(0,default.AllMapInfo.Length);
    default.PVEMapInfo.Remove(0,default.PVEMapInfo.Length);
    default.PVESavedMapInfo.Remove(0,default.PVESavedMapInfo.Length);

    default.AllBossRulesID.Remove(0,default.AllBossRulesID.Length);
    default.AllScorerRulesID.Remove(0,default.AllScorerRulesID.Length);
    default.AllNormalRulesID.Remove(0,default.AllNormalRulesID.Length);
    default.CurChapter = 1;
    default.CurProgress = -1;
    default.StartGuan = 1;

}
//初始化一章所有的过关条件
static function bool InitGameRulesData()
{
	local int i;
	local int Chapter;
	local int PartNum;
//	local int RandNum;
	local KFXCSVTable PVEGameRound;
	local int RoundID;
	Chapter = default.CurChapter;
	PVEGameRound = class'KFXTools'.static.KFXCreateCSVTable("KFXPVEGameChapter.csv");
	if(!PVEGameRound.SetCurrentRow(Chapter))
	{
		log("PVE Game Round Is "$Chapter);
		return false;
	}
	PartNum = PVEGameRound.GetInt("BossRoundNum");
	log("PVE Boss Round Is "$PartNum);
	for(i=1; i<=PartNum; i++)
	{
		RoundID = PVEGameRound.GetInt("BossRoundID"$i);

		default.AllBossRulesID.Insert(default.AllBossRulesID.Length,1);
		default.AllBossRulesID[default.AllBossRulesID.Length-1] = RoundID;
		log("PVE Boss Round ID Is "$RoundID);
	}

	PartNum = PVEGameRound.GetInt("HigherScoreRoundNum");
	log("PVE Scorer Round Is "$PartNum);
	for(i=1; i<=PartNum; i++)
	{
		RoundID = PVEGameRound.GetInt("HigherScoreRoundID"$i);
		default.AllScorerRulesID.Insert(default.AllScorerRulesID.Length,1);
		default.AllScorerRulesID[default.AllScorerRulesID.Length-1] = RoundID;
		log("PVE Scorer Round ID Is "$RoundID);
	}

	PartNum = PVEGameRound.GetInt("NormalRoundNum");
	log("PVE Normal Round Is "$PartNum);
	for(i=1; i<=PartNum; i++)
	{
		RoundID = PVEGameRound.GetInt("NormalRoundID"$i);
		default.AllNormalRulesID.Insert(default.AllNormalRulesID.Length,1);
		default.AllNormalRulesID[default.AllNormalRulesID.Length-1] = RoundID;
		log("PVE Normal Round ID Is "$RoundID);
	}
	return true;
}
static function bool InitAllRandRulesData()//每一关随机出过关条件
{
//	local int RoundID;
	local int BossNum,ScorerNum,NormalNum;
	local int RandBoss,RandScorer,RandNormal;
	local int BossID,ScorerID,NormalID;
	local int i;
	local int Count;
    local int Progress;
    local PVEGuanInfo Guan;
   	local array<int> TempBossID;
	local array<int> TempScorerID;
	local array<int> TempNormalID;


	log("PVEGameManager------default.PVEAllGuanInfo.Length :"$default.PVEAllGuanInfo.Length);
    if(default.PVEAllGuanInfo.Length > 0)
    {
        log("PVEGameManager------default.PVEAllGuanInfo.Length "$default.PVEAllGuanInfo.Length);
        return false;
    }
    Count = 0;
    CopyArrayData(TempBossID,  default.AllBossRulesID);
    CopyArrayData(TempScorerID,default.AllScorerRulesID);
    CopyArrayData(TempNormalID,default.AllNormalRulesID);

    log("PVEGameManager------default.StartGuan :"$default.StartGuan);
    log("PVEGameManager------default.g_PerChapterNum :"$default.g_PerChapterNum);

	while(default.StartGuan + Count <= default.g_PerChapterNum)
	{
		 Progress = default.StartGuan + Count;

         log("PVEGameManager------Progress :"$Progress);
         if(CurProgressIsBoss(Progress))
         {
            log("PVEGameManager------default.AllBossRulesID.Length :"$default.AllBossRulesID.Length);
            if(default.AllBossRulesID.Length <= 0)
            {
                CopyArrayData(default.AllBossRulesID,TempBossID);
            }

            BossNum = default.AllBossRulesID.Length;
            RandBoss = rand(BossNum) ;
            BossID = default.AllBossRulesID[RandBoss];
            log("PVEGameManager------BossNum :"$BossNum);
            log("PVEGameManager------RandBoss :"$RandBoss);
            log("PVEGameManager------BossID :"$BossID);
            default.AllBossRulesID.Remove(RandBoss,1);
            Guan.RulesID = BossID;
            Guan.Type = PVE_BOSS;
//            if(TempBossID.Length < default.TotalBossNum)
//            {
//                TempBossID.Insert(TempBossID.Length,1);
//                TempBossID[TempBossID.Length-1] = BossID ;
//            }
         }
         else if(CurProgressIsScorer(Progress))
         {
            if(default.AllScorerRulesID.Length <= 0)
            {
                CopyArrayData(default.AllScorerRulesID,TempScorerID);
            }
            ScorerNum = default.AllScorerRulesID.Length;
            RandScorer = rand(ScorerNum) ;
            ScorerID = default.AllScorerRulesID[RandBoss];

            log("PVEGameManager------ScorerNum :"$ScorerNum);
            log("PVEGameManager------RandScorer :"$RandScorer);
            log("PVEGameManager------ScorerID :"$ScorerID);

            default.AllScorerRulesID.Remove(RandBoss,1);
            Guan.RulesID = ScorerID;
            Guan.Type = PVE_SCORER;
//            TempScorerID.Insert(TempScorerID.Length,1);
//            TempScorerID[TempScorerID.Length-1] = ScorerID;
         }
         else
         {
            if(default.AllNormalRulesID.Length <= 0)
            {
                 CopyArrayData(default.AllNormalRulesID,TempNormalID);
            }
             NormalNum = default.AllNormalRulesID.Length;
             RandNormal = rand(NormalNum) ;
             NormalID = default.AllNormalRulesID[RandNormal];

             log("PVEGameManager------NormalNum :"$NormalNum);
             log("PVEGameManager------RandNormal :"$RandNormal);
             log("PVEGameManager------NormalID :"$NormalID);

             default.AllNormalRulesID.Remove(RandNormal,1);
             Guan.RulesID = NormalID;
             Guan.Type = PVE_NORMAL;
//             TempNormalID.Insert(TempNormalID.Length,1);
//             TempNormalID[TempNormalID.Length-1] = NormalID;
		 }
		 default.PVEAllGuanInfo.Insert(default.PVEAllGuanInfo.Length,1);
		 default.PVEAllGuanInfo[default.PVEAllGuanInfo.Length-1] = Guan;
		 Count++;
	}
	for(i=0; i<default.PVEAllGuanInfo.Length; i++)
	{
		log("InitAllRandRulesData----RulesID "$default.PVEAllGuanInfo[i].RulesID);
	}
	if(default.StartGuan + Count >= default.g_PerChapterNum)
	{
		log("PVEGameManager Init All RandRules Success");
		return true;
	}
	else
	{
		log("PVEGameManager Init All RandRules Failed");
		return false;
	}
}


//每一关随机出地图
static function bool InitAllRandMapData()
{
    local int i;
    local KFXCSVTable MapInfo;
    local int RulesID;
    local int MapNum;
    local int RandMap;
	local int MapID;
	local int index;


	log("PVEGameManager Init Map Start");
	MapInfo = class'KFXTools'.static.KFXCreateCSVTable("KFXPVERoundToMapAndAI.csv");
	if(MapInfo == none)
	{
	   log("Create KFXPVERoundToMapAndAI.csv failed");
	   return false;
	}
	InitPVEMapInfo();     //将所有关的所有地图都先读取进来
	log("InitAllRandMapData-------default.PVEAllGuanInfo.Length: "$default.PVEAllGuanInfo.Length);
	for(i=0; i<default.PVEAllGuanInfo.Length; i++)
	{
		RulesID = default.PVEAllGuanInfo[i].RulesID;
		log("InitAllRandMapData-------RulesID: "$RulesID);
		if(!MapInfo.SetCurrentRow(RulesID))
		{
			log("PVEGameManager read csvtable is error, ID is "$RulesID);
			continue ;
		}
		default.PVEAllGuanInfo[i].TimeLimit  = MapInfo.GetInt("TimeLimit");
		default.PVEAllGuanInfo[i].KillLimit  = MapInfo.GetInt("KillLimit");
		log("PVEGameManager -------TimeLimit "$default.PVEAllGuanInfo[i].TimeLimit);
		log("PVEGameManager -------KillLimit "$default.PVEAllGuanInfo[i].KillLimit);


        //读取每关的攻击防守自由小队的人数
        default.PVEAllGuanInfo[i].AttackBotNum =   MapInfo.GetInt("AttackNum");
        default.PVEAllGuanInfo[i].DefendBotNum =   MapInfo.GetInt("DefendNum");
        default.PVEAllGuanInfo[i].FreeBotNum =   MapInfo.GetInt("FreeNum");
        log("PVEGameManager -------AttackBotNum "$default.PVEAllGuanInfo[i].AttackBotNum);
        log("PVEGameManager -------DefendBotNum "$default.PVEAllGuanInfo[i].DefendBotNum);
        log("PVEGameManager -------FreeBotNum "$default.PVEAllGuanInfo[i].FreeBotNum);

        if(IsRulesInMapArray(RulesID,index))
        {
           if(default.PVEMapInfo[index].MapArray.Length <= 0)
           {
               CopyArrayData(default.PVEMapINfo[index].MapArray,default.PVESavedMapINfo[index].MapArray);
               log("PVEGameManager  CopyArrayData");
           }
           MapNum = default.PVEMapInfo[index].MapArray.Length;
           RandMap = rand(MapNum);
           MapID =  default.PVEMapInfo[index].MapArray[RandMap];
           default.PVEMapInfo[index].MapArray.Remove(RandMap,1);
           log("PVEGameManager 1111 "$"RulesID: "$RulesID$" MapID: "$MapID);
           if(MapID > 0)
           {
                default.PVEAllGuanInfo[i].MapID = MapID;
                log("PVEGameManager  "$"RulesID: "$RulesID$" MapID: "$MapID);
           }

        }
    }
}


//随机地图的逻辑是将所有不相同的过关条件对应的地图存储到PVEMapInfo,构成所有地图的数组
//然后
static function InitPVEMapInfo()
{
    local int i,j;
    local int RulesID;
    local KFXCSVTable MapInfo;
    local int index;
    local int MapNum;
    local int MapID;
    log("PVEGame Init PVEMapInfo Start");
    MapInfo = class'KFXTools'.static.KFXCreateCSVTable("KFXPVERoundToMapAndAI.csv");
    if(MapInfo == none)
    {
       log("Create KFXPVERoundToMapAndAI.csv failed");
       return ;
    }
    log("InitPVEMapInfo-------default.PVEAllGuanInfo.Length: "$default.PVEAllGuanInfo.Length);
    for(i=0; i<default.PVEAllGuanInfo.Length; i++)
    {
        RulesID = default.PVEAllGuanInfo[i].RulesID;
        log("InitPVEMapInfo-------RulesID: "$RulesID);
        if(!IsRulesInMapArray(RulesID,index))
        {
            default.PVEMapInfo.Insert(default.PVEMapInfo.Length,1);
            default.PVEMapInfo[default.PVEMapInfo.Length - 1].RulesID = default.PVEAllGuanInfo[i].RulesID;
            index = default.PVEMapInfo.Length - 1;
            log("InitPVEMapInfo-------index: "$index);

            log("InitPVEMapInfo-------default.PVEMapInfo.Length: "$default.PVEMapInfo.Length);
            if(!MapInfo.SetCurrentRow(RulesID))
            {
                log("PVEGameManager read csvtable is error, ID is "$RulesID);
                continue ;
            }
            MapNum = MapInfo.GetInt("UsefulMapNum");
            log("InitPVEMapInfo-------MapNum: "$MapNum);
            log("InitPVEMapInfo--222-----index: "$index);
            for(j=1; j<=MapNum; j++)
            {
                MapID = MapInfo.GetInt("Map"$j);
                log("InitPVEMapInfo-------MapID: "$MapID);
                default.PVEMapInfo[index].MapArray.Insert(default.PVEMapInfo[index].MapArray.Length,1);
                default.PVEMapInfo[index].MapArray[default.PVEMapInfo[index].MapArray.Length-1] = MapID;
            }

        }
    }
    CopyStructArrayData(default.PVESavedMapInfo,default.PVEMapInfo);
}

static function bool IsRulesInMapArray(int Rules,out int index)
{
	local int i;
	for(i=0; i<default.PVEMapInfo.Length; i++)
	{
		if(default.PVEMapInfo[i].RulesID == Rules)
		{
			index = i;
			log("InitPVEMapInfo-------return true index: "$index);
			return true;
		}
	}
	log("InitPVEMapInfo-------return false: ");
	return false;
}
static function bool IsMapUsedInCurRules(int RulesID, int Map)
{
	local int i;

	for(i=0; i<default.PVEAllGuanInfo.Length; i++)
	{
		if(default.PVEAllGuanInfo[i].RulesID == RulesID)
		{
			if(default.PVEAllGuanInfo[i].MapID == Map)
			{
				return true;
			}
		}
	}
	return false;
}
function bool IsMapUsedInOtherRules(int Type,int RulesID, int Map)
{
	local int i;
	for(i=0; i<default.PVEAllGuanInfo.Length; i++)
	{
		if(default.PVEAllGuanInfo[i].RulesID != RulesID)
		{
			if(default.PVEAllGuanInfo[i].MapID == Map)
			{
				return true;
			}
		}
	}
	return false;
}

//每一关BOT类型
//每一关随机BOT
static function bool InitAllRandBotData()
{
    local int i;
    local KFXCSVTable CSVBotInfo;
    local int RulesID;
    local int BotClassNum;
    local int MonsterClassNum;
    local PVEBotInfo BotInfo;
    local PVEMonsterInfo MonsterInfo;
    local int j;

    log("PVEGameManager Init BotType Start");
    CSVBotInfo = class'KFXTools'.static.KFXCreateCSVTable("KFXPVERoundToMapAndAI.csv");
    if(CSVBotInfo == none)
    {
       log("InitAllRandBotTypeData ---Create KFXPVERoundToMapAndAI.csv failed");
       return false;
    }

	log("PVEGameManager PVEAllGuanInfo.Length :"$default.PVEAllGuanInfo.Length);
	for(i=0; i<default.PVEAllGuanInfo.Length; i++)
	{
		RulesID = default.PVEAllGuanInfo[i].RulesID;
		log("InitAllRandBotData-------RulesID: "$RulesID);
		if(!CSVBotInfo.SetCurrentRow(RulesID))
		{
			log("PVEGameManager read Bot Type csvtable is error, ID is "$RulesID);
			continue;
		}
		BotClassNum = CSVBotInfo.GetInt("BotClassNum");
        MonsterClassNum = CSVBotInfo.GetInt("MonsterClassNum");
        log("PVEGameManager-------BotClassNum: "$BotClassNum);
        log("PVEGameManager-------MonsterClassNum: "$MonsterClassNum);

        for(j=1; j<=BotClassNum; j++)
        {
            BotInfo.BotType =  CSVBotInfo.GetInt("BotClass"$j);
            BotInfo.BotNum  =  CSVBotInfo.GetInt("BotClassNum"$j);

            log("PVEGameManager-------BotInfo.BotType: "$BotInfo.BotType);
            log("PVEGameManager-------BotInfo.BotNum: "$BotInfo.BotNum);

            default.PVEAllGuanInfo[i].BotInfo.Insert(default.PVEAllGuanInfo[i].BotInfo.Length,1);
            default.PVEAllGuanInfo[i].BotInfo[default.PVEAllGuanInfo[i].BotInfo.Length-1] = BotInfo;


        }
        for(j=1; j<=MonsterClassNum; j++)
        {
            MonsterInfo.MonsterType = CSVBotInfo.GetInt("Monster"$j);
            MonsterInfo.MonsterNum = CSVBotInfo.GetInt("MonsterNum"$j);
            log("PVEGameManager-------MonsterInfo.MonsterType : "$MonsterInfo.MonsterType );
            log("PVEGameManager-------MonsterInfo.MonsterNum: "$MonsterInfo.MonsterNum);

            default.PVEAllGuanInfo[i].MonsterInfo.Insert(default.PVEAllGuanInfo[i].MonsterInfo.Length,1);
            default.PVEAllGuanInfo[i].MonsterInfo[default.PVEAllGuanInfo[i].MonsterInfo.Length-1] = MonsterInfo;

        }
    }
}
//每一关随机BOT 该函数被弃用
//static function bool InitAllRandBotTypeData()
//{
//    local int i;
//    local KFXCSVTable CSVBotInfo,CSVBotSuit,CSVBotWeapon;
//    local int RulesID;
//    local int BotNum;
//    local PVEBotInfo BotInfo;
//    local int SuitNum;
//    local int RandSuit,Physics,Suit;
//    local int j;
//    local int BotWeaponType;
//    log("PVEGameManager Init BotType Start");
//    CSVBotInfo = class'KFXTools'.static.KFXCreateCSVTable("KFXPVERoundToMapAndAI.csv");
//    CSVBotSuit = class'KFXTools'.static.KFXCreateCSVTable("KFXBotSuit.csv");
//    CSVBotWeapon = class'KFXTools'.static.KFXCreateCSVTable("KFXBotWeapon.csv");
//    if(CSVBotInfo == none)
//    {
//       log("InitAllRandBotTypeData ---Create KFXPVERoundToMapAndAI.csv failed");
//       return false;
//    }
//    if(CSVBotInfo == none)
//    {
//       log("InitAllRandBotTypeData ----Create CSVBotSuit.csv failed");
//       return false;
//    }
//    if(CSVBotWeapon == none)
//    {
//       log("InitAllRandBotTypeData ----Create KFXBotWeapon.csv failed");
//       return false;
//    }
//
//    log("PVEGameManager PVEAllGuanInfo.Length :"$default.PVEAllGuanInfo.Length);
//    for(i=0; i<default.PVEAllGuanInfo.Length; i++)
//    {
//        RulesID = default.PVEAllGuanInfo[i].RulesID;
//        log("PVEGameManager-------RulesID: "$RulesID);
//        if(!CSVBotInfo.SetCurrentRow(RulesID))
//        {
//            log("PVEGameManager read Bot Type csvtable is error, ID is "$RulesID);
//            continue;
//        }
//        BotWeaponType = CSVBotInfo.GetInt("BotWeapon");
//        if(!CSVBotWeapon.SetCurrentRow(BotWeaponType))
//        {
//            log("PVEGameManager read Bot Weapon csvtable is error, ID is "$BotWeaponType);
//            continue;
//        }
//        BotNum = CSVBotWeapon.GetInt("UsefulAITypeNum");
//        log("PVEGameManager-------BotNum: "$BotNum);
//
//        for(j=1; j<=BotNum; j++)
//        {
//            BotInfo.BotType =  CSVBotWeapon.GetInt("AIType"$j);
//            BotInfo.BotNum  =  CSVBotWeapon.GetInt("AINum"$j);
//            log("PVEGameManager-------BotInfo.BotType: "$BotInfo.BotType);
//            log("PVEGameManager-------BotInfo.BotNum: "$BotInfo.BotNum);
//
//            if(!CSVBotSuit.SetCurrentRow(BotInfo.BotType))
//            {
//                log("PVEGameManager read KFXBotSuit.csv is error ,ID is : "$BotInfo.BotType);
//                continue;
//            }
//
//            SuitNum = CSVBotSuit.GetInt("UsefulSuitNum");
//            randsuit = rand(SuitNum) + 1;
//            Physics =   CSVBotSuit.GetInt("PawnID"$RandSuit);
//            Suit =   CSVBotSuit.GetInt("Suit"$RandSuit);
//            BotInfo.BotSuit = Suit;
//            BotInfo.BotPhysics = Physics;
//            log("PVEGameManager-------SuitNum: "$SuitNum);
//            log("PVEGameManager-------randsuit: "$randsuit);
//            log("PVEGameManager-------Physics: "$Physics);
//            log("PVEGameManager-------Suit: "$Suit);
//
//            default.PVEAllGuanInfo[i].BotInfo.Insert(default.PVEAllGuanInfo[i].BotInfo.Length,1);
//            default.PVEAllGuanInfo[i].BotInfo[default.PVEAllGuanInfo[i].BotInfo.Length-1] = BotInfo;
//        }
//    }
//}
static function CopyStructArrayData(out array<PVEGameMapInfo> Desc,array<PVEGameMapInfo> Src)
{
    local int i;
    if(Desc.Length < Src.Length)
    {
        Desc.Insert(Desc.Length,Src.Length-Desc.Length);
    }
    for(i=0; i<Src.Length; i++)
    {
        Desc[i] = Src[i];
    }

}
static function CopyArrayData(out array<int> Desc,out array<int> Src)
{
	local int i;
	log("PVEGameManager--------Src.Length "$Src.Length);
	log("PVEGameManager--------Desc.Length "$Desc.Length);
    if(Desc.Length < Src.Length)
	{
		Desc.Insert(Desc.Length,Src.Length-Desc.Length);
	}

	for(i=0; i<Src.Length; i++)
	{
		Desc[i] = Src[i];
		log("PVEGameManager--------Desc[i] "$Desc[i]);
	}

}
static function bool CurProgressIsBoss(int RealGuan)
{
	return RealGuan == g_PerBossNum;//这一关是BOSS关
}
static function bool CurProgressIsScorer(int RealGuan)
{
	return  !CurProgressIsBoss(RealGuan) && (RealGuan  % g_PerPartNum == 0);//这一关是刷分关
}
static function bool CurProgressIsNormal(int RealGuan)
{
	return  !CurProgressIsBoss(RealGuan) && !CurProgressIsScorer(RealGuan);
}
function int GetCurProgress()
{
   return default.CurProgress;
}
static function SetStartGuan(int Start)
{
	default.StartGuan = Start;
	log("PVE Game Start Is: "$Start);
}
static function SetStartChapter(int Chapter)
{
    default.CurChapter = Chapter;
    log("PVE Game Chapter Is: "$Chapter);
}
static function bool SetPVEChapter(int Chapter)
{
	default.CurChapter = Chapter;
	log("PVE Game Chapter Is: "$Chapter);
	return true;
}
static function PVEGuanInfo GetCurGuanInfo()
{
    log("PVEGameManager PVEGuanInfo is "$default.CurProgress);
	return default.PVEAllGuanInfo[default.CurProgress];
}
static function int GetCurPVERules()
{
    log("Cur CurProgress is "$default.CurProgress);
    log("GetCurPVERules Cur RulesID is "$default.PVEAllGuanInfo[default.CurProgress].RulesID);
	return default.PVEAllGuanInfo[default.CurProgress].RulesID;
}
static function int SetCurPVERules(int RulesID)
{
    log("Cur RulesID is "$RulesID);
    log("SetCurPVERules Cur RulesID is "$default.PVEAllGuanInfo[default.CurProgress].RulesID);
	default.PVEAllGuanInfo[default.CurProgress ].RulesID = RulesID;
}
static function int SetNextPVERules(int RulesID)
{
    log("Cur RulesID is "$RulesID);
    log("SetCurPVERules Cur RulesID is "$default.PVEAllGuanInfo[default.CurProgress].RulesID);
	default.PVEAllGuanInfo[default.CurProgress + 1].RulesID = RulesID;
}
static function GetCurPVERulesBotInfo(out array<int> Desc1, out array<int> Desc2)
{
    local int i;
    local int CurGuanBotLength;

    CurGuanBotLength =  default.PVEAllGuanInfo[default.CurProgress].BotInfo.Length;
    log("PVEGameManager--------CurGuanBotLength "$CurGuanBotLength);
    if(Desc1.Length < CurGuanBotLength || Desc2.Length < CurGuanBotLength)
    {
        Desc1.Insert(Desc1.Length,CurGuanBotLength-Desc1.Length);
        Desc2.Insert(Desc2.Length,CurGuanBotLength-Desc2.Length);
    }
    for(i=0; i<CurGuanBotLength; i++)
    {
        Desc1[i] = default.PVEAllGuanInfo[default.CurProgress].BotInfo[i].BotType;
        Desc2[i] = default.PVEAllGuanInfo[default.CurProgress].BotInfo[i].BotNum;

        log("PVEGameManager--------Desc1[i] "$Desc1[i]);
        log("PVEGameManager--------Desc2[i] "$Desc2[i]);
    }

}
static function GetCurPVERulesBotOrder(out int AttackNum,out int DefendNum, out int FreeNum)
{
    log("GetCurPVERulesBotOrder Cur RulesID is "$default.PVEAllGuanInfo[default.CurProgress].RulesID);
	AttackNum = default.PVEAllGuanInfo[default.CurProgress].AttackBotNum;
	DefendNum = default.PVEAllGuanInfo[default.CurProgress].DefendBotNum;
	FreeNum   = default.PVEAllGuanInfo[default.CurProgress].FreeBotNum;
	log("AttackNum is  "$AttackNum$" DefendNum is  "$DefendNum$" FreeNum is  "$FreeNum);
}
static function int GetCurPVERulesTime()
{
    log("GetCurPVERulesTime Cur RulesID is "$default.PVEAllGuanInfo[default.CurProgress].TimeLimit);
	return default.PVEAllGuanInfo[default.CurProgress].TimeLimit;
}
static function int GetCurMapID()
{
    log("Cur Map is "$default.PVEAllGuanInfo[default.CurProgress].MapID);
	return default.PVEAllGuanInfo[default.CurProgress].MapID;
}
static function PVEGuanInfo GetGuanInfo(int GuanID)
{
	local int Progress;
	Progress = GuanID - default.StartGuan;
    log(" PVEGuanInfo is "$Progress);
	return default.PVEAllGuanInfo[Progress];
}
static function int GetPVERules(int GuanID)
{
	local int Progress;
	Progress = GuanID - default.StartGuan;
    log("GuanID is :"$GuanID$" RulesID is "$default.PVEAllGuanInfo[Progress].RulesID);
	return default.PVEAllGuanInfo[Progress].RulesID;
}

static function int GetPVEMapID(int GuanID)
{
	local int Progress;
	Progress = GuanID - default.StartGuan;
    log("GuanID is :"$GuanID$" Map is "$default.PVEAllGuanInfo[Progress].MapID);
	return default.PVEAllGuanInfo[Progress].MapID;
}
static function string GetPVEMapString(int GuanID)
{
	local string MapStr;
	local int MapID;
	local KFXCSVTable KFXMapInfo;
	KFXMapInfo = class'KFXTools'.static.KFXCreateCSVTable("KFXMapInfo.csv");
	MapID = GetPVEMapID(GuanID);
	log("PVEGameManager-------MapID "$MapID);
	if(!KFXMapInfo.SetCurrentRow(MapID))
	{
		log("PVE MapID Is ,%d, Error"$MapID);
		return MapStr;
	}
	MapStr = KFXMapInfo.GetString("MapName");
	MapStr $=".ut2";
	log("PVEGameManager-------MapStr "$MapStr);
	return MapStr;
}
static function bool PrepareNextGuan()
{
	default.CurProgress++;
	log("Start Prepare Next Guan "$default.CurProgress);
	return true;
}
static function bool SetProgress(int Pro)
{
	default.CurProgress = Pro;
	log("Set Next Guan "$default.CurProgress);
	return true;
}
static function int GetRulesByIndex(int i)
{
	log("PVEGameManager-------default.PVEAllGuanInfo[i].RulesID "$default.PVEAllGuanInfo[i].RulesID);
    return default.PVEAllGuanInfo[i].RulesID;
}
static function int GetMapByIndex(int i)
{
	log("PVEGameManager-------default.PVEAllGuanInfo[i].MapID "$default.PVEAllGuanInfo[i].MapID);
	return default.PVEAllGuanInfo[i].MapID;
}

//包含之前章节的部分，例如第二章第一部分是4，而不是1
static function int GetCurPart()
{
	return (default.CurChapter - 1)*3 + ((default.StartGuan + default.CurProgress - 1)/9 + 1);
}
static function bool IsFirstGuanInPart()
{
	return  (default.StartGuan + default.CurProgress)%9 == 1;
}

defaultproperties
{
     CurChapter=1
     CurProgress=-1
     StartGuan=1
}
