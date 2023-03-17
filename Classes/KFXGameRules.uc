//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXGameRules extends GameRules;

var  string  GameRulesName;
var  bool    bUseVolumeStart;
//=====添加模式下的pickup随机生成
var array<KFXPickupFactory> pickupfactory;
function PostBeginPlay()
{
    if ((NextGameRules != None))
    {
        KFXGameRules(NextGameRules).PostBeginPlay();
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
    if(KFXBot(Player) != none)
    {
         log("ProtectHostageRule------Bot ");
         return FindBotStart(Player,InTeam,incomingName);
    }
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
        NewRating = Level.Game.RatePlayerStart(N, Team, Player);

        if ( NewRating > BestRating )
        {
           BestRating = NewRating;
           BestStart = N;
        }

    }


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
// 寻找BOT出生点
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

        if(KFXBot(Player).PlayerStartTag != 'none')
        {
            if(N.Tag != KFXBot(Player).PlayerStartTag)
                 continue;

        }
        else
        {
            if(N.Tag == 'Sniper')//普通BOT不能出生在狙击BOT出生点
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
