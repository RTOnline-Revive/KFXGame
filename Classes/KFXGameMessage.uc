//-----------------------------------------------------------
//  Class:      KFXGame.KFXGameMessage
//  Creator:    zhangjinpin@kingsoft ÕÅ½ðÆ·
//  Data:       2007-07-29
//  Desc:       ÓÎÏ·ÏûÏ¢
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXGameMessage extends LocalMessage;


var localized string    lPlayerLogin,                       //=" ½øÈëÓÎÏ·"
						lPlayerLogout,                      //=" Àë¿ªÓÎÏ·"
						lUnknownPlayer,                     //="Î´ÖªÍæ¼Ò"

						lModeReqTeam,                       //="ÏûÃðÄã¿´¼ûµÄÃ¿¸öµÐÈË£¬ÕùÈ¡¸ü¶à»÷É±ÊýÒÔÈ¡µÃÊ¤Àû"
						lModeReqSingle,                     //="Ã¿¸öÈË¶¼ÊÇÄãµÄµÐÈË£¬±£»¤ºÃ×Ô¼º£¬ÕùÈ¡¸ü¶à»÷É±Êý"
						lModeReqRound,                      //="¼ßÃðËùÓÐµÄµÐÈË"
						lModeReqBombRed,                    //="Í¨¹ý°²·ÅÕ¨µ¯´Ý»ÙÄ¿±ê£¬µ±È»Ò²¿ÉÒÔ¼ßÃðËùÓÐµÐÈË"
						lModeReqBombBlue,                   //="ÊØ»¤×Ô¼ºµÄÀ×µã²ð³ýµÐ·½µÄÕ¨µ¯£¬µ±È»ÄãÒ²¿ÉÒÔ¼ßÃðËùÓÐµÄµÐÈË"
						lModeReqOccupy,                     //="Õ¼ÁìµØÍ¼ÀïÈ«²¿µÄ¾Ýµã"
						lModeReqGhostBlue,                  //="±£»¤ÎÒ·½ÉèÊ©£¡ÀûÓÃµÐÈË·¢³öµÄÉùÒôÏûÃðµÐÈË"
						lModeReqGhostRed,                   //="ÒÆ¶¯»áÈÃÄãÏÔÐÎ£¬½÷É÷µÄ½Ó½üµÐ·½ÉèÊ©²¢ÊµÊ©±¬ÆÆ"
						lModeTankModeHint,                  //="ÏûÃð¶Ô·½µÄÌ¹¿ËºÍÖ±Éý»ú"


						lBombInstallSuccessByUs,            //=" ³É¹¦°²ÖÃÕ¨µ¯£¬ÇëÇ°È¥·ÀÊØ"
						lBombInstallSuccessByThem,          //=" ³É¹¦°²ÖÃÕ¨µ¯£¬Çë¾¡¿ì²ð³ý"
						lBombRemoveSuccessByBlue,           //=" ³É¹¦²ð³ýÕ¨µ¯£¬À¶¶Ó»ñÊ¤"
						lChangeTeam,                        //=" ±¾¾Ö¿ªÊ¼Ë«·½»¥»»ÕóÓª"
						lGameTransWeap,                     //=" ÔÚ¿ªÊ¼ÓÎÏ·Ç°£¬ÇëÏÈÑ¡ÔñºÏÊÊµÄÎäÆ÷"
						lPlayerOccuping,                    //=" ÕýÔÚÕ¼Áì¾Ýµã"
						lPlayerOccupySuccessByUs,           //=" ³É¹¦Õ¼Áì¾Ýµã£¬ÎÒ·½¶áµÃÁËÒ»¸ö¾Ýµã"
						lPlayerOccupySuccessByThem,         //=" ³É¹¦Õ¼Áì¾Ýµã£¬ÎÒ·½ËðÊ§ÁËÒ»¸ö¾Ýµã"
						lOccupyByBlue,                      //=" ³É¹¦Õ¼Áì¾Ýµã£¬À¶·½15Ãëºó½«Ó®µÃÊ¤Àû"
						lOccupyByRed,                       //=" ³É¹¦Õ¼Áì¾Ýµã£¬ºì·½15Ãëºó½«Ó®µÃÊ¤Àû"
						lOccupyDefSuccess,                  //=" ³É¹¦ÊØ×¡¼º·½¾Ýµã"
						lRedTeamIsOccupying,                 //="ºì·½ÕýÔÚÕ¼Áì¾Ýµã"
						lBlueTeamIsOccupying,                 //="À¶·½ÕýÔÚÕ¼Áì¾Ýµã"
						lRedTeamOccupySuccess,               // ="ºì·½³É¹¦Õ¼Áì¾Ýµã"
						lBlueTeamOccupySuccess,              //  ="À¶·½³É¹¦Õ¼Áì¾Ýµã"
						lWeapOpenTelescope,                 //="µã»÷Êó±êÓÒ¼ü¿ÉÒÔ´ò¿ªÃé×¼¾µ"
						lWeapSetMachGun,                    //="µã»÷Êó±êÓÒ¼ü¿ÉÒÔ¼ÜÉè»ú¹ØÇ¹ÒÔÌá¸ßÉä»÷¾«¶È"
						lWeapCoolOffMachGun,                //="»ú¹ØÇ¹Ç¹Éí¹ýÈÈ£¬ÎÞ·¨¼ÌÐøÉä»÷£¬ÇëÀäÈ´Ò»¶ÎÊ±¼äºóÔÙÊ¹ÓÃ"
						lWeapSetRocket,                     //="µã»÷Êó±êÓÒ¼ü¼ÜÉè»ð¼ýÍ²ºó²Å¿ÉÒÔ½øÐÐÉä»÷"
						lWeapMagnifier,                     //="µã»÷Êó±êÓÒ¼ü¿ÉÒÔ´ò¿ªÃé×¼¾µ½øÐÐÉä»÷"
						lWeapTrippleMode,                   //="µã»÷Êó±êÓÒ¼üÇÐ»»ÈýÁ¬·¢Éä»÷Ä£Ê½"
						lWeapHeavyMode,                     //="µã»÷Êó±êÓÒ¼ü¿ÉÒÔ¶ÔÄ¿±ê½øÐÐÖØ»÷"
						lWeapCoolOffSaw,                    //="µç¾â¹ýÈÈ£¬ÎÞ·¨¼ÌÐø¹¥»÷£¬ÇëÀäÈ´Ò»¶ÎÊ±¼ä"

						lLoseStrength,                      //="±ä»¯×´Ì¬ÏÂÊ§È¥Ò»ÇÐÕ½¶·Á¦£¬¼á³Ö8Ãëºó»á×Ô¶¯¸´Ô­£¨Ê±¼ä¸ù¾Ý¾ßÌåÐÞ¸Äµ÷Õû£©"
						lDropAndPick,                       //="°´GÈÓµôµ±Ç°ÎäÆ÷£¬´ËÊ±¿¿½üµØÃæÉÏµÄÆäËûÎäÆ÷¿ÉÒÔ½«ÆäÊ°Æð"
						lTransWeap,                         //="ÓÎÏ·ÄÚËæÊ±¿É°´N¼ü´ò¿ªÎäÆ÷±³°ü"
						lCallChat,                          //="ÁÄÌìÊ±°´TAB¼ü¿ÉÒÔÇÐ»»ÁÄÌìÆµµÀ"
						lTakeOutC4,                         //="°´5¼üÇÐ»»³öC4Õ¨µ¯£¬°´×¡Êó±ê×ó¼ü½øÐÐ°²×°"
						lDefuseBomb,                        //="°´×¡E¼ü²ð³ýÕ¨µ¯"
						lWatchTeammate,                     //="°´¿Õ¸ñ¼ü¹Û¿´¶ÓÓÑÐÐ¶¯"
						lToggleWatch,                       //="µ¥»÷Êó±ê×ó¼üÇÐ»»¹Û²ìÕß"
						lBombMustSquare,                    //="Õ¨µ¯±ØÐë°²×°µ½Ö¸¶¨µØµã"
						lBombHasInstalled,                  //="Õ¨µ¯ÒÑ¾­°²×°"
						lBombJustThrow,                     //="Õ¨µ¯µôÂä£¬
															//»ðËÙµ½À×´ïÌáÊ¾µØµãÊ°È¡Õ¨µ¯"

						lDolbyChatGameLimit,                //"ÁÄÌì½»»¥Ä£Ê½ÖÐ²»¿ÉÊ¹ÓÃ¶ÓÎéÓïÒô"
						lDolbySingleGameLimit,              //"¸öÈË¸´ÉúÄ£Ê½ÖÐ²»¿ÉÊ¹ÓÃ¶ÓÎéÓïÒô"
						lDolbyCorpseGameLimit,              //"½©Ê¬Ä£Ê½ÖÐ²»¿ÉÊ¹ÓÃ¶ÓÎéÓïÒô"

						lWaitingToTurnCorpse,               //"±äÒì²¡¶¾ÕýÔÚÑ°ÕÒËÞÖ÷£¬XXÃëºó½«»áÓÐÈËÀà±äÒì³ÉÄ¾ÄËÒÁ"
						lJustTurnToCorpse,                  //" ÄãÒÑ±»¸ÐÈ¾³ÉÎªÄ¾ÄËÒÁ£¬ÊÇÄÇÐ©·è¿ñµÄÈËÀàº¦ÁËÄã£¬½«ÄãµÄ¸ÐÈ¾Ö®´¥ÉìÏòÃ¿Ò»¸öÈËÀà°É£¡"
						lAllTurnToCorpse,                   //"ÈËÀàÈ«²¿±»¸ÐÈ¾£¬Ä¾ÄËÒÁ»ñÊ¤"
						lAllCorpsesKilled,                  //"ÈËÀàÏûÃðËùÓÐÄ¾ÄËÒÁÊ±"
						lTimeLimitToCorpse,                 //"µ½´ïÌÓÍÑÊ±¼ä£¬ÈËÀà»ñÊ¤"
						lAliveHaveAntibody,                 //"Ð¡ÐÄ£¡£¡£¡Ð¡ÐÄ£¡£¡ËûÊÇÓ¢ÐÛ"

						lWaitingToTurnPig,                  //"Ò°ÖíC4Õ¨µ¯ÒÑ¾­Æô¶¯£¬15ÃëÖ®ºó±¬Õ¨!"
						lJustTurnToPig,                     //ÄãÏÖÔÚÊÇÒ°Öí£¬¹¥»÷ËùÓÐÐÒ´æµÄÈËÀà°É¡£
						lStillPerson,                       //"´ó²¿·ÖÈËÀàÒÑ¾­±ä³ÉÁË·è¿ñµÄÒ°Öí£¬¶ã¿ªËüÃÇ!"

						lCurCadence_1,                     //ÖÕ½áÕßÄ£Ê½½Ú×à£º·¨ÀÏÍõµÄ¹ÄÎè
						lCurCadence_2,                     //ÖÕ½áÕßÄ£Ê½½Ú×à£º·¨ÀÏÍõµÄ¶÷»Ý
						lCurCadence_3,                     //ÖÕ½áÕßÄ£Ê½½Ú×à£º·¨ÀÏÍõµÄ·è¿ñ
						lCurCadence_4,                     //ÖÕ½áÕßÄ£Ê½½Ú×à£º·¨ÀÏÍõµÄÓÀÉú
						lCurCadence_5,                     //ÖÕ½áÕßÄ£Ê½½Ú×à£º·¨ÀÏÍõµÄ×çÖä

						lCorpseDmgHeavy,                   //ÖÕ½áÕßÉËº¦³ÁÖØ

						lChangeToCorpse,                   //ÖÕ½áÕßÄ£Ê½Éú³É½©Ê¬

						lChangeToTerminator,               //ÖÕ½áÕßÄ£Ê½ Éú³ÉÖÕ½áÕß
						lTerminatorHelp,

						lInvasionTransWeapInfo,             //ÖÕ½áÕß¿ÉÒÔÊ¹ÓÃÁ½°ÑÖ÷ÎäÆ÷£¬Äú¿ÉÒÔµã»÷Êó±êÓÒ¼üÑ¡ÔñµÚ¶þ°ÑÖ÷ÎäÆ÷

						lTwistSkillDelay,

						lTerminatorWin,                     //ÖÕ½áÕß»ñÊ¤
						lCorpseWin,                         //Ä¾ÄËÒÁ»ñÊ¤
						lBloodThirstyCD,                    //ÊÈÑªÕýÔÚCDµÄÌáÊ¾

						lTankNeedDriver,                    //Íæ¼ÒÉÏÌ¹¿ËµÄÌáÊ¾
						lTankAccHint,                       //Ì¹¿Ë¼ÓËÙÌáÊ¾
						lTankArmorHint,                     //Ì¹¿Ë»¤¼×ÌáÊ¾

						lPropHanging,                       // ¹Ò»ú¿¨ÌáÊ¾

						lItemDropOwner,                     ///<»÷ÂäÂíÈø°ÂµôÂäÎïÆ·Íæ¼ÒÌáÊ¾
						lItemDropOther,                     ///<·Ç»÷ÂäÂíÈø°ÂµôÂäÎïÆ·Íæ¼ÒÌáÊ¾
						lItemPickOwner,                     ///<Ê°¿ÉÈ¡ÂíÈø°ÂµôÂäÎïÆ·Íæ¼ÒÌáÊ¾
						lItemPickOther,                      ///<·ÇÊ°¿ÉÈ¡ÂíÈø°ÂµôÂäÎïÆ·Íæ¼ÒÌáÊ¾

                        lVIPTipText,                        //VIPÓÄÁéÄ£Ê½ÌáÊ¾ÄúÊÇVIP
                        lVIPCantBuyWeapon,                   //VIP²»ÄÜÂòÇ¹
                        lVIPArrived,                          //VIPÔÚ×îÖÕµãÊØ×¡×îºótÃë(t¿ÉÅä£©µÈ´ýÖ±Éý»ú¾ÈÔ®
                        lBlueRestart,                       //¾¯²ì¸´»îºóÎÄ×ÖÌáÊ¾
                        lRedRestart,                       //ÓÄÁé¸´»îºóÎÄ×ÖÌáÊ¾
                        lVIPSwitchMajorWeapon,             //VIP °´1ÇÐÖ÷ÎäÆ÷Ê±
                        lProtectVIP,                        //ÇëËÙ¶ÈÇ°Íù±£»¤VIP£¡
                        lFollowVIP,                         //±£³Ö¶ÓÐÎ£¬¸ú½ôVIP£¡
                        lAddBloodAmmoTips,                 //Ôö¼ÓÑªºÍ×Óµ¯ÌáÊ¾
                        lOnlyAddBloodTips,                 //Ôö¼ÓÑªÌáÊ¾
                        lOnlyAddAmmoTips,                  //Ôö¼Ó×Óµ¯ÌáÊ¾
                        lGetItemMessage,                   //»ñµÃÁã¼þÌáÊ¾
                        lPlayerRestartTips,                //[XXXX]Íæ¼ÒÒÑ¸´»î
                        lPlayerDeadTips,                   //[XXXX]Íæ¼ÒËÀÍö
                        lSelfDeadTips,                     //ÒÑËÀÍö£¬×Ô¶¯¸´»î
                        lNeedRestartTips,                  //ÄúÒÑËÀÍö£¬¿É°´¡°F¡±¼üÏûºÄ¸´»î±Ò¸´»î£¬»òµÈ´ýÖÁÏÂ1²¿·Ö¿ªÊ¼ºó×Ô¶¯¸´»î
                        lAllPlayerDeadTips,                //TÃëÄÚÈôÎÞÍæ¼Ò¸´»î£¬ÔòÓÎÏ·Ê§°Ü
                        lPlayerAttackDoor;                 //»÷´òéÙ»ÆÉ«²¿Î»




