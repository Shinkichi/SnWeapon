//=============================================================================
// KFWeap_AutoTurretWeapon
//=============================================================================
//=============================================================================
// Killing Floor 2
// Copyright (C) 2022 Tripwire Interactive LLC
//=============================================================================

class KFWeap_AutoTurretWeapon extends KFWeap_SMGBase;

var KFPawn_AutoTurret InstigatorDrone;

var transient bool bFiring;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
    StartLoadWeaponContent();
}

simulated state WeaponFiring
{
	simulated function EndState(Name NextStateName)
	{
		local Pawn OriginalInstigator;

		// The Instigator for this weapon is the Player owning the weapon (for Perk, damage, etc,. calculations)
		// But for Weapon Firing end state logic we need to point to the real Drone Pawn so we don't mess
		// With whichever weapon the Player had equipped at that point

		OriginalInstigator = Instigator;

		Instigator = InstigatorDrone;

		super.EndState(NextStateName);

		Instigator = OriginalInstigator;
	}
}

simulated function FireAmmunition()
{
	CurrentFireMode = DEFAULT_FIREMODE;
	super.FireAmmunition();
}

simulated function GetMuzzleLocAndRot(out vector MuzzleLoc, out rotator MuzzleRot)
{
	if (KFSkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('MuzzleFlash', MuzzleLoc, MuzzleRot) == false)
	{
		`Log("MuzzleFlash not found!");
	}

	// To World Coordinates. (Rotation should be 0 so no taken into account)
	// MuzzleLoc = Location + QuatRotateVector(QuatFromRotator(Rotation), MuzzleLoc);
}

simulated function InstantFireClient()
{
	local vector			StartTrace;
	local vector 			EndTrace;
	local rotator			AimRot;
	local Array<ImpactInfo>	ImpactList;
	local int				Idx;
	local ImpactInfo		RealImpact;
	local float				CurPenetrationValue;
	local KFPawn 			KFPOwner;

	// see Controller AimHelpDot() / AimingHelp()
	bInstantHit = true;

	// define range to use for CalcWeaponFire()
	GetMuzzleLocAndRot(StartTrace, AimRot );
	EndTrace = StartTrace + vector(Owner.Rotation) * GetTraceRange();
	
	bInstantHit = false;

    // Initialize penetration power
    PenetrationPowerRemaining = GetInitialPenetrationPower(CurrentFireMode);
    CurPenetrationValue = PenetrationPowerRemaining;

	// Perform shot
	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

	// Set flash location to trigger client side effects.  Bypass Weapon.SetFlashLocation since
	// that function is not marked as simulated and we want instant client feedback.
	// ProjectileFire/IncrementFlashCount has the right idea:
	//	1) Call IncrementFlashCount on Server & Local
	//	2) Replicate FlashCount if ( !bNetOwner )
	//	3) Call WeaponFired() once on local player
	KFPOwner = KFPawn(Owner);
	if( KFPOwner != None )
	{
		KFPOwner.SetFlashLocation( Self, CurrentFireMode, RealImpact.HitLocation );
	}

	// local player only for clientside hit detection
	// allow weapon to add extra bullet impacts (useful for shotguns)
	InstantFireClient_AddImpacts(StartTrace, AimRot, ImpactList);

	for (Idx = 0; Idx < ImpactList.Length; Idx++)
	{
		ProcessInstantHitEx(CurrentFireMode, ImpactList[Idx],, CurPenetrationValue, Idx);
	}

	if ( Instigator.Role < ROLE_Authority )
	{
		SendClientImpactList(CurrentFireMode, ImpactList);
	}
}

simulated function HandleProjectileImpact(byte ProjectileFireMode, ImpactInfo Impact, optional float PenetrationValue)
{
	// local player only for clientside hit detection
	if ( Instigator != None)
	{
		if ( Instigator.Role < ROLE_Authority )
		{
			SendClientProjectileImpact(ProjectileFireMode, Impact, PenetrationValue);
		}

		ProcessInstantHitEx(ProjectileFireMode, Impact,, PenetrationValue, 0);
	}
}


simulated function Projectile ProjectileFire()
{
	local vector StartTrace, RealStartLoc, AimDir;
	local rotator AimRot;
	local class<KFProjectile> MyProjectileClass;

	// tell remote clients that we fired, to trigger effects

	if ( ShouldIncrementFlashCountOnFire() )
	{
		IncrementFlashCount();
	}

    MyProjectileClass = GetKFProjectileClass();

	if( Role == ROLE_Authority || (MyProjectileClass.default.bUseClientSideHitDetection
        && MyProjectileClass.default.bNoReplicationToInstigator && Instigator != none
        && Instigator.IsLocallyControlled()) )
	{
		// This is where we would start an instant trace. (what CalcWeaponFire uses)
		// MySkelMesh.GetSocketWorldLocationAndRotation( 'MuzzleFlash', StartTrace, AimRot );
		GetMuzzleLocAndRot(StartTrace, AimRot );

		AimDir = Vector(Owner.Rotation);

		// this is the location where the projectile is spawned.
		RealStartLoc = StartTrace;

		return SpawnAllProjectiles(MyProjectileClass, RealStartLoc, AimDir);
	}

	return None;
}

simulated function KFProjectile SpawnProjectile( class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir )
{
	local KFProjectile	SpawnedProjectile;
	local int ProjDamage;
	local Pawn OriginalInstigator;

	/*
	 * Instigator issues here. The instigator of the weapon here is the PlayerController which won't replicate the projectile.  
	 * Changing it to the drone pawn for spawning, then swapping it again to be able to apply perk effects.
	 */

	// Spawn projectile
	OriginalInstigator = Instigator;
	Instigator = InstigatorDrone;
	SpawnedProjectile = Spawn( KFProjClass, self,, RealStartLoc);
	if( SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe )
	{
		// Mirror damage and damage type from weapon. This is set on the server only and
		// these properties are replicated via TakeHitInfo
		if ( InstantHitDamage.Length > CurrentFireMode && InstantHitDamageTypes.Length > CurrentFireMode )
		{
            ProjDamage = GetModifiedDamage(CurrentFireMode);
            SpawnedProjectile.Damage = ProjDamage;
            SpawnedProjectile.MyDamageType = InstantHitDamageTypes[CurrentFireMode];
		}

		// Set the penetration power for this projectile
		// because of clientside hit detection, we need two variables --
		// one that replicates on init and one that updates but doesn't replicate
		SpawnedProjectile.InitialPenetrationPower = GetInitialPenetrationPower(CurrentFireMode);
		SpawnedProjectile.PenetrationPower = SpawnedProjectile.InitialPenetrationPower;

		SpawnedProjectile.UpgradeDamageMod = GetUpgradeDamageMod();
		SpawnedProjectile.Init( AimDir );
	}

	if (MedicComp != none && KFProj_HealingDart(SpawnedProjectile) != None)
	{
		if (TargetingComp != none && TargetingComp.LockedTarget[1] != none)
		{
			KFProj_HealingDart(SpawnedProjectile).SeekTarget = TargetingComp.LockedTarget[1];
		}
	}

	Instigator = OriginalInstigator;
	// return it up the line
	return SpawnedProjectile;
}

simulated function IncrementFlashCount()
{
	local KFPawn P;
	P = KFPawn(Owner);

	if( P != None )
	{
		P.IncrementFlashCount( Self, CurrentFireMode );
	}
}

simulated function Fire()
{
	if (bFiring)
	{
		return;
	}

	if (HasAmmo(DEFAULT_FIREMODE))
	{
		SendToFiringState(DEFAULT_FIREMODE);
	}

	bFiring = true;
}


simulated function StopFire(byte FireModeNum)
{
	if (!bFiring)
	{
		return;
	}

	bFiring = false;
	super.StopFire(FireModeNum);
	GoToState('Inactive');
}

simulated function bool ShouldRefire()
{
	// if doesn't have ammo to keep on firing, then stop
	if( !HasAmmo( CurrentFireMode ) )
	{
		return false;
	}

	return bFiring;
}

/**
 * Starts playing looping FireSnd only (used for switching sounds in Zedtime)
 */
simulated function StartLoopingFireSound(byte FireModeNum)
{
	if ( FireModeNum < bLoopingFireSnd.Length && bLoopingFireSnd[FireModeNum] && !ShouldForceSingleFireSound() )
	{
		bPlayingLoopingFireSnd = true;
		KFPawn(Owner).SetWeaponAmbientSound(WeaponFireSnd[FireModeNum].DefaultCue, WeaponFireSnd[FireModeNum].FirstPersonCue);
	}
}

/**
 * Stops playing looping FireSnd only (used for switching sounds in Zedtime)
 */
simulated function StopLoopingFireSound(byte FireModeNum)
{
	if ( bPlayingLoopingFireSnd )
	{
		KFPawn(Owner).SetWeaponAmbientSound(None);
		if ( FireModeNum < WeaponFireLoopEndSnd.Length )
		{
			WeaponPlayFireSound(WeaponFireLoopEndSnd[FireModeNum].DefaultCue, WeaponFireLoopEndSnd[FireModeNum].FirstPersonCue);
		}

		bPlayingLoopingFireSnd = false;
	}
}

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	local name WeaponFireAnimName;
	local KFPerk CurrentPerk;
	local float TempTweenTime, AdjustedAnimLength;
	local KFPawn KFPO;

	// If we have stopped the looping fire sound to play single fire sounds for zed time
	// start the looping sound back up again when the time is back above zed time speed
	if( FireModeNum < bLoopingFireSnd.Length && bLoopingFireSnd[FireModeNum] && !bPlayingLoopingFireSnd )
    {
        StartLoopingFireSound(FireModeNum);
    }

	PlayFiringSound(CurrentFireMode);
	KFPO = KFPawn(Owner);

	if( KFPO != none )
	{
		// Tell our pawn about any changes in animation speed
		UpdateWeaponAttachmentAnimRate( GetThirdPersonAnimRate() );

		if( KFPO.IsLocallyControlled() )
		{
			if( KFPO.IsFirstPerson() )
			{
				if ( !bPlayingLoopingFireAnim )
				{
					WeaponFireAnimName = GetWeaponFireAnim(FireModeNum);

					if ( WeaponFireAnimName != '' )
					{
						AdjustedAnimLength = MySkelMesh.GetAnimLength(WeaponFireAnimName);
						TempTweenTime = FireTweenTime;

						CurrentPerk = GetPerk();
						if( CurrentPerk != none )
						{
							CurrentPerk.ModifyRateOfFire( AdjustedAnimLength, self );

							// We need to unlock the slide if we fire from zero ammo while uber ammo is active
							if( EmptyMagBlendNode != none
								&& BonesToLockOnEmpty.Length > 0
								&& AmmoCount[GetAmmoType(FireModeNum)] == 0
								&& CurrentPerk.GetIsUberAmmoActive(self) )
							{
								EmptyMagBlendNode.SetBlendTarget( 0, 0 );
								TempTweenTime = 0.f;
							}
						}

						PlayAnimation(WeaponFireAnimName, AdjustedAnimLength,, TempTweenTime);
					}
				}

				// Start muzzle flash effect
				CauseMuzzleFlash(FireModeNum);
			}

			HandleRecoil();
			ShakeView();

			if (AmmoCount[0] == 0 && ForceReloadTimeOnEmpty > 0)
			{
				SetTimer(ForceReloadTimeOnEmpty, false, nameof(ForceReload));
			}
		}
	}
}

simulated function WeaponPlayFireSound(AkBaseSoundObject DefaultSound, AkBaseSoundObject FirstPersonSound)
{
    // ReplicateSound needs an "out" vector
    local vector SoundLocation;

	if( Owner != None && !bSuppressSounds  )
	{
        SoundLocation = KFPawn(Owner).GetPawnViewLocation();

		if ( DefaultSound != None )
		{
            Owner.PlaySoundBase( DefaultSound, false, false, false, SoundLocation );
		}
	}
}

/** True if we want to override the looping fire sounds with fire sounds from another firemode */
simulated function bool ShouldForceSingleFireSound()
{
	// If this weapon has a single-shot firemode, disable looping fire sounds during zedtime
	if ( `IsInZedTime(Instigator) && SingleFireSoundIndex != 255 )
	{
		return true;
	}

	return false;
}

