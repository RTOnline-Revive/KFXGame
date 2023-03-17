//-----------------------------------------------------------
//  Class:      KFXGame.KFXTeamScoreBoard
//  Modify:     zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-07-02
//  Desc:
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXTeamScoreBoard extends KFXScoreBoard;

// ��������
var Font fxFontArray[10];
var string fxFontNames[10];
var int nWinnerExp;
var int nDynamicExp;
var int ntemptest;

var string DrawWinLossMatNames[9];

var RandCoin RotCoin;

// ����ScoreBoard��ÿ֡���ᱻ���õĶ���
simulated event UpdateScoreBoard(Canvas Canvas)
{
    local int i;

	RedPlayerCount = 0;
    BluePlayerCount = 0;

	// ������ʾ
    for ( i = 0; i < GRI.PRIArray.Length; i++ )
	{
		PRI = KFXPlayerReplicationInfo(GRI.PRIArray[i]);

		if ( (PRI.Team != None) && (!PRI.bIsSpectator || PRI.bWaitingPlayer) )
		{
			if ( PRI.IsRedTeam() )
			{
				if ( RedPlayerCount < 8 )
				{
					RedPRI[RedPlayerCount] = PRI;
					RedPlayerCount++;
				}
			}
			else if( PRI.IsBlueTeam() )
            {
                if ( BluePlayerCount < 8 )
			    {
				    BluePRI[BluePlayerCount] = PRI;
				    BluePlayerCount++;
		    	}
	    	}
  	    }
	}

    super.UpdateScoreBoard(Canvas);
}

simulated function Init()
{
    super.Init();
    RotCoin = spawn(class'RandCoin');
    RotCoin.LinkMesh(mesh(dynamicloadobject("fx_weapon_anims.mesh_Coins",class'mesh')));
    RotCoin.bHidden=true;
}

//�Ŷ�ģʽ���򷽷�
function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
	local KFXPlayerReplicationInfo tp1, tp2;
	tp1 = KFXPlayerReplicationInfo(p1);
	tp2 = KFXPlayerReplicationInfo(p2);
	//�������򣬼������ǰ
	//��Ҫ�������ݵķ���false

	//����۲�ɳ�ΪACE
	if( tp1.bSpectatorView )
    {
        if( tp2.bSpectatorView )
            return true;
        else
            return false;
    }
    else if ( tp2.bSpectatorView )
        return true;


	if(tp1.fxKills < tp2.fxKills)
		return false;
	else if(tp1.fxKills > tp2.fxKills)
		return true;
	if(tp1.fxDeaths > tp2.fxDeaths)
		return false;
	else if(tp1.Deaths < tp2.fxDeaths)
		return true;
