//-----------------------------------------------------------
//  Class:      KFXGame.KFXScoreBoard
//  Modify:     zhangjinpin@kingsoft 张金品
//  Data:       2007-04-04
//  Desc:       HUD代码的分析和修改
//  Update:
//  Special:    返故园，松菊犹存
//-----------------------------------------------------------
class KFXScoreBoard extends ScoreBoard;


var localized string FontArrayNames[9];
var localized string lCurGameRoom;          //="当前在%index号房间游戏"
var Font FontArrayFonts[9];

var KFXPlayerReplicationInfo PRI, OwnerPRI;
var KFXPlayerReplicationInfo RedPRI[8], BluePRI[8];
var int RedPlayerCount, BluePlayerCount;

var color ShadeColor;
var string KFXBoardFontAlias;

var string KFXMatSrc;

var float totaltime;
var int gfps;                     //用来显示的fps
var int lfps;                     //用来计算的fps
var int killerID;			//最后一次击杀自己的玩家id
//<< 文字相关
var localized array<string> CONF_WhichWins,     //("平局","蓝队获胜","红队获胜")
                            CONF_Modes,         //("团队复生","个人复生","团队竞技","爆破模式","占领模式","永生模式","坦克大战","木乃伊模式","木乃伊2模式","反恐演习)
                            CONF_Ranks;         //("恭喜您荣获冠军","恭喜您荣获亚军","恭喜您荣获季军")

var localized string        CONF_Team,          //"队伍"
                            CONF_Level,         //"等级"
                            CONF_Name,          //"昵称"
                            CONF_TeamName,      //"战队名称"
                            CONF_Contrib,       //"贡献度"
                            CONF_Kill,          //"消灭"
                            CONF_Die,           //"牺牲"
                            CONF_Point,         //"荣誉值"
                            CONF_Bonus,         //"特殊荣誉奖励"
                            CONF_GPoint,        //"获得金币"
                            CONF_PPoint,        //"获得荣誉值"
                            CONF_Times,         //"次"
                            CONF_Account,         //"得分"
                            CONF_TeamAccount;   // "战队分数"

//>>

//奖牌
var string                  MedalMatName[3];    //奖牌资源名

var int					nTestCnt;

simulated function KFXGameReplicationInfo GetGRI()
{
    return KFXGameReplicationInfo(GRI);
}

// 更新ScoreBoard，每帧都会被调用的东西
simulated event UpdateScoreBoard(Canvas Canvas)
{
    OwnerPRI = KFXPlayerReplicationInfo(PlayerController(Owner).PlayerReplicationInfo);

    // 最终战绩面板
    if ( PlayerController(Owner).IsInState('GameEnded')
         || PlayerController(Owner).IsInState('MatchOver'))
	{
		//最终战绩表改到UI中，不画hud了
        DrawFinal(Canvas);
	}
	// 小局战绩面板
    else if( PlayerController(Owner).IsInState('RoundEnded'))
    {
        DrawRound(Canvas);
    }
    // 及时战绩面板
    else
    {
    	nTestCnt++;
	   //DrawInstant(Canvas);
    }
}

// 画即时战绩
simulated function DrawInstant(Canvas Canvas) {}
function KFXDrawBattleInfo(Canvas Canvas);
function _DrawWinLossDraw(Canvas Canvas) ;

// 画最终战绩
simulated function DrawFinal(Canvas Canvas)//wangkai modified...
{
    local KFXHUD nethud;
    nethud= KFXHUD(PlayerController(Owner).myhud);


    // 画战绩面板
    if( KFXPlayer(Owner).bShowWinAndLoss )
    {
        _DrawWinLossDraw(Canvas);
    }

}

// 小局战绩面板
simulated function DrawRound(Canvas Canvas) {}

// 画人物等级
simulated function DrawPlayerLevelEx(Canvas Canvas, KFXPlayerReplicationInfo PlayerRP,
									int TileIndex, int YPosEx,optional bool bIsAIGame)
{
    local KFXCSVTable fxCsvLevel;
    local string sLevelIcon;

    fxCsvLevel = class'KFXTools'.static.KFXCreateCSVTable("LevelUpgradeTable.csv");

    if( fxCsvLevel == none )
    {
        return;
    }

    if( !fxCsvLevel.SetCurrentRow(PlayerRP.fxLevel) )
    {
        return;
    }

    sLevelIcon = fxCsvLevel.GetString("SmallLevelIcon");
	KFXDrawXMLBoardTile(Canvas, TileIndex, YPosEx, sLevelIcon,bIsAIGame);
}
//画战队图标
function DrawPlayerFactionIcon(Canvas canvas,
				int icon_idx, int TileIdx, int YPosEx, optional bool bAIGame)
{
	local string faction_icon;
	local float u, v, ul, vl;

	faction_icon = "set:mat2_createteampage image:NewImage10";

	Canvas.KFXLoadXMLMaterial("mat2_createteampage", "NewImage10", u, v, ul, vl);


	KFXDrawXMLBoardTile(Canvas, TileIdx, YPosEx, faction_icon, bAIGame);
}


