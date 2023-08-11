
class KFProj_Bolt_JavelinGun_Alt extends KFProj_Rocket_SealSqueal;

defaultproperties
{
	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=100  //300
		DamageRadius=1000  //600
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_JavelinGun_Alt'
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
		ShardClass=class'KFProj_NailShard_JavelinGun'
		NumShards=10
	End Object
	ExplosionTemplate=ExploTemplate0

	AssociatedPerkClass=class'KFPerk_Berserker'
}