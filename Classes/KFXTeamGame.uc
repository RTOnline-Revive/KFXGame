//-----------------------------------------------------------
//  Class:      KFXGame.KFXTeamGame
//  Creator:    zhangjinpin@kingsoft ÕÅ½ðÆ·
//  Data:       2007-03-26
//  Desc:       FOXÏîÄ¿ÓÎÏ·¹æÔò
//  Update:
//  Special:    ÎÞ·½±ä»Ã
//-----------------------------------------------------------

class KFXTeamGame extends KFXDeathGame
	config(kfxgame_team);

//-----------------------------------------------------------
// ¶¨Òå¿ÉÅäÖÃ±äÁ¿
//-----------------------------------------------------------


//-----------------------------------------------------------
// ¶¨Òå²»¿ÉÅäÖÃ±äÁ¿
//-----------------------------------------------------------
var KFXTeamInfo KFXTeams[2];
var string  KFXTeamClass;
var bool    bScoreTeamKills;
var bool  bStartedCountDown;   //µ¹¼ÆÊ±ÊÇ·ñ¿ªÊ¼
var bool  bTeamsMustBeReady;   //Ë«·½¶ÓÎéÊÇ·ñ×¼±¸ºÃ
var float TimeGameInPending;   //ÓÎÏ·½øÈëpending×´Ì¬µÄÊ±¼ä

var class<TeamAI> 			TeamAIType[2];
//-----------------------------------------------------------
// event²¿·Ö
//-----------------------------------------------------------
event PreBeginPlay()
{
    super.PreBeginPlay();
}


// ÔÚÕâÀï³õÊ¼»¯¶ÓÎé
event PostBeginPlay()
{
	local int i;
	local class<KFXTeamInfo> fxTeamClass;
	fxTeamClass = class<KFXTeamInfo>(DynamicLoadObject(KFXTeamClass,class'Class'));

	KFXTeams[0] = Spawn(fxTeamClass);
	KFXTeams[1] = Spawn(fxTeamClass);

	for (i = 0; i < 2; i++)
	{
		KFXTeams[i].TeamIndex = i;
		GetGRI().Teams[i] = KFXTeams[i];
	}
    //Edit by lwg
    ;
    ;
    for (i=0;i<2;i++)
	{
		KFXTeams[i].AI = Spawn(TeamAIType[i]);
		KFXTeams[i].AI.Team = KFXTeams[i];
	}
	KFXTeams[0].AI.EnemyTeam = KFXTeams[1];
	KFXTeams[1].AI.EnemyTeam = KFXTeams[0];
	KFXTeams[0].AI.SetObjectiveLists();
	KFXTeams[1].AI.SetObjectiveLists();

	Super.PostBeginPlay();
	GetGRI().Winner = none;
	GetGRI().bRandWinner = false;
}

//Edit by lwg
function UnrealTeamInfo GetBotTeam(optional int TeamBots)
{
	local int first, second;

	if ( bPlayersVsBots && (Level.NetMode != NM_Standalone) )
		return KFXTeams[1];

        /*
	if ( (Level.NetMode == NM_Standalone) || !bBalanceTeams )
	{
		if ( KFXTeams[0].AllBotsSpawned() )
	    {
			bBalanceTeams = false;
		    if ( !KFXTeams[1].AllBotsSpawned() )
			    return KFXTeams[1];
	    }
	    else if ( KFXTeams[1].AllBotsSpawned() )
	    {
			bBalanceTeams = false;
		    return KFXTeams[0];
		}
	}
        */
	second = 1;

	// always imbalance teams in favor of bot team in single player
	if ( StandalonePlayer != None && StandalonePlayer.PlayerReplicationInfo.Team != None
	     && StandalonePlayer.PlayerReplicationInfo.Team.TeamIndex == 1 )
	{
		first = 1;
		second = 0;
	}
	if ( KFXTeams[first].Size < KFXTeams[second].Size )
		return KFXTeams[first];
	else
		return KFXTeams[second];
}

//-----------------------------------------------------------


