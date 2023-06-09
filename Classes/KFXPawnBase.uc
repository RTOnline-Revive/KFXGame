// ====================================================================
//  Class:  KFXGame.KFXWeapBase
//  Creator: Kevin Sun
//  Date: 2007.12.04
//  Description: Base class of KFXPawns
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXPawnBase extends UnrealPawn
	native
	abstract
	dependson(KFXPlayerBase);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

const CONS_decoration_count = 9;

var KFXAvatarPart AvatarHead;
var KFXAvatarPart AvatarLegs;

var int KFXOverLapMasks[32];    //´ËÑÚÂëÓÃÀ´¸²¸ÇµôÒÑ¾­´æÔÚµÄÏàµÖ´¥µÄ×´Ì¬

//==============================================================================
// Old Code

//  ½ÇÉ«µÚÈýÈË³ÆÎäÆ÷Ïà¶ÔÎ»ÖÃ±íË÷Òý
// To be Removed
//var int KFXWeaponLocationCsvIndex;

//  ½ÇÉ«µÚÈýÈË³ÆÎäÆ÷Ïà¶ÔÎ»ÖÃ±í
var string KFXWeapLocTableName;

// Foot Step
var bool bLeftStep;
var float fPlayStepSoundRate;
var config float fShowStepEffectRate;
var float lastShowStepEffectTime;

// Ê¬Ìå´æÁôÊ±¼ä
var float AshesKeepingTime;
var config float ClientAshesKeepingTime;      //¿Í»§¶ËÊ¬ÌåÊ±¼ä£¬ºÍ·þÎñÆ÷²»ÔÙ°ó¶¨£¬Òª²»È»»áµ¼ÖÂ²»³öÉú
// Ê¬ÌåÏûÊ§Ê±¼ä
var float AshesDisappearTime;

///Ê¬Ìå¿É·ñ±»Éä»÷ 0 ²»ÄÜ±»´ò 1 ¿ÉÒÔ±»´ò
var config int AshesHitEnable;

//< Properties from xPawn
var config float FootstepVolume;
var config float FootstepRadius;
var config float HitSoundVolume;
var config float HitSoundRadius;
var config float FootstepRate;
var config float BobTimeFactor;

var float MinTimeBetweenPainSounds;

var sound SoundFootsteps[11]; // Indexed by ESurfaceTypes (sorry about the literal).
var sound SoundLand[11];
var sound SoundFallPains;
var sound HeadshotSound;
var sound BodyshotSound;
var sound KnifeHitSound;
var sound HammerHitSound;
var sound DeadSound;
var sound CrySound[5];

var sound HitBodySound[4];       //´òÔÚÈËÉíÉÏµÄàÛàÛÉù£¬ºÍÊÜÉËÒôÐ§·Ö¿ª£¨Ô­±¾Á½¸öÒôÐ§ÊÇºÍÔÚÒ»ÆðµÄ£©
var sound HitHeadSound[4];


// ½Å²½ÉùÒô
struct native StepSound
{
	var sound RunSound[5];
	var sound JumpSound;
};

var Array<StepSound> StepSounds;
var int LastStepSoundIndex;

// À©Õ¹ÒÆ¶¯¶¯»­
var bool KFXUseEightDirectionMoveAnims;

var name KFXRunAnimsExt[4];
var name KFXWalkAnimsExt[4];
var name KFXCrouchAnimsExt[4];
var name KFXSwimAnimsExt[4];
var name KFXFlyAnimsExt[4];
//À©Õ¹»÷ÖÐÓÅ»¯¶¯»­

// ËÀÍö¶¯»­
var name BombDeathAnimName;     // Õ¨ËÀ¶¯»­Ãû
//ÓÅ»¯ÊÜÉË¶¯×÷£¬Èý²¿·ÖÊ®¶þ¸ö¶¯»­
var name HitHeadDeathAnimExt[12];        //»÷ÖÐÍ·²¿µÄËÀÍö¶¯»­
var name HitCrouchHeadDeathAnimExt[12];  //»÷ÖÐÍ·²¿µÄËÀÍö¶¯»­
var name HitBodyDeathAnimExt[12];        //»÷ÖÐÉíÌåµÄËÀÍö¶¯»­
var name HitCrouchBodyDeathAnimExt[12]; //»÷ÖÐ¶××ÅÊ±ÉíÌåµÄËÀÍö¶¯»­
var name HitLegsDeathAnimExt[3];        //»÷ÖÐÍÈ²¿µÄËÀÍö¶¯»­
var name ExplodeDeathAnimExt[3];        //±¬Õ¨ËÀÍö¶¯×÷

var KFXWeapAttachment WeaponAttachment;

//var ShadowProjector PlayerShadow;

var name FireRootBone;
var name WeaponBone;

// FIXME: to delete!
var enum EFireAnimState
{
	FAS_None,
	FAS_PlayOnce,
	FAS_Looping,
	FAS_Ready
} FireState;
/////////////////////////
//> Properties from xPawn end

//< Properties from UnrealPawn



//> Properties from UnrealPawn end

// Damage Type Relevent
var int KFXHitWeaponID;     // Rep to Client when dead

//----ÎÞËÀÍöÄ£Ê½ÖÐÏÔÊ¾»÷ÖÐ¶ÔÏó·ÖÊý-----------
var float dmgTimeDisply;
//-------------------------------------------
struct native KFXRepDamageInfo
{
	var Pawn   InstigatedBy;
	var WeaponAttachment HitWeapon;
	var vector HitLocation;
	var vector Momentum;
	var byte   DmgShakeView;
	var byte   FlashCount;
	var int     HitWeaponID;    //»÷É±µÄÎäÆ÷id
	var int    DamageVal;
};
var KFXRepDamageInfo KFXDmgRepInfo;
var KFXRepDamageInfo KFXSavedDmgRepInfo;  // Client Êµ¼ÊÓ¦ÓÃµÄKFXRepDamageInfo

// Armor Relevent
var int   KFXArmorID;            // »¤¼×ID
var int   KFXArmorPoints;        // »¤¼×Öµ
var int   KFXArmorMaxPoints;     // ×î¸ß»¤¼×Öµ
var float KFXArmorHeadFactor;    // »¤¼×µÄÍ·²¿±£»¤ÏµÊý
var float KFXArmorBodyFactor;    // »¤¼×µÄÉíÌå±£»¤ÏµÊý

/////////////////////////////////////////
// added by duodonglai to test doubleJump
var int  MultiJumpRemaining;
var config int MaxMultiJump;
var int  DoubleJumpZ; // depends on the tolerance (100)
var config float DoubleJumpZThresh;
///////////////////////// ///////////////

//var float KFXCollisionRadius;
//var float KFXCollisionHeight;

var bool bIsGroveling;  // ÊÇ·ñ´¦ÓÚÅ¿×ÅµÄ×´Ì¬

var config bool bKFXCanDodge;  // ¼±ÉÁ¿ª¹Ø
var int CanMoveCount;      // Îª0Ôò¿ÉÒÔÒÆ¶¯,>0 ½ûÖ¹ÒÆ¶¯
var bool bCanFire;      // ÊÇ·ñ¿ÉÒÔ¿ªÇ¹
var bool bCanUseWeapon;

//var bool bProneKilled;
// TODO:ÕæµÄÐèÒªÂð?
var float ProneCollisionRadius;
var float ProneCollisionHeight;

// ÉËº¦²ÎÊý
var float KFXDamageFactor;   //ÉËº¦Òò×Ó

//--------------hitboxÅÐ¶ÏÉËº¦-------
var array<float> KFXDiffPartDmg;
//--------------hitboxÅÐ¶ÏÉËº¦-------
//±¬Í·¸ÅÂÊ
var float KFXHeadKillProb;

var float KFXAnimalRecoverTime;      ///<±ä³É¶¯Îïºó»Ö¸´¼õÉÙÊ±¼ä


var float KFXFPSoundScale;   // ½Å²½ÉùÒôÁ¿Scale£¬½Å²½ÉùÏµÊý
var float KFXSpeedScale;     // ÒÆ¶¯ËÙ¶ÈScale
//-----¼øÓÚÐèÇó±È½Ï¼òµ¥ËùÒÔ¾Í²»°´ÕÕÕý¹æÍ¾¾¶´¦Àí-------------

var bool   KFXLevelAllowHideWeap; //ÆðÌøÊ±µØÐÎÒòËØ¿ØÖÆÊÇ·ñ¿ÉÒÔÊÕÇ¹£¬ÆðÌøºÍ×¹Âä¸ß¶È´óÓÚÁÙ½çµã£¨50£©µÄÊ±ºò¾ùÖÃÎªtrue
var float  WeapJumpFactor;//ÆðÌøÊÕÇ¹¿ØÖÆÒò×Ó
var int TickIndex;
//--------------------------
//==============================================================================
// newpawn

// ½ÇÉ«µÄÅäÖÃÐÅÏ¢
struct native KFXStatePack
{
	var byte Revision;
	var byte TeamID;
	var int  nRoleID;        // pawnlistÖÐµÄid
	//... Avatar Data
	var int     nDecorations[CONS_decoration_count];
	var int nSuitID;  //»»×°µÄÌ××°Ä£ÐÍ
//    var int   nFace;
//    var int   nHand;
//    var int       nRear;
//    var int       nWaist;
//    var int   nLeftReg;
//    var int       nRightReg;
//    var int       nFoot;
};
var KFXStatePack KFXCurrentState;  // Current state
var KFXStatePack KFXPendingState;  // state To Be
var KFXStatePack KFXNormalState;   // Normal State, ÓÃÓÚ±äÉí»Ö¸´

var bool bSpecialRoleState;        // ÌØÊâ½ÇÉ«,·ÇÕý³£×´Ì¬(ÀýÈçÖí)

// Ö§³ÖAvatarÏµÍ³,Pawn±¾Éí×÷ÎªÉíÌå²¿·Ö³öÏÖ,
enum EAvatarPart
{
	Avatar_None,
	Avatar_Body,
	Avatar_Head,
	Avatar_Legs
};
// Avatar¶ÔÓ¦µÄID:·ÖÎª»ù´¡Ä£ÐÍ, Í·,ÉíÌå,ÍÈ
struct native KFXAvatarData
{
	var int nBodyID;  // Avatar»»×°µÄÉíÌåÄ£ÐÍ
	var int nHeadID;  // Avatar»»×°µÄÍ·Ä£ÐÍ
	var int nLegsID;  // Avatar»»×°µÄÍÈÄ£ÐÍ
	//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.9
	//var int nSuitID;  //»»×°µÄÌ××°Ä£ÐÍ
};

//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.2.6
// KFXAvatarDataÔÚKFXIsAvatarÎªtrueµÄÇé¿öÏÂ²ÅÍ¬²½ ËùÒÔ±ØÐëµ¥ÄÃ³öÀ´

var KFXAvatarData KFXAvatar;
var bool KFXIsAvatar; // ÊÇ·ñÖ§³ÖAvatar»»×°

//--------------------------------------------
var int KFXDefAniState; // Ä¬ÈÏ¶¯»­×é
var int KFXCurAniState;//µ±Ç°¶¯»­×é--------ÓÉÓÚ·ÇÖ÷¿Ø¿Í»§¶ËÎÞ·¨·ÃÎÊweapon¹ÊÎ¬»¤´Ë±äÁ¿£¬¿Í»§¶Ë×¨ÓÃ
var name FireAnim[2];
var name CrouchFireAnim[2];
var name HitAnim[4];
var name ReloadAnim;
var name CrouchReloadAnim;
var name SwitchWeaponAnim;
var name UndeployAnim;       // Ò»°ãÓÉÎäÆ÷¶¯Ì¬Ö¸¶¨

//----------------------------------------
//ÓÅ»¯ÊÜÉË¶¯×÷£¬Èý²¿·ÖÊ®¶þ¸ö¶¯»­  ÏÖÔÚ¸ÄÎªÈý²¿·Ö36¸ö¶¯»­ ½«¶¯»­¶¼À©Õ¹µ½Èý¸ö
var name HitHeadAnimExt[12];
var name HitBodyAnimExt[12];
var name HitLegAnimExt[12];
var name CHitAnimExt[3];
//--------------------------------------------


//============================»ù±¾ÐÐ×ß¶¯»­ basic movement Anims
var name BlendRunAnim[4];            //ÅÜ²½
var name BlendWalkAnims[4];           //ÐÐ×ß
var name BlendCrouchAnims[4];         //¶××ß


// Ó°×ÓµÄÍ¶Éä
var ShadowProjector KFXPlayerBodyShadow;
var ShadowProjector KFXPlayerHeadShadow;
var ShadowProjector KFXPlayerLegsShadow;
//var ScenceActorHUDProjector ScenceActorHUDProjector;
//ÒþÉí¹¦ÄÜ
//-------------------------------------------
var Material KFXInvisSkin;//´æ´¢ÒþÉí²ÄÖÊ
//---------------------------------------

// ±äÉíÏà¹Ø²ÎÊý
var class<Actor> BornEffectClass;
var class<Actor> RecoverEffectClass;
var class<Actor> LastRecoverEffectClass;

var class<Actor> StepWaterEffectClass;

//--------------------------------------------
// Ragdoll Ïà¹Ø±äÁ¿
var(Karma) bool  RagdollEnabled;    // Enable Ragdoll
var(Karma) string RagdollOverride;  // The Karma asset to use as a ragdoll
var(Karma) float RagInvInertia;     // Use to work out how much 'spin' ragdoll gets on death.
var(Karma) float RagDeathVel;       // How fast ragdoll moves upon death
var(Karma) float RagShootStrength;  // How much effect shooting ragdolls has. Be careful!
var(Karma) float RagSpinScale;      // Increase propensity to spin around Z (up).
var(Karma) float RagDeathUpKick;    // Amount of upwards kick ragdolls get when they die

//--------------------------------------------


// Heqingming.Use 4 direction to emulate 8 direction by rotating following bones appropriately.
var name PelvisBone,Spine1Bone,Spine2Bone,Spine3Bone; //´Ócsv±íÖÐ¶ÁÈ¡¹Ê½«ÆätransientÊôÐÔÈ¥µô£¬ÔÊÐí±£Áôµ½uÎÄ¼þÖÐ
var transient int LastAngleRotated,LastFacingDir,SmoothStep;
var transient float LastSecSmooth,CurrentSecSmooth;

var float fxKFXGasArmourFactor;       // ¶¾Æø·À»¤¿¨:¶¾ÆøÊÜÉË¼õÉÙÒò×Ó

var vector CameraOffset;

var float SpeedDownTime;
var float SpeedDownFactor;
var config float DamagedSpeedDownRate;      //ÊÜÉË¼õËÙÒò×Ó

var float DamageValue;
var globalconfig float  LandedSpeedDownScale;      ///  ÌøÆðºóÂäµØËÙ¶È½µµÄ±ÈÂÊ
replication
{
	reliable if( Role==ROLE_Authority && bNetDirty )
		KFXPendingState, bIsGroveling/*, KFXArmorPoints*/, KFXHitWeaponID, KFXFPSoundScale, KFXSpeedScale, KFXDmgRepInfo ,KFXArmorBodyFactor,
		fxKFXGasArmourFactor,LandedSpeedDownScale;
	reliable if( Role==ROLE_Authority && bNetDirty && bNetOwner )
		SpeedDownFactor, SpeedDownTime, DoubleJumpZ, DoubleJumpZThresh, MaxMultiJump, ProneCollisionHeight, ProneCollisionRadius, CanMoveCount, bCanFire, bCanUseWeapon;
	reliable if( Role==ROLE_Authority && bNetDirty && KFXIsAvatar )
		KFXAvatar,ClientChangeDuck;
	unreliable if(Role < Role_Authority)
        ServerTakeFallingDamage, KFXServerModifyVelocity,ServerSetQuickChangeToss,ServerLanded;
	reliable if( Role==ROLE_Authority && bNetInitial)
		DamagedSpeedDownRate;
}

simulated function TurnOff()
{
	SetCollision(true,false);
	AmbientSound = None;
	bNoWeaponFiring = true;
	AnimBlendToAlpha( 2,0,0);
// Kevin Sun: ½â¾öÐ¡¾Ö½áÊø¶¯»­²¥·ÅµÄÎÊÌâ
//    Velocity = vect(0,0,0);
//    SetPhysics(PHYS_None);
//    bPhysicsAnimUpdate = false;
//    bIsIdle = true;
//    bWaitForAnim = false;
//    StopAnimating();
//    bIgnoreForces = true;
}

//=============================================================================
// ¶¯»­Ïà¹Øº¯Êý                                                 `

simulated event SetAnimAction(name NewAction)
{
	if ( !HasAnim(NewAction) )
		return;

	PlayAnim(NewAction);
}

// AnimEnd£º Close Channel 1
simulated event AnimEnd(int Channel)
{
	if (Channel == 2)
	{
		AnimBlendToAlpha(2, 0.0,0.12 );
	}
}

// Client Only
// ¸ù¾ÝÊ¹ÓÃµÄ²»Í¬ÎäÆ÷ºÍËù´¦²»Í¬×´Ì¬£¬½ÇÉ«¶¯»­±»»®·Ö³É²»Í¬µÄ×é
simulated function int KFXGetAniGroupIndex();

