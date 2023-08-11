class KFDT_Ballistic_Henry extends KFDT_Ballistic_Rifle
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
	KDamageImpulse=2500
	KDeathUpKick=-500
	KDeathVel=200

	KnockdownPower=15
	StumblePower=50
	GunHitPower=150

	ModifierPerkList(0)=class'KFPerk_Sharpshooter'
	WeaponDef=class'KFWeapDef_Henry1860'
}
