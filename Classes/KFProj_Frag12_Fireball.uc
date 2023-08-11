class KFProj_Frag12_Fireball extends KFProj_BallisticExplosive
	hidedropdown;

/** Cached reference to owner weapon */
var protected KFWeapon OwnerWeapon;

/** Initialize the projectile */
function Init( vector Direction )
{
	super.Init( Direction );

	OwnerWeapon = KFWeapon( Owner );
	if( OwnerWeapon != none )
	{
		OwnerWeapon.LastPelletFireTime = WorldInfo.TimeSeconds;
	}
}

/** Don't allow more than one pellet projectile to perform this check in a single frame */
function bool ShouldWarnAIWhenFired()
{
	return super.ShouldWarnAIWhenFired() && OwnerWeapon != none && OwnerWeapon.LastPelletFireTime < WorldInfo.TimeSeconds;
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

simulated protected function PrepareExplosionTemplate()
{
	local KFPlayerReplicationInfo InstigatorPRI;

	if ( Instigator != none)
	{
		InstigatorPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

		if (InstigatorPRI != none && InstigatorPRI.CurrentPerkClass == class'KFPerk_Firebug')
		{
			ExplosionTemplate.ExplosionEffects.DefaultImpactEffect.ParticleTemplate = ParticleSystem'WEP_HuskCannon_EMIT.FX_Huskcannon_Impact_L1';
			ExplosionTemplate.ExplosionSound = AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact';
		}
		else
		{
			ExplosionTemplate.ExplosionEffects.DefaultImpactEffect.ParticleTemplate = ParticleSystem'WEP_HuskCannon_EMIT.FX_Huskcannon_Impact_L1_CF';
			ExplosionTemplate.ExplosionSound = AkEvent'WW_WEP_SA_RPG7.Play_WEP_SA_RPG7_Explosion';
		}
	}

	//ExplosionTemplate.ExplosionEffects.DefaultImpactEffect.ParticleTemplate = ParticleSystem'WEP_HuskCannon_EMIT.FX_Huskcannon_Impact_L1_CF';
	//ExplosionTemplate.ExplosionSound = AkEvent'WW_WEP_SA_RPG7.Play_WEP_SA_RPG7_Explosion';

    super.PrepareExplosionTemplate();
}

defaultproperties
{
	Physics=PHYS_Falling
    bBounce=false
	Speed=5000 //6000
	MaxSpeed=5000  //6000
	TerminalVelocity=7000.0
	TossZ=150
	//GravityScale=1
    //MomentumTransfer=50000.0
    ArmDistSquared=0 //87500 //2.5 meters - //122500 // 3.5 meters

	bWarnAIWhenFired=true

	ProjFlightTemplate=ParticleSystem'WEP_HRG_Kaboomstick_EMIT.FX_HRG_Kaboomstick_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_Kaboomstick_EMIT.FX_HRG_Kaboomstick_Projectile_ZEDTIME'
	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
	//AltExploEffects=KFImpactEffectInfo'WEP_HRG_Kaboomstick_ARCH.WEP_HRG_Kaboomstick_Explosion_Concussive_Force'
	AltExploEffects=KFImpactEffectInfo'WEP_M79_ARCH.M79Grenade_Explosion_Concussive_Force'
	
	AssociatedPerkClass(0)=class'KFPerk_Demolitionist'

	// Fire light
	Begin Object Class=PointLightComponent Name=FlamePointLight
		LightColor = (R = 245,G = 190,B = 140,A = 255)
		Brightness = 4.f
		Radius = 500.f
		FalloffExponent = 10.f
		CastShadows = False
		CastStaticShadows = FALSE
		CastDynamicShadows = TRUE
		bCastPerObjectShadows = false
		bEnabled = FALSE
		LightingChannels = (Indoor = TRUE,Outdoor = TRUE,bInitialized = TRUE)
	End Object

	// Grenade explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
		LightColor = (R = 245,G = 190,B = 140,A = 255)
		Brightness = 4.f
		Radius = 2000.f
		FalloffExponent = 10.f
		CastShadows = False
		CastStaticShadows = FALSE
		CastDynamicShadows = False
		bCastPerObjectShadows = false
		bEnabled = FALSE
		LightingChannels = (Indoor = TRUE,Outdoor = TRUE,bInitialized = TRUE)
	End Object

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=90//100//120//125
		DamageRadius=150//200//200//250
		DamageFalloffExponent=1.f //1.0
		DamageDelay=0.f
		bUseOverlapCheck = true

		MomentumTransferScale=6000.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_Frag12'
		KnockDownStrength=100
		FractureMeshRadius=200.0
		FracturePartVel=100.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HuskProjectile_Explosion'
		ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact'
		ExplosionEmitterScale=2.f
		
		// Dynamic Light
		ExploLight=ExplosionPointLight
		ExploLightStartFadeOutTime = 0.0
		ExploLightFadeOutTime = 0.5

		// Camera Shake
		CamShake = none
		bOrientCameraShakeTowardsEpicenter=true

		bIgnoreInstigator=false
	End Object
	ExplosionTemplate=ExploTemplate0

	AmbientSoundPlayEvent=none
    AmbientSoundStopEvent=none
}
