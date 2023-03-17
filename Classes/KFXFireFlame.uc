//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXFireFlame extends KFXFireBase;

var class<XEmitter>  FlameClass;
var class<Emitter>   FlameCollideFogEffectClass;
var class<Emitter>   FlameNormalFogEffectClass;
var class<Emitter>   EmitterFlameEffectClass;

var XEmitter         FlameEffect;
var Emitter          FlameCollideFogEffect;
var Emitter          FlameNormalFogEffect;
var float            DamagePersecond;
var Emitter          EmiterFlameEffect;
var float           EmitterFlameSpeed;
var float            EmitterFlameLifeTime;

simulated function csvKFXInit(int FireModeID)
{
	local KFXCSVTable CFG_FireMode;

    super.csvKFXInit(FireModeID);

    CFG_FireMode    = class'KFXTools'.static.GetConfigTable(12);
	if ( !CFG_FireMode.SetCurrentRow(FireModeID) )
	{
		Log("[Kevin] Can't Resolve The Weapon ID (Fire Mode Table): "$FireModeID);
		return;
	}

    DamagePersecond = CFG_FireMode.GetFloat("Param1");;

    log("KFXFireFlame DamagePersecond"$DamagePersecond);
}

simulated function KFXFireEntry()
{
	local Vector Start, End, X, HitLocation, HitNormal;
    local Actor Other;
    local Material HitMaterial;
    //log("FireFlame FireEntry"$Level.NetMode);
	// Check & Consume Ammo
	if ( !KFXConsumeAmmo( KFXWeapBase(Weapon).KFXGetAmmoPerFire() ) )
	{
        return;
    }
	// Server Stuff
	if (Weapon.Role == ROLE_Authority)
	{
		// Server Player Firing
		ServerPlayFiring();
	}

	// Playe Fire Effect
	// onwer client
	if (Instigator.IsLocallyControlled())
	{
		FireUpdateCrossHair();
		PlayFiring();
		FlashMuzzleFlash();
		StartMuzzleSmoke();
	}

    if ( Weapon.Role == ROLE_Authority )
    {
        Weapon.IncrementFlashCount(KFXFireGroup);
        //log("FireFlame FireEntry IncrementFlashCount");
    }
	NextFireTime += KFXWeapBase(Weapon).KFXGetRate();
	NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
	//log("NextFireTime:"$NextFireTime$"KFXGetRate:"$KFXWeapBase(Weapon).KFXGetRate());
    if ( (FlameEffect!= none || EmiterFlameEffect!= none) && Level.NetMode != NM_DedicatedServer )
        return;
    if ( Level.NetMode != NM_DedicatedServer )
    {
        Start = Instigator.Location + Instigator.EyePosition();
        Other = Weapon.Trace(HitLocation, HitNormal, Start + 1000*(vector(Instigator.Controller.Rotation)), Start, true,,HitMaterial);

//        FlameEffect = self.Weapon.Spawn( FlameClass, Weapon,,,Instigator.Controller.Rotation );
//        Weapon.AttachToBone(FlameEffect,'Bone_Flash');
//        FlameEffect.mSizeRange[0] = 6;

    	EmiterFlameEffect = self.Weapon.Spawn( EmitterFlameEffectClass, Weapon,,,Instigator.Controller.Rotation );
        Weapon.AttachToBone(EmiterFlameEffect,'Bone_Flash');
        EmitterFlameLifeTime = EmiterFlameEffect.Emitters[0].LifetimeRange.Max;
        EmitterFlameSpeed = EmiterFlameEffect.Emitters[0].StartVelocityRange.X.Max;
    }
}

simulated function CalcFlameDest( float DeltaTime, rotator Dir, vector RealDest, out vector Dest )
{
    local float Dist;
    local float FlameDist;
    local float DestDist;
    local int  Negative;

    FlameDist = VSize( FlameEffect.mSpawnVecA - FlameEffect.Location);
    DestDist = VSize(RealDest - FlameEffect.Location);
    log("CalcFlameDest DeltaTime:"$DeltaTime$"Dir:"$Dir$"RealDest:"$RealDest$"FlameDist"$FlameDist$"DestDist"$DestDist);

    if ( VSize(RealDest - FlameEffect.mSpawnVecA) <600*DeltaTime || DestDist - FlameDist < 0 )
    {
        //log("CalcFlameDest equal RealDest:"$RealDest);
        Dest = RealDest;
        return;
    }
    else
    {
        //log("CalcFlameDest not equal RealDest:"$VSize(RealDest - FlameEffect.mSpawnVecA));
    }
    if ((DestDist - FlameDist)<0)
        Negative = -1;
    else
        Negative = 1;
    Dest = FlameEffect.Location + vector( Dir ) * (FlameDist + Negative*600*DeltaTime ) ;
    //log("CalcFlameDest not equal diff:"$vector( Dir ) * (Negative*600*DeltaTime ));
}

simulated function CalcFlameDestForEmitter( vector RealDest)
{
    local vector Dist;
    local int i;
    local float Factor;
    local vector Dir;
    local vector newVel;
    local RangeVector RngVector;
    local Range  fRange;

    Dist = RealDest - EmiterFlameEffect.Location;
    Factor = VSize(Dist)/(EmitterFlameLifeTime*EmitterFlameSpeed);
    Factor = self.FClamp(Factor,0.0,1);

    Dir = vector(Weapon.Rotation);
    newVel = EmitterFlameSpeed*Dir*Factor;
    fRange.Max = newVel.X;
    fRange.Min = newVel.X;
    RngVector.X = fRange;

    fRange.Max = newVel.Y;
    fRange.Min = newVel.Y;
    RngVector.Y = fRange;

    fRange.Max = newVel.Z;
    fRange.Min = newVel.Z;
    RngVector.Z = fRange;
    //log("CalcFlameDestForEmitter:"$Factor$"Life:"$Factor*EmitterFlameLifeTime);

    for ( i = 0; i<EmiterFlameEffect.Emitters.Length; i++ )
    {
        EmiterFlameEffect.Emitters[i].StartVelocityRange = RngVector;
    }
}