static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	//<< dolby voice, player µÇÂ½Ê±£¬Èç¹ûÔÚÆÁ±ÎÁÐ±íÀï£¬Ôò¶ÔÆäÆÁ±Î

	if (Switch == 1 && P != none && KFXPlayer(P) != none && KFXPlayer(P).DVClient != none)
	{
		log ("++++++++++++ MuteOne ++++++++++");
		if (KFXPlayer(P).DVClient.DVInBanList(KFXPlayerReplicationInfo(RelatedPRI_1).fxPlayerDBID))
		{
			// ÆÁ±ÎÇëÇó
			KFXPlayer(P).DVServerMuteOne(KFXPlayerReplicationInfo(RelatedPRI_1).fxPlayerDBID, true);
			// ±êÊ¶ÆÁ±Î
			KFXPlayerReplicationInfo(RelatedPRI_1).bKFXMute = true;
		}
	}
	//>>
}

//wangkai, ½«Õâ²¿·Ö´úÂë×ªÒÆµ½ÐÂ½Ó¿ÚGetStringEx£¬´Ë½Ó¿Ú²»ÔÙÊ¹ÓÃ
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
)
{
	return "";
}

//<< wangkai, À©Õ¹½Ó¿Ú£¬Ìí¼ÓPlayerController²ÎÊý
static function string GetStringEx(
	int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional PlayerController P,
	optional Object OptionalObject)
{
	switch (Switch)
	{
		//------------------- »ù±¾ÐÅÏ¢ ----------------
		// Íæ¼ÒµÇÂ½
		case 1:
			if( RelatedPRI_1 == none )
			{
				return default.lUnknownPlayer $ default.lPlayerLogin;
			}
			else
			{
				return RelatedPRI_1.PlayerName $ default.lPlayerLogin;
			}
			break;

		// Íæ¼ÒÍË³ö
		case 2:
			if( RelatedPRI_1 == none )
			{
				return default.lUnknownPlayer $ default.lPlayerLogout;
			}
			else
			{
				return RelatedPRI_1.PlayerName $ default.lPlayerLogout;
			}
			break;

		//------------------- Ä£Ê½ÌáÊ¾ ----------------
		//Ä£Ê½ÌáÊ¾, ÍÅ¶Ó¸´Éú
		case 11:
			return default.lModeReqTeam;
			break;

		//Ä£Ê½ÌáÊ¾, ¸öÈË¸´Éú
		case 12:
			return default.lModeReqSingle;
			break;

		//Ä£Ê½ÌáÊ¾, ÍÅ¶Ó¾º¼¼
		case 13:
			return default.lModeReqRound;
			break;

		//Ä£Ê½ÌáÊ¾, ±¬ÆÆ
		case 14:
			log("IsBlueTeam"@KFXPlayerReplicationInfo(RelatedPRI_1).IsBlueTeam());
			if (KFXPlayerReplicationInfo(RelatedPRI_1).IsBlueTeam())//À¶¶Ó
				return default.lModeReqBombBlue;
			else
				return default.lModeReqBombRed;
			break;

		//Ä£Ê½ÌáÊ¾, Õ¼Áì
		case 15:
			return default.lModeReqOccupy;
			break;
	   //Ä£Ê½ÌáÊ¾£¬ÓÄÁé
		case 16:
			if (RelatedPRI_1.Team.TeamIndex == 0)//À¶¶Ó
				return default.lModeReqGhostBlue;
			else
				return default.lModeReqGhostRed;
			break;
		//Ä£Ê½ÌáÊ¾£ºÌ¹¿Ë´óÕ½
		case 17:
				return default.lModeTankModeHint;

		//------------------- ±¬ÆÆÕ¼ÁìÏà¹Ø ----------------
		// XXX³É¹¦°²×°Õ¨µ¯
		case 31:
			if (KFXPlayerReplicationInfo(P.PlayerReplicationInfo).Team.TeamIndex == RelatedPRI_1.Team.TeamIndex)//Í¬¶Ó
			{
				return RelatedPRI_1.PlayerName $ default.lBombInstallSuccessByUs;
			}
			else//²»Í¬¶Ó
			{
				return RelatedPRI_1.PlayerName $ default.lBombInstallSuccessByThem;
			}
			break;

		// XXX³É¹¦²ð³ýÕ¨µ¯
		case 32:
			return RelatedPRI_1.PlayerName $ default.lBombRemoveSuccessByBlue;
			break;

		// XXXÕýÔÚÕ¼Áì¾Ýµã
		case 33:
			return RelatedPRI_1.PlayerName $ default.lPlayerOccuping;
			break;

		// XXX³É¹¦Õ¼Áì¾Ýµã
		case 34:
			if (KFXPlayerReplicationInfo(P.PlayerReplicationInfo).Team.TeamIndex == RelatedPRI_1.Team.TeamIndex)//Í¬¶Ó
			{
				return RelatedPRI_1.PlayerName $ default.lPlayerOccupySuccessByUs;
			}
			else//²»Í¬¶Ó
			{
				return RelatedPRI_1.PlayerName $ default.lPlayerOccupySuccessByThem;
			}
			break;

		// È«²¿Õ¼Áì15Ãë½áÊø
		case 35:
			if( RelatedPRI_1.Team.TeamIndex == 0 )//À¶¶Ó
			{
				return RelatedPRI_1.PlayerName $ default.lOccupyByBlue;
			}
			else if( RelatedPRI_1.Team.TeamIndex == 1 )//ºì¶Ó
			{
				return RelatedPRI_1.PlayerName $ default.lOccupyByRed;
			}
			break;

		// ·ÀÓù×¡ÁËÕ¼Áì
		case 36:
			return RelatedPRI_1.PlayerName $ default.lOccupyDefSuccess;
			break;
		// »»¶ÓÌáÊ¾
		case 37:
			return default.lChangeTeam;
			break;
		case 38:
			return default.lGameTransWeap;
			break;



		//------------------- ÎäÆ÷Ïà¹Ø ----------------
		//ÓÒ¼ü¿ª¾Ñ»÷¾µ, AWP etc.
		case 41:
			return default.lWeapOpenTelescope;
			break;

		//ÓÒ¼ü¼Ü»úÇ¹
		case 42:
			return default.lWeapSetMachGun;
			break;

		//»úÇ¹¹ýÈÈ
		case 43:
			return default.lWeapCoolOffMachGun;
			break;

		//ÓÒ¼ü¼Ü»ð¼ýÍ²
		case 44:
			return default.lWeapSetRocket;
			break;

		//ÓÒ¼ü´ò¿ª·Å´ó¾µ, AUG etc.
		case 45:
			return default.lWeapMagnifier;
			break;

		//ÈýÁ¬·¢Ä£Ê½
		case 46:
			return default.lWeapTrippleMode;
			break;

		//ÖØ»÷Ä£Ê½, Knife etc.
		case 47:
			return default.lWeapHeavyMode;
			break;

		// µç¾â¹ýÈÈ
		case 48:
			return default.lWeapCoolOffSaw;

		//------------------- ÆäËü ----------------
		//Ê§È¥Õ½¶·Á¦
		case 50:
			return default.lLoseStrength;
			break;

		//¼ñÇ¹
		case 51:
			return default.lDropAndPick;
			break;

		//°´X¼ü»»Ç¹
		case 53:
			return default.lTransWeap;
			break;

		//µ÷³öÁÄÌì
		case 54:
			return default.lCallChat;
			break;

		//ÄÃ³öC4
		case 55:
			return default.lTakeOutC4;
			break;

		//°´X¼ü²ð³ýC4
		case 56:
			return default.lDefuseBomb;
			break;

		//¹Û¿´¶ÓÎé
		case 57:
			return default.lWatchTeammate;
			break;

		//ÇÐ»»±»¹Û²ìÕß
		case 58:
			return default.lToggleWatch;
			break;

		// Õ¨µ¯±ØÐë°²×°µ½Ö¸¶¨µØµã
		case 59:
			return default.lBombMustSquare;
			break;

		// Õ¨µ¯ÒÑ¾­°²×°(È¥×°Õ¨µ¯µÄÊ±ºò, Õ¨µ¯ÒÑ¾­×°ÉÏÁË)
		case 60:
			return default.lBombHasInstalled;
			break;
		case 61:
			return default.lBombJustThrow;
			break;
		case 62:
			return default.lDolbyChatGameLimit;
			break;
		case 63:
			return default.lDolbySingleGameLimit;
			break;
		case 64:
			return default.lDolbyCorpseGameLimit;
			break;

				//½©Ê¬Ä£Ê½Ïà¹Ø
		case 71:
		   return default.lWaitingToTurnCorpse;
		   break;
		case 72:
		   return default.lJustTurnToCorpse;
		   break;
		case 73:
		   return default.lAllTurnToCorpse;
		   break;
		case 74:
		   return default.lAllCorpsesKilled;
		   break;
		case 75:
		   return default.lTimeLimitToCorpse;
		   break;
		/*case 76:
		   return default.lForbidDance;
		case 77:
			if ( KFXCorpsePlayerReplicationInfo(P.PlayerReplicationInfo) == KFXCorpsePlayerReplicationInfo(RelatedPRI_1) )//Í¬¶Ó
			{
				return default.lAliveChangeToHero;
			}
			else//²»Í¬¶Ó
			{
				return default.lAliveHaveAntibody;
			}*/
		//=====Ð¡ÖíÄ£Ê½Ïà¹Ø
		case 81:
			return default.lWaitingToTurnPig;
		case 82:
			return default.lJustTurnToPig;
		case 83:
			return default.lStillPerson;

		//======ÖÕ½áÕßÄ£Ê½Ïà¹Ø=======
		case 90:
			return default.lInvasionTransWeapInfo;
		case 91:
			return default.lCurCadence_1;
		case 92:
			return default.lCurCadence_2;
		case 93:
			return default.lCurCadence_3;
		case 94:
			return default.lCurCadence_4;
		case 95:
			return default.lCurCadence_5;

		case 100:
			return default.lChangeToCorpse;
		case 120:
			return default.lChangeToTerminator;
		case 121:
			return default.lTerminatorWin;
		case 122:
			return default.lCorpseWin;
		case 123:
			return default.lBloodThirstyCD;
		case 130:
			return default.lCorpseDmgHeavy;
		case 131:
			return default.lTerminatorHelp;
		case 135:
			return default.lTwistSkillDelay;

		//µÀ¾ßÏà¹Ø
		case 150:
			return default.lPropHanging;

		//ÉÍ½ðÈÎÎñµôÂäÎïÆ·Ïà¹Ø
		case 160:
			 return default.lItemDropOwner;
		case 161:
			 return default.lItemDropOther;
		case 162:
			 return default.lItemPickOwner;
		case 163:
			 return default.lItemPickOther;

        //VIPÓÄÁéÄ£Ê½Ïà¹Ø
        case 200:
            return default.lVIPTipText;
        case 201:
            return default.lVIPCantBuyWeapon;
        case 202:
             return default.lVIPArrived;
        case 203:
            return default.lBlueRestart;
        case 204:
             return default.lRedRestart;
        case 205:
             return default.lVIPSwitchMajorWeapon;
        case 206:
             return default.lProtectVIP;
        case 207:
             return default.lFollowVIP;
        case 208:
             return default.lAddBloodAmmoTips;
        case 209:
             return default.lOnlyAddBloodTips;
        case 210:
             return default.lOnlyAddAmmoTips;
        case 211:
             return default.lGetItemMessage;
        //PVE
        case 212:
             return default.lPlayerRestartTips;
        case 213:
             return default.lPlayerDeadTips;
        case 214:
             return default.lSelfDeadTips;
        case 215:
             return default.lNeedRestartTips;
        case 216:
             return default.lAllPlayerDeadTips;
        case 217:
             return default.lPlayerAttackDoor;

    }
    return "";
}

defaultproperties
{
     bIsConsoleMessage=否
}