// Client Only
// ×ª»»µ½Ö¸¶¨µÄ¶¯»­×é, -1±íÊ¾³õÊ¼¶¯»­
simulated function KFXChangeAniGroup(int index)
{
	local KFXPlayerBase.KFXPawnStateAnims AnimGroup;
	local KFXPlayerBase.KFXTakeDamagedAnims DamagedAnimGroup;
	local KFXPlayerBase.KFXPawnBlendAnims BlendAnimGroup;
	local KFXPlayerBase Player;
	local name OldIdleAnim;
	local float OldIdleFrame, OldIdleRate;
	local int loop;
	local int i;
	local bool OrigAnim;

	Player = KFXPlayerBase(Level.GetLocalPlayerController());
	log("[Pawn]  KFXChangeAniGroup "$index@WeaponAttachment);

	OrigAnim = index==-1;
	if(OrigAnim)
		index = 0;	//Ä¬ÈÏÊÇÄÃÀ×µÄ¶¯×÷£¬Èç¹û²»Í×£¬ÈÃÃÀÊõ×öÒ»Ì×¡£

//    if ( Player == none ) return;

	//¼ÇÂ¼¾ÉµÄ¶¯×÷£¬·ÀÖ¹¶¯×÷Í»È»±ä»¯£¿
//    if ( Controller==none || PlayerController(Controller).bBehindView )
//    {
		GetAnimParams(1, OldIdleAnim, OldIdleFrame, OldIdleRate);
//  }
/*
//============================´ô´ô¶¯»­ Stupid Idle Anims
var name BlendIdleStandAnims;         //´ôÕ¾
var name BlendIdleCrouchAnims;        //´ô¶×
var name BlendIdleChatAnims;          //ÁÄÌì
var name BlendIdleRestAnims;          //ÐÝÏ¢
var name BlendIdleTakeoffAnims;       //´ôÌÚ¿Õ

*/
	AnimGroup       = Player.KFXGetPawnStateAnimGroup(index);
	DamagedAnimGroup =  Player.KFXGetDamagedPawnAnimGroup(index);
	BlendAnimGroup  = Player.KFXGetKFXPawnBlendAnimsGroup(index);

    //log("[Pawn]  KFXChangeAniGroup animation:"$AnimGroup.@DamagedAnimGroup@BlendAnimGroup);

    if(OrigAnim	//½ÇÉ«³õÊ¼Ê±£¬ÊÇÃ»ÓÐÎäÆ÷µÄ¡£
		|| (WeaponAttachment != none && WeaponAttachment.ComponentID[2]==0))
    {
		for( loop = 0 ; loop<4 ; loop++ )
		{
			 MovementAnims[loop] = AnimGroup.Run[loop];
			 CrouchAnims[loop]   = AnimGroup.Crouch[loop];
			 WalkAnims[loop]     = AnimGroup.Walk[loop];
			 TakeoffAnims[loop]  = AnimGroup.Takeoff[loop];
			 LandAnims[loop]     = AnimGroup.Land[loop];
	//         HitHeadAnimExt[loop]= AnimGroup.HitHead[loop];
	//         HitBodyAnimExt[loop]= AnimGroup.HitBody[loop];
	//         HitLegAnimExt[loop] = AnimGroup.HitLegs[loop];

			 for(i=0; i<3; i++)
			 {
				 HitHeadAnimExt[loop + i * 4] = DamagedAnimGroup.HitHead[i * 4 + loop];
				 HitBodyAnimExt[loop + i * 4] = DamagedAnimGroup.HitBody[i * 4 + loop];
				 HitLegAnimExt [loop + i * 4] = DamagedAnimGroup.HitLegs[i * 4 + loop];
			 }

			 BlendRunAnim[loop]  = BlendAnimGroup.Run[loop];
			 BlendWalkAnims[loop]= BlendAnimGroup.Walk[loop];
			 BlendCrouchAnims[loop] = BlendAnimGroup.Crouch[loop];
			 BlendTakeoffAnims[loop] = BlendAnimGroup.Takeoff[loop];
			 BlendLandAnims[loop]   = BlendAnimGroup.Land[loop];

		}
		for(i=0; i < 3; i++)
		{
			//CHitAnimExt     = AnimGroup.CHitAnim;
			CHitAnimExt[i] = DamagedAnimGroup.CHitAnim[i];
		}


		TurnLeftAnim     = AnimGroup.RunTurn[0];
		TurnRightAnim    = AnimGroup.RunTurn[1];
		CrouchTurnRightAnim = AnimGroup.CrouchTurn[0];
		CrouchTurnLeftAnim  = AnimGroup.CrouchTurn[1];

		BlendRunTurnAnims[0] = BlendAnimGroup.RunTurn[0];
		BlendRunTurnAnims[1] = BlendAnimGroup.RunTurn[1];
		BlendWalkTurnAnims[0] = BlendAnimGroup.WalkTurn[0];
		BlendWalkTurnAnims[1] = BlendAnimGroup.WalkTurn[1];
		BlendCrouchTurnAnims[0] = BlendAnimGroup.CrouchTurn[0];
		BlendCrouchTurnAnims[1] = BlendAnimGroup.CrouchTurn[1];


		IdleWeaponAnim = AnimGroup.IdleStand;
		IdleCrouchAnim = AnimGroup.IdleCrouch;
		IdleChatAnim   = AnimGroup.IdleChat;
		IdleRestAnim   = AnimGroup.IdleRest;
		TakeoffStillAnim = AnimGroup.IdleTakeoff;


		BlendIdleStandAnims = BlendAnimGroup.IdleStand;
		BlendIdleCrouchAnims = BlendAnimGroup.IdleCrouch;
		BlendIdleChatAnim = BlendAnimGroup.IdleChat;
		BlendIdleRestAnims = BlendAnimGroup.IdleRest;
		BlendIdleTakeoffAnims = BlendAnimGroup.IdleTakeoff;

	//JumpCrouchAnim     = AnimGroup.JumpCrouch;

		FireAnim[0]         = AnimGroup.StandFire[0];
		FireAnim[1]         = AnimGroup.StandFire[1];
		CrouchFireAnim[0]   = AnimGroup.CrouchFire[0];
		CrouchFireAnim[1]   = AnimGroup.CrouchFire[1];
		SwitchWeaponAnim    = AnimGroup.SwitchWeapon;
		ReloadAnim          = AnimGroup.StandReload;
		CrouchReloadAnim    = AnimGroup.CrouchReload;

		BoneRefresh();

	}
	else
	{
		for( loop = 0 ; loop<4 ; loop++ )
		{
			 if(AnimGroup.Run[loop]!='') MovementAnims[loop] = class'DataTable'.static.StringToName(AnimGroup.Run[loop]$"_G");
			 if(AnimGroup.Crouch[loop]!='') CrouchAnims[loop]   = class'DataTable'.static.StringToName(AnimGroup.Crouch[loop]$"_G");
			 if(AnimGroup.Walk[loop]!='') WalkAnims[loop]     = class'DataTable'.static.StringToName(AnimGroup.Walk[loop]$"_G");
			 if(AnimGroup.Takeoff[loop]!='') TakeoffAnims[loop]  = class'DataTable'.static.StringToName(AnimGroup.Takeoff[loop]$"_G");
			 if(AnimGroup.Land[loop]!='') LandAnims[loop]     = class'DataTable'.static.StringToName(AnimGroup.Land[loop]$"_G");
	//         HitHeadAnimExt[loop]= AnimGroup.HitHead[loop];
	//         HitBodyAnimExt[loop]= AnimGroup.HitBody[loop];
	//         HitLegAnimExt[loop] = AnimGroup.HitLegs[loop];

			 for(i=0; i<3; i++)
			 {
				 if(DamagedAnimGroup.HitHead[i * 4 + loop]!='') HitHeadAnimExt[loop + i * 4] = class'DataTable'.static.StringToName(DamagedAnimGroup.HitHead[i * 4 + loop]$"_G");
				 if(DamagedAnimGroup.HitBody[i * 4 + loop]!='') HitBodyAnimExt[loop + i * 4] = class'DataTable'.static.StringToName(DamagedAnimGroup.HitBody[i * 4 + loop]$"_G");
				 if(DamagedAnimGroup.HitLegs[i * 4 + loop]!='') HitLegAnimExt [loop + i * 4] = class'DataTable'.static.StringToName(DamagedAnimGroup.HitLegs[i * 4 + loop]$"_G");
			 }

			 if(BlendAnimGroup.Run[loop]!='') BlendRunAnim[loop]  = class'DataTable'.static.StringToName(BlendAnimGroup.Run[loop]$"_G");
			 if(BlendAnimGroup.Walk[loop]!='') BlendWalkAnims[loop]= class'DataTable'.static.StringToName(BlendAnimGroup.Walk[loop]$"_G");
			 if(BlendAnimGroup.Crouch[loop]!='') BlendCrouchAnims[loop] = class'DataTable'.static.StringToName(BlendAnimGroup.Crouch[loop]$"_G");
			 if(BlendAnimGroup.Takeoff[loop]!='') BlendTakeoffAnims[loop] = class'DataTable'.static.StringToName(BlendAnimGroup.Takeoff[loop]$"_G");
			 if(BlendAnimGroup.Land[loop]!='') BlendLandAnims[loop]   = class'DataTable'.static.StringToName(BlendAnimGroup.Land[loop]$"_G");

		}
		for(i=0; i < 3; i++)
		{
			//CHitAnimExt     = AnimGroup.CHitAnim;
			if(DamagedAnimGroup.CHitAnim[i]!='') CHitAnimExt[i] = class'DataTable'.static.StringToName(DamagedAnimGroup.CHitAnim[i]$"_G");
		}


		if(AnimGroup.RunTurn[0]!='') TurnLeftAnim     = class'DataTable'.static.StringToName(AnimGroup.RunTurn[0]$"_G");
		if(AnimGroup.RunTurn[1]!='') TurnRightAnim    = class'DataTable'.static.StringToName(AnimGroup.RunTurn[1]$"_G");
		if(AnimGroup.CrouchTurn[0]!='') CrouchTurnRightAnim = class'DataTable'.static.StringToName(AnimGroup.CrouchTurn[0]$"_G");
		if(AnimGroup.CrouchTurn[1]!='') CrouchTurnLeftAnim  = class'DataTable'.static.StringToName(AnimGroup.CrouchTurn[1]$"_G");

		if(BlendAnimGroup.RunTurn[0]!='') BlendRunTurnAnims[0] = class'DataTable'.static.StringToName(BlendAnimGroup.RunTurn[0]$"_G");
		if(BlendAnimGroup.RunTurn[1]!='') BlendRunTurnAnims[1] = class'DataTable'.static.StringToName(BlendAnimGroup.RunTurn[1]$"_G");
		if(BlendAnimGroup.WalkTurn[0]!='') BlendWalkTurnAnims[0] = class'DataTable'.static.StringToName(BlendAnimGroup.WalkTurn[0]$"_G");
		if(BlendAnimGroup.WalkTurn[1]!='') BlendWalkTurnAnims[1] = class'DataTable'.static.StringToName(BlendAnimGroup.WalkTurn[1]$"_G");
		if(BlendAnimGroup.CrouchTurn[0]!='') BlendCrouchTurnAnims[0] = class'DataTable'.static.StringToName(BlendAnimGroup.CrouchTurn[0]$"_G");
		if(BlendAnimGroup.CrouchTurn[1]!='') BlendCrouchTurnAnims[1] = class'DataTable'.static.StringToName(BlendAnimGroup.CrouchTurn[1]$"_G");


		if(AnimGroup.IdleStand!='') IdleWeaponAnim = class'DataTable'.static.StringToName(AnimGroup.IdleStand$"_G");
		if(AnimGroup.IdleCrouch!='') IdleCrouchAnim = class'DataTable'.static.StringToName(AnimGroup.IdleCrouch$"_G");
		if(AnimGroup.IdleChat!='') IdleChatAnim   = class'DataTable'.static.StringToName(AnimGroup.IdleChat$"_G");
		if(AnimGroup.IdleRest!='') IdleRestAnim   = class'DataTable'.static.StringToName(AnimGroup.IdleRest$"_G");
		if(AnimGroup.IdleTakeoff!='') TakeoffStillAnim = class'DataTable'.static.StringToName(AnimGroup.IdleTakeoff$"_G");


		if(BlendAnimGroup.IdleStand!='') BlendIdleStandAnims = class'DataTable'.static.StringToName(BlendAnimGroup.IdleStand$"_G");
		if(BlendAnimGroup.IdleCrouch!='') BlendIdleCrouchAnims = class'DataTable'.static.StringToName(BlendAnimGroup.IdleCrouch$"_G");
		if(BlendAnimGroup.IdleChat!='') BlendIdleChatAnim = class'DataTable'.static.StringToName(BlendAnimGroup.IdleChat$"_G");
		if(BlendAnimGroup.IdleRest!='') BlendIdleRestAnims = class'DataTable'.static.StringToName(BlendAnimGroup.IdleRest$"_G");
		if(BlendAnimGroup.IdleTakeoff!='') BlendIdleTakeoffAnims = class'DataTable'.static.StringToName(BlendAnimGroup.IdleTakeoff$"_G");

		//if(AnimGroup.JumpCrouch!='') JumpCrouchAnim    = class'DataTable'.static.StringToName(AnimGroup.JumpCrouch$"_G");

		if(AnimGroup.StandFire[0]!='') FireAnim[0]         = class'DataTable'.static.StringToName(AnimGroup.StandFire[0]$"_G");
		if(AnimGroup.StandFire[1]!='') FireAnim[1]         = class'DataTable'.static.StringToName(AnimGroup.StandFire[1]$"_G");
		if(AnimGroup.CrouchFire[0]!='') CrouchFireAnim[0]   = class'DataTable'.static.StringToName(AnimGroup.CrouchFire[0]$"_G");
		if(AnimGroup.CrouchFire[1]!='') CrouchFireAnim[1]   = class'DataTable'.static.StringToName(AnimGroup.CrouchFire[1]$"_G");
		if(AnimGroup.SwitchWeapon!='') SwitchWeaponAnim    = class'DataTable'.static.StringToName(AnimGroup.SwitchWeapon$"_G");
		if(AnimGroup.StandReload!='') ReloadAnim          = class'DataTable'.static.StringToName(AnimGroup.StandReload$"_G");
		if(AnimGroup.CrouchReload!='') CrouchReloadAnim    = class'DataTable'.static.StringToName(AnimGroup.CrouchReload$"_G");

		BoneRefresh();
	}

	//    self.StopAnimating(true);

	//½¨Á¢µÚÒ»Í¨µÀµÄÈÚºÏ
	AnimBlendParams( 1,1,0,0,Spine1Bone);
	AnimBlendParams(2, 1.0, 0.0, 0.0);
	AnimBlendParams(2, 1.0, 0.0, 0.0, Spine1Bone);

	if((Physics == PHYS_Walking || Physics == PHYS_Falling || Physics == PHYS_Ladder) && (!bWaitForAnim) )
	{
		if(OldIdleAnim!='')
		{
			;
			AnimBlendToAlpha( 2,0,0.3);
			PlayAnim(OldIdleAnim,3,,2);
		}
		if ( Level.GetLocalPlayerController().IsInState('EoundEnded') || Level.GetLocalPlayerController().IsInState('GameEnded'))
		{
			AnimBlendToAlpha( 2,0,0);
		}

		if(IsInState('Dying'))
		{}
		else
		{
			if(bIsCrouched)
			{
				PlayAnim(BlendIdleCrouchAnims,3,,1);
				PlayAnim(IdleCrouchAnim);
			}
			else
			{
				PlayAnim(BlendIdleStandAnims,3,,1);
				PlayAnim(IdleWeaponAnim);
			}
		}
	}


}

simulated function KFXPlayFiring(KFXWeapAttachment weap, optional int mode, optional bool bFirst)
{

	local name AnimName;
	local float AnimFrame, AnimRate;
	local name FinalFireAnim;

	// ???
	//if (Physics == PHYS_Swimming)
	//    return;

//    if( bFirst )
//        return;

	if ( bIsCrouched )
		FinalFireAnim = CrouchFireAnim[mode];
	else
		FinalFireAnim = FireAnim[mode];

	FinalFireAnim = weap.KFXHackFireAnim(FinalFireAnim);

	GetAnimParams(2, AnimName, AnimFrame, AnimRate);

	if(!IsAnimating(2)|| AnimName==FinalFireAnim )
	{
		;
		AnimBlendParams(2, 1.0, 0.0, 0.0, FireRootBone);
		PlayAnim(FinalFireAnim,1.0, 0.0, 2);
	}

//Nooooooooootice£ºÕâÀïÊÇÇåÃ÷¸ç×¢ÊÍµÄÒ»¸öÎÊÌâ£¬Ô­À´ÎªÊ²Ã´²»ÄÜ×ö¶×ÏÂÉä»÷µÄ¶¯×÷ÈÚºÏ?
//Èç¹ûÒÔºó·¢ÏÖÕâÀïÓÐ¶¯×÷Bug£¬ÄÇÃ´»Ö¸´Õâ¶Î´úÂë£¬²¢ÇÒÒªÇóÃÀÊõÖÆ×÷¶×ÏÂ¿ªÇ¹µÄ¶¯»­¡£

// Heqingming.play on channel 0 when idle to correct no leg animation.
//    if ( !bIsIdle)// && !IsAnimating(1)
//  {
//      if(!IsAnimating(1))
//      {
//          LOG("<<<<<<<<<<<||>>>>>>>>>>>>>Firing Anim Blend Called!");
//          AnimBlendParams(1, 1.0, 0.0, 0.0, FireRootBone);
//          PlayAnim(FinalFireAnim,1.0, 0.0, 1);
//        }
//  }
//  else
//  {
//        LOG("<========||========>Nooooooooooo Blend Called!");
//      PlayAnim(FinalFireAnim,, 0.0, 0);
//  }
	//FireState = FAS_PlayOnce;
}

simulated function KFXStopFiring(KFXWeapAttachment weap, optional int mode)
{
//    if (FireState == FAS_Looping)
//    {
//        FireState = FAS_PlayOnce;
//    }
	log("KFXPawnBase-------weap.KFXGetAnimIndex() "$weap.KFXGetAnimIndex());
	if(weap.KFXGetAnimIndex() == 0) // C4Õ¨µ¯,È¡Ïû°²×°¶¯×÷
	{
		StopAnimating();//ÖÐÖ¹µÚÈýÈË³ÆÉùÒô
		AnimBlendToAlpha(2, 0.0, 0.12);
	}
}

simulated function KFXPlayReload(KFXWeapAttachment weap)
{
	local name FinalReloadAnim;
	local float ReloadRate;

	// ???
	//if (Physics == PHYS_Swimming)
	//    return;

	if ( bIsCrouched )
		FinalReloadAnim = CrouchReloadAnim;
	else
		FinalReloadAnim = ReloadAnim;
	FinalReloadAnim = weap.KFXHackReloadAnim(FinalReloadAnim);

	;
	AnimBlendParams(2, 1.0, 0.0, 0.2, FireRootBone);

	// Õë¶Ô¿ìËÙ»»µ¯¿¨½øÐÐµ÷Õû¶¯»­
	ReloadRate = KFXPlayerReplicationInfo(self.PlayerReplicationInfo).fxFastSwitchAmmoRate;
	PlayAnim(FinalReloadAnim,ReloadRate, 0.0, 2);

	//FireState = FAS_PlayOnce;
}
//------ÇÐÇ¹ÖÕÖ¹µÚÈýÈË³ÆÉùÒô
simulated function KFXSwitchStop()
{
	local name anim;
	local float frame, rate;

	KFXStopSound(self,none);

	if ( IsAnimating(2) )
	{
	   //¹Øµôchannel 2
	   AnimBlendToAlpha(2, 0, 0);
//       AnimBlendToAlpha(1, 0, 0);
	}

	GetAnimParams(2, anim, frame, rate);
	;

}
// Client Only ¸Ãº¯ÊýÒÑ¾­ÓÉ×ÓÀàÖØÐ´
simulated function KFXPlayDyingAnimation(class<DamageType> DamageType, int HitWeaponID, vector HitLoc);
//{
//    local int WeaponType;
//
//    local Vector X,Y,Z, Dir;
//    local int Direction,HitPart,i;
//    local name HitAnimation;
//    local vector pos;
//    HitPart=KFXGetHitPartByHeight(HitLoc);
//    if(HitPart<0)
//    {
//        log("[KFXPawnBase] HitPart is error!!!!");
//        return;
//    }
//    log("Pawn------Controller "$Controller);
//    log("Pawn-----Level.GetLocalPlayerController()"$Level.GetLocalPlayerController());
//    GetAxes(Rotation, X,Y,Z);
//    HitLoc.Z = Location.Z;
//
//    // random
//    if ( VSize(Location - HitLoc) < 1.0 )
//    {
//        Dir = VRand();
//    }
//    // hit location based
//    else
//    {
//        Dir = -Normal(Location - HitLoc);
//    }
//
//    if ( Dir dot X > 0.7 || Dir == vect(0,0,0))
//    {
//        Direction = 0;
//    }
//    else if ( Dir dot X < -0.7 )
//    {
//        Direction = 1;
//    }
//    else if ( Dir dot Y > 0 )
//    {
//        Direction = 3;
//    }
//    else
//    {
//        Direction = 2;
//    }
//
//    WeaponType = HitWeaponID >> 16;
//    if ( bIsCrouched )
//    {
//        DefPrePivot.Z += 40;
//        PrePivot = DefPrePivot;
////        pos = Location;
////
////        pos.Z += 24;
////        SetLocation(pos);
//    }
//    else
//    {
//        SetCollisionSize(default.CollisionRadius, default.CollisionHeight + 24);
//        pos = Location;
//        pos.Z += 24;
//        SetLocation(pos);
//    }
//
//    KFXPlayDyingSound();
//
//    AnimBlendParams( 2,1,0,1);
//
//    if (DamageType.default.bDelayedDamage)
//    {
//        i = rand(3);
//        PlayAnim(ExplodeDeathAnimExt[i],1.0,,2);
//        PlayAnim(ExplodeDeathAnimExt[i],1.0,,1);
//        PlayAnim(ExplodeDeathAnimExt[i],1.0,,0);
//        //log("[KFXPawnBase]  KFXPlayDyingAnimation  ExplodeAnim:"$ExplodeDeathAnimExt[i]);
//        return;
//    }
//
//  switch(HitPart)
//  {
//      case 0:
//      if ( bIsCrouched )
//      {
//            HitAnimation=HitCrouchHeadDeathAnimExt[Direction*3+rand(3)];
//        }
//        else
//        {
//            HitAnimation=HitHeadDeathAnimExt[Direction*3+rand(3)];
//        }
//
//        Spawn(class<Actor>(DynamicLoadObject("KFXEffects.fx_effect_headshot",Class'class')),self,,Location,Rotation);
//        break;
//      case 1:
//      if ( bIsCrouched )
//      {
//            HitAnimation=HitCrouchBodyDeathAnimExt[Direction*3+rand(3)];
//        }
//        else
//        {
//            HitAnimation=HitBodyDeathAnimExt[Direction*3+rand(3)];
//        }
//        break;
//      case 2:
//      if ( bIsCrouched )
//      {
//            HitAnimation=HitCrouchBodyDeathAnimExt[Direction*3+rand(3)];
//        }
//        else
//            HitAnimation = HitLegsDeathAnimExt[rand(3)];
//
//        break;
//  }
//  //LOG("PlayDying Animation:"$HitAnimation );
//    PlayAnim(HitAnimation, 1.0, 0, 2);
//    PlayAnim(HitAnimation, 1.0, 0, 1);
//    PlayAnim(HitAnimation, 1.0, 0, 0);
//
//}

simulated function KFXPlayDyingSound()
{
	PlaySound(DeadSound, SLOT_Pain,
	HitSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
	HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
}

function TakeDamage( float Damage, Pawn instigatedBy, Vector Hitlocation,
						vector momentum, class<DamageType> damageType)
{
	KFXDmgRepInfo.InstigatedBy  = instigatedBy;
	KFXDmgRepInfo.HitLocation   = Hitlocation;
	KFXDmgRepInfo.Momentum      = momentum;
	KFXDmgRepInfo.DmgShakeView  = KFXDmgInfo.DmgShakeView;
	KFXDmgRepInfo.HitWeapon = WeaponAttachment(instigatedBy.Weapon.ThirdPersonActor);
	//KFXDmgRepInfo.HitWeaponID = KFXDmgInfo.WeaponID;
	KFXHitWeaponID = KFXDmgInfo.WeaponID;
	_TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}
simulated function ClientTakeDamage(out float HealthVP,out float Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	KFXDmgRepInfo.InstigatedBy  = instigatedBy;
	KFXDmgRepInfo.HitLocation   = Hitlocation;
	KFXDmgRepInfo.Momentum      = momentum;
	KFXDmgRepInfo.DmgShakeView  = KFXDmgInfo.DmgShakeView;
	KFXDmgRepInfo.HitWeapon = WeaponAttachment(instigatedBy.Weapon.ThirdPersonActor);
	//KFXDmgRepInfo.HitWeaponID = KFXDmgInfo.WeaponID;
	KFXHitWeaponID = KFXDmgInfo.WeaponID;
	_ClientTakeDamage(HealthVP,Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

function GasDamage( int Damage, Pawn instigatedBy, Vector Hitlocation,
						vector momentum, class<DamageType> damageType)
{
	KFXDmgRepInfo.InstigatedBy  = instigatedBy;
	KFXDmgRepInfo.HitLocation   = Hitlocation;
	KFXDmgRepInfo.Momentum      = momentum;
	KFXDmgRepInfo.DmgShakeView  = KFXDmgInfo.DmgShakeView;
	KFXDmgRepInfo.HitWeapon = WeaponAttachment(instigatedBy.Weapon.ThirdPersonActor);
	//KFXDmgRepInfo.HitWeaponID = KFXDmgInfo.WeaponID;
	KFXHitWeaponID = KFXDmgInfo.WeaponID;
	_GasDamage(Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}
// Ëæ±ãÉ±
simulated function float ClientReduceDamage
(
	float Damage,
	pawn injured,
	pawn instigatedBy,
	vector HitLocation,
	out vector Momentum,
	class<DamageType> DamageType
)
{
	local float ArmorPct;

	if(KFXVehiclesBase(injured)!=none)
	{
		Damage = KFXVehiclesBase(injured).KFXClientHixBoxDmg(Damage, KFXVehiclesBase(injured).KFXDmgInfo.HitBoxID);
	}
	else if(KFXPawn(injured)!=none)
	{
		// »¤¼×¼ÆËã
		if ( instigatedBy == none )
		{
			ArmorPct = 1;
		}
		else
		{
			ArmorPct =  KFXPawn(injured).KFXDmgInfo.ArmorPct;
		}
		if( DamageType != class'Fell'  )
			Damage = KFXPawn(injured).KFXArmorAbsorbDmg(Damage, KFXPawn(injured).KFXDmgInfo.HitBoxID );
		Damage = KFXPawn(injured).KFXClientHixBoxDmg(Damage, KFXPawn(injured).KFXDmgInfo.HitBoxID, instigatedBy);
	}

	// ÅÐ¶ÏÊÇ·ñ´¦ÓÚÌØÊâ×´Ì¬
	if( injured != none )
	{
		if( KFXPawn(Injured).KFXIsGodMode())//)KFXPlayerReplicationInfo(injured.PlayerReplicationInfo).bSuperState) //´ËÕÊºÅÊÇGM
		{
			return 0;
		}
		if( KFXPlayerReplicationInfo(injured.PlayerReplicationInfo).bSpecMode )
		{
			return Damage * FRand();
		}
	}

	return Super.ClientReduceDamage( Damage, injured, instigatedBy, HitLocation, Momentum, DamageType );
}

// Client TakeDmage
simulated function _ClientTakeDamage(out float HealthVP,out float Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local float actualDamage;
	local int OldHealth,actualintDamage;
	local KFXTaskManager taskMgr;
	local bool bShootDown;
	local bool bHeadKill;
	local int HitHP;

	//<<<Hawk Wang Ö§³ÖÈÎÎñÏµÍ³µÄÉËº¦ÀàÈÎÎñ 2010-01-18
	if(KFXPlayer(self.Controller) != none)
	{
		taskMgr = KFXPlayer(self.Controller).TaskManager;
	}
	//>>>

	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role == ROLE_Authority )
	{
		log("Server Should Not In");
		return;
	}
	HealthVP = Health;
	if ( Health <= 0 )
	{
//        HealthVP = 0;
//        Damage = 0;
		return;
	}
	;
	if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
		instigatedBy = DelayedDamageInstigatorController.Pawn;

	if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
		ClientSetMovementPhysics();
	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

	if (Weapon != None)
		Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if (DrivenVehicle != None)
			DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
		Damage *= 2;
	actualDamage = ClientReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);    //¼õÉÙÉËº¦
//    if( DamageType.default.bArmorStops && (actualDamage > 0) )
//        actualDamage = ShieldAbsorb(actualDamage);


	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;

	//ClientPlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
	OldHealth = Health;

	//KFXGameInfo(Level.Game).ScoreDamage( actualDamage, instigatedBy.Controller, Controller );
	actualintDamage = actualDamage+0.5;
	DamageValue = actualintDamage;

	Health -= actualintDamage;    //×îÖÕÉËº¦
	Damage = actualintDamage;     //DamageÖµ»Ø´«·þÎñÆ÷


//    if ( actualintDamage > 0 )
//    {
//
//    }
	log("KFXPawnBase------Damage "$Damage);

	if(Damage > 0 && InstigatedBy.Controller != none && Health > 0)
	{
		KFXPawnBase(InstigatedBy).KFXClientPlayAttackBloodMessage(Damage);
	}
	if(Damage > 0 && Health > 0)
	{
		KFXDmgRepInfo.FlashCount++;
		KFXSavedDmgRepInfo = KFXDmgRepInfo;
		log("First person damage call");
		KFXClientPlayTakeHit();     //²¥·ÅµôÑªÐ§¹û
	}

	HitHP = actualintDamage;

	//×ªÒÆµ½ServerTakeDamageÖÐ
//	if(level.Game.IsA('KFXPVEGame'))
//	{
//		if( Bot(Controller)!=none && KFXPlayer(InstigatedBy.Controller)!=none)
//		{
//			KFXPlayer(InstigatedBy.Controller).CheckPVELevelUp(HitHP,0);
//		}
//
//		if( KFXPlayer(Controller)!=none && Bot(InstigatedBy.Controller) != none )
//		{
//			KFXPlayer(Controller).CheckPVELevelUp(0,HitHP);
//		}
//	}

	if (Health <= 0)
	{
		bShootDown = true;
		HitHP = actualintDamage + Health;

		if (HITBOX(KFXDmgInfo.HitBoxID) == HITBOX_HEAD)
		{
			bHeadKill = true;
		}
	}
	else
	{
		bShootDown = false;
		bHeadKill = false;
	}

	if(Health <= 0)               //²¥·ÅËÀÍö¶¯»­
	{
		//ClientDied(HitLocation,DamageType);
		//KFXPawn(instigatedBy).ClientBroadcastDeathMessage(instigatedBy,Self,damageType);
	}

	HealthVP = Health;
//    log("KFXPawnBase-----HealthVP "$HealthVP);
//    log("KFXPawnBase-----Health "$Health);
//    log("KFXPawnBase-----Damage "$Damage);
	//log("KFXPawnBase-----HealthVP "$HealthVP);

}

event KFXBroadcastLocalized
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
	//<< sunqiang , ´¦Àí¼¤ÀøÉùÒôÂß¼­ Client simulated Fire
//    local KFXPlayerREplicationInfo p1, p2, p;
//  local int i;
//
//  local GameReplicationInfo GRI;
//
//    GRI = KFXPlayer(Controller).GameReplicationInfo;
//  //¼ÇÂ¼Ë­É±ËÀÁË×Ô¼º
//  p1 = KFXPlayerReplicationInfo(RelatedPRI_1); //killer
//  p2 = KFXPlayerReplicationInfo(RelatedPRI_2); //killed
//
//    log("KFXPawnBase-----GRI "$GRI);
//
//  //Èç¹ûÆäÖÐÓÐÒ»·½²»ÊÇÈË»òÕßÊÇ×Ô¼º£¬ÄÇÃ´¾Í²»ÐèÒªÖ´ÐÐ´ËÂß¼­¡£·ñÔò¼ÇÂ¼¸´³ð
//  if(p1 != none && p2 != none && p1 != p2)
//  {
//      for(i=0; i<GRI.PRIArray.Length; i++)
//      {
//          p = KFXPlayerReplicationInfo(GRI.PRIArray[i]);
//          if(p.fxPlayerDBID == p1.fxPlayerDBID)
//              p1 = p;
//          else if(p.fxPlayerDBID == p2.fxPlayerDBID)
//              p2 = p;
////            if(GameReplicationInfo.PRIArray[i] == RelatedPRI_1)
////            {
////                p1 = KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
////            }
////            else if(GameReplicationInfo.PRIArray[i] == RelatedPRI_2)
////            {
////                p2 = KFXPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
////            }
////            if(p1 != none && p2 != none)
////                break;
//        }
//      p2.nIDLastKillMe = p1.fxPlayerDBID;
//      p2.nRealIDLastKillMe = p1.fxRoleGUID;
//      if(p1.nIDLastKillMe == p2.fxPlayerDBID)
//      {
//          p1.nIDLastKillMe = 0;
//      }
//  }

//    KFXBroadcastHandler(BroadcastHandler).KFXAllowBroadcastLocalized(
//        Sender,
//        Message,
//        Switch1,
//        RelatedPRI_1,
//        RelatedPRI_2,
//        OptionalObject,
//        Switch2
//    );

	if(Controller != none)
	{
		KFXPlayer(Controller).KFXClientReceiveLocalizedMessage(
			Message, Switch1, RelatedPRI_1, RelatedPRI_2, OptionalObject, Switch2
			);
	}

}
simulated function ClientBroadcastDeathMessage(Pawn Killer, Pawn Other, class<DamageType> damageType)
{
	local int counter;
	log("KFXPawnBase------Killer "$Killer);
	log("KFXPawnBase------Other "$Other);
	log("KFXPawnBase------damageType "$damageType);
	log("KFXPawnBase------KillerOther.PlayerReplicationInfo "$Killer.PlayerReplicationInfo);
	log("KFXPawnBase------Other.PlayerReplicationInfo "$Other.PlayerReplicationInfo);

	if( (Killer == Other) || (Killer == None) )
	{
		KFXBroadcastLocalized(
			self,
			class'KFXCombatMessage_Suicide',
			KFXPawn(Other).KFXDmgInfo.WeaponID,
			None,
			Other.PlayerReplicationInfo,
			damageType
			);

		;
	}
	else
	{
		//¸ß16Î»ÎªÁ¬É±£¬µÍ16Î»Îª»÷É±ÊýÁ¿
		counter = (KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxKills +1)& 0xffff;     //¿Í»§¶ËÄ£Äâ£¬Õâ¸öÊ±ºòfxKills»¹Ã»ÓÐ´«¹ýÀ´
		counter = counter | (KFXPlayerReplicationInfo(Killer.PlayerReplicationInfo).fxCurMultiKillCount << 16);
		log("Pawn-----Counter "$Counter);
		if( KFXPawn(Other).KFXDmgInfo.bAutoAim != 0 )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_AutoAim',
				KFXPawn(Other).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
		else if ( damageType == class'KFXDmgTypeCrossWall' )
		{
			if ( KFXPawn(Other).KFXDmgInfo.HitBoxID == 2 )
			{
				KFXBroadcastLocalized(
					self,
					class'KFXCombatMessage_CWKill_HeadKill',
					KFXPawn(Other).KFXDmgInfo.WeaponID,
					Killer.PlayerReplicationInfo,
					Other.PlayerReplicationInfo,
					damageType,
					counter
					);

			}
			else
			{
				KFXBroadcastLocalized(
					self,
					class'KFXCombatMessage_CWKill',
					KFXPawn(Other).KFXDmgInfo.WeaponID,
					Killer.PlayerReplicationInfo,
					Other.PlayerReplicationInfo,
					damageType,
					counter
					);

			}
		}
		else if( KFXPawn(Other).KFXDmgInfo.HitBoxID == 2 )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_KillHead',
				KFXPawn(Other).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
		//<< wangkai, É±¶¯ÎïÏûÏ¢
		else if ( KFXPawn(Other).bSpecialRoleState )
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_KillAnimal',
				KFXPawn(Other).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
		}
		else
		{
			KFXBroadcastLocalized(
				self,
				class'KFXCombatMessage_Normal',
				KFXPawn(Other).KFXDmgInfo.WeaponID,
				Killer.PlayerReplicationInfo,
				Other.PlayerReplicationInfo,
				damageType,
				counter
				);
			;
		}
	}
}
//Éú³ÉÔÚµØÉÏµÄÎäÆ÷
simulated function KFXWeapBase KFXCreateWeaponPickUp( int WeaponID)
{
	local KFXCSVTable CFG_Weapon, CFG_Class;
	local KFXWeapBase weap;
	local int ClassID;
	local int WeapType;

	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
	CFG_Class       = class'KFXTools'.static.GetConfigTable(19);

	if ( !CFG_Weapon.SetCurrentRow(WeaponID) )
	{
		Log("[Weapon] Can't Resolve The Weapon ID (Attribute Table): "$WeaponID);
		return none;
	}

	ClassID = CFG_Weapon.GetInt("Class");

	// Load Class, Spawn Weapon
	if ( ClassID != 0 && CFG_Class.SetCurrentRow(ClassID) )
	{
		WeapType = CFG_Weapon.GetInt( "WeaponGroup1" );

		weap = Spawn(
			class<KFXWeapBase>(
				DynamicLoadObject(CFG_Class.GetString("Class"), class'Class')));
		if( weap != none )
		{
			weap.Instigator = none;
			weap.KFXServerInit(WeaponID);
			weap.KFXSetAmmo(weap.KFXGetAmmo());
		   // weap.KFXSetCartridgeClip(p);
//            weap.KFXSetArmourPierce(p);
//            weap.GiveTo(p);
		}
		//if ( weap != none )
//            weap.PickupFunction(p);
	}
	else
	{
		Log("[Weapon] Can't Resolve The Weapon Class or Invalid Class ID : "$ClassID);
		return none;
	}
	return weap;
}

