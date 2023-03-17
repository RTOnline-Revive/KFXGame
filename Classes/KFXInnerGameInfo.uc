//-----------------------------------------------------------
//  Class:      KFXGame.GameRules
//  Creator:    wangkai1@kingsoft 王凯
//  Data:       2008年12月06日
//  Desc:       嵌入到普通GameInfo中的小游戏GameInfo
//  Update:
//  Special:    想法很简单：游戏中嵌套的小游戏；
//              不太熟悉，照GameInfo的接口定义画了葫芦
//              努力使此类成为所有内嵌小游戏的接口规范
//-----------------------------------------------------------

class KFXInnerGameInfo extends Info
    config(KFXGameRPInfo);

var GameInfo        MainGameInfo;
var array<PlayerController>     CandidateControllerList;    //报名等待者列表
var array<PlayerController>     PlayerControllerList;       //参赛者列表

var string          GameName;

var bool            bStarted;

var config float    TotalGameTime;
var config float    TotalRoundTime;
var config int      TotalRound;
var config int      TotalWinRound;      // 赢得比赛需要局数

var float           StartGameTime;
var float           StartRoundTime;
var int             CurRound;




//初始化游戏
function InitGame( GameInfo InGameInfo, string InGameName, optional out string Error )
{
    MainGameInfo = InGameInfo;
    GameName = InGameName;

    if (GameName == "")
    {
        log ("InnerGame: Invalid game name");
    }
    else
    {
        log ("InnerGame: "@GameName);
        CandidateControllerList.Remove(0, CandidateControllerList.length);
        PlayerControllerList.Remove(0, PlayerControllerList.length);

        log("[Boxing] TotalGameTime"     @ TotalGameTime);
        log("[Boxing] TotalRoundTime"    @ TotalRoundTime);
        log("[Boxing] TotalRound"        @ TotalRound);
        log("[Boxing] TotalWinRound"     @ TotalWinRound);


    }
}

//全局游戏玩家退出
function bool OutterPlayerLogout( PlayerController Player);

//玩家登陆
function bool PlayerLogin( PlayerController NewPlayer );

function PostPlayerLogin( PlayerController NewPlayer );

//玩家登出
function bool PlayerLogout( PlayerController Player );

function PostPlayerLogout( PlayerController NewPlayer );

//用于向每个玩家广播消息
event BroadcastLocalized( actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject );

//更换队伍
function bool ChangeTeam(Controller Other, int N, bool bNewTeam){ return false; }

//检查游戏积分是否达到游戏结束点
function CheckScore(PlayerReplicationInfo Scorer,optional  PlayerReplicationInfo Loser);

//开始游戏
function StartMatch()
{
    Reset();
}

function PostStartMatch();

//结束游戏
function EndGame( PlayerController Winner, string Reason );

//结束小局
function EndRound( PlayerController Winner, string Reason );

function StartRound()
{
    StartRoundTime = Level.TimeSeconds;
    CurRound++;
}

//游戏结束了
function PostGameEnd( PlayerController Winner, string Reason );

//小局结束了
function PostEndRound( PlayerController Winner, string Reason );

//重置
function Reset()
{
    StartGameTime   = Level.TimeSeconds;
    StartRoundTime  = Level.TimeSeconds;
    CurRound        = 1;
}

//重新开玩家
function RestartPlayer( Controller aPlayer );

//由分数触发的事件
function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc);

//由分数触发的事件
function TeamScoreEvent(int Team, float Points, string Desc);

//暂停游戏
function bool SetPause( bool bPause, PlayerController P ){ return false; }

//游戏主流程
function GameLoop(float DeltaTime)
{
    // logic problems, overide me!
    if (Level.TimeSeconds - StartGameTime > TotalGameTime)
        EndGame(None, "GameTimeLimit");
    else if (Level.TimeSeconds - StartRoundTime > TotalRoundTime)
        EndRound(None, "RoundTimeLimit");
    else if (CurRound == TotalRound)
        EndRound(None, "RoundNumLimit");
}

//用于跑游戏主流程 (move to native code ?)
event Tick( float DeltaTime )
{
    GameLoop(DeltaTime);
}

defaultproperties
{
     TotalGameTime=100.000000
     TotalRoundTime=15.000000
     TotalRound=3
     TotalWinRound=2
}
