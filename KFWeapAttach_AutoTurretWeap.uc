//=============================================================================
// KFWeapAttach_AutoTurretWeapon
//=============================================================================
//=============================================================================
// Killing Floor 2
// Copyright (C) 2022 Tripwire Interactive LLC
//=============================================================================
class KFWeapAttach_AutoTurretWeap extends KFWeaponAttachment;

const DeployAnimName  = 'Drone_Deploy';
const DroneFireAnim   = 'Drone_Shoot';
const DroneEmptyStartAnim = 'Drone_Start_Empty';
const DroneEmptyAnim  = 'Drone_Empty';
const DroneIdleAnim   = 'Drone_Idle';
const DroneClosedAnim = 'Drone_IdleClose';

const LaserSightSocketName = 'LaserSightSocket';
const LaserColorParamName = '0blue_1red';

var transient MaterialInstanceConstant LaserDotMIC;
var transient MaterialInstanceConstant LaserBeamMIC;

simulated function float PlayDeployAnim()
{
	local float Duration;

	Duration = WeapMesh.GetAnimLength( DeployAnimName );
	WeapMesh.PlayAnim( DeployAnimName, Duration / ThirdPersonAnimRate, false, true );

	return Duration;
}

simulated function PlayEmptyState()
{
	local float Duration;	

	ClearTimer(nameof(PlayIdleAnim));

	Duration = WeapMesh.GetAnimLength( DroneEmptyStartAnim );	
	WeapMesh.PlayAnim( DroneEmptyStartAnim, Duration / ThirdPersonAnimRate, true, false);

	SetTimer(Duration, false, 'PlayEmptyAnim');
}

simulated function PlayEmptyAnim()
{
	local float Duration;

	Duration = WeapMesh.GetAnimLength( DroneEmptyAnim );
	WeapMesh.PlayAnim( DroneEmptyAnim, Duration / ThirdPersonAnimRate, true, false);

	if (LaserSight != none)
	{
		LaserSight.ChangeVisibility(false);
	}
}

simulated function PlayIdleAnim()
{
	local float Duration;

	Duration = WeapMesh.GetAnimLength( DroneIdleAnim );
	WeapMesh.PlayAnim( DroneIdleAnim, Duration / ThirdPersonAnimRate, true, false );
}

simulated function PlayCloseAnim()
{
	local float Duration;

	Duration = WeapMesh.GetAnimLength( DroneClosedAnim );
	WeapMesh.PlayAnim( DroneClosedAnim, Duration / ThirdPersonAnimRate, true, false );
}

/**
 * Spawn all of the effects that will be seen in behindview/remote clients.  This
 * function is called from the pawn, and should only be called when on a remote client or
 * if the local client is in a 3rd person mode.
 * @return TRUE if the effect culling check passes
*/
simulated function bool ThirdPersonFireEffects( vector HitLocation, KFPawn P, byte ThirdPersonAnimRateByte )
{
	// local EAnimSlotStance AnimType;

    SpawnTracer(GetMuzzleLocation(), HitLocation);

	// Effects below this point are culled based on visibility and distance
	if ( !ActorIsRelevant(self, false, MaxFireEffectDistance) )
	{
		return false;
	}

	DecodeThirdPersonAnimRate( ThirdPersonAnimRateByte );

	// Weapon shoot anims
	if( !bWeapMeshIsPawnMesh )
	{
		PlayWeaponFireAnim();
	}

/* 
	if( P.IsDoingSpecialMove() && P.SpecialMoves[P.SpecialMove].bAllowFireAnims )
	{
		AnimType = EAS_Additive;
	}
	else
	{
		AnimType = EAS_FullBody;
	}
*/
	// AnimType = EAS_FullBody;

	// Character shoot anims
/*
	if ( AnimType == EAS_Additive )
	{
		PlayPawnFireAnim( P, AnimType );

		// interrupt other weapon action anims (e.g. Reload)
		if( !P.IsDoingSpecialMove() )
		{
			P.StopBodyAnim(P.bIsCrouched ? EAS_CH_UpperBody : EAS_UpperBody, 0.1f);
		}

		if ( OnWeaponStateChanged != None )
		{
			OnWeaponStateChanged(true);
		}
	}
*/

//  Always DEFAULT_FIREMODE
	CauseMuzzleFlash(0);

	return true;
}

