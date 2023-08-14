class KFDT_Bludgeon_RiotHammer extends KFDT_Bludgeon
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=3000 //1500
	KDeathUpKick=0 //0
	KDeathVel=375

	KnockdownPower=100
	StunPower=0
	StumblePower=50
	MeleeHitPower=100

	WeaponDef=class'KFWeapDef_RiotHammer'

	ModifierPerkList(0)=class'KFPerk_Berserker'
	//ModifierPerkList(1)=class'KFPerk_SWAT'
}
