class KFWeap_Blunt_RiotHammer extends KFWeap_MeleeBase;

/** Explosion actor class to spawn */
var class<KFExplosionActor> ExplosionActorClass;
var() KFGameExplosion ExplosionTemplate;
var() KFGameExplosion LightAttackExplosionTemplate;

/** The actor the alt attack explosion should attach to */
var transient Actor BlastAttachee;

/** The hit location of the blast */
var vector BlastHitLocation;

/** Spawn location offset to improve cone hit detection */
var transient float BlastSpawnOffset;

/** Starting Damage radius of the alt attack explosion*/
var float StartingDamageRadius;

/** Animations that play in reaction to hitting with the alt fire attack*/
const HardFire_L = 'HardFire_L';
const HardFire_R = 'HardFire_R';
const HardFire_F = 'HardFire_F';
const HardFire_B = 'HardFire_B';

var bool bFriendlyFireEnabled;

replication
{
	if (bNetInitial)
		bFriendlyFireEnabled;
}

simulated event bool HasAmmo(byte FireModeNum, optional int Amount)
{
	// Default fire mode either has ammo to trigger the heal or needs to return true to still allow a basic swing
	if (FireModeNum == DEFAULT_FIREMODE)
	{
		return true;
	}

	return super.HasAmmo(FireModeNum, Amount);
}




/** Healing charge doesn't count as ammo for purposes of inventory management (e.g. switching) */
simulated function bool HasAnyAmmo()
{
	// Special ammo is stored in the default firemode (heal darts are separate)
	if (HasSpareAmmo() || AmmoCount[DEFAULT_FIREMODE] >= AmmoCost[CUSTOM_FIREMODE])
	{
		return true;
	}

	return false;
}

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	/** Initially check whether friendly fire is on or not. */
	if (Role == ROLE_Authority && KFGameInfo(WorldInfo.Game).FriendlyFireScale != 0.f)
	{
		bFriendlyFireEnabled = true;
	}

	if (ExplosionTemplate != none)
	{
		StartingDamageRadius = ExplosionTemplate.DamageRadius;
	}
}

/** Pulverizer should be able to interrupt its reload state with any melee attack */
simulated function bool CanOverrideMagReload(byte FireModeNum)
{
	return FireModeNum != RELOAD_FIREMODE;
}

/** Override to allow for two different states associated with RELOAD_FIREMODE */
simulated function SendToFiringState(byte FireModeNum)
{
	// Ammo needs to be synchronized on client/server for this to work!
	if ( FireModeNum == RELOAD_FIREMODE && !Super(KFWeapon).CanReload() )
	{
		SetCurrentFireMode(FireModeNum);
		GotoState('WeaponUpkeep');
		return;
	}

	Super.SendToFiringState(FireModeNum);
}

/** Always allow reload and choose the correct state in SendToFiringState() */
simulated function bool CanReload(optional byte FireModeNum)
{
	return true;
}

/** Skip calling StillFiring/PendingFire to fix log warning */
simulated function bool ShouldRefire()
{
	if ( CurrentFireMode == CUSTOM_FIREMODE )
		return false;

	return Super.ShouldRefire();
}

simulated protected function PrepareExplosion()
{
	local KFPlayerController KFPC;
	local KFPerk InstigatorPerk;

	ExplosionTemplate = default.ExplosionTemplate;
	ExplosionTemplate.DamageRadius = StartingDamageRadius;

	// Change the radius and damage based on the perk
	if (Owner.Role == ROLE_Authority)
	{
		KFPC = KFPlayerController(Instigator.Controller);
		if (KFPC != none)
		{
			`Log("RADIUS BEFORE: " $ExplosionTemplate.DamageRadius);

			InstigatorPerk = KFPC.GetPerk();
			ExplosionTemplate.DamageRadius *= InstigatorPerk.GetAoERadiusModifier();

			`Log("RADIUS BEFORE: " $ExplosionTemplate.DamageRadius);

		}
	}

	ExplosionActorClass = default.ExplosionActorClass;
}

/** Get the hard fire anim when the alt fire attack connects */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	// Adjust cone fire angle based on swing direction
	switch (MeleeAttackHelper.CurrentAttackDir)
	{
	case DIR_Forward:
	case DIR_ForwardLeft:
	case DIR_ForwardRight:
		return HardFire_F;
	case DIR_Backward:
	case DIR_BackwardLeft:
	case DIR_BackwardRight:
		return HardFire_B;
	case DIR_Left:
		return HardFire_L;
	case DIR_Right:
		return HardFire_R;
	}
	return '';
}

