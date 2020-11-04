//=============================================================================
// KFDT_Bludgeon_Pulverizer
//=============================================================================
// Killing Floor 2
// Copyright (C) 2015 Tripwire Interactive LLC
//=============================================================================

class KFDT_Bludgeon_Pulverizer extends KFDT_Bludgeon
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=3000 //1500
	KDeathUpKick=0 //0
	KDeathVel=375

	KnockdownPower=100
	StunPower=0
	StumblePower=50
	MeleeHitPower=100

	WeaponDef=class'KFWeapDef_Pulverizer'

	ModifierPerkList(0)=class'KFPerk_Berserker'
	ModifierPerkList(1)=class'KFPerk_Demolitionist'
}
