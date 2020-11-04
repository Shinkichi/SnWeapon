
class KFProj_Explosive_SMEG extends KFProj_BallisticExplosive
	hidedropdown;

defaultproperties
{
	Physics=PHYS_Projectile
	Speed=4000
	MaxSpeed=4000
	TossZ=0
	GravityScale=1.0
    MomentumTransfer=50000.0
    ArmDistSquared=0

	bWarnAIWhenFired=true

	ProjFlightTemplate=ParticleSystem'WEP_Bleeder_EMIT.FX_Bleeder_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_Bleeder_EMIT.FX_Bleeder_Projectile'
	ProjDudTemplate=ParticleSystem'WEP_Bleeder_EMIT.FX_Bleeder_Projectile'
	GrenadeBounceEffectInfo=KFImpactEffectInfo'WEP_Bleeder_ARCH.Bleeder_bullet_impact'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'

	ImpactEffects=KFImpactEffectInfo'WEP_Bleeder_ARCH.Bleeder_bullet_impact'

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
		Damage=100  //300
		DamageRadius=1000  //600
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_SMEG'
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
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true

		// Shards
		ShardClass=class'KFProj_NailShard'
		NumShards=10
	End Object
	ExplosionTemplate=ExploTemplate0
}

