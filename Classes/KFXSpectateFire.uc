class KFXSpectateFire extends Actor;

var KFXSpectateWeap Weapon;
var KFXPlayer Viewer;

//×ó¼üÄ£Ê½ºÍÓÒ¼üÄ£Ê½£¬Ô­Ê¼¿ª»ðÄ£Ê½
var int FireModeNum;
var int AltFireModeNum;

//<ÏÂÃæµÄ¼¸¸öÄ£Ê½ÀàÐÍ»áÊÜµ½ÎäÆ÷×é¼þµÄÓ°Ïì¶ø¸Ä±ä>//
//×ó¼üÄ£Ê½£¨°´ÏÔÊ¾ÄÚÈÝ·ÖÀà£©
//0£ºÎÞ×ó¼ü¶¯×÷
//1£ºÓÐ×ó¼ü¶¯×÷£¨¶¯×÷ÊÜÓÒ¼ü×´Ì¬Ó°Ïì£¬×¼ÐÇ»á¸Ä±ä£©
//2£ºÓÐÇ°ÖÃ¶¯×÷£¨ÈçÊÖÀ×£©£¨ÔÝÊ±ºöÊÓ£©
var byte KFXFireType;

//ÓÒ¼üÄ£Ê½£¨°´ÏÔÊ¾ÄÚÈÝ·ÖÀà£©
//0£ºÎÞÓÒ¼ü¶¯×÷
//1£ºÓÐÓÒ¼ü¶¯×÷
var byte KFXAltFireType;

//ÓÒ¼ü½øÈë×´Ì¬
//0£º²»½øÈëÈÎºÎ×´Ì¬
//1£º£¨½øÈë/ÍË³ö£©¿ª¾µ×´Ì¬
//2£º£¨½øÈë/ÍË³ö£©¼ÜÇ¹×´Ì¬
//3£º£¨½øÈë/ÍË³ö£©ÈýÁ¬·¢×´Ì¬
//4: £¨½øÈë/ÍË³ö£©ÓÐÊÓ¸ß±ä»¯µÄ¼ÜÇ¹×´Ì¬
var byte KFXAltFireState;

// animation //

var() name PreFireAnim;
var() name FireAnim;
var() name FireLoopAnim;
var() name FireEndAnim;

var() float PreFireAnimRate;
var() float FireAnimRate;
var() float FireLoopAnimRate;
var() float FireEndAnimRate;
var() float TweenTime;


//Ô­Ê¼
var() name PreFireAnimOrg;
var() name FireAnimOrg;
var() name FireLoopAnimOrg;
var() name FireEndAnimOrg;

//ÎÕ°Ñ
var() name PreFireAnim_G;
var() name FireAnim_G;
var() name FireLoopAnim_G;
var() name FireEndAnim_G;


var name AltFireAnim;
var name UnAltFireAnim;
var float AltFireAnimRate;
var float UnAltFireAnimRate;

var name EmptyFireAnim;
var float  EmptyFireAnimRate;

//Ô­Ê¼
var name EmptyFireAnimOrg;
//ÎÕ°Ñ
var name EmptyFireAnim_G;

//< cross Hair
var int     KFXCrossHairType;     // Type Of CrossHair
var color   KFXCHColorNormal;
var color   KFXCHColorEnemy;
var color   KFXCHColorFriend;
var float   CrossHairLength;       // cross Hair Affected by Firing
var float   CrossHairSpread;       // cross Hair Affected by Accuracy
var float   CrossHairLengthFireToFill;   // when fire, the length to fill
var float   CrossHairSpreadFireToFill;   // when fire, the spread to fill

var float   CrossHairRaiseFactor[3];
var float   CrossHairDecayFactor[3];

var float   CrossHairMaxLength[3];    // Max length
var float   CrossHairMaxSpread[3];    // Max Spread
var float   CrossHairMinLength[3];    // Min length
var float   CrossHairMinSpread[3];    // Min Spread

var float   CrossHairSpreadCrouch[3];    // Crosshair Spread for state
var float   CrossHairSpreadStand[3];
var float   CrossHairSpreadRun[3];
var float   CrossHairSpreadWalk[3];
var float   CrossHairSpreadJump[3];
var texture KFXCrossHairTex[3];      //×¼ÐÇµÄ²ÄÖÊ
var texture KFXSniperMaterial;  //×¼¾µµÄ²ÄÖÊ
var string  OrgSniperSightStr;

