class KFDT_Bludgeon_RiotHammerBash extends KFDT_Bludgeon_RiotHammer
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1600
	KDeathUpKick=0
	KDeathVel=500

	KnockdownPower=0
	StunPower=0
	StumblePower=200
	MeleeHitPower=100

	WeaponDef=class'KFWeapDef_RiotHammer'

	ModifierPerkList(0)=class'KFPerk_Berserker'
	//ModifierPerkList(1)=class'KFPerk_SWAT'
}
