//-----------------------------------------------------------
//  Class:      KFXGame.KFXConsole
//  Creator:    zhangjinpin@kingsoft ÕÅ½ðÆ·
//  Data:       2007-08-06
//  Desc:       ºêº°»°
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXConsole extends ExtendedConsole;

//ÁÄÌìÀàÐÍ
const CT_Team = 0;
const CT_Public = 1;
const CT_Faction = 2;
const CT_Private = 3;
const CT_ALL = 4;

var string KFXConsoleFontAlias;
var bool    bKFXCorpseLimit;
//------------------------------------------------------------------------------
// ºêº°»°Ïà¹Ø¶¨Òå

enum ESpeechMenuState
{
    SM_None,
    SM_ZKey,
    SM_XKey,
    SM_CKey,
};
var int fxSMState;
var int fxSMIndex;
var name fxSMType;

var string LastChatPlayerName;               //Ë½ÁËÊ¹ÓÃµÄÍæ¼ÒÃû×Ö
var string TempPlayerName;           //ÔÝÊ±Ë½ÁËÊ¹ÓÃµÄÍæ¼ÒÃû×Ö
var string chat_content;
var localized string SMT_ChatType[CT_All];
var localized string SMT_Color_ChatType[CT_All];
var localized string SMT_InputTip, SMT_InputTip_Faction;
var float lastdrawtime;

var localized string SMZKeyText[10];
var localized string SMXKeyText[10];
var localized string SMCKeyText[10];
var localized string SMZKeyType;    // Speech type. Added by linsen. 2008-4-24
var localized string SMXKeyType;
var localized string SMCKeyType;

var localized string CancelUse;      //È¡ÏûÌáÊ¾Óï
var localized string SayTimeMsg;     //Ëµ»°Ê±¼ä¼ä¸ô£»
var localized string SaveScreenshots;  //±£´æ½ØÍ¼

///Ã¿´Î½ØÆÁÖ®¼äÐèÒªµÄ×îÐ¡¼ä¸ôÊ±¼ä
var float ScreenShotCDTime;

///½ØÆÁ¼ä¸ôÊ±¼ä¼ÆÊ±Æ÷
var float ScreenShotCDTimeCounter;

///ÊÇ·ñ¿ÉÒÔ½ØÆÁµÄ¿ØÖÆ±äÁ¿
var bool CanScreenShot;

var color ShadeColor;

// ºêº°»°Ïà¹Ø¶¨Òå
//------------------------------------------------------------------------------

// ÁÄÌì¿ª¹Ø
var bool bKFXChatState;
// ÁÄÌìÆµµÀ±ê¼Ç
var int  nChatChannel;  //0 : ¶ÓÎé
                        //1 £»È«Ìå
                        //2 £»Õ½¶Ó
                        //3 £ºË½ÁË
var int HistoryCmdType[16];			//hold the command's type
var int  nLastChatIndex; //ÉÏ´Î»ñÈ¡µÄË½ÁÄÍæ¼ÒµÄÔÚË½ÁÄÍæ¼ÒÁÐ±íÖÐµÄ±àºÅ
var float  nLastSayTime;   //ÉÏ´ÎËµ»°µÄÊ±¼ä


var  int UseAimIndex;             //µÀ¾ßÊ¹ÓÃ¶ÔÏóÈº:  1 : ÓÑ·½ , 2 : µÐ·½
var  Array<string> PlayerNames;   //µÀ¾ßÊ¹ÓÃ¶ÔÏóÃû£º
var  Array<PlayerReplicationInfo>   PlayerReplicationInfos;   //µÀ¾ßÊ¹ÓÃ¶ÔÏóÈºPawns£º

var  bool bChating;               //ÕýÔÚÍ¨ÐÅ
var  float ChatTime;              //Í¨ÐÅÊ±¼ä

//¾Ù±¨ÈËµÄÐÅÏ¢
struct SuspectInfo
{
	var int idx;
	var string role_name;
	var int role_id;
};
var array<SuspectInfo>	suspect_roles;
var localized string SMT_Cancel;	//È¡Ïû
var KFXPlayer		curr_player;
var int				curr_player_idx;
var localized string SMT_NoFaction;	//ÌáÊ¾Íæ¼ÒÃ»ÓÐÕ½¶Ó
var localized string SMT_ErrorCmdTip;
// ÖÃ¿Õ
exec function Talk() {}
exec function TeamTalk() {}

exec function ClearTalkState()
{
     nChatChannel = 0;
}
// ´ò¿ªÁÄÌìÆµµÀ
exec function KFXTalk()
{

    ;
	// µ¥»úÄ£Ê½²»ÄÜÁÄÌì
//    if( self.curr_player.Level.NetMode == NM_Standalone )
//    {
//        return;
//    }
    curr_player = GetController();
    if ( curr_player == none || !curr_player.bKFXKeyOfChat )
    {
        return;
    }

    ConsoleCommand("ENABLEIME");
    //nChatChannel = 0;
    bKFXChatState = true;

	KFXUpdateTyping();

    TypingOpen();
}

function string RemoveBlankSpace(string str, int dir)
{
	//×ó²à
	if((dir&0x01) == 0x01)
	{
		while(Len(str) > 0)
		{
			if(Left(str, 1) != " ")
			{
				break;
			}
			str = Right(str, Len(str)-1);
		}
	}
	if((dir&0x02) == 0x02)
	{
		while(Len(str) > 0)
		{
			if(Right(str, 1) != " ")
			{
				break;
			}
			str = Left(str, Len(str)-1);
		}
	}
	return str;
}

// ÊÇ·ñÊÇÕ½¶Ó³ÉÔ±
function bool KFXIsFactionMember()
{
    return GUIController(ViewportOwner.GUIController).IsFactionMember();
}
//µ±Ç°ÊÇ·ñÊÇÕ½¶ÓÈü
function bool KFXIsFactionGame()
{
	return GUIController(viewportowner.GUIController).IsFactionGame();
}
function string GetLastPrivateChatName()
{
	return GUIController(ViewportOwner.GUIController).GetLastPersonnalChatName();
}
function TipMessage(String msg)
{
	KFXHUD(curr_player.myHUD).ChatMessageOutGame("",msg,31,0, 0);
}
exec function TipErrorCmdMsg()
{
	local string str;
	str = GUIController(viewportowner.GUIController).ReformatString(SMT_ErrorCmdTip, "|", 10);
	//log("[LABOR]---------------console cmd is invalid:"$str);
	TipMessage(str);

}

