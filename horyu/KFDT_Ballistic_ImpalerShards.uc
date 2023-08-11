
class KFDT_Ballistic_ImpalerShards extends KFDT_Piercing
	abstract
	hidedropdown;

/**
 * Returns the class of the projectile to spawn if the weapon using this damage
 * type can pin a zed when it kills it
 */
static simulated function class<KFProj_PinningBullet> GetPinProjectileClass()
{
    return class'KFProj_Nail_Impaler';
}

defaultproperties
{
	BloodSpread=0.4
	BloodScale=0.6

	//Physics
	KDamageImpulse=2500
	KDeathUpKick=800
	KDeathVel=1200

	//Afflictions
	StumblePower=40
	GunHitPower=40

	WeaponDef=class'KFWeapDef_Impaler'
	ModifierPerkList(0)=class'KFPerk_Support'
}
