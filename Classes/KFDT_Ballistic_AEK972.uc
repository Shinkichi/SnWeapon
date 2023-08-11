class KFDT_Ballistic_AEK972 extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=10
	GunHitPower=50

	WeaponDef=class'KFWeapDef_AEK972'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Commando'
}
