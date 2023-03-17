//-----------------------------------------------------------
//  Class:  KFXGame.KFXGUIPawn
//  Creator: Wang Kai
//  Date: 2009.03.13
//  Description: 游戏外场景使用的Pawn
//  Log:
// (c) 2009, kingsoft, Inc - All Rights Reserved
//-----------------------------------------------------------
class KFXGUIPawn extends KFXPawn;

var() SceneManager SceneMgr;
var() name ShowAnim;
var() name IdleAnim;
var bool bShowing;
var() Emitter SelectedEmitter;
var() byte GroupID;
var() byte PawnID;
var bool bInitEmitterLocation;

event Timer();
//对pawn当前状态数据进行核对
function TestPawnStateData();
event PostBeginPlay()
{
    SelectedEmitter = Spawn(class'KFXEffects.fx_effect_god',self,,Location);
    SelectedEmitter.bHidden = true;
    KFXCreateShadow();
}

simulated function BeginShow()
{
    if(bShowing)
    {
        return;
    }
    bShowing = true;
    PlayAnim(ShowAnim);
}
auto state KFXPending
{
    function BeginState()
    {
        super.BeginState();
        PlayAnim(IdleAnim);
        Enable('Trigger');
        Enable('AnimEnd');
    }

    function AnimEnd(int Channel)
    {
        global.AnimEnd(Channel);
    }
    function trigger(actor Other,pawn EventInstigator)
    {
        global.trigger(Other,EventInstigator);
    }
}

simulated function KFXCreateShadow()
{
    if ( KFXPlayerBodyShadow == none )
    {
        KFXPlayerBodyShadow = Spawn(class'ShadowProjector',Self,'',Location);
        KFXPlayerBodyShadow.ShadowActor = self;
        KFXPlayerBodyShadow.bBlobShadow = bBlobShadow;
        KFXPlayerBodyShadow.LightDirection = Normal(vect(0,0,1)); // = -sunLigthDirection;
        KFXPlayerBodyShadow.LightDistance = 1000;
        KFXPlayerBodyShadow.MaxTraceDistance=355;
        KFXPlayerBodyShadow.InitShadow();
    }
    KFXPlayerBodyShadow.bShadowActive = true;
}

function AnimEnd(int Channel)
{
    if(bShowing)
    {
        bShowing = false;
        SelectedEmitter.bHidden = false;
        PlayAnim(IdleAnim);
    }
}

function PlayIdleAnim()
{
    PlayAnim(IdleAnim);
}

function trigger(actor Other,pawn EventInstigator)
{
    BeginShow();
}

simulated function ShowEffect(bool bShow)
{
    local vector Loc;
    if(!bInitEmitterLocation)
    {
        Loc = GetBoneCoords('bip01 neck').Origin;
        Loc.Z=Location.Z - CollisionHeight;
        SelectedEmitter.SetLocation(Loc);
        bInitEmitterLocation=true;
    }
    SelectedEmitter.bHidden = !bShow;
}

defaultproperties
{
}
