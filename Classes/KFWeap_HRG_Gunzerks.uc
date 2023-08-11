class KFWeap_HRG_Gunzerks extends KFWeap_Blunt_PowerGloves;

var name ReloadAnimation;
var float ReloadAnimRateModifier;
var float ReloadAnimRateModifierElite;

var protected transient bool bWaitingForSecondShot; 
var protected transient int  NumAttacks;

/** A muzzle flash instance for left weapon */
var KFMuzzleFlash LeftMuzzleFlash;

//------------------------------------------------------------------------------

const MAX_LOCKED_TARGETS = 2;//10;//6;

/** Constains all currently locked-on targets */
var protected array<Pawn> LockedTargets;

/** How much to scale recoil when firing in multi-rocket mode */
var float BurstFireRecoilModifier;

/** The last time a target was acquired */
var protected float LastTargetLockTime;

/** The last time a target validation check was performed */
var protected float LastTargetValidationCheckTime;

/** How much time after a lock on occurs before another is allowed */
var const float TimeBetweenLockOns;

/** How much time should pass between target validation checks */
var const float TargetValidationCheckInterval;

/** Minimum distance a target can be from the crosshair to be considered for lock on */
var const float MinTargetDistFromCrosshairSQ;

/** Dot product FOV that targets need to stay within to maintain a target lock */
var const float MaxLockMaintainFOVDotThreshold;

/** Sound Effects to play when Locking */
var AkBaseSoundObject LockAcquiredSoundFirstPerson;
var AkBaseSoundObject LockLostSoundFirstPerson;

/** Icon textures for lock on drawing */
var const Texture2D LockedOnIcon;
var LinearColor LockedIconColor;

/** Ironsights Audio */
var AkComponent       IronsightsComponent;
var AkEvent            IronsightsZoomInSound;
var AkEvent           IronsightsZoomOutSound;

/*********************************************************************************************
 * @name Target Locking And Validation
 **********************************************************************************************/

