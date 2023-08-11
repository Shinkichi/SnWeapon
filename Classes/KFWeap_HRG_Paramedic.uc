class KFWeap_HRG_Paramedic extends KFWeap_ThrownBase;

`define AUTOTURRET_MIC_LED_INDEX 2

const DETONATE_FIREMODE = 5; // NEW - IronSights Key

var(Animations) const editconst name DetonateAnim;
var(Animations) const editconst name DetonateLastAnim;

/** Sound to play upon successful detonation */
var() AkEvent DetonateAkEvent;

/** Strenght applied to forward dir to get the throwing velocity */
var const float ThrowStrength;
/** Max num of turrets that can be deployed */
var const byte MaxTurretsDeployed;
/** Offset to spawn the dron (screen coordinates) */
var const vector TurretSpawnOffset;

var transient byte NumDeployedTurrets;
var transient KFPlayerController KFPC;

/** If the turret is in a state available for throw another to fix some animation issues. */
var transient bool bTurretReadyToUse;

var repnotify float CurrentAmmoPercentage;

const TransitionParamName = 'transition_full_to_empty';
const EmptyParamName = 'Blinking_0_off___1_on';

var transient bool bDetonateLocked;

replication
{
    if( bNetDirty )
		NumDeployedTurrets, CurrentAmmoPercentage, bTurretReadyToUse;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(CurrentAmmoPercentage))
	{
		UpdateMaterialColor(CurrentAmmoPercentage);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated event PreBeginPlay()
{
	local class<KFWeap_HRG_ParamedicWeapon>  WeaponClass;

	super.PreBeginPlay();

    WeaponClass = class<KFWeap_HRG_ParamedicWeapon> (DynamicLoadObject(class'KFPawn_HRG_Paramedic'.default.WeaponDefinition.default.WeaponClassPath, class'Class'));
	WeaponClass.static.TriggerAsyncContentLoad(WeaponClass);
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		KFPC = KFPlayerController(Instigator.Controller);
		NumDeployedTurrets = KFPC.DeployedTurrets.Length;
	}
}

/** Route ironsight player input to detonate */
simulated function SetIronSights(bool bNewIronSights)
{
	if ( !Instigator.IsLocallyControlled()  )
	{
		return;
	}

	if ( bNewIronSights )
	{
		StartFire(DETONATE_FIREMODE);
	}
	else
	{
		StopFire(DETONATE_FIREMODE);
	}
}

/** Overridded to add spawned turret to list of spawned turrets */
simulated function Projectile ProjectileFire()
{
	local vector SpawnLocation, SpawnDirection;
    local KFPawn_HRG_Paramedic SpawnedActor;

	if (Role != ROLE_Authority)
	{
		return none;
	}

	if (CurrentFireMode == DEFAULT_FIREMODE)
	{
		GetTurretSpawnLocationAndDir(SpawnLocation, SpawnDirection);
		SpawnedActor = Spawn(class'KFPawn_HRG_Paramedic', self,, SpawnLocation + (TurretSpawnOffset >> Rotation), Rotation,,true);
		
		if( SpawnedActor != none )
		{
			SpawnedActor.OwnerWeapon = self;
			SpawnedActor.SetPhysics(PHYS_Falling);
			SpawnedActor.Velocity = SpawnDirection * ThrowStrength;
			SpawnedActor.UpdateInstigator(Instigator);
			SpawnedActor.UpdateWeaponUpgrade(CurrentWeaponUpgradeIndex);
			SpawnedActor.SetTurretState(ETS_Throw);

			if (KFPC != none)
			{
				KFPC.DeployedTurrets.AddItem( SpawnedActor );
				NumDeployedTurrets = KFPC.DeployedTurrets.Length;
			}

			bTurretReadyToUse  = false;
			bForceNetUpdate    = true;
		}

		return none;
	}

	return super.ProjectileFire();
}

simulated function GetTurretSpawnLocationAndDir(out vector SpawnLocation, out vector SpawnDirection)
{
	local vector		StartTrace, EndTrace, RealStartLoc, AimDir;
	local ImpactInfo	TestImpact;
	local vector DirA, DirB;
	local Quat Q;

	// This is where we would start an instant trace. (what CalcWeaponFire uses)
	StartTrace = GetSafeStartTraceLocation();
	AimDir = Vector(GetAdjustedAim( StartTrace ));

	// this is the location where the projectile is spawned.
	RealStartLoc = GetPhysicalFireStartLoc(AimDir);

	if( StartTrace != RealStartLoc )
	{
		// if projectile is spawned at different location of crosshair,
		// then simulate an instant trace where crosshair is aiming at, Get hit info.
		EndTrace = StartTrace + AimDir * GetTraceRange();
		TestImpact = CalcWeaponFire( StartTrace, EndTrace );
		// Store the original aim direction without correction
		DirB = AimDir;

		// Then we realign projectile aim direction to match where the crosshair did hit.
		AimDir = Normal(TestImpact.HitLocation - RealStartLoc);

		// Store the desired corrected aim direction
		DirA = AimDir;

		// Clamp the maximum aim adjustment for the AimDir so you don't get wierd
		// cases where the projectiles velocity is going WAY off of where you
		// are aiming. This can happen if you are really close to what you are
		// shooting - Ramm
		if ( (DirA dot DirB) < MaxAimAdjust_Cos )
		{
			Q = QuatFromAxisAndAngle(Normal(DirB cross DirA), MaxAimAdjust_Angle);
			AimDir = QuatRotateVector(Q,DirB);
		}
	}

	SpawnDirection = AimDir;
	SpawnLocation = RealStartLoc;
}

/** Detonates the oldest turret */
simulated function Detonate(optional bool bKeepTurret = false)
{
	local int i;
	local array<Actor> TurretsCopy;

	// auto switch weapon when out of ammo and after detonating the last deployed turret
	if( Role == ROLE_Authority )
	{
		TurretsCopy = KFPC.DeployedTurrets;
		for (i = 0; i < TurretsCopy.Length; i++)
		{
			if (bKeepTurret && i == 0)
			{
				continue;
			}

			if (KFPawn_HRG_Paramedic(TurretsCopy[i]) != none)
			{
				KFPawn_HRG_Paramedic(TurretsCopy[i]).SetTurretState(ETS_Detonate);
			}
			else if (KFPawn_HRG_Warthog(TurretsCopy[i]) != none)
			{
				KFPawn_HRG_Warthog(TurretsCopy[i]).SetTurretState(ETS_Detonate);
			}
			else if (KFPawn_Autoturret(TurretsCopy[i]) != none)
			{
				KFPawn_Autoturret(TurretsCopy[i]).SetTurretState(ETS_Detonate);
			}
		}

		KFPC.DeployedTurrets.Remove(bKeepTurret ? 1 : 0, KFPC.DeployedTurrets.Length);

		SetReadyToUse(true);

		if( !HasAnyAmmo() && NumDeployedTurrets == 0 )
		{
			if( CanSwitchWeapons() )
			{
	            Instigator.Controller.ClientSwitchToBestWeapon(false);
			}
		}
	}
}

/** Removes a turret from the list using either an index or an actor and updates NumDeployedTurrets */
function RemoveDeployedTurret( optional int Index = INDEX_NONE, optional Actor TurretActor )
{
	if( Index == INDEX_NONE )
	{
		if( TurretActor != none )
		{
			Index = KFPC.DeployedTurrets.Find( TurretActor );
		}
	}

	if( Index != INDEX_NONE )
	{
		KFPC.DeployedTurrets.Remove( Index, 1 );
		NumDeployedTurrets = KFPC.DeployedTurrets.Length;
		bForceNetUpdate = true;
	}
}

function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	local int i;
	local Actor WeaponPawn;

	super.SetOriginalValuesFromPickup( PickedUpWeapon );

	if (PickedUpWeapon.KFPlayer != none && PickedUpWeapon.KFPlayer != KFPC)
	{
		for (i = 0; i < PickedUpWeapon.KFPlayer.DeployedTurrets.Length; i++)
		{
			KFPC.DeployedTurrets.AddItem(PickedUpWeapon.KFPlayer.DeployedTurrets[i]);
		}

		PickedUpWeapon.KFPlayer.DeployedTurrets.Remove(0, PickedUpWeapon.KFPlayer.DeployedTurrets.Length);
	}

	if (KFPC.DeployedTurrets.Length > 1)
	{
		Detonate(true);
	}

	PickedUpWeapon.KFPlayer = none;

	NumDeployedTurrets   = KFPC.DeployedTurrets.Length;
	bForceNetUpdate      = true;

	for( i = 0; i < NumDeployedTurrets; ++i )
	{
		WeaponPawn = KFPC.DeployedTurrets[i];
		if (WeaponPawn != none)
		{
			// charge alerts (beep, light) need current instigator
			WeaponPawn.Instigator = Instigator;
			WeaponPawn.SetOwner(self);

			if (Instigator.Controller != none)
			{
				if (KFPawn_HRG_Paramedic(KFPC.DeployedTurrets[i]) != none)
				{
					KFPawn_HRG_Paramedic(KFPC.DeployedTurrets[i]).InstigatorController = Instigator.Controller;
				}
				else if (KFPawn_HRG_Warthog(KFPC.DeployedTurrets[i]) != none)
				{
					KFPawn_HRG_Warthog(KFPC.DeployedTurrets[i]).InstigatorController = Instigator.Controller;
				}
				else if (KFPawn_Autoturret(KFPC.DeployedTurrets[i]) != none)
				{
					KFPawn_Autoturret(KFPC.DeployedTurrets[i]).InstigatorController = Instigator.Controller;
				}
			}
		}
	}
}


/**
 * Drop this item out in to the world
 */
function DropFrom(vector StartLocation, vector StartVelocity)
{
	local DroppedPickup P;

	// Offset spawn closer to eye location
	StartLocation.Z += Instigator.BaseEyeHeight / 2;

	// for some reason, Inventory::DropFrom removes weapon from inventory whether it was able to spawn the pickup or not.
	// we only want the weapon removed from inventory if pickup was successfully spawned, so instead of calling the supers,
	// do all the super functionality here.

	if( !CanThrow() )
	{
		return;
	}

	if( DroppedPickupClass == None || DroppedPickupMesh == None )
	{
		Destroy();
		return;
	}

	// the last bool param is to prevent collision from preventing spawns
	P = Spawn(DroppedPickupClass,,, StartLocation,,,true);
	if( P == None )
	{
		// if we can't spawn the pickup (likely for collision reasons),
		// just return without removing from inventory or destroying, which removes from inventory
		PlayerController(Instigator.Controller).ReceiveLocalizedMessage( class'KFLocalMessage_Game', GMT_FailedDropInventory );
		return;
	}

	if( Instigator != None && Instigator.InvManager != None )
	{
		Instigator.InvManager.RemoveFromInventory(Self);

		if( Instigator.IsAliveAndWell() && !Instigator.InvManager.bPendingDelete )
		{
			`DialogManager.PlayDropWeaponDialog( KFPawn(Instigator) );
		}
	}

	SetupDroppedPickup( P, StartVelocity );

	KFDroppedPickup(P).PreviousOwner = KFPlayerController(Instigator.Controller);

	Instigator = None;
	GotoState('');

	AIController = None;
}

 /**
 * Returns true if this weapon uses a secondary ammo pool
 */
