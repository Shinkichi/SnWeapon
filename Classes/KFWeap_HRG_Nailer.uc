class KFWeap_HRG_Nailer extends KFWeap_ShotgunBase;

simulated function NotifyAltFireUsage()
{
	local KFPawn_Human KFPH;

	// Notify 3P to change material.
	KFPH = KFPawn_Human(Instigator);
	if (KFPH != none)
	{
		KFPH.SetUsingAltFireMode(bUseAltFireMode, true);
		KFPH.bNetDirty = true;
	}
}

defaultproperties
{
	// Inventory
	InventorySize=7 //6
	GroupPriority=100
	WeaponSelectTexture=Texture2D'wep_ui_hrg_stunner_tex.UI_Weapon_Select_HRG_Stunner'

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
	PackageKey="HRG_Nailer"
	FirstPersonMeshName="Wep_1P_HRG_Stunner_MESH.Wep_1stP_HRG_Stunner_Rig"
	FirstPersonAnimSetNames(0)="Wep_1P_HRG_Stunner_ANIM.Wep_1stP_HRG_Stunner_Anim"
	PickupMeshName="WEP_3P_HRG_Stunner_MESH.Wep_HRG_Stunner_Pickup"
	AttachmentArchetypeName="WEP_HRG_Stunner_ARCH.Wep_AA12_3P"
	MuzzleFlashTemplateName="WEP_HRG_Stunner_ARCH.Wep_AA12_MuzzleFlash"

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_NailsBurst'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_HRG_Nailer'
	InstantHitDamage(DEFAULT_FIREMODE)=50//60.0 //65.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HRG_Nailer'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireInterval(DEFAULT_FIREMODE)=0.15
	Spread(DEFAULT_FIREMODE)=0.005
	FireOffset=(X=30,Y=5,Z=-4)
	// Shotgun
	NumPellets(DEFAULT_FIREMODE)=1

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Nail'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_HRG_Nailer'
	InstantHitDamage(ALTFIRE_FIREMODE)=50//60.0 //65.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_HRG_Nailer'
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	FireInterval(ALTFIRE_FIREMODE)=0.15
	Spread(ALTFIRE_FIREMODE)=0.005

	// Shotgun
	NumPellets(ALTFIRE_FIREMODE)=1

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRG_Stunner'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	//WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Fire_1P')
    //WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Alt_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Alt_Fire_1P')
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_Nailgun.Play_WEP_SA_Nailgun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_Nailgun.Play_WEP_SA_Nailgun_Fire_1P')
    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_Nailgun.Play_WEP_SA_Nailgun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_Nailgun.Play_WEP_SA_Nailgun_Fire_1P')
    
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Dry_Fire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Dry_Fire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Ammo
	MagazineCapacity[0]=40//32//25
	SpareAmmoCapacity[0]=360//288//225 //250
	InitialSpareMags[0]=1
	bCanBeReloaded=true
	bReloadFromMagazine=true
	bHasFireLastAnims=false

	// Recoil
	maxRecoilPitch=150
	minRecoilPitch=125
	maxRecoilYaw=75
	minRecoilYaw=-75
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
    
	AssociatedPerkClasses(0)=class'KFPerk_Commando'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
}