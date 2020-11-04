class KFDT_Ballistic_RPK12 extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=10
	GunHitPower=0

	WeaponDef=class'KFWeapDef_RPK12'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Commando'
}
