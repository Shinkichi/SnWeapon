class KFProj_Bullet_Pellet_M1897TrenchgunShrapnel extends KFProj_Bullet
    hidedropdown;

defaultproperties
{
    MaxSpeed=7000.0
    Speed=7000.0

    DamageRadius=0

	bSyncToOriginalLocation = True
	bSyncToThirdPersonMuzzleLocation = false
	bNoReplicationToInstigator = false
	bReplicateClientHitsAsFragments = true

	MyDamageType=class'KFDT_Piercing_M1897TrenchgunShrapnel'
	Damage=50.0f//80.0f

	ProjFlightTemplate=ParticleSystem'WEP_ChiappaRhino_EMIT.FX_Tracer_ChiappaRhino_ZEDTime'
}

