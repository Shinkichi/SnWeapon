
class KFDT_Ballistic_Viper50 extends KFDT_Ballistic_Submachinegun
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
		case 'chest':
		case 'heart':
	 		return true;
	}

	return false;
}

defaultproperties
{
	KDamageImpulse=2500
	KDeathUpKick=-500
	KDeathVel=250

	KnockdownPower=20
	StumblePower=30
	GunHitPower=150

	WeaponDef=class'KFWeapDef_Viper50'
	ModifierPerkList(0)=class'KFPerk_SWAT'
}
