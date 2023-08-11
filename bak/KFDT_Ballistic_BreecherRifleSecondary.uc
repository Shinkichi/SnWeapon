class KFDT_Ballistic_BreecherRifleSecondary extends KFDT_Ballistic_Shotgun
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
	KDeathUpKick=800 //600
	KDeathVel=650 //450
	//KDamageImpulse=160 //600 //350
	GibImpulseScale=1.0
	//KDeathUpKick=250 //350
	//KDeathVel=15 //20 

    StumblePower=35  //8
	GunHitPower=45
	
	WeaponDef=class'KFWeapDef_BreecherRifle'
}