static simulated event bool UsesAmmo()
{
    return true;
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	if( FireModeNum == DETONATE_FIREMODE )
	{
		return NumDeployedTurrets > 0;
	}

	return super.HasAmmo( FireModeNum, Amount );
}

simulated function BeginFire( byte FireModeNum )
{
	local bool bCanDetonate;

	// Clear any pending detonate if we pressed the main fire
	// That prevents strange holding right click behaviour and sound issues
	if (FireModeNum == DEFAULT_FIREMODE)
	{
		ClearPendingFire(DETONATE_FIREMODE);
	}

	if (FireModeNum == DETONATE_FIREMODE )
	{
		if (bDetonateLocked)
		{
			return;
		}

		if (NumDeployedTurrets > 0 && bTurretReadyToUse)
		{
			bCanDetonate = NumDeployedTurrets > 0;
			
			if (bCanDetonate)
			{
				PrepareAndDetonate();
			}
		}
	}
	else
	{
		if (KFPC != none)
		{
			NumDeployedTurrets = KFPC.DeployedTurrets.Length;
		}

		if (FireModeNum == DEFAULT_FIREMODE
			&& NumDeployedTurrets >= MaxTurretsDeployed
			&& HasAnyAmmo())
		{
			if (!bTurretReadyToUse)
			{
				return;
			}

			PrepareAndDetonate();
		}
		
		super.BeginFire( FireModeNum );
	}
}

