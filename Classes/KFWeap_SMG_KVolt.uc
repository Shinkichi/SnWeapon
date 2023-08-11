class KFWeap_SMG_KVolt extends KFWeap_MedicBase;

/** Override for 1st person healing dart anims */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	if (FireModeNum == ALTFIRE_FIREMODE)
	{
		return (bUsingSights) ? FireSightedAnims[0] : FireAnim;
	}

	return Super.GetWeaponFireAnim(FireModeNum);
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Electric;
}


defaultproperties
{
	// Healing charge
    HealAmount=15
	HealFullRechargeSeconds=13 //15

	// Inventory
	InventorySize=5//6
	GroupPriority=100
	WeaponSelectTexture=Texture2D'WEP_UI_KRISS_TEX.UI_WeaponSelect_KRISS'
	SecondaryAmmoTexture=Texture2D'UI_SecondaryAmmo_TEX.MedicDarts'

	// FOV
	MeshFOV=86
	MeshIronSightFOV=45
	PlayerIronSightFOV=75

	// Zooming/Position
	IronSightPosition=(X=15.f,Y=0.f,Z=0.0f)
	PlayerViewOffset=(X=20.f,Y=9.5f,Z=-3.0f)

	// Content
	PackageKey="KVolt"
	FirstPersonMeshName="wep_1p_kriss_mesh.Wep_1stP_KRISS_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_kriss_anim.wep_1p_kriss_anim"
	PickupMeshName="wep_3p_kriss_mesh.Wep_KRISS_Pickup"
	AttachmentArchetypeName="SnWeapon_Packages.Wep_KVolt_3P"
	MuzzleFlashTemplateName="WEP_Laser_Cutter_ARCH.Wep_Laser_Cutter_MuzzleFlash_1P"

	HealingDartDamageType=class'KFDT_Dart_Healing'
	DartFireSnd=(DefaultCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_1P')
	LockAcquiredSoundFirstPerson=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Alert_Locked_1P'
	LockLostSoundFirstPerson=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Alert_Lost_1P'
	LockTargetingSoundFirstPerson=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Alert_Locking_1P'
    HealImpactSoundPlayEvent=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Heal'
    HurtImpactSoundPlayEvent=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Hurt'
	OpticsUIClass=class'KFGFxWorld_MedicOptics'
	HealingDartWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Default_Recoil'

	// Ammo
	MagazineCapacity[0]=50//33
	SpareAmmoCapacity[0]=450//495
	InitialSpareMags[0]=4
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=50
	minRecoilPitch=40
	maxRecoilYaw=80
	minRecoilYaw=-80
	RecoilRate=0.045
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=100
	RecoilISMinYawLimit=65435
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	IronSightMeshFOVCompensationScale=1.85
	WalkingRecoilModifier=1.1
	JoggingRecoilModifier=1.2

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Electricity'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
    WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_LazerCutter'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_KVolt'
	FireInterval(DEFAULT_FIREMODE)=+0.0857 // 700 RPM
	Spread(DEFAULT_FIREMODE)=0.015
	InstantHitDamage(DEFAULT_FIREMODE)=33
	FireOffset=(X=180,Y=27,Z=-30)//(X=30,Y=4.5,Z=-5)

	// ALTFIRE_FIREMODE
	AmmoCost(ALTFIRE_FIREMODE)=30
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_HealingDart_MedicBase'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Dart_Toxic'

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_KVolt'
	InstantHitDamage(BASH_FIREMODE)=26
	
	//@todo: add akevents when we have them
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue = AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_FullAuto_LP_3P', FirstPersonCue = AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_FullAuto_LP_1P')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_Single_3P', FirstPersonCue=AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_Single_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_MedicSMG.Play_SA_MedicSMG_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_DryFire'

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	//bLoopingFireAnim(ALTFIRE_FIREMODE)=true
	//bLoopingFireSnd(ALTFIRE_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue = AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_FullAuto_LP_End_3P', FirstPersonCue = AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_FullAuto_LP_End_1P')
	SingleFireSoundIndex=ALTFIRE_FIREMODE

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	AssociatedPerkClasses(0)=class'KFPerk_FieldMedic'
	AssociatedPerkClasses(1)=class'KFPerk_Swat'
	AssociatedPerkClasses(2)=class'KFPerk_Survivalist'

    // Weapon Upgrade stat boosts
    //WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
}
