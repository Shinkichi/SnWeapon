//class KFDT_Ballistic_HX63A extends KFDT_Ballistic_Shotgun
class KFDT_Ballistic_HX63A extends KFDT_Ballistic_AssaultRifle
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
	BloodSpread=0.4
	BloodScale=0.6
	EffectGroup=FXG_UnexplodedGrenade

	KDamageImpulse=350
	KDeathUpKick=120
	KDeathVel=10

    KnockdownPower=0
	StumblePower=75
	GunHitPower=0

	WeaponDef=class'KFWeapDef_HX63A'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
   	ModifierPerkList(1)=class'KFPerk_Commando'
}
