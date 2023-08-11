class KFDT_Ballistic_ThermalImploderImpactAlt extends KFDT_Ballistic_Handgun
	abstract;

defaultproperties
{
	WeaponDef=class'KFWeapDef_ThermalImploder'
	ModifierPerkList(0)=class'KFPerk_Firebug'

	EffectGroup=FXG_Flare
	CameraLensEffectTemplate=class'KFCameraLensEmit_Fire'

	KDamageImpulse=1000
	KDeathUpKick=120
	KDeathVel=10

	BurnPower=20
	StumblePower=200 //150
	GunHitPower=150 //100
}