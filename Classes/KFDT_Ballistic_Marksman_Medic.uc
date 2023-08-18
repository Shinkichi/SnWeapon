class KFDT_Ballistic_Marksman_Medic extends KFDT_Ballistic_Rifle
//class KFDT_Ballistic_Marksman_Medic extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

/** Allows the damage type to customize exactly which hit zones it can dismember */
static simulated function bool CanDismemberHitZone( name InHitZoneName )
{
	if( super.CanDismemberHitZone( InHitZoneName ) )
	{
		return true;
	}

	switch ( InHitZoneName )
	{
		case 'lupperarm':
		case 'rupperarm':
	 		return true;
	}

	return false;
}

/** Called when damage is dealt to apply additional damage type (e.g. Damage Over Time) */
static function ApplySecondaryDamage( KFPawn Victim, int DamageTaken, optional Controller InstigatedBy )
{
    local class<KFDamageType> ToxicDT;

    ToxicDT = class'KFDT_Ballistic_Assault_Medic'.static.GetMedicToxicDmgType( DamageTaken, InstigatedBy );
    if ( ToxicDT != None )
    {
        Victim.ApplyDamageOverTime(DamageTaken, InstigatedBy, ToxicDT);
    }
}

/**
 * Allows medic perk to add poison damage 
 * @return: None if toxic skill is not available
 */
static function class<KFDamageType> GetMedicToxicDmgType( out int out_Damage, optional Controller InstigatedBy ) 
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = KFPlayerController(InstigatedBy).GetPerk();
	if( InstigatorPerk == none || (!InstigatorPerk.IsToxicDmgActive() && !InstigatorPerk.IsZedativeActive()) )
	{
		return None;
	}	

	InstigatorPerk.ModifyToxicDmg( out_Damage );
	return InstigatorPerk.GetToxicDmgTypeClass();
}

defaultproperties
{
    KDamageImpulse=2000
    KDeathUpKick=-450
    KDeathVel=200

    KnockdownPower=12//15
    StumblePower=16//20
    GunHitPower=100

	WeaponDef=class'KFWeapDef_MedicMarksman'

	//Perk
	ModifierPerkList(0)=class'KFPerk_FieldMedic'
    ModifierPerkList(1)=class'KFPerk_SharpShooter'
}