simulated function DrawPlayerLevel(Canvas Canvas, KFXPlayerReplicationInfo PlayerRP,
									int TileIndex, int RowIndex)
{
    local KFXCSVTable fxCsvLevel;
    local string sLevelIcon;

    fxCsvLevel = class'KFXTools'.static.KFXCreateCSVTable("LevelUpgradeTable.csv");

    if( fxCsvLevel == none )
    {
        return;
    }

    if( !fxCsvLevel.SetCurrentRow(PlayerRP.fxLevel) )
    {
        return;
    }

    sLevelIcon = fxCsvLevel.GetString("SmallLevelIcon");
	KFXDrawBoardTile(Canvas, TileIndex, RowIndex, sLevelIcon);
}

//---------------------- wangkai, 最终战绩相关 -----------------------
//画最终战绩-背景
simulated function DrawFinalBackground(Canvas Canvas);

//画最终战绩-玩家列表
simulated function DrawFinalPlayerList(Canvas Canvas);

//画模式信息
simulated function DrawFinalModeInfo(Canvas Canvas);

//画模式名称
simulated function _DrawFinalModeName(Canvas Canvas);

//画最终战绩-我的成绩
simulated function DrawFinalMyScore(Canvas Canvas)
{
    local int MyFinalExp;
    MyFinalExp = OwnerPRI.fxCurrExp + OwnerPRI.fxExtraExp;

//    //获得金币
//    Canvas.SetDrawColor(244, 240, 195, 255);
//    Canvas.KFXFontAlias = "heavymedium15";
//    KFXDrawTextCsv(Canvas, 221, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 222, "heavymedium15", OwnerPRI.fxGameCash);
//
//    //获得荣誉值
//    KFXDrawTextCsv(Canvas, 223, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 224, "heavymedium15", MyFinalExp);
//
//    //画消灭/牺牲
//    KFXDrawTextCsv(Canvas, 225, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 226, "heavymedium15", OwnerPRI.fxKills $ "/" $ OwnerPRI.fxDeaths);
//    //画我的击杀绩计
//
//    //画爆头
//	KFXDrawBoardTile(Canvas, 201);
//	KFXDrawTextCsv(Canvas, 227, "heavymedium15", ""$ PRI.fxHeadKillNum);
//    //画刀杀
//	KFXDrawBoardTile(Canvas, 202);
//	KFXDrawTextCsv(Canvas, 228, "heavymedium15", ""$ PRI.fxDaggerKillNum);
//    //画杀动物
//	KFXDrawBoardTile(Canvas, 203);
//	KFXDrawTextCsv(Canvas, 229, "heavymedium15", ""$ PRI.fxSpecKillNum);
}

//画最终战绩-领奖台
function DrawFinalRostrum(Canvas Canvas)
{
    local int i;
    for (i=0; i<GRI.PRIArray.length && i<3; i++)//前三名
    {
    	if( GRI.PRIArray[i] == OwnerPRI )//是自己
    	{
            //画“恭喜您荣获XX”
            Canvas.SetDrawColor(255, 255, 255, 255);
            KFXDrawBoardText(Canvas, CONF_Ranks[i], 204, i);

            //画奖牌(虽然位于我的成绩里，但这里做比较方便)
            Canvas.SetPos(742, 160);
            _DrawFinalPlayerMedal(Canvas, i);
        }
        else
        {
            //画玩家名字和等级
            _DrawFinalPlayerNameAndLevel(Canvas, KFXPlayerReplicationInfo(GRI.PRIArray[i]), i);
            //画爆头/刀杀/杀动物
            _DrawFinalKillStatistics(Canvas, KFXPlayerReplicationInfo(GRI.PRIArray[i]),i);
        }
    }
}

//画最终战绩-画玩家列表表头
simulated function _DrawFinalPlayerListHeader(Canvas Canvas, float Y1);

