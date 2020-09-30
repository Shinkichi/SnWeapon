
class KFExplosionActor_Frag12 extends KFExplosionActor;

var float DamageScale;

simulated function float GetDamageFor(Actor Victim)
{
    return ExplosionTemplate.Damage * DamageScale;
}

defaultproperties
{
    DamageScale=1.f
}