simulated function ClientDied(Vector Hitlocation,class<DamageType> DamageType)
{
	//local vector            TossVel;
	//local class<Pickup>  PickupClass;
	//local Weapon Weapon;

	log("KFXPawnBase-----ClientDied");
	ClientPlayDying(DamageType, HitLocation);
	//log("KFXPawnBase-------WeaponID "$WeaponID);

	//Weapon = KFXCreateWeaponPickUp(WeaponID);
//    if ( Weapon != None && (DrivenVehicle == None || DrivenVehicle.bAllowWeaponToss) )
//    {
//        if ( Controller != None )
//            Controller.LastPawnWeapon = Weapon.Class;
//        Weapon.HolderDied();
//        TossVel = Vector(GetViewRotation());
//        //TossVel = TossVel * ((Velocity dot TossVel) + 500) + Vect(0,0,200);
//        TossVel = TossVel + Vect(0,0,200);
//        ClientTossWeapon(Weapon,TossVel);
//    }
//    Pickup = Spawn(PickupClass,,, StartLocation);
//    if ( Pickup != None )
//    {
//        Pickup.InitDroppedPickupFor(self);
//        Pickup.Velocity = Velocity;
//        if (Instigator.Health > 0)
//            WeaponPickup(Pickup).bThrown = true;
//    }
	if ( DrivenVehicle != None )
	{
		Velocity = DrivenVehicle.Velocity;
		DrivenVehicle.DriverDied();
	}
}
//Server Take Damage Only do ScoreDamage and Died()
function _ServerTakeDamage( float Damage, float HealthVP,Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	local float actualDamage;
	local Controller Killer;
	local int OldHealth,actualintDamage;
	local KFXTaskManager taskMgr;
	local int HitLength;
	local bool bShootDown;
	local bool bHeadKill;
	local int HitHP;
	local int RealDmg;
	local KFXPlayerReplicationInfo PRI;
	PRI = KFXPlayerReplicationInfo(InstigatedBy.PlayerReplicationInfo);
    if(self.IsA('KFXMutatePawn'))
    {
    	actualDamage = damage;
    	HealthVP = Health - actualDamage;
	}
	else
	{
    	actualDamage = Health - HealthVP;
    }
	if(Health <= HealthVP)
	{
		PRI.fxKillBlood += int(Damage+0.5);
	}
	else
	{
		PRI.fxKillBlood += Health - HealthVP;
	}


	log("fxKills: "$KFXPlayerReplicationInfo(InstigatedBy.PlayerReplicationInfo).fxKills);
	//KFXGameInfo(Level.Game).ScoreDamage( actualDamage, instigatedBy.Controller, Controller );
	actualintDamage = actualDamage+0.5;
	DamageValue = actualintDamage;
//    Health -= actualintDamage;
	RealDmg = Health - HealthVP;
	Health = HealthVP;   //¿Í»§¶ËÄ£Äâ£¬½«¿Í»§¶Ë¼ÆËãµÃµ½µÄHealthÖµ´«¸ø¿Í»§¶Ë

	log("KFXPawnBase-----RealDmg "$RealDmg);
//    log("KFXPawnBase-----HealthVP "$HealthVP);

	if ( actualintDamage > 0 )
	{
		KFXDmgRepInfo.FlashCount++;
		KFXDmgRepInfo.DamageVal =  RealDmg;
	}
	HitHP = actualintDamage;

	if(level.Game.IsA('KFXPVEGame'))
	{
		if( Bot(Controller)!=none && KFXPlayer(InstigatedBy.Controller)!=none)
		{
			KFXPlayer(InstigatedBy.Controller).CheckPVELevelUp(HitHP,0);
		}

		if( KFXPlayer(Controller)!=none && Bot(InstigatedBy.Controller) != none )
		{
			KFXPlayer(Controller).CheckPVELevelUp(0,HitHP);
		}
	}

	if (Health <= 0)
	{
		bShootDown = true;
		HitHP = actualintDamage + Health;

		if (HITBOX(KFXDmgInfo.HitBoxID) == HITBOX_HEAD)
		{
			bHeadKill = true;
		}
	}
	else
	{
		bShootDown = false;
		bHeadKill = false;
	}

	// ¹ã²¥»÷ÖÐÏûÏ¢
	// ÓÐ¿ÉÄÜÊÇ¸ß´¦×¹Âä»òÆäËû·ÇÎäÆ÷ÉËº¦


	BroadcastHitInfo(InstigatedBy, HitHP, KFXDmgInfo.WeaponID, bShootDown, bHeadKill);


	if ( Level.NetMode == NM_Standalone )
	{
		HitLength = KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList.Length;
		KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList[HitLength-1].Damage = actualintDamage;
	}
	//-----------------------------------
	//<<<Hawk Wang µ÷ÓÃÉËº¦µÄÊÂ¼þ 2010-01-18
	if(taskMgr != none)
	{
		taskMgr.DamageTook(killer,self.Controller,DamageType,actualDamage);
	}
//    log("KFXPawnBase-----Health "$Health);
//    log("KFXPawnBase-----HealthVP "$HealthVP);
	//>>>
	if ( Health <= 0 )
	{
		// pawn died
		////////////////////////////////////////////////////////////////////////
		// Modify by zjpwxh@kingsoft 2007-8-30
		// È¥µôÁË×¹Â¥µÈËÀÍöÊ±£¬ÅÐ¶Ï¹¥»÷ÕßµÄÎÊÌâ
		/*
		if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
			Killer = LastHitBy;
		else if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		*/

		if ( instigatedBy != None )
		{
			Killer = instigatedBy.GetKillerController();
		}

		if( !NeedToBeDied( Killer, damageType ) )
		{
			//----Ö§³ÖÕý³£Çé¿öÏÂµÄÎÞËÀÍö-----½©Ê¬
			;
			NoDeathProcess( Killer, damageType, OldHealth );
			return;
		}
		;
		////////////////////////////////////////////////////////////////////////

		if ( Killer == None && DamageType.Default.bDelayedDamage )
			Killer = DelayedDamageInstigatorController;

        if ( Killer == None && ClassIsChildOf(DamageType,Class'KFXGame.KFXFlameDamageType') )
            Killer = DelayedDamageInstigatorController;


		if ( bPhysicsAnimUpdate )
			TearOffMomentum = momentum;
		ServerDied(Killer, damageType, HitLocation);     // Server Died
	}
	else
	{
		// Do not apply momentum if not died
		if ( instigatedBy != None )
		{
			Killer = instigatedBy.GetKillerController();
		}

			;//AddVelocity( momentum );

		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		if ( instigatedBy != None && instigatedBy != self )
			LastHitBy = instigatedBy.Controller;
	}
	MakeNoise(1.0);
}

//Server Died [Client Simulated Fire]
function ServerDied(Controller Killer, class<DamageType> damageType, vector HitLocation)
{

	local Weapon OldWeapon;

	OldWeapon = Inventory.WeaponChange(5, true);
	if(OldWeapon!=none)Weapon=OldWeapon;

	if(Killer.Pawn!=none)
	{
		KFXPlayer(Controller).KillMePawn = Killer.Pawn;
	}
	else
	{
		KFXPlayer(Controller).KillMePawn = none;
	}

	 super.ServerDied(Killer,damageType,HitLocation);
}


// TakegDamage from Pawn
function _TakeDamage(float Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local float actualDamage;
	local Controller Killer;
	local int OldHealth,actualintDamage;
	local KFXTaskManager taskMgr;
	local int HitLength;
	local bool bShootDown;
	local bool bHeadKill;
	local int HitHP;
	//<<<Hawk Wang Ö§³ÖÈÎÎñÏµÍ³µÄÉËº¦ÀàÈÎÎñ 2010-01-18
	if(KFXPlayer(self.Controller) != none)
	{
		taskMgr = KFXPlayer(self.Controller).TaskManager;
	}
	//>>>

	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
	{
		log(self$" client damage type "$damageType$" by "$instigatedBy);
		return;
	}

	if ( Health <= 0 )
		return;
	;
	if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
		instigatedBy = DelayedDamageInstigatorController.Pawn;

	if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
		SetMovementPhysics();
	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

	if (Weapon != None)
		Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if (DrivenVehicle != None)
			DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
		Damage *= 2;
	actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
//    if( DamageType.default.bArmorStops && (actualDamage > 0) )
//        actualDamage = ShieldAbsorb(actualDamage);


	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;

	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
	OldHealth = Health;

	KFXGameInfo(Level.Game).ScoreDamage( actualDamage, instigatedBy.Controller, Controller );
	actualintDamage = actualDamage+0.5;
	DamageValue = actualintDamage;
	Health -= actualintDamage;
	if ( actualintDamage > 0 )
	{
		KFXDmgRepInfo.FlashCount++;
	}
	HitHP = actualintDamage;

	if (Health <= 0)
	{
		bShootDown = true;
		HitHP = actualintDamage + Health;

		if (HITBOX(KFXDmgInfo.HitBoxID) == HITBOX_HEAD)
		{
			bHeadKill = true;
		}
	}
	else
	{
		bShootDown = false;
		bHeadKill = false;
	}

	// ¹ã²¥»÷ÖÐÏûÏ¢
	// ÓÐ¿ÉÄÜÊÇ¸ß´¦×¹Âä»òÆäËû·ÇÎäÆ÷ÉËº¦
	BroadcastHitInfo(InstigatedBy, HitHP, KFXDmgInfo.WeaponID, bShootDown, bHeadKill);


	if ( Level.NetMode == NM_Standalone )
	{
		HitLength = KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList.Length;
		KFXHUD(KFXPlayer(Level.GetLocalPlayerController()).myHUD).HitDmgInfoList[HitLength-1].Damage = actualintDamage;
	}
	//-----------------------------------
	//<<<Hawk Wang µ÷ÓÃÉËº¦µÄÊÂ¼þ 2010-01-18
	if(taskMgr != none)
	{
		taskMgr.DamageTook(killer,self.Controller,DamageType,actualDamage);
	}
	//>>>
	if ( Health <= 0 )
	{
		// pawn died
		////////////////////////////////////////////////////////////////////////
		// Modify by zjpwxh@kingsoft 2007-8-30
		// È¥µôÁË×¹Â¥µÈËÀÍöÊ±£¬ÅÐ¶Ï¹¥»÷ÕßµÄÎÊÌâ
		/*
		if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
			Killer = LastHitBy;
		else if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		*/

		if ( instigatedBy != None )
		{
			Killer = instigatedBy.GetKillerController();
		}

		if( !NeedToBeDied( Killer, damageType ) )
		{
			//----Ö§³ÖÕý³£Çé¿öÏÂµÄÎÞËÀÍö-----½©Ê¬
			;
			NoDeathProcess( Killer, damageType, OldHealth );
			return;
		}
		;
		////////////////////////////////////////////////////////////////////////

		if ( Killer == None && DamageType.Default.bDelayedDamage )
			Killer = DelayedDamageInstigatorController;
		if ( bPhysicsAnimUpdate )
			TearOffMomentum = momentum;
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		// Do not apply momentum if not died
		if ( instigatedBy != None )
		{
			Killer = instigatedBy.GetKillerController();
		}

			;//AddVelocity( momentum );

		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		if ( instigatedBy != None && instigatedBy != self )
			LastHitBy = instigatedBy.Controller;
	}
	MakeNoise(1.0);
}
function bool NeedEnableMomentum(Controller Killer, Vector momentum, class<DamageType> damageType)
{
	return false;
}
function bool NeedToBeDied(Controller Killer, class<DamageType> damageType)
{
	return true;
}
function NoDeathProcess( Controller Killer, class<DamageType> damageType, int OldHealth );
function _GasDamage(float Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Controller Killer;

	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
	{
		log(self$" client damage type "$damageType$" by "$instigatedBy);
		return;
	}

	if ( Health <= 0 )
		return;

	if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
		instigatedBy = DelayedDamageInstigatorController.Pawn;

	if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
		SetMovementPhysics();
	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

	if (Weapon != None)
		Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if (DrivenVehicle != None)
			DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );


	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;

	PlayHit(Damage,InstigatedBy, hitLocation, damageType, Momentum);
	Health -= Damage;
	if ( Damage > 0 )
	{
		KFXDmgRepInfo.FlashCount++;
	}
	//-----------------------------------

	if ( Health <= 0 )
	{
		// pawn died
		////////////////////////////////////////////////////////////////////////
		// Modify by zjpwxh@kingsoft 2007-8-30
		// È¥µôÁË×¹Â¥µÈËÀÍöÊ±£¬ÅÐ¶Ï¹¥»÷ÕßµÄÎÊÌâ
		/*
		if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
			Killer = LastHitBy;
		else if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		*/

		if ( instigatedBy != None )
		{
			Killer = instigatedBy.GetKillerController();
		}
		////////////////////////////////////////////////////////////////////////

		if ( Killer == None && DamageType.Default.bDelayedDamage )
			Killer = DelayedDamageInstigatorController;
		if ( bPhysicsAnimUpdate )
			TearOffMomentum = momentum;
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		// Do not apply momentum if not died
		//AddVelocity( momentum );
		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
		if ( instigatedBy != None && instigatedBy != self )
			LastHitBy = instigatedBy.Controller;
	}
	MakeNoise(1.0);
}

// Server Only
// Ö´ÐÐËÀÍöÐ§¹û
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum);

//Client Only    sunqiang    Client simulated Fire
simulated function ClientPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum);

// Client Only
// Take HitµÄÐ§¹û
simulated function KFXClientPlayTakeHit()
{
	local string soundname;
	local Sound SoundHit;
	log("[TakeHit] Pawn="$name$
		" InstigatedBy="$KFXSavedDmgRepInfo.InstigatedBy.Name$
		" Location="$KFXSavedDmgRepInfo.HitLocation$
		" Momentum="$KFXSavedDmgRepInfo.Momentum$
		" ShakeView="$KFXSavedDmgRepInfo.DmgShakeView);

	// ¶¾Æøµ¯Ã»ÓÐÕâÐ©ÌØÐ§
//    if ( KFXHitWeaponID / 65536 != 8 )
//    {
	KFXClientPlayTakeHitEffects();
	KFXClientPlayTakeHitSound();
	if ( KFXSavedDmgRepInfo.InstigatedBy.Controller != none )
	{
		soundname = "fx_death_sounds.male_bodyshot2_"$Rand(5)+1;
		SoundHit = Sound(DynamicLoadObject(soundname,class'sound',false));
		Level.GetLocalPlayerController().PlaySound(SoundHit, SLOT_Pain,
		6.0*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
		HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));

		log("PlaySound own hit "$soundname);
	}
//    }

	if ( KFXHitWeaponID != 524289 )
	{
		KFXClientPlayDirectionalHit(KFXSavedDmgRepInfo.HitLocation);
	}



	// Shake View
	if ( IsLocallyControlled() && KFXSavedDmgRepInfo.DmgShakeView > 0 )
		KFXShakeView(KFXSavedDmgRepInfo.HitLocation, KFXSavedDmgRepInfo.DmgShakeView);

}

simulated function PlayHitPawnEffects(
	optional vector HitLocation,
	optional vector HitNormal)
{
}
// Client Only
simulated function KFXClientPlayTakeHitEffects()
{
	local KFXWeapAttachment DmgWeap;
	local vector src_location;
	local KFXPlayer LocalPC;

	if ( KFXSavedDmgRepInfo.InstigatedBy != none && KFXSavedDmgRepInfo.InstigatedBy.Weapon != none )
		DmgWeap = KFXWeapAttachment(KFXSavedDmgRepInfo.InstigatedBy.Weapon.ThirdPersonActor);

//    if ( DmgWeap == none )
//        return;
	LocalPC = KFXPlayer(Level.GetLocalPlayerController());
	if(Controller == LocalPC)
		KFXPlayer(Controller).time_be_hitted = Level.TimeSeconds;

	if ( Controller == LocalPC)
	{
		if(LocalPC.life_style==0 || !LocalPC.life_first_person_blood_valid)
			return;
	}
	if(DmgWeap != none)
	{
		src_location = KFXSavedDmgRepInfo.InstigatedBy.Location;
	}
	else
	{
		src_location = KFXSavedDmgRepInfo.InstigatedBy.Location;
	}
	PlayHitPawnEffects( KFXSavedDmgRepInfo.HitLocation, Normal(src_location - Location) );
}

