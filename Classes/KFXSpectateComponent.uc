//-----------------------------------------------------------
//½öÓÃÓÚ¿Í»§¶Ë
//-----------------------------------------------------------
class KFXSpectateComponent extends SpectateWeap;

const NUM_FIRE_MODES = 2;
const NUM_SND_FPFIRE_SC = 4;

var int ComponentTypeID;
var int WeaponPart;
var byte WeapAltFireChangeNum;
var class<Emitter> FireFlashClass; //»ðÃ°×é¼þ×¨ÓÃ»ð»¨Àà
var array<string> PaintTextures; //¸ü¸ÄµÄÌùÍ¼Ãû£¬ÔÝÊ±½öÓÃÓÚÅçÆá£¬µ«ÊÇÒÔºó¿ÉÒÔÓÃÓÚ×é¼þµÄÌùÍ¼¸ü¸Ä
var string  SniperSightStr; //¿ª¾µÌùÍ¼Ãû
var name  FireAnim;
var int KFXZoomLevelMax;
var int KFXZoomlevelMin;

//ÏûÑæÆ÷ÏûÒôÆ÷»ðÃ°Ìí¼Ó²¿·ÖÂß¼­
var bool bShowTrack;           //ÊÇ·ñÏÔÊ¾µ¯Ïß
var bool bShowAnotherFireSound;
var sound KFXSndTPFire[NUM_FIRE_MODES];     // ¿ª»ðÉùÒô
//// Ç°Á½¸öÊÇ×ó¼ü¿ª»ðÒôÐ§£¬ºóÁ½¸öÊÇÓÒ¼ü¿ª»ðÒôÐ§
var sound KFXSndFPFire[NUM_SND_FPFIRE_SC];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
var string KFXSndTPFireString[NUM_FIRE_MODES];
var string KFXSndFPFireString[NUM_SND_FPFIRE_SC];   //µÚÒ»ÈË³Æ¿ª»ðÒôÐ§
//Ë«³ÖÎäÆ÷¹Ò¼þ
var Actor DBComponent;
var int SniperX;
var int SniperY;

