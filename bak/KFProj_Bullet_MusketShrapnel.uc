class KFProj_Bullet_MusketShrapnel extends KFProj_Bullet
    hidedropdown;

defaultproperties
{
	MaxSpeed=22500.0
	Speed=22500.0

    DamageRadius=0

	bSyncToOriginalLocation = True
	bSyncToThirdPersonMuzzleLocation = false
	bNoReplicationToInstigator = false
	bReplicateClientHitsAsFragments = true

	MyDamageType=class'KFDT_Piercing_MusketShrapnel'
	Damage=160.0f//80.0f

	ProjFlightTemplate=ParticleSystem'WEP_ChiappaRhino_EMIT.FX_Tracer_ChiappaRhino_ZEDTime'
}

