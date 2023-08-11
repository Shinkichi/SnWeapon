class KFWeap_HRG_Kamaitachi extends KFWeap_FlameBase;

defaultproperties
{
	FlameSprayArchetype=KFSprayActor_HRG_Vampire'SnWeapon_Packages.WEP_HRG_Kamaitachi_Spray'

	// Shooting Animations Last (Default)
	FireLoopEndLastAnim=ShootLoop_End;
	FireLoopEndLastSightedAnim=ShootLoop_Iron_End;

	// FOV
    Meshfov=80
	MeshIronSightFOV=65 //52
    PlayerIronSightFOV=50 //80

	// Zooming/Position
	PlayerViewOffset=(X=20.0,Y=12,Z=-1)
	IronSightPosition=(X=0,Y=0,Z=0)

	// Depth of field
	DOF_FG_FocalRadius=150
	DOF_FG_MaxNearBlurSize=1


	// Content
	PackageKey="HRG_Kamaitachi"
	FirstPersonMeshName="WEP_1P_HRG_Vampire_MESH.Wep_1stP_HRG_Vampire_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_HRG_Vampire_Anim.Wep_1stP_HRG_Vampire_Anim"
	PickupMeshName="WEP_3P_HRG_Vampire_MESH.Wep_3rdP_HRG_Vampire_Pickup"
	AttachmentArchetypeName="WEP_HRG_Vampire_ARCH.WEP_HRG_Vampire_3P"
	MuzzleFlashTemplateName="WEP_HRG_Vampire_ARCH.Wep_HRG_Vampire_MuzzleFlash"

	// Ammo
	MagazineCapacity[0]=0/100//40 //50
	SpareAmmoCapacity[0]=0/600//240 //280 //350 //300
	InitialSpareMags[0]=0/1
	AmmoPickupScale[0]=0/1

	bCanRefillSecondaryAmmo=FALSE;

	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=115 //150
	minRecoilPitch=75 //115
	maxRecoilYaw=75 //115
	minRecoilYaw=-75 //-115
	RecoilRate=0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65034
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.25
	IronSightMeshFOVCompensationScale=1.5
    HippedRecoilModifier=1.5

    // Inventory
	InventorySize=8 //9
	GroupPriority=100
	WeaponSelectTexture=Texture2D'WEP_UI_HRG_Vampire_TEX.UI_WeaponSelect_HRG_Vampire'

	// Saw attack (uses fuel)
	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Vampire'
	FiringStatesArray(DEFAULT_FIREMODE)=SprayingFire
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Custom
	FireInterval(DEFAULT_FIREMODE)=+.05 // 1200 RPM//+0.07 // 850 RPM
	AmmoCost(DEFAULT_FIREMODE)=0
	FireOffset=(X=30,Y=4.5,Z=-5)
	//MinFireDuration=0.25
	MinAmmoConsumed=4

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRG_Kamaitachi'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Vampire.Play_WEP_HRG_Vampire_Suck_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Vampire.Play_WEP_HRG_Vampire_Suck_Loop_1P')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Vampire.Play_WEP_HRG_Vampire_3P_AltFire', FirstPersonCue=AkEvent'WW_WEP_HRG_Vampire.Play_WEP_HRG_Vampire_1P_AltFire')
    WeaponFireSnd(CUSTOM_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Vampire.Play_WEP_HRG_Vampire_3P_Shoot', FirstPersonCue=AkEvent'WW_WEP_HRG_Vampire.Play_WEP_HRG_Vampire_1P_Shoot')

	//@todo: add akevents when we have them
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_Microwave_Gun.Play_SA_MicrowaveGun_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_Microwave_Gun.Play_SA_MicrowaveGun_DryFire'
	WeaponDryFireSnd(CUSTOM_FIREMODE)=None

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	SingleFireSoundIndex=FIREMODE_NONE

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

   	AssociatedPerkClasses(0)=class'KFPerk_Berserker'

   	BonesToLockOnEmpty=(RW_Handle1, RW_BatteryCylinder1, RW_BatteryCylinder2, RW_LeftArmSpinner, RW_RightArmSpinner, RW_LockEngager2, RW_LockEngager1)

 	// AI Warning
 	bWarnAIWhenFiring=true
    MaxAIWarningDistSQ=2250000

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	UpgradeFireModes(CUSTOM_FIREMODE)=0

	bAlwaysRelevant = true
	bOnlyRelevantToOwner = false

	bAllowClientAmmoTracking=false

}