simulated function bool ActorIsRelevant(Actor EffectInstigator, bool bForceDedicated, optional float VisibleCullDistance=5000.0, optional float HiddenCullDistance=350.0 )
{
	local PlayerController	P;
	local float DistSq;
	local vector CameraLoc;
	local rotator CameraRot;

	if ( EffectInstigator == None )
	{
		return FALSE;
	}

	// No local player, so only spawn on dedicated server if bForceDedicated
	if ( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return bForceDedicated;
	}

	if ( bForceDedicated && (WorldInfo.NetMode == NM_ListenServer) && (WorldInfo.Game.NumPlayers > 1) )
	{
		// Is acting as server, so spawn effect if bForceDedicated
		return TRUE;
	}

	// Determine how far to the nearest local viewer
	DistSq = 10000000000.0;
	ForEach LocalPlayerControllers(class'PlayerController', P)
	{
		if ( P.GetViewTarget() == self )
		{
			return true;
		}
		P.GetPlayerViewPoint(CameraLoc, CameraRot);
		DistSq = FMin(DistSq, VSizeSq(Location - CameraLoc)*Square(P.LODDistanceFactor));
	}

	if ( DistSq > VisibleCullDistance*VisibleCullDistance )
	{
		// never spawn beyond cull distance
		return FALSE;
	}
	else if ( DistSq < HiddenCullDistance*HiddenCullDistance )
	{
		// If close enough, always spawn even if hidden
		return TRUE;
	}

/* This doesn't seem to be updating the render time, so ignore it */
	return TRUE;
}

/** Plays fire animation on weapon mesh */
simulated function PlayWeaponFireAnim()
{
	local float Duration;
	local bool bAnimPlayed;

	Duration = WeapMesh.GetAnimLength( DroneFireAnim );

	bAnimPlayed = WeapMesh.PlayAnim( DroneFireAnim, Duration / ThirdPersonAnimRate, false, false );

	if (bAnimPlayed)
	{
		ClearTimer(nameof(PlayIdleAnim));
		SetTimer(Duration, false, nameof(PlayIdleAnim));
	}
}

/**
	Laser
 */

simulated function AttachLaserSight()
{
	if ( WeapMesh != none && LaserSight == None && LaserSightArchetype != None )
	{
		LaserSight = new(self) Class'KFLaserSightAttachment' (LaserSightArchetype);
		LaserSight.AttachLaserSight(WeapMesh, false, LaserSightSocketName);
	}
}

simulated function UpdateLaserColor(bool bInCombat)
{
	if (LaserSight != none)
	{
		if (LaserDotMIC == none)
		{
			LaserDotMIC = LaserSight.LaserDotMeshComp.CreateAndSetMaterialInstanceConstant(0);
		}

		if (LaserBeamMIC == none)
		{
			LaserBeamMIC = LaserSight.LaserBeamMeshComp.CreateAndSetMaterialInstanceConstant(0);
		}
	}

	if (LaserDotMIC != none)
	{
		LaserDotMIC.SetScalarParameterValue(LaserColorParamName, bInCombat ? 1 : 0);
	}

	if (LaserBeamMIC != none)
	{
		LaserBeamMIC.SetScalarParameterValue(LaserColorParamName, bInCombat ? 1 : 0);
	}
}

/**
 * Assign weapon skin to 3rd person mesh
 */
simulated event SetWeaponSkin(int ItemId, optional bool bFinishedLoading = false)
{
	local array<MaterialInterface> SkinMICs;

	if ( ItemId > 0 && WorldInfo.NetMode != NM_DedicatedServer && !bWaitingForWeaponSkinLoad)
	{
		if (!bFinishedLoading && StartLoadWeaponSkin(ItemId))
		{
			return;
		}

		SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(ItemId, WST_ThirdPerson);

		if ( SkinMICs.Length > 0 )
		{
			WeapMesh.SetMaterial(0, SkinMICs[0]);
		}
	}
}

defaultproperties
{
	//defaults
	bHasLaserSight=true
}