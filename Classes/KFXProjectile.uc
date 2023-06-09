// ====================================================================
//  Class:  KFXWeapons.KFXProjectile
//  Creator: Kevin Sun
//  Date: 2007.03.27
//  Description: KFXProjectile
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXProjectile extends Projectile
    dependson(KFXFireBase);

var     float       ExplodeTimer;
var     int         HitTimesLimit;
var     int         HitTimes;
var     bool        bCanHitOwner, bHitWater, bCanHitPawn;
var     xEmitter    Trail;
var     Emitter     ETrail;
var     float       DampenFactor, DampenFactorParallel;
var     class<xEmitter> HitEffectClass;
var     float       LastSparkTime;
var     bool        bTimerSet;
var     bool        bCollisionSetTimer;

var     sound       BombSound;		// sound when projectile Bomb
var     sound       BombWaterSound; // sound when projectile Bomb in water

var     class<Emitter> BombEffectClass;
var     class<Emitter> BombWaterEffectClass;
var     class<xEmitter> TrailEffectClass;
var     class<Emitter> ETrailEffectClass;

//------------------------------------------------------------------------
var float   PendingDestroyTime;

var     int         KFXWeaponID;        // ÎäÆ÷ID
var     int         KFXProjectileID;    // PJ ID

var     float       KFXArmorPct;        // ´©¼×ÏµÊý
var     int         KFXDmgShakeView;    // ÉËº¦ÊÓ½ÇÕð¶¯
var     KFXFireBase.KFXPBDamageInfo  KFXPBDamageType;

///»¤¼×¼õÃâÏµÊýÊý×é´óÐ¡
const KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM = 2;  //< KFX_WPN_AMMORREDUCEPCT_LEVEL_NUM * KFX_WPN_AMMORREDUCEPCT_CLASSIC_NUM
var float KFXArmorWeaponPct[KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM];
///´©¼×ÏµÊý
var float KFXDmgArmorPct[KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM];

//--------Ä£ÐÍ¸´ÓÃ»úÖÆ
var bool bManuFixed;

//---------------------
replication
{
    reliable if (Role==ROLE_Authority && bNetDirty)
        ExplodeTimer, KFXProjectileID, KFXWeaponID;
}

// Server & Client Shared
simulated function KFXInit()
{
    local KFXCSVTable CFG_Proj;
    local string MeshName, TextureName;
    local int loop;

    ;

    if ( KFXProjectileID == 0 )
    {
        Log("[Projectile] Error! Projectile ID didn't Initialized !");
        return;
    }

    CFG_Proj = class'KFXTools'.static.GetConfigTable(20);

    if ( !CFG_Proj.SetCurrentRow(KFXProjectileID) )
    {
        Log("[Projectile] Can't Resolve The Projectile ID (Projectile Table): "$KFXProjectileID);
        return;
    }

    // Init Shared
    Speed               = CFG_Proj.GetFloat("Speed");
    MaxSpeed            = CFG_Proj.GetFloat("MaxSpeed");
    Acceleration.Z      = CFG_Proj.GetFloat("Gravity");
    MomentumTransfer    = CFG_Proj.GetFloat("Transfer");
    ExplodeTimer        = CFG_Proj.GetFloat("ExplodeTime");
    DampenFactor        = CFG_Proj.GetFloat("DampenFactor");
    DampenFactorParallel= CFG_Proj.GetFloat("DampenFactorParallel");
    bBounce             = CFG_Proj.GetBool("bBounce");
    bManuFixed          = CFG_Proj.GetBool("ManuFix");
    PendingDestroyTime  = CFG_Proj.GetFloat("PendingDestroyTime");


    if ( ExplodeTimer == 0 )
        LifeSpan = 0;
    else
        LifeSpan = ExplodeTimer + PendingDestroyTime + 5;

    if ( Role == ROLE_Authority )
    {
        Velocity = Vector(Rotation) * Speed;

        if (Instigator != none && Instigator.HeadVolume.bWaterVolume)
        {
            bHitWater = true;
            Velocity = 0.6*Velocity;
        }
    }

    // Init Client
    if ( Level.NetMode != NM_DedicatedServer )
    {
        SetDrawScale(CFG_Proj.GetFloat("DrawScale"));

        MeshName = CFG_Proj.GetString("Mesh");

        if ( !(MeshName ~= "null") )
        {
            LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );
            BoneRefresh();
        }
        if ( bManuFixed )
        {
            for ( loop = 0; loop < 2; loop++ )
            {
                TextureName = CFG_Proj.GetString("Texture"$loop);
                if ( TextureName != "none" )
                {
                    skins.Insert( skins.Length, 1 );
                    skins[loop] = material(DynamicLoadObject( TextureName, class'material' ));
                }
                else
                break;
            }
        }
    }

    if ( !bCollisionSetTimer )
    {
        ;
        SetTimer(ExplodeTimer, false);
//        if(KFXWeaponID >> 16 == 52)             //¸ß±¬À×¿Í»§¶ËºÍ·þÎñÆ÷±¬Õ¨Ê±¼ä²»Ò»ÖÂ
//        {
//            if(Role < Role_Authority)
//            {
//                SetTimer(ExplodeTimer - 1, false);      //¿Í»§¶Ë±¬Õ¨±È·þÎñÆ÷¼õÉÙÒ»Ãë
//            }
//            else
//            {
//                SetTimer(ExplodeTimer, false);
//            }
//        }
//        else
//        {
//            SetTimer(ExplodeTimer, false);
//        }
        bTimerSet = true;
    }

    KFXInitClientEffect();
}