// Owner Client Only
simulated function KFXShakeView(vector ShakerPos, byte Intensity)
{
	local KFXPlayer pc;
	local float dist;

//    if ( !IsLocallyControlled() )
//        return;

	pc = KFXPlayer(Controller);
	if(!pc.bKFXShakeView)
	return;
	// calc flash
	dist = VSize(Location - ShakerPos);

	if ( dist > 1200 )
		return;

	pc.KFXDamageShakeView( Intensity - dist * 0.04 );
}
exec function simHit()
{
	KFXClientPlayDirectionalHit(Location);
}
// Client Only
// KFXClientPlayDirectionalHit    ¸Ãº¯ÊýÒÔ±»×ÓÀàÖØÐ´
simulated function KFXClientPlayDirectionalHit(Vector HitLoc)
{
	local Vector X,Y,Z, Dir;
	local int Direction,HitPart;
	local name HitAnimation;
	HitPart=KFXGetHitPartByHeight(HitLoc);
	if(HitPart<0)
	{
		log("PawnBase KFXClientPlayDirectionalHit HitPart:"$HitPart);
		return;
	}
	GetAxes(Rotation, X,Y,Z);
	HitLoc.Z = Location.Z;

	// random
	if ( VSize(Location - HitLoc) < 1.0 )
	{
		Dir = VRand();
	}
	// hit location based
	else
	{
		Dir = -Normal(Location - HitLoc);
	}

	if ( Dir dot X > 0.7 || Dir == vect(0,0,0))
	{
		Direction = 0;
	}
	else if ( Dir dot X < -0.7 )
	{
		Direction = 1;
	}
	else if ( Dir dot Y > 0 )
	{
		Direction = 3;
	}
	else
	{
		Direction = 2;
	}

	switch(HitPart)
	{
		case 0:
		HitAnimation=HitHeadAnimExt[Direction + 4 * Rand(3)];
		break;
		case 1:
		HitAnimation=HitBodyAnimExt[Direction + 4 * Rand(3)];
		break;
		case 2:
		HitAnimation=HitLegAnimExt[Direction + 4 * Rand(3)];
		break;
	}

	if ( bIsCrouched )
	{
		HitAnimation = CHitAnimExt[rand(3)];
	}

//    if ( HasAnim(HitAnimation) )// && KFXHitWeaponID != 524289
//    {
		AnimBlendParams(2, 1.0, 0.0, 0.0,Spine1Bone);
		PlayAnim(HitAnimation, 1.0, 0, 2);
		PlayAnim(HitAnimation, 1.0, 0, 1);
		PlayAnim(HitAnimation, 1.0, 0, 0);
//    }

	if(IsLocallyControlled())
	{
		if ( KFXPlayer(Controller) != none )
		{
			KFXPlayer(Controller).TakeHit(Direction);
		}
	}
}
simulated function GetRandDamageSound()
{
	local KFXCSVTable CFG_LIST, CFG_Media, CFG_Sound;
	local int PawnStateID, TempID;
	//local string TempString;
	//local int i,j;
	local int RandNum;
	//local string DirName[4];

	;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Media = class'KFXTools'.static.GetConfigTable(42);
	CFG_Sound = class'KFXTools'.static.GetConfigTable(46);

	if ( CFG_LIST == none || CFG_Media == none  )
		return;

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return;
	}

	PawnStateID = CFG_LIST.GetInt("BaseID"); // TODO: À©Õ¹ÖÃ±äÉí¹¦ÄÜ

	if ( !CFG_Media.SetCurrentRow(PawnStateID) )
		return;

	/// ¶ÁÈ¡ÒôÐ§×ÊÔ´
	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndHeadshot"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		HeadshotSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndBodyshot"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		BodyshotSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndKnifeHit"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		KnifeHitSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndDeath"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		DeadSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndFallPain"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		SoundFallPains = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
}
//----------------------------------------------------------
//»ñµÃ»÷ÖÐ²¿Î»µÄ±àºÅ£¬0---head£¬1---body£¬2--- leg
simulated function int KFXGetHitPartByHeight(Vector HitLoc)
{
	local vector RootLocation;
	local float  HitHeight,HitHeightScale;

	RootLocation.Z=Location.Z-CollisionHeight;
	HitHeight=HitLoc.Z- RootLocation.Z;
	HitHeightScale=HitHeight/(2*CollisionHeight);
	log("[KFXPawnBase]KFXGetHitPartByHeight Height:"$CollisionHeight$"Location:"$Location$"HitLoc:"$HitLoc);
	if(HitHeightScale>0.8)
		return 0;
	else if(HitHeightScale<=0.8&&HitHeightScale>0.5)
		return 1;
	else if(HitHeightScale<=0.5)
		return 2;
	else
		return -1;
}
// Client Only
// Kill Blood
simulated function KFXClientPlayAttackBloodMessage(int BloodLoss)
{
	 local int KillBlood;
	 local int KillFiftyBloodNum;
	 local int i;
	 local KFXPlayerReplicationInfo PRI;
	 PRI = KFXPlayerReplicationInfo(PlayerReplicationInfo);
	 if(PRI != none)
	 {
		 log("KFXPawnBase---111---PRI.fxAttackBloodOnce "$PRI.fxAttackBloodOnce);
		 KillBlood = PRI.fxAttackBloodOnce;
		 KillBlood += BloodLoss;
		 PRI.fxAttackBloodOnce += BloodLoss;
		 log("KFXPawnBase--222----KillBlood "$KillBlood);
		 log("KFXPawnBase------Controller "$Controller);

		 if(Controller != none)
		 {
			 while(KillBlood >= 10)
			 {
				if(KillBlood >= 50)
				{
				  KFXHUD(KFXPlayer(Controller).myHUD).AddFlyingBlood(50);
if(KFXHUD(KFXPlayer(Controller).myHUD)._HUD_NEW_ == 2)
{
				  KFXPlayer(Controller).Player.GUIController.SetHUDData_VipFlyingBlood(50);
}
				  KillBlood -= 50;
				}
				else if(KillBlood >= 10)
				{
				  KFXHUD(KFXPlayer(Controller).myHUD).AddFlyingBlood(10);
if(KFXHUD(KFXPlayer(Controller).myHUD)._HUD_NEW_ == 2)
{
				  KFXPlayer(Controller).Player.GUIController.SetHUDData_VipFlyingBlood(10);
}
				  KillBlood -= 10;
				}

			 }
		 }
		 PRI.fxAttackBloodOnce = PRI.fxAttackBloodOnce % 10;
	 }
}

// Client Only
// Take hit sound
simulated function KFXClientPlayTakeHitSound()
{
	local int WeaponType;

	local float SoundVolFactor,SoundRadiusFactor;

	WeaponType = KFXHitWeaponID >> 16;

	SoundVolFactor = KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0);
	SoundRadiusFactor = KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0);
	// FIXME:
	// KFXHitWeaponIDÊÇ·ñÈ·±£ÕýÈ·£¿
	// KFXDmgInfo.HitBoxID¿Í»§¶ËÄÜ·ÃÎÊµ½£¿
	// ÃüÖÐÒôÐ§ºÍÈËµÄÉùÒô»¹ÔÚÒ»Æð£¿
	// ÊÇ·ñ»¹ÓÃ Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds
	;

	GetRandDamageSound();
	if(KFXDmgInfo.HitBoxID == 2) //  ´òÍ·
	{
		PlaySound(BodyshotSound, SLOT_Pain,
				 6.0*SoundVolFactor,,
				 HitSoundRadius*SoundRadiusFactor);
	}
	else if (WeaponType > 40 && WeaponType < 51) // Melee Weapon Hit
	{
		PlaySound(KnifeHitSound, SLOT_Pain,
		HitSoundVolume*SoundVolFactor,,
		HitSoundRadius*SoundRadiusFactor);
	}
	else if(KFXHitWeaponID!=0)
	{
		PlaySound(BodyshotSound, SLOT_Pain,
		6.0*SoundVolFactor,,
		HitSoundRadius*SoundRadiusFactor);
	}
}

//=============================================================================
// Called immediately before gameplay begins.
simulated event PreBeginPlay();
// Called immediately after gameplay begins.
simulated event PostBeginPlay();
// called after PostBeginPlay.  On a net client, PostNetBeginPlay() is spawned after replicated variables have been initialized to
// their replicated values
simulated event PostNetBeginPlay();

simulated event PostNetReceive()
{
	if ( PlayerReplicationInfo != None )
	{
		//Setup(class'xUtil'.static.FindPlayerRecord(PlayerReplicationInfo.CharacterName));
		bNetNotify = false;
	}
}

//
//=============================================================================
auto state KFXPending  // ¸Õ³öÉúÊ±µÄ×´Ì¬
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;
	simulated function BeginState()
	{
		//°ïÖúÏûÏ¢: X¼ü»»Ç¹
		if(self.Controller!=none)
		KFXPlayer(Controller).ReceiveLocalizedMessage(class'KFXGameMessage', 53);
	}
	simulated function EndState();
	simulated event Tick(float DeltaTime)
	{
		if ( Level.NetMode != NM_DedicatedServer )
		{
			KFXPostReceiveTick();
		}
	}
}

simulated function CSVConfig(array<int> Ids)
{
	KFXPendingState.nRoleID = Ids[0];
	KFXPendingState.nSuitID = Ids[1];
	csvKFXInit();
}

simulated function csvKFXInit()
{
	csvKFXSetupOrgData();
	csvKFXSetupCfgData();
	csvKFXSetupClientMedia();
//  csvKFXAddAgentDecoration(self);
}
function AddDeadPawn();
function DeleteDeadPawn();
state KFXChangeState
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	simulated function bool CanSwitchWeapon()
	{
		return false;
	}
	simulated function BeginState()
	{
		;

		if ( Level.NetMode == NM_DedicatedServer )
			;
		else
		{
			if(KFXPendingState.nRoleID == 2)
				bIsFemale = true;
			else
				bIsFemale = false;
		}

		ShouldCrouch(true);

		KFXSetupOrgData();
		KFXSetupCfgData();
		if ( Level.NetMode == NM_DedicatedServer )
			KFXSetupServerMedia();
		else
			KFXSetupClientMedia();

		KFXCurrentState = KFXPendingState;
		NotifyInitEnd();
		KFXAddAgentDecoration(self);

		//Èç¹û´ËÊ±Ã»ÓÐWeaponAttachment£¬ÄÇÃ´²¥·ÅÄ¬ÈÏ¶¯»­
		log("[LABOR]--------------weaponattachment?"$WeaponAttachment);
		if(WeaponAttachment == none)
			KFXChangeAniGroup(-1);

		GotoState('');
	}

	simulated function EndState()
	{
		if (Controller == none)
		{
			 KFXPawnInitialize();

			 //¸÷ÖÖ×´Ì¬¶ÔÓ¦µÄ¸²¸ÇÑÚÂë
			 KFXOverLapMasks[1] = 0x7fff0000;//0x00780201;
			 KFXOverLapMasks[3] = 0x00080208;
			 KFXOverLapMasks[4] = 0x00000210;
			 KFXOverLapMasks[9] = 0x00000200;
			 KFXOverLapMasks[16] = 0x00020200;
			 KFXOverLapMasks[19] = 0x00080200;
			 KFXOverLapMasks[20] = 0x00300200;
			 KFXOverLapMasks[18] = 0x00400200;
			 KFXOverLapMasks[21] = 0x007a0008;
		}

		ShouldCrouch(false);
//        if(KFXGhostPawn(self)!=none&&KFXGhostPawn(self).KFXPawnCanHid())
//        {
//            KFXGhostPawn(self).KFXSetInvis(KFXInvisSkin,3000,false);
//        }
	}

	simulated function KFXPawnInitialize()
	{
		local AIScript A;
		local playercontroller P;

		;

		//<< from PreBeginPlay
		if ( Role == ROLE_Authority )
		{
			// Handle autodestruction if desired.
			if( !bGameRelevant && (Level.NetMode != NM_Client) && !Level.Game.BaseMutator.CheckRelevance(Self) )
				Destroy();
			else if ( (Level.DetailMode == DM_Low) && (CullDistance == Default.CullDistance) )
				CullDistance *= 0.8;

			Instigator = self;
			DesiredRotation = Rotation;
			if ( bDeleteMe )
				return;

			if ( BaseEyeHeight == 0 )
				BaseEyeHeight = 0.8 * CollisionHeight;
			EyeHeight = BaseEyeHeight;

			if ( menuname == "" )
				menuname = GetItemName(string(class));
		}
		//>>

		//<< from PostBeginPlay
		if ( Role == ROLE_Authority )
		{
			SplashTime = 0;
			SpawnTime = Level.TimeSeconds;
			EyeHeight = BaseEyeHeight;
			OldRotYaw = Rotation.Yaw;

			// automatically add controller to pawns which were placed in level
			// NOTE: pawns spawned during gameplay are not automatically possessed by a controller
			if ( Level.bStartup && (Health > 0) && !bDontPossess )
			{
				// check if I have an AI Script
				if ( AIScriptTag != '' )
				{
					foreach AllActors(class'AIScript',A,AIScriptTag)
						break;
					// let the AIScript spawn and init my controller
					if ( A != None )
					{
						A.SpawnControllerFor(self);
						if ( Controller != None )
							return;
					}
				}
				if ( (ControllerClass != None) && (Controller == None) )
					Controller = spawn(ControllerClass);
				if ( Controller != None )
				{
					Controller.Possess(self);
					AIController(Controller).Skill += SkillModifier;
				}
			}
		}
		//>

		//<< from PostNetBeginPlay
		if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
			MaxLights = Min(4,MaxLights);
		if ( Role == ROLE_Authority )
			return;
		if ( (Controller != None) && (Controller.Pawn == None) )
		{
			Controller.Pawn = self;
			if ( (PlayerController(Controller) != None)
				&& (PlayerController(Controller).ViewTarget == Controller) )
				PlayerController(Controller).SetViewTarget(self);
		}

		if ( Role == ROLE_AutonomousProxy )
			bUpdateEyeHeight = true;

		if ( (PlayerReplicationInfo != None)
			&& (PlayerReplicationInfo.Owner == None) )
		{
			PlayerReplicationInfo.SetOwner(Controller);
			if ( left(PlayerReplicationInfo.PlayerName, 5) ~= "PRESS" )
			{
				P = Level.GetLocalPlayerController();
				if ( (P.PlayerReplicationInfo != None) && !(left(PlayerReplicationInfo.PlayerName, 5) ~= "PRESS") )
					bScriptPostRender = true;
			}
		}
		PlayWaiting();

		MultiJumpRemaining = MaxMultiJump;
		bCanDoubleJump = CanMultiJump();
		//>
	}
}
//=============================================================================
function UpdatePawnSpeedScale();
simulated function  InitSkills();
// Server Only
// ³õÊ¼»¯¸Ã³õÊ¼»¯µÄÊý¾Ý
// ÐèÒªÔÚ¸Õ¸ÕSpawnÍê¾Íµ÷ÓÃ
function KFXInitilizeA(KFXPlayer player)
{
	local int AvatarBodyID,AvatarHeadID, AvatarLegsID, SuitID, RoleID;
	local KFXFaeryAgent.CurEquipItemsListType fxNetPlayerEquipList;
	local KFXCSVTable CFG_AVATAR;

	;

	//LOG("ExpAvatarBody"$player.fxDBPlayerInfo.AvatarBody
	//$"AvatarHead"$player.fxDBPlayerInfo.AvatarHead
	//$"AvatarLegs"$player.fxDBPlayerInfo.AvatarLegs
	//$"Suit"$player.fxDBPlayerInfo.Suit);

	if ( Role != ROLE_Authority )
		return;
	CFG_AVATAR = class'KFXTools'.static.GetConfigTable(44);
	if ( CFG_AVATAR == none )
		return;

	fxNetPlayerEquipList = player.fxDBPlayerEquipList;
	AvatarBodyID = player.fxDBPlayerInfo.AvatarBody;
	AvatarHeadID = player.fxDBPlayerInfo.AvatarHead;
	AvatarLegsID = player.fxDBPlayerInfo.AvatarLegs;

	SuitID = Player.KFXGetSuitID();
	if ( !CFG_AVATAR.SetCurrentRow(SuitID) )
	{
		if( !CFG_AVATAR.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		;
		//CFG_LIST.SetCurrentRow(1)
	}
//	if ( (SuitID & 0xffff) > 6000 )     //¶à´ËÒ»¾ÙµÄ´úÂë
//	{

		player.fxDBPlayerInfo.RoleID = CFG_AVATAR.GetInt("PawnListID"); //3;
//	}
//	else
//	{
//		player.fxDBPlayerInfo.RoleID = CFG_AVATAR.GetInt("PawnListID"); //1;
//	}

	log("KFXPawnBase----SuitID "$SuitID);
	log("KFXPawnBase----player.fxDBPlayerInfo.RoleID "$player.fxDBPlayerInfo.RoleID);

	log("KFXPawn::KFXInitilizeA RoleID:"$RoleID$"SuitID"$SuitID$"Team"$Player.PlayerReplicationInfo.Team.TeamIndex);
	//----Èç¹û½«Ä³¸ö¶ÔÏóµÄownerÉ¾³ý£¬²¢¼ÌÐøÖ´ÐÐÂß¼­ÊÇ·ñ»áµ¼ÖÂ·þÎñÆ÷±ÀÀ££¿
	//---²¢ÇÒÐèÒªÈ·¶¨ÏÂ½ÇÉ«µÄavartaÊÇ·ñÓÀÔ¶²»Ó¦¸ÃÎª0
	if ( AvatarBodyID > 0 && !KFXGameInfo(Level.Game).CheckItemID(AvatarBodyID,EID_RoleBody) )
	{
		log("ERROR: KFXInitilizeB Error AvatarBody"$AvatarBodyID);
        log("Destroy Controller for Error AvatarBody "$"Player Name Is :"$Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(Controller).fxDBPlayerInfo.PlayerID);

        Controller.Destroy();
        return;
    }
    if ( AvatarHeadID > 0 && !KFXGameInfo(Level.Game).CheckItemID(AvatarHeadID,EID_RoleHead) )
    {
        log("ERROR: KFXInitilizeB Error AvatarHead"$AvatarHeadID);
        log("Destroy Controller for Error AvatarHead "$"Player Name Is :"$Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(Controller).fxDBPlayerInfo.PlayerID);

        Controller.Destroy();
        return;
    }
    if ( AvatarLegsID > 0 && !KFXGameInfo(Level.Game).CheckItemID(AvatarLegsID,EID_RoleLeg) )
    {
        log("ERROR: KFXInitilizeB Error AvatarLegs"$AvatarLegsID);
        log("Destroy Controller for Error AvatarLegs "$"Player Name Is :"$Controller.PlayerReplicationInfo.PlayerName$"  Role ID Is:"$KFXPlayer(Controller).fxDBPlayerInfo.PlayerID);

        Controller.Destroy();
        return;
    }
    if(player.PlayerReplicationInfo != none)
    {
        UpdatePawnSpeedScale();
        log("KFXPawnBase------KFXSpeedScale "$KFXSpeedScale);
    }
    if ( player.PlayerReplicationInfo.Team != none )
          KFXInitilizeB(
            player.fxDBPlayerInfo.RoleID,
            player.PlayerReplicationInfo.Team.TeamIndex,
            //<<ÀîÍþ¹ú Ì××°Ïà¹Ø
            //player.fxDBPlayerInfo.AvatarBody & 0xffff,
            //player.fxDBPlayerInfo.AvatarHead & 0xffff,
            //player.fxDBPlayerInfo.AvatarLegs & 0xffff,0
            AvatarBodyID & 0xffff,
            AvatarHeadID & 0xffff,
            AvatarLegsID & 0xffff,
            SuitID & 0xffff,
            player.fxTransWeapList.BodyPendents
            );
            //>>
    else
           KFXInitilizeB(
            player.fxDBPlayerInfo.RoleID,
            255,
            //<<ÀîÍþ¹ú Ì××°Ïà¹Ø
            //player.fxDBPlayerInfo.AvatarBody & 0xffff,
            //player.fxDBPlayerInfo.AvatarHead & 0xffff,
            //player.fxDBPlayerInfo.AvatarLegs & 0xffff,0
            AvatarBodyID & 0xffff,
            AvatarHeadID & 0xffff,
            AvatarLegsID & 0xffff,
            SuitID & 0xffff,
            player.fxTransWeapList.BodyPendents
            );
            //>>
}

// Server Only
// ³õÊ¼»¯¸Ã³õÊ¼»¯µÄÊý¾Ý
// ÐèÒªÔÚ¸Õ¸ÕSpawnÍê¾Íµ÷ÓÃ
//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.9 ¸ü¸Ä½Ó¿ÚÔö¼ÓÁËÌ××°µÄid
function KFXInitilizeB(int nRoleID, int nTeamIndex,
	optional int AvatarBody, optional int AvatarHead, optional int AvatarLegs,
	optional int SuitID, optional int body_pendends[CONS_decoration_count]
	)
{
	local int i;
	;

	if ( Role != ROLE_Authority )
		return;
	// Çø·ÖÄÐÅ®
	if ( nRoleID % 2 == 0 )
		bIsFemale = true;
	else
		bIsFemale = false;

	KFXPendingState.TeamID = nTeamIndex;

	KFXPendingState.nRoleID = nRoleID; //tmp code
	for(i=0; i<CONS_decoration_count; i++)
	{
		KFXPendingState.nDecorations[i] = body_pendends[i];
		log("[LABOR]-------------body_pendens, i="$i@body_pendends[i]);
	}

	KFXNormalState = KFXPendingState;  // ±£´æÒ»°ã×´Ì¬

	KFXAvatar.nBodyID = AvatarBody;
	KFXAvatar.nHeadID = AvatarHead;
	KFXAvatar.nLegsID = AvatarLegs;
	//<<ÀîÍþ¹ú Ì××°Ïà¹Ø
	KFXPendingState.nSuitID = SuitID;
	//>>
	KFXPendingState.Revision++;

	InitSkills();

	GotoState('KFXChangeState');
}

// Server only.
// load default property value.
static function LoadDefaults()
{
	local KFXCSVTable CFG_ATTR;

	CFG_ATTR = class'KFXTools'.static.GetConfigTable(41);

	if ( CFG_ATTR == none )
		return;

	if ( !CFG_ATTR.SetCurrentRow(1) )
		return;

//    default.CollisionHeight = CFG_ATTR.GetFloat("CollisionHeight");
//    default.CollisionRadius = CFG_ATTR.GetFloat("CollisionRadius");
	default.AccelRate       = CFG_ATTR.GetFloat("AccelRate");
	default.GroundSpeed     = CFG_ATTR.GetFloat("GroundSpeed");
	default.WaterSpeed      = CFG_ATTR.GetFloat("WaterSpeed");
	default.AirSpeed        = CFG_ATTR.GetFloat("AirSpeed");
	default.LadderSpeed     = CFG_ATTR.GetFloat("LadderSpeed");
	default.JumpZ           = CFG_ATTR.GetFloat("JumpZ");
//    default.DrawScale       = CFG_ATTR.GetFloat("DrawScale");
	default.DoubleJumpZThresh = CFG_ATTR.GetFloat("MultiJumpThresh");
}

// Client & Server
// ¶ÁÈ¡£¬ÉèÖÃPawnÄ¬ÈÏÊôÐÔ(CSV±í)
simulated function KFXSetupOrgData()
{
	local int nOldCollisionHeight;
	local vector CollisionHeightDiff;

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø Èç¹û»úÆ÷ÈË±»±äÖí bCanWalk²»ÄÜÉèÖÃ³Éfalse ·ñÔòÃ»·¨ËÑÂ·
	nOldCollisionHeight       = DefCollisionHeight;

	if( Controller != none&&KFXBot(Controller) != none )
		bCanWalk = true;
	else
		bCanWalk        = default.bCanWalk;
	bIsGroveling        = false;

	if ( Role == ROLE_Authority )
	{
		SetDrawScale(DrawScale);
		SetCollisionSize(DefCollisionRadius /** DrawScale*/, DefCollisionHeight /** DrawScale*/);

		/// ÏÔÊ¾ÐÅÏ¢
		PrePivot = DefPrePivot;
	}
	if(Level.NetMode!=NM_DedicatedServer)
	{
		CollisionHeightDiff.Z = DefCollisionHeight-nOldCollisionHeight;
		SetLocation(location + CollisionHeightDiff);
	}

	// Clear Weapon States
	if ( !bCanUseWeapon )
	{
		if ( KFXWeapBase(Weapon) != none )
		{
			KFXWeapBase(Weapon).KFXClearStates();
			Weapon.SetDefaultDisplayProperties();
			Weapon.DetachFromPawn(self);
		}
		SetWeapon(none);
		PendingWeapon = none;
	}

	if ( bCanUseWeapon && self.Weapon==none)
	{
		//if( KFXBot(Controller) != none )
		//    KFXBot(Controller).SwitchToBestWeapon();
	}

}
simulated function csvKFXSetupOrgData()
{
	local KFXCSVTable CFG_LIST, CFG_ATTR;
	local int PawnStateID;
	local int i;

	CFG_LIST = class'KFXTools'.static.GetConfigTable(40);
	if ( CFG_LIST == none )
		return;
	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return;
	}

	PawnStateID         = CFG_LIST.GetInt("BaseID");

	ChildSetAttrID(PawnStateID);

	bSpecialRoleState   = CFG_LIST.GetBool("bSpecial");

	KFXHeadKillProb = CFG_LIST.GetFloat("HeadKillProb");

	KFXDiffPartDmg.Insert(0,11);
	KFXDiffPartDmg[0]  = CFG_LIST.GetFloat("ChestDmg");
	KFXDiffPartDmg[1]  = CFG_LIST.GetFloat("StomachDmg");
	KFXDiffPartDmg[2]  = CFG_LIST.GetFloat("HeadDmg");
	KFXDiffPartDmg[3]  = CFG_LIST.GetFloat("LeftUpArmDmg");
	KFXDiffPartDmg[4]  = CFG_LIST.GetFloat("LeftForeArmDmg");
	KFXDiffPartDmg[5]  = CFG_LIST.GetFloat("RightUpArmDmg");
	KFXDiffPartDmg[6]  = CFG_LIST.GetFloat("RightForeArmDmg");
	KFXDiffPartDmg[7]  = CFG_LIST.GetFloat("LeftThighDmg");
	KFXDiffPartDmg[8]  = CFG_LIST.GetFloat("LeftCalfDmg");
	KFXDiffPartDmg[9]  = CFG_LIST.GetFloat("RightThighDmg");
	KFXDiffPartDmg[10]  = CFG_LIST.GetFloat("RightCalfDmg");
	;

	CFG_ATTR = class'KFXTools'.static.GetConfigTable(41);

	if ( CFG_ATTR == none )
		return;

	if ( !CFG_ATTR.SetCurrentRow(PawnStateID) )
		return;


	// TODO: Ö§³Ö±äÉí¹¦ÄÜºó£¬default±äÁ¿ÐèÒªÈ¥³ý £¬ÒòÎª¿ÉÄÜÐèÒªÍ¬Ê±´æÔÚ¶àÌ×defaultÊôÐÔ
	DefCollisionHeight      = CFG_ATTR.GetFloat("CollisionHeight");
	DefCollisionRadius      = CFG_ATTR.GetFloat("CollisionRadius");

	AccelRate               = CFG_ATTR.GetFloat("AccelRate");


	for ( i = 0; i<3; i++ )
	{
		HitBoxBounds[i].Height = CFG_ATTR.GetFloat("HitBoxBound"$i+1$"Height");
		HitBoxBounds[i].Radius = CFG_ATTR.GetFloat("HitBoxBound"$i+1$"Radius");
	}

	HitBoxBoundRadius       = HitBoxBounds[0].Radius;
	HitBoxBoundHeight       = HitBoxBounds[0].Height;

	CrouchHeight    = CFG_ATTR.GetFloat("CrouchHeight");
	CrouchRadius    = CFG_ATTR.GetFloat("CrouchRadius");
	BaseEyeHeight   = CFG_ATTR.GetFloat("BaseEyeHeight");
	CrouchBaseEyeHeight = CFG_ATTR.GetFloat("CrouchEyeHeight");

	DefGroundSpeed          = CFG_ATTR.GetFloat("GroundSpeed");
	DefWaterSpeed           = CFG_ATTR.GetFloat("WaterSpeed");
	DefAirSpeed             = CFG_ATTR.GetFloat("AirSpeed");
	DefLadderSpeed          = CFG_ATTR.GetFloat("LadderSpeed");
	DefWalkingPct           = CFG_ATTR.GetFloat("WalkingPct");
	DefCrouchedPct          = CFG_ATTR.GetFloat("CrouchPct");

	MaxFallSpeed    = CFG_ATTR.GetFloat("MaxFallSpeed");
	//default.JumpZ           = CFG_ATTR.GetFloat("JumpZ");
	DefJumpZ                = CFG_ATTR.GetFloat("JumpZ");
	DoubleJumpZ     = CFG_ATTR.GetFloat("MultiJumpZ");
	MaxMultiJump    = CFG_ATTR.GetFloat("MultiJumpNum");
	DoubleJumpZThresh = CFG_ATTR.GetFloat("MultiJumpThresh");
	DodgeSpeedZ     = CFG_ATTR.GetFloat("DodgeSpeedZ");
	DodgeSpeedFactor = CFG_ATTR.GetFloat("DodgeSpeedFactor");

	bCanJump        = CFG_ATTR.GetBool("bCanJump");
	bCanCrouch      = CFG_ATTR.GetBool("bCanCrouch");
	bCanWalk        = CFG_ATTR.GetBool("bCanWalk");
	bCanSwim        = CFG_ATTR.GetBool("bCanSwim");
	bCanFly         = CFG_ATTR.GetBool("bCanFly");
	bCanClimbLadders = CFG_ATTR.GetBool("bCanClimb");
	bCanStrafe      = CFG_ATTR.GetBool("bCanDodge");
	bCanWallDodge   = bCanStrafe;
	bKFXCanDodge    = bCanStrafe;
	bCanUseWeapon   = CFG_ATTR.GetBool("bCanUseWeapon");


	GroundSpeed         = DefGroundSpeed;
	WaterSpeed          = DefWaterSpeed;
	AirSpeed            = DefAirSpeed;
	LadderSpeed         = DefLadderSpeed;
	WalkingPct          = DefWalkingPct;
	CrouchedPct         = DefCrouchedPct;

	JumpZ               = DefJumpZ;

	KFXDamageFactor     = CFG_ATTR.GetFloat("DamageFactor");
	bUseHitboxDamage    = CFG_ATTR.GetBool("bUseHitbox");

	DrawScale = CFG_ATTR.GetFloat("DrawScale");
	/// ÏÔÊ¾ÐÅÏ¢
	/// PrePivot is replication Data!
	DefPrePivot.X = CFG_ATTR.GetFloat("PivotX");
	DefPrePivot.Y = CFG_ATTR.GetFloat("PivotY");
	DefPrePivot.Z = CFG_ATTR.GetFloat("PivotZ");
}
simulated function ChildSetAttrID( int BaseID ){}