var float   FrameTime;       // Frame Time

//var int FireCount;                //replication

var bool PlayedPreFire;

var int SniperX;
var int SniperY;


// Client & Server
// TODO: ÐèÒªÓÅ»¯£¬ºÜ¶àÎäÆ÷²»ÐèÒªµ¯µÀ²ÎÊý
// ×¢Òâ£ºÓÉÓÚ»æÖÆ×¼ÐÇÊ±ÏÈµ÷ÓÃÓÒ¼ü¿ª»ðÄ£Ê½µÄ×¼ÐÇ£¬¶øÊµ¼ÊÓÃµÄÊÇ×ó¼ü¿ª»ðÄ£Ê½µÄ×¼ÐÇ
// Òò´ËÓÒ¼ü¿ª»ðÄ£Ê½²»ÐèÒªµ÷ÓÃ´ËÀàµÄKFXInit, Ó¦ÖØÐ´´Ëº¯Êý»ò²»µ÷ÓÃKFXInitCrosshairº¯Êý
simulated function KFXInit(int WeaponID)
{
	local KFXCSVTable CFG_Weapon,CFG_FireMode ,CFG_Track, CFG_Media, CFG_DmgType, CFG_Proj;
//    local string StateName, TempString;
	//local int nTemp/*, loop*/;
	local name nAnimTemp;

	CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
	CFG_FireMode    = class'KFXTools'.static.GetConfigTable(12);
	CFG_Track       = class'KFXTools'.static.GetConfigTable(16);
	CFG_DmgType     = class'KFXTools'.static.GetConfigTable(21);
	CFG_Proj        = class'KFXTools'.static.GetConfigTable(20);

	if ( !CFG_Weapon.SetCurrentRow(WeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Attribute Table): "$WeaponID);
		return;
	}

	FireModeNum = CFG_Weapon.GetInt("FireMode1");
	AltFireModeNum = CFG_Weapon.GetInt("FireMode2");
	SetModeType(FireModeNum,AltFireModeNum);

	if ( !CFG_Track.SetCurrentRow(WeaponID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Track Table): "$WeaponID);
		return;
	}

	// Load Client Resource
	if ( Level.NetMode != NM_DedicatedServer )
	{
		CFG_Media      = class'KFXTools'.static.GetConfigTable(10);

		if ( !CFG_Media.SetCurrentRow(WeaponID) )
		{
			Log("[Kevin] Can't Resolve The Weapon ID (Media Table): "$WeaponID);
			return;
		}

		// Load Anim
		nAnimTemp = CFG_Media.GetName("PreFireAni");
		if ( nAnimTemp != '0' )
		{
			PreFireAnim = nAnimTemp;
			PreFireAnimRate = CFG_Media.GetFloat("PreFireAniRate");
		}

		nAnimTemp = CFG_Media.GetName("FireAni");
		if ( nAnimTemp != '0' )
		{
			FireAnim = nAnimTemp;
			FireAnimRate = CFG_Media.GetFloat("FireAniRate");
		}

		nAnimTemp = CFG_Media.GetName("FireLoopAni");
		if ( nAnimTemp != '0' )
		{
			FireLoopAnim = nAnimTemp;
			FireLoopAnimRate = CFG_Media.GetFloat("FireLoopAniRate");
		}

		nAnimTemp = CFG_Media.GetName("FireEndAni");
		if ( nAnimTemp != '0' )
		{
			FireEndAnim = nAnimTemp;
			FireEndAnimRate = CFG_Media.GetFloat("FireEndAniRate");
		}

		nAnimTemp = CFG_Media.GetName("EmptyFireAni");
		if ( nAnimTemp != '0' )
		{
			EmptyFireAnim = nAnimTemp;
			EmptyFireAnimRate = CFG_Media.GetFloat("EmptyFireAniRate");
		}

		TweenTime = CFG_Media.GetFloat("TweenTime");

		//Ô­Ê¼
		PreFireAnimOrg          =PreFireAnim;
		FireAnimOrg             =FireAnim;
		FireLoopAnimOrg         =FireLoopAnim;
		FireEndAnimOrg          =FireEndAnim;
        EmptyFireAnimOrg        =EmptyFireAnim;

	    if(PreFireAnim!='')
			PreFireAnim_G = class'DataTable'.static.StringToName(PreFireAnim$"_G");
		if(FireAnim!='')
			FireAnim_G = class'DataTable'.static.StringToName(FireAnim$"_G");
		if(FireLoopAnim!='')
			FireLoopAnim_G = class'DataTable'.static.StringToName(FireLoopAnim$"_G");
		if(FireEndAnim!='')
			FireEndAnim_G = class'DataTable'.static.StringToName(FireEndAnim$"_G");
		if(EmptyFireAnim!='')
			EmptyFireAnim_G = class'DataTable'.static.StringToName(EmptyFireAnim$"_G");



//        // Load MuzzleFlash
//        TempString = CFG_Media.GetString("MFMaterial");
//
//        if ( !(TempString ~= "null") )
//        {
//            MuzzleMaterial = TexRotator(
//                DynamicLoadObject(TempString, class'TexRotator'));
//            MuzzleFlashSize = CFG_Media.GetFloat("MFSize");
//            MuzzleScale     = CFG_Media.GetFloat("MFScale");
//            FlashOffsetX    = CFG_Media.GetFloat("MFOffsetX");
//            FlashOffsetY    = CFG_Media.GetFloat("MFOffsetY");
//            FlashLength     = CFG_Media.GetFloat("MFTime");
//        }

		// ³õÊ¼»¯×¼ÐÄÅäÖÃÊý¾Ý
		KFXInitCrosshair(CFG_Media);
		if(WeaponID == 1)
		{
			KFXCrossHairType = -1;
		}
	}
}

