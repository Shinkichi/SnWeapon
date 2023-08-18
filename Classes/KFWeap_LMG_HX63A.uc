class KFWeap_LMG_HX63A extends KFWeap_RifleBase;

/** Alternate reload anims (when below the bullet belt threshold */
const ReloadLowAmmoAnim = 'Reload_Empty_Half';
const ReloadLowAmmoEliteAnim = 'Reload_Empty_Half_Elite';

/** Array of bone names corresponding to bullets in the ammo belt */
var protected const string AmmoBeltBulletBonePrefix;

/** Number of bullets in the ammo belt */
var protected const int NumAmmoBeltBullets;

/** How much ammo we had the last time we updated the ammo belt */
var transient protected int LastAmmoCount;

/** TRUE when set for the first time */
var transient protected bool bAmmoBeltInitialized;

/** Just in case we spawned in with an ammo count that's lower than the threshold */
simulated event ReplicatedEvent( name VarName )
{
	super.ReplicatedEvent( VarName );

	if( !bAmmoBeltInitialized )
	{
		UpdateAmmoBeltBullets();
	}
}

/** Just in case we spawned in with an ammo count that's lower than the threshold */
simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if( !bAmmoBeltInitialized && Role == ROLE_Authority )
	{
		UpdateAmmoBeltBullets();
	}
}

/** Update ammo belt */
simulated function ConsumeAmmo( byte FireModeNum )
{
	super.ConsumeAmmo( FireModeNum );

	UpdateAmmoBeltBullets();
}

/** Update ammo belt */
simulated function PerformReload( optional byte FireModeNum )
{
	super.PerformReload( FireModeNum );

	UpdateAmmoBeltBullets();
}

/** Notify triggered by reload animations, when ammo belt is grabbed offscreen */
simulated function ANIMNOTIFY_RestoreAmmoBelt()
{
	local int AmmoType, PendingAmmoCount;

	AmmoType = GetAmmoType(0);

	// This value will sync with the amount actually reloaded in PerformReload()
	PendingAmmoCount = Min( AmmoCount[AmmoType] + SpareAmmoCount[AmmoType], MagazineCapacity[AmmoType] );
	if( PendingAmmoCount < NumAmmoBeltBullets )
	{
		UpdateAmmoBeltBullets( PendingAmmoCount );
	}
	else
	{
		UpdateAmmoBeltBullets( , true );
	}
}

/** Hides/shows bones on the weapon to simulate reaching the end of the ammo belt */
simulated function UpdateAmmoBeltBullets( optional int ForcedBulletCount=INDEX_NONE, optional bool bShowAll=false )
{
	local Name BulletBoneName;
	local int NumAmmo, i;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Don't do any bone alterations until the bone array has been filled out
	if( MySkelMesh.LocalAtoms.Length == 0 )
	{
		// Check on the next frame to see if we can init our ammo belt
		if( !IsTimerActive(nameOf(Timer_AttemptAmmoBeltUpdate)) )
		{
			SetTimer( 0.01f, false, nameOf(Timer_AttemptAmmoBeltUpdate) );
		}
		return;
	}

	// So we don't do this in PostInitAnimTree() or again in Timer_AttemptAmmoBeltUpdate() if we don't have to
	bAmmoBeltInitialized = true;

	// Don't do anything if ammo hasn't changed
	NumAmmo = ForcedBulletCount != INDEX_NONE ? ForcedBulletCount : AmmoCount[GetAmmoType(0)];
	if( !bShowAll && (LastAmmoCount == NumAmmo || (LastAmmoCount >= NumAmmoBeltBullets && NumAmmo >= NumAmmoBeltBullets)) )
	{
		return;
	}

	// Hide or unhide depending on place in array
	for( i = 0; i < NumAmmoBeltBullets; ++i )
	{
		BulletBoneName = Name( AmmoBeltBulletBonePrefix $ (i+1) );

		// Unhide all bullets if our ammo count is higher than the number of bullets
		if( bShowAll || NumAmmo >= NumAmmoBeltBullets )
		{
			MySkelMesh.UnHideBoneByName( BulletBoneName );
			continue;
		}

		if( i > NumAmmo-1 )
		{
			MySkelMesh.HideBoneByName( BulletBoneName, PBO_None );
		}
		else
		{
			MySkelMesh.UnHideBoneByName( BulletBoneName );
		}
	}

	LastAmmoCount = NumAmmo;
}

