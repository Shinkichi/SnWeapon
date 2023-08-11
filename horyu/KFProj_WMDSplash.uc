class KFProj_WMDSplash extends KFProj_MolotovSplash;


/** Overridden to adjust particle system for different surface orientations (wall, ceiling),
  * nudge location and change to alternate effects if is Firebug with Splash Skill (Ground Fire)
  */
simulated protected function PrepareExplosionActor(GameExplosionActor GEA)
{
	local KFExplosion_HRGScorcherGroundFire KFEM;
	local vector ExplosionDir;

	super.PrepareExplosionActor( GEA );

	// KFProjectile::Explode gives GEA a "nudged" location of 32 units, but it's too much, so use a smaller nudge
	GEA.SetLocation( Location + vector(GEA.Rotation) * 10 );

	KFEM = KFExplosion_HRGScorcherGroundFire( GEA );
	if( KFEM != none )
	{
		ExplosionDir = vector( KFEM.Rotation );

		if( ExplosionDir.Z < -0.95 )
		{
			// ceiling
			KFEM.LoopingParticleEffect = KFEM.default.LoopingParticleEffectCeiling;
		}
		else if( ExplosionDir.Z < 0.05 )
		{
			// wall
			KFEM.LoopingParticleEffect = KFEM.default.LoopingParticleEffectWall;
		}
        else if(bAltExploEffects)
        {
            KFEM.LoopingParticleEffect = KFEM.default.LoopingParticleEffectAlternate;
        }
		// else floor
	}
}

/** 
* Use alternative explosion effects when Ground Fire Perk is active
*/
simulated function PostBeginPlay()
{
	local KFPlayerReplicationInfo InstigatorPRI;

	if( AltExploEffects != none && Instigator != none )
	{
		InstigatorPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		if( InstigatorPRI != none )
		{
			bAltExploEffects = InstigatorPRI.bSplashActive;
		}
	}
	else
	{
		bAltExploEffects = false;
	}

	super.PostBeginPlay();
}

defaultproperties
{

	ProjFlightTemplate=ParticleSystem'WEP_3P_Molotov_EMIT.FX_Molotov_Grenade_Spread_01'
	ExplosionActorClass=class'KFExplosion_HRGScorcherGroundFire'


	// light ground fire
	Begin Object Name=FlamePointLight
	    LightColor=(R=245,G=190,B=140,A=255)
		Brightness=2.f
		Radius=300.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bCastPerObjectShadows=false
		bEnabled=FALSE
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object

	// explosion (parameters to ExplosionActorClass)
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=10
		DamageRadius=150
		DamageFalloffExponent=1.f
		DamageDelay=0.f
		// Don't burn the guy that tossed it, it's just too much damage with multiple fires, its almost guaranteed to kill the guy that tossed it
        bIgnoreInstigator=true

		MomentumTransferScale=1

		// Damage Effects
		MyDamageType=class'KFDT_Fire_Ground_WMD'
		KnockDownStrength=0
		FractureMeshRadius=0
		ExplosionEffects=None

		bDirectionalExplosion=true

		// Camera Shake
		CamShake=none

		// Dynamic Light
        ExploLight=FlamePointLight
        ExploLightStartFadeOutTime=4.2
        ExploLightFadeOutTime=0.3
		ExploLightFlickerIntensity=5.f
		ExploLightFlickerInterpSpeed=15.f
	End Object
	ExplosionTemplate=ExploTemplate0

    //AssociatedPerkClass=class'KFPerk_Firebug'
}