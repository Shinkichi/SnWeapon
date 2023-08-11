
class KFProj_Grenade_ThermalImploderAlt extends KFProjectile
	hidedropdown;

/** Speed when residual flames are dropped during projectile flight */
var vector SpeedDirectionResidualFlames;

/** Amount of residual flames to drop during flight
 *  This is the max number, if the projectile is interrupted before reaching the max, the left residual numbers will NOT be spawned.
 *  This value can NOT be 0 or 1.
 */
var int AmountResidualFlamesDuringFlight;

/** Time delay until starting to drop residual flames during flight (should NOT be greater than Lifespan)*/
var float TimeDelayStartDroppingResidualFlames;

/** Class for spawning residual flames **/
var class<KFProjectile> ResidualFlameProjClass;

/** Number of lingering flames to spawn when projectile hits environment or a pawn before reaching max
 *  Note: one flame will always spawn in the place or pawn hit.
 */
var() int AmountResidualFlamesInExplosion;

/** Magnitude to multiply velocity computed for residual flames in explosion */
var float MagnitudeVelocityResidualFlamesInExplosion;

/** Offset added to the final velocity computed for residual flames in explosion */
var vector OffsetVelocityResidualFlamesInExplosion;

/** (Computed) Last Velocity from Explode() */
var vector LastVelocity;

/** (Computed) Time between residual flames drops */
var float IntervalDroppingResidualFlames;

/** Same as Lifespan (but using TimeAlive we assure projectile follows same flow as an explosion) */
var float TimeAlive;

simulated protected function StopSimulating()
{
	if (Instigator != none && Instigator.Role == ROLE_Authority)
	{
		ClearTimer(nameof(Timer_SpawningResidualFlamesDuringFlight));
		ClearTimer(nameof(Timer_StartSpawningResidualFlamesDuringFlight));
	}
	ClearTimer(nameof(Timer_Shutdown));

	super.StopSimulating();
}

simulated function PostBeginPlay()
{
	//Subtract a bit (0.005) from TimeAlive to not match last cycle of the timer with time the projectile has to disappear (causing last flame not to drop then)
	//Subtract 1 from AmountResidualFlamesDuringFlight because the first flame will be spawned manually at the start of the timer.
	IntervalDroppingResidualFlames=((TimeAlive - 0.005) - TimeDelayStartDroppingResidualFlames)/(AmountResidualFlamesDuringFlight - 1);
	if (Instigator != none && Instigator.Role == ROLE_Authority)
	{
		SetTimer(TimeDelayStartDroppingResidualFlames, false, nameof(Timer_StartSpawningResidualFlamesDuringFlight));
	}
	SetTimer(TimeAlive, false, nameof(Timer_Shutdown));

	super.PostBeginPlay();
}

simulated function Init(vector Direction)
{
	super.Init(Direction);
	SpeedDirectionResidualFlames = Velocity/5;
}

/** Timer to spawn residual flames while projectile is flying */
simulated function Timer_SpawningResidualFlamesDuringFlight()
{
	SpawnResidualFlame(ResidualFlameProjClass, Location, SpeedDirectionResidualFlames);
}

/** Timer to act as offset to start spawning residual flames during flight (in order to avoid dropping flames to close to player) */
simulated function Timer_StartSpawningResidualFlamesDuringFlight()
{
	SpawnResidualFlame(ResidualFlameProjClass, Location, SpeedDirectionResidualFlames);
	SetTimer(IntervalDroppingResidualFlames, true, nameof(Timer_SpawningResidualFlamesDuringFlight));
}

/** Timer until calling Shutdown */
simulated function Timer_Shutdown()
{
	Shutdown();
}

/** Spawn several projectiles that explode and linger on impact */
function SpawnResidualFlames (vector HitLocation, vector HitNormal, vector HitVelocity)
{
	local int i;
	local vector HitVelDir;
	local float HitVelMag;
	local vector SpawnLoc, SpawnVel;

	HitVelMag = VSize (HitVelocity)*MagnitudeVelocityResidualFlamesInExplosion;
	HitVelDir = Normal (HitVelocity);

	SpawnLoc = HitLocation + (HitNormal * 10.f);

	// spawn random lingering fires (rather, projectiles that cause little fires)
	for( i = 0; i < AmountResidualFlamesInExplosion; ++i )
	{
		SpawnVel = CalculateResidualFlameVelocity( HitNormal, HitVelDir, HitVelMag );
		SpawnVel = SpawnVel + OffsetVelocityResidualFlamesInExplosion;
		SpawnResidualFlame( ResidualFlameProjClass, SpawnLoc, SpawnVel );
	}
}

