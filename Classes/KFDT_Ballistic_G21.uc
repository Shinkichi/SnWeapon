class KFDT_Ballistic_G21 extends KFDT_Ballistic_Handgun
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=-450
	KDeathVel=200

	KnockdownPower=15
	StumblePower=20
	GunHitPower=100

	WeaponDef=class'KFWeapDef_G21'
	ModifierPerkList(0)=class'KFPerk_Gunslinger'
}
