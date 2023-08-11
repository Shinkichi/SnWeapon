class KFDT_Ballistic_HRGInfantryLifleGrenadeImpact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

// Damage type to use for the burning damage over time
var class<KFDamageType> BurnDamageType;

/** Called when damage is dealt to apply additional damage type (e.g. Damage Over Time) */
static function ApplySecondaryDamage( KFPawn Victim, int DamageTaken, optional Controller InstigatedBy )
{	
	// Overriden to specific a different damage type to do the burn damage over
	// time. We do this so we don't get shotgun pellet impact sounds/fx during
	// the DOT burning.
    if ( default.BurnDamageType.default.DoT_Type != DOT_None )
    {
        Victim.ApplyDamageOverTime(DamageTaken, InstigatedBy, default.BurnDamageType);
    }
}

defaultproperties
{
	WeaponDef=class'KFWeapDef_HRGInfantryLifle'
	ModifierPerkList(0)=class'KFPerk_Survivalist'

	EffectGroup=FXG_Flare
	BurnDamageType=class'KFDT_Fire_HRGInfantryLifleDoT'
	CameraLensEffectTemplate=class'KFCameraLensEmit_Fire'

	KDamageImpulse=1000
	KDeathUpKick=120
	KDeathVel=10

	BurnPower=45 
	KnockdownPower=70
	StumblePower=400 //250
	GunHitPower=275 //150
}