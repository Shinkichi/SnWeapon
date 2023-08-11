
class KFWeap_HRG_ParamedicWeapon extends KFWeap_GrenadeLauncher_Base;

var KFPawn_HRG_Paramedic InstigatorDrone;

// Used to calculate parabola when spawn projectile
var KFPawn_Human CurrentTarget;

// Used to force distance when throwing projectiles when the pawn dies
var float CurrentDistanceProjectile;

var float DistanceParabolicLaunch;

var transient float FireLookAheadSeconds;

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
}

simulated function Projectile ProjectileFire()
{
	local vector RealStartLoc, AimDir, TargetLocation;
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
		GetMuzzleLocAndRot(RealStartLoc, AimRot);

		if (CurrentTarget != none)
		{
			TargetLocation = CurrentTarget.Location;
			TargetLocation.Z += CurrentTarget.GetCollisionHeight() * 0.5f; // Add an offset on the location, so it matches correctly

			AimDir = Normal(TargetLocation - RealStartLoc);
		}
		else
		{
			AimDir = Vector(Owner.Rotation);
		}

		return SpawnAllProjectiles(MyProjectileClass, RealStartLoc, AimDir);
	}

	return None;
}

simulated function KFProjectile SpawnProjectile( class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir )
{
	local KFProjectile SpawnedProjectile;
	local int ProjDamage;
	local Pawn OriginalInstigator;
	local vector TargetLocation, Distance;
	local float HorizontalDistance, TermA, TermB, TermC, InitialSpeed;

	/*
	 * Instigator issues here. The instigator of the weapon here is the PlayerController which needs to replicate the projectile.  
	 * We spawn it with that instigator, then we change to be able to be able to apply perk effects.
	 */

	// Spawn projectile

	OriginalInstigator = Instigator;
	Instigator = InstigatorDrone;

	SpawnedProjectile = Spawn( KFProjClass, self,, RealStartLoc);

	if( SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe )
	{
		if (CurrentTarget != none) // This is used for regular shooting
		{
			//TargetLocation = CurrentTarget.Mesh.GetBoneLocation('Spine1');
			TargetLocation = CurrentTarget.Location;
			TargetLocation.Z += CurrentTarget.GetCollisionHeight() * 0.5f; // Add an offset on the location, so it matches correctly

			// Apply look ahead
			TargetLocation += CurrentTarget.Velocity * FireLookAheadSeconds;
		}
		else if (CurrentDistanceProjectile > 0.f) // This is used for the explosion when drone dies
		{
			TargetLocation = RealStartLoc + AimDir * CurrentDistanceProjectile;
			TargetLocation.Z -= InstigatorDrone.DeployHeight; // We target more or less the ground
		}

		//CurrentTarget.DrawDebugSphere(TargetLocation, 100, 10, 0, 255, 0, true);

		Distance = TargetLocation - RealStartLoc;
		Distance.Z = 0.f;
		HorizontalDistance = VSize(Distance); // 2D

		// If bigger than minimal horizontal distance, and drone is higher than target..
		if (HorizontalDistance > DistanceParabolicLaunch
			&& RealStartLoc.Z > TargetLocation.Z)
		{
			// Parabolic launch calculation
			// Tweak speed so it can fall on the TargetLocation, use parabolic launch, we assume an Angle = 0
			// We transform from 3D to 2D, assume horizontal start is 0, and horizontal distance is the modulus of the vector distance to target

			// Angle = 0 -> sin(0) -> 0 so no need to apply any initial Y velocity

			// ( ( Y - Y0 ) / ( 0.5 * gravity ) )
			TermA = (TargetLocation.Z - RealStartLoc.Z) / (-11.5f * 0.5f * 100.f); // gravity to cm/s

			// ( X - X0 )^2 / V^2 -> assume XO is 0
			TermB = HorizontalDistance * HorizontalDistance;

			TermC = TermB / TermA;

			InitialSpeed = Sqrt(TermC);

			AimDir = Normal(Distance);
			AimDir.Z = 0.f;
		}
		else
		{
			// No parabollic, so we force Speed
			if (RealStartLoc.Z < TargetLocation.Z)
			{
				InitialSpeed = 3000.f;
			}
			else
			{
				InitialSpeed = 1000.f;
			}
		}

		SpawnedProjectile.Speed = InitialSpeed;
		SpawnedProjectile.MaxSpeed = 0;
		SpawnedProjectile.TerminalVelocity = InitialSpeed * 2.f;
		SpawnedProjectile.TossZ = 0.f;

		// Mirror damage and damage type from weapon. This is set on the server only and
		// these properties are replicated via TakeHitInfo
		if ( InstantHitDamage.Length > CurrentFireMode && InstantHitDamageTypes.Length > CurrentFireMode )
		{
            ProjDamage = GetModifiedDamage(CurrentFireMode);
            SpawnedProjectile.Damage = ProjDamage;
            SpawnedProjectile.MyDamageType = InstantHitDamageTypes[CurrentFireMode];
		}

		SpawnedProjectile.UpgradeDamageMod = GetUpgradeDamageMod();

		SpawnedProjectile.Init( AimDir );
	}

	Instigator = OriginalInstigator;

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
	if (IsInState('WeaponFiring'))
	{
		return;
	}

	if (HasAmmo(DEFAULT_FIREMODE))
	{
		SendToFiringState(DEFAULT_FIREMODE);
	}
}

