class KFProj_Bullet_ExpressRifle extends KFProj_Bullet
	hidedropdown;

defaultproperties
{
	MaxSpeed=14000.0//7000.0
	Speed=14000.0//7000.0

	bWarnAIWhenFired=true

	DamageRadius=0

	ProjFlightTemplate=ParticleSystem'WEP_1P_MB500_EMIT.FX_MB500_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_1P_MB500_EMIT.FX_MB500_Tracer_ZEDTime'

	AmbientSoundPlayEvent=none
    AmbientSoundStopEvent=none
}