/** Spawn several projectiles that explode and linger on impact on explosion and one projectile to explode where this projectile hit */
simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
	local bool bDoExplosion;

	if (bHasDisintegrated)
	{
		return;
	}

	bDoExplosion = !bHasExploded && Instigator.Role == ROLE_Authority;

	if (bDoExplosion)
	{
		SpawnResidualFlames (HitLocation, HitNormal, LastVelocity);
		SpawnResidualFlame (ResidualFlameProjClass, Location, LastVelocity);
	}

	super.TriggerExplosion(HitLocation, HitNormal, HitActor);
}


simulated function Explode (vector HitLocation, vector HitNormal)
{
	LastVelocity = Velocity;
	super.Explode (HitLocation, HitNormal);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	ProcessBulletTouch(Other, HitLocation, HitNormal);
	super.ProcessTouch(Other, HitLocation, HitNormal);
}

simulated function SpawnFlightEffects()
{
	super.SpawnFlightEffects();
	
	if (ProjEffects != None)
	{
		ProjEffects.SetFloatParameter( 'FlareLifetime', LifeSpan );
	}
}

simulated function SyncOriginalLocation()
{
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local TraceHitInfo HitInfo;

	if (Role < ROLE_Authority && Instigator != none && Instigator.IsLocallyControlled())
	{
		HitActor = Trace(HitLocation, HitNormal, OriginalLocation, Location,,, HitInfo, TRACEFLAG_Bullet);
		if (HitActor != none)
		{
			Explode(HitLocation, HitNormal);
		}
	}

    Super.SyncOriginalLocation();
}

defaultproperties
{
	Physics=PHYS_Falling

	MaxSpeed=7000.0
	Speed=3000.0 //7000.0
	TerminalVelocity=7000.0

	bWarnAIWhenFired=true

    bCollideActors=true
    bCollideComplex=true

	DamageRadius=0
	GravityScale=0.4 //0.5 //1.0
	TossZ=0
	TimeDelayStartDroppingResidualFlames=0.005 //0.05
	TimeAlive=0.5//0.6 //0.2
	ProjEffectsFadeOutDuration=5.0
	AmountResidualFlamesDuringFlight=8 //10
	SpeedDirectionResidualFlames=(X=0, Y=0, Z=0)
	AmountResidualFlamesInExplosion=3
	MagnitudeVelocityResidualFlamesInExplosion=0.5
	OffsetVelocityResidualFlamesInExplosion=(X=0, Y=0, Z=200)
	bNoReplicationToInstigator=false

	Begin Object Class=PointLightComponent Name=PointLight0
	    //LightColor=(R=252,G=218,B=171,A=255)
		LightColor=(R=250,G=25,B=80,A=255)
		Brightness=0.5f
		Radius=500.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=true
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object
	ProjFlightLight=PointLight0


	ResidualFlameProjClass=class'KFProj_Grenade_ThermalImploderAltSplash'
	//ProjFlightTemplateZedTime=ParticleSystem'WEP_DragonsBreath_EMIT.Tracer.FX_DragonsBreath_Tracer_ZEDTime'

	ProjFlightTemplate=ParticleSystem'WEP_HRGScorcher_Pistol_EMIT.FX_HRGScorcher_Projectile_01_ALT'

	AssociatedPerkClass=class'KFPerk_Firebug'

	// Light during explosion
    Begin Object Class=PointLightComponent Name=ExplosionPointLight
        LightColor=(R=252,G=218,B=171,A=255)
        Brightness=4.f
        Radius=2000.f
        FalloffExponent=10.f
        CastShadows=False
        CastStaticShadows=FALSE
        CastDynamicShadows=False
		bCastPerObjectShadows=false
        bEnabled=FALSE
        LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
    End Object

	// Explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=0
		DamageRadius=500
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		bIgnoreInstigator=false
	
		MomentumTransferScale=0

		// Damage Effects
		MyDamageType=class'KFDT_Fire_ThermalImploderDoT'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_HRGScorcher_Pistol_ARCH.HRGScorcher_Pistol_Grenade_Explosion'
		ExplosionSound=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_AltFire_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
        CamShakeInnerRadius=200
        CamShakeOuterRadius=900
        CamShakeFalloff=1.5f
        bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0
	ExplosionActorClass=class'KFExplosionActor'

	bDamageDestructiblesOnTouch=true
}

