
class KFProj_HighExplosive_HRG_Paramedic extends KFProj_BallisticExplosive
	hidedropdown;

var transient bool bHitWall;

simulated event PreBeginPlay()
{
	local KFPawn InstigatorPawn;
    local KFPawn_HRG_Paramedic InstigatorPawnWarthog;

	InstigatorPawnWarthog = KFPawn_HRG_Paramedic(Instigator);
    if (InstigatorPawnWarthog != none)
    {
		InstigatorPawn = KFPawn(InstigatorPawnWarthog.OwnerWeapon.Instigator);

		if (InstigatorPawn != none)
		{
			Instigator = InstigatorPawn;
		}
	}

    Super.PreBeginPlay();
}

simulated function bool AllowNuke()
{
	return False;//true;
}

simulated function bool AllowDemolitionistConcussive()
{
	return False;//true;
}

simulated function bool AllowDemolitionistExplosionChangeRadius()
{
	return False;//true;
}

// Used by Demolitionist Nuke and Mad Bomber skills
simulated function bool CanDud()
{
    return false;
}

simulated function SetupDetonationTimer(float FuseTime)
{
	if (FuseTime > 0)
	{
		bIsTimedExplosive = true;
		SetTimer(FuseTime, false, 'ExplodeTimer');
	}
}