/** We need to update our locked targets every frame and make sure they're within view and not dead */
simulated event Tick( float DeltaTime )
{
	local Pawn RecentlyLocked, StaticLockedTargets[2];
	//local Pawn RecentlyLocked, StaticLockedTargets[10];
	local bool bUpdateServerTargets;
	local int i;

	super.Tick( DeltaTime );

    if( /*bUsingSights && bUseAltFireMode
    	&&*/ Instigator != none
    	&& Instigator.IsLocallyControlled() )
    {
		if( `TimeSince(LastTargetLockTime) > TimeBetweenLockOns
			/*&& LockedTargets.Length < AmmoCount[GetAmmoType(0)]*/
			&& LockedTargets.Length < MAX_LOCKED_TARGETS)
		{
	        bUpdateServerTargets = FindTargets( RecentlyLocked );
	    }

		if( LockedTargets.Length > 0 )
		{
			bUpdateServerTargets = bUpdateServerTargets || ValidateTargets( RecentlyLocked );
		}

		// If we are a client, synchronize our targets with the server
		if( bUpdateServerTargets && Role < ROLE_Authority )
		{
			for( i = 0; i < MAX_LOCKED_TARGETS; ++i )
			{
				if( i < LockedTargets.Length )
				{
					StaticLockedTargets[i] = LockedTargets[i];
				}
				else
				{
					StaticLockedTargets[i] = none;
				}
			}

			ServerSyncLockedTargets( StaticLockedTargets );
		}
    }
}


/**
* Given an potential target TA determine if we can lock on to it.  By default only allow locking on
* to pawns.
*/
simulated function bool CanLockOnTo(Actor TA)
{
	Local KFPawn PawnTarget;

	PawnTarget = KFPawn(TA);

	// Make sure the pawn is legit, isn't dead, and isn't already at full health
	if ((TA == None) || !TA.bProjTarget || TA.bDeleteMe || (PawnTarget == None) ||
		(TA == Instigator) || (PawnTarget.Health <= 0) || 
		!HasAmmo(DEFAULT_FIREMODE))
	{
		return false;
	}

	// Make sure and only lock onto players on the same team
	return !WorldInfo.GRI.OnSameTeam(Instigator, TA);
}

/** Finds a new lock on target, adds it to the target array and returns TRUE if the array was updated */
simulated function bool FindTargets( out Pawn RecentlyLocked )
{
	local Pawn P, BestTargetLock;
	local byte TeamNum;
	local vector AimStart, AimDir, TargetLoc, Projection, DirToPawn, LinePoint;
	local Actor HitActor;
	local float PointDistSQ, Score, BestScore;

	TeamNum = Instigator.GetTeamNum();
	AimStart = GetSafeStartTraceLocation();
	AimDir = vector( GetAdjustedAim(AimStart) );
	BestScore = 0.f;

    //Don't add targets if we're already burst firing
    if (IsInState('AltReloading'))
    {
        return false;
    }

	foreach WorldInfo.AllPawns( class'Pawn', P )
	{
		if (!CanLockOnTo(P))
		{
			continue;
		}
		// Want alive pawns and ones we already don't have locked
		if( P != none && P.IsAliveAndWell() && P.GetTeamNum() != TeamNum && LockedTargets.Find(P) == INDEX_NONE )
		{
			TargetLoc = GetLockedTargetLoc( P );
			Projection = TargetLoc - AimStart;
			DirToPawn = Normal( Projection );

			// Filter out pawns too far from center
			if( AimDir dot DirToPawn < 0.5f )
			{
				continue;
			}

			// Check to make sure target isn't too far from center
            PointDistToLine( TargetLoc, AimDir, AimStart, LinePoint );
            PointDistSQ = VSizeSQ( LinePoint - P.Location );
            if( PointDistSQ > MinTargetDistFromCrosshairSQ )
            {
            	continue;
            }

            // Make sure it's not obstructed
            HitActor = class'KFAIController'.static.ActorBlockTest(self, TargetLoc, AimStart,, true, true);
            if( HitActor != none && HitActor != P )
            {
            	continue;
            }

            // Distance from target has much more impact on target selection score
            Score = VSizeSQ( Projection ) + PointDistSQ;
            if( BestScore == 0.f || Score < BestScore )
            {
            	BestTargetLock = P;
            	BestScore = Score;
            }
		}
	}

	if( BestTargetLock != none )
	{
		LastTargetLockTime = WorldInfo.TimeSeconds;
		LockedTargets.AddItem( BestTargetLock );
		RecentlyLocked = BestTargetLock;

		// Plays sound/FX when locking on to a new target
		PlayTargetLockOnEffects();

		return true;
	}

	RecentlyLocked = none;

	return false;
}

/** Checks to ensure all of our current locked targets are valid */
simulated function bool ValidateTargets( optional Pawn RecentlyLocked )
{
	local int i;
	local bool bShouldRemoveTarget, bAlteredTargets;
	local vector AimStart, AimDir, TargetLoc;
	local Actor HitActor;

	if( `TimeSince(LastTargetValidationCheckTime) < TargetValidationCheckInterval )
	{
		return false;
	}

	LastTargetValidationCheckTime = WorldInfo.TimeSeconds;

	AimStart = GetSafeStartTraceLocation();
	AimDir = vector( GetAdjustedAim(AimStart) );

	bAlteredTargets = false;
	for( i = 0; i < LockedTargets.Length; ++i )
	{
		// For speed don't bother checking a target we just locked
		if( RecentlyLocked != none && RecentlyLocked == LockedTargets[i] )
		{
			continue;
		}

		bShouldRemoveTarget = false;

		if( LockedTargets[i] == none
			|| !LockedTargets[i].IsAliveAndWell() )
		{
			bShouldRemoveTarget = true;
		}
		else
		{
			TargetLoc = GetLockedTargetLoc( LockedTargets[i] );
			if( AimDir dot Normal(LockedTargets[i].Location - AimStart) >= MaxLockMaintainFOVDotThreshold )
			{
				HitActor = class'KFAIController'.static.ActorBlockTest( self, TargetLoc, AimStart,, true, true );
				if( HitActor != none && HitActor != LockedTargets[i] )
				{
					bShouldRemoveTarget = true;
				}
			}
			else
			{
				bShouldRemoveTarget = true;
			}
		}

		// A target was invalidated, remove it from the list
		if( bShouldRemoveTarget )
		{
			LockedTargets.Remove( i, 1 );
			--i;
			bAlteredTargets = true;
			continue;
		}
	}

	// Plays sound/FX when losing a target lock, but only if we didn't play a lock on this frame
	if( bAlteredTargets && RecentlyLocked == none )
	{
		PlayTargetLostEffects();
	}

	return bAlteredTargets;
}

/** Synchronizes our locked targets with the server */
reliable server function ServerSyncLockedTargets( Pawn TargetPawns[MAX_LOCKED_TARGETS] )
{
	local int i;

    LockedTargets.Length = 0;
	for( i = 0; i < MAX_LOCKED_TARGETS; ++i )
	{
        if (TargetPawns[i] != none)
        {
            LockedTargets.AddItem(TargetPawns[i]);
        }		
	}
}

/** Adjusts our destination target impact location */
static simulated function vector GetLockedTargetLoc( Pawn P )
{
	// Go for the chest, but just in case we don't have something with a chest bone we'll use collision and eyeheight settings
	if( P.Mesh.SkeletalMesh != none && P.Mesh.bAnimTreeInitialised )
	{
		if( P.Mesh.MatchRefBone('Head') != INDEX_NONE )
		{
			return P.Mesh.GetBoneLocation( 'Head' );
		}
		/*if( P.Mesh.MatchRefBone('Spine2') != INDEX_NONE )
		{
			return P.Mesh.GetBoneLocation( 'Spine2' );
		}
		else if( P.Mesh.MatchRefBone('Spine1') != INDEX_NONE )
		{
			return P.Mesh.GetBoneLocation( 'Spine1' );
		}*/
		
		return P.Mesh.GetPosition() + ((P.CylinderComponent.CollisionHeight + (P.BaseEyeHeight  * 0.5f)) * vect(0,0,1)) ;
	}

	// General chest area, fallback
	return P.Location + ( vect(0,0,1) * P.BaseEyeHeight * 0.75f );	
}

simulated function ZoomIn(bool bAnimateTransition, float ZoomTimeToGo)
{
    super.ZoomIn(bAnimateTransition, ZoomTimeToGo);

    if (IronsightsZoomInSound != none && Instigator != none && Instigator.IsLocallyControlled())
    {
        IronsightsComponent.PlayEvent(IronsightsZoomInSound, false);
    }
}

/** Clear all locked targets when zooming out, both server and client */
simulated function ZoomOut( bool bAnimateTransition, float ZoomTimeToGo )
{
	super.ZoomOut( bAnimateTransition, ZoomTimeToGo );

    if (IronsightsZoomOutSound != none && Instigator != none && Instigator.IsLocallyControlled())
    {
        IronsightsComponent.PlayEvent(IronsightsZoomOutSound, false);
    }

	// Play a target lost effect if we're clearing targets on the way out
	if( Instigator.IsLocallyControlled() && LockedTargets.Length > 0 )
	{
		PlayTargetLostEffects();
	}
	LockedTargets.Length = 0;
}

/** Play FX or sounds when locking on to a new target */
simulated function PlayTargetLockOnEffects()
{
	if( Instigator != none && Instigator.IsHumanControlled() )
	{
		PlaySoundBase( LockAcquiredSoundFirstPerson, true );
	}
}

/** Play FX or sounds when losing a target lock */
simulated function PlayTargetLostEffects()
{
	if( Instigator != none && Instigator.IsHumanControlled() )
	{
		PlaySoundBase( LockLostSoundFirstPerson, true );
	}
}

/*********************************************************************************************
 * @name Projectile Spawning
 **********************************************************************************************/

/** Spawn projectile is called once for each rocket fired. In burst mode it will cycle through targets until it runs out */
simulated function KFProjectile SpawnProjectile( class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir )
{
	local KFProj_Bullet_Gunzerks StarProj;

    if( CurrentFireMode == GRENADE_FIREMODE )
    {
        return super.SpawnProjectile( KFProjClass, RealStartLoc, AimDir );
    }

    // We need to set our target if we are firing from a locked on position
    if( /*bUsingSights
    	&& CurrentFireMode == ALTFIRE_FIREMODE
    	&&*/ LockedTargets.Length > 0 )
    {
		// We'll aim our rocket at a target here otherwise we will spawn a dumbfire rocket at the end of the function
		if( LockedTargets.Length > 0 )
		{
			// Spawn our projectile and set its target
			StarProj = KFProj_Bullet_Gunzerks( super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir) );
			if( StarProj != none  )
			{
                //Seek to new target, then remove from list.  Always use first target in the list for new fire.
				StarProj.SetLockedTarget( KFPawn(LockedTargets[0]) );
                LockedTargets.Remove(0, 1);

                return StarProj;
			}
		}

		return None;
    }

   	return super.SpawnProjectile( KFProjClass, RealStartLoc, AimDir );
}

