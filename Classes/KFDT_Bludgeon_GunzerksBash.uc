
class KFDT_Bludgeon_GunzerksBash extends KFDT_Bludgeon
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=3500
	KDeathUpKick=800
	KDeathVel=575

	KnockdownPower=0
	StunPower=0
    StumblePower=200
    MeleeHitPower=100

    WeaponDef=class'KFWeapDef_HRG_Gunzerks'
	//ModifierPerkList(0)=class'KFPerk_Gunslinger'
	//ModifierPerkList(1)=class'KFPerk_Firebug'
}