function ExplodeTimer()
{
    local Actor HitActor;
    local vector HitLocation, HitNormal;

	GetExplodeEffectLocation(HitLocation, HitNormal, HitActor);

    TriggerExplosion(HitLocation, HitNormal, HitActor);
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
    if( IsZero(HitLocation) )
    {
        HitLocation = Location;
    }

	if( IsZero(HitRotation) )
    {
        HitRotation = vect(0,0,1);
    }
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local Vector VNorm;
    local rotator NewRotation;
    local Vector Offset;

	bHitWall = true;

	if (bIsTimedExplosive)
	{
 		// Reflect off Wall w/damping
		VNorm = (Velocity dot HitNormal) * HitNormal;

		Velocity = -VNorm * DampenFactor + (Velocity - VNorm) * DampenFactorParallel;

		Speed = VSize(Velocity);

    	if (WorldInfo.NetMode != NM_DedicatedServer && Pawn(Wall) == none)
    	{
            // do the impact effects
    		`ImpactEffectManager.PlayImpactEffects(Location, Instigator, HitNormal, GrenadeBounceEffectInfo, true );
    	}

		// if we hit a pawn or we are moving too slowly stop moving and lay down flat
		if ( Speed < MinSpeedBeforeStop  )
		{
			ImpactedActor = Wall;
			SetPhysics(PHYS_None);

			if( ProjEffects != none )
			{
                ProjEffects.SetTranslation(LandedTranslationOffset);
            }

        	// Position the shell on the ground
            RotationRate.Yaw = 0;
        	RotationRate.Pitch = 0;
        	RotationRate.Roll = 0;
        	NewRotation = Rotation;
        	NewRotation.Pitch = 0;
			if(ResetRotationOnStop)
			{
				SetRotation(NewRotation);
			}
			Offset.Z = LandedTranslationOffset.X;
			SetLocation(Location + Offset);
		}

		return;
	}

	if( WorldInfo.NetMode == NM_Standalone ||
		(WorldInfo.NetMode == NM_ListenServer && Instigator != none && Instigator.IsLocallyControlled()) )
	{
    	TriggerExplosion(Location, HitNormal, None);
		Shutdown();	// cleanup/destroy projectile
		return;
	}

	if( Owner != none && KFWeapon( Owner ) != none && Instigator != none )
	{
		if( Instigator.Role == ROLE_Authority)
		{
			KFWeap_HRG_ParamedicWeapon(Owner).ForceExplosionReplicateKill(Location, self);
		}
	}

	StopSimulating();	// cleanup/destroy projectile
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // If we collided with a Siren shield, let the shield code handle touches
    if( Other.IsA('KFTrigger_SirenProjectileShield') )
    {
        return;
    }

	if ( !bCollideWithTeammates && Pawn(Other) != None )
	{
        // Don't hit teammates
		if( Other.GetTeamNum() == GetTeamNum() )
		{
            return;
		}
	}

	// Process impact hits
	if (Other != Instigator && !Other.bStatic)
	{
		ProcessBulletTouch(Other, HitLocation, HitNormal);
	}

	if (bIsTimedExplosive)
	{
		return;
	}

	if( WorldInfo.NetMode == NM_Standalone ||
		(WorldInfo.NetMode == NM_ListenServer && Instigator != none && Instigator.IsLocallyControlled()) )
	{
		// Call KFProjectile base code.. as we don't want to repeat the KFProj_BallisticExplosive base again
		TriggerExplosion(HitLocation, HitNormal, Other);
		Shutdown();	// cleanup/destroy projectile
		return;
	}

	if( Owner != none && KFWeapon( Owner ) != none && Instigator != none )
	{
		// Special case, for some very complicate reason around replication, instigators and the Warthog pawn
		// This code on the base class was never triggered on Clients: (IsLocallyControlled() always fails, also on the rightful owner of he projectile)
		// if( Instigator.Role < ROLE_Authority && Instigator.IsLocallyControlled() )
		// Hence we call here a reliable client function on the Owner
		// That will call exactly the same code that's inside that If on the base class of this file

		if( Instigator.Role == ROLE_Authority)
		{
			KFWeap_HRG_ParamedicWeapon(Owner).ForceExplosionReplicate(Other, HitLocation, HitNormal, self);
		}
	}

	StopSimulating();
}

simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (bHitWall == false)
		{
			SetRotation(rotator(Normal(Velocity)));
		}
	}
}

/** This will cause the projectile to move to the Original Spawn location when first replicated. This solves the issue of the projectile spawning some distance away from the player when first replicated */
simulated function SyncOriginalLocation()
{
	local vector MuzzleLocation, PredictedHitLocation, AimDir, EndTrace, MuzzleToPredictedHit;

	if ( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// For remote pawns, have the projectile look like its actually
    // coming from the muzzle of the third person weapon
    if( bSyncToThirdPersonMuzzleLocation && Instigator != none
        && !Instigator.IsFirstPerson() && KFPawn(Owner) != none
        && KFPawn(Owner).WeaponAttachment != none )
    {
        MuzzleLocation = KFPawn(Owner).WeaponAttachment.GetMuzzleLocation(bFiredFromLeftHandWeapon ? 1 : 0);

        // Set the aim direction to the vector along the line where the
        // projectile would hit based on velocity. This is the most accurate
        if( !IsZero(Velocity) )
        {
            AimDir = Normal(Velocity);
        }

        // Set the aim direction to the vector along the line where the
        // projectile would hit based on where it has moved away from
        // the original location
        if( IsZero(Velocity) )
        {
            AimDir = Normal(Location-OriginalLocation);
        }

        // Use the rotation if the location calcs give a zero direction
        if( IsZero(AimDir) )
        {
            AimDir = Normal(Vector(Rotation));
        }

        if( Location != MuzzleLocation )
        {
        	// if projectile is spawned at different location than the third
            // person muzzle location, then simulate an instant trace where
            // the projectile would hit
        	EndTrace = Location + AimDir * 16384;
        	PredictedHitLocation = GetPredictedHitLocation(Location, EndTrace);

        	MuzzleToPredictedHit = Normal(PredictedHitLocation - MuzzleLocation);

        	// only adjust AimDir if PredictedHitLocation is "forward" (i.e. don't let projectile fire back towards the shooter)
            //@todo: still need to make this less wonky (can still shoot straight up sometimes when using long weapons, like the sawblade shooter)
        	if( MuzzleToPredictedHit dot vector(Rotation) > 0.f )
        	{
        		// Then we realign projectile aim direction to match where the projectile would hit.
        		AimDir = MuzzleToPredictedHit;
        	}
        }

        // Move the projectile to the MuzzleLocation
        SetLocation(MuzzleLocation);

        // If the Velocity is zero (usually because the projectile impacted
        // something on the server in its first tick before replicating)
        // then turn its phyics and collion back on
        if( IsZero(Velocity) )
        {
            SetPhysics(default.Physics);
            SetCollision( default.bCollideActors, default.bBlockActors );
        }

        // Adjust the velocity of the projectile so it will hit where
        // it is supposed to
        Velocity = Speed * Normal(AimDir);
    }
	// set location based on 'OriginalLocation'
    else if ( Role < ROLE_Authority )
    {
        // If the Velocity is zero (usually because the projectile impacted
        // something on the server in its first tick before replicating)
        // then turn its physics and collion back on and give it velocity
        // again so the simulation will work properly on the client
        if( IsZero(Velocity) )
        {
            SetPhysics(default.Physics);

            // Set the aim direction to the vector along the line where the
            // projectile would hit
            AimDir = Normal(Location-OriginalLocation);

            // Use the rotation if the location calcs give a zero direction
            if( IsZero(AimDir) )
            {
                AimDir = Vector(Rotation);
            }

            Velocity = Speed * AimDir;
            SetCollision( default.bCollideActors, default.bBlockActors );
        }

        SetLocation(OriginalLocation);
    }
}


defaultproperties
{
	bCollideWithTeammates = false

	Physics=PHYS_Falling
	Speed=2000
	MaxSpeed=2000
	TerminalVelocity=2000
	TossZ=0
	GravityScale=1.0
    MomentumTransfer=50000.0
    ArmDistSquared=0
    LifeSpan=25.0f

	bIsTimedExplosive = false

	bWarnAIWhenFired=true

	ProjFlightTemplate=ParticleSystem'WEP_HRG_Warthog_EMIT.FX_HRG_Warthog_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_Warthog_EMIT.FX_HRG_Warthog_Projectile_ZEDTIME'
	ProjDudTemplate=ParticleSystem'WEP_HRG_Warthog_EMIT.FX_HRG_Warthog_Projectile_Dud'
	GrenadeBounceEffectInfo=KFImpactEffectInfo'FX_Impacts_ARCH.DefaultGrenadeImpacts'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
	AltExploEffects=KFImpactEffectInfo'WEP_HRG_Warthog_ARCH.HRG_Warthog_Explosion_Concussive_Force'

	// Grenade explosion light
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

	ExplosionActorClass=class'KFExplosion_HRG_Paramedic'

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=50
		DamageRadius=400//200
		DamageFalloffExponent=1
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Toxic_Paramedic'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.Medic_Perk_ZedativeCloud'
		ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Medic.Play_WEP_EXP_Grenade_Medic_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=none
		CamShakeInnerRadius=0
		CamShakeOuterRadius=0
		CamShakeFalloff=0//1.5f
		bOrientCameraShakeTowardsEpicenter=true
		bIgnoreInstigator=False//true
		//ActorClassToIgnoreForDamage = class'KFPawn_Human'
	End Object
	ExplosionTemplate=ExploTemplate0

	AmbientSoundPlayEvent=AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Projectile_LP'
    AmbientSoundStopEvent=AkEvent'WW_WEP_HRG_Warthog.Stop_WEP_HRG_Warthog_Projectile'

	// The higher the more bouncing
    DampenFactor=0.4f
    DampenFactorParallel=0.4f

	bHitWall = false
}

