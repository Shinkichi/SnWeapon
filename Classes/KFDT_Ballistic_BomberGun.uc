class KFDT_Ballistic_BomberGun extends KFDT_Ballistic_Shell
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
	KDamageImpulse=3500
	KDeathUpKick=800 //600
	KDeathVel=650 //450

    StumblePower=75
	GunHitPower=45
	
	WeaponDef=class'KFWeapDef_BomberGun'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
	ModifierPerkList(1)=class'KFPerk_Gunslinger'
}
