
class KFWeap_SMG_Viper extends KFWeap_SMGBase;

defaultproperties
{
	// Inventory
	InventorySize=4
	GroupPriority=60
	WeaponSelectTexture=Texture2D'WEP_UI_MP5RAS_TEX.UI_WeaponSelect_MP5RAS'

	// FOV
	MeshFOV=86
	MeshIronSightFOV=50
	PlayerIronSightFOV=75

	// Zooming/Position
	IronSightPosition=(X=10.f,Y=0,Z=0)
	PlayerViewOffset=(X=17.f,Y=8,Z=-4.0)

	// Content
	PackageKey="Viper"
	FirstPersonMeshName="wep_1p_mp5ras_mesh.Wep_1stP_MP5RAS_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_mp5ras_anim.wep_1p_mp5ras_anim"
	PickupMeshName="wep_3p_mp5ras_mesh.Wep_MP5RAS_Pickup"
	AttachmentArchetypeName="wep_mp5ras_arch.Wep_MP5RAS_3P"
	MuzzleFlashTemplateName="wep_mp5ras_arch.Wep_MP5RAS_MuzzleFlash"

	// Ammo
	MagazineCapacity[0]=10//40
	SpareAmmoCapacity[0]=80//320
	InitialSpareMags[0]=4
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=650
	minRecoilPitch=550
	maxRecoilYaw=150
	minRecoilYaw=-150
	RecoilRate=0.07
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1250
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.25
	IronSightMeshFOVCompensationScale=1.5

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pistol9mm'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Viper'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireInterval(DEFAULT_FIREMODE)=+0.2
	Spread(DEFAULT_FIREMODE)=0.01
	InstantHitDamage(DEFAULT_FIREMODE)=90.0
	FireOffset=(X=30,Y=4.5,Z=-5)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_Pistol9mm'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_Viper'
	FireInterval(ALTFIRE_FIREMODE)=+0.2
	InstantHitDamage(ALTFIRE_FIREMODE)=90.0
	Spread(ALTFIRE_FIREMODE)=0.01

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Viper'
	InstantHitDamage(BASH_FIREMODE)=24.0
	
	//@todo: add akevents when we have them
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_DesertEagle.Play_WEP_SA_DesertEagle_Fire_Single_M', FirstPersonCue=AkEvent'WW_WEP_SA_DesertEagle.Play_WEP_SA_DesertEagle_Fire_Single_S')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_DesertEagle.Play_WEP_SA_DesertEagle_Fire_Single_M', FirstPersonCue=AkEvent'WW_WEP_SA_DesertEagle.Play_WEP_SA_DesertEagle_Fire_Single_S')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_MedicSMG.Play_SA_MedicSMG_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_DryFire'

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shot_EndLP_3P', FirstPersonCue=AkEvent'WW_WEP_Autoturret.Play_WEP_AutoTurret_Shot_EndLP_1P')
	SingleFireSoundIndex=ALTFIRE_FIREMODE
	
	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	AssociatedPerkClasses(0)=class'KFPerk_Commando'
	AssociatedPerkClasses(1)=class'KFPerk_Swat'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.2f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.4f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.6f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Damage1, Scale=1.2f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.6f), (Stat=EWUS_Damage1, Scale=1.6f), (Stat=EWUS_Weight, Add=3)))
}