// Client & Server Only
// ¶ÁÈ¡£¬ÉèÖÃ¿ÉÅäÖÃÊôÐÔ(ÍøÂçÊý¾Ý)
// Éæ¼°µ½ÏÔÊ¾ºÍÉùÒôµÄÊý¾ÝÐèÒªÍ¬²½µ½¿Í»§¶Ë
function KFXSetupCfgData()
{
	;
	// TODO: Ê¹ÓÃKFXStateÖÐµÄÊý¾Ý
}
function csvKFXSetupCfgData()
{
	;
	// TODO: Ê¹ÓÃKFXStateÖÐµÄÊý¾Ý
}

// Server Only
simulated function KFXSetupServerMedia()
{
	// ÔØÈë¹Ç÷À,HitBoxÐÅÏ¢
	KFXServerCreateAvatar();
}

// Client Only
// ³õÊ¼»¯¿Í»§¶ËÏà¹ØÂß¼­

simulated function csvKFXSetupClientMedia()
{
	;
	csvKFXLoadMediaState();
	csvKFXCreateAvatar();
}
simulated function KFXSetupClientMedia()
{
	local Actor EffectActor;
	local vector KFXEffectSpawnLoc;

	;

	// ±£´æ»Ö¸´ÌØÐ§
	LastRecoverEffectClass = RecoverEffectClass;


	KFXCreateAvatar();
	KFXCreateShadow();
	LinkDBWeapAnim();
	ShouldCrouch(false);
	// ²¥·Å³öÉú»ò»Ö¸´ÌØÐ§
	if( KFXNeedBornEffect() )
	{
		KFXEffectSpawnLoc = Location - vect(0,0,1)*self.CollisionHeight;
		if ( LastRecoverEffectClass != none )
		{
			EffectActor = Spawn(LastRecoverEffectClass, self,,KFXEffectSpawnLoc);
			AttachToBone(EffectActor,'');
		}
		else if ( BornEffectClass != none )
		{
			EffectActor = Spawn(BornEffectClass, self,,Location);
			AttachToBone(EffectActor,'');
		}
	}

	if ( bCanUseWeapon && self.Weapon==none)
	{
		if(Controller!=none)
		Controller.SwitchToBestWeapon();
		else
		;
	}
}
simulated function bool KFXNeedBornEffect()
{
	return true;
}
simulated function bool IsGodPawn();
// Client Only
// ¶ÁÈ¡£¬ÉèÖÃPawnµÄÏÔÊ¾,ÉùÒôµÈÊý¾Ý
simulated function csvKFXLoadMediaState()
{
	local KFXCSVTable CFG_LIST, CFG_Media, CFG_Sound;
	local int PawnStateID, TempID;
	local string TempString;
	local int i,j;
	local int RandNum;
	local string DirName[4];

	;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Media = class'KFXTools'.static.GetConfigTable(42);
	CFG_Sound = class'KFXTools'.static.GetConfigTable(46);

	if ( CFG_LIST == none || CFG_Media == none  )
		return;

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return;
	}

	PawnStateID = CFG_LIST.GetInt("BaseID"); // TODO: À©Õ¹ÖÃ±äÉí¹¦ÄÜ

	if ( !CFG_Media.SetCurrentRow(PawnStateID) )
		return;

	/// ¶ÁÈ¡¶¯»­×ÊÔ´
	KFXDefAniState = CFG_Media.GetInt("DefAniState");

	BombDeathAnimName       = CFG_Media.GetName("AniBombDeath");

	DirName[0] = "F";
	DirName[1] = "B";
	DirName[2] = "L";
	DirName[3] = "R";

	//³õÊ¼»¯ËÀÍö¶¯×÷
	for ( i = 0; i<4; i++ )
	{
		for ( j = 0; j<3; j++ )
		{
			HitHeadDeathAnimExt[i*3+j]  = CFG_Media.GetName("AnimHeadDeath"$DirName[i]$j);
			HitCrouchHeadDeathAnimExt[i*3+j] = CFG_Media.GetName("AnimCrouchHeadDeath"$DirName[i]$j);
			HitBodyDeathAnimExt[i*3+j] = CFG_Media.GetName("AnimBodyDeath"$DirName[i]$j);
			HitCrouchBodyDeathAnimExt[i*3+j] = CFG_Media.GetName("AnimCrouchBodyDeath"$DirName[i]$j);
		}
	}
	for ( j = 0; j<3; j++ )
	{
		HitLegsDeathAnimExt[j] = CFG_Media.GetName("AnimLegsDeath"$j);
		ExplodeDeathAnimExt[j] = CFG_Media.GetName("AnimExplodeDeath"$j);
	}

	/// ¶ÁÈ¡ÒôÐ§×ÊÔ´
	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndHeadshot"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		HeadshotSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndBodyshot"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		BodyshotSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	//ÔÝÊ±½öÓ¦ÓÃÓÚÉú»¯Ä£Ê½
	for(i=0; i<4; i++)
	{
		RandNum = i + 1;
		TempID = CFG_LIST.GetInt("SndHitHeadSound"$RandNum);
		if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
		{
			HitHeadSound[i] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
			log("KFXPawnBase---111----HitHeadSound[i] "$HitHeadSound[i]);
		}

		RandNum = i + 1;
		TempID = CFG_LIST.GetInt("SndHitBodySound"$RandNum);
		if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
		{
			HitBodySound[i] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
			log("KFXPawnBase---111----HitBodySound[i] "$HitBodySound[i]);
		}
	}
	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndKnifeHit"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		KnifeHitSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	TempID = CFG_LIST.GetInt("SndHammerHit");
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		HammerHitSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndDeath"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		DeadSound = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	RandNum = Rand(5) + 1;
	TempID = CFG_LIST.GetInt("SndFallPain"$RandNum);
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		SoundFallPains = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}
	TempID = CFG_LIST.GetInt("SndCry1");
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		CrySound[0] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	TempID = CFG_LIST.GetInt("SndCry2");
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		CrySound[1] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	TempID = CFG_LIST.GetInt("SndCry3");
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		CrySound[2] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	TempID = CFG_LIST.GetInt("SndCry4");
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		CrySound[3] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	TempID = CFG_LIST.GetInt("SndCry5");
	if ( TempID != 0 && CFG_Sound.SetCurrentRow(TempID) )
	{
		CrySound[4] = Sound(DynamicLoadObject(CFG_Sound.GetString("ResName"), class'Sound'));
	}

	/// ¶ÁÈ¡Ð§¹û×ÊÔ´
	BornEffectClass = none;
	TempString = CFG_Media.GetString("EffectBorn");
	if ( TempString != "none" )
	{
		BornEffectClass = class<Actor>(DynamicLoadObject(TempString, class'Class'));
	}

	RecoverEffectClass = none;
	TempString = CFG_Media.GetString("EffectRecover");
	if ( TempString != "none" )
	{
		RecoverEffectClass = class<Actor>(DynamicLoadObject(TempString, class'Class'));
	}

	BloodEffect = none;
	TempString = CFG_Media.GetString("EffectBlood");
	if ( TempString != "none" )
	{
		BloodEffect = class<Effects>(DynamicLoadObject(TempString, class'Class'));
	}

	StepWaterEffectClass = none;
	TempString = CFG_Media.GetString("EffectWater");
	if ( TempString != "none" )
	{
		StepWaterEffectClass = class<Actor>(DynamicLoadObject(TempString, class'Class'));
	}

	// ÉùÒô²¥·ÅÆµÂÊ
	fPlayStepSoundRate        = CFG_Media.GetFloat("StepSoundRate");

	// ÎäÆ÷
	KFXWeapLocTableName       = CFG_Media.GetString("WeapOffsetTable");

	// ÁÙÊ±¹¦ÄÜ
	//KFXWeaponLocationCsvIndex = CFG_Media.GetInt("WeapLocIndex");

	log("[Pawn] KFXLoadMediaData End");

}

// »ñµÃ¸ù¾Ý¶ÓÎé»ñµÃµÄ×Ö·û´®
simulated function string KFXGetTeamColoredString(string Origin, int TeamIndex)
{
	local string ColorRed, ColorBlue, ColorGrey;

	ColorRed = "red";
	ColorBlue = "blue";
	ColorGrey = "Grey";

	if ( Right(Origin, 1) == "_" )
	{
		switch ( TeamIndex )
		{
			case 0:
				return Origin$ColorBlue;
			case 1:
				return Origin$ColorRed;
			default:
				return Origin$ColorGrey;
		}
	}
	else
		return Origin;
}

// Client & Server
// ÅÐ¶ÏÊÇ·ñÔÚÍ¬Ò»¶Ó
simulated function bool KFXInTheSameTeam(KFXPawnBase p)
{
	if ( p.KFXCurrentState.TeamID != KFXCurrentState.TeamID
		|| p.KFXCurrentState.TeamID == 255 )
		return false;
	return true;
}

// Server Only
function KFXServerCreateAvatar()
{
	local KFXCSVTable CFG_LIST, CFG_Media, CFG_Skel, CFG_Avatar;
	local int PawnStateID, DefMeshID, SkeletonID;
	local string MeshName;
	local bool bFirstPerson;
	local vector NewLoc;

	;
	bPhysicsAnimUpdate=true;

	if( !CheckLocHeight() )
	{
		log("[KFXPawnBase]  KFXCreateAvatar no Crouch" );
		ShouldCrouch(false);
		// Switch to default Hitbox Group: Must After Skeleton Initialized !
		SwitchHitBoxGroup(0);
	}
	else
	{
		log("[KFXPawnBase]  KFXCreateAvatar must Crouch" );

		NewLoc = Location;
		NewLoc.Z -= BaseEyeHeight - CrouchBaseEyeHeight ;
		SetLocation(NewLoc);
		ClientChangeDuck();
		ForceCrouch();
		// Switch to default Hitbox Group: Must After Skeleton Initialized !
		SwitchHitBoxGroup(1);

	}

	if ( bFirstPerson &&controller!=none)
	{
		//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
		if(PlayerController(Controller) != none&&PlayerController(Controller).bBehindView)
		//if(PlayerController(Controller).bBehindView)
		//>>
		{
			PlayerController(Controller).ToggleBehindView();
		}
	}
	else if(self.Controller!=none)
	{
		//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
		if(PlayerController(Controller) != none&&!PlayerController(Controller).bBehindView)
		//if(!PlayerController(Controller).bBehindView)
		//>>
		{
			PlayerController(Controller).ToggleBehindView();
		}
	}
}
//=====¼ì²é½ÇÉ«ËùÔÚÎ»ÖÃ´¦µÄ³¡¾°¸ß¶ÈÀ´ÅÐ¶ÏÆäÊÇ·ñÊÇÓ¦¸ÃÏÂ¶×
simulated function bool CheckLocHeight()
{
	local vector TestLoc;

	TestLoc = Location;
	TestLoc.Z = TestLoc.Z + CollisionHeight - CrouchHeight;
	;

	if( KFXCurrentState.nRoleID == 1003 || KFXCurrentState.nRoleID == 1001 || KFXCurrentState.nRoleID == 1002 )
	{
		if( !SetLocation( TestLoc ) )
		return true;
	}

	return false;
}

//===client only
simulated function SetInitCrouch( Bool Need )
{
}

simulated function bool GetInitCrouch()
{
	return true;
}

simulated function ClientChangeDuck()
{
	SetInitCrouch( true );
	;
}

// Client Only (KFXSetupMediaDataµ÷ÓÃ)
// ³õÊ¼»¯»ò±ä»» AvatarÄ£ÐÍ
simulated function KFXCreateAvatar()
{
	// AssignInitialPose
	if ( Level.NetMode != NM_DedicatedServer )
	{
		// ¸ÉµôAvatar²¿·Ö
		KFXDestroyShadow();

		if ( AvatarHead != none )
			AvatarHead.Destroy();
		if ( AvatarLegs != none )
			AvatarLegs.Destroy();

		bPhysicsAnimUpdate=true;



		bWaitForAnim = true;
		;
//        if(KFXWeapBase(Weapon)!=none && Weapon.ThirdPersonActor!=none&&KFXWeapAttachment(KFXWeapBase(Weapon).ThirdPersonActor)!=none)
//        {
//            KFXChangeAniGroup(KFXWeapAttachment(KFXWeapBase(Weapon).ThirdPersonActor).KFXAnimGroupIndex);
//            LOG("[PawnBase] KFXCreateAvatar"$KFXWeapAttachment(KFXWeapBase(Weapon).ThirdPersonActor).KFXAnimGroupIndex);
//        }
//        else
//        {
//            LOG("[PawnBase] KFXCreateAvatar Default index"$KFXDefAniState);
			if( KFXDefAniState > 0 )
				KFXCurAniState = KFXDefAniState;

			KFXChangeAniGroup(KFXCurAniState);//KFXDefAniState
//        }
		bWaitForAnim = false;


		if( !GetInitCrouch() )
		{
			log("[KFXPawnBase]  KFXCreateAvatar no Crouch" );
			SwitchHitBoxGroup(0);
		}
		else
		{
			log("[KFXPawnBase]  KFXCreateAvatar must Crouch" );
			ForceCrouch();
			// Switch to default Hitbox Group: Must After Skeleton Initialized !
			SwitchHitBoxGroup(1);
			SetInitCrouch( false );
		}


		TweenAnim(IdleCrouchAnim,0.0);
		AnimBlendParams(2, 1.0, 0.2, 0.2, FireRootBone);
		BoneRefresh();

		if( Physics == PHYS_Walking )
		{
			if(bIsCrouched)
			{
				PlayAnim(BlendIdleCrouchAnims,,,1);
				PlayAnim(IdleCrouchAnim);
			}
			else
			{
				PlayAnim(BlendIdleStandAnims,,,1);
				PlayAnim(IdleWeaponAnim);
			}
		}
	}

//
//    // Toggle Thirdperson?
//    // ÅÐ¶ÏÖ»ÓÐÔÚÖ÷¿Ø¿Í»§¶Ë²Å½øÐÐ¸Ã²Ù×÷
//    if ( IsLocallyControlled() )
//    {
//        bDoTorsoTwist=false;
//        bInterpolating=false;
//    }

}
simulated function csvKFXCreateAvatar()
{
	local KFXCSVTable CFG_LIST, CFG_Media;
	local int PawnStateID, DefMeshID, DefBodyID, DefHeadID, DefLegsID, SkeletonID;

	;
	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Media = class'KFXTools'.static.GetConfigTable(42);
	if ( CFG_LIST == none || CFG_Media == none )
		return;

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return;
	}

	PawnStateID = CFG_LIST.GetInt("BaseID");
	DefMeshID   = CFG_LIST.GetInt("MeshID");

	if ( !CFG_Media.SetCurrentRow(PawnStateID) )
		return;
	SkeletonID  = CFG_Media.GetInt("Skeleton");

	//<<ÀîÍþ¹ú Ì××°Ïà¹Ø
	if( KFXPendingState.nSuitID != 0 )
	{
		;
		DefMeshID = KFXPendingState.nSuitID;
	}
	else
		;
	//>>

	// ²»Ö§³ÖAvatarµÄ³õÊ¼»¯
	KFXIsAvatar = false;
	csv_KFXAvatarDisabled(DefMeshID, SkeletonID);
	KFXPendingState.nSuitID = DefMeshID;
}

simulated function int GetPlayerRealTeamNum()
{
	local int ChangeTeamCont;

	if( KFXGameReplicationInfo(Level.GRI) == none  )
		return 0;

    ChangeTeamCont = KFXGameReplicationInfo( Level.GRI ).fxChangeTeamCount;
    if( ChangeTeamCont%2 == 0 )
    {
        if(PlayerReplicationInfo != none)
        {
		return ( PlayerReplicationInfo.Team.TeamIndex );
	}
	else
	{
            return 0;
        }
    }
    else
    {
        if(PlayerReplicationInfo != none)
        {
		return ( 1 - PlayerReplicationInfo.Team.TeamIndex );
	}
        else
        {
            return 1;
        }
    }
}


simulated function _KFXAvatarEnabled(int BodyID, int HeadID, int LegID, int SkelID)
{
	local KFXCSVTable CFG_Skel, CFG_Avatar;
	local string SkeletonName, MeshName, Skin1, Skin2;
	local MeshAnimation SkelAnim;
	local bool PartitionTeam;

	// ·Ç»»×°Ä£Ê½£¬¸ù¾ÝRoleIDÀ´³õÊ¼»¯½ÇÉ«
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);
	CFG_Skel  = class'KFXTools'.static.GetConfigTable(45);

	if ( CFG_Avatar == none || CFG_Skel == none )
		return;

	if ( !CFG_Skel.SetCurrentRow(SkelID) )
		return;
	SkeletonName = CFG_Skel.GetString("Res");
	RootBone     = CFG_Skel.GetName("RootBone");
	HeadBone     = CFG_Skel.GetName("HeadBone");
	SpineBone1   = CFG_Skel.GetName("SpineBone1");
	SpineBone2   = CFG_Skel.GetName("SpineBone2");
	WeaponBone   = CFG_Skel.GetName("WeaponBone");
	FireRootBone = CFG_Skel.GetName("FireRootBone");
	PelvisBone   = CFG_Skel.GetName("PelvisBone");
	Spine1Bone   = CFG_Skel.GetName("Spine1Bone");
	Spine2Bone   = CFG_Skel.GetName("Spine2Bone");
	Spine3Bone   = CFG_Skel.GetName("Spine3Bone");

	RagdollEnabled = CFG_Skel.GetBool("UseRagdoll");
	if (RagdollEnabled)
		RagdollOverride = CFG_Skel.GetString("RagDollData");

	if ( !CFG_Avatar.SetCurrentRow(BodyID) )
		return;
	MeshName = CFG_Avatar.GetString("mesh");
	Skin1 = CFG_Avatar.GetString("skin1");
	Skin2 = CFG_Avatar.GetString("skin2");

	// ³õÊ¼»¯meshºÍSkins
	SkelAnim = none; // Really necessry ?
	//SkelAnim = MeshAnimation(DynamicLoadObject(SkeletonName, class'MeshAnimation'));
	//LinkSkelAnim(SkelAnim);
	LinkMesh(Mesh(DynamicLoadObject(MeshName, class'Mesh')),false);
	LinkDBWeapAnim();
	log("_KFXAvatarEnabled mesh:"$self.Mesh);
//    if( HeadID == 4122 && BodyID == 4112 && LegID == 4132 && BodyID == 9115 && HeadID == 9125 && LegID == 9135 )
//    {
		PartitionTeam = true;

		KFXChangeSkin(Skin1,Skin2,false);

//    }
//    else
//    {
//        PartitionTeam = false;
//        KFXChangeSkin(Skin1,Skin2,false);
//    }

	// Create Avatar Part
	if ( AvatarHead == none )
		AvatarHead = Spawn(class'KFXAvatarPart');
	AvatarHead.KFXAvatarInitialize( self, GetPlayerRealTeamNum(), HeadID, SkelAnim, PartitionTeam );

	if ( AvatarLegs == none )
		AvatarLegs = Spawn(class'KFXAvatarPart');
	AvatarLegs.KFXAvatarInitialize(self, GetPlayerRealTeamNum(), LegID, SkelAnim, PartitionTeam);

	AttachToBone(AvatarHead, '');
	AttachToBone(AvatarLegs, '');

	bPhysicsAnimUpdate=true;
}

simulated function Shader GetSpecialSkin()
{
	return none;
}

simulated function KFXChangeSkin(string Skin1,string Skin2,optional bool Special)
{
	// Create Main Part Skin
	local Shader CopyShader, ResultShader[2];
	local material mat;
	if ( Special )
	{
		CopyShader = GetSpecialSkin();
		ResultShader[0] = new class'Shader';
		ResultShader[1] = new class'Shader';

		ResultShader[0].SelfIllumination = CopyShader.SelfIllumination;
		ResultShader[0].OutputBlending = CopyShader.OutputBlending;
		ResultShader[0].Diffuse = CopyShader.Diffuse;
		ResultShader[0].Opacity = CopyShader.Opacity;
		//ResultShader[0].Specular = CopyShader.Specular;
		ResultShader[0].SpecularityMask = CopyShader.SpecularityMask;
		ResultShader[0].SelfIllumination = CopyShader.SelfIllumination;
		ResultShader[0].SelfIlluminationMask = CopyShader.SelfIlluminationMask;
		ResultShader[0].Detail = CopyShader.Detail;
		ResultShader[0].OutputBlending = CopyShader.OutputBlending;

		ResultShader[1].SelfIllumination = CopyShader.SelfIllumination;
		ResultShader[1].OutputBlending = CopyShader.OutputBlending;
		ResultShader[1].Diffuse = CopyShader.Diffuse;
		ResultShader[1].Opacity = CopyShader.Opacity;
		//ResultShader[1].Specular = CopyShader.Specular;
		ResultShader[1].SpecularityMask = CopyShader.SpecularityMask;
		ResultShader[1].SelfIllumination = CopyShader.SelfIllumination;
		ResultShader[1].SelfIlluminationMask = CopyShader.SelfIlluminationMask;
		ResultShader[1].Detail = CopyShader.Detail;
		ResultShader[1].OutputBlending = CopyShader.OutputBlending;
	}
	if(Skins.Length==0)
	{
		Skins.Insert(0,2);
	}
	Skins[0] = none;
//    Skins[1] = none;

	if ( Skin1 != "none" )
	{
		Skin1 = KFXGetTeamColoredString( Skin1, GetPlayerRealTeamNum() );
		mat = default.Skins[0];
		if ( Special )
		{
			log("mat0:"$mat);
			if ( Shader( mat ) !=none )
				ResultShader[0].Specular = Shader(mat).Diffuse;
			else
				ResultShader[0].Specular = mat;
			Skins[0]= ResultShader[0];//CopyShader;//ResultShader[0];
		}
		else
		{
			Skins[0]=mat;
		}
	}
	RequestRecord(""$"5 "$Skin1);  //RDN_Texture0
}

