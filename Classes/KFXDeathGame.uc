//-----------------------------------------------------------
//  Class:      KFXGame.KFXDeathGame
//  Creator:    zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-03-26
//  Desc:       FOX��Ŀ������Ϸģʽ
//  Update:
//  Special:    ��������οƮ��
//-----------------------------------------------------------

class KFXDeathGame extends KFXGameInfo
	config(kfxgame_death);

// ������Ҫ����һЩ��Դ

// ���ñ�������������KFXGameReplicationInfo��KFXPlayerReplicationInfo��

//-----------------------------------------------------------
// ��������ñ���
//-----------------------------------------------------------
var localized string lUpgradeExp;

//-----------------------------------------------------------
// ���岻�����ñ���
//-----------------------------------------------------------
var int nStartCountDown;                        // ��ʼ�ĵ���ʱ
//var string VoiceReplicationInfoType;            // ����ͬ��

var float  KFXGameStartMatchTime;               //��Ϸ�ڿ�ʼ������ʱ��
var array<WeapPickupBase> WeapPickBases;
var float  PickupRespawnTime;
//-----------------------------------------------------------
// event����
//-----------------------------------------------------------
event PreBeginPlay()
{
    super.PreBeginPlay();
}

event PlayerController Login
(
    string Portal,
    string Options,
    out string Error
)
{
    local PlayerController  fxPlayerController;

    fxPlayerController = super.Login(Portal,Options,Error);

	if( fxPlayerController != none )
    {
        // ���¾��������ֵ
        UpdataExp(fxPlayerController);
    }

    return fxPlayerController;
}
//-----------------------------------------------------------


//-----------------------------------------------------------
// function����
//-----------------------------------------------------------

// GRIת��
function  KFXGameReplicationInfo GetGRI()
{
    return KFXGameReplicationInfo(GameReplicationInfo);
}

// �������
function RestartPlayer( Controller aPlayer )
{
    super.RestartPlayer(aPlayer);

    // ����״̬
    KFXPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).bDeadStatus = false;

    // ��¼ʱ��
    KFXPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).fxRestartTime = Level.TimeSeconds;
}

// ���¾���ֵ
//function UpdataExp(Controller Killer) {}

// ���㹱�׶�
function UpdateContribution(PlayerReplicationInfo PlayerRP);

// ���ɱ
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
	local float ArmorPct;
	log("[LABOR]--------reduce damage!"@injured@DamageType);
    if(KFXVehiclesBase(injured)!=none)
	{
        Damage = KFXVehiclesBase(injured).KFXHixBoxDmg(Damage, KFXVehiclesBase(injured).KFXDmgInfo.HitBoxID);
	}
    else if(KFXPawn(injured)!=none)
    {
        // ���׼���
        if ( instigatedBy == none )
        {
            ArmorPct = 1;
        }
        else
        {
            ArmorPct =  KFXPawn(injured).KFXDmgInfo.ArmorPct;
        }
        if( DamageType != class'Fell'  )
            Damage = KFXPawn(injured).KFXArmorAbsorbDmg(Damage, KFXPawn(injured).KFXDmgInfo.HitBoxID );
	    Damage = KFXPawn(injured).KFXHixBoxDmg(Damage, KFXPawn(injured).KFXDmgInfo.HitBoxID, instigatedBy);
    }

	// �ж��Ƿ�������״̬
    if( injured != none )
    {
        if( KFXPlayerReplicationInfo(injured.PlayerReplicationInfo).bSuperState) //���ʺ���GM
        {
            return 0;
        }
        if( KFXPlayerReplicationInfo(injured.PlayerReplicationInfo).bSpecMode )
        {
            return Damage * FRand();
        }
    }

	return Super.ReduceDamage( Damage, injured, instigatedBy, HitLocation, Momentum, DamageType );
}

