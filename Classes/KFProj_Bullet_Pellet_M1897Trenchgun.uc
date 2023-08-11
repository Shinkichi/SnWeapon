class KFProj_Bullet_Pellet_M1897Trenchgun extends KFProj_Bullet_Pellet
    hidedropdown;

defaultproperties
{
    MaxSpeed=7000.0
    Speed=7000.0

    DamageRadius=0
	ProjFlightTemplate=ParticleSystem'FX_Projectile_EMIT.FX_Tracer_9MM_ZEDTime'

	bSpawnShrapnel=true
	bDebugShrapnel=false

	NumSpawnedShrapnel=2//3
	ShrapnelSpreadWidthEnvironment=0.25 //0.5
	ShrapnelSpreadHeightEnvironment=0.25 //0.5
	ShrapnelSpreadWidthZed=0.75 //0.5
	ShrapnelSpreadHeightZed=0.75 //0.5
	ShrapnelClass = class'KFProj_Bullet_Pellet_M1897TrenchgunShrapnel'
	//ShrapnelSpawnSoundEvent = AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_Bullet_Fragmentation'
	//ShrapnelSpawnVFX=ParticleSystem'WEP_ChiappaRhino_EMIT.FX_ChiappaRhino_Shrapnel_Hit'
	
}
