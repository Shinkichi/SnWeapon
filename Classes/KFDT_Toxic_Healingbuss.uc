class KFDT_Toxic_Healingbuss extends KFDT_Toxic
	abstract
	hidedropdown;

defaultproperties
{

	//DoT
	DoT_Duration=5.0
	DoT_Interval=1.0
	DoT_DamageScale=0.4

	//Afflictions
	PoisonPower=300
	StumblePower=300
	MeleeHitPower=100

	bNoInstigatorDamage=true

	WeaponDef=class'KFWeapDef_Healingbuss'

	ModifierPerkList(0)=class'KFPerk_FieldMedic'
	//ModifierPerkList(1)=class'KFPerk_Berserker'
}
