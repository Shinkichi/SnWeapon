class KFProj_Bullet_HRG_Electro extends KFProj_Nail_Nailgun
	hidedropdown;

defaultproperties
{
	MaxSpeed=7000.0
	Speed=7000.0

    bWarnAIWhenFired=true

	DamageRadius=0

    LifeSpan = 5.0f

    BouncesLeft=1//2
    DampingFactor=0.65

	ProjFlightTemplate=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Rifle_Tracer_ZedTime'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Rifle_Tracer_ZedTime'
	ImpactEffects = KFImpactEffectInfo'WEP_Laser_Cutter_ARCH.Laser_Cutter_bullet_impact'
	RicochetEffects = KFImpactEffectInfo'WEP_Laser_Cutter_ARCH.Laser_Cutter_bullet_impact'
}
