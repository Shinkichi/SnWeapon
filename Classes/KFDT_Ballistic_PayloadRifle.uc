class KFDT_Ballistic_PayloadRifle extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

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
	bNoInstigatorDamage=false
	bShouldSpawnPersistentBlood=true

	KDamageImpulse=3000
	KDeathUpKick=1000
	KDeathVel=500

	KnockdownPower=400//200
	StumblePower=380//340
	GunHitPower=550//275

	WeaponDef=class'KFWeapDef_PayloadRifle'
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
}