//画最终战绩-画玩家列表中的一行
simulated function _DrawFinalPlayerListLine(Canvas Canvas, KFXPlayerReplicationInfo PRI, float Y1);

//画最终战绩-画爆头/刀杀/杀动物
simulated function _DrawFinalKillStatistics(Canvas Canvas, KFXPlayerReplicationInfo PRI, int Index)
{
    Canvas.SetDrawColor(255, 255, 255, 255);

    //画爆头
	KFXDrawBoardTile(Canvas, 204, Index);
	KFXDrawBoardText(Canvas, ""$ PRI.fxHeadKillNum, 201, Index);
    //画刀杀
	KFXDrawBoardTile(Canvas, 205, Index);
	KFXDrawBoardText(Canvas, ""$ PRI.fxDaggerKillNum, 202, Index);
    //画杀动物
	KFXDrawBoardTile(Canvas, 206, Index);
	KFXDrawBoardText(Canvas, ""$ PRI.fxSpecKillNum, 203, Index);
}

//画最终战绩-画玩家昵称和等级图标
simulated function _DrawFinalPlayerNameAndLevel(Canvas Canvas, KFXPlayerReplicationInfo PRI, int Index)
{
//    Canvas.KFXFontAlias = "heavymedium15";
//    KFXDrawBoardText(Canvas, ""$ PRI.PlayerName, 203, Index);
//    DrawPlayerLevel(Canvas, PRI, 208, 76);
}

//画最终战绩-画金银铜牌
simulated function _DrawFinalPlayerMedal(Canvas Canvas, int Rank)
{
    if (Rank < 0 || Rank>2)
        return;
    KFXDrawBoardTile(Canvas, 207,, MedalMatName[Rank]);

}
//--------------------------------------------------------------------



// 载入一种字体
function Font LoadFontStatic(int i)
{
	if( default.FontArrayFonts[i] == none )
	{
		default.FontArrayFonts[i] = Font(DynamicLoadObject(default.FontArrayNames[i], class'Font'));

		if( default.FontArrayFonts[i] == none )
		{
			Log("Warning: "$default.Class$" Couldn't dynamically load font "$default.FontArrayNames[i]);
		}
	}

	return default.FontArrayFonts[i];
}

// 排名方法(贡献度 - 击毙熟 - 死亡数)
simulated function bool InOrder( PlayerReplicationInfo P1, PlayerReplicationInfo P2 )
{
    local KFXPlayerReplicationInfo KP1;
    local KFXPlayerReplicationInfo KP2;

    KP1 = KFXPlayerReplicationInfo(P1);
    KP2 = KFXPlayerReplicationInfo(P2);


    if( KP1.fxContribution < KP2.fxContribution )
    {
        return false;
    }
    else if( KP1.fxContribution == KP2.fxContribution )
    {
        if( KP1.fxKills < KP2.fxKills )
        {
            return false;
        }
        if( KP1.fxKills == KP2.fxKills )
        {
    		if ( KP1.fxDeaths > KP2.fxDeaths )
    		{
    			return false;
    		}
    	}
    }
    return true;
}

//------------------------------------------------------------------------------
// 新结构 - 封装一个画文字的配置表接口
simulated function KFXDrawTextCsv(Canvas Canvas, int Index, string FontAlias, optional coerce string Text)
{
    local KFXCSVTable fxCsvHudText;


    local string fxText;
    local int nJustfied;
    local int nShader;
    local float LeftX;
    local float LeftY;
    local float RightX;
    local float RightY;
    local bool Active;

    fxCsvHudText = class'KFXTools'.static.KFXCreateCSVTable("KFXHudText.csv");

    if( fxCsvHudText == none )
    {
        return;
    }

    if( Index == 0 || !fxCsvHudText.SetCurrentRow(Index) )
    {
        return;
    }

    Active = fxCsvHudText.GetBool("Active");

	if ( !Active )
	{
		return;
	}

	if ( Text == "" )
	{
    	fxText = fxCsvHudText.GetString("Text");
    }
    else
    {
    	fxText = Text;
    }
    nJustfied = fxCsvHudText.GetInt("Justfied");
    nShader = fxCsvHudText.GetInt("Shader");
    LeftX = fxCsvHudText.GetFloat("LeftX");
    LeftY = fxCsvHudText.GetFloat("LeftY");
    RightX = fxCsvHudText.GetFloat("RightX");
    RightY = fxCsvHudText.GetFloat("RightY");


    Canvas.KFXFontAlias = FontAlias;
    Canvas.KFXSetPivot(DP_MiddleMiddle);
    Canvas.KFXDrawStrJustifiedWithBorder(
        fxText,
        nJustfied,
        LeftX, LeftY,
        RightX, RightY,
        ShadeColor,
        nShader
        );
    Canvas.KFXSetPivot(DP_UpperLeft);
}

