class KFProj_Bullet_Pistol_ChiappaHippoShrapnel extends KFProj_Bullet
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

	MyDamageType=class'KFDT_Ballistic_ChiappaHippoShrapnel'
	Damage=150.f//100.0f//80.0f

	//ProjFlightTemplate=ParticleSystem'WEP_1P_L85A2_EMIT.FX_L85A2_Tracer_ZEDTime'
	//ProjFlightTemplate=ParticleSystem'WEP_ChiappaRhino_EMIT.FX_Tracer_ChiappaRhino_ZEDTime'
	ProjFlightTemplate=ParticleSystem'WEP_HRG_Stunner_EMIT.FX_HRG_Stunner_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_Stunner_EMIT.FX_HRG_Stunner_Tracer_ZEDTime'
}

