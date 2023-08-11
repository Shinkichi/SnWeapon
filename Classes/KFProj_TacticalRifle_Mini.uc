
class KFProj_TacticalRifle_Mini extends KFProj_BallisticExplosive
    hidedropdown;

defaultproperties
{
    Physics=PHYS_Falling
    Speed=4000
    MaxSpeed=4000
    TerminalVelocity=4000
    TossZ=150
    GravityScale=0.5
    MomentumTransfer=50000.0
    ArmDistSquared=150000 // 4.0 meters
    LifeSpan=25.0f

    bWarnAIWhenFired=true

    ProjFlightTemplate=ParticleSystem'Wep_M16_M203_EMIT.FX_M16_M203_40mm_Projectile'
    ProjFlightTemplateZedTime=ParticleSystem'Wep_M16_M203_EMIT.FX_M16_M203_40mm_Projectile_ZEDTIME'
    ProjDudTemplate=ParticleSystem'Wep_M16_M203_EMIT.FX_M16_M203_40mm_Projectile_Dud'
    GrenadeBounceEffectInfo=KFImpactEffectInfo'FX_Impacts_ARCH.DefaultGrenadeImpacts'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
    AltExploEffects=KFImpactEffectInfo'WEP_M79_ARCH.M79Grenade_Explosion_Concussive_Force'

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
		Damage=125  //300
		DamageRadius=700  //800
		DamageFalloffExponent=2.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_TacticalRifle'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0	
		ExplosionEffects=KFImpactEffectInfo'WEP_M84_ARCH.M84_Explosion'
		ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Frag.Play_WEP_Flashbang'

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
    End Object
    ExplosionTemplate=ExploTemplate0

    AmbientSoundPlayEvent=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Projectile_Loop'
    AmbientSoundStopEvent=AkEvent'WW_WEP_SA_M79.Stop_WEP_SA_M79_Projectile_Loop'
}

