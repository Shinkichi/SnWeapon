class KFDT_Ballistic_TacticalRifleImpact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100

	//KnockdownPower=125
	//StumblePower=340
	GunHitPower=275

	WeaponDef=class'KFWeapDef_TacticalRifle'

	//Perk
	ModifierPerkList(0)=class'KFPerk_SWAT'
}