simulated function PrepareAndDetonate()
{
	local name DetonateAnimName;
	local float AnimDuration;
	local bool bInSprintState;
	DetonateAnimName = ShouldPlayLastAnims() ? DetonateLastAnim : DetonateAnim;
	AnimDuration = MySkelMesh.GetAnimLength( DetonateAnimName );
	bInSprintState = IsInState( 'WeaponSprinting' );

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if( NumDeployedTurrets > 0 )
		{
			PlaySoundBase( DetonateAkEvent, true );
		}

		if( bInSprintState )
		{
			AnimDuration *= 0.25f;
			PlayAnimation( DetonateAnimName, AnimDuration );
		}
		else
		{
			PlayAnimation( DetonateAnimName );
		}
	}

	if( Role == ROLE_Authority )
	{
		Detonate();
	}

	CurrentFireMode = DETONATE_FIREMODE;
	IncrementFlashCount();

	if( bInSprintState )
	{
		SetTimer( AnimDuration * 0.8f, false, nameof(PlaySprintStart) );
	}
	else
	{
		SetTimer( AnimDuration * 0.5f, false, nameof(GotoActiveState) );
	}
}

// do nothing, as we have no alt fire mode
simulated function AltFireMode();

/** Allow weapons with abnormal state transitions to always use zed time resist*/
simulated function bool HasAlwaysOnZedTimeResist()
{
    return GetStateName() != FiringStatesArray[BASH_FIREMODE];
}

