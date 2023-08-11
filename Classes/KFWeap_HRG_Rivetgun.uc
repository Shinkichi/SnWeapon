class KFWeap_HRG_Rivetgun extends KFWeap_Shotgun_Nailgun;

var(Animations) const editconst	name		AltFireLoopAnim;
var(Animations) const editconst	name		AltFireLoopSightedAnim;
var(Animations) const editconst	name		AltFireLoopStartAnim;
var(Animations) const editconst	name		AltFireLoopStartSightedAnim;
var(Animations) const editconst	name		AltFireLoopEndAnim;
var(Animations) const editconst	name		AltFireLoopEndSightedAnim;

/** Reduction for the amount of damage dealt to the weapon owner (including damage by the explosion) */
var float SelfDamageReductionValue;

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Explosive;
}

/** Allows weapon to calculate its own damage for display in trader */
static simulated function float CalculateTraderWeaponStatDamage()
{
	local float CalculatedDamage;
	local class<KFDamageType> DamageType;
	local GameExplosion ExplosionInstance;

	ExplosionInstance = class<KFProjectile>(default.WeaponProjectiles[DEFAULT_FIREMODE]).default.ExplosionTemplate;

	CalculatedDamage = default.InstantHitDamage[DEFAULT_FIREMODE] + ExplosionInstance.Damage;

	DamageType = class<KFDamageType>(ExplosionInstance.MyDamageType);
	if( DamageType != none && DamageType.default.DoT_Type != DOT_None )
	{
		CalculatedDamage += (DamageType.default.DoT_Duration / DamageType.default.DoT_Interval) * (CalculatedDamage * DamageType.default.DoT_DamageScale);
	}

	return CalculatedDamage;
}

/** Get name of the animation to play for PlayFireEffects */
simulated function name GetLoopingFireAnim(byte FireModeNum)
{
	if (FireModeNum == ALTFIRE_FIREMODE)
	{
		if (bUsingSights)
		{
			return AltFireLoopSightedAnim;
		}

		return AltFireLoopAnim;
	}

	return super.GetLoopingFireAnim(FireModeNum);
}

/** Get name of the animation to play for PlayFireEffects */
simulated function name GetLoopStartFireAnim(byte FireModeNum)
{
	if (FireModeNum == ALTFIRE_FIREMODE)
	{
		if (bUsingSights)
		{
			return AltFireLoopStartSightedAnim;
		}

		return AltFireLoopStartAnim;
	}


	return super.GetLoopStartFireAnim(FireModeNum);
}


/** Get name of the animation to play for PlayFireEffects */
simulated function name GetLoopEndFireAnim(byte FireModeNum)
{
	if (FireModeNum == ALTFIRE_FIREMODE)
	{
		if (bUsingSights)
		{
			return AltFireLoopEndSightedAnim;
		}
		else
		{
			return AltFireLoopEndAnim;
		}
	}

	return super.GetLoopEndFireAnim(FireModeNum);
}

simulated function ConsumeAmmo(byte FireModeNum)
{
	local KFPerk InstigatorPerk;

`if(`notdefined(ShippingPC))
	if (bInfiniteAmmo)
	{
		return;
	}
