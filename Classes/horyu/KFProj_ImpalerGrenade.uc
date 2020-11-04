
class KFProj_ImpalerGrenade extends KFProj_BallisticExplosive
	hidedropdown;

defaultproperties
{
    LandedTranslationOffset=(X=2)

	Physics=PHYS_Falling
	Speed=4000
	MaxSpeed=4000
	TerminalVelocity=4000
	TossZ=150
	GravityScale=.5
    MomentumTransfer=50000.0
    ArmDistSquared=150000 // 4.0 meters
    LifeSpan=25.0f

	bWarnAIWhenFired=true

	ProjFlightTemplate=ParticleSystem'WEP_3P_M79_EMIT.FX_M79_40mm_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_3P_M79_EMIT.FX_M79_40mm_Projectile_ZEDTIME'
	ProjDudTemplate=ParticleSystem'WEP_3P_M79_EMIT.FX_M79_40mm_Projectile_Dud'
	GrenadeBounceEffectInfo=KFImpactEffectInfo'wep_Nailbomb_arch.Nail_Bomb_Grenade_Impacts'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
	AltExploEffects=KFImpactEffectInfo'WEP_M79_ARCH.M79Grenade_Explosion_Concussive_Force'
	//ExplosionActorClass=class'KFExplosionActor'

	DampenFactor=0.40000
    DampenFactorParallel=0.60000

	// Grenade explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
	    LightColor=(R=252,G=218,B=171,A=255)
		Brightness=4.f
		Radius=2000.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bEnabled=FALSE
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=50  //300
		DamageRadius=500  //600
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_ImpalerGrenade'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'wep_Nailbomb_arch.Nailbomb_Explosion'
		ExplosionSound=AkEvent'WW_EXP_Nail_Bomb.Play_Nail_Bomb_Explode'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
		CamShakeInnerRadius=100
		CamShakeOuterRadius=450
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true

		// Shards
		ShardClass=class'KFProj_ImpalerGrenadeShard'
		NumShards=10
	End Object
	ExplosionTemplate=ExploTemplate0

	AssociatedPerkClass=class'KFPerk_Support'
}
