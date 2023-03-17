//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXGameRules extends GameRules;

var  string  GameRulesName;
var  bool    bUseVolumeStart;
//=====���ģʽ�µ�pickup�������
var array<KFXPickupFactory> pickupfactory;
function PostBeginPlay()
{
    if ((NextGameRules != None))
    {
        KFXGameRules(NextGameRules).PostBeginPlay();
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
    if(KFXBot(Player) != none)
    {
         log("ProtectHostageRule------Bot ");
         return FindBotStart(Player,InTeam,incomingName);
    }
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
        NewRating = Level.Game.RatePlayerStart(N, Team, Player);

        if ( NewRating > BestRating )
        {
           BestRating = NewRating;
           BestStart = N;
        }

    }


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
            foreach N.VisibleCollidingActors(class'Pawn', A, fRadius)
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


    if ( BestStart == none )
    {
        log("[FindPlayerStart] Error: Can't Find a PlayerStart !");
        BestStart = super.FindPlayerStart(Player,InTeam,incomingName);
    }

    return BestStart;
}
// Ѱ��BOT������
function NavigationPoint FindBotStart( Controller Player, optional byte InTeam, optional string incomingName )
{
    local NavigationPoint N, BestStart;
    local float BestRating, NewRating;
    local byte Team;
    local Pawn A;
    local float fRadius;
    local bool bFoundCollide;
    if(KFXPlayer(Player) != none)
    {
        log("I'm Finding Bot Start,not persons");
        return none;
    }
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

        if(KFXBot(Player).PlayerStartTag != 'none')
        {
            if(N.Tag != KFXBot(Player).PlayerStartTag)
                 continue;

        }
        else
        {
            if(N.Tag == 'Sniper')//��ͨBOT���ܳ����ھѻ�BOT������
               continue;
        }
        NewRating = Level.Game.RatePlayerStart(N, Team, Player);

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
        log("[FindBotStart] Error: Can't Find a PlayerStart !");
        BestStart = super.FindBotStart(Player,InTeam,incomingName);
    }

    return BestStart;

}
function NotifyObjectiveDestroy(Pawn Instigator, Actor Killed)
{
   if ((NextGameRules != None))
   {
       NextGameRules.NotifyObjectiveDestroy(Instigator,Killed);
   }
}
function FindPickupFactory()
{
    local KFXPickupFactory A;
    if ((NextGameRules != None))
    {
       FindPickupFactory();
    }

    foreach AllActors(class'KFXPickupFactory',A)
    {
        pickupfactory[A.PickupNum]=A;
    }
}

defaultproperties
{
     GameRulesName="GameRules"
}
