class KFXSquadAI extends ReplicationInfo;

var KFXTeamInfo Team;

var Controller SquadLeader;
var KFXPlayerReplicationInfo LeaderPRI;
var KFXSquadAI NextSquad;	// list of squads on a team
//var GameObjective SquadObjective;

var int Size;

//var AssaultPath AlternatePath;	// path to use for attacking base
var name AlternatePathTag;

var Bot SquadMembers;

var float GatherThreshold;
var localized string SupportString, DefendString, AttackString, HoldString, FreelanceString;
var localized string SupportStringTrailer;
var name CurrentOrders;

var Pawn Enemies[8];
var int MaxSquadSize;
var bool bFreelance;
var bool bFreelanceAttack;
var bool bFreelanceDefend;
var bool bRoamingSquad;
var bool bAddTransientCosts;
//var UnrealScriptedSequence FreelanceScripts;

function AddBot(Bot B)
{
}
function RemovePlayer(PlayerController P)
{
}
function RemoveBot(Bot B)
{
}
function NotifyKilled(Controller Killer, Controller Killed, pawn KilledPawn)
{
}
//这个地方实现的方法已经有很大不同了
function bool FriendlyToward(Pawn Other)
{
	return false;
}

function bool ValidEnemy(Pawn NewEnemy)
{
    //判定是否是队友 貌似Mat里的写法已经不一样了
	//return ( (NewEnemy != None) && !NewEnemy.bAmbientCreature && (NewEnemy.Health > 0) && (NewEnemy.Controller != None));
    return ( (NewEnemy != None) && !NewEnemy.bAmbientCreature && (NewEnemy.Health > 0) && (NewEnemy.Controller != None)	&& !FriendlyToward(NewEnemy) );
}

function bool SetEnemy( KFXBot B, Pawn NewEnemy )
{
	local bool bResult;

	return bResult;

}
//
///* AddEnemy()
//adds an enemy - returns false if enemy was already on list
//*/
function bool AddEnemy(Pawn NewEnemy)
{
	return false;
}
//
/* LostEnemy()
Bot lost track of enemy.  Change enemy for this bot, clear from list if no one can see it
*/
function bool LostEnemy(KFXBot B)
{
	local pawn Lost;
	return (B.Enemy != Lost);
}

function RemoveEnemy(Pawn E)
{
}


function bool MustKeepEnemy(Pawn E)
{
	return false;
}

/* ModifyThreat()
return a modified version of the threat value passed in for a potential enemy
*/
function float ModifyThreat(float current, Pawn NewThreat, bool bThreatVisible, KFXBot B)
{
	return current;
}

function float AssessThreat( KFXBot B, Pawn NewThreat, bool bThreatVisible )
{
	return 0.5;
}

function bool FindNewEnemyFor(KFXBot B, bool bSeeEnemy)
{
	return false;
}

function bool LeaderFindRoamDest( KFXBot B )
{
    return false;
}

//
function bool AssignSquadResponsibility(KFXBot B)
{
	return false;
}

function bool ClearPathFor(Controller C)
{
	local bool bForceDefer;
	return bForceDefer;
}

defaultproperties
{
}
