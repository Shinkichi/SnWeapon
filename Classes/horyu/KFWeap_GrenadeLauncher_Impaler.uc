class KFWeap_GrenadeLauncher_Impaler extends KFWeap_GrenadeLauncher_Base;

/*********************************************************************************************
 Firing / Projectile - Below projectile spawning code copied from KFWeap_ShotgunBase
********************************************************************************************* */

/** Spawn projectile is called once for each shot pellet fired */
simulated function KFProjectile SpawnAllProjectiles(class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir)
{
	local KFPerk InstigatorPerk;

	if (CurrentFireMode == GRENADE_FIREMODE)
	{
		return Super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir);
	}

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != none)
	{
		Spread[CurrentFireMode] = default.Spread[CurrentFireMode] * InstigatorPerk.GetTightChokeModifier();
	}

	return super.SpawnAllProjectiles(KFProjClass, RealStartLoc, AimDir);
}

simulated function AltFireMode()
{
	if ( !Instigator.IsLocallyControlled() )
	{
		return;
	}

	StartFire(ALTFIRE_FIREMODE);
}

// Upgrade: Magazine Capacity
simulated function int GetUpgradedMagCapacity(optional int FireMode = DEFAULT_FIREMODE, optional int UpgradeIndex = INDEX_NONE)
{
}

simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, optional int FireMode = DEFAULT_FIREMODE, optional int UpgradeIndex = INDEX_NONE, optional KFPerk CurrentPerk)
{
}

defaultproperties
{
	ForceReloadTime=0.3f

	// Inventory
	InventoryGroup=IG_Primary
	GroupPriority=75
	InventorySize=6
	WeaponSelectTexture=Texture2D'WEP_UI_M79_TEX.UI_WeaponSelect_M79'

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=73

	// Zooming/Position
	PlayerViewOffset=(X=13.0,Y=13,Z=-4)
	FastZoomOutTime=0.2

	// Content
	PackageKey="Impaler"
	FirstPersonMeshName="WEP_1P_M79_MESH.Wep_1stP_M79_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_M79_ANIM.WEP_1P_M79_ANIM"
	PickupMeshName="WEP_3P_M79_MESH.Wep_m79_Pickup"
	AttachmentArchetypeName="WEP_M79_ARCH.Wep_M79_3P"
	MuzzleFlashTemplateName="WEP_M79_ARCH.Wep_M79_MuzzleFlash"

   	// Zooming/Position
	IronSightPosition=(X=0,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=1
	SpareAmmoCapacity[0]=26
	InitialSpareMags[0]=9
	AmmoPickupScale[0]=2.0
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=900
	minRecoilPitch=775
	maxRecoilYaw=500
	minRecoilYaw=-500
	RecoilRate=0.085
	RecoilBlendOutRatio=0.35
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1500
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.8
	FallingRecoilModifier=1.5
	HippedRecoilModifier=1.25

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Grenade'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFireAndReload
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Nail_Impaler'
	FireInterval(DEFAULT_FIREMODE)=+0.25
	InstantHitDamage(DEFAULT_FIREMODE)=50.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_ImpalerShards'
	PenetrationPower(DEFAULT_FIREMODE)=20//2.0
	Spread(DEFAULT_FIREMODE)=0.175
	NumPellets(DEFAULT_FIREMODE)=10
	FireOffset=(X=23,Y=4.0,Z=-3)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Grenade'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFireAndReload
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_ImpalerGrenade'
	FireInterval(ALTFIRE_FIREMODE)=+0.25
	InstantHitDamage(ALTFIRE_FIREMODE)=150.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_ImpalerImpact'
	Spread(ALTFIRE_FIREMODE)=0.015

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Impaler'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Fire_M', FirstPersonCue=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Fire_S')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Fire_M', FirstPersonCue=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Fire_S')

	//@todo: add akevent when we have it
	WeaponDryFireSnd(DEFAULT_FIREMODE)=none
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=none

	// Animation
	bHasFireLastAnims=true

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	AssociatedPerkClasses(0)=class'KFPerk_Support'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.12f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.3f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.55f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.12f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.55f), (Stat=EWUS_Weight, Add=3)))
}