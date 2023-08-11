
class KFWeap_Rifle_Musket extends KFWeap_RifleBase;

/**
 * Instead of a toggle, just immediately fire alternate fire.
 */
simulated function AltFireMode()
{
	// LocalPlayer Only
	if ( !Instigator.IsLocallyControlled()  )
	{
		return;
	}

	StartFire( ALTFIRE_FIREMODE );
}

defaultproperties
{
	// Inventory / Grouping
	InventorySize=4 //5
	GroupPriority=25
	WeaponSelectTexture=Texture2D'wep_ui_winchester_tex.UI_WeaponSelect_Winchester'
   	AssociatedPerkClasses(0)=class'KFPerk_Sharpshooter'
   	AssociatedPerkClasses(1)=class'KFPerk_Gunslinger'

    // FOV
    MeshFOV=65
	MeshIronSightFOV=45
    PlayerIronSightFOV=65

	// Depth of field
	DOF_FG_FocalRadius=50
	DOF_FG_MaxNearBlurSize=3.5

	// Content
	PackageKey="Musket"
	FirstPersonMeshName="WEP_1P_Winchester_MESH.Wep_1stP_Winchester_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Winchester_ANIM.Wep_1stP_Winchester_Anim"
	PickupMeshName="WEP_3P_Winchester_MESH.Wep_LAR1894_Pickup"
	AttachmentArchetypeName="SnWeapon_Packages.Wep_Musket_3P"
	MuzzleFlashTemplateName="wep_winchester_arch.Wep_Winchester_MuzzleFlash"

	// Ammo
	MagazineCapacity[0]=1//12
	SpareAmmoCapacity[0]=47//84 //84
	InitialSpareMags[0]=15//4 //3
	AmmoPickupScale[0]=4.0
	bCanBeReloaded=true
	bReloadFromMagazine=false

	// Zooming/Position
	PlayerViewOffset=(X=8.0,Y=7,Z=-3.5)
	IronSightPosition=(X=0,Y=0,Z=0)

	// AI warning system
	bWarnAIWhenAiming=true
	AimWarningDelay=(X=0.4f, Y=0.8f)
	AimWarningCooldown=0.0f

	// Recoil
	maxRecoilPitch=850
	minRecoilPitch=750
	maxRecoilYaw=150
	minRecoilYaw=-150
	RecoilRate=0.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	IronSightMeshFOVCompensationScale=1.4

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFireAndReload
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Musket'
	InstantHitDamage(DEFAULT_FIREMODE)=150//80 //105
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Musket'
	FireInterval(DEFAULT_FIREMODE)=0.4 // 70 RPM  0.85 0.75 0.45
	Spread(DEFAULT_FIREMODE)=0.007
	PenetrationPower(DEFAULT_FIREMODE)=3.0//1.5
	FireOffset=(X=25,Y=3.0,Z=-2.5)

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// Custom animations
	FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)
	BonesToLockOnEmpty=(RW_Hammer)
	bHasFireLastAnims=true

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Musket'
	InstantHitDamage(BASH_FIREMODE)=25

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_SA_SW500_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_SA_SW500_Fire_1P')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_SA_SW500_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_SA_SW500_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_Winchester.Play_WEP_SA_Winchester_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_Winchester.Play_WEP_SA_Winchester_Handling_DryFire'
	EjectedShellForegroundDuration=1.5f

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.6f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.9f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=2.3f,IncrementWeight=3)
	//WeaponUpgrades[4]=(IncrementDamage=2.5f,IncrementWeight=4)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.6f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.9f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=2.3f), (Stat=EWUS_Weight, Add=3)))
	WeaponUpgrades[4]=(Stats=((Stat=EWUS_Damage0, Scale=2.5f), (Stat=EWUS_Weight, Add=4)))
}