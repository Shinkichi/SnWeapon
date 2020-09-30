
class KFDT_Explosive_Frag12 extends KFDT_Explosive
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

	KnockdownPower=50
	StumblePower=170
    MeleeHitPower=50

	// unreal physics momentum
    bExtraMomentumZ=false

	//Perk
    ModifierPerkList(0) = class'KFPerk_Demolitionist'
    
	
	WeaponDef=class'KFWeapDef_Frag12'
}
 