//-----------------------------------------------------------
// function²¿·Ö
//-----------------------------------------------------------
// ÔÚGameinfoµÄInitGameÊ±±»µ÷ÓÃ
// ¸ù¾ÝUI´«µÝµÄÐÅÏ¢Ñ¡ÔñÒ»¸ö¶ÓÎé±àºÅ
function byte PickTeam(byte num, Controller C)
{
	local KFXTeamInfo SmallTeam, BigTeam, NewTeam;

	SmallTeam = KFXTeams[0];
	BigTeam = KFXTeams[1];

	if ( SmallTeam.Size > BigTeam.Size )
	{
		SmallTeam = KFXTeams[1];
		BigTeam = KFXTeams[0];
	}
    // ·Ç´óÌüÄ£Ê½
    if ( KFXAgent == none )
    {
		if( Level.NetMode != NM_DedicatedServer)
		{
        	if ( num < 2 )
        	{
        		NewTeam = KFXTeams[num];
        	}
        }
        else
            NewTeam = SmallTeam;
    }
    else
    {
    	if ( num < 2 )
    	{
    		NewTeam = KFXTeams[num];
    	}

    	// ×Ô¶¯Ñ¡ÔñÈËÉÙµÄ¶ÓÎé
        if ( NewTeam == None )
    	{
    		NewTeam = SmallTeam;
    	}
    }

	return NewTeam.TeamIndex;
}
//----¼ì²éÊÇ·ñÐèÒªÔÚÓÎÏ·ÖÐÍ¾½øÐÐ»»¶Ó£¬Ð¡¾ÖÄ£Ê½ºÍ·ÇÐ¡¾ÖÄ£Ê½Âß¼­Ó¦¸ÃÓÐËù²»Í¬
function bool KFXCheckTeamNeedChanged()
{
    return false;
}


// ¸ü»»¶ÓÎé
function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
{
	local KFXTeamInfo NewTeam;

	// ÅÐ¶ÏControllerÊÇ·ñÊÇÒ»¸öÅÔ¹ÛÕß
    if ( Other.IsA('PlayerController') && Other.PlayerReplicationInfo.bOnlySpectator )
	{
		Other.PlayerReplicationInfo.Team = None;
		return true;
	}

	// Ñ¡ÔñÒ»¸ö¶ÓÎé
    NewTeam = KFXTeams[PickTeam(num,Other)];
	;

	// ÅÐ¶ÏÊÇ·ñÒÑ¾­ÔÚÕâ¸ö¶ÓÎé
	if ( Other.PlayerReplicationInfo.Team == NewTeam )
	{
		;
        return false;
	}

	// Çå¿Õ³öÉúµã
    Other.StartSpot = None;

	// ÏÈÒÆ³ö¶ÓÎé£¬ÔÙ¼ÓÈë£¬±£Ö¤Team.sizeÕýÈ·
    if ( Other.PlayerReplicationInfo.Team != None )
	{
		Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
	}

	if ( NewTeam.AddToTeam(Other) )
	{
		BroadcastLocalizedMessage( GameMessageClass, 3, Other.PlayerReplicationInfo, None, NewTeam );

		// ¼ÓÈëÊÂ¼þ´¥·¢
        if ( bNewTeam && PlayerController(Other) != None )
		{
			GameEvent("TeamChange", ""$num, Other.PlayerReplicationInfo);
		}
	}

	return true;
}

// Í¬×éÖ®¼ä²»¿É»¥É±
function float ReduceDamage
(
    float Damage,
    pawn injured,
    pawn instigatedBy,
    vector HitLocation,
    out vector Momentum,
    class<DamageType> DamageType
)
{
	local int InjuredTeam, InstigatorTeam;
	local controller InstigatorController;


    // ÕÒµ½¹¥»÷ÕßµÄController
    if ( InstigatedBy != None )
	{
		InstigatorController = InstigatedBy.Controller;
	}
	else
    {
        InstigatorController = injured.DelayedDamageInstigatorController;
    }

	// ÕÒ²»µ½·µ»ØÄ¬ÈÏµÄReduceDamage
    if ( InstigatorController == None )
	{
		if ( DamageType.default.bDelayedDamage )
		{
			InstigatorController = injured.DelayedDamageInstigatorController;
		}
		if ( InstigatorController == None )
		{
			return Super.ReduceDamage( Damage,injured,instigatedBy,HitLocation,Momentum,DamageType );
		}
	}

	// È¡Á½¸öÈËµÄ¶ÓÎé±àºÅ
    GetDmgTwoSideTeamNum(Injured, InstigatorController,
                            InjuredTeam, InstigatorTeam );
    if(KFXVehiclesBase(injured)==none)
    {
    	if ( InstigatorController != injured.Controller )
    	{
    		if ( InjuredTeam != 255 && InstigatorTeam != 255 && InjuredTeam == InstigatorTeam )
    		{
    		    KFXFriendlyDamage(Damage, injured, instigatedBy);
    		    if( !KFXFriendlyDamage(Damage, injured, instigatedBy) )
    		    {
                    Damage *= GetGRI().fxFriendlyFireScale;
                }
    		}
    	}
	}

	return Super.ReduceDamage( Damage, injured, instigatedBy, HitLocation, Momentum, DamageType );
}

