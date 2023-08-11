class KFDT_Ballistic_KVolt extends KFDT_Ballistic_Submachinegun
//class KFDT_Ballistic_KVolt extends KFDT_EMP
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100

	StumblePower=15
	GunHitPower=15

	EMPPower=8

	WeaponDef=class'KFWeapDef_KVolt'
	ModifierPerkList(0)=class'KFPerk_FieldMedic'
	ModifierPerkList(1)=class'KFPerk_SWAT'
	ModifierPerkList(2)=class'KFPerk_Survivalist'

	EffectGroup=FXG_Electricity
}
