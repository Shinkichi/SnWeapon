
class KFDT_Ballistic_Auto1911 extends KFDT_Ballistic_Handgun
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=-450
	KDeathVel=200

	KnockdownPower=15
	StumblePower=20
	GunHitPower=100

	WeaponDef=class'KFWeapDef_Auto1911'

	ModifierPerkList(0)=class'KFPerk_Gunslinger'
	//ModifierPerkList(1)=class'KFPerk_Commando'
	//ModifierPerkList(2)=class'KFPerk_SWAT'
}
