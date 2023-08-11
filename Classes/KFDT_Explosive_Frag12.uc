
class KFDT_Explosive_Frag12 extends KFDT_Explosive
    abstract
    hidedropdown;

// Damage type to use for the burning damage over time
var class<KFDamageType> BurnDamageType;

/** Called when damage is dealt to apply additional damage type (e.g. Damage Over Time) */
static function ApplySecondaryDamage(KFPawn Victim, int DamageTaken, optional Controller InstigatedBy)
{
	// Overriden to specific a different damage type to do the burn damage over
	// time. We do this so we don't get shotgun pellet impact sounds/fx during
	// the DOT burning.
	if (default.BurnDamageType.default.DoT_Type != DOT_None)
	{
		Victim.ApplyDamageOverTime(DamageTaken, InstigatedBy, default.BurnDamageType);
	}
}

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

	BurnPower = 50.0//5 //25

	//Perk
    ModifierPerkList(0)=class'KFPerk_Demolitionist'
	ModifierPerkList(1) = class'KFPerk_Firebug'

	WeaponDef=class'KFWeapDef_Frag12'
	BurnDamageType = class'KFDT_Frag12Dot'
}
 