
class KFDT_Ballistic_PDR_Medic extends KFDT_Ballistic_AssaultRifle
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

defaultproperties
{
	KDamageImpulse=1000
	KDeathUpKick=-200
	KDeathVel=135
	
	StumblePower=25
	GunHitPower=45

	WeaponDef=class'KFWeapDef_MedicPDR'

    //Perk
    ModifierPerkList(0)=class'KFPerk_FieldMedic'
    ModifierPerkList(1)=class'KFPerk_Commando'
    ModifierPerkList(2)=class'KFPerk_SWAT'
}