//ÁÄÌìÇÐ»»¹æÔò
function KFXDoSwitchChannel()
{
	switch(nChatChannel)
	{
		case CT_Public:
			nChatChannel = CT_Team;
			break;
		case CT_Team:
			nChatChannel = CT_Faction;
			break;
		case CT_Faction:
			nChatChannel = CT_Private;
			break;
		case CT_Private:
			nChatChannel = CT_Public;
			break;
	}
}

// ÇÐ»»¶ÓÁÄºÍ¹«ÁÄ
function KFXChangeChannel()
{
	local int cnt;
	local int tmp_channel;
	local bool bfind;

	tmp_channel = nChatChannel;
    if( bKFXChatState )
    {
    	while(cnt < CT_All)
    	{
    		cnt++;
	        //nChatChannel = (nChatChannel + 1) % CT_ALL;
            KFXDoSwitchChannel();

	        if(nChatChannel == CT_Faction && !KFXIsFactionMember())
	        {
	        	//Èç¹û²»ÊÇÕ½¶Ó³ÉÔ±£¬ÄÇÃ´ÌáÊ¾Íæ¼Ò
				//TipMessage(SMT_NoFaction);
	            continue;
			}
			else if(nChatChannel == CT_Public && KFXIsFactionGame())
			{
				continue;
			}
			else if(nChatChannel == CT_Private)
			{
				if(LastChatPlayerName == "")
					 LastChatPlayerName = GetLastPrivateChatName();
				if(LastChatPlayerName == "")
					continue;

			}

//			{
				//·ûºÏÌõ¼þ£¬ÄÇÃ´ÖÕÖ¹²éÕÒchannel
				bfind = true;
				break;
//			}
		}
		if(!bfind)
		{
			nChatChannel = tmp_channel;
			return;
		}
    }
}

simulated event Tick( float Delta )
{
    super.Tick(Delta);
    if(nLastSayTime > 0)
      nLastSayTime = nLastSayTime - Delta;

    if (nLastSayTime > 3)
    {
    	nLastSayTime = 3;
    }

    if(bChating)
    {
        ChatTime+=Delta;
        if(ChatTime>2)
        {
            ChatTime=0;
            bChating=false;
        }
    }

    if( !CanScreenShot )
    {
        ScreenShotCDTimeCounter -= Delta;

        if( ScreenShotCDTimeCounter < 0.0 )
        {
            CanScreenShot = true;
        }
    }
}
//¼ì²é×Ö·û´®ÊÇ·ñÊÇºº×Ö
function bool CheckIsNum(string str)
{
	local int i, l;
	local string ch;
	l = Len(str);
	for(i=0; i<l; i++)
	{
		ch = Mid(str, i, 1);
		if(ch>="0" && ch<="9")
		{
			;
		}
		else
		{
			return false;
		}
	}

	return (Len(str)>0);
}
function DoClean()
{
	DoCheckChatContent(Len(TypedStr));
}
function DoCheckChatContent(int idx)
{

	TypedStr = Mid(TypedStr, idx);
	TypedStrPos = Len(TypedStr);
	log("[LABOR]------------kfxcommand, TypedStr="$TypedStr@TypedStrPos);
}
function bool KFXBlankspaceCommand(string cmd)
{
	local string tmp;
	//local string prefix;
    local Array<string> Content;

	cmd = RemoveBlankSpace(cmd, 0x01|0x02);

    Split(cmd, " ", Content);


	tmp = cmd;
	if(Content.length > 0)
	 	cmd = Content[0];

	if(cmd ~= "/r")
	{
		//×ª»¯³É»Ø¸´
       LastChatPlayerName = GetLastPrivateChatName();
       if(LastChatPlayerName != "")
       {
           nChatChannel = CT_Private;
			DoClean();
	   }
	}
	else if(cmd ~= "/t")
	{
		//×ª»¯³ÉÕ½¶ÓÆµµÀ
    	if (KFXIsFactionMember())
        {
			nChatChannel = CT_Faction;
	        DoClean();
        }
        else
        {
			//TipMessage(SMT_NoFaction);
		}
	}
	else if(cmd ~= "/w")
	{
		if(Content.Length > 1)
		{
			LastChatPlayerName = Content[1];
			nChatChannel = CT_Private;
			DoClean();
		}
	}
//	else if(Left(cmd, 1) == "/")
//	{
//		DoClean();
//		TipErrorCmdMsg();
//	}
//	else
//	{
//		return false;
//	}
	return true;
}
function bool KFXCommand(string com)
{

    local string prefix;
    local Array<string> Content;
    local int num;


	//Çå³ý¿Õ¸ñ
	com = RemoveBlankSpace(com, 0x01|0x02);

    Split(com, " ", Content);
//    if(nChatChannel == CT_Private)
//    {
//       prefix = Locs(Content[2]);
//    }
//    else
//    {
//       prefix = Locs(Content[1]);
//    }

	if(Content.length > 0)
	 	prefix = Content[0];
	log("[LABOR]---------kfxcommand, TypedStr="$com@Content[0]);

//    if(prefix ~= "/1")      // È«Ìå
//    {
//        // Èç¹ûÊÇÕ½¶ÓÈü£¬Ìø¹ýÈ«ÌåÁÄÌì
//        if(KFXIsFactionGame())
//        {
//        	//´íÎóÌáÊ¾
//        	//Çå¿ÕÁÄÌìÄÚÈÝ
//            DoClean();
//        }
//        else
//        {
//    	    nChatChannel = CT_Public;
//
//    	    DoCheckChatContent(InStr(TypedStr, prefix)+Len(prefix));
//		}
//    }
//    else if(prefix ~= "/2")      // ¶ÓÎé
//    {
//       nChatChannel = CT_Team;
//  	    DoCheckChatContent(InStr(TypedStr, prefix)+Len(prefix));
//    }
//    else
	if(prefix ~= "/t")      // Õ½¶Ó
    {
       // ²»ÊÇÕ½¶Ó³ÉÔ±£¬Ö±½ÓÌø¹ýÕ½¶Ó
    	if (!KFXIsFactionMember())
        {
            ;
            //´íÎóÌáÊ¾
            //Çå¿ÕÄÚÈÝ
            //DoClean();
        }
        else
        {
	        nChatChannel = CT_Faction;
            DoCheckChatContent(InStr(TypedStr, prefix)+Len(prefix));
		}
    }
    else if(prefix ~= "/w")      // Ë½ÁÄ
    {
		if(Content.Length > 1)
		{
			LastChatPlayerName = Content[1];
           	nChatChannel = CT_Private;
		}
       //Èç¹ûÓÐÄÚÈÝ£¬ÄÇÃ´Ö±½ÓÒª·¢ËÍÄÚÈÝ
		if(Content.Length > 2)
		{
			DoCheckChatContent(InStr(TypedStr, Content[1])+Len(Content[1]));
		}
		else
		{
			DoClean();
		}
  	}
    else if(prefix == "/r")
    {

       	//Èç¹ûÃ»ÓÐÄÚÈÝ£¬ÄÇÃ´ÏÂ´ÎÄ¬ÈÏ¸Ä³ÉË½ÁÄ
       LastChatPlayerName = GetLastPrivateChatName();

       if(LastChatPlayerName != "")
       {
	       	nChatChannel = CT_Private;
	   }
	   if(content.Length>1)
	   {
			//Èç¹ûÓÐÄÚÈÝ£¬ÄÇÃ´Ö±½Ó·¢ËÍ£¬²¢ÇÒ£¬ÏÂ´Î¸Ä³ÉË½ÁÄ
			DoCheckChatContent(InStr(TypedStr, prefix)+Len(prefix));
	   }
	   else
	   {
	   		DoClean();
	   }
    }
    else if(prefix == "/?")	//²é¿´°ïÖú
    {
    	log("[LABOR]-------------/?");
    	DoClean();
    	TipErrorCmdMsg();
	}
	else if(prefix == "/m")
	{
		//Êó±êÁéÃô¶È
		//curr_player.SetSensitivity(curr_player.PlayerInput.MouseSensitivity);
    	if(CheckIsNum(Content[1]))
		{
        	num = int(Content[1]);
        	if(num > 0 && num <= 100)
        	{
				curr_player.SetSensitivity(num/100.0);
			}
			else
			{
				TipErrorCmdMsg();
			}
		}
		else
		{
			TipErrorCmdMsg();
		}
		DoClean();
		log("[LABOR]-------------/m"$(num/100.0));
	}
	else if(prefix == "/br")
	{
		//ÁÁ¶È
		//ConsoleCommand("BRIGHTNESS "$0.8);
		num = int(Content[1]);
		if(CheckIsNum(Content[1]) && num>0 && num<=100)
		{
			ConsoleCommand("BRIGHTNESS "$(num/100.0));
		}
		else
		{
			TipErrorCmdMsg();
		}
		DoClean();
		log("[LABOR]-------------/br"$(num/100.0));
	}
	else if(prefix == "/s")
	{
		//ÒôÁ¿
		//ConsoleCommand("Set ini:ALAudio.ALAudioSubsystem AllVolume "$1.0);
		num = int(Content[1]);
		if(CheckIsNum(Content[1]) && num>0 && num<=100)
		{
			ConsoleCommand("set ini:Engine.Engine.AudioDevice AllVolume "$(num/100.0));
		}
		else
		{
			TipErrorCmdMsg();
		}
		DoClean();
		log("[LABOR]-------------/s"$(num/100.0));
	}
//	else if(Left(prefix, 1) == "/")
//	{
//		TipErrorCmdMsg();
//		DoClean();
//	}
	return true;
}

