
class KFDT_Explosive_TacticalRifle extends KFDT_Explosive
	abstract
	hidedropdown;

defaultproperties
{
	bNoInstigatorDamage=true
	bShouldSpawnPersistentBlood=true
	ScreenMaterialName=Effect_Flashbang

	// physics impact
	RadialDamageImpulse=3000
	KDeathUpKick=1000
	KDeathVel=300

	//Afflictions
	KnockdownPower=0
	StumblePower=200
	MeleeHitPower=0
	GunHitPower=0
	StunPower=400

	ObliterationHealthThreshold=-80
	ObliterationDamageThreshold=160

	//Perk
	ModifierPerkList(0)=class'KFPerk_SWAT'
	
	WeaponDef=class'KFWeapDef_TacticalRifle'
}
