class KFProj_Pellet_Gunzerks extends KFProj_Bullet_Pellet
	hidedropdown;


/** Last hit normal from Touch() or HitWall() */
var vector LastHitNormal;

var float GroundFireChance;

/** Our intended target actor */
var private KFPawn LockedTarget;

/** How much 'stickyness' when seeking toward our target. Determines how accurate rocket is */
var const float SeekStrength;

replication
{
	if( bNetInitial )
		LockedTarget;
}

function SetLockedTarget( KFPawn NewTarget )
{
	LockedTarget = NewTarget;
}

simulated event Tick( float DeltaTime )
{
	local vector TargetImpactPos, DirToTarget;

	super.Tick( DeltaTime );

	// Skip the first frame, then start seeking
	if( !bHasExploded
		&& LockedTarget != none
		&& Physics == PHYS_Projectile
		&& Velocity != vect(0,0,0)
		&& LockedTarget.IsAliveAndWell()
		&& `TimeSince(CreationTime) > 0.03f )
	{
		// Grab our desired relative impact location from the weapon class
		TargetImpactPos = class'KFWeap_HRG_Gunzerks'.static.GetLockedTargetLoc( LockedTarget );

		// Seek towards target
		Speed = VSize( Velocity );
		DirToTarget = Normal( TargetImpactPos - Location );
		Velocity = Normal( Velocity + (DirToTarget * (SeekStrength * DeltaTime)) ) * Speed;

		// Aim rotation towards velocity every frame
		SetRotation( rotator(Velocity) );
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	LastHitNormal = HitNormal;
	Super.ProcessTouch(Other, HitLocation, HitNormal);
}

/**
* Explode this Projectile
*/
simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
	LastHitNormal = HitNormal;
	Super.TriggerExplosion(HitLocation, HitNormal, HitActor);
}


simulated protected function StopSimulating()
{
	local vector FlameSpawnVel;

	if (Role == ROLE_Authority && Physics == PHYS_Falling && FRand() < GroundFireChance)
	{
		//SpawnGroundFire();
		FlameSpawnVel = 0.25f * CalculateResidualFlameVelocity(LastHitNormal, Normal(Velocity), VSize(Velocity));
		SpawnResidualFlame(class'KFProj_Gunzerks_Splash', Location + (LastHitNormal * 10.f), FlameSpawnVel);
	}

	super.StopSimulating();
}

defaultproperties
{
	GroundFireChance=1.f
	//Physics=PHYS_Falling

	MaxSpeed=7000.0
	Speed=7000.0
	TerminalVelocity=7000.0

	bWarnAIWhenFired=true

	DamageRadius=0
	GravityScale=0.35
	TossZ=0

	Begin Object Class=PointLightComponent Name=PointLight0
	    LightColor=(R=252,G=218,B=171,A=255)
		Brightness=0.5f
		Radius=500.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=true
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object
	ProjFlightLight=PointLight0

	ImpactEffects=KFImpactEffectInfo'WEP_DragonsBreath_ARCH.DragonsBreath_bullet_impact'
	ProjFlightTemplate=ParticleSystem'WEP_DragonsBreath_EMIT.Tracer.FX_DragonsBreath_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_DragonsBreath_EMIT.Tracer.FX_DragonsBreath_Tracer_ZEDTime'

    AmbientSoundPlayEvent=AkEvent'WW_WEP_SA_DragonsBreath.Play_SA_DragonsBreath_Projectile_Loop'
    AmbientSoundStopEvent=AkEvent'WW_WEP_SA_DragonsBreath.Stop_SA_DragonsBreath_Projectile_Loop'
    
    SeekStrength=928000.0f  // 128000.0f
}

