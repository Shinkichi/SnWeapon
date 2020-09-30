class KFWeap_Pistol_DualBomber extends KFWeap_DualBase;

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Explosive;
}


defaultproperties
{
	//Content
	PackageKey="Dual_BomberGun"
	FirstPersonMeshName="WEP_1P_Dual_FlareGun_MESH.Wep_1stP_Dual_FlareGun_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Dual_FlareGun_ANIM.Wep_1stP_Dual_FlareGun_Anim"
	PickupMeshName="WEP_3P_Dual_FlareGun_MESH.Wep_FlareGun_Pickup"
	AttachmentArchetypeName="WEP_Dual_FlareGun_ARCH.Wep_Dual_FlareGun_3P"
	MuzzleFlashTemplateName="WEP_Dual_FlareGun_ARCH.Wep_Flaregun_MuzzleFlash"

	Begin Object Name=FirstPersonMesh
		AnimTreeTemplate=AnimTree'CHR_1P_Arms_ARCH.WEP_1stP_Dual_Animtree_Master_Revolver'
	End Object

	FireOffset=(X=17,Y=4.0,Z=-2.25)
	LeftFireOffset=(X=17,Y=-4,Z=-2.25)

	// Position and FOV
	IronSightPosition=(X=4,Y=0,Z=0)
	PlayerViewOffset=(X=23,Y=0,Z=-1)
	QuickWeaponDownRotation=(Pitch=-8192,Yaw=0,Roll=0)
	MeshFOV=60
	MeshIronSightFOV=55
    PlayerIronSightFOV=77

	// Depth of field
	DOF_FG_FocalRadius=40
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=12 // twice as much as single
	SpareAmmoCapacity[0]=132//180
	InitialSpareMags[0]=7
	AmmoPickupScale[0]=1.0
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
	FireInterval(DEFAULT_FIREMODE)=+0.11 // about twice as fast as single
	InstantHitDamage(DEFAULT_FIREMODE)=15.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_BomberGun_Dual'
	Spread(DEFAULT_FIREMODE)=0.015
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'

	// ALTFIRE_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Explosive_BomberGun'
	FireInterval(ALTFIRE_FIREMODE)=+0.11 // about twice as fast as single
	InstantHitDamage(ALTFIRE_FIREMODE)=15.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_BomberGun_Dual'
	Spread(ALTFIRE_FIREMODE)=0.015
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'

	// BASH_FIREMODE
	InstantHitDamage(BASH_FIREMODE)=24.0
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_BomberGun'

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_DryFire'

	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Fire_1P')
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_DryFire'

	// Inventory
	InventorySize=4
	GroupPriority=35
	WeaponSelectTexture=Texture2D'wep_ui_dual_flaregun_tex.UI_WeaponSelect_DualFlaregun'
	bIsBackupWeapon=false
	bCanThrow=true
	bDropOnDeath=true
	SingleClass=class'KFWeap_Pistol_Bomber'
    AssociatedPerkClasses(0)=class'KFPerk_Demolitionist'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	// Hammer lock control
	bHasFireLastAnims=true
	BonesToLockOnEmpty=(RW_Hammer)
	BonesToLockOnEmpty_L=(LW_Hammer)

	// Revolver
	bRevolver=true
	CylinderRotInfo=(Inc=-60.0, Time=0.0875/*about 0.35 in the anim divided by ratescale of 4*/)
	CylinderRotInfo_L=(Inc=-60.0, Time=0.0875/*about 0.35 in the anim divided by ratescale of 4*/)

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.25f,IncrementWeight=0)
	//WeaponUpgrades[2]=(IncrementDamage=1.5f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.75f,IncrementWeight=4)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Damage1, Scale=1.25f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.5f), (Stat=EWUS_Damage1, Scale=1.5f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.75f), (Stat=EWUS_Damage1, Scale=1.75f), (Stat=EWUS_Weight, Add=4)))
}

