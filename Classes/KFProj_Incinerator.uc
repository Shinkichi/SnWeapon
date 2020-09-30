
class KFProj_Incinerator extends KFProj_Bullet
	hidedropdown;

/** Time before particle system parameter is set */
var float FlameDisperalDelay;
/** Last hit normal from Touch() or HitWall() */
var vector LastHitNormal;
/** Residual / splash flame chance */
var float ResidualFlameChance;

/**
 * Spawns any effects needed for the flight of this projectile
 */
simulated function SpawnFlightEffects()
{
	Super.SpawnFlightEffects();

	if ( WorldInfo.NetMode != NM_DedicatedServer && WorldInfo.GetDetailMode() > DM_Low  )
	{
		SetTimer(FlameDisperalDelay, false, nameof(MidFlightFXTimer));
	}
}

simulated function MidFlightFXTimer()
{
	if (ProjEffects!=None)
	{
		ProjEffects.SetFloatParameter('Spread', 1.0);
	}
}

simulated protected function StopFlightEffects()
{
	Super.StopFlightEffects();
	ClearTimer(nameof(MidFlightFXTimer));
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	LastHitNormal = HitNormal;
	Super.ProcessTouch(Other, HitLocation, HitNormal);
}

/**
 * Explode this Projectile
 */
simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
	LastHitNormal = HitNormal;
	Super.TriggerExplosion(HitLocation, HitNormal, HitActor);
}

/** 
 * Chance of spawning splash flames.  Need to use StopSimulating,
 * because TriggerExplosion() is not always called for this projectile.
 *
 * @note: Normally, we would just do this in TriggerExplosion, but bullets don't call TriggerExplosion
 * when ExplosionTemplate==None.  This is highly odd because code was added to TriggerExplosion() that runs
 * even when ExplosionTemplate==None.  Instead of trying to untangle things... here is a workaround
 */
simulated protected function StopSimulating()
{
	local vector FlameSpawnVel;

	// Can use physics mode as a way of doing this only once
	if ( Role == ROLE_Authority && Physics == PHYS_Falling && FRand() < ResidualFlameChance )
	{
		FlameSpawnVel = 0.25f * CalculateResidualFlameVelocity( LastHitNormal, Normal( Velocity ), VSize( Velocity ) );
		SpawnResidualFlame( class'KFProj_IncineratorSplash', Location + (LastHitNormal * 10.f), FlameSpawnVel );
	}

	Super.StopSimulating();
}

defaultproperties
{
	Physics=PHYS_Falling

	Speed=5000
	MaxSpeed=5000
	TerminalVelocity=5000

	bWarnAIWhenFired=true

	DamageRadius=0
	GravityScale=2.00//0.05 //0.35//0.15
	TossZ=0
	FlameDisperalDelay=0.25
	ResidualFlameChance=0.33 

	Begin Object Class=PointLightComponent Name=PointLight0
	    LightColor=(R=250,G=160,B=100,A=255)
		Brightness=1.5f
		Radius=350.f
		FalloffExponent=3.0f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=true
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object
	ProjFlightLight=PointLight0
	ProjFlightLightPriority=LPP_High

	ImpactEffects=KFImpactEffectInfo'WEP_FlareGun_ARCH.Wep_Flaregun_bullet_impact'
	ProjFlightTemplate=ParticleSystem'WEP_Flaregun_EMIT.FX_Flaregun_Projectile_01'

	bAmbientSoundZedTimeOnly=false
    AmbientSoundPlayEvent=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Whistle'
    AmbientSoundStopEvent=AkEvent'WW_WEP_Flare_Gun.Stop_WEP_Flare_Gun_Whistle'
}

