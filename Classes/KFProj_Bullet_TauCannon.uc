class KFProj_Bullet_TauCannon extends KFProj_Bullet_Pellet
	hidedropdown;

defaultproperties
{
	MaxSpeed=7000.0
	Speed=7000.0

    bWarnAIWhenFired=true

	DamageRadius=0

    //LifeSpan = 5.0f

	ProjFlightTemplate=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Rifle_Tracer_ZedTime'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Rifle_Tracer_ZedTime'
	ImpactEffects = KFImpactEffectInfo'WEP_Laser_Cutter_ARCH.Laser_Cutter_bullet_impact'
}
