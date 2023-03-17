//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXPlayerBase extends UnrealPlayer
    dependson(KFXDVClientAgent);// wangkai, Dolby Voice

//=============================================================================
// Cached Data, Load Before Gameplay

//2010-03-04 HAWK.Wang
//M2 ��������CSV������
//����չ���ͻ�������������һ�������ٿ��ǰ˷����ƶ���
//ȥ����Ӿ�����У���ܵȸ��������ڵĶ���
//��ɫ���°��������ڶ�ͨ���Ķ���
struct KFXPawnStateAnims
{
    //============================�������߶��� basic movement Anims
    var name Run[4];            //�ܲ�
    var name RunTurn[2];        //�ܲ�ת��
    var name Walk[4];           //����
    var name WalkTurn[2];       //����ת��
    var name Crouch[4];         //����
    var name CrouchTurn[2];     //����ת��
    //============================��Ծ���� jump Animation
    var name Takeoff[4];        //����
    var name Land[4];           //���
    //============================�������� Stupid Idle Anims
    var name IdleStand;         //��վ
    var name IdleCrouch;        //����
    var name IdleChat;          //����
    var name IdleRest;          //��Ϣ
    var name IdleTakeoff;       //���ڿ�
    //============================��������
    var name HitHead[4];        //����ͷ
    var name HitBody[4];        //����������
    var name HitLegs[4];        //�����Ȳ�
    var name CHitAnim;          //�¶�ʱ�����˶���
    //============================���𣬻�ǹ������
    var name StandFire[2];      //վ������Firemode[0,1]
    var name CrouchFire[2];     //�¶׿���Firemode[0,1]
    var name SwitchWeapon;      //��ǹ
    var name StandReload;       //����
    var name CrouchReload;      //�׻���
	//var name JumpCrouch;		//����
};

//���˶������ⲹ�䣬��Ϊ KFXPawnStateAnims�ݲ����ˣ��ز�������ṹ��
struct KFXTakeDamagedAnims
{
    //============================��������
    var name HitHead[12];        //����ͷ
    var name HitBody[12];        //����������
    var name HitLegs[12];        //�����Ȳ�
    var name CHitAnim[3];       //�¶�ʱ�����˶���
};
//��ɫ��һͨ���Ķ�������������أ�
struct KFXPawnBlendAnims
{
    //============================�������߶��� basic movement Anims
    var name Run[4];            //�ܲ�
    var name RunTurn[2];        //�ܲ�ת��
    var name Walk[4];           //����
    var name WalkTurn[2];       //����ת��
    var name Crouch[4];         //����
    var name CrouchTurn[2];     //����ת��
    //============================��Ծ���� jump Animation
    var name Takeoff[4];        //����
    var name Land[4];           //���
    //============================�������� Stupid Idle Anims
    var name IdleStand;         //��վ
    var name IdleCrouch;        //����
    var name IdleChat;          //����
    var name IdleRest;          //��Ϣ
    var name IdleTakeoff;       //���ڿ�
//    var name JumpCrouch;        //����
};

var array<KFXPawnStateAnims> KFXPawnAnimsTable;
var array<KFXPawnBlendAnims> KFXPawnBlendAnimsTable;

var array<KFXTakeDamagedAnims> KFXDamagedPawnAnimsTable;

//<< wangkai, Dolby Voice, 2008-07-03
var KFXDVClientAgent            DVClient;
var bool                        bDVItemOK;
var string                      KFXPlayerIP;
var localized string            CONF_3DTalkOpen,
                                CONF_3DTalkClose,
                                CONF_TeamTalkOpen,
                                CONF_TeamTalkClose,
                                CONF_3DTalkHelp,
                                CONF_TeamTalkHelp,
                                CONF_OpenDVTalk,
                                CONF_NotAllowed,
                                CONF_NoSpatialInSpec;

var bool                        bDVTipShown;// ��ʾ�ű�����������ʾ��Ϣ
var bool                        bDVTeamTalkPressLocked;// �������죨����˵���Ƿ�����
var bool                        bDVTeamTalkToggleLocked;// �������죨�л����Ƿ�����
var bool                        bDVAllowTalk;// �Ƿ���Կ�ʼ����
//>>

var vector				LastVelocity;
var bool				LastRun,LastDuck,LastJumpStatus,LastDoubleJump;
var eDoubleClickDir		LastDoubleClickMove;
var	byte				LastClientRoll;
var int					LastPitch,LastYaw;
var	float				LastSentTime;

replication
{
    reliable if ( Role == ROLE_Authority )  // ͬ�����ͻ���
        DVInitClientInfo, DVChangeTeam, KFXGetVoiceItems, RepSpeedHack;
    unreliable if(Role < ROLE_Authority)
        KFXServerTeamTalk, DVServerMuteOne;
}

//<< ���μ�����ȫ���Admin���� wangkai
exec function AdminLogin(string CmdLine);
exec function AdminLogout();
exec function Admin( string CommandLine );
exec function AdminDebug( string CommandLine );
//>>

//<<������ �������� ���ٳ���
function IsSpeedHack()
{
    RepSpeedHack();
}

