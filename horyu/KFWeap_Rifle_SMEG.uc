class KFWeap_Rifle_SMEG extends KFWeap_MedicBase;

/** Returns trader filter index based on weapon type (copied from riflebase) */
static simulated event EFilterTypeUI GetTraderFilter()
{
    return FT_Projectile;
}

simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, optional int FireMode = DEFAULT_FIREMODE, optional int UpgradeIndex = INDEX_NONE, optional KFPerk CurrentPerk)
{
	if (FireMode == BASH_FIREMODE)
	{
		return;
	}
	
	InMagazineCapacity = GetUpgradedMagCapacity(FireMode, UpgradeIndex);

	/*if (CurrentPerk == none)
	{
		CurrentPerk = GetPerk();
	}

	if (CurrentPerk != none)
	{
		CurrentPerk.ModifyMagSizeAndNumber(self, InMagazineCapacity, AssociatedPerkClasses, FireMode == ALTFIRE_FIREMODE, Class.Name);
	}*/
}

/*********************************************************************************************
 * @name	Tick/Update
 *********************************************************************************************/

simulated event Tick( float DeltaTime )
{
	if( LaserSight != None )
	{
		LaserSight.Update(DeltaTime, self);
	}
}

/**
 * @see Weapon::StartFire
 */
simulated function StartFire(byte FireModeNum)
{
	if (MedicComp != none)
	{
		if (!MedicComp.ShouldStartFire(FireModeNum))
		{
			return;
		}
	}

	// Attempt auto-reload
	if( FireModeNum == DEFAULT_FIREMODE || FireModeNum == ALTFIRE_FIREMODE )
	{
		if ( ShouldAutoReload(FireModeNum) )
		{
			FireModeNum = RELOAD_FIREMODE;
		}
	}

	// Convert to altfire if we have alt fire mode active
	if (FireModeNum == DEFAULT_FIREMODE)
	{
		bStopAltFireOnNextRelease = false;
		if (bUseAltFireMode && !bGamepadFireEntry)
		{
			FireModeNum = ALTFIRE_FIREMODE;
			bStopAltFireOnNextRelease = true;
		}
	}

	if ( FireModeNum == RELOAD_FIREMODE )
	{
		// Skip Super/ ServerStartFire and let server wait for ServerSendToReload to force state synchronization
		BeginFire(FireModeNum);
		return;
	}

	Super.StartFire(FireModeNum);
}

/** Start the heal recharge cycle */
function StartHealRecharge()
{
}

/** Heal Ammo Regen */
function HealAmmoRegeneration(float DeltaTime)
{
}

/**
 * @see Weapon::ConsumeAmmo
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
    local byte AmmoType;
    local KFPerk InstigatorPerk;

`if(`notdefined(ShippingPC))
    if( bInfiniteAmmo )
    {
        return;
    }
`endif

	AmmoType = GetAmmoType(FireModeNum);

	InstigatorPerk = GetPerk();
	if( InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive( self ) )
	{
		return;
	}

	// If AmmoCount is being replicated, don't allow the client to modify it here
	if ( Role == ROLE_Authority || bAllowClientAmmoTracking )
	{
	    // Don't consume ammo if magazine size is 0 (infinite ammo with no reload)
		if (MagazineCapacity[AmmoType] > 0 && AmmoCount[AmmoType] > 0)
		{
			// Ammo cost needs to be firemodenum because it is independent of ammo type.
			AmmoCount[AmmoType] = Max(AmmoCount[AmmoType] - AmmoCost[FireModeNum], 0);
		}
	}
}

/** Determines the secondary ammo left for HUD display */
simulated function int GetSecondaryAmmoForHUD()
{
    return AmmoCount[1] + SpareAmmoCount[1];
}

/**
* See Pawn.ProcessInstantHit
* @param DamageReduction: Custom KF parameter to handle penetration damage reduction
*/
simulated function ProcessInstantHitEx(byte FiringMode, ImpactInfo Impact, optional int NumHits, optional out float out_PenetrationVal, optional int ImpactNum)
{
    local KFPerk InstigatorPerk;

    InstigatorPerk = GetPerk();
    if (InstigatorPerk != none)
    {
        InstigatorPerk.UpdatePerkHeadShots(Impact, InstantHitDamageTypes[FiringMode], ImpactNum);
    }

    super.ProcessInstantHitEx(FiringMode, Impact, NumHits, out_PenetrationVal, ImpactNum);
}

