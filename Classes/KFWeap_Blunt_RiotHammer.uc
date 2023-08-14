class KFWeap_Blunt_RiotHammer extends KFWeap_MeleeBase;

const ShootAnim_L = 'HardFire_L';
const ShootAnim_R = 'HardFire_R';
const ShootAnim_F = 'HardFire_F';
const ShootAnim_B = 'HardFire_B';

var bool bWasTimeDilated;

/** Explosion actor class to spawn */
var class<KFExplosionActor> ExplosionActorClass;
var() KFGameExplosion ExplosionTemplate;
/** If true, use an alternate set of explosion effects */
var bool    bAltExploEffects;
var KFImpactEffectInfo AltExploEffects;

var transient Actor BlastAttachee;

/** Spawn location offset to improve cone hit detection */
var transient float BlastSpawnOffset;

/** If set, heavy attack button has been released during the attack */
var transient bool bPulverizerFireReleased;

var bool bFriendlyFireEnabled;

var class<KFExplosionActor> NukeExplosionActorClass;

var float StartingDamageRadius;

replication
{
	if (bNetInitial)
		bFriendlyFireEnabled;
}

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	/** Initially check whether friendly fire is on or not. */
	if(Role == ROLE_Authority && KFGameInfo(WorldInfo.Game).FriendlyFireScale != 0.f)
	{
		bFriendlyFireEnabled = true;
	}

	if (ExplosionTemplate != none)
	{
		StartingDamageRadius = ExplosionTemplate.DamageRadius;
	}
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


simulated event bool HasAmmo(byte FireModeNum, optional int Amount)
{
	// Default fire mode either has ammo to trigger the heal or needs to return true to still allow a basic swing
	if (FireModeNum == DEFAULT_FIREMODE)
	{
		return true;
	}

	return super.HasAmmo(FireModeNum, Amount);
}

/** Pulverizer should be able to interrupt its reload state with any melee attack */
simulated function bool CanOverrideMagReload(byte FireModeNum)
{
	return FireModeNum != RELOAD_FIREMODE;
}

/** Explosion Actor version */
simulated function CustomFire()
{
	local KFExplosionActor ExploActor;
	local vector SpawnLoc;
	local rotator SpawnRot;

	if ( Instigator.Role < ROLE_Authority )
	{
		return;
	}

	// On local player or server, we cache off our time dilation setting here
	if (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_DedicatedServer || Instigator.Controller != None)
	{
		bWasTimeDilated = WorldInfo.TimeDilation < 1.f;
	}

	PrepareExplosionTemplate();
	SetExplosionActorClass();

	SpawnLoc = Instigator.GetWeaponStartTraceLocation();
	SpawnRot = GetPulverizerAim(SpawnLoc);

	// nudge backwards to give a wider code near the player
	SpawnLoc += vector(SpawnRot) * BlastSpawnOffset;

	// explode using the given template
	ExploActor = Spawn(ExplosionActorClass, self,, SpawnLoc, SpawnRot,, true);
	if (ExploActor != None)
	{
		ExploActor.InstigatorController = Instigator.Controller;
		ExploActor.Instigator = Instigator;

		// Force the actor we collided with to get hit again (when DirectionalExplosionAngleDeg is small)
		// This is only necessary on server since GetEffectCheckRadius() will be zero on client
		ExploActor.Attachee = BlastAttachee;
		ExplosionTemplate.bFullDamageToAttachee = true;

		// enable muzzle location sync
		ExploActor.bReplicateInstigator = true;
		ExploActor.SetSyncToMuzzleLocation(true);

		ExploActor.Explode(ExplosionTemplate, vector(SpawnRot));
	}

	// tell remote clients that we fired, to trigger effects in third person
	IncrementFlashCount();

	if ( bDebug )
	{
		DrawDebugCone(SpawnLoc, vector(SpawnRot), ExplosionTemplate.DamageRadius, ExplosionTemplate.DirectionalExplosionAngleDeg * DegToRad,
			ExplosionTemplate.DirectionalExplosionAngleDeg * DegToRad, 16, MakeColor(64,64,255,0), TRUE);
	}
}