// ¸üÐÂtypeÄÚÈÝ
function KFXUpdateTyping()
{
	//¼ì²éË½ÁÄ¶ÔÏó£¬Èç¹ûÃ»ÓÐ£¬ÄÇÃ´ÇÐ»»µ½¶ÓÎéÁÄÌì
    if(nChatChannel == CT_Private)
    {
    	if(LastChatPlayerName == "")
	        LastChatPlayerName = GetLastPrivateChatName();
    	if(LastChatPlayerName == "")
    		nChatChannel = CT_Team;
    }
}

exec function MacroChat(string nType)
{
//   local string Key;
//   local string Type;
//   local string Content;
//   local string ChatType;
//   local bool   nReturn;
//   Key = "Key"$nType;
//   Type = "Type"$nType;
//   nReturn = class'KFXTools'.static.KFXIniGetString(Content,"userinfo.conf", "chatmacro", Key);
//   if((!nReturn)||Content=="")
//       return;
//   nReturn = class'KFXTools'.static.KFXIniGetString(ChatType,"userinfo.conf", "chatmacro", Type);
//   if((!nReturn)||Content=="")
//       return;
//   if(ChatType == "1")
//   {
//      TypedStr = "TeamSay "$Content;
//   }
//   else if(ChatType == "0")
//   {
//      TypedStr = "Say "$Content;
//   }
//   else
//   {
//       TypedStr = "";
//       return;
//   }
//   //GUICOntroller(ViewportOwner.GUIController).CheckInputIngame(TypedStr);
//   if( !ConsoleCommand( TypedStr ) )
//   {
//        Message( Localize("Errors","Exec","Core"), 6.0 );
//   }
//   TypedStr = "";
}

// ¹Ø±ÕÁÄÌì×´Ì¬
function TypingClose()
{
    super.TypingClose();

    bKFXChatState = false;
    ConsoleCommand("DISABLEIME");
}

function PersonnalChat( string PlayerName, string ChatContent )
{
	log("[LABOR]-----------personal chat, playername="$PlayerName@"content="$ChatContent);
	KFXHUD(curr_player.myHUD).ChatMessageOutGame(PlayerName, ChatContent, 30, 0, 0);
	GUIController(ViewportOwner.GUIController).PersonnalChatInGame(PlayerName, ChatContent);
}

function PublicChatInGame(int nChatType, string ChatContent)
{
	log("[LABOR]-----------public chat, chatType="$nChatType@"content="$ChatContent);
    GUIController(ViewportOwner.GUIController).RealmPublicChatInGame(nChatType, ChatContent);
}

