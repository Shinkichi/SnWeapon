class KFWeap_Rifle_MaserGun extends KFWeap_ScopedBase;

//Props related to charging the weapon
var float MaxChargeTime;
var float ValueIncreaseTime;
var float DmgIncreasePerCharge;
var float AOEIncreasePerCharge;
var float IncapIncreasePerCharge;
var int AmmoIncreasePerCharge;

var transient float ChargeTime;
var transient float ConsumeAmmoTime;
var transient float MaxChargeLevel;

var ParticleSystem ChargingEffect;
var ParticleSystem ChargedEffect;

var transient ParticleSystemComponent ChargingPSC;
var transient bool bIsFullyCharged;

var const WeaponFireSndInfo FullyChargedSound;

var float SelfDamageReductionValue;

var float FullChargedTimerInterval;

var ScriptedTexture CanvasTexture;

/** Current length of the square scope texture. This is checked against before modifying the
    ScopeTextureSize in the scenario when InitFOV is called multiple times with the same values */
var int CurrentCanvasTextureSize;

/** Icon textures for lock on drawing */
var Texture2D LockedHitZoneIcon;
var Texture2D DefaultHitZoneIcon;
var LinearColor RedIconColor;
var LinearColor YellowIconColor;
var LinearColor BlueIconColor;

/*********************************************************************************************
 * @name Weapon lock on support
 **********************************************************************************************/

/** angle of the maximum FOV extents of the scope for rending things onto the scope canvas */
var float MaxScopeScreenDot;

/*********************************************************************************************
 * @name Ambient sound
 ********************************************************************************************* */
/** Pilot light sound play event */
var AkEvent                         AmbientSoundPlayEvent;

/** Pilot light sound stop event */
var AkEvent	                        AmbientSoundStopEvent;

/** Socket to attach the ambient sound to. */
var() name AmbientSoundSocketName;

/**
 * Initialize the FOV settings for this weapon, adjusting for aspect ratio
 * @param SizeX the X resolution of the screen
 * @param SizeY the Y resolution of the screen
 * @param DefaultPlayerFOV the default player FOV of the player holding this weapon
 */
simulated function InitFOV(float SizeX, float SizeY, float DefaultPlayerFOV)
{
    local int NewScopeTextureSize;

    super.InitFOV(SizeX, SizeY, DefaultPlayerFOV);

    NewScopeTextureSize = int(ScopeTextureScale*SizeX);

    if(NewScopeTextureSize > MaxSceneCaptureSize)
        NewScopeTextureSize = MaxSceneCaptureSize;

    if( CurrentCanvasTextureSize != NewScopeTextureSize )
    {
        CanvasTexture =  ScriptedTexture(class'ScriptedTexture'.static.Create(NewScopeTextureSize, NewScopeTextureSize, PF_FloatRGB, MakeLinearColor(0,0,0,0)));

        CanvasTexture.Render = OnRender;
        CanvasTexture.bNeedsTwoCopies = true;

        if( ScopeLenseMIC != none )
        {
            ScopeLenseMIC.SetTextureParameterValue('ScopeText', CanvasTexture);
        }
        CurrentCanvasTextureSize = NewScopeTextureSize;
    }
}

simulated function AltFireMode ()
{
	super.AltFireMode();
	TargetingComp.AdjustLockTarget(ETargetingMode_Zed, none);
	TargetingComp.AdjustLockTarget(ETargetingMode_Player, none);
}

/**
 * Set parameters for the weapon once replication is complete (works in Standalone as well)
 */
reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet);

    // Only want to spawn sniper lenses on human players, but when PostBeginPlay
    // gets called Instigator isn't valid yet. So using NetMode == NM_Client,
    // since weapons should only exist on owning human clients with that netmode
    if( Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled() )
    {
        if( ScopeLenseMIC != none )
        {
            ScopeLenseMIC.SetTextureParameterValue('ScopeText', CanvasTexture);
        }
    }
}

