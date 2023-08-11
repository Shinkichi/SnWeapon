//class KFProj_Rocket_LightningBore extends KFProjectile;
class KFProj_Rocket_LightningBore extends KFProj_BallisticExplosive;

var float FuseTime;

/** This is the effect indicator that is played for the current user **/
var(Projectile) ParticleSystem ProjIndicatorTemplate;
var ParticleSystemComponent	ProjIndicatorEffects;

var bool IndicatorActive;

/**
    Fire effects
 */

simulated function TryActivateIndicator()
{
	if(!IndicatorActive && Instigator != None)
	{
		IndicatorActive = true;

		if(WorldInfo.NetMode == NM_Standalone || Instigator.Role == Role_AutonomousProxy ||
		 (Instigator.Role == ROLE_Authority && WorldInfo.NetMode == NM_ListenServer && Instigator.IsLocallyControlled() ))
		{
			if( ProjIndicatorTemplate != None )
			{
			    ProjIndicatorEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjIndicatorTemplate);
			}

			if(ProjIndicatorEffects != None)
			{
				ProjIndicatorEffects.SetAbsolute(false, false, false);
				ProjIndicatorEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
				ProjIndicatorEffects.bUpdateComponentInTick = true;
				AttachComponent(ProjIndicatorEffects);
			}
		}
	}
}

/**
 * Set the initial velocity and cook time
 */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
	   SetTimer(FuseTime, false, 'Timer_Detonate');
	}
}

/**
 * Explode after a certain amount of time
 */
function Timer_Detonate()
{
	Detonate();
}

/** Called when the owning instigator controller has left a game */
simulated function OnInstigatorControllerLeft()
{
	if( WorldInfo.NetMode != NM_Client )
	{
		SetTimer( 1.f + Rand(5) + fRand(), false, nameOf(Timer_Detonate) );
	}
}

/**
 * Trace down and get the location to spawn the explosion effects and decal
 */
simulated function GetExplodeEffectLocation(out vector HitLocation, out vector HitRotation, out Actor HitActor)
{
    local vector EffectStartTrace, EffectEndTrace;
	local TraceHitInfo HitInfo;

	EffectStartTrace = Location + vect(0,0,1) * 4.f;
	EffectEndTrace = EffectStartTrace - vect(0,0,1) * 32.f;

    // Find where to put the decal
	HitActor = Trace(HitLocation, HitRotation, EffectEndTrace, EffectStartTrace, false,, HitInfo, TRACEFLAG_Bullet);

	// If the locations are zero (probably because this exploded in the air) set defaults
    if (IsZero(HitLocation))
    {
        HitLocation = Location;
    }

	if (IsZero(HitRotation))
    {
        HitRotation = vect(0,0,1);
    }
}

/** Used to check current status of StuckTo actor (to figure out if we should fall) */
simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	StickHelper.Tick(DeltaTime);

	if (!IsZero(Velocity))
	{
		SetRelativeRotation(rotator(Velocity));
	}

	TryActivateIndicator();
}

