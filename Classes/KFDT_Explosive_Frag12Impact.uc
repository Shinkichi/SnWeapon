
class KFDT_Explosive_Frag12Impact extends KFDT_Ballistic_Shell
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

	//Perk
    ModifierPerkList(0)=class'KFPerk_Demolitionist'
	ModifierPerkList(1) = class'KFPerk_Firebug'
	
	WeaponDef=class'KFWeapDef_Frag12'
}
 