function GetDmgTwoSideTeamNum(pawn injured, Controller InstigatorController,
                            out int InjuredTeam, out int instigatedByTeam )
{
    InjuredTeam = Injured.GetTeamNum();
    instigatedByTeam = InstigatorController.GetTeamNum();
}

// ¶ÓÓÑÖ®¼äµÄÌØÊâÉËº¦
function bool KFXFriendlyDamage(int Damage, pawn injured, pawn instigatedBy)
{
    // C4 Õ¨µ¯
    if( KFXPawn(injured).KFXDmgInfo.WeaponID == 1 )
    {
        return true;
    }

    return false;
}

// É±ÈËºó½±Àø
function ScoreKill(Controller Killer, Controller Other)
{
    local KFXPlayerReplicationInfo fxPRI;

    // ²»ÊÇÍæ¼ÒÖ®¼ä
    if ( !Other.bIsPlayer || ( Killer != None && !Killer.bIsPlayer)
        || Other.PlayerReplicationInfo.Team == none || Killer.PlayerReplicationInfo.Team ==none )//¶Ô¶¯Ì¬»»¶ÓÄ£Ê½µÄ¼æÈÝ
	{
        return;
	}

    // Íæ¼Ò±»É±ºó
    if ( Other.bIsPlayer )
	{
		// ×ÔÉ±»òÃ»ÓÐÉ±ÊÖ
        if ( Killer == None || Killer == Other )
		{
			if( Other != none  && Other.PlayerReplicationInfo != none )
			{
                // ×ÔÉ±²»¼õ¶ÓÎé·ÖÊý
			    Other.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
			    Other.PlayerReplicationInfo.Team.NetUpdateTime = Level.TimeSeconds - 1;
            }
      	}
		else if ( Killer.PlayerReplicationInfo != None )
		{
            fxPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);

            // ÅÐ¶ÏÊÇ·ñÊÇÍ¬Ò»¸ö¶ÓÎé
            if( fxPRI.Team != Other.PlayerReplicationInfo.Team )
		    {
			    // »ý·ÖÔö¼Ó
		        fxPRI.NetUpdateTime = Level.TimeSeconds - 1;

                fxPRI.Team.Score += 1;
			    fxPRI.Team.NetUpdateTime = Level.TimeSeconds - 1;
		    }
		    else if ( GetGRI().fxFriendlyFireScale > 0 )
		    {
			    fxPRI.Score -= 1;
                fxPRI.NetUpdateTime = Level.TimeSeconds - 1;

			    fxPRI.Team.Score -= 1;
			    fxPRI.Team.NetUpdateTime = Level.TimeSeconds - 1;
			}
		}
	}

	// ÅÐ¶Ï½áÊøÌõ¼þ£¨·ÖÊý£©
    if ( Killer != None && bScoreTeamKills )
    {
		CheckScore(Killer.PlayerReplicationInfo,Other.PlayerReplicationInfo);
	}
}

function KFXTeamInfo GetTeam(int nTeamIndex)
{
    if( nTeamIndex == 0 )
    {
        return KFXTeams[0];
    }
    else if ( nTeamIndex == 1 )
    {
        return KFXTeams[1];
    }
}

function KFXTeamInfo GetOtherTeam(int nTeamIndex)
{
    if( nTeamIndex == 0 )
    {
        return KFXTeams[1];
    }
    else if ( nTeamIndex == 1 )
    {
        return KFXTeams[0];
    }
}

