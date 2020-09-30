class KFWeap_Pistol_Bomber extends KFWeap_PistolBase;

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Explosive;
}


defaultproperties
{
	// Content
	PackageKey="BomberGun"
	FirstPersonMeshName="WEP_1P_FlareGun_MESH.Wep_1stP_FlareGun_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_FlareGun_ANIM.Wep_1stP_FlareGun_Anim"
	PickupMeshName="WEP_3P_FlareGun_MESH.Wep_FlareGun_Pickup"
	AttachmentArchetypeName="WEP_FlareGun_ARCH.Wep_FlareGun_3P"
	MuzzleFlashTemplateName="WEP_FlareGun_ARCH.Wep_Flaregun_MuzzleFlash"

	Begin Object Name=FirstPersonMesh
		AnimTreeTemplate=AnimTree'CHR_1P_Arms_ARCH.WEP_1stP_Animtree_Master_Revolver'
	End Object

   	// Position and FOV
   	PlayerViewOffset=(X=12.0,Y=14,Z=-6)
	IronSightPosition=(X=4,Y=0,Z=0)
	MeshFOV=60
	MeshIronSightFOV=55
    PlayerIronSightFOV=77

   	// Depth of field
	DOF_FG_FocalRadius=40
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=6
	SpareAmmoCapacity[0]=138//186
	InitialSpareMags[0]=15
	AmmoPickupScale[0]=2.0
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=400
	minRecoilPitch=350
	maxRecoilYaw=125
	minRecoilYaw=-125
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=400
	RecoilISMinPitchLimit=65485
	RecoilBlendOutRatio=0.75
	IronSightMeshFOVCompensationScale=1.5

	// DEFAULT_FIREMODE
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Explosive_BomberGun'
	FireInterval(DEFAULT_FIREMODE)=+0.2
	InstantHitDamage(DEFAULT_FIREMODE)=15.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_BomberGun'
	Spread(DEFAULT_FIREMODE)=0.015
	FireOffset=(X=20,Y=4.0,Z=-3)

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamage(BASH_FIREMODE)=22
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_BomberGun'

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_DryFire'

	// Inventory
	InventorySize=2
	GroupPriority=15
	bCanThrow=true
	bDropOnDeath=true
	WeaponSelectTexture=Texture2D'wep_ui_flaregun_tex.UI_WeaponSelect_Flaregun'
	bIsBackupWeapon=false
	DualClass=class'KFWeap_Pistol_DualBomber'
    AssociatedPerkClasses(0)=class'KFPerk_Demolitionist'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	// Hammer lock control
	bHasFireLastAnims = true
	BonesToLockOnEmpty = (RW_Hammer)

	// Revolver
	bRevolver=true
	CylinderRotInfo=(Inc=-60.0, Time=0.0175/*about 0.07 in the anim divided by ratescale of 4*/)

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.25f,IncrementWeight=0)
	//WeaponUpgrades[2]=(IncrementDamage=1.5f,IncrementWeight=1)
	//WeaponUpgrades[3]=(IncrementDamage=1.75f,IncrementWeight=2)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.5f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.75f), (Stat=EWUS_Weight, Add=2)))
}