//Ҫ��ǰһִ֡�У�����Pawn��������
function CalcKillInfoPreTick(Controller Killer,Pawn KilledPawn)
{
    local KFXPlayerReplicationInfo fxPRI;

    if( Killer != none )
    {
        fxPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }

    if( fxPRI != none )
    {
        if( KilledPawn != none )
        {
            // �жϵ�ɱ**����ط����ĸ���?
            fxPRI.fxDaggerKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);

            // �ж�ɱ��
            if ( KFXPawn(KilledPawn).bSpecialRoleState )
            {
                fxPRI.fxSpecKillNum++;
            }

            fxPRI.fxProjectileKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);
            // �жϱ�ͷ
//            log("KFXDeathGame--------KFXPawn(KilledPawn).KFXDmgInfo.HitBoxID "$KFXPawn(KilledPawn).KFXDmgInfo.HitBoxID);
            if ( KFXPawn(KilledPawn).KFXDmgInfo.HitBoxID == 2 )
            {
                fxPRI.fxHeadKillNum++;
                fxPRI.bHeadKill = true;
            }
            else
            {
                fxPRI.bHeadKill = false;
            }
//            log("fxPRI.fxHeadKillNum "$fxPRI.fxHeadKillNum);
        }
    }
}
// ��������
function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
    local KFXPlayerReplicationInfo fxPRI;

    // �ҵ�����������
    super.Killed(Killer, Killed, KilledPawn, damageType);

    if( Killer != none )
    {
        fxPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }

    if( fxPRI != none )
    {
        if( KilledPawn != none )
        {
            // �жϵ�ɱ**����ط����ĸ���?
            fxPRI.fxDaggerKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);

            // �ж�ɱ��
            if ( KFXPawn(KilledPawn).bSpecialRoleState )
            {
                fxPRI.fxSpecKillNum++;
            }

            fxPRI.fxProjectileKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);
            // �жϱ�ͷ
            if ( KFXPawn(KilledPawn).KFXDmgInfo.HitBoxID == 2 )
            {
                fxPRI.fxHeadKillNum++;
                fxPRI.bHeadKill = true;
            }
            else
            {
                fxPRI.bHeadKill = false;
            }
        }
    }

    // ���㾭��ֵ
    if( Killer != none && Killer.bIsPlayer )
    {
        UpdataExp(Killer);
    }
    if( Killed != none && Killed != Killer && Killed.bIsPlayer )
    {
        UpdataExp(Killed);
    }
}

function ServerKilledPostTick( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
    local KFXPlayerReplicationInfo fxPRI;

    // �ҵ�����������
    super.ServerKilledPostTick(Killer, Killed, KilledPawn, damageType);

    /*if( Killer != none )
    {
        fxPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }

    if( fxPRI != none )
    {
        if( KilledPawn != none )
        {
            // �жϵ�ɱ**����ط����ĸ���?
            fxPRI.fxDaggerKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);

            // �ж�ɱ��
            if ( KFXPawn(KilledPawn).bSpecialRoleState )
            {
                fxPRI.fxSpecKillNum++;
            }

            fxPRI.fxProjectileKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);
            // �жϱ�ͷ
            if ( KFXPawn(KilledPawn).KFXDmgInfo.HitBoxID == 2 )
            {
                fxPRI.fxHeadKillNum++;
                fxPRI.bHeadKill = true;
            }
            else
            {
                fxPRI.bHeadKill = false;
            }
        }
    }*/
    // ���㾭��ֵ
    if( Killer != none && Killer.bIsPlayer )
    {
        UpdataExp(Killer);
    }
    if( Killed != none && Killed != Killer && Killed.bIsPlayer )
    {
        UpdataExp(Killed);
    }
}

