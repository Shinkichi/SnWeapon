
class KFProj_Bullet_LaserRifle extends KFProj_Bullet
	hidedropdown;

defaultproperties
{
	Physics=PHYS_Projectile
	Speed=3800 //1800
	MaxSpeed=3800 //1800
	ProjFlightTemplate=ParticleSystem'ZED_EvilDAR_EMIT.FX_EvilDar_Laser_Projectile'
	ExplosionActorClass=class'KFExplosionActor'

    bCollideComplex=true	// Ignore simple collision on StaticMeshes, and collide per poly
	bBlockedByInstigator=false

	Begin Object Class=PointLightComponent Name=ExplosionPointLight
	    LightColor=(R=245,G=190,B=140,A=255)
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

	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=70//7
		DamageRadius=75
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		// Damage Effects
		MomentumTransferScale=60.f //60000.
		KnockDownStrength=100
		//FractureMeshRadius=200.0
		//FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.EDar_Laser_Explosion'
		ExplosionSound=AkEvent'WW_ZED_Evil_DAR.Play_ZED_EvilDAR_SFX_Laser_Impact'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.5

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.HuskFireball'
		CamShakeInnerRadius=50
		CamShakeOuterRadius=75
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	/*Begin Object Class=AkComponent name=AmbientAkSoundComponent
		bStopWhenOwnerDestroyed=true
        bForceOcclusionUpdateInterval=true
        OcclusionUpdateInterval=0.1f
    End Object*/
    AmbientComponent=AmbientAkSoundComponent
    Components.Add(AmbientAkSoundComponent)

	bAutoStartAmbientSound=true
	bStopAmbientSoundOnExplode=true
	//AmbientSoundPlayEvent=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_LP'
    //AmbientSoundStopEvent=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_LP_Stop'
}
