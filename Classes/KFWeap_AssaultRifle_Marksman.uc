class KFWeap_AssaultRifle_Marksman extends KFWeap_RifleBase;

defaultproperties
{
	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=85
	DOF_FG_MaxNearBlurSize=2.5

	// Content
	PackageKey="Marksman"
	FirstPersonMeshName="WEP_1P_L85A2_MESH.Wep_1stP_L85A2_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_L85A2_ANIM.Wep_1st_L85A2_Anim"
	PickupMeshName="WEP_3P_L85A2_MESH.Wep_L85A2_Pickup"
	AttachmentArchetypeName="WEP_L85A2_ARCH.Wep_L85A2_3P"
	MuzzleFlashTemplateName="WEP_L85A2_ARCH.Wep_L85A2_MuzzleFlash"

   	// Zooming/Position
	PlayerViewOffset=(X=3.0,Y=9,Z=-3)
	IronSightPosition=(X=0,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=18//20
	SpareAmmoCapacity[0]=162//160
	InitialSpareMags[0]=3
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=150  //200  //300 //200
	minRecoilPitch=100 //150   //225 //170
	maxRecoilYaw=224  //175    //262 //274
	minRecoilYaw=-224  //-175    //-262  //-274
	RecoilRate=0.11 //0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.25
	IronSightMeshFOVCompensationScale=1.5
    HippedRecoilModifier=1.5

    // Inventory / Grouping
	InventorySize=6
	GroupPriority=50
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_Bullpup'
   	AssociatedPerkClasses(0)=class'KFPerk_Sharpshooter'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_AssaultRifle'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Marksman'
	FireInterval(DEFAULT_FIREMODE)=+0.2//+0.22
	Spread(DEFAULT_FIREMODE)=0.0085
	InstantHitDamage(DEFAULT_FIREMODE)=50
	FireOffset=(X=30,Y=4.5,Z=-5)

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Marksman'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_MKB42.Play_WEP_MKB42_Fire_3P_Single', FirstPersonCue=AkEvent'WW_WEP_MKB42.Play_WEP_MKB42_Fire_1P_Single') //@TODO: Replace me

	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Handling_DryFire'

	// Advanced (High RPM) Fire Effects
	//bLoopingFireAnim(DEFAULT_FIREMODE)=true
	//bLoopingFireSnd(DEFAULT_FIREMODE)=true
	//SingleFireSoundIndex=ALTFIRE_FIREMODE

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.3f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.65f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.85f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.65f), (Stat=EWUS_Damage1, Scale=1.65f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.85f), (Stat=EWUS_Damage1, Scale=1.85f), (Stat=EWUS_Weight, Add=3)))
}


