class KFDT_Bludgeon_RiotHammerHeavy extends KFDT_Bludgeon_RiotHammer
	abstract
	hidedropdown;

defaultproperties
{
    KDamageImpulse=3000 //1500
	KDeathUpKick=0 //0
	KDeathVel=425

	KnockdownPower=100 //0
	StunPower=0
	StumblePower=100
	MeleeHitPower=100

	WeaponDef=class'KFWeapDef_RiotHammer'

	ModifierPerkList(0)=class'KFPerk_Berserker'
	//ModifierPerkList(1)=class'KFPerk_SWAT'
}
