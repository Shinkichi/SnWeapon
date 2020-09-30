class KFWeap_Chaingun extends KFWeap_FlameBase;

/** Shoot animation to play when shooting secondary fire */
var(Animations) const editconst	name	FireHeavyAnim;

/** Shoot animation to play when shooting secondary fire last shot */
var(Animations) const editconst	name	FireLastHeavyAnim;

/** Shoot animation to play when shooting secondary fire last shot when aiming */
var(Animations) const editconst	name	FireLastHeavySightedAnim;

/** Alt-fire explosion template */
var() GameExplosion 		ExplosionTemplate;

/** How much recoil the altfire should do */
var protected const float AltFireRecoilScale;

/** Allows weapon to calculate its own damage for display in trader */
static simulated function float CalculateTraderWeaponStatDamage()
{
	local float BaseDamage, DoTDamage;
	local class<KFDamageType> DamageType;

	BaseDamage = default.InstantHitDamage[DEFAULT_FIREMODE];

	DamageType = class<KFDamageType>(default.InstantHitDamageTypes[DEFAULT_FIREMODE]);
	if (DamageType != none && DamageType.default.DoT_Type != DOT_None)
	{
		DoTDamage = (DamageType.default.DoT_Duration / DamageType.default.DoT_Interval) * (BaseDamage * DamageType.default.DoT_DamageScale);
	}

	return BaseDamage * default.NumPellets[DEFAULT_FIREMODE] + DoTDamage;
}

/*********************************************************************************************
 Firing / Projectile - Below projectile spawning code copied from KFWeap_ShotgunBase
********************************************************************************************* */

/** Spawn projectile is called once for each shot pellet fired */
simulated function KFProjectile SpawnAllProjectiles(class<KFProjectile> KFProjClass, vector RealStartLoc, vector AimDir)
{
	local KFPerk InstigatorPerk;

	if (CurrentFireMode == GRENADE_FIREMODE)
	{
		return Super.SpawnProjectile(KFProjClass, RealStartLoc, AimDir);
	}

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != none)
	{
		Spread[CurrentFireMode] = default.Spread[CurrentFireMode] * InstigatorPerk.GetTightChokeModifier();
	}

	return super.SpawnAllProjectiles(KFProjClass, RealStartLoc, AimDir);
}

/** Handle one-hand fire anims */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	local bool bPlayFireLast;

    bPlayFireLast = ShouldPlayFireLast(FireModeNum);

	if ( bUsingSights )
	{
		if( bPlayFireLast )
        {
        	if ( FireModeNum == ALTFIRE_FIREMODE )
        	{
                return FireLastHeavySightedAnim;
        	}
        	else
        	{
                return FireLastSightedAnim;
            }
        }
        else
        {
            return FireSightedAnims[FireModeNum];
        }

	}
	else
	{
		if( bPlayFireLast )
        {
        	if ( FireModeNum == ALTFIRE_FIREMODE )
        	{
                return FireLastHeavyAnim;
        	}
        	else
        	{
                return FireLastAnim;
            }
        }
        else
        {
        	if ( FireModeNum == ALTFIRE_FIREMODE )
        	{
                return FireHeavyAnim;
        	}
        	else
        	{
                return FireAnim;
            }
        }
	}
}

/**
 * Instead of a toggle, just immediately fire alternate fire.
 */
simulated function AltFireMode()
{
	// LocalPlayer Only
	if ( !Instigator.IsLocallyControlled()  )
	{
		return;
	}

	StartFire( ALTFIRE_FIREMODE );
}

/** Disable normal bullet spread */
simulated function rotator AddSpread( rotator BaseAim )
{
	return BaseAim; // do nothing
}

/** Disable auto-reload for alt-fire */
simulated function bool ShouldAutoReload(byte FireModeNum)
{
	local bool bRequestReload;

    bRequestReload = Super.ShouldAutoReload(FireModeNum);

    // Must be completely empty for auto-reload or auto-switch
    if ( FireModeNum == ALTFIRE_FIREMODE && AmmoCount[0] > 0 )
    {
   		bPendingAutoSwitchOnDryFire = false;
   		return false;
    }

    return bRequestReload;
}

/** Notification that a weapon attack has has happened */
function HandleWeaponShotTaken( byte FireMode )
{
    if( KFPlayer != none && FireMode == ALTFIRE_FIREMODE )
	{
        KFPlayer.AddShotsFired( GetNumProjectilesToFire(FireMode) );
        return;
	}

	super.HandleWeaponShotTaken( FireMode );
}

/** Increase recoil for altfire */
simulated function ModifyRecoil( out float CurrentRecoilModifier )
{
	if( CurrentFireMode == ALTFIRE_FIREMODE )
	{
		CurrentRecoilModifier *= AltFireRecoilScale;
	}

	super.ModifyRecoil( CurrentRecoilModifier );
}

/** Can be overridden on a per-weapon or per-state basis */
simulated function bool IsHeavyWeapon()
{
	return true;
}

/** No pilot light on freeze thrower */
simulated function SetPilotDynamicLightEnabled( bool bLightEnabled );

static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Electric;
}

