class KFWeap_Edged_MurasamaBlade extends KFWeap_MeleeBase;

/** The current amount of charge/heat this weapon has */
var repnotify float UltimateCharge;
/** The highest amount of charge/heat this weapon can have*/
var float MaxUltimateCharge;
/** How often the DecayAmount is removed from a non-fully charged weapon */
var float DecayInterval;
/** How much charge to remove every <DecayInterval> seconds*/
var float DecayAmount;

/** How much charge to gain when hitting with each Firemode */
var array<float> UltimateChargePerHit;
/** How much charge to gain with a successful block */
var float UltimateChargePerBlock;
/** How much charge to gain with a successful parry */
var float UltimateChargePerParry;

/** Name of the special anim used for the ultimate attack */
var name UltimateAttackAnim;

/** Hitbox for the normal attack */
var array<MeleeHitBoxInfo> DefaultHitboxChain;
/** Hitbox for the ultimate attack */
var array<MeleeHitBoxInfo> UltimateHitboxChain;

/** Hit range for the default attack */
var int DefaultMaxHitRange;
/** Hit range for the ultimate attack, generated from DefaultMaxHitrange and UltimateRangeScale*/
var int UltimateMaxHitRange;
/** Relative length of the ultimate hitbox compared to the default hitbox*/
var float UltimateRangeScale;
/** Width of the ultimate hotbox */
var float UltimateWidthScale;
/** Extent of the default hitbox, defaults to 0*/
var vector DefaultHitboxExtent;
/** Extent of the Ultimate Hitbox*/
var vector UltimateHitboxExtent;


replication
{
	if (bNetDirty)
		UltimateCharge;
}

simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
	case nameof(UltimateCharge):
		AdjustChargeFX();
		break;
	default:
		super.ReplicatedEvent(VarName);
	};
}

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	SetupHitboxes();
	//Decay time removed due to feedback
	//SetTimer(DecayInterval, true, nameof(TimeR_UltimateChargeDecay));
}

/** Create box the default and ultimate hitboxes */
simulated function SetupHitboxes()
{
	SetupChain(DefaultHitboxChain, DefaultMaxHitRange, DefaultHitboxExtent);
	UltimateMaxHitRange = UltimateRangeScale * DefaultMaxHitRange;
	UltimateHitboxExtent.X = UltimateWidthScale;
	UltimateHitboxExtent.Y = UltimateWidthScale;
	UltimateHitboxExtent.Z = UltimateWidthScale;
	SetupChain(UltimateHitboxChain, UltimateMaxHitRange, UltimateHitboxExtent);

	// set the default hitbox as the active hitbox
	MeleeAttackHelper.HitboxExtent = DefaultHitboxExtent;
	MeleeAttackHelper.SetHitboxChain(DefaultHitboxChain);
	MeleeAttackHelper.SetMeleeRange(DefaultMaxHitRange);
}

/** Programmatically generate the hitbox chain */
simulated function SetupChain(out array<MeleeHitBoxInfo> OutputChain, int InputHitRange, vector HitboxExtent)
{
	local vector BoneAxis;
	local float Dist;
	local MeleeHitBoxInfo TempHitBoxInfo;

	BoneAxis = vect(0, 0, 1);
	for (Dist = InputHitRange; Dist > 0; Dist -= MeleeAttackHelper.HitboxSpacing)
	{
		TempHitBoxInfo.BoneOffset = (Dist - HitboxExtent.X) * BoneAxis;
		OutputChain.AddItem(TempHitBoxInfo);
	}
}

/** Lose charge over time */
simulated function Timer_UltimateChargeDecay()
{
	// as long as not already fully charged
	if (UltimateCharge != MaxUltimateCharge)
	{
		AdjustUltimateCharge(DecayAmount * -1);
	}
}

simulated function string GetSpecialAmmoForHUD()
{
	return int(UltimateCharge)$"%";
}