simulated function Destroyed()
{
//    log("KFXProjectile-----Destroyed---Level.TimeSeconds "$Level.TimeSeconds);
    if ( Trail != None )
        Trail.mRegen = false; // stop the emitter from regenerating
    if ( ETrail != None )
        ETrail.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
//	local PlayerController PC;

    //Velocity = Vector(Rotation);
    log("KFXProjectile------PostBeginPlay------Level.TimeSeconds "$Level.TimeSeconds);
    Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer)
    {
//		PC = Level.GetLocalPlayerController();
//		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5500 )
//		{
//            if ( TrailEffectClass != none )
//            {
//                Trail = Spawn(TrailEffectClass, self,, Location, Rotation);
//            }
//            else if ( ETrailEffectClass != none )
//            {
//                ETrail = Spawn(ETrailEffectClass, self,, Location, Rotation);
//                AttachToBone(ETrail,'');
//            }
//		}


		if ( SpawnSound != none )
		{
            PlaySound(SpawnSound, SLOT_None, 1.0, true, 1000,, false  );
        }
    }


    //Velocity = Speed * Vector(Rotation);
    //RandSpin(25000);

    /*
    if (Instigator != none && Instigator.HeadVolume.bWaterVolume)
    {
        bHitWater = true;
        Velocity = 0.6*Velocity;
    }
    */
}

simulated function PostNetBeginPlay()
{
    // KFX Projectile Init
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( Role < ROLE_Authority )
            KFXInit();

        if ( Physics == PHYS_None )
        {
            log("KFXProjectile-------PostNetBeginPlay------Explode");
            Explode( Location, -vector(Rotation) );
        }
    }
}

simulated function Timer()
{
//    log("KFXProjcetile----- Timer----Explode");
    Explode(Location, vect(0,0,1));
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, none );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
    if ( !Other.bWorldGeometry && (Other != Instigator || bCanHitOwner) )
    {
        ;
        log("KFXProjectile------left(string(Other),29) "$left(string(Other),29));
        log("KFXProjectile-----bCanHitPawn"$bCanHitPawn);
        if (left(string(Other),29)~="XunLianGuan.KFXTutorialObject")
            Explode(HitLocation, Normal(vect(0.0,1.0,0.0)));
        else if (bCanHitPawn)
	        Explode(HitLocation, Normal(HitLocation-Other.Location));
		else
		    HitWall(Normal(HitLocation-Other.Location), Other);
    }
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    local Vector VNorm;
	local PlayerController PC;

	HitTimes++;
