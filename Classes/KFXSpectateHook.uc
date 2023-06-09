class KFXSpectateHook extends Actor;

var KFXPlayer Viewer;						// ±¾µØcontroller
var KFXPawn ViewTarget;

var class<ScoreBoard>	CheatScoreBoardClass;

// ÎäÆ÷Ïà¹ØÐÅÏ¢
var KFXSpectateWeap CurSpectateWeap;  			// µ±Ç°Ä£ÄâµÄµÚÒ»ÈË³ÆÎäÆ÷
var array<KFXSpectateWeap> SpectateWeapList;    // Ä£ÄâµÚÒ»ÈË³ÆÎäÆ÷ÁÐ±í
var array<KFXSpectateComponent> SpectateCompList; //Ä£ÄâµÚÒ»ÈË³ÆÎäÆ÷×é¼þÁÐ±í

var KFXWeapBase RealWeapon;				// ÕæÕý¹´×¡µÄÎäÆ÷- -  £¨·þÎñÆ÷¿É·ÃÎÊ£©
var KFXWeapAttachment RealWeapAttachment; //ÕæÎäÆ÷ÔÚ¿Í»§¶Ë¶ÔÓ¦µÄattachment £¨·þÎñ¶ËºÍ¿Í»§¶Ë¿É·ÃÎÊ£©
var KFXPlayerReplicationInfo VieweePRI;    //±»¹Û²ìÕßµÄPRI £¨·þÎñ¶ËºÍ¿Í»§¶Ë¿É·ÃÎÊ£©

// ÐèÒªÍ¬²½µÄÊý¾Ý
var int KFXCheatAmmoCount;               // µ±Ç°×Óµ¯ÐÅÏ¢
var int KFXCheatReload;

// ÎÞÐèÍ¬²½µÄÊý¾Ý
var byte KFXFireMode;

replication
{
	reliable if( Role == ROLE_Authority && bNetDirty /*&& bNetOwner*/ )
		KFXCheatAmmoCount, KFXCheatReload,
		VieweePRI;
}

simulated function PreBeginPlay()
{
	if ( Level.NetMode == NM_DedicatedServer )
	{
	}
	else
	{
		Viewer = KFXPlayer(level.GetLocalPlayerController());
	}
}

//ÇÐ»»ÎäÆ÷
simulated function ClientChangeWeapon(KFXWeapAttachment WeapAttachment)
{
    if( Role < Role_Authority )
    {
        log("[KFXSpectateHook] ClientChangeWeapon WeapAttachment is"@WeapAttachment.KFXWeaponID);
        if( RealWeapAttachment == WeapAttachment )
        {
            log("[KFXSpectateHook] ClientChangeWeapon RealWeapAttachment is"@RealWeapAttachment.KFXWeaponID);
            return;
        }
        ClientSetWeapon(WeapAttachment);
        CurSpectateWeap.PlayChangeWeapon();
    }
}

//µ±Ç°ViewTargetµÄweapon»»µ¯Ê±
simulated function ClientPlayReload()
{
    if(CurSpectateWeap != none)
	{
		CurSpectateWeap.PlayReload();
	}
}

//µ±Ç°ViewTargetµÄweapon¿ª»ðÊ±
simulated function ClientPlayFire(byte fireMode)
{
    KFXFireMode = fireMode;
	if(CurSpectateWeap != none)
	{
		CurSpectateWeap.PlayFire();
	}
}

simulated function Destroyed()
{
    local int loop;
    ;
	for(loop =0; loop < SpectateWeapList.Length ; loop++)
    {
        SpectateWeapList[loop].Destroy();
    }

    for(loop =0; loop < SpectateCompList.Length ; loop++)
    {
        SpectateCompList[loop].Destroy();
    }
	super.Destroyed();
}

function ServerChangeViewTarget(KFXPawn pawn)
{
    ViewTarget = pawn;
}

simulated function Tick(float DeltaTime)
{
	//local KFXPawn P;
	local KFXWeapAttachment ViewWeapAttach;
	//local int loop;

	if( Level.NetMode == NM_DedicatedServer )
	{
        //½öÓÃÓÚ·þÎñ¶ËRealWeaponµÄ¸Ä±ä£¬¿Í¹Û¶Ë¶ÔÓ¦µÄSpectateWeapÊ¹ÓÃÁíÍâµÄÂß¼­
        if(ViewTarget != none)
        {
            RealWeapon = KFXWeapBase(ViewTarget.Weapon);
            RealWeapAttachment = ViewTarget.WeaponAttachment;
        }

		if (RealWeapon != none)
		{
			KFXCheatAmmoCount = RealWeapon.KFXGetAmmo();
			KFXCheatReload = RealWeapon.KFXGetReload();
		}
		else
		{
		    KFXCheatAmmoCount = 0;
			KFXCheatReload = 0;
        }
	}

	if( Level.NetMode == NM_Client)
	{
	    if( ViewTarget != KFXPawn(Viewer.ViewTarget))
	    {
	       //ViewTarget.bHidden = false;
	       //ViewTarget.AvatarLegs.bHidden=false;
           ViewTarget = KFXPawn(Viewer.ViewTarget) ;
        }
        if(ViewTarget != none)
        {
        ViewWeapAttach = ViewTarget.WeaponAttachment;
        }
        else
        {
            ViewWeapAttach = none;
        }
    	if( RealWeapAttachment != ViewWeapAttach || (CurSpectateWeap == none && ViewWeapAttach != none))
    	{
            //¶ÔÓÚ¹Û²ìÕßÇÐ»»¹Û²ìÄ¿±ê£¬ÒÔ¼°ÆäËûÇé¿ö£¬Ê¹¹Û²ìµ½µÄÎäÆ÷Ò²¶ÔÓ¦¸Ä±ä£¬
            //¶ÔÓÚÕâÖÖ²¢·Ç»»Ç¹ÒýÆðµÄÎäÆ÷±ä»¯£¬ÔÚ´Ë´¦½øÐÐµÚÒ»ÈË³ÆÄ£ÄâÎäÆ÷µÄ¸Ä±ä
            log("RealWeapAttachment is"@RealWeapAttachment@"ViewWeapAttach"@ViewWeapAttach);
            if(ViewWeapAttach != none)
            {
                ClientSetWeapon(ViewWeapAttach);
            }
        }
        if(CurSpectateWeap != none)
        CurSpectateWeap.UpdateWeaponState(RealWeapAttachment);
    }
}

