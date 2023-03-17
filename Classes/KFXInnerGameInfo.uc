//-----------------------------------------------------------
//  Class:      KFXGame.GameRules
//  Creator:    wangkai1@kingsoft ����
//  Data:       2008��12��06��
//  Desc:       Ƕ�뵽��ͨGameInfo�е�С��ϷGameInfo
//  Update:
//  Special:    �뷨�ܼ򵥣���Ϸ��Ƕ�׵�С��Ϸ��
//              ��̫��Ϥ����GameInfo�Ľӿڶ��廭�˺�«
//              Ŭ��ʹ�����Ϊ������ǶС��Ϸ�Ľӿڹ淶
//-----------------------------------------------------------

class KFXInnerGameInfo extends Info
    config(KFXGameRPInfo);

var GameInfo        MainGameInfo;
var array<PlayerController>     CandidateControllerList;    //�����ȴ����б�
var array<PlayerController>     PlayerControllerList;       //�������б�

var string          GameName;

var bool            bStarted;

var config float    TotalGameTime;
var config float    TotalRoundTime;
var config int      TotalRound;
var config int      TotalWinRound;      // Ӯ�ñ�����Ҫ����

var float           StartGameTime;
var float           StartRoundTime;
var int             CurRound;




//��ʼ����Ϸ
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

//ȫ����Ϸ����˳�
function bool OutterPlayerLogout( PlayerController Player);

//��ҵ�½
function bool PlayerLogin( PlayerController NewPlayer );

function PostPlayerLogin( PlayerController NewPlayer );

//��ҵǳ�
function bool PlayerLogout( PlayerController Player );

function PostPlayerLogout( PlayerController NewPlayer );

//������ÿ����ҹ㲥��Ϣ
event BroadcastLocalized( actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject );

//��������
function bool ChangeTeam(Controller Other, int N, bool bNewTeam){ return false; }

//�����Ϸ�����Ƿ�ﵽ��Ϸ������
function CheckScore(PlayerReplicationInfo Scorer,optional  PlayerReplicationInfo Loser);

//��ʼ��Ϸ
function StartMatch()
{
    Reset();
}

function PostStartMatch();

//������Ϸ
function EndGame( PlayerController Winner, string Reason );

//����С��
function EndRound( PlayerController Winner, string Reason );

function StartRound()
{
    StartRoundTime = Level.TimeSeconds;
    CurRound++;
}

//��Ϸ������
function PostGameEnd( PlayerController Winner, string Reason );

//С�ֽ�����
function PostEndRound( PlayerController Winner, string Reason );

//����
function Reset()
{
    StartGameTime   = Level.TimeSeconds;
    StartRoundTime  = Level.TimeSeconds;
    CurRound        = 1;
}

//���¿����
function RestartPlayer( Controller aPlayer );

//�ɷ����������¼�
function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc);

//�ɷ����������¼�
function TeamScoreEvent(int Team, float Points, string Desc);

//��ͣ��Ϸ
function bool SetPause( bool bPause, PlayerController P ){ return false; }

//��Ϸ������
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

//��������Ϸ������ (move to native code ?)
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