simulated function StartFire(byte FireModeNum)
{
	// Attempt auto-reload
	if ( FireModeNum == ALTFIRE_FIREMODE )
	{
		`log("Nope, use the default you dirty cheater :)");
		FiremodeNum = DEFAULT_FIREMODE;
	}

	Super.StartFire(FireModeNum);
}

/** Return true if this weapon should play the fire last animation for this shoot animation */
simulated function bool ShouldPlayFireLast(byte FireModeNum)
{
//    if( SpareAmmoCount[GetAmmoType(FireModeNum)] == 0 )
//    {
//        return true;
//    }

    return false;
}

/** Returns animation to play based on reload type and status */
simulated function name GetReloadAnimName( bool bTacticalReload )
{
	if ( AmmoCount[0] > 0 )
	{
		// Disable half-reloads for now.  This can happen if server gets out
		// of sync, but choosing the wrong animation will just make it worse!
		`warn("Railgun reloading with non-empty mag");
	}

	return bTacticalReload ? ReloadEmptyMagEliteAnim : ReloadEmptyMagAnim;
}

/*********************************************************************************************
 * @name Ambient sound
 **********************************************************************************************/
/**
 * Starts playing looping ambient sound
 */
simulated function StartAmbientSound()
{
	if( Instigator != none && Instigator.IsLocallyControlled() && Instigator.IsFirstPerson() )
	{
        PostAkEventOnBone(AmbientSoundPlayEvent, AmbientSoundSocketName, false, false);
    }
}

/**
 * Stops playing looping ambient sound
 */
simulated function StopAmbientSound()
{
    PostAkEventOnBone(AmbientSoundStopEvent, AmbientSoundSocketName, false, false);
}

/**
 * Detach weapon from skeletal mesh
 *
 * @param	SkeletalMeshComponent weapon is attached to.
 */
simulated function DetachWeapon()
{
    StopAmbientSound();
    Super.DetachWeapon();
}

/*********************************************************************************************
 * @name Weapon lock on and targeting
 **********************************************************************************************/

/**
 * Tick the weapon (used for simple updates)
 *
 * @param	DeltaTime Elapsed time.
 */
simulated event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

	if (Instigator != none && Instigator.Controller != none && Instigator.IsLocallyControlled())
	{
		CanvasTexture.bNeedsUpdate = bUsingSights && TargetingComp.bTargetingUpdated;
	}
}

/** Event called when weapon actor is destroyed */
simulated event Destroyed()
{
    if( CanvasTexture != none )
    {
        CanvasTexture = none;
    }

    StopAmbientSound();

	super.Destroyed();
}

/*********************************************************************************************
 * @name Targeting HUD
 **********************************************************************************************/

/** Handle drawing items on the scope ScriptedTexture */
simulated function OnRender(Canvas C)
{
    local int i;

    if( !bUsingSights )
    {
       return;
    }

	// Draw the targeting locations on the scope
	for (i = 0; i < TargetingComp.TargetVulnerableLocations_Zed.Length; i++)
    {
        if( !IsZero(TargetingComp.TargetVulnerableLocations_Zed[i]) )
        {
            DrawTargetingIcon( C, i );
        }
    }

    CanvasTexture.bNeedsUpdate = true;
}

/**
 * @brief Draws an icon when human players are hidden but in the field of view
 *
 * @param PRI Player's PlayerReplicationInfo
 * @param IconWorldLocation The "player's" location in the world
 */
