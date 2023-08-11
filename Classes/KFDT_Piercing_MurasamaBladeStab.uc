class KFDT_Piercing_MurasamaBladeStab extends KFDT_Piercing
	abstract
	hidedropdown;

var class<KFDamageType> BleedDamageType;

/**
* Allows the damage type to customize exactly which hit zones it can dismember while the zed is alive
*/
static simulated function bool CanDismemberHitZoneWhileAlive(name InHitZoneName)
{
    return false;
}

/** Called when damage is dealt to apply additional damage type (e.g. Damage Over Time) */
static function ApplySecondaryDamage( KFPawn Victim, int DamageTaken, optional Controller InstigatedBy )
{
    // potential for two DoTs if DoT_Type is set
    if (default.BleedDamageType.default.DoT_Type != DOT_None)
    {
        Victim.ApplyDamageOverTime(DamageTaken, InstigatedBy, default.BleedDamageType);
    }
}

defaultproperties
{
	KDamageImpulse=200
	KDeathUpKick=250
	
	StumblePower=0
	MeleeHitPower=0//100

    BleedDamageType=class'KFDT_Bleeding_MurasamaBlade'

	WeaponDef=class'KFWeapDef_MurasamaBlade'

	ModifierPerkList(0)=class'KFPerk_Berserker'
}