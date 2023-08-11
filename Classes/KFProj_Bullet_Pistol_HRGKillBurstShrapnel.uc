class KFProj_Bullet_Pistol_HRGKillBurstShrapnel extends KFProj_Bullet
    hidedropdown;

defaultproperties
{
    MaxSpeed=18000.0
    Speed=18000.0

    DamageRadius=0

	bSyncToOriginalLocation = True
	bSyncToThirdPersonMuzzleLocation = false
	bNoReplicationToInstigator = false
	bReplicateClientHitsAsFragments = true

	MyDamageType=class'KFDT_Piercing_HRGKillBurstShrapnel'
	Damage=160.0f//80.0f

	ProjFlightTemplate=ParticleSystem'WEP_ChiappaRhino_EMIT.FX_Tracer_ChiappaRhino_ZEDTime'
}

