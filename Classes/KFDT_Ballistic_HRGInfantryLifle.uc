class KFDT_Ballistic_HRGInfantryLifle extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100

	StumblePower=15
	GunHitPower=175

	WeaponDef=class'KFWeapDef_HRGInfantryLifle'

	ModifierPerkList(0)=class'KFPerk_Survivalist'
	EffectGroup=FXG_Energy_Yellow
}
