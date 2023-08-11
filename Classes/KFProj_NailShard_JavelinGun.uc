
class KFProj_NailShard_JavelinGun extends KFProj_Nail_Nailgun
	hidedropdown;

defaultproperties
{
	MaxSpeed=5000.0
	Speed=5000.0

    Damage=35
	DamageRadius=0
	MyDamageType=class'KFDT_Piercing_JavelinGun_NailFragment'
	MomentumTransfer=1.f

	bSyncToOriginalLocation=True
	bSyncToThirdPersonMuzzleLocation=false
	bNoReplicationToInstigator=false
    bReplicateClientHitsAsFragments=true

    BouncesLeft=2
    DampingFactor=0.65
    RicochetEffects=KFImpactEffectInfo'WEP_Nail_Shotgun_ARCH.NailBulletImpacts'

	ProjFlightTemplate=ParticleSystem'WEP_Nailbomb_EMIT.FX_Nailbomb_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_Nailbomb_EMIT.FX_Nailbomb_Tracer_ZEDTime'
}
