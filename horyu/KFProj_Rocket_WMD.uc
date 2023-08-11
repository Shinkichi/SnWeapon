class KFProj_Rocket_WMD extends KFProj_BallisticExplosive
	hidedropdown;

/** Amount of residual flames to drop during flight
 *  This is the max number, if the projectile is interrupted before reaching the max, the left residual numbers will NOT be spawned.
 *  This value can NOT be 0 or 1.
 */
var int AmountResidualFlamesDuringFlight;

/** Magnitude to multiply velocity computed for residual flames in explosion */
var float MagnitudeVelocityResidualFlamesInExplosion;

/** Offset added to the final velocity computed for residual flames in explosion */
var vector OffsetVelocityResidualFlamesInExplosion;

/** (Computed) Last Velocity from Explode() */
var vector LastVelocity;

/** Class for spawning residual flames **/
var class<KFProjectile> ResidualFlameProjClass;

/** Number of lingering flames to spawn when projectile hits environment or a pawn before reaching max
 *  Note: one flame will always spawn in the place or pawn hit.
 */
var() int AmountResidualFlamesInExplosion;

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

/**
 * Give the projectiles a chance to situationally customize/tweak any explosion parameters.
 * We will also copy in any data we exposed here for .ini file access.
 */
simulated protected function PrepareExplosionTemplate()
{
	local KFWeapon KFW;

	GetRadialDamageValues(ExplosionTemplate.Damage, ExplosionTemplate.DamageRadius, ExplosionTemplate.DamageFalloffExponent);
	ExplosionTemplate.Damage *= UpgradeDamageMod;

	KFW = KFWeapon(Owner);
	if (KFW == none && Instigator != none)
	{
		KFW = KFWeapon(Instigator.Weapon);
	}
	if (KFW != none)
	{
		KFW.ModifyExplosionRadius(ExplosionTemplate.DamageRadius, WeaponFireMode);
	}
}

simulated protected function SetExplosionActorClass();

defaultproperties
{
	ExplosionActorClass=class'KFExplosion_WMD'

	Physics=PHYS_Falling//PHYS_Projectile
	Speed=6000
	MaxSpeed=6000
	TossZ=0
	GravityScale=0.5//1.0
    MomentumTransfer=50000.0
    ArmDistSquared=150000 // 4 meters

	bWarnAIWhenFired=true

	AmountResidualFlamesInExplosion=6//3
	ResidualFlameProjClass=class'KFProj_WMDSplash'

	ProjFlightTemplate=ParticleSystem'WEP_RPG7_EMIT.FX_RPG7_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_RPG7_EMIT.FX_RPG7_Projectile_ZED_TIME'
	ProjDudTemplate=ParticleSystem'WEP_RPG7_EMIT.FX_RPG7_Projectile_Dud'
	GrenadeBounceEffectInfo=KFImpactEffectInfo'WEP_RPG7_ARCH.RPG7_Projectile_Impacts'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'


	AmbientSoundPlayEvent=AkEvent'WW_WEP_SA_RPG7.Play_WEP_SA_RPG7_Projectile_Loop'
  	AmbientSoundStopEvent=AkEvent'WW_WEP_SA_RPG7.Stop_WEP_SA_RPG7_Projectile_Loop'

  	AltExploEffects=KFImpactEffectInfo'WEP_RPG7_ARCH.RPG7_Explosion_Concussive_Force'

	// Grenade explosion light
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

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=750
		DamageRadius=400    //1000 //250
		DamageFalloffExponent=2  //3
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_WMD'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.Nuke_Explosion'
		ExplosionSound=AkEvent'WW_GLO_Runtime.Play_WEP_Nuke_Explo'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=500
		CamShakeFalloff=3.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0
}
