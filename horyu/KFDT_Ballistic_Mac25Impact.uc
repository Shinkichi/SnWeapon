
class KFDT_Ballistic_Mac25Impact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=500
	KDeathVel=250
	
	KnockdownPower=12
	StumblePower=14
	LegStumblePower=14
	GunHitPower=39

	WeaponDef=class'KFWeapDef_Mac25'

	ModifierPerkList(0)=class'KFPerk_Demolitionist'
	ModifierPerkList(1)=class'KFPerk_SWAT'
}