//    log("KFXProjcetile----- Timer----HitTimes "$HitTimes);
//    log("KFXProjcetile----- Timer----HitTimesLimit "$HitTimesLimit);
	if ( HitTimes >= HitTimesLimit )
	{
        Explode(Location, HitNormal);
		return;
	}

    // Reflect off Wall damping
    VNorm = (Velocity dot HitNormal) * HitNormal;
    Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

    RandSpin(100000);
    DesiredRotation.Roll = 0;
    RotationRate.Roll = 0;
    Speed = VSize(Velocity);

    if ( Speed < 20 )
    {
        bBounce = False;
        PrePivot.Z = -1.5;
		SetPhysics(PHYS_None);
		DesiredRotation = Rotation;
		DesiredRotation.Roll = 0;
		DesiredRotation.Pitch = 0;
		SetRotation(DesiredRotation);
        if ( Trail != None )
            Trail.mRegen = false; // stop the emitter from regenerating
        if ( ETrail != None )
            ETrail.Destroy();
    }
    else
    {
		if ( (Level.NetMode != NM_DedicatedServer) && (Speed > 250) )
		{
            PlayImpact(HitNormal);
		}
		else
		{
			bFixedRotationDir = false;
			bRotateToDesired = true;
			DesiredRotation.Pitch = 0;
			RotationRate.Pitch = 50000;
		}
        if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) && (Level.TimeSeconds - LastSparkTime > 0.5) && EffectIsRelevant(Location,false) )
        {
			PC = Level.GetLocalPlayerController();
			if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
				Spawn(HitEffectClass,,, Location, Rotator(HitNormal));
            LastSparkTime = Level.TimeSeconds;
        }
    }
}

simulated function PlayImpact(vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_Misc,
    TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
    TransientSoundRadius*0.5*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false  );
}

simulated function BlowUp(vector HitLocation)
{
	DelayedHurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local vector Offset;
    local vector HitLoc, HitNorm;
    local material mat;
    local Actor  Effect;

    ;

    //if ( Role == ROLE_Authority )
        BlowUp(HitLocation);

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( /*EffectIsRelevant(Location,false)*/ true )
        {
            // Spawn Emitter
    		Offset = 50 * HitNormal;
            Trace(HitLoc, HitNorm, HitLocation-Offset,HitLocation+Offset, false, ,mat);

            // Water mat
            if ( mat != none && mat.SurfaceType == EST_Water && BombWaterEffectClass != none )
            {
                if (BombWaterSound != none)
                    PlaySound(BombWaterSound,SLOT_Misc,
                            TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
                            TransientSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,false);
                else
                     PlaySound(BombSound,SLOT_None,
                            TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
                            TransientSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,true);

                Effect = Spawn(BombWaterEffectClass,,, HitLocation, rotator(vect(0,0,1)));
                AttachToBone(Effect,'');
            }
            // Other Mat
            else
            {
                PlaySound(BombSound,SLOT_None,
                TransientSoundVolume*KFXPlayer(Level.GetLocalPlayerController()).GetSoundVolumeFactor(0),,
                TransientSoundRadius*KFXPlayer(Level.GetLocalPlayerController()).GetSoundRadiusFactor(0),,true);

                Effect = Spawn(BombEffectClass,,, HitLocation, rotator(vect(0,0,1)));
                AttachToBone(Effect,'');
                // Spawn Scorch
                Spawn(ExplosionDecal, self,,HitLocation + 10*HitNormal, rotator(-HitNormal));
            }
        }
        log("KFXProjectilr   PendingDestroyTime:"$PendingDestroyTime);
        if ( PendingDestroyTime > 0 )
        {
            GotoState('PendingDestory');
        }
        else
        {
            Destroy();
        }
    }
    else
    {
        GotoState('PendingDestory');
    }
}