function GroupChat( string ChatContent )
{
	log("[LABOR]-----------group Chat:"$ChatContent);
    GUIController(ViewportOwner.GUIController).GroupChatInGame(ChatContent);
}


//function  GetNextChatPlayerName(out int Index)
//{
//   //TempPlayerName = GUICOntroller(ViewportOwner.GUIController).GetNextName(Index);
//   if(TempPlayerName != "")
//    {
//      KFXUpdateTyping();
//    }
//}

state Typing
{
    function BeginState()
	{
		//Èç¹ûÔÚÕ½¶Ó±ÈÈüÖÐ£¬nchannelÎªÈ«Ìå£¬ÄÇÃ´×ª»¯ÏÂ¡£

			//È«Ìå»òÕßÕ½¶Ó
		if(KFXIsFactionGame() && nChatChannel == CT_Public)
		{
   			nChatChannel = CT_Team;
			KFXUpdateTyping();
		}
		else if(!KFXIsFactionMember() && nChatChannel == CT_Faction)
		{
			nChatChannel = CT_Team;
			KFXUpdateTyping();
		}

        bVisible = true;
	}

    function EndState()
    {
        bVisible = false;
    }
	event NotifyLevelChange()
	{
		Global.NotifyLevelChange();
		GotoState('');
	}

	//»æÖÆ
	function PostRender(Canvas canvas)
	{
    	//¸ù¾ÝplayerÌá¹©µÄÎ»ÖÃ
    	local float xpos;
    	local float ypos;
    	local EDrawPivot pv;
    	local float xl, yl;
    	local string prefix;
    	local int col;

		KFXHUD(curr_player.myHUD).GetTypeGameChatPos(canvas, ypos, pv);

        xpos = 8;
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.KFXSetPivot(pv);
		Canvas.KFXFontAlias="heavymedium14";

		//»æÖÆµ×Í¼
		Canvas.SetPos(xpos-4, ypos-6);
		Canvas.KFXDrawXMLTile("mat2_HUD_interface", "NewImage99", true, 278, 50);
		Canvas.SetPos(xpos, ypos+25);
		if(KFXIsFactionGame())
			Canvas.KFXDrawStr(SMT_InputTip_Faction);
		else
			Canvas.KFXDrawStr(SMT_InputTip);

		Canvas.SetPos(xpos, ypos);
		//»æÖÆÁÄÌìÀàÐÍ
		if(nChatChannel == CT_Private)
		{
			//»æÖÆÁÄÌì¶ÔÏó
			prefix = "["$LastChatPlayerName$"]"$SMT_ChatType[nChatChannel];
		}
		else if(nChatChannel < CT_All)
		{
			prefix = SMT_ChatType[nChatChannel];
		}
		else
		{
			log("#### WARNING #### can't find chat type in console");
			return;
		}
		//ÉèÖÃ±êÇ©µÄÑÕÉ«
		col = int(SMT_Color_ChatType[nChatChannel]);
		col = col & 0x00FFFFFF;
		Canvas.SetDrawColor(col>>16, col>>8, col);
		Canvas.KFXDrawStr(prefix);
		Canvas.KFXStrLen(prefix, xl, yl);

        //ÉèÖÃÁÄÌìÄÚÈÝµÄÑÕÉ«
	 	//»æÖÆÊäÈëµÄÄÚÈÝ
	 	Canvas.SetDrawColor(255, 255, 255);
	 	xpos += xl;
	 	Canvas.SetPos(xpos, ypos);
		Canvas.KFXDrawStr(TypedStr);

		//»æÖÆ¹â±ê£¬ÉÁ¶¯Ð§¹û
		Canvas.bForceAlpha = true;
		if(curr_player.Level.TimeSeconds-lastdrawtime < 0.5)
		{
			Canvas.ForcedAlpha = 0.1f;
		}
		else if(curr_player.Level.TimeSeconds - lastdrawtime < 1.0)
		{
			Canvas.ForcedAlpha = 1.0f;
		}
		else
		{
			lastdrawtime = curr_player.Level.TimeSeconds;
		}
		xl = 0;
		yl = 0;
		Canvas.KFXStrLen(Left(TypedStr, TypedStrPos), xl, yl);
		xpos += xl;
		Canvas.SetPos(xpos, ypos);
		Canvas.KFXDrawStr("_");
		Canvas.bForceAlpha = false;

		//ÉèÖÃimeËùÔÚµÄÎ»ÖÃ
		TypedStrDrawX = xpos;
		TypedStrDrawY = ypos;
	}


	//ÏÞÖÆ×Ö·û´®³¤¶È
    function bool KeyType( EInputKey Key, optional string Unicode )
	{
		if (bIgnoreKeys)
			return true;

		//ºöÂÔ¡°< &¡±
		if(Key == 60 || Key == 38)
			return true;
		if( Key>=0x20 )
		{
            if(len(TypedStr) >= 50)
               return( true );
			if( Unicode != "" )
				TypedStr = Left(TypedStr, TypedStrPos) $ Unicode $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
			else
				TypedStr = Left(TypedStr, TypedStrPos) $ Chr(Key) $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
			TypedStrPos++;

            return( true );
		}

		return false;
	}
    // ×÷ÁËÒ»Ð©ÐÞ¸Ä
    function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		//local string Temp;
	    //local Array<string> Content;
	    //local string sContent;
		//local string tmpstr;
		local int cnt;

		if (Action== IST_PRess)
		{
			bIgnoreKeys=false;
		}

		if( Key==IK_Escape )
		{
			if( TypedStr!="" )
			{
				TypedStr="";
				TypedStrPos=0;
				HistoryCur = HistoryTop;
                return true;
			}
			else
			{
                TypingClose();
                return true;
			}
		}
		else if( Action != IST_Press )
		{
            return false;
		}
		else if( key == IK_Space)
		{
			KFXBlankspaceCommand(TypedStr);
			return true;
		}
		else if( Key==IK_Enter )
		{
			if( bKFXChatState )
			{
//			    if((( nChatChannel ==0 )&& (TypedStrPos <= 8 ))
//			        ||((nChatChannel == 1) && (TypedStrPos <= 4 ))
//			        ||((nChatChannel == 2) && (TypedStrPos <=10 ))
//			        ||((nChatChannel == 3) && (TypedStrPos <= len(LastChatPlayerName)+ 15 )))
				//Èç¹ûÊäÈëµÄÄÚÈÝÎª¿Õ£¬ÄÇÃ´¹Ø±Õ¿ØÖÆÌ¨
				//if(TypedStr == "")
//                {
//                    TypingClose();
//                    return true;
//                }
            }
            if(TypedStr != "")
            {
                KFXCommand(TypedStr);
			}
            if( TypedStr!="" )
			{
                //GUICOntroller(ViewportOwner.GUIController).CheckInputIngame(TypedStr);
			    //if(KFXCommand(TypedStr))
                //  return  true;

				//Èç¹ûµ±Ç°Óï¾äºÍÉÏÒ»ÌõÒ»Ñù£¬ÄÇÃ´ÆÁ±Î
				log("[LABOR]-----------cmp says:'"$History[HistoryTop-1]$"'"
						@"'"$RemoveBlankSpace(TypedStr, 0x01|0x02)$"'");
				if(History[HistoryTop-1] == RemoveBlankSpace(TypedStr, 0x01|0x02))
				{
	                if(nLastSayTime > 0)
	                {
	                   TipMessage(SayTimeMsg);
	                   return true;
	                }
				}

                nLastSayTime = 3;

				//´æÎª¼ÇÂ¼
				History[HistoryTop] = RemoveBlankSpace(TypedStr, 0x01|0x02);
				HistoryCmdType[HistoryTop] = nChatChannel;
                HistoryTop = (HistoryTop+1) % ArrayCount(History);

				if ( ( HistoryBot == -1) || ( HistoryBot == HistoryTop ) )
				{
                    HistoryBot = (HistoryBot+1) % ArrayCount(History);
                }

				HistoryCur = HistoryTop;

				// Make a local copy of the string.
				//Temp=TypedStr;
				//TypedStr="";
				//TypedStrPos=0;

                //Split(Temp, " ", Content);
                log("[LABOR]--------kfxconsole do enter, channel="$nChatChannel
							@"TypedStr="$TypedStr);
				if(nChatChannel == CT_Private)
                {
                     log("KFXConsole-----curr_player.bIsChatWithPersonal "$curr_player.bIsChatWithPersonal);
//                     if(!curr_player.bIsChatWithPersonal)
//                        return false;

                     PersonnalChat(LastChatPlayerName, TypedStr);
                }
                else if (nChatChannel == CT_Faction)     // Õ½¶ÓÁÄÌì
                {
                     log("KFXConsole-----curr_player.bIsChatWithFaction "$curr_player.bIsChatWithFaction);
//                     if(!curr_player.bIsChatWithFaction)
//                        return false;

                     GroupChat(typedStr);
                }
                else if(nChatChannel == CT_Public)
                {

                    log("KFXConsole-----curr_player.bIsChatWithAll "$curr_player.bIsChatWithAll);
//                    if(!curr_player.bIsChatWithAll)
//                        return false;

                    PublicChatInGame(1, typedStr);
                }
                else if(nChatChannel == CT_Team)
                {
                    log("KFXConsole-----curr_player.bIsChatWithTeam "$curr_player.bIsChatWithTeam);
//                    if(!curr_player.bIsChatWithTeam)
//                        return false;

                    PublicChatInGame(8, typedStr);
                }
//				if( !ConsoleCommand( Temp ) )
//				{
//					Message( Localize("Errors","Exec","Core"), 6.0 );
//				}

				Message( "", 6.0 );
			}
			TypedStr = "";
			TypedStrPos = 0;

            TypingClose();

            return true;
		}
		else if( Key==IK_Up )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryBot)
				{
					HistoryCur = HistoryTop;
				}
				else
				{
					HistoryCur--;
					if (HistoryCur<0)
					{
                        HistoryCur = ArrayCount(History)-1;
                    }
				}

				TypedStr = History[HistoryCur];
				TypedStrPos = Len(TypedStr);
				nChatChannel = HistoryCmdType[HistoryCur];
			}
            return true;
		}
		else if( Key==IK_Down )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryTop)
				{
					HistoryCur = HistoryBot;
				}
				else
				{
                    HistoryCur = (HistoryCur+1) % ArrayCount(History);
                }

				TypedStr = History[HistoryCur];
				TypedStrPos = Len(TypedStr);
				nChatChannel = HistoryCmdType[HistoryCur];
			}

		}
		else if( Key==IK_Backspace )
		{
            if( TypedStrPos > 0 )
			{
                TypedStr = Left(TypedStr,TypedStrPos-1)$Right(TypedStr, Len(TypedStr) - TypedStrPos);
				TypedStrPos--;
			}
            return true;
		}
		else if ( Key==IK_Delete )
		{
			if ( TypedStrPos < Len(TypedStr) )
			{
				TypedStr = Left(TypedStr,TypedStrPos)$Right(TypedStr, Len(TypedStr) - TypedStrPos - 1);
			}
			return true;
		}
		else if ( Key==IK_Left )
		{
            TypedStrPos = Max(0, TypedStrPos - 1);
            log("[LABOR]-----------typed str="$TypedStr@TypedStrPos@Left(TypedStr, TypedStrPos));
			return true;
		}
		else if ( Key==IK_Right )
		{
			TypedStrPos = Min(Len(TypedStr), TypedStrPos + 1);
            log("[LABOR]-----------typed str="$TypedStr@TypedStrPos@Left(TypedStr, TypedStrPos));
			return true;
		}
		else if ( Key==IK_Home )
		{
			TypedStrPos = 0;
			return true;
		}
		else if ( Key==IK_End )
		{
			TypedStrPos = Len(TypedStr);
			return true;
		}
		// add by zjpwxh@kingsoft ÇÐ»»ÆµµÀ
        else if ( Key == IK_Tab )
        {
        	//¼ÇÂ¼ÆµµÀÇÐ»»Ö®Ç°ËùÊäÈëµÄ»°
            KFXChangeChannel();
        }
