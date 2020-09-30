
class KFDT_EMP_JavelinGun extends KFDT_EMP
	abstract
	hidedropdown;

defaultproperties
{

	// physics impact
	RadialDamageImpulse=1000
	KDeathUpKick=500
	KDeathVel=50

	KnockdownPower=0
	MeleeHitPower=100
	EMPPower=100

	//Perk
	ModifierPerkList(0) = class'KFPerk_Berserker'

	WeaponDef = class'KFWeapDef_JavelinGun'
}
