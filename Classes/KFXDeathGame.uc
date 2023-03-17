//-----------------------------------------------------------
//  Class:      KFXGame.KFXDeathGame
//  Creator:    zhangjinpin@kingsoft 张金品
//  Data:       2007-03-26
//  Desc:       FOX项目死亡游戏模式
//  Update:
//  Special:    剑胆琴心慰飘零
//-----------------------------------------------------------

class KFXDeathGame extends KFXGameInfo
	config(kfxgame_death);

// 可以需要载入一些资源

// 配置变量都定义在了KFXGameReplicationInfo和KFXPlayerReplicationInfo中

//-----------------------------------------------------------
// 定义可配置变量
//-----------------------------------------------------------
var localized string lUpgradeExp;

//-----------------------------------------------------------
// 定义不可配置变量
//-----------------------------------------------------------
var int nStartCountDown;                        // 开始的倒计时
//var string VoiceReplicationInfoType;            // 语音同步

var float  KFXGameStartMatchTime;               //游戏内开始比赛的时间
var array<WeapPickupBase> WeapPickBases;
var float  PickupRespawnTime;
//-----------------------------------------------------------
// event部分
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
        // 更新经验和荣誉值
        UpdataExp(fxPlayerController);
    }

    return fxPlayerController;
}
//-----------------------------------------------------------


//-----------------------------------------------------------
// function部分
//-----------------------------------------------------------

// GRI转型
function  KFXGameReplicationInfo GetGRI()
{
    return KFXGameReplicationInfo(GameReplicationInfo);
}

// 玩家重生
function RestartPlayer( Controller aPlayer )
{
    super.RestartPlayer(aPlayer);

    // 死亡状态
    KFXPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).bDeadStatus = false;

    // 记录时间
    KFXPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).fxRestartTime = Level.TimeSeconds;
}

// 更新经验值
//function UpdataExp(Controller Killer) {}

// 计算贡献度
function UpdateContribution(PlayerReplicationInfo PlayerRP);

