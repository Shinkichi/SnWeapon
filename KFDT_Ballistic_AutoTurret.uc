//=============================================================================
// KFDT_Ballistic_AutoTurret
//=============================================================================
// Class Description
//=============================================================================
// Killing Floor 2
// Copyright (C) 2022 Tripwire Interactive LLC
//=============================================================================

class KFDT_Ballistic_AutoTurret extends KFDT_Ballistic_AssaultRifle
	abstract
	hidedropdown;

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100
	
	StumblePower=5
	GunHitPower=0

	WeaponDef=class'KFWeapDef_AutoTurret'

	//Perk
	ModifierPerkList(0)=class'KFPerk_Commando'

	bCanZedTime=false
	bCanEnrage=false
}
