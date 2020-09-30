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

/**
 * Force the fire not to burn the instigator, since setting it in the default props is not working for some reason - Ramm
 */
simulated protected function PrepareExplosionTemplate()
{
	local KFPawn KFP;
	local KFPerk CurrentPerk;
	
	ExplosionTemplate.bIgnoreInstigator = true;

    super.PrepareExplosionTemplate();

    if( ExplosionActorClass == class'KFPerk_Demolitionist'.static.GetNukeExplosionActorClass() )
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
	}
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
simulated function bool AllowNuke()
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
}

defaultproperties
{
	Physics=PHYS_Falling
    bBounce=false
    MaxSpeed=4000.0
	Speed=4000.0
	TerminalVelocity=7000.0
	TossZ=150
	//GravityScale=1
    //MomentumTransfer=50000.0
    ArmDistSquared=0 //87500 //2.5 meters - //122500 // 3.5 meters

	bWarnAIWhenFired=true

	ProjFlightTemplate=ParticleSystem'WEP_HRG_Kaboomstick_EMIT.FX_HRG_Kaboomstick_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_Kaboomstick_EMIT.FX_HRG_Kaboomstick_Projectile_ZEDTIME'
	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
	AltExploEffects=KFImpactEffectInfo'WEP_HRG_Kaboomstick_ARCH.WEP_HRG_Kaboomstick_Explosion_Concussive_Force'
	
	AssociatedPerkClass(0)=class'KFPerk_Demolitionist'

	// Grenade explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
	    LightColor=(R=252,G=218,B=171,A=255)
		Brightness=0.5f
		Radius=400.f
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
		Damage=125
		DamageRadius=250
		DamageFalloffExponent=2  //3
		DamageDelay=0.f

		MomentumTransferScale=22500

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_Frag12'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_SeekerSix_ARCH.FX_SeekerSix_Explosion'
		ExplosionSound=AkEvent'WW_WEP_Seeker_6.Play_WEP_Seeker_6_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.3

		bIgnoreInstigator=true

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=300
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	AmbientSoundPlayEvent=none
    AmbientSoundStopEvent=none
}
