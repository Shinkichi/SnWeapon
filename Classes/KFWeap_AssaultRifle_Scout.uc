class KFWeap_AssaultRifle_Scout extends KFWeap_ScopedBase;

var (Positioning) vector SecondaryFireOffset;

const SecondaryFireAnim             = 'Shoot_Secondary';
const SecondaryFireIronAnim         = 'Shoot_Secondary_Iron';
const SecondaryFireAnimLast         = 'Shoot_Secondary_Last';
const SecondaryFireIronAnimLast     = 'Shoot_Secondary_Iron_Last';
const SecondaryReloadAnimEmpty      = 'Reload_Secondary_Empty';
const SecondaryReloadAnimHalf       = 'Reload_Secondary_Half';
const SecondaryReloadAnimEliteEmpty = 'Reload_Secondary_Elite_Empty';
const SecondaryReloadAnimEliteHalf  = 'Reload_Secondary_Elite_Half';
const ShotgunMuzzleSocket           = 'ShotgunMuzzleFlash';

var transient KFMuzzleFlash ShotgunMuzzleFlash;
var() KFMuzzleFlash ShotgunMuzzleFlashTemplate;

// Used on the server to keep track of grenades
var int ServerTotalAltAmmo;

var transient bool bCanceledAltAutoReload;

var protected const float AltFireRecoilScale;

static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Assault;
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Explosive;
} 

/** Instead of switch fire mode use as immediate alt fire */
simulated function AltFireMode()
{
	if ( !Instigator.IsLocallyControlled() )
	{
		return;
	}

	if (bCanceledAltAutoReload)
	{
		bCanceledAltAutoReload = false;
		TryToAltReload(true);
		return;
	}

	// StartFire - StopFire called from KFPlayerInput
	StartFire(ALTFIRE_FIREMODE);
}

simulated function BeginFire( Byte FireModeNum )
{
	local bool bStoredAutoReload;

	// We are trying to reload the weapon but the primary ammo in already at full capacity
	if ( FireModeNum == RELOAD_FIREMODE && !CanReload() )
	{
		// Store the current state of bCanceledAltAutoReload in case its not possible to do the reload
		bStoredAutoReload = bCanceledAltAutoReload;
		bCanceledAltAutoReload = false;

		if(CanAltAutoReload(false))
		{
			TryToAltReload(false);
			return;
		}

		bCanceledAltAutoReload = bStoredAutoReload;
	}

	super.BeginFire( FireModeNum );
}

/**
 * Initializes ammo counts, when weapon is spawned.
 */
function InitializeAmmo()
{
	Super.InitializeAmmo();

	// Add Secondary ammo to our secondary spare ammo count both of these are important, in order to allow dropping the weapon to function properly.
	SpareAmmoCount[1]	= Min(SpareAmmoCount[1] + InitialSpareMags[1] * default.MagazineCapacity[1], GetMaxAmmoAmount(1) - AmmoCount[1]);
	ServerTotalAltAmmo += SpareAmmoCount[1];

	// Make sure the server doesn't get extra shots on listen servers.
	if(Role == ROLE_Authority && !Instigator.IsLocallyControlled())
	{
		ServerTotalAltAmmo += AmmoCount[1];
	}
}

/**
 * @see Weapon::ConsumeAmmo
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
	local byte AmmoType;
	local bool bNoInfiniteAmmo;
	local int OldAmmoCount;

	if(UsesSecondaryAmmo() && FireModeNum == ALTFIRE_FIREMODE && Role == ROLE_Authority && !Instigator.IsLocallyControlled())
	{
		AmmoType = GetAmmoType(FireModeNum);

		OldAmmoCount = AmmoCount[AmmoType];
		Super.ConsumeAmmo(FireModeNum);

		bNoInfiniteAmmo = (OldAmmoCount - AmmoCount[AmmoType]) > 0 || AmmoCount[AmmoType] == 0;
		if ( bNoInfiniteAmmo )
		{
			ServerTotalAltAmmo--;
		}
	}
	else
	{
		Super.ConsumeAmmo(FireModeNum);
	}
}

/** Make sure user can't fire infinitely if they cheat to get infinite ammo locally. */
simulated event bool HasAmmo( byte FireModeNum, optional int Amount=1 )
{
	local byte AmmoType;

	AmmoType = GetAmmoType(FireModeNum);

	if(AmmoType == 1 && Role == ROLE_Authority && UsesSecondaryAmmo() && !Instigator.IsLocallyControlled())
	{
		if(ServerTotalAltAmmo <= 0)
		{
			return false;
		}
	}

	return Super.HasAmmo(FireModeNum, Amount );
}

