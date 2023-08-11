
class KFDT_Ballistic_AR50 extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=5
	GunHitPower=0

	WeaponDef=class'KFWeapDef_AR50'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Commando'
}
