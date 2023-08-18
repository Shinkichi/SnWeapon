class KFWeap_JavelinGun extends KFWeap_GrenadeLauncher_Base;
/** Reduction for the amount of damage dealt to the weapon owner (including damage by the explosion) */
var float SelfDamageReductionValue;

// Reduce damage to self
function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super.AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != none && DamageCauser != none && DamageCauser.Instigator == Instigator)
	{
		InDamage *= SelfDamageReductionValue;
	}
}

simulated function AltFireMode()
{
	if ( !Instigator.IsLocallyControlled() )
	{
		return;
	}

	StartFire(ALTFIRE_FIREMODE);
}

// GrenadeLaunchers determine ShouldPlayFireLast based on the spare ammo
// overriding to use the base KFWeapon version since that uses the current ammo in the mag
simulated function bool ShouldPlayFireLast(byte FireModeNum)
{
	return Super(KFWeapon).ShouldPlayFireLast(FireModeNum);
}

/** Returns trader filter index based on weapon type (copied from riflebase) */
static simulated event EFilterTypeUI GetTraderFilter()
{
    return FT_Projectile;
}

defaultproperties
{
	SelfDamageReductionValue=0.075f //0.f

	// Content
	PackageKey="JavelinGun"
	FirstPersonMeshName="wep_1p_seal_squeal_mesh.WEP_1stP_Seal_Squeal_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_seal_squeal_anim.Wep_1stP_Seal_Squeal_Anim"
	PickupMeshName="wep_3p_seal_squeal_mesh.WEP_3rdP_Seal_Squeal_Pickup" //@TODO: Replace me
	AttachmentArchetypeName="wep_seal_squeal_arch.Wep_Seal_Squeal_3P"
	MuzzleFlashTemplateName="WEP_Seal_Squeal_ARCH.Wep_Seal_Squeal_MuzzleFlash" //@TODO: Replace me

	// Inventory / Grouping
	InventorySize=7 //8
	GroupPriority=75
	WeaponSelectTexture=Texture2D'WEP_UI_Seal_Squeal_TEX.UI_WeaponSelect_SealSqueal'
   	AssociatedPerkClasses(0)=class'KFPerk_Berserker'
   	AssociatedPerkClasses(1)=class'KFPerk_Sharpshooter'

    // FOV
    MeshFOV=75
	MeshIronSightFOV=40
    PlayerIronSightFOV=65

	// Depth of field
	DOF_FG_FocalRadius=50
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=5
	SpareAmmoCapacity[0]=30 //25
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Zooming/Position
	PlayerViewOffset=(X=11.0,Y=8,Z=-2)
	IronSightPosition=(X=10,Y=0,Z=0)

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
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletArrow'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bolt_JavelinGun'
	InstantHitDamage(DEFAULT_FIREMODE)=250//350.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Piercing_JavelinGun'
	FireInterval(DEFAULT_FIREMODE)=0.5//0.75
	Spread(DEFAULT_FIREMODE)=0
	PenetrationPower(DEFAULT_FIREMODE)=4.0
	FireOffset=(X=25,Y=3.0,Z=-2.5)
	
	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletArrow'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None
	
	//FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletArrow'
	//FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	//WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	//WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bolt_JavelinGun_Alt'
	//InstantHitDamage(ALTFIRE_FIREMODE)=125
	//InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_JavelinGun_Alt'
	//FireInterval(ALTFIRE_FIREMODE)=0.5//0.75
	//Spread(ALTFIRE_FIREMODE)=0
	//PenetrationPower(ALTFIRE_FIREMODE)=0

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_JavelinGun'
	InstantHitDamage(BASH_FIREMODE)=25

	// Custom animations
	FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)
	BonesToLockOnEmpty=(RW_BoltAssembly1, RW_BoltAssembly2, RW_BoltAssembly3)
	bHasFireLastAnims=true

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_3P', FirstPersonCue=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_1P') //@TODO: Replace me
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_DryFire' //@TODO: Replace me

	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_3P', FirstPersonCue=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_1P') //@TODO: Replace me
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_DryFire' //@TODO: Replace me
	EjectedShellForegroundDuration=1.5f

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
}