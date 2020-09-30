class KFDT_Piercing_JavelinGun extends KFDT_Piercing
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=250
	KDeathVel=150



    KnockdownPower=20
	StunPower=101 //90
	StumblePower=250
	GunHitPower=100
	MeleeHitPower=40

	ModifierPerkList(0)=class'KFPerk_Berserker'
	WeaponDef=class'KFWeapDef_JavelinGun'
}
