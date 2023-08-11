class KFProj_Bullet_HRG_ElectroShrapnel extends KFProj_Bullet
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

	MyDamageType=class'KFDT_Ballistic_HRG_Electro'
	Damage=64.0f//80.0f

	ProjFlightTemplate=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Rifle_Tracer_ZedTime'
}

