//-----------------------------------------------------------
//  Class:      KFXGame.KFXScoreBoard
//  Modify:     zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-04-04
//  Desc:       HUD����ķ������޸�
//  Update:
//  Special:    ����԰���ɾ��̴�
//-----------------------------------------------------------
class KFXScoreBoard extends ScoreBoard;


var localized string FontArrayNames[9];
var localized string lCurGameRoom;          //="��ǰ��%index�ŷ�����Ϸ"
var Font FontArrayFonts[9];

var KFXPlayerReplicationInfo PRI, OwnerPRI;
var KFXPlayerReplicationInfo RedPRI[8], BluePRI[8];
var int RedPlayerCount, BluePlayerCount;

var color ShadeColor;
var string KFXBoardFontAlias;

var string KFXMatSrc;

var float totaltime;
var int gfps;                     //������ʾ��fps
var int lfps;                     //���������fps
var int killerID;			//���һ�λ�ɱ�Լ������id
//<< �������
var localized array<string> CONF_WhichWins,     //("ƽ��","���ӻ�ʤ","��ӻ�ʤ")
                            CONF_Modes,         //("�ŶӸ���","���˸���","�ŶӾ���","����ģʽ","ռ��ģʽ","����ģʽ","̹�˴�ս","ľ����ģʽ","ľ����2ģʽ","������ϰ)
                            CONF_Ranks;         //("��ϲ���ٻ�ھ�","��ϲ���ٻ��Ǿ�","��ϲ���ٻ񼾾�")

var localized string        CONF_Team,          //"����"
                            CONF_Level,         //"�ȼ�"
                            CONF_Name,          //"�ǳ�"
                            CONF_TeamName,      //"ս������"
                            CONF_Contrib,       //"���׶�"
                            CONF_Kill,          //"����"
                            CONF_Die,           //"����"
                            CONF_Point,         //"����ֵ"
                            CONF_Bonus,         //"������������"
                            CONF_GPoint,        //"��ý��"
                            CONF_PPoint,        //"�������ֵ"
                            CONF_Times,         //"��"
                            CONF_Account,         //"�÷�"
                            CONF_TeamAccount;   // "ս�ӷ���"

//>>

//����
var string                  MedalMatName[3];    //������Դ��

var int					nTestCnt;

simulated function KFXGameReplicationInfo GetGRI()
{
    return KFXGameReplicationInfo(GRI);
}

// ����ScoreBoard��ÿ֡���ᱻ���õĶ���
simulated event UpdateScoreBoard(Canvas Canvas)
{
    OwnerPRI = KFXPlayerReplicationInfo(PlayerController(Owner).PlayerReplicationInfo);

    // ����ս�����
    if ( PlayerController(Owner).IsInState('GameEnded')
         || PlayerController(Owner).IsInState('MatchOver'))
	{
		//����ս����ĵ�UI�У�����hud��
        DrawFinal(Canvas);
	}
	// С��ս�����
    else if( PlayerController(Owner).IsInState('RoundEnded'))
    {
        DrawRound(Canvas);
    }
    // ��ʱս�����
    else
    {
    	nTestCnt++;
	   //DrawInstant(Canvas);
    }
}

// ����ʱս��
simulated function DrawInstant(Canvas Canvas) {}
function KFXDrawBattleInfo(Canvas Canvas);
function _DrawWinLossDraw(Canvas Canvas) ;

// ������ս��
simulated function DrawFinal(Canvas Canvas)//wangkai modified...
{
    local KFXHUD nethud;
    nethud= KFXHUD(PlayerController(Owner).myhud);


    // ��ս�����
    if( KFXPlayer(Owner).bShowWinAndLoss )
    {
        _DrawWinLossDraw(Canvas);
    }

}

// С��ս�����
simulated function DrawRound(Canvas Canvas) {}

// ������ȼ�
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
//��ս��ͼ��
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

//---------------------- wangkai, ����ս����� -----------------------
//������ս��-����
simulated function DrawFinalBackground(Canvas Canvas);

//������ս��-����б�
simulated function DrawFinalPlayerList(Canvas Canvas);

//��ģʽ��Ϣ
simulated function DrawFinalModeInfo(Canvas Canvas);

//��ģʽ����
simulated function _DrawFinalModeName(Canvas Canvas);