// 新结构 - 画图的接口                                            //大分辨率的时候，拉伸
simulated function KFXDrawTileCsv(Canvas Canvas, int Index, optional bool bfull)
{
    local KFXCSVTable fxCsvHudTile;
    local Material fxMat;

    local string fxMatSrc;
    local float PosX;
    local float PosY;
    local float OrigX;
    local float OrigY;
    local float ClipX;
    local float ClipY;
    local KFXHUD nethud;

    nethud= KFXHUD(PlayerController(Owner).myhud);

    fxCsvHudTile = class'KFXTools'.static.KFXCreateCSVTable("KFXHudTile.csv");

    if( fxCsvHudTile == none )
    {
        ;
        return;
    }

    if( Index == 0 || !fxCsvHudTile.SetCurrentRow(Index) )
    {
        ;
        return;
    }

    fxMatSrc = fxCsvHudTile.GetString("MatSrc");
    fxMat = Material(DynamicLoadObject(fxMatSrc, class'Material'));

    if( fxMat == none )
    {
        ;
        return;
    }

    PosX = fxCsvHudTile.GetFloat("PosX");
    PosY = fxCsvHudTile.GetFloat("PosY");
    OrigX = fxCsvHudTile.GetFloat("OrigX");
    OrigY = fxCsvHudTile.GetFloat("OrigY");
    ClipX = fxCsvHudTile.GetFloat("ClipX");
    ClipY = fxCsvHudTile.GetFloat("ClipY");


    Canvas.KFXSetPivot(DP_UpperMiddle);
    Canvas.SetPos( PosX, PosY);
    if(bfull)
    {
    	Canvas.KFXSetPivot(DP_UpperLeft);
		Canvas.DrawTile(fxMat, ClipX/1024.0*Canvas.SizeX, ClipY/768.0*Canvas.SizeY,
				OrigX, OrigY, ClipX, ClipY);
	}
	else
	{
	    Canvas.DrawTile(
	        fxMat,
	        ClipX, ClipY,
	        OrigX, OrigY,
	        ClipX, ClipY
	        );
	}
    Canvas.SetDrawColor(255, 255, 255, 255);
//    Canvas.KFXFontAlias = "heavymedium15";

//    if( nethud.sRealmName == "none Realm" )
//        Canvas.KFXDrawStrJustified("FPS:"$gfps, 1,
//        PosX, PosY+ClipY,
//        PosX + ClipX, PosY+ClipY+30
//        );
//    else
//        Canvas.KFXDrawStrJustified("FPS:"$gfps$"   "$nethud.sRealmName$"   "$nethud.sChannelName$"   "$
//        "["$nethud.nRoomID$"]"$nethud.sRoomName, 1,
//        PosX, PosY+ClipY,
//        PosX + ClipX, PosY+ClipY+30
//        );
    Canvas.KFXSetPivot(DP_UpperLeft);
}
//------------------------------------------------------------------------------

function tick(float deltatime)
{
    totaltime+=deltatime;
    lfps++;
    if(totaltime>1)
    {
        gfps=lfps;
        lfps=0;
        totaltime=0;
    }
}

simulated function string KFXGetFactionIcon(KFXPlayerReplicationInfo PRI)
{
	if ( PRI.fxFactionIcon != 0 )
	{
		return "fx_ui3_texs.FactionIcon_S_" $ PRI.fxFactionIcon;
	}
	else
	{
		return "";
	}
}

simulated function string KFXGetFactionBackGround(KFXPlayerReplicationInfo PRI)
{
	if ( PRI.fxFactionBackGround != 0 )
	{
		return "fx_ui3_texs.FactionIcon_S_" $ PRI.fxFactionBackGround;
	}
	else
	{
		return "";
	}
}