function RepSpeedHack()
{
    bWasSpeedHack = true;
}


function ServerAdminLogin(string CmdLine)
{
    log ("ALERT: ServerAdminLogin, PlayerName:"@PlayerReplicationInfo.PlayerName@"CmdLine:"@CmdLine);
}

function MakeAdmin()
{
    log ("ALERT: MakeAdmin, PlayerName:"@PlayerReplicationInfo.PlayerName);
}

function AdminCommand( string CommandLine )
{
    log ("ALERT: AdminCommand, PlayerName:"@PlayerReplicationInfo.PlayerName@"CmdLine:"@CommandLine);
}
//>>

// Client Only
simulated function KFXPawnStateAnims KFXGetPawnStateAnimGroup(int Index)
{
    return KFXPawnAnimsTable[Index];
}

// Client Only
simulated function KFXTakeDamagedAnims KFXGetDamagedPawnAnimGroup(int Index)
{
    return KFXDamagedPawnAnimsTable[Index];
}

simulated function KFXPawnBlendAnims KFXGetKFXPawnBlendAnimsGroup( int Index )
{
    return KFXPawnBlendAnimsTable[Index];
}

simulated function PreBeginPlay()
{
    local bool bRet;
    super.PreBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {
        _KFXPreloadPawnStateAnimTable();
    }
    //<< Dolby �ͻ��˳�ʼ��
    if (Level.NetMode != NM_DedicatedServer)
    {
        bRet = DVInit();
    }
    //>>

    if (Role == ROLE_Authority)
		class<KFXPawnBase>(PawnClass).static.LoadDefaults();
}