//        else if(Key == IK_Ctrl)
//        {
//        	//°´ctrlÇÐ»»ÁÄÌì¶ÔÏó
//        	if(curr_player.GameReplicationInfo.PRIArray.Length > 1)
//        	{
//        		do
//        		{
//					cnt++;
//		        	curr_player_idx++;
//		        	curr_player_idx = curr_player_idx%curr_player.GameReplicationInfo.PRIArray.Length;
//					if(curr_player.GameReplicationInfo.PRIArray[curr_player_idx].PlayerName
//							== curr_player.PlayerReplicationInfo.PlayerName)
//					{
//						;
//					}
//					else
//					{
//						nChatChannel = CT_Private;
//						LastChatPlayerName = curr_player.GameReplicationInfo.PRIArray[curr_player_idx].PlayerName;
//						KFXUpdateTyping();
//						TypedStr = "";
//						TypedStrPos = Len(TypedStr);
//						break;
//					}
//				}
//				until(cnt<16);
//				cnt = 0;
//			}
//		}
		else if(Key == IK_F3)
		{
			//¶ÓÎé
			nChatChannel = CT_Team;
			KFXUpdateTyping();

		}
		else if(key == IK_F2)
		{
			//È«Ìå»òÕßÕ½¶Ó
			if(!KFXIsFactionGame())
			{
       			nChatChannel = CT_Public;
				KFXUpdateTyping();
			}
			else if(KFXIsFactionMember())
			{
				nChatChannel = CT_Faction;
				KFXUpdateTyping();
			}
		}
        return( true );
	}
}

