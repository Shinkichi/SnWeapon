//=============================================================================
// KFDT_Piercing_KatanaStab
//=============================================================================
// Killing Floor 2
// Copyright (C) 2015 Tripwire Interactive LLC
//=============================================================================

class KFDT_Piercing_KatanaStab extends KFDT_Piercing
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=200
	KDeathUpKick=250
	
	StumblePower=0
	MeleeHitPower=100

	WeaponDef=class'KFWeapDef_Katana'

	ModifierPerkList(0)=class'KFPerk_Berserker'
}