simulated function DrawTargetingIcon( Canvas Canvas, int index )
{
    local vector WorldPos;
    local float IconSize, IconScale;
    local vector2d ScreenPos;

    // Project world pos to canvas
	WorldPos = TargetingComp.TargetVulnerableLocations_Zed[index];
    ScreenPos = WorldToCanvas(Canvas, WorldPos);

    // calculate scale based on resolution and distance
    IconScale = FMin(float(Canvas.SizeX) / 1024.f, 1.f);
	// Scale down up to 40 meters away, with a clamp at 20% size
    IconScale *= FClamp(1.f - VSize(WorldPos - Instigator.Location) / 4000.f, 0.2f, 1.f);

    // Apply size scale
    IconSize = 300.f * IconScale;
    ScreenPos.X -= IconSize / 2.f;
    ScreenPos.Y -= IconSize / 2.f;

    // Off-screen check
    if( ScreenPos.X < 0 || ScreenPos.X > Canvas.SizeX || ScreenPos.Y < 0 || ScreenPos.Y > Canvas.SizeY )
    {
        return;
    }

    Canvas.SetPos( ScreenPos.X, ScreenPos.Y );

	// Pick the color of the targeting box to draw
	if( TargetingComp.LockedHitZone[0] >= 0 && index == TargetingComp.LockedHitZone[0] )
    {
        Canvas.DrawTile( LockedHitZoneIcon, IconSize, IconSize, 0, 0, LockedHitZoneIcon.SizeX, LockedHitZoneIcon.SizeY, RedIconColor);
    }
    else if( TargetingComp.PendingHitZone[0] >= 0 && index == TargetingComp.PendingHitZone[0] )
    {
        Canvas.DrawTile( LockedHitZoneIcon, IconSize, IconSize, 0, 0, LockedHitZoneIcon.SizeX, LockedHitZoneIcon.SizeY, YellowIconColor);
    }
    else
    {
        Canvas.DrawTile( DefaultHitZoneIcon, IconSize, IconSize, 0, 0, DefaultHitZoneIcon.SizeX, DefaultHitZoneIcon.SizeY, BlueIconColor);
    }
}

/**
 * Canvas.Project() doesn't work because our Canvas doesn't have a FSceneView, so
 * we have to get the transforms out of the scene capture actor... or in this
 * case we can make it work with angles
 */
simulated function vector2d WorldToCanvas( Canvas Canvas, vector WorldPoint)
{
	local vector ViewLoc, ViewDir;
	local rotator ViewRot;
	local vector X,Y,Z;
	local vector2d ScreenPoint;
	local float DotToZedUpDown, DotToZedLeftRight, UpDownScale, LeftRightScale;

	Instigator.Controller.GetPlayerViewPoint(ViewLoc, ViewRot);
	GetAxes(ViewRot, X, Y, Z);
	ViewDir = Normal(WorldPoint - ViewLoc);

    DotToZedUpDown = Z dot ViewDir;
    DotToZedLeftRight = Y dot ViewDir;

    UpDownScale = DotToZedUpDown/MaxScopeScreenDot;
    LeftRightScale = DotToZedLeftRight/MaxScopeScreenDot;

    ScreenPoint.X = CanvasTexture.SizeX * (0.5 + LeftRightScale * 0.5);
    ScreenPoint.Y = CanvasTexture.SizeY * (0.5 - UpDownScale * 0.5);

	return ScreenPoint;
}

/*
{
	local vector V;

	// transform by viewProjectionMatrix
	V = TransformVector(SceneCapture.ViewMatrix * SceneCapture.ProjMatrix, WorldPoint);

	// apply clip "matrix"
	V.X = (Canvas.ClipX/2.f) + (V.X*(Canvas.ClipX/2.f));
	V.Y *= -1.f;
	V.Y = (Canvas.ClipY/2.f) + (V.Y*(Canvas.ClipY/2.f));

	return V;
}
*/

/*********************************************************************************************
 * state Inactive
 * This state is the default state.  It needs to make sure Zooming is reset when entering/leaving
 *********************************************************************************************/

auto simulated state Inactive
{
	simulated function BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		StopAmbientSound();
	}
}

/*********************************************************************************************
 * State WeaponEquipping
 * The Weapon is in this state while transitioning from Inactive to Active state.
 * Typically, the weapon will remain in this state while its selection animation is being played.
 * While in this state, the weapon cannot be fired.
*********************************************************************************************/

simulated state WeaponEquipping
{
	simulated function BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
        StartAmbientSound();
	}
}

/*********************************************************************************************
 * State WeaponPuttingDown
 * Putting down weapon in favor of a new one.
 * Weapon is transitioning to the Inactive state.
*********************************************************************************************/

simulated state WeaponPuttingDown
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		StopAmbientSound();
	}
}

/*********************************************************************************************
* State WeaponAbortEquip
* Special PuttingDown state used when WeaponEquipping is interrupted.  Must come after
* WeaponPuttingDown definition or this willextend the super version.
*********************************************************************************************/

simulated state WeaponAbortEquip
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		StopAmbientSound();
	}
}

