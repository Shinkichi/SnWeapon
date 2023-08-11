class KFDT_Slashing_HRG_Kamaitachi extends KFDT_Slashing
	abstract;

var class<KFDamageType> BleedDamageType;

/** Called when damage is dealt to apply additional damage type (e.g. Damage Over Time) */
static function ApplySecondaryDamage( KFPawn Victim, int DamageTaken, optional Controller InstigatedBy )
{
    // potential for two DoTs if DoT_Type is set
    if (default.BleedDamageType.default.DoT_Type != DOT_None)
    {
        Victim.ApplyDamageOverTime(DamageTaken, InstigatedBy, default.BleedDamageType);
    }
}

static simulated function bool CanDismemberHitZone( name InHitZoneName )
{
	return true;
}

defaultproperties
{
	EffectGroup=FXG_Sawblade
	KDamageImpulse=1000
	KDeathUpKick=800
	KDeathVel=600

	StunPower=0
	StumblePower=100  //5
	MeleeHitPower=20

    BleedDamageType=class'KFDT_Bleeding_HRG_Kamaitachi'

	WeaponDef=class'KFWeapDef_HRG_Kamaitachi'

	ModifierPerkList(0)=class'KFPerk_Berserker'
}