// Ѱ�����������
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
    local NavigationPoint N, BestStart;
    local float BestRating, NewRating;
    local byte Team;
    local Pawn A;
    local float fRadius;
    local bool bFoundCollide;

    // ��������ڶ���**�޶���255
    if ( Player != None && Player.PlayerReplicationInfo != None )
    {
        if ( Player.PlayerReplicationInfo.Team != None )
        {
            if( KFXPlayer(Player) != none )
            {
                Team = KFXPlayer(Player).GetPlayerRealTeamNum();
            }
            else
                Team = Player.PlayerReplicationInfo.Team.TeamIndex;
        }
        else
        {
            Team = InTeam;
        }
    }
    else
    {
        Team = InTeam;
    }

    // �������е�ͼ�����������㣬ѡ��һ����ѵ�
    for ( N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint )
    {
        if ( PlayerStart(N) == none
        || ( PlayerStart(N).TeamNumber != Team /*&& PlayerStart(N).TeamNumber != 255*/ ) )
        {
            continue;
        }

        fRadius = FMax(N.CollisionRadius, 80.0);

        // �жϸõ��Ƿ�����
        bFoundCollide = false;
        foreach N.CollidingActors(class'Pawn', A, fRadius)
        {
            bFoundCollide = true;
            break;
        }
        if ( bFoundCollide ) continue;

        // ѡ��һ�����ŵ�
        NewRating = RatePlayerStart(N, Team, Player);

        if ( NewRating > BestRating )
        {
           BestRating = NewRating;
           BestStart = N;
        }
    }

    /*
    // ����ѡ��**��֤�ܳ���
    if ( BestStart == none )
    {
        for ( N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint )
        {
            if ( PlayerStart(N) == none
            || ( PlayerStart(N).TeamNumber != Team && PlayerStart(N).TeamNumber != 255 ) )
            {
                continue;
            }

            fRadius = FMax(N.CollisionRadius, 80.0);

            // �жϸõ��Ƿ�����
            foreach N.VisibleCollidingActors(class'Actor', A, fRadius)
            {
                 continue;
            }

            BestStart = N;

            if( BestStart != none )
            {
                break;
            }
        }
    }
    */

    if ( BestStart == none )
    {
        log("[FindPlayerStart] Error: Can't Find a PlayerStart !");
    }

    return BestStart;
}
// ��Ϸ������Ĵ���
function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;
	local KFXPlayer Player;
	local int nLevel;///<����
    local int WinnerTeamID;///<ʤ���ߵ�ս��id
    local int GameCash;
    local int MVPWeapon;
    local int nWinSpoint;
    local int nLostSpoint;
    local int ACEWeapID;
    local int CurExp;
    local string PlayerName;
    log("[KFXDeathGame] SetEndGameFocus");

	for ( P=Level.ControllerList; P!=None; P=P.nextController )
	{
        if( GetGRI().Winner!=none && GetGRI().Winner ==  P.PlayerReplicationInfo.Team )
            WinnerTeamID = KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxBattleTeamID;
        else
            WinnerTeamID = 0;

        KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxWinnerTeamID = WinnerTeamID;
        UpdataExp(P);
        UpdateBattleTeamWinAndLostPoint(P,Winner);
        //<< wangkai
        if( GetGRI().Winner == none )
        {
            //KFX_DEUCE
            KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxGameResult = 2;
            nLevel = 1;
        }
        else if ( GetGRI().Winner ==  P.PlayerReplicationInfo.Team )
        {
            //KFX_VICTORY
            KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxGameResult = 1;
            nLevel = 0;
        }
        else
        {
            //KFX_DEFEATED
            KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxGameResult = 3;
            nLevel = 2;
        }

        //<<������ ��������� ����KFXBot
        if( KFXPlayer(P) != none )
        //<<
        UpdateGameCash(KFXPlayer(P));
        //>>

    	Player = KFXPlayer(P);
    	if ( Player != None )
    	{
    		Player.ClientSetBehindView(true);
    		//��ʱ��ʾACE����
    		Player.StopOtherWeaponUsedInfo();
            ACEWeapID = Player.GetLastACEWeapon();

             KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).ACEWeapon = ACEWeapID;

            //��Ϸ�������������ͻ��˷������� MVP����
            GameCash = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxGameCash;
            nWinSpoint = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxWinSpoint;
            nLostSpoint = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxLostSpoint;
            CurExp   = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxCurrExp;
            PlayerName = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).PlayerName;
            log("KFXDeathGame------PlayerName :"$PlayerName
                                   $"ACEWeapID "$ACEWeapID
                                   $"GameCash :"$GameCash
                                   $"CurExp :"$CurExp);

            //ִ��ClientGameEndedProcess֮ǰ�Ÿոռ�����������UpdateGameCash��������������ͬһ֡��
			//����ͬ����ʱ�򣬲�һ��˭��˭������Ҫô�Ժ����������ݹ�ȥ��Ҫô����ǰ���㣬�������������ɱ�˵�ʱ��ͼ��㡣
            if( !Player.IsInState('GameEnded') )
                Player.ClientGameEndedProcess(nLevel,GameCash,
                			KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxGameCash_Netbar,
							nWinSpoint,nLostSpoint,ACEWeapID,CurExp);
			Player.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;   //����������������һ֡������һ��

    	}
    	P.GameHasEnded();
	}
}

// ��ʼ�ĵ���ʱ��Ϣ
function PlayStartupMessage(int nCountDown)
{
	local Controller P;

    for ( P = Level.ControllerList; P != None; P = P.NextController )
    {
        if ( KFXPlayer(P) != None )
        {
            KFXPlayer(P).PlayStartUpMessage(nCountDown);
        }
    }
}

