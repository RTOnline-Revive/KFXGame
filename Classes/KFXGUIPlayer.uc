// ====================================================================
//  Class:  KFXGame.KFXGUIPlayer
//  Creator: Wang Kai
//  Date: 2009.03.05
//  Description: 游戏外场景使用的PlayerController
//  Log:
// (c) 2009, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXGUIPlayer extends PlayerController;

event InitInputSystem()
{
    super.InitInputSystem();
    if (Player != none && Player.GUIController != none)
    {
    }
    else
    {
        log ("============ Not ready yet ===========");
    }
    PlayMusic("player_music1",0,true);
    SetFOV(75);
}

auto state PlayerWaiting
{
    exec function Fire(optional float F)
    {
        global.Fire(F);
    }

    exec function SwitchWeapon(byte F)
    {
        global.SwitchWeapon( F);
    }
}

exec function Fire(optional float F)
{
    if( ! KFXGUIGameInfo(level.Game).bPlayingScene )
    {
        DoPawnTrace();
    }
}

exec function SwitchWeapon(byte F)
{
    if( ! KFXGUIGameInfo(level.Game).bPlayingScene )
    {
        KFXGUIGameInfo(level.Game).Show(F%4+F/4,F/4+1);
    }
}

event SelectRole(byte GroupID)
{
    if( GroupID == 0 )
    {
        KFXGUIGameInfo(level.Game).StopShow();
    }
    if( ! KFXGUIGameInfo(level.Game).bPlayingScene )
    {
        if(GroupID == 2)
        {
            KFXGUIGameInfo(level.Game).Show(GroupID,2);
        }
        else
        {
            KFXGUIGameInfo(level.Game).Show(GroupID,1);
        }
    }
}

function DoPawnTrace()
{
    local vector Dir,HitLocation,HitNormal,TraceEnd,TraceStart;
	local Actor ClickActor;
	//local KFXGUIPlayer P;

	Dir.x = Player.WindowsMouseX;
	Dir.y = Player.WindowsMouseX;
	Dir.z = 0;
	Dir = Player.GUIController.ScreenToWorld(Dir);
	TraceStart = Location;
	TraceEnd = TraceStart + Dir * 10000;

	ClickActor = Trace(HitLocation,HitNormal,TraceEnd,TraceStart,true);
	if (ClickActor != None && KFXGUIPawn(ClickActor) != None)
	{
        KFXGUIGameInfo(level.Game).SelectGUIPawn(KFXGUIPawn(ClickActor));
    }
    else
    {
        ;
    }
}

defaultproperties
{
}
