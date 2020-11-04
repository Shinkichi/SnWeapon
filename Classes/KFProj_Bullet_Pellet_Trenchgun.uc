class KFProj_Bullet_Pellet_Trenchgun extends KFProj_PinningBullet
	hidedropdown;

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	local TraceHitInfo HitInfo;

    // Don't bounce any more if being used to pin a zed
    if( bSpawnedForPin )
    {
        BouncesLeft=0;
    }

	SetRotation(rotator(Normal(Velocity)));
    SetPhysics(PHYS_Falling);

    // Should hit destructibles without bouncing
	if (!Wall.bStatic && bDamageDestructiblesOnTouch && Wall.bProjTarget)
	{
		Wall.TakeDamage(Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo, self);
		Explode(Location, HitNormal);
	}
	// check if we should do a bounce, otherwise stick
    else if( !Bounce(HitNormal, Wall) )
    {
        // Turn off the corona when it stops
    	if ( WorldInfo.NetMode != NM_DedicatedServer && ProjEffects!=None )
    	{
            ProjEffects.DeactivateSystem();
        }

        // if our last hit is a destructible, don't stick
        if ( !Wall.bStatic && !Wall.bWorldGeometry && Wall.bProjTarget )
    	{
            Explode(Location, HitNormal);
            ImpactedActor = None;
    	}
        else
        {
        	// Play the bullet impact sound and effects
        	if ( WorldInfo.NetMode != NM_DedicatedServer )
        	{
        		`ImpactEffectManager.PlayImpactEffects(Location, Instigator, HitNormal);
        	}

            SetPhysics(PHYS_None);

        	// Stop ambient sounds when this projectile ShutsDown
        	if( bStopAmbientSoundOnExplode )
        	{
                StopAmbientSound();
        	}

			//@todo: check for pinned victim
        }

        bBounce = false;
    }
}

//==============
// Touching
// Overriden to get nails bouncing off of destructible meshes
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // @todo: Implement functionality properly choosing which actors to
    // ProcessTouch for when this projectile is being used to pin ragdolls

	if ( Other != Instigator && !Other.bWorldGeometry && Other.bCanBeDamaged )
	{
		if ( Pawn(other) != None )
		{
            Super.ProcessTouch(Other, HitLocation, HitNormal);
		}
		else
        {
            ProcessDestructibleTouchOnBounce( Other, HitLocation, HitNormal );
        }
	}
	else
	{
        Super.ProcessTouch(Other, HitLocation, HitNormal);;
	}
}

simulated function Tick( float DeltaTime )
{
    super.Tick(DeltaTime);

    if ( WorldInfo.NetMode != NM_DedicatedServer && Physics != PHYS_None )
    {
        SetRotation(Rotator(Normal(Velocity)));
    }
}

simulated function Landed( Vector HitNormal, actor FloorActor )
{
    // Turn off the corona when it stops
	if ( WorldInfo.NetMode != NM_DedicatedServer && ProjEffects!=None )
	{
        ProjEffects.DeactivateSystem();
    }

    SetPhysics(PHYS_None);

	// Stop ambient sounds when this projectile ShutsDown
	if( bStopAmbientSoundOnExplode )
	{
        StopAmbientSound();
	}
}

defaultproperties
{
	MaxSpeed=3500.0
	Speed=3500.0

    bWarnAIWhenFired=true

	DamageRadius=0

    LifeSpan = 5.0f

    BouncesLeft=2
    DampingFactor=0.65
    RicochetEffects=KFImpactEffectInfo'WEP_Nail_Shotgun_ARCH.NailBulletImpacts'

	ProjFlightTemplate=ParticleSystem'WEP_1P_MB500_EMIT.FX_MB500_Tracer'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_1P_MB500_EMIT.FX_MB500_Tracer_ZEDTime'
}