class KFProj_Bullet_Scout_Shotgun extends KFProj_Bullet
	hidedropdown;

defaultproperties
{
	Physics=PHYS_Falling

	MaxSpeed=30000.0//14000.0//7000.0
	Speed=30000.0//14000.0//7000.0

	bWarnAIWhenFired=true

	DamageRadius=0

	ProjFlightTemplate=ParticleSystem'WEP_1P_MB500_EMIT.FX_MB500_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_1P_MB500_EMIT.FX_MB500_Tracer_ZEDTime'

	AmbientSoundPlayEvent=none
    AmbientSoundStopEvent=none
}
