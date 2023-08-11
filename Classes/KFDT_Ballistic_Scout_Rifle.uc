class KFDT_Ballistic_Scout_Rifle extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=12
	GunHitPower=0

	WeaponDef=class'KFWeapDef_Scout'

	ModifierPerkList(0)=class'KFPerk_Sharpshooter'
	//ModifierPerkList(1)=class'KFPerk_Support'
}