simulated protected function PrepareExplosionTemplate()
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
			InstigatorPerk = KFPC.GetPerk();
			ExplosionTemplate.DamageRadius *= InstigatorPerk.GetAoERadiusModifier();
		}
	}

	ExplosionActorClass = default.ExplosionActorClass;
}

simulated protected function SetExplosionActorClass()
{
	ExplosionActorClass = default.ExplosionActorClass;
}


/** Called by CustomFire when shotgun blast is fired */
simulated function Rotator GetPulverizerAim( vector StartFireLoc )
{
	local Rotator R;

	R = GetAdjustedAim(StartFireLoc);

	// Adjust cone fire angle based on swing direction
	switch (MeleeAttackHelper.CurrentAttackDir)
	{
		case DIR_Left:
			R.Yaw += 5461;
			break;
		case DIR_Right:
			R.Yaw -= 5461;
			break;
		case DIR_Forward:
			R.Pitch -= 2048;
			break;
		case DIR_Backward:
			R.Pitch += 2048;
			break;
	}

	return R;
}

/** Don't play a shoot anim when FireAmmunition is called */
simulated function name GetWeaponFireAnim(byte FireModeNum)
{
	// Adjust cone fire angle based on swing direction
	switch (MeleeAttackHelper.CurrentAttackDir)
	{
		case DIR_Forward:
		case DIR_ForwardLeft:
		case DIR_ForwardRight:
			return ShootAnim_F;
		case DIR_Backward:
		case DIR_BackwardLeft:
		case DIR_BackwardRight:
			return ShootAnim_B;
		case DIR_Left:
			return ShootAnim_L;
		case DIR_Right:
			return ShootAnim_R;
	}
	return '';
}

