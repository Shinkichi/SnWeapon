
class KFDT_Explosive_SMEG extends KFDT_Explosive
	abstract
	hidedropdown;

defaultproperties
{
	bShouldSpawnPersistentBlood=true

	// physics impact
	RadialDamageImpulse=3000
	KDeathUpKick=1000
	KDeathVel=300

    StunPower=200   //125
	MeleeHitPower=100
	StumblePower=500

	WeaponDef=class'KFWeapDef_SMEG'
    ModifierPerkList(0)=class'KFPerk_Support'
}