simulated function _KFXPreloadPawnStateAnimTable()
{
    local KFXCSVTable CFG_PawnAnims;
    local int Counter;
    local int i;
    CFG_PawnAnims  = class'KFXTools'.static.GetConfigTable(43);

    if ( CFG_PawnAnims == none )
        return;

    Counter = 0;
    while( CFG_PawnAnims.SetCurrentRow(Counter) != false )
    {
        KFXPawnAnimsTable.Length = Counter + 1;
        KFXPawnBlendAnimsTable.Length = Counter + 1;
        KFXDamagedPawnAnimsTable.Length = Counter + 1;

        // Common Anims
        KFXPawnAnimsTable[Counter].Run[0] = CFG_PawnAnims.GetName("RunF");
        KFXPawnAnimsTable[Counter].Run[1] = CFG_PawnAnims.GetName("RunB");
        KFXPawnAnimsTable[Counter].Run[2] = CFG_PawnAnims.GetName("RunL");
        KFXPawnAnimsTable[Counter].Run[3] = CFG_PawnAnims.GetName("RunR");
        KFXPawnAnimsTable[Counter].RunTurn[0] = CFG_PawnAnims.GetName("RunTurnL");
        KFXPawnAnimsTable[Counter].RunTurn[1] = CFG_PawnAnims.GetName("RunTurnR");
        KFXPawnAnimsTable[Counter].Walk[0] = CFG_PawnAnims.GetName("WalkF");
        KFXPawnAnimsTable[Counter].Walk[1] = CFG_PawnAnims.GetName("WalkB");
        KFXPawnAnimsTable[Counter].Walk[2] = CFG_PawnAnims.GetName("WalkL");
        KFXPawnAnimsTable[Counter].Walk[3] = CFG_PawnAnims.GetName("WalkR");
        KFXPawnAnimsTable[Counter].WalkTurn[0] = CFG_PawnAnims.GetName("WalkTurnL");
        KFXPawnAnimsTable[Counter].WalkTurn[1] = CFG_PawnAnims.GetName("WalkTurnR");
        KFXPawnAnimsTable[Counter].Crouch[0] = CFG_PawnAnims.GetName("CrouchF");
        KFXPawnAnimsTable[Counter].Crouch[1] = CFG_PawnAnims.GetName("CrouchB");
        KFXPawnAnimsTable[Counter].Crouch[2] = CFG_PawnAnims.GetName("CrouchL");
        KFXPawnAnimsTable[Counter].Crouch[3] = CFG_PawnAnims.GetName("CrouchR");
        KFXPawnAnimsTable[Counter].CrouchTurn[0] = CFG_PawnAnims.GetName("CrouchTurnL");
        KFXPawnAnimsTable[Counter].CrouchTurn[1] = CFG_PawnAnims.GetName("CrouchTurnR");

        KFXPawnAnimsTable[Counter].Takeoff[0] = CFG_PawnAnims.GetName("TakeoffF");
        KFXPawnAnimsTable[Counter].Takeoff[1] = CFG_PawnAnims.GetName("TakeoffB");
        KFXPawnAnimsTable[Counter].Takeoff[2] = CFG_PawnAnims.GetName("TakeoffL");
        KFXPawnAnimsTable[Counter].Takeoff[3] = CFG_PawnAnims.GetName("TakeoffR");
        KFXPawnAnimsTable[Counter].Land[0] = CFG_PawnAnims.GetName("LandF");
        KFXPawnAnimsTable[Counter].Land[1] = CFG_PawnAnims.GetName("LandB");
        KFXPawnAnimsTable[Counter].Land[2] = CFG_PawnAnims.GetName("LandL");
        KFXPawnAnimsTable[Counter].Land[3] = CFG_PawnAnims.GetName("LandR");

        KFXPawnAnimsTable[Counter].IdleStand = CFG_PawnAnims.GetName("IdleStand");
        KFXPawnAnimsTable[Counter].IdleCrouch = CFG_PawnAnims.GetName("IdleCrouch");
        KFXPawnAnimsTable[Counter].IdleChat = CFG_PawnAnims.GetName("IdleChat");
        KFXPawnAnimsTable[Counter].IdleRest = CFG_PawnAnims.GetName("IdleRest");
        KFXPawnAnimsTable[Counter].IdleTakeoff = CFG_PawnAnims.GetName("IdleTakeoff");
        //KFXPawnAnimsTable[Counter].JumpCrouch = CFG_PawnAnims.GetName("JumpCrouch");

        KFXPawnAnimsTable[Counter].HitHead[0] = CFG_PawnAnims.GetName("HitHeadF0");
        KFXPawnAnimsTable[Counter].HitHead[1] = CFG_PawnAnims.GetName("HitHeadB0");
        KFXPawnAnimsTable[Counter].HitHead[2] = CFG_PawnAnims.GetName("HitHeadL0");
        KFXPawnAnimsTable[Counter].HitHead[3] = CFG_PawnAnims.GetName("HitHeadR0");

        KFXPawnAnimsTable[Counter].HitBody[0] = CFG_PawnAnims.GetName("HitBodyF0");
        KFXPawnAnimsTable[Counter].HitBody[1] = CFG_PawnAnims.GetName("HitBodyB0");
        KFXPawnAnimsTable[Counter].HitBody[2] = CFG_PawnAnims.GetName("HitBodyL0");
        KFXPawnAnimsTable[Counter].HitBody[3] = CFG_PawnAnims.GetName("HitBodyR0");

        KFXPawnAnimsTable[Counter].HitLegs[0] = CFG_PawnAnims.GetName("HitLegF0");
        KFXPawnAnimsTable[Counter].HitLegs[1] = CFG_PawnAnims.GetName("HitLegB0");
        KFXPawnAnimsTable[Counter].HitLegs[2] = CFG_PawnAnims.GetName("HitLegL0");
        KFXPawnAnimsTable[Counter].HitLegs[3] = CFG_PawnAnims.GetName("HitLegR0");

        KFXPawnAnimsTable[Counter].CHitAnim   = CFG_PawnAnims.GetName("CHitAnim0");
        //��ԭ���Ĵ浽����������ʼ�ձ�����һ���ṹ������  KFXDamagedPawnAnimsTable���� 048����F 159����B 2610����L 3711����R
        for(i=0; i<4; i++)
        {
             KFXDamagedPawnAnimsTable[Counter].HitHead[i] = KFXPawnAnimsTable[Counter].HitHead[i];
             KFXDamagedPawnAnimsTable[Counter].HitBody[i] = KFXPawnAnimsTable[Counter].HitBody[i];
             KFXDamagedPawnAnimsTable[Counter].HitLegs[i] = KFXPawnAnimsTable[Counter].HitLegs[i];
        }
        KFXDamagedPawnAnimsTable[Counter].CHitAnim[0] = KFXPawnAnimsTable[Counter].CHitAnim;
        //�������ӵĸ�ֵ
        for(i=1; i<3; i++)
        {
            KFXDamagedPawnAnimsTable[Counter].HitHead[0 + i * 4] = CFG_PawnAnims.GetName("HitHeadF"$i);
            KFXDamagedPawnAnimsTable[Counter].HitHead[1 + i * 4] = CFG_PawnAnims.GetName("HitHeadB"$i);
            KFXDamagedPawnAnimsTable[Counter].HitHead[2 + i * 4] = CFG_PawnAnims.GetName("HitHeadL"$i);
            KFXDamagedPawnAnimsTable[Counter].HitHead[3 + i * 4] = CFG_PawnAnims.GetName("HitHeadR"$i);

            KFXDamagedPawnAnimsTable[Counter].HitBody[0 + i * 4] = CFG_PawnAnims.GetName("HitBodyF"$i);
            KFXDamagedPawnAnimsTable[Counter].HitBody[1 + i * 4] = CFG_PawnAnims.GetName("HitBodyB"$i);
            KFXDamagedPawnAnimsTable[Counter].HitBody[2 + i * 4] = CFG_PawnAnims.GetName("HitBodyL"$i);
            KFXDamagedPawnAnimsTable[Counter].HitBody[3 + i * 4] = CFG_PawnAnims.GetName("HitBodyR"$i);

            KFXDamagedPawnAnimsTable[Counter].HitLegs[0 + i * 4] = CFG_PawnAnims.GetName("HitLegF"$i);
            KFXDamagedPawnAnimsTable[Counter].HitLegs[1 + i * 4] = CFG_PawnAnims.GetName("HitLegB"$i);
            KFXDamagedPawnAnimsTable[Counter].HitLegs[2 + i * 4] = CFG_PawnAnims.GetName("HitLegL"$i);
            KFXDamagedPawnAnimsTable[Counter].HitLegs[3 + i * 4] = CFG_PawnAnims.GetName("HitLegR"$i);

            KFXDamagedPawnAnimsTable[Counter].CHitAnim[i]   = CFG_PawnAnims.GetName("CHitAnim"$i);
        }

        KFXPawnAnimsTable[Counter].StandFire[0] = CFG_PawnAnims.GetName("StandFire1");
        KFXPawnAnimsTable[Counter].StandFire[1] = CFG_PawnAnims.GetName("StandFire2");
        KFXPawnAnimsTable[Counter].CrouchFire[0] = CFG_PawnAnims.GetName("CrouchFire1");
        KFXPawnAnimsTable[Counter].CrouchFire[1] = CFG_PawnAnims.GetName("CrouchFire2");
        KFXPawnAnimsTable[Counter].SwitchWeapon = CFG_PawnAnims.GetName("SwitchWeapon");
        KFXPawnAnimsTable[Counter].StandReload = CFG_PawnAnims.GetName("StandReload");
        KFXPawnAnimsTable[Counter].CrouchReload = CFG_PawnAnims.GetName("CrouchReload");





        // Common Anims
        KFXPawnBlendAnimsTable[Counter].Run[0] = CFG_PawnAnims.GetName("BlendRunF");
        KFXPawnBlendAnimsTable[Counter].Run[1] = CFG_PawnAnims.GetName("BlendRunB");
        KFXPawnBlendAnimsTable[Counter].Run[2] = CFG_PawnAnims.GetName("BlendRunL");
        KFXPawnBlendAnimsTable[Counter].Run[3] = CFG_PawnAnims.GetName("BlendRunR");
        KFXPawnBlendAnimsTable[Counter].RunTurn[0] = CFG_PawnAnims.GetName("BlendRunTurnL");
        KFXPawnBlendAnimsTable[Counter].RunTurn[1] = CFG_PawnAnims.GetName("BlendRunTurnR");
        KFXPawnBlendAnimsTable[Counter].Walk[0] = CFG_PawnAnims.GetName("BlendWalkF");
        KFXPawnBlendAnimsTable[Counter].Walk[1] = CFG_PawnAnims.GetName("BlendWalkB");
        KFXPawnBlendAnimsTable[Counter].Walk[2] = CFG_PawnAnims.GetName("BlendWalkL");
        KFXPawnBlendAnimsTable[Counter].Walk[3] = CFG_PawnAnims.GetName("BlendWalkR");
        KFXPawnBlendAnimsTable[Counter].WalkTurn[0] = CFG_PawnAnims.GetName("BlendWalkTurnL");
        KFXPawnBlendAnimsTable[Counter].WalkTurn[1] = CFG_PawnAnims.GetName("BlendWalkTurnR");
        KFXPawnBlendAnimsTable[Counter].Crouch[0] = CFG_PawnAnims.GetName("BlendCrouchF");
        KFXPawnBlendAnimsTable[Counter].Crouch[1] = CFG_PawnAnims.GetName("BlendCrouchB");
        KFXPawnBlendAnimsTable[Counter].Crouch[2] = CFG_PawnAnims.GetName("BlendCrouchL");
        KFXPawnBlendAnimsTable[Counter].Crouch[3] = CFG_PawnAnims.GetName("BlendCrouchR");
        KFXPawnBlendAnimsTable[Counter].CrouchTurn[0] = CFG_PawnAnims.GetName("BlendCrouchTurnL");
        KFXPawnBlendAnimsTable[Counter].CrouchTurn[1] = CFG_PawnAnims.GetName("BlendCrouchTurnR");

        KFXPawnBlendAnimsTable[Counter].Takeoff[0] = CFG_PawnAnims.GetName("BlendTakeoffF");
        KFXPawnBlendAnimsTable[Counter].Takeoff[1] = CFG_PawnAnims.GetName("BlendTakeoffB");
        KFXPawnBlendAnimsTable[Counter].Takeoff[2] = CFG_PawnAnims.GetName("BlendTakeoffL");
        KFXPawnBlendAnimsTable[Counter].Takeoff[3] = CFG_PawnAnims.GetName("BlendTakeoffR");
        KFXPawnBlendAnimsTable[Counter].Land[0] = CFG_PawnAnims.GetName("BlendLandF");
        KFXPawnBlendAnimsTable[Counter].Land[1] = CFG_PawnAnims.GetName("BlendLandB");
        KFXPawnBlendAnimsTable[Counter].Land[2] = CFG_PawnAnims.GetName("BlendLandL");
        KFXPawnBlendAnimsTable[Counter].Land[3] = CFG_PawnAnims.GetName("BlendLandR");

        KFXPawnBlendAnimsTable[Counter].IdleStand = CFG_PawnAnims.GetName("BlendIdleStand");
        KFXPawnBlendAnimsTable[Counter].IdleCrouch = CFG_PawnAnims.GetName("BlendIdleCrouch");
        KFXPawnBlendAnimsTable[Counter].IdleChat = CFG_PawnAnims.GetName("BlendIdleChat");
        KFXPawnBlendAnimsTable[Counter].IdleRest = CFG_PawnAnims.GetName("BlendIdleRest");
        KFXPawnBlendAnimsTable[Counter].IdleTakeoff = CFG_PawnAnims.GetName("BlendIdleTakeoff");
//        KFXPawnBlendAnimsTable[Counter].JumpCrouch = CFG_PawnAnims.GetName("BlendJumpCrouch");

        Counter++;
        //LOG("Anim HAWK Line "$Counter$" Loaded.");
    }
}

