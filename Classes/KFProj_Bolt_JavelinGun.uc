class KFProj_Bolt_JavelinGun extends KFProj_Bolt_Crossbow
	hidedropdown;


defaultproperties
{
	//Physics=PHYS_Falling

	bWarnAIWhenFired=true

	// Speed is defined by the charge level of the bow:
	MaxSpeed=7500//15000.0
	Speed=7500//15000.0
	TerminalVelocity=7500//15000.0

	DamageRadius=0

    BouncesLeft=0
	ProjFlightTemplate=ParticleSystem'WEP_Crossbow_EMIT.FX_Crossbow_Projectile'
	//ProjIndicatorTemplate=ParticleSystem'WEP_Seal_Squeal_EMIT.FX_Harpoon_Projectile_Indicator'

    LifeSpan=10
    LifeSpanAfterStick=180

    bBlockedByInstigator=false
    bCollideActors=true
    bCollideComplex=true
    bNoEncroachCheck=true
	bNoReplicationToInstigator=false
	bUseClientSideHitDetection=true
	bUpdateSimulatedPosition=false
	bRotationFollowsVelocity=false
	bNetTemporary=false
    bSyncToOriginalLocation=true

	ImpactEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Crossbow_impact'

    AmbientSoundPlayEvent=AkEvent'WW_WEP_SA_Crossbow.Play_Bolt_Fly_By'
    AmbientSoundStopEvent=AkEvent'WW_WEP_SA_Crossbow.Stop_Bolt_Fly_By'

	WeaponClassName=KFWeap_JavelinGun
	ProjPickupTemplate=ParticleSystem'WEP_Crossbow_EMIT.FX_Crossbow_Projectile_Pickup'
    AmmoPickupSound=AkEvent'WW_WEP_SA_Crossbow.Play_Crossbow_Bolt_Pickup'

    TouchTimeThreshhold=0.15
}