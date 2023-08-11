class KFDT_Ballistic_AR45 extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=900
    KDeathUpKick=-300
    KDeathVel=100

    StumblePower=16
    GunHitPower=16

	WeaponDef=class'KFWeapDef_AR45'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Commando'
}