simulated function csv_KFXAvatarDisabled(int MeshID, int SkelID)
{
	local KFXCSVTable CFG_Skel, CFG_Avatar;
	local string SkeletonName, MeshName, Skin1, Skin2;

	// ·Ç»»×°Ä£Ê½£¬¸ù¾ÝRoleIDÀ´³õÊ¼»¯½ÇÉ«
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);
	CFG_Skel  = class'KFXTools'.static.GetConfigTable(45);

	if ( CFG_Avatar == none || CFG_Skel == none )
		return;

	if ( !CFG_Skel.SetCurrentRow(SkelID) )
		return;
	SkeletonName = CFG_Skel.GetString("Res");
	RootBone     = CFG_Skel.GetName("RootBone");
	HeadBone     = CFG_Skel.GetName("HeadBone");
	SpineBone1   = CFG_Skel.GetName("SpineBone1");
	SpineBone2   = CFG_Skel.GetName("SpineBone2");
	WeaponBone   = CFG_Skel.GetName("WeaponBone");
	FireRootBone = CFG_Skel.GetName("FireRootBone");
	PelvisBone   = CFG_Skel.GetName("PelvisBone");
	Spine1Bone   = CFG_Skel.GetName("Spine1Bone");
	Spine2Bone   = CFG_Skel.GetName("Spine2Bone");
	Spine3Bone   = CFG_Skel.GetName("Spine3Bone");

	RagdollEnabled = CFG_Skel.GetBool("UseRagdoll");
	if (RagdollEnabled)
		RagdollOverride = CFG_Skel.GetString("RagDollData");


	if ( !CFG_Avatar.SetCurrentRow(MeshID) )
		return;
	MeshName = CFG_Avatar.GetString("mesh");
	Skin1 = CFG_Avatar.GetString("skin1");
	Skin2 = CFG_Avatar.GetString("skin2");

	// ³õÊ¼»¯meshºÍSkins
	// Really necessry ?
	//LinkSkelAnim(MeshAnimation(DynamicLoadObject(SkeletonName, class'MeshAnimation')));
	LinkMesh(Mesh(DynamicLoadObject(MeshName, class'Mesh')),false);
	LinkDBWeapAnim();
	log("pawn mesh:"$Mesh);
	// Set Skins
	Skins[0] = Material(DynamicLoadObject(Skin1, class'Material'));
	Skins[1] = Material(DynamicLoadObject(Skin2, class'Material'));
}
simulated function KFXChangeSkinSpecial( bool Special )
{
	local KFXCSVTable CFG_Avatar;
	local String Skin1, Skin2;
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);
	if ( !CFG_Avatar.SetCurrentRow(KFXPendingState.nSuitID) )
		return;
	Skin1 = CFG_Avatar.GetString("skin1");
	Skin2 = CFG_Avatar.GetString("skin2");
	log("KFXChangeSkinSpecial SuitID:"$KFXPendingState.nSuitID$"Skin1:"$Skin1$"Skin2:"$Skin2);
	KFXChangeSkin(Skin1,Skin2,Special);

}
simulated function LinkDBWeapAnim()
{
	local KFXCSVTable CFG_LIST, CFG_Media, CFG_Skel;
	local int PawnStateID, DefMeshID, SkelID;
	local string SkeletonName;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Media = class'KFXTools'.static.GetConfigTable(42);
	if ( CFG_LIST == none || CFG_Media == none )
		return;

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return;
	}

	PawnStateID = CFG_LIST.GetInt("BaseID");
	DefMeshID   = CFG_LIST.GetInt("MeshID");

	if ( !CFG_Media.SetCurrentRow(PawnStateID) )
		return;
	SkelID  = CFG_Media.GetInt("Skeleton");




	CFG_Skel  = class'KFXTools'.static.GetConfigTable(45);
	if ( !CFG_Skel.SetCurrentRow(SkelID) )
		return;

	SkeletonName = CFG_Skel.GetString("Res");
	log("linkanim"@SkeletonName);
	LinkSkelAnim(MeshAnimation(DynamicLoadObject(SkeletonName, class'MeshAnimation')));
	SkeletonName = CFG_Skel.GetString("Res2");   // ¶ÁÈ¡ÎÕ°ÑÎäÆ÷ÏàÓ¦µÄ½ÇÉ«¶¯»­°ü
	log("linkanim"@SkeletonName);
	LinkSkelAnim(MeshAnimation(DynamicLoadObject(SkeletonName, class'MeshAnimation')));
	BoneRefresh();

	if( Physics == PHYS_Walking )
	{
		if(bIsCrouched)
		{
			PlayAnim(BlendIdleCrouchAnims,,,1);
			PlayAnim(IdleCrouchAnim);
		}
		else
		{
			PlayAnim(BlendIdleStandAnims,,,1);
			PlayAnim(IdleWeaponAnim);
		}
	}
}

//<<ÀîÍþ¹ú Ì××°Ïà¹Ø
exec function bool KFXChangeSuit(int SuitID)
{
	local KFXCSVTable CFG_Avatar;
	local string MeshName, Skin1, Skin2;

	if ( KFXIsAvatar )
		return false;

	// ¼ì²é¸ü»»²¿Î»
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);
	if ( !CFG_Avatar.SetCurrentRow(SuitID) )
		return false;

	MeshName = CFG_Avatar.GetString("mesh");
	//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.2.12  ÐÞ¸Ä»»bodyid²»»»¶¯×÷µÄÎÊÌâ
	LinkMesh(Mesh(DynamicLoadObject(MeshName, class'Mesh')), false);

	LinkDBWeapAnim();

	BoneRefresh();

	Skin1 = CFG_Avatar.GetString("skin1");
	Skin2 = CFG_Avatar.GetString("skin2");
	KFXChangeSkin(Skin1,Skin2,false);

	return true;
}

// Client Only
// Avatar»»×°º¯Êý
exec function bool KFXChangeAvatar(int AvatarID)
{
	local KFXCSVTable CFG_Avatar;
	local string MeshName, Skin1, Skin2;
	local EAvatarPart Part;

	if ( !KFXIsAvatar )
		return false;

	// ¼ì²é¸ü»»²¿Î»
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);
	if ( !CFG_Avatar.SetCurrentRow(AvatarID) )
		return false;

	Part = EAvatarPart( CFG_Avatar.GetInt("part") );

	// Change Body
	if ( Part == Avatar_Body )
	{
		MeshName = CFG_Avatar.GetString("mesh");
		//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.2.12  ÐÞ¸Ä»»bodyid²»»»¶¯×÷µÄÎÊÌâ
		LinkMesh(Mesh(DynamicLoadObject(MeshName, class'Mesh')), false);
		//>>

		LinkDBWeapAnim();

		BoneRefresh();

		Skin1 = CFG_Avatar.GetString("skin1");
		Skin2 = CFG_Avatar.GetString("skin2");
		KFXChangeSkin(Skin1,Skin2,false);
	}
	// Change Head
	else if ( Part == Avatar_Head )
	{
		//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.2.12  ÐÞ¸Ä»»bodyid²»»»¶¯×÷µÄÎÊÌâ
		AvatarHead.KFXAvatarChangeMesh(AvatarID, GetPlayerRealTeamNum(), true);
		//>>
	}
	// Change Legs
	else if ( Part == Avatar_Legs )
	{
		//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.2.12  ÐÞ¸Ä»»bodyid²»»»¶¯×÷µÄÎÊÌâ
		AvatarLegs.KFXAvatarChangeMesh(AvatarID, GetPlayerRealTeamNum(), true);
		//>>
	}
	else
	{
		return false;
	}

	return true;
}

// Client Only
// Avatar»»×°º¯Êý,»Ö¸´³õÊ¼µÄÄ£ÐÍ
// @param BodyPart: ²Î¿¼Ã¶¾ÙÐÍEAvatarPart
exec function bool KFXRemoveAvatar(int BodyPart/*EAvatarPart*/)
{
	local KFXCSVTable CFG_LIST;
	local int AvatarID;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);

	if ( CFG_LIST == none )
		return false;

	if ( !CFG_LIST.SetCurrentRow(KFXPendingState.nRoleID) )
	{
		if( !CFG_LIST.SetCurrentRow(1) ) //ÉèÖÃÄ¬ÈÏ
		return false;
	}

	if ( BodyPart == 1 ) // Body
	{
		AvatarID = CFG_LIST.GetInt("DefBody");
	}
	else if ( BodyPart == 2 ) // Head
	{
		AvatarID = CFG_LIST.GetInt("DefHead");
	}
	else if ( BodyPart == 3 ) // Legs
	{
		AvatarID = CFG_LIST.GetInt("DefLeg");
	}

   return KFXChangeAvatar(AvatarID);
}

// Client Only
// ÅÐ¶ÏAvatarÓëRoleÊÇ·ñºÏÊÊ
simulated static function bool KFXIsAvatarCompatible(int AvatarID, int RoleID)
{
	local KFXCSVTable CFG_LIST, CFG_Media, CFG_Avatar;
	local int PawnStateID, SkeletonID, AvatarSkelID;

	if ( AvatarID <= 0 || RoleID <= 0 )
		return false;

	CFG_LIST  = class'KFXTools'.static.GetConfigTable(40);
	CFG_Media = class'KFXTools'.static.GetConfigTable(42);
	CFG_Avatar= class'KFXTools'.static.GetConfigTable(44);

	if ( CFG_LIST == none || CFG_Media == none || CFG_Avatar == none )
		return false;

	if ( !CFG_LIST.SetCurrentRow(/*KFXPendingState.nRoleID*/RoleID) )
		return false;
	PawnStateID = CFG_LIST.GetInt("BaseID");

	if ( !CFG_Media.SetCurrentRow(PawnStateID) )
		return false;
	SkeletonID  = CFG_Media.GetInt("Skeleton");

	if ( !CFG_Avatar.SetCurrentRow(AvatarID) )
		return false;
	AvatarSkelID = CFG_Avatar.GetInt("skeleton");

	if ( AvatarSkelID != SkeletonID )
		return false;

	return true;
}

// Client Only (KFXSetupMediaDataµ÷ÓÃ)
// ³õÊ¼»¯ÒõÓ° (TODO:¸ù¾Ý³¡¾°µÄÌ«Ñô¹âÀ´È·¶¨ÒõÓ°·½Ïò)
simulated function KFXCreateShadow()
{
//    local Sunlight sunlightActor;
//    local vector sunLigthDirection;
//    local ProjDisplay ProjHUD;
	;

	if(bActorShadows && bPlayerShadows)
	{
//        foreach AllActors(class'Sunlight',sunlightActor)
//        {
//             sunLigthDirection = Normal(vector(sunlightActor.Rotation));
//             LOG("[DDL] ----- sunLigthDirect = "$sunLigthDirection);
//             break;
//        }

		// Create Body Shadow
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
		KFXPlayerBodyShadow.bShadowActive = class'KFXPlayer'.default.bKFXShowShadow;

		if ( AvatarHead != none )
		{
			// Create Head Shadow
			if ( KFXPlayerHeadShadow == none )
			{
				KFXPlayerHeadShadow = Spawn(class'ShadowProjector',Self,'',Location);
				KFXPlayerHeadShadow.ShadowActor = AvatarHead;
				KFXPlayerHeadShadow.bBlobShadow = bBlobShadow;
				KFXPlayerHeadShadow.LightDirection = Normal(vect(0,0,1)); // = -sunLigthDirection;
				KFXPlayerHeadShadow.LightDistance = 1000;
				KFXPlayerHeadShadow.MaxTraceDistance=355;
				KFXPlayerHeadShadow.InitShadow();
			}
			KFXPlayerHeadShadow.bShadowActive = class'KFXPlayer'.default.bKFXShowShadow;
		}

		if ( AvatarLegs != none )
		{
			// Create Legs Shadow
			if ( KFXPlayerLegsShadow == none )
			{
				KFXPlayerLegsShadow = Spawn(class'ShadowProjector',Self,'',Location);
				KFXPlayerLegsShadow.ShadowActor = AvatarLegs;
				KFXPlayerLegsShadow.bBlobShadow = bBlobShadow;
				KFXPlayerLegsShadow.LightDirection = Normal(vect(0,0,1)); // = -sunLigthDirection;
				KFXPlayerLegsShadow.LightDistance = 1000;
				KFXPlayerLegsShadow.MaxTraceDistance=355;
				KFXPlayerLegsShadow.InitShadow();
			}
			KFXPlayerLegsShadow.bShadowActive = class'KFXPlayer'.default.bKFXShowShadow;
		}
	}
//    ScenceActorHUDProjector = Spawn(class'ScenceActorHUDProjector',Self,'',Location);
//    log("[PawnBase] ScenceActorHUDProjector "$ScenceActorHUDProjector);
//    ScenceActorHUDProjector.ScenceActor = self;
//    ScenceActorHUDProjector.InitScenceActorHUD();
//    AttachToBone(ScenceActorHUDProjector,'');
//    ScenceActorHUDProjector.SetRelativeLocation( vect(0,0,0) );
//
//    ProjHUD = Spawn(class'ProjDisplay',Self,'',Location);
//    AttachToBone(ProjHUD,'');
//    ProjHUD.SetRelativeLocation( vect(0,0,0) );
//    ProjHUD.Texture = ScenceActorHUDProjector.SAHUDTexture;//Material(DynamicLoadObject("fx_ui3_texs.hud_danger", class'Material'));
//    LOG("[PawnBase] ProjHUD"$ProjHUD$"Texture:"$ProjHUD.Texture );
}
simulated function KFXDestroyShadow()
{
	if ( KFXPlayerBodyShadow != none )
		KFXPlayerBodyShadow.Destroy();

	if ( KFXPlayerHeadShadow != none )
		KFXPlayerHeadShadow.Destroy();

	if ( KFXPlayerLegsShadow != none )
		KFXPlayerLegsShadow.Destroy();
}
simulated function KFXSetShadowEnable(bool bEnable)
{
	if ( KFXPlayerBodyShadow != none )
		KFXPlayerBodyShadow.bShadowActive = bEnable;

	if ( KFXPlayerHeadShadow != none )
		KFXPlayerHeadShadow.bShadowActive = bEnable;

	if ( KFXPlayerLegsShadow != none )
		KFXPlayerLegsShadow.bShadowActive = bEnable;
}
//=============================================================================
// Server Only or Stand alone
// ±äÉí£¡±äÉí£¡±äÉí£¡
exec function bool KFXMagicChange(int RoleID, optional int suitid)
{
	;

//    if ( RoleID == KFXCurrentState.nRoleID )
//        return false;

	KFXPendingState.nRoleID = RoleID;
	KFXPendingState.nSuitID = SuitID;

	if(KFXPendingState.nRoleID == 2)
		bIsFemale = true;
	else
		bIsFemale = false;
//    KFXPendingState.Revision++;
//    NetUpdateTime = Level.TimeSeconds - 1;
	csvKFXInit();
//    GotoState('KFXChangeState');

	return true;
}
// Server Only or Stand alone
// ±äÉí»Ö¸´£¡
exec function KFXMagicResume()
{
	;
	if ( Role != ROLE_Authority )
		return;

	if ( KFXNormalState.nRoleID == KFXCurrentState.nRoleID )
		return;

	KFXPendingState.nRoleID = KFXNormalState.nRoleID;
	KFXPendingState.Revision++;
	;

	NetUpdateTime = Level.TimeSeconds - 1;

	GotoState('KFXChangeState');
}

//<<ÀîÍþ¹ú Ì××°Ïà¹Ø 2009.1.22
exec function bool KFXGoToChangeState()
{
	;

	if ( Role != ROLE_Authority )
		return false;

	KFXPendingState.Revision++;
	NetUpdateTime = Level.TimeSeconds - 1;

	GotoState('KFXChangeState');

	return true;
}
//>>

// Client Only
simulated function KFXPostReceiveTick()
{
	// Change state , Client Only
	// TODO: ÎªÊ²Ã´ PostNetReceiveÀïÃæ²»ºÃÓÃ
	if ( KFXCurrentState.Revision != KFXPendingState.Revision && PlayerReplicationInfo != none)
	{
	   if (!Level.GetLocalPlayerController().IsGameRecorderRecording() && Level.GetLocalPlayerController().PlayerReplicationInfo == PlayerReplicationInfo )
		   ConsoleCommand("Record");
		// TODO: Ó¦¸ÃÅÐ¶ÏÊÇ·ñÒÑ¾­ÔÚ KFXChangeState×´Ì¬ÖÐ£¬»ò×öÌØÊâ´¦Àí
		;
		GotoState('KFXChangeState');
	}
	// Received Damage Info
	if(KFXDmgRepInfo.FlashCount != KFXSavedDmgRepInfo.FlashCount)
	{
        if(KFXSavedDmgRepInfo.InstigatedBy != Level.GetLocalPlayerController().Pawn || KFXDmgRepInfo.InstigatedBy != Level.GetLocalPlayerController().Pawn)
		{
			log("third person damage anim1");
			KFXSavedDmgRepInfo = KFXDmgRepInfo;
			KFXClientPlayTakeHit();

		}
		else             //Èç¹ûÎÒÊÇÐ×ÊÖ£¬¿´µÐÈËÊÜÉË¶¯×÷²»ÔÚÕâ²¥·Å£¬Ö»ÓÐ×îºóÒ»Ç¹²ÅÔÚÕâ²¥·Å
		{
			if(Level.NetMode == NM_StandAlone)
			{
				KFXSavedDmgRepInfo = KFXDmgRepInfo;
				KFXClientPlayTakeHit();
			}
			else
			{
                if(Health <= 0)
				{
					KFXSavedDmgRepInfo = KFXDmgRepInfo;
					KFXClientPlayTakeHit();
					if(KFXDmgRepInfo.InstigatedBy != none && KFXDmgRepInfo.InstigatedBy.Controller != none)
					{
						 KFXPawnBase(KFXDmgRepInfo.InstigatedBy).KFXClientPlayAttackBloodMessage(KFXDmgRepInfo.DamageVal);
					}
				}
			}
		}
	}

}

//=============================================================================
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local Weapon OldWeapon;
	OldWeapon = Inventory.WeaponChange(5, true);
	if(OldWeapon!=none)Weapon=OldWeapon;
	super.Died(Killer,damageType,HitLocation);

}