simulated function KFXInitCrosshair( KFXCSVTable CFG_Media )
{
	local string TempString;

	KFXCrossHairType  = CFG_Media.GetInt("CHType");
	// set 1
	CrossHairRaiseFactor[0] = CFG_Media.GetFloat("CHRaise1");
	CrossHairDecayFactor[0] = CFG_Media.GetFloat("CHDecay1");

	CrossHairMaxLength[0] = CFG_Media.GetFloat("CHShMax1");
	CrossHairMaxSpread[0] = CFG_Media.GetFloat("CHSpMax1");
	CrossHairMinLength[0] = CFG_Media.GetFloat("CHShMin1");
	CrossHairMinSpread[0] = CFG_Media.GetFloat("CHSpMin1");

	CrossHairSpreadJump[0]    = CFG_Media.GetFloat("CHSpJump1");
	CrossHairSpreadRun[0]     = CFG_Media.GetFloat("CHSpRun1");
	CrossHairSpreadWalk[0]    = CFG_Media.GetFloat("CHSpWalk1");
	CrossHairSpreadStand[0]   = CFG_Media.GetFloat("CHSpStand1");
	CrossHairSpreadCrouch[0]  = CFG_Media.GetFloat("CHSpCrouch1");

	TempString = CFG_Media.GetString("CHMaterial1");
	if ( !(TempString ~= "null") )
		KFXCrossHairTex[0] = texture(DynamicLoadObject(TempString, class'texture'));

	// set 2
	CrossHairRaiseFactor[1] = CFG_Media.GetFloat("CHRaise2");
	CrossHairDecayFactor[1] = CFG_Media.GetFloat("CHDecay2");

	CrossHairMaxLength[1] = CFG_Media.GetFloat("CHShMax2");
	CrossHairMaxSpread[1] = CFG_Media.GetFloat("CHSpMax2");
	CrossHairMinLength[1] = CFG_Media.GetFloat("CHShMin2");
	CrossHairMinSpread[1] = CFG_Media.GetFloat("CHSpMin2");

	CrossHairSpreadJump[1]    = CFG_Media.GetFloat("CHSpJump2");
	CrossHairSpreadRun[1]     = CFG_Media.GetFloat("CHSpRun2");
	CrossHairSpreadWalk[1]    = CFG_Media.GetFloat("CHSpWalk2");
	CrossHairSpreadStand[1]   = CFG_Media.GetFloat("CHSpStand2");
	CrossHairSpreadCrouch[1]  = CFG_Media.GetFloat("CHSpCrouch2");

	TempString = CFG_Media.GetString("CHMaterial2");
	if ( !(TempString ~= "null") )
		KFXCrossHairTex[1] = texture(DynamicLoadObject(TempString, class'texture'));

	// set 3
	CrossHairRaiseFactor[2] = CFG_Media.GetFloat("CHRaise3");
	CrossHairDecayFactor[2] = CFG_Media.GetFloat("CHDecay3");

	CrossHairMaxLength[2] = CFG_Media.GetFloat("CHShMax3");
	CrossHairMaxSpread[2] = CFG_Media.GetFloat("CHSpMax3");
	CrossHairMinLength[2] = CFG_Media.GetFloat("CHShMin3");
	CrossHairMinSpread[2] = CFG_Media.GetFloat("CHSpMin3");

	CrossHairSpreadJump[2]    = CFG_Media.GetFloat("CHSpJump3");
	CrossHairSpreadRun[2]     = CFG_Media.GetFloat("CHSpRun3");
	CrossHairSpreadWalk[2]    = CFG_Media.GetFloat("CHSpWalk3");
	CrossHairSpreadStand[2]   = CFG_Media.GetFloat("CHSpStand3");
	CrossHairSpreadCrouch[2]  = CFG_Media.GetFloat("CHSpCrouch3");

	TempString = CFG_Media.GetString("CHMaterial3");
	if ( !(TempString ~= "null") )
		KFXCrossHairTex[2] = texture(DynamicLoadObject(TempString, class'texture'));

	OrgSniperSightStr = CFG_Media.GetString("SniperRifleHUD");
	if ( !(OrgSniperSightStr ~= "null") )
		KFXSniperMaterial = texture(DynamicLoadObject(OrgSniperSightStr, class'texture'));
}

