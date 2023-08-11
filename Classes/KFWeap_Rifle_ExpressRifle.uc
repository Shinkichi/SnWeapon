
class KFWeap_Rifle_ExpressRifle extends KFWeap_ShotgunBase;

/** How much to scale recoil when firing in double barrel fire. */
var(Recoil) float QuadFireRecoilModifier;

/** Shoot animation to play when shooting both barrels from the hip */
var(Animations) const editconst	name	FireQuadAnim;

/** How much momentum to apply when fired in double barrel */
var(Recoil) float DoubleBarrelKickMomentum;

/** How much to reduce shoot momentum when falling */
var(Recoil) float FallingMomentumReduction;

/** Reduction for the amount of damage dealt to the weapon owner (including damage by the explosion) */
var float SelfDamageReductionValue;

// Reduce damage to self
function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super.AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != none && DamageCauser != none && DamageCauser.Instigator == Instigator)
	{
		InDamage *= SelfDamageReductionValue;
	}
}

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

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Rifle;
}

simulated function AltFireMode()
{
	// LocalPlayer Only
	if (!Instigator.IsLocallyControlled())
	{
		return;
	}
	if (ReloadStatus == RS_Reloading)
	{
		return;
	}
	

	if (AmmoCount[0] <= 1)
	{
		StartFire(DEFAULT_FIREMODE);
	}
	else
	{
		AmmoCost[ALTFIRE_FIREMODE] = Max(1, AmmoCount[0]);
		StartFire(ALTFIRE_FIREMODE);
	}
}

/** Returns number of projectiles to fire from SpawnProjectile */
simulated function byte GetNumProjectilesToFire(byte FireModeNum)
{
	local Float MagPercentFull;
	if (FireModeNum == ALTFIRE_FIREMODE)
	{
		MagPercentFull = Float(AmmoCount[0]) / float(default.AmmoCost[ALTFIRE_FIREMODE]);
		return NumPellets[FireModeNum] * MagPercentFull;
	}

	return NumPellets[CurrentFireMode];
}

/** Handle one-hand fire anims */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	if (bUsingSights)
	{
		return FireSightedAnims[FireModeNum];
	}
	else
	{
		if (FireModeNum == ALTFIRE_FIREMODE)
		{
			return FireQuadAnim;
		}
		else
		{
			return FireAnim;
		}
	}
}

/*********************************************************************************************
* State WeaponSingleFiring
* Fire must be released between every shot.
*********************************************************************************************/

simulated state WeaponQuadBarrelFiring extends WeaponSingleFiring
{
	/** Overrideen to include the DoubleFireRecoilModifier*/
	simulated function ModifyRecoil(out float CurrentRecoilModifier)
	{
		super.ModifyRecoil(CurrentRecoilModifier);
		CurrentRecoilModifier *= QuadFireRecoilModifier;
	}

	simulated function BeginState(name PreviousStateName)
	{
		local vector UsedKickMomentum;
		Super.BeginState(PreviousStateName);

		// Push the player back when they fire both barrels
		if (Instigator != none)
		{
			UsedKickMomentum.X = -DoubleBarrelKickMomentum;

			if (Instigator.Physics == PHYS_Falling)
			{
				UsedKickMomentum = UsedKickMomentum >> Instigator.GetViewRotation();
				UsedKickMomentum *= FallingMomentumReduction;
			}
			else
			{
				UsedKickMomentum = UsedKickMomentum >> Instigator.Rotation;
				UsedKickMomentum.Z = 0;
			}

			Instigator.AddVelocity(UsedKickMomentum,Instigator.Location,none);
		}
	}
}

simulated function BeginState(name PreviousStateName)
{
	local vector UsedKickMomentum;
	Super.BeginState(PreviousStateName);

	// Push the player back when they fire both barrels
	if (Instigator != none)
	{
		UsedKickMomentum.X = -DoubleBarrelKickMomentum;

		if (Instigator.Physics == PHYS_Falling)
		{
			UsedKickMomentum = UsedKickMomentum >> Instigator.GetViewRotation();
			UsedKickMomentum *= FallingMomentumReduction;
		}
		else
		{
			UsedKickMomentum = UsedKickMomentum >> Instigator.Rotation;
			UsedKickMomentum.Z = 0;
		}

		Instigator.AddVelocity(UsedKickMomentum,Instigator.Location,none);
	}
}