simulated function ClientPlayDying(class<DamageType> DamageType, vector HitLoc)
{
	if ( RagdollEnabled )
		Client_PlayDying_Ragdoll(DamageType, HitLoc);
	else
		Client_PlayDying_Normal(DamageType, HitLoc);
}
simulated function Client_PlayDying_Ragdoll(class<DamageType> DamageType, vector HitLoc)
{
	local vector shotDir, hitLocRel, deathAngVel, shotStrength;
	local float maxDim;
	local string RagSkelName;
	local KarmaParamsSkel skelParams;

	AmbientSound = None;
	bCanTeleport = false;
	bReplicateMovement = false;
	//bTearOff = true;
	bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
	TakeHitLocation = HitLoc;

	// stop shooting
	AnimBlendParams(1, 0.0);

	GotoState('Dying');

	super.ClientPlayDying(DamageType, HitLoc);
	if ( Level.NetMode != NM_DedicatedServer )
	{
		// In low physics detail, if we were not just controlling this pawn,
		// and it has not been rendered in 3 seconds, just destroy it.
		if(Level.PhysicsDetailLevel == PDL_Low && (Level.TimeSeconds - LastRenderTime > 3) )
		{
			Destroy();
			return;
		}

		// Try and obtain a rag-doll setup.
	  //  if(bPigKilled)
	   //{
	  //      RagSkelName = PigRagdoll;
	  // }
	  // else
	  if( RagdollOverride != "")
	   {
			RagSkelName = RagdollOverride;
	   }
	   else
			Log("UnrealPawn.PlayDying: No RagdollOverride");

		// if we managed to find a name, try and make a rag-doll slot availbale.
		if( RagSkelName != "" )
		{
			KMakeRagdollAvailable();
		}

		if( KIsRagdollAvailable() && RagSkelName != "" )
		{
			skelParams = KarmaParamsSkel(KParams);
			skelParams.KSkeleton = RagSkelName;
			//KParams = skelParams;

			//Log("RAGDOLL");

			// Stop animation playing.
			StopAnimating(true);

			// DEBUG
			//TearOffMomentum = vect(0, 0, 0);
			//if(VSize(TearOffMomentum) < 0.01)
			//  Log("TearOffMomentum magnitude of Zero");
			// END DEBUG

			if(DamageType != None && DamageType.default.bKUseOwnDeathVel)
			{
				RagDeathVel = DamageType.default.KDeathVel;
				RagDeathUpKick = DamageType.default.KDeathUpKick;
			}

			// Set the dude moving in direction he was shot in general
			shotDir = Normal(TearOffMomentum);
			shotStrength = RagDeathVel * shotDir;

			// Calculate angular velocity to impart, based on shot location.
			hitLocRel = TakeHitLocation - Location;

			// We scale the hit location out sideways a bit, to get more spin around Z.
			hitLocRel.X *= RagSpinScale;
			hitLocRel.Y *= RagSpinScale;

			// If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
			if( VSize(TearOffMomentum) < 0.01 )
			{
				//Log("TearOffMomentum magnitude of Zero");
				deathAngVel = VRand() * 18000.0;
			}
			else
			{
				deathAngVel = RagInvInertia * (hitLocRel Cross shotStrength);
			}

			// Set initial angular and linear velocity for ragdoll.
			// Scale horizontal velocity for characters - they run really fast!
			skelParams.KStartLinVel.X = 0.6 * Velocity.X;
			skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
			skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
			skelParams.KStartLinVel += shotStrength;

			// if not moving downwards - give extra upward kick
			if(Velocity.Z > -10)
				skelParams.KStartLinVel.Z += RagDeathUpKick;

			skelParams.KStartAngVel = deathAngVel;

			// Set up deferred shot-bone impulse
			maxDim = Max(CollisionRadius, CollisionHeight);

			skelParams.KShotStart = TakeHitLocation - (1 * shotDir);
			skelParams.KShotEnd = TakeHitLocation + (2*maxDim*shotDir);
			skelParams.KShotStrength = RagShootStrength;

			// Turn on Karma collision for ragdoll.
			KSetBlockKarma(true);

			// Set physics mode to ragdoll.
			// This doesn't actaully start it straight away, it's deferred to the first tick.
			SetPhysics(PHYS_KarmaRagdoll);

			PlaySound(DeadSound, SLOT_Pain,
				HitSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
				HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));

			return;
		}

		// jag
		KFXPlayDyingAnimation(DamageType,KFXHitWeaponID, HitLoc);
	}
}
simulated function Client_PlayDying_Normal(class<DamageType> DamageType, vector HitLoc)
{
//    bTearOff = true;
//    bPlayedDeath = true;
	if(Level.NetMode == NM_DedicatedServer)
	{
		KFXHitWeaponID = KFXDmgInfo.WeaponID;
	}
	HitDamageType = DamageType; // these are replicated to other clients
	TakeHitLocation = HitLoc;

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//if(Level.NetMode == NM_DedicatedServer && !PlayerController(Controller).bBehindView)
	if(Level.NetMode == NM_DedicatedServer && PlayerController(Controller) != none && !PlayerController(Controller).bBehindView)
	//>>
	{
		PlayerController(Controller).ServerToggleBehindView();
	}

	if ( DamageType != None )
	{
		if ( DamageType.Default.DeathOverlayMaterial != None )
			SetOverlayMaterial(DamageType.Default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
		else if ( (DamageType.Default.DamageOverlayMaterial != None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
			SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 2*DamageType.default.DamageOverlayTime, true);
	}

	super.ClientPlayDying(DamageType, HitLoc);
	StopAnimating(true);
	if(Level.NetMode != NM_DedicatedServer)
	{
		AvatarLegs.StopAnimating(true);
		KFXPlayDyingAnimation(DamageType,KFXHitWeaponID, HitLoc);

		KFXDestroyShadow();
	}
}

// Server & Client
// TODO: Make it Clear
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	if ( RagdollEnabled )
		_PlayDying_Ragdoll(DamageType, HitLoc);
	else
		_PlayDying_Normal(DamageType, HitLoc);
}
simulated function _PlayDying_Normal(class<DamageType> DamageType, vector HitLoc)
{
//    bTearOff = true;
//    bPlayedDeath = true;
	if(Level.NetMode == NM_DedicatedServer)
	{
		KFXHitWeaponID = KFXDmgInfo.WeaponID;
	}
	log("KFXPawnBase------KFXHitWeaponID "$KFXHitWeaponID);
	HitDamageType = DamageType; // these are replicated to other clients
	TakeHitLocation = HitLoc;

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø ¼æÈÝKFXBot
	//if(Level.NetMode == NM_DedicatedServer && !PlayerController(Controller).bBehindView)
	if(Level.NetMode == NM_DedicatedServer && PlayerController(Controller) != none && !PlayerController(Controller).bBehindView)
	//>>
	{
		PlayerController(Controller).ServerToggleBehindView();
	}

	if ( DamageType != None )
	{
		if ( DamageType.Default.DeathOverlayMaterial != None )
			SetOverlayMaterial(DamageType.Default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
		else if ( (DamageType.Default.DamageOverlayMaterial != None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
			SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 2*DamageType.default.DamageOverlayTime, true);
	}

	super.PlayDying(DamageType, HitLoc);
	StopAnimating(true);
	self.AvatarLegs.StopAnimating(true);
	if(Level.NetMode != NM_DedicatedServer)
	{
		KFXPlayDyingAnimation(DamageType,KFXHitWeaponID, HitLoc);

		KFXDestroyShadow();
	}
}
simulated function _PlayDying_Ragdoll(class<DamageType> DamageType, vector HitLoc)
{
	local vector shotDir, hitLocRel, deathAngVel, shotStrength;
	local float maxDim;
	local string RagSkelName;
	local KarmaParamsSkel skelParams;

	AmbientSound = None;
	bCanTeleport = false;
	bReplicateMovement = false;
	bTearOff = true;
	bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
	TakeHitLocation = HitLoc;

	// stop shooting
	AnimBlendParams(1, 0.0);

	GotoState('Dying');

	super.PlayDying(DamageType, HitLoc);
	if ( Level.NetMode != NM_DedicatedServer )
	{
		// In low physics detail, if we were not just controlling this pawn,
		// and it has not been rendered in 3 seconds, just destroy it.
		if(Level.PhysicsDetailLevel == PDL_Low && (Level.TimeSeconds - LastRenderTime > 3) )
		{
			Destroy();
			return;
		}

		// Try and obtain a rag-doll setup.
	  //  if(bPigKilled)
	   //{
	  //      RagSkelName = PigRagdoll;
	  // }
	  // else
	  if( RagdollOverride != "")
	   {
			RagSkelName = RagdollOverride;
	   }
	   else
			Log("UnrealPawn.PlayDying: No RagdollOverride");

		// if we managed to find a name, try and make a rag-doll slot availbale.
		if( RagSkelName != "" )
		{
			KMakeRagdollAvailable();
		}

		if( KIsRagdollAvailable() && RagSkelName != "" )
		{
			skelParams = KarmaParamsSkel(KParams);
			skelParams.KSkeleton = RagSkelName;
			//KParams = skelParams;

			//Log("RAGDOLL");

			// Stop animation playing.
			StopAnimating(true);

			// DEBUG
			//TearOffMomentum = vect(0, 0, 0);
			//if(VSize(TearOffMomentum) < 0.01)
			//  Log("TearOffMomentum magnitude of Zero");
			// END DEBUG

			if(DamageType != None && DamageType.default.bKUseOwnDeathVel)
			{
				RagDeathVel = DamageType.default.KDeathVel;
				RagDeathUpKick = DamageType.default.KDeathUpKick;
			}

			// Set the dude moving in direction he was shot in general
			shotDir = Normal(TearOffMomentum);
			shotStrength = RagDeathVel * shotDir;

			// Calculate angular velocity to impart, based on shot location.
			hitLocRel = TakeHitLocation - Location;

			// We scale the hit location out sideways a bit, to get more spin around Z.
			hitLocRel.X *= RagSpinScale;
			hitLocRel.Y *= RagSpinScale;

			// If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
			if( VSize(TearOffMomentum) < 0.01 )
			{
				//Log("TearOffMomentum magnitude of Zero");
				deathAngVel = VRand() * 18000.0;
			}
			else
			{
				deathAngVel = RagInvInertia * (hitLocRel Cross shotStrength);
			}

			// Set initial angular and linear velocity for ragdoll.
			// Scale horizontal velocity for characters - they run really fast!
			skelParams.KStartLinVel.X = 0.6 * Velocity.X;
			skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
			skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
			skelParams.KStartLinVel += shotStrength;

			// if not moving downwards - give extra upward kick
			if(Velocity.Z > -10)
				skelParams.KStartLinVel.Z += RagDeathUpKick;

			skelParams.KStartAngVel = deathAngVel;

			// Set up deferred shot-bone impulse
			maxDim = Max(CollisionRadius, CollisionHeight);

			skelParams.KShotStart = TakeHitLocation - (1 * shotDir);
			skelParams.KShotEnd = TakeHitLocation + (2*maxDim*shotDir);
			skelParams.KShotStrength = RagShootStrength;

			// Turn on Karma collision for ragdoll.
			KSetBlockKarma(true);

			// Set physics mode to ragdoll.
			// This doesn't actaully start it straight away, it's deferred to the first tick.
			SetPhysics(PHYS_KarmaRagdoll);

			PlaySound(DeadSound, SLOT_Pain,
				HitSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
				HitSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
			log("KFXPawnBase-------DeadSound "$DeadSound);
			return;
		}

		// jag
		KFXPlayDyingAnimation(DamageType,KFXHitWeaponID, HitLoc);
	}
}

// Client Only
simulated function ChangedWeapon()
{
	if ( !bCanUseWeapon )
		return;

	if ( Weapon != none )
	{
		KFXWeapBase(Weapon).KFXClearStates();
		//±ÜÃâÆðÌøÇÐÇ¹Ôì³ÉÂäµØÊ±bcanfire²»ÄÜ»Ö¸´
		if(PendingWeapon!=none && KFXWeapBase(PendingWeapon).KFXGetCanJumpFire()&&!self.bCanFire)
		{
			self.bCanFire = true;
		}
	}
	super.ChangedWeapon();
}

// Server Only
function ServerChangedWeapon(Weapon OldWeapon, Weapon NewWeapon)
{
	if ( !bCanUseWeapon )
		return;

	//< From Pawn
	SetWeapon(NewWeapon);

	if ( Controller != None )
		Controller.ChangedWeapon();

	PendingWeapon = None;
	log("KFXPawnBase------OldWeapon "$OldWeapon);
	if ( OldWeapon != None )
	{


		OldWeapon.SetDefaultDisplayProperties();
		OldWeapon.DetachFromPawn(self);
		OldWeapon.GotoState('Hidden');
		OldWeapon.NetUpdateFrequency = 2;
		//Í³¼Æ¸ÃÎäÆ÷Ê±¼ä
		if(Controller != none)
		{
			KFXPlayer(Controller).StatsWeaponUsedInfo(KFXWeapBase(OldWeapon).KFXGetWeaponID());
		}
		//»»Ç¹Ê±£¬Í£Ö¹×°×Óµ¯¡£
		KFXWeapBase(OldWeapon).KFXStopReload();
		// Kevin Sun: Hack to Destroy the Weapon
		if ( KFXWeapBase(OldWeapon).KFXNeedDestroy() )
			OldWeapon.Destroy();
	}
	if(NewWeapon != none)
	{
		if(Controller != none && KFXWeapBase(NewWeapon).KFXGetWeaponID() != 1)
		{
			KFXPlayer(Controller).AddWeaponUsedInfo(KFXWeapBase(NewWeapon).KFXGetWeaponID());
		}

	}
	if ( Weapon != None )
	{
		Weapon.NetUpdateFrequency = 100;
		Weapon.AttachToPawn(self);
		Weapon.BringUp(OldWeapon);
		PlayWeaponSwitch(NewWeapon);

	}

	if ( Inventory != None )
		Inventory.OwnerEvent('ChangedWeapon'); // tell inventory that weapon changed (in case any effect was being applied)
	//> from Pawn
}

// Change Weapon Logic
simulated function bool CanSwitchWeapon()
{
	if ( !bCanUseWeapon )
		return false;

	if ( Weapon == none || KFXWeapBase(Weapon) == none )
		return true;

	return KFXWeapBase(Weapon).KFXHackCanSwitchWeapon();
}
simulated function SwitchWeapon(byte F)
{
	local weapon newWeapon;
	if ( CanSwitchWeapon() )
	{
		if ( (Level.Pauser!=None) || (Inventory == None) )
			return;
		if ( (Weapon != None) && (Weapon.Inventory != None) )
			newWeapon = Weapon.Inventory.WeaponChange(F, false);
		else
			newWeapon = None;
		if ( newWeapon!=none&&KFXWeapBase(newWeapon).KFXGetWeaponID()==2&&
			 KFXWeapBase(Weapon).KFXGetWeaponID()!=2&&F==3)
		{
			newWeapon = None;
		}
		if ( newWeapon == None )
			newWeapon = Inventory.WeaponChange(F, true);
		if ( newWeapon == None )
		{
			if ( F == 10 )
				ServerNoTranslocator();

			return;
		}
		log("[PawnBase] SwitchWeapon "$PendingWeapon$"Weapon:"$Weapon$"newWeapon"$newWeapon);
		if ( PendingWeapon != None && PendingWeapon.bForceSwitch )
		{
			PendingWeapon = none;
			return;
		}
		if ( Weapon == None )
		{
			PendingWeapon = newWeapon;
			ChangedWeapon();
		}
		else if ( Weapon != newWeapon || PendingWeapon != None )
		{
			PendingWeapon = newWeapon;
			if((KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) >= 51 && (KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) <= 60)
				//&& ((KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) >= 61 || (KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) <= 50))
			{
//                bQuickChangeToss = true;
//                ServerSetQuickChangeToss(true);
//                log("KFXpawnBase------bQuickChangeToss "$bQuickChangeToss);
			}
			Weapon.PutDown();
		}
		else if ( Weapon == newWeapon )
			Weapon.Reselect(); // sjs
	}
}
simulated function  ServerSetQuickChangeToss(bool bChangeToss)
{
//    bQuickChangeToss = bChangeToss;
//    log("KFXPawnBase-------bQuickChangeToss "$bQuickChangeToss);
}
simulated function PrevWeapon()
{
	if ( CanSwitchWeapon() )
		super.PrevWeapon();
}
simulated function NextWeapon()
{
	if ( CanSwitchWeapon() )
		super.NextWeapon();
}
simulated function CheckJustRestartSwitchWeapon()
{
	local bool bHasMajorWeapon,bHasMinorWeapon,bHasMeleeWeapon,bHasTossWeapon;
	local Weapon MinorWeapon,MeleeWeapon,TossWeapon;
	local Inventory Inv;

	bHasMajorWeapon = false;
	bHasMinorWeapon = false;
	bHasMeleeWeapon = false;
	bHasTossWeapon  = false;

	for(Inv = Inventory; Inv != none; Inv = Inv.Inventory)
	{
		if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=1 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=30)
		{
			 bHasMajorWeapon = true;
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=31 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=40)
		{
			 bHasMinorWeapon = true;
			 MinorWeapon = KFXWeapBase(Inv);
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=41 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=50)
		{
			 bHasMeleeWeapon = true;
			 MeleeWeapon = KFXWeapBase(Inv);
		}
		else if(KFXWeapBase(Inv).KFXGetWeaponID() >> 16 >=51 && KFXWeapBase(Inv).KFXGetWeaponID() >> 16 <=60)
		{
			 bHasTossWeapon  = true;
			 TossWeapon =KFXWeapBase(Inv);
			 break;
		}
	}

	KFXPlayer(Controller).bHasJustRestarted = false;
	if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=1 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=30)
	{
		if(bHasMinorWeapon)
		{
			Weapon.OldWeapon = MinorWeapon;
		}
	}
	else if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=41 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=50)
	{
		 if(!bHasMajorWeapon && !bHasMinorWeapon)
		 {
			if(bHasTossWeapon)
			{
				Weapon.OldWeapon = TossWeapon  ;
			}
		 }
	}
	else if(KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 >=51 && KFXWeapBase(Weapon).KFXGetWeaponID() >> 16 <=60)
	{
		 if(!bHasMajorWeapon && !bHasMinorWeapon)      //³öÉúÊ±£¬Ã»ÓÐÖ÷ÎäÆ÷ºÍ¸±ÎäÆ÷£¬Ö»ÓÐµ¶ºÍÀ×µÄÊ±ºòÒªÀ´»ØÇÐ
		 {
			 if(bHasMeleeWeapon)
			{
				Weapon.OldWeapon = MeleeWeapon;
			}
		 }
	}

	if ( Weapon.OldWeapon != None )
	{
		if ( KFXWeapBase(Weapon.OldWeapon).KFXHackCanSwitchTo() )
		{
			PendingWeapon = Weapon.OldWeapon;
			Weapon.PutDown();
		}
	}
	else
	{
		switchweapon(3);
	}
}
exec function SwitchToLastWeapon()
{
	if ( CanSwitchWeapon() )
	{
		if(KFXPlayer(Controller).bHasJustRestarted)
		{
			CheckJustRestartSwitchWeapon();
		}
		else
		{
			if ( Weapon.OldWeapon != None )
			{
				if ( KFXWeapBase(Weapon.OldWeapon).KFXHackCanSwitchTo() )
				{
					PendingWeapon = Weapon.OldWeapon;
					if((KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) >= 51 && (KFXWeapBase(Weapon).KFXGetWeaponID() >> 16) <= 60)
					//&& ((KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) >= 61 || (KFXWeapBase(PendingWeapon).KFXGetWeaponID() >> 16) <= 50))
					{
//                        bQuickChangeToss = true;
//                        ServerSetQuickChangeToss(true);
//                        log("KFXpawnBase------bQuickChangeToss "$bQuickChangeToss);
					}
					Weapon.PutDown();
				}
			}
			else
			{
				switchweapon(3);
			}
		}
	}
}
simulated function name GetWeaponBoneFor(Inventory I)
{
	return WeaponBone;
}
// Destroyed
simulated function Destroyed()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		KFXDestroyShadow();

		if ( AvatarHead != none )
			AvatarHead.Destroy();
		if ( AvatarLegs != none )
			AvatarLegs.Destroy();
	}

	super.Destroyed();
}
// Damages
function gibbedBy(actor Other)
{
	// ¿Í»§¶Ë¼ÆËãÒÆ¶¯Ôò²»µ÷ÓÃgibbed
	if ( PlayerController(Controller) != none
		&& PlayerController(Controller).ClientCalculateMove )
		return;

	//<<ÀîÍþ¹ú »úÆ÷ÈËÏà¹Ø Èç¹ûÊÇ»úÆ÷ÈËÒ²²»ÐèÒªµ÷ÓÃgibbedBy()
	if( KFXBot(Controller) != none )
		return;
	//>>

	super.gibbedBy(Other);
}
// Camera or Draw Compute
/* EyePosition()
Called by PlayerController to determine camera position in first person view.  Returns
the offset from the Pawn's location at which to place the camera
*/
simulated function vector EyePosition()
{
	if ( KFXWeapBase(Weapon) != none )
	{
		return KFXWeapBase(Weapon).KFXHackEyePosition( EyeHeight * vect(0,0,1) + WalkBob + CameraOffset >> Rotation );
	}

	return EyeHeight * vect(0,0,1) + WalkBob;
}
// Compute offset for drawing an inventory item.
simulated function vector CalcDrawOffset(inventory Inv)
{
	local vector DrawOffset;
	local rotator WeaponShakeRot;

	if ( Controller == None )
		return (Inv.PlayerViewOffset >> Rotation) + BaseEyeHeight * vect(0,0,1);

	if ( Weapon != none )
	{
		WeaponShakeRot = KFXWeapBase(Weapon).KFXWeaponShakeView();
	}

	DrawOffset = ((0.9/Weapon.DisplayFOV * 100 * ModifiedPlayerViewOffset(Inv)) >> (GetViewRotation() + WeaponShakeRot) );


	if ( !IsLocallyControlled() )
		DrawOffset.Z += BaseEyeHeight;
	else
	{
		// Kevin Sun: Hack for Correct the 1st View Weapon Position
		DrawOffset += EyePosition() - WalkBob;
		if( bWeaponBob )
			DrawOffset += WeaponBob(Inv.BobDamping);
		 DrawOffset += CameraShake();
	}

	if(Physics==PHYS_Falling&&!KFXWeapBase(weapon).KFXGetCanJumpFire()&&self.KFXLevelAllowHideWeap)
	{
		if(WeapJumpFactor*TickIndex<5)
		{
			TickIndex++;
			DrawOffset-=5*WeapJumpFactor*TickIndex*vector(self.Controller.Rotation);
		}
		else
		{
			DrawOffset-=5*WeapJumpFactor*TickIndex*vector(self.Controller.Rotation);
		}

		return DrawOffset;
	}
	return DrawOffset;
}
// ¼ÓÈëÎäÆ÷¶ÔÊÓ½ÇµÄÏÞÖÆ
function bool KFXHackRotation(rotator OldRot, rotator NewRot, out rotator HackRot)
{
	if ( KFXWeapBase(Weapon) != none )
	{
		return KFXWeapBase(Weapon).KFXWeapHackRotation(OldRot, NewRot, HackRot);
	}
	return false;
}
// Hack LimitPitch
function int LimitPitch(int pitch)
{
	if ( KFXWeapBase(Weapon) != none
		&& KFXWeapBase(Weapon).KFXHackPitchLimit(pitch) )
	{
		return pitch;
	}
	return super.LimitPitch(pitch);
}
//overide to support CrouchBaseEyeHeight configable
simulated function SetBaseEyeheight()
{
	if ( !bIsCrouched )
		BaseEyeheight = Default.BaseEyeheight;
	else
		BaseEyeheight = CrouchBaseEyeHeight;

	Eyeheight = BaseEyeheight;
}
//overide to support CrouchBaseEyeHeight configable
simulated event StartCrouch(float HeightAdjust)
{
	EyeHeight += HeightAdjust;
	OldZ -= HeightAdjust;
	BaseEyeHeight = CrouchBaseEyeHeight;
	;

	// switch Hitbox Group : Crouch
	SwitchHitBoxGroup(1);
	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(Sound(DynamicLoadObject("fx_step_sounds.general_squat", class'Sound')),SLOT_None,
		1.0*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),false);
}
simulated event EndCrouch(float HeightAdjust)
{
	super.EndCrouch(HeightAdjust);
	;
	// switch Hitbox Group : Stand
	SwitchHitBoxGroup(0);
}
//Landed Ö»ÔÚ¿Í»§¶ËÓÐµ÷ÓÃ
simulated function ServerLanded( int SurfaceNum )
{
    PlayOwnedSound(StepSounds[SurfaceNum].JumpSound, SLOT_Interact, GetExSoundFactor(KFXFPSoundScale), true, FootstepRadius,,false);
}

event function Landed(vector HitNormal)
{
	local material FloorMat;
	local int SurfaceNum;
	local vector HL,HN,Start,End;
	local actor A;

	SurfaceNum = 0;

	super.Landed(HitNormal);

	if ( (Base!=None) && (!Base.IsA('LevelInfo')) && (Base.SurfaceType!=0) )
	{
		SurfaceNum = Base.SurfaceType;
	}
	else
	{
		Start = Location - Vect(0,0,1)*CollisionHeight;
		End = Start - Vect(0,0,32);

		A = Trace(hl,hn,End,Start,false,,FloorMat);
		if (FloorMat !=None)
			SurfaceNum = FloorMat.SurfaceType;
	}

	if(IsLocallyControlled())
	{
		ServerTakeFallingDamage(Velocity);
	}
    ServerLanded(SurfaceNum);
	if(Abs(Velocity.Z) < MaxFallSpeed)
	{
		PlaySound(StepSounds[SurfaceNum].JumpSound, SLOT_Interact, 0.3*FootstepVolume /* GetExSoundFactor(KFXFPSoundScale) * FootstepRate*/, true, FootstepRadius,,false);
	}else
	{
		if(int(((Abs(Velocity.Z) - MaxFallSpeed) / MaxFallSpeed) * 100) > 0)
		{
			PlaySound(SoundFallPains, SLOT_Pain, HitSoundVolume*0.3,,HitSoundRadius,,false);
		}
		else
		{
			PlaySound(StepSounds[SurfaceNum].JumpSound, SLOT_Interact, 0.3*FootstepVolume * GetExSoundFactor(KFXFPSoundScale) * FootstepRate, true, FootstepRadius+10,,false);
		}
	}

	if(FloorMat !=None && FloorMat.SurfaceType == EST_Water)
	{
		Spawn(StepWaterEffectClass, self,,hl);
	}

	MultiJumpRemaining = MaxMultiJump;

	Acceleration = vect(0, 0, 0);
	Velocity     = Velocity / 2 * LandedSpeedDownScale;
	log("KFXPawnBase-----LandedSpeedDownScale "$LandedSpeedDownScale);
	if( Role < ROLE_Authority && !bIsCrouched && BaseEyeHeight != default.BaseEyeHeight )
	{
		;
		BaseEyeHeight = default.BaseEyeHeight;
		EyeHeight = default.BaseEyeHeight;
	}

	NotifyWeapLanded();

}

event FellOutOfWorld(eKillZType KillType)
{
	if ( Health > 0 && KillType == KILLZ_None )
	{
		log("=============before destroy");
		level.GetLocalPlayerController().ClientOpenMenu("KFXGUI.KFXKickIdlePage");
	}

	if ( Level.NetMode == NM_Client )
		return;

	if ( (Controller != None) && Controller.AvoidCertainDeath() )
		return;

	Health = -1;

	if( KillType == KILLZ_Lava)
		Died( None, class'FellLava', Location );
	else if(KillType == KILLZ_Suicide)
		Died( None, class'Fell', Location );
	else
	{
		if ( Physics != PHYS_Karma )
			SetPhysics(PHYS_None);
		Died( None, class'Fell', Location );
	}
}

function ServerTakeFallingDamage(vector FallingVelocity)
{
	local float Shake, EffectiveSpeed;
	local float damage;
	if (FallingVelocity.Z < -0.5 * MaxFallSpeed)
	{
		if ( Role == ROLE_Authority )
		{
			MakeNoise(1.0);
			if (FallingVelocity.Z < -1 * MaxFallSpeed)
			{
				EffectiveSpeed = FallingVelocity.Z;
				if ( TouchingWaterVolume() )
					EffectiveSpeed = FMin(0, EffectiveSpeed + 100);
				if ( EffectiveSpeed < -1 * MaxFallSpeed )
				{
					//±ÜÃâÔÚÏÂÂäÖ»µôÐ¡ÓÚ1µÄÉúÃüÊ±£¬³öÏÖµÄÉúÃüÖµ²»±äµÄÎÊÌâ
					damage = -100 * (EffectiveSpeed + MaxFallSpeed)/MaxFallSpeed;
					if(damage>0&&damage<1)
					damage = 1;

					TakeDamage(damage, None, Location, vect(0,0,0), class'Fell');
				}
			}
		}
		if ( Controller != None )
		{
			Shake = FMin(1, -1 * FallingVelocity.Z/MaxFallSpeed);
			Controller.DamageShake(Shake);
		}
	}
	else if (FallingVelocity.Z < -1.4 * JumpZ)
		MakeNoise(0.5);
}

function KFXServerModifyVelocity();

simulated event ModifyVelocity(float DeltaTime, vector OldVelocity);

/*
Pawn was killed - detach any controller, and die
*/
simulated function ChunkUp( Rotator HitRotation, float ChunkPerterbation )
{
	if ( (Level.NetMode != NM_Client) && (Controller != None) )
	{
		if ( Controller.bIsPlayer )
			Controller.PawnDied(self);
		else
			Controller.Destroy();
	}

	bTearOff = true;
	HitDamageType = class'Gibbed'; // make sure clients gib also
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
		GotoState('TimingOut');
	if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( class'GameInfo'.static.UseLowGore() )
	{
		Destroy();
		return;
	}

	if ( Level.NetMode != NM_ListenServer )
		Destroy();
}
//Client Simulated Fire Client Only
simulated function ClientSetMovementPhysics()
{
	if (Physics == PHYS_Falling)
		return;
	if ( PhysicsVolume.bWaterVolume )
		SetPhysics(PHYS_Swimming);
	else
		SetPhysics(PHYS_Walking);
}
function SetMovementPhysics()
{
	if (Physics == PHYS_Falling)
		return;
	if ( PhysicsVolume.bWaterVolume )
		SetPhysics(PHYS_Swimming);
	else
		SetPhysics(PHYS_Walking);
}

function CreateInventory(string InventoryClassName)
{
	local Inventory Inv;
	local class<Inventory> InventoryClass;

	InventoryClass = Level.Game.BaseMutator.GetInventoryClass(InventoryClassName);
	if( (InventoryClass!=None) && (FindInventoryType(InventoryClass)==None) )
	{
		Inv = Spawn(InventoryClass);
		if( Inv != None )
		{
			Inv.GiveTo(self);
			if ( Inv != None )
				Inv.PickupFunction(self);
		}
	}
}

// Weapon Bob
simulated function vector WeaponBob(float BobDamping)
{
	Local Vector WBob;

	/*
	WBob = BobDamping * WalkBob;
	WBob.Z = (0.45 + 0.55 * BobDamping)  * WalkBob.Z;
	WBob.Z += LandBob;
	*/
	return WBob;
}

