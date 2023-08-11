class KFWeap_Pistol_HRGVitamin extends KFWeap_PistolBase;

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
	
	// Content
	PackageKey="HRG_Vitamin"
	FirstPersonMeshName="WEP_1P_HRG_Winterbite_MESH.Wep_1stP_HRG_Winterbite_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_HRG_Winterbite_anim.Wep_1stP_HRG_Winterbite_Anim"
	PickupMeshName="WEP_3P_HRG_Winterbite_MESH.Wep_HRG_Winterbite_Pickup"
	AttachmentArchetypeName="WEP_HRG_Winterbite_ARCH.Wep_HRG_Winterbite_3P"
	MuzzleFlashTemplateName="WEP_HRG_Winterbite_ARCH.Wep_HRG_Winterbite_MuzzleFlash"

	Begin Object Name=FirstPersonMesh
		AnimTreeTemplate=AnimTree'CHR_1P_Arms_ARCH.WEP_1stP_Animtree_Master_Revolver'
	End Object

   	// Position and FOV
   	PlayerViewOffset=(X=15.0,Y=14,Z=-6)
	IronSightPosition=(X=4,Y=0,Z=0)
	MeshFOV=60
	MeshIronSightFOV=55
    PlayerIronSightFOV=77

   	// Depth of field
	DOF_FG_FocalRadius=40
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=12//6
	SpareAmmoCapacity[0]=150
	InitialSpareMags[0]=9
	AmmoPickupScale[0]=2.0
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
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_MedicDart'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_HealingDart_MedicBase'
	FireInterval(DEFAULT_FIREMODE)=+0.2
	InstantHitDamage(DEFAULT_FIREMODE)=49 //40.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Toxic_HRGVitaminImpact'
	Spread(DEFAULT_FIREMODE)=0.09//0.009 //0.015
	FireOffset=(X=20,Y=4.0,Z=-3)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_MedicDart'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_None

	// BASH_FIREMODE
	InstantHitDamage(BASH_FIREMODE)=24
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRGVitamin'

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_MedicDart.Play_WEP_SA_Medic_Dart_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_DryFire'

	// Inventory
	InventorySize=2
	GroupPriority=15
	bCanThrow=true
	bDropOnDeath=true
	WeaponSelectTexture=Texture2D'WEP_UI_HRG_Winterbite_Item_TEX.UI_WeaponSelect_HRG_Winterbite'
	bIsBackupWeapon=false
	DualClass=class'KFWeap_Pistol_DualHRGVitamin'
    AssociatedPerkClasses(0)=class'KFPerk_FieldMedic'
    AssociatedPerkClasses(1)=class'KFPerk_Gunslinger'
   
	// Attachments
	bHasIronSights=true
	bHasFlashlight=true

	// Hammer lock control
	bHasFireLastAnims = true
	BonesToLockOnEmpty = (RW_Hammer)

	// Revolver
	bRevolver=true
	CylinderRotInfo=(Inc=-60.0, Time=0.0175/*about 0.07 in the anim divided by ratescale of 4*/)

	// Weapon Upgrade stat boosts
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.8f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=2.0f), (Stat=EWUS_Weight, Add=2)))
}

