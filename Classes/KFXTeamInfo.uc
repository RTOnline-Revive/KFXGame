//-----------------------------------------------------------
//  Class:      KFXGame.KFXTeamInfo
//  Creator:    zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-04-09
//  Desc:       ������Ϣ
//  Update:
//  Special:
//-----------------------------------------------------------

class KFXTeamInfo extends UnrealTeamInfo;

var int      fxCurrWinRound;          // ��ǰʤ������
var float    OccupyScore;        //ռ��÷�
var float     KFXTeamGrade;       //��������

replication
{
	// �仯��ͬ��
	reliable if( bNetDirty && (Role==ROLE_Authority) )
		fxCurrWinRound,KFXTeamGrade;
}

defaultproperties
{
}
