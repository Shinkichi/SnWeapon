
class KFWeap_Shotgun_Flechette extends KFWeap_ShotgunBase;

/*simulated function AltFireMode()
{
	if ( !Instigator.IsLocallyControlled() )
	{
		return;
	}

	StartFire(ALTFIRE_FIREMODE);
}*/


/**
 * See Pawn.ProcessInstantHit
 * @param DamageReduction: Custom KF parameter to handle penetration damage reduction
 */
simulated function ProcessInstantHitEx(byte FiringMode, ImpactInfo Impact, optional int NumHits, optional out float out_PenetrationVal, optional int ImpactNum )
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none )
	{
		InstigatorPerk.UpdatePerkHeadShots( Impact, InstantHitDamageTypes[FiringMode], ImpactNum );
	}
	
	super.ProcessInstantHitEx( FiringMode, Impact, NumHits, out_PenetrationVal, ImpactNum );
}

defaultproperties
{
	// Inventory
	InventorySize=5
	GroupPriority=25
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_Mossberg'

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=95
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=8.0,Y=8.0,Z=-3.5)
	IronSightPosition=(X=9.5,Y=0,Z=0)

	// Content
	PackageKey="Flechette"
	FirstPersonMeshName="WEP_1P_MB500_MESH.Wep_1stP_MB500_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_MB500_ANIM.Wep_1st_MB500_Anim_New"
	PickupMeshName="WEP_3P_MB500_MESH.Wep_MB500_Pickup"
	AttachmentArchetypeName="WEP_MB500_ARCH.Wep_MB500_3P"
	MuzzleFlashTemplateName="WEP_MB500_ARCH.Wep_MB500_MuzzleFlash"

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Nail'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Nail_Blunderbuss'
	InstantHitDamage(DEFAULT_FIREMODE)=180//140.0//20.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Flechette'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireInterval(DEFAULT_FIREMODE)=0.77 // 78 RPM
	NumPellets(DEFAULT_FIREMODE)=1
	Spread(DEFAULT_FIREMODE)=0.01 //0.02
	FireOffset=(X=30,Y=3,Z=-3)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)="ui_firemodes_tex.UI_FireModeSelect_NailsBurst"
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Nail_Blunderbuss'
	InstantHitDamage(ALTFIRE_FIREMODE)=36//20.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_Flechette_Secondary'
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	FireInterval(ALTFIRE_FIREMODE)=0.77 // 78 RPM
	NumPellets(ALTFIRE_FIREMODE)=5//7
	Spread(ALTFIRE_FIREMODE)=0.07
	
	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Flechette'
	InstantHitDamage(BASH_FIREMODE)=25

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_MB500.Play_WEP_SA_MB500_Fire_M', FirstPersonCue=AkEvent'WW_WEP_SA_MB500.Play_WEP_SA_MB500_Fire_S')
    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_MB500.Play_WEP_SA_MB500_Fire_M', FirstPersonCue=AkEvent'WW_WEP_SA_MB500.Play_WEP_SA_MB500_Fire_S')

    // using M4 dry fire sound. this is intentional.
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_M4.Play_WEP_SA_M4_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_M4.Play_WEP_SA_M4_Handling_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	// Ammo
	MagazineCapacity[0]=6//8
	SpareAmmoCapacity[0]=42//56
	InitialSpareMags[0]=3
	bCanBeReloaded=true
	bReloadFromMagazine=false

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

	AssociatedPerkClasses(0)=class'KFPerk_Support'
	//AssociatedPerkClasses(1)=class'KFPerk_Berserker'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.25f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.5f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.75f,IncrementWeight=3)
	//WeaponUpgrades[4]=(IncrementDamage=2.0f,IncrementWeight=4)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.5f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.75f), (Stat=EWUS_Weight, Add=3)))
	WeaponUpgrades[4]=(Stats=((Stat=EWUS_Damage0, Scale=2.0f), (Stat=EWUS_Weight, Add=4)))
}