class KFWeap_Pistol_DualHRGVitamin extends KFWeap_DualBase;

/*********************************************************************************************
 * @name Healing Darts
 ********************************************************************************************* */
/** DamageTypes for Instant Hit Weapons */
var	class<DamageType>   HealingDartDamageType;

/** How much to heal for when using this weapon */
var(Healing) int		HealAmount;

/**
 * See Pawn.ProcessInstantHit
 * @param DamageReduction: Custom KF parameter to handle penetration damage reduction
 */
simulated function ProcessInstantHitEx( byte FiringMode, ImpactInfo Impact, optional int NumHits, optional out float out_PenetrationVal, optional int ImpactNum )
{
    local KFPawn HealTarget;
    local KFPlayerController Healer;
	local KFPerk InstigatorPerk;
	local float AdjustedHealAmount;

    HealTarget = KFPawn(Impact.HitActor);
    Healer = KFPlayerController(Instigator.Controller);

	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none )
	{
		InstigatorPerk.UpdatePerkHeadShots( Impact, InstantHitDamageTypes[FiringMode], ImpactNum );
	}

	if (FiringMode == ALTFIRE_FIREMODE && HealTarget != none && WorldInfo.GRI.OnSameTeam(Instigator,HealTarget) )
	{
        // Let the accuracy system know that we hit someone
		if( Healer != none )
		{
            Healer.AddShotsHit(1);
		}

		AdjustedHealAmount = HealAmount * static.GetUpgradeHealMod(CurrentWeaponUpgradeIndex);
    	HealTarget.HealDamage(AdjustedHealAmount, Instigator.Controller, HealingDartDamageType);

        // Play a healed impact sound for the healee
        /*if( HealImpactSoundPlayEvent != None && HealTarget != None && !bSuppressSounds  )
    	{
    	    HealTarget.PlaySoundBase(HealImpactSoundPlayEvent, false, false,,Impact.HitLocation);
    	}*/
	}
	else
	{
        // Play a hurt impact sound for the hurt
        /*if( HurtImpactSoundPlayEvent != None && HealTarget != None && !bSuppressSounds  )
    	{
    	    HealTarget.PlaySoundBase(HurtImpactSoundPlayEvent, false, false,,Impact.HitLocation);
    	}*/
        Super.ProcessInstantHitEx(FiringMode, Impact, NumHits, out_PenetrationVal);
	}
}

defaultproperties
{
	// Healing charge
    HealAmount=20
	HealingDartDamageType=class'KFDT_Dart_Healing'
	
	//Content
	PackageKey="dual_Vitamin"
	FirstPersonMeshName="wep_1p_dual_winterbite_mesh.Wep_1stP_Dual_Winterbite_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_dual_Winterbite_anim.Wep_1stP_Dual_Winterbite_Anim"
	PickupMeshName="WEP_3P_HRG_Winterbite_MESH.Wep_HRG_Winterbite_Pickup"
	AttachmentArchetypeName="wep_dual_winterbite_arch.Wep_Dual_Winterbite_3P"
	MuzzleFlashTemplateName="wep_dual_winterbite_arch.Wep_Winterbite_MuzzleFlash"

	Begin Object Name=FirstPersonMesh
		AnimTreeTemplate=AnimTree'CHR_1P_Arms_ARCH.WEP_1stP_Dual_Animtree_Master_Revolver'
	End Object

	FireOffset=(X=17,Y=4.0,Z=-2.25)
	LeftFireOffset=(X=17,Y=-4,Z=-2.25)

	// Position and FOV
	IronSightPosition=(X=4,Y=0,Z=0)
	PlayerViewOffset=(X=23,Y=0,Z=-1)
	QuickWeaponDownRotation=(Pitch=-8192,Yaw=0,Roll=0)
	MeshFOV=60
	MeshIronSightFOV=55
    PlayerIronSightFOV=77

	// Depth of field
	DOF_FG_FocalRadius=40
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=24//12 // twice as much as single
	SpareAmmoCapacity[0]=144
	InitialSpareMags[0]=4
	AmmoPickupScale[0]=1.0
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=400
	minRecoilPitch=350
	maxRecoilYaw=125
	minRecoilYaw=-125
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=400
	RecoilISMinPitchLimit=65485
	RecoilBlendOutRatio=0.75
	IronSightMeshFOVCompensationScale=1.5

	// DEFAULT_FIREMODE
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_HealingDart_MedicBase'
	FireInterval(DEFAULT_FIREMODE)=+0.11 // about twice as fast as single
	InstantHitDamage(DEFAULT_FIREMODE)=49 //40.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Toxic_HRGVitaminImpact'
	Spread(DEFAULT_FIREMODE)=0.09//0.009 //0.015
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_MedicDart'

	// ALTFIRE_FIREMODE
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_HealingDart_MedicBase'
	FireInterval(ALTFIRE_FIREMODE)=+0.11 // about twice as fast as single
	InstantHitDamage(ALTFIRE_FIREMODE)=49 //40.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Toxic_HRGVitaminImpact'
	Spread(ALTFIRE_FIREMODE)=0.09//00.009 //0.015
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_MedicDart'

	// BASH_FIREMODE
	InstantHitDamage(BASH_FIREMODE)=24.0
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRGVitamin'

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_DryFire'

	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_1P')
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_DryFire'

	// Inventory
	InventorySize=4
	GroupPriority=35
	WeaponSelectTexture=Texture2D'WEP_UI_Dual_Winterbite_Item_TEX.UI_WeaponSelect_HRG_DualWinterbite'
	bIsBackupWeapon=false
	bCanThrow=true
	bDropOnDeath=true
	SingleClass=class'KFWeap_Pistol_HRGVitamin'
    AssociatedPerkClasses(0)=class'KFPerk_FieldMedic'
    AssociatedPerkClasses(1)=class'KFPerk_Gunslinger'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	// Hammer lock control
	bHasFireLastAnims=true
	BonesToLockOnEmpty=(RW_Hammer)
	BonesToLockOnEmpty_L=(LW_Hammer)

	// Revolver
	bRevolver=true
	CylinderRotInfo=(Inc=-60.0, Time=0.0875/*about 0.35 in the anim divided by ratescale of 4*/)
	CylinderRotInfo_L=(Inc=-60.0, Time=0.0875/*about 0.35 in the anim divided by ratescale of 4*/)

	// Weapon Upgrade stat boosts
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.4f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.8f), (Stat=EWUS_Damage1, Scale=1.8f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=2.0f), (Stat=EWUS_Damage1, Scale=2.0f), (Stat=EWUS_Weight, Add=4)))
}