//	if(p1.PlayerID > p2.PlayerID)
//		return false;
//	else
		return true;	//kills��deaths��ͬ�ģ�������

}
//��ʱս���ϵ�����
simulated function DrawInstantText(Canvas Canvas)
{
    Canvas.SetDrawColor(255, 255, 255, 255);

    self.KFXDrawTextCsv(Canvas, 2, "heavysmall12");   //�ȼ�
    self.KFXDrawTextCsv(Canvas, 3, "heavysmall12");   //�ǳ�
    self.KFXDrawTextCsv(Canvas, 4, "heavysmall12");   //ս������
    self.KFXDrawTextCsv(Canvas, 6, "heavysmall12");   //����
//    self.KFXDrawTextCsv(Canvas, 6, "heavysmall12");
    self.KFXDrawTextCsv(Canvas, 7, "heavysmall12");   //����
	self.KFXDrawTextCsv(Canvas, 8, "heavysmall12");   //�ӳ�

    //-------------------------------------------------
    // �²�����
    //-------------------------------------------------
    Canvas.SetDrawColor(255, 255, 255, 255);

    self.KFXDrawTextCsv(Canvas, 12, "heavysmall12");
    self.KFXDrawTextCsv(Canvas, 13, "heavysmall12");
    self.KFXDrawTextCsv(Canvas, 14, "heavysmall12");
    self.KFXDrawTextCsv(Canvas, 16, "heavysmall12");
    //self.KFXDrawTextCsv(Canvas, 16, "heavysmall12");
	self.KFXDrawTextCsv(Canvas, 17, "heavysmall12");
	self.KFXDrawTextCsv(Canvas, 18, "heavysmall12");

}
//�Ѵ�����ȡ���������棬������д
simulated function DrawBluePlayerInfo(Canvas Canvas,KFXPlayerReplicationInfo PRI,int NormalEx,int YPosEx,int Height)
{
	KFXDrawBoardTextEx(Canvas, "" $ PRI.PlayerName, 308+NormalEx, YPosEx-(24-Height)/2, Height);			//�ǳ�
    KFXDrawBoardTextEx(Canvas, "" $ PRI.fxBattleTeamName, 309+NormalEx, YPosEx-(24-Height)/2, Height);	//ս��
    KFXDrawBoardTextEx(Canvas, "" $ PRI.fxKills, 310+NormalEx, YPosEx-(24-Height)/2, Height);		//��ɱ
    KFXDrawBoardTextEx(Canvas, "" $ PRI.fxDeaths, 311+NormalEx, YPosEx-(24-Height)/2, Height);			//����
    KFXDrawBoardTextEx(Canvas, "" $ (PRI.Ping*4), 312+NormalEx, YPosEx-(24-Height)/2, Height);			//�ӳ�
}
//�Ѵ�����ȡ���������棬������д
simulated function DrawRedPlayerInfo(Canvas Canvas,KFXPlayerReplicationInfo PRI,int NormalEx,int YPosEx,int Height)
{
    KFXDrawBoardTextEx(Canvas, ""$PRI.PlayerName, 302+NormalEx, YPosEx-(24-Height)/2, Height);		//�ǳ�
    KFXDrawBoardTextEx(Canvas, ""$PRI.fxBattleTeamName, 303+NormalEx, YPosEx-(24-Height)/2, Height);	//ս��
    KFXDrawBoardTextEx(Canvas, ""$PRI.fxKills, 304+NormalEx, YPosEx-(24-Height)/2, Height);	//��ɱ
    KFXDrawBoardTextEx(Canvas, ""$PRI.fxDeaths, 305+NormalEx, YPosEx-(24-Height)/2, Height);			//����
    KFXDrawBoardTextEx(Canvas, ""$(PRI.Ping*4), 306+NormalEx, YPosEx-(24-Height)/2, Height);			//�ӳ�
}
// ����ʱս��
simulated function DrawInstant(Canvas Canvas)
{
    local int i;
    local int YPosEx;
    local int Height;
    local int id1, id2;	//ace��Ϣͳ�ƣ���һ�����ڶ�����id
	local color colorText;
	local bool bfind;
	local string roomid;
	local int NormalEx;
	//local KFXPlayerReplicationInfo tBlue[8], tRed[8];

	super.DrawInstant(Canvas);
    Canvas.SetDrawColor(255, 255, 255, 255);

    //����ʱս����屳��
    self.KFXDrawTileCsv(Canvas, 1, true);

    // ��ʱս��ͳ������
    //Canvas.SetDrawColor(255, 255, 255, 255);
    //self.KFXDrawTextCsv(Canvas, 1, "heavylarge16");

    //-------------------------------------------------
    // �ϲ�����
    //-------------------------------------------------
    DrawInstantText(Canvas);               //��ʱս���ϵ�������ʾ
    Canvas.KFXSetPivot(DP_MiddleMiddle);

    ntemptest++;

	killerID = OwnerPRI.nIDLastKillMe;
	//����ace��
	if(GRI.PRIArray.Length > 0)
	{
		id1 = KFXPlayerReplicationInfo(GRI.PRIArray[0]).fxPlayerDBID;
	}
	if(GRI.PRIArray.Length > 1)
	{
		id2 = KFXPlayerReplicationInfo(GRI.PRIArray[1]).fxPlayerDBID;
	}

	//�����ɱ��Ϊ0ʱ����ô����
	if((BluePlayerCount == 0 || BluePRI[0].fxkills == 0)
			&& (RedPlayerCount == 0 || RedPRI[0].fxkills == 0))
	{
		id1 = -1;
		id2 = -1;
	}

	if(!OwnerPRI.bSpectatorView)
	{
		//ȷ���Լ������棺
		NormalEx = 0;
	    for( i = 0; i < BluePlayerCount; i++)
	    {
			if(BluePRI[i] ==  OwnerPRI)
			{
				NormalEx = 100;
				break;
			}
		}
	}
	else
	{
		NormalEx = 0;	//���������
	}

    //������
    //�����ӱ�ʶ

    KFXDrawXMLBoardTile(Canvas, 313+NormalEx, 0);

	//�����Ӷ����Ա��Ϣ
    YPosEx = 0;
    for( i = 0; i < BluePlayerCount; i++)
    {
    	//��������Ҳ����Լ�����ô����ɫ��
		//����������Ҳ����Լ�����ô�������
		//����Լ��ҷ���������ô���������һ�����
		//����Լ�����������ô������

        if( BluePRI[i] ==  OwnerPRI )
        {
        	//��������ʾ�Լ��ı��
			if(BluePRI[i].bDeadStatus == false)
			{
				KFXDrawXMLBoardTile(Canvas, 304+NormalEx, YPosEx);
			}
			Canvas.KFXSetPivot(DP_MiddleLeft);
			KFXDrawXMLBoardTile(Canvas, 306+NormalEx, YPosEx);
			Height = 35;
        }
        else
        {
	        if( BluePRI[i].bDeadStatus == true )
	        {
	            KFXDrawXMLBoardTile(Canvas, 301+NormalEx, YPosEx);
	        }
	        else
	        {
	        	KFXDrawXMLBoardTile(Canvas, 302+NormalEx, YPosEx);
	        }
	        Height = 24;
		}
        Canvas.KFXSetPivot(DP_MiddleMiddle);
		if(i < 2)
		{
			//ACE��ʾ����
			if(BluePRI[i].fxPlayerDBID == id1)
			{                                           //37��ʾaceͼ��ĸ߶�
				KFXDrawXMLBoardTile(Canvas, 309+NormalEx, YPosEx-(30-Height)/2);
			}
			else if(BluePRI[i].fxPlayerDBID == id2)
			{
				KFXDrawXMLBoardTile(Canvas, 311+NormalEx, YPosEx-(30-Height)/2);
			}
		}
		//������������ֻ�ɫ
        if( BluePRI[i].bDeadStatus == true )
        {
            colorText = Canvas.MakeColor(128, 128, 128, 255);
        }
        else
        {
        	if(BluePRI[i] == OwnerPRI)
        	{
				colorText = class'Canvas'.static.MakeColor(255, 255, 0, 255);
			}
			else
			{
				colorText = class'Canvas'.static.makeColor(255, 255, 255, 255);
			}
        }

        //����ͼ��
        if(!bfind && PlayerController(Owner) != none && killerID == BluePRI[i].fxPlayerDBID
			&& OwnerPRI.Team.TeamIndex != BluePRI[i].Team.TeamIndex)
        {
			KFXDrawXMLBoardTile(Canvas, 318+NormalEx, YPosEx-(24-Height)/2);
			bfind = true;
		}

		// ������ȼ�ͼ��
		Canvas.KFXSetPivot(DP_MiddleMiddle);
        DrawPlayerLevelEx(Canvas, BluePRI[i], 307+NormalEx, YPosEx-(24-Height)/2);

		//��ս��ͼ��
		if(BluePRI[i].fxFactionIcon > 0)
	        DrawPlayerFactionIcon(Canvas, BluePRI[i].fxFactionIcon, 340+NormalEx, YPosEx-(24-Height)/2);

	    Canvas.KFXFontAlias = "heavymedium15";
        Canvas.SetDrawColor(colorText.R, colorText.G, colorText.B, colorText.A);

		Canvas.KFXSetPivot(DP_MiddleMiddle);

        //�����ӻ�ɱ������Ϣ
        DrawBluePlayerInfo(Canvas,BluePRI[i],NormalEx,YPosEx,Height) ;

        //�ƶ����
		if( BluePRI[i] ==  OwnerPRI )
        {
            YPosEx += 35 + 6;
        }
        else
        {
        	YPosEx += 24 + 6;
		}
	}

    // �����
    //����ӱ�ʶ
	KFXDrawXMLBoardTile(Canvas, 314+NormalEx, 0);
	//����ӳ�Ա��Ϣ
    YPosEx = 0;
    for( i = 0; i < RedPlayerCount; i++)
    {
		if(RedPRI[i] == OwnerPRI)
		{
			if(RedPRI[i].bDeadStatus == false)
			{
				KFXDrawXMLBoardTile(Canvas, 305+NormalEx, YPosEx);
			}
			Canvas.KFXSetPivot(DP_MiddleLeft);
    		KFXDrawXMLBoardTile(Canvas, 315+NormalEx, YPosEx);
			Height = 35;
		}
		else
		{
			if(RedPRI[i].bDeadStatus == true)
			{
				KFXDrawXMLBoardTile(Canvas, 316+NormalEx, YPosEx);
			}
			else
			{
				KFXDrawXMLBoardTile(Canvas, 303+NormalEx, YPosEx);
			}
			Height = 24;
		}
		Canvas.KFXSetPivot(DP_MiddleMiddle);
		if(i < 2)
		{
			if(RedPRI[i].fxPlayerDBID == id1)
			{
				KFXDrawXMLBoardTile(Canvas, 310+NormalEx, YPosEx-(30-Height)/2);
			}
			else if(RedPRI[i].fxPlayerDBID == id2)
			{
				KFXDrawXMLBoardTile(Canvas, 312+NormalEx, YPosEx-(30-Height)/2);
			}
		}

        if( RedPRI[i].bDeadStatus == true )
        {
			colorText = Canvas.MakeColor(129, 129, 127, 255);
        }
        else
        {
        	if(RedPRI[i] == OwnerPRI)
        	{
				colorText = Canvas.MakeColor(255, 255, 0, 255);
			}
			else
			{
				 colorText = Canvas.MakeColor(255, 255, 255, 255);
			}
        }

		//����ͼ��
        if(!bfind && PlayerController(Owner) != none && killerID == (RedPRI[i]).fxPlayerDBID
					&& OwnerPRI.Team.TeamIndex != RedPRI[i].Team.TeamIndex)
        {
			KFXDrawXMLBoardTile(Canvas, 317+NormalEx, YPosEx-(24-Height)/2);
			bfind = true;
		}
        // ������ȼ�ͼ��                                 //���Ķ���
        Canvas.KFXSetPivot(DP_MiddleMiddle);
		DrawPlayerLevelEx(Canvas, RedPRI[i], 308+NormalEx, YPosEx-(24-Height)/2);

        //��ս��ͼ��
		if(RedPRI[i].fxFactionIcon > 0)
	        DrawPlayerFactionIcon(Canvas, RedPRI[i].fxFactionIcon, 341+NormalEx, YPosEx-(24-Height)/2);


		Canvas.KFXFontAlias = "heavymedium15";
        Canvas.SetDrawColor(colorText.R, colorText.G, colorText.B, colorText.A);

        //����ӻ�ɱ��������Ϣ
        DrawRedPlayerInfo(Canvas,RedPRI[i],NormalEx,YPosEx,Height);

        //�ƶ����
		if( RedPRI[i] ==  OwnerPRI )
        {
            YPosEx += 35 + 6;
        }
        else
        {
        	YPosEx += 24 + 6;
		}
    }


	//����������ĸ������fpsֵ
	Canvas.KFXSetPivot(DP_MiddleMiddle);
	Canvas.SetDrawColor(255, 255, 255, 255);
	roomid = lCurGameRoom;
	ReplaceText(roomid, "%index", ""$KFXPlayer(Owner).Player.GUIController.PlayerDateInfo.RoomID);
  	KFXDrawBoardTextEx(Canvas, roomid, 324, 0, 0);

  	KFXDrawBoardTextEx(Canvas, "FPS:"$gfps, 325, 0, 0);



    Canvas.KFXSetPivot(DP_UpperLeft);

}


