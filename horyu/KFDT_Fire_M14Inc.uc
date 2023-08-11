// M14 Incendiary - By Shinkichi 2020
class KFDT_Fire_M14Inc extends KFDT_Ballistic_Rifle
	abstract
	hidedropdown;
// Damage type to use for the burning damage over time
var class<KFDamageType> BurnDamageType;

/** Allows the damage type to customize exactly which hit zones it can dismember */
static simulated function bool CanDismemberHitZone(name InHitZoneName)
{
	if (super.CanDismemberHitZone(InHitZoneName))
	{
		return true;
	}

	switch (InHitZoneName)
	{
	case 'lupperarm':
	case 'rupperarm':
	case 'chest':
	case 'heart':
		return true;
	}

	return false;
}

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
	WeaponDef=class'KFWeapDef_M14Inc'
	ModifierPerkList(0)=class'KFPerk_Firebug'
	ModifierPerkList(1)=class'KFPerk_Sharpshooter'

	// Physics
	KDamageImpulse=2750
	KDeathUpKick=750
	KDeathVel=450

	// Afflictions
    KnockdownPower=30
	StunPower=40
	StumblePower=50
	GunHitPower=150
	MeleeHitPower=0

	CameraLensEffectTemplate = class'KFCameraLensEmit_Fire'
	EffectGroup = FXG_IncendiaryRound
	BurnDamageType=class'KFDT_Fire_M14IncDoT'
}
