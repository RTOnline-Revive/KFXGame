//-----------------------------------------------------------
//  Class:      KFXGame.KFXTeamInfo
//  Creator:    zhangjinpin@kingsoft 张金品
//  Data:       2007-04-09
//  Desc:       队伍信息
//  Update:
//  Special:
//-----------------------------------------------------------

class KFXTeamInfo extends UnrealTeamInfo;

var int      fxCurrWinRound;          // 当前胜利局数
var float    OccupyScore;        //占领得分
var float     KFXTeamGrade;       //队伍评分

replication
{
	// 变化就同步
	reliable if( bNetDirty && (Role==ROLE_Authority) )
		fxCurrWinRound,KFXTeamGrade;
}

defaultproperties
{
}