///////////////////////////////////////////////////////////////
///  Client Move Relevent
///////////////////////////////////////////////////////////////
function BeginClientMoveServerAdjust();
function EndClientMoveServerAdjust()
{
    IsClientMoveParamError=false;
}
function AddClientMoveParamError()
{
    IsClientMoveParamError=true;
}

///////////////////////////////////////////////////////////////
///  Voice Chat
///////////////////////////////////////////////////////////////
// rep from server
simulated function KFXGetVoiceItems(bool bSpatial, byte VoiceFont)
{
    //log ("--DEBUG ONLY-- bSpatial"@bSpatial@" VoiceFont"@VoiceFont);
    if (DVClient != none)
    {
        DVClient.DVSetVoiceFont(VoiceFont);
        if (bSpatial)
        {
            DVClient.DVSetEngine(ENG_DOLBYHEADPHONE);
        }
        else
        {
            DVClient.DVSetEngine(ENG_MONO);
        }

    }
    // update local variables
    KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXSpatial = bSpatial;
    KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXVoiceFont = VoiceFont;
    KFXPlayerReplicationInfo(PlayerReplicationInfo).KFXCurVoiceFont = VoiceFont;
    bDVItemOK = true;
}

simulated function bool DVInit()
{
    local bool bRet;

    //<< wangkai Dolby Voice 2008-07-03
    if (Level.NetMode != NM_DedicatedServer)
    {
        DVClient = spawn(class'KFXDVClientAgent');
        if (DVClient == none)
        {
            log("[Dolby Voice] <DVInit> Error! Cannot Spawn DVClient");
            return false;
        }

        bRet = DVClient.DVInit();

        if (!bRet)
        {
            log("[Dolby Voice] <DVInit> Error! Client Lib Init Error");
            //ʧ�ܣ���Ϊ�գ���ֹ�����
            DVClient = none;
            return false;
        }
        log("[Dolby Voice] <DVInit> Client Lib Initialized");

        return true;
    }
    else
    {
        log ("Dolby Not Client Side");
    }
    return false;
    //>>
}

