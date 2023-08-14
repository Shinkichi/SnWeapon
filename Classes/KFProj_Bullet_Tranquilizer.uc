
class KFProj_Bullet_Tranquilizer extends KFProj_Bullet
    hidedropdown;

defaultproperties
{
    MaxSpeed=22500//30000.0
    Speed=22500//30000.0

    DamageRadius=0

    ProjFlightTemplate=ParticleSystem'WEP_Bleeder_EMIT.FX_Bleeder_Projectile'
	ImpactEffects=KFImpactEffectInfo'WEP_Bleeder_ARCH.Bleeder_bullet_impact'
}

