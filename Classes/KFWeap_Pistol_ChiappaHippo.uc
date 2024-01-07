
class KFWeap_Pistol_ChiappaHippo extends KFWeap_PistolBase;

defaultproperties
{
    // FOV
    MeshFOV=86
    MeshIronSightFOV=77
    PlayerIronSightFOV=77

    // Depth of field
    DOF_FG_FocalRadius=38
    DOF_FG_MaxNearBlurSize=3.5

    // Zooming/Position
    PlayerViewOffset=(X=14.0,Y=10,Z=-4)

	// Content
	PackageKey="ChiappaHippo"
	FirstPersonMeshName="WEP_1P_ChiappaRhino_MESH.Wep_1stP_ChiappaRhino_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_ChiappaRhino_ANIM.WEP_1stP_ChiappaRhino_Anim"
    PickupMeshName="WEP_3P_ChiappaRhino_MESH.Wep_3rdP_ChiappaRhino_Pickup"
    AttachmentArchetypeName="WEP_ChiappaRhino_ARCH.Wep_ChiappaRhino_3P"
	MuzzleFlashTemplateName="WEP_ChiappaRhino_ARCH.Wep_ChiappaRhino_MuzzleFlash"

    // Zooming/Position
    IronSightPosition=(X=11,Y=0,Z=-.25)

    // Ammo
    MagazineCapacity[0]=6
    SpareAmmoCapacity[0]=138//174//114
    InitialSpareMags[0]=7
    AmmoPickupScale[0]=2.0
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
    FireInterval(DEFAULT_FIREMODE)=+0.175
    InstantHitDamage(DEFAULT_FIREMODE)=50//75.0 //70.0
    InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_ChiappaHippo'
    PenetrationPower(DEFAULT_FIREMODE)=1.0//2.0
    Spread(DEFAULT_FIREMODE)=0.01
    FireOffset=(X=20,Y=4.0,Z=-3)

    // ALT_FIREMODE
    FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

    // BASH_FIREMODE
    InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_ChiappaHippo'
    InstantHitDamage(BASH_FIREMODE)=24

    // Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_1911.Play_WEP_SA_1911_Fire_Single_M', FirstPersonCue=AkEvent'WW_WEP_1911.Play_WEP_SA_1911_Fire_Single_S')
    WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_ChiappaRhinos.Play_WEP_ChiappaRhinos_DryFire'

    // Attachments
    bHasIronSights=true
    bHasFlashlight=false

    // Inventory
    InventorySize=2
    GroupPriority=22
    bCanThrow=true
    bDropOnDeath=true
    WeaponSelectTexture=Texture2D'wep_ui_chiapparhino_tex.UI_WeaponSelect_ChiappaRhinos'
    bIsBackupWeapon=false
    AssociatedPerkClasses(0)=class'KFPerk_Gunslinger'

    DualClass=class'KFWeap_Pistol_ChiappaHippoDual'

    // Custom animations
    FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)
    IdleFidgetAnims=(Guncheck_v1, Guncheck_v2, Guncheck_v3, Guncheck_v4)

    bHasFireLastAnims=true

    BonesToLockOnEmpty=(RW_Hammer)

    WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'

    WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Weight, Add=1)))
    WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
}