/** When this weapon hits with an attack */
simulated function NotifyMeleeCollision(Actor HitActor, optional vector HitLocation)
{
	local KFPawn_Monster Victim;

	if (HitActor.bWorldGeometry)
	{
		return;
	}

	Victim = KFPawn_Monster(HitActor);
	if ( Victim == None || (Victim.bPlayedDeath && `TimeSince(Victim.TimeOfDeath) > 0.f) )
	{
		return;
	}

	if(Victim != none)
	{
		// hit something with a melee attack so gain charge
		AdjustUltimateCharge(UltimateChargePerHit[CurrentFireMode]);
	}
}

/** When this weapon parries an attack */
simulated function NotifyAttackParried()
{
	AdjustUltimateCharge(UltimateChargePerParry);
}

/** When this weapon blocks an attack */
simulated function NotifyAttackBlocked()
{
	AdjustUltimateCharge(UltimateChargePerBlock);
}

/** Whether the weapon is fully charged */
simulated function bool IsFullyCharged()
{
	return UltimateCharge >= MaxUltimateCharge;
}

/** Increase or decrease ultimate charge as long as not already fully charged*/
simulated function AdjustUltimateCharge(float AdjustAmount)
{
	if (!IsFullyCharged())
	{
		UltimateCharge = FClamp(UltimateCharge + AdjustAmount, 0.f, MaxUltimateCharge);
		AdjustChargeFX();
	}
}

simulated function AdjustChargeFX()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		KFPawn(Instigator).SetWeaponComponentRTPCValue("Weapon_Charge", UltimateCharge / MaxUltimateCharge);
		Instigator.SetRTPCValue('Weapon_Charge', UltimateCharge / MaxUltimateCharge);

		/*if (IsFullyCharged())
		{
			ActivatePSC(ChargedPSC, ChargedEffect, 'Hand_FX_Start_R');
			AdjustLoopingWeaponSound(true);
		}*/
	}
}

// OLD WAY (heavyfire firemode)
//simulated state MeleeHeavyAttacking
//{
//	simulated event BeginState(Name PreviousStateName)
//	{
//		Super.BeginState(PreviousStateName);
//
//		if (IsFullyCharged())
//		{
//			// perform ultimate
//			SendToFiringState(CUSTOM_FIREMODE);
//		}
//	}
//}

// NEW WAY (reload firemode)
simulated function StartFire(byte FireModeNum)
{
	if (FireModeNum == RELOAD_FIREMODE && IsFullyCharged())
	{
		FireModeNum = CUSTOM_FIREMODE;
	}

	super.StartFire(FireModeNum);
}

/** State for the fully charged Ultimate attack */
simulated state UltimateAttackState extends MeleeHeavyAttacking
{
	simulated function bool TryPutDown() { return false; }

	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);

		// stop the player from interrupting the super attack with another attack
		StartFireDisabled = true;

		// swap to the larger ultimate hitbox
		MeleeAttackHelper.HitboxExtent = UltimateHitboxExtent;
		MeleeAttackHelper.SetHitboxChain(UltimateHitboxChain);
		MeleeAttackHelper.SetMeleeRange(UltimateMaxHitRange);
		MeleeAttackHelper.bUseDirectionalMelee = false;
		MeleeAttackHelper.bHasChainAttacks = false;
	}

	simulated function name GetMeleeAnimName(EPawnOctant AtkDir, EMeleeAttackType AtkType)
	{
		// use the special attack anim
		return UltimateAttackAnim;
	}

	simulated event EndState(Name NextStateName)
	{
		super.EndState(NextStateName);

		// consume charge
		UltimateCharge = 0;
		KFPawn(Instigator).SetWeaponComponentRTPCValue("Weapon_Charge", 0.0f);
		Instigator.SetRTPCValue('Weapon_Charge', 0.0f);

		// player can now interrupt attacks with other attacks again
		StartFireDisabled = false;

		// swap back to the default hitbox
		MeleeAttackHelper.HitboxExtent = DefaultHitboxExtent;
		MeleeAttackHelper.SetHitboxChain(DefaultHitboxChain);
		MeleeAttackHelper.SetMeleeRange(DefaultMaxHitRange);
		MeleeAttackHelper.bUseDirectionalMelee = true;
		MeleeAttackHelper.bHasChainAttacks = true;
	}
}

simulated event bool HasAmmo(byte FireModeNum, optional int Amount)
{
	if (FireModeNum == CUSTOM_FIREMODE)
	{
		return IsFullyCharged();
	}

	return super.HasAmmo(FireModeNum, Amount);
}

defaultproperties
{
	// Zooming/Position
	PlayerViewOffset=(X=2,Y=0,Z=0)

	// Content
	PackageKey="MurasamaBlade"
	FirstPersonMeshName="WEP_1P_KATANA_MESH.Wep_1stP_Katana_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_KATANA_ANIM.Katana_Anim_Master"
	PickupMeshName="WEP_3P_KATANA_MESH.Wep_Katana_Pickup"
	AttachmentArchetypeName="WEP_Katana_ARCH.Wep_Katana_3P"

	Begin Object Name=MeleeHelper_0
		MaxHitRange=190
		// Override automatic hitbox creation (advanced)
		HitboxChain.Add((BoneOffset=(X=+3,Z=190)))
		HitboxChain.Add((BoneOffset=(X=-3,Z=170)))
		HitboxChain.Add((BoneOffset=(X=+3,Z=150)))
		HitboxChain.Add((BoneOffset=(X=-3,Z=130)))
		HitboxChain.Add((BoneOffset=(X=+3,Z=110)))
		HitboxChain.Add((BoneOffset=(X=-3,Z=90)))
		HitboxChain.Add((BoneOffset=(X=+3,Z=70)))
		HitboxChain.Add((BoneOffset=(X=-3,Z=50)))
		HitboxChain.Add((BoneOffset=(X=+3,Z=30)))
		HitboxChain.Add((BoneOffset=(Z=10)))
		WorldImpactEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Bladed_melee_impact'
		MeleeImpactCamShakeScale=0.03f //0.3
		// modified combo sequences
		ChainSequence_F=(DIR_Left, DIR_ForwardRight, DIR_ForwardLeft, DIR_ForwardRight, DIR_ForwardLeft)
		ChainSequence_B=(DIR_BackwardRight, DIR_ForwardLeft, DIR_BackwardLeft, DIR_ForwardRight, DIR_Left, DIR_Right, DIR_Left)
		ChainSequence_L=(DIR_Right, DIR_Left, DIR_ForwardRight, DIR_ForwardLeft, DIR_Right, DIR_Left)
		ChainSequence_R=(DIR_Left, DIR_Right, DIR_ForwardLeft, DIR_ForwardRight, DIR_Left, DIR_Right)
	End Object

	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Vampire'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Slashing_MurasamaBlade'
	InstantHitDamage(DEFAULT_FIREMODE)=68// 34
	
	InstantHitDamageTypes(HEAVY_ATK_FIREMODE)=class'KFDT_Slashing_MurasamaBladeHeavy'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=90 //68

	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Piercing_MurasamaBladeStab'
	InstantHitDamage(BASH_FIREMODE)=68

	FiringStatesArray(CUSTOM_FIREMODE)=UltimateAttackState
	InstantHitDamageTypes(CUSTOM_FIREMODE)=class'KFDT_Slashing_MurasamaBladeSpecial'
	InstantHitDamage(CUSTOM_FIREMODE)=100//400
	InstantHitMomentum(CUSTOM_FIREMODE)=2500.f//100000.f
	WeaponFireTypes(CUSTOM_FIREMODE)=EWFT_Custom

	// Inventory
	GroupPriority=50
	InventorySize=4
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_Katana'
	AssociatedPerkClasses(0)=class'KFPerk_Berserker'
	
	// Block Sounds
	BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Block_MEL_Katana'
	ParrySound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Metal'
	
	ParryDamageMitigationPercent=0.50
	BlockDamageMitigation=0.60
	ParryStrength=4

	UltimateCharge=0.0f
	MaxUltimateCharge=100.0f;

	//Decay time removed. Enable by uncommenting the line in PreBeginPlay()
	DecayInterval=1.f
	DecayAmount=1.f

	UltimateChargePerHit(DEFAULT_FIREMODE)=5.0f//1.0f
	UltimateChargePerHit(BASH_FIREMODE)=5.0f//1.0f
	UltimateChargePerHit(HEAVY_ATK_FIREMODE)=15.0f//3.0f
	UltimateChargePerHit(CUSTOM_FIREMODE)=0.0f
	UltimateChargePerBlock=5.0f//1.0f
	UltimateChargePerParry=25.0f//5.0f

	UltimateAttackAnim=Atk_Draw

	DefaultMaxHitRange=240
	UltimateRangeScale=2.0f
	UltimateWidthScale=70.f

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.2f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.4f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.6f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Damage1, Scale=1.2f), (Stat=EWUS_Damage2, Scale=1.2f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.4f), (Stat=EWUS_Damage2, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.6f), (Stat=EWUS_Damage1, Scale=1.6f), (Stat=EWUS_Damage2, Scale=1.6f), (Stat=EWUS_Weight, Add=3)))
}