defaultproperties
{
	SelfDamageReductionValue=0.075f //0.f

	// Inventory
	InventorySize=8//10
	GroupPriority=110
	WeaponSelectTexture=Texture2D'WEP_UI_Quad_Barrel_TEX.UI_WeaponSelect_QuadBarrel'

    // FOV
    MeshFOV=60
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=65
	DOF_FG_MaxNearBlurSize=3

	// Zooming/Position
	PlayerViewOffset=(X=15.0,Y=8.0,Z=-4.5)
	IronSightPosition=(X=3,Y=0,Z=0)

	// Content
	PackageKey="ExpressRifle"
	FirstPersonMeshName="wep_1p_quad_barrel_mesh.Wep_1stP_Quad_Barrel"
	FirstPersonAnimSetNames(0)="wep_1p_quad_barrel_anim.Wep_1stP_Quad_Barrel_Anim"
	PickupMeshName="WEP_3P_Quad_Barrel_MESH.Wep_3rdP_Quad_Barrel_Pickup"
	AttachmentArchetypeName="WEP_Quad_Barrel_ARCH.Wep_Quad_Barrel_3P"
	MuzzleFlashTemplateName="WEP_Quad_Barrel_ARCH.Wep_Quad_Barrel_MuzzleFlash"

	// Animations
	FireAnim=Shoot_Single
	FireQuadAnim=Shoot_Double
	FireSightedAnims[0]=Shoot_Iron_Single
	FireSightedAnims[1]=Shoot_Iron_Double
    bHasFireLastAnims=false

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_ExpressRifle'
	InstantHitDamage(DEFAULT_FIREMODE)=250//240
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_ExpressRifle'
	PenetrationPower(DEFAULT_FIREMODE)=8//4.0
	FireInterval(DEFAULT_FIREMODE)=0.25 // 240 RPM
	FireOffset=(X=25,Y=3.5,Z=-4)
	NumPellets(DEFAULT_FIREMODE)=1
	Spread(DEFAULT_FIREMODE) = 0.0085
	ForceReloadTimeOnEmpty=0.3

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(ALTFIRE_FIREMODE)= WeaponQuadBarrelFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_ExpressRifle'
	InstantHitDamage(ALTFIRE_FIREMODE)=250//240
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_ExpressRifle'
	PenetrationPower(ALTFIRE_FIREMODE)=8//4.0
	FireInterval(ALTFIRE_FIREMODE)=0.25 // 240 RPM
	NumPellets(ALTFIRE_FIREMODE)=4
	Spread(ALTFIRE_FIREMODE) = 0.017//0.034
	AmmoCost(ALTFIRE_FIREMODE)=4
	DoubleBarrelKickMomentum=1000
	FallingMomentumReduction=0.5

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_ExpressRifle'
	InstantHitDamage(BASH_FIREMODE)=27 //24

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_Fire_3P_Single', FirstPersonCue=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_Fire_1P_Single') //@TODO: Replace
    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_Fire_3P_AltFire', FirstPersonCue=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_Fire_1P_AltFire') //@TODO: Replace

	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_DryFire' //@TODO: Replace
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_DryFire' //@TODO: Replace

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Ammo
	MagazineCapacity[0]=4
	SpareAmmoCapacity[0]=48 //72
	InitialSpareMags[0]=3 //8
	AmmoPickupScale[0]=2.0 //3.0
	bCanBeReloaded=true
	bReloadFromMagazine=true
	bNoMagazine=true

	// Recoil
	maxRecoilPitch=1200 //900
	minRecoilPitch=775
	maxRecoilYaw=800 //500
	minRecoilYaw=-500
	RecoilRate=0.085
	RecoilBlendOutRatio=1.1
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
	HippedRecoilModifier=1.1 //1.25
	QuadFireRecoilModifier=2.0

	AssociatedPerkClasses.Empty()
	AssociatedPerkClasses(0)=class'KFPerk_Sharpshooter'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.15f,IncrementWeight=1)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
}