simulated function ClientSetWeapon(KFXWeapAttachment WeapAttach )
{
    local int loop1;
    local int loop2;
    local KFXSpectateComponent Component;

    RealWeapAttachment = WeapAttach;
    if(RealWeapAttachment == none)
    {
        
        CurSpectateWeap = none;
        return;
    }

    //Èç¹ûµ±Ç°ÕýÊ¹ÓÃÄ£ÄâÎäÆ÷£¬µ«ÐÂÄ£ÄâÎäÆ÷Óëµ±Ç°µÄ²»Í¬£¬ÔòÒªÇåÀíµ±Ç°Ä£ÄâÎäÆ÷,°Ñ×é¼þ²ðµô£¬ÒÔ±ãÓÚÕâÐ©×é¼þ±»±ðµÄÎäÆ÷ÖØÐÂÀûÓÃ
    if(CurSpectateWeap != none && CurSpectateWeap.KFXWeaponID != RealWeapAttachment.KFXWeaponID)
    {
        for(loop1 = 0; loop1 < 6; loop1++)
        {
            CurSpectateWeap.SetWeapComponent(none,loop1+1);
        }
        CurSpectateWeap = none;
    }
    //Èç¹ûµ±Ç°ÎäÆ÷Îª¿Õ£¬»òÕßÆäËûÔ­ÒòÖÃ¿Õ
    if( CurSpectateWeap == none )
    {
        for(loop1 = 0; loop1 < SpectateWeapList.Length; loop1++)
        {
            if( RealWeapAttachment.KFXWeaponID == SpectateWeapList[loop1].KFXWeaponID)
            {
                CurSpectateWeap = SpectateWeapList[loop1];
                break;
            }
        }
        if(CurSpectateWeap == none)
        {
            CurSpectateWeap = Spawn(class<KFXSpectateWeap>(
                DynamicLoadObject("KFXGame.KFXSpectateWeap",
				class'Class')),
				self
				);
        	if (CurSpectateWeap != none)
        	{
        		CurSpectateWeap.SpectateHook = self;
        		CurSpectateWeap.KFXInit(RealWeapAttachment.KFXWeaponID);
        		SpectateWeapList[SpectateWeapList.Length]=CurSpectateWeap;
        	}
        	if(Level.NetMode == NM_Client)
        	{
        	    log("KFXSpetateHook--------ViewTarget "$ViewTarget);
        	    log("KFXSpetateHook--------ViewTarget.bIsFemale "$ViewTarget.bIsFemale);

                if(ViewTarget != none && ViewTarget.bIsFemale)
        	    {
                    CurSpectateWeap.GetFemaleWeaponMesh();
                }
            }
        }
    }

    //ÖØÖÃÃ¿¸ö×é¼þ
    for(loop1 = 0; loop1 < 6; loop1++)
    {
        if(RealWeapAttachment.ComponentID[loop1]!=0)
        {
            for(loop2 =0; loop2 < SpectateCompList.Length ; loop2++)
            {
                if( SpectateCompList[loop2].ComponentTypeID == RealWeapAttachment.ComponentID[loop1])
                {
                    Component = SpectateCompList[loop2];
                    break;
                }
            }

            if(Component != none)
            {
                CurSpectateWeap.SetWeapComponent(Component,loop1+1);
                Component = none;
            }
            else
            {
                Component = Spawn(class<KFXSpectateComponent>(
                    DynamicLoadObject("KFXGame.KFXSpectateComponent",
    				class'Class')),
    				self
    				);
            	if (Component != none)
            	{
            		Component.KFXInit(RealWeapAttachment.ComponentID[loop1],loop1+1);
            		SpectateCompList[SpectateCompList.Length] = Component;
            	}
            	CurSpectateWeap.SetWeapComponent(Component,loop1+1);
                Component = none;

            }
        }
        else
        {
            CurSpectateWeap.SetWeapComponent(none,loop1+1);
        }

    }

    CurSpectateWeap.SetRelation();
    //ÓÉÓÚÎäÆ÷±¾ÉíºÍ×é¼þ¶¼»á¶ÔÎäÆ÷µÄ¹ÌÓÐÊôÐÔÔì³ÉÓ°Ïì£¬¶ø×´Ì¬ÓëÎäÆ÷ÀàÐÍ¡¢¹ÌÓÐÊôÐÔÏà¹Ø£¬ËùÒÔÔÚ×îºóÉèÖÃ×´Ì¬
    CurSpectateWeap.InitWeaponState( RealWeapAttachment );

}

simulated function AngleChanged(bool bFirstAngle)
{
    CurSpectateWeap.AngleChanged(bFirstAngle);
}


simulated function int KFXGetAmmo()
{
    return KFXCheatAmmoCount;
}

simulated function int KFXGetReload()
{
    return KFXCheatReload;
}

defaultproperties
{
     bHidden=是
     bOnlyRelevantToOwner=是
     RemoteRole=ROLE_SimulatedProxy
     bNetNotify=是
}
