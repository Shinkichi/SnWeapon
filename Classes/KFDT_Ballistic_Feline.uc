
class KFDT_Ballistic_Feline extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=10
	GunHitPower=0

	WeaponDef=class'KFWeapDef_Feline'

	//Perk
	ModifierPerkList(0)=class'KFPerk_SWAT'
}