simulated function KFXDrawBoardText(Canvas Canvas, string Text, int Index, int RowIndex)
{
    local KFXCSVTable CsvBoardText;

    local int nJustfied;
    local int nShader;
    local float LeftX;
    local float LeftY;
    local float RightX;
    local float RightY;
    local bool Active;
    local int RowSpacing;

    CsvBoardText = class'KFXTools'.static.KFXCreateCSVTable("ScoreBoardText.csv");

    if( CsvBoardText == none )
    {
        return;
    }

    if( Index == 0 || !CsvBoardText.SetCurrentRow(Index) )
    {
        return;
    }

    Active = CsvBoardText.GetBool("Active");
    nJustfied = CsvBoardText.GetInt("Justfied");
    nShader = CsvBoardText.GetInt("Shader");
    LeftX = CsvBoardText.GetFloat("LeftX");
    LeftY = CsvBoardText.GetFloat("LeftY");
    RightX = CsvBoardText.GetFloat("RightX");
    RightY = CsvBoardText.GetFloat("RightY");
    RowSpacing = CsvBoardText.GetInt("RowSpacing");

	if ( Active )
	{
	    Canvas.KFXDrawStrJustifiedWithBorder(
	        Text,
	        nJustfied,
	        LeftX, LeftY + RowIndex * RowSpacing,
	        RightX, RightY + RowIndex * RowSpacing,
	        ShadeColor,
	        nShader
	        );
    }

}

