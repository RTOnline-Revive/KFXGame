//-----------------------------------------------------------
//  Class:      KFXGame.KFXBroadcastHandler
//  Creator:    zhangjinpin@kingsoft 张金品
//  Data:       2007-10-25
//  Desc:       广播处理
//  Update:
//  Special:
//-----------------------------------------------------------
class KFXBroadcastHandler extends BroadcastHandler;


// 简单处理，去掉了一些判断
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

// 增加一个参数
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
