class KFDT_Explosive_HRGInfantryLifle extends KFDT_Fire
	abstract;

// Damage type to use for the burning damage over time
var class<KFDamageType> BurnDamageType;

/** Play damage type specific impact effects when taking damage */
static function PlayImpactHitEffects(KFPawn P, vector HitLocation, vector HitDirection, byte HitZoneIndex, optional Pawn HitInstigator)
{
	// Play burn effect when dead
	if (P.bPlayedDeath && P.WorldInfo.TimeSeconds > P.TimeOfDeath)
	{
		default.BurnDamageType.static.PlayImpactHitEffects(P, HitLocation, HitDirection, HitZoneIndex, HitInstigator);
		return;
	}

	super.PlayImpactHitEffects(P, HitLocation, HitDirection, HitZoneIndex, HitInstigator);
}

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
	//Duration over time variables
	DoT_Duration=INDEX_NONE
	DoT_Interval=INDEX_NONE
	DoT_DamageScale=0

	bShouldSpawnPersistentBlood=true

	// physics impact
	RadialDamageImpulse=2000//3000
	GibImpulseScale=0.15
	KDeathUpKick=1000
	KDeathVel=300


	//Afflictions
	StumblePower=200
	BurnPower=50

	// Grenade explosion does damage the instigator
	bNoInstigatorDamage=false
	
	WeaponDef=class'KFWeapDef_HRGInfantryLifle'
	BurnDamageType=class'KFDT_Fire_HRGIncendiaryRifleGrenadeDoT'

	ModifierPerkList(0)=class'KFPerk_Survivalist'
}
