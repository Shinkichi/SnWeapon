
class KFWeap_Pistol_ChiappaHippoDual extends KFWeap_DualBase;

defaultproperties
{
	// Content
	PackageKey="Dual_ChiappaHippo"
	FirstPersonMeshName="WEP_1P_Dual_ChiappaRhino_MESH.Wep_1stP_Dual_ChiappaRhino_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Dual_ChiappaRhino_ANIM.WEP_1stP_Dual_ChiappaRhino_Anim"
	PickupMeshName="WEP_3P_Dual_ChiappaRhino_MESH.Wep_3rdP_ChiappaRhino_Pickup"
    AttachmentArchetypeName="WEP_Dual_ChiappaRhino_ARCH.Wep_Dual_ChiappaRhino_3P"
    MuzzleFlashTemplateName="WEP_Dual_ChiappaRhino_ARCH.Wep_Dual_ChiappaRhino_MuzzleFlash"

    FireOffset=(X=17,Y=4.0,Z=-2.25)
    LeftFireOffset=(X=17,Y=-4,Z=-2.25)

    // Zooming/Position
    IronSightPosition=(X=-1,Y=0,Z=-1.1)
    PlayerViewOffset=(X=9,Y=0,Z=-5)
    QuickWeaponDownRotation=(Pitch=-8192,Yaw=0,Roll=0)

    SingleClass=class'KFWeap_Pistol_ChiappaHippo'

    // FOV
    MeshFOV=86
    MeshIronSightFOV=77
    PlayerIronSightFOV=77

    // Depth of field
    DOF_FG_FocalRadius=38
    DOF_FG_MaxNearBlurSize=3.5

    // Ammo
    MagazineCapacity[0]=12
    SpareAmmoCapacity[0]=132//168//108
    InitialSpareMags[0]=3
    AmmoPickupScale[0]=1.0
    bCanBeReloaded=true
    bReloadFromMagazine=true

    // Recoil
	maxRecoilPitch=450
	minRecoilPitch=400
	maxRecoilYaw=150
	minRecoilYaw=-150
	RecoilRate=0.07
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485

    // DEFAULT_FIREMODE
    FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pistol_ChiappaHippo'
    FireInterval(DEFAULT_FIREMODE)=+0.1
    InstantHitDamage(DEFAULT_FIREMODE)=50//75.0 //70.0
    InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_ChiappaHippo'
    PenetrationPower(DEFAULT_FIREMODE)=1.0//2.0
    Spread(DEFAULT_FIREMODE)=0.01

    FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'

    // ALTFIRE_FIREMODE
    FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTFIRE_FIREMODE)= EWFT_Projectile
    WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_Pistol_ChiappaHippo'
    FireInterval(ALTFIRE_FIREMODE)=+0.1
    InstantHitDamage(ALTFIRE_FIREMODE)=50//75.0 //70.0
    InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_ChiappaHippo'
    PenetrationPower(ALTFIRE_FIREMODE)=1.0//2.0
    Spread(ALTFIRE_FIREMODE)=0.01

    FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'

    // BASH_FIREMODE
    InstantHitDamage(BASH_FIREMODE)=24
    InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_ChiappaHippo'

    // Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_1911.Play_WEP_SA_1911_Fire_Single_M', FirstPersonCue=AkEvent'WW_WEP_1911.Play_WEP_SA_1911_Fire_Single_S')
    WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_DryFire'

	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_1911.Play_WEP_SA_1911_Fire_Single_M', FirstPersonCue=AkEvent'WW_WEP_1911.Play_WEP_SA_1911_Fire_Single_S')
    WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_DryFire'

    // Attachments
    bHasIronSights=true
    bHasFlashlight=false

    // Inventory
    InventorySize=4
    GroupPriority=42
    bCanThrow=true
    bDropOnDeath=true
    WeaponSelectTexture=Texture2D'wep_ui_chiapparhino_tex.UI_WeaponSelect_DualChiappaRhinos'
    bIsBackupWeapon=false
    AssociatedPerkClasses(0)=class'KFPerk_Gunslinger'

    BonesToLockOnEmpty=(RW_Hammer)
    BonesToLockOnEmpty_L=(LW_Hammer)

    bHasFireLastAnims=true

    WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Damage1, Scale=1.25f), (Stat=EWUS_Weight, Add=2)))
    WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.4f), (Stat=EWUS_Weight, Add=4)))
}

