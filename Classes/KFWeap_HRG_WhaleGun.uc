class KFWeap_HRG_WhaleGun extends KFWeap_ShotgunBase;

defaultproperties
{
	// Content
	PackageKey="HRG_WhaleGun"
	FirstPersonMeshName="wep_1p_hrg_sonicgun_mesh.WEP_1stP_HRG_SonicGun_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_hrg_sonicgun_anim.Wep_1stP_HRG_SonicGun_Anim"
	PickupMeshName="wep_3p_hrg_sonicgun_mesh.WEP_3rdP_HRG_SonicGun_Pickup"
	AttachmentArchetypeName="wep_hrg_sonicgun_arch.Wep_HRG_SonicGun_3P"
	MuzzleFlashTemplateName="WEP_HRG_SonicGun_ARCH.Wep_HRG_SonicGun_MuzzleFlash"

	// Inventory / Grouping
	InventorySize=7
	GroupPriority=75
	WeaponSelectTexture=Texture2D'WEP_UI_HRG_SonicGun_TEX.UI_WeaponSelect_HRG_SonicGun'

    // FOV
    MeshFOV=75
	MeshIronSightFOV=40
    PlayerIronSightFOV=65

	// Depth of field
	DOF_FG_FocalRadius=50
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=12 //8
	SpareAmmoCapacity[0]=96 //72
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Zooming/Position
	PlayerViewOffset=(X=11.0,Y=8,Z=-2)
	IronSightPosition=(X=10,Y=-0.1,Z=-0.2)

	// AI warning system
	bWarnAIWhenAiming=true
	AimWarningDelay=(X=0.4f, Y=0.8f)
	AimWarningCooldown=0.0f

	// Recoil
	maxRecoilPitch=200 //500
	minRecoilPitch=150 //400
	maxRecoilYaw=50 //150
	minRecoilYaw=-50 //-150
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
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_HRG_WhaleGun'
	InstantHitDamage(DEFAULT_FIREMODE)=25//20//125
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HRG_WhaleGun'
	FireInterval(DEFAULT_FIREMODE)=0.5 //0.75
	Spread(DEFAULT_FIREMODE)=0.12 //0.1 //0.15
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireOffset=(X=25,Y=3.0,Z=-2.5)
	// Shotgun
	NumPellets(DEFAULT_FIREMODE)=10//12

	// ALTFIRE_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRG_WhaleGun'
	InstantHitDamage(BASH_FIREMODE)=26

	// Custom animations
	FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)
	BonesToLockOnEmpty=(RW_BoltAssembly1, RW_BoltAssembly2, RW_BoltAssembly3)
	bHasFireLastAnims=true

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_BlastBrawlers.Play_WEP_HRG_BlastBrawlers_Shoot_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_BlastBrawlers.Play_WEP_HRG_BlastBrawlers_Shoot_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_HRG_SonicGun.Play_WEP_HRG_SonicGun_DryFire'
	EjectedShellForegroundDuration=1.5f

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.1f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Weight, Add=2)))

    bAllowClientAmmoTracking=true
    AimCorrectionSize=0.f
	
	AssociatedPerkClasses(0)=class'KFPerk_Support'

}