//------------------------------------------------------------------------------
// ºêº°»°Ïà¹Ø¹¦ÄÜ

function KFXPlayer GetController()
{
    if( ViewportOwner == none || ViewportOwner.Actor == none )
    {
        return none;
    }
    else
    {
        return KFXPlayer(ViewportOwner.Actor);
    }
}

function KFXPlayerReplicationInfo GetPRI()
{
    if( curr_player != none )
    {
        return KFXPlayerReplicationInfo(GetController().PlayerReplicationInfo);
    }
    else
    {
        return none;
    }
}

// ´ò¿ªºêº°»°²Ëµ¥
exec function SpeechMenuToggle(string Type)
{
    // µ¥»úÄ£Ê½²»ÄÜº°»°
    curr_player = GetController();

//    if( self.curr_player.Level.NetMode == NM_Standalone )
//    {
//        return;
//    }

    if(!curr_player.CanSpeech())
    {
        return;
    }
    if ( bKFXCorpseLimit == true )
    {
        return;
    }

    if( Type ~= "ZKey" )
    {
        fxSMState = ESpeechMenuState.SM_ZKey;
    }
    else if( Type ~= "XKey" )
    {
        fxSMState = ESpeechMenuState.SM_XKey;
    }
    else if( Type ~= "CKey" )
    {
        fxSMState = ESpeechMenuState.SM_CKey;
    }
    else
    {
        return;
    }

	// Èç¹ûÃ»ÓÐÓïÒô°ü»òÊÇ¹Û²ìÕÛÔò²»´ò¿ª
    if( GetPRI().bOnlySpectator || GetPRI().VoiceType == none )
    {
        return;
	}
    GotoState('SpeechMenuVisible');
}

// ºêº°»°×´Ì¬
state SpeechMenuVisible
{
	// Àë¿ª×´Ì¬
    exec function SpeechMenuToggle(string Type)
	{
		GotoState('');
	}

	function bool KeyType( EInputKey Key, optional string Unicode )
	{
		if (bIgnoreKeys)
		{
			return true;
		}

		return false;
	}

    // µÃµ½ÓïÒô°ü
	function class<VoicePack> GetVoiceClass()
	{
		if( curr_player == none || GetPRI() == none )
		{
            return None;
        }

		return GetPRI().VoiceType;
	}

    // ´¦ÀíÊäÈë
	function HandleInput(int nKey)
	{
		// È¡Ïû¼ü
        if( nKey == 0 )
		{
            CloseSpeechMenu();
			return;
		}

        // ÉèÖÃÀàÐÍ
        switch( ESpeechMenuState(fxSMState) )
        {
            case SM_ZKey:
                fxSMType = 'Z_Speech';
                break;

            case SM_XKey:
                fxSMType = 'X_Speech';
                break;

            case SM_CKey:
                fxSMType = 'C_Speech';
                break;
        }

        // Í¨¹ýÀàÐÍºÍ±àºÅÕÒÉùÒô
        fxSMIndex = GetVoiceIndex(fxSMState, nKey);

        // º°»°
		curr_player.Speech(fxSMType, fxSMIndex, "");

		CloseSpeechMenu();
	}

    // µÃµ½ÉùÒô±àºÅ
    function int GetVoiceIndex(int nState, int nKey)
    {
        return nKey;
    }

	// ¼üÎ»×ª»»ÎªÊý×Ö
    function int KeyToNumber(EInputKey InKey)
	{
		local int i;

		for( i = 0; i < 10; i++ )
		{
			if( bSpeechMenuUseLetters )
			{
				if( InKey == LetterKeys[i] )
				{
					return i;
				}
			}
			else
			{
				if( InKey == NumberKeys[i] )
				{
					return i;
				}
			}
		}

		return -1;
	}

    // À¹½ØÊäÈë
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local int input;

        // ÊÇ·ñÀ¹½Ø¿ØÖÆÌ¨ÊäÈë?

		if( Action != IST_Press )
		{
			return false;
		}

        // ×ª»»ÊäÈë
		input = KeyToNumber(Key);

		if( input != -1 )
		{
			HandleInput(input);
			return true;
		}

		return false;
	}

    function PostRender( canvas Canvas )
	{
        local int i;
        local string s;

        //Canvas.SetDrawColor(153, 216, 253, 255);
        Canvas.SetDrawColor(236, 239, 154, 255);
        // ÔÝÊ±Ð´ËÀ
        switch( ESpeechMenuState(fxSMState) )
        {
            case SM_ZKey:
               // Add speech type
               // Modified by linsen 2008-4-24
               s = SMZKeyType;
               //Canvas.SetPos( 26 * Canvas.SizeX / 1024, 268 * Canvas.SizeY / 768 );
               Canvas.SetPos( 26, Canvas.SizeY - 500 );

               Canvas.KFXFontAlias = "heavytiny11";
               Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
               for( i = 1; i <= 10; i++ )
                {
                    if(i == 10)
                    {
                        s = ""$0$" - "$SMZKeyText[0];
                    }
                    else
                    {
                        s = ""$i$" - "$SMZKeyText[i];
                    }
                    //Canvas.SetPos( 26 * Canvas.SizeX / 1024, (268+i*20) * Canvas.SizeY / 768 );
                    Canvas.SetPos( 26, Canvas.SizeY - 500 + i*20);
                    Canvas.KFXFontAlias = KFXConsoleFontAlias;
                    Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
                }
                break;

            case SM_XKey:
                s = SMXKeyType;
                Canvas.SetPos( 26, Canvas.SizeY - 500 );
                Canvas.KFXFontAlias = "heavytiny11";
                Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
                for( i = 1; i <= 10; i++ )
                {
                    if(i == 10)
                    {
                        s = ""$0$" - "$SMXKeyText[0];
                    }
                    else
                    {
                        s = ""$i$" - "$SMXKeyText[i];
                    }

                    Canvas.SetPos( 26, Canvas.SizeY - 500 + i*20);
                    Canvas.KFXFontAlias = KFXConsoleFontAlias;
                    Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
                }
                break;

            case SM_CKey:
                s = SMCKeyType;
                Canvas.SetPos( 26, Canvas.SizeY - 500 );
                Canvas.KFXFontAlias = "heavytiny11";
                Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
                for( i = 1; i <= 10; i++ )
                {
                    if(i == 10)
                    {
                        s = ""$0$" - "$SMCKeyText[0];
                    }
                    else
                    {
                        s = ""$i$" - "$SMCKeyText[i];
                    }

                    Canvas.SetPos( 26, Canvas.SizeY - 500 + i*20);
                    Canvas.KFXFontAlias = KFXConsoleFontAlias;
                    Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
                }
                break;
        }
	}

    function BeginState()
	{
        bVisible = true;
		bIgnoreKeys = true;
	}

    function EndState()
    {
        bVisible = false;
        bChating=true;
    }

    function CloseSpeechMenu()
	{
		GoToState('');
	}

	event NotifyLevelChange()
	{
		log("[LABOR]-----------kfx console notify level change!");
		Global.NotifyLevelChange();
		GotoState('');
	}
}


