class KFProj_Cannonball_BombLauncher extends KFProj_Grenade
	hidedropdown;

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local TraceHitInfo HitInfo;

	super.HitWall(HitNormal, Wall, WallComp);

	// Damage some destructibles...
	if (Pawn(Wall) == none && !Wall.bStatic && Wall.bCanBeDamaged)
	{
		HitInfo.HitComponent = WallComp;
		HitInfo.Item = INDEX_None;
		Wall.TakeDamage(Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo, self);
	}
}

/** Adjusts movement/physics of projectile.
  * Returns true if projectile actually bounced / was allowed to bounce */
simulated function bool Bounce( vector HitNormal, Actor BouncedOff )
{
	SetLocation(Location + HitNormal);
	super.Bounce(HitNormal, BouncedOff);

	// stop and drop
	Disable( 'Touch' );
	Velocity = vect(0,0,0);
	return true;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// ... Damage other destructibles?
    if (Other != Instigator && !Other.bStatic)
    {
		if (!CheckRepeatingTouch(Other) && Other.GetTeamNum() != GetTeamNum())
		{
			ProcessBulletTouch(Other, HitLocation, HitNormal);
		}
    }

	Disable( 'Touch' );
	Velocity = Vect(0,0,0);
}

defaultproperties
{
	//bWarnAIWhenFired=true

	Speed=3200
	MaxSpeed=3200

	// Rolling and dampen values
    DampenFactor=0.1
    DampenFactorParallel=0

	bCollideComplex=TRUE	// Ignore simple collision on StaticMeshes, and collide per poly
	bUseClientSideHitDetection=true
	bNoReplicationToInstigator=false
	bAlwaysReplicateExplosion=true;
	bUpdateSimulatedPosition=true

	Begin Object Name=CollisionCylinder
		CollisionRadius=0.f
		CollisionHeight=0.f
		BlockNonZeroExtent=false
	End Object

	ExplosionActorClass=class'KFExplosionActor'

	ProjFlightTemplate=ParticleSystem'WEP_Blunderbuss_EMIT.FX_Cannonball_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_Blunderbuss_EMIT.FX_Cannonball_Projectile_ZEDTIME'
	
	GrenadeBounceEffectInfo=KFImpactEffectInfo'FX_Impacts_ARCH.DefaultGrenadeImpacts'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
	AltExploEffects=KFImpactEffectInfo'WEP_Gravity_Imploder_ARCH.Blue_Explosion_Concussive_Force'

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=250
		DamageRadius=750
		DamageFalloffExponent=2
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_BombLauncher'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_Blunderbuss_ARCH.Cannonball_Explosion'
		ExplosionSound=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	// gameplay
	FuseTime=1.0
}