event ModeTick( float dt )
{
	local Vector Start, End, X, HitLocation, HitNormal;
    local Actor Other;
    local Material HitMaterial;
    local Vector RealDest;

    super.ModeTick(dt);
    if ( FlameEffect == none && EmiterFlameEffect == none && Weapon.Role != ROLE_Authority )
        return;
    if ( !bIsFiring )
        return;
    if ( !AllowFire())
    {
        //log("ModeTick Destroy bIsFiring"$bIsFiring$"AllowFire"$AllowFire());
        if ( FlameEffect != none )
            FlameEffect.Destroy();
        if ( EmiterFlameEffect != none )
            EmiterFlameEffect.Destroy();
        if ( FlameCollideFogEffect != none )
            FlameCollideFogEffect.Destroy();
        if ( FlameNormalFogEffect != none )
            FlameNormalFogEffect.Destroy();
        if ( Weapon.Role == ROLE_Authority )
            Weapon.ZeroFlashCount(KFXFireGroup);
        return;
    }
    if ( Instigator.Controller != none && PlayerController(Instigator.Controller).bBehindView )
        return;
    //log("NextFireTime"$NextFireTime);
    Start = Instigator.Location + Instigator.EyePosition();
    if ( Level.NetMode != NM_DedicatedServer )
        Other = Weapon.Trace(HitLocation, HitNormal, Start + EmitterFlameSpeed*(vector(Instigator.Controller.Rotation)), Start, true,,HitMaterial);
    else
        Other = Weapon.Trace(HitLocation, HitNormal, Start + 500*(vector(Instigator.Controller.Rotation)), Start, true,,HitMaterial);
    if ( Other != none )
    {
        RealDest = HitLocation;
        if ( KFXPawn(Other) != none && Weapon.Role == ROLE_Authority )
        {
            if ( Instigator.Controller != none )
            {

                    if ( KFXFireGroup == 0 || AltDamageType == none )
            			KFXPawn(Other).KFXTakePBDamage(Instigator, class'KFXGame.KFXFlameDamageType',
            				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
            				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param2);
            		else
            			KFXPawn(Other).KFXTakePBDamage(Instigator, class'KFXGame.KFXFlameDamageType',
            				KFXPBDamageType[KFXFireGroup].BitState, KFXPBDamageType[KFXFireGroup].Timer,
            				KFXPBDamageType[KFXFireGroup].Param1, KFXPBDamageType[KFXFireGroup].Param1);
            }
        }
        if ( FlameNormalFogEffect != none )
            FlameNormalFogEffect.Destroy();
        if ( Level.NetMode != NM_DedicatedServer )
        {
            if ( FlameCollideFogEffect == none )
            {
                //LOG("Spawn  FlameCollideFogEffect");
                FlameCollideFogEffect = self.Weapon.Spawn( FlameCollideFogEffectClass, Weapon,,,Rotator(HitNormal) );;
            }
            Weapon.AttachToBone(FlameCollideFogEffect,'BONE_FLASH');
            FlameCollideFogEffect.SetLocation( HitLocation );
        }
    }
    else
    {
        if ( FlameCollideFogEffect != none )
            FlameCollideFogEffect.Destroy();
        if ( Level.NetMode != NM_DedicatedServer )
        {
//            if ( (FlameNormalFogEffect == none && VSize(FlameEffect.mSpawnVecA - FlameEffect.Location) > 400) || FlameNormalFogEffect != none )
//            {
//            if ( VSize(FlameEffect.mSpawnVecA - FlameEffect.Location) > 100 )
//            {
//                if ( FlameNormalFogEffect == none )
//                {
//                    //LOG("Spawn  FlameNormalFogEffect");
//                    FlameNormalFogEffect = self.Weapon.Spawn( FlameNormalFogEffectClass, Weapon,,,Rotator(HitNormal) );;
//                }
//                Weapon.AttachToBone(FlameNormalFogEffect,'BONE_FLASH');
//                FlameNormalFogEffect.SetLocation( FlameEffect.mSpawnVecA );
//            }
//            }
        }

        RealDest = Start +  1000*(vector(Instigator.Controller.Rotation));
    }
    if ( Level.NetMode != NM_DedicatedServer )
        CalcFlameDestForEmitter(RealDest);
        //CalcFlameDest(dt,Instigator.Controller.Rotation,RealDest,FlameEffect.mSpawnVecA);

}



function StopFiring()
{
    //log("StopFiring Destroy ");
    super.StopFiring();
    if ( FlameEffect != none )
        FlameEffect.Destroy();
    if ( EmiterFlameEffect != none )
        EmiterFlameEffect.Destroy();
    if ( FlameCollideFogEffect != none )
        FlameCollideFogEffect.Destroy();
    if ( FlameNormalFogEffect != none )
        FlameNormalFogEffect.Destroy();
    if ( Weapon.Role == ROLE_Authority )
        Weapon.ZeroFlashCount(KFXFireGroup);

}

defaultproperties
{
     FlameClass=Class'KFXGame.KFXFlameBeam'
     FlameCollideFogEffectClass=Class'KFXEffects.fx_effect_flames_hitwall'
     FlameNormalFogEffectClass=Class'KFXEffects.fx_effect_flames_fire'
     EmitterFlameEffectClass=Class'KFXEffects.fx_effect_flames_fire_02'
     DamagePersecond=30.000000
}
