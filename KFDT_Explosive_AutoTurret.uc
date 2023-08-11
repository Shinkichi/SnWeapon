//=============================================================================
// KFDT_Explosive_AutoTurret
//=============================================================================
// Explosive damage type for AutoTurret explosion
//=============================================================================
// Killing Floor 2
// Copyright (C) 2022 Tripwire Interactive LLC
//=============================================================================

class KFDT_Explosive_AutoTurret extends KFDT_Explosive
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

	KnockdownPower = 100
	StumblePower = 300

	WeaponDef=class'KFWeapDef_AutoTurret'
	ModifierPerkList(0)=class'KFPerk_Commando'

	bCanZedTime=false
	bCanEnrage=false
}