// we need 'inline'
simulated function bool IsDVValid()
{
    return ((DVClient != none)
         && (DVClient.bDVValid)
         && bDVItemOK);
}

simulated static function byte DVGetAnimVoiceFont(int animnum)
{
    if (animnum == 1001)//��
        return 6;
    else if (animnum == 1003)//��
        return 7;
    else
        return 0;
}

//<< Dolby Voice Related exec functions

//<< debug only
/*
exec function DVSetAudioServer(string ip, optional string port)
{
    if (port == "")
        port = "30000";
    if (DVClient.DVSetAudioServerInfo(ip, port))
        LOG("############## Set Audio Server : "$ip);
    else
        LOG("############## Set Audio Server Failed");
}
*/
//>>
simulated function bool DVAllowTalk()
{
    return true;
}

// ȫ�֡�˵ ������
exec function DVSetSpeakEnable(bool bEnable)
{
    if (DVClient != none)
    {
        DVClient.DVSetSpeakEnable(bEnable);
        //myHud.Message(none, "[Dolby] Set Speak Enable"@bEnable, 'System');
    }
}

// ȫ�֡��� ������
exec function DVSetListenEnable(bool bEnable)
{
    if (DVClient != none)
    {
        DVClient.DVSetListenEnable(bEnable);
        //myHud.Message(none, "[Dolby] Set Listen Enable"@bEnable, 'System');
    }
}

// �����󶨹��ܣ�3D��˵�����л�
exec function DVToggleSpatialSpeak()
{
    if (!DVAllowTalk())
    {
//        myHud.Message(none, CONF_NotAllowed, 'System');
        return;
    }
    // �ǹ۲���
    if (IsInState('Spectating'))
    {
        myHud.Message(none, CONF_NoSpatialInSpec, 'System');
        return;
    }

    if (IsDVValid())
    {
        if (Pawn != none)
        {
            DVSetSpatialSpeakEnable(!DVClient.bDVSpatialTalk);
        }
    }
}

// 3D��˵������
simulated function DVSetSpatialSpeakEnable(bool bEnable)
{
    if (IsDVValid())
    {
        DVClient.DVSetSpatialTalkEnable(bEnable);
        if (DVClient.bDVSpeakEnabled)
        {
            // hud
//            if (bEnable)
//                myHud.Message(none, CONF_3DTalkOpen, 'System');
//            else
//                myHud.Message(none, CONF_3DTalkClose, 'System');
        }
    }
}

