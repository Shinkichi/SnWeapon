
class KFProj_DoubleDragonSplash extends KFProj_FlareGunSplash;

defaultproperties
{
	PostExplosionLifetime=2.5
	ExplosionActorClass=class'KFExplosion_GroundFire'

    Begin Object Name=ExploTemplate0
    	Damage=8
		DamageRadius=150.0
        MyDamageType=class'KFDT_Fire_Ground_DoubleDragon'
        ExplosionEffects=KFImpactEffectInfo'WEP_Flamethrower_ARCH.GroundFire_Impacts'
    End Object

    AssociatedPerkClass=none
}