//需要传递：相对于第一个位置的偏移YPosEx， 每个位置的高度Height
simulated function KFXDrawBoardTextEx(Canvas Canvas, string Text, int Index, int YPosEx, int Height)
{
    local KFXCSVTable CsvBoardText;

    local int nJustfied;
    local int nShader;
    local float LeftX;
    local float LeftY;
    local float RightX;
    local float RightY;
    local bool Active;
    local int RowSpacing;

    CsvBoardText = class'KFXTools'.static.KFXCreateCSVTable("ScoreBoardText.csv");

    if( CsvBoardText == none )
    {
        return;
    }

    if( Index == 0 || !CsvBoardText.SetCurrentRow(Index) )
    {
        return;
    }

    Active = CsvBoardText.GetBool("Active");
    nJustfied = CsvBoardText.GetInt("Justfied");
    nShader = CsvBoardText.GetInt("Shader");
    LeftX = CsvBoardText.GetFloat("LeftX");
    LeftY = CsvBoardText.GetFloat("LeftY");
    RightX = CsvBoardText.GetFloat("RightX");
    RightY = CsvBoardText.GetFloat("RightY");
    RowSpacing = CsvBoardText.GetInt("RowSpacing");

	if ( Active )
	{
	    Canvas.KFXDrawStrJustifiedWithBorder(
	        Text,
	        nJustfied,
	        LeftX, LeftY + YPosEx,
	        RightX, RightY + YPosEx,
	        ShadeColor,
	        nShader
	        );
    }

}
simulated function KFXDrawXMLBoardTile(Canvas Canvas, int TileIndex, optional int YPosEx,
				optional String pMatSrc,optional bool bIsAIGame)
{
    local KFXCSVTable CsvBoardTile;
    local Material Mat;

    local string MatSrc;
    local string MatSet, MatImage;
    local bool Active;
    local int PosX, PosY;
    local float OrigX, OrigY;
    local float ClipX, ClipY;
    local float LengthX, LengthY;
    local int RowSpacing;


    CsvBoardTile = class'KFXTools'.static.KFXCreateCSVTable("ScoreBoardTile.csv");

    if( CsvBoardTile == none )
    {
        ;
        return;
    }

    if( TileIndex == 0 || !CsvBoardTile.SetCurrentRow(TileIndex) )
    {
        ;
        return;
    }
	if(pMatSrc == "")	//传入pMatSrc之后，不需要读表中的底图，但需要表中的一些坐标信息
	{
    	MatSrc = CsvBoardTile.GetString("MatSrc");
	}
	else
	{
    	MatSrc = pMatSrc;
	}

	//根据“set:imagesetname image:imagename”解析
	MatSrc = Right(MatSrc, Len(MatSrc)-InStr(MatSrc, ":")-1);
	MatSet = Left(MatSrc, InStr(MatSrc, " "));
	MatImage = Right(MatSrc, Len(MatSrc)-InStr(MatSrc, ":")-1);
	if(MatSet != "" && MatImage != "")
	{
	    Mat = Canvas.KFXLoadXMLMaterial(MatSet, MatImage, OrigX, OrigY, ClipX, ClipY);

    }
	else
	{

	}

    if( Mat == none )
    {
        ;
        return;
    }

    Active = CsvBoardTile.GetBool("Active");
    PosX = CsvBoardTile.GetFloat("PosX");
    PosY = CsvBoardTile.GetFloat("PosY");
    if(bIsAIGame && TileIndex == 308)
    {
        PosX = PosX - 32;   //赏金的等级图标向左移32；
        PosY = PosY + 33;
    }
    LengthX = CsvBoardTile.GetFloat("LengthX");
    LengthY = CsvBoardTile.GetFloat("LengthY");
    if(pMatSrc == "")	//如果使用pMatSrc，那么不需要读取表中的这些字段，而是用pMatSrc的
    {
	    OrigX = CsvBoardTile.GetFloat("OrigX");
	    OrigY = CsvBoardTile.GetFloat("OrigY");
	    ClipX = CsvBoardTile.GetFloat("ClipX");
	    ClipY = CsvBoardTile.GetFloat("ClipY");
	    RowSpacing = CsvBoardTile.GetInt("RowSpacing");
	}

	if ( Active )
	{
	    Canvas.SetPos(PosX, PosY + YPosEx);
	    if(TileIndex == 315 || TileIndex == 306 || TileIndex == 329
				|| TileIndex == 406 || TileIndex == 415 || LengthX == 1024)
	    {
	    	Canvas.KFXSetPivot(DP_MiddleLeft);
	    	Canvas.SetPos(0, PosY + YPosEx);
	    	LengthX = LengthX / 1024.0 * Canvas.SizeX;
			Canvas.SetDrawColor(255, 255, 255, 200);
			Canvas.KFXDrawXMLTile(MatSet, MatImage, false, LengthX, LengthY, OrigX,
					OrigY, ClipX, ClipY);

		}
		else
		{
			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.KFXDrawXMLTile(MatSet, MatImage, true, LengthX, LengthY, OrigX,
					OrigY, ClipX, ClipY);
	    }
	    Canvas.SetDrawColor(255, 255, 255, 255);
    }
}
simulated function KFXDrawBoardTile(Canvas Canvas, int TileIndex, optional int RowIndex, optional string TileSrc)
{
    local KFXCSVTable CsvBoardTile;
    local Material Mat;

    local string MatSrc;
    local bool Active;
    local int PosX, PosY;
    local int OrigX, OrigY;
    local int ClipX, ClipY;
    local int LengthX, LengthY;
    local int RowSpacing;


    CsvBoardTile = class'KFXTools'.static.KFXCreateCSVTable("ScoreBoardTile.csv");

    if( CsvBoardTile == none )
    {
        ;
        return;
    }

    if( TileIndex == 0 || !CsvBoardTile.SetCurrentRow(TileIndex) )
    {
        ;
        return;
    }

	if ( TileSrc != "" )
	{
		MatSrc = TileSrc;
    }
    else
    {
    	MatSrc = CsvBoardTile.GetString("MatSrc");
    }

    Mat = Material(DynamicLoadObject(MatSrc, class'Material'));

    if( Mat == none )
    {
        ;
        return;
    }

    Active = CsvBoardTile.GetBool("Active");
    PosX = CsvBoardTile.GetFloat("PosX");
    PosY = CsvBoardTile.GetFloat("PosY");
    LengthX = CsvBoardTile.GetFloat("LengthX");
    LengthY = CsvBoardTile.GetFloat("LengthY");
    OrigX = CsvBoardTile.GetFloat("OrigX");
    OrigY = CsvBoardTile.GetFloat("OrigY");
    ClipX = CsvBoardTile.GetFloat("ClipX");
    ClipY = CsvBoardTile.GetFloat("ClipY");
    RowSpacing = CsvBoardTile.GetInt("RowSpacing");

	if ( Active )
	{
	    Canvas.SetPos(PosX, PosY + RowIndex * RowSpacing);
	    Canvas.DrawTile(
	        Mat,
	        LengthX, LengthY,
	        OrigX, OrigY,
	        ClipX, ClipY
	        );
	    Canvas.SetDrawColor(255, 255, 255, 255);
    }
}

defaultproperties
{
     ShadeColor=(A=255)
     KFXBoardFontAlias="heavymedium14"
     MedalMatName(0)="fx_ui3_texs.HUD_taxis_medal_Gold"
     MedalMatName(1)="fx_ui3_texs.HUD_taxis_medal_Silver"
     MedalMatName(2)="fx_ui3_texs.HUD_taxis_medal_Bronze"
     HudClass=Class'KFXGame.KFXHUD'
}
