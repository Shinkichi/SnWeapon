
class KFDT_Ballistic_JavelinGunImpact extends KFDT_Ballistic_Shell
	abstract
	hidedropdown;

static simulated function bool CanDismemberHitZone(name InHitZoneName)
{
	return false;
}

static simulated function bool CanDismemberHitZoneWhileAlive(name InHitZoneName)
{
    return false;
}

defaultproperties
{
	KDamageImpulse=0
	KDeathUpKick=0
	KDeathVel=0

	StumblePower=340
	GunHitPower=275

	ModifierPerkList(0)=class'KFPerk_Berserker'

	WeaponDef=class'KFWeapDef_JavelinGun'
}
