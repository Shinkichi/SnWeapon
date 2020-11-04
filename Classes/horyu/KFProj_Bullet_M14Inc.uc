// M14 Incendiary - By Shinkichi 2020
class KFProj_Bullet_M14Inc extends KFProj_Bullet
	hidedropdown;

defaultproperties
{
	MaxSpeed=30000.0
	Speed=30000.0

	DamageRadius=0

	ProjFlightTemplate=ParticleSystem'WEP_1P_L85A2_EMIT.FX_L85A2_Tracer_ZEDTime'

	ImpactEffects= KFImpactEffectInfo'WEP_MAC10_ARCH.Mac10_bullet_impact'
}
