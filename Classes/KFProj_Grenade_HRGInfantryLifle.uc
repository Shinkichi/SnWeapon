
class KFProj_Grenade_HRGInfantryLifle extends KFProjectile;

/** Time projectile is alive after being sticked to an actor or a pawn */
var float StickedTime;

/** This is the effects attached while being sticked to a wall or a pawn */
var ParticleSystemComponent	ProjStickedEffects;
var(Projectile) ParticleSystem ProjStickedTemplate;

/** This is the light attached while being sticked to a wall or a pawn */
var PointLightComponent ProjStickedLight;
var LightPoolPriority ProjStickedLightPriority;

/** Time before particle system parameter is set */
var float FlameDisperalDelay;

/** Impact effects to use when projectile hits a zed */
var KFImpactEffectInfo ImpactEffectsOnZed;

/** Sound to play while projectile is sticked*/
var AKEvent	AmbientSoundPlayEventSticked;

/** (Computed) State if sticked or not projectile */
var bool bSticked;

/** (Computed) Helper variable for Tick() to count sticked time */
var float CurrentStickedTime;

/** Offset time to start fading out light after being sticked */
var float StickedLightFadeStartTime;

/** Time being faded out light after being sticked */
var float StickedLightFadeTime;

/**
 * Spawns any effects needed for the flight of this projectile
 */
simulated function SpawnFlightEffects()
{
	Super.SpawnFlightEffects();

	if ( WorldInfo.NetMode != NM_DedicatedServer && WorldInfo.GetDetailMode() > DM_Low  )
	{
		SetTimer(FlameDisperalDelay, false, nameof(MidFlightFXTimer));
	}
}

simulated function MidFlightFXTimer()
{
	if (ProjEffects!=None)
	{
		ProjEffects.SetFloatParameter('Spread', 1.0);
	}
}

simulated protected function StopFlightEffects()
{
	Super.StopFlightEffects();
	ClearTimer(nameof(MidFlightFXTimer));
}


/** Blows up mine immediately */
simulated function Detonate()
{
	//StickHelper.UnPin();
	//StopStickedEffects();
	Shutdown();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	AdjustCanDisintigrate(); // TODO needed in order to siren not get rid of proyectile?
}

/**
 * We use Detonate to make disappear the proyectile, but no explosion will show up.
 * We only want to make it disappear.
 */
simulated function Timer_Explode()
{
	Detonate();
}

/** Called when the owning instigator controller has left a game */
/** TODO needed? Innecessary rand for time in timer? */
simulated function OnInstigatorControllerLeft()
{
	if( WorldInfo.NetMode != NM_Client )
	{
		SetTimer( 1.f + Rand(5) + fRand(), false, nameof(Timer_Explode) );
	}
}

// Overriding functions where StickHelper.TryStick is called to start timer to delete the proyectile
simulated event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp )
{
	super.HitWall(HitNormal, Wall, WallComp);
	SetTimer(StickedTime, false, nameof(Timer_Explode));
	StartStickedEffects();
	`ImpactEffectManager.PlayImpactEffects(Location, Instigator, , ImpactEffects );
	//StopFlightEffects();
}

// Overriding functions where StickHelper.TryStick is called to start timer to delete the proyectile
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (Other != Instigator && !Other.bStatic && DamageRadius == 0.0 )
	{
		ProcessBulletTouch(Other, HitLocation, HitNormal);
	}
	super.ProcessTouch(Other, HitLocation, HitNormal);
	SetTimer(StickedTime, false, nameof(Timer_Explode));
	StartStickedEffects();
	`ImpactEffectManager.PlayImpactEffects(Location, Instigator, , ImpactEffects );
	//StopFlightEffects();
}

//We swap effects, sound and light with the appropiate valuess when sticking.
//It has to be done this way because we can't access to AmbientSound to play other sound when sticked.
simulated function StartStickedEffects()
{
	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		StopFlightEffects();
		ProjFlightLight = ProjStickedLight;
		ProjFlightLightPriority = ProjStickedLightPriority;
		ProjFlightTemplate = ProjStickedTemplate;
		AmbientSoundPlayEvent = AmbientSoundPlayEventSticked;
		SpawnFlightEffects();
		ProjEffects.SetFloatParameter( 'FlareLifetime', StickedTime );
	}
	bSticked=true;
	CurrentStickedTime=0.0;
}

