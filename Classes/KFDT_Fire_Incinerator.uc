
class KFDT_Fire_Incinerator extends KFDT_Ballistic_Handgun
	abstract;

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
	WeaponDef=class'KFWeapDef_Incinerator'
	ModifierPerkList(0)=class'KFPerk_Firebug'

	EffectGroup=FXG_Flare
	BurnDamageType=class'KFDT_Fire_IncineratorDoT'
	CameraLensEffectTemplate=class'KFCameraLensEmit_Fire'

	KDamageImpulse=1000
	KDeathUpKick=120
	KDeathVel=10

	BurnPower=30 //2.5 //15.5
	KnockdownPower=15
	StumblePower=100//50
	GunHitPower=150
}