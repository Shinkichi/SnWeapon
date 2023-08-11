//class KFDT_Ballistic_BAR extends KFDT_Ballistic_Rifle
class KFDT_Ballistic_BAR extends KFDT_Ballistic_AssaultRifle
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
	KDamageImpulse=2000
	KDeathUpKick=400
	KDeathVel=250

    KnockdownPower=20
	StunPower=25 //25
	StumblePower=85
	GunHitPower=80 //100
	MeleeHitPower=0

	WeaponDef=class'KFWeapDef_BAR'
	ModifierPerkList(0)=class'KFPerk_Commando'
	ModifierPerkList(1)=class'KFPerk_Sharpshooter'
}
