
class KFDT_Bludgeon_Shovel extends KFDT_Bludgeon
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=800
	KDeathVel=400

	KnockdownPower=0
	StunPower=0
	StumblePower=0//100
	MeleeHitPower=0//100
	
	BigHeadPower=1000
	ShrinkPower=1000

	WeaponDef=class'KFWeapDef_Shovel'
	ModifierPerkList(0)=class'KFPerk_Berserker'
}
