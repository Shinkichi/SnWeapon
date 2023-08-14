class KFDT_Explosive_HX63A extends KFDT_Explosive
	abstract
	hidedropdown;

defaultproperties
{
	bShouldSpawnPersistentBlood=true

	// physics impact
	RadialDamageImpulse=2500  //2000
	KDeathUpKick=350   //350
	KDeathVel=250    //250

	KnockdownPower=5
	StumblePower=10

	//Perk
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
	
	WeaponDef=class'KFWeapDef_HX63A'
}
 