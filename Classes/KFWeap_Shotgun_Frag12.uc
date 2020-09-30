// Frag12 Auto Shotgun - By Shinkichi 2020
class KFWeap_Shotgun_Frag12 extends KFWeap_ShotgunBase;

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Explosive;
}


defaultproperties
{
	// Inventory
	InventorySize=10
	GroupPriority=100
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_AA12'

	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

     // FOV
 	MeshFOV=86
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=85
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=15.0,Y=8.5,Z=0.0)
	IronSightPosition=(X=8,Y=0,Z=0)

	// Content
	PackageKey="Frag12"
	FirstPersonMeshName="Wep_1P_AA12_MESH.Wep_1stP_AA12_Rig"
	FirstPersonAnimSetNames(0)="Wep_1P_AA12_ANIM.Wep_1stP_AA12_Anim"
	PickupMeshName="WEP_3P_AA12_MESH.Wep_AA12_Pickup"
	AttachmentArchetypeName="WEP_AA12_ARCH.Wep_AA12_3P"
	MuzzleFlashTemplateName="WEP_AA12_ARCH.Wep_AA12_MuzzleFlash"

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Frag12_Fireball'
	InstantHitDamage(DEFAULT_FIREMODE)=30.0//125
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Explosive_Frag12Impact'
	Spread(DEFAULT_FIREMODE) = 0.0085
	FireOffset=(X=25,Y=3.5,Z=-4)
	FireInterval(DEFAULT_FIREMODE)=0.2 // 300 RPM
	// Shotgun
	NumPellets(DEFAULT_FIREMODE)=1

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Frag12_Fireball'
	InstantHitDamage(ALTFIRE_FIREMODE)=30.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Explosive_Frag12Impact'
	Spread(ALTFIRE_FIREMODE)=0.0085
	FireInterval(ALTFIRE_FIREMODE)=0.2 // 300 RPM
	// Shotgun
	NumPellets(ALTFIRE_FIREMODE)=1

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Frag12'
	InstantHitDamage(BASH_FIREMODE)=30

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Fire_1P')
    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Fire_1P')

	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Handling_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Ammo
	MagazineCapacity[0]=20
	SpareAmmoCapacity[0]=120
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true
	bHasFireLastAnims=false

	// Recoil
	maxRecoilPitch=250
	minRecoilPitch=225
	maxRecoilYaw=125
	minRecoilYaw=-125
	RecoilRate=0.075
	RecoilBlendOutRatio=0.25
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.7
	FallingRecoilModifier=1.5
	HippedRecoilModifier=1.75
    
   	AssociatedPerkClasses(0)=class'KFPerk_Demolitionist'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
}