/*********************************************************************************************
 * State Active
 * A Weapon this is being held by a pawn should be in the active state.  In this state,
 * a weapon should loop any number of idle animations, as well as check the PendingFire flags
 * to see if a shot has been fired.
 *********************************************************************************************/

simulated state Active
{
	/** Overridden to prevent playing fidget if play has no more ammo */
	simulated function bool CanPlayIdleFidget(optional bool bOnReload)
	{
		if( !HasAmmo(0) )
		{
			return false;
		}

		return super.CanPlayIdleFidget( bOnReload );
	}
}

/*********************************************************************************************
 * State WeaponDetonating
 * The weapon is in this state while detonating a charge
*********************************************************************************************/

simulated function GotoActiveState();

simulated state WeaponDetonating
{
	ignores AllowSprinting;

	simulated event BeginState( name PreviousStateName )
	{
		PrepareAndDetonate();
	}

	simulated function GotoActiveState()
	{
		GotoState('Active');
	}
}

/*********************************************************************************************
 * State WeaponThrowing
 * Handles throwing weapon (similar to state GrenadeFiring)
 *********************************************************************************************/

simulated state WeaponThrowing
{
	/** Never refires.  Must re-enter this state instead. */
	simulated function bool ShouldRefire()
	{
		return false;
	}

    simulated function EndState(Name NextStateName)
    {
        local KFPerk InstigatorPerk;

        Super.EndState(NextStateName);

        //Targeted fix for Demolitionist w/ the C4.  It should remain in zed time  while waiting on
        //      the fake reload to be triggered.  This will return 0 for other perks.
        InstigatorPerk = GetPerk();
        if( InstigatorPerk != none )
        {
            SetZedTimeResist( InstigatorPerk.GetZedTimeModifier(self) );
        }
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
	simulated event BeginState( name PreviousStateName )
	{
		super.BeginState( PreviousStateName );

		// perform a "reload" if we refilled our ammo from empty while it was unequipped
		if( !HasAmmo(THROW_FIREMODE) && HasSpareAmmo() )
		{
			PerformArtificialReload();
		}
		StopFire(DETONATE_FIREMODE);
	}
}

/*********************************************************************************************
 * State WeaponPuttingDown
 * Putting down weapon in favor of a new one.
 * Weapon is transitioning to the Inactive state.
 *
 * Detonating while putting down causes C4 not to be put down, which causes problems, so let's
 * just ignore SetIronSights, which causes detonation
*********************************************************************************************/

simulated state WeaponPuttingDown
{
	ignores SetIronSights;

	simulated event BeginState( name PreviousStateName )
	{
		super.BeginState( PreviousStateName );
		StopFire(DETONATE_FIREMODE);
	}
}

/*********************************************************************************************
 * @name	Trader
 *********************************************************************************************/

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Explosive;
}