// 随便杀
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
        // 护甲计算
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

	// 判断是否处于特殊状态
    if( injured != none )
    {
        if( KFXPlayerReplicationInfo(injured.PlayerReplicationInfo).bSuperState) //此帐号是GM
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

//要求前一帧执行，否则Pawn就销毁了
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
            // 判断刀杀**这个地方用哪个表?
            fxPRI.fxDaggerKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);

            // 判断杀猪
            if ( KFXPawn(KilledPawn).bSpecialRoleState )
            {
                fxPRI.fxSpecKillNum++;
            }

            fxPRI.fxProjectileKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);
            // 判断爆头
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
// 死亡处理
function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
    local KFXPlayerReplicationInfo fxPRI;

    // 找到死亡的种类
    super.Killed(Killer, Killed, KilledPawn, damageType);

    if( Killer != none )
    {
        fxPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }

    if( fxPRI != none )
    {
        if( KilledPawn != none )
        {
            // 判断刀杀**这个地方用哪个表?
            fxPRI.fxDaggerKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);

            // 判断杀猪
            if ( KFXPawn(KilledPawn).bSpecialRoleState )
            {
                fxPRI.fxSpecKillNum++;
            }

            fxPRI.fxProjectileKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);
            // 判断爆头
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

    // 计算经验值
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

    // 找到死亡的种类
    super.ServerKilledPostTick(Killer, Killed, KilledPawn, damageType);

    /*if( Killer != none )
    {
        fxPRI = KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }

    if( fxPRI != none )
    {
        if( KilledPawn != none )
        {
            // 判断刀杀**这个地方用哪个表?
            fxPRI.fxDaggerKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,9);

            // 判断杀猪
            if ( KFXPawn(KilledPawn).bSpecialRoleState )
            {
                fxPRI.fxSpecKillNum++;
            }

            fxPRI.fxProjectileKillNum = GetPRIDataByID(fxPRI,fxPRI.REP_WEAPONKILL,11);
            // 判断爆头
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
    // 计算经验值
    if( Killer != none && Killer.bIsPlayer )
    {
        UpdataExp(Killer);
    }
    if( Killed != none && Killed != Killer && Killed.bIsPlayer )
    {
        UpdataExp(Killed);
    }
}

// 寻找人物出生点
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
    local NavigationPoint N, BestStart;
    local float BestRating, NewRating;
    local byte Team;
    local Pawn A;
    local float fRadius;
    local bool bFoundCollide;

    // 找玩家所在队伍**无队伍255
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

    // 遍历所有地图的所有重生点，选择一个最佳的
    for ( N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint )
    {
        if ( PlayerStart(N) == none
        || ( PlayerStart(N).TeamNumber != Team /*&& PlayerStart(N).TeamNumber != 255*/ ) )
        {
            continue;
        }

        fRadius = FMax(N.CollisionRadius, 80.0);

        // 判断该点是否有人
        bFoundCollide = false;
        foreach N.CollidingActors(class'Pawn', A, fRadius)
        {
            bFoundCollide = true;
            break;
        }
        if ( bFoundCollide ) continue;

        // 选择一个最优点
        NewRating = RatePlayerStart(N, Team, Player);

        if ( NewRating > BestRating )
        {
           BestRating = NewRating;
           BestStart = N;
        }
    }

    /*
    // 二次选择**保证能出来
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

            // 判断该点是否有人
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
// 游戏结束后的处理
function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;
	local KFXPlayer Player;
	local int nLevel;///<局势
    local int WinnerTeamID;///<胜利者的战队id
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

        //<<李威国 机器人相关 兼容KFXBot
        if( KFXPlayer(P) != none )
        //<<
        UpdateGameCash(KFXPlayer(P));
        //>>

    	Player = KFXPlayer(P);
    	if ( Player != None )
    	{
    		Player.ClientSetBehindView(true);
    		//及时显示ACE武器
    		Player.StopOtherWeaponUsedInfo();
            ACEWeapID = Player.GetLastACEWeapon();

             KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).ACEWeapon = ACEWeapID;

            //游戏结束后服务器向客户端发送银币 MVP武器
            GameCash = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxGameCash;
            nWinSpoint = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxWinSpoint;
            nLostSpoint = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxLostSpoint;
            CurExp   = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxCurrExp;
            PlayerName = KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).PlayerName;
            log("KFXDeathGame------PlayerName :"$PlayerName
                                   $"ACEWeapID "$ACEWeapID
                                   $"GameCash :"$GameCash
                                   $"CurExp :"$CurExp);

            //执行ClientGameEndedProcess之前才刚刚计算了银币数UpdateGameCash，这两个函数是同一帧，
			//数据同步的时候，不一定谁先谁后，所以要么以函数参数传递过去，要么就提前计算，比如玩家死亡、杀人的时候就计算。
            if( !Player.IsInState('GameEnded') )
                Player.ClientGameEndedProcess(nLevel,GameCash,
                			KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).fxGameCash_Netbar,
							nWinSpoint,nLostSpoint,ACEWeapID,CurExp);
			Player.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;   //这样可以吗？是在下一帧还是下一秒

    	}
    	P.GameHasEnded();
	}
}

// 开始的倒记时信息
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

// 人物的升级
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

// 检测单个Player
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

// 开始比赛
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

// 守护核心
function KFXGameCore() {}

function bool IsKillPlayer(KFXPlayer Player)
{
	if (Player.PlayerReplicationInfo == none)
	{
		return true;
	}
	else if (!KFXPlayerReplicationInfo(Player.PlayerReplicationInfo).bSpectatorView && Player.PlayerReplicationInfo.Team == none)
	{     //Team为NONE 的前提必须不是观察者模式进入
		return true;
	}

	return false;
}

// 游戏准备状态
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
        // 没有人加入返回
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

// 游戏状态
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

        // 超时则结束游戏
        if ( bOverTime )
        {
			EndGame(None,"TimeLimit");
		}
		// 改变计时器
        else if ( GetGRI().fxTimeLimit > 0 )
        {
            GetGRI().bStopCountDown = false;
            GetGRI().fxRemainingTime--;

            // 每分钟同步一次
            if ( GetGRI().fxRemainingTime % 60 == 0 )
            {
                GetGRI().fxRemainingFix = GetGRI().fxRemainingTime;

                // 判断一下是否存在特殊状况(单人进入)
                KFXGameCore();
            }

            if ( GetGRI().fxRemainingTime <= 0 )
            {
                EndGame(None,"TimeLimit");
            }
        }

        GetGRI().fxElapsedTime++;

        // 判断特殊状态
        for ( P=Level.ControllerList; P!=None; P=P.nextController )
		{
		    //<<李威国 机器人相关 兼容KFXBot
            //if ( (P.PlayerReplicationInfo != None) && !P.PlayerReplicationInfo.bOutOfLives )
            if ( PlayerController(P) != none && (P.PlayerReplicationInfo != None) && !P.PlayerReplicationInfo.bOutOfLives )
            //>>
			{
				// 无敌状态
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

		// 直接RestartPlayer
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
// 结束状态
state MatchOver
{
	//-----------------------------------------------------
    // 结束状态下无法执行如下操作
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
    // Timer触发
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

        // 人物升级
        KFXLevelup();

		//向服务器回刷数据
		if((Level.TimeSeconds > EndTime + GetGRI().fxRestartDelay/2) && EndGameSignal == 0)
		{
            StatTeamSpoint();
            cnt = 0;
        	for ( P = Level.ControllerList; P!=None; P=P.nextController )
        	{
                // updateExp
                UpdataExp(P);
                //<<李威国 机器人相关 阻止机器人回写数据
                RefalshData(P);
                cnt++;
			}

			//存在一个bug，如果玩家刚进入游戏，游戏就结束了，那么会出现KFXPlayer没有初始化完成
            //导致玩家不会出现ControllerList列表中。导致这个玩家的信息有些是错误的
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

        // 延迟一定时间重起游戏
        if ( (Level.TimeSeconds > EndTime + GetGRI().fxRestartDelay) )
        {
        	log("[LABOR]-----------call game end="$bCallGameEnd@Level.ControllerList);
            // 大厅模式
            if ( !bCallGameEnd )
            {
            	if(EndGameSignal == 0)
	                StatTeamSpoint();
                // 回写数据**让客户端断开连接
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
                   		//<<李威国 机器人相关 阻止机器人回写数据
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
    	//为了防止出现winner为空的情况,在这里进行平局winner赋值,客户端判定相同
		if( GetGRI().Winner == none )
		{
		    if(GetGRI().ReWinOnDraw == 1)
            {
                //默认蓝队胜利,那么如果中途换队了，是现在的蓝队，还是原来的蓝队，暂时就是原来的蓝队吧
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

		// 停止倒计时
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
// 默认属性
//-----------------------------------------------------------

defaultproperties
{
}