simulated event Tick( float DeltaTime )
{
	local float NewBrightness;
	super.Tick(DeltaTime);
	StickHelper.Tick(DeltaTime); //Used to check current status of StuckTo actor (to figure out if we should fall)

	//Fading out light after being sticked (matching FX decreasing projectile size)
	if (bSticked)
	{
		CurrentStickedTime += DeltaTime;
		
		if (CurrentStickedTime > StickedLightFadeStartTime)
		{
			NewBrightness = 1.5 - Lerp(0, 1.5, (CurrentStickedTime - StickedLightFadeStartTime)/StickedLightFadeTime);
			ProjFlightLight.SetLightProperties(NewBrightness,,);
			ProjFlightLight.UpdateColorAndBrightness();
		}
	}
}

simulated function SyncOriginalLocation()
{
	super.SyncOriginalLocation();
}

defaultproperties
{
	Physics=PHYS_Falling

	LifeSpan=20

	Speed=4550		//3500 //5000
	MaxSpeed=5000
	TerminalVelocity=5000

	bWarnAIWhenFired=true

	DamageRadius=0
	GravityScale=0.36	//0.4 //0.5 //1.0
	TossZ=0
	FlameDisperalDelay=0.25

	bSticked=false
	CurrentStickedTime=0.0
	StickedLightFadeStartTime=4.0
	StickedLightFadeTime=1.0
    TouchTimeThreshhold=0.15

	//Sticking to environment or pinning to enemies
	bCanStick=true
	bCanPin=false
	StickedTime=5.0

    bCollideActors=true
    bCollideComplex=true

	bPushedByEncroachers=false
	bDamageDestructiblesOnTouch=true
	bWaitForEffects=true
	ProjEffectsFadeOutDuration=0.25
	//Network due to sticking feature
	bNetTemporary=false
	NetPriority=5
	NetUpdateFrequency=200
	bNoReplicationToInstigator=false
	bUseClientSideHitDetection=true
	bUpdateSimulatedPosition=false
	bSyncToOriginalLocation=true
	bSyncToThirdPersonMuzzleLocation=true

	PinBoneIdx=INDEX_None

	bCanBeDamaged=false
	bCanDisintegrate=true
/*
	Begin Object Name=CollisionCylinder
		BlockNonZeroExtent=false
		// for siren scream
		CollideActors=true
	End Object
*/
	Begin Object Class=KFProjectileStickHelper_HRGScorcher Name=StickHelper0
	End Object
	StickHelper=StickHelper0

	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'


	//FX
	Begin Object Class=PointLightComponent Name=PointLight0
	    //LightColor=(R=250,G=160,B=100,A=255)
		LightColor=(R=250,G=25,B=80,A=255)
		Brightness=1.5f
		Radius=350.f
		FalloffExponent=3.0f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=true
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object
	ProjFlightLight=PointLight0
	ProjFlightLightPriority=LPP_High

	Begin Object Class=PointLightComponent Name=PointLight1
	    //LightColor=(R=250,G=160,B=100,A=255)
		LightColor=(R=250,G=25,B=80,A=255)
		Brightness=1.5f
		Radius=350.f
		FalloffExponent=3.0f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=true
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object
	ProjStickedLight=PointLight1
	ProjStickedLightPriority=LPP_High
	
	ImpactEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Light_bullet_impact'
	//ImpactEffectsOnZed=KFImpactEffectInfo'WEP_HRGScorcher_Pistol_ARCH.Wep_HRGScorcher_bullet_impact_zed'
	ProjFlightTemplate=ParticleSystem'WEP_HRGScorcher_Pistol_EMIT.FX_HRGScorcher_Projectile_01'
	ProjStickedTemplate=ParticleSystem'WEP_HRGScorcher_Pistol_EMIT.FX_HRGScorcher_Projectile_Sticked'

	//Sound
	bAmbientSoundZedTimeOnly=false
	bAutoStartAmbientSound=true
    bStopAmbientSoundOnExplode=true
    AmbientSoundPlayEvent=AkEvent'WW_WEP_HRG_Scorcher.Stop_WEP_HRG_Scorcher_Flyby'
    AmbientSoundStopEvent=None

	AmbientSoundPlayEventSticked=AkEvent'WW_WEP_HRG_Scorcher.Stop_WEP_HRG_Scorcher_Burn'

    /*Begin Object Class=AkComponent name=AmbientAkSoundComponent
    	bStopWhenOwnerDestroyed=true
    	bForceOcclusionUpdateInterval=true
        OcclusionUpdateInterval=0.25f
    End Object
    AmbientComponent=AmbientAkSoundComponent
    Components.Add(AmbientAkSoundComponent)*/
}