//TO BE CLEANED
function CheckBob(float DeltaTime, vector Y)
{
	local float OldBobTime;
	local float Speed2D;

	// Pawn
	if( !bWeaponBob /*|| bJustLanded */)
	{
		WalkBob = Vect(0,0,0);
		return;
	}
	Bob = FClamp(Bob, -0.01, 0.01);
	if (Physics == PHYS_Walking )
	{
		Speed2D = VSize(Velocity);
		if ( Speed2D < 10 )
		{
			BobTime += 0.2 * DeltaTime;
		}
		else
		{
			BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
		}
		WalkBob = Y * Bob * Speed2D * sin(BobTime * BobTimeFactor) * 0.15; // 8, 1

		/* È¡ÏûÉÏÏÂ»Î¶¯
		AppliedBob = AppliedBob * (1 - FMin(1, 16 * deltatime));
		WalkBob.Z = AppliedBob;
		if ( Speed2D > 10 )
			WalkBob.Z = WalkBob.Z + 0.75 * Bob * Speed2D * sin(12 * BobTime) * 0.4; // 16, 1;
			*/
	}
	else if ( Physics == PHYS_Swimming )
	{
		BobTime += DeltaTime;
		Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
		WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * BobTime);
		WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * BobTime);
	}
	else
	{
		BobTime = 0;
		WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
	}

	// KFXPawn
	if ( (Physics != PHYS_Walking) || (VSize(Velocity) < 10)
		|| ((PlayerController(Controller) != None) && PlayerController(Controller).bBehindView) )
		return;


//    m = int(0.5 * Pi + 9.0 * OldBobTime/Pi);
//    n = int(0.5 * Pi + 9.0 * BobTime/Pi);

	OldBobTime = BobTime;
}

simulated function NotifyTeamChanged()
{
	// my PRI now has a new team
	PostNetReceive();
}

simulated function ResetPhysicsBasedAnim()
{
	bIsIdle = false;
	bWaitForAnim = false;
}
simulated function float GetExSoundFactor(float NormalSoundScale)
{
	return  NormalSoundScale;
}
simulated function float GetExSoundRadius(float NormalSoundRadius)
{
	return NormalSoundRadius;
}
simulated function FootStepping(int Side)
{
	local int SurfaceNum;
	local actor A;
	local material FloorMat;
	local vector HL,HN,Start,End;
	local vector planVelocity;
	local int StepSoundIndex;
	local float planSpeed;
	local bool EnableLadderSound;
	local float StepRate;
	if ( bIsCrouched || bIsWalking )
		return;


	planVelocity = Velocity;
	planVelocity.Z = 0;
	planSpeed = VSize(planVelocity);

	SurfaceNum = 0;
	EnableLadderSound = false;

	if ( Physics == PHYS_Ladder )
	{
		EnableLadderSound = Physics == PHYS_Ladder && VSize(Velocity)>DefLadderSpeed* WalkingPct;
		StepRate = fPlayStepSoundRate * DefGroundSpeed / DefLadderSpeed;
		SurfaceNum = 5;
	}
	else
	{
		StepRate = fPlayStepSoundRate * DefGroundSpeed / planSpeed;
	}

	if ( ( Level.TimeSeconds - LastFootStepTime ) < StepRate )
	{
		return;
	}


	if ( (Base!=None) && (!Base.IsA('LevelInfo')) && (Base.SurfaceType!=0) )
	{
		SurfaceNum = Base.SurfaceType;
	}
	else
	{
		Start = Location - Vect(0,0,1)*CollisionHeight;
		End = Start - Vect(0,0,32);
		A = Trace(hl,hn,End,Start,false,,FloorMat);
		if (FloorMat !=None)
			SurfaceNum = FloorMat.SurfaceType;
	}

	if ( ((Physics == PHYS_Walking && planSpeed > DefGroundSpeed * WalkingPct)|| EnableLadderSound) )
	{
		LastFootStepTime = Level.TimeSeconds;

		// ²¥·ÅÓëÉÏÒ»´Î²»Ò»ÑùµÄÉùÒô
		StepSoundIndex =  Rand(ArrayCount(StepSounds[SurfaceNum].RunSound));

		while(StepSoundIndex == LastStepSoundIndex)
		{
			StepSoundIndex = Rand(ArrayCount(StepSounds[SurfaceNum].RunSound));
		}

		LastStepSoundIndex = StepSoundIndex;

        if(Controller == none)
        {
            if(Level.GetLocalPlayerController().pawn != none)
            {
                if( VSize(Location - Level.GetLocalPlayerController().pawn.Location) < KFXPawn(Level.GetLocalPlayerController().pawn).GetExSoundRadius(3500) )
                {
                    PlaySound(StepSounds[SurfaceNum].RunSound[StepSoundIndex], SLOT_Interact,
                    0.7*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0)/*FootstepVolume * GetExSoundFactor(KFXFPSoundScale)*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0)*/,,
                    FootstepRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
                }
            }
            else if(Level.GetLocalPlayerController().viewtarget != none)
            {
                if( VSize(Location - Level.GetLocalPlayerController().viewtarget.Location) < KFXPawn(Level.GetLocalPlayerController().viewtarget).GetExSoundRadius(3500) )
                {
                    PlaySound(StepSounds[SurfaceNum].RunSound[StepSoundIndex], SLOT_Interact,
                    0.7*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0)/*FootstepVolume * GetExSoundFactor(KFXFPSoundScale)*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0)*/,,
                    FootstepRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
                }
            }
        }
        else
        {
        PlaySound(StepSounds[SurfaceNum].RunSound[StepSoundIndex], SLOT_Interact,
            0.3*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0)/*FootstepVolume * GetExSoundFactor(KFXFPSoundScale)*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0)*FootstepRate*/,,
            FootstepRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));
        }

	}

	if(FloorMat !=None && FloorMat.SurfaceType == EST_Water && VSize(planVelocity) > 100 &&(Level.TimeSeconds - lastShowStepEffectTime > fShowStepEffectRate))
	{
		lastShowStepEffectTime = Level.TimeSeconds;

		Spawn(StepWaterEffectClass, self,,hl);
	}
}

simulated function PlayFootStepLeft()
{
	PlayFootStep(-1);
}

simulated function PlayFootStepRight()
{
	PlayFootStep(1);
}

simulated function PlayFootStep(int Side)
{
//    if ( (Role==ROLE_SimulatedProxy) || (PlayerController(Controller) == None) || PlayerController(Controller).bBehindView )
//    {
		FootStepping(Side);
		return;
//    }
}

simulated function SetWeapAttachment(KFXWeapAttachment NewAtt)
{
	local KFXPlayer localPlayer;

	localPlayer = KFXPlayer(level.GetLocalPlayerController());
	if(localPlayer.IsInState('spectating') && !localPlayer.bBehindView &&
		 localPlayer.ViewTarget == self)
	{
		localPlayer.SpectateHook.ClientChangeWeapon(NewAtt);
	}

	WeaponAttachment = NewAtt;
	log("[KFXPawnBase]   SetWeapAttachment");
	bWaitForAnim = false;
	KFXChangeAniGroup(WeaponAttachment.KFXGetAnimIndex());
	KFXCurAniState = WeaponAttachment.KFXGetAnimIndex();

//    if ( Level.NetMode == NM_Client )
//        AttachToBone(WeaponAttachment, WeaponBone);
}

simulated function name GetAttachBone();

/* DisplayDebug()
list important actor variable on canvas.  Also show the pawn's controller and weapon info
*/
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string T;
	local float XL;

//    if ( !bSoakDebug )
//    {
//        Super.DisplayDebug(Canvas, YL, YPos);
//        return;
//    }

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.StrLen("TEST", XL, YL);
	YPos = YPos + 8*YL;
	Canvas.SetPos(4,YPos);
	Canvas.SetDrawColor(255,255,0);
	T = GetDebugName();
	if ( bDeleteMe )
		T = T$" DELETED (bDeleteMe == true)";
	Canvas.DrawText(T, false);
	YPos += 3 * YL;
	Canvas.SetPos(4,YPos);

	if ( Controller == None )
	{
		Canvas.SetDrawColor(255,0,0);
		Canvas.DrawText("NO CONTROLLER");
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}
	else
		Controller.DisplayDebug(Canvas,YL,YPos);

	YPos += 2*YL;
	Canvas.SetPos(4,YPos);
	Canvas.SetDrawColor(0,255,255);
	Canvas.DrawText("Anchor "$Anchor$" Serpentine Dist "$SerpentineDist$" Time "$SerpentineTime);
	YPos += YL;
	Canvas.SetPos(4,YPos);

	T = "Floor "$Floor$" DesiredSpeed "$DesiredSpeed$" Crouched "$bIsCrouched$" Try to uncrouch "$UncrouchTime;
	if ( (OnLadder != None) || (Physics == PHYS_Ladder) )
		T=T$" on ladder "$OnLadder;
	Canvas.DrawText(T);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("kfxdebug: ",true);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("defaultX: ", true);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("JumpZ "$default.JumpZ$" WalkingPct "$default.WalkingPct$" BaseEyeHeight "$default.BaseEyeHeight$" CrouchedPct "$default.CrouchedPct$" CrouchHeight "$default.CrouchHeight$" CrouchRadius "$default.CrouchRadius, true);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("currentX: ", true);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText(" CrouchHeight "$CrouchHeight$" CrouchRadius "$CrouchRadius, true);
	YPos += YL;
	Canvas.SetPos(4,YPos);
}

function String GetDebugName()
{
	if ( PlayerReplicationInfo != None )
		return PlayerReplicationInfo.PlayerName;
	return GetItemName(string(self));
}

///////////////////////////////////////////////////////////////////////////////////
state Dying
{

ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;  //AnimEnd,

	function Landed(vector HitNormal)
	{
		if ( Level.NetMode == NM_DedicatedServer )
			return;
		if ( Shadow != None )
			Shadow.Destroy();

		KFXDestroyShadow();
	}

	simulated function BeginState()
	{
		local int i;
		local Emitter Emt;
		if(Level.NetMode!=NM_DedicatedServer)
		{
			foreach BasedActors(class'Emitter', Emt)
			{
				Emt.Destroy();
			}
		}

		SetCollision(false,false,false);
		if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
			LifeSpan = AshesKeepingTime;
		else
		{
			ClientAshesKeepingTime = GetAshesKeepingTime();
			log("KFXPawnBase-----ClientAshesKeepingTime "$ClientAshesKeepingTime);
			SetTimer(ClientAshesKeepingTime, false);
		}

		if ( !RagdollEnabled )
			SetPhysics(PHYS_Walking);

		bInvulnerableBody = true;
		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
				Controller.PawnDied(self);
			else
				Controller.Destroy();
		}

		for (i = 0; i < Attached.length; i++)
			if (Attached[i] != None)
				Attached[i].PawnBaseDied();
		if ( !RagdollEnabled )
			SetPhysics(PHYS_Falling);

		AmbientSound = None;
	}

	function LandThump()
	{
		// animation notify - play sound if actually landed, and animation also shows it
		if ( Physics == PHYS_None)
		{
			bThumped = true;
			//PlaySound(GetSound(EST_CorpseLanded));
		}
	}

	simulated function TakeDamage( float Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
	{
		//local Vector SelfToHit, SelfToInstigator, CrossPlaneNormal;
		//local float W;
		//local float YawDir;

		//local vector HitNormal;
		//local name HitBone;
		//local float HitBoneDist;
		//local int MaxCorpseYawRate;

		KFXDmgRepInfo.InstigatedBy  = instigatedBy;
		if ( damageType.default.bDelayedDamage )
			KFXDmgRepInfo.HitLocation = Location;
		else
			KFXDmgRepInfo.HitLocation = Hitlocation;
		KFXDmgRepInfo.Momentum      = momentum;
		KFXDmgRepInfo.DmgShakeView  = KFXDmgInfo.DmgShakeView;
		KFXDmgRepInfo.FlashCount++;

		/*
		if (Damage > 0)
		{
			if ( InstigatedBy != None )
			{
				// Figure out which direction to spin:

				if( InstigatedBy.Location != Location )
				{
					SelfToInstigator = InstigatedBy.Location - Location;
					SelfToHit = HitLocation - Location;

					CrossPlaneNormal = Normal( SelfToInstigator cross Vect(0,0,1) );
					W = CrossPlaneNormal dot Location;

					if( HitLocation dot CrossPlaneNormal < W )
						YawDir = -1.0;
					else
						YawDir = 1.0;
				}
			}
			if( VSize(Momentum) < 10 )
			{
				Momentum = - Normal(SelfToInstigator) * Damage * 1000.0;
				Momentum.Z = Abs( Momentum.Z );
			}

			if ( !RagdollEnabled )
				SetPhysics(PHYS_Falling);

			Momentum = Momentum / Mass;
			AddVelocity( Momentum );
			bBounce = true;

			RotationRate.Pitch = 0;
			RotationRate.Yaw += VSize(Momentum) * YawDir;

			MaxCorpseYawRate = 150000;
			RotationRate.Yaw = Clamp( RotationRate.Yaw, -MaxCorpseYawRate, MaxCorpseYawRate );
			RotationRate.Roll = 0;

			bFixedRotationDir = true;
			bRotateToDesired = false;

			Health -= Damage;
			//CalcHitLoc( HitLocation, vect(0,0,0), HitBone, HitBoneDist );

			if( InstigatedBy != none )
				HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
			else
				HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );

			;//DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );
		}
		*/
	}

	simulated function Timer()
	{
		Destroy();
	}

	// Client Only
	// Take HitµÄÐ§¹û
	simulated function KFXClientPlayTakeHit()
	{
		if( AshesHitEnable == 1 )
		{
			KFXClientPlayTakeHitEffects();

			if(Physics == PHYS_KarmaRagdoll)
				KAddImpulse(KFXSavedDmgRepInfo.Momentum, KFXSavedDmgRepInfo.HitLocation);
		}
	}
}
function float GetAshesKeepingTime()
{
	log("KFXPlayer-----ClientAshesKeepingTime "$ClientAshesKeepingTime);
	return ClientAshesKeepingTime;
}
//client only
simulated function KFXLevelAllowWeapHide()
{

	local int SurfaceNum;
	local actor A;
	local material FloorMat;
	local vector HL,HN,Start,End;

	SurfaceNum = 0;

	Start = Location - Vect(0,0,1)*CollisionHeight;
	End = Start - Vect(0,0,90);
	A = Trace(hl,hn,End,Start,false,,FloorMat);
	if (FloorMat !=None)
	{
		;
		KFXLevelAllowHideWeap =  false;
	}
	else
	{
		;
		KFXLevelAllowHideWeap = true;
	}
}
simulated function NotifyWeapJump()
{
	;
	if(self.Weapon != none && !KFXWeapBase(Weapon).KFXGetCanJumpFire())
	{
		KFXWeapBase(Weapon).KFXNotifyJump();
		if( Role < ROLE_Authority || Level.NetMode == NM_Standalone)
		bCanFire=false;
	}
	else
	{
		KFXLevelAllowHideWeap = false;
	}
}
simulated function NotifyWeapLanded()
{
	;
	TickIndex = 0;
	if(Weapon!=none&&KFXWeapBase(Weapon).KFXGetFireMode(0)!=none&&!KFXWeapBase(Weapon).KFXGetCanJumpFire())
	{
		KFXWeapBase(Weapon).KFXNotifyLanded();
	}
	if( Role < ROLE_Authority || Level.NetMode == NM_Standalone)
	{
		KFXLevelAllowHideWeap = false;
		bCanFire=true;
	}
}

singular event BaseChange()
{
	local float decorMass;

	if ( bInterpolating )
		return;
	if ( (base == None) && (Physics == PHYS_Falling))
	{
		if(!KFXLevelAllowHideWeap)
			KFXLevelAllowWeapHide();

		if(KFXLevelAllowHideWeap)
		{
			NotifyWeapJump();
		}
	}

	if ( (base == None) && (Physics == PHYS_None) )
	{
		SetPhysics(PHYS_Falling);

	}
	// Pawns can only set base to non-pawns, or pawns which specifically allow it.
	// Otherwise we do some damage and jump off.
	else if ( Pawn(Base) != None && Base != DrivenVehicle )
	{
		if ( !Pawn(Base).bCanBeBaseForPawns )
		{
			Base.TakeDamage( (1-Velocity.Z/400)* Mass/Base.Mass, Self,Location,0.5 * Velocity , class'Crushed');
			JumpOffPawn();
		}
	}
	else if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
	{
		decorMass = FMax(Decoration(Base).Mass, 1);
		Base.TakeDamage((-2* Mass/decorMass * Velocity.Z/400), Self, Location, 0.5 * Velocity, class'Crushed');
	}
}
simulated function KFXSetInvisLevel(int Level,optional bool bForced)
{
}
/*vehicle*/
simulated event StartDriving(Vehicle V)
{
	super.StartDriving( V );
	if ( !V.bRemoteControlled || V.bHideRemoteDriver )
	{
		;
		if(KFXPlayer(Level.GetLocalPlayerController()).bServerAllowHide)
		{
			KFXSetInvisLevel(0,true);
		}
		if(AvatarHead != none && AvatarLegs != none)
		{
			AvatarHead.bHidden = true;
			AvatarLegs.bHidden = true;
		}
	}
}

simulated event StopDriving(Vehicle V)
{
	super.StopDriving( V );
	if ( !V.bRemoteControlled || V.bHideRemoteDriver )
	{
		if(AvatarHead != none && AvatarLegs != none)
		{
			AvatarHead.bHidden = false;
			AvatarLegs.bHidden = false;
		}
	}
}

/*vehilce*/

//Hawk.Wang 2010-08-09 UED Only
//ÉèÖÃÍ·ÊÎÎ»ÖÃ
exec function KFXSetComPos(string XYZ)
{
	local vector Pos;
	local Array<string> stringArray;

	Split( XYZ,",",stringArray);

	if( stringArray.Length != 3 )
	{
		return;
	}

	Pos.X = int( stringArray[0]);
	Pos.Y = int( stringArray[1]);
	Pos.Z = int( stringArray[2]);
	KFXWeapBase(weapon).KFXWeapComponent[4].SetRelativeLocation( Pos );
}

//Hawk.Wang 2010-08-09 UED Only
//ÉèÖÃÍ·ÊÎÐý×ª
exec function KFXSetComRot(string ROTString )
{
	local rotator rota;
	local Array<string> stringArray;

	Split( ROTString,",",stringArray);

	rota.Pitch = int(stringArray[0]);
	rota.Yaw   = int(stringArray[1]);
	rota.Roll  = int(stringArray[2]);
	KFXWeapBase(weapon).KFXWeapComponent[4].SetRelativeRotation( rota );
}






/* TimingOut - where gibbed pawns go to die (delay so they can get replicated)
*/
state TimingOut
{
ignores BaseChange, Landed, AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	function TakeDamage( float Damage, Pawn instigatedBy, Vector hitlocation,
							vector momentum, class<DamageType> damageType)
	{
	}

	function BeginState()
	{
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		LifeSpan = 1.0;
		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
				Controller.PawnDied(self);
			else
				Controller.Destroy();
		}
	}
}
simulated function KFXAddAgentDecoration(Pawn p);

// server only
function BroadcastHitInfo(
	Pawn Hitter,
	int HitHP,
	int WeapID,
	bool bShootDown,
	bool bHeadKill
)
{
	local KFXPlayerReplicationInfo HitterPRI, OwnPRI;
	local PlayerReplicationInfo PRI;
	local GameReplicationInfo GRI;
	local int i;

	if (WeapID != 0 && HitHP != 0
			&& Hitter != none && Hitter.PlayerReplicationInfo != none)
	{
		HitterPRI = KFXPlayerReplicationInfo(Hitter.PlayerReplicationInfo);
		HitterPRI.UpdateHitOtherList(bHeadKill, HitHP, PlayerReplicationInfo, bShootDown);
		OwnPRI = KFXPlayerReplicationInfo(PlayerReplicationInfo);
		OwnPRI.UpdateBeHitedList(bHeadKill, HitHP, Hitter.PlayerReplicationInfo, bShootDown, WeapID);
	}
	if (bShootDown && Controller != none
		&& KFXPlayer(Controller).GameReplicationInfo != none)
	{
		GRI = KFXPlayer(Controller).GameReplicationInfo;
		for (i = 0; i < GRI.PRIArray.Length; i++)
		{
			PRI = GRI.PRIArray[i];
			KFXPlayerReplicationInfo(PRI).UpdateDeadHitInfo(PlayerReplicationInfo);
		}
		KFXPlayerReplicationInfo(PlayerReplicationInfo).TransCombatInfo();
	}
}

defaultproperties
{
     fPlayStepSoundRate=0.300000
     fShowStepEffectRate=0.200000
     AshesKeepingTime=10.000000
     ClientAshesKeepingTime=2.000000
     AshesDisappearTime=10.000000
     FootstepRate=0.400000
     StepSounds(0)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     StepSounds(1)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     StepSounds(2)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     StepSounds(3)=(RunSound[0]=Sound'fx_step_sounds.Metal.metal_run1',RunSound[1]=Sound'fx_step_sounds.Metal.metal_run2',RunSound[2]=Sound'fx_step_sounds.Metal.metal_run3',RunSound[3]=Sound'fx_step_sounds.Metal.metal_run4',RunSound[4]=Sound'fx_step_sounds.Metal.metal_run5',JumpSound=Sound'fx_step_sounds.Metal.metal_jump1')
     StepSounds(4)=(RunSound[0]=Sound'fx_step_sounds.wood.wood_run1',RunSound[1]=Sound'fx_step_sounds.wood.wood_run2',RunSound[2]=Sound'fx_step_sounds.wood.wood_run3',RunSound[3]=Sound'fx_step_sounds.wood.wood_run4',RunSound[4]=Sound'fx_step_sounds.wood.wood_run5',JumpSound=Sound'fx_step_sounds.wood.wood_jump1')
     StepSounds(5)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     StepSounds(6)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     StepSounds(7)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     StepSounds(8)=(RunSound[0]=Sound'fx_step_sounds.snow.snow_run1',RunSound[1]=Sound'fx_step_sounds.snow.snow_run2',RunSound[2]=Sound'fx_step_sounds.snow.snow_run3',RunSound[3]=Sound'fx_step_sounds.snow.snow_run4',RunSound[4]=Sound'fx_step_sounds.snow.snow_run5',JumpSound=Sound'fx_step_sounds.snow.snow_jump1')
     StepSounds(9)=(RunSound[0]=Sound'fx_step_sounds.wade.wade_run1',RunSound[1]=Sound'fx_step_sounds.wade.wade_run2',RunSound[2]=Sound'fx_step_sounds.wade.wade_run3',RunSound[3]=Sound'fx_step_sounds.wade.wade_run4',RunSound[4]=Sound'fx_step_sounds.wade.wade_run5',JumpSound=Sound'fx_step_sounds.wade.wade_jump1')
     StepSounds(10)=(RunSound[0]=Sound'fx_step_sounds.General.general_run1',RunSound[1]=Sound'fx_step_sounds.General.general_run2',RunSound[2]=Sound'fx_step_sounds.General.general_run3',RunSound[3]=Sound'fx_step_sounds.General.general_run4',RunSound[4]=Sound'fx_step_sounds.General.general_run5',JumpSound=Sound'fx_step_sounds.General.general_jump1')
     KFXUseEightDirectionMoveAnims=是
     dmgTimeDisply=1.500000
     bCanFire=是
     ProneCollisionRadius=55.000000
     ProneCollisionHeight=70.000000
     KFXDamageFactor=1.000000
     KFXFPSoundScale=1.000000
     KFXSpeedScale=1.000000
     WeapJumpFactor=0.300000
     RagInvInertia=4.000000
     RagDeathVel=200.000000
     RagShootStrength=6000.000000
     RagSpinScale=2.500000
     RagDeathUpKick=150.000000
     DamagedSpeedDownRate=1.000000
     bAvoidLedges=是
     bCanWalkOffLedges=是
     GroundSpeed=0.000000
     WaterSpeed=0.000000
     AirSpeed=0.000000
     LadderSpeed=0.000000
     JumpZ=0.000000
     WalkingPct=0.000000
     CrouchedPct=0.000000
     bPhysicsAnimUpdate=是
     bDoTorsoTwist=是
     bUseDefCollisionVar=是
     bUseDefPrePivotVar=是
     bUseDefSpeedVar=是
     bActorShadows=是
     bAlwaysRelevant=是
     bNetNotify=是
     RotationRate=(Pitch=3072)
     Begin Object Class=KarmaParamsSkel Name=PawnKParams0
         KConvulseSpacing=(Max=2.200000)
         KLinearDamping=0.150000
         KAngularDamping=0.050000
         KStartEnabled=是
         KVelDropBelowThreshold=50.000000
         bHighDetailOnly=否
         KFriction=0.600000
         KImpactThreshold=500.000000
     End Object
     KParams=KarmaParamsSkel'KFXGame.KFXPawnBase.PawnKParams0'

}
