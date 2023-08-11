class KFDT_Ballistic_LightningBoreImpact extends KFDT_Ballistic_Shell
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

	BurnPower=50
	KnockdownPower=50
	StumblePower=350
	GunHitPower=300

	ModifierPerkList(0)=class'KFPerk_Survivalist'
	ModifierPerkList(1)=class'KFPerk_Demolitionist'
	
	WeaponDef=class'KFWeapDef_ThermiteBore'
}
