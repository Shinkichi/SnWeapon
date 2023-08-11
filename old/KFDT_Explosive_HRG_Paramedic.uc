
class KFDT_Explosive_HRG_Paramedic extends KFDT_Explosive
	abstract
	hidedropdown;

defaultproperties
{
	bShouldSpawnPersistentBlood = true

	// physics impact
	RadialDamageImpulse = 2000
	GibImpulseScale = 0.15
	KDeathUpKick = 1000
	KDeathVel = 300

	KnockdownPower = 50
	StumblePower = 150

	WeaponDef=class'KFWeapDef_HRG_Paramedic'
	ModifierPerkList(0)=class'KFPerk_FieldMedic'

	bCanZedTime=false
	bCanEnrage=false
}
