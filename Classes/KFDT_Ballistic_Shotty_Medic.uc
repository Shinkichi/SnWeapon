//class KFDT_Ballistic_Shotty_Medic extends KFDT_Ballistic_Handgun
class KFDT_Ballistic_Shotty_Medic extends KFDT_Ballistic_Shotgun
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100

	StumblePower=0
	GunHitPower=45

	WeaponDef=class'KFWeapDef_MedicShotty'

	//Perk
	ModifierPerkList(0)=class'KFPerk_FieldMedic'
	ModifierPerkList(1)=class'KFPerk_Support'
	ModifierPerkList(2)=class'KFPerk_Gunslinger'
}
