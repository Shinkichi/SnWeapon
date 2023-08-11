class KFDT_Slashing_MurasamaBladeSpecial extends KFDT_Slashing_MurasamaBlade
	abstract;

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
	// Physics
	KDamageImpulse=2500//5000
	KDeathUpKick=1000//2000
	KDeathVel=1875//3750

	// Afflictions
	KnockdownPower=250//500
	StumblePower=250//500
	MeleeHitPower=250//500

	WeaponDef=class'KFWeapDef_MurasamaBlade'

	ModifierPerkList(0)=class'KFPerk_Berserker'
}