// µÃµ½¶ÓÎéÖÐÄ³ÈËµÄRP
function PlayerReplicationInfo GetTeamPlayerRP(int nTeamIndex)
{
    local Controller C;
	local KFXPlayer fxPlayer;

 	for ( C = Level.ControllerList; C != None; C = C.NextController )
    {
    	fxPlayer = KFXPlayer(C);
    	if ( fxPlayer != None
            && fxPlayer.PlayerReplicationInfo.Team != none
            && !fxPlayer.IsDead()
            && !fxPlayer.IsInState('Spectating')
            && fxPlayer.PlayerReplicationInfo.Team.TeamIndex == nTeamIndex )
    	{
            return fxPlayer.PlayerReplicationInfo;
    	}
    }
    return none;
}

// µÃµ½¶ÓÓÑµÄRP(²»ÊÇ×Ô¼º)
function PlayerReplicationInfo GetTeamMateRP(KFXPlayer Player)
{
    local Controller C;
	local KFXPlayer fxPlayer;

 	for ( C = Level.ControllerList; C != None; C = C.NextController )
    {
    	fxPlayer = KFXPlayer(C);
    	if ( fxPlayer != None
            && fxPlayer.PlayerReplicationInfo.Team != none
            && !fxPlayer.IsDead()
            && !fxPlayer.IsInState('Spectating')
            && fxPlayer != Player
            && fxPlayer.PlayerReplicationInfo.Team.TeamIndex == Player.PlayerReplicationInfo.Team.TeamIndex )
    	{
            return fxPlayer.PlayerReplicationInfo;
    	}
    }
    return none;
}

// ÕÒ¶ÔÊÖµÄRP
function PlayerReplicationInfo GetOtherTeamRP(KFXPlayer Player)
{
    local Controller C;
	local KFXPlayer fxPlayer;

 	for ( C = Level.ControllerList; C != None; C = C.NextController )
    {
    	fxPlayer = KFXPlayer(C);
    	if ( fxPlayer != None
            && fxPlayer.PlayerReplicationInfo.Team != none
            && !fxPlayer.IsDead()
            && !fxPlayer.IsInState('Spectating')
            && fxPlayer != Player
            && fxPlayer.PlayerReplicationInfo.Team.TeamIndex != Player.PlayerReplicationInfo.Team.TeamIndex )
    	{
            return fxPlayer.PlayerReplicationInfo;
    	}
    }
    return none;
}

function int GetTeamPlayerNum(int nTeamIndex)
{
	local int i;
    local Controller C;
	local KFXPlayer fxPlayer;

 	for ( C = Level.ControllerList; C != None; C = C.NextController )
    {
    	fxPlayer = KFXPlayer(C);
    	if ( fxPlayer != None
            && fxPlayer.PlayerReplicationInfo.Team != none
            && fxPlayer.GetPlayerRealTeamNum() == nTeamIndex )
    	{
            i++;
    	}
    }
    return i;
}

