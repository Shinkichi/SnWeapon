class KFWeap_Rifle_BAR extends KFWeap_ScopedBase;

defaultproperties
{
	// Inventory / Grouping
	InventorySize=8//7
	GroupPriority=75
	WeaponSelectTexture=Texture2D'WEP_UI_M14EBR_TEX.UI_WeaponSelect_SM14-EBR'
   	AssociatedPerkClasses(0)=class'KFPerk_Commando'
   	//AssociatedPerkClasses(1)=class'KFPerk_Sharpshooter'
   	
 	// 2D scene capture
	Begin Object Name=SceneCapture2DComponent0
	   TextureTarget=TextureRenderTarget2D'Wep_Mat_Lib.WEP_ScopeLense_Target'
	   FieldOfView=12.5 // "2.0X" = 25.0(our real world FOV determinant)/2.0
	End Object

    ScopedSensitivityMod=8.0

	ScopeLenseMICTemplate=MaterialInstanceConstant'WEP_1P_M14EBR_MAT_TWO.WEP_1P_M14EBR_Scope_MAT'

    // FOV
    MeshFOV=70
	MeshIronSightFOV=27
    PlayerIronSightFOV=70

	// Depth of field
	DOF_BlendInSpeed=3.0	
	DOF_FG_FocalRadius=0//70
	DOF_FG_MaxNearBlurSize=3.5

	// Content
	PackageKey="BAR"
	FirstPersonMeshName="WEP_1P_M14EBR_MESH.WEP_1stP_M14_EBR"
	FirstPersonAnimSetNames(0)="WEP_1P_M14EBR_ANIM.Wep_1stP_M14_EBR_Anim"
	PickupMeshName="WEP_3P_M14EBR_MESH.Wep_M14EBR_Pickup"
	AttachmentArchetypeName="WEP_M14EBR_ARCH.Wep_M14EBR_3P"
	MuzzleFlashTemplateName="WEP_M14EBR_ARCH.Wep_M14EBR_MuzzleFlash"

	LaserSightTemplate=KFLaserSightAttachment'FX_LaserSight_ARCH.LaserSight_WithAttachment_1P'

	// Ammo
	MagazineCapacity[0]=10//30//20
	SpareAmmoCapacity[0]=70//180//120
	InitialSpareMags[0]=2
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Zooming/Position
	PlayerViewOffset=(X=15.0,Y=11.5,Z=-4)
	IronSightPosition=(X=0.0,Y=0,Z=0)

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
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_M14EBR'
	InstantHitDamage(DEFAULT_FIREMODE)=160//80.0 //90
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_BAR'
	FireInterval(DEFAULT_FIREMODE)=0.2 // 300 RPM
	PenetrationPower(DEFAULT_FIREMODE)=1.5
	Spread(DEFAULT_FIREMODE)=0.007
	FireOffset=(X=30,Y=3.0,Z=-2.5)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None


	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_BAR'
	InstantHitDamage(BASH_FIREMODE)=27

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_Winchester.Play_WEP_Centerfire_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_Winchester.Play_WEP_Centerfire_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_EBR.Play_WEP_SA_EBR_Handling_DryFire'

	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_Winchester.Play_WEP_Centerfire_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_Winchester.Play_WEP_Centerfire_Fire_1P')
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_EBR.Play_WEP_SA_EBR_Handling_DryFire'

	// Custom animations
	FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false
	bHasLaserSight=true

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.3f,IncrementWeight=2)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
}