/** Called on the server alongside PulverizerFired */
reliable server private function ServerBeginPulverizerFire(Actor HitActor, optional vector HitLocation)
{
	// Ignore if too far away (something went wrong!)
	if ( VSizeSq2D(HitLocation - Instigator.Location) > Square(500) )
	{
		`log("ServerBeginPulverizerFire outside of range!");
		return;
	}

	BlastAttachee = HitActor;
	SendToFiringState(CUSTOM_FIREMODE);
}

/** Called when altfire melee attack hits a target and there is ammo left */
simulated function BeginPulverizerFire()
{
	SendToFiringState(CUSTOM_FIREMODE);
}

/** Skip calling StillFiring/PendingFire to fix log warning */
simulated function bool ShouldRefire()
{
	if ( CurrentFireMode == CUSTOM_FIREMODE )
		return false;

	return Super.ShouldRefire();
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

/** Debugging */
`if(`notdefined(ShippingPC))
exec function ToggleWeaponDebug()
{
	bDebug = !bDebug;
}
`endif

/*********************************************************************************************
 * State MeleeHeavyAttacking
 * This is the alt-fire Melee State.
 *********************************************************************************************/

simulated state MeleeHeavyAttacking
{
	/** Reset bPulverizerFireReleased */
	simulated event BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		bPulverizerFireReleased = false;
	}

	/** Set bPulverizerFireReleased to ignore NotifyMeleeCollision */
	simulated function StopFire(byte FireModeNum)
	{
		Super.StopFire(FireModeNum);
		bPulverizerFireReleased = true;
	}

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

			if ( AmmoCount[0] >= AmmoCost[CUSTOM_FIREMODE] && !IsTimerActive(nameof(BeginPulverizerFire)) )
			{
				BlastAttachee = HitActor;

				// need to delay one frame, since this is called from AnimNotify
				SetTimer(0.001f, false, nameof(BeginPulverizerFire));

				if ( Role < ROLE_Authority )
				{
					if( HitActor.bTearOff && Victim != none )
					{
						Victim.TakeRadiusDamage(Instigator.Controller, ExplosionTemplate.Damage, ExplosionTemplate.DamageRadius, ExplosionTemplate.MyDamageType,
							ExplosionTemplate.MomentumTransferScale, Location, true, (Owner != None) ? Owner : self);
					}
					else
					{
						ServerBeginPulverizerFire(HitActor, HitLocation);
					}
				}
			}
		}
	}
}

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
	AssociatedPerkClasses(0)=class'KFPerk_Berserker'
	AssociatedPerkClasses(1)=class'KFPerk_SWAT'

	// Content
	PackageKey="RiotHammer"
	FirstPersonMeshName="WEP_1P_Pulverizer_MESH.Wep_1stP_Pulverizer_Rig_New"
	FirstPersonAnimSetNames(0)="WEP_1P_Pulverizer_ANIM.Wep_1stP_Pulverizer_Anim"
	PickupMeshName="WEP_3P_Pulverizer_MESH.Wep_Pulverizer_Pickup"
	AttachmentArchetypeName="WEP_Pulverizer_ARCH.Wep_Pulverizer_3P"
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

	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BluntMelee'
	InstantHitDamage(DEFAULT_FIREMODE)=80
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Bludgeon_RiotHammer'

	FireModeIconPaths(HEAVY_ATK_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BluntMelee'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=145
	InstantHitDamageTypes(HEAVY_ATK_FIREMODE)=class'KFDT_Bludgeon_RiotHammerHeavy'

	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_RiotHammerBash'
	InstantHitDamage(BASH_FIREMODE)=20

	// Trigger explosion
	FireModeIconPaths(CUSTOM_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_ShotgunSingle'
	FiringStatesArray(CUSTOM_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(CUSTOM_FIREMODE)=EWFT_Custom
	FireInterval(CUSTOM_FIREMODE)=1.0f
	AmmoCost(CUSTOM_FIREMODE)=1

	BlastSpawnOffset=-10.f

	// Explosion settings.  Using archetype so that clients can serialize the content
	// without loading the 1st person weapon content (avoid 'Begin Object')!
	ExplosionActorClass=class'KFExplosionActorReplicated'
	ExplosionTemplate=KFGameExplosion'SnWeapon_Packages.Wep_RiotHammer_Explosion'
	//ExplosionTemplate=KFGameExplosion'WEP_Pulverizer_ARCH.Wep_Pulverizer_Explosion'
	AltExploEffects = none//KFImpactEffectInfo'WEP_RPG7_ARCH.RPG7_Explosion_Concussive_Force' //Leave this alone until we want it

	//NukeExplosionActorClass=class'KFExplosion_ReplicatedNuke'

	// RELOAD
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

	// Fire Effects
	WeaponFireSnd(CUSTOM_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_MEL_Pulverizer.Play_WEP_MEL_Pulverizer_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_MEL_Pulverizer.Play_WEP_MEL_Pulverizer_Fire_1P')

	// Block Effects
	BlockSound=AkEvent'WW_WEP_Bullet_Impacts.Play_Block_MEL_Hammer'
	ParrySound=AkEvent'WW_WEP_Bullet_Impacts.Play_Parry_Wood'

	// Trader
	ParryDamageMitigationPercent=0.40
	BlockDamageMitigation=0.50

	ParryStrength=5

	// Weapon Upgrade stat boosts
	//WeaponUpgrades[1]=(IncrementDamage=1.05f,IncrementWeight=1)
	//WeaponUpgrades[2]=(IncrementDamage=1.1f,IncrementWeight=2)

	WeaponUpgrades[1]=(Stats=((Stat=EWUS_Damage0, Scale=1.1f), (Stat=EWUS_Damage1, Scale=1.1f), (Stat=EWUS_Damage2, Scale=1.1f), (Stat=EWUS_Weight, Add=1)))
	WeaponUpgrades[2]=(Stats=((Stat=EWUS_Damage0, Scale=1.2f), (Stat=EWUS_Damage1, Scale=1.2f), (Stat=EWUS_Damage2, Scale=1.2f), (Stat=EWUS_Weight, Add=2)))
}