// ���������
function KFXLevelup()
{
    local Controller P;
    local KFXPlayer Player;

    for( P = Level.ControllerList; P != none; P = P.nextController )
    {
        Player = KFXPlayer(P);

        if( Player != none && KFXCheckLevelup(Player) )
        {
            KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).bLevelup = true;
        }
    }
}

// ��ⵥ��Player
function bool KFXCheckLevelup(KFXPlayer Player)
{
    local int nExp;
    local KFXCSVTable fxLevelCsv;

    fxLevelCsv  = class'KFXTools'.static.KFXCreateCSVTable("LevelUpgradeTable.csv");

    if ( fxLevelCsv == none )
    {
        return false;
    }

    if( !fxLevelCsv.SetCurrentRow(Player.fxDBPlayerInfo.nLevel) )
    {
        return false;
    }

    nExp = fxLevelCsv.GetInt("HonorUpgrade");

    if( KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxCurrExp > nExp )
    {
        return true;
    }

    return false;
}

// ��ʼ����
function StartMatch()
{
    log("[zjpwxh]Call StartMatch");

    if( nGameState != EGameState.EGameState_MatchInProgress )
    {
        KFXGameStartTime = Level.TimeSeconds;
        KFXGameStartMatchTime = Level.TimeSeconds;
        GotoState('MatchInProgress');
    }

    Super.StartMatch();
}

// �ػ�����
function KFXGameCore() {}

function bool IsKillPlayer(KFXPlayer Player)
{
	if (Player.PlayerReplicationInfo == none)
	{
		return true;
	}
	else if (!KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).bSpectatorView && Player.PlayerReplicationInfo.Team == none)
	{     //TeamΪNONE ��ǰ����벻�ǹ۲���ģʽ����
		return true;
	}

	return false;
}

// ��Ϸ׼��״̬
auto State PendingMatch
{
	function RestartPlayer( Controller aPlayer )
    {
        if( Level.NetMode == NM_Standalone )
        {
            global.RestartPlayer(aPlayer);
        }
        else if( nStartCountDown <= 0 )
        {
            if( KFXPlayer(aPlayer)==none || KFXPlayer(aPlayer).bRequairLogInGame )
                Global.RestartPlayer(aPlayer);
        }
    }

    function Timer()
    {
        Global.Timer();
        log("DeathGame-------NumPlayers : "$NumPlayers);
        // û���˼��뷵��
        if ( NumPlayers == 0 )
        {
            return;
		}

		PlayStartupMessage(nStartCountDown);

        nStartCountDown--;

        ;

        if( nStartCountDown <= 0 )
        {
            StartMatch();
        }
    }
    function Beginstate()
    {
        log("[zjpwxh]PendingMatch State");

        nGameState = EGameState.EGameState_PendingMatch;
    }
}

