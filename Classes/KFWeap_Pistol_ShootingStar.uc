class KFWeap_Pistol_ShootingStar extends KFWeap_PistolBase;

const MAX_LOCKED_TARGETS = 6;

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

/**
* Toggle between DEFAULT and ALTFIRE
*/
/*simulated function AltFireMode()
{
    super.AltFireMode();
   
    LockedTargets.Length = 0;
}*/

/*********************************************************************************************
 * @name Target Locking And Validation
 **********************************************************************************************/

/** We need to update our locked targets every frame and make sure they're within view and not dead */
simulated event Tick( float DeltaTime )
{
	local Pawn RecentlyLocked, StaticLockedTargets[6];
	local bool bUpdateServerTargets;
	local int i;

	super.Tick( DeltaTime );

    if( bUsingSights /*&& bUseAltFireMode*/
    	&& Instigator != none
    	&& Instigator.IsLocallyControlled() )
    {
		if( `TimeSince(LastTargetLockTime) > TimeBetweenLockOns
			&& LockedTargets.Length < AmmoCount[GetAmmoType(0)]
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
    if (IsInState('WeaponBurstFiring'))
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
	local KFProj_Bullet_Pistol_ShootingStar StarProj;

    if( CurrentFireMode == GRENADE_FIREMODE )
    {
        return super.SpawnProjectile( KFProjClass, RealStartLoc, AimDir );
    }

    // We need to set our target if we are firing from a locked on position
    if( bUsingSights
    	/*&& CurrentFireMode == ALTFIRE_FIREMODE*/
    	&& LockedTargets.Length > 0 )
    {
		// We'll aim our rocket at a target here otherwise we will spawn a dumbfire rocket at the end of the function
		if( LockedTargets.Length > 0 )
		{
			// Spawn our projectile and set its target
			StarProj = KFProj_Bullet_Pistol_ShootingStar( super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir) );
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

simulated state WeaponSingleFiring
{
	simulated function BeginState( Name PrevStateName )
	{
		LockedTargets.Length = 0;

		super.BeginState( PrevStateName );
	}
}

/*********************************************************************************************
 * State WeaponBurstFiring
 * Fires a burst of bullets. Fire must be released between every shot.
 *********************************************************************************************/

simulated state WeaponBurstFiring
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

	simulated event EndState( Name NextStateName )
	{
		LockedTargets.Length = 0;

		super.EndState( NextStateName );
	}
}

defaultproperties
{
    // FOV
    MeshFOV=86
    MeshIronSightFOV=77
    PlayerIronSightFOV=77

    // Depth of field
    DOF_FG_FocalRadius=38
    DOF_FG_MaxNearBlurSize=3.5

    // Zooming/Position
    PlayerViewOffset=(X=14.0,Y=10,Z=-4)

	// Content
	PackageKey="ShootingStar"
	FirstPersonMeshName="WEP_1P_ChiappaRhino_MESH.Wep_1stP_ChiappaRhino_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_ChiappaRhino_ANIM.WEP_1stP_ChiappaRhino_Anim"
    PickupMeshName="WEP_3P_ChiappaRhino_MESH.Wep_3rdP_ChiappaRhino_Pickup"
    AttachmentArchetypeName="WEP_ChiappaRhino_ARCH.Wep_ChiappaRhino_3P"
	MuzzleFlashTemplateName="WEP_ChiappaRhino_ARCH.Wep_ChiappaRhino_MuzzleFlash"

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

    // Zooming/Position
    IronSightPosition=(X=11,Y=0,Z=-.25)

    // Ammo
    MagazineCapacity[0]=6
    SpareAmmoCapacity[0]=114
    InitialSpareMags[0]=7
    AmmoPickupScale[0]=2.0
    bCanBeReloaded=true
    bReloadFromMagazine=true

    // Recoil
    maxRecoilPitch=500
    minRecoilPitch=450
    maxRecoilYaw=150
    minRecoilYaw=-150
    RecoilRate=0.07
    RecoilMaxYawLimit=500
    RecoilMinYawLimit=65035
    RecoilMaxPitchLimit=1250
    RecoilMinPitchLimit=65035
    RecoilISMaxYawLimit=50
    RecoilISMinYawLimit=65485
    RecoilISMaxPitchLimit=500
    RecoilISMinPitchLimit=65485

    // DEFAULT_FIREMODE
    FiringStatesArray(DEFAULT_FIREMODE)=WeaponBurstFiring
    WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pistol_ShootingStar'
    FireInterval(DEFAULT_FIREMODE)=+0.175
    InstantHitDamage(DEFAULT_FIREMODE)=75.0 //70.0
    InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_ShootingStar'
    PenetrationPower(DEFAULT_FIREMODE)=2.0
    Spread(DEFAULT_FIREMODE)=0.01
    FireOffset=(X=20,Y=4.0,Z=-3)

	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_AutoTarget'

    // ALT_FIREMODE
    FiringStatesArray(ALTFIRE_FIREMODE)=WeaponBurstFiring
    WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_AutoTarget'

    // BASH_FIREMODE
    InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_ShootingStar'
    InstantHitDamage(BASH_FIREMODE)=24

    // Fire Effects
    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_Fire_1P')
    WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_DryFire'

    // Attachments
    bHasIronSights=true
    bHasFlashlight=false

    // Inventory
    InventorySize=2
    GroupPriority=22
    bCanThrow=true
    bDropOnDeath=true
    WeaponSelectTexture=Texture2D'wep_ui_chiapparhino_tex.UI_WeaponSelect_ChiappaRhinos'
    bIsBackupWeapon=false
    AssociatedPerkClasses(0)=class'KFPerk_Gunslinger'

    DualClass=class'KFWeap_Pistol_ShootingStarDual'

    // Custom animations
    FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)
    IdleFidgetAnims=(Guncheck_v1, Guncheck_v2, Guncheck_v3, Guncheck_v4)

    bHasFireLastAnims=true

    BonesToLockOnEmpty=(RW_Hammer)

    WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

    WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Weight, Add=1)))
    WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
}