/*********************************************************************************************
 * @name Targeting HUD -- Partially adapted from KFWeap_Rifle_RailGun
 **********************************************************************************************/

/** Handle drawing our custom lock on HUD  */
simulated function DrawHUD( HUD H, Canvas C )
{
    local int i;

    if( /*!bUsingSights ||*/ LockedTargets.Length == 0 )
    {
       return;
    }

    // Draw target locked icons
	C.EnableStencilTest( true );
    for( i = 0; i < LockedTargets.Length; ++i )
    {
        if( LockedTargets[i] != none )
        {
            DrawTargetingIcon( C, i );
        }
    }
	C.EnableStencilTest( false );
}

/** Draws a targeting icon for each one of our locked targets */
simulated function DrawTargetingIcon( Canvas Canvas, int Index )
{
    local vector WorldPos, ScreenPos;
    local float IconSize, IconScale;

    // Project world pos to canvas
    WorldPos = GetLockedTargetLoc( LockedTargets[Index] );
    ScreenPos = Canvas.Project( WorldPos );//WorldToCanvas(Canvas, WorldPos);

    // calculate scale based on resolution and distance
    IconScale = fMin( float(Canvas.SizeX) / 1024.f, 1.f );
	// Scale down up to 40 meters away, with a clamp at 20% size
    IconScale *= fClamp( 1.f - VSize(WorldPos - Instigator.Location) / 4000.f, 0.2f, 1.f );
 
    // Apply size scale
    IconSize = 200.f * IconScale;
    ScreenPos.X -= IconSize / 2.f;
    ScreenPos.Y -= IconSize / 2.f;

    // Off-screen check
    if( ScreenPos.X < 0 || ScreenPos.X > Canvas.SizeX || ScreenPos.Y < 0 || ScreenPos.Y > Canvas.SizeY )
    {
        return;
    }

    Canvas.SetPos( ScreenPos.X, ScreenPos.Y );

	// Draw the icon
    Canvas.DrawTile( LockedOnIcon, IconSize, IconSize, 0, 0, LockedOnIcon.SizeX, LockedOnIcon.SizeY, LockedIconColor );
}

