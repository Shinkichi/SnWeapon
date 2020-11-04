//=============================================================================
// KFDT_Bludgeon_Pulverizer
//=============================================================================
// Killing Floor 2
// Copyright (C) 2015 Tripwire Interactive LLC
//=============================================================================

class KFDT_Bludgeon_PulverizerBash extends KFDT_Bludgeon_Pulverizer
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=1600
	KDeathUpKick=0
	KDeathVel=500

	KnockdownPower=0
	StunPower=0
	StumblePower=200
	MeleeHitPower=100

	WeaponDef=class'KFWeapDef_Pulverizer'

	ModifierPerkList(0)=class'KFPerk_Berserker'
	ModifierPerkList(1)=class'KFPerk_Demolitionist'
}
