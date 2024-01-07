class KFDT_Ballistic_ChiappaHippoShrapnel extends KFDT_Ballistic_Shotgun
    abstract
    hidedropdown;

defaultproperties
{
	KDamageImpulse=1500
	KDeathUpKick=-450
	KDeathVel=200

	KnockdownPower=30//15
	StumblePower=40//20
	GunHitPower=200//100

    WeaponDef=class'KFWeapDef_ChiappaHippo'

    ModifierPerkList(0)=class'KFPerk_Gunslinger'
}
