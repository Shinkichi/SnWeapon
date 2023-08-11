
class KFDT_Ballistic_WMDImpact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=3000
	KDeathUpKick=1000
	KDeathVel=500

	KnockdownPower=200
	StumblePower=340
	GunHitPower=275

	ModifierPerkList.Empty
	ModifierPerkList(0)=class'KFPerk_FieldMedic'

	WeaponDef=class'KFWeapDef_WMD'
}