simulated function KFXInit(int TypeID,int Part)
{
	local KFXCSVTable CFG_WeaponComponent,CFG_Sound;
	local vector relPos;
	local rotator relRot;
	local vector anoPos;
	local rotator anoRot;
	local float   anoScale;
	local string temstr;
	local int loop;
	local int nTemp;
	ComponentTypeID = TypeID;
	WeaponPart = Part;

	CFG_WeaponComponent = class'KFXTools'.static.GetConfigTable(22);
	CFG_Sound      = class'KFXTools'.static.GetConfigTable(14);
	if( !CFG_WeaponComponent.SetCurrentRow(ComponentTypeID) )
	{
		Log("[WeaponComponent] Can't Resolve ComponentID (component Table): "$ComponentTypeID);
		return;
	}

	WeapAltFireChangeNum = CFG_WeaponComponent.GetInt("FireMode2");

	if(part == 4)
	{
		SniperSightStr = CFG_WeaponComponent.GetString("SniperSightHUD");
		SniperX = CFG_WeaponComponent.GetInt("SniperX");
		SniperY = CFG_WeaponComponent.GetInt("SniperY");
	}

	KFXZoomLevelMax = CFG_WeaponComponent.GetInt("OneSightFOV");
	KFXZoomLevelMin = CFG_WeaponComponent.GetInt("TwoSightFOV");

	temstr = CFG_WeaponComponent.GetString("FPEffect");
	if(temstr != "null" && temstr != "")
	{
		FireFlashClass = class<Emitter>(DynamicLoadObject(temstr,class'Class'));
	}

	FireAnim = CFG_WeaponComponent.GetName("FireAnim");

	//»ñÈ¡Ìæ»»ÌùÍ¼×ÊÔ´Ãû
	PaintTextures.Remove(0,PaintTextures.length);
	skins.Remove(0,skins.length);
	for(loop=0; true; loop++)
	{
		temstr = CFG_WeaponComponent.GetString("FPViewSkin"$loop);
		if(temstr=="")
		{
			break;
		}
		else
		{
			if(Part!=6)
			{
				if(temstr!="null")
                	skins[loop]=Material(DynamicLoadObject(temstr,class'Material',false));
			}
			else
			{
				PaintTextures[PaintTextures.length]= temstr;
			}
		}
	}

	if(Part==6)
	{
		return;
	}

	LinkMesh( mesh(DynamicLoadObject(CFG_WeaponComponent.GetString("FPViewMesh"), class'Mesh')));
    DBComponent = spawn(class'DBWeaponComponent');
    DBComponent.LinkMesh( mesh(DynamicLoadObject(CFG_WeaponComponent.GetString("FPViewMesh"), class'Mesh')));
    log("SpectateComponent-------DBComponent "$DBComponent);

    relPos.X = CFG_WeaponComponent.GetFloat("FPLocationX");
	relPos.Y = CFG_WeaponComponent.GetFloat("FPLocationY");
	relPos.Z = CFG_WeaponComponent.GetFloat("FPLocationZ");
	SetRelativeLocation(relPos);

	relRot.Roll = CFG_WeaponComponent.GetInt("FPRotRoll");
	relRot.Yaw = CFG_WeaponComponent.GetInt("FPRotYaw");
	relRot.Pitch = CFG_WeaponComponent.GetInt("FPRotPitch");
	SetRelativeRotation(relRot);

	log("SpectateComponent relPos"@relPos@"relRot"@relRot);

	SetDrawScale(CFG_WeaponComponent.GetFloat("FPScale"));

    //Ë«Ç¹Åä¼þ
	anoPos.X = CFG_WeaponComponent.GetFloat("AnotherFPLocationX");
	anoPos.Y = CFG_WeaponComponent.GetFloat("AnotherFPLocationY");
	anoPos.Z = CFG_WeaponComponent.GetFloat("AnotherFPLocationZ");
	anoRot.Roll = CFG_WeaponComponent.GetInt("AnotherFPRotRoll");
	anoRot.Yaw = CFG_WeaponComponent.GetInt("AnotherFPRotYaw");
	anoRot.Pitch = CFG_WeaponComponent.GetInt("AnotherFPRotPitch");
	anoScale = CFG_WeaponComponent.GetFloat("AnotherFPScale");

    log("SpectateComponent anoPos"@anoPos@"anoRot"@anoRot$" anoScale:"$anoScale);

    DBComponent.SetRelativeLocation(anoPos);
    DBComponent.SetRelativeRotation(anoRot);
	DBComponent.SetDrawScale(anoScale);

	bShowTrack = CFG_WeaponComponent.GetBool("ShowTrack");
	bShowAnotherFireSound  = CFG_WeaponComponent.GetBool("ShowAnotherFireSound");
	if(bShowAnotherFireSound)
	{
		//Third Person Fire sound
		nTemp = CFG_WeaponComponent.GetInt( "SndTPFire1" );
		log("WeaponComponent-----11--nTemp "$nTemp);
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			log("WeaponComponent-----11--"$CFG_Sound.GetString("ResName"));
			KFXSndTPFireString[0] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndTPFire2" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndTPFireString[1] =CFG_Sound.GetString("ResName");
		}
		//First Person Fire Sound
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire11" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[0] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire12" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[2] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire21" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[1] = CFG_Sound.GetString("ResName");
		}
		nTemp = CFG_WeaponComponent.GetInt( "SndFPFire22" );
		if ( nTemp != 0 && CFG_Sound.SetCurrentRow(nTemp) )
		{
			KFXSndFPFireString[3] = CFG_Sound.GetString("ResName");
		}
		log("WeaponComponent---------KFXSndTPFireString[0] "$KFXSndTPFireString[0]
		$"KFXSndTPFireString[1] :"$KFXSndTPFireString[1]
		$"KFXSndFPFireString[0] :"$KFXSndFPFireString[0]
		$"KFXSndFPFireString[2] :"$KFXSndFPFireString[2]
		$"KFXSndFPFireString[1] :"$KFXSndFPFireString[1]
		$"KFXSndFPFireString[3] :"$KFXSndFPFireString[3]);
	}
	log("SpectateComponent-----bShowTrack: "$bShowTrack$"bShowAnotherFireSound: "$bShowAnotherFireSound);
}

defaultproperties
{
     DrawType=DT_Mesh
     bOnlyDrawIfAttached=是
}
