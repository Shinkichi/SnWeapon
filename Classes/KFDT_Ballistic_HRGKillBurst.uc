class KFDT_Ballistic_HRGKillBurst extends KFDT_Ballistic_Handgun
    abstract
    hidedropdown;

/** Allows the damage type to customize exactly which hit zones it can dismember */
static simulated function bool CanDismemberHitZone( name InHitZoneName )
{
    switch ( InHitZoneName )
	{
		case 'lupperarm':
		case 'rupperarm':
		case 'chest':
		case 'heart':
		case 'lcalf':
		case 'rcalf':
		case 'lthigh':
		case 'rthigh':
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

    WeaponDef=class'KFWeapDef_HRGKillBurst'

    ModifierPerkList(0)=class'KFPerk_Gunslinger'
}
