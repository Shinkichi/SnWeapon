
class KFDT_Ballistic_TP9 extends KFDT_Ballistic_Submachinegun
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	KnockdownPower=0
	StumblePower=20
	GunHitPower=12

	WeaponDef=class'KFWeapDef_TP9'
	ModifierPerkList(0)=class'KFPerk_SWAT'
}
