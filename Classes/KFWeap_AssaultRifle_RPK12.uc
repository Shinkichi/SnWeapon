
class KFWeap_AssaultRifle_RPK12 extends KFWeap_RifleBase;

defaultproperties
{
	// FOV
	MeshFOV=75
	MeshIronSightFOV=33
	PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=50
	DOF_FG_SharpRadius=0
	DOF_FG_MinBlurSize=0
	DOF_FG_MaxNearBlurSize=3
	DOF_FG_ExpFalloff=1

	// Zooming/Position
	PlayerViewOffset=(X=2.0,Y=8,Z=-3)

	// Content
	PackageKey="RPK12"
	FirstPersonMeshName="WEP_1P_AK12_MESH.Wep_1stP_AK12_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_AK12_ANIM.Wep_1st_AK12_Anim"
	PickupMeshName="WEP_3P_AK12_MESH.Wep_AK12_Pickup"
	AttachmentArchetypeName="WEP_AK12_ARCH.Wep_AK12_3P"
	MuzzleFlashTemplateName="WEP_AK12_ARCH.Wep_AK12_MuzzleFlash"

	// Ammo
	MagazineCapacity[0]=40//30
	SpareAmmoCapacity[0]=400//300
	InitialSpareMags[0]=3
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=150
	minRecoilPitch=115
	maxRecoilYaw=115
	minRecoilYaw=-115
	RecoilRate=0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	IronSightMeshFOVCompensationScale=2.5

	// Inventory / Grouping
	InventorySize=6
	GroupPriority=75
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_AK12'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_AssaultRifle'
	FireInterval(DEFAULT_FIREMODE)=+0.0909 // 660 RPM
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_RPK12'
	Spread(DEFAULT_FIREMODE)=0.0085
	InstantHitDamage(DEFAULT_FIREMODE)=30.0 //25
	FireOffset=(X=32,Y=4.0,Z=-5)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_AssaultRifle'
	FireInterval(ALTFIRE_FIREMODE)=+0.1
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_RPK12'
	InstantHitDamage(ALTFIRE_FIREMODE)=30.0 //25
	Spread(ALTFIRE_FIREMODE)=0.0085

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_RPK12'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Fire_Loop_M', FirstPersonCue=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Fire_Loop_S')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Fire_Single_M', FirstPersonCue=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Fire_Single_S')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_AK12.Play_WEP_SA_AK12_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_AK12.Play_WEP_SA_AK12_Handling_DryFire'


	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Fire_Loop_End_M', FirstPersonCue=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Fire_Loop_End_S')
	SingleFireSoundIndex=ALTFIRE_FIREMODE

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	AssociatedPerkClasses(0)=class'KFPerk_Commando'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.3f,IncrementWeight=2)
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
}