/*********************************************************************************************
 * State WeaponSingleFiring
 * Fire must be released between every shot.
 *********************************************************************************************/

/*simulated state WeaponSingleFiring
{
	simulated function BeginState( Name PrevStateName )
	{
		LockedTargets.Length = 0;

		super.BeginState( PrevStateName );
	}
}*/

//------------------------------------------------------------------------------

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
}

simulated function Shoot()
{
	// LocalPlayer Only
	if ( !Instigator.IsLocallyControlled()  )
	{
		return;
	}
	
	if( Role < Role_Authority )
	{
		// if we're a client, synchronize server
		ServerShoot();
	}

	ProcessShoot();
}

/** 
    Each attack shoots twice, once with the right and left fists.
    Ammo is decremented after the second shot.
*/
reliable server function bool ServerShoot()
{
	return ProcessShoot();
}

simulated function bool ProcessShoot()
{
	// Shooting only happens when default firing
	if(CurrentFireMode != DEFAULT_FIREMODE)
		return false;

	CustomFire();

	if (!bWaitingForSecondShot)
	{
		// AmmoCount[DEFAULT_FIREMODE] = Max(AmmoCount[DEFAULT_FIREMODE] - 1, 0);
		DecrementAmmo();
	}

	bWaitingForSecondShot = !bWaitingForSecondShot;
	return true;
}

