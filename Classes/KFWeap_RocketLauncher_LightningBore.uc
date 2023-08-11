class KFWeap_RocketLauncher_LightningBore extends KFWeap_GrenadeLauncher_Base;

/** List of spawned harpoons (will be detonated oldest to youngest) */
var array<KFProj_Rocket_LightningBore> DeployedHarpoons;

/** Same as DeployedHarpoons.Length, but replicated because harpoons are only tracked on server */
var int NumDeployedHarpoons;

/** Reduction for the amount of damage dealt to the weapon owner (including damage by the explosion) */
var float SelfDamageReductionValue;

var(Animations) const editconst name DetonateAnim;
var(Animations) const editconst name DetonateAnimLast;
var(Animations) const editconst name DetonateAnimIron;
var(Animations) const editconst name DetonateAnimIronLast;

replication
{
	if( bNetDirty )
		NumDeployedHarpoons;
}

/**
 * Toggle between DEFAULT and ALTFIRE
 */
simulated function AltFireMode()
{
	// skip super

	if (!Instigator.IsLocallyControlled())
	{
		return;
	}

	StartFire(ALTFIRE_FIREMODE);
}

/** Overridded to add spawned charge to list of spawned charges */
simulated function Projectile ProjectileFire()
{
	local Projectile P;
	local KFProj_Rocket_LightningBore Harpoon;

	P = super.ProjectileFire();

	Harpoon = KFProj_Rocket_LightningBore(P);
	if (Harpoon != none)
	{
		DeployedHarpoons.AddItem(Harpoon);
		NumDeployedHarpoons = DeployedHarpoons.Length;
		bForceNetUpdate = true;
	}

	return P;
}

/** Returns animation to play based on reload type and status */
simulated function name GetReloadAnimName(bool bTacticalReload)
{
	// magazine relaod
	if (AmmoCount[0] > 0)
	{
		return (bTacticalReload) ? ReloadNonEmptyMagEliteAnim : ReloadNonEmptyMagAnim;
	}
	else
	{
		return (bTacticalReload) ? ReloadEmptyMagEliteAnim : ReloadEmptyMagAnim;
	}
}

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super.AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != none && DamageCauser != none && DamageCauser.Instigator == Instigator)
	{
		InDamage *= SelfDamageReductionValue;
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

// GrenadeLaunchers determine ShouldPlayFireLast based on the spare ammo
// overriding to use the base KFWeapon version since that uses the current ammo in the mag
simulated function bool ShouldPlayFireLast(byte FireModeNum)
{
	return Super(KFWeapon).ShouldPlayFireLast(FireModeNum);
}

simulated function PrepareAndDetonate()
{
	local name SelectedAnim;
	local float AnimDuration;
	local bool bInSprintState;

	// choose the detonate animation based on whether it is in ironsights and whether it is the last harpoon
	if (bUsingSights)
	{
		SelectedAnim = ShouldPlayFireLast(DEFAULT_FIREMODE) ? DetonateAnimIronLast : DetonateAnimIron;
	}
	else
	{
		SelectedAnim = ShouldPlayFireLast(DEFAULT_FIREMODE) ? DetonateAnimLast : DetonateAnim;
	}

	AnimDuration = MySkelMesh.GetAnimLength(SelectedAnim);
	bInSprintState = IsInState('WeaponSprinting');

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (bInSprintState)
		{
			AnimDuration *= 0.25f;
			PlayAnimation(SelectedAnim, AnimDuration);
		}
		else
		{	
			PlayAnimation(SelectedAnim);
		}
	}

	if (Role == ROLE_Authority)
	{
		Detonate();
	}

	//AnimDuration value here representes the ALTFIRE FireInterval
	AnimDuration = 0.75f; //1.f;
	if (bInSprintState)
	{
		SetTimer(AnimDuration * 0.8f, false, nameof(PlaySprintStart));
	}
	else
	{
		SetTimer(AnimDuration * 0.5f, false, nameof(GotoActiveState));
	}
}

/** Detonates all the harpoons */
simulated function Detonate()
{
	local int i;

	// auto switch weapon when out of ammo and after detonating the last deployed charge
	if (Role == ROLE_Authority)
	{
		for (i = DeployedHarpoons.Length - 1; i >= 0; i--)
		{
			DeployedHarpoons[i].Detonate();
		}

		if (!HasAnyAmmo() && NumDeployedHarpoons == 0)
		{
			if (CanSwitchWeapons())
			{
	            Instigator.Controller.ClientSwitchToBestWeapon(false);
			}
		}
	}
}