simulated function ComponentChangeModeType(int FireModeNumChange,int AltFireModeNumChange,int part)
{
	if((FireModeNumChange== 0 && AltFireModeNumChange == 0) && part!=4)
	{
		return;
	}
	SetModeType(FireModeNum+FireModeNumChange,AltFireModeNum+ AltFireModeNumChange);
}

simulated function SetModeType(int ModeNum,int AltModeNum)
{
	local KFXCSVTable CFG_FireMode;
	CFG_FireMode    = class'KFXTools'.static.GetConfigTable(12);
	switch(ModeNum)
	{
	case 3: KFXFireType=2;break;  //ÔÝÊ±²»¶ÔÓÐÇ°ÖÃ¶¯×÷µÄ¿ª»ð¶¯×÷½øÐÐ´¦Àí£¬ºöÊÓÇ°ÖÃ¶¯×÷
	case 11:KFXFireType=2;break;
	default: KFXFireType=1;
	}

	switch(AltModeNum)
	{
	case 4:
	case 18:
	case 17:
	case 16:KFXAltFireType = 0; KFXAltFireState = 1;
		CFG_FireMode.SetCurrentRow(AltModeNum);
		weapon.KFXZoomLevelMax += CFG_FireMode.GetInt("OneSightFOV");
		weapon.KFXZoomLevelMin += CFG_FireMode.GetInt("TwoSightFOV");
		break;
	case 41: KFXAltFireType = 0; KFXAltFireState = 3; break;
	case 1302:KFXAltFireType = 1; KFXAltFireState = 0; break;
	case 1305:KFXAltFireType = 1; KFXAltFireState = 0; break;
	default:KFXAltFireType=0;KFXAltFireState=0;
	}
}