//---------------------- wangkai, ����ս����� -----------------------
//������ս��-������б��ͷ
function _DrawFinalPlayerListHeader(Canvas Canvas, float Y1)
{

    Canvas.SetDrawColor(234, 206, 123, 255);
//    Canvas.KFXFontAlias = "heavymedium15";
//
//    // ����
//    KFXDrawTextCsv(Canvas, 32, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 33, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 34, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 35, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 36, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 37, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 38, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 39, "heavymedium15");
//
//    // ���
//    KFXDrawTextCsv(Canvas, 42, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 43, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 44, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 45, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 46, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 47, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 48, "heavymedium15");
//    KFXDrawTextCsv(Canvas, 49, "heavymedium15");
}

//������ս��-������б��е�һ�� (������)
function _DrawFinalPlayerListLine(Canvas Canvas, KFXPlayerReplicationInfo PRI, float Y1)
{
}

//������ս��-��Draw/Win/Lossͼ
function int CalcFinalWinNLose()
{
    local int WhichWins;
	local int ret;

    WhichWins = WhichTeamWin();
    if (WhichWins == 0)//ƽ
    {
    	ret = 4;
        //KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[4]);
    }
    else if(GetGRI().bBlueWinOnDraw)
    {
        //KFXDrawXMLBoardTile(Canvas, 343,, DrawWinLossMatNames[8]); //Ĭ������Ӯ��ͼƬ
        if ( OwnerPRI.IsRedTeam() )//�����
        {
            //KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[3]);
            ret = 3;
        }
        else
        {
            //KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[0]);
            ret = 0;
        }
    }
    else if(GetGRI().bRandWinner)
    {
    	ret = 7;
        //KFXDrawXMLBoardTile(Canvas, 343,, DrawWinLossMatNames[7]);
//        if(RotCoin.ResultFace == 0)
//        {
//            RotCoin.ResultFace = WhichWins;
//            RotCoin.bHidden = false;
//            RotCoin.LastRotTime = level.TimeSeconds;
//        }
//
//        if(RotCoin.ResultFace != 0)
//        {
//            RotCoin.DrawRotCoin(Canvas);
//        }
    }
    else if (WhichWins == 1  )//����Ӯ
    {
        if ( OwnerPRI.IsRedTeam() )//�����
        {
            //KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[3]);
            ret = 3;
        }
        else
        {
            //KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[0]);
            ret = 0;
        }
    }
    else if (WhichWins == 2)//���Ӯ
    {
        if ( OwnerPRI.IsRedTeam() )//���Ӯ
        {
            //KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[1]);
            ret = 1;
        }
        else//������
        {
            //KFXDrawXMLBoardTile(Canvas, 321, ,DrawWinLossMatNames[2]);
            ret = 2;
        }
    }
    else
    	ret = -1;
    return ret;
}
function _DrawWinLossDraw(Canvas Canvas)
{
    local int WhichWins;

    WhichWins = WhichTeamWin();
    Canvas.KFXSetPivot(DP_MiddleMiddle);
    if (WhichWins == 0)//ƽ
    {
        KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[4]);
    }
    else if(GetGRI().bBlueWinOnDraw)
    {
        //KFXDrawXMLBoardTile(Canvas, 343,, DrawWinLossMatNames[8]); //Ĭ������Ӯ��ͼƬ
        if ( OwnerPRI.IsRedTeam() )//�����
        {
            KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[3]);
        }
        else
        {
            KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[0]);
        }
    }
    else if(GetGRI().bRandWinner)
    {
        KFXDrawXMLBoardTile(Canvas, 343,, DrawWinLossMatNames[7]);
        if(RotCoin.ResultFace == 0)
        {
            RotCoin.ResultFace = WhichWins;
            RotCoin.bHidden = false;
            RotCoin.LastRotTime = level.TimeSeconds;
        }

        if(RotCoin.ResultFace != 0)
        {
            RotCoin.DrawRotCoin(Canvas);
        }
    }
    else if (WhichWins == 1  )//����Ӯ
    {
        if ( OwnerPRI.IsRedTeam() )//�����
        {
            KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[3]);
        }
        else
        {
            KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[0]);
        }
    }
    else if (WhichWins == 2)//���Ӯ
    {
        if ( OwnerPRI.IsRedTeam() )//���Ӯ
        {
            KFXDrawXMLBoardTile(Canvas, 321,, DrawWinLossMatNames[1]);
        }
        else//������
        {
            KFXDrawXMLBoardTile(Canvas, 321, ,DrawWinLossMatNames[2]);
        }
    }
}