/**
 *	Overridden so any grenades added will go to the spare ammo and no the clip.
 */
function int AddSecondaryAmmo(int Amount)
{
	local int OldAmmo;

	// If we can't accept spare ammo, then abort
	if( !CanRefillSecondaryAmmo() )
	{
		return 0;
	}

	if(Role == ROLE_Authority && !Instigator.IsLocallyControlled())
	{
		OldAmmo = ServerTotalAltAmmo;

		ServerTotalAltAmmo = Min(ServerTotalAltAmmo + Amount, GetMaxAmmoAmount(1));
		ClientGiveSecondaryAmmo(Amount);
		return ServerTotalAltAmmo - OldAmmo;
	}
	else
	{
		OldAmmo = SpareAmmoCount[1];
		ClientGiveSecondaryAmmo(Amount);
		return SpareAmmoCount[1] - OldAmmo;
	}
}

/** Give client specified amount of ammo (used player picks up ammo on the server) */
reliable client function ClientGiveSecondaryAmmo(byte Amount)
{
	SpareAmmoCount[1] = Min(SpareAmmoCount[1] + Amount, GetMaxAmmoAmount(1) - AmmoCount[1]);
	TryToAltReload(true);
}

function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	local KFWeap_AssaultRifle_Scout Weap;

	Super.SetOriginalValuesFromPickup(PickedUpWeapon);

	if(Role == ROLE_Authority && !Instigator.IsLocallyControlled())
	{
		Weap = KFWeap_AssaultRifle_Scout(PickedUpWeapon);
		ServerTotalAltAmmo = Weap.ServerTotalAltAmmo;
		SpareAmmoCount[1] = ServerTotalAltAmmo - AmmoCount[1];
	}
	else
	{
		// If we're locally controlled, don't bother using ServerTotalAltAmmo.
		SpareAmmoCount[1] = PickedUpWeapon.SpareAmmoCount[1];
	}
}

simulated state FiringSecondaryState extends WeaponFiring
{
	// Overriden to not call FireAmmunition right at the start of the state
	simulated event BeginState( Name PreviousStateName )
	{
		Super.BeginState(PreviousStateName);
		NotifyBeginState();
	}

	simulated function EndState(Name NextStateName)
	{
		Super.EndState(NextStateName);
		NotifyEndState();
	}

    /**
     * This function returns the world location for spawning the visual effects
     * Overridden to use a special offset for using the shotgun
     */
	simulated event vector GetMuzzleLoc()
	{
		local vector MuzzleLocation;

		// swap fireoffset temporarily
		FireOffset = SecondaryFireOffset;
		MuzzleLocation = Global.GetMuzzleLoc();
		FireOffset = default.FireOffset;

		return MuzzleLocation;
	}

	/** Get whether we should play the reload anim as well or not */
	simulated function name GetWeaponFireAnim(byte FireModeNum)
	{
		if (AmmoCount[FireModeNum] > 0)
		{
			return bUsingSights ? SecondaryFireIronAnim : SecondaryFireAnim;
		}
		return bUsingSights ? SecondaryFireIronAnimLast : SecondaryFireAnimLast;
	}
}

/**
 * Don't allow secondary fire to make a primary fire shell particle come out of the gun.
 */
