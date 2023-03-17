// ====================================================================
//  Class:  KFXGame.KFXGUIGameInfo
//  Creator: Wang Kai
//  Date: 2009.03.05
//  Description: 游戏外场景使用的GameInfo
//  Log:
// (c) 2009, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXGUIGameInfo extends GameInfo;

var array<KFXGUIPawn> GUIPawns;
var PlayerStart StartPlace;
var KFXGUIPlayer SinglePlayer;
var KFXGUIPawn SelectedGUIPawn1;
var KFXGUIPawn SelectedGUIPawn2;
var bool bPlayingScene;

function PostBeginPlay()
{
    local KFXGUIPawn GUIPawn;
    local PlayerStart temStart;
    foreach AllActors(class'KFXGUIPawn',GUIPawn)
    {
        GUIPawns[GUIPawns.Length]=GUIPawn;
    }

    foreach AllActors(class'PlayerStart',temStart)
    {
        StartPlace = temStart;
    }
}

event SceneEnded( SceneManager SM, Actor Other )
{
    //让相机回到场景中设定的点和方向
    bPlayingScene = false;
    SinglePlayer.SetLocation(StartPlace.Location);
    SinglePlayer.SetRotation(StartPlace.Rotation);
    SinglePlayer.Player.GUIController.OpenMenu("KFXCreateRolePage");
}

function SelectGUIPawn(KFXGUIPawn pawn)
{
    local int loop;

    if(! bPlayingScene)
    {
        SelectedGUIPawn1 = pawn;
        for(loop=0; loop < GUIPawns.Length; loop++)
        {
            GUIPawns[loop].ShowEffect(false) ;
            if(GUIPawns[loop].GroupID == pawn.GroupID && GUIPawns[loop].PawnID != pawn.PawnID )
            {
                SelectedGUIPawn2 = GUIPawns[loop];
            }
        }
        pawn.SceneMgr.BeginScene();

    }
}

function Show(byte GroupID,byte PawnID)
{
    local int loop;
    if(! bPlayingScene)
    {
        for(loop=0; loop < GUIPawns.Length; loop++)
        {
            if( GUIPawns[loop].GroupID == GroupID && GUIPawns[loop].PawnID == PawnID )
            {
                SelectGUIPawn(GUIPawns[loop]);
                break;
            }
        }

    }
}

function StopShow()
{
    if(bPlayingScene)
    {
        SelectedGUIPawn1.SceneMgr.StopScene();
        SelectedGUIPawn1.PlayIdleAnim();
        SelectedGUIPawn2.PlayIdleAnim();
        SelectedGUIPawn1.ShowEffect(true);
        SelectedGUIPawn2.ShowEffect(true);
    }
}

event SceneAbort();	  //相机运动过程中space、enter、esc、leftmouse会导致这个函数被调用，随后 SceneEnded也会调用

event SceneStarted(SceneManager SM,Actor Other)
{
    bPlayingScene = true;
}

event PlayerController Login
(
    string Portal,
    string Options,
    out string Error
)
{
    SinglePlayer = KFXGUIPlayer(super.Login(Portal,Options,Error));
    return SinglePlayer;
}

defaultproperties
{
     PlayerControllerClassName="KFXGame.KFXGUIPlayer"
}
