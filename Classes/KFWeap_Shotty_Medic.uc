class KFWeap_Shotty_Medic extends KFWeap_MedicBase;

/*********************************************************************************************
 * @name	Trader
 *********************************************************************************************/

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Pistol;
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Shotgun;
}

/*********************************************************************************************
 Firing / Projectile - Below projectile spawning code copied from KFWeap_ShotgunBase
********************************************************************************************* */

/** Spawn projectile is called once for each shot pellet fired */
simulated function KFProjectile SpawnAllProjectiles( class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir )
{
	local KFPerk InstigatorPerk;

    if( CurrentFireMode == GRENADE_FIREMODE )
    {
        return Super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir);
    }

    InstigatorPerk = GetPerk();
    if( InstigatorPerk != none )
    {
    	Spread[CurrentFireMode] = default.Spread[CurrentFireMode] * InstigatorPerk.GetTightChokeModifier();
    }

	return super.SpawnAllProjectiles(KFProjClass, RealStartLoc, AimDir);
}

/** Disable normal bullet spread */
simulated function rotator AddSpread(rotator BaseAim)
{
	return BaseAim; // do nothing
}

defaultproperties
{

	// Healing charge
    HealAmount=15

	// Inventory
	InventoryGroup=IG_Secondary
	InventorySize=2//1
	GroupPriority=25
	bCanThrow=true
	bDropOnDeath=true
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_MedicPistol'
	SecondaryAmmoTexture=Texture2D'UI_SecondaryAmmo_TEX.MedicDarts'

	// Shooting Animations
	FireSightedAnims[0]=Shoot_Iron
	FireSightedAnims[1]=Shoot_Iron2
	FireSightedAnims[2]=Shoot_Iron3

    // FOV
	MeshFOV=86
	MeshIronSightFOV=77
    PlayerIronSightFOV=77

	// Depth of field
	DOF_FG_FocalRadius=40
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=29.0,Y=13,Z=-4)

	//Content
	PackageKey="Medic_Shotty"
	FirstPersonMeshName="WEP_1P_Medic_Pistol_MESH.Wep_1stP_Medic_Pistol_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Medic_Pistol_ANIM.WEP_1P_Medic_Pistol_ANIM"
	PickupMeshName="wep_3p_medic_pistol_mesh.Wep_Medic_Pistol_Pickup"
	//AttachmentArchetypeName="WEP_Medic_Pistol_ARCH.Wep_Medic_Pistol_3P"
	AttachmentArchetypeName="SnWeapon_Packages.Wep_Medic_Shotty_3P"
	MuzzleFlashTemplateName="WEP_Medic_Pistol_ARCH.Wep_Medic_Pistol_MuzzleFlash"

	HealingDartDamageType=class'KFDT_Dart_Healing'
	DartFireSnd=(DefaultCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_1P')
	LockAcquiredSoundFirstPerson=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Alert_Locked_1P'
	LockLostSoundFirstPerson=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Alert_Lost_1P'
	LockTargetingSoundFirstPerson=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Alert_Locking_1P'
    HealImpactSoundPlayEvent=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Heal'
    HurtImpactSoundPlayEvent=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Hurt'
	OpticsUIClass=class'KFGFxWorld_MedicOptics'
	HealingDartWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Default_Recoil'

   	// Zooming/Position
	IronSightPosition=(X=15,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=10//15
	SpareAmmoCapacity[0]=90//160//240
	InitialSpareMags[0]=4//8
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=400
	minRecoilPitch=375
	maxRecoilYaw=250
	minRecoilYaw=-250
	RecoilRate=0.075
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pellet'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireInterval(DEFAULT_FIREMODE)=0.2 //0.2  300 RPM
	InstantHitDamage(DEFAULT_FIREMODE)=20.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Shotty_Medic'
	NumPellets(DEFAULT_FIREMODE)=3//6
	Spread(DEFAULT_FIREMODE)=0.07
	FireOffset=(X=20,Y=4.0,Z=-3)

	// ALTFIRE_FIREMODE
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_HealingDart_MedicBase'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Dart_Toxic'

	// BASH_FIREMODE
	InstantHitDamage(BASH_FIREMODE)=21
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Shotty_Medic'

	AssociatedPerkClasses(0)=class'KFPerk_FieldMedic'
	AssociatedPerkClasses(1)=class'KFPerk_Support'
	AssociatedPerkClasses(2)=class'KFPerk_Gunslinger'
	
	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Stunner.Play_WEP_HRG_Stunner_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_MedicPistol.Play_SA_MedicPistol_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	//WeaponUpgrades[1]=(IncrementDamage=1.7f,IncrementWeight=0, IncrementHealFullRecharge=.9)
	//WeaponUpgrades[2]=(IncrementDamage=2.0f,IncrementWeight=1, IncrementHealFullRecharge=.8)
	//WeaponUpgrades[3]=(IncrementDamage=2.55f,IncrementWeight=2, IncrementHealFullRecharge=.7)
	//WeaponUpgrades[4]=(IncrementDamage=3.0f,IncrementWeight=3, IncrementHealFullRecharge=.6)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.7f), (Stat=EWUS_HealFullRecharge, Scale=0.9f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=2.0f), (Stat=EWUS_Weight, Add=1), (Stat=EWUS_HealFullRecharge, Scale=0.8f)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=2.55f), (Stat=EWUS_Weight, Add=2), (Stat=EWUS_HealFullRecharge, Scale=0.7f)))
	WeaponUpgrades[4]=(Stats=((Stat=EWUS_Damage0, Scale=3.0f), (Stat=EWUS_Weight, Add=3), (Stat=EWUS_HealFullRecharge, Scale=0.6f)))
}