simulated function CauseMuzzleFlash(byte FireModeNum)
{
	if(FireModeNum == ALTFIRE_FIREMODE)
	{
		if (ShotgunMuzzleFlash == None)
		{
			AttachMuzzleFlash();
		}

		if (ShotgunMuzzleFlash != none)
		{
			ShotgunMuzzleFlash.CauseMuzzleFlash(FireModeNum);
		}
		
		if ( ShotgunMuzzleFlash.bAutoActivateShellEject )
		{
			ShotgunMuzzleFlash.CauseShellEject();
			SetShellEjectsToForeground();
		}
	}
	else
	{
		Super.CauseMuzzleFlash(FireModeNum);
	}
}

simulated function AttachMuzzleFlash()
{
	super.AttachMuzzleFlash();

	if ( MySkelMesh != none )
	{
		if (ShotgunMuzzleFlashTemplate != None)
		{
			ShotgunMuzzleFlash = new(self) Class'KFMuzzleFlash'(ShotgunMuzzleFlashTemplate);
			ShotgunMuzzleFlash.AttachMuzzleFlash(MySkelMesh, ShotgunMuzzleSocket,);
		}
	}
}

/*********************************************************************************************
 * State Reloading
 * This is the default Reloading State.  It's performed on both the client and the server.
 *********************************************************************************************/

/** Do not allow alternate fire to tell the weapon to reload. Alt reload occurs in a separate codepath */
simulated function bool ShouldAutoReload(byte FireModeNum)
{
	if(FireModeNum == ALTFIRE_FIREMODE)
	{
		return false;
	}

	return Super.ShouldAutoReload(FireModeNum);
}

/** Called on local player when reload starts and replicated to server */
simulated function SendToAltReload()
{
	ReloadAmountLeft = MagazineCapacity[1] - AmmoCount[1];
	GotoState('AltReloading');
	if ( Role < ROLE_Authority )
	{
		ServerSendToAltReload();
	}
}

/** Called from client when reload starts */
reliable server function ServerSendToAltReload()
{
	ReloadAmountLeft = MagazineCapacity[1] - AmmoCount[1];
	GotoState('AltReloading');
}

/**
 * State Reloading
 * State the weapon is in when it is being reloaded (current magazine replaced with a new one, related animations and effects played).
 */