simulated function SpawnExplosionFromTemplate(KFGameExplosion Template)
{
	local KFExplosionActor ExploActor;
	local vector SpawnLoc;
	local rotator SpawnRot;

	SpawnLoc = BlastHitLocation;
	SpawnRot = GetAdjustedAim(SpawnLoc);

	// explode using the given template
	ExploActor = Spawn(ExplosionActorClass, self, , SpawnLoc, SpawnRot, , true);
	if (ExploActor != None)
	{
		ExploActor.InstigatorController = Instigator.Controller;
		ExploActor.Instigator = Instigator;
		ExplosionTemplate.bFullDamageToAttachee = true;

		KFExplosionActorReplicated(ExploActor).bIgnoreInstigator = false;
		ExploActor.bReplicateInstigator = true;

		ExploActor.Explode(Template, vector(SpawnRot));
	}

	// Reset damage radius
	ExplosionTemplate.DamageRadius = StartingDamageRadius;
}

simulated function CustomFire()
{
	if (Instigator.Role < ROLE_Authority)
	{
		return;
	}

	PrepareExplosion();
	SpawnExplosionFromTemplate(ExplosionTemplate);

	// tell remote clients that we fired, to trigger effects in third person
	IncrementFlashCount();
}

// HEAVY ATTACK
simulated state MeleeHeavyAttacking
{
	/** Network: Local Player */
	simulated function NotifyMeleeCollision(Actor HitActor, optional vector HitLocation)
	{
		local KFPawn Victim;

		// If fire button is being held down, try firing pulverizer
		if ( Instigator != None && Instigator.IsLocallyControlled() /*&& !bPulverizerFireReleased*/ )
		{
			// only detonate when the pulverizer hits a pawn so that level geometry doesn't get in the way
			if ( HitActor.bWorldGeometry )
			{
				return;
			}

			Victim = KFPawn(HitActor);
			if ( Victim == None ||
				(!bFriendlyFireEnabled && Victim.GetTeamNum() == Instigator.GetTeamNum()) ||
				(Victim.bPlayedDeath && `TimeSince(Victim.TimeOfDeath) > 0.f) )
			{
				return;
			}

			if (AmmoCount[0] >= AmmoCost[CUSTOM_FIREMODE] && !IsTimerActive(nameof(BeginMedicBatExplosion)))
			{
				BlastAttachee = HitActor;
				BlastHitLocation = HitLocation;

				// need to delay one frame, since this is called from AnimNotify
				SetTimer(0.001f, false, nameof(BeginMedicBatExplosion));

				if (Role < ROLE_Authority && Instigator.IsLocallyControlled())
				{
					if (!HitActor.bTearOff || Victim == none)
					{
						ServerBeginMedicBatExplosion(HitActor, HitLocation);
					}
				}
			}
		}
	}
}

/** Called on the server */
reliable server private function ServerBeginMedicBatExplosion(Actor HitActor, optional vector HitLocation)
{
	// Ignore if too far away (something went wrong!)
	if (VSizeSq2D(HitLocation - Instigator.Location) > Square(500))
	{
		return;
	}

	BlastHitLocation = HitLocation;
	BlastAttachee = HitActor;
	SendToFiringState(CUSTOM_FIREMODE);
}

/** Called when altfire melee attack hits a target and there is ammo left */
simulated function BeginMedicBatExplosion()
{
	SendToFiringState(CUSTOM_FIREMODE);
}

/*********************************************************************************************
 * State Active
 * A Weapon this is being held by a pawn should be in the active state.  In this state,
 * a weapon should loop any number of idle animations, as well as check the PendingFire flags
 * to see if a shot has been fired.
 *********************************************************************************************/

simulated state Active
{
	/**
	 * Called from Weapon:Active.BeginState when HasAnyAmmo (which is overridden above) returns false.
	 */
	simulated function WeaponEmpty()
	{
		local int i;

		// Copied from Weapon:Active.BeginState where HasAnyAmmo returns true.
		// Basically, pretend the weapon isn't empty in this case.
		for (i=0; i<GetPendingFireLength(); i++)
		{
			if (PendingFire(i))
			{
				BeginFire(i);
				break;
			}
		}
	}
}

defaultproperties
{
	// Content
	PackageKey="RiotHammer"
	FirstPersonMeshName="WEP_1P_Pulverizer_MESH.Wep_1stP_Pulverizer_Rig_New"
	AttachmentArchetypeName="WEP_Pulverizer_ARCH.Wep_Pulverizer_3P"
	FirstPersonAnimSetNames(0)="WEP_1P_Pulverizer_ANIM.Wep_1stP_Pulverizer_Anim"
	PickupMeshName="WEP_3P_Pulverizer_MESH.Wep_Pulverizer_Pickup"
	MuzzleFlashTemplateName="WEP_Pulverizer_ARCH.Wep_Pulverizer_MuzzleFlash"

	Begin Object Name=MeleeHelper_0
		MaxHitRange=190
		WorldImpactEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Blunted_melee_impact'
		// Override automatic hitbox creation (advanced)
		HitboxChain.Add((BoneOffset=(Y=-3,Z=170)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=150)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=130)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=110)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=90)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=70)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=50)))
		HitboxChain.Add((BoneOffset=(Y=+3,Z=30)))
		HitboxChain.Add((BoneOffset=(Y=-3,Z=10)))
		// modified combo sequences
		MeleeImpactCamShakeScale=0.04f //0.5
		ChainSequence_F=(DIR_ForwardRight, DIR_ForwardLeft, DIR_ForwardRight, DIR_ForwardLeft)
		ChainSequence_B=(DIR_BackwardRight, DIR_ForwardLeft, DIR_BackwardLeft, DIR_ForwardRight)
		ChainSequence_L=(DIR_Right, DIR_ForwardLeft, DIR_ForwardRight, DIR_Left, DIR_Right)
		ChainSequence_R=(DIR_Left, DIR_ForwardRight, DIR_ForwardLeft, DIR_Right, DIR_Left)
	End Object

	// Reload
	FiringStatesArray(RELOAD_FIREMODE)=Reloading

	// Ammo
	MagazineCapacity[0]=5
	SpareAmmoCapacity[0]=15
	InitialSpareMags[0]=0
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Inventory
	GroupPriority=75
	InventorySize=6
	WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_Pulverizer'

	// Default
	// Maps to Alt Ammo
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BluntMelee'
	InstantHitDamage(DEFAULT_FIREMODE)=80
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Bludgeon_RiotHammer'

	// Heavy Attack
	FireModeIconPaths(HEAVY_ATK_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BluntMelee'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=145
	InstantHitDamageTypes(HEAVY_ATK_FIREMODE)=class'KFDT_Bludgeon_RiotHammerHeavy'

	// Heavy Attack Explosion
	FireModeIconPaths(CUSTOM_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(CUSTOM_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(CUSTOM_FIREMODE)=EWFT_Custom
	FireInterval(CUSTOM_FIREMODE)=1.0f
	AmmoCost(CUSTOM_FIREMODE)=1

	// Bash
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_RiotHammerBash'
	InstantHitDamage(BASH_FIREMODE)=20

	// Perk
	AssociatedPerkClasses(0)=class'KFPerk_Berserker'
	//AssociatedPerkClasses(1)=class'KFPerk_SWAT'

	// Block and Parry
	BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Block_MEL_Hammer'
	ParrySound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Wood'
	ParryDamageMitigationPercent=0.40
	BlockDamageMitigation=0.50
	ParryStrength=5

	// Explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
		LightColor=(R = 0,G = 128,B = 255,A = 255)
		Brightness=4.f
		Radius=500.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=True
		bEnabled=FALSE
		LightingChannels=(Indoor = TRUE,Outdoor = TRUE,bInitialized = TRUE)
	End Object

	// Explosion
	ExplosionActorClass = class'KFExplosionActorReplicated'
	//ExplosionActorClass = class'KFExplosionActor'
	Begin Object Class=KFGameExplosion Name=HeavyAttackHealingExplosion
		Damage=125  //300
		DamageRadius=700  //800
		DamageFalloffExponent=2.f
		DamageDelay=0.f
		MyDamageType=class'KFDT_Explosive_RiotHammer'

		// Damage Effects
		KnockDownStrength=0
		KnockDownRadius=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0	
		ExplosionEffects=KFImpactEffectInfo'WEP_M84_ARCH.M84_Explosion'
		ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Frag.Play_WEP_Flashbang'
		//MomentumTransferScale=0
		//bIgnoreInstigator=false

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=HeavyAttackHealingExplosion

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.05f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.1f,IncrementWeight=2)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.1f), (Stat=EWUS_Damage1, Scale=1.1f), (Stat=EWUS_Damage2, Scale=1.1f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Damage1, Scale=1.2f), (Stat=EWUS_Damage2, Scale=1.2f), (Stat=EWUS_Weight, Add=2)))

}}