exec function KFXPrintScreen()
{
   local sound  sounds;

   if( CanScreenShot )
   {
       sounds =Sound(DynamicLoadObject("fx_ui_sounds.item_prscrn", class'Sound'));
       ViewportOwner.Actor.PlayOwnedSound(sounds,SLOT_Misc);
       KFXHUD(ViewportOwner.Actor.myHUD).KFXSendClewMessage(SaveScreenshots,true,,2,0);
       ConsoleCommand("SHOT");

       ScreenShotCDTimeCounter = ScreenShotCDTime;
       CanScreenShot = false;
   }

}

//wangkai, ÆÁ±ÎËùÓÐ²Ù×÷£¬ÁÄÌìÄ£Ê½ÏÂÓÃ
state BlockAll
{
    function BeginState()
	{
		Super.BeginState();
        ;
    }

    function EndState()
    {
        super.EndState();
        ;
    }
	exec function KFXTalk();
	exec function SpeechMenuToggle(string Type);
	exec function MacroChat(string nType);
    exec function ClearTalkState();
    function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
    {
        return false;
    }
}

// ºêº°»°Ïà¹Ø¹¦ÄÜ
//------------------------------------------------------------------------------

//< To Be Cleaned...
//
//// Àë¿ª×´Ì¬
//exec function UseItemToggle(int Type)
//{
//    UseAimIndex = Type;
//	GotoState('UseItemState');
//}
//function LeaveUseItemState();
//
////Ê¹ÓÃµÀ¾ß×´Ì¬
////------------------------------------------------------------------------------
//state UseItemState
//{
//	// Àë¿ª×´Ì¬
//    exec function UseItemToggle(int Type)
//	{
//		GotoState('');
//	}
//
//	function bool KeyType( EInputKey Key, optional string Unicode )
//	{
//		if (bIgnoreKeys)
//		{
//			return true;
//		}
//		return false;
//	}
//
//    // ´¦ÀíÊäÈë
//	function HandleInput(int nKey)
//	{
//		// È¡Ïû¼ü
//        if( nKey == 0 )
//		{
//            LeaveUseItemState();
//			return;
//		}
//		if((nKey >= PlayerNames.Length)||(nKey <= 0))
//		     return;
//        KFXPlayer(ViewportOwner.Actor).KFXClientUseItem(KFXPlayerReplicationInfo(PlayerReplicationInfos[nKey - 1]));
//        LeaveUseItemState();
//	}
//	// ¼üÎ»×ª»»ÎªÊý×Ö
//    function int KeyToNumber(EInputKey InKey)
//	{
//		local int i;
//
//		for( i = 0; i < 10; i++ )
//		{
//			if( InKey == NumberKeys[i] )
//			{
//				return i;
//			}
//		}
//		return -1;
//	}
//
//    // À¹½ØÊäÈë
//	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
//	{
//		local int inputnum;
//
//        // ÊÇ·ñÀ¹½Ø¿ØÖÆÌ¨ÊäÈë?
//
//		if( Action != IST_Press )
//		{
//			return false;
//		}
//
//        // ×ª»»ÊäÈë
//		inputnum = KeyToNumber(Key);
//
//		if( inputnum != -1 )
//		{
//			HandleInput(inputnum);
//			return true;
//		}
//		return false;
//	}
//
//    function PostRender( canvas Canvas )
//	{
//        local int i;
//        local string s;
//        local int nSelfTeamID;
//        local int nOtherTeamID;
//        local int nLength;
//        local int nIndex;
//        local string sPlayerName;
//        local PlayerReplicationInfo  PlayerInfo;
//        PlayerNames.Remove(0, PlayerNames.Length);
//        PlayerReplicationInfos.Remove(0, PlayerReplicationInfos.Length);
//        nLength =  ViewportOwner.Actor.Level.GRI.PRIArray.Length;
//        nSelfTeamID =  ViewportOwner.Actor.PlayerReplicationInfo.Team.TeamIndex;
//        PlayerNames.Insert(PlayerNames.Length, 1);
//        PlayerNames[PlayerNames.Length - 1] = CancelUse;
//        for(nIndex = 0; nIndex < nLength; nIndex ++)
//        {
//            nOtherTeamID = ViewportOwner.Actor.Level.GRI.PRIArray[nIndex].Team.TeamIndex;
//            sPlayerName = ViewportOwner.Actor.Level.GRI.PRIArray[nIndex].PlayerName;
//            PlayerInfo = ViewportOwner.Actor.Level.GRI.PRIArray[nIndex];
//            if((UseAimIndex == 1)&&(nOtherTeamID != nSelfTeamID))   //¸øµÐ·½Ê¹ÓÃ
//            {
//                PlayerNames.Insert(PlayerNames.Length, 1);
//                PlayerNames[PlayerNames.Length - 1] = sPlayerName;
//                PlayerReplicationInfos.Insert(PlayerReplicationInfos.Length, 1);
//                PlayerReplicationInfos[PlayerReplicationInfos.Length - 1] = PlayerInfo;
//            }else  if((UseAimIndex == 5)&&(nOtherTeamID == nSelfTeamID))   //¸øÓÑ·½Ê¹ÓÃ
//            {
//                PlayerNames.Insert(PlayerNames.Length, 1);
//                PlayerNames[PlayerNames.Length - 1] = sPlayerName;
//                PlayerReplicationInfos.Insert(PlayerReplicationInfos.Length, 1);
//                PlayerReplicationInfos[PlayerReplicationInfos.Length - 1] = PlayerInfo;
//            }
//        }
//
//        //Canvas.SetDrawColor(153, 216, 253, 255);
//        Canvas.SetDrawColor(236, 239, 154, 255);
//        for( i = 0; i < PlayerNames.Length; i++ )
//        {
//            s = ""$i$" - "$PlayerNames[i];
//            Canvas.SetPos( 26 * Canvas.SizeX / 1024, (268+i*20) * Canvas.SizeY / 768 );
//            Canvas.KFXFontAlias = KFXConsoleFontAlias;
//            Canvas.KFXDrawStrWithBorder(s, ShadeColor, -1);
//        }
//
//	}
//    function BeginState()
//	{
//        bVisible = true;
//		bIgnoreKeys = true;
//	}
//
//    function EndState()
//    {
//        bVisible = false;
//    }
//
//    function LeaveUseItemState()
//	{
//		GoToState('');
//	}
//
//	event NotifyLevelChange()
//	{
//		Global.NotifyLevelChange();
//		GotoState('');
//	}
//}
//> To Be Cleaned