/* HurtRadius()
 Hurt locally authoritative actors within the radius.
 extends Projectile
*/
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local int loop;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;

	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{

		    // Set KFXDamageInfo.
            if ( KFXPawn(Victims) != none )
            {
                KFXPawn(Victims).KFXDmgInfo.WeaponID = KFXWeaponID;
                KFXPawn(Victims).KFXDmgInfo.ArmorPct = KFXArmorPct;
                KFXPawn(Victims).KFXDmgInfo.bAutoAim = 0;
                KFXPawn(Victims).KFXDmgInfo.HitBoxID = 0;
                KFXPawn(Victims).KFXDmgInfo.DmgShakeView = KFXDmgShakeView;

                ///Ïò½ÇÉ«´«µÝ»¤¼×ÐÅÏ¢
                for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
                {
                    KFXPawn(Victims).KFXArmorWeaponPct[loop] = KFXArmorWeaponPct[loop];
                }
                for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
                {
                    KFXPawn(Victims).KFXDmgArmorPct[loop] = KFXDmgArmorPct[loop];
                }
            }
            else if ( KFXVehiclesBase(Victims) != none )
            {
                KFXVehiclesBase(Victims).KFXDmgInfo.WeaponID = KFXWeaponID;
                KFXVehiclesBase(Victims).KFXDmgInfo.ArmorPct = KFXArmorPct;
                KFXVehiclesBase(Victims).KFXDmgInfo.bAutoAim = 0;
                KFXVehiclesBase(Victims).KFXDmgInfo.HitBoxID = 0;
                KFXVehiclesBase(Victims).KFXDmgInfo.DmgShakeView = KFXDmgShakeView;
            }

			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;

			// ÉËº¦Ë¥¼õµ÷Õû
			if ( Abs(dist - Victims.CollisionRadius) <= 400 )
			{
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			}
			else
			{
            	damageScale = FMax(0,(1 - Sqrt(Abs(dist - Victims.CollisionRadius)) / Sqrt(DamageRadius)));
			}
		    ;


            if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;

    		if( KFXPawn(Victims) != none&&KFXPawn(Victims).CanPassRadiusDamage() )
            {}
            else
			Victims.TakeDamage
			(
				damageScale * DamageAmount * KFXPawn(Victims).KFXBombPrevent,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			
			if(KFXPawn(Victims)!=none && KFXPlayer(KFXPawn(Victims).Controller)!=none)
			{
				KFXPlayer(KFXPawn(Victims).Controller).KFXDamageNoise(damageScale * DamageAmount * KFXPawn(Victims).KFXBombPrevent);
			}
		    ;

			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

            // Clear KFXDamageInfo.
            if ( KFXPawn(Victims) != none )
            {
                // Take PB Damage
                if ( KFXPBDamageType.BitState >= 0 && Role == ROLE_Authority )
                    KFXPawn(Victims).KFXTakePBDamage(Instigator, DamageType,
                        KFXPBDamageType.BitState, KFXPBDamageType.Timer,
                        KFXPBDamageType.Param1, KFXPBDamageType.Param2);

                KFXPawn(Victims).KFXDmgInfo.WeaponID = 0;
                KFXPawn(Victims).KFXDmgInfo.ArmorPct  = 0;
                KFXPawn(Victims).KFXDmgInfo.bAutoAim = 0;
                KFXPawn(Victims).KFXDmgInfo.HitBoxID = 0;
                KFXPawn(Victims).KFXDmgInfo.DmgShakeView = 0;

                ///»¤¼×ÐÅÏ¢¹é0
                for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
                {
                    KFXPawn(Victims).KFXArmorWeaponPct[loop] = 0;
                }
                for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
                {
                    KFXPawn(Victims).KFXDmgArmorPct[loop] = 0;
                }
            }
            else if ( KFXVehiclesBase(Victims) != none )
            {
                KFXVehiclesBase(Victims).KFXDmgInfo.WeaponID = KFXWeaponID;
                KFXVehiclesBase(Victims).KFXDmgInfo.ArmorPct = KFXArmorPct;
                KFXVehiclesBase(Victims).KFXDmgInfo.bAutoAim = 0;
                KFXVehiclesBase(Victims).KFXDmgInfo.HitBoxID = 0;
                KFXVehiclesBase(Victims).KFXDmgInfo.DmgShakeView = KFXDmgShakeView;
            }
		}
	}
	if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
	{
	   	Victims = LastTouched;
		LastTouched = None;

		;

    	// Set KFXDamageInfo.
        if ( KFXPawn(Victims) != none )
        {
            KFXPawn(Victims).KFXDmgInfo.WeaponID = KFXWeaponID;
            KFXPawn(Victims).KFXDmgInfo.ArmorPct = KFXArmorPct;
            KFXPawn(Victims).KFXDmgInfo.bAutoAim = 0;
            KFXPawn(Victims).KFXDmgInfo.HitBoxID = 0;
            KFXPawn(Victims).KFXDmgInfo.DmgShakeView = KFXDmgShakeView;

            ///Ïò½ÇÉ«´«µÝ»¤¼×ÐÅÏ¢
            for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
            {
                KFXPawn(Victims).KFXArmorWeaponPct[loop] = KFXArmorWeaponPct[loop];
            }
            for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
            {
                KFXPawn(Victims).KFXDmgArmorPct[loop] = KFXDmgArmorPct[loop];
            }

        }
        else if ( KFXVehiclesBase(Victims) != none )
        {
            KFXVehiclesBase(Victims).KFXDmgInfo.WeaponID = KFXWeaponID;
            KFXVehiclesBase(Victims).KFXDmgInfo.ArmorPct = KFXArmorPct;
            KFXVehiclesBase(Victims).KFXDmgInfo.bAutoAim = 0;
            KFXVehiclesBase(Victims).KFXDmgInfo.HitBoxID = 0;
            KFXVehiclesBase(Victims).KFXDmgInfo.DmgShakeView = KFXDmgShakeView;
        }

		dir = Victims.Location - HitLocation;
		dist = FMax(1,VSize(dir));
		dir = dir/dist;
		damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
//        damageScale = FMax(0,(1 - Sqrt(Abs(dist - Victims.CollisionRadius)) / Sqrt(DamageRadius)));
		if ( Instigator == None || Instigator.Controller == None )
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		if( KFXPawn(Victims) != none&&KFXPawn(Victims).CanPassRadiusDamage() )
        {}
        else if ( KFXPawn(Victims) != none )
        Victims.TakeDamage
		(
			damageScale * DamageAmount * KFXPawn(Victims).KFXBombPrevent,
			Instigator,
			Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
			(damageScale * Momentum * dir),
			DamageType
		);
		if(KFXPawn(Victims)!=none && KFXPlayer(KFXPawn(Victims).Controller)!=none)
		{
			KFXPlayer(KFXPawn(Victims).Controller).KFXDamageNoise(damageScale * DamageAmount * KFXPawn(Victims).KFXBombPrevent);
		}

		if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

	    // Clear KFXDamageInfo.
        if ( KFXPawn(Victims) != none )
        {
            // Take PB Damage
            if ( KFXPBDamageType.BitState >= 0 && Role == ROLE_Authority )
                KFXPawn(Victims).KFXTakePBDamage(Instigator, DamageType,
                    KFXPBDamageType.BitState, KFXPBDamageType.Timer,
                    KFXPBDamageType.Param1, KFXPBDamageType.Param2);

            KFXPawn(Victims).KFXDmgInfo.WeaponID = 0;
            KFXPawn(Victims).KFXDmgInfo.ArmorPct  = 0;
            KFXPawn(Victims).KFXDmgInfo.bAutoAim = 0;
            KFXPawn(Victims).KFXDmgInfo.HitBoxID = 0;
            KFXPawn(Victims).KFXDmgInfo.DmgShakeView = 0;

            ///»¤¼×ÐÅÏ¢¹é0
            for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
            {
                KFXPawn(Victims).KFXArmorWeaponPct[loop] = 0;
            }
            for ( loop=0; loop<KFX_WPN_ARMORREDUCEPCT_TOTLE_NUM; loop++ )
            {
                KFXPawn(Victims).KFXDmgArmorPct[loop] = 0;
            }

        }
        else if ( KFXVehiclesBase(Victims) != none )
        {
            KFXVehiclesBase(Victims).KFXDmgInfo.WeaponID = KFXWeaponID;
            KFXVehiclesBase(Victims).KFXDmgInfo.ArmorPct = KFXArmorPct;
            KFXVehiclesBase(Victims).KFXDmgInfo.bAutoAim = 0;
            KFXVehiclesBase(Victims).KFXDmgInfo.HitBoxID = 0;
            KFXVehiclesBase(Victims).KFXDmgInfo.DmgShakeView = KFXDmgShakeView;
        }
	}

	bHurtEntry = false;
}

