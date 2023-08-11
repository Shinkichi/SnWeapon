class KFWeap_HRG_Electro_Dual extends KFWeap_Revolver_DualSW500;

var(Animations) const editconst array<name> FireSightedAnims_Alt;

simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, optional int FireMode = DEFAULT_FIREMODE, optional int UpgradeIndex = INDEX_NONE, optional KFPerk CurrentPerk)
{
}

/* ********************************************************************************************* */

/** Get name of the animation to play for PlayFireEffects
  *
  * Overridden to allow for left weapon anims and multiple FireSightedAnim_Alts
  */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	local bool bPlayFireLast;

	bPlayFireLast = ShouldPlayFireLast(FireModeNum);

	if (bFireFromRightWeapon && bUsingSights && !bPlayFireLast)
	{
		return bUseAltFireMode ? FireSightedAnims_Alt[Rand(FireSightedAnims_Alt.Length)] : FireSightedAnims[Rand(LeftFireSightedAnims.Length)];
	}

	return super.GetWeaponFireAnim(FireModeNum);
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Electric;
}

defaultproperties
{
	// Inventory
	InventorySize=4
	GroupPriority=75

	// Recoil
	maxRecoilPitch=525 //750
	minRecoilPitch=472 //675
	maxRecoilYaw=300
	minRecoilYaw=-300
	RecoilRate=0.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	IronSightMeshFOVCompensationScale=1.4

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)="ui_firemodes_tex.UI_FireModeSelect_Electricity"
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_HRG_Electro'
	InstantHitDamage(DEFAULT_FIREMODE)=32.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HRG_Electro'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	NumPellets(DEFAULT_FIREMODE)=3//5
	Spread(DEFAULT_FIREMODE)=0.12 //0.15

	// ALTFIRE_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)="ui_firemodes_tex.UI_FireModeSelect_Electricity"
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_HRG_Electro'
	InstantHitDamage(ALTFIRE_FIREMODE)=32.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_HRG_Electro'
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	NumPellets(ALTFIRE_FIREMODE)=3//5
	Spread(ALTFIRE_FIREMODE)=0.12 //0.15

	//BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRG_Electro'

	AssociatedPerkClasses.Empty()
	AssociatedPerkClasses(0)=class'KFPerk_Gunslinger'
	AssociatedPerkClasses(1)=class'KFPerk_Support'

	// Recoil
	RecoilBlendOutRatio=0.35

	//Ammunition
	SpareAmmoCapacity[0]=110//80
	InitialSpareMags[0]=3//2

	WeaponSelectTexture=Texture2D'WEP_UI_Dual_HRG_SW_500_TEX.UI_WeaponSelect_HRG_DualSW500'

	//Weapon Upgrades
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=4)))

	FireAnim=HRG_Shoot_RW
	LeftFireAnim=HRG_Shoot_LW

	FireLastAnim=HRG_Shoot_RW_Last
	LeftFireLastAnim=HRG_Shoot_LW_Last

	FireSightedAnims_Alt=(HRG_Shoot_Iron_RW, HRG_Shoot_Iron2_RW, HRG_Shoot_Iron3_RW)
	LeftFireSightedAnim_Alt=HRG_Shoot_Iron_LW

	FireLastSightedAnim_Alt=HRG_Shoot_Iron_RW_Last
	LeftFireLastSightedAnim_Alt=HRG_Shoot_Iron_LW_Last

	FireSightedAnims=(HRG_Shoot_IronOG_RW, HRG_Shoot_IronOG2_RW, HRG_Shoot_IronOG3_RW)
	LeftFireSightedAnims=(HRG_Shoot_IronOG_LW)

	FireLastSightedAnim=HRG_Shoot_IronOG_RW_Last
	LeftFireLastSightedAnim=HRG_Shoot_IronOG_LW_Last

	SingleClass=class'KFWeap_HRG_Electro'

	// Content
	PackageKey="HRG_Electro_Dual"
	FirstPersonMeshName="wep_1p_dual_hrg_sw_500_mesh.Wep_1st_Dual_HRG_SW_500_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_dual_hrg_sw_500_anim.Wep_1stP_Dual_HRG_SW_500_Anim"
	PickupMeshName="WEP_3P_HRG_SW_500_MESH.Wep_3rdP_HRG_SW_500_Pickup"
	AttachmentArchetypeName="WEP_Dual_HRG_SW_500_ARCH.Wep_Dual_HRG_SW_500_3P"
	MuzzleFlashTemplateName="WEP_Dual_HRG_SW_500_ARCH.Wep_Dual_HRG_SW_500_MuzzleFlash"

	//Weapon Sounds
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_HRG_Buckshot_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_HRG_Buckshot_Fire_1P')
    WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_SW500.Play_WEP_HRG_Buckshot_Fire_DryFire'

    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_HRG_Buckshot_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_SW500.Play_WEP_HRG_Buckshot_Fire_1P')
    WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_SW500.Play_WEP_HRG_Buckshot_Fire_DryFire'

    // Revolver shell/cap replacement
	UnusedBulletMeshTemplate=SkeletalMesh'wep_3p_hrg_sw_500_mesh.Wep_3rdP_HRG_SW_500_Bullet'
	UsedBulletMeshTemplate=SkeletalMesh'wep_3p_hrg_sw_500_mesh.Wep_3rdP_HRG_SW_500_EmptyShell'
	BulletFXSocketNames=(RW_Bullet_FX_5, LW_Bullet_FX_5, RW_Bullet_FX_4, LW_Bullet_FX_4, RW_Bullet_FX_3, LW_Bullet_FX_3, RW_Bullet_FX_2, LW_Bullet_FX_2, RW_Bullet_FX_1, LW_Bullet_FX_1)


}