
class KFProj_Bullet_Pistol_ChiappaHippo extends KFProj_Bullet
    hidedropdown;

defaultproperties
{
	MaxSpeed=15000.0//18000.0
	Speed=15000.0//18000.0

    DamageRadius=0
	//ProjFlightTemplate=ParticleSystem'FX_Projectile_EMIT.FX_Tracer_9MM_ZEDTime'
	ProjFlightTemplate=ParticleSystem'WEP_HRG_Stunner_EMIT.FX_HRG_Stunner_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_Stunner_EMIT.FX_HRG_Stunner_Tracer_ZEDTime'

	bSpawnShrapnel=true
	bDebugShrapnel=false

	NumSpawnedShrapnel=1//3
	//ShrapnelSpreadWidthEnvironment=0.25 //0.5
	//ShrapnelSpreadHeightEnvironment=0.25 //0.5
	//ShrapnelSpreadWidthZed=0.75 //0.5
	//ShrapnelSpreadHeightZed=0.75 //0.5
	ShrapnelClass = class'KFProj_Bullet_Pistol_ChiappaHippoShrapnel'
	//ShrapnelSpawnSoundEvent = AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_Bullet_Fragmentation'
	//ShrapnelSpawnVFX=ParticleSystem'WEP_ChiappaRhino_EMIT.FX_ChiappaRhino_Shrapnel_Hit'
	
}