simulated state AltReloading extends Reloading
{
	ignores ForceReload, ShouldAutoReload, AllowSprinting;

	simulated function byte GetWeaponStateId()
	{
		local KFPerk Perk;
		local bool bTacticalReload;

		Perk = GetPerk();
		bTacticalReload = (Perk != None && Perk.GetUsingTactialReload(self));

		return (bTacticalReload ? WEP_ReloadSecondary_Elite : WEP_ReloadSecondary);
	}

	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		bCanceledAltAutoReload = true;
	}

	// Overridding super so we don't call functions we don't want to call.
	simulated function EndState(Name NextStateName)
	{
		ClearZedTimeResist();
		ClearTimer(nameof(ReloadStatusTimer));
		ClearTimer(nameof(ReloadAmmoTimer));

		CheckBoltLockPostReload();
		NotifyEndState();

		`DialogManager.PlayAmmoDialog( KFPawn(Instigator), float(SpareAmmoCount[1]) / float(GetMaxAmmoAmount(1)) );
	}

	// Overridding super so when this reload is called directly after normal reload state there
	// are not complications resulting from back to back reloads.
	simulated event ReplicatedEvent(name VarName)
	{
		Global.ReplicatedEvent(Varname);
	}

	/** Make sure we can inturrupt secondary reload with anything. */
	simulated function bool CanOverrideMagReload(byte FireModeNum)
	{
		return false;
	}

	/** Returns animation to play based on reload type and status */
	simulated function name GetReloadAnimName( bool bTacticalReload )
	{
		// magazine relaod
		if ( AmmoCount[1] > 0 )
		{
			return (bTacticalReload) ? SecondaryReloadAnimEliteHalf : SecondaryReloadAnimHalf;
		}
		else
		{
			return (bTacticalReload) ? SecondaryReloadAnimEliteEmpty : SecondaryReloadAnimEmpty;
		}
	}

	simulated function PerformReload(optional byte FireModeNum)
	{
		Global.PerformReload(ALTFIRE_FIREMODE);

		if(Instigator.IsLocallyControlled() && Role < ROLE_Authority)
		{
			ServerSetAltAmmoCount(AmmoCount[1]);
		}

		bCanceledAltAutoReload = false;
	}

	simulated function EReloadStatus GetNextReloadStatus(optional byte FireModeNum)
	{
		return Global.GetNextReloadStatus(ALTFIRE_FIREMODE);
	}
}


reliable server function ServerSetAltAmmoCount(byte Amount)
{
	AmmoCount[1] = Amount;
}

/** Allow reloads for primary weapon to be interupted by firing secondary weapon. */
simulated function bool CanOverrideMagReload(byte FireModeNum)
{
	if(FireModeNum == ALTFIRE_FIREMODE)
	{
		return true;
	}

	return Super.CanOverrideMagReload(FireModeNum);
}

/*********************************************************************************************
 * State Active
 * Try to get weapon to automatically reload secondary fire types when it can.
 *********************************************************************************************/
simulated state Active
{
	/** Initialize the weapon as being active and ready to go. */
	simulated event BeginState(Name PreviousStateName)
	{
		// do this last so the above code happens before any state changes
		Super.BeginState(PreviousStateName);

		// If nothing happened, try to reload
		TryToAltReload(true);
	}
}

/** Network: Local Player */
simulated function bool CanAltAutoReload(bool bIsAuto)
{
	if ( !Instigator.IsLocallyControlled() )
	{
		return false;
	}

	if(!UsesSecondaryAmmo())
	{
		return false;
	}

	// If the weapon wants to fire its primary weapon, and it can fire, do not allow weapon to automatically alt reload
	if(PendingFire(DEFAULT_FIREMODE) && HasAmmo(DEFAULT_FIREMODE))
	{
		return false;
	}

	if(!CanReload(ALTFIRE_FIREMODE))
	{
		return false;
	}

	if (bIsAuto && AmmoCount[1] > 0)
	{
		return false;
	}

	if (bCanceledAltAutoReload)
	{
		return false;
	}

	return true;
}

simulated function TryToAltReload(bool bIsAuto)
{
	if ((IsInState('Active') || IsInState('WeaponSprinting')) && CanAltAutoReload(bIsAuto))
	{
		SendToAltReload();
	}
}

simulated function int GetSecondaryAmmoForHUD()
{
	return AmmoCount[1];
}

simulated function int GetSecondarySpareAmmoForHUD()
{
	return SpareAmmoCount[1];
}

simulated function ModifyRecoil( out float CurrentRecoilModifier )
{
	if( CurrentFireMode == ALTFIRE_FIREMODE )
	{
		CurrentRecoilModifier *= AltFireRecoilScale;
	}
	
	super.ModifyRecoil( CurrentRecoilModifier );
}

defaultproperties
{
	bCanRefillSecondaryAmmo = true;

	// Content
	PackageKey="Scout"
	FirstPersonMeshName="wep_1p_famas_mesh.Wep_1stP_Famas_Rig"
	FirstPersonAnimSetNames(0)="wep_1p_famas_anim.Wep_1stP_Famas_Anim"
	PickupMeshName="WEP_3P_Famas_MESH.WEP_Famas_Pickup"
	AttachmentArchetypeName="Wep_Famas_ARCH.Wep_Famas_3P"
	MuzzleFlashTemplateName="wep_famas_arch.Wep_Famas_MuzzleFlash"
	ShotgunMuzzleFlashTemplate=KFMuzzleFlash'wep_famas_arch.Wep_Famas_Shotgun_MuzzleFlash'

	// Scope Render
	// 2D scene capture
	Begin Object Name=SceneCapture2DComponent0
		TextureTarget=TextureRenderTarget2D'Wep_Mat_Lib.WEP_ScopeLense_Target'
		FieldOfView=12.5 // "2.0X" = 25.0(our real world FOV determinant)/2.0
	End Object

	ScopedSensitivityMod = 8.0
	ScopeLenseMICTemplate = MaterialInstanceConstant'WEP_1P_FNFAL_MAT.WEP_1P_FNFAL_Scope_MAT'
	ScopeMICIndex = 2

    // FOV
    MeshFov=65
	MeshIronSightFOV=60 //45
    PlayerIronSightFOV=70

	// Depth of field
	DOF_BlendInSpeed=3.0
	DOF_FG_FocalRadius=0
	DOF_FG_MaxNearBlurSize=3.5

	// Zooming/Position
	PlayerViewOffset=(X=22.0,Y=9.f,Z=-2.f)
	IronSightPosition=(X=0,Y=0,Z=0)

	// Ammo
	MagazineCapacity[0]=30//24
	SpareAmmoCapacity[0]=180//240
	InitialSpareMags[0]=2//3
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Shotgun Ammo
	MagazineCapacity[1]=6
	SpareAmmoCapacity[1]=36//42
	InitialSpareMags[1]=1

	// Recoil
	maxRecoilPitch=100 //125 //200 //120
	minRecoilPitch=75 //100 //150 //70
	maxRecoilYaw=40 //80
	minRecoilYaw=-40 //-80
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
	IronSightMeshFOVCompensationScale=1.7
    HippedRecoilModifier=2.0 //1.5

	// Inventory / Grouping
	InventorySize=6
	GroupPriority=80 //75
	WeaponSelectTexture=Texture2D'WEP_UI_Famas_TEX.UI_WeaponSelect_Famas'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_InstantHit
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_AssaultRifle'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_Scout_Rifle'
	FireInterval(DEFAULT_FIREMODE)=+0.2//+0.12 // 500 RPM
	InstantHitDamage(DEFAULT_FIREMODE)=40.0//45.0//35.0
	Spread(DEFAULT_FIREMODE)=0.005 //0.0085
	FireOffset=(X=30,Y=4.5,Z=-5)
	SecondaryFireOffset=(X=20.f,Y=4.5,Z=-7.f)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=FiringSecondaryState
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_Scout_Shotgun'
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_Scout_Shotgun'
	InstantHitDamage(ALTFIRE_FIREMODE)=250//210//225//25.0
	PenetrationPower(ALTFIRE_FIREMODE)=4.0//2.0
   	FireInterval(ALTFIRE_FIREMODE)=+0.77 //78 RPM //+1.2 //50 RPM
	NumPellets(ALTFIRE_FIREMODE)=1//7
	Spread(ALTFIRE_FIREMODE) = 0.017
    SecondaryAmmoTexture=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_Scout'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
    WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_UMP.Play_WEP_UMP_Fire_3P_Single',FirstPersonCue=AkEvent'WW_WEP_UMP.Play_WEP_UMP_Fire_1P_Single')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_AR15.Play_WEP_SA_AR15_Handling_DryFire'
	
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_Fire_3P_Single', FirstPersonCue=AkEvent'WW_WEP_Quad_Shotgun.Play_Quad_Shotgun_Fire_1P_Single') //@TODO: Replace
    WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_AA12.Play_WEP_SA_AA12_Handling_DryFire'

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	AssociatedPerkClasses(0)=class'KFPerk_Sharpshooter'
	
	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.125f), (Stat=EWUS_Damage1, Scale=1.125f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.25f), (Stat=EWUS_Damage1, Scale=1.25f), (Stat=EWUS_Weight, Add=2)))

	bUsesSecondaryAmmoAltHUD=true
	AltFireRecoilScale = 4.5 //4.0 //2.5

	//FireAnim=Shoot_Burst2
	FireSightedAnims[0]=Shoot_Burst2_Iron
}