//������ս��-������
function DrawFinalBackground(Canvas Canvas)
{
    local KFXHUD nethud;
    nethud= KFXHUD(PlayerController(Owner).myhud);


    //��Draw/Win/Loss
    _DrawWinLossDraw(Canvas);


    Canvas.SetPos(92, 108);

    if(nethud.nRealmType == 5)
    {
        //��ս����Ϣ  ս��ģʽ����ս���õı���ͼ
        Canvas.DrawTile(Material(DynamicLoadObject("fx_ui3_texs.HUD_taxis_faction", class'Material')),
                    847, 570, 0, 0, 847, 570);
    }
    else
    {
        //��Ϊս��ģʽ�˴��벻��
        Canvas.DrawTile(Material(DynamicLoadObject("fx_ui3_texs.HUD_taxis_mix_end", class'Material')),
                    847, 570, 0, 0, 847, 570);
    }
}

//������ս��-����б�
function DrawFinalPlayerList(Canvas Canvas)
{
    local int i;

    //�б��ͷ
    _DrawFinalPlayerListHeader(Canvas, 0);

    //����������
    for (i=0; i<BluePlayerCount; i++)
    {
	    // ���Լ��ĵ�ɫ
		if( BluePRI[i] == OwnerPRI )
		{
	        KFXDrawBoardTile(Canvas, 21, i);
	    }

	    // ս��
		if ( BluePRI[i].bKFXHasFactionBadge
			&& KFXGetFactionBackGround(BluePRI[i]) != ""
			&& KFXGetFactionIcon(BluePRI[i]) != ""
			&& BluePRI[i].fxBattleTeamID > 0 )
		{
	        KFXDrawBoardTile(Canvas, 22, i, KFXGetFactionBackGround(BluePRI[i]));
	        KFXDrawBoardTile(Canvas, 23, i, KFXGetFactionIcon(BluePRI[i]));
	    }

	    if ( BluePRI[i].KFXVIP > 0 )
	    {
	        KFXDrawBoardTile(Canvas, 24, i);
	    }

	    //���ȼ�ͼ��
	    DrawPlayerLevel(Canvas, BluePRI[i], 25,  i);
		KFXDrawBoardText(Canvas, BluePRI[i].PlayerName,21, i);			//�ǳ�
		KFXDrawBoardText(Canvas, BluePRI[i].fxBattleTeamName,22, i);	//ս������
		KFXDrawBoardText(Canvas, "" $ BluePRI[i].fxContribution,23, i);	//���׶�
		KFXDrawBoardText(Canvas, "" $ BluePRI[i].fxKills,24, i);		//����
		KFXDrawBoardText(Canvas, "" $ BluePRI[i].fxDeaths,25, i);		//����
		KFXDrawBoardText(Canvas, "" $ BluePRI[i].fxShowCredit,26, i);	//��������ֵ
		KFXDrawBoardText(Canvas, "+"$ BluePRI[i].fxShowWinExp,27, i);	//�����ʤ����ֵ
    }

    //���������
    for (i=0; i<RedPlayerCount; i++)
    {
    		    // ���Լ��ĵ�ɫ
		if( RedPRI[i] == OwnerPRI )
		{
	        KFXDrawBoardTile(Canvas, 31, i);
	    }

	    // ս��
		if ( RedPRI[i].bKFXHasFactionBadge
			&& KFXGetFactionBackGround(RedPRI[i]) != ""
			&& KFXGetFactionIcon(RedPRI[i]) != ""
			&& RedPRI[i].fxBattleTeamID > 0 )
		{
	        KFXDrawBoardTile(Canvas, 32,i, KFXGetFactionBackGround(RedPRI[i]));
	        KFXDrawBoardTile(Canvas, 33,i, KFXGetFactionIcon(RedPRI[i]));
	    }

	    if ( RedPRI[i].KFXVIP > 0 )
	    {
	        KFXDrawBoardTile(Canvas, 34,i);
	    }

	    //���ȼ�ͼ��
	    DrawPlayerLevel(Canvas, RedPRI[i], 35, i);
		KFXDrawBoardText(Canvas, RedPRI[i].PlayerName, 31, i);			//�ǳ�
		KFXDrawBoardText(Canvas, RedPRI[i].fxBattleTeamName,32, i);		//ս������
		KFXDrawBoardText(Canvas, "" $ RedPRI[i].fxContribution, 33, i);	//���׶�
		KFXDrawBoardText(Canvas, "" $ RedPRI[i].fxKills, 34, i);		//����
		KFXDrawBoardText(Canvas, "" $ RedPRI[i].fxDeaths, 35, i);		//����
		KFXDrawBoardText(Canvas, "" $ RedPRI[i].fxShowCredit, 36, i);	//��������ֵ
		KFXDrawBoardText(Canvas, "+"$ RedPRI[i].fxShowWinExp, 37, i);	//�����ʤ����ֵ
    }
}