defaultproperties
{
	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=75
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=9.0,Y=10,Z=-4)

	// Content
	PackageKey="AutoTurretWeapon"
	FirstPersonMeshName="wep_1p_autoturretWeapon_mesh.Wep_1stP_AutoTurretWeapon_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_autoturretWeapon_anim.Wep_1stP_AutoTurretWeapon_Anim"
	PickupMeshName="wep_3p_autoturretWeapon_mesh.Wep_AutoTurretWeapon_Pickup"
	AttachmentArchetypeName="WEP_AutoTurretWeapon_ARCH.AutoTurretWeaponAttachment"
	MuzzleFlashTemplateName="wep_autoturretWeapon_arch.Wep_AutoTurretWeapon_MuzzleFlash"

   	// Zooming/Position
	IronSightPosition=(X=7,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=150
	SpareAmmoCapacity[0]=0
	InitialSpareMags[0]=0
	bCanBeReloaded=false
	bReloadFromMagazine=false

	// Recoil
	maxRecoilPitch=225
	minRecoilPitch=150
	maxRecoilYaw=150
	minRecoilYaw=-150
	RecoilRate=0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=195
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.25
	IronSightMeshFOVCompensationScale=1.5

	// Inventory / Grouping
	InventorySize=5
	GroupPriority=25
	WeaponSelectTexture=Texture2D'WEP_UI_AutoTurret_TEX.UI_WeaponSelect_AutoTurret'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletBurst'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pistol9mm'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_AutoTurret'
	FireInterval(DEFAULT_FIREMODE)=+0.12 // 500 rpm
	InstantHitDamage(DEFAULT_FIREMODE)=10
	Spread(DEFAULT_FIREMODE)=0.01
	FireOffset=(X=30,Y=4.5,Z=-4)

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	WeaponFireTypes(BASH_FIREMODE)=EWFT_None

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shot_LP_3P', FirstPersonCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shot_LP_1P')
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shot_EndLP_3P', FirstPersonCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shot_EndLP_1P')
	
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shoot_3P', FirstPersonCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shoot_1P')
	SingleFireSoundIndex=ALTFIRE_FIREMODE

	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	bLoopingFireAnim(DEFAULT_FIREMODE)=true

	AssociatedPerkClasses(0)=class'KFPerk_Commando'
	
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))

	InstigatorDrone=none

	bFiring=false
}

