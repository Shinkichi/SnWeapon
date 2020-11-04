
class KFDT_Ballistic_Trenchgun extends KFDT_Ballistic_Shotgun
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
	BloodSpread=0.4
	BloodScale=0.6

	KDamageImpulse=3500
	KDeathUpKick=800
	KDeathVel=650
	GibImpulseScale=1.0

    StumblePower=55
	GunHitPower=75
	
	WeaponDef=class'KFWeapDef_Trenchgun'

	ModifierPerkList(0)=class'KFPerk_Support'
}