//¼ÆËãÐ¡¶Ó»ý·ÖÊ±µÄÓÐÐ§¶ÓÔ±ÊýÁ¿
function int GetSpointPlayerNum()
{
	local int i;
    local Controller C;
	local KFXPlayer fxPlayer;

 	for ( C = Level.ControllerList; C != None; C = C.NextController )
    {
    	fxPlayer = KFXPlayer(C);
    	if ( fxPlayer != None
            && fxPlayer.PlayerReplicationInfo.Team != none
            && KFXPlayerReplicationInfo(fxPlayer.PlayerReplicationInfo).fxKills != 0)
    	{
            i++;
    	}
    }
    return i;
}
//¼ÆËãÕ½¶ÓÈüÊ¤ÀûºÍÊ§°ÜµÄµÃ·Ö
function UpdateBattleTeamWinAndLostPoint( Controller Player,PlayerReplicationInfo Winner )
{
    local KFXPlayerReplicationInfo fxPRI;
    local float  TotalPlayTime;       // ÓÎÏ·Ê±¼ä
    local int PlayerNum,WinnerPlayersNum,LostPlayersNum;
    local int WinTeam;
    local bool SelfIsWinner;

    if(GetGRI().nGameType == 0)
    {
        fxPRI.fxWinSpoint = 0;
        fxPRI.fxLostSpoint = 0;
        return;
    }

    fxPRI = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo);
    if( self.GetGRI().Winner == self.KFXTeams[0] )
    {
        WinTeam = 0;
    }
    else if( self.GetGRI().Winner == self.KFXTeams[1] )
        WinTeam = 1;
    else
        WinTeam = -1;

    SelfIsWinner = false;

    if( Player == none || !Player.bIsPlayer )
    {
        return;
    }
    if ( Player.PlayerReplicationInfo.Team == self.GetGRI().Winner )
    {
        SelfIsWinner = true;
    }
    if( KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxBattleTeamID == 0 )
    {
        fxPRI.fxWinSpoint = 0;
        fxPRI.fxLostSpoint = 0;
        return;
    }

    PlayerNum = GetNumPlayers();

    if( SelfIsWinner && KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).Team.TeamIndex == 0 )
    {
        WinnerPlayersNum = GetTeamPlayerNum(0);
    }
    else if( !SelfIsWinner && KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).Team.TeamIndex != 0 )
        WinnerPlayersNum = GetTeamPlayerNum(0);
    else
        WinnerPlayersNum = GetTeamPlayerNum(1);

    LostPlayersNum = PlayerNum - WinnerPlayersNum;

    TotalPlayTime = (Level.TimeSeconds - KFXGameStartTime) / 60.0;

    if(GetGRI().nGameType == 1)
    {
        ///Ê¤ÀûÕ½¶ÓµÃ·Ö¼°¹±Ï×¶È
        if( WinnerPlayersNum>0 )
        {
            fxPRI.fxWinSpoint = 1.5 * TotalPlayTime*GetSpointPlayerNum();
        }
        else
        {
            fxPRI.fxWinSpoint = 0;
        }
        ///Ê§°ÜÕ½¶ÓµÃ·Ö¼°¹±Ï×¶È
        if( LostPlayersNum>0 )
        {
            fxPRI.fxLostSpoint = 0.5 * TotalPlayTime*GetSpointPlayerNum();
        }
        else
        {
            fxPRI.fxLostSpoint = 0;
        }
        if(SelfIsWinner)
        {
           fxPRI.fxPlayerContribution = 1.5 * TotalPlayTime;
        }
        else
        {
           fxPRI.fxPlayerContribution = 0.5 * TotalPlayTime;
        }

    }
    else if(GetGRI().nGameType == 2)
    {
        ///Ê¤ÀûÕ½¶ÓµÃ·Ö¼°¹±Ï×¶È
        if( WinnerPlayersNum>0 )
        {
            fxPRI.fxWinSpoint = 3 * TotalPlayTime*GetSpointPlayerNum();
        }
        else
        {
            fxPRI.fxWinSpoint = 0;
        }
        ///Ê§°ÜÕ½¶ÓµÃ·Ö¼°¹±Ï×¶È
        if( LostPlayersNum>0 )
        {
            fxPRI.fxLostSpoint = 1 * TotalPlayTime*GetSpointPlayerNum();
        }
        else
        {
            fxPRI.fxLostSpoint = 0;
        }
        if(SelfIsWinner)
        {
           fxPRI.fxPlayerContribution = 3 * TotalPlayTime;
        }
        else
        {
           fxPRI.fxPlayerContribution = 1 * TotalPlayTime;
        }

    }
    if(fxPRI.fxKills < 1 || fxPRI.fxPlayerContribution < 0)
         fxPRI.fxPlayerContribution = 0;
    //fxPRI.fxWinSpoint = Clamp(fxPRI.fxWinSpoint,0,300);
//    fxPRI.fxLostSpoint = Clamp(fxPRI.fxLostSpoint,0,100);
    log("[KFXTeamGame] UpdateBattleTeamWinAndLostPoint WinnerPlayersNum:"$WinnerPlayersNum$"TotleNum:"$PlayerNum);
    log("[KFXDeathGame] UpdateBattleTeamWinAndLostPoint"
        $"fxWinSpoint:"$fxPRI.fxWinSpoint
        $"fxLostSpoint:"$fxPRI.fxLostSpoint
        $"fxPRI.fxPlayerContribution:"$fxPRI.fxPlayerContribution);
}