//������ս��-ģʽ��Ϣ
function DrawFinalModeInfo(Canvas Canvas)
{
    local int WhichWin;
    super.DrawFinalModeInfo(Canvas);
    //���ĸ���Ӯ��
    WhichWin = WhichTeamWin();
    if (WhichWin == 1)//��
    {
        Canvas.SetDrawColor(7, 95, 239, 255);
    }
    else if (WhichWin == 2)//��
    {
        Canvas.SetDrawColor(253, 31, 26, 255);
    }
    else//ƽ
    {
        Canvas.SetDrawColor(255, 255, 255, 255);
    }

    Canvas.KFXFontAlias = "heavymedium15";
    Canvas.KFXDrawStrJustifiedWithBorder(CONF_WhichWins[WhichWin], 2, 742, 133, 925, 148, ShadeColor, 2);

    //��ģʽ����
    _DrawFinalModeName(Canvas);
}

//������ս��-�ҵĳɼ�
function DrawFinalMyScore(Canvas Canvas)
{
    super.DrawFinalMyScore(Canvas);
}

function int WhichTeamWin()
{
    if( PlayerController(Owner).GameReplicationInfo.Winner == level )
    {
        return 0;//ƽ
    }
    else if( (KFXTeamInfo(PlayerController(Owner).GameReplicationInfo.Winner).TeamIndex == 0 && self.GetGRI().fxChangeTeamCount%2 == 0)
        || (KFXTeamInfo(PlayerController(Owner).GameReplicationInfo.Winner).TeamIndex == 1 && self.GetGRI().fxChangeTeamCount%2 == 1) )
    {
        return 1;//����
    }
    else if( (KFXTeamInfo(PlayerController(Owner).GameReplicationInfo.Winner).TeamIndex == 1 && self.GetGRI().fxChangeTeamCount%2 == 0)
        || (KFXTeamInfo(PlayerController(Owner).GameReplicationInfo.Winner).TeamIndex == 0 && self.GetGRI().fxChangeTeamCount%2 == 1) )
    {
        return 2;//���
    }
    else
    {
        log ("[KFXTeamScoreBorad] Bad team id of winner");
        return 255;
    }
}

