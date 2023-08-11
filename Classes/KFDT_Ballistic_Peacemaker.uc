class KFDT_Ballistic_Peacemaker extends KFDT_Ballistic_Handgun
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=2000
	KDeathUpKick=400
	KDeathVel=250

    KnockdownPower=20
	StunPower=20 //25
	StumblePower=0
	GunHitPower=80 //100
	MeleeHitPower=0

	WeaponDef=class'KFWeapDef_Peacemaker'

	ModifierPerkList(0)=class'KFPerk_Gunslinger'
	ModifierPerkList(1)=class'KFPerk_Sharpshooter'
}
