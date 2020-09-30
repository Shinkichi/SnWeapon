
class KFDT_Ballistic_TacticalRifle extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=10
	GunHitPower=0

	WeaponDef=class'KFWeapDef_TacticalRifle'

	//Perk
	ModifierPerkList(0)=class'KFPerk_SWAT'
	ModifierPerkList(1)=class'KFPerk_Commando'
}