//¶ÔÓÚÄ£ÄâÍ¶ÖÀÀàÎäÆ÷µÄÇ°ÖÃ¶¯×÷£¬ÔÝÊ±²»¿¼ÂÇ
simulated function PlayPreFire()
{
	if ( Weapon.Mesh != None && Weapon.HasAnim(PreFireAnim) )
	{
		Weapon.PlayAnim(PreFireAnim, PreFireAnimRate, TweenTime);
		PlayedPreFire = true;
	}
}
// Play Firing
// Owner Client Only
simulated function PlayFire()
{
	if( Weapon != none && Viewer != none &&!Viewer.bBehindView )
	{
		Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
		FireUpdateCrossHair();
	}

	if(Weapon.Component[0]!=none && Weapon.Component[0].FireAnim!='' && Weapon.Component[0].FireAnim != 'null')
	{
		Weapon.Component[0].PlayAnim(Weapon.Component[0].FireAnim);
	}
	log("KFXSpectate-----Weapon.Component[0] "$Weapon.Component[0]);
	log("KFXSpectate-----Weapon.Component[0].bShowAnotherFireSound "$Weapon.Component[0].bShowAnotherFireSound);

	//ÊÇ·ñÅäÁËÏûÒôÆ÷¹¦ÄÜ
	if(Weapon.Component[0]!=none && !Weapon.Component[0].bShowAnotherFireSound)
	{
		Weapon.PlaySound(
				Weapon.KFXGetFPFireSound(),
				SLOT_Interact,
				TransientSoundVolume,
				,
				TransientSoundRadius,
				,
				false);
	}
	else
	{
		Weapon.PlaySound(
				Weapon.KFXGetFPSmallFireSound(),
				SLOT_Interact,
				TransientSoundVolume,
				,
				TransientSoundRadius,
				,
				false);
	}

	//ClientPlayForceFeedback(FireForce);  // jdf
}

simulated function PlayAltFire()
{
	if(KFXAltFireType == 1)
	{
		if(Weapon.WeaponStateValue == 0)
		{
			Weapon.PlayAnim(AltFireAnim,AltFireAnimRate,TweenTime);
		}
		else
		{
			Weapon.PlayAnim(UnAltFireAnim,UnAltFireAnimRate,TweenTime);
		}
	}
}

simulated function Tick(float deltaTime)
{
	if(Level.NetMode != NM_DedicatedServer)
	{
		FrameTime = deltaTime;
		UpdateCrossHair();
	}
}


// Update CrossHair Params
// Client Only
simulated function UpdateCrossHair()
{
	local float DesiredSpread, DesiredLength;
	local byte CrosshairIndex;
	CrosshairIndex = Viewer.KFXCrosshairSizeIndex;

	// Calc Desiared Cross Hair
	CalcDesiaredCrossHair(DesiredSpread, DesiredLength);

	// Decay cross Hair
	DecayCrossHair(DesiredSpread, DesiredLength);

	// clamp values
	CrossHairLength = FMax(CrossHairMinLength[CrosshairIndex], CrossHairLength);
	CrossHairSpread = FMax(CrossHairMinSpread[CrosshairIndex], CrossHairSpread);
}

// Calc Desiared cross Hair
// Client Only
simulated function CalcDesiaredCrossHair(out float DesiredSpread, out float DesiredLength)
{
	local float DecayValue;
	local byte CrosshairIndex;
	CrosshairIndex = Viewer.KFXCrosshairSizeIndex;

	// calc real spread & Length - decay
	DecayValue = CrossHairRaiseFactor[CrosshairIndex] * FrameTime;

	if ( Instigator == none )
	{
		return;
	}

	if ( CrossHairSpreadFireToFill > 0 )
	{
		// fill fire spread
		DesiredSpread = CrossHairSpread + DecayValue;
		CrossHairSpreadFireToFill -= DecayValue;

		if ( CrossHairSpreadFireToFill < 0 )
			CrossHairSpreadFireToFill = 0;
	}
	else
	{
		// calc Spread
		if ( Instigator.Physics != PHYS_Walking )
		{
			DesiredSpread = CrossHairSpreadJump[CrosshairIndex];
		}
		else if ( KFXIsSpeedInRun() )
		{
			DesiredSpread = CrossHairSpreadRun[CrosshairIndex];
		}
		else if ( VSize(Instigator.Velocity) > 10 )
		{
			DesiredSpread = CrossHairSpreadWalk[CrosshairIndex];
		}
		else if ( Instigator.bIsCrouched )
		{
			DesiredSpread = CrossHairSpreadCrouch[CrosshairIndex];
		}
		else
		{
			DesiredSpread = CrossHairSpreadStand[CrosshairIndex];
		}
	}

	if ( CrossHairLengthFireToFill > 0 )
	{
		// fill fire spread
		DesiredLength = CrossHairLength + DecayValue;
		CrossHairLengthFireToFill -= DecayValue;

		if ( CrossHairLengthFireToFill < 0 )
			CrossHairLengthFireToFill = 0;
	}
	else
	{
		DesiredLength = CrossHairMinLength[CrosshairIndex];
	}
}