// ÓÎÏ·×¼±¸×´Ì¬
auto State PendingMatch
{

    function Timer()
    {
        local Controller P;
        local int bReady[2];
	    local KFXPlayer fxPlayer;

        Global.Timer();

        // Ã»ÓÐÈË¼ÓÈë·µ»Ø
        if ( NumPlayers == 0 )
        {
            return;
		}

        if( bTeamsMustBeReady )
        {
            if( TimeGameInPending < 0.2 )
                TimeGameInPending = Level.TimeSeconds;

            if( GetTeamPlayerRP(0) == none || GetTeamPlayerRP(1) == none )
            {

                if( Level.TimeSeconds - TimeGameInPending > 30 )
                {
                    GotoState('MatchOver');
                }
                return;
            }
        }

        bReady[0] = 1;
        bReady[1] = 1;

        if ( !bStartedCountDown && ( bTeamsMustBeReady || (Level.NetMode == NM_Standalone)) )
        {
            for (P=Level.ControllerList; P!=None; P=P.NextController )
                if ( P.IsA('PlayerController') && (P.PlayerReplicationInfo != None)
                    && P.bIsPlayer && P.PlayerReplicationInfo.bWaitingPlayer
                    && !P.PlayerReplicationInfo.bReadyToPlay )
                    {
                        fxPlayer = KFXPlayer( P );
                        bReady[ fxPlayer.PlayerReplicationInfo.Team.TeamIndex ] = 0;
                    }
        }


        if ( bReady[0]>0 && bReady[1]>0 )
        {
			bStartedCountDown = true;
            if ( nStartCountDown <= 0 )
                StartMatch();
            else
                nStartCountDown--;

        }
        if( bStartedCountDown )
        {
    		PlayStartupMessage( nStartCountDown );

            ;
        }
    }

}

state MatchOver
{

   function StatTeamSpoint()
   {
        // »ñÊ¤¶ÓÎé»ý·ÖºÍ   Ã¿³¡ÓÎÏ·»ý·Ö= ¡Æ Ã¿¸öÍæ¼ÒÌá¹©µÄ»ý·Ö
        local int SpointWinSum;
        // »ñ°Ü¶ÓÎé»ý·ÖºÍ   Ã¿³¡ÓÎÏ·»ý·Ö= ¡Æ Ã¿¸öÍæ¼ÒÌá¹©µÄ»ý·Ö
        local int SpointLoseSum;

        local Controller P;
         for ( P = Level.ControllerList; P!=None; P=P.nextController )
         {

                if(GetGRI().Winner ==  P.PlayerReplicationInfo.Team)
                {
                     SpointWinSum += (Level.TimeSeconds -  KFXPlayer(P).KFXPlayerLoginTime )/60*1.5 ;
                }else if(GetGRI().Winner == none)
                {
                  SpointWinSum += (Level.TimeSeconds -  KFXPlayer(P).KFXPlayerLoginTime )/60*1.5 ;
                  SpointLoseSum += (Level.TimeSeconds -  KFXPlayer(P).KFXPlayerLoginTime )/60*1.5;
                }else
                {
                  SpointLoseSum += (Level.TimeSeconds -  KFXPlayer(P).KFXPlayerLoginTime )/60*0.5  ;
                }
          }
        KFXAgent.KFXFactionEndGameInfo[0].m_iCurPointAdd = SpointWinSum;
        KFXAgent.KFXFactionEndGameInfo[0].m_iGameTicketAdd = SpointWinSum/10;
        KFXAgent.KFXFactionEndGameInfo[0].m_iMmrAdd = SpointWinSum*2;
        if(GetGRI().Winner != none)
        {
            KFXAgent.KFXFactionEndGameInfo[0].m_uiGameResult = 1 ;
            KFXAgent.KFXFactionEndGameInfo[0].m_uiTeamType = KFXTeamInfo(GetGRI().Winner).TeamIndex;
        }else
        {   KFXAgent.KFXFactionEndGameInfo[0].m_uiGameResult = 2;
            KFXAgent.KFXFactionEndGameInfo[0].m_uiTeamType = KFXTeams[0].TeamIndex;
        }

                log( "KFXAgent.KFXFactionEndGameInfo[0].m_iCurPointAdd"@KFXAgent.KFXFactionEndGameInfo[0].m_iCurPointAdd@
             "KFXAgent.KFXFactionEndGameInfo[0].m_iGameTicketAdd"@KFXAgent.KFXFactionEndGameInfo[0].m_iGameTicketAdd@
             "KFXAgent.KFXFactionEndGameInfo[0].m_iMmrAdd"@KFXAgent.KFXFactionEndGameInfo[0].m_iMmrAdd@
             "KFXAgent.KFXFactionEndGameInfo[0].m_uiGameResult"@KFXAgent.KFXFactionEndGameInfo[0].m_uiGameResult@
             "KFXAgent.KFXFactionEndGameInfo[0].m_uiTeamType"@KFXAgent.KFXFactionEndGameInfo[0].m_uiTeamType);

        KFXAgent.KFXFactionEndGameInfo[1].m_iCurPointAdd = SpointLoseSum;
        KFXAgent.KFXFactionEndGameInfo[1].m_iGameTicketAdd = SpointLoseSum/10;
        KFXAgent.KFXFactionEndGameInfo[1].m_iMmrAdd = SpointLoseSum*2;

        if(GetGRI().Winner != none)
        {
            KFXAgent.KFXFactionEndGameInfo[1].m_uiGameResult = 3;
            KFXAgent.KFXFactionEndGameInfo[1].m_uiTeamType = GetOtherTeam(KFXTeamInfo(GetGRI().Winner).TeamIndex).TeamIndex;
        }else
        {   KFXAgent.KFXFactionEndGameInfo[1].m_uiGameResult = 2;
            KFXAgent.KFXFactionEndGameInfo[1].m_uiTeamType = KFXTeams[1].TeamIndex;
        }

                log( "KFXAgent.KFXFactionEndGameInfo[1].m_iCurPointAdd"@KFXAgent.KFXFactionEndGameInfo[1].m_iCurPointAdd@
             "KFXAgent.KFXFactionEndGameInfo[1].m_iGameTicketAdd"@KFXAgent.KFXFactionEndGameInfo[1].m_iGameTicketAdd@
             "KFXAgent.KFXFactionEndGameInfo[1].m_iMmrAdd"@KFXAgent.KFXFactionEndGameInfo[1].m_iMmrAdd@
             "KFXAgent.KFXFactionEndGameInfo[1].m_uiGameResult"@KFXAgent.KFXFactionEndGameInfo[1].m_uiGameResult@
             "KFXAgent.KFXFactionEndGameInfo[1].m_uiTeamType"@KFXAgent.KFXFactionEndGameInfo[1].m_uiTeamType);

   }
}

