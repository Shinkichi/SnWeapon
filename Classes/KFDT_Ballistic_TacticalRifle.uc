
class KFDT_Ballistic_TacticalRifle extends KFDT_Ballistic_AssaultRifle
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
	KDamageImpulse=1000
	KDeathUpKick=-200
	KDeathVel=135
	
	StumblePower=15
	GunHitPower=0

	WeaponDef=class'KFWeapDef_TacticalRifle'

	//Perk
	ModifierPerkList(0)=class'KFPerk_SWAT'
	ModifierPerkList(1)=class'KFPerk_Commando'
}