function CheckTurretAmmo()
{
	local float Percentage;
	local KFWeapon Weapon;
	local KFPawn KFP;

	if (Role == Role_Authority)
	{
		if (KFPC == none)
		{
			return;
		}

		if (KFPC.DeployedTurrets.Length > 0)
		{
			if (KFPawn_HRG_Paramedic(KFPC.DeployedTurrets[0]) != none)
			{
				Weapon = KFWeapon(KFPawn_HRG_Paramedic(KFPC.DeployedTurrets[0]).Weapon);
			}
			else if (KFPawn_HRG_Warthog(KFPC.DeployedTurrets[0]) != none)
			{
				Weapon = KFWeapon(KFPawn_HRG_Warthog(KFPC.DeployedTurrets[0]).Weapon);
			}
			else if (KFPawn_Autoturret(KFPC.DeployedTurrets[0]) != none)
			{
				Weapon = KFWeapon(KFPawn_Autoturret(KFPC.DeployedTurrets[0]).Weapon);
			}

			if (Weapon != none)
			{
				Percentage = float(Weapon.AmmoCount[0]) / Weapon.MagazineCapacity[0];
				if (Percentage != CurrentAmmoPercentage)
				{
					CurrentAmmoPercentage = Percentage;
					bNetDirty = true;

					if (WorldInfo.NetMode == NM_Standalone)
					{
						UpdateMaterialColor(CurrentAmmoPercentage);
					}
					else
					{
						KFP = KFPawn(Instigator);
						if (KFP != none)
						{
							KFP.OnWeaponSpecialAction( 1 + (CurrentAmmoPercentage * 100) );
						}
					}
				}
			}
		}
	}
}

function SetReadyToUse(bool bReady)
{
	if (bTurretReadyToUse != bReady)
	{
		bTurretReadyToUse = bReady;
		bNetDirty = true;
	}
}

simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if (Role == Role_Authority)
	{
		CheckTurretAmmo();
	}
}

