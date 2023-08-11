class KFDT_Piercing_JavelinGun extends KFDT_Piercing
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=250
	KDeathVel=150

	StunPower=101
	StumblePower=250
	GunHitPower=100

	ModifierPerkList(0)=class'KFPerk_Berserker'
   	ModifierPerkList(1)=class'KFPerk_Sharpshooter'
	WeaponDef=class'KFWeapDef_JavelinGun'
}