static simulated function float CalculateTraderWeaponStatDamage()
{
	local float CalculatedDamage;
	local class<KFDamageType> DamageType;
	local GameExplosion ExplosionInstance;

	ExplosionInstance = class<KFProjectile>(default.WeaponProjectiles[DEFAULT_FIREMODE]).default.ExplosionTemplate;

	CalculatedDamage = default.InstantHitDamage[DEFAULT_FIREMODE] + ExplosionInstance.Damage;

	DamageType = class<KFDamageType>(ExplosionInstance.MyDamageType);
	if (DamageType != none && DamageType.default.DoT_Type != DOT_None)
	{
		CalculatedDamage += (DamageType.default.DoT_Duration / DamageType.default.DoT_Interval) * (CalculatedDamage * DamageType.default.DoT_DamageScale);
	}

	return CalculatedDamage;
}


/**
* @see Weapon::ConsumeAmmo
*/
simulated function ConsumeAmmo(byte FireModeNum)
{
    local KFPerk InstigatorPerk;

`if(`notdefined(ShippingPC))
    if (bInfiniteAmmo)
    {
        return;
    }
`endif

    InstigatorPerk = GetPerk();
    if (InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive(self)) //check for pyro maniac
    {
        return;
    }

    // If AmmoCount is being replicated, don't allow the client to modify it here
    if (Role == ROLE_Authority || bAllowClientAmmoTracking)
    {
		super.ConsumeAmmo(FireModeNum);
    }
}

/*simulated function StartFire(byte FiremodeNum)
{
	if (IsTimerActive('RefireCheckTimer'))
	{
		return;
	}

	super.StartFire(FiremodeNum);
}*/

simulated function OnStartFire()
{
	local KFPawn PawnInst;
	PawnInst = KFPawn(Instigator);

	if (PawnInst != none)
	{
		PawnInst.OnStartFire();
	}
}


/*simulated function FireAmmunition()
{
	// Let the accuracy tracking system know that we fired
	HandleWeaponShotTaken(CurrentFireMode);

	// Handle the different fire types
	switch (WeaponFireTypes[CurrentFireMode])
	{
	case EWFT_InstantHit:
		// Launch a projectile if we are in zed time, and this weapon has a projectile to launch for this mode
		if (`IsInZedTime(self) && WeaponProjectiles[CurrentFireMode] != none )
		{
			ProjectileFire();
		}
		else
		{
			InstantFireClient();
		}
		break;

	case EWFT_Projectile:
		ProjectileFire();
		break;

	case EWFT_Custom:
		CustomFire();
		break;
	}

	// If we're firing without charging, still consume one ammo
	if (GetChargeLevel() < 1)
	{
		ConsumeAmmo(CurrentFireMode);
	}

	NotifyWeaponFired(CurrentFireMode);

	// Play fire effects now (don't wait for WeaponFired to replicate)
	PlayFireEffects(CurrentFireMode, vect(0, 0, 0));
}*/

