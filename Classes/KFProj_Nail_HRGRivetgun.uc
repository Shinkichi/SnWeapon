class KFProj_Nail_HRGRivetgun extends KFProjectile;

var float FuseTime;

/** This is the effect indicator that is played for the current user **/
var(Projectile) ParticleSystem ProjIndicatorTemplate;
var ParticleSystemComponent	ProjIndicatorEffects;

var bool IndicatorActive;

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

	AdjustCanDisintigrate();
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
	local vector ExplosionNormal;
	/*local KFWeap_HRG_Rivetgun HRG_RivetgunOwner;

	if (Role == ROLE_Authority)
    {
    	HRG_RivetgunOwner = KFWeap_HRG_Rivetgun(Owner);
    	if (HRG_RivetgunOwner != none)
    	{
    		HRG_RivetgunOwner.RemoveDeployedHarpoon(, self);
    	}
    }*/

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
	/*local KFWeap_HRG_Rivetgun HRG_RivetgunOwner;

	if (Role == ROLE_Authority)
    {
    	HRG_RivetgunOwner = KFWeap_HRG_Rivetgun(Owner);
    	if (HRG_RivetgunOwner != none)
    	{
    		HRG_RivetgunOwner.RemoveDeployedHarpoon(, self);
    	}
    }*/

    super.Disintegrate(InDisintegrateEffectRotation);
}

// for nukes && concussive force
simulated protected function PrepareExplosionTemplate()
{
	class'KFPerk_Demolitionist'.static.PrepareExplosive(Instigator, self);

	super.PrepareExplosionTemplate();
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

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'WEP_HX25_Pistol_EMIT.FX_HX25_Pistol_Projectile_small'
	ProjIndicatorTemplate=ParticleSystem'WEP_Seal_Squeal_EMIT.FX_Harpoon_Projectile_Indicator'
	AltExploEffects=KFImpactEffectInfo'WEP_HX25_Pistol_ARCH.HX25_Pistol_Submunition_Explosion_Concussive_Force'

	bWarnAIWhenFired=true

	MaxSpeed=4000.0
	Speed=4000.0
	TerminalVelocity=4000

	Physics=PHYS_Falling

	TossZ=150
    GravityScale=0.5//0.7

	GlassShatterType=FMGS_ShatterAll

	bCollideComplex=true

	bIgnoreFoliageTouch=true

	bBlockedByInstigator=false
	bAlwaysReplicateExplosion=true

	FuseTime=1.0//4.0

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

	// Grenade explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
	    LightColor=(R=252,G=218,B=171,A=255)
		Brightness=4.f
		Radius=250.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=FALSE
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=30
		DamageRadius=150
		DamageFalloffExponent=1.0f
		DamageDelay=0.f

		MomentumTransferScale=1.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_HRGRivetgun'
		KnockDownStrength=10
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_HX25_Pistol_ARCH.HX25_Pistol_Submunition_Explosion'
		ExplosionSound=AkEvent'WW_WEP_SA_HX25.Play_WEP_SA_HX25_Mini_Explosion'
		bIgnoreInstigator=true
		ActorClassToIgnoreForDamage=class'KFProj_Nail_HRGRivetgun'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.3

		// Camera Shake
		CamShake=KFCameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=300
		CamShakeFalloff=1.5f
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