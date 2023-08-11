class KFWeap_AssaultRifle_IncendiarySniper extends KFWeap_ScopedBase;

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Flame;
}

defaultproperties
{
	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

	// 2D scene capture
	Begin Object Name=SceneCapture2DComponent0
		TextureTarget=TextureRenderTarget2D'Wep_Mat_Lib.WEP_ScopeLense_Target'
		FieldOfView=12.5 // "2.0X" = 25.0(our real world FOV determinant)/2.0
	End Object

	ScopedSensitivityMod = 8.0

	ScopeLenseMICTemplate = MaterialInstanceConstant'WEP_1P_FNFAL_MAT.WEP_1P_FNFAL_Scope_MAT'

    // FOV
	MeshFOV=55 //60
	MeshIronSightFOV=20
    PlayerIronSightFOV=70

	// Depth of field
	DOF_BlendInSpeed=3.0	
	DOF_FG_FocalRadius=0//70
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	IronSightPosition=(X=15,Y=0,Z=0)
	PlayerViewOffset=(X=22.0,Y=11,Z=-3.0)

	// Content
	PackageKey="IncendiarySniper"
	FirstPersonMeshName="WEP_1P_FNFAL_MESH.WEP_1stP_FNFAL_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_FNFAL_ANIM.Wep_1stP_FNFAL_Anim"
	PickupMeshName="WEP_3P_FNFAL_MESH.WEP_3rdP_FNFAL_Pickup"
	AttachmentArchetypeName="WEP_FNFAL_ARCH.Wep_FNFAL_3P"
	MuzzleFlashTemplateName="WEP_FNFAL_ARCH.Wep_FNFAL_MuzzleFlash" //NEED To REPLACE

	// Ammo
	MagazineCapacity[0]=30//20
	SpareAmmoCapacity[0]=150//160
	InitialSpareMags[0]=2//3
	AmmoPickupScale[0]=1.0
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=200 //185
	minRecoilPitch=165 //150
	maxRecoilYaw=190 //175
	minRecoilYaw=-165 //-150
	RecoilRate=0.09
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=150
	RecoilISMinYawLimit=65385
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.6
	HippedRecoilModifier=1.5 //1.25

	// Inventory
	InventorySize=8
	GroupPriority=100
	WeaponSelectTexture=Texture2D'WEP_UI_FNFAL_TEX.UI_WeaponSelect_FNFAL'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_IncendiarySniper'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_IncendiarySniper'
	FireInterval(DEFAULT_FIREMODE)=+0.22  // 273 RPM
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	InstantHitDamage(DEFAULT_FIREMODE)=70.0 //50
	Spread(DEFAULT_FIREMODE)=0.007
	FireOffset=(X=30,Y=4.5,Z=-5)

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_IncendiarySniper'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_FNFAL.Play_WEP_FNFAL_Fire_3P_Single', FirstPersonCue=AkEvent'WW_WEP_FNFAL.Play_WEP_FNFAL_Fire_1P_Single')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_FNFAL.Play_WEP_FNFAL_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	AssociatedPerkClasses(0)=class'KFPerk_Firebug'
	AssociatedPerkClasses(1)=class'KFPerk_Sharpshooter'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
}