//������ս��-�ҵĳɼ�
simulated function DrawFinalMyScore(Canvas Canvas)
{
    local int MyFinalExp;
    MyFinalExp = OwnerPRI.fxCurrExp + OwnerPRI.fxExtraExp;

//    //��ý��
//    Canvas.SetDrawColor(244, 240, 195, 255);
//    Canvas.KFXFontAlias = "heavymedium15";
//    KFXDrawTextCsv(Canvas, 221, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 222, "heavymedium15", OwnerPRI.fxGameCash);
//
//    //�������ֵ
//    KFXDrawTextCsv(Canvas, 223, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 224, "heavymedium15", MyFinalExp);
//
//    //������/����
//    KFXDrawTextCsv(Canvas, 225, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 226, "heavymedium15", OwnerPRI.fxKills $ "/" $ OwnerPRI.fxDeaths);
//    //���ҵĻ�ɱ����
//
//    //����ͷ
//	KFXDrawBoardTile(Canvas, 201);
//	KFXDrawTextCsv(Canvas, 227, "heavymedium15", ""$ PRI.fxHeadKillNum);
//    //����ɱ
//	KFXDrawBoardTile(Canvas, 202);
//	KFXDrawTextCsv(Canvas, 228, "heavymedium15", ""$ PRI.fxDaggerKillNum);
//    //��ɱ����
//	KFXDrawBoardTile(Canvas, 203);
//	KFXDrawTextCsv(Canvas, 229, "heavymedium15", ""$ PRI.fxSpecKillNum);
}

//������ս��-�콱̨
function DrawFinalRostrum(Canvas Canvas)
{
    local int i;
    for (i=0; i<GRI.PRIArray.length && i<3; i++)//ǰ����
    {
    	if( GRI.PRIArray[i] == OwnerPRI )//���Լ�
    	{
            //������ϲ���ٻ�XX��
            Canvas.SetDrawColor(255, 255, 255, 255);
            KFXDrawBoardText(Canvas, CONF_Ranks[i], 204, i);

            //������(��Ȼλ���ҵĳɼ�����������ȽϷ���)
            Canvas.SetPos(742, 160);
            _DrawFinalPlayerMedal(Canvas, i);
        }
        else
        {
            //��������ֺ͵ȼ�
            _DrawFinalPlayerNameAndLevel(Canvas, KFXPlayerReplicationInfo(GRI.PRIArray[i]), i);
            //����ͷ/��ɱ/ɱ����
            _DrawFinalKillStatistics(Canvas, KFXPlayerReplicationInfo(GRI.PRIArray[i]),i);
        }
    }
}

//������ս��-������б��ͷ
simulated function _DrawFinalPlayerListHeader(Canvas Canvas, float Y1);

//������ս��-������б��е�һ��
simulated function _DrawFinalPlayerListLine(Canvas Canvas, KFXPlayerReplicationInfo PRI, float Y1);

//������ս��-����ͷ/��ɱ/ɱ����
simulated function _DrawFinalKillStatistics(Canvas Canvas, KFXPlayerReplicationInfo PRI, int Index)
{
    Canvas.SetDrawColor(255, 255, 255, 255);

    //����ͷ
	KFXDrawBoardTile(Canvas, 204, Index);
	KFXDrawBoardText(Canvas, ""$ PRI.fxHeadKillNum, 201, Index);
    //����ɱ
	KFXDrawBoardTile(Canvas, 205, Index);
	KFXDrawBoardText(Canvas, ""$ PRI.fxDaggerKillNum, 202, Index);
    //��ɱ����
	KFXDrawBoardTile(Canvas, 206, Index);
	KFXDrawBoardText(Canvas, ""$ PRI.fxSpecKillNum, 203, Index);
}

//������ս��-������ǳƺ͵ȼ�ͼ��
simulated function _DrawFinalPlayerNameAndLevel(Canvas Canvas, KFXPlayerReplicationInfo PRI, int Index)
{
//    Canvas.KFXFontAlias = "heavymedium15";
//    KFXDrawBoardText(Canvas, ""$ PRI.PlayerName, 203, Index);
//    DrawPlayerLevel(Canvas, PRI, 208, 76);
}

//������ս��-������ͭ��
simulated function _DrawFinalPlayerMedal(Canvas Canvas, int Rank)
{
    if (Rank < 0 || Rank>2)
        return;
    KFXDrawBoardTile(Canvas, 207,, MedalMatName[Rank]);

}
//--------------------------------------------------------------------



// ����һ������
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

// ��������(���׶� - ������ - ������)
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
// �½ṹ - ��װһ�������ֵ����ñ�ӿ�
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

// �½ṹ - ��ͼ�Ľӿ�                                            //��ֱ��ʵ�ʱ������
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

//��Ҫ���ݣ�����ڵ�һ��λ�õ�ƫ��YPosEx�� ÿ��λ�õĸ߶�Height
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
	if(pMatSrc == "")	//����pMatSrc֮�󣬲���Ҫ�����еĵ�ͼ������Ҫ���е�һЩ������Ϣ
	{
    	MatSrc = CsvBoardTile.GetString("MatSrc");
	}
	else
	{
    	MatSrc = pMatSrc;
	}

	//���ݡ�set:imagesetname image:imagename������
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
        PosX = PosX - 32;   //�ͽ�ĵȼ�ͼ��������32��
        PosY = PosY + 33;
    }
    LengthX = CsvBoardTile.GetFloat("LengthX");
    LengthY = CsvBoardTile.GetFloat("LengthY");
    if(pMatSrc == "")	//���ʹ��pMatSrc����ô����Ҫ��ȡ���е���Щ�ֶΣ�������pMatSrc��
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
