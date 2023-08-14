class KFDT_Ballistic_PlasmaCutter extends KFDT_Ballistic_Shotgun
//class KFDT_Ballistic_PlasmaCutter extends KFDT_EMP
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

	KDamageImpulse=1250
	KDeathUpKick=400
	KDeathVel=300
	GibImpulseScale=1.0

    StumblePower=15
	GunHitPower=25

	EMPPower=8

	WeaponDef=class'KFWeapDef_HRG_Electro'
	
	ModifierPerkList.Empty()
	ModifierPerkList(0)=class'KFPerk_Survivalist'
}
