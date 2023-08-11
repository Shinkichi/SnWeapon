class KFDT_Ballistic_Musket extends KFDT_Ballistic_Rifle
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
	GoreDamageGroup=DGT_Shotgun

	KDamageImpulse=4500
	KDeathUpKick=-700
	KDeathVel=350

   	KnockdownPower=25
	StumblePower=60
	GunHitPower=200

	ModifierPerkList(0)=class'KFPerk_Sharpshooter'
	ModifierPerkList(1)=class'KFPerk_Gunslinger'
	WeaponDef=class'KFWeapDef_Musket'
}
