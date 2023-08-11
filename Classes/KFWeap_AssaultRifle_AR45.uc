class KFWeap_AssaultRifle_AR45 extends KFWeap_RifleBase;

/** Returns trader filter index based on weapon type (copied from riflebase) */
static simulated event EFilterTypeUI GetTraderFilter()
{
    if( default.FiringStatesArray[DEFAULT_FIREMODE] == 'WeaponFiring' || default.FiringStatesArray[DEFAULT_FIREMODE] == 'WeaponBurstFiring' )
    {
        return FT_Assault;
    }
    else // if( FiringStatesArray[DEFAULT_FIREMODE] == 'WeaponSingleFiring')
    {
        return FT_Rifle;
    }
}

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
	DOF_FG_FocalRadius=75
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=9.0,Y=10,Z=-4)

	// Content
	PackageKey="AR45"
	FirstPersonMeshName="WEP_1P_AR15_9mm_MESH.Wep_1stP_AR15_9mm_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_AR15_9mm_ANIM.Wep_1stP_AR15_9mm_Anim"
	PickupMeshName="WEP_3P_AR15_9mm_MESH.Wep_AR15_Pickup"
	AttachmentArchetypeName="WEP_AR15_9mm_ARCH.Wep_AR15_9mm_3P"
	MuzzleFlashTemplateName="WEP_AR15_9mm_ARCH.Wep_AR15_9MM_MuzzleFlash"

   	// Zooming/Position
	IronSightPosition=(X=7,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=20
	SpareAmmoCapacity[0]=160//240
	InitialSpareMags[0]=3//6
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
    maxRecoilPitch=120
    minRecoilPitch=92
    maxRecoilYaw=101 //92
    minRecoilYaw=-101  //92
    RecoilRate=0.085
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
    HippedRecoilModifier=1.4

	// Inventory / Grouping
	InventorySize=4
	GroupPriority=25
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_AR15'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_AssaultRifle'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_AR45'
	FireInterval(DEFAULT_FIREMODE)=+0.12 // 500 RPM
	Spread(DEFAULT_FIREMODE)=0.01
	InstantHitDamage(DEFAULT_FIREMODE)=45.0 //25
	FireOffset=(X=30,Y=4.5,Z=-4)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_AssaultRifle'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_AR45'
	FireInterval(ALTFIRE_FIREMODE)=+0.12 // 500 RPM
	InstantHitDamage(ALTFIRE_FIREMODE)=45.0 //25
	Spread(ALTFIRE_FIREMODE)=0.01

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_AR45'
	InstantHitDamage(BASH_FIREMODE)=24

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_UMP.Play_WEP_UMP_Fire_3P_Single',FirstPersonCue=AkEvent'WW_WEP_UMP.Play_WEP_UMP_Fire_1P_Single')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_UMP.Play_WEP_UMP_Fire_3P_Single',FirstPersonCue=AkEvent'WW_WEP_UMP.Play_WEP_UMP_Fire_1P_Single')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_AR15.Play_WEP_SA_AR15_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_AR15.Play_WEP_SA_AR15_Handling_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	AssociatedPerkClasses(0)=class'KFPerk_Commando'
	
	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.2f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.4f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.8f,IncrementWeight=3)
	//WeaponUpgrades[4]=(IncrementDamage=2.0f,IncrementWeight=4)
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Damage1, Scale=1.2f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.8f), (Stat=EWUS_Damage1, Scale=1.8f), (Stat=EWUS_Weight, Add=3)))
	WeaponUpgrades[4]=(Stats=((Stat=EWUS_Damage0, Scale=2.0f), (Stat=EWUS_Damage1, Scale=2.0f), (Stat=EWUS_Weight, Add=4)))
}