simulated function DecrementAmmo()
{
    local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive( self ) )
	{
		return;
	}
	AmmoCount[DEFAULT_FIREMODE] = Max(AmmoCount[DEFAULT_FIREMODE] - 1, 0);
}

simulated state Active
{
	/**
	 * Called from Weapon:Active.BeginState when HasAnyAmmo (which is overridden above) returns false.
	 */
	simulated function WeaponEmpty()
	{
		local int i;

		// Copied from Weapon:Active.BeginState where HasAnyAmmo returns true.
		// Basically, pretend the weapon isn't empty in this case.
		for (i=0; i<GetPendingFireLength(); i++)
		{
			if (PendingFire(i))
			{
				BeginFire(i);
				break;
			}
		}
	}
}

static simulated event bool UsesAmmo()
{
	return true;
}

simulated function CustomFire()
{
	local byte CachedFireMode;

	CachedFireMode = CurrentFireMode;
	CurrentFireMode = CUSTOM_FIREMODE;

	ProjectileFire();

	// Let the accuracy tracking system know that we fired
	HandleWeaponShotTaken(CurrentFireMode);

	NotifyWeaponFired(CurrentFireMode);

	// Play fire effects now (don't wait for WeaponFired to replicate)
	PlayFireEffects(CurrentFireMode, vect(0, 0, 0));

	CurrentFireMode = CachedFireMode;
}

/** Override for not playing animations (even if noanimation is set it interrupts the melee ones.) */
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	// If we have stopped the looping fire sound to play single fire sounds for zed time
	// start the looping sound back up again when the time is back above zed time speed
	if( FireModeNum < bLoopingFireSnd.Length && bLoopingFireSnd[FireModeNum] && !bPlayingLoopingFireSnd )
    {
        StartLoopingFireSound(FireModeNum);
    }

	PlayFiringSound(CurrentFireMode);

	if( Instigator != none )
	{
		if( Instigator.IsLocallyControlled() )
		{
			if( Instigator.IsFirstPerson() )
			{
				// Start muzzle flash effect
				CauseMuzzleFlash(FireModeNum);
			}

			ShakeView();
		}
	}
}

/**
 * @see Weapon::StartFire
 */
simulated function StartFire(byte FireModeNum)
{
	// can't start fire because it's in an uninterruptible state
	if (StartFireDisabled)
	{
		return;
	}

	if (FireModeNum == DEFAULT_FIREMODE)
	{
		if(AmmoCount[DEFAULT_FIREMODE] > 0)
		{
			StartMeleeFire(FireModeNum, DIR_FORWARD, ATK_Normal);
		} 
		else
		{
			super.StartFire(RELOAD_FIREMODE);
			// If not cleared, it will loop the animation.
			ClearPendingFire(RELOAD_FIREMODE);
		}
		return;
	}

	super.StartFire(FireModeNum);
}

