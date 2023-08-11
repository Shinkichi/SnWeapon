class KFWeap_Shotgun_DM12 extends KFWeap_ShotgunBase;

/*var vector BarrelOffset;

simulated function KFProjectile SpawnProjectile(class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir)
{
	if (CurrentFireMode == GRENADE_FIREMODE)
	{
		return Super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir);
	}

	Super.SpawnProjectile(KFProjClass, RealStartLoc + BarrelOffset / 2.f, AimDir);
	Super.SpawnProjectile(KFProjClass, RealStartLoc - BarrelOffset / 2.f, AimDir);

	return None;
}*/


defaultproperties
{
	//BarrelOffset=(X=10.0,Y=0,Z=0)

	// Inventory
	InventorySize=5
	GroupPriority=55
	WeaponSelectTexture=Texture2D'WEP_UI_HZ12_TEX.UI_WeaponSelect_HZ12'

    // FOV
    MeshFOV=75
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=95
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=20,Y=7.6,Z=-3.0)
	IronSightPosition=(X=6.0,Y=0,Z=0)

	// Content
	PackageKey="DM12"
	FirstPersonMeshName="WEP_1P_HZ12_MESH.Wep_1stP_HZ12_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_HZ12_ANIM.Wep_1stP_HZ12_Anim"
	PickupMeshName="WEP_3P_HZ12_MESH.Wep_3rdP_HZ12_Pickup"
	AttachmentArchetypeName="WEP_HZ12_ARCH.Wep_HZ12_3P"
	MuzzleFlashTemplateName="WEP_HZ12_ARCH.Wep_HZ12_MuzzleFlash"

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)="ui_firemodes_tex.UI_FireModeSelect_BulletAuto"
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pellet'
	InstantHitDamage(DEFAULT_FIREMODE)=50.0//53.0//20.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_DM12'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireInterval(DEFAULT_FIREMODE)=0.2//0.1
	Spread(DEFAULT_FIREMODE)=0.1//0.15
	FireOffset=(X=30,Y=3,Z=-3)
    AmmoCost(DEFAULT_FIREMODE)=2
	// Shotgun
	NumPellets(DEFAULT_FIREMODE)=2

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)="ui_firemodes_tex.UI_FireModeSelect_BulletSingle"
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_Pellet'
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0//53.0//20.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_DM12'
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	FireInterval(ALTFIRE_FIREMODE)=0.2//0.1
	Spread(ALTFIRE_FIREMODE)=0.1//0.15
    AmmoCost(ALTFIRE_FIREMODE)=2
	// Shotgun
	NumPellets(ALTFIRE_FIREMODE)=2

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_DM12'
	InstantHitDamage(BASH_FIREMODE)=25

	// Fire Effects
	//WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HZ12.Play_WEP_HZ12_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HZ12.Play_WEP_HZ12_Fire_1P')
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_AF2011.Play_WEP_AF2011_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_AF2011.Play_WEP_AF2011_Fire_1P') //@TODO: Replace me
    //WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HZ12.Play_WEP_HZ12_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HZ12.Play_WEP_HZ12_Fire_1P')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_AF2011.Play_WEP_AF2011_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_AF2011.Play_WEP_AF2011_Fire_1P') //@TODO: Replace me

    // using M4 dry fire sound. this is intentional.
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_M4.Play_WEP_SA_M4_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_M4.Play_WEP_SA_M4_Handling_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	// Ammo
	MagazineCapacity[0]=24//32//16
	SpareAmmoCapacity[0]=168//160//80
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=650  //650  //550
	minRecoilPitch=550  //550  //550
	maxRecoilYaw=550 //150
	minRecoilYaw=-550 //150
	RecoilRate=0.09 //0.07
	RecoilBlendOutRatio=1.1 //0.35
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1250
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.8
	FallingRecoilModifier=1.5
	HippedRecoilModifier=1.25

	// Animation
	bHasFireLastAnims=false

	AssociatedPerkClasses(0)=class'KFPerk_SWAT'
	AssociatedPerkClasses(1)=class'KFPerk_Commando'
	
	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.1f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.2f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.3f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.1f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Weight, Add=3)))
}