defaultproperties
{
    //FlameSprayArchetype=SprayActor_Flame'WEP_CryoGun_ARCH.Wep_CryoGun_IceSpray'

    // FX
	PSC_PilotLight=none
	PilotLights.Empty

	// Shooting Animations
	bHasFireLastAnims=true
	FireLastHeavySightedAnim=Shoot_Heavy_Iron_Last
    FireHeavyAnim=Shoot_Heavy
    FireLastHeavyAnim=Shoot_Heavy_Last

	// Shooting Animations
	FireSightedAnims[0]=Shoot
	FireSightedAnims[1]=Shoot_Heavy_Iron
	FireLoopSightedAnim=ShootLoop

	// Advanced Looping (High RPM) Fire Effects
	FireLoopStartSightedAnim=ShootLoop_Start
	FireLoopEndSightedAnim=ShootLoop_End

    // FOV
	MeshIronSightFOV=52
    PlayerIronSightFOV=80

	// Depth of field
	DOF_FG_FocalRadius=150
	DOF_FG_MaxNearBlurSize=1

	// Content
	PackageKey="Chaingun"
	FirstPersonMeshName="WEP_1P_CryoGun_MESH.Wep_1stP_CryoGun_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_CryoGun_anim.Wep_1stP_CryoGun_anim"
	PickupMeshName="WEP_3P_CryoGun_MESH.Wep_CryoGun_Pickup"
	AttachmentArchetypeName="SnWeapon_Packages.Wep_Chaingun_3P"
	MuzzleFlashTemplateName="WEP_L85A2_ARCH.Wep_L85A2_MuzzleFlash"

	LaserSightTemplate=KFLaserSightAttachment'FX_LaserSight_ARCH.LaserSight_WithAttachment_1P'

   	// Zooming/Position
	PlayerViewOffset=(X=6.0,Y=15,Z=-5)
	IronSightPosition=(X=20,Y=8,Z=-3) //z=0
    QuickWeaponDownRotation=(Pitch=-8192,Yaw=0,Roll=0)

		//PlayerViewOffset=(X=3.0,Y=9,Z=-3)
	    //IronSightPosition=(X=3,Y=6,Z=-1)

	// Ammo
	MagazineCapacity[0]=100
	SpareAmmoCapacity[0]=500
	InitialSpareMags[0]=1
	AmmoPickupScale[0]=0.75
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=200
	minRecoilPitch=150
	maxRecoilYaw=175
	minRecoilYaw=-125
	RecoilRate=0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	IronSightMeshFOVCompensationScale=2.5
    HippedRecoilModifier=1.5
	AltFireRecoilScale=4.0f

    // Inventory
	InventorySize=7
	GroupPriority=75
	WeaponSelectTexture=Texture2D'wep_ui_cryogun_tex.UI_WeaponSelect_Cryogun'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=SprayingFire//WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pellet'
	InstantHitDamage(DEFAULT_FIREMODE)=20//24
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Chaingun'
	FireInterval(DEFAULT_FIREMODE)=+0.06 // 1250 RPM
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	Spread(DEFAULT_FIREMODE)=0.07
	FireOffset=(X=50,Y=10.0,Z=-15)
	MinAmmoConsumed=5//4

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_Pellet'
	InstantHitDamage(ALTFIRE_FIREMODE)=20//24
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_Chaingun'
	FireInterval(ALTFIRE_FIREMODE)=0.6
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	AmmoCost(ALTFIRE_FIREMODE)=10
	NumPellets(ALTFIRE_FIREMODE)=10
	Spread(ALTFIRE_FIREMODE)=0.15f

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Chaingun'
	InstantHitDamage(BASH_FIREMODE)=28

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_ZED_Patriarch.Play_Mini_Gun_LP', FirstPersonCue=AkEvent'WW_ZED_Patriarch.Play_Mini_Gun_LP')
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_ZED_Patriarch.Play_Mini_Gun_Tail', FirstPersonCue=AkEvent'WW_ZED_Patriarch.Play_Mini_Gun_Tail')
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_SA_MedicShotgun.Play_SA_MedicShotgun_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_SA_MedicShotgun.Play_SA_MedicShotgun_Fire_1P')

	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_Flamethrower.Play_WEP_SA_Flamethrower_Handling_DryFire'
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_Flamethrower.Play_WEP_SA_Flamethrower_Handling_DryFire'

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	SingleFireSoundIndex=FIREMODE_NONE
	bLoopingFireAnim(ALTFIRE_FIREMODE)=false
	bLoopingFireSnd(ALTFIRE_FIREMODE)=false

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false
	bHasLaserSight=TRUE

 	// AI Warning
 	bWarnAIWhenFiring=true

	AssociatedPerkClasses.Empty()
   	AssociatedPerkClasses(0)=class'KFPerk_Commando'
   	AssociatedPerkClasses(1)=class'KFPerk_Support'
   
	// Eviscerator uses its own anim tree with its own specified bones to lock, so leave it alone
	BonesToLockOnEmpty.Empty()
   
	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Weak_Recoil'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.4f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.8f,IncrementWeight=2)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.8f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
}