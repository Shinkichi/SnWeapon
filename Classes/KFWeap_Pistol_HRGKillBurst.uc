class KFWeap_Pistol_HRGKillBurst extends KFWeap_GrenadeLauncher_Base;

simulated state WeaponSingleFireAndReload
{
	simulated function BeginState(Name PrevStateName)
	{
		// Don't let us fire more shots than we have ammo for
		BurstAmount = GetBurstAmount();

		super.BeginState(PrevStateName);
	}

	simulated function int GetBurstAmount()
	{
		return Min( default.BurstAmount, AmmoCount[GetAmmoType(CurrentFireMode)] );
	}

	simulated function bool ShouldRefire()
	{
		// Stop firing when we hit the burst amount
		if( 0 >= BurstAmount )
		{
			return false;
		}
		// if doesn't have ammo to keep on firing, then stop
		else if( !HasAmmo( CurrentFireMode ) )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	/**
	 * FireAmmunition: Perform all logic associated with firing a shot
	 * - Fires ammunition (instant hit or spawn projectile)
	 * - Consumes ammunition
	 * - Plays any associated effects (fire sound and whatnot)
	 * Overridden to decrement the BurstAmount
	 *
	 * Network: LocalPlayer and Server
	 */
	simulated function FireAmmunition()
	{
		super.FireAmmunition();
		BurstAmount--;
	}

	simulated event EndState( Name NextStateName )
	{
		Super.EndState(NextStateName);
		EndFire(CurrentFireMode);
	}
}

/*********************************************************************************************
 Firing / Projectile
********************************************************************************************* */

/** Disable normal bullet spread */
simulated function rotator AddSpread(rotator BaseAim)
{
	return BaseAim; // do nothing
}

///////////////////////////////////////////////////////////////////////////////////////////
//
// Trader
//
///////////////////////////////////////////////////////////////////////////////////////////

/** Allows weapon to calculate its own damage for display in trader
  * Overridden to multiply damage by number of pellets.
  */
/*static simulated function float CalculateTraderWeaponStatDamage()
{
	local float BaseDamage, DoTDamage;
	local class<KFDamageType> DamageType;

	local GameExplosion ExplosionInstance;

	ExplosionInstance = class<KFProjectile>(default.WeaponProjectiles[DEFAULT_FIREMODE]).default.ExplosionTemplate;

	BaseDamage = default.InstantHitDamage[DEFAULT_FIREMODE] + ExplosionInstance.Damage;

	DamageType = class<KFDamageType>(ExplosionInstance.MyDamageType);
	if( DamageType != none && DamageType.default.DoT_Type != DOT_None )
	{
		DoTDamage = (DamageType.default.DoT_Duration / DamageType.default.DoT_Interval) * (BaseDamage * DamageType.default.DoT_DamageScale);
	}

	return BaseDamage * default.NumPellets[DEFAULT_FIREMODE] + DoTDamage;
}*/

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Pistol;
}

defaultproperties
{
	ForceReloadTime=0.3f

	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

	// Inventory
	InventoryGroup=IG_Secondary
	GroupPriority=75
	InventorySize=4
	WeaponSelectTexture=Texture2D'WEP_UI_HRGScorcher_Pistol_TEX.UI_WeaponSelect_HRGScorcher'

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=73

	// Zooming/Position
	PlayerViewOffset=(X=13.0,Y=13,Z=-4)
	FastZoomOutTime=0.2

	// Content
	PackageKey="HRGKillburst"
	FirstPersonMeshName="WEP_1P_HRGScorcher_Pistol_MESH.Wep_1stP_HRGScorcher_Pistol_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_HRGScorcher_Pistol_ANIM.Wep_1stP_HRGScorcher_Pistol_Anim"
	PickupMeshName="wep_3p_HRGScorcher_Pistol_mesh.WEP_HRGScorcher_Pickup"
	AttachmentArchetypeName="WEP_HRGScorcher_Pistol_ARCH.Wep_HRGScorcher_Pistol_3P"
	MuzzleFlashTemplateName="WEP_HRGScorcher_Pistol_ARCH.Wep_HRGScorcher_Pistol_MuzzleFlash"

   	// Zooming/Position
	IronSightPosition=(X=0,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=3//1
	SpareAmmoCapacity[0]=84//28
	InitialSpareMags[0]=12
	AmmoPickupScale[0]=4.0
	bCanBeReloaded=true
	bReloadFromMagazine=true
	bNoMagazine=true
	
	// Recoil
	maxRecoilPitch=850
	minRecoilPitch=750
	maxRecoilYaw=150
	minRecoilYaw=-150
    RecoilRate=0.1
	RecoilBlendOutRatio=0.35
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.8
	FallingRecoilModifier=1.5
	HippedRecoilModifier=1.25
	IronSightMeshFOVCompensationScale=1.4

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletBurst'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFireAndReload
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pistol_HRGKillBurst'
	InstantHitDamage(DEFAULT_FIREMODE)=150.0//75.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HRGKillBurst'
	Spread(DEFAULT_FIREMODE)=0.015
	FireInterval(DEFAULT_FIREMODE)=+0.06 // 1000 RPM
	FireOffset=(X=23,Y=4.0,Z=-3)
	BurstAmount=3

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRGKillBurst'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_SA_SW500_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_SA_SW500_Fire_1P')

	//@todo: add akevent when we have it
	WeaponDryFireSnd(DEFAULT_FIREMODE)=none

	// Animation
	bHasFireLastAnims=true

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

   	AssociatedPerkClasses(0)=class'KFPerk_Gunslinger'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
}