/** Removes a charge from the list using either an index or an actor and updates NumDeployedHarpoons */
function RemoveDeployedHarpoon(optional int HarpoonIndex = INDEX_NONE, optional Actor HarpoonActor)
{
	if (HarpoonIndex == INDEX_NONE)
	{
		if (HarpoonActor != none)
		{
			HarpoonIndex = DeployedHarpoons.Find(HarpoonActor);
		}
	}

	if (HarpoonIndex != INDEX_NONE)
	{
		DeployedHarpoons.Remove(HarpoonIndex, 1);
		NumDeployedHarpoons = DeployedHarpoons.Length;
		bForceNetUpdate = true;
	}
}

/** Allow reloads for primary weapon to be interupted by firing secondary weapon. */
simulated function bool CanOverrideMagReload(byte FireModeNum)
{
	if(FireModeNum == ALTFIRE_FIREMODE)
	{
		return true;
	}

	return Super.CanOverrideMagReload(FireModeNum);
}

defaultproperties
{
	// Content
	PackageKey="Lightning"
	FirstPersonMeshName="wep_1p_thermite_mesh.WEP_1stP_Thermite_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_thermite_anim.WEP_1stP_Thermite_Anim"
	PickupMeshName="WEP_3P_Thermite_MESH.WEP_Thermite_Pickup" //@TODO: Replace me
	AttachmentArchetypeName="wep_thermite_arch.Wep_Thermite_3P"
	MuzzleFlashTemplateName="wep_thermite_arch.Wep_Thermite_MuzzleFlash" //@TODO: Replace me

	// Inventory / Grouping
	InventorySize=7
	GroupPriority=100
	WeaponSelectTexture=Texture2D'WEP_UI_Thermite_TEX.UI_WeaponSelect_Thermite'
   	AssociatedPerkClasses(0)=class'KFPerk_Survivalist'
   	//AssociatedPerkClasses(1)=class'KFPerk_Demolitionist'
   	
    // FOV
    MeshFOV=75
	MeshIronSightFOV=40
    PlayerIronSightFOV=65

	// Depth of field
	DOF_FG_FocalRadius=50
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=4//6
	SpareAmmoCapacity[0]=38//36 //42
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Zooming/Position
	PlayerViewOffset=(X=11.0,Y=8,Z=-2)
	IronSightPosition=(X=10,Y=-0.15,Z=0.7)

	// AI warning system
	bWarnAIWhenAiming=true
	AimWarningDelay=(X=0.4f, Y=0.8f)
	AimWarningCooldown=0.0f

	// Recoil
	maxRecoilPitch=500
	minRecoilPitch=400
	maxRecoilYaw=150
	minRecoilYaw=-150
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1250
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.6
	IronSightMeshFOVCompensationScale=1.5

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Electricity'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Rocket_LightningBore'
	InstantHitDamage(DEFAULT_FIREMODE)=150
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_LightningBoreImpact'
	FireInterval(DEFAULT_FIREMODE)=0.8 //100 RPM
	Spread(DEFAULT_FIREMODE)=0
	PenetrationPower(DEFAULT_FIREMODE)=0
	FireOffset=(X=25,Y=3.0,Z=-2.5)

	// ALTFIRE_FIREMODE (remote detonate)
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponDetonating
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Custom
	AmmoCost(ALTFIRE_FIREMODE)=0

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_LightningBore'
	InstantHitDamage(BASH_FIREMODE)=26

	// Custom animations
	FireSightedAnims=(Shoot_Iron)
	BonesToLockOnEmpty=(RW_Exhaust, RW_BoltAssembly1, RW_BoltAssembly2, RW_BoltAssembly3)
	bHasFireLastAnims=true

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Thermite.Play_WEP_Thermite_Thermite_Shoot_3P', FirstPersonCue=AkEvent'WW_WEP_Thermite.Play_WEP_Thermite_Thermite_Shoot_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Thermite.Play_WEP_Thermite_Dry_Fire'
	EjectedShellForegroundDuration=1.5f

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.125f), (Stat=EWUS_Weight, Add=1)))

	SelfDamageReductionValue=0.05f //0.25f

	DetonateAnim=Alt_Fire
	DetonateAnimLast=Alt_Fire_Last
	DetonateAnimIron=Alt_Fire_Iron
	DetonateAnimIronLast=Alt_Fire_Iron_Last
}
