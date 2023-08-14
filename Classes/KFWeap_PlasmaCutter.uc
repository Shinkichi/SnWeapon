
class KFWeap_PlasmaCutter extends KFWeap_PistolBase;

var vector BarrelOffset;

simulated function KFProjectile SpawnProjectile(class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir)
{
	if (CurrentFireMode == GRENADE_FIREMODE)
	{
		return Super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir);
	}

	Super.SpawnProjectile(KFProjClass, RealStartLoc + BarrelOffset / 2.f, AimDir);
	Super.SpawnProjectile(KFProjClass, RealStartLoc - BarrelOffset / 2.f, AimDir);

	return None;
}


defaultproperties
{
	PlayerViewOffset=(X=20.0,Y=10,Z=-10)

	// Content
	PackageKey="PlasmaCutter"
	FirstPersonMeshName="WEP_1P_Welder_MESH.Wep_1stP_Welder_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Welder_ANIM.Wep_1st_Welder_Anim"
	AttachmentArchetypeName="WEP_Welder_ARCH.Welder_3P"
	MuzzleFlashTemplateName="WEP_Welder_ARCH.Wep_Welder_MuzzleFlash"

	// Aim Assist
	AimCorrectionSize=0.f
	bTargetAdhesionEnabled=false

	// Ammo
	MagazineCapacity[0]=10
	SpareAmmoCapacity[0]=100
	InitialSpareMags[0]=4
	AmmoPickupScale[0]=1.0
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Inventory
	InventorySize=3
	GroupPriority=5
	bCanThrow=true
	bDropOnDeath=true
	WeaponSelectTexture=Texture2D'WEP_UI_AF2001_TEX.UI_WeaponSelect_AF2011'
	bIsBackupWeapon=false
	AssociatedPerkClasses(0)=class'KFPerk_Survivalist'

	// DEFAULT_FIREMODE
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)= EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_PlasmaCutter'
	FireInterval(DEFAULT_FIREMODE)=+0.1898
	InstantHitDamage(DEFAULT_FIREMODE)=53 //91
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_PlasmaCutter'
	PenetrationPower(DEFAULT_FIREMODE)=1.5
	Spread(DEFAULT_FIREMODE)=0.01
	FireOffset=(X=20,Y=4.0,Z=-3)
    AmmoCost(DEFAULT_FIREMODE)=1

	// ALT_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_AF2011.Play_WEP_AF2011_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_AF2011.Play_WEP_AF2011_Fire_1P') //@TODO: Replace me
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_DesertEagle.Play_WEP_SA_DesertEagle_Handling_DryFire' //@TODO: Replace me

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_PlasmaCutter'
	InstantHitDamage(BASH_FIREMODE)=20

    //ScreenUIClass=class'KFGFxWorld_WelderScreen'
    
	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.25f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.4f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.6f,IncrementWeight=3)
	//WeaponUpgrades[4]=(IncrementDamage=1.9f,IncrementWeight=4)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.6f), (Stat=EWUS_Weight, Add=3)))
	WeaponUpgrades[4]=(Stats=((Stat=EWUS_Damage0, Scale=1.9f), (Stat=EWUS_Weight, Add=4)))
}
