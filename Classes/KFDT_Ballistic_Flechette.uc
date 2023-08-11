
class KFDT_Ballistic_Flechette extends KFDT_Piercing
	abstract
	hidedropdown;

/**
 * Returns the class of the projectile to spawn if the weapon using this damage
 * type can pin a zed when it kills it
 */
static simulated function class<KFProj_PinningBullet> GetPinProjectileClass()
{
    return class'KFProj_Nail_Blunderbuss';
}

defaultproperties
{
	BloodSpread=0.4
	BloodScale=0.6

	KDamageImpulse=900
	KDeathUpKick=-500
	KDeathVel=350
	//KDamageImpulse=350
	//KDeathUpKick=120
	//KDeathVel=10

    KnockdownPower=0
	StumblePower=50//10
	GunHitPower=0

	WeaponDef=class'KFWeapDef_Flechette'

	ModifierPerkList(0)=class'KFPerk_Support'
	ModifierPerkList(1)=class'KFPerk_Berserker'
}