//Ê¹ÓÃµÀ¾ß×´Ì¬
//------------------------------------------------------------------------------

//hud¾Ù±¨Íâ¹Ò
exec function ReportSomeone()
{
	local int i;
	local KFXPlayer p;
	//Ìø×ªµ½reportstate£¬È»ºó»æÖÆÎÄ×Ö
	//²¶×½°´¼ü
	curr_player = GetController();
	p = curr_player;
	log("[labor]---------------ForcePrecacheTime:"$p.ForcePrecacheTime
			@p.Level.TimeSeconds-p.ForcePrecacheTime);

	if(p.ForcePrecacheTime ==0 || (p.Level.TimeSeconds-p.ForcePrecacheTime < 15))
		return;

	if(KFXPlayerReplicationInfo(p.PlayerReplicationInfo).bSpectatorView)
	{
		return;
	}
	if(p.IsA('KFXMutatePlayer'))
		return;

	log("[LABOR]----------do report someone");

	suspect_roles.Remove(0, suspect_roles.Length);
	for(i=0; i<p.GameReplicationInfo.PRIArray.Length; i++)
	{
		if(p.GameReplicationInfo.PRIArray[i] != p.PlayerReplicationInfo
				&& !KFXPlayerReplicationInfo(p.GameReplicationInfo.PRIArray[i]).bSpectatorView
				&& p.GameReplicationInfo.PRIArray[i].Team.TeamIndex == p.PlayerReplicationInfo.Team.TeamIndex)
		{
			suspect_roles.Insert(suspect_roles.Length, 1);
			suspect_roles[suspect_roles.Length-1].idx = suspect_roles.Length;
			suspect_roles[suspect_roles.Length-1].role_id = KFXPlayerReplicationInfo(p.GameReplicationInfo.PRIArray[i]).fxPlayerDBID;
			suspect_roles[suspect_roles.Length-1].role_name = p.GameReplicationInfo.PRIArray[i].PlayerName;
		}
	}
	if(suspect_roles.Length > 0)
		gotostate('ReportSomeoneState');
}
state ReportSomeoneState
{
	function BeginState()
	{
		Super.BeginState();
        bVisible = true;
		log("[LABOR]---------ReportSomeoneState");
	}
    function EndState()
    {
        bVisible = false;
    }
	function PostRender( canvas Canvas )
	{
		local int i;
		Canvas.SetDrawColor(236, 239, 154, 255);
		Canvas.KFXFontAlias = KFXConsoleFontAlias;
		for(i=0; i<suspect_roles.length; i++)
		{
			Canvas.SetPos(26, Canvas.SizeY - 500+i*20);
			Canvas.KFXDrawStr(""$suspect_roles[i].idx$". "$suspect_roles[i].role_name);
		}
		Canvas.SetPos(26, Canvas.SizeY - 500+i*20);
		Canvas.KFXDrawStr("0. "$SMZKeyText[0]);

	}
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local int keyvalue;
		local int i;
		if(Action != IST_Press)
			return false;
		log("[LABOR]----------key down="$Key);
		keyvalue = Key-IK_0;
  		if(keyvalue>=0 && keyvalue<=9)
  		{
  			for(i=0; i<suspect_roles.length; i++)
  			{
				if(suspect_roles[i].idx == keyvalue)
				{
					ConsoleCommand("ReportRole"@suspect_roles[i].role_id@suspect_roles[i].role_name);
					break;
				}
			}
			GotoState('');
			return true;
		}
		return false;
	}
	event NotifyLevelChange()
	{
		Global.NotifyLevelChange();
		GotoState('');
	}
}

defaultproperties
{
     KFXConsoleFontAlias="heavytiny11"
     SMT_ChatType(0)="[Team]"
     SMT_ChatType(1)="[Public]"
     SMT_ChatType(2)="[Faction]"
     SMT_ChatType(3)=":"
     ScreenShotCDTime=5.000000
     CanScreenShot=是
     ShadeColor=(A=255)
     bSpeechMenuUseMouseWheel=否
}
