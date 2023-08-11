class KFDT_Bludgeon_Gunzerks extends KFDT_Bludgeon
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=2500 
	KDeathUpKick=500
	KDeathVel=400

	MeleeHitPower=100
	StunPower=0
	StumblePower=0

	WeaponDef=class'KFWeapDef_HRG_Gunzerks'
	//ModifierPerkList(0)=class'KFPerk_Gunslinger'
	//ModifierPerkList(1)=class'KFPerk_Firebug'
}