// Tool function
// Is Current Velocity Higher than Walk
simulated function bool KFXIsSpeedInRun()
{
	return VSize(Instigator.Velocity) > (Instigator.WalkingPct * Instigator.GroundSpeed + 10);
}

// Decay Cross Hair
// Client Only
simulated function DecayCrossHair(float DesiredSpread, float DesiredLength)
{
	local float DecayValue;
	local byte CrosshairIndex;
	CrosshairIndex = Viewer.KFXCrosshairSizeIndex;

	// calc real spread & Length - decay
	DecayValue = CrossHairDecayFactor[CrosshairIndex] * FrameTime;

	if ( DesiredSpread - CrossHairSpread > DecayValue )
	{
		CrossHairSpread = CrossHairSpread + DecayValue;
	}
	else if ( DesiredSpread - CrossHairSpread < -DecayValue )
	{
		CrossHairSpread = CrossHairSpread - DecayValue;
	}
	else
	{
		CrossHairSpread =  DesiredSpread;
	}

	if ( DesiredLength - CrossHairLength > DecayValue )
	{
		CrossHairLength = CrossHairLength + DecayValue;
	}
	else if ( DesiredLength - CrossHairLength < -DecayValue )
	{
		CrossHairLength = CrossHairLength - DecayValue;
	}
	else
	{
		CrossHairLength = DesiredLength;
	}
}

// Update CrossHair Params on firing
// Client Only
simulated function FireUpdateCrossHair()
{
	local byte CrosshairIndex;
	CrosshairIndex = Viewer.KFXCrosshairSizeIndex;
	CrossHairSpreadFireToFill = CrossHairMaxSpread[CrosshairIndex] - CrossHairSpread;
	CrossHairLengthFireToFill = CrossHairMaxLength[CrosshairIndex] - CrossHairLength;
}


