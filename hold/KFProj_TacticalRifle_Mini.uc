class KFProj_TacticalRifle_Mini extends KFProj_BallisticExplosive;

defaultproperties
{
	Physics=PHYS_Falling

    Speed=4000
    MaxSpeed=4000
    TerminalVelocity=4000
    GravityScale=0.5
    TossZ=150

	// set collision size to 0 so it doesn't cause non-zero extent checks against zeds
	Begin Object Name=CollisionCylinder
		CollisionRadius=0.f
		CollisionHeight=0.f
	End Object

	//FuseTime=0.01
	PostExplosionLifetime=15

	bWarnAIWhenFired=true

	bSyncToOriginalLocation=true
	bSyncToThirdPersonMuzzleLocation=true
	bUpdateSimulatedPosition=true

	bDamageDestructiblesOnTouch=true
	Damage=50
	MyDamageType=class'KFDT_Ballistic_TacticalRifleImpact'

    ProjFlightTemplate=ParticleSystem'WEP_Medic_GrenadeLauncher_EMIT.FX_Medic_GrenadeLauncher_Projectile'
    ProjFlightTemplateZedTime=ParticleSystem'WEP_Medic_GrenadeLauncher_EMIT.FX_Medic_GrenadeLauncher_Projectile_ZEDTIME'
	//ExplosionActorClass=class'KFExplosion_MedicGrenadeMini'

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
        //ExploLight=ExplosionPointLight
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

	// Temporary effect (5.14.14)
	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'

	AssociatedPerkClass=class'KFPerk_SWAT'
}