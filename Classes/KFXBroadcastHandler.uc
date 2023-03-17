//-----------------------------------------------------------
//  Class:      KFXGame.KFXBroadcastHandler
//  Creator:    zhangjinpin@kingsoft �Ž�Ʒ
//  Data:       2007-10-25
//  Desc:       �㲥����
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXBroadcastHandler extends BroadcastHandler;


// �򵥴���ȥ����һЩ�ж�
function KFXBroadcastLocalized
(
    Actor Sender,
    PlayerController Receiver,
    class<LocalMessage> Message,
    optional int Switch1,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject,
    optional int Switch2
)
{
	KFXPlayer(Receiver).KFXReceiveLocalizedMessage(
        Message, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch2
        );

}

// ����һ������
event KFXAllowBroadcastLocalized
(
    actor Sender,
    class<LocalMessage> Message,
    optional int Switch1,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject,
    optional int Switch2
)
{
	local Controller C;
	local KFXPlayer P;

	For( C = Level.ControllerList; C != None; C = C.NextController )
	{
		P = KFXPlayer(C);
		if( P != None )
		{
			KFXBroadcastLocalized(
                Sender,
                P,
                Message,
                Switch1,
                RelatedPRI_1,
                RelatedPRI_2,
                OptionalObject,
                Switch2
                );
		}
	}
}

defaultproperties
{
}