/** Causes charge to explode */
function Detonate()
{
	local KFWeap_RocketLauncher_LightningBore WeaponOwner;
	local vector ExplosionNormal;

	if (Role == ROLE_Authority)
    {
    	WeaponOwner = KFWeap_RocketLauncher_LightningBore(Owner);
    	if (WeaponOwner != none)
    	{
    		WeaponOwner.RemoveDeployedHarpoon(, self);
    	}
    }

	ExplosionNormal = vect(0,0,1) >> Rotation;
	Explode(Location, ExplosionNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	StickHelper.UnPin();
	super.Explode(HitLocation, HitNormal);
}

simulated function Disintegrate( rotator InDisintegrateEffectRotation )
{
	local KFWeap_RocketLauncher_LightningBore WeaponOwner;

	if (Role == ROLE_Authority)
    {
    	WeaponOwner = KFWeap_RocketLauncher_LightningBore(Owner);
    	if (WeaponOwner != none)
    	{
    		WeaponOwner.RemoveDeployedHarpoon(, self);
    	}
    }

    super.Disintegrate(InDisintegrateEffectRotation);
}

simulated function SyncOriginalLocation()
{
	// IMPORTANT NOTE: We aren't actually syncing to the original location (or calling the super).
	// We just want to receive the original location so we can do a trace between that location and
	// our current location to determine if we hit any zeds between those two locations.
	// KFII-45464

	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local TraceHitInfo HitInfo;

	if (Role < ROLE_Authority && Instigator != none && Instigator.IsLocallyControlled())
	{
		HitActor = Trace(HitLocation, HitNormal, OriginalLocation, Location,,, HitInfo, TRACEFLAG_Bullet);
		if (HitActor != none)
		{
			StickHelper.TryStick(HitNormal, HitLocation, HitActor);
		}
	}
}

simulated protected function StopSimulating()
{
	super.StopSimulating();

	if (ProjIndicatorEffects!=None)
	{
        ProjIndicatorEffects.DeactivateSystem();
	}
}

/** Don't allow more than one pellet projectile to perform this check in a single frame */
/*function bool ShouldWarnAIWhenFired()
{
	return super.ShouldWarnAIWhenFired() && OwnerWeapon != none && OwnerWeapon.LastPelletFireTime < WorldInfo.TimeSeconds;
}*/

/**
 * Force the fire not to burn the instigator, since setting it in the default props is not working for some reason - Ramm
 */
simulated protected function PrepareExplosionTemplate()
{
	local Weapon OwnerWeapon;
	local Pawn OwnerPawn;
	local KFPerk_Survivalist Perk;

	//local KFPawn KFP;
	//local KFPerk CurrentPerk;
	
	ExplosionTemplate.bIgnoreInstigator = true;

    super.PrepareExplosionTemplate();

	super(KFProjectile).PrepareExplosionTemplate();
	OwnerWeapon = Weapon(Owner);
	if (OwnerWeapon != none)
	{
		OwnerPawn = Pawn(OwnerWeapon.Owner);
		if (OwnerPawn != none)
		{
			Perk = KFPerk_Survivalist(KFPawn(OwnerPawn).GetPerk());
			if (Perk != none)
			{
				ExplosionTemplate.DamageRadius *= Perk.GetAoERadiusModifier();
			}
		}
	}

    /*if( ExplosionActorClass == class'KFPerk_Demolitionist'.static.GetNukeExplosionActorClass() )
    {
		KFP = KFPawn( Instigator );
		if( KFP != none )
		{
			CurrentPerk = KFP.GetPerk();
			if( CurrentPerk != none )
			{
				CurrentPerk.SetLastHX25NukeTime( WorldInfo.TimeSeconds );
			}
		}
	}*/
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
    // For some reason on clients up close shots with this projectile
    // get HitWall calls instead of Touch calls. This little hack fixes
    // the problem. TODO: Investigate why this happens - Ramm
    // If we hit a pawn with a HitWall call on a client, do touch instead
    if( WorldInfo.NetMode == NM_Client && Pawn(Wall) != none )
    {
        Touch( Wall, WallComp, Location, HitNormal );
        return;
    }

    Super.HitWall(HitNormal, Wall, WallComp);
}

/** Only allow this projectile to cause a nuke if there hasn't been another nuke very recently */
/*simulated function bool AllowNuke()
{
	local KFPawn KFP;
	local KFPerk CurrentPerk;

	KFP = KFPawn( Instigator );
	if( KFP != none )
	{
		CurrentPerk = KFP.GetPerk();
		if( CurrentPerk != none && `TimeSince(CurrentPerk.GetLastHX25NukeTime()) < 0.25f )
		{
			return false;
		}
	}

	return super.AllowNuke();
}*/

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'WEP_Thermite_EMIT.FX_Harpoon_Projectile'
	ProjIndicatorTemplate=ParticleSystem'WEP_Thermite_EMIT.FX_Harpoon_Projectile_Indicator'

	bWarnAIWhenFired=true

	MaxSpeed=5000.0 //4000.0
	Speed=5000.0 //4000.0
	TerminalVelocity=5000 //4000

	Physics=PHYS_Falling

	TossZ=0 //150
    GravityScale=0.36 //0.5//0.7

	GlassShatterType=FMGS_ShatterAll

	bCollideComplex=true

	bIgnoreFoliageTouch=true

	bBlockedByInstigator=false
	bAlwaysReplicateExplosion=true

	FuseTime=4.0

	bNetTemporary=false
	NetPriority=5
	NetUpdateFrequency=200

	bNoReplicationToInstigator=false
	bUseClientSideHitDetection=true
	bUpdateSimulatedPosition=true
	bSyncToOriginalLocation=true
	bSyncToThirdPersonMuzzleLocation=true

	PinBoneIdx=INDEX_None

	bCanBeDamaged=true
	bCanDisintegrate=true
	Begin Object Name=CollisionCylinder
		BlockNonZeroExtent=false
		// for siren scream
		CollideActors=true
	End Object

	//AssociatedPerkClass(0)=class'KFPerk_Demolitionist'

	// explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
	    LightColor=(R=252,G=218,B=171,A=255)
		Brightness=4.f
		Radius=2000.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=FALSE
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0 // @todo: change me
		Damage=240//65//150 //250
	    DamageRadius=800//500 //600
        DamageFalloffExponent=0.f//1.f
        DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_EMP_LightningBore'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'ZED_Matriarch_ARCH.Lightning_Storm_Explosion_Arch'
        ExplosionSound=AkEvent'WW_ZED_Matriarch.Play_Matriarch_Storm_Attack_01'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
        CamShakeInnerRadius=450
        CamShakeOuterRadius=900
        CamShakeFalloff=1.f
        bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	ExplosionActorClass=class'KFExplosionActor'

	bCanStick=true
	bCanPin=true
	Begin Object Class=KFProjectileStickHelper Name=StickHelper0
	End Object
	StickHelper=StickHelper0

	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'

}