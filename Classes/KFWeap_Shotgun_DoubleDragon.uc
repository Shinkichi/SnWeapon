
class KFWeap_Shotgun_DoubleDragon extends KFWeap_ShotgunBase;

/** How much to scale recoil when firing in double barrel fire. */
var(Recoil) float DoubleFireRecoilModifier;

/** Shoot animation to play when shooting both barrels from the hip */
var(Animations) const editconst	name	FireDoubleAnim;

/** How much momentum to apply when fired in double barrel */
var(Recoil) float DoubleBarrelKickMomentum;

/** How much to reduce shoot momentum when falling */
var(Recoil) float FallingMomentumReduction;

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Flame;
}

/**
 * Toggle between DEFAULT and ALTFIRE
 */
simulated function AltFireMode()
{
	// LocalPlayer Only
	if ( !Instigator.IsLocallyControlled()  )
	{
		return;
	}

    if (AmmoCount[0] == 1)
    {
        StartFire(DEFAULT_FIREMODE);
    }
    else
    {
        StartFire(ALTFIRE_FIREMODE);
    }
}

/**
 * Send weapon to proper firing state
 */
simulated function SendToFiringState(byte FireModeNum)
{
	if( FireModeNum == ALTFIRE_FIREMODE && AmmoCount[0] == 1)
    {
		// not enough ammo for altfire
		Super.SendToFiringState(DEFAULT_FIREMODE);
	}
	else
	{
		Super.SendToFiringState(FireModeNum);
	}
}

/*********************************************************************************************
 * State WeaponSingleFiring
 * Fire must be released between every shot.
 *********************************************************************************************/

simulated state WeaponDoubleBarrelFiring extends WeaponSingleFiring
{
    /** Overrideen to include the DoubleFireRecoilModifier*/
    simulated function ModifyRecoil( out float CurrentRecoilModifier )
	{
		super.ModifyRecoil( CurrentRecoilModifier );
	    CurrentRecoilModifier *= DoubleFireRecoilModifier;
	}

	simulated function BeginState(name PreviousStateName)
    {
   	    local vector UsedKickMomentum;
       	Super.BeginState(PreviousStateName);

    	// Push the player back when they fire both barrels
        if (Instigator != none )
    	{
            UsedKickMomentum.X = -DoubleBarrelKickMomentum;

            if( Instigator.Physics == PHYS_Falling  )
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

/** Handle one-hand fire anims */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	if ( bUsingSights )
	{
        return FireSightedAnims[FireModeNum];
	}
	else
	{
    	if ( FireModeNum == ALTFIRE_FIREMODE )
    	{
            return FireDoubleAnim;
    	}
    	else
    	{
            return FireAnim;
        }
	}
}

/**
 * Causes the muzzle flash to turn on and setup a time to
 * turn it back off again.
 */
simulated function CauseMuzzleFlash(byte FireModeNum)
{
	// Alternate barrels
    if( FireModeNum == DEFAULT_FIREMODE )
	{
        if( AmmoCount[0] == 1 )
        {
            super.CauseMuzzleFlash(DEFAULT_FIREMODE);
        }
        else
        {
            super.CauseMuzzleFlash(ALTFIRE_FIREMODE);
        }
	}
	// Fire both barrels
	else
	{
        super.CauseMuzzleFlash(DEFAULT_FIREMODE);
        super.CauseMuzzleFlash(ALTFIRE_FIREMODE);
	}
}

defaultproperties
{
	// Inventory
	InventorySize=5 //4
	GroupPriority=50
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_DBShotgun'

    // FOV
    MeshFOV=75
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=65
	DOF_FG_MaxNearBlurSize=3

	// Zooming/Position
	PlayerViewOffset=(X=4.0,Y=7.0,Z=-5.0)
	IronSightPosition=(X=3,Y=0,Z=0)

	// Content
	PackageKey="Shotgun_DoubleDragon"
	FirstPersonMeshName="wep_1p_double_barrel_mesh.Wep_1stP_Double_Barrel"
	FirstPersonAnimSetNames(0)="WEP_1P_Double_Barrel_ANIM.Wep_1stP_Double_Barrel_Anim"
	PickupMeshName="WEP_3P_Double_Barrel_MESH.Wep_Double_Barrel_Pickup"
	AttachmentArchetypeName="WEP_Shotgun_DoubleBarrel_ARCH.Wep_Shotgun_DoubleBarrel_3P"
	MuzzleFlashTemplateName="WEP_Shotgun_DoubleBarrel_ARCH.Wep_Shotgun_DoubleBarrel_MuzzleFlash"

	// Animations
	FireAnim=Shoot_Single
	FireDoubleAnim=Shoot_Double
	FireSightedAnims[0]=Shoot_Iron_Single
	FireSightedAnims[1]=Shoot_Iron_Double
    bHasFireLastAnims=false

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_DoubleDragon'
	InstantHitDamage(DEFAULT_FIREMODE)=25
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_DoubleDragon'
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	FireInterval(DEFAULT_FIREMODE)=0.25 // 240 RPM
	FireOffset=(X=25,Y=3.5,Z=-4)
	NumPellets(DEFAULT_FIREMODE)=8 //12
	Spread(DEFAULT_FIREMODE)=0.25
	ForceReloadTimeOnEmpty=0.3

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunAuto'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponDoubleBarrelFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_DoubleDragon'
	InstantHitDamage(ALTFIRE_FIREMODE)=25
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_DoubleDragon'
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	FireInterval(ALTFIRE_FIREMODE)=0.25 // 240 RPM
	NumPellets(ALTFIRE_FIREMODE)=16 //24
	Spread(ALTFIRE_FIREMODE)=0.25
	AmmoCost(ALTFIRE_FIREMODE)=2
	DoubleBarrelKickMomentum=1000
	FallingMomentumReduction=0.5

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_DoubleDragon'
	InstantHitDamage(BASH_FIREMODE)=24

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_DragonsBreath.Play_SA_DragonsBreath_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_DragonsBreath.Play_SA_DragonsBreath_Fire_1P')
    WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_DragonsBreath.Play_SA_DragonsBreath_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_DragonsBreath.Play_SA_DragonsBreath_Fire_1P')

	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_Shotgun.Play_SA_WEP_DoubleBarrel_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_Shotgun.Play_SA_WEP_DoubleBarrel_Handling_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	// Ammo
	MagazineCapacity[0]=2
	SpareAmmoCapacity[0]=46
	InitialSpareMags[0]=11
	AmmoPickupScale[0]=2.0//3.0
	bCanBeReloaded=true
	bReloadFromMagazine=true
	bNoMagazine=true

	// Recoil
	maxRecoilPitch=900
	minRecoilPitch=775
	maxRecoilYaw=500
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
	DoubleFireRecoilModifier=2.2
	HippedRecoilModifier=1.25

	AssociatedPerkClasses(0)=class'KFPerk_Firebug'
	//AssociatedPerkClasses(1)=class'KFPerk_Support'

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Heavy_Recoil_SingleShot'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.05f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.1f,IncrementWeight=2)
	//WeaponUpgrades[3]=(IncrementDamage=1.15f,IncrementWeight=3)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.05f), (Stat=EWUS_Damage1, Scale=1.05f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.1f), (Stat=EWUS_Damage1, Scale=1.1f), (Stat=EWUS_Weight, Add=2)))
	WeaponUpgrades[3]=(Stats=((Stat=EWUS_Damage0, Scale=1.15f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=3)))
}