//--------------------------------------------------------------------



// С��ս�����
simulated function DrawRound(Canvas Canvas)
{
    super.DrawRound(Canvas);
}

//��ս����Ϣ ����ս���Ҳ�
function KFXDrawBattleInfo(Canvas Canvas)
{
    local string BlueStr, RedStr;

    if((WhichTeamWin() == 1))  // ��:������ƽ��
    {
        BlueStr = ""$BluePRI[0].fxWinSpoint;
        RedStr = ""$BluePRI[0].fxLostSpoint;
    }
    else
    {
        BlueStr = ""$RedPRI[0].fxLostSpoint;
        RedStr = ""$RedPRI[0].fxWinSpoint;
    }

    Canvas.SetDrawColor(255, 255, 255, 255);

    if ( BluePlayerCount > 0 )
    {
        //��ս��ͼ��  ����
		if ( KFXGetFactionBackGround(BluePRI[0]) != ""
			&& KFXGetFactionIcon(BluePRI[0]) != ""
			&& BluePRI[0].fxBattleTeamID > 0 )
		{
            Canvas.SetPos(757, 168);
            Canvas.DrawTile( Material(DynamicLoadObject(KFXGetFactionBackGround(BluePRI[0]), class'Material')),
                20, 20,
                0, 0, 20, 20);

            Canvas.SetPos(757, 168);
            Canvas.DrawTile( Material(DynamicLoadObject(KFXGetFactionIcon(BluePRI[0]), class'Material')),
                20, 20,
                0, 0, 20, 20);
        }

        //��ս������  ����
        Canvas.KFXFontAlias = "heavymedium14";
        Canvas.KFXDrawStrJustifiedWithBorder(""$BluePRI[0].fxBattleTeamName, 1,
            788, 168,
            921, 188,
            ShadeColor, -1
            );
    }
    //��ս�ӷ��� ����
    Canvas.KFXFontAlias = "heavysmall12";
    Canvas.KFXDrawStrJustifiedWithBorder(CONF_TeamAccount, 1,
    813, 231,
    870, 245,
    ShadeColor, -1
    );

    Canvas.Font = LoadFoxFont(3);
    Canvas.DrawTextJustified(BlueStr, 1,
    813, 278,
    867, 301
    );

    if ( RedPlayerCount > 0 )
    {
        //��ս��ͼ��  ���
        if ( KFXGetFactionBackGround(RedPRI[0]) != ""
			&& KFXGetFactionIcon(RedPRI[0]) != ""
			&& RedPRI[0].fxBattleTeamID > 0 )
		{
            Canvas.SetPos(757, 402);
            Canvas.DrawTile( Material(DynamicLoadObject(KFXGetFactionBackGround(RedPRI[0]), class'Material')),
                20, 20,
                0, 0, 20, 20);

            Canvas.SetPos(757, 402);
            Canvas.DrawTile( Material(DynamicLoadObject(KFXGetFactionIcon(RedPRI[0]), class'Material')),
                20, 20,
                0, 0, 20, 20);
        }

        //��ս������  ���
        Canvas.KFXFontAlias = "heavymedium14";
        Canvas.KFXDrawStrJustifiedWithBorder(""$RedPRI[0].fxBattleTeamName, 1,
        788, 403,
        921, 419,
        ShadeColor, -1
        );
    }

    //��ս�ӷ���  ���
    Canvas.KFXFontAlias = "heavysmall12";
    Canvas.KFXDrawStrJustifiedWithBorder(CONF_TeamAccount, 1,
    813, 465,
    870, 479,
    ShadeColor, -1
    );
    Canvas.Font = LoadFoxFont(3);
    Canvas.DrawTextJustified(RedStr, 1,
    813, 512,
    867, 535
    );



}
// ������������
function Font LoadFoxFont(int i)
{
	if( default.fxFontArray[i] == none )
	{
		default.fxFontArray[i] = Font(DynamicLoadObject(default.fxFontNames[i], class'Font'));

		if( default.fxFontArray[i] == none )
		{
			;
		}
	}

	return default.fxFontArray[i];
}