/** Avoiding reload anim to interrupt combo */
simulated state AltReloading extends MeleeChainAttacking
{
	simulated function int GetBurstAmount()
	{
		// Clamp our bursts to either the number of targets or how much ammo we have remaining
		return Clamp( LockedTargets.Length, 1, AmmoCount[GetAmmoType(CurrentFireMode)] );
	}

    /** Overridden to apply scaled recoil when in multi-rocket mode */
    simulated function ModifyRecoil( out float CurrentRecoilModifier )
	{
		super.ModifyRecoil( CurrentRecoilModifier );

	    CurrentRecoilModifier *= BurstFireRecoilModifier;
	}

    simulated function bool ShouldRefire()
    {
        return LockedTargets.Length > 0;
    }

    simulated function FireAmmunition()
    {
        super.FireAmmunition();
        if (Role < ROLE_Authority)
        {
            LockedTargets.Remove(0, 1);
        }
    }

	simulated function BeginState(Name PrevStateName)
	{
		local KFPerk InstigatorPerk;

		if( CurrentFireMode == DEFAULT_FIREMODE )
		{
			StartFireDisabled = true;
			bWaitingForSecondShot = false;
			NumAttacks = 0;
		}
		
		InstigatorPerk = GetPerk();
		if (InstigatorPerk != none)
		{
			SetZedTimeResist( InstigatorPerk.GetZedTimeModifier(self) );
		}

		super.BeginState( PrevStateName );
	}

	simulated function EndState(Name NextStateName)
	{
		LockedTargets.Length = 0;
		
		super.EndState(NextStateName);
		if( CurrentFireMode == DEFAULT_FIREMODE )
		{
			StartFireDisabled = false;
		}

		ClearZedTimeResist();
	}

	simulated function bool ShouldContinueMelee(optional int ChainCount)
	{
		if ( CurrentFireMode == DEFAULT_FIREMODE )
		{
			return false;
		}	
		return super.ShouldContinueMelee(ChainCount);
	}
}

/**
 * Called on a client, this function Attaches the WeaponAttachment
 * to the Mesh.
 *
 * Overridden to attach LeftMuzzleFlash
 */
simulated function AttachMuzzleFlash()
{
	super.AttachMuzzleFlash();

	if ( MySkelMesh != none )
	{
		if (MuzzleFlashTemplate != None)
		{
			LeftMuzzleFlash = new(self) Class'KFMuzzleFlash'(MuzzleFlashTemplate);
			LeftMuzzleFlash.AttachMuzzleFlash(MySkelMesh, 'MuzzleFlash_L');
		}
	}
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 *
 * Overridden to cause left weapon flash
 */
simulated function CauseMuzzleFlash(byte FireModeNum)
{
	if( MuzzleFlash == None || LeftMuzzleFlash == None )
	{
		AttachMuzzleFlash();
	}

	if( bWaitingForSecondShot )
	{
		if (MuzzleFlash != None )
		{
			// Not ejecting shells for this weapon.
			MuzzleFlash.CauseMuzzleFlash(FireModeNum);
		}
	}
	else
	{
		if( LeftMuzzleFlash != None )
		{
			// Not ejecting shells for this weapon.
			LeftMuzzleFlash.CauseMuzzleFlash(FireModeNum);
		}
	}
}

/**
 * Remove/Detach the muzzle flash components
 */
simulated function DetachMuzzleFlash()
{
	super.DetachMuzzleFlash();

	if (MySkelMesh != none && LeftMuzzleFlash != None)
	{
		LeftMuzzleFlash.DetachMuzzleFlash(MySkelMesh);
		LeftMuzzleFlash = None;
	}
}

/**
 * Adjust the FOV for the first person weapon and arms.
 */
simulated event SetFOV( float NewFOV )
{
	super.SetFOV( NewFOV );

	if( LeftMuzzleFlash != none )
	{
		LeftMuzzleFlash.SetFOV( NewFOV );
	}
}

simulated function StopFireEffects(byte FireModeNum)
{
	super.StopFireEffects( FireModeNum );

	if (LeftMuzzleFlash != None)
	{
        LeftMuzzleFlash.StopMuzzleFlash();
	}
}

/** Returns true if weapon can potentially be reloaded */
simulated function bool CanReload(optional byte FireModeNum)
{
	if ( FiringStatesArray[RELOAD_FIREMODE] == 'WeaponUpkeep' )
	{
		return true;
	}

	if ( FireModeNum == CUSTOM_FIREMODE)
	{
		FireModeNum = DEFAULT_FIREMODE;
	}

	return Super.CanReload(FireModeNum);
}

simulated function name GetReloadAnimName( bool bTacticalReload )
{
	return ReloadAnimation;
}

/** No diferent states */
simulated function EReloadStatus GetNextReloadStatus(optional byte FireModeNum)
{
	switch ( ReloadStatus )
	{
		case RS_None: //drop
		case RS_Reloading:
			if ( HasSpareAmmo(FiremodeNum) && ReloadAmountLeft > 0 )
			{
				return RS_Reloading;
			}
	}

	return RS_Complete;
}

/** Returns an anim rate scale for reloading */
simulated function float GetReloadRateScale()
{
	local float Modifier;

	Modifier = UseTacticalReload() ? ReloadAnimRateModifierElite : ReloadAnimRateModifier;

	return super.GetReloadRateScale() * Modifier;
}

simulated function bool HasAnyAmmo()
{
	return AmmoCount[0] > 0 || SpareAmmoCount[0] > 0;
}

simulated function int GetMeleeDamage(byte FireModeNum, optional vector RayDir)
{
	local int Damage;

	Damage = GetModifiedDamage(FireModeNum, RayDir);
	// decode damage scale (see GetDamageScaleByAngle) from the RayDir
	if ( !IsZero(RayDir) )
	{
		Damage = Round(float(Damage) * FMin(VSize(RayDir), 1.f));
	}

	return Damage;
}

/**
 * See Pawn.ProcessInstantHit
 * @param DamageReduction: Custom KF parameter to handle penetration damage reduction
 */
simulated function ProcessInstantHitEx(byte FiringMode, ImpactInfo Impact, optional int NumHits, optional out float out_PenetrationVal, optional int ImpactNum )
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none )
	{
		InstigatorPerk.UpdatePerkHeadShots( Impact, InstantHitDamageTypes[FiringMode], ImpactNum );
	}
	
	super.ProcessInstantHitEx( FiringMode, Impact, NumHits, out_PenetrationVal, ImpactNum );
}