simulated function UpdateMaterialColor(float Percentage)
{
	if (NumDeployedTurrets == 0)
	{
		WeaponMICs[`AUTOTURRET_MIC_LED_INDEX].SetScalarParameterValue(EmptyParamName, 0);
	}
	else if (Percentage >= 0)
	{
		WeaponMICs[`AUTOTURRET_MIC_LED_INDEX].SetScalarParameterValue(TransitionParamName, 1.0f - Percentage);
		WeaponMICs[`AUTOTURRET_MIC_LED_INDEX].SetScalarParameterValue(EmptyParamName, Percentage == 0 ? 1 : 0);
	}
}

simulated function SetWeaponUpgradeLevel(int WeaponUpgradeLevel)
{
	local Actor Turret;
	local KFPawn_HRG_Paramedic TurretPawn;

	super.SetWeaponUpgradeLevel(WeaponUpgradeLevel);

	if (KFPC != none)
	{
		foreach KFPC.DeployedTurrets(Turret)
		{
			TurretPawn = KFPawn_HRG_Paramedic(Turret);
			if (TurretPawn != none)
			{
				TurretPawn.UpdateWeaponUpgrade(WeaponUpgradeLevel);
			}
		}
	}
}

/**
 *	GRENADE FIRING
 *  There's a bug that alt fire interrupts the grenade anim at any moment,
 *  This avoids being able to altfire until the throw animation ends or the
 *  interrupt notify is reached.
 */

simulated state GrenadeFiring 
{
	simulated function EndState(Name NextStateName)
	{
		ClearDetonateLock();
		Super.EndState(NextStateName);
	}
}


/** Play animation at the start of the GrenadeFiring state */
simulated function PlayGrenadeThrow()
{
    local name WeaponFireAnimName;
	local float InterruptTime;

    PlayFiringSound(CurrentFireMode);

    if( Instigator != none && Instigator.IsFirstPerson() )
    {
    	WeaponFireAnimName = GetGrenadeThrowAnim();

    	if ( WeaponFireAnimName != '' )
    	{
			InterruptTime = MySkelMesh.GetAnimInterruptTime(WeaponFireAnimName);
    		PlayAnimation(WeaponFireAnimName, MySkelMesh.GetAnimLength(WeaponFireAnimName),,FireTweenTime);
    	
			bDetonateLocked = true;
			SetTimer(InterruptTime, false, nameof(ClearDetonateLock));
		}
    }
}

simulated function ClearDetonateLock()
{
	bDetonateLocked = false;
	ClearTimer(nameof(ClearDetonateLock));
}

/***/


///////////////////////////////////////////////////////////////////////////////////////////
//
// Trader
//
///////////////////////////////////////////////////////////////////////////////////////////

/** Allows weapon to calculate its own stats for display in trader */
static simulated event SetTraderWeaponStats( out array<STraderItemWeaponStats> WeaponStats )
{
	super.SetTraderWeaponStats(WeaponStats);

	WeaponStats.Length = 4;

	WeaponStats[0].StatType = TWS_Damage;
	WeaponStats[0].StatValue = class'KFWeap_HRG_ParamedicWeapon'.static.CalculateTraderWeaponStatDamage();

	WeaponStats[1].StatType = TWS_Penetration;
	WeaponStats[1].StatValue = class'KFWeap_HRG_ParamedicWeapon'.default.PenetrationPower[DEFAULT_FIREMODE];

	WeaponStats[2].StatType = TWS_Range;
	// This is now set in native since EffectiveRange has been moved to KFWeaponDefinition
	// WeaponStats[2].StatValue = CalculateTraderWeaponStatRange();

	WeaponStats[3].StatType = TWS_RateOfFire;
	WeaponStats[3].StatValue = class'KFWeap_HRG_ParamedicWeapon'.static.CalculateTraderWeaponStatFireRate();
}

defaultproperties
{
	// start in detonate mode so that an attempt to detonate before any charges are thrown results in
	// the proper third-person anim
	CurrentFireMode=DETONATE_FIREMODE

	// Zooming/Position
	PlayerViewOffset=(X=6.0,Y=2,Z=-4)
	FireOffset=(X=0,Y=0)
	TurretSpawnOffset=(X=0, Y=15, Z=-50)
	
	// Content
	PackageKey="HRG_Paramedic"
	FirstPersonMeshName="Wep_1P_HRG_Warthog_MESH.Wep_1P_Warthog_Rig"
	FirstPersonAnimSetNames(0)="Wep_1P_HRG_Warthog_ANIM.Wep_1P_HRG_Warthog_ANIM"
	PickupMeshName="wep_3p_hrg_warthog_mesh.Wep_HRG_Warthog_Pickup" 
	AttachmentArchetypeName="WEP_HRG_Warthog_ARCH.Wep_HRG_Warthog_3P"

	// Anim
	FireAnim=C4_Throw
	FireLastAnim=C4_Throw_Last

	DetonateAnim=Detonate
	DetonateLastAnim=Detonate_Last

	// Ammo
	MagazineCapacity[0]=1
	SpareAmmoCapacity[0]=3
	InitialSpareMags[0]=1
	AmmoPickupScale[0]=1.0

	// THROW_FIREMODE
	FireInterval(THROW_FIREMODE)=0.25
	FireModeIconPaths(THROW_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_MedicDart'

	// DETONATE_FIREMODE
	FiringStatesArray(DETONATE_FIREMODE)=WeaponDetonating
	WeaponFireTypes(DETONATE_FIREMODE)=EWFT_Custom
	AmmoCost(DETONATE_FIREMODE)=0

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRG_Paramedic'
	InstantHitDamage(BASH_FIREMODE)=26

	// Inventory / Grouping
	InventoryGroup=IG_Equipment
	GroupPriority=11
	WeaponSelectTexture=Texture2D'WEP_UI_HRG_Warthog_TEX.UI_WeaponSelect_HRG_Warthog'
	InventorySize=3

   	DetonateAkEvent=AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Detonate_Trigger'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.05f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.1f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.15f,IncrementWeight=3)

   	AssociatedPerkClasses(0)=class'KFPerk_FieldMedic'

    MaxTurretsDeployed=1
    NumDeployedTurrets=0
	ThrowStrength=1350.0f
	bTurretReadyToUse=true

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
	NumBloodMapMaterials=3

	bDetonateLocked=false
	CurrentAmmoPercentage=-1.0f
}