defaultproperties
{
     fxFontNames(0)="fx_AntimonyNumfonts_texs.AntimonyFontBasic"
     fxFontNames(1)="fx_FuturaNumfonts_texs.FuturaNumfontBasic"
     fxFontNames(2)="fx_SwissNumfonts_texs.SwissNumfontBasic"
     fxFontNames(3)="fx_8514_texs.8514Numt"
     fxFontNames(4)="fx_Transistor_texs.TraNumt"
     DrawWinLossMatNames(0)="set:mat2_HUD_result01 image:NewImage1"
     DrawWinLossMatNames(1)="set:mat2_HUD_result01 image:NewImage3"
     DrawWinLossMatNames(2)="set:mat2_HUD_result01 image:NewImage4"
     DrawWinLossMatNames(3)="set:mat2_HUD_result01 image:NewImage5"
     DrawWinLossMatNames(4)="set:mat2_HUD_result01 image:NewImage2"
     DrawWinLossMatNames(5)="set:mat2_HUD_result02 image:NewImage1"
     DrawWinLossMatNames(6)="set:mat2_HUD_result02 image:NewImage2"
     DrawWinLossMatNames(7)="set:mat2_HUD_FactionMatch image:NewImage1"
     DrawWinLossMatNames(8)="set:mat2_HUD_FactionMatch image:NewImage1"
}