defaultproperties
{
    // Inventory / Grouping
    InventorySize=7
    GroupPriority=75
    WeaponSelectTexture=Texture2D'WEP_UI_Bleeder_TEX.UI_WeaponSelect_Bleeder'
    SecondaryAmmoTexture=Texture2D'UI_SecondaryAmmo_TEX.MedicDarts'
    AssociatedPerkClasses(0)=class'KFPerk_Support'

    // FOV
    MeshFOV=70
    MeshIronSightFOV=27
    PlayerIronSightFOV=70

    // Depth of field
    DOF_BlendInSpeed=3.0
    DOF_FG_FocalRadius=0//70
    DOF_FG_MaxNearBlurSize=3.5

	// Content
	PackageKey="SMEG"
	FirstPersonMeshName="WEP_1P_Bleeder_MESH.WEP_1stP_Bleeder_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Bleeder_ANIM.Wep_1stP_Bleeder_Anim"
	PickupMeshName="wep_3p_bleeder_mesh.Wep_3rdP_Bleeder_Pickup"
    AttachmentArchetypeName="WEP_Bleeder_ARCH.Wep_Bleeder_3P"
	MuzzleFlashTemplateName="WEP_Bleeder_ARCH.Wep_Bleeder_MuzzleFlash"

	OpticsUIClass=class'KFGFxWorld_MedicOptics'

    LaserSightTemplate=KFLaserSightAttachment'FX_LaserSight_ARCH.LaserSight_WithAttachment_1P'

    // Ammo
    MagazineCapacity[0]=7
    SpareAmmoCapacity[0]=98
    InitialSpareMags[0]=4
    bCanBeReloaded=true
    bReloadFromMagazine=true

    // Zooming/Position
    PlayerViewOffset=(X=20.0,Y=11.0,Z=-2) //(X=15.0,Y=11.5,Z=-4)
    IronSightPosition=(X=30.0,Y=0,Z=0)

    // AI warning system
    bWarnAIWhenAiming=true
    AimWarningDelay=(X=0.4f, Y=0.8f)
    AimWarningCooldown=0.0f

    // Recoil
    maxRecoilPitch=225
    minRecoilPitch=200
    maxRecoilYaw=200
    minRecoilYaw=-200
    RecoilRate=0.08
    RecoilMaxYawLimit=500
    RecoilMinYawLimit=65035
    RecoilMaxPitchLimit=900
    RecoilMinPitchLimit=65035
    RecoilISMaxYawLimit=150
    RecoilISMinYawLimit=65385
    RecoilISMaxPitchLimit=375
    RecoilISMinPitchLimit=65460
    RecoilViewRotationScale=0.6

    // DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Nail_Blunderbuss'
    FireInterval(DEFAULT_FIREMODE)=0.25
	InstantHitDamage(DEFAULT_FIREMODE)=50.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_BlunderbussShards'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	Spread(DEFAULT_FIREMODE)=0.175
	NumPellets(DEFAULT_FIREMODE)=5//10
    FireOffset=(X=30,Y=3.0,Z=-2.5)

	// ALT_FIREMODE
    FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
    FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
    WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
    WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Explosive_SMEG'
    InstantHitDamage(ALTFIRE_FIREMODE)=100.0
    InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_SMEG'
    FireInterval(ALTFIRE_FIREMODE)=0.50//0.25
	AmmoCost(ALTFIRE_FIREMODE)=7
    PenetrationPower(ALTFIRE_FIREMODE)=0.0 //2.0
	Spread(ALTFIRE_FIREMODE)=0.175
	NumPellets(ALTFIRE_FIREMODE)=7
    
	MagazineCapacity[1]=0
	HealingDartAmmo=0
   
    // BASH_FIREMODE
    InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_SMEG'
    InstantHitDamage(BASH_FIREMODE)=27

    // Fire Effects
    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Bleeder.Play_WEP_Bleeder_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_Bleeder.Play_WEP_Bleeder_Fire_1P')  //@TODO: Replace
    WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_EBR.Play_WEP_SA_EBR_Handling_DryFire'  //@TODO: Replace
    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Bleeder.Play_WEP_Bleeder_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_Bleeder.Play_WEP_Bleeder_Fire_1P')  //@TODO: Replace
    WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_EBR.Play_WEP_SA_EBR_Handling_DryFire'  //@TODO: Replace
   

    // Custom animations
    FireSightedAnims=(Shoot_Iron, Shoot_Iron2, Shoot_Iron3)

    // Attachments
    bHasIronSights=true
    bHasFlashlight=false
    bHasLaserSight=false

    WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil'

    //WeaponUpgrades[1]=(IncrementDamage=1.4f,IncrementWeight=1, IncrementHealFullRecharge=.8)
    //WeaponUpgrades[2]=(IncrementDamage=1.8f,IncrementWeight=2, IncrementHealFullRecharge=.6)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Weight, Add=1), (Stat=EWUS_HealFullRecharge, Scale=0.9f)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Weight, Add=2), (Stat=EWUS_HealFullRecharge, Scale=0.8f)))
}