simulated function Timer_AttemptAmmoBeltUpdate()
{
	if( !bAmmoBeltInitialized )
	{
		UpdateAmmoBeltBullets();
	}
}

/** Returns animation to play based on reload type and status */
simulated function name GetReloadAnimName( bool bTacticalReload )
{
	if( AmmoCount[0] > 0 && AmmoCount[0] < NumAmmoBeltBullets )
	{
		// If we are below the threshold, play our low ammo reload
		return bTacticalReload ? ReloadLowAmmoEliteAnim : ReloadLowAmmoAnim;
	}
	else
	{
		return super.GetReloadAnimName( bTacticalReload );
	}
}

/**
 * State WeaponEquipping
 * The Weapon is in this state while transitioning from Inactive to Active state.
 * Typically, the weapon will remain in this state while its selection animation is being played.
 * While in this state, the weapon cannot be fired.
 */
simulated state WeaponEquipping
{
	simulated event BeginState( Name PreviousStateName )
	{
		super.BeginState( PreviousStateName );

		// Just in case a reload was interrupted after ANIMNOTIFY_RestoreAmmoBelt() was called,
		// set the ammo belt to the current amount of bullets in the magazine on equip
		UpdateAmmoBeltBullets();
	}
}

defaultproperties
{
	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

    // FOV
    MeshFOV=75
	MeshIronSightFOV=35
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=85
	DOF_FG_MaxNearBlurSize=2.5

	// Content
	PackageKey="HX63A"
	FirstPersonMeshName="WEP_1P_Stoner63A_MESH.Wep_1stP_Stoner63A_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Stoner63A_ANIM.Wep_1stP_Stoner63A_Anim"
	PickupMeshName="WEP_3P_Stoner63A_MESH.Wep_Stoner63A_Pickup"
	AttachmentArchetypeName="SnWeapon_Packages.Wep_HX63A_3P"
	MuzzleFlashTemplateName="WEP_Stoner63A_ARCH.Wep_Stoner63A_MuzzleFlash"

   	// Zooming/Position
	PlayerViewOffset=(X=4.0,Y=8,Z=-4)
	IronSightPosition=(X=8.5,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=75
	SpareAmmoCapacity[0]=500
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=120
	minRecoilPitch=70
	maxRecoilYaw=130
	minRecoilYaw=-130
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.25
	IronSightMeshFOVCompensationScale=2.3
    HippedRecoilModifier=1.5

    // Inventory / Grouping
	InventorySize=9
	GroupPriority=100
	WeaponSelectTexture=Texture2D'wep_ui_stoner63a_tex.UI_WeaponSelect_Stoner'
	
	AssociatedPerkClasses.Empty()
   	AssociatedPerkClasses(0)=class'KFPerk_Demolitionist'
   	//AssociatedPerkClasses(1)=class'KFPerk_Commando'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Explosive_HX63A'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HX63A'
	FireInterval(DEFAULT_FIREMODE)=+0.066 // 900 RPM
	Spread(DEFAULT_FIREMODE)=0.0085
	InstantHitDamage(DEFAULT_FIREMODE)=15.0//10.0
	//FireOffset=(X=30,Y=4.5,Z=-5)
	FireOffset=(X=50,Y=10.0,Z=-15)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HX63A'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Stoner.Play_WEP_Stoner_Fire_3P_Loop', FirstPersonCue=AkEvent'WW_WEP_Stoner.Play_WEP_Stoner_Fire_1P_Loop')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Stoner.Play_WEP_Stoner_Fire_3P_Single', FirstPersonCue=AkEvent'WW_WEP_Stoner.Play_WEP_Stoner_Fire_1P_Single')
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Stoner.Play_WEP_Stoner_Fire_3P_EndLoop', FirstPersonCue=AkEvent'WW_WEP_Stoner.Play_WEP_Stoner_Fire_1P_EndLoop')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Handling_DryFire'
	EjectedShellForegroundDuration=0.8f

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	SingleFireSoundIndex=ALTFIRE_FIREMODE

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Ammo belt
	AmmoBeltBulletBonePrefix="RW_Bullets"
	NumAmmoBeltBullets=14
	LastAmmoCount=-1

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.27f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.27f), (Stat=EWUS_Weight, Add=1)))
}
