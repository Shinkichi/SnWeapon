
class KFDT_Ballistic_TacticalRifleGrenadeImpact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=2000
	KDeathUpKick=750
	KDeathVel=350

	KnockdownPower=125
	StumblePower=340
	GunHitPower=275

	WeaponDef=class'KFWeapDef_TacticalRifle'

	//ModifierPerkList(0)=class'KFPerk_SWAT'
	//ModifierPerkList(1)=class'KFPerk_Commando'
}
