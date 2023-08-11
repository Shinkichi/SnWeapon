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

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Assault;
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Shotgun;
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

/*********************************************************************************************
 * state SprayingFire
 * This is the default Firing State for flame weapons.
 *********************************************************************************************/

/** Runs on a loop when firing to determine if AI should be warned */
function Timer_CheckForAIWarning();

simulated state WeaponBurstFiring
{
	simulated function BeginState( Name PreviousStateName )
	{
		AmmoConsumed = 0;
		TurnOnFireSpray();

		// Start timer to warn AI
		if( bWarnAIWhenFiring )
		{
			Timer_CheckForAIWarning();
			SetTimer( 0.5f, true, nameOf(Timer_CheckForAIWarning) );
		}

		super.BeginState(PreviousStateName);
	}

	/** Leaving state, shut everything down. */
	simulated function EndState(Name NextStateName)
	{
		if (bFireSpraying)
		{
			TurnOffFireSpray();
		}
		ClearFlashLocation();
		ClearTimer('RefireCheckTimer');
		ClearPendingFire(0);

		// Clear AI warning timer
		if( bWarnAIWhenFiring )
		{
			ClearTimer( nameOf(Timer_CheckForAIWarning) );
		}

		super.EndState(NextStateName);
	}

	/** Overriden here to enforce a minimum amount of ammo consumed (to make sure the flame stays on a minimum duration) */
	simulated function ConsumeAmmo( byte FireMode )
	{
		global.ConsumeAmmo(FireMode);

		AmmoConsumed++;
	}

	/**
	 * Check if current fire mode can/should keep on firing.
	 * This is called from a firing state after each shot is fired
	 * to decide if the weapon should fire again, or stop and go to the active state.
	 * The default behavior, implemented here, is keep on firing while player presses fire
	 * and there is enough ammo. (Auto Fire).
	 *
	 * @return	true to fire again, false to stop firing and return to Active State.
	 */
	simulated function bool ShouldRefire()
	{
		// if doesn't have ammo to keep on firing, then stop
		if( !HasAmmo( CurrentFireMode ) )
		{
			return false;
		}

		// refire if owner is still willing to fire or if we've matched or surpassed minimum
		// amount of ammo consumed
		return ( StillFiring(CurrentFireMode) || AmmoConsumed < MinAmmoConsumed );
	}

	/** Runs on a loop when firing to determine if AI should be warned */
	function Timer_CheckForAIWarning()
	{
		local vector Direction, DangerPoint;
		local vector TraceStart, Projection;
		local Pawn P;
		local KFPawn_Monster HitMonster;

		TraceStart = Instigator.GetWeaponStartTraceLocation();
		Direction = vector( GetAdjustedAim(TraceStart) );

	    // Warn all zeds within range
	    foreach WorldInfo.AllPawns( class'Pawn', P )
	    {
	        if( P.GetTeamNum() != Instigator.GetTeamNum() && !P.IsHumanControlled() && P.IsAliveAndWell() )
	        {
	            // Determine if AI is within range as well as within our field of view
	            Projection = P.Location - TraceStart;
	            if( VSizeSQ(Projection) < MaxAIWarningDistSQ )
	            {
	                PointDistToLine( P.Location, Direction, TraceStart, DangerPoint );

		            if( VSizeSQ(DangerPoint - P.Location) < MaxAIWarningDistFromPointSQ )
		            {
		                // Tell the AI to evade away from the DangerPoint
		                HitMonster = KFPawn_Monster( P );
		                if( HitMonster != none && HitMonster.MyKFAIC != None )
		                {
		                    HitMonster.MyKFAIC.ReceiveLocationalWarning( DangerPoint, TraceStart, self );
		                }
		            }
		        }
	        }
	    }
	}

	simulated function bool IsFiring()
	{
		return TRUE;
	}

	simulated function bool TryPutDown()
	{
		bWeaponPutDown = TRUE;
		return FALSE;
	}
};

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
	maxRecoilPitch=150
	minRecoilPitch=115
	maxRecoilYaw=80 //115
	minRecoilYaw=-80 //-115
	RecoilRate=0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	RecoilViewRotationScale=0.25
	IronSightMeshFOVCompensationScale=1.5
    HippedRecoilModifier=1.5
	AltFireRecoilScale=6.0f //4.0f

    // Inventory
	InventorySize=8//7
	GroupPriority=75
	WeaponSelectTexture=Texture2D'wep_ui_cryogun_tex.UI_WeaponSelect_Cryogun'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	//FiringStatesArray(DEFAULT_FIREMODE)=SprayingFire
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponBurstFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_Pellet_Chaingun'
	InstantHitDamage(DEFAULT_FIREMODE)=25//20
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Chaingun'
	FireInterval(DEFAULT_FIREMODE)=+0.06 // 1250 RPM//+0.07 // 850 RPM
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	Spread(DEFAULT_FIREMODE)=0.07
	FireOffset=(X=50,Y=10.0,Z=-15)
	MinAmmoConsumed=4
	//BurstAmount=10

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_Pellet_Chaingun'
	InstantHitDamage(ALTFIRE_FIREMODE)=25//20
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_Chaingun'
	FireInterval(ALTFIRE_FIREMODE)=0.6f
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
   	AssociatedPerkClasses(2)=class'KFPerk_SWAT'

	// Eviscerator uses its own anim tree with its own specified bones to lock, so leave it alone
	BonesToLockOnEmpty.Empty()
   
	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Weak_Recoil'

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.4f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.8f,IncrementWeight=2)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.4f), (Stat=EWUS_Damage1, Scale=1.15f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.8f), (Stat=EWUS_Damage1, Scale=1.3f), (Stat=EWUS_Weight, Add=2)))
}