// ÊØ»¤ºËÐÄ
function KFXGameCore()
{
    local int i, j;
    local Controller P;
    local KFXPlayer PlayerT0, PlayerT1;

    if( KFXAgent != none )
    {
        for( P = Level.ControllerList; KFXPlayer(P) != none; P = P.nextController )
        {
            //ÅÐ¶ÏÍæ¼ÒµÄRPIÐÅÏ¢ÊÇ·ñÒÑ¾­¶ªÊ§------Ô­Òò²¢Î´ÕÒµ½
            if (IsKillPlayer(KFXPlayer(P)))
            {
     			log("Destroy Controller for TeamGame PRI  Is None "$"Player Name Is :"$P.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(P).fxDBPlayerInfo.PlayerID);

                P.Destroy();
                log("TeamGame Find Player PRI is none or Team is none"$P.PlayerReplicationInfo$P.PlayerReplicationInfo.PlayerName);
                continue;
            }
            // ÅÐ¶Ï0¶Ó
            if( P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex == 0 )
            {
                PlayerT0 = KFXPlayer(P);

                i++;
            }
            // ÅÐ¶Ï1¶Ó
            else if( P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex == 1)
            {
                PlayerT1 = KFXPlayer(P);

                j++;
            }
        }

        // Ã»ÓÐÈËÖ±½Ó½áÊøÓÎÏ·
        if( i == 0 && j == 0 )
        {
            KFXCallGameEnd();
        }
        // À¼·½Ã»ÓÐÈË
        else if( i == 0 && j > 0 )
        {
            EndGame(PlayerT1.PlayerReplicationInfo, "NoEnemy");
        }
        // ºì·½Ã»ÓÐÈË
        else if( i > 0 && j == 0 )
        {
            EndGame(PlayerT0.PlayerReplicationInfo, "NoEnemy");
        }
    }
}
//-----------------------------------------------------------

//-----------------------------------------------------------
// Ä¬ÈÏÊôÐÔ
//-----------------------------------------------------------

defaultproperties
{
     KFXTeamClass="KFXGame.KFXTeamInfo"
     bScoreTeamKills=是
     TeamAIType(0)=Class'UnrealGame.TeamAI'
     TeamAIType(1)=Class'UnrealGame.TeamAI'
     bTeamGame=是
     ScoreBoardType="KFXGame.KFXGameScoreBoard"
     GameReplicationInfoClass=Class'KFXGame.KFXGameReplicationInfo'
     GameName="TeamGame"
}