simulated state HuskCannonCharge extends WeaponFiring
{
    //For minimal code purposes, I'll directly call global.FireAmmunition after charging is released
    simulated function FireAmmunition()
    {}

    //Store start fire time so we don't have to timer this
    simulated event BeginState(Name PreviousStateName)
    {
        super.BeginState(PreviousStateName);

		ChargeTime = 0;
		ConsumeAmmoTime = 0;
		MaxChargeLevel = int(MaxChargeTime / ValueIncreaseTime);

		if (ChargingPSC == none)
		{
			ChargingPSC = new(self) class'ParticleSystemComponent';

			if(MySkelMesh != none)
			{
				MySkelMesh.AttachComponentToSocket(ChargingPSC, 'MuzzleFlash');
			}
			else
			{
				AttachComponent(ChargingPSC);
			}
		}
		else
		{
			ChargingPSC.ActivateSystem();
		}

		bIsFullyCharged = false;

		global.OnStartFire();

		if(ChargingPSC != none)
		{
			ChargingPSC.SetTemplate(ChargingEffect);
		}
    }

	simulated function bool ShouldRefire()
	{
		// ignore how much ammo is left (super/global counts ammo)
		return StillFiring(CurrentFireMode);
	}

    simulated event Tick(float DeltaTime)
    {
        local float ChargeRTPC;

		global.Tick(DeltaTime);

		// Don't charge unless we're holding down the button
		if (PendingFire(CurrentFireMode))
		{
			ConsumeAmmoTime += DeltaTime;
		}

		if (bIsFullyCharged)
		{
			if (ConsumeAmmoTime >= FullChargedTimerInterval)
			{
				//ConsumeAmmo(DEFAULT_FIREMODE);
				ConsumeAmmoTime -= FullChargedTimerInterval;
			}

			return;
		}

		// Don't charge unless we're holding down the button
		if (PendingFire(CurrentFireMode))
		{
			ChargeTime += DeltaTime;
		}

		ChargeRTPC = FMin(ChargeTime / MaxChargeTime, 1.f);
        KFPawn(Instigator).SetWeaponComponentRTPCValue("Weapon_Charge", ChargeRTPC); //For looping component
        Instigator.SetRTPCValue('Weapon_Charge', ChargeRTPC); //For one-shot sounds

		if (ConsumeAmmoTime >= ValueIncreaseTime)
		{
			ConsumeAmmo(DEFAULT_FIREMODE);
			ConsumeAmmoTime -= ValueIncreaseTime;
		}

		if (ChargeTime >= MaxChargeTime || !HasAmmo(DEFAULT_FIREMODE))
		{
			bIsFullyCharged = true;
			ChargingPSC.SetTemplate(ChargedEffect);
			KFPawn(Instigator).SetWeaponAmbientSound(FullyChargedSound.DefaultCue, FullyChargedSound.FirstPersonCue);
		}
    }

    //Now that we're done charging, directly call FireAmmunition. This will handle the actual projectile fire and scaling.
    simulated event EndState(Name NextStateName)
    {
		ClearZedTimeResist();
        ClearPendingFire(CurrentFireMode);
		ClearTimer(nameof(RefireCheckTimer));

		KFPawn(Instigator).bHasStartedFire = false;
		KFPawn(Instigator).bNetDirty = true;

		if (ChargingPSC != none)
		{
			ChargingPSC.DeactivateSystem();
		}

		KFPawn(Instigator).SetWeaponAmbientSound(none);
    }

	simulated function HandleFinishedFiring()
	{
		global.FireAmmunition();

		if (bPlayingLoopingFireAnim)
		{
			StopLoopingFireEffects(CurrentFireMode);
		}

		if (MuzzleFlash != none)
		{
			SetTimer(MuzzleFlash.MuzzleFlash.Duration, false, 'Timer_StopFireEffects');
		}
		else
		{
			SetTimer(0.3f, false, 'Timer_StopFireEffects');
		}

		NotifyWeaponFinishedFiring(CurrentFireMode);

		super.HandleFinishedFiring();
	}
}

// Placing the actual Weapon Firing end state here since we need it to happen at the end of the actual firing loop.
simulated function Timer_StopFireEffects()
{
	// Simulate weapon firing effects on the local client
	if (WorldInfo.NetMode == NM_Client)
	{
		Instigator.WeaponStoppedFiring(self, false);
	}

	ClearFlashCount();
	ClearFlashLocation();
}

/*simulated function CauseMuzzleFlash(byte FireModeNum)
{
	if (MuzzleFlash == None)
	{
		AttachMuzzleFlash();
	}

	super.CauseMuzzleFlash(FireModeNum);
}*/

simulated function int GetChargeLevel()
{
	return Min(ChargeTime / ValueIncreaseTime, MaxChargeLevel);
}

// Should generally match up with KFWeapAttach_HuskCannon::GetChargeFXLevel
/*simulated function int GetChargeFXLevel()
{
	local int ChargeLevel;

	ChargeLevel = GetChargeLevel();
	if (ChargeLevel < 1)
	{
		return 1;
	}
	else if (ChargeLevel < MaxChargeLevel)
	{
		return 2;
	}
	else
	{
		return 3;
	}
}*/

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super.AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != none && DamageCauser != none && DamageCauser.Instigator == Instigator ) //self
	{
		InDamage *= SelfDamageReductionValue;
	}
}

