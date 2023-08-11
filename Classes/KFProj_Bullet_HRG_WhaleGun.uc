class KFProj_Bullet_HRG_WhaleGun extends KFProj_Bullet_Pellet
	hidedropdown;

defaultproperties
{
	MaxSpeed=7000.0
	Speed=7000.0

	bWarnAIWhenFired=true

	DamageRadius=0

	ImpactEffects = KFImpactEffectInfo'WEP_HRG_BlastBrawlers_ARCH.HRG_BlastBrawler_Projectile_Impacts'
	ProjFlightTemplate=ParticleSystem'WEP_HRG_BlastBrawlers_EMIT.FX_BlastBrawlers_Tracer_Instant'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_BlastBrawlers_EMIT.FX_BlastBrawlers_Tracer_Instant'
	//ProjFlightTemplate=ParticleSystem'WEP_HRG_BlastBrawlers_EMIT.FX_BlastBrawlers_Projectile'
	//ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_BlastBrawlers_EMIT.FX_BlastBrawlers_Projectile'

	AmbientSoundPlayEvent=none
    AmbientSoundStopEvent=none
}