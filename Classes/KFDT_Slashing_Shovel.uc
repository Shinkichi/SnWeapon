
class KFDT_Slashing_Shovel extends KFDT_Slashing
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1250
	KDeathUpKick=500
	KDeathVel=250

	MeleeHitPower=0//50
	StunPower=0
	StumblePower=0//50
	
	PoisonPower=1000
	
	WeaponDef=class'KFWeapDef_Shovel'
	ModifierPerkList(0)=class'KFPerk_Berserker'	
}