`endif

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != none && InstigatorPerk.GetIsUberAmmoActive(self))
	{
		return;
	}

	super.ConsumeAmmo(FireModeNum);
}

/*********************************************************************************************
 * State WeaponAltFiringAuto
 *
 *********************************************************************************************/

simulated state WeaponAltFiringAuto extends WeaponFiring
{
    /** Overrideen to include the DoubleFireRecoilModifier*/
    simulated function ModifyRecoil(out float CurrentRecoilModifier)
	{
		super.ModifyRecoil(CurrentRecoilModifier);
	    CurrentRecoilModifier *= AltFireRecoilModifier;
	}

	/** Initialize the weapon as being active and ready to go. */
	simulated function BeginState(Name PreviousStateName)
	{
        super.BeginState(PreviousStateName);

		// Initialize recoil blend out settings
		if (RecoilRate > 0 && RecoilBlendOutRatio > 0)
		{
			RecoilYawBlendOutRate = ((maxRecoilYaw*AltFireRecoilModifier)/RecoilRate) * RecoilBlendOutRatio;
			RecoilPitchBlendOutRate = ((maxRecoilPitch*AltFireRecoilModifier)/RecoilRate) * RecoilBlendOutRatio;
		}
    }
}

// Reduce damage to self
function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super.AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != none && DamageCauser != none && DamageCauser.Instigator == Instigator)
	{
		InDamage *= SelfDamageReductionValue;
	}
}

defaultproperties
{
	SelfDamageReductionValue=0.f//0.075f //0.f
	//Inventory
	InventorySize=5
	GroupPriority=75

	FireLoopAnim=HRG_ShootLoop
	FireLoopSightedAnim=HRG_ShootLoop_Iron
	FireLoopStartAnim=HRG_ShootLoop_Start
	FireLoopStartSightedAnim=HRG_ShootLoop_Iron_Start
	FireLoopEndAnim=HRG_ShootLoop_End
	FireLoopEndSightedAnim=HRG_ShootLoop_Iron_End

	AltFireLoopAnim=HRG_Alt_ShootLoop
	AltFireLoopSightedAnim=HRG_Alt_ShootLoop_Iron
	AltFireLoopStartAnim=HRG_Alt_ShootLoop_Start
	AltFireLoopStartSightedAnim=HRG_Alt_ShootLoop_Iron_Start
	AltFireLoopEndAnim=HRG_Alt_ShootLoop_End
	AltFireLoopEndSightedAnim=HRG_Alt_ShootLoop_Iron_End

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_Nail'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	InstantHitDamage(DEFAULT_FIREMODE)=10//40
	Spread(DEFAULT_FIREMODE)=0.025
	FireInterval(DEFAULT_FIREMODE)=0.07 //857 RPM
	NumPellets(DEFAULT_FIREMODE)=1
	PenetrationPower(DEFAULT_FIREMODE)=0//3.0
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_HRGRivetgun'
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Nail_HRGRivetgun'

	// ALTFIRE_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_NailsBurst'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponAltFiringAuto
	InstantHitDamage(ALTFIRE_FIREMODE)=10//40
	Spread(ALTFIRE_FIREMODE)=0.15
	FireInterval(ALTFIRE_FIREMODE)=0.12 //500 RPM
	NumPellets(ALTFIRE_FIREMODE)=3
	PenetrationPower(ALTFIRE_FIREMODE)=0//3.0
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_HRGRivetgun'
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Nail_HRGRivetgun'
	AltFireRecoilModifier=2.5f

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_HRGRivetgun'

	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireAnim(ALTFIRE_FIREMODE)=true

	maxRecoilPitch=100
	minRecoilPitch=85
	maxRecoilYaw=60
	minRecoilYaw=-60
	RecoilRate=0.045
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=100
	RecoilISMinYawLimit=65435
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	IronSightMeshFOVCompensationScale=1.5
	WalkingRecoilModifier=1.1
	JoggingRecoilModifier=1.2

	AssociatedPerkClasses.Empty()
	AssociatedPerkClasses(0)=class'KFPerk_Demolitionist'

	MagazineCapacity[0]=42
	SpareAmmoCapacity[0]=336
	InitialSpareMags[0]=2

	WeaponSelectTexture=Texture2D'WEP_UI_HRG_Nailgun_PDW_TEX.UI_WeaponSelect_HRG_Nailgun_PDW'

	WeaponUpgrades.Empty()
	WeaponUpgrades[0]=(Stats=((Stat=EWUS_Damage0, Scale=1.f, Add=0), (Stat=EWUS_Weight, Scale=1.f, Add=0)))
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.3f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))

	// Content
	PackageKey="HRG_Rivetgun"
	FirstPersonMeshName="WEP_1P_HRG_Nailgun_PDW_MESH.Wep_1stP_HRG_Nailgun_PDW_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_HRG_Nailgun_PDW_ANIM.Wep_1stP_HRG_Nailgun_PDW_Anim"
	PickupMeshName="WEP_3P_HRG_Nailgun_PDW_MESH.Wep_HRG_Nailgun_PDW_Pickup"
	AttachmentArchetypeName="WEP_HRG_Nailgun_PDW_ARCH.Wep_HRG_Nailgun_PDW_3P"
	MuzzleFlashTemplateName="WEP_HRG_Nailgun_PDW_ARCH.Wep_HRG_Nailgun_PDW_MuzzleFlash"
}