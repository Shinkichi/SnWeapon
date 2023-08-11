class KFDT_Slashing_MurasamaBladeHeavy extends KFDT_Slashing_MurasamaBlade
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
	KDamageImpulse=300
	KDeathUpKick=400

	StumblePower=0//50 
	MeleeHitPower=0//100

	WeaponDef=class'KFWeapDef_MurasamaBlade'

	ModifierPerkList(0)=class'KFPerk_Berserker'
}