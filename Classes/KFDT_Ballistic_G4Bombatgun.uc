
class KFDT_Ballistic_G4Bombatgun extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=3500
	KDeathUpKick=800 //600
	KDeathVel=650 //450

    StumblePower=75
	GunHitPower=45
	
	WeaponDef=class'KFWeapDef_G4Bombatgun'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
}