// ��Ϸ״̬
state MatchInProgress
{
    function RestartPlayer( Controller aPlayer )
    {
        //log("GameInfo RestartPlayer -------");
        if( (KFXPlayer(aPlayer)==none || KFXPlayer(aPlayer).bRequairLogInGame) )
        {
            Global.RestartPlayer(aPlayer);
        }
    }

    function Timer()
    {
        local Controller P;

        Global.Timer();

        // ��ʱ�������Ϸ
        if ( bOverTime )
        {
			EndGame(None,"TimeLimit");
		}
		// �ı��ʱ��
        else if ( GetGRI().fxTimeLimit > 0 )
        {
            GetGRI().bStopCountDown = false;
            GetGRI().fxRemainingTime--;

            // ÿ����ͬ��һ��
            if ( GetGRI().fxRemainingTime % 60 == 0 )
            {
                GetGRI().fxRemainingFix = GetGRI().fxRemainingTime;

                // �ж�һ���Ƿ��������״��(���˽���)
                KFXGameCore();
            }

            if ( GetGRI().fxRemainingTime <= 0 )
            {
                EndGame(None,"TimeLimit");
            }
        }

        GetGRI().fxElapsedTime++;

        // �ж�����״̬
        for ( P=Level.ControllerList; P!=None; P=P.nextController )
		{
		    //<<������ ��������� ����KFXBot
            //if ( (P.PlayerReplicationInfo != None) && !P.PlayerReplicationInfo.bOutOfLives )
            if ( PlayerController(P) != none && (P.PlayerReplicationInfo != None) && !P.PlayerReplicationInfo.bOutOfLives )
            //>>
			{
				// �޵�״̬
                if( KFXPlayerReplicationInfo(P.PlayerReplicationInfo).bSuperState
                    && Level.TimeSeconds - KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxRestartTime
						> GetGRI().fxSuperLimit + KFXPlayer(P).KFXGetSuitSuperTime()
                        && P.Pawn != none)
				{
				    KFXPlayerReplicationInfo(P.PlayerReplicationInfo).bSuperState = false;
				    KFXPawn(P.Pawn).KFXSetGodMode(false);
                }

                if( Level.TimeSeconds - KFXPlayerReplicationInfo(P.PlayerReplicationInfo).TimeNeedChangeWeapBegin > TimeSpawnWait )
                {
                    if( KFXPlayer(P)==none || !KFXPlayer(P).bRequairLogInGame )
                    {
                        KFXPlayer(P).ClientBeginGame();
                        KFXPlayer(P).bRequairLogInGame = true;
                        ;
                        if( !P.IsInState('RoundEnded') && !P.IsInState('GameEnded') && !KFXPlayerReplicationInfo(P.PlayerReplicationInfo).bSpectatorView)
                        {
                            RestartPlayer(P);
                        }
                     }
                }
                DeathTimer( PlayerController(P) );
			}
		}
    }

    function Beginstate()
    {
		local KFXPlayerReplicationInfo fxPRI;

		foreach DynamicActors(class'KFXPlayerReplicationInfo',fxPRI)
		{
			fxPRI.StartTime = 0;
//			if(fxPRI.bSpectatorView == true)
//            {
//                  if(!KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle)
//                  {
//                      KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle = true;
//                  }
//                  if(!KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle)
//                  {
//                      KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle = true;
//                  }
//                  log("KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle: "$KFXGameReplicationInfo(GameReplicationInfo).bEnableEnemyAngle);
//                  log("KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle: "$KFXGameReplicationInfo(GameReplicationInfo).bEnableThirdAngle);
//            }

		}

		GetGRI().ElapsedTime = 0;

		// ֱ��RestartPlayer
        bDelayedStart = false;
		bWaitingToStartMatch = false;

		nGameState = EGameState.EGameState_MatchInProgress;

        log("[zjpwxh]MatchInProgres State"$Level.TimeSeconds);
    }
}

