class KFDT_Ballistic_HealingbussImpact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=2000
	KDeathUpKick=750
	KDeathVel=1500

	StumblePower=400
	KnockdownPower=200
	GunHitPower=300

	WeaponDef=class'KFWeapDef_Healingbuss'

	ModifierPerkList(0)=class'KFPerk_FieldMedic'
}