simulated function StopFire(byte FireModeNum)
{
	super.StopFire(FireModeNum);

	GoToState('Inactive');
}

simulated function bool ShouldRefire()
{
	return false;
}

simulated function ForceExplosionReplicateKill(Vector HitLocation, KFProj_HighExplosive_HRG_Paramedic Proj)
{
	HandleClientProjectileExplosion(HitLocation, Proj);

	Proj.Shutdown();	// cleanup/destroy projectile
}

simulated function ForceExplosionReplicate(Actor Other, Vector HitLocation, Vector HitNormal, KFProj_HighExplosive_HRG_Paramedic Proj)
{
	HandleClientProjectileExplosion(HitLocation, Proj);

	if (Proj.ExplosionTemplate != None)
	{
		Proj.TriggerExplosion(HitLocation, HitNormal, Other);
	}

	Proj.Shutdown();	// cleanup/destroy projectile
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

simulated function bool HasAlwaysOnZedTimeResist()
{
    return true;
}

defaultproperties
{

	// Inventory / Grouping
	InventorySize=5
	GroupPriority=25
	WeaponSelectTexture=Texture2D'WEP_UI_AutoTurret_TEX.UI_WeaponSelect_AutoTurret'

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=75
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=9.0,Y=10,Z=-4)

	// Content
	PackageKey="HRG_ParamedicWeapon"
	FirstPersonMeshName="Wep_1P_HRG_WarthogWeapon_MESH.Wep_1stP_HRG_WarthogWeapon_Rig"
	FirstPersonAnimSetNames(0)="Wep_1P_HRG_WarthogWeapon_ANIM.Wep_1stP_HRG_WarthogWeapon_Anim"
	PickupMeshName="WEP_3P_HRG_WarthogWeapon_MESH.Wep_HRG_Warthog_Pickup"
	AttachmentArchetypeName="WEP_HRG_WarthogWeapon_ARCH.HRG_WarthogWeaponAttachment"
	MuzzleFlashTemplateName="WEP_HRG_WarthogWeapon_ARCH.HRG_WarthogWeapon_MuzzleFlash"

   	// Zooming/Position
	IronSightPosition=(X=0,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=35
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

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Grenade'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_HighExplosive_HRG_Paramedic'
	FireInterval(DEFAULT_FIREMODE)=+2.1//+1.4//+0.7
	InstantHitDamage(DEFAULT_FIREMODE)=10.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Dart_Toxic'
	Spread(DEFAULT_FIREMODE)=0.0
	FireOffset=(X=30,Y=4.5,Z=-4)

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	WeaponFireTypes(BASH_FIREMODE)=EWFT_None

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Fire_1P')

	//@todo: add akevent when we have it
	WeaponDryFireSnd(DEFAULT_FIREMODE)=none

	// Attachments
	bHasIronSights=false
	bHasFlashlight=false

	AssociatedPerkClasses(0)=class'KFPerk_Demolitionist'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.12f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.3f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.55f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.12f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.55f), (Stat=EWUS_Weight, Add=3)))

	InstigatorDrone=none

	CurrentTarget=none
	CurrentDistanceProjectile=-1.f

	DistanceParabolicLaunch=150.f //cm

	FireLookAheadSeconds=0.2f
}