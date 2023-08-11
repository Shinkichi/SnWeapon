class KFDT_Toxic_HRGVitaminImpact extends KFDT_Toxic
	abstract;

defaultproperties
{
	KDamageImpulse=1000
	KDeathUpKick=700
	KDeathVel=350

	//FreezePower=5 //0
	StumblePower=50
	GunHitPower=150 //100

	WeaponDef=class'KFWeapDef_HRGVitamin'
	
	ModifierPerkList(0)=class'KFPerk_FieldMedic'
	ModifierPerkList(1)=class'KFPerk_Gunslinger'
}