function DeathTimer( PlayerController P )
{
}
function StatTeamSpoint();
// ����״̬
state MatchOver
{
	//-----------------------------------------------------
    // ����״̬���޷�ִ�����²���
	//-----------------------------------------------------
    function RestartPlayer( Controller aPlayer ) {}
	function ScoreKill(Controller Killer, Controller Other) {}

    function float ReduceDamage( float Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
	{
		return 0;
	}
	function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
	{
		return false;
	}
	//-----------------------------------------------------
    function PreCallGameEnd();
    // Timer����
    function Timer()
    {
        local Controller P;
        local array<KFXBot> BotArray;
        local int i;
        local int cnt;
        local bool find;


        Global.Timer();

		log("[LABOR]----------------match over!"@Level.TimeSeconds@EndTime
				@GetGRI().fxRestartDelay/2@EndGameSignal);

        // ��������
        KFXLevelup();

		//���������ˢ����
		if((Level.TimeSeconds > EndTime + GetGRI().fxRestartDelay/2) && EndGameSignal == 0)
		{
            StatTeamSpoint();
            cnt = 0;
        	for ( P = Level.ControllerList; P!=None; P=P.nextController )
        	{
                // updateExp
                UpdataExp(P);
                //<<������ ��������� ��ֹ�����˻�д����
                RefalshData(P);
                cnt++;
			}

			//����һ��bug�������Ҹս�����Ϸ����Ϸ�ͽ����ˣ���ô�����KFXPlayerû�г�ʼ�����
            //������Ҳ������ControllerList�б��С����������ҵ���Ϣ��Щ�Ǵ����
            if(KFXAgent.Players.Length != cnt)
            {
				for(i=0; i<KFXAgent.Players.length; i++)
            	{
   			        find = false;
		        	for ( P = Level.ControllerList; P!=None; P=P.nextController )
					{
						if(KFXPlayerReplicationInfo(p.PlayerReplicationInfo).fxPlayerDBID == KFXAgent.Players[i].PlayerID)
						{
							find = true;
							break;
						}
					}
					if(!find)
					{
						KFXAgent.Players[i].MissionBlock.Missions.Length = 0;
						log("#### WARNING #### can't find this player, id="$KFXAgent.Players[i].PlayerID
								@"name="$KFXAgent.Players[i].PlayerName);
					}
				}
            }

            EndGameSignal = 1;
		    if ( KFXAgent != none )
		        KFXAgent.KFXEndGame();
		}

        // �ӳ�һ��ʱ��������Ϸ
        if ( (Level.TimeSeconds > EndTime + GetGRI().fxRestartDelay) )
        {
        	log("[LABOR]-----------call game end="$bCallGameEnd@Level.ControllerList);
            // ����ģʽ
            if ( !bCallGameEnd )
            {
            	if(EndGameSignal == 0)
	                StatTeamSpoint();
                // ��д����**�ÿͻ��˶Ͽ�����
                for ( P = Level.ControllerList; P!=None; P=P.nextController )
                {
                    if(KFXBot(P) != none)
                    {
                        BotArray[BotArray.Length] = KFXBot(P);
                        continue;
                    }
                    if( KFXPlayer(P) == none ) continue;
                    /*
                    if( GetGRI().Winner == none )
                    {
                        //KFX_DEUCE
                        KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxGameResult = 2;
                    }
                    else if( GetGRI().Winner ==  P.PlayerReplicationInfo.Team )
                    {
                        //KFX_VICTORY
                        KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxGameResult = 1;
                    }
                    else
                    {
                        //KFX_DEFEATED
                        KFXPlayerReplicationInfo(P.PlayerReplicationInfo).fxGameResult = 3;
                    }
                    */

					if(EndGameSignal == 0)
					{
                    	// updateExp
                    	UpdataExp(P);
                   		//<<������ ��������� ��ֹ�����˻�д����
                    	RefalshData(P);
                    	AfterRefreshData(KFXPlayer(P));
					}
					log("Destroy Controller for Game Over "$"Player Name Is :"$P.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(P).fxDBPlayerInfo.PlayerID);
                    P.Destroy();

                    log("---------------KFXPlayer...Destroy!!!");
                }
                for ( i=0; i<BotArray.length; i++ )
                {
                    //log("---------------KFXBot...Destroy!!!");
                    BotArray[i].Destroy();
                }


                KFXCallGameEnd();
            }
            else if( !bGameRestarted )
            {
                RestartGame();
            }
        }
	}

    function BeginState()
    {
    	//Ϊ�˷�ֹ����winnerΪ�յ����,���������ƽ��winner��ֵ,�ͻ����ж���ͬ
		if( GetGRI().Winner == none )
		{
		    if(GetGRI().ReWinOnDraw == 1)
            {
                //Ĭ������ʤ��,��ô�����;�����ˣ������ڵ����ӣ�����ԭ�������ӣ���ʱ����ԭ�������Ӱ�
                GetGRI().bBlueWinOnDraw = true;
                GetGRI().Winner = GetGRI().Teams[0];
            }
            else if(GetGRI().ReWinOnDraw == 2)
            {
                GetGRI().bRandWinner = true;
                if((Rand(10)+level.Second)%2 == 0)
                {
                    GetGRI().Winner = GetGRI().Teams[0];
                }
                else
                {
                    GetGRI().Winner = GetGRI().Teams[1];
                }
            }
            else
            {
                GetGRI().Winner = level;
            }
		}

		// ֹͣ����ʱ
        GetGRI().bStopCountDown = true;

        nGameState = EGameState.EGameState_MatchOver;

        log("[zjpwxh]MatchOver State at:"$Level.TimeSeconds);
	}
}

function FindWeapPickupBase()
{
	local WeapPickupBase A;
	local int loop;
	loop=0;
	
	foreach AllActors(class'WeapPickupBase',A)
	{
		WeapPickBases[loop]=A;
		loop++;
	}
	;
}

function SpawnPickupFromBase()
{
	local int loop;
	local KFXGameReplicationInfo localGRI;
	
	log("SpawnPickupFromBase");
	
	localGRI = GetGRI();
	
	for(loop=0; loop < WeapPickBases.Length; loop++)
	{
		if(WeapPickBases[loop].myPickUp != none)
			WeapPickBases[loop].myPickUp.Destroy();
		WeapPickBases[loop].SpawnPickup();
	}
}
//-----------------------------------------------------------

//-----------------------------------------------------------
// Ĭ������
//-----------------------------------------------------------

defaultproperties
{
}