simulated function KFXDamageNoise()
{
    local KFXPlayer pc;
    local float dist;
    
    return;

    pc = KFXPlayer(level.GetLocalPlayerController());

    if ( pc.Pawn != none )
    {
        // calc flash
        dist = VSize(pc.Pawn.Location - Location);

        if ( dist > 1200 )
            return;

        pc.KFXDamageNoise( 100 - dist * 0.04 );
    }
}

state PendingDestory
{
    simulated function BeginState()
    {
        log("PendingDestory BeginState Settimer PendingDestroyTime:"$PendingDestroyTime);
        if ( Level.NetMode == NM_DedicatedServer )
        {
            SetTimer(PendingDestroyTime + 0.5, false);
        }
        else
        {
            SetTimer(PendingDestroyTime, false);
        }
    }

    simulated function Timer()
    {
//        log("KFXProjectile-------Destroy");
        if ( Level.NetMode == NM_DedicatedServer )
        {
            SetPhysics(PHYS_None);
            Destroy();
        }
        else
        {
            Destroy();
        }
    }

    simulated function Explode(vector HitLocation, vector HitNormal)
    {
    }

    simulated singular function Touch(Actor Other)
    {
    }
}

// ³õÊ¼»¯ÊÖÀ×ÌØÐ§¡¢ÒôÐ§£¨¶Á±íÊµÏÖ£©
simulated function KFXInitClientEffect()
{
    local KFXCSVTable CFG_Proj;
    local string TempStr;

    if ( Level.NetMode == NM_DedicatedServer )
    {
    	return;
    }

    if ( KFXProjectileID == 0 )
    {
        Log("[Projectile] Error! Projectile ID didn't Initialized !");
        return;
    }

    CFG_Proj = class'KFXTools'.static.GetConfigTable(20);

    if ( !CFG_Proj.SetCurrentRow(KFXProjectileID) )
    {
        Log("[Projectile] Can't Resolve The Projectile ID (Projectile Table): "$KFXProjectileID);
        return;
    }

    // »ñÈ¡ÌØÐ§×ÊÔ´
    TempStr = CFG_Proj.GetString("BombEffect");
    if ( TempStr != "none" )
    {
    	BombEffectClass = class<Emitter>(DynamicLoadObject( TempStr, class'Class' ));
    }
    TempStr = CFG_Proj.GetString("BombWaterEffect");
    if ( TempStr != "none" )
    {
    	BombWaterEffectClass = class<Emitter>(DynamicLoadObject( TempStr, class'Class' ));
    }
    TempStr = CFG_Proj.GetString("XTrailEffect");
    if ( TempStr != "none" )
    {
    	TrailEffectClass = class<xEmitter>(DynamicLoadObject( TempStr, class'Class' ));
    }
    TempStr = CFG_Proj.GetString("TrailEffect");
    if ( TempStr != "none" )
    {
    	ETrailEffectClass = class<Emitter>(DynamicLoadObject( TempStr, class'Class' ));
    }

    // »ñÈ¡ÒôÐ§×ÊÔ´

    TempStr = CFG_Proj.GetString("BombSound");
    if ( TempStr != "none" )
    {
    	BombSound = sound(DynamicLoadObject( TempStr, class'Sound' ));
    }

    log("KFXProjectile--------BombSound  "$BombSound);

    TempStr = CFG_Proj.GetString("BombWaterSound");
    if ( TempStr != "none" )
    {
    	BombWaterSound = sound(DynamicLoadObject( TempStr, class'Sound' ));
    }

    TempStr = CFG_Proj.GetString("ExplosionDecal");

    if ( TempStr != "none" )
    {
    	ExplosionDecal = class<Projector>(DynamicLoadObject( TempStr, class'Class' ));
    }

    KFXPlayTrailEffect();
}

simulated function KFXPlayTrailEffect()
{
	local PlayerController PC;

	if ( Level.NetMode != NM_DedicatedServer)
    {
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5500 )
		{
	        if ( TrailEffectClass != none )
	        {
	            Trail = Spawn(TrailEffectClass, self,, Location, Rotation);
	        }
	        else if ( ETrailEffectClass != none )
	        {
	            ETrail = Spawn(ETrailEffectClass, self,, Location, Rotation);
	            AttachToBone(ETrail,'');
	        }
		}
	}
}

defaultproperties
{
     ExplodeTimer=2.000000
     HitTimesLimit=1000
     MaxSpeed=0.000000
     MyDamageType=Class'KFXGame.KFXDamageType'
     Physics=PHYS_Falling
     TransientSoundVolume=1.000000
     TransientSoundRadius=1000.000000
     bBounce=是
     bFixedRotationDir=是
     DesiredRotation=(Pitch=65536,Yaw=16384,Roll=8192)
}
