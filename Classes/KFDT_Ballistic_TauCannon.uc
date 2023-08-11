class KFDT_Ballistic_TauCannon extends KFDT_Ballistic_Rifle
//class KFDT_Ballistic_TauCannon extends KFDT_Ballistic_Shotgun
	abstract
	hidedropdown;

defaultproperties
{
	bNoInstigatorDamage=false
	bShouldSpawnPersistentBlood=true

	// physics impact
	RadialDamageImpulse=1500//1500 //2500 //1500
	KDamageImpulse=900 //900
	GibImpulseScale=0.15 //0.15
	KDeathUpKick=500//225  //500 //1500
	KDeathVel=500 //225 //500

	StumblePower=45//30//15

	EMPPower=24//8

	WeaponDef=class'KFWeapDef_TauCannon'
	ModifierPerkList(0)=class'KFPerk_Survivalist'
	ModifierPerkList(1)=class'KFPerk_Sharpshooter'
}
