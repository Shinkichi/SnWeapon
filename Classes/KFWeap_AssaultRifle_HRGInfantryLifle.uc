
class KFWeap_AssaultRifle_HRGInfantryLifle extends KFWeap_AssaultRifle_M16M203;

static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Rifle;
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Electric;
}

defaultproperties
{
	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron
	FireSightedAnims[2]=Shoot_Iron
	
	// Recoil
	RecoilRate=0.07
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=250
	RecoilISMinPitchLimit=65485

	// Ammo
	InitialSpareMags[0]	= 2//3 //2
	MagazineCapacity[0]	= 20//30
	SpareAmmoCapacity[0]= 160//180//270

    //grenades
	InitialSpareMags[1]	= 3//2
	MagazineCapacity[1]	= 1
	SpareAmmoCapacity[1]= 13 //9

	// Content
	PackageKey="HRG_InfantryLifle"
	FirstPersonMeshName="WEP_1P_HRG_IncendiaryRifle_MESH.WEP_1stP_HRG_IncendiaryRifle_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_HRG_IncendiaryRifle_ANIM.Wep_1stP_HRG_IncendiaryRifle_Anim"
	PickupMeshName="WEP_3P_HRG_IncendiaryRifle_MESH.Wep_HRG_IncendiaryRifle_Pickup"
	AttachmentArchetypeName="WEP_HRG_IncendiaryRifle_ARCH.Wep_HRG_IncendiaryRifle_3P_new"
	MuzzleFlashTemplateName="WEP_HRG_IncendiaryRifle_ARCH.Wep_HRG_IncendiaryRifle_MuzzleFlash"
	WeaponSelectTexture=Texture2D'WEP_UI_HRG_IncendiaryRifle_TEX.UI_WeaponSelect_HRG_IncendiaryRifle'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_HRG_Energy'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HRGInfantryLifle'
	PenetrationPower(DEFAULT_FIREMODE)=1.0
	FireInterval(DEFAULT_FIREMODE)=+0.175 //342 RPM
	Spread(DEFAULT_FIREMODE)=0.0085
	InstantHitDamage(DEFAULT_FIREMODE)=75//80 //90.0 //125.0
	FireOffset=(X=30,Y=4.5,Z=-5)
	SecondaryFireOffset=(X=20.f,Y=4.5,Z=-7.f)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=FiringSecondaryState
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Grenade_HRGInfantryLifle'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_HRGInfantryLifleGrenadeImpact'
	PenetrationPower(ALTFIRE_FIREMODE)=0
	FireInterval(ALTFIRE_FIREMODE)=+0.25f
	InstantHitDamage(ALTFIRE_FIREMODE)=333	//370 //185 //210 //250.0
	Spread(ALTFIRE_FIREMODE)=0.0085

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRGInfantryLifle'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'ww_wep_hrg_energy.Play_WEP_HRG_Energy_3P_Shoot', FirstPersonCue=AkEvent'ww_wep_hrg_energy.Play_WEP_HRG_Energy_1P_Shoot')
	//WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_IncendiaryRifle.Play_M16_Fire_3P_EndLoop', FirstPersonCue=AkEvent'WW_WEP_HRG_IncendiaryRifle.Play_M16_Fire_1P_EndLoop')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_Fire_1P')

	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_L85A2.Play_WEP_SA_L85A2_Handling_DryFire'

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=false
	bLoopingFireSnd(DEFAULT_FIREMODE)=false
	bHasIronSights=true
	
	// Perk
	AssociatedPerkClasses.Empty()
	AssociatedPerkClasses(0)=class'KFPerk_Survivalist'

	// Weapon Upgrade
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Damage1, Scale=1.2f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.4f), (Stat=EWUS_Weight, Add=2)))
}