exec function DVToggleTeamTalk()
{
    if (bDVTeamTalkPressLocked)
        return;

    if (!DVAllowTalk())
    {
//        myHud.Message(none, CONF_NotAllowed, 'System');
        return;
    }
    if (IsDVValid())
    {
        DVSetTeamTalkEnableNaked(!DVClient.bDVTeamTalk);
        bDVTeamTalkToggleLocked = DVClient.bDVTeamTalk;
    }
}

// �����󶨹��ܣ����顰˵������
exec function DVSetTeamTalkEnable(bool bEnable)
{
    if (bDVTeamTalkToggleLocked)
        return;

    if (!DVAllowTalk())
    {
//        myHud.Message(none, CONF_NotAllowed, 'System');
        return;
    }
    if (IsDVValid())
    {
        DVSetTeamTalkEnableNaked(bEnable);
        bDVTeamTalkPressLocked = bEnable;
    }
}

simulated function DVSetTeamTalkEnableNaked(bool bEnable)
{
    //<<������ �ű�HUD��� 2009 2.4
    //>>

    if (DVClient != none)
    {
        if (DVClient.bDVSpeakEnabled)
        {
            KFXServerTeamTalk(bEnable);

            //��������һ��
            KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXTeamTalk = bEnable;

            // hud
//            if (bEnable)
//                myHud.Message(none, CONF_TeamTalkOpen, 'System');
//            else
//                myHud.Message(none, CONF_TeamTalkClose, 'System');
        }

        DVClient.DVSetTeamTalkEnable(bEnable);
    }
}

// �Ƿ�����ĳ����
// PlayerID: ���ݿ������ΨһID
exec function DVMuteOne(int PlayerID, bool bMute)
{
    if (DVClient != none && DVClient.bDVListenEnabled)
    {
        //�����Լ����κ����β���
        if (PlayerID == KFXPlayerReplicationInfo(PlayerReplicationInfo).fxPlayerDBID)
            return;
        if ( (bMute && !DVClient.DVInBanList(PlayerID))
            || (!bMute && DVClient.DVInBanList(PlayerID)) )
        {
            ;
            // ��������
            DVServerMuteOne(PlayerID, bMute);
            // ��ʶ������
            DVMarkMute(PlayerID, bMute);
            //�����б����
            if (bMute)
                DVClient.DVAddBan(PlayerID);
            else
                DVClient.DVRemoveBan(PlayerID);
        }
    }
}

// ���ñ�ʶĳ����Ƿ�����
simulated function DVMarkMute(int PlayerID, bool bMute)
{
    local int i;

    for (i=0; i<GameReplicationInfo.PRIArray.Length; i++)
    {
        if (KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).fxPlayerDBID == PlayerID)
        {
            KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).bKFXMute = bMute;
            return;
        }
    }
}

exec function DVPrintBan()
{
    local int i;
    local string content;
    if (DVClient != none)
    {
        content = "DVBanList: {";
        for (i=0; i<DVClient.BannedID.length; i++)
        {
            content $= DVClient.BannedID[i] $", ";
        }
        content $= "}";
        log (content);
    }
}

// TODO: ���� use map��
// Server only, rep from client
// PlayerID: ������ݿ���Ψһ��ʶ
// bMute���Ƿ�����
simulated function DVServerMuteOne(int PlayerID, bool bMute)
{
    local Controller C;
    local KFXPlayer P;

	if (Role == ROLE_Authority)
	{
        if (KFXGameInfo(Level.Game).DVServer == none || KFXPlayerReplicationInfo(PlayerReplicationInfo).fxPlayerDBID == PlayerID)
            return;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
    	{
    		P = KFXPlayer(C);
    		if ( P != None && P.fxDBPlayerInfo.PlayerID == PlayerID )
    		{
                log ("DVServerMuteOne: "$PlayerReplicationInfo.PlayerName$" - "$P.PlayerReplicationInfo.PlayerName@bMute);
                KFXGameInfo(Level.Game).DVServer.DVMuteOneToOne(KFXPlayer(self), P, bMute);
                return;
            }
    	}
	}
}

// server only, rep from client to server;
simulated function KFXServerTeamTalk(bool bTeamTalk)
{
    if (Role == ROLE_Authority)
    {
        KFXPlayerReplicationInfo(PlayerReplicationInfo).bKFXTeamTalk =  bTeamTalk;
    }
}

// TEST ONLY
exec function DVNoTalk()
{
    log ("DVChannelMappings: "@DVClient.DVTeamChnMapping@DVClient.DVSpatialChnMapping);
    DVClient.DVTalkIntoChannelMapping(DVClient.DVTeamChnMapping, false);
    DVClient.DVTalkIntoChannelMapping(DVClient.DVSpatialChnMapping, false);
}