defaultproperties
{
	// Content
	PackageKey="HRG_Gunzerks"
	FirstPersonMeshName="WEP_1P_HRG_BlastBrawlers_MESH.WEP_1stP_HRG_Blast_Brawlers_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_HRG_BlastBrawlers_ANIM.WEP_1P_HRG_BlastBrawlers_ANIM"
	PickupMeshName="WEP_3P_HRG_BlastBrawlers_MESH.Wep_HRG_Blast_Brawlers_Pickup"
	AttachmentArchetypeName="WEP_HRG_BlastBrawlers_ARCH.Wep_HRG_BlastBrawlers_3P"
	MuzzleFlashTemplateName="WEP_HRG_BlastBrawlers_ARCH.Wep_HRG_BlastBrawler_MuzzleFlash"

	Begin Object Class=KFMeleeHelperWeaponGunzerks Name=MeleeHelper_0
		MaxHitRange=230 //150 //190
		// Override automatic hitbox creation (advanced)
		HitboxChain.Add((BoneOffset=(Y=+3,Z=150)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=130)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=110)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=90)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=70)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=50)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=30)))
		HitboxChain.Add((BoneOffset=(Z=10)))
		HitboxChain.Add((BoneOffset=(Z=-10)))
		WorldImpactEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Blunted_melee_impact'
		// modified combo sequences
		bAllowMeleeToFracture=false
		bUseDirectionalMelee=true
		bHasChainAttacks=false
		MeleeImpactCamShakeScale=0.035f //0.4
		ChainSequence_F=()
		ChainSequence_B=()
		ChainSequence_L=()
		ChainSequence_R=()
	End Object
	MeleeAttackHelper=MeleeHelper_0

	// Target Locking
	MinTargetDistFromCrosshairSQ=2500.0f // 0.5 meters
	TimeBetweenLockOns=0.06f
	TargetValidationCheckInterval=0.1f
	MaxLockMaintainFOVDotThreshold=0.36f

	// LockOn Visuals
    LockedOnIcon=Texture2D'Wep_Scope_TEX.Wep_1stP_Yellow_Red_Target'
    LockedIconColor=(R=1.f, G=0.f, B=0.f, A=0.5f)

    // Lock On/Lost Sounds
	LockAcquiredSoundFirstPerson=AkEvent'WW_WEP_SA_Railgun.Play_Railgun_Scope_Locked'
	LockLostSoundFirstPerson=AkEvent'WW_WEP_SA_Railgun.Play_Railgun_Scope_Lost'

	// FOV
	//MeshFOV=95

    // Shotgun Ammo
	MagazineCapacity[0]=10//6//4 //3
	SpareAmmoCapacity[0]=100//60//40 //36 //28
	InitialSpareMags[0]=2
	AmmoPickupScale[0]=1.5 //2.0

	bCanBeReloaded=true
	bReloadFromMagazine=true
	bNoMagazine=false
	
	// Zooming/Position
	PlayerViewOffset=(X=20,Y=0,Z=0)

    // Inventory
	GroupPriority=110
	InventorySize=6//9 //7
	WeaponSelectTexture=Texture2D'WEP_UI_HRG_BlastBrawlers_TEX.UI_WeaponSelect_HRG_BlastBrawlers'
	FireModeIconPaths(CUSTOM_FIREMODE)=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_AutoTarget'
	FiringStatesArray(CUSTOM_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(CUSTOM_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(CUSTOM_FIREMODE)=class'KFProj_Bullet_Gunzerks'
    FireInterval(CUSTOM_FIREMODE)=0.1f
	InstantHitDamageTypes(CUSTOM_FIREMODE)=class'KFDT_Ballistic_GunzerksShotgun'
    InstantHitDamage(CUSTOM_FIREMODE)=78//130//195//26//39//50
	AmmoCost(CUSTOM_FIREMODE)=0
	NumPellets(CUSTOM_FIREMODE)=1//5
	Spread(CUSTOM_FIREMODE)=0//0.12 //0.1 //0.15
	WeaponFireSnd(CUSTOM_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_BlastBrawlers.Play_WEP_HRG_BlastBrawlers_Shoot_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_BlastBrawlers.Play_WEP_HRG_BlastBrawlers_Shoot_1P')
	InstantHitMomentum(CUSTOM_FIREMODE)=1.0
	PenetrationPower(CUSTOM_FIREMODE)=2.0
	PenetrationDamageReductionCurve(CUSTOM_FIREMODE)=(Points=((InVal=0.f,OutVal=0.f),(InVal=1.f, OutVal=1.f)))

	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_AutoTarget'
	InstantHitDamage(DEFAULT_FIREMODE)=50
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Bludgeon_Gunzerks'
	FiringStatesArray(DEFAULT_FIREMODE)=AltReloading//MeleeChainAttacking

	FireModeIconPaths(HEAVY_ATK_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BluntMelee'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=200 //175
	InstantHitDamageTypes(HEAVY_ATK_FIREMODE)=class'KFDT_Bludgeon_GunzerksHeavy'

	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_GunzerksBash'
	InstantHitDamage(BASH_FIREMODE)=100

	FiringStatesArray(RELOAD_FIREMODE)=Reloading

	AssociatedPerkClasses(0)=class'KFPerk_Gunslinger'
	
	// Block Sounds
	BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Block_MEL_Crovel'
	ParrySound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Metal'

	ParryStrength=5
	ParryDamageMitigationPercent=0.40
	BlockDamageMitigation=0.50 //0.40

	bWaitingForSecondShot = false
	NumAttacks = 0

	bAllowClientAmmoTracking=false

	ReloadAnimation = "Atk_B"
	ReloadAnimRateModifier = 1.6f
	ReloadAnimRateModifierElite = 1.0f; //0.5f;

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.125f), (Stat=EWUS_Damage1, Scale=1.125f), (Stat=EWUS_Damage2, Scale=1.125f), (Stat=EWUS_Weight, Add=1)))
}
