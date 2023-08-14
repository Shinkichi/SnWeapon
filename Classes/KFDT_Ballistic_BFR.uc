
class KFDT_Ballistic_BFR extends KFDT_Ballistic_Handgun
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
	KDamageImpulse=2000
	KDeathUpKick=400
	KDeathVel=250

    KnockdownPower=25
	//StunPower=20 //25
	StumblePower=80
	GunHitPower=160
	//MeleeHitPower=0

	WeaponDef=class'KFWeapDef_BFR'
	ModifierPerkList(0)=class'KFPerk_Gunslinger'
	ModifierPerkList(1)=class'KFPerk_Sharpshooter'
}