exec function DVClientDebug(string cmd, string param)
{
    local int i;
    local KFXDVClientAgent.DVDeviceInfo device;
    local array<KFXDVClientAgent.DVDeviceInfo> devices;
    local array<byte> channelMaps;

    if (cmd ~= "DVGetAllDevice")
    {
        DVClient.DVGetAllDevice(devices);
        for (i=0; i<devices.length; i++)
        {
            log ("ID:           "$ devices[i].nId);
            log ("Name:         "$ devices[i].sName);
            log ("DevType:      "$ devices[i].DevType);
            log ("SysDefault:   "$ devices[i].bSysDefault);
            log ("DVDefault:    "$ devices[i].bDVDefault);
            log ("Engine:       "$ devices[i].Engine);
            log ("-----------------");
        }
    }
    else if (cmd ~= "DVGetInputDevice")
    {
        DVClient.DVGetCurrentInputDevice(device);
        log ("ID:           "$ device.nId);
        log ("Name:         "$ device.sName);
        log ("DevType:      "$ device.DevType);
        log ("SysDefault:   "$ device.bSysDefault);
        log ("DVDefault:    "$ device.bDVDefault);
        log ("Engine:       "$ device.Engine);
        log ("-----------------");
    }
    else if (cmd ~= "DVGetOutputDevice")
    {
        DVClient.DVGetCurrentOutputDevice(device);
        log ("ID:           "$ device.nId);
        log ("Name:         "$ device.sName);
        log ("DevType:      "$ device.DevType);
        log ("SysDefault:   "$ device.bSysDefault);
        log ("DVDefault:    "$ device.bDVDefault);
        log ("Engine:       "$ device.Engine);
        log ("-----------------");
    }
    else if (cmd ~= "DVSetVoiceFont")
    {
        DVClient.DVSetVoiceFont(EDVVoiceFont(int(Param)));
    }
    else if (cmd ~= "DVSetRoomMode")
    {
        DVClient.DVSetRoomMode(EDVRoomMode(int(Param)));
    }
    else if (cmd ~= "DVStartSpeakTest")
    {
        DVClient.DVStartSpeakTest(EDVSpeakTest(int(Param)));
    }
    else if (cmd ~= "DVStopSpeakTest")
    {
        DVClient.DVStopSpeakTest();
    }
    else if (cmd ~= "DVRecord")
    {
        DVClient.DVStartMicTest_Record();
    }
    else if (cmd ~= "DVPlay")
    {
        DVClient.DVStartMicTest_Play(EDVMicTest(int(Param)));
    }
    else if (cmd ~= "DVOnlyTalkInto")
    {
        channelMaps[0] = 1;
        DVClient.DVOnlyTalkIntoChannelMapping(channelMaps);
    }
    else
    {
        log ("DOLBY: undefined");
    }

}

// Client Only!!!
simulated function DVInitClientInfo(string PlayerName, int nPlayerID, int nGameID, string sASIP, int sASPort, int nSpatialChnMapping, int nTeamChnMapping)
{
//    local string sName;
    log ("[Dolby Voice] ChannelMapping:"@nSpatialChnMapping@nTeamChnMapping);

    //�ͻ��˲����ã�����
    if (DVClient == none)
    {
        log ("[Dolby Voice] <DVInitClientInfo> Error! Null DVClient");
        return;
    }

    //����һ�¿ͻ���
    DVClient.DVCleanUp();

    //��������������
    if (!DVClient.DVSetAudioServerInfo(sASIP, sASPort))
    {
        log ("[Dolby Voice] <DVInitClientInfo> Error! Connect Audio Server Error!");
        return;
    }

    //����DV�ͻ��������Ϣ��Channelӳ����Ϣ
    if (!DVClient.DVSetClientInfo(nGameID, PlayerName, nPlayerID, nSpatialChnMapping, nTeamChnMapping))
    {
        log ("[Dolby Voice] <DVInitClientInfo> Error! DVSetClientInfo Error!");
        return;
    }

    // �ͻ��˿�ʼ�����ɣ�
    DVClient.DVStart();

    return;
}

//-----------------------------------------------------------
// ֪ͨDVClient��������
//-----------------------------------------------------------
simulated function DVChangeTeam(int nNewTeamChnMapping)
{
    if (DVClient == none)
    {
        log ("[Dolby Voice] <DVChangeTeam> Null DVClient");
        return;
    }
    else
    {
        DVClient.DVChangeTeam(nNewTeamChnMapping);
    }
}

function int DVGetInitTeamID()
{
    return PlayerReplicationInfo.Team.TeamIndex;
}

event bool IsKFXPlayer()
{
    return true;
}

