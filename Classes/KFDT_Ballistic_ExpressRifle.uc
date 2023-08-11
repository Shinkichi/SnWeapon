
class KFDT_Ballistic_ExpressRifle extends KFDT_Ballistic_Rifle
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
	// Physics
	KDamageImpulse=2750
	KDeathUpKick=750
	KDeathVel=450

	// Afflictions
    KnockdownPower=30
	StunPower=40
	StumblePower=50
	GunHitPower=150

	ModifierPerkList.Empty()
	ModifierPerkList(0)=class'KFPerk_Sharpshooter'
	
	WeaponDef=class'KFWeapDef_ExpressRifle'
}