// increase the instant hit damage based on the charge level
simulated function int GetModifiedDamage(byte FireModeNum, optional vector RayDir)
{
	local int ModifiedDamage;

	ModifiedDamage = super.GetModifiedDamage(FireModeNum, RayDir);
	if (FireModeNum == DEFAULT_FIREMODE)
	{
		ModifiedDamage = ModifiedDamage * (1.f + DmgIncreasePerCharge * GetChargeLevel());
	}

	return ModifiedDamage;
}

/**
 * Performs an 'Instant Hit' shot.
 * Network: Local Player and Server
 * Overriden to support the aim targeting of the railgun
 */
simulated function InstantFireClient()
{
	local vector			StartTrace, EndTrace;
	local rotator			AimRot;
	local Array<ImpactInfo>	ImpactList;
	local int				Idx;
	local ImpactInfo		RealImpact;
	local float				CurPenetrationValue;
	local vector			AimLocation;

	// see Controller AimHelpDot() / AimingHelp()
	bInstantHit = true;

	// define range to use for CalcWeaponFire()
	AimLocation = GetInstantFireAimLocation();
	StartTrace = GetSafeStartTraceLocation();
	if (!IsZero(AimLocation))
	{
		AimRot = rotator(Normal(AimLocation - StartTrace));
    	EndTrace = StartTrace + vector(AimRot) * GetTraceRange();
	}
	else
	{
    	AimRot = GetAdjustedAim(StartTrace);
    	EndTrace = StartTrace + vector(AimRot) * GetTraceRange();
	}

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
	if( Instigator != None )
	{
		// If we have penetration, set the hitlocation to the last thing we hit
        if( ImpactList.Length > 0 )
		{
            Instigator.SetFlashLocation( Self, CurrentFireMode, ImpactList[ImpactList.Length - 1].HitLocation );
        }
        else
        {
            Instigator.SetFlashLocation( Self, CurrentFireMode, RealImpact.HitLocation );
        }
	}

	// local player only for clientside hit detection
	if ( Instigator != None && Instigator.IsLocallyControlled() )
	{
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
}

simulated function vector GetInstantFireAimLocation()
{
	return TargetingComp.LockedAimLocation[0];
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
	// Inventory / Grouping
	InventorySize=9 //10
	GroupPriority=100
	WeaponSelectTexture=Texture2D'WEP_UI_RailGun_TEX.UI_WeaponSelect_Railgun'
   	AssociatedPerkClasses(0)=class'KFPerk_Firebug'

   	// 2D scene capture
	Begin Object Name=SceneCapture2DComponent0
	   //TextureTarget=TextureRenderTarget2D'Wep_Mat_Lib.WEP_ScopeLense_Target'
	   FieldOfView=23.0 // "1.5X" = 35.0(our real world FOV determinant)/1.5
	End Object

    ScopedSensitivityMod=16.0

	ScopeLenseMICTemplate=MaterialInstanceConstant'WEP_1P_RailGun_MAT.Wep_1stP_RailGun_Lens_MIC'

    // FOV
	MeshIronSightFOV=27
    PlayerIronSightFOV=70

	// Depth of field
	DOF_BlendInSpeed=3.0
	DOF_FG_FocalRadius=0//70
	DOF_FG_MaxNearBlurSize=3.5

	// Content
	PackageKey="MaserGun"
	FirstPersonMeshName="WEP_1P_RailGun_MESH.WEP_1stP_RailGun_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_RailGun_ANIM.WEP_1P_RailGun_ANIM"
	PickupMeshName="wep_3p_railgun_mesh.Wep_3rdP_RailGun_Pickup"
	AttachmentArchetypeName="WEP_RailGun_ARCH.Wep_RailGun_3P_Updated"
	MuzzleFlashTemplateName="WEP_RailGun_ARCH.Wep_RailGun_MuzzleFlash"

	// Ammo
	MagazineCapacity[0]=1
	SpareAmmoCapacity[0]=32 //20
	InitialSpareMags[0]=6
	bCanBeReloaded=true
	bReloadFromMagazine=true
	AmmoPickupScale[0]=3.0

	// Zooming/Position
	PlayerViewOffset=(X=3.0,Y=7,Z=-2)
	IronSightPosition=(X=-0.25,Y=0,Z=0) // any further back along X and the scope clips through the camera during firing

	// AI warning system
	bWarnAIWhenAiming=true
	AimWarningDelay=(X=0.4f, Y=0.8f)
	AimWarningCooldown=0.0f

	// Recoil
	maxRecoilPitch=600
	minRecoilPitch=450
	maxRecoilYaw=250
	minRecoilYaw=-250
	RecoilRate=0.09
	RecoilBlendOutRatio=1.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1500
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.6
	FallingRecoilModifier=1.5
	HippedRecoilModifier=2.33333

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_AutoTarget'
	FiringStatesArray(DEFAULT_FIREMODE)=HuskCannonCharge//WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_MaserGun'
	InstantHitDamage(DEFAULT_FIREMODE)=70//280  //375
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_MaserGun'
	FireInterval(DEFAULT_FIREMODE)=0.1 //0.4
	PenetrationPower(DEFAULT_FIREMODE)=10.0
	Spread(DEFAULT_FIREMODE)=0.005
	FireOffset=(X=30,Y=3.0,Z=-2.5)
	ForceReloadTimeOnEmpty=0.5

	IronSightsSpreadMod=0.01

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_ManualTarget'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(ALTFIRE_FIREMODE)=none
	InstantHitDamage(ALTFIRE_FIREMODE)=560 //750
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_MaserGun'
	FireInterval(ALTFIRE_FIREMODE)=0.1 //0.4
	PenetrationPower(ALTFIRE_FIREMODE)=10.0
	Spread(ALTFIRE_FIREMODE)=0.005


	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_MaserGun'
	InstantHitDamage(BASH_FIREMODE)=30

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_Railgun.Play_WEP_SA_Railgun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_Railgun.Play_WEP_SA_Railgun_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_Railgun.Play_WEP_SA_Railgun_DryFire'
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_Railgun.Play_WEP_SA_Railgun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_Railgun.Play_WEP_SA_Railgun_Fire_1P')
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_Railgun.Play_WEP_SA_Railgun_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Custom animations
	FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)
    BonesToLockOnEmpty=(RW_TopLeft_RadShield1,RW_TopRight_RadShield1,RW_TopLeft_RadShield2,RW_TopRight_RadShield2,RW_TopLeft_RadShield3,RW_TopRight_RadShield3,RW_TopLeft_RadShield4,RW_TopRight_RadShield4,RW_TopLeft_RadShield5,RW_TopRight_RadShield5,RW_TopLeft_RadShield6,RW_TopRight_RadShield6,RW_BottomLeft_RadShield2,RW_BottomRight_RadShield2,RW_BottomLeft_RadShield3,RW_BottomRight_RadShield3,RW_BottomLeft_RadShield4,RW_BottomRight_RadShield4,RW_BottomLeft_RadShield5,RW_BottomRight_RadShield5,RW_BottomLeft_RadShield6,RW_BottomRight_RadShield6,RW_BottomLeft_RadShield1,RW_BottomRight_RadShield1,RW_Bullets1,RW_AcceleratorMagnetrons,RW_Bolt)

    MaxScopeScreenDot=0.2

	//Ambient Sounds
    AmbientSoundPlayEvent=AkEvent'WW_WEP_SA_Railgun.Play_Railgun_Loop'
    AmbientSoundStopEvent=AkEvent'WW_WEP_SA_Railgun.Stop_Railgun_Loop'
	AmbientSoundSocketName=AmbientSound

	// Lock on
	TargetingCompClass=class'KFTargetingWeaponComponent_RailGun'
    LockedHitZoneIcon=Texture2D'Wep_Scope_TEX.Wep_1stP_Yellow_Red_Target'
    DefaultHitZoneIcon=Texture2D'Wep_Scope_TEX.Wep_1stP_Blue_Target'
    RedIconColor=(R=1.f, G=0.f, B=0.f)
    YellowIconColor=(R=1.f, G=1.f, B=0.f)
    BlueIconColor=(R=0.25, G=0.6f, B=1.f)

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.25f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Damage1, Scale=1.25f), (Stat=EWUS_Weight, Add=1)))
}