// Join a voice chatroom by name
exec function Join(string ChanName, string ChanPwd);
// Leave a voice chatroom by name
exec function Leave(string ChannelTitle);
// Set a voice chatroom to your active channel
exec function Speak(string ChannelTitle);
// Set your active channel to the default channel
exec function SpeakDefault();
// Set your active channel to the last active channel
exec function SpeakLast();
// Change the password for you personal chatroom
exec function SetChatPassword(string NewPassword);
exec function EnableVoiceChat();
exec function DisableVoiceChat();
simulated function InitializeVoiceChat();
function InitPrivateChatRoom();
simulated function string GetDefaultActiveChannel();
simulated function AutoJoinVoiceChat();
simulated function ChangeVoiceChatMode( bool bEnable );
simulated function bool ChatBan(int PlayerID, byte Type);
simulated function SetChannelPassword(string ChannelName, string ChannelPassword);
simulated function string FindChannelPassword(string ChannelName);
function VoiceChatRoom.EJoinChatResult ServerJoinVoiceChannel(int ChannelIndex, optional string ChannelPassword);
function ServerLeaveVoiceChannel(int ChannelIndex);
function ServerSpeak(int ChannelIndex, optional string ChannelPassword);
function ServerSetChatPassword(string NewPassword);
function ServerChangeVoiceChatMode( bool bEnable );
simulated function ClientSetActiveRoom(int ChannelIndex);

function CallServerMove
(
    float TimeStamp,
    vector InAccel,
    vector ClientLoc,
    bool NewbRun,
    bool NewbDuck,
    bool NewbPendingJumpStatus,
    bool NewbJumpStatus,
    bool NewbDoubleJump,
    eDoubleClickDir DoubleClickMove,
    byte ClientRoll,
    int View,
    optional byte OldTimeDelta,
    optional int OldAccel
)
{
	local int DiffPitch,DiffYaw;
	local float CallMoveTimeOut,LengthDiff;
	local bool DirChanged;

	// �ڿ�����ת�ӽǵ�ʱ��Ϊ�˽����������ݣ�����һ����ֵ
	DiffPitch = LastPitch - Rotation.Pitch;
	DiffYaw = LastYaw - Rotation.Yaw;
	// get Abs.
	if (DiffPitch < 0)
		DiffPitch = -DiffPitch;
	if (DiffYaw < 0)
		DiffYaw = -DiffYaw;

	if (Pawn != None)
	{
		DirChanged = (VSize(normal(LastVelocity)) > 0.2) && (normal(LastVelocity) Dot normal(Pawn.Velocity) < 0.95);
		LengthDiff = VSize(LastVelocity) - VSize(Pawn.Velocity);
		if (LengthDiff < 0)
			LengthDiff = -LengthDiff;
	}
	if (LengthDiff > 100 ||
		DirChanged ||
		LastRun != NewbRun ||
		LastDuck != NewbDuck ||
		LastJumpStatus != NewbJumpStatus ||
		LastDoubleJump != NewbDoubleJump ||
		LastDoubleClickMove != DoubleClickMove ||
		LastClientRoll != ClientRoll ||
		DiffPitch > 32768 / 360 * 30 ||
		DiffYaw > 32768 / 360 * 30)
	{
		if (Pawn != None)
			LastVelocity = Pawn.Velocity;
		LastRun = NewbRun;
		LastDuck = NewbDuck;
		LastJumpStatus = NewbJumpStatus;
		LastDoubleJump = NewbDoubleJump;
		LastDoubleClickMove = DoubleClickMove;
		LastClientRoll = ClientRoll;
		LastPitch = Rotation.Pitch;
		LastYaw = Rotation.Yaw;
		LastSentTime = TimeStamp;

		Super.CallServerMove
		(
			TimeStamp,
			InAccel,
			ClientLoc,
			NewbRun,
			NewbDuck,
			NewbPendingJumpStatus,
			NewbJumpStatus,
			NewbDoubleJump,
			DoubleClickMove,
			ClientRoll,
			View,
			OldTimeDelta,
			OldAccel
		);
	}
	else
	{
		if (InAccel == vect(0,0,0))
		{
			// ��ֹ״̬����Ϊ�������ֵ
			CallMoveTimeOut = MaxResponseTime - 0.05f;
		}
		else
		{
			//����ǿͻ������˺��жϣ���ô�������õø���
			//���ֵ�����ȱ�㣺��������λ�úͿͻ��˵�λ�ò��Խ�󣬵����˺��жϲ�ͬ�����ء�
			//			  �ŵ㣺�ƶ������͵���
			//λ�ò�� = CallMoveTimeOut * WalkSpeed
			CallMoveTimeOut = 0.5f;
		}
		CallMoveTimeOut = 0.02f;
		if (LastSentTime + CallMoveTimeOut < Level.TimeSeconds)
		{
			if (Pawn != None)
				LastVelocity = Pawn.Velocity;
			LastRun = NewbRun;
			LastDuck = NewbDuck;
			LastJumpStatus = NewbJumpStatus;
			LastDoubleJump = NewbDoubleJump;
			LastDoubleClickMove = DoubleClickMove;
			LastClientRoll = ClientRoll;
			LastPitch = Rotation.Pitch;
			LastYaw = Rotation.Yaw;
			LastSentTime = TimeStamp;

			Super.CallServerMove
			(
				TimeStamp,
				InAccel,
				ClientLoc,
				NewbRun,
				NewbDuck,
				NewbPendingJumpStatus,
				NewbJumpStatus,
				NewbDoubleJump,
				DoubleClickMove,
				ClientRoll,
				View,
				OldTimeDelta,
				OldAccel
			);
		}
	}
}

defaultproperties
{
     MaxResponseTime=2.000000
}