// Draw CrossHair
// Client Only
simulated function bool KFXDrawCrossHair(Canvas C)
{
	local float CenterX, CenterY, UL, VL;
	local Actor TraceActor;
	local color CrossHairColor;
	local byte CrosshairIndex;
	local int bold; //×¼ÐÇ¿í¶È
//    local int tempcolor;
//    local int i;
	CrosshairIndex = Viewer.KFXCrosshairSizeIndex;

	CenterX = C.SizeX * 0.5;
	CenterY = C.SizeY * 0.5;

	// CrossHair color
	if(Instigator==none)
	return false;
	TraceActor = KFXHud(Viewer.myHUD).KFXLastTraceViewActor;

	if ( KFXPawn(TraceActor) != none && !KFXPawn(TraceActor).bTearOff && KFXPawn(TraceActor) != Instigator )
	{
		if ( KFXPawn(Instigator).KFXInTheSameTeam(KFXPawn(TraceActor)) )
			C.DrawColor = KFXCHColorFriend;
		else
		{
			C.DrawColor = KFXCHColorEnemy;
		}
	}
	else
	{
		C.DrawColor = KFXCHColorNormal;
	}
	C.Style = 5;
	bold = 2;   //×¼ÐÇ¿í¶È£¬Ä¬ÈÏÎª1

	switch (KFXCrossHairType)
	{
	case -1: //none
		return false;
	case 1:
		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
		break;
	case 2:
		// center
		C.SetPos(CenterX-bold/2, CenterY-bold/2);
		C.DrawLine(3, bold, bold);

		// up
		C.SetPos(CenterX-bold/2, CenterY - CrossHairSpread);
		C.DrawLine(0, CrossHairLength, bold);

		// down
		C.SetPos(CenterX-bold/2, CenterY + CrossHairSpread + 1);
		C.DrawLine(1, CrossHairLength, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
	case 3:
		// center
		C.SetPos(CenterX-bold/2, CenterY-bold/2);
		C.DrawLine(3, bold, bold);

		// down
		C.SetPos(CenterX-bold/2, CenterY + CrossHairSpread + 1);
		C.DrawLine(1, CrossHairLength, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
		break;
	case 4:
		// center
		C.SetPos(CenterX-bold/2, CenterY-bold/2);
		C.DrawLine(3, bold, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY-bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY-bold/2);
		C.DrawLine(3, CrossHairLength, bold);
		break;
	case 5:
		// center
		C.SetPos(CenterX - 1, CenterY - 1 - bold/2);
		C.DrawLine(3, 3, bold);
		C.SetPos(CenterX - 1, CenterY - bold/2);
		C.DrawLine(3, 3, bold);
		C.SetPos(CenterX - 1, CenterY + 1 - bold/2);
		C.DrawLine(3, 3, bold);
		break;
	case 6:
		if ( KFXPawn(TraceActor) != none && !KFXPawn(TraceActor).bTearOff && KFXPawn(TraceActor) != Instigator )
				{
					if( KFXPawn(Instigator).KFXInTheSameTeam(KFXPawn(TraceActor) ))
					{
						C.DrawColor = KFXCHColorFriend;
					}

						else
				   {
						C.DrawColor = KFXCHColorEnemy;
			}
		}
		else
		{
			if ( Viewer.KFXCrosshairColorType == 1 )
			{
				CrossHairColor.R = 0xff;
				CrossHairColor.G = 0xd3;
				CrossHairColor.B = 0x0b;
				CrossHairColor.A = 0xff;
				C.DrawColor = CrossHairColor;
			}
			else if ( Viewer.KFXCrosshairColorType == 2 )
			{
				CrossHairColor.R = 0x00;
				CrossHairColor.G = 0xd8;
				CrossHairColor.B = 0xfd;
				CrossHairColor.A = 0xff;
				C.DrawColor = CrossHairColor;
			}
			else
			{
				CrossHairColor.R = 0x03;
				CrossHairColor.G = 0xf3;
				CrossHairColor.B = 0x01;
				CrossHairColor.A = 0xff;
				C.DrawColor = CrossHairColor;
			}
		}
		if ( Viewer.KFXCrosshairShapeType == 0 )
		{
			// up
			C.SetPos(CenterX - bold/2, CenterY - CrossHairSpread);
			C.DrawLine(0, CrossHairLength, bold);

			// down
			C.SetPos(CenterX - bold/2, CenterY + CrossHairSpread + 1);
			C.DrawLine(1, CrossHairLength, bold);

			// left
			C.SetPos(CenterX - CrossHairSpread, CenterY - bold/2);
			C.DrawLine(2, CrossHairLength, bold);

			// right
			C.SetPos(CenterX + CrossHairSpread + 1, CenterY - bold/2);
			C.DrawLine(3, CrossHairLength, bold);
		}
		else if ( Viewer.KFXCrosshairShapeType == 1 )
		{
			// center
			C.SetPos(CenterX-bold/2, CenterY-bold/2);
			C.DrawLine(3, bold, bold);

			// up
			C.SetPos(CenterX - bold/2, CenterY - CrossHairSpread);
			C.DrawLine(0, CrossHairLength, bold);

			// down
			C.SetPos(CenterX - bold/2, CenterY + CrossHairSpread + 1);
			C.DrawLine(1, CrossHairLength, bold);

			// left
			C.SetPos(CenterX - CrossHairSpread, CenterY - bold/2);
			C.DrawLine(2, CrossHairLength, bold);

			// right
			C.SetPos(CenterX + CrossHairSpread + 1, CenterY - bold/2);
			C.DrawLine(3, CrossHairLength, bold);
		}
		else if ( Viewer.KFXCrosshairShapeType == 2 )
		{
			//CrossHairTex = texture(DynamicLoadObject("fx_ui3_texs.crosshair_c", class'texture'));
			if ( KFXCrossHairTex[CrosshairIndex] != none )
			{
				CenterX = C.SizeX * 0.5;
				CenterY = C.SizeY * 0.5;
				UL = KFXCrossHairTex[CrosshairIndex].USize;
				VL = KFXCrossHairTex[CrosshairIndex].VSize;
				C.SetPos(CenterX - UL / 2, CenterY - VL / 2);
				C.DrawTile(KFXCrossHairTex[CrosshairIndex], UL, VL, 0, 0, UL, VL);
			}
		}
		break;
	case 10:
		// DrawTile
		if ( KFXCrossHairTex[CrosshairIndex] != none )
		{
			CenterX = C.SizeX * 0.5;
			CenterY = C.SizeY * 0.5;
			UL = KFXCrossHairTex[CrosshairIndex].USize;
			VL = KFXCrossHairTex[CrosshairIndex].VSize;
			C.SetPos(CenterX - UL / 2, CenterY - VL / 2);
			C.DrawTile(KFXCrossHairTex[CrosshairIndex], UL, VL, 0, 0, UL, VL);
		}
		break;
	default:
		// up
		C.SetPos(CenterX - bold/2, CenterY - CrossHairSpread);
		C.DrawLine(0, CrossHairLength, bold);

		// down
		C.SetPos(CenterX - bold/2, CenterY + CrossHairSpread + 1);
		C.DrawLine(1, CrossHairLength, bold);

		// left
		C.SetPos(CenterX - CrossHairSpread, CenterY - bold/2);
		C.DrawLine(2, CrossHairLength, bold);

		// right
		C.SetPos(CenterX + CrossHairSpread + 1, CenterY - bold/2);
		C.DrawLine(3, CrossHairLength, bold);
	}
	return true;
}

simulated function bool KFXDrawCFourProgress(Canvas C)
{
	return true;
}

simulated function bool KFXDrawSniperCrossHair(Canvas C)
{
	local float CenterX, CenterY, UL, VL;
	local int OffsetX, OffsetY;
	local int tempcolor;


	CenterX = C.SizeX * 0.5;    //ÌùÍ¼µÄX×ø±ê
	CenterY = C.SizeY * 0.5;    //ÌùÍ¼µÄY×ø±ê
	UL = KFXSniperMaterial.USize;
	VL = KFXSniperMaterial.VSize;
	C.SetPos(SniperX*C.SizeX/1024, SniperY*C.SizeY/768);
	C.SetDrawColor(255, 255, 255, 255);
	C.DrawTile(KFXSniperMaterial, UL*C.SizeX/1024, VL*C.SizeY/768, 0, 0, UL, VL);

	tempcolor = Rand(20)+30;
	C.SetDrawColor(255-tempcolor-20, tempcolor, tempcolor, 255);
	//»æÖÆ¸ÉÈÅÍâ¹ÒµÄºìµã
	OffsetX = Rand(40) - 20;
	OffsetY = Rand(40) - 20;

	C.SetPos(CenterX+OffsetX, CenterY+OffsetY);
	C.DrawLine(3, 1, 1);

	return true;
}

simulated function SetWeapState(byte StateValue)
{
	if(StateValue == 0)
	{
		Weapon.WeaponStateValue = StateValue;
	}
	else
	{
		switch( KFXAltFireState)
		{
		case 0:
			Weapon.WeaponStateValue = StateValue;
			break;
		case 1:
			Weapon.WeaponStateValue = StateValue;
			if(!Viewer.bBehindView)
			{
				Weapon.KFXClientSetZoomLevel(StateValue);
			}
			break;
		case 2:
			Weapon.WeaponStateValue = StateValue;
			break;
		case 3:
			Weapon.WeaponStateValue = StateValue;
			break;
		case 4:
			Weapon.WeaponStateValue = StateValue;
		}
	}
}

simulated function ChangeWeapState(byte StateValue)
{
	switch( KFXAltFireState)
	{
	case 0:
		Weapon.WeaponStateValue = StateValue;
		break;
	case 1:
		Weapon.WeaponStateValue = StateValue;
		if(!Viewer.bBehindView )
		{
			Weapon.KFXClientDoZoom(StateValue);
		}
		break;
	case 2:
		Weapon.WeaponStateValue = StateValue;
		break;
	case 3:
		Weapon.WeaponStateValue = StateValue;
		break;
	case 4:
		if( Weapon.WeaponStateValue == 0 )
		{
			Weapon.bEnterState = true;
			Weapon.EQBeginTime = level.TimeSeconds;
		}
		else
		{
			Weapon.bQuitState = true;
			Weapon.EQBeginTime = level.TimeSeconds;
		}
		Weapon.WeaponStateValue = StateValue;
	}
}

defaultproperties
{
     KFXCrossHairType=-1
     KFXCHColorNormal=(G=255,A=255)
     KFXCHColorEnemy=(R=255,A=255)
     KFXCHColorFriend=(G=255,A=255)
     bHidden=是
     TransientSoundVolume=0.800000
     TransientSoundRadius=40.000000
}
