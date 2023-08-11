class KFDT_Bludgeon_GunzerksHeavy extends KFDT_Bludgeon
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=3500
	KDeathUpKick=800
	KDeathVel=575

	KnockdownPower=75
	StunPower=0
	StumblePower=150
	MeleeHitPower=150
    EMPPower=0

	WeaponDef=class'KFWeapDef_HRG_Gunzerks'
	//ModifierPerkList(0)=class'KFPerk_Gunslinger'
	//ModifierPerkList(1)=class'KFPerk_Firebug'

	//OverrideImpactEffect=ParticleSystem'WEP_HRG_BlastBrawlers_EMIT.FX_Static_Strikers_Impact'
}
