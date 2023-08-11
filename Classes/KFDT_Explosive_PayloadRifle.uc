class KFDT_Explosive_PayloadRifle extends KFDT_Explosive
	abstract
	hidedropdown;

defaultproperties
{
	//bNoInstigatorDamage=false
	bShouldSpawnPersistentBlood=true

	// physics impact
	RadialDamageImpulse=10000
	KDeathUpKick=2000
	KDeathVel=500

	KnockdownPower=40 //225
	StumblePower=70 //400

	ObliterationHealthThreshold=-500
	ObliterationDamageThreshold=500

	//Perk
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
	
	WeaponDef=class'KFWeapDef_PayloadRifle'
}
 